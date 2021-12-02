// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const fs = require('fs');

async function main() {

  const MusicFactory = await hre.ethers.getContractFactory("MusicFactory");
  const MusicMarket = await hre.ethers.getContractFactory("MusicMarket");
  const ERC20Minter = await hre.ethers.getContractFactory("ERC20Minter");
  const Airdrop = await hre.ethers.getContractFactory("Airdrop");
  
  const musicFactory = await MusicFactory.deploy();
  await musicFactory.deployed();
  const musicFactoryAddress = musicFactory.address;
  console.log("Music Factory deployed to:", musicFactoryAddress);

  const erc20Minter = await ERC20Minter.deploy(); // jihyun's rinkeby test account 
  await erc20Minter.deployed();
  const erc20Address = erc20Minter.address;
  console.log("ERC20 deployed to:", erc20Address);

  const musicMarket = await MusicMarket.deploy(erc20Address, musicFactoryAddress);
  await musicMarket.deployed();
  const musicMarketAddress = musicMarket.address;
  console.log("Music Market deployed to:", musicMarketAddress);

  const airdrop = await Airdrop.deploy(erc20Address);
  await airdrop.deployed();
  const airdropAddress = airdrop.address;
  console.log("Airdrop deployed to:", airdropAddress);
  
  
  let address = {
    "musicFactory" : musicFactoryAddress,
    "erc20" : erc20Address,
    "musicMarket" : musicMarketAddress,
    "airdrop" : airdropAddress,
  };
  let addressJSON = JSON.stringify(address);
  fs.writeFileSync("environment/ContractAddress.json", addressJSON);


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });