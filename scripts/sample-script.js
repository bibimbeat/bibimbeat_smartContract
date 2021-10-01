// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const fs = require('fs');

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');


  // const GameItems = await hre.ethers.getContractFactory("GameItems");
  // const gameItems = await GameItems.deploy();
  // await gameItems.deployed();
  // const gameItems = await GameItems.attach("0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0");

  // console.log("GameItems deployed to:", gameItems.address);
  // await gameItems.mint();
  // const balance = await gameItems.balanceOf("0x8626f6940e2eb28930efb4cef49b2d1f2c9c1199", 0)
  // console.log(balance);
  // We get the contract to deploy
  const MusicFactory = await hre.ethers.getContractFactory("MusicFactory");

  // const musicFactory = await MusicFactory.attach("0x5FbDB2315678afecb367f032d93F642f64180aa3");
  const musicFactory = await MusicFactory.deploy();
  await musicFactory.deployed();

  console.log("Music Factory deployed to:", musicFactory.address);

  let address = {"musicFactory" : musicFactory.address};
  let addressJSON = JSON.stringify(address);
  fs.writeFileSync("environment/MusicFactory.json", addressJSON); 


  // await musicFactory.mintMusic(777, {gasLimit: 30000000});
  // await musicFactory.mintMusic(1, "lucffky");
  // await musicFactory.mintMusic(464, "luckvvy");
  // await musicFactory.mintMusic(734, "lucdcky");
  // await musicFactory.mintMusic(77273, "lzzzucky");
  // console.log(tx);

  // const tokenIdList = await musicFactory.getTokenIDs();

  // await Promise.all(tokenIdList.map(async (res) => {
  //   const i = parseInt(Number(res._hex), 10);
  //   console.log(i);
  //   const uri = await musicFactory.getTokenURI(i);
  //   const amount = await musicFactory.getTokenAmount(i);
  //   console.log(amount);
  //   console.log(uri);
  // }));
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });