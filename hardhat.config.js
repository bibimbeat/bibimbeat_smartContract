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
    arbitrum_rinkeby: {
      url: process.env.arbitrumRinkebyUrl,
      accounts: [process.env.privateKey],
    },
    metis: {
      url: process.env.metisUrl,
      accounts: [process.env.privateKey],
    },
    mumbai: {
      url: process.env.mumbaiUrl,
      accounts: [process.env.privateKey],
    }
  },
  solidity: "0.7.6",
};
