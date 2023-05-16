// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;
/* solhint-disable no-inline-assembly */

/**
     * Fallback User SCW Operation struct
     * @param sender smart account for this request
     * @param nonce unique value the sender uses to verify it is not a replay.
     * @param callData the method call to execTransaction on this account.
     * @param callGasLimit gas used for execTransaction call to the account
     * @param dappIdentifier dapp identifier for which deposit will be deducted
     * @param signature verifying-signer-verified signature over the entire request
     */
    struct FallbackUserOperation {

        address sender;
        address target;
        address dappIdentifier;
        uint256 nonce;
        uint256 callGasLimit;
        bytes callData;
        bytes signature;
    }

library FallbackUserOperationLib {
}