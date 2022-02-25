// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;
import "./NFT.sol";

contract testNFT is NFTTemplate {
	constructor()
        NFTTemplate("testNFT", "TN", "ipfs://default")
    {
    }
	function burn(uint tokenId) public {
		_burn(tokenId);
	}
	function mint(address _to, uint _tokenId) external onlyOwner {
        _mint(_to, _tokenId);
    }
	function test() public view returns(uint _totalSupply){
		_totalSupply = totalSupply();
	}
}