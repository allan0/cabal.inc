// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title CabalNftMarketplace
 * @dev A simple marketplace for listing and selling ERC721 tokens for native currency (ETH).
 */
contract CabalNftMarketplace is Ownable, ReentrancyGuard {
    struct Listing {
        address seller;
        uint256 price; // in wei
        bool active;
    }

    // Mapping from NFT contract address to a nested mapping of tokenId to Listing
    mapping(address => mapping(uint256 => Listing)) public listings;

    // Platform fee in basis points (e.g., 250 for 2.5%)
    uint256 public platformFeeBps;

    event ItemListed(
        address indexed seller,
        address indexed nftAddress,
        uint256 indexed tokenId,
        uint256 price
    );
    event ItemSold(
        address indexed seller,
        address indexed buyer,
        address indexed nftAddress,
        uint256 indexed tokenId,
        uint256 price
    );
    event ItemCanceled(
        address indexed seller,
        address indexed nftAddress,
        uint256 indexed tokenId
    );
    event PlatformFeeUpdated(uint256 newFeeBps);

    constructor(uint256 _initialFeeBps) Ownable(msg.sender) {
        require(_initialFeeBps <= 500, "Fee cannot exceed 5%"); // Safety check
        platformFeeBps = _initialFeeBps;
    }

    /**
     * @dev Lists an ERC721 token for sale. The caller must be the owner of the token
     * and must have approved this contract to transfer it.
     * @param nftAddress The address of the ERC721 contract.
     * @param tokenId The ID of the token to list.
     * @param price The selling price in wei.
     */
    function listItem(address nftAddress, uint256 tokenId, uint256 price) external {
        require(price > 0, "Price must be greater than zero");
        IERC721 nft = IERC721(nftAddress);
        require(nft.ownerOf(tokenId) == msg.sender, "You do not own this item");

        // Transfer the NFT from the seller to this marketplace contract for safekeeping
        nft.transferFrom(msg.sender, address(this), tokenId);

        listings[nftAddress][tokenId] = Listing({
            seller: msg.sender,
            price: price,
            active: true
        });

        emit ItemListed(msg.sender, nftAddress, tokenId, price);
    }

    /**
     * @dev Allows a user to buy a listed item.
     * @param nftAddress The address of the ERC721 contract.
     * @param tokenId The ID of the token to buy.
     */
    function buyItem(address nftAddress, uint256 tokenId) external payable nonReentrant {
        Listing storage listing = listings[nftAddress][tokenId];
        require(listing.active, "Item is not listed for sale");
        require(msg.value == listing.price, "Incorrect payment amount");

        address seller = listing.seller;
        
        // Mark as inactive to prevent re-entrancy issues before transfers
        listing.active = false;

        // Calculate and transfer platform fee to the owner
        uint256 fee = (msg.value * platformFeeBps) / 10000;
        uint256 sellerProceeds = msg.value - fee;

        if (fee > 0) {
            (bool success, ) = owner().call{value: fee}("");
            require(success, "Fee transfer failed");
        }

        // Transfer proceeds to the seller
        (bool success_seller, ) = seller.call{value: sellerProceeds}("");
        require(success_seller, "Payment to seller failed");
        
        // Transfer the NFT to the buyer
        IERC721(nftAddress).safeTransferFrom(address(this), msg.sender, tokenId);

        emit ItemSold(seller, msg.sender, nftAddress, tokenId, msg.value);
    }

    /**
     * @dev Allows the seller to cancel their listing and retrieve their NFT.
     * @param nftAddress The address of the ERC721 contract.
     * @param tokenId The ID of the token to cancel.
     */
    function cancelListing(address nftAddress, uint256 tokenId) external {
        Listing storage listing = listings[nftAddress][tokenId];
        require(listing.active, "Item is not listed for sale");
        require(listing.seller == msg.sender, "You are not the seller");

        listing.active = false;
        
        // Return the NFT to the seller
        IERC721(nftAddress).safeTransferFrom(address(this), msg.sender, tokenId);

        emit ItemCanceled(msg.sender, nftAddress, tokenId);
    }

    /**
     * @dev Updates the platform fee. Only callable by the owner.
     * @param newFeeBps The new fee in basis points.
     */
    function updatePlatformFee(uint256 newFeeBps) external onlyOwner {
        require(newFeeBps <= 500, "Fee cannot exceed 5%");
        platformFeeBps = newFeeBps;
        emit PlatformFeeUpdated(newFeeBps);
    }
}
