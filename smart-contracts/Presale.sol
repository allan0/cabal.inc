// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./CabalToken.sol";

/**
 * @title Presale
 * @dev A contract to manage the presale of CabalToken.
 */
contract Presale is Ownable {
    CabalToken public immutable cabalToken;
    uint256 public immutable rate; // How many token units a user gets per 1 wei
    uint256 public weiRaised;
    
    uint256 public constant PRESALE_CAP = 10_000_000 * 10**18; // e.g., 10M tokens for presale
    uint256 public tokensSold;

    mapping(address => bool) public isWhitelisted;
    mapping(address => uint256) public contributions;
    
    uint256 public constant MIN_CONTRIBUTION = 0.1 ether;
    uint256 public constant MAX_CONTRIBUTION = 5 ether;

    event TokensPurchased(address indexed purchaser, uint256 amountPaid, uint256 tokensReceived);

    constructor(uint256 _rate, address _cabalTokenAddress) Ownable(msg.sender) {
        require(_rate > 0, "Rate must be > 0");
        rate = _rate;
        cabalToken = CabalToken(_cabalTokenAddress);
    }

    /**
     * @dev Allows whitelisted users to buy tokens.
     */
    function buyTokens() external payable {
        require(isWhitelisted[msg.sender], "Not whitelisted");
        require(msg.value >= MIN_CONTRIBUTION, "Contribution below minimum");
        require(contributions[msg.sender] + msg.value <= MAX_CONTRIBUTION, "Exceeds max contribution");
        
        uint256 tokensToMint = msg.value * rate;
        require(tokensSold + tokensToMint <= PRESALE_CAP, "Presale cap reached");

        contributions[msg.sender] += msg.value;
        tokensSold += tokensToMint;
        weiRaised += msg.value;

        // Instead of this contract holding tokens, it requests the token contract to mint them.
        // The CabalToken owner must be this presale contract's address.
        cabalToken.mint(msg.sender, tokensToMint);

        emit TokensPurchased(msg.sender, msg.value, tokensToMint);
    }

    function addToWhitelist(address[] calldata accounts) external onlyOwner {
        for (uint i = 0; i < accounts.length; i++) {
            isWhitelisted[accounts[i]] = true;
        }
    }

    function removeFromWhitelist(address account) external onlyOwner {
        isWhitelisted[account] = false;
    }

    /**
     * @dev Allows the owner to withdraw the raised funds (ETH).
     */
    function withdraw() external onlyOwner {
        (bool success, ) = owner().call{value: address(this).balance}("");
        require(success, "Withdrawal failed");
    }
}
