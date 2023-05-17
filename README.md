

BATCHED GASLESS TRANSACTIONS
=======
This is a simple starter kit/project that uses the new Biconomy SDK (https://docs.biconomy.io) to implement the following modules :

1. Social Logins to get Smart Contract Wallet Address
2. Gasless Transactions using biconomy dashboard (dashboard.biconomy.io)
3. Batched Transactions (minting NFTS/ERC 721 Tokens together)

## How to start using this starter kit ?
------

So before we begin to run this project, there are two parts to the project :
- Contract
- Vite Project

We will start of with making few changes in the first directory :

## Installation

Navigate to this directory in your terminal and then 

```bash
  cd contract
```
Install the dependencies inside the contract directory by :

```bash
 npm install
```

Now, there is a .env file in the format of :

```
PRIVATE_KEY=xxxx
ETHERSCAN_API_KEY=xxxx
POLYSCAN_API_KEY=xxxx
```

In **PRIVATE_KEY** make sure to enter the private key of your Metamask wallet address on Polygon Mumbai Network. 
In **POLYGONSCAN_API_KEY** enter the API Key you get from https://polygonscan.com/myapikey You can go to your Account Dashboard, click on the navigation tab labelled API-KEYs.From there, you may click on Add to create a new key and give a name to your project. Each PolygonScan account is limited to creating 3 keys at any one time.

It would look something like this - 

https://2337587251-files.gitbook.io/~/files/v0/b/gitbook-legacy-files/o/assets%2F-MkGpkdXjBmLFG7DUuT7%2F-MkpUond_qxJH5lLfsaE%2F-MkpZPB0C8OkfbnnRYDj%2Fthree.png?alt=media&token=68bcb2d6-6747-492b-ba8f-37a34ba99f43![image](https://github.com/vanshika-srivastava/gasless-batched/assets/76511019/9752e612-6ef9-444f-9ccd-7b06a85d7ca1)

Once you have made the changes, now we can move on to the part of deploying the smart contract on polygon_mumbai network. For this you need to have some matic in the wallet whose private key you have provided in .env file. Execute this command in your terminal to deploy the contract :

```bash
  npx hardhat run scripts/deploy.ts --network mumbai
```

Once you get this message - 

```
"NFT Contract deployed to:",_contract address_,"for using biconomy sdk for this demo"
```

Next step would be verfiying the contract address, use the following command -

```bash
  npx hardhat verify --network mumbai <your-contract-address>
```

This will verify your contract on Polygonscan and give you a verified address and a link in terminal which you can check on polygon scan.



## Biconomy Dashboard Registration

Now we will move on second directory, vite-project and we will required using [Biconomy's new dashboard](dashboard.biconomy.io) in this step.

We will use the verified address in the dashboard for whitelising the address which will allow us to set up a gas tank and do gasless transactions.

1. Visit [Biconomy's new dashboard](dashboard.biconomy.io)
2. You will get three sign up options, you can use magic link or github to login.
3. Once logged in, you will be able to see this - 

![image](https://github.com/vanshika-srivastava/gasless-batched/assets/76511019/93758a7b-2365-41d8-b832-c16dc11429ba)

4. Now we will go on **ADD NEW PAYMASTER** to setup for the contract.
5. You will see a popup to add the **NAME** and **CHAIN** . Add the name of paymaster and the chain on which you have deployed the contract.
6. After you have succesfully setup your paymaster details, you will see **API KEY** on dashboard which you need to use in your .env file.
7. Next, whitelist the contract address on dashboard to enable the gasless transactions. 
![image](https://github.com/vanshika-srivastava/gasless-batched/assets/76511019/ffbb37e1-ce9c-47ad-a46f-c36fa8d1f117)
8. Next, add the NAME of contract, VERIFIED SMART CONTRACT ADDRESS and after this the ABI will be fetched automatically. You can choose the WRITE METHODS as well and it will show under active contract.
9. Now, click on gas tank. You can recharge the gas tank from your EOA/Metamask wallet. Make sure to connect it to dashboard, enter the amount you would like to refill with and then click on depost. Finally, you will get a popup to add the matic funds in gas tank.


## Frontend Configuration

Next, go to root project and install the packages.

```bash
 npm install
```

In your terminal navigate to the root folder of the project and go to .env which has the following -

```
VITE_BICONOMY_API_KEY=
VITE_NFT_CONTRACT_ADDRESS=
```
Add the API KEY from Dashboard, and the verified contract address that was returned to you in this file.

After you have added the above, type the following in terminal.

```bash
 npm run dev
```

This should start the project in the localhost. You can do batched transactions of minting NFTs and do a batched of minting and transferring in a single click. You would be using your smart contract wallet address for all the functions.

![image](https://github.com/vanshika-srivastava/gasless-batched/assets/76511019/fca24d32-9751-4b46-83fa-430f32e380a1)


If you have any doubts, feel free to open discussions. Pull Requests are more than welcome.

_________________

Made with Biconomy SDK + REACT + VITE

>>>>>>> 0717398 (Pushed gasless-batched)

