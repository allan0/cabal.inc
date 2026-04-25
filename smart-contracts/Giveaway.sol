// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title Giveaway
 * @dev A contract to manage a trustless giveaway based on achieving a goal.
 * The creator locks a prize (ETH or ERC20) which can only be claimed by a winner
 * after the creator confirms the goal has been met.
 */
contract Giveaway is Ownable, ReentrancyGuard {
    enum PrizeType { ETH, ERC20 }
    enum GiveawayState { Open, Canceled, Complete }

    PrizeType public prizeType;
    IERC20 public prizeToken; // Address of the ERC20 token, if applicable
    uint256 public prizeAmount;
    uint256 public goalTarget; // e.g., number of referrals
    
    address public winner;
    GiveawayState public state;

    event GiveawayCreated(uint256 goal, uint256 amount, address token);
    event WinnerSet(address indexed winner);
    event PrizeClaimed(address indexed winner, uint256 amount);
    event GiveawayCanceled(address indexed owner, uint256 amount);

    constructor(
        uint256 _goalTarget,
        address _prizeTokenAddress,
        uint256 _prizeAmount
    ) payable Ownable(msg.sender) {
        require(_goalTarget > 0, "Goal must be greater than 0");
        require(_prizeAmount > 0 || msg.value > 0, "Prize amount must be set");

        goalTarget = _goalTarget;
        state = GiveawayState.Open;

        if (_prizeTokenAddress == address(0)) {
            // Prize is ETH
            require(msg.value > 0, "ETH prize requires sending ETH");
            prizeType = PrizeType.ETH;
            prizeAmount = msg.value;
        } else {
            // Prize is ERC20
            require(_prizeAmount > 0, "ERC20 prize requires an amount");
            prizeType = PrizeType.ERC20;
            prizeToken = IERC20(_prizeTokenAddress);
            prizeAmount = _prizeAmount;
            
            // The creator must have approved this contract to spend the prize tokens
            bool success = prizeToken.transferFrom(msg.sender, address(this), prizeAmount);
            require(success, "ERC20 transfer to escrow failed");
        }

        emit GiveawayCreated(_goalTarget, prizeAmount, _prizeTokenAddress);
    }

    /**
     * @dev Sets the winner of the giveaway. Can only be called by the owner
     * and only when the giveaway is in an Open state.
     * @param _winner The address of the user who won the giveaway.
     */
    function setWinner(address _winner) external onlyOwner {
        require(state == GiveawayState.Open, "Giveaway is not active");
        require(_winner != address(0), "Winner cannot be the zero address");
        winner = _winner;
        emit WinnerSet(_winner);
    }

    /**
     * @dev Allows the designated winner to claim their prize.
     */
    function claimPrize() external nonReentrant {
        require(state == GiveawayState.Open, "Giveaway is not active");
        require(msg.sender == winner, "You are not the designated winner");

        state = GiveawayState.Complete;

        if (prizeType == PrizeType.ETH) {
            (bool success, ) = winner.call{value: prizeAmount}("");
            require(success, "ETH prize transfer failed");
        } else {
            bool success = prizeToken.transfer(winner, prizeAmount);
            require(success, "ERC20 prize transfer failed");
        }
        
        emit PrizeClaimed(winner, prizeAmount);
    }

    /**
     * @dev Allows the creator to cancel the giveaway and reclaim the prize funds,
     * but only if a winner has NOT been set yet.
     */
    function cancelGiveaway() external onlyOwner nonReentrant {
        require(state == GiveawayState.Open, "Giveaway is not active");
        require(winner == address(0), "Cannot cancel after a winner has been set");
        
        state = GiveawayState.Canceled;
        
        if (prizeType == PrizeType.ETH) {
            (bool success, ) = owner().call{value: prizeAmount}("");
            require(success, "ETH prize reclaim failed");
        } else {
            bool success = prizeToken.transfer(owner(), prizeAmount);
            require(success, "ERC20 prize reclaim failed");
        }

        emit GiveawayCanceled(owner(), prizeAmount);
    }
}
