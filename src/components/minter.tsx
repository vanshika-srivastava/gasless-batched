import "../minter.css"
import React, { useState, useEffect } from "react";
import { ethers } from "ethers";
import abi from "../utils/abi.json";
import SmartAccount from "@biconomy/smart-account";

interface Props {
  smartAccount: SmartAccount;
  provider: any;
  acct: any;
}

const Minter: React.FC<Props> = ({ smartAccount, provider, acct }) => {
  const [nftContract, setNFTContract] = useState<any>(null);
  const [nftCount, setNFTCount] = useState<number>(0);
  const [recipientAddress, setRecipientAddress] = useState<string>("");
  const [nftIndexes, setNFTIndexes] = useState<number[]>([]);
  const [nftsAsBalanceCount, setNftsAsBalanceCount] = useState(0);

  const nftAddress = import.meta.env.VITE_NFT_CONTRACT_ADDRESS;

  
  useEffect(() => {
    getNFTCount();
    getNFTIndexes();
    
  }, []);

  useEffect(() => {
    setNftsAsBalanceCount(nftCount);
  }, [nftCount]);


  const getNFTCount = async () => {
    const contract = new ethers.Contract(nftAddress, abi, provider);
    setNFTContract(contract);

    const count = await contract.balanceOf(smartAccount.address);
    setNFTCount(count.toNumber());
  };

  const getNFTIndexes = async () => {
    const contract = new ethers.Contract(nftAddress, abi, provider);
    setNFTContract(contract);
  
const countdata = await contract.balanceOf(smartAccount.address);
const nftIndexes = [];

for (let i = 0; i < countdata; i++) {
  const index = await contract.tokenOfOwnerByIndex(smartAccount.address, i);
  nftIndexes.push(index.toNumber());
}

setNFTIndexes(nftIndexes);
  }





  const mintNftAsBalance = async () => {
    try {
      const contract = new ethers.Contract(nftAddress, abi, provider);
      setNFTContract(contract);

      // Mint 4 NFTs
      const mintTx1 = await contract.populateTransaction.mint();
      const mintTx2 = await contract.populateTransaction.mint();
      const mintTx3 = await contract.populateTransaction.mint();
      const mintTx4 = await contract.populateTransaction.mint();

      const tx1 = {
        to: nftAddress,
        data: mintTx1.data,
      };
      const tx2 = {
        to: nftAddress,
        data: mintTx2.data,
      };
      const tx3 = {
        to: nftAddress,
        data: mintTx3.data,
      };
      const tx4 = {
        to: nftAddress,
        data: mintTx4.data,
      };

      const mintResponse = await smartAccount.sendTransactionBatch({
        transactions: [tx1, tx2, tx3, tx4],
      });
      await mintResponse.wait();

      console.log({ mintResponse });

      getNFTCount();
    } catch (error) {
      console.log(error);
    }
  };



  const mintAndTransferNft = async () => {
    try {
      if (!recipientAddress) {
        console.log("Recipient address not specified");
        return;
      }
  
      const contract = new ethers.Contract(nftAddress, abi, provider);
      setNFTContract(contract);

      const nftSelect = document.getElementById("nft-select") as HTMLSelectElement;
      const selectedNftId = parseInt(nftSelect.value);
  
      // Mint a new NFT
      const mintTx = await contract.populateTransaction.mint();
  
      // Transfer the selected NFT to the recipient address
      const transferTx = await contract.populateTransaction[
        "safeTransferFrom(address,address,uint256)"
      ](smartAccount.address, recipientAddress, selectedNftId);
  
      const tx1 = {
        to: nftAddress,
        data: mintTx.data,
      };
      const tx2 = {
        to: nftAddress,
        data: transferTx.data,
      };
  
      const transferResponse = await smartAccount.sendTransactionBatch({
        transactions: [tx1, tx2],
      });
      await transferResponse.wait();
  
      console.log({ transferResponse });

      const popup = document.createElement('div');
popup.textContent = `Transfer successful. Hash: ${transferResponse.hash}`;
popup.classList.add('popup'); // add the popup class to the element
document.body.appendChild(popup);

// show the popup box
popup.style.display = 'block';

// set a timeout to remove the popup box after 5 seconds (5000 milliseconds)
setTimeout(() => {
  popup.remove();
}, 5000);

      
  
      getNFTCount();
    } catch (error) {
      console.log(error);
    }
  }
     
  const nftURL = `https://testnets.opensea.io/${smartAccount.address}`
  const transferURL = `https://testnets.opensea.io/${recipientAddress}`

  const sortedIndexes = nftIndexes.sort((a, b) => a - b);


  
  return (
    <div className="container">
      <div className="container-box-1">
        <br></br>
        <br></br>
       
        {nftsAsBalanceCount >= 4 ? (
          <>
            <div>
            <p>You have {nftCount} NFTs in your balance</p>
            <br></br>
              <button onClick={mintNftAsBalance}>Mint NFTs as balance</button>
              <br></br>
              <br></br>
              <button style={{ marginLeft: '10px' }} onClick={() => window.open(nftURL, '_blank')}>View minted on SCW address on OpenSea</button>
            </div>
          </>
        ) : (
          <p>Please Mint more NFTs to add as balance for transfer
            <p>
              <button onClick={mintNftAsBalance}>Mint NFTs as balance</button>
            </p>
          </p>
        )}
  
        {nftsAsBalanceCount >= 4 && (
          <div className="container-box-2">
            
            <div>
              <label htmlFor="recipient-address">Recipient Address : </label>
              <input
                id="recipient-address"
                type="text"
                value={recipientAddress}
                onChange={(e) => setRecipientAddress(e.target.value)}
              />
            </div>
            <br></br>
            <br></br>
            <div className="selectnft">
              Select an NFT ID to Transfer : <select id="nft-select">
                {sortedIndexes.map((index) => (
                  <option value={index}>{index}</option>
                ))}
              </select>
            </div>
            <p>
              <button onClick={mintAndTransferNft}>Mint and Transfer NFT</button>
              <br></br>
              <br></br>
  
              <button style={{ marginLeft: '10px' }} onClick={() => window.open(transferURL, '_blank')}>View Transferred NFTs on OpenSea</button>
            </p>
          </div>
        )}
      </div>
    </div>
  );
  
}



  
  export default Minter ;


  


