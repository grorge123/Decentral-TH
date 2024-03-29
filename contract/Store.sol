// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;
import "./fusionNFT.sol";
import "./admin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract Store is Admin{

	event getNFTEvent(address contractAddr, address user, string uri);
	
	fusionNFT FNFT;
	IERC20 NTToken;
	struct NormalNFT{
		uint price;
		string[] uri;
	}
	uint constant public initialUint = 10 ** 18;
	uint public fusionNFTPrice = 100 * initialUint;
	string[] public fusionNFTUri;

	mapping(address => NormalNFT) public NFTList;

	bytes32 private lastrandom;
    

	constructor(address fusionAddr, address NTTokenAddr)
	{
		FNFT = fusionNFT(fusionAddr);
		NTToken = IERC20(NTTokenAddr);
	}

	function RandomNumber() public returns (uint256) {
        lastrandom = keccak256(abi.encodePacked(block.difficulty, block.timestamp, msg.sender, lastrandom));
		return uint256(lastrandom);
	}


	modifier checkToken(uint _price){
		require(NTToken.allowance(msg.sender, address(this)) >= _price, "You have not approve enough token");
		require(NTToken.balanceOf(msg.sender) >= _price, "You have not enough token");
		_;
	}

	function getNFT(address contractAddr) checkToken(NFTList[contractAddr].price) public returns(string memory) {
		require(NFTList[contractAddr].uri.length > 0, "It have not been store");

		NTToken.transferFrom(msg.sender, address(this), NFTList[contractAddr].price);
		uint NFTUriId = RandomNumber() % NFTList[contractAddr].uri.length;
		FNFT.mint(msg.sender, NFTList[contractAddr].uri[NFTUriId]);
		emit getNFTEvent(contractAddr, msg.sender, NFTList[contractAddr].uri[NFTUriId]);
		return NFTList[contractAddr].uri[NFTUriId];
	}
	
	function setNFTPrice(address contractAddr, uint _price) public onlyAdmin{ 
		NFTList[contractAddr].price = _price * initialUint;
	}

	function getNFTUriLength(address contractAddr) public view returns(uint){
		return NFTList[contractAddr].uri.length;
	}

	function setNFTUri(address contractAddr, uint _id, string calldata _uri) public onlyAdmin{
		if(_id >= NFTList[contractAddr].uri.length){
			NFTList[contractAddr].uri.push(_uri);
		}else{
			NFTList[contractAddr].uri[_id] = _uri;
		}
	}

	function getPrice(address contractAddr) public view returns(uint){
		return NFTList[contractAddr].price;
	}

	function getNFTUri(address contractAddr, uint _id) public view returns(string memory){
		return NFTList[contractAddr].uri[_id];
	}

}