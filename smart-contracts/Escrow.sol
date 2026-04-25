// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./CabalToken.sol"; // Assumes CabalToken.sol is in the same directory

/**
 * @title Escrow
 * @dev Manages the escrow process for real estate NFT sales on the Cabal platform.
 */
contract Escrow is Ownable {
    enum SaleState { Created, Locked, InspectionPassed, Canceled, Complete }

    struct Sale {
        address payable seller;
        address buyer;
        address broker;
        address deedContractAddress;
        uint256 tokenId;
        uint256 salePrice; // In wei
        uint256 commissionBps; // Commission in basis points (e.g., 250 for 2.5%)
        SaleState state;
        bool buyerApproved;
        bool sellerApproved;
        bool brokerApproved;
    }
    
    CabalToken public immutable cabalToken;
    mapping(uint256 => Sale) public sales; // tokenId -> Sale

    event SaleCreated(uint256 indexed tokenId, address indexed seller, uint256 price);
    event FundsDeposited(uint256 indexed tokenId, address indexed buyer, uint256 amount);
    event InspectionApproved(uint256 indexed tokenId, address indexed approver);
    event SaleFinalized(uint256 indexed tokenId);
    event SaleCanceled(uint256 indexed tokenId);

    constructor(address _cabalTokenAddress) Ownable(msg.sender) {
        cabalToken = CabalToken(_cabalTokenAddress);
    }

    /**
     * @dev Creates a new sale listing. Seller must approve this contract to transfer the NFT.
     */
    function createSale(
        address deedContractAddress,
        uint256 tokenId,
        uint256 salePrice,
        address broker,
        uint256 commissionBps
    ) external {
        IERC721 deed = IERC721(deedContractAddress);
        require(deed.ownerOf(tokenId) == msg.sender, "Not the owner of the deed");
        require(sales[tokenId].seller == address(0), "Sale already exists for this deed");
        require(commissionBps <= 1000, "Commission cannot exceed 10%"); // Safety check

        sales[tokenId] = Sale({
            seller: payable(msg.sender),
            buyer: address(0),
            broker: broker,
            deedContractAddress: deedContractAddress,
            tokenId: tokenId,
            salePrice: salePrice,
            commissionBps: commissionBps,
            state: SaleState.Created,
            buyerApproved: false,
            sellerApproved: false,
            brokerApproved: false
        });

        deed.transferFrom(msg.sender, address(this), tokenId);
        emit SaleCreated(tokenId, msg.sender, salePrice);
    }

    /**
     * @dev Buyer deposits funds into escrow, locking the sale.
     */
    function depositFunds(uint256 tokenId) external payable {
        Sale storage sale = sales[tokenId];
        require(sale.state == SaleState.Created, "Sale not in created state");
        require(msg.value == sale.salePrice, "Incorrect fund amount");

        sale.buyer = msg.sender;
        sale.state = SaleState.Locked;
        emit FundsDeposited(tokenId, msg.sender, msg.value);
    }

    /**
     * @dev Allows any of the three parties to approve the inspection/due diligence phase.
     */
    function approveInspection(uint256 tokenId) external {
        Sale storage sale = sales[tokenId];
        require(sale.state == SaleState.Locked, "Sale not locked");
        
        if (msg.sender == sale.buyer) sale.buyerApproved = true;
        else if (msg.sender == sale.seller) sale.sellerApproved = true;
        else if (msg.sender == sale.broker) sale.brokerApproved = true;
        else revert("Not a party to this sale");

        emit InspectionApproved(tokenId, msg.sender);

        if (sale.buyerApproved && sale.sellerApproved && sale.brokerApproved) {
            sale.state = SaleState.InspectionPassed;
        }
    }

    /**
     * @dev Finalizes the sale after inspection. Transfers NFT to buyer, funds to seller, and commission to broker.
     */
    function finalizeSale(uint256 tokenId) external {
        Sale storage sale = sales[tokenId];
        require(sale.state == SaleState.InspectionPassed, "Inspection not passed");
        require(msg.sender == sale.seller || msg.sender == sale.buyer || msg.sender == sale.broker, "Not a party to this sale");

        sale.state = SaleState.Complete;
        
        uint256 commissionAmount = (sale.salePrice * sale.commissionBps) / 10000;
        uint256 sellerAmount = sale.salePrice - commissionAmount;

        // Transfer NFT to buyer
        IERC721(sale.deedContractAddress).safeTransferFrom(address(this), sale.buyer, sale.tokenId);
        
        // Pay seller
        (bool success, ) = sale.seller.call{value: sellerAmount}("");
        require(success, "Seller payment failed");
        
        // Pay broker commission in native currency
        (bool commissionSuccess, ) = sale.broker.call{value: commissionAmount}("");
        require(commissionSuccess, "Broker payment failed");

        // TODO: Implement logic to also pay a portion of the commission in $CBL
        // This would require this contract to hold $CBL or have minting rights.
        
        emit SaleFinalized(tokenId);
    }
    
    /**
     * @dev Cancels the sale and refunds the buyer. Can be called by any party before finalization.
     */
    function cancelSale(uint256 tokenId) external {
        Sale storage sale = sales[tokenId];
        require(sale.state == SaleState.Created || sale.state == SaleState.Locked, "Sale cannot be canceled at this stage");
        require(msg.sender == sale.seller || msg.sender == sale.buyer || msg.sender == sale.broker, "Not a party to this sale");

        sale.state = SaleState.Canceled;

        // Return NFT to seller
        IERC721(sale.deedContractAddress).safeTransferFrom(address(this), sale.seller, sale.tokenId);
        
        // Refund buyer if funds were deposited
        if (sale.buyer != address(0)) {
            (bool success, ) = sale.buyer.call{value: sale.salePrice}("");
            require(success, "Refund failed");
        }

        emit SaleCanceled(tokenId);
    }
}
