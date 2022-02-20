// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";

contract fusionNFT is ERC721Enumerable, Ownable {
    using Strings for uint256;
	uint256 tokenIdCnt = 0;
    string public baseURI = "ipfs://";
    string public notRevealedUri;
    string public baseExtension;

    mapping(uint256 => string) private _tokenURIs;
    mapping(uint256 => mapping(uint256 => string)) public recipe;

    constructor()
        ERC721("FusionNFT", "FUN")
    {
    }

    function mint(address _to,  string calldata _uri) external onlyOwner {
        _mint(_to, tokenIdCnt);
        _tokenURIs[tokenIdCnt] = _uri;
		tokenIdCnt += 1;
    }


	function setRecipe(string memory A, string memory B, string calldata C) external onlyOwner {
		recipe[uint256(keccak256(bytes(A)))][uint256(keccak256(bytes(B)))] = C;
		recipe[uint256(keccak256(bytes(B)))][uint256(keccak256(bytes(B)))] = C;
	}

	function fusion(uint256 tokenIdA, uint256 tokenIdB)external {
		require(ownerOf(tokenIdA) == msg.sender, "You are not the first NFT owner");
		require(ownerOf(tokenIdB) == msg.sender, "You are not the second NFT owner");
		require(bytes(recipe[uint256(keccak256(bytes(_tokenURIs[tokenIdA])))][uint256(keccak256(bytes(_tokenURIs[tokenIdB])))]).length != 0, "This recipe not exist");
		string memory _uri = recipe[uint256(keccak256(bytes(_tokenURIs[tokenIdA])))][uint256(keccak256(bytes(_tokenURIs[tokenIdB])))];
		_burn(tokenIdA);
		_burn(tokenIdB);
        _mint(msg.sender, tokenIdCnt);
        _tokenURIs[tokenIdCnt] = _uri;
		tokenIdCnt += 1;
	}
	
    function withdraw(address to) public onlyOwner {
        uint256 balance = address(this).balance;
        payable(to).transfer(balance);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(baseExtension).length > 0) {
            return
                string(abi.encodePacked(base, tokenId.toString(), baseExtension));
        }
        // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
        return string(abi.encodePacked(base, _tokenURI));
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setbaseExtension(string memory _baseExtension) public onlyOwner {
        baseExtension = _baseExtension;
    }
}
