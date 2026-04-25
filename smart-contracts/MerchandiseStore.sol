// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title MerchandiseStore
 * @dev A contract for Cabal creators to sell merchandise for specific ERC20 tokens
 * and offer bonus tokens as a reward.
 */
contract MerchandiseStore is Ownable {
    struct Product {
        uint256 id;
        address seller; // The wallet that receives payment
        IERC20 paymentToken;
        uint256 price; // Price in the smallest unit of the paymentToken
        IERC20 bonusToken;
        uint256 bonusAmount;
        bool isActive;
    }

    uint256 public nextProductId;
    mapping(uint256 => Product) public products;

    event ProductListed(
        uint256 indexed productId,
        address indexed seller,
        address paymentToken,
        uint256 price
    );
    event ProductPurchased(
        uint256 indexed productId,
        address indexed buyer,
        uint256 pricePaid,
        uint256 bonusReceived
    );
    event ProductDeactivated(uint256 indexed productId);

    constructor() Ownable(msg.sender) {}

    /**
     * @dev Lists a new product for sale.
     * @param _seller The address that will receive the payment.
     * @param _paymentToken The ERC20 token address for payment.
     * @param _price The price of the product (in the token's smallest unit).
     * @param _bonusToken The ERC20 token address for the bonus reward.
     * @param _bonusAmount The amount of bonus tokens to award.
     */
    function listProduct(
        address _seller,
        address _paymentToken,
        uint256 _price,
        address _bonusToken,
        uint256 _bonusAmount
    ) external onlyOwner {
        require(_seller != address(0), "Seller cannot be zero address");
        require(_paymentToken != address(0), "Payment token cannot be zero address");
        require(_price > 0, "Price must be greater than zero");

        uint256 productId = nextProductId;
        products[productId] = Product({
            id: productId,
            seller: _seller,
            paymentToken: IERC20(_paymentToken),
            price: _price,
            bonusToken: IERC20(_bonusToken),
            bonusAmount: _bonusAmount,
            isActive: true
        });

        nextProductId++;
        emit ProductListed(productId, _seller, _paymentToken, _price);
    }

    /**
     * @dev Allows a user to purchase a product.
     * The user MUST have approved this contract to spend `price` of `paymentToken`.
     * The contract OWNER must have approved this contract to spend `bonusAmount` of `bonusToken`.
     * @param productId The ID of the product to purchase.
     */
    function purchase(uint256 productId) external {
        Product storage product = products[productId];
        require(product.isActive, "Product is not available for sale");

        address buyer = msg.sender;

        // 1. Transfer payment from buyer to seller
        bool paymentSuccess = product.paymentToken.transferFrom(buyer, product.seller, product.price);
        require(paymentSuccess, "Payment transfer failed");

        // 2. Transfer bonus tokens from the owner (creator's bonus wallet) to the buyer
        if (product.bonusAmount > 0 && address(product.bonusToken) != address(0)) {
            bool bonusSuccess = product.bonusToken.transferFrom(owner(), buyer, product.bonusAmount);
            require(bonusSuccess, "Bonus token transfer failed");
        }

        emit ProductPurchased(productId, buyer, product.price, product.bonusAmount);
    }

    /**
     * @dev Deactivates a product, making it unavailable for purchase.
     */
    function deactivateProduct(uint256 productId) external onlyOwner {
        require(products[productId].isActive, "Product already inactive");
        products[productId].isActive = false;
        emit ProductDeactivated(productId);
    }

    /**
     * @dev Allows the owner to update the price of a product.
     */
    function updatePrice(uint256 productId, uint256 newPrice) external onlyOwner {
        require(products[productId].isActive, "Product not active");
        require(newPrice > 0, "Price must be greater than zero");
        products[productId].price = newPrice;
    }
}
