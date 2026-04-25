// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./CabalToken.sol";

/**
 * @title CabalTGE
 * @dev Manages the Token Generation Event and vesting schedules for the Cabal platform.
 * This contract will be the owner of the CabalToken contract to control all minting.
 */
contract CabalTGE is Ownable {
    CabalToken public immutable cabalToken;

    struct VestingSchedule {
        uint256 totalAmount;   // Total amount to be vested for the beneficiary
        uint256 releasedAmount; // Amount already claimed by the beneficiary
        uint64 cliffTimestamp;  // Timestamp after which vesting begins (in seconds)
        uint64 startTimestamp;  // The official start of the vesting period (usually same as cliff)
        uint64 durationSeconds; // Total duration of the vesting period in seconds
    }

    mapping(address => VestingSchedule) public vestingSchedules;

    // Tokenomics based on your project's allocation
    uint256 public constant COMMUNITY_ALLOCATION = 60_000_000 * 10**18; // 60%
    uint256 public constant PARTNERS_ALLOCATION = 15_000_000 * 10**18;  // 15%
    uint256 public constant INVESTORS_ALLOCATION = 15_000_000 * 10**18; // 15%
    uint256 public constant TEAM_ALLOCATION = 10_000_000 * 10**18;     // 10%

    uint256 public communityTokensMinted;
    uint256 public partnerTokensAllocated;
    uint256 public investorTokensAllocated;
    uint256 public teamTokensAllocated;

    event VestingScheduleCreated(address indexed beneficiary, uint256 totalAmount, uint64 cliffTimestamp, uint64 durationSeconds);
    event TokensClaimed(address indexed beneficiary, uint256 amount);
    event CommunityTokensMinted(address indexed to, uint256 amount);

    constructor(address _cabalTokenAddress) Ownable(msg.sender) {
        cabalToken = CabalToken(_cabalTokenAddress);
    }

    /**
     * @dev Sets vesting schedule for team members.
     * Team: 9-month cliff, then linear vesting over 24 months.
     */
    function createTeamVesting(address beneficiary, uint256 totalAmount) public onlyOwner {
        require(teamTokensAllocated + totalAmount <= TEAM_ALLOCATION, "Team allocation exceeded");
        teamTokensAllocated += totalAmount;
        _createVestingSchedule(beneficiary, totalAmount, 9 * 30 days, 24 * 30 days);
    }
    
    /**
     * @dev Sets vesting schedule for investors.
     * Example: 6-month cliff, then linear vesting over 18 months.
     */
    function createInvestorVesting(address beneficiary, uint256 totalAmount) public onlyOwner {
        require(investorTokensAllocated + totalAmount <= INVESTORS_ALLOCATION, "Investor allocation exceeded");
        investorTokensAllocated += totalAmount;
        _createVestingSchedule(beneficiary, totalAmount, 6 * 30 days, 18 * 30 days);
    }

    /**
     * @dev Internal function to create and store a vesting schedule.
     */
    function _createVestingSchedule(
        address beneficiary,
        uint256 totalAmount,
        uint64 cliffDuration,
        uint64 vestingDuration
    ) private {
        require(vestingSchedules[beneficiary].totalAmount == 0, "Schedule already exists");
        
        uint64 currentTime = uint64(block.timestamp);
        uint64 cliffTimestamp = currentTime + cliffDuration;
        vestingSchedules[beneficiary] = VestingSchedule({
            totalAmount: totalAmount,
            releasedAmount: 0,
            cliffTimestamp: cliffTimestamp,
            startTimestamp: cliffTimestamp, // Vesting starts after the cliff
            durationSeconds: vestingDuration
        });
        emit VestingScheduleCreated(beneficiary, totalAmount, cliffTimestamp, vestingDuration);
    }

    /**
     * @dev Allows a beneficiary to claim their vested tokens.
     */
    function claimVestedTokens() public {
        VestingSchedule storage schedule = vestingSchedules[msg.sender];
        require(schedule.totalAmount > 0, "No vesting schedule for this address");

        uint256 vestedAmount = _getVestedAmount(msg.sender);
        uint256 claimableAmount = vestedAmount - schedule.releasedAmount;

        require(claimableAmount > 0, "No tokens to claim at this time");

        schedule.releasedAmount += claimableAmount;
        cabalToken.mint(msg.sender, claimableAmount);
        emit TokensClaimed(msg.sender, claimableAmount);
    }
    
    /**
     * @dev Mints tokens from the community allocation for quest rewards, airdrops, etc.
     * Restricted to the contract owner (your backend/admin wallet).
     */
    function mintCommunityTokens(address to, uint256 amount) public onlyOwner {
        require(communityTokensMinted + amount <= COMMUNITY_ALLOCATION, "Community allocation exceeded");
        communityTokensMinted += amount;
        cabalToken.mint(to, amount);
        emit CommunityTokensMinted(to, amount);
    }

    /**
     * @dev Public view function to check how many tokens a beneficiary can claim right now.
     */
    function getClaimableAmount(address beneficiary) public view returns (uint256) {
        VestingSchedule memory schedule = vestingSchedules[beneficiary];
        if (schedule.totalAmount == 0) return 0;
        uint256 vestedAmount = _getVestedAmount(beneficiary);
        return vestedAmount - schedule.releasedAmount;
    }

    /**
     * @dev Internal pure function to calculate the total vested amount for a beneficiary at the current time.
     */
    function _getVestedAmount(address beneficiary) internal view returns (uint256) {
        VestingSchedule memory schedule = vestingSchedules[beneficiary];
        uint64 currentTime = uint64(block.timestamp);

        if (currentTime < schedule.cliffTimestamp) {
            return 0; // No tokens vested before the cliff
        }
        if (currentTime >= schedule.startTimestamp + schedule.durationSeconds) {
            return schedule.totalAmount; // All tokens vested after the duration
        }

        // Calculate vested amount during the linear vesting period
        uint256 timeElapsed = currentTime - schedule.startTimestamp;
        return (schedule.totalAmount * timeElapsed) / schedule.durationSeconds;
    }
}
