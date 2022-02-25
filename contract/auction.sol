// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

interface IMyNFT is IERC721Enumerable {
	function tokenURI(uint256 tokenId) external view returns (string memory);
	
}

contract Auction is Ownable{

	IERC20 NTToken;


	struct limitPrice{
		address creator;
		uint price;
		address NFTContract;
		uint tokenId;
	}

	limitPrice[] limitPriceList;
	mapping(address => mapping( address => mapping(uint => bool))) isSell;

	address[] public whiteList;

	constructor(address NTTokenAddress){
		NTToken = IERC20(NTTokenAddress);
	}

    function getBalance(address _addr) public view returns( uint ){
        return NTToken.balanceOf(_addr);
    }
	
	function setWhiteList(uint _id, address _addr) onlyOwner() public {
		if(_id >= whiteList.length){
			whiteList.push(_addr);
		}else{
			whiteList[_id] = _addr;
		}
	}

	modifier checkPremission(address _NFTAddr, uint _tokenId, uint _price) {
		IMyNFT NFTContract = IMyNFT(_NFTAddr);
        require(NFTContract.ownerOf(_tokenId) == msg.sender, "You are not Owner");
		require(NFTContract.getApproved(_tokenId) == address(this), "You have not approve");
        require(isSell[msg.sender][_NFTAddr][_tokenId] == false, "You have sold it");
		_;
    }

	modifier checkWallet(address _NFTAddr, uint _tokenId, uint _price, address seller){
		IMyNFT NFTContract = IMyNFT(_NFTAddr);
		require(NFTContract.getApproved(_tokenId) == address(this), "Seller have not approve");
		require(NTToken.allowance(msg.sender, address(this)) >= _price, "You have not approve enough token");
		
		_;
	}

	function createLimitPriceOrder(uint _NFTId, uint _tokenId, uint _price) checkPremission(whiteList[_NFTId], _tokenId,  _price) public returns( uint ){
		limitPrice memory Order;
		Order.creator = msg.sender;
		Order.price = _price;
		Order.tokenId = _tokenId;
		Order.NFTContract = whiteList[_NFTId];
		limitPriceList.push(Order);
		isSell[msg.sender][whiteList[_NFTId]][_tokenId] = true;
		return limitPriceList.length - 1;
	}

	function cancelLimitPriceOrder(uint _id) public {
		require(limitPriceList[_id].creator == msg.sender, "You are not Owner");
		isSell[limitPriceList[_id].creator][limitPriceList[_id].NFTContract][limitPriceList[_id].tokenId] = false;
		if(limitPriceList.length > 1){
			limitPriceList[_id] = limitPriceList[limitPriceList.length - 1];
		}
		limitPriceList.pop();
	}

	function buyLimitPriceOrder(uint _id) 
	public
	checkWallet(limitPriceList[_id].NFTContract, limitPriceList[_id].tokenId, limitPriceList[_id].price, limitPriceList[_id].creator) 
	{
		IMyNFT NFTContract = IMyNFT(limitPriceList[_id].NFTContract);
		NTToken.transferFrom(msg.sender, limitPriceList[_id].creator, limitPriceList[_id].price);
		NFTContract.safeTransferFrom(limitPriceList[_id].creator, msg.sender, limitPriceList[_id].tokenId);
		isSell[limitPriceList[_id].creator][limitPriceList[_id].NFTContract][limitPriceList[_id].tokenId] = false;
		if(limitPriceList.length > 1){
			limitPriceList[_id] = limitPriceList[limitPriceList.length - 1];
		}
		limitPriceList.pop();
	}

	function getLimitPriceListLength() public view returns(uint){
		return limitPriceList.length;
	}

	function getLimitPriceList(uint _id) public view returns(limitPrice memory){
		return limitPriceList[_id];
	}
	function getWhiteListLength() public view returns(uint){
		return whiteList.length;
	}
	
}