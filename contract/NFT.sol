// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";
import "./admin.sol";

contract NFTTemplate is ERC721Enumerable, Ownable, Admin {
    using Strings for uint256;

    string public baseURI = "ipfs://";
    string public baseExtension;
    string public defaultUri = "ipfs://default";

    mapping(uint256 => string) _tokenURIs;
    
    uint256 tokenIdCnt = 0;

    constructor(string memory name, string memory symble, string memory _defaultUri)
        ERC721(name, symble)
    {
        defaultUri = _defaultUri;
    }

    function mint(address _to,  string calldata _uri) external virtual onlyAdmin {
        uint256 _tokenId = tokenIdCnt;
        _mint(_to, _tokenId);
        _tokenURIs[_tokenId] = _uri;
        tokenIdCnt += 1;
    }
    
    function mint(address _to) external virtual onlyAdmin {
        uint256 _tokenId = tokenIdCnt;
        _mint(_to, _tokenId);
        tokenIdCnt += 1;
    }

    function setTokenUri(uint _tokenId, string calldata _uri) external onlyAdmin{
        require(bytes(_tokenURIs[_tokenId]).length == 0, "This NFT has been setted");
        _tokenURIs[_tokenId] = _uri;
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

        if (bytes(_tokenURI).length == 0) {
            return defaultUri;
        }

        if (bytes(baseExtension).length > 0) {
            return
                string(abi.encodePacked(baseURI, tokenId.toString(), baseExtension));
        }

        return string(abi.encodePacked(baseURI, _tokenURI));
    }

    function setBaseURI(string memory _newBaseURI) public onlyAdmin {
        baseURI = _newBaseURI;
    }

    function setbaseExtension(string memory _baseExtension) public onlyAdmin {
        baseExtension = _baseExtension;
    }

    function setDefaultUri(string memory _defaultUri) public onlyAdmin {
        defaultUri = _defaultUri;
    }
}
