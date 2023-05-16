// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./libs/FallbackUserOperation.sol";

contract FallbackGasTank is Ownable, ReentrancyGuard {
    using ECDSA for bytes32;
    using FallbackUserOperationLib for FallbackUserOperation;

    // States
    mapping(address => uint256) public dappIdentifierBalances;
    address public verifyingSigner;
    //transaction base gas
    uint128 public baseGas=21000;
    // nonce for account 
    mapping(address => uint256) private nonces;

    constructor(address _owner, address _verifyingSigner) {
        require(_verifyingSigner != address(0), "signer of gas tank can not be 0");
        verifyingSigner = _verifyingSigner;
        require(_owner != address(0), "owner can not be 0");
        _transferOwnership(_owner);
    }

    //** read methods */
    function getNonce(address _sender) external view returns(uint256 nonce) {
        nonce = nonces[_sender];
    }

    function getBalance(address _dappIdentifier) external view returns(uint256 balance) {
        balance = dappIdentifierBalances[_dappIdentifier];
    }

    //Events
    
    // Dapp deposits
    event Deposit(address indexed sender, uint256 indexed amount, address indexed dappIdentifier); 
    /* Designed to enable the community to track change in storage variable baseGas which is used for charge calcuations 
       Unlikely to change */
    event BaseGasChanged(uint128 indexed newBaseGas, address indexed actor);

    event GaslessTxExecuted(address indexed relayer, address indexed sender, bytes data, address dappIdentifier, uint256 indexed payment);

    event GasTankEmpty();

    event GasWithdrawn(address indexed _dappIdentifier, address indexed _to, address _actor, uint256 indexed _value);

    function setBaseGas(uint128 gas) external onlyOwner{
        baseGas = gas;
        emit BaseGasChanged(baseGas,msg.sender);
    }

    /**
    this function will let owner change signer
    */
    function setSigner( address _newVerifyingSigner) external onlyOwner{
        require(_newVerifyingSigner != address(0), "FallbackGasTank: new signer can not be zero address");
        verifyingSigner = _newVerifyingSigner;
    }

    /**
     * add a deposit for given dappIdentifier (Dapp Depositor address), used for paying for transaction fees
     */
    function depositFor(address dappIdentifier) public payable nonReentrant {
        require(dappIdentifier != address(0), "dappIdentifier can not be zero address");
        dappIdentifierBalances[dappIdentifier] += msg.value;
        // Emits an event
        emit Deposit(msg.sender, msg.value, dappIdentifier);
    }

    function withdrawGasForDapp(address dappIdentifier,address payable withdrawAddress, uint256 amount) external onlyOwner nonReentrant {
        uint256 currentBalance = dappIdentifierBalances[dappIdentifier];
        require(amount <= currentBalance, "Insufficient amount to withdraw");
        unchecked {
        dappIdentifierBalances[dappIdentifier] = currentBalance - amount;
        }
        (bool success,) = withdrawAddress.call{value : amount}("");
        require(success, "failed to withdraw");
        emit GasWithdrawn(dappIdentifier, withdrawAddress, msg.sender, amount);
    }

    /**
     * return the hash we're going to sign off-chain (and validate on-chain)
     * this method is called by the off-chain service, to sign the request.
     * it is called on-chain from the handleFallbackUserOp, to validate the signature.
     * note that this signature covers all fields of the FallbackUserOperation, except the "signature",
     * which is the signature itself.
     */
    function getHash(FallbackUserOperation calldata fallbackUserOp)
    public view returns (bytes32) {
        return keccak256(abi.encode(
                fallbackUserOp.sender,
                fallbackUserOp.target,
                fallbackUserOp.nonce,
                keccak256(fallbackUserOp.callData),
                fallbackUserOp.callGasLimit,
                fallbackUserOp.dappIdentifier,
                block.chainid,
                address(this)
        ));
    }

    function _validateSignature(FallbackUserOperation calldata fallbackUserOp) internal view {

        bytes32 hash = getHash(fallbackUserOp);
        uint256 sigLength = fallbackUserOp.signature.length;

        // we only "require" it here so that the revert reason on invalid signature will be of "VerifyingPaymaster", and not "ECDSA"
        require(sigLength == 65, "FallbackGasTank: invalid signature length in fallbackUserOp");
        require(verifyingSigner == hash.toEthSignedMessageHash().recover(fallbackUserOp.signature), "FallbackGasTank: wrong signature");
    }

    function _updateNonce(FallbackUserOperation calldata fallbackUserOp) internal {
         ++nonces[fallbackUserOp.sender];
    }

    function handleFallbackUserOp(
        FallbackUserOperation calldata fallbackUserOp
    ) external nonReentrant returns(bool success, bytes memory ret)
    {
         uint256 gasStarted = gasleft();
         address _target = fallbackUserOp.target;
         require(_target != address(0),"call to null address");
         require(msg.sender == tx.origin,"only EOA relayer");
         address payable relayer = payable(msg.sender);
         
        _validateSignature(fallbackUserOp);
        _updateNonce(fallbackUserOp);

        (success, ret) = _target.call{gas : fallbackUserOp.callGasLimit}(fallbackUserOp.callData);
        _verifyCallResult(success,ret,"Forwarded call to destination did not succeed");
        uint256 gasUsed;
        unchecked {
        gasUsed = gasStarted - gasleft(); // Takes into account gas cost for refund. 
        }
        uint256 actualGasCost = (gasUsed + baseGas) * tx.gasprice;

        (bool successful,) = relayer.call{value : actualGasCost}("");
        if(!successful) {
            emit GasTankEmpty();
        }

        // deduct funds
        dappIdentifierBalances[fallbackUserOp.dappIdentifier] -= actualGasCost;

        // emit event with payment, dapp details, relayer address and refund...
        emit GaslessTxExecuted(msg.sender, fallbackUserOp.sender, fallbackUserOp.callData, fallbackUserOp.dappIdentifier, actualGasCost);
    }

    /**
     * @dev verifies the call result and bubbles up revert reason for failed calls
     *
     * @param success : outcome of forwarded call
     * @param returndata : returned data from the frowarded call
     * @param errorMessage : fallback error message to show 
     */
     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure {
        if (!success) {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

