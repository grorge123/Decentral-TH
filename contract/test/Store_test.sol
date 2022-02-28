
pragma solidity ^0.8.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "../token.sol";
import "../Store.sol";
import "../fusionNFT.sol";
import "hardhat/console.sol";


contract storetest{
	fusionNFT NFT;
	NTToken token;
	Store store;
	uint constant initialUint = 10 ** 18;

	function beforeAll() public {
        token = new NTToken();
		NFT = new fusionNFT();
		NFT.setBaseURI("");
		store = new Store(address(NFT), address(token));
		store.setFusionNFTPrice(5);
		store.setfusionNFTUri(1, "SUCCESS");
		NFT.setAdmin(address(store), true);
	}

	function mint() public {
		try store.getFusionNFT(){ // test not enough token
            Assert.ok(false,"It should't success");
        }catch Error(string memory reason){
            Assert.ok(true, "It should't fail");
        }
		token.approve(address(store), 5*initialUint);
		store.getFusionNFT();
		// Assert.equal(NFT.balanceOf(address(this)), 1, "Mint should success");
		// Assert.equal(NFT.tokenURI(1), "SUCCESS", "It should be success");
		// Assert.equal(token.balanceOf(address(this)), (1000000-5) * initialUint, "It should be cost");
	}
    
	
}