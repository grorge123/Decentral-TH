Moralis = require('moralis')
const serverUrl = "https://q35jbv5jagyw.usemoralis.com:2053/server";
const appId = "1kfWR1GvtpZwlXDhJ3sG1Fv9twJzjZ3zcn2DkBjq";
Moralis.start({ serverUrl, appId });
async function getAllToken() {
	const options = { address: "0x2A26AA5bE62947D6bE159D4D96bE8cf3Abe21A88", chain: "rinkeby" };
	const NFTs = await Moralis.Web3API.token.getAllTokenIds(options);
	console.log(NFTs)
}
async function getNFTFromAddr() {
	const options = {chain:"rinkeby", address:"0xa7102Fb5f86A448063305ff9d13a2D7f37b18097",token_address:"0x2A26AA5bE62947D6bE159D4D96bE8cf3Abe21A88"}
	const NFTS = await Moralis.Web3API.account.getNFTsForContract(options)
	console.log(NFTS)
}
getNFTFromAddr()