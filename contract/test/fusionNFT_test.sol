
pragma solidity ^0.8.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "../fusionNFT.sol";

contract tokenTest{

	fusionNFT NFT;
	string A = "ASDHjklasdjkhwualAHUWDHjkasdhjkjwkhlasbdnm";
	string B = "asdhjHJKLASDHujlsjbvjbLKJSAhdLKJsAJSHDaskdJHLKJASD";
	string C = "Successful";
	string D = "AAAAABBBBBBBBBCCCCCCCCCC";
	address NULL = 0xa7102Fb5f86A448063305ff9d13a2D7f37b18097;
	function beforeAll() public {
        NFT = new fusionNFT();
		NFT.setRecipe(A, B, C);
		NFT.setBaseURI("");
    }

	function failFusion()public{
		NFT.mint(NULL, A); // 0
		NFT.mint(NULL, B); // 1
		NFT.mint(NULL, D); // 2
		try NFT.fusion(0, 1){ // test not owner
            Assert.ok(false,"It should't success");
        }catch Error(string memory reason){
            Assert.ok(true, "It should't fail");
        }
		try NFT.fusion(2, 3){ // test not owner
            Assert.ok(false,"It should't success");
        }catch Error(string memory reason){
            Assert.ok(true, "It should't fail");
        }
	}

	function fusion()public{
		NFT.mint(address(this), A); // 3
		NFT.mint(address(this), B); // 4
		NFT.fusion(3, 4); // 5
		Assert.equal(NFT.ownerOf(5), address(this), "You should be owner");
		Assert.equal(NFT.tokenURI(5), C, "It should be success");
		try NFT.ownerOf(3){
		    Assert.ok(false,"It should't success");
        }catch Error(string memory reason){
            Assert.ok(true, "It should't fail");
        }
		try NFT.ownerOf(4){
		    Assert.ok(false,"It should't success");
        }catch Error(string memory reason){
            Assert.ok(true, "It should't fail");
        }
	}
	
	function notExistRecipt()public{
		NFT.mint(address(this), D); // 6
		try NFT.fusion(5, 6){
		    Assert.ok(false,"It should't success");
        }catch Error(string memory reason){
            Assert.ok(true, "It should't fail");
        }
	}

	
}