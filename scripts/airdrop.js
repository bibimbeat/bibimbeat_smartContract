const hre = require("hardhat");
const fs = require('fs');
const WalletAddress = require('./../environment/airdropwallets.json');

async function main() {
  const Airdrop = await hre.ethers.getContractFactory("Airdrop");
  const airdrop = await Airdrop.attach("0xcf6249FFb910AfBb1990C61013775338e1045C83");
  
  let addrArray = [];
  for(var i = 0; i < WalletAddress.length; i++) 
      addrArray.push(WalletAddress[i].Yourethereumwalletaddress);
  console.log(addrArray);

  console.log("starting airdrop..")
  const tx = await airdrop.airdrop(addrArray);
  await tx.wait();
  console.log("airdrop completed!");

//   const airdropAddress = airdrop.address;
//   console.log("Airdrop deployed to:", airdropAddress);
  
  
//   let address = {
//     "musicFactory" : musicFactoryAddress,
//     "erc20" : erc20Address,
//     "musicMarket" : musicMarketAddress,
//     "airdrop" : airdropAddress,
//   };
//   let addressJSON = JSON.stringify(address);
//   fs.writeFileSync("environment/ContractAddress.json", addressJSON);

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });