// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract HoBINFT is ERC721, ERC721URIStorage {
    using Strings for uint256;
    constructor() ERC721("HoBiNFT", "HBT") {}

    // string public baseUri = "https://gateway.pinata.cloud/ipfs/QmUdFbnu3GiB6BPgooCdewyZ4t4FBGtasRpvwZcxySm2Je/";
    function _baseURI() internal pure override returns (string memory) {
        return "https://gateway.pinata.cloud/ipfs/QmUdFbnu3GiB6BPgooCdewyZ4t4FBGtasRpvwZcxySm2Je/";
    }

    function mintNFT(address nftMarketplace, uint256 tokenId) public {
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, _baseURI());
        _setApprovalForAll(msg.sender, nftMarketplace, true);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }
}