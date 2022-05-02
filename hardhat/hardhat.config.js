require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
const url = "https://eth-rinkeby.alchemyapi.io/v2/NbpgpuaX20aXkIYuL9YY4vMgm5DpnQVN"
const prikey="ac65355320766cb69d15ca744e3d211f08a015b78ec966fbc4307bd2fde94248"
module.exports = {
  solidity: "0.8.12",
  networks: {
    rinkeby: {
      url: url,
      accounts:[prikey]
    }
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: "11VS4CCN865N89BU7RF8UV9ZYU2V4D7739"
  }
};
