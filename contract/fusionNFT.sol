// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;
import "./NFT.sol";

contract fusionNFT is NFTTemplate {
    using Strings for uint256;
	
    
    mapping(uint256 => mapping(uint256 => string)) public recipe;

    constructor()
        NFTTemplate("FusionNFT", "FUN", "ipfs://bafkreid4jqgen3erpgaua7u7iywzzdatolmopwpkldtnjiali2wy5qwanq")
    {
    }

    function mint(address _to,  string calldata _uri) override external onlyAdmin {
        _mint(_to, tokenIdCnt);
        _tokenURIs[tokenIdCnt] = _uri;
		tokenIdCnt += 1;
    }


	function setRecipe(string calldata A, string calldata B, string calldata C) external onlyAdmin {
		recipe[uint256(keccak256(bytes(A)))][uint256(keccak256(bytes(B)))] = C;
		recipe[uint256(keccak256(bytes(B)))][uint256(keccak256(bytes(B)))] = C;
	}

    function getRecipe(string calldata A, string calldata B) public view returns(string memory){
        return recipe[uint256(keccak256(bytes(A)))][uint256(keccak256(bytes(B)))];
    }

	function fusion(uint256 tokenIdA, uint256 tokenIdB)external {
		require(ownerOf(tokenIdA) == msg.sender, "You are not the first NFT owner");
		require(ownerOf(tokenIdB) == msg.sender, "You are not the second NFT owner");
		require(bytes(recipe[uint256(keccak256(bytes(_tokenURIs[tokenIdA])))][uint256(keccak256(bytes(_tokenURIs[tokenIdB])))]).length != 0, "This recipe not exist");
		string memory _uri = recipe[uint256(keccak256(bytes(_tokenURIs[tokenIdA])))][uint256(keccak256(bytes(_tokenURIs[tokenIdB])))];
		_burn(tokenIdA);
        _tokenURIs[tokenIdA] = "";
		_burn(tokenIdB);
        _tokenURIs[tokenIdB] = "";
        _mint(msg.sender, tokenIdCnt);
        _tokenURIs[tokenIdCnt] = _uri;
		tokenIdCnt += 1;
	}
	
    function withdraw(address to) public onlyOwner {
        uint256 balance = address(this).balance;
        payable(to).transfer(balance);
    }

}
