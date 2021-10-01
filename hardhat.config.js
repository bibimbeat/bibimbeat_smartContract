require("@nomiclabs/hardhat-waffle");
require("@metis.io/hardhat-mvm");
require("dotenv").config();

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  networks: {
    rinkeby: {
      url: process.env.rinkebyUrl,
      accounts: [process.env.privateKey],
    },
    metis: {
      url: process.env.metisUrl,
      accounts: [process.env.privateKey],
      gasPrice: 15000000,
      ovm: true,
    },
  },
  solidity: "0.7.6",

  ovm: {
    solcVersion: '0.7.6',
    optimizer: true,
    runs: 20
  }
};
