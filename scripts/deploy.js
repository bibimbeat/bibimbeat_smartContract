// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const fs = require('fs');

async function main() {

  const MusicFactory = await hre.ethers.getContractFactory("MusicFactory");
  const ERC20Minter = await hre.ethers.getContractFactory("ERC20Minter");

  const MusicMarket = await hre.ethers.getContractFactory("MusicMarket");
  
  // const musicFactory = await MusicFactory.attach("0x5FbDB2315678afecb367f032d93F642f64180aa3");
  const musicFactory = await MusicFactory.deploy();
  await musicFactory.deployed();
  const musicFactoryAddress = musicFactory.address;
  console.log("Music Factory deployed to:", musicFactoryAddress);

  const erc20Minter = await ERC20Minter.deploy("Bibimbeat", "BBB", 100000000000000, '0x98cc800c4F5F16C00b506D29A470b04f6938384D'); // jihyun's rinkeby test account 
  await erc20Minter.deployed();
  const erc20MinterAddress = erc20Minter.address;
  console.log("ERC20 deployed to:", erc20MinterAddress);

  const musicMarket = await MusicMarket.deploy(erc20MinterAddress, musicFactoryAddress);
  await musicMarket.deployed();
  const musicMarketAddress = musicMarket.address;
  console.log("Music Market deployed to:", musicMarketAddress);
  
  
  let address = {
    "musicFactory" : musicFactoryAddress,
    "erc20" : erc20MinterAddress,
    "musicMarket" : musicMarketAddress
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