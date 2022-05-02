
const hre = require("hardhat");
const address = '0xa7102Fb5f86A448063305ff9d13a2D7f37b18097';
async function main() {
  const FusionNFT = await hre.ethers.getContractFactory("fusionNFT");
  const fusionNFT = await FusionNFT.deploy();

  	await fusionNFT.deployed();
	console.log("fusionNFT deployed to:", fusionNFT.address);
	NFTContract = await FusionNFT.attach(fusionNFT.address)
	await NFTContract.mint2(address, "bafkreiat2mmtmzodnd6fhxb3koyvwfndgj7tlyt5ce6a5guhtaflepslwy");
	await NFTContract.mint2(address, "bafkreifcx67k3nglshecxmm3xyqugw7kzpfag7mtzqrkxzuusbhfnv6yry");
	await NFTContract.mint2(address, "bafkreiffbqlqeokla5rcudslnhoxojmsgdw47z54pgolwiltri6mvzsk44");
	await NFTContract.mint2(address, "bafkreigyqoojpadsasl55m7zcd2jmmgyhhaeyd2weqn52ar55xbjvipwry");
	await NFTContract.mint2(address, "bafkreifsduglipelo572aamokpn3qgamrf6lsngudcrjwxvqv2oaxrhj4u");
	await NFTContract.mint2(address, "bafkreic44me6uz2yj5xabuvoalabhnmrwkw5uz3yan7boy3oie4xgthwaa");
	await NFTContract.mint2(address, "bafkreicbp5o3dysdubfr347d234p4tfu4rq2z5o2qopqufq7aypr66au3m");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
