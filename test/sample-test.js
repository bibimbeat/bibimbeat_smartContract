const { expect } = require("chai");

describe("ERC20Minter", function () {
  it("Testing amounts", async function () {
    const ERC20Minter = await hre.ethers.getContractFactory("ERC20Minter");
    const totalSupply = hre.ethers.utils.parseEther("7770000");
    const erc20Minter = await ERC20Minter.deploy("Bibimbeat", "BBB", totalSupply, '0xE51716dB94ec43de4aa66E955f3fC941Cee84472'); // jihyun's rinkeby test account 
    await erc20Minter.deployed();

    let supply = await erc20Minter.totalSupply();
    let supplyNumber = Number(supply._hex);
    console.log("supplyNumber is : " + supplyNumber);
    console.log("haha");
    // console.log(sex._hex);

    expect(await erc20Minter.name()).to.equal("Bibimbeat");
    console.log(await erc20Minter.name())
    console.log(supplyNumber)
    expect(supplyNumber).to.equal(7770000 * Math.pow(10, 18));
  });
});
