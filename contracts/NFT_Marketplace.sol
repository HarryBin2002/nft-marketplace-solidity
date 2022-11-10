// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; 

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract NFTMarketplace is Ownable {

    address private ownerMarketplace;
    address private USDTContract;

    constructor(
        address _USDTContract
    ) {
        ownerMarketplace = msg.sender;
        USDTContract = _USDTContract;
    }

    mapping (address => uint256) private ownerToTokenId;
    mapping (uint256 => address) private TokenIdtoOwner;
    mapping (uint256 => uint256) private tokenIdToItemId;


    // Structure NFT item
    struct NFT_ITEM {
        address nftContract;
        uint256 tokenId;
        uint256 price;
        bool sold;
    }

    NFT_ITEM[] private items;
    uint256 private itemId;

    // Listing NFT 
    function listingNFT(
        address nftContract,
        uint256 tokenId,
        uint256 price
    ) payable public {
        require(price > 0, "price invalid");

        items.push(
            NFT_ITEM(nftContract, tokenId, price, false)
        );

        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

        ownerToTokenId[msg.sender] = tokenId; 
        TokenIdtoOwner[tokenId] = msg.sender;
        tokenIdToItemId[tokenId] = itemId;
        itemId += 1;
    } 

    // Delisting NFT
    function delistingNFTForce(
        address nftContract,
        uint256 tokenId
    ) public onlyOwner {

        IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId);

        delete items[tokenIdToItemId[tokenId]];
        itemId -= 1;
    }

    function delistingNFT(
        address nftContract,
        uint256 tokenId
    ) public {
        require(TokenIdtoOwner[tokenId] == msg.sender, "You're not owner of this NFT");

        IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId);

        delete items[tokenIdToItemId[tokenId]];
        itemId -= 1;
    }

    // Buying NFT
    struct NFTtoSold {
        address nftContract;
        uint256 tokenId;
        uint256 offeredPrice;
        address buyer;
    }

    NFTtoSold[] public offers;
    address private buyer;

    function offeringNFT(
        address nftContract,
        uint256 tokenId,
        uint256 offeredPrice
    ) public {
        NFT_ITEM storage itemExam = items[tokenIdToItemId[tokenId]]; 

        require(msg.sender.balance > 0, "not enough money");
        require(itemExam.sold == false, "NFt is sold");

        offers.push(
            NFTtoSold(nftContract, tokenId, offeredPrice, msg.sender)
        );
    }
    
    function SellingNFT(
        address nftContract,
        uint256 tokenId
    ) public {
        require(TokenIdtoOwner[tokenId] == msg.sender, "not allowance");
        for (uint256 i = 0; i < offers.length; i++) {
            if (offers[i].tokenId == tokenId && offers[i].offeredPrice == getMaximumPriceNFT(tokenId)) {
                IERC721(nftContract).transferFrom(
                    address(this),
                    offers[i].buyer,
                    offers[i].tokenId
                );

                ERC20(USDTContract).transferFrom(
                    offers[i].buyer, 
                    msg.sender, 
                    offers[i].offeredPrice
                );

            }
        }
        itemId -= 1;
    }

    function getMaximumPriceNFT(uint256 tokenId) internal view returns (uint256) {
        uint256 maxOfferedPrice = offers[0].offeredPrice;

        for (uint256 i = 0; i < offers.length; i++) {
            if (offers[i].tokenId == tokenId && offers[i].offeredPrice > maxOfferedPrice) {
                maxOfferedPrice = offers[i].offeredPrice;
            }
        }

        return maxOfferedPrice;
    }

    // Getting
    function getAmountNFTOnMarket() public view returns (uint256) {
        return itemId;
    }

    function getItemIdFromTokenId(uint256 tokenId) public view returns (uint256) {
        return tokenIdToItemId[tokenId];
    }  

    function getListOfferNFT() public view returns (NFTtoSold[] memory) {
        return offers;
    }
}