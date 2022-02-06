
pragma solidity ^0.8.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "hardhat/console.sol";
import "../token.sol";
import "../auction.sol";
import "../NFT.sol";

contract auctionTest{

	NTToken token;
	Auction auction;
	MyNFT NFT; 
	uint constant initialUint = 10 ** 18;

	function beforeAll() public {
        token = new NTToken();
		auction = new Auction(address(token));
		NFT = new MyNFT("");
		NFT.mint(address(this), "TEST"); //tokenId = 0
		NFT.mint(address(this), "TEST"); //tokenId = 1
		NFT.mint(0xf04c6a55F0fdc0A5490d83Be69A7A675912A5AB3, "TEST"); //tokenId = 2
	}
    
	function connect() public {
		Assert.equal(token.owner(), address(this), "You should be Owner");
		Assert.equal(auction.getBalance(address(this)), 1000000 * initialUint, "It should mint 1000000 token");
	}

	function Order() public{
		try auction.createLimitPriceOrder(address(NFT), 2, 5){ // test not owner
            Assert.ok(false,"It should't success");
        }catch Error(string memory reason){
			console.logString("Test not owner:");
			console.logString(reason);
            Assert.ok(true, "It should't fail");
        }
		try auction.createLimitPriceOrder(address(NFT), 3, 5){ // test not exist
            Assert.ok(false,"It should't success");
        }catch Error(string memory reason){
			console.logString("Test not exist:");
			console.logString(reason);
            Assert.ok(true, "It should't fail");
        }
		try auction.createLimitPriceOrder(address(NFT), 0, 5){ // test not approve
            Assert.ok(false,"It should't success");
        }catch Error(string memory reason){
			console.logString("Test not approve:");
			console.logString(reason);
            Assert.ok(true, "It should't fail");
        }
		NFT.approve(address(auction), 0);
		auction.createLimitPriceOrder(address(NFT), 0, 5);
		try auction.createLimitPriceOrder(address(NFT), 0, 5){ // test multiple create
            Assert.ok(false,"It should't success");
        }catch Error(string memory reason){
			console.logString("Test multiple create");
			console.logString(reason);
            Assert.ok(true, "It should't fail");
        }
		Assert.equal(auction.getLimitPriceList()[0].creator, address(this), "It should be create order");
	}
    
	function cancel() public{
		NFT.approve(address(auction), 1);
		auction.createLimitPriceOrder(address(NFT), 1, 5);
		try auction.cancelLimitPriceOrder(2){ // test not exist order
            Assert.ok(false,"It should't success");
        }catch (bytes memory reason){
            Assert.ok(true, "It should't fail");
        }
		auction.cancelLimitPriceOrder(0);
		Assert.equal(auction.getLimitPriceList().length, 1, "It should be create order");
		Assert.equal(auction.getLimitPriceList()[0].tokenId, 1, "It should be create order");
	}
}