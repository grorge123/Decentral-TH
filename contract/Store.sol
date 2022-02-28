// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;
import "./fusionNFT.sol";
import "./VRF.sol";
import "./admin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract Store is Admin{
	fusionNFT FNFT;
	VRFv2Consumer VRF;
	IERC20 NTToken;
	uint constant initialUint = 10 ** 18;
	uint fusionNFTPrice = 100 * initialUint;
	string[] fusionNFTUri;

    uint256 internal fee;
	bytes32 private lastrandom;
    
    uint256 public randomResult;

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

	function getFusionNFT() checkToken(fusionNFTPrice) public {
		NTToken.transferFrom(msg.sender, address(this), fusionNFTPrice);
		uint NFTUriId = RandomNumber() % fusionNFTUri.length;
		FNFT.mint(msg.sender, fusionNFTUri[NFTUriId]);
	}
	
	function setFusionNFTPrice(uint _price) public onlyAdmin{ 
		fusionNFTPrice = _price * initialUint;
	}

	function fusionNFTUriLength() public view returns(uint){
		return fusionNFTUri.length;
	}

	function setfusionNFTUri(uint _id, string calldata _uri) public onlyAdmin{
		if(_id >= fusionNFTUri.length){
			fusionNFTUri.push(_uri);
		}else{
			fusionNFTUri[_id] = _uri;
		}
	}

}