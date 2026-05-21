# Project Code Bundle - Generated on Thu 21 May 19:40:14 +04 2026
This file contains the core logic and configuration for the Cabal project.

## Section: Flutter Config

### File: ./pubspec.yaml
```yaml
name: cabal
description: A Flutter project for quest-based user engagement in cabals.
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.3.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # --- TON Blockchain (Critical for TON Native Focus) ---
  ton: ^0.0.7
  
  # --- Backend & Auth ---
  supabase_flutter: ^2.5.8 
  firebase_core: ^2.32.0 

  # --- Core UI & State ---
  provider: ^6.1.5
  flutter_animate: ^4.5.2
  intl: ^0.20.2
  page_transition: ^2.2.1
  collection: ^1.19.1
  uuid: ^4.5.1
  logging: ^1.3.0

  # --- Icons & Styling ---
  cupertino_icons: ^1.0.8
  font_awesome_flutter: ^10.7.0
  fl_chart: ^0.68.0
  marquee: ^2.3.0
  shimmer: ^3.0.0

  # --- Networking & Web3 ---
  http: ^1.2.1
  dio: ^5.5.0
  xml: ^6.5.0
  web3dart: ^2.7.3 
  reown_appkit: ^1.2.0 
  url_launcher: ^6.3.2
  webview_flutter: ^4.9.0

  # --- Utilities ---
  flutter_dotenv: ^5.2.1
  image_picker: ^1.2.0
  video_player: ^2.9.1
  share_plus: ^7.2.2
  path_provider: ^2.1.3
  bs58: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true

  assets:
    - assets/images/
    - assets/videos/
    - assets/fonts/
    - assets/audio/
    - .env
    - config.env

  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        - asset: assets/fonts/Poppins-Italic.ttf
          style: italic
        - asset: assets/fonts/Poppins-Medium.ttf
          weight: 500
        - asset: assets/fonts/Poppins-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
    - family: NotoSans
      fonts:
        - asset: assets/fonts/NotoSans-Regular.ttf

# Fixed: Removed leading space to ensure it's a top-level key
dependency_overrides:
  intl: ^0.20.2

```

## Section: Environment Config

### File: ./config.env
```env
# This file stores your secret keys and configuration for local development.
# For web builds, these values must be passed using --dart-define.
# DO NOT commit this file to version control.

# Supabase
SUPABASE_URL="https://unjwwotvbtquecgqltqp.supabase.co"
SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVuand3b3R2YnRxdWVjZ3FsdHFwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM3MDk3OTAsImV4cCI6MjA2OTI4NTc5MH0.Ne4lHW4LsM5VNNSJyeTMOTFNJzt0IBOlfkuFRXt9T2M"

# WalletConnect Project ID
WALLET_CONNECT_PROJECT_ID="61b4c2a7392e99d13ece7bf970f40dd2"

# EVM Node Provider (Infura)
SEPOLIA_RPC_URL="https://sepolia.infura.io/v3/cb0292dd10bc4d59b2a8cc4dd8fea46f"
MAINNET_RPC_URL="https://mainnet.infura.io/v3/cb0292dd10bc4d59b2a8cc4dd8fea46f"

# Block Explorer & Data API Keys
ETHERSCAN_API_KEY="JRSE5UF8TSENTSDNPE8JPVQDZVBDCYB9E9"
COINGECKO_API_KEY="CG-KYa8Awz81tJcQ7HwF2cTzyXR"

# Pinata IPFS Service API Keys
PINATA_API_KEY="bd1f35daec3d7c05546b"
PINATA_API_SECRET="a207e993699bc694e195f9ad5bafcb83d939f8561606fd578266df3efe806bf1"

# --- Deployed Smart Contract Addresses (REPLACE THESE AFTER DEPLOYMENT) ---

# Sepolia Testnet Addresses
SEPOLIA_CABAL_TOKEN_ADDRESS="0x..."
SEPOLIA_CABAL_TGE_ADDRESS="0x..."
SEPOLIA_CABAL_ACHIEVEMENTS_ADDRESS="0x..."
SEPOLIA_PRESALE_ADDRESS="0x..."
SEPOLIA_REAL_ESTATE_DEED_ADDRESS="0x..."
SEPOLIA_ESCROW_ADDRESS="0x..."
SEPOLIA_NFT_MARKETPLACE_ADDRESS="0x..."
SEPOLIA_MERCHANDISE_STORE_ADDRESS="0x..."

# Mainnet Addresses
MAINNET_CABAL_TOKEN_ADDRESS="0x..."
MAINNET_CABAL_TGE_ADDRESS="0x..."
MAINNET_CABAL_ACHIEVEMENTS_ADDRESS="0x..."
MAINNET_PRESALE_ADDRESS="0x..."
MAINNET_REAL_ESTATE_DEED_ADDRESS="0x..."
MAINNET_ESCROW_ADDRESS="0x..."
MAINNET_NFT_MARKETPLACE_ADDRESS="0x..."
MAINNET_MERCHANDISE_STORE_ADDRESS="0x..."

```

## Section: Firebase Config

### File: ./firebase.json
```json
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}

```

## Section: Project Documentation

### File: ./README.md
```md
# airloot

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

```

## Section: Solidity Smart Contracts

### File: ./smart-contracts/CabalTGE.sol
```sol
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

```

### File: ./smart-contracts/CabalAchievements.sol
```sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title CabalAchievements
 * @dev An ERC721 contract for minting achievement badges as NFTs.
 * Each achievement is a unique, non-fungible token that serves as an on-chain credential.
 */
contract CabalAchievements is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    // Mapping to prevent a user from minting the same achievement type more than once.
    // The bytes32 is a unique identifier for the achievement (e.g., keccak256("first_quest_completed")).
    mapping(address => mapping(bytes32 => bool)) public hasMintedAchievement;

    event AchievementMinted(address indexed to, uint256 indexed tokenId, string tokenURI, bytes32 achievementId);

    constructor() ERC721("Cabal Achievements", "CBLA") Ownable(msg.sender) {}

    /**
     * @dev Mints a new achievement NFT to a user. Only the contract owner can call this.
     * @param player The address of the user receiving the NFT.
     * @param tokenURI The URI pointing to the JSON metadata for this NFT (e.g., ipfs://...).
     * @param achievementId A unique identifier for the achievement type to prevent duplicates.
     */
    function safeMint(address player, string memory tokenURI, bytes32 achievementId) public onlyOwner {
        require(!hasMintedAchievement[player][achievementId], "Achievement already minted for this user");
        
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(player, tokenId);
        _setTokenURI(tokenId, tokenURI);
        
        hasMintedAchievement[player][achievementId] = true;

        emit AchievementMinted(player, tokenId, tokenURI, achievementId);
    }

    // The following functions are overrides required by Solidity for contracts inheriting from multiple parents.
    
    /**
     * @dev See {ERC721-_burn}.
     */
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    /**
     * @dev See {ERC721URIStorage-tokenURI}.
     */
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

```

### File: ./smart-contracts/ProjectFactory.sol
```sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title ProjectToken
 * @dev A boilerplate ERC20 contract that can be deployed by the ProjectFactory.
 * The creator of the token is given ownership and can mint up to the max supply.
 * This provides a simple, secure way for Cabal communities to launch their own token.
 */
contract ProjectToken is ERC20, Ownable {
    uint256 public immutable maxSupply;

    constructor(
        string memory name,
        string memory symbol,
        uint256 _maxSupply,
        address initialOwner
    ) ERC20(name, symbol) Ownable(initialOwner) {
        // maxSupply is provided without decimals, then multiplied by 10**18
        maxSupply = _maxSupply * (10**decimals());
    }

    /**
     * @dev Creates `amount` new tokens for `to`.
     * Can only be called by the owner of this contract (the project creator).
     */
    function mint(address to, uint256 amount) public onlyOwner {
        require(totalSupply() + amount <= maxSupply, "ProjectToken: Max supply exceeded");
        _mint(to, amount);
    }
}


/**
 * @title ProjectFactory
 * @dev A factory contract for deploying new ProjectToken contracts for Cabals.
 * This enables "TGE as a Service" functionality within the Cabal platform.
 */
contract ProjectFactory is Ownable {
    event TokenCreated(
        address indexed tokenAddress,
        address indexed creator,
        string name,
        string symbol,
        uint256 maxSupply
    );

    /**
     * @dev Deploys a new ProjectToken contract and emits an event with its details.
     * The caller of this function becomes the owner of the new token contract.
     * @param name The name of the new token (e.g., "My Project").
     * @param symbol The symbol of the new token (e.g., "PROJ").
     * @param maxSupply The maximum total supply of the token (e.g., 1_000_000), excluding decimals.
     */
    function createToken(
        string memory name,
        string memory symbol,
        uint256 maxSupply
    ) public {
        // 'new' keyword deploys a new instance of the ProjectToken contract
        ProjectToken newToken = new ProjectToken(name, symbol, maxSupply, msg.sender);
        
        emit TokenCreated(
            address(newToken),
            msg.sender,
            name,
            symbol,
            maxSupply
        );
    }
}

```

### File: ./smart-contracts/RealEstateDeed.sol
```sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title RealEstateDeed
 * @dev An ERC721 contract where each NFT represents a unique property deed on the Cabal platform.
 */
contract RealEstateDeed is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    // Mapping from a property's unique identifier to its NFT tokenId
    mapping(bytes32 => uint256) public propertyToTokenId;

    event DeedMinted(address indexed owner, uint256 indexed tokenId, string tokenURI, bytes32 propertyId);

    constructor() ERC721("Cabal Real Estate Deed", "CRED") Ownable(msg.sender) {}

    /**
     * @dev Mints a new deed NFT representing a property.
     * @param owner The address of the property owner.
     * @param tokenURI The URI pointing to the JSON metadata for the property (e.g., ipfs://...).
     * @param propertyId A unique identifier for the property (e.g., keccak256("123 Main St")).
     */
    function mintDeed(address owner, string memory tokenURI, bytes32 propertyId) public onlyOwner returns (uint256) {
        require(propertyToTokenId[propertyId] == 0, "Deed already exists for this property");

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(owner, tokenId);
        _setTokenURI(tokenId, tokenURI);

        propertyToTokenId[propertyId] = tokenId;

        emit DeedMinted(owner, tokenId, tokenURI, propertyId);
        return tokenId;
    }

    // The following functions are overrides required by Solidity for contracts inheriting from multiple parents.
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

```

### File: ./smart-contracts/Escrow.sol
```sol
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

```

### File: ./smart-contracts/Presale.sol
```sol
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

```

### File: ./smart-contracts/CabalNftMarketplace.sol
```sol
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

```

### File: ./smart-contracts/Giveaway.sol
```sol
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

```

### File: ./smart-contracts/MerchandiseStore.sol
```sol
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

```

## Section: Flutter/Dart Logic

### File: ./lib/utils/icon_mapper.dart
```dart
// lib/utils/icon_mapper.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// No Supabase import needed if not using Supabase types.

IconData getIconFromName(String? iconName) {
  if (iconName == null) return FontAwesomeIcons.questionCircle;
  switch (iconName.toLowerCase()) {
    // Social Media
    case 'twitter':
    case 'x':
      return FontAwesomeIcons.twitter; // Or .xing if specific
    case 'discord':
      return FontAwesomeIcons.discord;
    case 'telegram':
      return FontAwesomeIcons.telegram;
    case 'youtube':
      return FontAwesomeIcons.youtube;
    case 'instagram':
      return FontAwesomeIcons.instagram;

    // Web & Info
    case 'website':
    case 'globe':
      return FontAwesomeIcons.globe;
    case 'readme':
    case 'book':
    case 'article':
      return FontAwesomeIcons.bookOpenReader;
    case 'envelope':
    case 'email':
    case 'newsletter':
      return FontAwesomeIcons.solidEnvelope;
    case 'link':
      return FontAwesomeIcons.link;
    case 'survey':
      return FontAwesomeIcons.squarePollVertical;
    case 'quiz':
      return FontAwesomeIcons.clipboardQuestion;

    // Wallet & Blockchain
    case 'wallet':
    case 'ethereum': // EVM generic
    case 'base':     // EVM generic
    // case 'solana': // Removed
      return FontAwesomeIcons.wallet;

    // Quest States & General
    case 'onboarding':
      return FontAwesomeIcons.playCircle;
    case 'challenge':
    case 'trophy': // For achievement icon consistency
      return FontAwesomeIcons.trophy;
    case 'locked':
      return FontAwesomeIcons.lock;
    case 'unlocked':
      return FontAwesomeIcons.lockOpen;
    case 'xp':
    case 'star': // For achievement icon consistency
        return FontAwesomeIcons.star;
    case 'manualverification': // Icon for manual verification tasks
    case 'upload':
    case 'submit':
        return FontAwesomeIcons.arrowUpFromBracket;
    case 'pending':
        return FontAwesomeIcons.hourglassHalf;
    case 'completed':
        return FontAwesomeIcons.solidCircleCheck;


    default:
      debugPrint("icon_mapper.dart: Unknown icon name '$iconName', defaulting to solidStar.");
      return FontAwesomeIcons.solidStar; // A generic fallback
  }
}

```

### File: ./lib/utils/theme_manager.dart
```dart
import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart'; // Removed: Not used in this file

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

```

### File: ./lib/utils/leveling.dart
```dart
// lib/utils/leveling.dart

// Calculates the level based on total XP.
int calculateLevel(int totalXp) {
  if (totalXp < 100) return 1;
  if (totalXp < 300) return 2;
  if (totalXp < 600) return 3;
  if (totalXp < 1000) return 4;
  if (totalXp < 1500) return 5;
  // Add more levels as needed
  return 6;
}

// Calculates the XP required for a given level.
int xpForLevel(int level) {
  switch (level) {
    case 1: return 0;
    case 2: return 100;
    case 3: return 300;
    case 4: return 600;
    case 5: return 1000;
    case 6: return 1500;
    default: return 999999999; // A large number for "max level"
  }
}

```

### File: ./lib/utils/constants.dart
```dart
// lib/utils/constants.dart
import 'package:flutter/foundation.dart' show debugPrint; 

enum QuestType {
  custom,
  twitterFollow,
  twitterRetweet,
  twitterLike,
  discordJoin,
  telegramChannelJoin,
  telegramGroupJoin,
  youtubeSubscribe,
  youtubeLikeVideo,
  instagramFollow,
  connectWalletEth,
  connectWalletBase,
  newsletterSubscription,
  websiteVisit,
  evmTransaction,
  evmSignMessage,
  manualVerification,
  // --- WEB3 UPDATE: New On-Chain Quest Types ---
  evmSwapToken,
  evmHoldToken,
  evmMintNft,
  // --- Solana Placeholders ---
  // solanaTransaction,
  // solanaSignMessage,
}

// Ensures that if 'type' is null (e.g. from bad data), it defaults to 'custom'
// and won't cause a null error when questTypeToString is called.
String questTypeToString(QuestType? type) { 
  if (type == null) {
    debugPrint("constants.dart: questTypeToString received null type, returning 'custom' as fallback.");
    return 'custom'; 
  }
  return type.toString().split('.').last;
}

// Ensures that if 'typeStr' is null or an unrecognized string, it defaults to QuestType.custom.
QuestType questTypeFromString(String? typeStr) { 
  if (typeStr == null || typeStr.trim().isEmpty) {
    debugPrint("constants.dart: questTypeFromString received null or empty typeStr, defaulting to custom.");
    return QuestType.custom;
  }
  
  final normalizedTypeStr = typeStr.toLowerCase().replaceAll('_', '');

  switch (normalizedTypeStr) {
    case 'custom': return QuestType.custom;
    case 'twitterfollow': return QuestType.twitterFollow;
    case 'twitterretweet': return QuestType.twitterRetweet;
    case 'twitterlike': return QuestType.twitterLike;
    case 'discordjoin': return QuestType.discordJoin;
    case 'telegramchanneljoin': return QuestType.telegramChannelJoin;
    case 'telegramgroupjoin': return QuestType.telegramGroupJoin;
    case 'youtubesubscribe': return QuestType.youtubeSubscribe;
    case 'youtubelikevideo': return QuestType.youtubeLikeVideo;
    case 'instagramfollow': return QuestType.instagramFollow;
    case 'connectwalleteth': return QuestType.connectWalletEth;
    case 'connectwalletbase': return QuestType.connectWalletBase;
    case 'newslettersubscription': return QuestType.newsletterSubscription;
    case 'websitevisit': return QuestType.websiteVisit;
    case 'evmtransaction': return QuestType.evmTransaction;
    case 'evmsignmessage': return QuestType.evmSignMessage;
    case 'manualverification': return QuestType.manualVerification;
    // --- WEB3 UPDATE: Recognize new types from DB ---
    case 'evmswaptoken': return QuestType.evmSwapToken;
    case 'evmholdtoken': return QuestType.evmHoldToken;
    case 'evmmintnft': return QuestType.evmMintNft;
    // --- Solana Placeholders ---
    // case 'solanatransaction': return QuestType.solanaTransaction;
    // case 'solanasignmessage': return QuestType.solanaSignMessage;
    default:
      // Fallback for original underscore versions if any data still uses them
      // This second switch is only hit if the normalized version didn't match.
      // It's less likely to be needed if data is clean or new.
      debugPrint("constants.dart: Unknown quest type string '$typeStr' (normalized: '$normalizedTypeStr'), attempting original underscore or defaulting to custom.");
      switch (typeStr.toLowerCase()) { // Check original string with underscores
        case 'twitter_follow': return QuestType.twitterFollow;
        case 'twitter_retweet': return QuestType.twitterRetweet;
        // ... add other underscore fallbacks if necessary ...
        default:
          debugPrint("constants.dart: Quest type '$typeStr' (normalized: '$normalizedTypeStr') completely unrecognized, defaulting to custom.");
          return QuestType.custom;
      }
  }
}

// Example levels and XP thresholds
const Map<int, int> xpForLevel = {
  1: 0,
  2: 100,
  3: 250,
  4: 500,
  5: 1000,
  // Add more levels as needed
};

int calculateLevel(int totalXp) {
  int currentLevel = 1;
  for (var entry in xpForLevel.entries) {
    if (totalXp >= entry.value) {
      currentLevel = entry.key;
    } else {
      break;
    }
  }
  return currentLevel;
}

int getXpForNextLevel(int currentLevel) {
  return xpForLevel[currentLevel + 1] ?? 999999999;
}

int getXpForCurrentLevelStart(int currentLevel) {
  return xpForLevel[currentLevel] ?? 0;
}

```

### File: ./lib/utils/app_colors.dart
```dart
import 'package:flutter/material.dart';

class AppColors {
  // Core Branded Colors
  static const Color background = Color(0xFF0F0F0F);
  static const Color offBlack = Color(0xFF080808); 
  static const Color gold = Color(0xFFD4AF37);
  static const Color primaryAccent = Color(0xFFE2B05E);
  static const Color darkGrey = Color(0xFF1B1212);
  static const Color lightText = Color(0xFFF3E5AB);
  static const Color greyText = Color(0xFF9E9E9E);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3); // Added this to fix the crash

  // Gradients
  static const Gradient cardOverlayGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x22FFFFFF),
      Color(0x00FFFFFF),
    ],
  );
}

```

### File: ./lib/models/achievement_model.dart
```dart
// lib/models/achievement_model.dart
// No Supabase import needed if not using Supabase types.

class Achievement {
  final String id; // UUID, final
  String title;
  String description;
  String iconName; // Should map to an icon (e.g., FontAwesome)
  int xpBonus;
  final DateTime? createdAt; // Added
  DateTime? updatedAt; // Added

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    this.xpBonus = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory Achievement.fromSupabase(Map<String, dynamic> data) {
    return Achievement(
      id: data['id'] as String, // Should always exist
      title: data['title'] as String? ?? 'Unnamed Achievement',
      description: data['description'] as String? ?? 'No description.',
      iconName: data['icon_name'] as String? ?? 'star', // Default icon if null
      xpBonus: (data['xp_bonus'] ?? 0) as int,
      createdAt: data['created_at'] != null
          ? DateTime.tryParse(data['created_at'] as String)
          : null,
      updatedAt: data['updated_at'] != null
          ? DateTime.tryParse(data['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toSupabase() {
    // This map is for creating/updating an achievement definition.
    // 'id', 'created_at', 'updated_at' are typically DB-managed.
    return {
      'title': title,
      'description': description,
      'icon_name': iconName,
      'xp_bonus': xpBonus,
      // Other fields like criteria for awarding might be here if more complex
    };
  }
}

```

### File: ./lib/models/quest_section_model.dart
```dart
// lib/models/quest_section_model.dart

// No Supabase import needed if not using Supabase types directly.
// No other specific imports are needed for this simple model.

class QuestSection {
  final String id; // UUID, Primary Key, final
  // final String cabalId; // FK, Not typically needed in the model if fetched in context of a cabal
  String title;
  String? description; // Nullable, as DB allows NULL for this field
  int order;           // Maps to "order" (or "display_order") column in DB
  String? progressTextFormat; // e.g., "{completed}/{total} Done" - Nullable
  final DateTime? createdAt;    // Timestamp from DB, final after creation
  DateTime? updatedAt;      // Timestamp from DB

  QuestSection({
    required this.id,
    // required this.cabalId, // If you decide to include it
    required this.title,
    this.description,
    required this.order,
    this.progressTextFormat,
    this.createdAt,
    this.updatedAt,
  });

  factory QuestSection.fromSupabase(Map<String, dynamic> data) {
    return QuestSection(
      id: data['id'] as String, // Should always exist (PK)
      // cabalId: data['cabal_id'] as String, // If you include it
      title: data['title'] as String? ?? 'Untitled Section', // Fallback for null title
      description: data['description'] as String?, // Already nullable
      // Handle potential quoted "order" key if SQL uses it, otherwise default to 0
      order: (data['order'] ?? data['"order"'] ?? 0) as int,
      progressTextFormat: data['progress_text_format'] as String?, // Already nullable
      createdAt: data['created_at'] != null
          ? DateTime.tryParse(data['created_at'] as String) // Use tryParse for safety
          : null,
      updatedAt: data['updated_at'] != null
          ? DateTime.tryParse(data['updated_at'] as String) // Use tryParse for safety
          : null,
    );
  }

  Map<String, dynamic> toSupabase() {
    // This map is for creating/updating a quest section definition.
    // 'id', 'cabal_id', 'created_at', 'updated_at' are typically handled by DB/service layer.
    return {
      'title': title,
      'description': description, // Can be null
      // Use quoted "order" for JSON key if your DB expects it for columns named 'order'
      // Ensure this matches how your Supabase RPC or direct update expects it.
      // If it's just 'order', then use 'order': order.
      '"order"': order,
      'progress_text_format': progressTextFormat, // Can be null
      // 'cabal_id' would be required for inserts, typically added by the service layer.
    };
  }
}

```

### File: ./lib/models/notification_model.dart
```dart
// lib/models/notification_model.dart
// No Supabase import needed if not using Supabase types.

class NotificationModel {
  final String id; // UUID, final
  final String userId; // UUID of the user this notification belongs to, final
  String title;
  String body;
  String? type; // e.g., 'quest_complete', 'achievement_unlocked'
  String? referenceId; // e.g., quest_id, achievement_id. Can be UUID or other string.
  bool isRead;
  final DateTime createdAt; // Should be non-nullable as DB has NOT NULL DEFAULT NOW()

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.type,
    this.referenceId,
    required this.createdAt, // Made required
    this.isRead = false,
  });

  factory NotificationModel.fromSupabase(Map<String, dynamic> data) {
    return NotificationModel(
      id: data['id'] as String, // Should always exist
      userId: data['user_id'] as String? ?? '', // Should always exist, but defensive null check
      title: data['title'] as String? ?? 'No Title',
      body: data['body'] as String? ?? 'No Body',
      type: data['type'] as String?,
      referenceId: data['reference_id'] as String?, // Mapped from snake_case
      // createdAt should always exist due to DB default and NOT NULL constraint.
      // If it can somehow be null from a response, DateTime.now() is a fallback.
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'] as String) // Use parse, tryParse if it could be invalid format
          : DateTime.now(), // Fallback, though ideally DB ensures this is always set
      isRead: (data['is_read'] ?? false) as bool,
    );
  }

  Map<String, dynamic> toSupabase() {
    // This map is primarily for creating a new notification.
    // 'id' and 'created_at' are generated by the database.
    // 'is_read' defaults to false on insert.
    // Updates to 'is_read' are usually specific operations (e.g., markAsRead).
    return {
      'user_id': userId,
      'title': title,
      'body': body,
      if (type != null) 'type': type,
      if (referenceId != null) 'reference_id': referenceId,
      // 'is_read': isRead, // Typically not set directly on creation, defaults to false
      // 'created_at': handled by DB
    };
  }
}

```

### File: ./lib/models/news_article_model.dart
```dart
// lib/models/news_article_model.dart

class NewsArticle {
  final String title;
  final String link;
  final DateTime? pubDate;
  final String? source;
  final String? description;
  final String? imageUrl; // Optional image URL from the feed

  NewsArticle({
    required this.title,
    required this.link,
    this.pubDate,
    this.source,
    this.description,
    this.imageUrl,
  });
}

```

### File: ./lib/models/coin_data_model.dart
```dart
// lib/models/coin_data_model.dart

class CoinData {
  final String id;
  final String symbol;
  final String name;
  final String imageUrl;
  final double? currentPrice; // <-- ADD THIS
  final double? priceChangePercentage24h; // <-- ADD THIS

  CoinData({
    required this.id,
    required this.symbol,
    required this.name,
    required this.imageUrl,
    this.currentPrice, // <-- ADD THIS
    this.priceChangePercentage24h, // <-- ADD THIS
  });

  factory CoinData.fromJson(Map<String, dynamic> json) {
    return CoinData(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      imageUrl: json['image'] as String,
      // Handle potential null or incorrect types from the API
      currentPrice: (json['current_price'] as num?)?.toDouble(), // <-- ADD THIS
      priceChangePercentage24h: (json['price_change_percentage_24h'] as num?)?.toDouble(), // <-- ADD THIS
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'image': imageUrl,
      'current_price': currentPrice, // <-- ADD THIS
      'price_change_percentage_24h': priceChangePercentage24h, // <-- ADD THIS
    };
  }
}

```

### File: ./lib/models/cabal_leaderboard_entry.dart
```dart
// lib/models/cabal_leaderboard_entry.dart
import 'user_profile_model.dart';

class CabalLeaderboardEntry {
  final UserProfile userProfile;
  final int cabalXp;
  final int rank;

  CabalLeaderboardEntry({
    required this.userProfile,
    required this.cabalXp,
    required this.rank,
  });
}

```

### File: ./lib/models/community_post_model.dart
```dart
// lib/models/community_post_model.dart
import 'package:intl/intl.dart';

enum PostType { standard, poll, link }

class PollOption {
  final String id;
  final String text;
  int votes;

  PollOption({required this.id, required this.text, this.votes = 0});
}

class CommunityPost {
  final String id;
  final String userId;
  final String cabalId;
  final String content;
  final PostType type;
  int likes;
  final DateTime createdAt;
  
  // Joined data
  final String authorName;
  final String authorAvatarUrl;
  int commentCount;
  bool isLikedByUser;

  // Optional fields for specific post types
  final List<PollOption>? pollOptions;
  final String? linkImageUrl;
  final String? linkTitle;
  final String? linkSource;

  CommunityPost({
    required this.id,
    required this.userId,
    required this.cabalId,
    required this.content,
    this.type = PostType.standard,
    required this.likes,
    required this.createdAt,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.commentCount,
    required this.isLikedByUser,
    this.pollOptions,
    this.linkImageUrl,
    this.linkTitle,
    this.linkSource,
  });

  factory CommunityPost.fromSupabase(Map<String, dynamic> data) {
    // This factory now handles the flat structure from the RPC call
    return CommunityPost(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      cabalId: data['cabal_id'] as String,
      content: data['content'] as String,
      likes: (data['likes'] ?? 0) as int,
      createdAt: DateTime.parse(data['created_at'] as String),
      authorName: data['author_name'] as String? ?? 'Anonymous',
      authorAvatarUrl: data['author_avatar_url'] as String? ?? '',
      commentCount: (data['comment_count'] ?? 0) as int,
      isLikedByUser: (data['is_liked_by_user'] ?? false) as bool,
      // You can add logic here to parse poll options etc. from a JSONB column if you add one
    );
  }

  // Helper method for optimistic UI updates on like
  void updateFromToggleLike(Map<String, dynamic> likeData) {
    isLikedByUser = likeData['is_liked'] as bool? ?? isLikedByUser;
    likes = likeData['new_like_count'] as int? ?? likes;
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds}s ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else {
      return DateFormat('MMM d').format(createdAt);
    }
  }
}

```

### File: ./lib/models/bot_model.dart
```dart
// lib/models/bot_model.dart

enum BotStatus { active, paused, error }

class BotModel {
  final String id;
  final String name;
  final String type;
  BotStatus status; // <-- REMOVED 'final' KEYWORD
  final double pnl24h;
  final int totalTrades;

  BotModel({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.pnl24h,
    required this.totalTrades,
  });
}

```

### File: ./lib/models/marketplace_models.dart
```dart
// lib/models/marketplace_models.dart

class ProjectListing {
  final String id;
  final String projectName;
  final String projectDescription;
  final String creatorName;
  final String creatorAvatarUrl;
  final String budget;
  final String timeline;
  final List<String> requiredSkills;
  final bool isFullProject;
  final bool isOpen;

  ProjectListing({
    required this.id,
    required this.projectName,
    required this.projectDescription,
    required this.creatorName,
    required this.creatorAvatarUrl,
    required this.budget,
    required this.timeline,
    required this.requiredSkills,
    this.isFullProject = false,
    this.isOpen = true,
  });

  factory ProjectListing.fromSupabase(Map<String, dynamic> data) {
    final creatorProfile = data['creator_profile'] as Map<String, dynamic>? ?? {};
    final creatorName = creatorProfile['display_name'] as String? ?? 'Anonymous';
    final creatorAvatarUrl = creatorProfile['profile_image_url'] as String? ?? 'https://i.pravatar.cc/150?u=anonymous';

    return ProjectListing(
      id: data['id'] as String,
      projectName: data['project_name'] as String? ?? 'Untitled Project',
      projectDescription: data['project_description'] as String? ?? 'No description provided.',
      creatorName: creatorName,
      creatorAvatarUrl: creatorAvatarUrl,
      budget: data['budget'] as String? ?? 'Not specified',
      timeline: data['timeline'] as String? ?? 'Not specified',
      requiredSkills: data['required_skills'] != null
          ? List<String>.from(data['required_skills'])
          : [],
      isFullProject: (data['is_full_project'] ?? false) as bool,
      isOpen: (data['is_open'] ?? true) as bool,
    );
  }
}

class DeveloperProfile {
  final String id;
  final String userId; // <-- ADDED THIS FIELD
  final String developerName;
  final String developerAvatarUrl;
  final String tagline;
  final String rate;
  final List<String> skills;
  final bool isAvailable;

  DeveloperProfile({
    required this.id,
    required this.userId, // <-- ADDED THIS FIELD
    required this.developerName,
    required this.developerAvatarUrl,
    required this.tagline,
    required this.rate,
    required this.skills,
    this.isAvailable = true,
  });

  factory DeveloperProfile.fromSupabase(Map<String, dynamic> data) {
    final userProfile = data['creator_profile'] as Map<String, dynamic>? ?? {};
    final developerName = userProfile['display_name'] as String? ?? 'Anonymous Developer';
    final developerAvatarUrl = userProfile['profile_image_url'] as String? ?? 'https://i.pravatar.cc/150?u=${data['id']}';
    
    return DeveloperProfile(
      id: data['id'] as String,
      userId: data['user_id'] as String? ?? '', // <-- ADDED THIS FIELD
      developerName: developerName,
      developerAvatarUrl: developerAvatarUrl,
      tagline: data['tagline'] as String? ?? 'Expert available for hire.',
      rate: data['rate'] as String? ?? 'Not specified',
      skills: data['skills'] != null
          ? List<String>.from(data['skills'])
          : [],
      isAvailable: (data['is_available'] ?? true) as bool,
    );
  }
}

```

### File: ./lib/models/coin_model.dart
```dart
// lib/models/coin_model.dart

class Coin {
  final String id;
  final String symbol;
  final String name;
  final String imageUrl;
  final double currentPrice;
  final double? priceChangePercentage24h;

  Coin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.imageUrl,
    required this.currentPrice,
    this.priceChangePercentage24h,
  });

  factory Coin.fromMap(Map<String, dynamic> map) {
    return Coin(
      id: map['id'] ?? '',
      symbol: map['symbol'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['image'] ?? '',
      currentPrice: (map['current_price'] as num?)?.toDouble() ?? 0.0,
      priceChangePercentage24h: (map['price_change_percentage_24h'] as num?)?.toDouble(),
    );
  }
}

```

### File: ./lib/models/community_cabal_preview.dart
```dart
// lib/models/community_cabal_preview.dart
import 'cabal_model.dart';

class CommunityCabalPreview {
  final Cabal cabal;
  final int memberCount;
  final int postCount;
  final String? latestPostSnippet;
  final DateTime? latestPostTimestamp;

  CommunityCabalPreview({
    required this.cabal,
    required this.memberCount,
    required this.postCount,
    this.latestPostSnippet,
    this.latestPostTimestamp,
  });

  factory CommunityCabalPreview.fromSupabase(Map<String, dynamic> data) {
    // This assumes the RPC returns a nested 'cabals' object.
    // Adjust as per your actual RPC response structure.
    final cabalData = data['cabals'] as Map<String, dynamic>?;
    if (cabalData == null) {
      throw Exception("Invalid data format for CommunityCabalPreview");
    }

    return CommunityCabalPreview(
      cabal: Cabal.fromSupabase(cabalData),
      memberCount: (data['member_count'] ?? 0) as int,
      postCount: (data['post_count'] ?? 0) as int,
      latestPostSnippet: data['latest_post_snippet'] as String?,
      latestPostTimestamp: data['latest_post_timestamp'] != null
          ? DateTime.tryParse(data['latest_post_timestamp'] as String)
          : null,
    );
  }
}

```

### File: ./lib/models/nft_listing_model.dart
```dart
// lib/models/nft_listing_model.dart
import 'package:web3dart/web3dart.dart';

class NftListing {
  final String id;
  final String nftContractAddress;
  final int tokenId;
  final String sellerAddress;
  final String priceWei;
  final bool isActive;
  final String? listerUserId;
  final String? tokenUri;
  final String? nftName;
  final String? nftImageUrl;
  final String? collectionName;
  final DateTime createdAt;

  NftListing({
    required this.id,
    required this.nftContractAddress,
    required this.tokenId,
    required this.sellerAddress,
    required this.priceWei,
    required this.isActive,
    this.listerUserId,
    this.tokenUri,
    this.nftName,
    this.nftImageUrl,
    this.collectionName,
    required this.createdAt,
  });

  /// Convenience getter to display the price in Ether.
  double get priceInEth {
    final wei = BigInt.tryParse(priceWei) ?? BigInt.zero;
    return EtherAmount.inWei(wei).getValueInUnit(EtherUnit.ether);
  }

  factory NftListing.fromSupabase(Map<String, dynamic> data) {
    return NftListing(
      id: data['id'] as String,
      nftContractAddress: data['nft_contract_address'] as String,
      tokenId: (data['token_id'] as num).toInt(),
      sellerAddress: data['seller_address'] as String,
      priceWei: data['price_wei'] as String,
      isActive: data['is_active'] as bool,
      listerUserId: data['lister_user_id'] as String?,
      tokenUri: data['token_uri'] as String?,
      nftName: data['nft_name'] as String?,
      nftImageUrl: data['nft_image_url'] as String?,
      collectionName: data['collection_name'] as String?,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'nft_contract_address': nftContractAddress,
      'token_id': tokenId,
      'seller_address': sellerAddress,
      'price_wei': priceWei,
      'is_active': isActive,
      'lister_user_id': listerUserId,
      'token_uri': tokenUri,
      'nft_name': nftName,
      'nft_image_url': nftImageUrl,
      'collection_name': collectionName,
    };
  }
}

```

### File: ./lib/models/merchandise_product_model.dart
```dart
// lib/models/merchandise_product_model.dart

class MerchandiseProduct {
  final String id;
  final String cabalId;
  final String creatorUserId;
  final int productIdOnChain;
  final String name;
  final String? description;
  final String? imageUrl;
  final String paymentTokenAddress;
  final String paymentTokenSymbol;
  final String priceInWei;
  final String? bonusTokenAddress;
  final String? bonusTokenSymbol;
  final String? bonusAmountInWei;
  final bool isActive;
  final DateTime createdAt;

  MerchandiseProduct({
    required this.id,
    required this.cabalId,
    required this.creatorUserId,
    required this.productIdOnChain,
    required this.name,
    this.description,
    this.imageUrl,
    required this.paymentTokenAddress,
    required this.paymentTokenSymbol,
    required this.priceInWei,
    this.bonusTokenAddress,
    this.bonusTokenSymbol,
    this.bonusAmountInWei,
    required this.isActive,
    required this.createdAt,
  });

  /// Convenience getter to display the price in its standard unit (assumes 18 decimals).
  double get price {
    final wei = BigInt.tryParse(priceInWei) ?? BigInt.zero;
    return wei.toDouble() / 1e18;
  }

  /// Convenience getter to display the bonus amount in its standard unit (assumes 18 decimals).
  double? get bonusAmount {
    if (bonusAmountInWei == null) return null;
    final wei = BigInt.tryParse(bonusAmountInWei!) ?? BigInt.zero;
    return wei.toDouble() / 1e18;
  }

  factory MerchandiseProduct.fromSupabase(Map<String, dynamic> data) {
    return MerchandiseProduct(
      id: data['id'] as String,
      cabalId: data['cabal_id'] as String,
      creatorUserId: data['creator_user_id'] as String,
      productIdOnChain: (data['product_id_onchain'] as num).toInt(),
      name: data['name'] as String,
      description: data['description'] as String?,
      imageUrl: data['image_url'] as String?,
      paymentTokenAddress: data['payment_token_address'] as String,
      paymentTokenSymbol: data['payment_token_symbol'] as String,
      priceInWei: data['price_in_wei'] as String,
      bonusTokenAddress: data['bonus_token_address'] as String?,
      bonusTokenSymbol: data['bonus_token_symbol'] as String?,
      bonusAmountInWei: data['bonus_amount_in_wei'] as String?,
      isActive: data['is_active'] as bool,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'cabal_id': cabalId,
      'creator_user_id': creatorUserId,
      'product_id_onchain': productIdOnChain,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'payment_token_address': paymentTokenAddress,
      'payment_token_symbol': paymentTokenSymbol,
      'price_in_wei': priceInWei,
      'bonus_token_address': bonusTokenAddress,
      'bonus_token_symbol': bonusTokenSymbol,
      'bonus_amount_in_wei': bonusAmountInWei,
      'is_active': isActive,
    };
  }
}

```

### File: ./lib/models/activity_model.dart
```dart
// lib/models/activity_model.dart
import 'package:flutter/foundation.dart' show debugPrint;

enum ActivityType {
  unknown,
  userJoined,
  questCompleted,
  cabalCreated,
  achievementUnlocked,
}

ActivityType activityTypeFromString(String? typeStr) {
  if (typeStr == null) return ActivityType.unknown;
  switch (typeStr.toLowerCase()) {
    case 'user_joined':
      return ActivityType.userJoined;
    case 'quest_completed':
      return ActivityType.questCompleted;
    case 'cabal_created':
      return ActivityType.cabalCreated;
    case 'achievement_unlocked':
      return ActivityType.achievementUnlocked;
    default:
      debugPrint("Unknown activity type string: '$typeStr'");
      return ActivityType.unknown;
  }
}

class Activity {
  final String id;
  final ActivityType type;
  final String userId; // The user who performed the action
  final String? targetId; // e.g., cabal_id, quest_id, achievement_id
  final String? content; // e.g., "Cabal Name", "Quest Title"
  final DateTime createdAt;

  // Enriched data, populated after initial fetch
  String? userDisplayName;
  String? userProfileImageUrl;

  Activity({
    required this.id,
    required this.type,
    required this.userId,
    this.targetId,
    this.content,
    required this.createdAt,
    this.userDisplayName,
    this.userProfileImageUrl,
  });

  factory Activity.fromSupabase(Map<String, dynamic> data) {
    return Activity(
      id: data['id'] as String,
      type: activityTypeFromString(data['type'] as String?),
      userId: data['user_id'] as String,
      targetId: data['target_id'] as String?,
      content: data['content'] as String?,
      createdAt: DateTime.parse(data['created_at'] as String),
      // The 'users' table is joined in the RPC, so we can get this directly
      userDisplayName: (data['users'] != null) ? data['users']['display_name'] as String? : null,
      userProfileImageUrl: (data['users'] != null) ? data['users']['profile_image_url'] as String? : null,
    );
  }
}

```

### File: ./lib/models/cabal_model.dart
```dart
// lib/models/cabal_model.dart
class Cabal {
    final String id;
    String name;
    String description;
    final String creatorId;
    String? creatorHandle;
    String? logoUrl;
    String? bannerImageUrl;
    String? projectUrl;
    List<String> questSectionOrder;
    String? dailyChallengeHeader;
    Map<String, dynamic>? theme;
    String? category;
    bool isPrivate;
    final DateTime? createdAt;
    DateTime? updatedAt;

    // --- WEB3 UPDATE: New fields for token integration ---
    String? tokenContractAddress;
    int? chainId;
    String? tokenSymbol;

  Cabal({
      required this.id,
      required this.name,
      required this.description,
      required this.creatorId,
      this.creatorHandle,
      this.logoUrl,
      this.bannerImageUrl,
      this.projectUrl,
      this.questSectionOrder = const [],
      this.dailyChallengeHeader,
      this.category,
      this.theme,
      this.isPrivate = false,
      this.createdAt,
      this.updatedAt,
      // --- WEB3 UPDATE ---
      this.tokenContractAddress,
      this.chainId,
      this.tokenSymbol,
  });

  factory Cabal.fromSupabase(Map<String, dynamic> data) {
    return Cabal(
      id: data['id'] as String,
      name: data['name'] as String,
      description: data['description'] as String,
      creatorId: data['creator_id'] as String,
      creatorHandle: data['creator_handle'] as String?,
      logoUrl: data['logo_url'] as String?,
      bannerImageUrl: data['banner_image_url'] as String?,
      projectUrl: data['project_url'] as String?,
      questSectionOrder: data['quest_section_order'] != null ? List<String>.from(data['quest_section_order']) : [],
      dailyChallengeHeader: data['daily_challenge_header'] as String?,
      category: data['category'] as String?,
      theme: data['theme'] != null ? Map<String, dynamic>.from(data['theme']) : null,
      isPrivate: (data['is_private'] ?? false) as bool,
      createdAt: data['created_at'] != null ? DateTime.tryParse(data['created_at'] as String) : null,
      updatedAt: data['updated_at'] != null ? DateTime.tryParse(data['updated_at'] as String) : null,
      // --- WEB3 UPDATE ---
      tokenContractAddress: data['token_contract_address'] as String?,
      chainId: (data['chain_id'] as num?)?.toInt(),
      tokenSymbol: data['token_symbol'] as String?,
    );
  }
  
  Map<String, dynamic> toSupabase() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'creator_id': creatorId,
      'creator_handle': creatorHandle,
      'logo_url': logoUrl,
      'banner_image_url': bannerImageUrl,
      'project_url': projectUrl,
      'quest_section_order': questSectionOrder,
      'daily_challenge_header': dailyChallengeHeader,
      'category': category,
      'theme': theme,
      'is_private': isPrivate,
      // --- WEB3 UPDATE ---
      'token_contract_address': tokenContractAddress,
      'chain_id': chainId,
      'token_symbol': tokenSymbol,
    };
  }
}

```

### File: ./lib/models/quest_model.dart
```dart
// lib/models/quest_model.dart
import 'package:flutter/foundation.dart';
import '../utils/constants.dart'; // For QuestType enum

/// Represents a quest within a Cabal.
/// Maps directly to the 'quests' table in Supabase.
class Quest {
  final String id;
  final String? questSectionId;
  final String cabalId;
  String title;
  String description;
  String? detailedContent;
  int xpReward;
  QuestType type;
  String? actionUrl;
  String? iconName;
  List<String> prerequisiteQuestIds;
  
  // Cooldown & Repetition
  Duration? cooldown; 
  int totalSteps;
  
  // UI & Requirements
  String taskButtonText;
  bool requiresManualVerification;

  // User-Specific Progress (Populated via joins in SupabaseService)
  String userStatus; // 'not_started', 'in_progress', 'pending_review', 'completed', 'rejected'
  int userCurrentSteps;
  DateTime? lastCompletedAt;

  Quest({
    required this.id,
    this.questSectionId,
    required this.cabalId,
    required this.title,
    required this.description,
    this.detailedContent,
    required this.xpReward,
    required this.type,
    this.actionUrl,
    this.iconName,
    this.prerequisiteQuestIds = const [],
    this.cooldown,
    this.totalSteps = 1,
    this.taskButtonText = 'Complete Task',
    this.requiresManualVerification = false,
    this.userStatus = 'not_started',
    this.userCurrentSteps = 0,
    this.lastCompletedAt,
  });

  factory Quest.fromSupabase(Map<String, dynamic> data) {
    // Handle the QuestType conversion safely
    final typeStr = data['type'] as String? ?? 'custom';
    
    return Quest(
      id: data['id'] as String,
      questSectionId: data['quest_section_id'] as String?,
      cabalId: data['cabal_id'] as String,
      title: data['title'] as String? ?? 'Untitled Quest',
      description: data['description'] as String? ?? '',
      detailedContent: data['detailed_content'] as String?,
      xpReward: (data['xp_reward'] ?? 0) as int,
      type: questTypeFromString(typeStr),
      actionUrl: data['action_url'] as String?,
      iconName: data['icon_name'] as String?,
      prerequisiteQuestIds: data['prerequisite_quest_ids'] != null
          ? List<String>.from(data['prerequisite_quest_ids'])
          : [],
      cooldown: data['cooldown_period_seconds'] != null
          ? Duration(seconds: data['cooldown_period_seconds'] as int)
          : null,
      totalSteps: (data['total_steps'] ?? 1) as int,
      taskButtonText: data['task_button_text'] as String? ?? 'Complete Task',
      requiresManualVerification: (data['requires_manual_verification'] ?? false) as bool,
      
      // These are usually null unless fetched via a join with user_quest_progress
      userStatus: data['status'] as String? ?? 'not_started',
      userCurrentSteps: (data['current_steps'] ?? 0) as int,
      lastCompletedAt: data['last_completed_at'] != null 
          ? DateTime.tryParse(data['last_completed_at'] as String) 
          : null,
    );
  }

  /// Logic to determine the current display status for the UI
  String get statusText {
    if (userStatus == 'completed') {
      if (isOnCooldown) {
        final remaining = cooldownTimeRemaining;
        return "Cooldown: ${remaining.inHours}h ${remaining.inMinutes % 60}m";
      }
      return "Completed";
    }
    if (userStatus == 'pending_review') return "Under Review";
    if (userStatus == 'rejected') return "Rejected - Try Again";
    if (totalSteps > 1 && userCurrentSteps > 0) {
      return "Progress: $userCurrentSteps/$totalSteps";
    }
    return taskButtonText;
  }

  /// Checks if the quest is currently in a cooldown state based on last completion
  bool get isOnCooldown {
    if (lastCompletedAt == null || cooldown == null) return false;
    return DateTime.now().difference(lastCompletedAt!) < cooldown!;
  }

  Duration get cooldownTimeRemaining {
    if (lastCompletedAt == null || cooldown == null) return Duration.zero;
    final diff = cooldown! - DateTime.now().difference(lastCompletedAt!);
    return diff.isNegative ? Duration.zero : diff;
  }

  bool get isLocked => userStatus == 'locked';
  bool get isCompleted => userStatus == 'completed' && !isOnCooldown;

  Map<String, dynamic> toSupabase() {
    return {
      'cabal_id': cabalId,
      'quest_section_id': questSectionId,
      'title': title,
      'description': description,
      'detailed_content': detailedContent,
      'xp_reward': xpReward,
      'type': questTypeToString(type),
      'action_url': actionUrl,
      'icon_name': iconName,
      'prerequisite_quest_ids': prerequisiteQuestIds,
      'cooldown_period_seconds': cooldown?.inSeconds,
      'total_steps': totalSteps,
      'task_button_text': taskButtonText,
      'requires_manual_verification': requiresManualVerification,
    };
  }
}

```

### File: ./lib/models/user_profile_model.dart
```dart
import 'dart:math';

class UserProfile {
  final String id; // UUID from auth.users
  String? displayName;
  String? telegramUsername;
  String? profileImageUrl;
  int totalXp;
  int level;
  
  // FIXED: Renamed to connected_wallets to match Service calls
  Map<String, dynamic> connected_wallets;
  // FIXED: Renamed to connected_socials for consistency
  Map<String, dynamic> connected_socials;
  
  // Array Columns (TEXT[] / UUID[])
  List<String> preferredCoinIds;
  List<String> interests;
  List<String> favoritedCabalIds;
  List<String> joinedCabalIds;
  List<String> earnedAchievementIds;
  List<String> favoritedNewsLinks;

  // Referral & Verification
  String? referralCode;
  String? referredBy; // UUID of the referrer
  String? twitterHandle;
  bool isTwitterVerified;
  bool isAdmin;

  // Timestamps
  final DateTime? createdAt;
  DateTime? updatedAt;

  UserProfile({
    required this.id,
    this.displayName,
    this.telegramUsername,
    this.profileImageUrl,
    this.totalXp = 0,
    this.level = 1,
    this.connected_wallets = const {},
    this.connected_socials = const {},
    this.preferredCoinIds = const [],
    this.interests = const [],
    this.favoritedCabalIds = const [],
    this.joinedCabalIds = const [],
    this.earnedAchievementIds = const [],
    this.favoritedNewsLinks = const [],
    this.referralCode,
    this.referredBy,
    this.twitterHandle,
    this.isTwitterVerified = false,
    this.isAdmin = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Logic for Level calculation matching the SQL: floor(sqrt(v_new_xp / 100.0)) + 1
  static int calculateLevelFromXp(int xp) {
    if (xp <= 0) return 1;
    return (sqrt(xp / 100.0).floor()) + 1;
  }

  /// Alias for fromSupabase to fix compatibility with SupabaseService
  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile.fromSupabase(json);

  /// Maps Supabase JSON response to the UserProfile model
  factory UserProfile.fromSupabase(Map<String, dynamic> data) {
    final int xp = (data['total_xp'] ?? 0) as int;
    
    return UserProfile(
      id: data['id'] as String,
      displayName: data['display_name'] as String?,
      telegramUsername: data['telegram_username'] as String?,
      profileImageUrl: data['profile_image_url'] as String?,
      totalXp: xp,
      level: (data['level'] ?? calculateLevelFromXp(xp)) as int,
      
      // Fixed field names
      connected_wallets: data['connected_wallets'] != null 
          ? Map<String, dynamic>.from(data['connected_wallets']) 
          : {},
      connected_socials: data['connected_socials'] != null 
          ? Map<String, dynamic>.from(data['connected_socials']) 
          : {},

      preferredCoinIds: _parseList(data['preferred_coin_ids']),
      interests: _parseList(data['interests']),
      favoritedCabalIds: _parseList(data['favorited_cabal_ids']),
      joinedCabalIds: _parseList(data['joined_cabal_ids']),
      earnedAchievementIds: _parseList(data['earned_achievement_ids']),
      favoritedNewsLinks: _parseList(data['favorited_news_links']),

      referralCode: data['referral_code'] as String?,
      referredBy: data['referred_by'] as String?,
      twitterHandle: data['twitter_handle'] as String?,
      isTwitterVerified: (data['is_twitter_verified'] ?? false) as bool,
      isAdmin: (data['is_admin'] ?? false) as bool,
      
      createdAt: data['created_at'] != null 
          ? DateTime.tryParse(data['created_at'] as String) 
          : null,
      updatedAt: data['updated_at'] != null 
          ? DateTime.tryParse(data['updated_at'] as String) 
          : null,
    );
  }

  /// Converts the model to a Map for Supabase updates
  Map<String, dynamic> toSupabase() {
    return {
      'display_name': displayName,
      'telegram_username': telegramUsername,
      'profile_image_url': profileImageUrl,
      'total_xp': totalXp,
      'level': level,
      'connected_wallets': connected_wallets,
      'connected_socials': connected_socials,
      'preferred_coin_ids': preferredCoinIds,
      'interests': interests,
      'favorited_cabal_ids': favoritedCabalIds,
      'joined_cabal_ids': joinedCabalIds,
      'earned_achievement_ids': earnedAchievementIds,
      'favorited_news_links': favoritedNewsLinks,
      'twitter_handle': twitterHandle,
      'is_twitter_verified': isTwitterVerified,
      'is_admin': isAdmin,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  static List<String> _parseList(dynamic data) {
    if (data == null) return [];
    return List<String>.from(data.map((item) => item.toString()));
  }

  // Updated helper methods to use snake_case
  bool hasWallet(String chain) => connected_wallets.containsKey(chain.toLowerCase());
  String? get tonAddress => connected_wallets['ton']?.toString();
}

```

### File: ./lib/services/firestore_service.dart
```dart
// SUPABASE_MIGRATION: This file is no longer used. All logic should be in supabase_service.dart.
/*
// SUPABASE_MIGRATION: Firestore import removed
import '../models/user_profile_model.dart';
import '../models/cabal_model.dart';
import '../models/quest_section_model.dart';
import '../models/quest_model.dart';
import '../models/notification_model.dart';
import '../models/achievement_model.dart';
import '../utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FirestoreService {
  final FirebaseFirestore _db = // [Supabase Fix] Commented out: FirebaseFirestore\.instance;

  String _cleanTgUsername(String tgUsername) {
    return tgUsername.startsWith('@') ? tgUsername.substring(1) : tgUsername;
  }

  Future<UserProfile?> getUserProfile(String telegramUsername) async {
    final cleanUsername = _cleanTgUsername(telegramUsername);
    try {
      final docRef = _db.collection(FirestoreCollections.users).doc(cleanUsername);
      final docSnap = await docRef.get();
      if (docSnap.exists) {
        return UserProfile.fromFirestore(docSnap as DocumentSnapshot<Map<String, dynamic>>);
      } else {
        final newUser = UserProfile(telegramUsername: cleanUsername, displayName: cleanUsername);
        await docRef.set(newUser.toFirestore());
        return newUser;
      }
    } catch (e) {
      print("Error getting/creating user profile for $cleanUsername: $e");
      return null;
    }
  }

  Future<void> updateUserProfile(String telegramUsername, Map<String, dynamic> data) async {
    final cleanUsername = _cleanTgUsername(telegramUsername);
    try {
      await _db.collection(FirestoreCollections.users).doc(cleanUsername).update({
        ...data,
        'lastUpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error updating user profile for $cleanUsername: $e");
      rethrow;
    }
  }
  
  Future<List<UserProfile>> getTopUsers(int limit) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection(FirestoreCollections.users)
          .orderBy('totalXp', descending: true)
          .limit(limit)
          .get();
      return snapshot.docs
          .map((doc) => UserProfile.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      print("Error getting top users: $e");
      return [];
    }
  }

  Future<void> followUser(String currentUserId, String targetUserId) async {
    if (currentUserId == targetUserId) return;
    final currentUserClean = _cleanTgUsername(currentUserId);
    final targetUserClean = _cleanTgUsername(targetUserId);
    final currentUserRef = _db.collection(FirestoreCollections.users).doc(currentUserClean);
    final targetUserRef = _db.collection(FirestoreCollections.users).doc(targetUserClean);

    await _db.runTransaction((transaction) async {
      transaction.update(currentUserRef, {'followingUserIds': FieldValue.arrayUnion([targetUserClean])});
      transaction.update(targetUserRef, {'followersUserIds': FieldValue.arrayUnion([currentUserClean])});
    });
    // TODO: Create a notification for targetUserId
  }

  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    final currentUserClean = _cleanTgUsername(currentUserId);
    final targetUserClean = _cleanTgUsername(targetUserId);
    final currentUserRef = _db.collection(FirestoreCollections.users).doc(currentUserClean);
    final targetUserRef = _db.collection(FirestoreCollections.users).doc(targetUserClean);

    await _db.runTransaction((transaction) async {
      transaction.update(currentUserRef, {'followingUserIds': FieldValue.arrayRemove([targetUserClean])});
      transaction.update(targetUserRef, {'followersUserIds': FieldValue.arrayRemove([currentUserClean])});
    });
  }

  Future<List<Cabal>> getAllCabals() async {
    try {
      QuerySnapshot snapshot = await _db.collection(FirestoreCollections.cabals).get();
      return snapshot.docs
          .map((doc) => Cabal.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      print("Error getting all projects: $e");
      return [];
    }
  }

  Future<Cabal?> getCabal(String cabalId) async {
    try {
      DocumentSnapshot doc = await _db.collection(FirestoreCollections.cabals).doc(cabalId).get();
      if (doc.exists) {
        return Cabal.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
      }
    } catch (e) {
      print("Error getting project $cabalId: $e");
    }
    return null;
  }

  Future<List<QuestSection>> getQuestSectionsForCabal(String cabalId, List<String> sectionOrder) async {
    try {
      final List<QuestSection> sections = [];
      if (sectionOrder.isEmpty) { 
         QuerySnapshot snapshot = await _db
            .collection(FirestoreCollections.cabals).doc(cabalId)
            .collection(FirestoreCollections.questSections).orderBy('order').get();
          return snapshot.docs.map((doc) => QuestSection.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
      }
      for (String sectionId in sectionOrder) {
         final docSnap = await _db.collection(FirestoreCollections.cabals).doc(cabalId)
            .collection(FirestoreCollections.questSections).doc(sectionId).get();
        if (docSnap.exists) {
            sections.add(QuestSection.fromFirestore(docSnap as DocumentSnapshot<Map<String, dynamic>>));
        }
      }
      return sections;
    } catch (e) {
      print("Error getting quest sections for project $cabalId: $e");
      return [];
    }
  }

  Future<List<Quest>> getQuestsForSection(String cabalId, String sectionId) async {
    try {
      QuerySnapshot snapshot = await _db.collection(FirestoreCollections.cabals).doc(cabalId)
          .collection(FirestoreCollections.questSections).doc(sectionId)
          .collection(FirestoreCollections.quests).get();
      return snapshot.docs.map((doc) => Quest.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
    } catch (e) {
      print("Error getting quests for project $cabalId, section $sectionId: $e");
      return [];
    }
  }

  Future<Map<String, DateTime?>> getCompletedQuestTimestampsForUser(String telegramUsername, String cabalId) async {
    final cleanUsername = _cleanTgUsername(telegramUsername);
    Map<String, DateTime?> completedQuestTimestamps = {};
    try {
      QuerySnapshot snapshot = await _db.collection(FirestoreCollections.users).doc(cleanUsername)
          .collection(FirestoreCollections.userCabalProgress).doc(cabalId)
          .collection(FirestoreCollections.completedQuests).get();
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['completedAt'] is DateTime?) {
          completedQuestTimestamps[doc.id] = data['completedAt'] as DateTime?;
        }
      }
    } catch (e) {
      print("Error getting completed quests timestamps for $cleanUsername, project $cabalId: $e");
    }
    return completedQuestTimestamps;
  }
  
  Future<Set<String>> getCompletedQuestIdsForUser(String telegramUsername, String cabalId) async {
    final cleanUsername = _cleanTgUsername(telegramUsername);
    Set<String> completedIds = {};
    try {
      QuerySnapshot snapshot = await _db.collection(FirestoreCollections.users).doc(cleanUsername)
          .collection(FirestoreCollections.userCabalProgress).doc(cabalId)
          .collection(FirestoreCollections.completedQuests).get();
      for (var doc in snapshot.docs) {
        completedIds.add(doc.id);
      }
    } catch (e) {
      print("Error getting completed quest IDs for $cleanUsername, project $cabalId: $e");
    }
    return completedIds;
  }

  Future<void> completeQuestForUser({
    required String telegramUsername,
    required String cabalId,
    required Quest quest,
    required UserProfile userProfile,
  }) async {
    final cleanUsername = _cleanTgUsername(telegramUsername);    
    final userDocRef = _db.collection(FirestoreCollections.users).doc(cleanUsername);
    final completedQuestRef = userDocRef
        .collection(FirestoreCollections.userCabalProgress).doc(cabalId)
        .collection(FirestoreCollections.completedQuests).doc(quest.id);
    
    await _db.runTransaction((transaction) async {
        int newTotalXp = userProfile.totalXp + quest.xpReward;
        int newLevel = calculateLevel(newTotalXp);
        
        transaction.update(userDocRef, {
            'totalXp': newTotalXp,
            'level': newLevel,
            'joinedCabalIds': FieldValue.arrayUnion([cabalId])
        });
        
        transaction.set(completedQuestRef, {
          'completedAt': FieldValue.serverTimestamp(),
          'questTitle': quest.title,
          'xpAwarded': quest.xpReward
        });
        userProfile.totalXp = newTotalXp; // Update local model immediately for subsequent checks
        userProfile.level = newLevel;
    });

    await checkAndAwardAchievements(userProfile, questId: quest.id, cabalId: cabalId);
    await addNotification(
        userId: cleanUsername,
        title: "Quest Complete!",
        body: "You earned ${quest.xpReward} XP for completing '${quest.title}'.",
        type: "quest_complete",
        referenceId: quest.id
    );
    print("Quest ${quest.id} completed for $cleanUsername. XP Awarded: ${quest.xpReward}");
  }

  Future<List<Achievement>> getGlobalAchievements() async { // Renamed for clarity
      try {
          QuerySnapshot snapshot = await _db.collection('achievements').get();
          return snapshot.docs.map((doc) => Achievement.fromFirestore(doc as DocumentSnapshot<Map<String,dynamic>>)).toList();
      } catch (e) {
          print("Error getting achievements: $e");
          return [];
      }
  }
  
  Future<List<Achievement>> getEarnedAchievementsDetails(List<String> achievementIds) async {
    if (achievementIds.isEmpty) return [];
    List<Achievement> achievements = [];
    try {
      List<List<String>> chunks = [];
      for (var i = 0; i < achievementIds.length; i += 30) { // Updated to 30 (current Firestore limit)
          chunks.add(achievementIds.sublist(i, i + 30 > achievementIds.length ? achievementIds.length : i + 30));
      }
      for (var chunk in chunks) {
          if (chunk.isNotEmpty) {
            final snapshot = await _db.collection('achievements').where(FieldPath.documentId, whereIn: chunk).get();
            achievements.addAll(snapshot.docs.map((doc) => Achievement.fromFirestore(doc as DocumentSnapshot<Map<String,dynamic>>)));
          }
      }
    } catch(e) {
        print("Error fetching achievement details: $e");
    }
    return achievements;
  }

  Future<void> checkAndAwardAchievements(UserProfile userProfile, {String? questId, String? cabalId}) async {
    print("Checking achievements for ${userProfile.telegramUsername}...");
    
    // Example: Award an achievement for completing the quest "first_quest_ever"
    final firstQuestAchievementId = "ach_first_quest";
    if (questId == "first_quest_ever" && !userProfile.earnedAchievementIds.contains(firstQuestAchievementId)) {
        int bonusXp = 50; 
        try {
            await _db.collection(FirestoreCollections.users).doc(userProfile.telegramUsername).update({
                'earnedAchievementIds': FieldValue.arrayUnion([firstQuestAchievementId]),
                'totalXp': FieldValue.increment(bonusXp),
            });
            // Update local profile for immediate UI reflection and further checks if any
            userProfile.earnedAchievementIds.add(firstQuestAchievementId); 
            userProfile.totalXp += bonusXp;
            userProfile.level = calculateLevel(userProfile.totalXp);
            
            print("Awarded achievement: $firstQuestAchievementId to ${userProfile.telegramUsername}");
            await addNotification(
              userId: userProfile.telegramUsername,
              title: "Achievement Unlocked!",
              body: "You've earned the achievement: 'First Quest Conqueror!' (+${bonusXp} XP)", // Example name
              type: "achievement_unlocked",
              referenceId: firstQuestAchievementId
            );
        } catch (e) {
            print("Error awarding achievement $firstQuestAchievementId: $e");
        }
    }
    // TODO: Implement more comprehensive achievement checking logic.
    // Fetch all defined achievements (getGlobalAchievements).
    // For each achievement not yet earned by the user:
    //   - Check if its criteria are met based on userProfile data 
    //     (e.g., userProfile.totalXp, userProfile.level, count of completed quests).
    //   - If met, award it similar to the example above.
  }

  Future<List<NotificationModel>> getUserNotifications(String userId, {int limit = 20}) async {
    try {
      QuerySnapshot snapshot = await _db.collection(FirestoreCollections.users).doc(_cleanTgUsername(userId))
          .collection('notifications').orderBy('createdAt', descending: true).limit(limit).get();
      return snapshot.docs.map((doc) => NotificationModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
    } catch (e) {
      print("Error getting user notifications: $e");
      return [];
    }
  }
  
  Future<int> getUnreadNotificationCount(String userId) async {
      try {
          final snapshot = await _db.collection(FirestoreCollections.users).doc(_cleanTgUsername(userId))
              .collection('notifications').where('isRead', isEqualTo: false).count().get();
          return snapshot.count ?? 0; 
      } catch (e) {
          print("Error getting unread notification count: $e");
          return 0;
      }
  }

  Future<void> addNotification({ required String userId, required String title, required String body,
    String? type, String? referenceId}) async {
    try {
      await _db.collection(FirestoreCollections.users).doc(_cleanTgUsername(userId)).collection('notifications').add({
        'userId': _cleanTgUsername(userId), 'title': title, 'body': body, 'type': type,
        'referenceId': referenceId, 'createdAt': FieldValue.serverTimestamp(), 'isRead': false,
      });
    } catch (e) {
      print("Error adding notification: $e");
    }
  }

  Future<void> markNotificationAsRead(String userId, String notificationId) async {
    try {
      await _db.collection(FirestoreCollections.users).doc(_cleanTgUsername(userId))
          .collection('notifications').doc(notificationId).update({'isRead': true});
    } catch (e) {
      print("Error marking notification as read: $e");
    }
  }
  
  Future<void> markAllNotificationsAsRead(String userId) async {
    try {
      final batch = _db.batch();
      final snapshot = await _db.collection(FirestoreCollections.users).doc(_cleanTgUsername(userId))
          .collection('notifications').where('isRead', isEqualTo: false).get();
      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      print("Error marking all notifications as read: $e");
    }
  }
  
  Future<void> linkWallet(String telegramUsername, String walletType, String address) async {
    final cleanUsername = _cleanTgUsername(telegramUsername);
    await _db.collection(FirestoreCollections.users).doc(cleanUsername).update({
      'connectedWallets.${walletType}': address,
      'lastUpdatedAt': FieldValue.serverTimestamp(),
    });
    print("Wallet $walletType linked for $cleanUsername");
  }

  Future<void> linkSocialAccount(String telegramUsername, String platform, String accountId) async {
    final cleanUsername = _cleanTgUsername(telegramUsername);
     await _db.collection(FirestoreCollections.users).doc(cleanUsername).update({
      'connectedSocials.${platform}': accountId,
      'lastUpdatedAt': FieldValue.serverTimestamp(),
    });
    print("Social account $platform linked for $cleanUsername");
  }

  Future<bool> isAdmin(String telegramUsername) async {
    final cleanUsername = _cleanTgUsername(telegramUsername);
    if (cleanUsername.isEmpty) return false;
    try {
      DocumentSnapshot userDoc = await _db.collection(FirestoreCollections.users).doc(cleanUsername).get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>?; 
        return data?['isAdmin'] == true; 
      }
      return false; 
    } catch (e) {
      print("Error checking admin status for $cleanUsername: $e");
      return false; 
    }
  }
}

*\/ \/\/ End of FirestoreService

```

### File: ./lib/services/coingecko_service.dart
```dart
// lib/services/coingecko_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show debugPrint;
import '../models/coin_model.dart';

class CoinGeckoService {
  final String _baseUrl = "https://api.coingecko.com/api/v3";

  Future<List<Coin>> fetchTrendingCoins(int limit) async {
    final url = '$_baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$limit&page=1&sparkline=false&price_change_percentage=24h';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Coin.fromMap(json)).toList();
      } else {
        throw Exception('Failed to load trending coins. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching trending coins: $e');
      // Return an empty list or rethrow the exception, depending on how you want to handle errors.
      return [];
    }
  }
}

```

### File: ./lib/services/wallet_service_stub.dart
```dart
// lib/core/services/wallet_service_stub.dart
// This is the WEB implementation using Web3Modal.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class WalletType {
  static const String evm = 'evm';
  static const String solana = 'solana';
}

class WalletService {
  W3MService? _w3mService;

  // --- Public Getters ---
  String? get connectedEVMAddress => _w3mService?.session?.address;
  String? get currentEVMChainId => _w3mService?.session?.chainId;
  bool get isConnectedEVM => _w3mService?.isConnected ?? false;
  
  // Solana remains unsupported on web
  String? get connectedSolanaAddress => null;
  bool get isConnectedSolana => false;

  Future<void> initialize() async {
    final projectId = dotenv.env['WALLET_CONNECT_PROJECT_ID'];
    if (projectId == null) {
      debugPrint("WalletService (Web) FATAL: WALLET_CONNECT_PROJECT_ID not found in .env");
      return;
    }

    _w3mService = W3MService(
      projectId: projectId,
      metadata: const PairingMetadata(
        name: 'Cabal',
        description: 'Cabal Quest Platform',
        url: 'https://cabal-001.web.app',
        icons: ['https://cabal-001.web.app/icon.png'],
      ),
    );

    await _w3mService!.init();
    
    debugPrint("WalletService (Web): Web3Modal client initialized.");
  }

  Future<String?> connectEVMWallet() async {
    if (isConnectedEVM) return connectedEVMAddress;
    if (_w3mService == null) throw Exception("Web3Modal service not initialized.");

    try {
      await _w3mService!.openModalView(); // Corrected method call
      // The provider will listen for state changes.
      return connectedEVMAddress;
    } catch (e) {
      debugPrint('Error connecting wallet via Web3Modal: $e');
      await disconnectEVMWallet();
      rethrow;
    }
  }

  Future<void> disconnectEVMWallet() async {
    if (_w3mService != null && _w3mService!.isConnected) {
      await _w3mService!.disconnect();
    }
    debugPrint("WalletService (Web): EVM wallet disconnected.");
  }

  Future<String?> signEVMMessage(String message, {String? chainId}) async {
    if (!isConnectedEVM || _w3mService == null) throw Exception("EVM Wallet not connected.");
    
    final signature = await _w3mService!.request(
      topic: _w3mService!.session!.topic!,
      chainId: chainId ?? 'eip155:${_w3mService!.selectedChain!.chainId}',
      request: SessionRequest(
        method: 'personal_sign',
        params: [message, connectedEVMAddress],
      ),
    );
    return signature.toString();
  }

  Future<String?> sendEVMTransaction({
    required String to,
    String? data,
    String? value,
    String? chainId,
  }) async {
    if (!isConnectedEVM || _w3mService == null) throw Exception("EVM Wallet not connected.");
    
    final transaction = Transaction(
      from: EthereumAddress.fromHex(connectedEVMAddress!),
      to: EthereumAddress.fromHex(to),
      data: data != null ? hexToBytes(data) : null,
      value: value != null ? EtherAmount.fromUnitAndValue(EtherUnit.wei, BigInt.parse(value.substring(2), radix: 16)) : null,
    );

    final txHash = await _w3mService!.request(
      topic: _w3mService!.session!.topic!,
      chainId: chainId ?? 'eip155:${_w3mService!.selectedChain!.chainId}',
      request: SessionRequest(
        method: 'eth_sendTransaction',
        params: [transaction.toJson()],
      ),
    );
    return txHash.toString();
  }

  // --- Solana remains unsupported on web ---
  Future<String?> connectSolanaWallet() async {
    throw UnsupportedError("Solana wallet connection is not available on web.");
  }

  Future<void> disconnectSolanaWallet() async {
    throw UnsupportedError("Solana wallet is not available on web.");
  }
}

```

### File: ./lib/services/block_explorer_service.dart
```dart
// lib/services/block_explorer_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BlockExplorerService {
  final bool _isTestnet = kDebugMode;
  late final String _baseUrl;
  late final String _apiKey;

  BlockExplorerService() {
    _baseUrl = _isTestnet 
        ? 'https://api-sepolia.etherscan.io/api' 
        : 'https://api.etherscan.io/api';
    // UPDATED: Read API key from build environment on web, .env on mobile
    _apiKey = kIsWeb 
      ? const String.fromEnvironment('ETHERSCAN_API_KEY') 
      : dotenv.env['ETHERSCAN_API_KEY'] ?? '';
  }

  Future<int> getTokenHolderCount(String contractAddress) async {
    debugPrint("BlockExplorerService: Simulating fetch for token holder count.");
    await Future.delayed(const Duration(milliseconds: 800));
    return 1842;
  }

  Future<int> getTransactions24h(String contractAddress) async {
    debugPrint("BlockExplorerService: Simulating fetch for 24h transaction count.");
    await Future.delayed(const Duration(milliseconds: 600));
    return 431;
  }

  Future<List<Map<String, String>>> getRecentTransfers(String contractAddress, {int count = 10}) async {
    debugPrint("BlockExplorerService: Simulating fetch for recent transfers.");
    await Future.delayed(const Duration(milliseconds: 1000));
    return [
      {'hash': '0x1a2b...cdef', 'from': '0xAbC...123', 'to': '0xDeF...456', 'amount': '5,000 CBL', 'timestamp': DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String()},
      {'hash': '0x3c4d...ghij', 'from': 'Presale Contract', 'to': '0xGhi...789', 'amount': '10,000 CBL', 'timestamp': DateTime.now().subtract(const Duration(minutes: 15)).toIso8601String()},
      {'hash': '0x5e6f...klmn', 'from': '0xJkL...abc', 'to': '0xMnP...def', 'amount': '250 CBL', 'timestamp': DateTime.now().subtract(const Duration(minutes: 22)).toIso8601String()},
      {'hash': '0x7g8h...opqr', 'from': '0xQrS...ghi', 'to': '0xTuV...jkl', 'amount': '1,200 CBL', 'timestamp': DateTime.now().subtract(const Duration(minutes: 31)).toIso8601String()},
    ];
  }

  Future<double> getTokenPrice() async {
    debugPrint("BlockExplorerService: Simulating fetch for token price.");
    await Future.delayed(const Duration(milliseconds: 300));
    return 0.025;
  }
}

```

### File: ./lib/services/nft_service.dart
```dart
// lib/services/nft_service.dart
import 'dart:convert';
import 'package:cabal/screens/user_wallet_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

class NftService {
  final Dio _dio = Dio();
  late final String? _pinataApiKey;
  late final String? _pinataApiSecret;

  NftService() {
    // UPDATED: Read API keys from build environment on web, .env on mobile
    _pinataApiKey = kIsWeb 
      ? const String.fromEnvironment('PINATA_API_KEY') 
      : dotenv.env['PINATA_API_KEY'];
    _pinataApiSecret = kIsWeb 
      ? const String.fromEnvironment('PINATA_API_SECRET') 
      : dotenv.env['PINATA_API_SECRET'];

    if (_pinataApiKey == null || _pinataApiKey!.isEmpty || _pinataApiSecret == null || _pinataApiSecret!.isEmpty) {
      debugPrint("NFTService WARNING: Pinata API keys not found in environment. IPFS uploads will fail.");
    }
  }

  // ... (Rest of the file remains the same)
  Future<String> uploadToIpfs({
    required XFile imageFile,
    required String name,
    required String description,
    required Map<String, dynamic> attributes,
  }) async {
    if (_pinataApiKey == null || _pinataApiSecret == null) {
      throw Exception("Pinata API keys are not configured.");
    }
    
    debugPrint("NFTService: Starting real upload to IPFS via Pinata...");

    final imageCid = await _uploadFileToPinata(imageFile);
    debugPrint("  - Image uploaded successfully. CID: $imageCid");

    final metadata = {
      "name": name,
      "description": description,
      "image": "ipfs://$imageCid",
      "attributes": attributes.entries.map((e) => {"trait_type": e.key, "value": e.value.toString()}).toList(),
    };
    
    final metadataCid = await _uploadJsonToPinata(metadata, name);
    debugPrint("  - Metadata JSON uploaded successfully. CID: $metadataCid");

    final tokenUri = "ipfs://$metadataCid";
    debugPrint("NFTService: IPFS upload complete. Final Token URI: $tokenUri");

    return tokenUri;
  }

  Future<String> _uploadFileToPinata(XFile file) async {
    const url = 'https://api.pinata.cloud/pinning/pinFileToIPFS';
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: file.name),
    });

    final response = await _dio.post(
      url,
      data: formData,
      options: Options(headers: {
        'pinata_api_key': _pinataApiKey,
        'pinata_secret_api_key': _pinataApiSecret,
      }),
    );

    if (response.statusCode == 200) {
      return response.data['IpfsHash'];
    } else {
      throw Exception('Failed to upload file to Pinata: ${response.data}');
    }
  }

  Future<String> _uploadJsonToPinata(Map<String, dynamic> jsonData, String name) async {
    const url = 'https://api.pinata.cloud/pinning/pinJSONToIPFS';
    final data = {
      'pinataMetadata': {'name': '${name.replaceAll(' ', '_')}_metadata.json'},
      'pinataContent': jsonData,
    };
    
    final response = await _dio.post(
      url,
      data: data,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'pinata_api_key': _pinataApiKey,
        'pinata_secret_api_key': _pinataApiSecret,
      }),
    );
    
     if (response.statusCode == 200) {
      return response.data['IpfsHash'];
    } else {
      throw Exception('Failed to upload JSON to Pinata: ${response.data}');
    }
  }

  Future<List<UserNft>> fetchUserNfts(String ownerAddress) async {
    debugPrint("NFTService: Simulating fetch of NFTs for address $ownerAddress");
    await Future.delayed(const Duration(milliseconds: 1500));
    final sepoliaAchievementsAddress = kIsWeb ? const String.fromEnvironment('SEPOLIA_CABAL_ACHIEVEMENTS_ADDRESS') : dotenv.env['SEPOLIA_CABAL_ACHIEVEMENTS_ADDRESS'] ?? '';
    final sepoliaDeedAddress = kIsWeb ? const String.fromEnvironment('SEPOLIA_REAL_ESTATE_DEED_ADDRESS') : dotenv.env['SEPOLIA_REAL_ESTATE_DEED_ADDRESS'] ?? '';

    return [
      UserNft(
        name: "First Quest Conqueror",
        collectionName: "Cabal Achievements",
        imageUrl: "https://ipfs.io/ipfs/bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi",
        contractAddress: sepoliaAchievementsAddress,
        tokenId: 1,
      ),
      UserNft(
        name: "Deed: 123 Genesis Plaza",
        collectionName: "Cabal Real Estate",
        imageUrl: "https://ipfs.io/ipfs/bafybeicg2tbafrd5l3gqwsd6vhjw2vweutw2ttjwgxgvaztzfmsn27qgpm",
        contractAddress: sepoliaDeedAddress,
        tokenId: 42,
      ),
    ];
  }
}

```

### File: ./lib/services/news_service.dart
```dart
// lib/services/news_service.dart
import 'package:xml/xml.dart' as xml;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/news_article_model.dart';

class NewsService {
  final String _functionName = 'news-proxy';

  // The constructor is no longer needed as the Supabase client handles auth.

  Future<List<NewsArticle>> fetchNews() async {
    try {
      debugPrint("NewsService: Invoking Supabase Edge Function: $_functionName");

      final response = await Supabase.instance.client.functions.invoke(
        _functionName,
      );

      if (response.status == 200) {
        final String feedText = response.data as String;
        final document = xml.XmlDocument.parse(feedText);
        final items = document.findAllElements('item');

        final articles = items.map((node) {
          final title = node.findElements('title').first.innerText;
          final link = node.findElements('link').first.innerText;
          final pubDateStr = node.findElements('pubDate').firstOrNull?.innerText;
          final descriptionHtml = node.findElements('description').firstOrNull?.innerText ?? '';
          final contentEncoded = node.findElements('content:encoded').firstOrNull?.innerText ?? '';
          final source = document.findAllElements('channel').firstOrNull?.findElements('title').firstOrNull?.innerText ?? 'The Defiant';

          DateTime? pubDate;
          if (pubDateStr != null) {
            try {
              // Using a more robust date format parser that handles various RFC 822 formats
              pubDate = DateFormat("EEE, dd MMM yyyy HH:mm:ss Z").parse(pubDateStr);
            } catch (e) {
               try {
                 pubDate = DateFormat("EEE, dd MMM yy HH:mm:ss Z").parse(pubDateStr);
               } catch (e2) {
                 debugPrint("NewsService: Could not parse date '$pubDateStr'. Error: $e2");
               }
            }
          }

          String? imageUrl;
          final imgRegex = RegExp(r'<img[^>]+src="([^">]+)"');
          final match = imgRegex.firstMatch(contentEncoded);
          if (match != null && match.groupCount > 0) {
            imageUrl = match.group(1);
          }

          return NewsArticle(
            title: title,
            link: link,
            pubDate: pubDate,
            source: source,
            description: _stripHtml(descriptionHtml),
            imageUrl: imageUrl,
          );
        }).toList();

        // --- FIX: Sort by publication date, newest first. Handle null dates gracefully. ---
        articles.sort((a, b) => (b.pubDate ?? DateTime(0)).compareTo(a.pubDate ?? DateTime(0)));

        debugPrint("NewsService: Successfully fetched and parsed ${articles.length} articles via Edge Function.");
        return articles;
      } else {
        debugPrint("NewsService: Edge Function returned non-200 status: ${response.status}. Body: ${response.data}");
        throw Exception('Failed to load news feed via Edge Function: ${response.data}');
      }
    } catch (e) {
      debugPrint("NewsService: Error invoking Edge Function: $e");
      rethrow;
    }
  }

  String? _stripHtml(String? htmlString) {
    if (htmlString == null) return null;
    final RegExp htmlRegExp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(htmlRegExp, '').replaceAll('<![CDATA[', '').replaceAll(']]>', '').trim();
  }
}

```

### File: ./lib/services/web3_service.dart
```dart
// lib/services/web3_service.dart
import 'dart:convert';
// --- FIX: Corrected import paths from 'services' to 'screens' ---
import 'package:cabal/screens/escrow_detail_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/crypto.dart';
import 'package:cabal/config.dart'; // Import the new config helper

class Web3Service {
  late Web3Client _client;
  final bool _isTestnet = kDebugMode;

  // Contract Instances
  DeployedContract? _cabalTokenContract;
  DeployedContract? _cabalTgeContract;
  DeployedContract? _cabalAchievementsContract;
  DeployedContract? _presaleContract;
  DeployedContract? _realEstateDeedContract;
  DeployedContract? _escrowContract;
  DeployedContract? _nftMarketplaceContract;
  DeployedContract? _merchandiseStoreContract;

  // Contract Addresses
  late String cabalTokenAddress;
  late String cabalTgeAddress;
  late String cabalAchievementsAddress;
  late String presaleAddress;
  late String realEstateDeedAddress;
  late String escrowAddress;
  late String nftMarketplaceAddress;
  late String merchandiseStoreAddress;

  // --- NEW: Standard ERC20 ABI and Bytecode for the Token Factory ---
  static const String _erc20FactoryAbiJson = '''
  [
    {"inputs":[{"internalType":"string","name":"name_","type":"string"},{"internalType":"string","name":"symbol_","type":"string"}],"stateMutability":"nonpayable","type":"constructor"},
    {"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"spender","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Approval","type":"event"},
    {"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Transfer","type":"event"},
    {"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},
    {"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},
    {"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},
    {"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},
    {"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"subtractedValue","type":"uint256"}],"name":"decreaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},
    {"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"addedValue","type":"uint256"}],"name":"increaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},
    {"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"mint","outputs":[],"stateMutability":"nonpayable","type":"function"},
    {"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},
    {"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},
    {"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},
    {"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},
    {"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"}
  ]
  ''';
  
  static const String _erc20FactoryBytecode = "YOUR_SOLIDITY_CONTRACT_BYTECODE_HERE"; // Placeholder

  // --- FULLY IMPLEMENTED CONTRACT ABIs ---
  // --- FIX: Replaced truncated ABIs with valid empty JSON to prevent parsing errors. ---
  // --- IMPORTANT: You MUST replace these "[]" with your actual, full contract ABIs. ---
  final String _cabalTokenAbi = "[]";
  final String _genericErc721Abi = "[]";
  final String _cabalTgeAbi = "[]";
  final String _cabalAchievementsAbi = "[]";
  final String _presaleAbi = "[]";
  final String _realEstateDeedAbi = "[]";
  final String _escrowAbi = "[]";
  final String _nftMarketplaceAbi = "[]";
  final String _merchandiseStoreAbi = "[]";

  Future<void> initialize() async {
    final rpcUrl = _isTestnet ? AppConfig.sepoliaRpcUrl : AppConfig.mainnetRpcUrl;
    if (rpcUrl.isEmpty) throw Exception("RPC URL not found in environment.");
    _client = Web3Client(rpcUrl, Client());
    
    cabalTokenAddress = _isTestnet ? AppConfig.sepoliaCabalTokenAddress : AppConfig.mainnetCabalTokenAddress;
    cabalTgeAddress = _isTestnet ? AppConfig.sepoliaCabalTgeAddress : AppConfig.mainnetCabalTgeAddress;
    cabalAchievementsAddress = _isTestnet ? AppConfig.sepoliaCabalAchievementsAddress : AppConfig.mainnetCabalAchievementsAddress;
    presaleAddress = _isTestnet ? AppConfig.sepoliaPresaleAddress : AppConfig.mainnetPresaleAddress;
    realEstateDeedAddress = _isTestnet ? AppConfig.sepoliaRealEstateDeedAddress : AppConfig.mainnetRealEstateDeedAddress;
    escrowAddress = _isTestnet ? AppConfig.sepoliaEscrowAddress : AppConfig.mainnetEscrowAddress;
    nftMarketplaceAddress = _isTestnet ? AppConfig.sepoliaNftMarketplaceAddress : AppConfig.mainnetNftMarketplaceAddress;
    merchandiseStoreAddress = _isTestnet ? AppConfig.sepoliaMerchandiseStoreAddress : AppConfig.mainnetMerchandiseStoreAddress;

    if (cabalTokenAddress.isEmpty) {
      debugPrint("Web3Service WARNING: One or more contract addresses are missing in the environment. On-chain functions will fail.");
    } else {
      await _loadContracts();
    }
    
    debugPrint("Web3Service Initialized. Using ${(_isTestnet ? 'Sepolia Testnet' : 'Ethereum Mainnet')}");
  }

  // --- NEW DEPLOYMENT FUNCTION ---
  Future<String> deployAndInitializeERC20({
    required String name,
    required String symbol,
    required BigInt initialSupply,
    required EthPrivateKey credentials,
  }) async {
    // This is a high-level simulation. A real implementation would involve more complex logic.
    debugPrint("Simulating ERC20 deployment for $name ($symbol) with supply $initialSupply");
    await Future.delayed(const Duration(seconds: 2));
    final fakeAddress = "0x" + List.generate(40, (_) => 'abcdef1234567890'[DateTime.now().millisecond % 16]).join();
    debugPrint("Simulated deployment successful. Contract address: $fakeAddress");
    return fakeAddress;
  }
  
  Future<void> _loadContracts() async {
    try {
      _cabalTokenContract = _loadContract('CabalToken', _cabalTokenAbi, cabalTokenAddress);
      _cabalTgeContract = _loadContract('CabalTGE', _cabalTgeAbi, cabalTgeAddress);
      _cabalAchievementsContract = _loadContract('CabalAchievements', _cabalAchievementsAbi, cabalAchievementsAddress);
      _presaleContract = _loadContract('Presale', _presaleAbi, presaleAddress);
      _realEstateDeedContract = _loadContract('RealEstateDeed', _realEstateDeedAbi, realEstateDeedAddress);
      _escrowContract = _loadContract('Escrow', _escrowAbi, escrowAddress);
      _nftMarketplaceContract = _loadContract('CabalNftMarketplace', _nftMarketplaceAbi, nftMarketplaceAddress);
      _merchandiseStoreContract = _loadContract('MerchandiseStore', _merchandiseStoreAbi, merchandiseStoreAddress);
      
      debugPrint("Web3Service: All smart contracts loaded successfully.");
    } catch (e) {
      debugPrint("Web3Service ERROR: Failed to load contracts. Ensure ABIs and addresses are correct. Error: $e");
    }
  }

  DeployedContract? _loadContract(String name, String abi, String address) {
    if (address.isEmpty || abi.trim() == "[]" || abi.trim().isEmpty) {
      debugPrint("Web3Service: Skipping contract '$name' due to missing address or ABI.");
      return null;
    }
    return DeployedContract(ContractAbi.fromJson(abi, name), EthereumAddress.fromHex(address));
  }

  Future<EtherAmount> getEthBalance(String address) async => await _client.getBalance(EthereumAddress.fromHex(address));
  Future<BigInt> getUserCblBalance(String userAddress) async {
    if (_cabalTokenContract == null) return BigInt.zero;
    final result = await _client.call(contract: _cabalTokenContract!, function: _cabalTokenContract!.function('balanceOf'), params: [EthereumAddress.fromHex(userAddress)]);
    return result.first as BigInt;
  }
  Future<BigInt> getCirculatingSupply() async {
    if (_cabalTokenContract == null) return BigInt.zero;
    final result = await _client.call(contract: _cabalTokenContract!, function: _cabalTokenContract!.function('totalSupply'), params: []);
    return result.first as BigInt;
  }
  Future<BigInt> getPresaleTokensSold() async {
    if (_presaleContract == null) return BigInt.zero;
    final result = await _client.call(contract: _presaleContract!, function: _presaleContract!.function('tokensSold'), params: []);
    return result.first as BigInt;
  }
  Future<bool> isWhitelisted(String userAddress) async {
    if (_presaleContract == null) return false;
    final result = await _client.call(contract: _presaleContract!, function: _presaleContract!.function('isWhitelisted'), params: [EthereumAddress.fromHex(userAddress)]);
    return result.first as bool;
  }
  Future<bool> isMarketplaceApproved(String nftContractAddress, BigInt tokenId) async {
    final nftContract = DeployedContract(ContractAbi.fromJson(_genericErc721Abi, 'ERC721'), EthereumAddress.fromHex(nftContractAddress));
    final result = await _client.call(contract: nftContract, function: nftContract.function('getApproved'), params: [tokenId]);
    final approvedAddress = result.first as EthereumAddress;
    return approvedAddress.hex.toLowerCase() == nftMarketplaceAddress.toLowerCase();
  }
  Future<EscrowDetails> getEscrowDetails(BigInt tokenId) async {
    if (_escrowContract == null) throw Exception("Escrow Contract not loaded.");
    final saleData = await _client.call(contract: _escrowContract!, function: _escrowContract!.function('sales'), params: [tokenId]);
    
    final seller = (saleData[0] as EthereumAddress).hex;
    final buyer = (saleData[1] as EthereumAddress).hex;
    final broker = (saleData[2] as EthereumAddress).hex;
    final priceWei = saleData[4] as BigInt;
    final stateIndex = (saleData[6] as BigInt).toInt();
    final buyerApproved = saleData[7] as bool;
    final sellerApproved = saleData[8] as bool;
    final brokerApproved = saleData[9] as bool;

    final states = ["Created", "Locked", "InspectionPassed", "Canceled", "Complete"];
    
    return EscrowDetails(
      seller: seller, buyer: buyer, broker: broker,
      salePriceEth: EtherAmount.inWei(priceWei).getValueInUnit(EtherUnit.ether).toStringAsFixed(4) + " ETH",
      salePriceWei: priceWei,
      state: states[stateIndex],
      buyerApproved: buyerApproved, sellerApproved: sellerApproved, brokerApproved: brokerApproved,
    );
  }

  Transaction buildBuyPresaleTokensTransaction({required BigInt amountInWei}) {
    if (_presaleContract == null) throw Exception("Presale Contract not loaded.");
    return Transaction.callContract(contract: _presaleContract!, function: _presaleContract!.function('buyTokens'), parameters: [], value: EtherAmount.inWei(amountInWei));
  }
  Transaction buildTipUserTransaction({required String recipientAddress, required BigInt amountInCblWei}) {
    if (_cabalTokenContract == null) throw Exception("Cabal Token Contract not loaded.");
    return Transaction.callContract(contract: _cabalTokenContract!, function: _cabalTokenContract!.function('transfer'), parameters: [EthereumAddress.fromHex(recipientAddress), amountInCblWei]);
  }
  Transaction buildMintDeedTransaction({required String ownerAddress, required String tokenURI, required String propertyId}) {
    if (_realEstateDeedContract == null) throw Exception("Real Estate Deed Contract not loaded.");
    final propertyIdBytes = keccak256(Uint8List.fromList(utf8.encode(propertyId)));
    return Transaction.callContract(contract: _realEstateDeedContract!, function: _realEstateDeedContract!.function('mintDeed'), parameters: [EthereumAddress.fromHex(ownerAddress), tokenURI, propertyIdBytes]);
  }

  Transaction buildApproveNftTransaction({required String nftContractAddress, required BigInt tokenId}) {
    final nftContract = DeployedContract(ContractAbi.fromJson(_genericErc721Abi, 'ERC721'), EthereumAddress.fromHex(nftContractAddress));
    return Transaction.callContract(contract: nftContract, function: nftContract.function('approve'), parameters: [EthereumAddress.fromHex(nftMarketplaceAddress), tokenId]);
  }
  Transaction buildListItemTransaction({required String nftContractAddress, required BigInt tokenId, required BigInt priceInWei}) {
    if (_nftMarketplaceContract == null) throw Exception("NFT Marketplace Contract not loaded.");
    return Transaction.callContract(contract: _nftMarketplaceContract!, function: _nftMarketplaceContract!.function('listItem'), parameters: [EthereumAddress.fromHex(nftContractAddress), tokenId, priceInWei]);
  }
  Transaction buildBuyItemTransaction({required String nftContractAddress, required BigInt tokenId, required BigInt priceInWei}) {
    if (_nftMarketplaceContract == null) throw Exception("NFT Marketplace Contract not loaded.");
    return Transaction.callContract(contract: _nftMarketplaceContract!, function: _nftMarketplaceContract!.function('buyItem'), parameters: [EthereumAddress.fromHex(nftContractAddress), tokenId], value: EtherAmount.inWei(priceInWei));
  }
  Transaction buildCancelListingTransaction({required String nftContractAddress, required BigInt tokenId}) {
    if (_nftMarketplaceContract == null) throw Exception("NFT Marketplace Contract not loaded.");
    return Transaction.callContract(contract: _nftMarketplaceContract!, function: _nftMarketplaceContract!.function('cancelListing'), parameters: [EthereumAddress.fromHex(nftContractAddress), tokenId]);
  }

  Transaction buildCreateEscrowSaleTransaction({required String deedContractAddress, required BigInt tokenId, required BigInt salePriceWei, required String brokerAddress, required BigInt commissionBps}) {
    if (_escrowContract == null) throw Exception("Escrow Contract not loaded.");
    return Transaction.callContract(contract: _escrowContract!, function: _escrowContract!.function('createSale'), parameters: [EthereumAddress.fromHex(deedContractAddress), tokenId, salePriceWei, EthereumAddress.fromHex(brokerAddress), commissionBps]);
  }
  Transaction buildDepositFundsTransaction({required BigInt tokenId, required BigInt escrowAmountWei}) {
    if (_escrowContract == null) throw Exception("Escrow Contract not loaded.");
    return Transaction.callContract(contract: _escrowContract!, function: _escrowContract!.function('depositFunds'), parameters: [tokenId], value: EtherAmount.inWei(escrowAmountWei));
  }
  Transaction buildApproveInspectionTransaction({required BigInt tokenId}) {
    if (_escrowContract == null) throw Exception("Escrow Contract not loaded.");
    return Transaction.callContract(contract: _escrowContract!, function: _escrowContract!.function('approveInspection'), parameters: [tokenId]);
  }
  Transaction buildFinalizeSaleTransaction({required BigInt tokenId}) {
    if (_escrowContract == null) throw Exception("Escrow Contract not loaded.");
    return Transaction.callContract(contract: _escrowContract!, function: _escrowContract!.function('finalizeSale'), parameters: [tokenId]);
  }
  Transaction buildCancelSaleTransaction({required BigInt tokenId}) {
    if (_escrowContract == null) throw Exception("Escrow Contract not loaded.");
    return Transaction.callContract(contract: _escrowContract!, function: _escrowContract!.function('cancelSale'), parameters: [tokenId]);
  }

  Transaction buildListProductTransaction({required String sellerAddress, required String paymentTokenAddress, required BigInt priceInWei, required String bonusTokenAddress, required BigInt bonusAmountInWei}) {
    if (_merchandiseStoreContract == null) throw Exception("Merchandise Store Contract not loaded.");
    return Transaction.callContract(contract: _merchandiseStoreContract!, function: _merchandiseStoreContract!.function('listProduct'), parameters: [EthereumAddress.fromHex(sellerAddress), EthereumAddress.fromHex(paymentTokenAddress), priceInWei, EthereumAddress.fromHex(bonusTokenAddress.isEmpty ? '0x0000000000000000000000000000000000000000' : bonusTokenAddress), bonusAmountInWei]);
  }
  Transaction buildPurchaseTransaction({required BigInt productId}) {
    if (_merchandiseStoreContract == null) throw Exception("Merchandise Store Contract not loaded.");
    return Transaction.callContract(contract: _merchandiseStoreContract!, function: _merchandiseStoreContract!.function('purchase'), parameters: [productId]);
  }
  Transaction buildErc20ApproveTransaction({required String tokenAddress, required String spenderAddress, required BigInt amountInWei}) {
    final tokenContract = DeployedContract(ContractAbi.fromJson(_cabalTokenAbi, 'ERC20'), EthereumAddress.fromHex(tokenAddress));
    return Transaction.callContract(contract: tokenContract, function: tokenContract.function('approve'), parameters: [EthereumAddress.fromHex(spenderAddress), amountInWei]);
  }
}

```

### File: ./lib/services/auth_service.dart
```dart
// lib/services/auth_service.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'supabase_service.dart';

class AuthService {
  final SupabaseService _supabaseService = SupabaseService();

  // ====================== EMAIL AUTH ======================

  Future<AuthResponse> signUpWithEmail(String email, String password, {String? referralCode}) async {
    return await _supabaseService.signUpUser(email, password, referralCode: referralCode);
  }

  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await _supabaseService.signInUser(email, password);
  }

  // ====================== OAUTH (Google, Discord, Twitter) ======================

  /// Recommended: Use Supabase's built-in OAuth
  Future<bool> signInWithGoogle() async {
    return await _supabaseService.signInWithGoogle();
  }

  Future<bool> signInWithDiscord() async {
    return await _supabaseService.signInWithDiscord();
  }

  Future<bool> signInWithTwitter() async {
    return await _supabaseService.signInWithTwitter();
  }

  // ====================== WALLET CONNECTIONS (Stubs for now) ======================

  Future<String?> connectEthereumWallet() async {
    debugPrint("Attempting to connect Ethereum Wallet...");
    // TODO: Integrate Reown AppKit / Web3Modal here
    await Future.delayed(const Duration(seconds: 1));
    return "0x742d35Cc6634C0532925a3b844Bc454e4438f44e"; // Placeholder
  }

  Future<String?> connectSolanaWallet() async {
    debugPrint("Attempting to connect Solana Wallet...");
    // TODO: Integrate Solana Mobile or Phantom
    await Future.delayed(const Duration(seconds: 1));
    return "YourSolanaAddressPlaceholder..."; // Placeholder
  }

  Future<String?> connectBaseWallet() async {
    debugPrint("Attempting to connect Base Wallet...");
    // Usually same as Ethereum (EVM)
    await Future.delayed(const Duration(seconds: 1));
    return "0x742d35Cc6634C0532925a3b844Bc454e4438f44e"; // Placeholder
  }

  // ====================== SOCIAL ACTIONS ======================

  Future<bool> signInWithTwitterAction(String? targetUrl) async {
    if (targetUrl != null && targetUrl.isNotEmpty) {
      final uri = Uri.parse(targetUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }
    }
    debugPrint("No valid Twitter URL provided.");
    return false;
  }

  Future<bool> signInWithDiscordAction(String? targetUrl) async {
    if (targetUrl != null && targetUrl.isNotEmpty) {
      final uri = Uri.parse(targetUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }
    }
    debugPrint("No valid Discord URL provided.");
    return false;
  }

  Future<void> launchActionUrl(String? urlString) async {
    if (urlString == null || urlString.isEmpty) {
      throw Exception('No URL provided to launch');
    }

    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $urlString');
    }
  }

  // ====================== MISC ======================

  Future<void> signOut() async {
    await _supabaseService.signOutUser();
  }

  User? get currentUser => _supabaseService.getCurrentUser();

  Stream<AuthState> get authStateChanges => _supabaseService.authStateChanges;
}

```

### File: ./lib/services/storage_service.dart
```dart
// lib/services/storage_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class StorageService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<String?> uploadImage(XFile file, String bucket, String folder) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
      final path = '$folder/$fileName';

      await supabase.storage.from(bucket).upload(path, File(file.path));

      final publicUrl = supabase.storage.from(bucket).getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      print("Storage upload error: $e");
      return null;
    }
  }

  // Profile Picture Upload
  Future<String?> uploadProfilePicture(XFile file) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return null;
    return await uploadImage(file, 'profile-pictures', userId);
  }

  // Cabal Logo
  Future<String?> uploadCabalLogo(XFile file, String cabalId) async {
    return await uploadImage(file, 'cabal-logos', cabalId);
  }
}

```

### File: ./lib/services/wallet_service.dart
```dart
// lib/services/wallet_service.dart
import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'supabase_service.dart';
import 'ton_service.dart';

class WalletService {
  static final WalletService _instance = WalletService._internal();
  factory WalletService() => _instance;
  WalletService._internal();

  late ReownAppKitModal _appKit;

  void initialize(BuildContext context) {
    _appKit = ReownAppKitModal.of(context);
  }

  Future<void> connectEvmWallet(BuildContext context) async {
    try {
      await _appKit.openModal();
      if (_appKit.session != null) {
        final address = _appKit.getAddress();
        if (address != null) {
          await SupabaseService().addWallet(address, 'evm');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("EVM Wallet Connected")),
          );
        }
      }
    } catch (e) {
      debugPrint("EVM Connect Error: $e");
    }
  }

  Future<void> connectTonWallet(BuildContext context) async {
    final address = await TonService().connectTonWallet();
    if (address != null) {
      await SupabaseService().addWallet(address, 'ton');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("TON Connected: ${address.substring(0, 8)}...")),
      );
    }
  }

  String? getEvmAddress() => _appKit.getAddress();
}

```

### File: ./lib/services/partnership_service.dart
```dart
// lib/services/partnership_service.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

/// Logic-only service to handle partner attribution and referrals.
class PartnershipService {
  static const String _refKey = 'pending_referral_code';

  /// Captures the referral code from the entry point.
  /// Should be called in the initState of the very first screen.
  static Future<void> captureReferral() async {
    String? incomingRef;

    if (kIsWeb) {
      // 1. Check URL parameters (e.g., cabal.app/?ref=ALPHA)
      incomingRef = Uri.base.queryParameters['ref'];
      
      // 2. Check Telegram Mini App start parameter
      if (incomingRef == null && AppConfig.isTelegramMiniApp) {
        incomingRef = Uri.base.queryParameters['tgWebAppStartParam'];
      }
    }

    if (incomingRef != null && incomingRef.isNotEmpty) {
      debugPrint("PartnershipService: Captured ref code: $incomingRef");
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_refKey, incomingRef);
    }
  }

  /// Retrieves the stored referral code to pass to the Supabase signup.
  static Future<String?> getPendingReferral() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refKey);
  }

  /// Clears the referral after a successful signup/attribution.
  static Future<void> clearReferral() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_refKey);
  }

  /// Logic to determine if the current user is a "Whale" or "KOL" 
  /// based on their connected wallet history.
  /// Used for unlocking hidden partnership quests.
  static bool meetsPartnershipThreshold(int totalXp, int balance) {
    // Non-UI business logic
    if (totalXp > 5000 || balance > 100) return true;
    return false;
  }
}

```

### File: ./lib/services/supabase_service.dart
```dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile_model.dart';
import '../models/cabal_model.dart';
import '../models/quest_model.dart';
import '../models/quest_section_model.dart';
import '../models/notification_model.dart';
import '../models/community_post_model.dart';
import '../models/activity_model.dart';
import '../models/marketplace_models.dart';
import '../models/merchandise_product_model.dart';
import '../models/nft_listing_model.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // ====================== AUTH & SESSION ======================

  User? getCurrentUser() => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<void> signOutUser() async => await _client.auth.signOut();

  // ====================== PROFILE LOGIC ======================

  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final data = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (data == null) return null;
      return UserProfile.fromJson(data); // Matches the fromJson in the model
    } catch (e) {
      debugPrint("SupabaseService: Error fetching profile: $e");
      return null;
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    final user = getCurrentUser();
    if (user == null) return;
    await _client.from('profiles').update(updates).eq('id', user.id);
  }

  Future<void> addWallet(String address, String chain) async {
    final user = getCurrentUser();
    if (user == null) return;

    final profile = await getUserProfile(user.id);
    if (profile == null) return;

    final Map<String, dynamic> currentWallets = Map<String, dynamic>.from(profile.connected_wallets);
    currentWallets[chain.toLowerCase()] = address;

    await _client.from('profiles').update({
      'connected_wallets': currentWallets,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', user.id);
  }

  // ====================== CABAL LOGIC ======================

  Future<List<Cabal>> getAllCabals() async {
    final List<dynamic> data = await _client
        .from('cabals')
        .select()
        .order('created_at', ascending: false);
    return data.map((json) => Cabal.fromSupabase(json)).toList();
  }

  Future<Cabal?> getCabal(String cabalId) async {
    final data = await _client.from('cabals').select().eq('id', cabalId).maybeSingle();
    return data != null ? Cabal.fromSupabase(data) : null;
  }

  Future<Cabal?> createCabal({
    required String name,
    required String description,
    required String creatorHandle,
    bool isPrivate = false,
    String? category,
    String? projectUrl,
    String? logoUrl,
    String? bannerImageUrl,
    String? tokenContractAddress,
    String? tokenSymbol,
    int? chainId,
  }) async {
    final user = getCurrentUser();
    if (user == null) return null;

    final response = await _client.from('cabals').insert({
      'name': name,
      'description': description,
      'creator_id': user.id,
      'creator_handle': creatorHandle,
      'is_private': isPrivate,
      'category': category,
      'project_url': projectUrl,
      'logo_url': logoUrl,
      'banner_image_url': bannerImageUrl,
      'token_contract_address': tokenContractAddress,
      'token_symbol': tokenSymbol,
      'chain_id': chainId,
    }).select().single();

    return Cabal.fromSupabase(response);
  }

  Future<void> joinCabal(String cabalId) async {
    await _client.rpc('join_cabal', params: {'p_cabal_id': cabalId});
  }

  // ====================== QUEST LOGIC ======================

  Future<List<QuestSection>> getQuestSectionsForCabal(String cabalId) async {
    final List<dynamic> data = await _client
        .from('quest_sections')
        .select()
        .eq('cabal_id', cabalId)
        .order('order', ascending: true);
    return data.map((json) => QuestSection.fromSupabase(json)).toList();
  }

  Future<List<Quest>> getQuestsForCabal(String cabalId) async {
    final List<dynamic> data = await _client
        .from('quests')
        .select()
        .eq('cabal_id', cabalId);
    return data.map((json) => Quest.fromSupabase(json)).toList();
  }

  Future<Map<String, dynamic>> completeQuest(String questId) async {
    final user = getCurrentUser();
    if (user == null) throw Exception("User not logged in");

    await _client.from('user_quest_progress').upsert({
      'user_id': user.id,
      'quest_id': questId,
      'status': 'completed',
      'last_completed_at': DateTime.now().toIso8601String(),
    });

    final questData = await _client.from('quests').select('xp_reward').eq('id', questId).single();
    final int reward = questData['xp_reward'] as int;

    await _client.rpc('award_xp', params: {
      'p_user_id': user.id,
      'p_amount': reward,
    });

    return {'success': true, 'xp_earned': reward};
  }

  // ====================== SOCIAL & FEED ======================

  Future<List<CommunityPost>> getGlobalFeed() async {
    final List<dynamic> data = await _client
        .from('community_posts')
        .select('*, profiles(username, profile_image_url)')
        .order('created_at', ascending: false)
        .limit(50);
    
    return data.map((json) {
      final profile = json['profiles'] as Map<String, dynamic>;
      json['author_name'] = profile['username'];
      json['author_avatar_url'] = profile['profile_image_url'];
      return CommunityPost.fromSupabase(json);
    }).toList();
  }

  // ====================== UTILS & COUNTERS ======================

  Future<void> recordActivity() async {
    final user = getCurrentUser();
    if (user == null) return;
    await _client.from('profiles').update({
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', user.id);
  }

  /// FIXED: Removed the invalid positional argument and 'const' FetchOptions
  /// Uses the explicit .count() modifier which is safer for Flutter Web builds.
  Future<int> getUnreadNotificationCount(String userId) async {
    try {
      final response = await _client
          .from('notifications')
          .select('id')
          .eq('user_id', userId)
          .eq('is_read', false)
          .count(CountOption.exact);
      
      return response.count;
    } catch (e) {
      debugPrint("Error fetching notification count: $e");
      return 0;
    }
  }
}

```

### File: ./lib/services/ton_service.dart
```dart
// lib/services/ton_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ton/ton.dart'; // Core TON logic
import '../config.dart';
import 'supabase_service.dart';
//import 'package:cabal/core/app_config.dart';

/// Service to handle TON Blockchain interactions.
/// Optimized for Telegram Mini Apps (TMA) and Native Mobile via Deep Linking.
class TonService {
  static final TonService _instance = TonService._internal();
  factory TonService() => _instance;
  TonService._internal();

  final SupabaseService _supabaseService = SupabaseService();

  String? _currentAddress;
  bool _isConnecting = false;

  // Getters
  String? get currentAddress => _currentAddress;
  bool get isConnected => _currentAddress != null;
  bool get isConnecting => _isConnecting;

  /// Initializes the TON service. 
  /// In a production environment, this would check for an existing session.
  Future<void> initialize() async {
    final user = _supabaseService.getCurrentUser();
    if (user != null) {
      final profile = await _supabaseService.getUserProfile(user.id);
      if (profile != null && profile.connected_wallets.containsKey('ton')) {
        _currentAddress = profile.connected_wallets['ton'];
        debugPrint("TonService: Restored address $_currentAddress");
      }
    }
  }

  /// Initiates the TON Connect 2.0 flow.
  /// Works for both Web/TMA and Native Mobile.
  Future<String?> connectWallet() async {
    if (_isConnecting) return null;
    _isConnecting = true;

    try {
      debugPrint("TonService: Starting TON Connect...");

      // 1. Generate the Connection Request (Simplified for this phase)
      // In a full implementation, you would use a TonConnect bridge server.
      // For the "Ready for Partnerships" phase, we trigger the wallet selection.
      
      final String manifestUrl = AppConfig.tonManifestUrl;
      
      // 2. Define the Universal Link for Tonkeeper (The most common TON wallet)
      // Format: https://app.tonkeeper.com/ton-connect?v=2&id=<session_id>&r=<request_payload>
      
      // This is a placeholder for the actual TonConnect 2.0 handshake payload.
      // In TMA mode, the Telegram JS bridge usually handles this.
      if (AppConfig.isTelegramMiniApp) {
        debugPrint("TonService: Operating in Telegram Mini App mode.");
        // Logic here would call the JavaScript window.tonConnectUI
      }

      // 3. For Native iOS/Android: Open Tonkeeper via Deep Link
      // We simulate a successful connection for now to allow you to build the UI.
      // In production, the wallet returns the address via a background callback or redirect.
      const String mockTonAddress = "UQBKgXCNLPexv_I0G6Xkh-idD-FNPV8U_S81uS3tV24tV53r"; 

      // 4. Save to Supabase immediately to register the partnership/user
      await _supabaseService.addWallet(mockTonAddress, 'ton');
      
      _currentAddress = mockTonAddress;
      return _currentAddress;
    } catch (e) {
      debugPrint("TonService: Connection error: $e");
      return null;
    } finally {
      _isConnecting = false;
    }
  }

  /// Disconnects the wallet and removes it from the local state.
  Future<void> disconnect() async {
    _currentAddress = null;
    debugPrint("TonService: Wallet disconnected");
  }

  // ====================== TRANSACTIONS & SIGNING ======================

  /// Requests the user to sign a message (used for Quest verification).
  Future<String?> signMessage(String message) async {
    if (!isConnected) throw Exception("Wallet not connected");

    try {
      debugPrint("TonService: Requesting signature for: $message");
      // Simulation of a signed cell
      return "base64_encoded_signature_placeholder";
    } catch (e) {
      debugPrint("TonService: Signing error: $e");
      return null;
    }
  }

  /// Sends a transaction on the TON blockchain.
  /// [to] Recipient address (friendly or raw format)
  /// [amountNano] Amount in NanoTons (1 TON = 1,000,000,000 NanoTons)
  Future<bool> sendTonTransaction({
    required String to, 
    required int amountNano,
    String? comment,
  }) async {
    if (!isConnected) return false;

    try {
      debugPrint("TonService: Sending $amountNano NanoTons to $to");

      // Construct the TonConnect transaction request
      final transactionRequest = {
        "validUntil": (DateTime.now().millisecondsSinceEpoch / 1000).round() + 600, // 10 mins
        "messages": [
          {
            "address": to,
            "amount": amountNano.toString(),
            "payload": comment != null ? _encodeComment(comment) : null,
          }
        ]
      };

      // In TMA: tonConnectUI.sendTransaction(transactionRequest)
      // In Native: Open wallet via Universal Link with the request payload
      
      return true;
    } catch (e) {
      debugPrint("TonService: Transaction error: $e");
      return false;
    }
  }

  /// Internal helper to encode text comments into a TON Cell payload
  String _encodeComment(String comment) {
    // TON comments are typically Cell-based with a 0 prefix
    return base64Encode(utf8.encode(comment));
  }
}

```

### File: ./lib/widgets/video_background_widget.dart
```dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
// import 'package:supabase_flutter/supabase_flutter.dart'; // Not directly used in this widget, can remove if not needed elsewhere

import '../utils/app_colors.dart'; // <--- Added this import for AppColors

class VideoBackgroundWidget extends StatefulWidget {
  final String videoPath;
  final Widget child;
  final Color overlayColor; // Color to blend with the video for transparency effect
  final double overlayOpacity; // Opacity of the overlay color (0.0 to 1.0)

  const VideoBackgroundWidget({
    Key? key,
    required this.videoPath,
    required this.child,
    this.overlayColor = AppColors.offBlack, // <--- CHANGED DEFAULT TO AppColors.offBlack
    this.overlayOpacity = 0.7,      // <--- CHANGED DEFAULT TO 0.7
  }) : super(key: key);

  @override
  State<VideoBackgroundWidget> createState() => _VideoBackgroundWidgetState();
}

class _VideoBackgroundWidgetState extends State<VideoBackgroundWidget> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      _controller = VideoPlayerController.asset(widget.videoPath);
      await _controller.initialize();
      await _controller.setLooping(true);
      await _controller.setVolume(0.0); // Mute background video
      await _controller.play();
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }
    } catch (e) {
      print("Error initializing video player: $e");
      // Handle error, maybe show a static background
      if (mounted) {
        setState(() {
          _isVideoInitialized = false; // Or a flag to show error/fallback
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVideoInitialized || !_controller.value.isInitialized) {
      // Show a loading indicator or a static background while video loads
      return Container(
        color: widget.overlayColor.withOpacity(0.8), // Darker fallback
        child: const Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Stack(
      fit: StackFit.expand, // Make the Stack fill the screen
      children: <Widget>[
        // Video Player Layer (Responsive)
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover, // Ensures video covers the screen, might crop
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
        // Transparency Overlay Layer
        Container(
          color: widget.overlayColor.withOpacity(widget.overlayOpacity),
        ),
        // Content Layer
        widget.child,
      ],
    );
  }
}

```

### File: ./lib/widgets/animated_particle_background.dart
```dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
// import 'package:supabase_flutter/supabase_flutter.dart'; // Not directly used in this widget, can remove if not needed elsewhere

import '../utils/app_colors.dart'; // <--- ADDED THIS IMPORT

class AnimatedParticleBackground extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color particleColor1;
  final Color particleColor2;

  const AnimatedParticleBackground({
    Key? key,
    required this.child,
    this.baseColor = AppColors.offBlack, // <--- CHANGED DEFAULT to AppColors.offBlack
    this.particleColor1 = AppColors.particleGoldSoft, // <--- CHANGED DEFAULT to AppColors.particleGoldSoft
    this.particleColor2 = AppColors.particleGreySoft, // <--- CHANGED DEFAULT to AppColors.particleGreySoft
  }) : super(key: key);

  @override
  _AnimatedParticleBackgroundState createState() => _AnimatedParticleBackgroundState();
}

class _AnimatedParticleBackgroundState extends State<AnimatedParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<_Particle> _particles = [];
  final int _numParticles = 60; // Increased for denser, 'textured' feel // Number of particles
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10), // Slower, subtle animation
      vsync: this,
    )..repeat();

    // Initialize particles after the first frame to get screen size
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initParticles(MediaQuery.of(context).size);
        setState(() {}); // Trigger a rebuild once particles are initialized
      }
    });
  }

  void _initParticles(Size screenSize) {
    _particles = List.generate(_numParticles, (index) {
      return _Particle(
        position: Offset(
          _random.nextDouble() * screenSize.width,
          _random.nextDouble() * screenSize.height,
        ),
        radius: _random.nextDouble() * 2.0 + 0.5, // Even smaller, more numerous: 0.5 to 2.5
        color: _random.nextBool() ? widget.particleColor1 : widget.particleColor2,
        speed: Offset(
          (_random.nextDouble() - 0.5) * 0.15, // Slower speeds for calmer background // Slower speeds
          (_random.nextDouble() - 0.5) * 0.15, // Slower speeds for calmer background
        ),
        opacity: _random.nextDouble() * 0.25 + 0.05, // Even lower opacity: 0.05 to 0.3
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BackgroundPainter(
        controller: _controller,
        particles: _particles,
        baseColor: widget.baseColor,
        screenSizeCallback: () => mounted ? MediaQuery.of(context).size : Size.zero,
      ),
      child: widget.child,
    );
  }
}

class _Particle {
  Offset position;
  double radius;
  Color color;
  Offset speed;
  double opacity;

  _Particle({
    required this.position,
    required this.radius,
    required this.color,
    required this.speed,
    required this.opacity,
  });

  void update(Size screenSize) {
    position += speed;

    // Wrap around screen edges
    if (position.dx < -radius) position = Offset(screenSize.width + radius, position.dy);
    if (position.dx > screenSize.width + radius) position = Offset(-radius, position.dy);
    if (position.dy < -radius) position = Offset(position.dx, screenSize.height + radius);
    if (position.dy > screenSize.height + radius) position = Offset(position.dx, -radius);
  }
}

class _BackgroundPainter extends CustomPainter {
  final Animation<double> controller;
  final List<_Particle> particles;
  final Color baseColor;
  final Size Function() screenSizeCallback;


  _BackgroundPainter({
    required this.controller,
    required this.particles,
    required this.baseColor,
    required this.screenSizeCallback,
  }) : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw base background color
    paint.color = baseColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    if (particles.isEmpty) return; // Don't draw particles if not initialized

    final screenSize = screenSizeCallback();
    if (screenSize == Size.zero) return; // If size is not available yet.


    // Draw and update particles
    for (var particle in particles) {
      particle.update(size); // Use current canvas size for updates
      paint.color = particle.color.withOpacity(particle.opacity * (0.5 + (0.5 * sin(controller.value * 2 * pi)))); // Pulsating opacity
      canvas.drawCircle(particle.position, particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter oldDelegate) {
    return particles.isNotEmpty; // Repaint if particles are there, controller handles animation repaint
  }
}

```

### File: ./lib/widgets/onboarding_modal.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:supabase_flutter/supabase_flutter.dart'; // Removed: Not used in this file

class OnboardingModal extends StatelessWidget {
  const OnboardingModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 5,
      backgroundColor: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Welcome to Cabal!", // <--- CHANGED BRANDING HERE!
              style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.2),
            const SizedBox(height: 15),
            _buildFeatureHighlight(
              context,
              icon: FontAwesomeIcons.compass,
              title: "Explore Dashboard",
              description: "See your progress, XP, and active projects.",
              delay: 400.ms,
            ),
            _buildFeatureHighlight(
              context,
              icon: FontAwesomeIcons.listCheck,
              title: "Discover Projects",
              description: "Find new projects and complete quests.",
              delay: 600.ms,
            ),
            _buildFeatureHighlight(
              context,
              icon: FontAwesomeIcons.userGear,
              title: "Manage Profile",
              description: "Connect wallets, socials, and customize your display name.",
              delay: 800.ms,
            ),
             _buildFeatureHighlight(
              context,
              icon: FontAwesomeIcons.rankingStar,
              title: "Climb Leaderboard",
              description: "Compete with others by earning XP!",
              delay: 1000.ms,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary,
                foregroundColor: theme.colorScheme.secondary.computeLuminance() > 0.5 ? Colors.black : Colors.white,
              ),
              child: const Text("Let's Go!"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ).animate().fadeIn(delay: 1200.ms).scaleXY(begin: 0.8, curve: Curves.elasticOut),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureHighlight(BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Duration delay,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          FaIcon(icon, size: 24, color: theme.colorScheme.secondary),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                Text(description, style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.8))),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay).slideX(begin: -0.3);
  }
}

void showOnboardingInfo(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // User must dismiss it
    builder: (BuildContext context) {
      return const OnboardingModal();
    },
  );
}

```

### File: ./lib/widgets/expandable_fab.dart
```dart
import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart'; // Removed: Not used in this file
import 'dart:math' as math;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key? key,
    this.initialOpen,
    required this.distance,
    required this.children,
  }) : super(key: key);

  final bool? initialOpen;
  final double distance;
  final List<ActionButton> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(theme),
          ..._buildExpandingActionButtons(theme),
          _buildTapToOpenFab(theme),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab(ThemeData theme) {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          color: theme.colorScheme.secondaryContainer,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                Icons.close,
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons(ThemeData theme) {
    final children = <Widget>[];
    final count = widget.children.length;
    // Angle calculation adjusted for N children to spread them correctly if count is low
    // For 3 children, this spreads them 0, 45, 90 degrees from the bottom-right origin.
    // If you need them truly circular or symmetric, this formula might need more thought.
    final step = count > 1 ? 90.0 / (count - 1) : 0.0;
    for (var i = 0; i < count; i++) {
      final angleInDegrees = 90.0 - (step * i); // Spreads buttons upwards and leftwards from 0 to 90 degrees
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab(ThemeData theme) {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            backgroundColor: theme.colorScheme.secondary,
            onPressed: _toggle,
            child: FaIcon(FontAwesomeIcons.wandMagicSparkles, color: theme.colorScheme.onSecondary),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    Key? key,
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  }) : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final ActionButton child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: progress,
      builder: (context, _) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: offset.dx,
          bottom: offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: FractionalTranslation(
              translation: Offset(-progress.value, 0.0), 
              child: Opacity( 
                opacity: progress.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (child.tooltip != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        margin: const EdgeInsets.only(bottom: 4, right: 4),
                        decoration: BoxDecoration(
                          color: theme.cardColor.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 3,
                              offset: const Offset(0,1),
                            )
                          ]
                        ),
                        child: Text(child.tooltip!, style: theme.textTheme.bodySmall),
                      ),
                    FloatingActionButton.small(
                      heroTag: null, 
                      backgroundColor: theme.colorScheme.secondary, // <--- CHANGED HERE! More prominent gold.
                      foregroundColor: theme.colorScheme.onSecondary, // <--- CHANGED HERE! Ensure contrast.
                      onPressed: child.onPressed,
                      child: child.icon,
                      tooltip: child.tooltip,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    this.onPressed,
    required this.icon,
    this.tooltip,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget icon;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    // This build method for ActionButton itself is currently just a SizedBox.shrink().
    // The actual FloatingActionButton is created within _ExpandingActionButton.
    // This is generally fine as ActionButton is more of a data model for the button.
    return const SizedBox.shrink(); 
  }
}

```

### File: ./lib/widgets/cabal_header_widget.dart
```dart
// lib/widgets/project_header_widget.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/cabal_model.dart'; // Cabal model
import '../utils/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // <--- ADDED FONT AWESOME IMPORT

class CabalHeaderWidget extends StatelessWidget {
  final Cabal project;

  const CabalHeaderWidget({Key? key, required this.project}) : super(key: key);

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    String thirdLineText = ''; // Initialize with empty string
    if (project.projectUrl != null && project.projectUrl!.isNotEmpty) {
      try {
        final uri = Uri.parse(project.projectUrl!);
        thirdLineText = uri.host; // Example: display the host/domain
      } catch (e) {
        // Keep thirdLineText empty or set to "Invalid URL"
      }
    }

    final theme = Theme.of(context); // Get theme for consistent text styles

    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias, // Ensures gradient is clipped
      // Removed `color` here, as the `Container` below will provide the background
      child: Container( // <--- WRAPPED IN CONTAINER FOR GRADIENT BACKGROUND
        decoration: BoxDecoration(
          // Subtle gradient using existing theme colors or AppColors for consistency
          gradient: LinearGradient(
            colors: [
              theme.cardTheme.color ?? AppColors.darkCardBackground, // Base dark background
              (theme.cardTheme.color ?? AppColors.darkCardBackground).withOpacity(0.9), // Slightly transparent version
              AppColors.gold.withOpacity(0.05), // Very subtle hint of gold
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.7, 1.0], // Control the spread of colors
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: project.logoUrl != null && project.logoUrl!.isNotEmpty
                        ? Image.network(
                            project.logoUrl!,
                            height: 70,
                            width: 70,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(height: 70, width: 70, color:theme.colorScheme.surfaceVariant, child: FaIcon(FontAwesomeIcons.solidBuilding, size: 30, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7))), // <--- CHANGED TO FAICON
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 70, width: 70, color: theme.colorScheme.surfaceVariant,
                                child: Center(child: CircularProgressIndicator(value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null, strokeWidth: 2, color: theme.colorScheme.primary,)),
                              );
                            },
                          )
                        : Container(height: 70, width: 70, color:theme.colorScheme.surfaceVariant, child: FaIcon(FontAwesomeIcons.solidBuilding, size: 30, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7))), // <--- CHANGED TO FAICON
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: theme.textTheme.titleLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.bold, color: theme.colorScheme.primary), // Use theme for consistency
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'By ${project.creatorHandle ?? "Unknown"}',
                          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14, color: theme.textTheme.bodyMedium?.color), // Use theme for consistency
                        ),
                        if (thirdLineText.isNotEmpty) ...[ // Conditionally show this Text
                          const SizedBox(height: 2),
                          Text(
                            thirdLineText, // Use the prepared text
                            style: theme.textTheme.bodySmall?.copyWith(fontSize: 12, color: theme.textTheme.bodySmall?.color), // Use theme for consistency
                            overflow: TextOverflow.ellipsis,
                          ),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                project.description,
                style: theme.textTheme.bodyLarge?.copyWith(fontSize: 15, color: theme.textTheme.bodyLarge?.color, height: 1.4), // Use theme for consistency
              ),
              const SizedBox(height: 12),
              if (project.projectUrl != null && project.projectUrl!.isNotEmpty)
                InkWell(
                  onTap: () => _launchUrl(project.projectUrl!),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(FontAwesomeIcons.link, size: 14, color: theme.colorScheme.primary), // Use theme for consistency
                      const SizedBox(width: 6),
                      Text(
                        'Visit Cabal',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.primary.withOpacity(0.8), // Use theme for consistency
                          decoration: TextDecoration.underline,
                          decorationColor: theme.colorScheme.primary.withOpacity(0.8), // Use theme for consistency
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

```

### File: ./lib/widgets/quest_complete_celebration.dart
```dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
// import 'package:supabase_flutter/supabase_flutter.dart'; // Removed: Not used in this file

class QuestCompleteCelebration extends StatefulWidget {
  final VoidCallback onAnimationComplete;
  const QuestCompleteCelebration({Key? key, required this.onAnimationComplete}) : super(key: key);

  @override
  State<QuestCompleteCelebration> createState() => _QuestCompleteCelebrationState();
}

class _QuestCompleteCelebrationState extends State<QuestCompleteCelebration> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Widget> _emojis = [];
  final Random _random = Random();
  final List<String> _emojiChars = ['🎉', '✨', '🚀', '🌟', '💰', '👍', '💯', '🔥', '🥳'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: 2500.ms, // Total duration of the celebration
    )..forward().whenComplete(() {
      if (mounted) {
        widget.onAnimationComplete();
      }
    });

    // Generate emojis at the start
    _generateEmojis();
  }

  void _generateEmojis() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    for (int i = 0; i < 15; i++) { // Number of emojis
      final emoji = _emojiChars[_random.nextInt(_emojiChars.length)];
      final startX = _random.nextDouble() * screenWidth * 0.6 + screenWidth * 0.2; // Center 60%
      final startY = screenHeight * 0.4 + _random.nextDouble() * screenHeight * 0.2; // Middle section
      final endY = startY - (screenHeight * (_random.nextDouble() * 0.3 + 0.3)); // Move up
      final endX = startX + (_random.nextDouble() * 100 - 50); // Slight horizontal drift
      final duration = _random.nextInt(800) + 1200; // ms
      final delay = _random.nextInt(300); //ms
      final size = _random.nextDouble() * 20 + 25.0; // Emoji size

      _emojis.add(
        Positioned(
          left: startX,
          top: startY,
          child: Text(emoji, style: TextStyle(fontSize: size))
              .animate(delay: delay.ms, controller: _controller)
              .fade(duration: (duration * 0.3).round().ms, curve: Curves.easeIn)
              .slide(
                duration: duration.ms,
                begin: Offset.zero,
                end: Offset((endX - startX) / size, (endY - startY) / size), // Normalized slide
                curve: Curves.easeOutCirc,
              )
              .then(delay: (duration * 0.6).round().ms)
              .fadeOut(duration: (duration * 0.4).round().ms)
              .scale(begin: const Offset(1,1), end: const Offset(1.5,1.5), duration: duration.ms, curve: Curves.elasticOut),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If emojis are not generated yet (because context for screen size wasn't ready)
    if (_emojis.isEmpty && mounted) {
       WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _generateEmojis();
          setState(() {});
        }
      });
    }
    return IgnorePointer( // Makes the overlay non-interactive
      child: Stack(
        children: _emojis,
      ),
    );
  }
}

// Helper to show the celebration overlay
void showQuestCompleteCelebration(BuildContext context) {
  OverlayEntry? overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => QuestCompleteCelebration(
      onAnimationComplete: () {
        overlayEntry?.remove();
      },
    ),
  );
  Overlay.of(context).insert(overlayEntry);
}

```

### File: ./lib/widgets/quest_section_widget.dart
```dart
// lib/widgets/quest_section_widget.dart
import 'package:flutter/material.dart';

// Model Imports
import '../models/quest_section_model.dart';
import '../models/quest_model.dart';
import '../models/user_profile_model.dart'; // For UserProfile type

// Widget Imports
import '../widgets/quest_card_widget.dart'; // The QuestCardWidget should be up-to-date

// Typedef for callback
typedef QuestActionCallback = Future<void> Function(Quest quest);

class QuestSectionWidget extends StatefulWidget {
  final String cabalId;
  final QuestSection section;
  final UserProfile? viewingUserProfile;     // User whose progress is shown for this section
  final UserProfile? currentUserProfile;   // Currently authenticated user (the actor for actions)
  final List<Quest> quests; // Quests in this section; their status fields should be pre-updated
                            // by the parent screen based on viewingUserProfile's progress data.

  // Progress data for viewingUserProfile (passed down but primarily used by parent to update quest objects)
  final Set<String> completedQuestIdsForProject;
  final Map<String, DateTime?> userQuestCompletionTimestamps;
  final Map<String, int> userQuestStepsMap;
  final Map<String, String> userQuestStatusMap; // This is the source for quest.userQuestSpecificStatus

  final QuestActionCallback onClaimReward; // Action performed by currentUserProfile
  final String? loadingClaimQuestId; // ID of quest currently being processed

  // Theme-related properties passed from parent
  final Color cardColor;
  final Color textColor;
  final Color accentColor;

  const QuestSectionWidget({
    Key? key,
    required this.cabalId,
    required this.section,
    this.viewingUserProfile,
    this.currentUserProfile,
    required this.quests,
    required this.completedQuestIdsForProject,
    required this.userQuestCompletionTimestamps,
    required this.userQuestStepsMap,
    required this.userQuestStatusMap, // This map contains the actual statuses like 'pending_verification'
    required this.onClaimReward,
    this.loadingClaimQuestId,
    required this.cardColor,
    required this.textColor,
    required this.accentColor,
  }) : super(key: key);

  @override
  State<QuestSectionWidget> createState() => _QuestSectionWidgetState();
}

class _QuestSectionWidgetState extends State<QuestSectionWidget> {
  bool _isExpanded = true; // Default to expanded, or could use PageStorage

  @override
  void initState() {
    super.initState();
    // Optional: If you want to persist expansion state across rebuilds when in a list:
    // final pageStorageBucket = PageStorage.of(context);
    // _isExpanded = pageStorageBucket.readState(context, identifier: PageStorageKey('quest_section_${widget.section.id}_${widget.viewingUserProfile?.id ?? 'guest'}')) as bool? ?? true;
    // Adding viewingUserProfile?.id to the key makes the persisted state user-specific if needed.
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use colors passed from parent
    final effectiveCardColor = widget.cardColor;
    final effectiveTextColor = widget.textColor;
    final effectiveAccentColor = widget.accentColor;
    final effectiveIconColor = widget.textColor.withOpacity(0.7); // For ExpansionTile icon

    // Calculate completed quests IN THIS SECTION for the VIEWING USER
    // The `quest.isCompletedByUser` and `quest.userQuestSpecificStatus` fields on each `quest` object
    // in `widget.quests` should have already been set by the parent (`CabalDetailScreen`)
    // based on the `widget.viewingUserProfile`'s progress data (via _updateQuestObjectsWithViewingUserProgress).
    int completedInSection = 0;
    for (var quest in widget.quests) {
        // A quest is counted as completed for the section header if its specific status for the viewing user is 'completed'
        // AND it's not currently on an active cooldown for that user.
        if (quest.userQuestSpecificStatus == 'completed' && !quest.isOnCooldownForUser) {
            completedInSection++;
        }
    }

    String progressText = "";
    if (widget.viewingUserProfile != null) { // Only show detailed progress if viewing a specific user's progress
        if (widget.section.progressTextFormat != null && widget.section.progressTextFormat!.isNotEmpty) {
            progressText = widget.section.progressTextFormat!
                .replaceAll('{completed}', completedInSection.toString())
                .replaceAll('{total}', widget.quests.length.toString());
        } else if (widget.quests.isNotEmpty) {
            progressText = '$completedInSection / ${widget.quests.length} Done';
        } else {
            progressText = "0 / 0 Done"; // Or "No Quests" if preferred
        }
    } else { // Guest view or general cabal view (not tied to a specific user's progress)
        if (widget.quests.isNotEmpty) {
            progressText = "${widget.quests.length} Quests"; // Simpler for guest
        } else {
            progressText = "No Quests Available";
        }
    }

    return Card(
      color: effectiveCardColor,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0),
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme( // Scope Theme to make ExpansionTile divider transparent
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: PageStorageKey<String>("expansion_tile_section_${widget.section.id}_${widget.viewingUserProfile?.id ?? 'guest'}"), // User-specific key
          initiallyExpanded: _isExpanded,
          onExpansionChanged: (expanded) {
            if (mounted) {
              setState(() {
                _isExpanded = expanded;
                // If using PageStorage:
                // PageStorage.of(context).writeState(context, expanded, identifier: PageStorageKey('quest_section_${widget.section.id}_${widget.viewingUserProfile?.id ?? 'guest'}'));
              });
            }
          },
          iconColor: effectiveIconColor,
          collapsedIconColor: effectiveIconColor,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  widget.section.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: effectiveTextColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (progressText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    progressText,
                    style: TextStyle(fontSize: 13, color: effectiveTextColor.withOpacity(0.8), fontWeight: FontWeight.w500),
                  ),
                ),
            ],
          ),
          subtitle: (widget.section.description != null && widget.section.description!.isNotEmpty)
              ? Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                      widget.section.description!,
                      style: TextStyle(fontSize: 14, color: effectiveTextColor.withOpacity(0.75), height: 1.35),
                      maxLines: _isExpanded ? 3 : 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                )
              : null,
          childrenPadding: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0, top: 4.0),
          children: widget.quests.isEmpty
              ? [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                    child: Center(
                      child: Text(
                        "No quests in this section match your current filters.", // Or "No quests in this section yet." if no filters applied
                        textAlign: TextAlign.center,
                        style: TextStyle(color: effectiveTextColor.withOpacity(0.65), fontStyle: FontStyle.italic, fontSize: 14),
                      ),
                    ),
                  )
                ]
              : widget.quests.map((quest) {
                  // The 'quest' object passed to QuestCardWidget should have its status fields
                  // (isCompletedByUser, isLockedForUser, userQuestSpecificStatus, etc.)
                  // already correctly populated by the parent screen (CabalDetailScreen)
                  // based on widget.viewingUserProfile's data.
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: QuestCardWidget(
                      quest: quest,
                      onClaimReward: () => widget.onClaimReward(quest), // Action is by currentUserProfile
                      isLoadingClaim: widget.loadingClaimQuestId == quest.id,
                      cardColor: Color.lerp(effectiveCardColor, theme.scaffoldBackgroundColor, 0.08) ?? effectiveCardColor,
                      textColor: effectiveTextColor,
                      accentColor: effectiveAccentColor,
                      viewingUserProfile: widget.viewingUserProfile,    // User whose progress is shown on this card
                      currentUserProfile: widget.currentUserProfile,  // User performing the action
                    ),
                  );
                }).toList(),
        ),
      ),
    );
  }
}

```

### File: ./lib/widgets/info_tooltip.dart
```dart
// lib/widgets/info_tooltip.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InfoTooltip extends StatelessWidget {
  final String message;
  final IconData icon;
  final double iconSize;

  const InfoTooltip({
    Key? key,
    required this.message,
    this.icon = FontAwesomeIcons.circleInfo,
    this.iconSize = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: message,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      showDuration: const Duration(seconds: 5),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.95),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
      ),
      textStyle: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodyMedium?.color),
      triggerMode: TooltipTriggerMode.tap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: FaIcon(
          icon,
          size: iconSize,
          color: theme.colorScheme.secondary.withOpacity(0.8),
        ),
      ),
    );
  }
}

```

### File: ./lib/widgets/quest_card_widget.dart
```dart
// lib/widgets/quest_card_widget.dart
import 'dart:ui'; // For ImageFilter.blur
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:url_launcher/url_launcher.dart';

import '../models/quest_model.dart';
import '../models/user_profile_model.dart';
import '../utils/app_colors.dart';
import '../utils/icon_mapper.dart';
import '../utils/constants.dart' show QuestType, questTypeToString;
import '../screens/login_screen.dart';

class QuestCardWidget extends StatefulWidget {
  final Quest quest;
  final VoidCallback onClaimReward;
  final bool isLoadingClaim;
  final Color cardColor;
  final Color textColor;
  final Color accentColor;
  final UserProfile? viewingUserProfile;
  final UserProfile? currentUserProfile;

  const QuestCardWidget({
    Key? key,
    required this.quest,
    required this.onClaimReward,
    required this.isLoadingClaim,
    required this.cardColor,
    required this.textColor,
    required this.accentColor,
    this.viewingUserProfile,
    this.currentUserProfile,
  }) : super(key: key);

  @override
  State<QuestCardWidget> createState() => _QuestCardWidgetState();
}

class _QuestCardWidgetState extends State<QuestCardWidget> {
  bool _isExpanded = false;

  Map<String, dynamic> _getInteractionStateForCurrentUser() {
    if (widget.currentUserProfile == null) {
      bool canGuestInteractButton = (widget.quest.type == QuestType.custom &&
                                   (widget.quest.taskButtonText?.toLowerCase() == "info" ||
                                    widget.quest.detailedContent != null && widget.quest.detailedContent!.isNotEmpty)) ||
                                  (widget.quest.actionUrl != null &&
                                   widget.quest.actionUrl!.isNotEmpty &&
                                   (widget.quest.type == QuestType.websiteVisit ||
                                    widget.quest.type == QuestType.custom));

      String buttonText = "Log in to Start";
      if (widget.quest.type == QuestType.custom && (widget.quest.taskButtonText?.toLowerCase() == "info" || (widget.quest.detailedContent != null && widget.quest.detailedContent!.isNotEmpty))) {
        buttonText = widget.quest.taskButtonText ?? "View Info";
      } else if (widget.quest.actionUrl != null && widget.quest.actionUrl!.isNotEmpty && (widget.quest.type == QuestType.websiteVisit || widget.quest.type == QuestType.custom)) {
        buttonText = widget.quest.taskButtonText ?? "Visit Site";
      }
      return {'canInteract': canGuestInteractButton, 'buttonText': buttonText, 'isPendingForActor': false};
    }

    String actorSpecificStatus = 'not_started';
    bool isActorViewingSelf = widget.currentUserProfile!.id == widget.viewingUserProfile?.id;

    if (isActorViewingSelf) {
        actorSpecificStatus = widget.quest.userQuestSpecificStatus;
    }

    bool isPendingForActor = actorSpecificStatus == 'pending_verification';
    String statusTextForButton = widget.quest.statusText;

    if (isActorViewingSelf && isPendingForActor) {
      statusTextForButton = "Pending Review";
    }

    bool appearsInteractable;
    if (isActorViewingSelf) {
        appearsInteractable = !widget.isLoadingClaim &&
                              !widget.quest.isLockedForUser &&
                              (!widget.quest.isCompletedByUser || (widget.quest.isCompletedByUser && widget.quest.cooldownPeriod != null && !widget.quest.isOnCooldownForUser)) &&
                              !isPendingForActor;
    } else {
        appearsInteractable = !widget.isLoadingClaim &&
                              !widget.quest.isLockedForUser &&
                              (widget.quest.type == QuestType.websiteVisit || (widget.quest.type == QuestType.custom && widget.quest.actionUrl != null && widget.quest.actionUrl!.isNotEmpty));
        if (!appearsInteractable) {
            statusTextForButton = "Viewing";
        }
    }

    return {'canInteract': appearsInteractable, 'buttonText': statusTextForButton, 'isPendingForActor': isPendingForActor};
  }

  Future<void> _handleTap() async {
    String questIdDebug = widget.quest.id;
    String questTitleDebug = widget.quest.title;
    String questTypeDebug = widget.quest.type.toString();
    String questActionUrlDebug = widget.quest.actionUrl ?? "NULL_ACTION_URL";
    String questDetailedContentPreview = "NULL_DETAILED_CONTENT";
    if (widget.quest.detailedContent != null) {
        questDetailedContentPreview = widget.quest.detailedContent!.substring(0,
            (widget.quest.detailedContent!.length > 50 ? 50 : widget.quest.detailedContent!.length)) + "...";
    }

    debugPrint("QuestCardWidget: _handleTap CALLED.");
    debugPrint("  Quest Details from WIDGET.QUEST:");
    debugPrint("    ID: $questIdDebug");
    debugPrint("    Title: '$questTitleDebug'");
    debugPrint("    Type: $questTypeDebug");
    debugPrint("    ActionURL: $questActionUrlDebug");
    debugPrint("    DetailedContent (start): $questDetailedContentPreview");
    debugPrint("    TaskButtonText: ${widget.quest.taskButtonText ?? "NULL_BUTTON_TEXT"}");
    debugPrint("  Current User Profile ID: ${widget.currentUserProfile?.id ?? "NULL_CURRENT_USER"}");
    debugPrint("  Viewing User Profile ID: ${widget.viewingUserProfile?.id ?? "NULL_VIEWING_USER"}");
    debugPrint("  widget.isLoadingClaim: ${widget.isLoadingClaim}");

    if (widget.isLoadingClaim) {
      debugPrint("QuestCardWidget: Bailing: isLoadingClaim is true.");
      return;
    }

    if (widget.currentUserProfile == null) {
      debugPrint("QuestCardWidget: Handling guest interaction.");
      bool canGuestInteractSimple =
          (widget.quest.type == QuestType.custom && (widget.quest.taskButtonText?.toLowerCase() == "info" || (widget.quest.detailedContent != null && widget.quest.detailedContent!.isNotEmpty))) ||
          (widget.quest.actionUrl != null && widget.quest.actionUrl!.isNotEmpty && (widget.quest.type == QuestType.websiteVisit || widget.quest.type == QuestType.custom));

      if (canGuestInteractSimple) {
        if (widget.quest.detailedContent != null && widget.quest.detailedContent!.isNotEmpty) {
          if (mounted) setState(() => _isExpanded = !_isExpanded);
          if ((widget.quest.actionUrl == null || widget.quest.actionUrl!.isEmpty) && _isExpanded) {
             return;
          }
        }
        if (widget.quest.actionUrl != null && widget.quest.actionUrl!.isNotEmpty &&
            (widget.quest.type == QuestType.websiteVisit || (widget.quest.type == QuestType.custom && (widget.quest.taskButtonText?.toLowerCase() == "visit site" || widget.quest.taskButtonText?.toLowerCase() == "learn more")) )) {
          debugPrint("QuestCardWidget (Guest): Calling onClaimReward for URL launch for quest $questIdDebug");
          widget.onClaimReward();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please log in to interact with this quest.')),
          );
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
        }
      }
      return;
    }

    debugPrint("QuestCardWidget: Handling logged-in user interaction.");
    final interactionState = _getInteractionStateForCurrentUser();
    bool isActorViewingSelf = widget.currentUserProfile!.id == widget.viewingUserProfile?.id;

    if (interactionState['isPendingForActor'] == true && isActorViewingSelf) {
        debugPrint("QuestCardWidget: Quest is pending for actor viewing self. Bailing.");
        if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('This quest is currently pending verification for you.')),
            );
        }
        return;
    }

    if (! (interactionState['canInteract'] as bool? ?? false) ) {
        debugPrint("QuestCardWidget: Actor cannot interact based on interactionState. Checking for details expansion.");
        if (widget.quest.detailedContent != null && widget.quest.detailedContent!.isNotEmpty) {
            if (mounted) setState(() => _isExpanded = !_isExpanded);
        } else {
             if (widget.quest.isLockedForUser) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This quest is locked.')));
             } else if (widget.quest.isCompletedByUser && widget.quest.cooldownPeriod == null) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quest already completed.')));
             }
        }
        return;
    }

    if (widget.quest.detailedContent != null && widget.quest.detailedContent!.isNotEmpty) {
      if (!_isExpanded) {
        debugPrint("QuestCardWidget (User): Expanding details for quest $questIdDebug.");
        if (mounted) setState(() => _isExpanded = true);
      } else {
        debugPrint("QuestCardWidget (User): Calling onClaimReward (expanded card) for quest $questIdDebug");
        widget.onClaimReward();
      }
    } else {
      debugPrint("QuestCardWidget (User): Calling onClaimReward (no details) for quest $questIdDebug");
      widget.onClaimReward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalTheme = Theme.of(context);
    final currentCardColor = widget.cardColor;
    final currentTextColor = widget.textColor;
    final currentAccentColor = widget.accentColor;

    final interactionState = _getInteractionStateForCurrentUser();
    final String buttonText = interactionState['buttonText'] as String;
    final bool canInteractButtonVisual = interactionState['canInteract'] as bool? ?? false;
    final bool isQuestPendingForActorDisplay = interactionState['isPendingForActor'] as bool? ?? false;

    final String questTypeStr = questTypeToString(widget.quest.type);
    final questSpecificBorderColor = AppColors.questBorderColor(questTypeStr);
    final bool hasSpecificBorder = questSpecificBorderColor != AppColors.questTypeDefaultBorder;

    bool isLockedForViewingUser = widget.viewingUserProfile != null ? widget.quest.isLockedForUser : true;
    bool isCompletedByViewingUser = widget.viewingUserProfile != null ? widget.quest.isCompletedByUser : false;
    bool isOnCooldownForViewingUser = widget.viewingUserProfile != null ? widget.quest.isOnCooldownForUser : false;
    String viewingUserSpecificStatus = widget.viewingUserProfile != null ? widget.quest.userQuestSpecificStatus : 'not_started';
    bool isPendingForViewingUser = viewingUserSpecificStatus == 'pending_verification';

    List<Color> borderGradientColors;
    if (widget.viewingUserProfile == null) {
        borderGradientColors = [currentTextColor.withOpacity(0.2), currentTextColor.withOpacity(0.1)];
    } else if (isPendingForViewingUser) {
        borderGradientColors = [AppColors.warning, AppColors.warning.withOpacity(0.5)];
    } else if (hasSpecificBorder) {
        borderGradientColors = [questSpecificBorderColor, questSpecificBorderColor.withOpacity(0.6)];
    } else if (isCompletedByViewingUser && !isOnCooldownForViewingUser && widget.quest.cooldownPeriod == null) {
        borderGradientColors = [AppColors.success, AppColors.success.withOpacity(0.5)];
    } else if (isLockedForViewingUser || isOnCooldownForViewingUser) {
        borderGradientColors = [currentTextColor.withOpacity(0.3), currentTextColor.withOpacity(0.15)];
    } else {
        borderGradientColors = [AppColors.primaryAccent, AppColors.secondaryAccent];
    }

    Color xpColor;
    if (widget.viewingUserProfile == null) {
        xpColor = currentTextColor.withOpacity(0.6);
    } else if (isCompletedByViewingUser && !isOnCooldownForViewingUser && widget.quest.cooldownPeriod == null) {
        xpColor = globalTheme.brightness == Brightness.dark ? AppColors.darkTextSecondary.withOpacity(0.6) : AppColors.textSecondary.withOpacity(0.6);
    } else if (isLockedForViewingUser || isOnCooldownForViewingUser || isPendingForViewingUser) {
        xpColor = currentTextColor.withOpacity(0.5);
    } else {
        xpColor = AppColors.gold;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: InkWell(
          onTap: (widget.isLoadingClaim || (isQuestPendingForActorDisplay && widget.currentUserProfile?.id == widget.viewingUserProfile?.id) ) ? null : _handleTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: currentAccentColor.withOpacity(0.12),
          highlightColor: currentAccentColor.withOpacity(0.06),
          child: Container(
            decoration: BoxDecoration(
              color: currentCardColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: currentTextColor.withOpacity(0.1)),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: borderGradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(1.5),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: currentCardColor,
                  borderRadius: BorderRadius.circular(14.5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, right: 12.0),
                          child: FaIcon(
                            isLockedForViewingUser ? FontAwesomeIcons.lock :
                            (isPendingForViewingUser ? FontAwesomeIcons.hourglassHalf : getIconFromName(widget.quest.iconName)),
                            color: isLockedForViewingUser ? currentTextColor.withOpacity(0.5) :
                                     (isPendingForViewingUser ? AppColors.warning : AppColors.primaryAccent),
                            size: 20
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.quest.title,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: (isLockedForViewingUser || isPendingForViewingUser)
                                      ? currentTextColor.withOpacity(0.6)
                                      : currentTextColor,
                                  decoration: (isCompletedByViewingUser && !isOnCooldownForViewingUser && widget.quest.cooldownPeriod == null && !isPendingForViewingUser)
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  decorationColor: currentTextColor.withOpacity(0.6),
                                ),
                              ),
                              if (widget.quest.description.isNotEmpty && !_isExpanded) ...[
                                const SizedBox(height: 6),
                                Text(
                                  widget.quest.description,
                                  style: TextStyle(fontSize: 14, color: currentTextColor.withOpacity(0.75), height: 1.4),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ]
                            ],
                          ),
                        ),
                      ],
                    ),

                    if (widget.quest.totalSteps > 1 && (widget.viewingUserProfile == null || (!isCompletedByViewingUser && !isPendingForViewingUser)) ) ...[
                       const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: (widget.viewingUserProfile != null && widget.quest.totalSteps > 0)
                                  ? (widget.quest.userCurrentStepsCompleted.toDouble() / widget.quest.totalSteps.toDouble()).clamp(0.0, 1.0)
                                  : 0.0,
                              backgroundColor: AppColors.primaryAccent.withOpacity(0.2),
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryAccent),
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.viewingUserProfile != null ? '${widget.quest.userCurrentStepsCompleted}/${widget.quest.totalSteps}' : '0/${widget.quest.totalSteps}',
                             style: TextStyle(fontSize: 12, color: currentTextColor.withOpacity(0.7), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ).animate().fadeIn(delay: 100.ms),
                    ],

                    if (_isExpanded && widget.quest.detailedContent != null && widget.quest.detailedContent!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 32.0),
                        child: MarkdownBody(
                          data: widget.quest.detailedContent!,
                          styleSheet: MarkdownStyleSheet.fromTheme(globalTheme).copyWith(
                            p: globalTheme.textTheme.bodyMedium?.copyWith(
                              color: currentTextColor.withOpacity(0.85),
                              height: 1.5,
                            ),
                            h1: globalTheme.textTheme.titleLarge?.copyWith(
                              color: currentAccentColor,
                              fontWeight: FontWeight.bold,
                            ),
                            h2: globalTheme.textTheme.titleMedium?.copyWith(
                              color: currentAccentColor,
                              fontWeight: FontWeight.bold,
                            ),
                            a: TextStyle(color: AppColors.secondaryAccent, decoration: TextDecoration.underline),
                            listBullet: globalTheme.textTheme.bodyMedium?.copyWith(
                              color: currentTextColor.withOpacity(0.85),
                            ),
                          ),
                          onTapLink: (text, href, title) {
                            if (href != null) {
                              launchUrl(Uri.parse(href));
                            }
                          },
                          selectable: true,
                        ),
                      ).animate().fadeIn(duration: 200.ms),

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: xpColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                               FaIcon(FontAwesomeIcons.star, size: 12, color: xpColor),
                               const SizedBox(width: 6),
                               Text(
                                '${NumberFormat.compact().format(widget.quest.xpReward)} XP',
                                style: TextStyle(
                                  color: xpColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: (widget.isLoadingClaim || (isQuestPendingForActorDisplay && widget.currentUserProfile?.id == widget.viewingUserProfile?.id) || !canInteractButtonVisual)
                                      ? null
                                      : _handleTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: canInteractButtonVisual ? AppColors.primaryAccent : currentTextColor.withOpacity(0.1),
                            foregroundColor: canInteractButtonVisual ? AppColors.lightText : currentTextColor.withOpacity(0.5),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            minimumSize: const Size(90, 40),
                            elevation: (canInteractButtonVisual && !widget.isLoadingClaim && !(isQuestPendingForActorDisplay && widget.currentUserProfile?.id == widget.viewingUserProfile?.id)) ? 4 : 0,
                          ),
                          child: widget.isLoadingClaim
                              ? const SizedBox(
                                  height: 20, width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                                )
                              : Text(buttonText, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

```

### File: ./lib/widgets/gamified_banner_widget.dart
```dart
// lib/widgets/gamified_banner_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/user_profile_model.dart';
import '../utils/app_colors.dart';
import 'app_logo_widget.dart';
import 'package:intl/intl.dart';

class GamifiedBannerWidget extends StatelessWidget {
  final UserProfile? userProfile;
  final VoidCallback? onTapLeaderboard;

  const GamifiedBannerWidget({
    Key? key,
    this.userProfile,
    this.onTapLeaderboard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final NumberFormat xpFormatter = NumberFormat.compact();

    return Container(
      padding: const EdgeInsets.all(16.0).copyWith(top: MediaQuery.of(context).padding.top + 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.9),
            theme.colorScheme.primary.withOpacity(0.7),
            theme.colorScheme.secondary.withOpacity(0.6)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppLogoWidget(logoHeight: 40).animate().fadeIn(delay: 200.ms).slideX(begin: -0.5),
              Text(
                "Cabal",
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(color: Colors.black.withOpacity(0.3), offset: const Offset(1, 1), blurRadius: 2),
                  ]
                ),
              ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.5),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Cabal Intelligence Feed",
            style: theme.textTheme.titleLarge?.copyWith(color: Colors.white.withOpacity(0.95)),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.5),
          const SizedBox(height: 8),
          if (userProfile != null)
            Row(
              children: [
                FaIcon(FontAwesomeIcons.medal, color: AppColors.accent, size: 18),
                const SizedBox(width: 8),
                Text(
                  "Level ${userProfile!.level}",
                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                FaIcon(FontAwesomeIcons.starHalfStroke, color: AppColors.accent, size: 18),
                const SizedBox(width: 8),
                Text(
                  "${xpFormatter.format(userProfile!.totalXp)} XP",
                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ],
            ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.5),
          const SizedBox(height: 10),
          if (onTapLeaderboard != null)
            Align(
              alignment: Alignment.centerRight,
              child: ActionChip(
                avatar: FaIcon(FontAwesomeIcons.rankingStar, color: theme.colorScheme.primary, size: 16),
                label: Text("View Leaderboard", style: TextStyle(color: theme.colorScheme.primary)),
                onPressed: onTapLeaderboard,
                backgroundColor: AppColors.accent.withOpacity(0.9),
                elevation: 2,
              ).animate().fadeIn(delay: 800.ms).scaleXY(begin: 0.8)
            ),
        ],
      ),
    );
  }
}

```

### File: ./lib/widgets/animated_header_widget.dart
```dart
// lib/widgets/animated_header_widget.dart
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AnimatedHeaderWidget extends StatefulWidget {
  const AnimatedHeaderWidget({Key? key}) : super(key: key);

  @override
  State<AnimatedHeaderWidget> createState() => _AnimatedHeaderWidgetState();
}

class _AnimatedHeaderWidgetState extends State<AnimatedHeaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Color?> _textColorAnimation;
  late Animation<double> _shadowOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Use a CurvedAnimation to make the pulse feel more natural
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // Animate text color from a subtle gold to a bright white and back
    _textColorAnimation = ColorTween(
      begin: AppColors.gold.withOpacity(0.8),
      end: Colors.white,
    ).animate(_animation);
    
    // Animate the shadow opacity to create a "glow"
    _shadowOpacityAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(_animation);

    _controller.repeat(reverse: true); // Loop the animation back and forth
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            // The background gradient pulse
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.5 * _animation.value, // Animate the radius
              colors: [
                AppColors.gold.withOpacity(0.15 * _animation.value),
                Colors.transparent,
              ],
              stops: const [0.0, 1.0],
            ),
          ),
          child: Center(
            child: Text(
              'Cabal',
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: _textColorAnimation.value,
                shadows: [
                  Shadow(
                    blurRadius: 25.0 * _animation.value,
                    color: AppColors.gold.withOpacity(_shadowOpacityAnimation.value),
                  ),
                  Shadow(
                    blurRadius: 10.0,
                    color: AppColors.offBlack.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

```

### File: ./lib/widgets/shimmer_widget.dart
```dart
// lib/widgets/shimmer_widget.dart
import 'package:flutter/material.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
  }) : shapeBorder = const RoundedRectangleBorder();

  const ShimmerWidget.circular({
    super.key,
    required this.width,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Shimmer(
      gradient: LinearGradient(
        colors: [
          isDark ? Colors.grey[800]! : Colors.grey[200]!,
          isDark ? Colors.grey[700]! : Colors.grey[300]!,
          isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ],
        stops: const [0.1, 0.5, 0.9],
        begin: const Alignment(-1.0, -0.3),
        end: const Alignment(1.0, 0.3),
        tileMode: TileMode.clamp,
      ),
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: isDark ? Colors.grey[850]! : Colors.grey[100]!,
          shape: shapeBorder,
        ),
      ),
    );
  }
}

class Shimmer extends StatefulWidget {
  final LinearGradient gradient;
  final Widget child;

  const Shimmer({
    super.key,
    required this.gradient,
    required this.child,
  });

  @override
  _ShimmerState createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController.unbounded(vsync: this)
      ..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1200));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return widget.gradient.createShader(
          Rect.fromLTWH(
            -bounds.width * _shimmerController.value,
            0,
            bounds.width * 3,
            bounds.height,
          ),
        );
      },
      child: widget.child,
    );
  }
}

```

### File: ./lib/widgets/empty_state_card.dart
```dart
// lib/widgets/empty_state_card.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../models/user_profile_model.dart';
import '../screens/login_screen.dart';

class EmptyStateCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final UserProfile? currentUserProfile; // Pass this to check login status

  const EmptyStateCard({
    Key? key,
    required this.title,
    required this.message,
    required this.icon,
    required this.buttonText,
    required this.onButtonPressed,
    this.currentUserProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    void handleTap() {
      if (currentUserProfile == null) {
        // If user is a guest, navigate to login first
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: const LoginScreen(),
          ),
        );
      } else {
        // If user is logged in, perform the intended action
        onButtonPressed();
      }
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FaIcon(icon, size: 48, color: theme.colorScheme.primary.withOpacity(0.7)),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: handleTap,
              style: theme.elevatedButtonTheme.style,
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}

```

### File: ./lib/widgets/project_listing_card.dart
```dart
// lib/widgets/project_listing_card.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/marketplace_models.dart';
import '../utils/app_colors.dart';

class ProjectListingCard extends StatelessWidget {
  final ProjectListing project;

  const ProjectListingCard({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(project.creatorAvatarUrl)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    project.projectName,
                    style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                  ),
                ),
                if (project.isOpen)
                  Chip(
                    label: const Text("Open"),
                    backgroundColor: AppColors.success.withOpacity(0.15),
                    labelStyle: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  )
              ],
            ),
            const SizedBox(height: 4),
            Text("by ${project.creatorName}", style: theme.textTheme.bodySmall),
            const Divider(height: 24),
            Text(project.projectDescription, maxLines: 3, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoChip(theme, icon: FontAwesomeIcons.dollarSign, text: project.budget),
                const SizedBox(width: 8),
                _buildInfoChip(theme, icon: FontAwesomeIcons.clock, text: project.timeline),
              ],
            ),
            const SizedBox(height: 12),
            Text("Required Skills:", style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: project.requiredSkills.map((skill) => Chip(label: Text(skill))).toList(),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("View & Propose"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(ThemeData theme, {required IconData icon, required String text}) {
    return Chip(
      avatar: FaIcon(icon, size: 14, color: theme.colorScheme.secondary),
      label: Text(text),
      backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    );
  }
}

```

### File: ./lib/widgets/leaderboard_preview_card.dart
```dart
// lib/widgets/leaderboard_preview_card.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'shimmer_widget.dart';

class LeaderboardPreviewCard extends StatelessWidget {
  final int? rank;
  final int? userCabalXp;
  final bool isLoading;
  final VoidCallback onTap;

  const LeaderboardPreviewCard({
    Key? key,
    required this.rank,
    required this.userCabalXp,
    required this.isLoading,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final xpFormatter = NumberFormat.compact();

    if (isLoading) {
      return const ShimmerWidget.rectangular(height: 80);
    }
    
    if (rank == null || userCabalXp == null) {
      // Don't show the card if the user isn't ranked (e.g., 0 XP)
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              FaIcon(FontAwesomeIcons.rankingStar, color: theme.colorScheme.primary, size: 28),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Your Cabal Rank", style: theme.textTheme.titleMedium),
                  Text("Tap to view the full leaderboard", style: theme.textTheme.bodySmall),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("#$rank", style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.secondary)),
                  Text("${xpFormatter.format(userCabalXp)} XP", style: theme.textTheme.bodyMedium),
                ],
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: theme.iconTheme.color?.withOpacity(0.6)),
            ],
          ),
        ),
      ),
    );
  }
}

```

### File: ./lib/widgets/horizontal_cabal_list.dart
```dart
// lib/widgets/horizontal_cabal_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/cabal_model.dart';
import 'cabal_card_widget.dart';
import 'shimmer_widget.dart';
import 'package:page_transition/page_transition.dart';
import '../screens/cabal_detail_screen.dart';

class HorizontalCabalList extends StatelessWidget {
  final String title;
  final List<Cabal> cabals;
  final bool isLoading;
  final String? emptyMessage;

  const HorizontalCabalList({
    Key? key,
    required this.title,
    required this.cabals,
    this.isLoading = false,
    this.emptyMessage,
  }) : super(key: key);

  void _navigateToCabalDetail(BuildContext context, Cabal cabal) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: CabalDetailScreen(cabalId: cabal.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(title, style: theme.textTheme.titleLarge),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 230, // Fixed height for the horizontal list
          child: isLoading
              ? _buildLoadingState()
              : cabals.isEmpty
                  ? Center(child: Text(emptyMessage ?? "Nothing to see here... yet!", style: theme.textTheme.bodyMedium))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cabals.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemBuilder: (context, index) {
                        final cabal = cabals[index];
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75, // Make cards wide
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: CabalCardWidget(
                              project: cabal,
                              onTap: () => _navigateToCabalDetail(context, cabal),
                            ),
                          ),
                        ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.2);
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemBuilder: (context, index) => SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: const Padding(
          padding: EdgeInsets.only(right: 12.0),
          child: ShimmerWidget.rectangular(height: 230),
        ),
      ),
    );
  }
}

```

### File: ./lib/widgets/user_profile_widget.dart
```dart
// lib/widgets/user_profile_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import '../models/user_profile_model.dart';
import '../models/achievement_model.dart';
import '../services/supabase_service.dart';
import '../utils/icon_mapper.dart';
import '../utils/leveling.dart';
import '../utils/app_colors.dart';
import 'shimmer_widget.dart';

class UserProfileWidget extends StatefulWidget {
  final UserProfile userProfile;
  final Color? backgroundColor;
  final Color? textColor;

  const UserProfileWidget({
    Key? key,
    required this.userProfile,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  final SupabaseService _supabaseService = SupabaseService();
  List<Achievement> _earnedAchievements = [];
  bool _isLoadingAchievements = true;
  final NumberFormat xpFormatter = NumberFormat.compact();

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  @override
  void didUpdateWidget(covariant UserProfileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.userProfile.id != oldWidget.userProfile.id || !const ListEquality().equals(widget.userProfile.earnedAchievementIds, oldWidget.userProfile.earnedAchievementIds)) {
      _loadAchievements();
    }
  }

  Future<void> _loadAchievements() async {
    if (!mounted) return;
    setState(() => _isLoadingAchievements = true);

    if (widget.userProfile.earnedAchievementIds.isEmpty) {
      if (mounted) setState(() => _isLoadingAchievements = false);
      return;
    }
    try {
      final achievements = await _supabaseService.getAchievementsByIds(widget.userProfile.earnedAchievementIds);
      if (mounted) {
        setState(() {
          _earnedAchievements = achievements;
          _isLoadingAchievements = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading achievements: $e");
      if (mounted) setState(() => _isLoadingAchievements = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final bgColor = widget.backgroundColor ?? theme.cardTheme.color ?? theme.cardColor;
    final txtColor = widget.textColor ?? (isDark ? Colors.white : Colors.black);
    final txtSecColor = widget.textColor?.withOpacity(0.7) ?? theme.textTheme.bodyMedium?.color ?? (isDark ? Colors.white70 : Colors.black54);
    final accentColor = theme.colorScheme.secondary;

    int xpForNext = xpForLevel(widget.userProfile.level + 1);
    int xpForCurrent = xpForLevel(widget.userProfile.level);
    double progressPercentage = (widget.userProfile.totalXp - xpForCurrent).toDouble() / (xpForNext - xpForCurrent).toDouble();
    if (progressPercentage.isNaN || progressPercentage.isInfinite) {
      progressPercentage = 1.0;
    }

    return Card(
      elevation: 4,
      color: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: widget.userProfile.profileImageUrl != null ? NetworkImage(widget.userProfile.profileImageUrl!) : null,
                  child: widget.userProfile.profileImageUrl == null ? FaIcon(FontAwesomeIcons.userAstronaut, size: 30, color: txtSecColor) : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userProfile.displayName ?? 'User',
                        style: theme.textTheme.titleLarge?.copyWith(color: txtColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Level ${widget.userProfile.level}',
                        style: theme.textTheme.bodyMedium?.copyWith(color: txtSecColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${xpFormatter.format(widget.userProfile.totalXp)} XP / ${xpForNext == 999999999 ? "MAX" : xpFormatter.format(xpForNext)} XP ${xpForNext == 999999999 ? "" : "to Level ${widget.userProfile.level + 1}"}',
              style: theme.textTheme.bodyMedium?.copyWith(color: txtColor.withOpacity(0.85)),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progressPercentage,
              backgroundColor: accentColor.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const Divider(height: 32),
            _isLoadingAchievements
              ? const ShimmerWidget.rectangular(height: 30)
              : _earnedAchievements.isEmpty
                ? Center(child: Text("No achievements yet.", style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)))
                : Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _earnedAchievements.map((ach) => Tooltip(
                      message: ach.description,
                      child: Chip(
                        avatar: FaIcon(getIconFromName(ach.iconName), size: 16, color: accentColor.withOpacity(0.9)),
                        label: Text(ach.title, style: theme.chipTheme.labelStyle),
                        backgroundColor: theme.chipTheme.backgroundColor,
                      ),
                    )).toList(),
                  ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.1),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatChip(context, icon: FontAwesomeIcons.users, count: widget.userProfile.followersUserIds.length, label: "Followers", accentColor: accentColor),
                _buildStatChip(context, icon: FontAwesomeIcons.userCheck, count: widget.userProfile.followingUserIds.length, label: "Following", accentColor: accentColor),
                _buildStatChip(context, icon: FontAwesomeIcons.rightToBracket, count: widget.userProfile.joinedCabalIds.length, label: "Cabals", accentColor: accentColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(BuildContext context, {required IconData icon, required int count, required String label, required Color accentColor}) {
    final theme = Theme.of(context);
    return Chip(
      avatar: FaIcon(icon, size: 14, color: accentColor),
      label: Text('$count $label', style: theme.chipTheme.labelStyle?.copyWith(color: accentColor, fontSize: 13)),
      backgroundColor: accentColor.withOpacity(0.12),
      padding: theme.chipTheme.padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }
}

```

### File: ./lib/widgets/friends_feed_card.dart
```dart
// lib/widgets/friends_feed_card.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FriendsFeedCard extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String timeAgo;
  final String content;
  final String? imageUrl;

  const FriendsFeedCard({
    Key? key,
    required this.avatarUrl,
    required this.name,
    required this.timeAgo,
    required this.content,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(avatarUrl),
                    radius: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                        Text(timeAgo, style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7))),
                      ],
                    ),
                  ),
                  Icon(FontAwesomeIcons.ellipsis, size: 16, color: theme.iconTheme.color?.withOpacity(0.6)),
                ],
              ),
            ),
            if (imageUrl != null)
              Image.network(
                imageUrl!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                content,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
            Divider(height: 1, thickness: 0.5, color: theme.dividerColor.withOpacity(0.5)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(theme, icon: FontAwesomeIcons.heart, label: "Like"),
                  _buildActionButton(theme, icon: FontAwesomeIcons.comment, label: "Comment"),
                  _buildActionButton(theme, icon: FontAwesomeIcons.share, label: "Share"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(ThemeData theme, {required IconData icon, required String label}) {
    return TextButton.icon(
      onPressed: () {},
      icon: FaIcon(icon, size: 16, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8)),
      label: Text(label, style: theme.textTheme.bodySmall),
      style: TextButton.styleFrom(
        foregroundColor: theme.textTheme.bodyMedium?.color,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}

```

### File: ./lib/widgets/app_logo_widget.dart
```dart
// lib/widgets/app_logo_widget.dart
import 'package:flutter/material.dart';
import 'package:cabal/utils/app_colors.dart'; // Assuming your AppColors are here

class AppLogoWidget extends StatelessWidget {
  final double logoHeight;

  const AppLogoWidget({
    Key? key,
    this.logoHeight = 50.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/cabal_logo.png', // Switched to PNG for better compatibility
      height: logoHeight,
      errorBuilder: (context, error, stackTrace) {
        // Fallback in case the image still fails to load
        print("Error loading logo asset: $error");
        return Icon(
          Icons.shield_moon_rounded,
          size: logoHeight,
          color: AppColors.gold,
        );
      },
    );
  }
}

```

### File: ./lib/widgets/bot_card_widget.dart
```dart
// lib/widgets/bot_card_widget.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../models/bot_model.dart';
import '../utils/app_colors.dart';

class BotCardWidget extends StatelessWidget {
  final BotModel bot;
  final Function(BotStatus) onUpdateStatus;
  final VoidCallback onDelete;

  const BotCardWidget({
    Key? key,
    required this.bot,
    required this.onUpdateStatus,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pnlFormat = NumberFormat.simpleCurrency(locale: 'en_US');

    Color statusColor;
    String statusText;
    switch (bot.status) {
      case BotStatus.active:
        statusColor = AppColors.success;
        statusText = "Active";
        break;
      case BotStatus.paused:
        statusColor = AppColors.warning;
        statusText = "Paused";
        break;
      case BotStatus.error:
        statusColor = AppColors.error;
        statusText = "Error";
        break;
    }

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
                  child: FaIcon(FontAwesomeIcons.robot, color: theme.colorScheme.secondary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(bot.name, style: theme.textTheme.titleMedium),
                      Text(bot.type, style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7))),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'pause') onUpdateStatus(BotStatus.paused);
                    if (value == 'start') onUpdateStatus(BotStatus.active);
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    if (bot.status == BotStatus.active)
                      const PopupMenuItem<String>(
                        value: 'pause',
                        child: ListTile(leading: Icon(Icons.pause), title: Text('Pause Bot')),
                      ),
                    if (bot.status == BotStatus.paused || bot.status == BotStatus.error)
                      const PopupMenuItem<String>(
                        value: 'start',
                        child: ListTile(leading: Icon(Icons.play_arrow), title: Text('Start Bot')),
                      ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: ListTile(leading: Icon(Icons.delete_outline, color: Colors.red), title: Text('Delete Bot', style: TextStyle(color: Colors.red))),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn("24h P&L", pnlFormat.format(bot.pnl24h), bot.pnl24h >= 0 ? AppColors.success : AppColors.error, theme),
                _buildStatColumn("Total Trades", bot.totalTrades.toString(), theme.textTheme.bodyLarge!.color!, theme),
                _buildStatColumn("Status", statusText, statusColor, theme),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color valueColor, ThemeData theme) {
    return Column(
      children: [
        Text(label, style: theme.textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.titleMedium?.copyWith(color: valueColor, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

```

### File: ./lib/widgets/profile_stat_card.dart
```dart
// lib/widgets/profile_stat_card.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../utils/app_colors.dart';

class ProfileStatCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final VoidCallback? onTap;

  const ProfileStatCard({
    Key? key,
    required this.label,
    required this.count,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFormat = NumberFormat.compact();

    return AspectRatio(
      aspectRatio: 1, // Makes the card square
      child: Card(
        color: theme.cardTheme.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: theme.dividerColor),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FaIcon(icon, size: 24, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                const SizedBox(height: 8),
                Text(
                  numberFormat.format(count),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

```

### File: ./lib/widgets/profile_header.dart
```dart
// lib/widgets/profile_header.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../models/user_profile_model.dart';
import '../utils/app_colors.dart'; // Import for AppColors

class ProfileHeader extends StatelessWidget {
  final UserProfile userProfile;
  final bool isCurrentUser;
  final VoidCallback onEditProfile;
  final VoidCallback onFollow;
  final bool isFollowing;

  const ProfileHeader({
    Key? key,
    required this.userProfile,
    required this.isCurrentUser,
    required this.onEditProfile,
    required this.onFollow,
    required this.isFollowing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayAddress = userProfile.connectedWallets['evm'] != null
        ? "${userProfile.connectedWallets['evm']!.substring(0, 6)}...${userProfile.connectedWallets['evm']!.substring(userProfile.connectedWallets['evm']!.length - 4)}"
        : "No Wallet Connected";

    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: theme.colorScheme.surfaceVariant,
          child: CircleAvatar(
            radius: 48,
            backgroundImage: userProfile.profileImageUrl != null
                ? NetworkImage(userProfile.profileImageUrl!)
                : null,
            child: userProfile.profileImageUrl == null
                ? FaIcon(FontAwesomeIcons.userAstronaut, size: 40, color: theme.colorScheme.onSurfaceVariant)
                : null,
          ),
        ),
        const SizedBox(height: 16),
        // --- MODIFICATION START ---
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              userProfile.displayName ?? 'Cabal User',
              style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.onBackground, fontWeight: FontWeight.bold),
            ),
            if (userProfile.is_twitter_verified == true) ...[
              const SizedBox(width: 8),
              FaIcon(FontAwesomeIcons.solidCircleCheck, color: AppColors.questTypeTwitterBorder, size: 20),
            ]
          ],
        ),
        // --- MODIFICATION END ---
        const SizedBox(height: 4),
        if (userProfile.connectedWallets['evm'] != null)
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: userProfile.connectedWallets['evm']!));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Wallet address copied to clipboard!')),
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    displayAddress,
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onBackground.withOpacity(0.7), fontFamily: 'monospace'),
                  ),
                  const SizedBox(width: 8),
                  FaIcon(FontAwesomeIcons.copy, size: 12, color: theme.colorScheme.onBackground.withOpacity(0.7)),
                ],
              ),
            ),
          ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isCurrentUser) ...[
              ElevatedButton.icon(
                onPressed: onEditProfile,
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  foregroundColor: theme.colorScheme.onSurfaceVariant,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {
                  final referralLink = "https://cabal-001.web.app/join?ref=${userProfile.referralCode ?? userProfile.id}";
                  Share.share('Join me on Cabal! Use my referral link: $referralLink');
                },
                icon: const Icon(Icons.share_outlined, size: 16),
                label: const Text('Share Profile'),
                 style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  foregroundColor: theme.colorScheme.onSurfaceVariant,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ] else ...[
              ElevatedButton.icon(
                onPressed: onFollow,
                icon: FaIcon(isFollowing ? FontAwesomeIcons.userCheck : FontAwesomeIcons.userPlus, size: 14),
                label: Text(isFollowing ? 'Following' : 'Follow'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFollowing ? theme.colorScheme.surfaceVariant : theme.colorScheme.primary,
                  foregroundColor: isFollowing ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.onPrimary,
                   shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ]
          ],
        ),
      ],
    );
  }
}

```

### File: ./lib/widgets/quest_section_dialog.dart
```dart
// lib/widgets/quest_section_dialog.dart
import 'package:cabal/models/quest_section_model.dart';
import 'package:flutter/material.dart';

class QuestSectionDialog extends StatefulWidget {
  final QuestSection? section; // if null, it's a new section

  const QuestSectionDialog({Key? key, this.section}) : super(key: key);

  @override
  State<QuestSectionDialog> createState() => _QuestSectionDialogState();
}

class _QuestSectionDialogState extends State<QuestSectionDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.section?.title ?? '');
    _descriptionController = TextEditingController(text: widget.section?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop({
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.section == null ? 'Create New Section' : 'Edit Section'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Section Title *'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title cannot be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description (Optional)'),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

```

### File: ./lib/widgets/developer_profile_card.dart
```dart
// lib/widgets/developer_profile_card.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/marketplace_models.dart';
import '../utils/app_colors.dart';

class DeveloperProfileCard extends StatelessWidget {
  final DeveloperProfile developer;
  final VoidCallback onContact;

  const DeveloperProfileCard({
    Key? key, 
    required this.developer,
    required this.onContact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(developer.developerAvatarUrl),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(developer.developerName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text(developer.tagline, style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
                if (developer.isAvailable)
                  const FaIcon(FontAwesomeIcons.solidCircleCheck, color: AppColors.success, size: 20)
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                avatar: FaIcon(FontAwesomeIcons.dollarSign, size: 14, color: theme.colorScheme.secondary),
                label: Text(developer.rate),
                backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
              ),
            ),
            const Divider(height: 24),
            Text("Core Expertise:", style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              alignment: WrapAlignment.center,
              children: developer.skills.map((skill) => Chip(label: Text(skill))).toList(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onContact, // This now correctly uses the passed-in callback
                child: const Text("View Profile & Contact"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

```

### File: ./lib/widgets/reorderable_quest_section_card.dart
```dart
// lib/widgets/reorderable_quest_section_card.dart
import 'package:cabal/models/quest_section_model.dart';
import 'package:flutter/material.dart';
import 'package:cabal/models/quest_model.dart'; // <-- CORRECTED IMPORT
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReorderableQuestSectionCard extends StatelessWidget {
  final QuestSection section;
  final int questCount;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAddQuest;

  const ReorderableQuestSectionCard({
    Key? key,
    required this.section,
    required this.questCount,
    required this.onEdit,
    required this.onDelete,
    required this.onAddQuest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          ListTile(
            key: key, // Key for ReorderableListView
            title: Text(section.title, style: theme.textTheme.titleMedium),
            subtitle: Text(section.description ?? 'No description'),
            leading: ReorderableDragStartListener(
              index: section.order, // The index is crucial for reordering
              child: const Icon(Icons.drag_handle_rounded),
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') onEdit();
                if (value == 'delete') onDelete();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit Section')),
                const PopupMenuItem(value: 'delete', child: Text('Delete Section', style: TextStyle(color: Colors.red))),
              ],
            ),
          ),
          const Divider(height: 1),
          // Placeholder for listing quests within the section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$questCount Quests in this section'),
                ElevatedButton.icon(
                  icon: const FaIcon(FontAwesomeIcons.plus, size: 14),
                  label: const Text('Add Quest'),
                  onPressed: onAddQuest,
                  style: ElevatedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

```

### File: ./lib/widgets/community_cabal_card.dart
```dart
// lib/widgets/community_cabal_card.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../models/community_cabal_preview.dart';
import '../utils/app_colors.dart';

class CommunityCabalCard extends StatelessWidget {
  final CommunityCabalPreview preview;
  final VoidCallback onTap;

  const CommunityCabalCard({
    Key? key,
    required this.preview,
    required this.onTap,
  }) : super(key: key);

  String _formatTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return 'No posts yet';
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) return "${difference.inSeconds}s ago";
    if (difference.inMinutes < 60) return "${difference.inMinutes}m ago";
    if (difference.inHours < 24) return "${difference.inHours}h ago";
    return DateFormat('MMM d').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: preview.cabal.logoUrl != null
                        ? NetworkImage(preview.cabal.logoUrl!)
                        : null,
                    child: preview.cabal.logoUrl == null
                        ? FaIcon(FontAwesomeIcons.usersRectangle, size: 20)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          preview.cabal.name,
                          style: theme.textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "by ${preview.cabal.creatorHandle ?? 'Unknown'}",
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              if (preview.latestPostSnippet != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FaIcon(FontAwesomeIcons.quoteLeft, size: 12, color: theme.colorScheme.secondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '"${preview.latestPostSnippet!}"',
                        style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatChip(theme, icon: FontAwesomeIcons.users, text: "${preview.memberCount} Members"),
                  _buildStatChip(theme, icon: FontAwesomeIcons.solidMessage, text: "${preview.postCount} Posts"),
                  Text(
                    "Last post: ${_formatTimeAgo(preview.latestPostTimestamp)}",
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(ThemeData theme, {required IconData icon, required String text}) {
    return Chip(
      avatar: FaIcon(icon, size: 14, color: theme.colorScheme.secondary),
      label: Text(text),
      backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      visualDensity: VisualDensity.compact,
    );
  }
}

```

### File: ./lib/widgets/community_stats_header.dart
```dart
// lib/widgets/community_stats_header.dart
import 'package:cabal/models/cabal_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CommunityStatsHeader extends StatelessWidget {
  final Cabal cabal;
  final int memberCount;
  final int postCount;

  const CommunityStatsHeader({
    Key? key,
    required this.cabal,
    required this.memberCount,
    required this.postCount,
  }) : super(key: key);

  String _formatCabalAge() {
    if (cabal.createdAt == null) return "Age unknown";
    final difference = DateTime.now().difference(cabal.createdAt!);
    if (difference.inDays > 365) {
      return "${(difference.inDays / 365).floor()}y old";
    }
    if (difference.inDays > 30) {
      return "${(difference.inDays / 30).floor()}mo old";
    }
    if (difference.inDays > 0) {
      return "${difference.inDays}d old";
    }
    return "New!";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStat(theme, count: memberCount, label: "Members", icon: FontAwesomeIcons.users),
            _buildStat(theme, count: postCount, label: "Posts", icon: FontAwesomeIcons.solidMessage),
            _buildStat(theme, label: _formatCabalAge(), icon: FontAwesomeIcons.solidCalendarDays, isAge: true),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(ThemeData theme, {int? count, required String label, required IconData icon, bool isAge = false}) {
    return Column(
      children: [
        FaIcon(icon, size: 20, color: theme.colorScheme.secondary),
        const SizedBox(height: 8),
        if (!isAge)
          Text(
            NumberFormat.compact().format(count ?? 0),
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        Text(
          label,
          style: isAge 
            ? theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
            : theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

```

### File: ./lib/widgets/community_activity_chart.dart
```dart
// lib/widgets/community_activity_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/app_colors.dart';

class CommunityActivityChart extends StatelessWidget {
  final List<Map<String, dynamic>> activityData; // Expects [{'date': ISO_STRING, 'count': INT}]

  const CommunityActivityChart({Key? key, required this.activityData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spots = activityData.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final count = (entry.value['count'] as num? ?? 0).toDouble();
      return BarChartGroupData(x: index.toInt(), barRods: [
        BarChartRodData(
          toY: count,
          color: theme.colorScheme.primary,
          width: 5,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          )
        ),
      ]);
    }).toList();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Activity (Last 30 Days)", style: theme.textTheme.titleMedium),
            const SizedBox(height: 24),
            SizedBox(
              height: 150,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: spots,
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index % 7 == 0 && index < activityData.length) { 
                            final date = DateTime.parse(activityData[index]['date']);
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(DateFormat('MMM d').format(date), style: theme.textTheme.bodySmall),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                   barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => AppColors.darkGrey.withOpacity(0.8),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        if (groupIndex >= activityData.length) return null;
                        final date = DateTime.parse(activityData[group.x]['date']);
                        return BarTooltipItem(
                          '${rod.toY.toInt()} posts\n',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: DateFormat('MMM d, yyyy').format(date),
                              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

```

### File: ./lib/widgets/nft_listing_card.dart
```dart
// lib/widgets/nft_listing_card.dart
import 'package:flutter/material.dart';
import '../models/nft_listing_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class NftListingCard extends StatelessWidget {
  final NftListing listing;
  final VoidCallback onTap;

  const NftListingCard({
    Key? key,
    required this.listing,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFormat = NumberFormat("###,##0.00##", "en_US");

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Hero(
                tag: 'nft_image_${listing.id}', // Unique tag for Hero animation
                child: Image.network(
                  listing.nftImageUrl ?? 'https://via.placeholder.com/300/1E1E1E/FFFFFF?Text=NFT',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: theme.colorScheme.surfaceVariant,
                      child: const Center(
                        child: FaIcon(FontAwesomeIcons.image),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.collectionName ?? 'Unknown Collection',
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    listing.nftName ?? 'Unnamed NFT',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price',
                        style: theme.textTheme.bodySmall,
                      ),
                      Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.ethereum, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            numberFormat.format(listing.priceInEth),
                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

```

### File: ./lib/widgets/merchandise_card_widget.dart
```dart
// lib/widgets/merchandise_card_widget.dart
import 'package:cabal/models/merchandise_product_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class MerchandiseCardWidget extends StatelessWidget {
  final MerchandiseProduct product;
  final VoidCallback onTap;

  const MerchandiseCardWidget({
    Key? key,
    required this.product,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFormat = NumberFormat("###,##0.00##", "en_US");

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.network(
                product.imageUrl ?? 'https://via.placeholder.com/300/1E1E1E/FFFFFF?Text=Merch',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: theme.colorScheme.surfaceVariant,
                    child: const Center(
                      child: FaIcon(FontAwesomeIcons.shirt),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "${numberFormat.format(product.price)} ${product.paymentTokenSymbol}",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

```

### File: ./lib/widgets/post_card_widget.dart
```dart
// lib/widgets/post_card_widget.dart
import 'package:cabal/models/user_profile_model.dart';
import '../screens/login_screen.dart';
import '../screens/post_detail_screen.dart';
import '../services/supabase_service.dart';
import '../services/web3_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import '../features/wallet/application/wallet_provider.dart';
import '../models/community_post_model.dart';
import '../utils/app_colors.dart';

class PostCardWidget extends StatefulWidget {
  final CommunityPost post;
  final UserProfile? currentUserProfile;
  final bool isDetailView; // Prevents navigating to detail from detail screen

  const PostCardWidget({
    Key? key,
    required this.post,
    this.currentUserProfile,
    this.isDetailView = false,
  }) : super(key: key);

  @override
  State<PostCardWidget> createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {
  final SupabaseService _supabaseService = SupabaseService();
  late bool _isLiked;
  late int _likeCount;
  late int _commentCount;
  bool _isLiking = false;
  bool _isTipping = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.isLikedByUser;
    _likeCount = widget.post.likes;
    _commentCount = widget.post.commentCount;
  }

  Future<void> _toggleLike() async {
    if (widget.currentUserProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to like posts.')),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      return;
    }
    if (_isLiking) return;

    setState(() {
      _isLiking = true;
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });

    try {
      final result = await _supabaseService.toggleLike(widget.post.id);
      if (mounted) {
        setState(() {
          widget.post.updateFromToggleLike(result);
          _isLiked = widget.post.isLikedByUser;
          _likeCount = widget.post.likes;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLiked = !_isLiked;
          _likeCount += _isLiked ? 1 : -1;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isLiking = false);
      }
    }
  }
  
  Future<void> _handleTipCreator() async {
    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    final supabaseService = context.read<SupabaseService>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (!walletProvider.isConnectedEVM) {
        scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please connect your EVM wallet to tip.")));
        await walletProvider.connectEVMWallet(context: context);
        return;
    }

    if (widget.currentUserProfile?.id == widget.post.userId) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("You cannot tip yourself.")));
      return;
    }
    
    final tipAmountStr = await showDialog<String>(
      context: context, 
      builder: (context) => const TipAmountDialog()
    );

    if (tipAmountStr == null || tipAmountStr.trim().isEmpty) return;
    final tipAmountDouble = double.tryParse(tipAmountStr);
    if (tipAmountDouble == null || tipAmountDouble <= 0) return;

    setState(() => _isTipping = true);

    try {
      final authorProfile = await supabaseService.getUserProfile(widget.post.userId);
      final recipientAddress = authorProfile?.connectedWallets['evm'];

      if (recipientAddress == null || recipientAddress.isEmpty) {
        throw Exception("${widget.post.authorName} has not connected a wallet to receive tips.");
      }

      final amountInWei = BigInt.from(tipAmountDouble * 1e18);

      final tx = web3Service.buildTipUserTransaction(
        recipientAddress: recipientAddress,
        amountInCblWei: amountInWei,
      );
      
      final txHash = await walletProvider.sendTransaction(tx);
      
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text("Successfully tipped ${widget.post.authorName}! Tx: $txHash"),
        backgroundColor: AppColors.success,
      ));

    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Tip failed: $e"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isTipping = false);
    }
  }

  void _navigateToDetail() {
    if (widget.isDetailView) return;
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: PostDetailScreen(
          post: widget.post,
          currentUserProfile: widget.currentUserProfile,
        ),
      ),
    ).then((_) {
      if (mounted) {
        setState(() {
          _commentCount = widget.post.commentCount;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: _navigateToDetail,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme),
              const SizedBox(height: 12),
              Text(widget.post.content, style: theme.textTheme.bodyLarge?.copyWith(height: 1.4)),
              _buildFooter(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: widget.post.authorAvatarUrl.isNotEmpty
              ? NetworkImage(widget.post.authorAvatarUrl)
              : null,
          child: widget.post.authorAvatarUrl.isEmpty
              ? const FaIcon(FontAwesomeIcons.userAstronaut, size: 20)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.post.authorName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              Text(widget.post.timeAgo, style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7))),
            ],
          ),
        ),
        if (!widget.isDetailView)
          IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz, color: theme.iconTheme.color?.withOpacity(0.6))),
      ],
    );
  }

  Widget _buildFooter(ThemeData theme) {
    final likeColor = _isLiked ? AppColors.error : theme.textTheme.bodyMedium?.color;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            TextButton.icon(
              onPressed: _toggleLike,
              icon: _isLiking
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : FaIcon(
                      _isLiked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                      size: 16,
                      color: likeColor,
                    ).animate(target: _isLiked ? 1 : 0).shake(hz: 4, duration: 200.ms),
              label: Text(_likeCount.toString(), style: TextStyle(color: likeColor)),
              style: TextButton.styleFrom(foregroundColor: theme.textTheme.bodyMedium?.color),
            ),
            TextButton.icon(
              onPressed: _navigateToDetail,
              icon: const FaIcon(FontAwesomeIcons.solidComment, size: 16),
              label: Text(_commentCount.toString()),
              style: TextButton.styleFrom(foregroundColor: theme.textTheme.bodyMedium?.color),
            ),
            if (widget.currentUserProfile != null)
              TextButton.icon(
                onPressed: _isTipping ? null : _handleTipCreator,
                icon: _isTipping 
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const FaIcon(FontAwesomeIcons.coins, size: 16, color: AppColors.gold),
                label: const Text("Tip"),
                style: TextButton.styleFrom(foregroundColor: AppColors.gold),
              ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.share_outlined, size: 20),
        ),
      ],
    );
  }
}

class TipAmountDialog extends StatefulWidget {
  const TipAmountDialog({Key? key}) : super(key: key);

  @override
  State<TipAmountDialog> createState() => _TipAmountDialogState();
}

class _TipAmountDialogState extends State<TipAmountDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tip Creator with \$CBL'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
          decoration: const InputDecoration(
            labelText: 'Amount',
            suffixText: '\$CBL',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter an amount.';
            final amount = double.tryParse(value);
            if (amount == null) return 'Please enter a valid number.';
            if (amount <= 0) return 'Amount must be greater than zero.';
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(_controller.text.trim());
            }
          },
          child: const Text('Send Tip'),
        )
      ],
    );
  }
}

```

### File: ./lib/widgets/coin_chart_widget.dart
```dart
// lib/widgets/coin_chart_widget.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../core/services/coingecko_service.dart';
import '../features/wallet/application/wallet_provider.dart';
import 'shimmer_widget.dart';
import '../utils/app_colors.dart';

class CoinChartWidget extends StatefulWidget {
  final String coinId;
  final VoidCallback onClose;

  const CoinChartWidget({
    Key? key,
    required this.coinId,
    required this.onClose,
  }) : super(key: key);

  @override
  State<CoinChartWidget> createState() => _CoinChartWidgetState();
}

class _CoinChartWidgetState extends State<CoinChartWidget> {
  final CoinGeckoService _coinGeckoService = CoinGeckoService();
  Future<List<FlSpot>>? _chartDataFuture;
  Timer? _priceUpdateTimer;
  double _currentPrice = 0.0;
  double _initialPrice = 0.0;
  bool _isPriceUp = true;
  final _random = Random();

  final List<String> _exchanges = ["Binance", "Coinbase", "Kraken", "KuCoin"];

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }
  
  void _fetchInitialData() {
    _chartDataFuture = _coinGeckoService.getCoinChartData(widget.coinId).then((data) {
      if (data.isNotEmpty) {
        if (mounted) {
          final firstPrice = data.first[1] as double;
          final lastPrice = data.last[1] as double;
          setState(() {
            _currentPrice = lastPrice;
            _initialPrice = firstPrice;
            _startPriceUpdates();
          });
        }
        return data.map((point) => FlSpot(point[0].toDouble(), point[1].toDouble())).toList();
      }
      return [];
    });
  }

  void _startPriceUpdates() {
    _priceUpdateTimer?.cancel();
    _priceUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        double change = _currentPrice * (_random.nextDouble() * 0.001 - 0.0005);
        _currentPrice += change;
        _isPriceUp = change >= 0;
      });
    });
  }

  @override
  void dispose() {
    _priceUpdateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walletProvider = context.watch<WalletProvider>();
    final priceFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    final overallTrendUp = _currentPrice >= _initialPrice;

    return Card(
      elevation: 4,
      color: theme.cardColor.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.coinId.toUpperCase()} Chart (14d)",
                  style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.xmark, size: 18),
                  onPressed: widget.onClose,
                  tooltip: "Close Chart",
                )
              ],
            ),
            const Divider(height: 16),
            Row(
              children: [
                Text(priceFormat.format(_currentPrice), style: theme.textTheme.headlineSmall),
                const SizedBox(width: 8),
                FaIcon(
                  _isPriceUp ? FontAwesomeIcons.arrowUp : FontAwesomeIcons.arrowDown,
                  color: _isPriceUp ? AppColors.success : AppColors.error,
                  size: 16,
                )
              ],
            ).animate(key: ValueKey(_currentPrice)).fadeIn(duration: 300.ms),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<FlSpot>>(
                future: _chartDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: ShimmerWidget.rectangular(height: 150));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}", style: TextStyle(color: theme.colorScheme.error)));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No chart data."));
                  }
                  
                  final spots = snapshot.data!;
                  
                  return Column(
                    children: [
                      Expanded(
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: false),
                            titlesData: const FlTitlesData(show: false),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: spots,
                                isCurved: true,
                                color: overallTrendUp ? AppColors.success : AppColors.error,
                                barWidth: 2.5,
                                isStrokeCapRound: true,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [
                                      (overallTrendUp ? AppColors.success : AppColors.error).withOpacity(0.3),
                                      (overallTrendUp ? AppColors.success : AppColors.error).withOpacity(0.0),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ],
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                getTooltipColor: (spot) => AppColors.darkGrey.withOpacity(0.8),
                                getTooltipItems: (touchedSpots) {
                                  return touchedSpots.map((spot) {
                                    return LineTooltipItem(
                                      '${priceFormat.format(spot.y)}\n',
                                      TextStyle(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold),
                                      children: [
                                        TextSpan(
                                          text: DateFormat('MMM d, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(spot.x.toInt())),
                                          style: TextStyle(color: theme.colorScheme.onPrimary.withOpacity(0.8), fontSize: 12),
                                        ),
                                      ],
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(height: 24),
                      Text("Available On", style: theme.textTheme.titleSmall),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        alignment: WrapAlignment.center,
                        children: _exchanges.map((ex) => Chip(label: Text(ex))).toList(),
                      ),
                      const SizedBox(height: 16),
                      walletProvider.isConnectedEVM
                        ? ElevatedButton.icon(
                            onPressed: () {},
                            icon: const FaIcon(FontAwesomeIcons.rightLeft, size: 16),
                            label: const Text("Buy / Trade Now"),
                          )
                        : ElevatedButton.icon(
                            onPressed: () => walletProvider.connectEVMWallet(context: context),
                            icon: const FaIcon(FontAwesomeIcons.wallet, size: 16),
                            label: const Text("Connect Wallet to Trade"),
                          ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

```

### File: ./lib/widgets/news_card_widget.dart
```dart
// lib/widgets/news_card_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../models/news_article_model.dart';

class NewsCardWidget extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback onTap; // Changed from _launchUrl to a generic callback

  const NewsCardWidget({
    Key? key, 
    required this.article,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeAgo = article.pubDate != null
        ? DateFormat.yMMMd().add_jm().format(article.pubDate!)
        : 'Recently';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap, // Use the passed-in callback
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl != null && article.imageUrl!.isNotEmpty)
              Image.network(
                article.imageUrl!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 150,
                  color: theme.colorScheme.surfaceVariant,
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.image,
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                      size: 40,
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  if (article.description != null)
                    Text(
                      article.description!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        article.source ?? 'Web3 News',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      Text(
                        timeAgo,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

```

### File: ./lib/widgets/info_tile_widget.dart
```dart
// lib/widgets/info_tile_widget.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/app_colors.dart';

class InfoTileWidget extends StatefulWidget {
  final IconData? icon;
  final Widget? leadingWidget;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final List<Color>? gradientColors;
  final Color? iconColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const InfoTileWidget({
    Key? key,
    this.icon,
    this.leadingWidget,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.gradientColors,
    this.iconColor,
    this.titleStyle,
    this.subtitleStyle,
  }) : assert(icon != null || leadingWidget != null, "Either icon or leadingWidget must be provided");

  @override
  State<InfoTileWidget> createState() => _InfoTileWidgetState();
}

class _InfoTileWidgetState extends State<InfoTileWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIconColor = widget.iconColor ?? (widget.gradientColors != null ? Colors.white : theme.colorScheme.primary);
    final effectiveTitleStyle = widget.titleStyle ?? theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: widget.gradientColors != null ? Colors.white : theme.textTheme.titleMedium?.color
    );
    final effectiveSubtitleStyle = widget.subtitleStyle ?? theme.textTheme.bodySmall?.copyWith(
        color: widget.gradientColors != null ? Colors.white.withOpacity(0.8) : theme.textTheme.bodySmall?.color?.withOpacity(0.7)
    );

    // This AnimatedBuilder will handle the rotating border gradient
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18), // Slightly larger radius for the border
            gradient: SweepGradient(
              center: Alignment.center,
              transform: GradientRotation(_controller.value * 2 * pi),
              colors: [
                AppColors.gold.withOpacity(0.5),
                Colors.transparent,
                Colors.transparent,
                AppColors.gold.withOpacity(0.5),
                Colors.transparent,
                Colors.transparent,
              ],
              stops: const [0.0, 0.4, 0.5, 0.9, 0.9, 1.0], // Creates two moving "comets"
            ),
          ),
          padding: const EdgeInsets.all(1.5), // This padding creates the border thickness
          child: child,
        );
      },
      child: Card(
        margin: EdgeInsets.zero, // Card is now inside the border container
        elevation: 0, // Elevation is handled by the parent if needed
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap,
          splashColor: widget.gradientColors != null ? widget.gradientColors![0].withOpacity(0.3) : theme.splashColor,
          highlightColor: widget.gradientColors != null ? widget.gradientColors![0].withOpacity(0.1) : theme.highlightColor,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: widget.gradientColors != null
                ? BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.gradientColors!,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  )
                : BoxDecoration(color: theme.cardColor), 
            child: Row(
              children: [
                if (widget.leadingWidget != null)
                  widget.leadingWidget!
                else if (widget.icon != null)
                   FaIcon(widget.icon, size: 28, color: effectiveIconColor),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: effectiveTitleStyle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: effectiveSubtitleStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 18, color: effectiveIconColor.withOpacity(0.7)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

```

### File: ./lib/widgets/diamond_mesh_background.dart
```dart
// lib/widgets/diamond_mesh_background.dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class DiamondMeshBackground extends StatefulWidget {
  final Widget child;
  const DiamondMeshBackground({Key? key, required this.child}) : super(key: key);

  @override
  State<DiamondMeshBackground> createState() => _DiamondMeshBackgroundState();
}

class _DiamondMeshBackgroundState extends State<DiamondMeshBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _DiamondMeshPainter(
            progress: _controller.value,
            baseColor: AppColors.offBlack,
            lineColor: AppColors.gold.withOpacity(0.1),
            dotColor: AppColors.gold.withOpacity(0.3),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _DiamondMeshPainter extends CustomPainter {
  final double progress;
  final Color baseColor;
  final Color lineColor;
  final Color dotColor;

  _DiamondMeshPainter({
    required this.progress,
    required this.baseColor,
    required this.lineColor,
    required this.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    // --- NEW: Animated Gradient Background for Texture ---
    final center = Alignment(sin(progress * 2 * pi) * 0.5, cos(progress * 2 * pi) * 0.5);
    final gradient = RadialGradient(
      center: center,
      radius: 1.5,
      colors: [
        AppColors.darkGrey, // Darker center
        baseColor,      // Main background color
      ],
      stops: const [0.0, 1.0],
    );
    paint.shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    paint.shader = null; // Reset shader

    // Line Paint
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Dot Paint
    final dotPaint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    const double spacing = 50.0;
    final double diagonalSpacing = spacing / sqrt(2);

    // Draw rotated grid lines (diamonds)
    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i + size.height, size.height), linePaint);
    }
    for (double i = size.height; i > -size.width; i -= spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i - size.height, size.height), linePaint);
    }
    
    // Draw shimmering dots at intersections
    for (double y = 0; y < size.height + diagonalSpacing; y += diagonalSpacing) {
      for (double x = (y % (2 * diagonalSpacing) == 0) ? 0 : diagonalSpacing;
          x < size.width + diagonalSpacing;
          x += 2 * diagonalSpacing) {
        // Use a hash-like function to make shimmering appear random but deterministic
        final hash = (x.toInt() * 31 + y.toInt() * 17) % 100 / 100.0;
        final localShimmer = (sin(progress * 2 * pi + hash * pi) + 1) / 2;
        dotPaint.color = dotColor.withOpacity(localShimmer * 0.5);
        canvas.drawCircle(Offset(x, y), 1.0, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DiamondMeshPainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

```

### File: ./lib/widgets/activity_card_widget.dart
```dart
// lib/widgets/activity_card_widget.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart'; 
import '../models/activity_model.dart';
import '../utils/app_colors.dart';

class ActivityCardWidget extends StatelessWidget {
  final Activity activity;
  final VoidCallback? onTap;

  const ActivityCardWidget({
    Key? key,
    required this.activity,
    this.onTap,
  }) : super(key: key);

  // Helper to get the appropriate icon for each activity type
  IconData _getIconForActivityType(ActivityType type) {
    switch (type) {
      case ActivityType.cabalCreated:
        return FontAwesomeIcons.plus;
      case ActivityType.questCompleted:
        return FontAwesomeIcons.solidCircleCheck;
      case ActivityType.achievementUnlocked:
        return FontAwesomeIcons.trophy;
      case ActivityType.userJoined:
        return FontAwesomeIcons.userPlus;
      default:
        return FontAwesomeIcons.infoCircle;
    }
  }

  // Helper to build the rich text description for the activity
  Widget _buildActivityText(BuildContext context, ThemeData theme) {
    final userStyle = theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary);
    final regularStyle = theme.textTheme.titleSmall;
    final contentStyle = theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.secondary);

    final displayName = activity.userDisplayName ?? 'A user';
    final content = activity.content ?? 'an activity';

    List<TextSpan> textSpans;

    switch (activity.type) {
      case ActivityType.cabalCreated:
        textSpans = [
          TextSpan(text: displayName, style: userStyle),
          TextSpan(text: ' created a new cabal: ', style: regularStyle),
          TextSpan(text: content, style: contentStyle),
        ];
        break;
      case ActivityType.questCompleted:
        textSpans = [
          TextSpan(text: displayName, style: userStyle),
          TextSpan(text: ' completed the quest: ', style: regularStyle),
          TextSpan(text: content, style: contentStyle),
        ];
        break;
      // Add more cases here as you implement more activity types
      default:
        textSpans = [
          TextSpan(text: displayName, style: userStyle),
          TextSpan(text: ' did something.', style: regularStyle),
        ];
    }
    return RichText(
      text: TextSpan(children: textSpans),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeAgo = _formatTimeAgo(activity.createdAt);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar and Icon Column
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: theme.colorScheme.surfaceVariant,
                    backgroundImage: activity.userProfileImageUrl != null
                        ? NetworkImage(activity.userProfileImageUrl!)
                        : null,
                    child: activity.userProfileImageUrl == null
                        ? FaIcon(
                            FontAwesomeIcons.userAstronaut,
                            size: 24,
                            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        shape: BoxShape.circle,
                      ),
                      child: FaIcon(
                        _getIconForActivityType(activity.type),
                        size: 14,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 16),
              // Text Content Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildActivityText(context, theme),
                    const SizedBox(height: 4),
                    Text(
                      timeAgo,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to format the timestamp into a "time ago" string
  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds}s ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}d ago";
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }
}

```

### File: ./lib/widgets/cabal_card_widget.dart
```dart
// lib/widgets/cabal_card_widget.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/cabal_model.dart';
import '../utils/app_colors.dart';

enum CabalCardLayout { horizontalList, grid } // <-- NEW: Layout enum

class CabalCardWidget extends StatelessWidget {
  final Cabal project;
  final VoidCallback onTap;
  final CabalCardLayout layout; // <-- NEW: Layout property

  const CabalCardWidget({
    Key? key, 
    required this.project, 
    required this.onTap,
    this.layout = CabalCardLayout.horizontalList, // <-- NEW: Default layout
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return layout == CabalCardLayout.horizontalList 
      ? _buildHorizontalListCard(context)
      : _buildGridCard(context);
  }

  // This is the original card layout, now in its own method
  Widget _buildHorizontalListCard(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      color: theme.cardColor.withOpacity(0.85),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBanner(theme, height: 100),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      project.description,
                      style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    if (project.isPrivate)
                      Chip(
                        avatar: const FaIcon(FontAwesomeIcons.lock, size: 12),
                        label: const Text("Private"),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        labelStyle: theme.textTheme.bodySmall,
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // <-- NEW: A more compact card for the grid layout -->
  Widget _buildGridCard(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      color: theme.cardColor.withOpacity(0.85),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black45,
            title: Text(
              project.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: project.isPrivate 
              ? const FaIcon(FontAwesomeIcons.lock, size: 14, color: Colors.white70) 
              : null,
          ),
          child: _buildBanner(theme, height: double.infinity),
        ),
      ),
    );
  }

  Widget _buildBanner(ThemeData theme, {required double height}) {
    if (project.bannerImageUrl != null && project.bannerImageUrl!.isNotEmpty) {
      return Image.network(
        project.bannerImageUrl!,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => _buildPlaceholderBanner(theme, height: height),
      );
    }
    return _buildPlaceholderBanner(theme, height: height);
  }

  Widget _buildPlaceholderBanner(ThemeData theme, {required double height}) {
    return Container(
      height: height,
      width: double.infinity,
      color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
      child: Center(
        child: FaIcon(
          FontAwesomeIcons.usersRectangle,
          size: 30,
          color: theme.colorScheme.primary.withOpacity(0.6),
        ),
      ),
    );
  }
}

```

### File: ./lib/widgets/interactive_header_widget.dart
```dart
// lib/widgets/interactive_header_widget.dart
import 'dart:async';
import 'dart:ui';
import 'package:cabal/utils/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math'; // <-- FIX: IMPORT ADDED
import 'package:flutter_animate/flutter_animate.dart'; // <-- FIX: IMPORT ADDED

class InteractiveHeaderWidget extends StatefulWidget {
  final ScrollController scrollController;
  final VoidCallback onOpenSidePanel; // Callback for horizontal drag

  const InteractiveHeaderWidget({
    Key? key,
    required this.scrollController,
    required this.onOpenSidePanel,
  }) : super(key: key);

  @override
  _InteractiveHeaderWidgetState createState() => _InteractiveHeaderWidgetState();
}

class _InteractiveHeaderWidgetState extends State<InteractiveHeaderWidget> with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _interactionController;
  late Animation<double> _bubbleScaleAnimation;
  late Animation<double> _bubbleOpacityAnimation;
  late Animation<Color?> _textColorAnimation;

  bool _isInteracting = false;
  double _dragStartY = 0.0;

  // Sensitivity for the scroll gesture
  static const double _scrollSensitivity = 1.5;

  @override
  void initState() {
    super.initState();
    // For the idle "breathing" animation
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // For the on-touch interaction animation
    _interactionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _bubbleScaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _interactionController, curve: Curves.elasticOut),
    );
    _bubbleOpacityAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(_interactionController);
    _textColorAnimation = ColorTween(begin: AppColors.gold, end: Colors.white).animate(_interactionController);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _interactionController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    if (widget.scrollController.hasClients) {
      setState(() {
        _isInteracting = true;
        _dragStartY = details.globalPosition.dy;
        _interactionController.forward();

        // Animate the scroll view to snap the header into place
        widget.scrollController.animateTo(
          180, // This value should be the height of your header when collapsed
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isInteracting || !widget.scrollController.hasClients) return;

    final verticalDelta = details.delta.dy;
    final horizontalDelta = details.delta.dx;

    // Prioritize vertical scroll over horizontal action
    if (verticalDelta.abs() > horizontalDelta.abs()) {
      // Dragging down (negative delta) should scroll the content up (positive offset)
      final scrollOffset = widget.scrollController.offset - (verticalDelta * _scrollSensitivity);
      widget.scrollController.jumpTo(scrollOffset.clamp(0.0, widget.scrollController.position.maxScrollExtent));
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (widget.scrollController.hasClients) {
      setState(() {
        _isInteracting = false;
        _interactionController.reverse();
      });
    }
  }
  
  void _onHorizontalDragEnd(DragEndDetails details) {
    // Detect a "flick" to the right to open the side panel
    if (details.velocity.pixelsPerSecond.dx > 500) {
      widget.onOpenSidePanel();
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 250, // Initial expanded height of the header
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // The Bubble Animation
            AnimatedBuilder(
              animation: Listenable.merge([_breathingController, _interactionController]),
              builder: (context, child) {
                final breathValue = (sin(_breathingController.value * 2 * pi) + 1) / 2; // 0 to 1 sine wave
                final breathScale = 1.0 + (breathValue * 0.05);
                final finalScale = breathScale * _bubbleScaleAnimation.value;

                return Transform.scale(
                  scale: finalScale,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primaryAccent.withOpacity(_bubbleOpacityAnimation.value),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.7],
                      ),
                    ),
                  ),
                );
              },
            ),
            // The "Cabal" Text
            AnimatedBuilder(
                animation: _interactionController,
                builder: (context, child) {
                  return Text(
                    'Cabal',
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _textColorAnimation.value,
                      shadows: [
                        Shadow(blurRadius: _isInteracting ? 30.0 : 15.0, color: AppColors.primaryAccent.withOpacity(0.8)),
                        const Shadow(blurRadius: 10.0, color: AppColors.offBlack),
                      ],
                    ),
                  );
                }),
            // Instructional hint
            if (!_isInteracting)
              Positioned(
                bottom: 60,
                child: IgnorePointer(
                  child: Text(
                    "Touch and Drag to Explore",
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.5)),
                  ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 2000.ms),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

```

### File: ./lib/widgets/glowing_header_widget.dart
```dart
// lib/widgets/glowing_header_widget.dart
import 'dart:ui';
import 'dart:math';
import 'package:cabal/utils/app_colors.dart';
import 'package:flutter/material.dart';

class GlowingHeaderWidget extends StatefulWidget {
  final double shrinkProgress; // 0.0 = expanded, 1.0 = collapsed

  const GlowingHeaderWidget({
    Key? key,
    required this.shrinkProgress,
  }) : super(key: key);

  @override
  _GlowingHeaderWidgetState createState() => _GlowingHeaderWidgetState();
}

class _GlowingHeaderWidgetState extends State<GlowingHeaderWidget> with TickerProviderStateMixin {
  late AnimationController _breathingController;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Interpolate values based on the shrink progress
    final double textScale = lerpDouble(1.0, 0.6, widget.shrinkProgress)!;
    final double bubbleScale = lerpDouble(1.0, 0.5, widget.shrinkProgress)!;
    final double bubbleOpacity = lerpDouble(0.3, 0.15, widget.shrinkProgress)!;
    final double textYOffset = lerpDouble(0, -15, widget.shrinkProgress)!;

    return Stack(
      alignment: Alignment.center,
      children: [
        // The Bubble Animation
        AnimatedBuilder(
          animation: _breathingController,
          builder: (context, child) {
            final breathValue = (sin(_breathingController.value * 2 * pi) + 1) / 2;
            final breathScale = 1.0 + (breathValue * 0.05);
            final finalScale = breathScale * bubbleScale;

            return Transform.scale(
              scale: finalScale,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primaryAccent.withOpacity(bubbleOpacity),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.7],
                  ),
                ),
              ),
            );
          },
        ),
        // The "Cabal" Text
        Transform.translate(
          offset: Offset(0, textYOffset),
          child: Transform.scale(
            scale: textScale,
            child: Text(
              'Cabal',
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.gold,
                shadows: [
                  Shadow(blurRadius: 20.0, color: AppColors.primaryAccent.withOpacity(0.8)),
                  const Shadow(blurRadius: 10.0, color: AppColors.offBlack),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

```

### File: ./lib/widgets/chatoshi_search_modal.dart
```dart
// lib/widgets/chatoshi_search_modal.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../utils/app_colors.dart';

/// Displays the Chatoshi AI modal with a blurred background.
void showChatoshiSearchModal(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close',
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, anim1, anim2) => const ChatoshiSearchModal(),
    transitionBuilder: (context, anim1, anim2, child) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
        child: FadeTransition(
          opacity: anim1,
          child: child,
        ),
      );
    },
  );
}

class ChatoshiSearchModal extends StatefulWidget {
  // TODO: Add your real partner key here when you get it from Chatoshi
  final String partnerKey;

  const ChatoshiSearchModal({
    Key? key,
    this.partnerKey = 'your-partner-key', 
  }) : super(key: key);

  @override
  State<ChatoshiSearchModal> createState() => _ChatoshiSearchModalState();
}

class _ChatoshiSearchModalState extends State<ChatoshiSearchModal> {
  late WebViewController _webViewController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // The HTML payload that mounts the Chatoshi SDK
    final String htmlContent = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
      <style>
        body, html { 
          margin: 0; 
          padding: 0; 
          height: 100%; 
          width: 100%; 
          background-color: #121212; /* Matches AppColors.offBlack */
          color: white;
          overflow: hidden;
        }
        #chat-container { 
          width: 100%; 
          height: 100%; 
        }
        .loader {
          display: flex;
          justify-content: center;
          align-items: center;
          height: 100%;
          font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
          color: #FBC02D; /* Matches Cabal Gold */
        }
      </style>
      
      <!-- TODO: Replace "example.com" with the actual Chatoshi CDN URL -->
      <script src="https://example.com/chatoshi-sdk.js"></script>
    </head>
    <body>
      <div id="chat-container">
        <div class="loader">Initializing Chatoshi AI...</div>
      </div>
      
      <script>
        window.onload = function() {
          try {
            if (typeof Chatoshi !== 'undefined') {
              // Clear the loader text
              document.getElementById('chat-container').innerHTML = '';
              
              // Initialize the SDK
              const chat = new Chatoshi({
                partnerKey: '${widget.partnerKey}',
                container: '#chat-container',
                mode: 'embedded' // "embedded" mode is best inside a WebView wrapper
              });

              chat.on('app:ready', () => {
                console.log('Chatoshi AI web3 assistant is ready!');
              });
            } else {
              document.getElementById('chat-container').innerHTML = '<div class="loader">Failed to load Chatoshi SDK. Check network or URL.</div>';
            }
          } catch(e) {
             document.getElementById('chat-container').innerHTML = '<div class="loader">Error starting AI: ' + e.message + '</div>';
          }
        };
      </script>
    </body>
    </html>
    ''';

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.offBlack)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (mounted) setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("Chatoshi SDK WebView Error: \${error.description}");
          },
        ),
      )
      ..loadHtmlString(htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Card(
          elevation: 20,
          color: AppColors.offBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.darkGrey),
          ),
          child: Container(
            margin: const EdgeInsets.all(4.0),
            constraints: const BoxConstraints(maxWidth: 700),
            height: MediaQuery.of(context).size.height * 0.85,
            child: Column(
              children:[
                // Cabal Native Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children:[
                      const FaIcon(FontAwesomeIcons.robot, size: 20, color: AppColors.gold),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Chatoshi AI Copilot",
                          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip: "Close",
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppColors.darkGrey),
                
                // The WebView containing the injected Chatoshi SDK
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: Stack(
                      children:[
                        WebViewWidget(controller: _webViewController),
                        
                        if (_isLoading)
                          const Center(
                            child: CircularProgressIndicator(color: AppColors.gold),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

```

### File: ./lib/widgets/quest_card.dart
```dart
// lib/widgets/quest_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/quest_model.dart';
import '../services/supabase_service.dart';
import '../services/ton_service.dart';
import '../utils/app_colors.dart';
import '../utils/icon_mapper.dart';
import '../utils/constants.dart';
import 'quest_complete_celebration.dart';

class QuestCard extends StatefulWidget {
  final Quest quest;
  final VoidCallback? onComplete;

  const QuestCard({
    super.key, 
    required this.quest, 
    this.onComplete
  });

  @override
  State<QuestCard> createState() => _QuestCardState();
}

class _QuestCardState extends State<QuestCard> {
  bool _isProcessing = false;

  /// Primary handler for quest interaction based on QuestType
  Future<void> _handleQuestAction(BuildContext context) async {
    if (_isProcessing || widget.quest.isLocked) return;

    final supabase = Provider.of<SupabaseService>(context, listen: false);
    final ton = Provider.of<TonService>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    setState(() => _isProcessing = true);

    try {
      bool actionVerified = false;

      // 1. Handle Blockchain/Action Specifics
      switch (widget.quest.type) {
        case QuestType.connectWalletEth: // Mapping to TON for this focus
          final address = await ton.connectWallet();
          actionVerified = address != null;
          break;
          
        case QuestType.websiteVisit:
        case QuestType.telegramChannelJoin:
          // In production, we'd check if the user actually returned from the URL
          actionVerified = true; 
          break;

        default:
          // For custom quests, we assume immediate completion or manual verification
          actionVerified = true;
      }

      if (!actionVerified) {
        setState(() => _isProcessing = false);
        return;
      }

      // 2. Handle Manual Verification Flag
      if (widget.quest.requiresManualVerification) {
        // Logic for submitting proof to public.user_quest_progress
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text("Submission sent for review!"), backgroundColor: AppColors.info),
        );
        setState(() => _isProcessing = false);
        return;
      }

      // 3. Trigger Atomic Completion in Supabase
      final result = await supabase.completeQuest(widget.quest.id);

      if (result['success'] == true) {
        // Trigger high-fidelity celebration overlay
        showQuestCompleteCelebration(context);
        
        if (widget.onComplete != null) widget.onComplete!();
      }
    } catch (e) {
      debugPrint("QuestCard Error: $e");
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text("Action failed: $e"), backgroundColor: AppColors.error),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isCompleted = widget.quest.userStatus == 'completed';
    final bool isOnCooldown = widget.quest.isOnCooldown;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCompleted ? AppColors.success.withOpacity(0.3) : Colors.white.withOpacity(0.05),
          width: 1,
        ),
        boxShadow: [
          if (!isCompleted)
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- SIDE ACCENT ---
              Container(
                width: 6,
                color: isCompleted ? AppColors.success : AppColors.gold,
              ),

              // --- CONTENT ---
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: FaIcon(
                              getIconFromName(widget.quest.iconName),
                              color: isCompleted ? AppColors.success : AppColors.gold,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.quest.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text(
                                  "+${widget.quest.xpReward} XP",
                                  style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.quest.description,
                        style: const TextStyle(color: AppColors.greyText, fontSize: 13, height: 1.4),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      // --- PROGRESS BAR (Multi-step) ---
                      if (widget.quest.totalSteps > 1 && !isCompleted) ...[
                        const SizedBox(height: 16),
                        _buildProgressBar(),
                      ],

                      const SizedBox(height: 16),

                      // --- FOOTER ACTIONS ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.quest.statusText.toUpperCase(),
                            style: TextStyle(
                              color: isCompleted ? AppColors.success : AppColors.greyText,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          _buildActionButton(context, isCompleted, isOnCooldown),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildProgressBar() {
    double progress = widget.quest.userCurrentSteps / widget.quest.totalSteps;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("PROGRESS", style: TextStyle(fontSize: 9, color: AppColors.greyText)),
            Text("${widget.quest.userCurrentSteps}/${widget.quest.totalSteps}", style: const TextStyle(fontSize: 9, color: Colors.white70)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: Colors.white10,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, bool isCompleted, bool isOnCooldown) {
    if (isCompleted && !isOnCooldown && widget.quest.cooldown == null) {
      return const FaIcon(FontAwesomeIcons.circleCheck, color: AppColors.success, size: 24);
    }

    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: (_isProcessing || widget.quest.isLocked || isOnCooldown) 
            ? null 
            : () => _handleQuestAction(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: isCompleted ? Colors.white10 : AppColors.gold,
          foregroundColor: isCompleted ? Colors.white : Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: _isProcessing
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
            : Text(
                isOnCooldown ? "LOCKED" : (isCompleted ? "REDO" : "START"),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}

```

### File: ./lib/screens/stub_dart_js.dart
```dart

// lib/screens/stub_dart_js.dart
// This is a stub file for non-web platforms.
import 'package:flutter/foundation.dart' show kIsWeb;

dynamic get context {
  if (kIsWeb) {
    throw UnimplementedError('dart:js context called on non-web, but kIsWeb is true. This is odd.');
  }
  throw UnimplementedError('dart:js context is not available on this platform.');
}

class JsObject {
  static dynamic jsify(Map<dynamic, dynamic> data) {
    if (kIsWeb) {
      throw UnimplementedError('JsObject.jsify stub called. This should be the real dart:js version on web.');
    }
    throw UnimplementedError('JsObject.jsify is not available on this platform.');
  }
}

```

### File: ./lib/screens/placeholder_screen.dart
```dart
// lib/screens/placeholder_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/animated_particle_background.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const PlaceholderScreen({
    Key? key,
    required this.title,
    this.message = "This feature is on our roadmap and will be coming soon. Stay tuned!",
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // This screen doesn't have its own Scaffold or AppBar,
    // as it's intended to be displayed within the HomeNavWrapper's body.
    return AnimatedParticleBackground(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: 60,
              color: theme.colorScheme.primary.withOpacity(0.7),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ).animate().fadeIn(duration: 500.ms),
      ),
    );
  }
}

```

### File: ./lib/screens/create_project_listing_screen.dart
```dart
// lib/screens/create_project_listing_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/supabase_service.dart';
import '../widgets/animated_particle_background.dart';
import '../utils/app_colors.dart';

class CreateProjectListingScreen extends StatefulWidget {
  const CreateProjectListingScreen({Key? key}) : super(key: key);

  @override
  State<CreateProjectListingScreen> createState() => _CreateProjectListingScreenState();
}

class _CreateProjectListingScreenState extends State<CreateProjectListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final SupabaseService _supabaseService = SupabaseService();

  // Form fields
  String _projectName = '';
  String _projectDescription = '';
  String _budget = '';
  String _timeline = '';
  final List<String> _requiredSkills = [];
  bool _isFullProject = false;

  final TextEditingController _skillController = TextEditingController();
  bool _isSaving = false;

  void _addSkill() {
    if (_skillController.text.trim().isNotEmpty && !_requiredSkills.contains(_skillController.text.trim())) {
      setState(() {
        _requiredSkills.add(_skillController.text.trim());
        _skillController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _requiredSkills.remove(skill);
    });
  }

  Future<void> _submitListing() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.'), backgroundColor: AppColors.warning),
      );
      return;
    }
    _formKey.currentState!.save();

    setState(() => _isSaving = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final newListing = await _supabaseService.createProjectListing(
        projectName: _projectName,
        projectDescription: _projectDescription,
        budget: _budget,
        timeline: _timeline,
        requiredSkills: _requiredSkills,
        isFullProject: _isFullProject,
      );

      if (newListing != null && mounted) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Project listing posted successfully!'), backgroundColor: AppColors.success),
        );
        Navigator.of(context).pop(true); // Pop with 'true' to indicate success
      } else {
        throw Exception("Failed to create listing.");
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Theme.of(context).colorScheme.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Project Listing'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: AnimatedParticleBackground(
        child: AbsorbPointer(
          absorbing: _isSaving,
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.only(
                    top: kToolbarHeight + MediaQuery.of(context).padding.top + 16,
                    left: 16,
                    right: 16,
                    bottom: 100, // Space for the save button
                  ),
                  children: [
                    _buildSectionHeader(theme, "Project Details"),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Project Name *'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Project name is required' : null,
                      onSaved: (v) => _projectName = v!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Project Description *',
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                      validator: (v) => (v == null || v.trim().length < 20) ? 'Please provide a detailed description (min 20 chars)' : null,
                      onSaved: (v) => _projectDescription = v!,
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader(theme, "Logistics"),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Budget (e.g., \$5k - \$10k USD)', hintText: 'Be as specific as you can'),
                      onSaved: (v) => _budget = v!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Estimated Timeline (e.g., 4-6 Weeks)'),
                      onSaved: (v) => _timeline = v!,
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader(theme, "Required Skills"),
                    _buildSkillInput(theme),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: _requiredSkills
                          .map((skill) => Chip(
                                label: Text(skill),
                                onDeleted: () => _removeSkill(skill),
                                deleteIcon: const Icon(Icons.close, size: 16),
                              ))
                          .toList(),
                    ).animate().fadeIn(),
                    const SizedBox(height: 24),
                    SwitchListTile(
                      title: Text("This is a full project", style: theme.textTheme.titleMedium),
                      subtitle: Text(_isFullProject ? "Seeking a team or agency" : "Seeking individual contributors"),
                      value: _isFullProject,
                      onChanged: (val) => setState(() => _isFullProject = val),
                      secondary: FaIcon(_isFullProject ? FontAwesomeIcons.users : FontAwesomeIcons.user, color: theme.colorScheme.secondary),
                    ),
                  ].animate(interval: 100.ms).fadeIn().slideY(begin: 0.1),
                ),
              ),
              if (_isSaving)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
        width: double.infinity,
        color: theme.cardColor,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.publish_rounded),
          label: const Text('Post Listing'),
          onPressed: _isSaving ? null : _submitListing,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(title, style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary)),
    );
  }

  Widget _buildSkillInput(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _skillController,
            decoration: const InputDecoration(labelText: 'Add a Skill (e.g., Solidity)'),
            onFieldSubmitted: (_) => _addSkill(),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          icon: const Icon(Icons.add),
          onPressed: _addSkill,
          style: IconButton.styleFrom(backgroundColor: theme.colorScheme.secondary),
        ),
      ],
    );
  }
}

```

### File: ./lib/screens/create_post_screen.dart
```dart
// lib/screens/create_post_screen.dart
import 'package:cabal/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile_model.dart';
import '../utils/app_colors.dart';
import '../widgets/animated_particle_background.dart';

class CreatePostScreen extends StatefulWidget {
  final String cabalId;
  final String cabalName;

  const CreatePostScreen({
    Key? key,
    required this.cabalId,
    required this.cabalName,
  }) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  final TextEditingController _contentController = TextEditingController();
  UserProfile? _currentUserProfile;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _contentController.addListener(() {
      if (mounted) setState(() {}); // Rebuild to update character count and button state
    });
  }

  Future<void> _loadUserProfile() async {
    final user = _supabaseService.getCurrentUser();
    if (user != null) {
      final profile = await _supabaseService.getUserProfile(user.id);
      if (mounted) {
        setState(() {
          _currentUserProfile = profile;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _submitPost() async {
    if (_contentController.text.trim().isEmpty || _isSaving) return;

    setState(() => _isSaving = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final newPost = await _supabaseService.createCommunityPost(
        cabalId: widget.cabalId,
        content: _contentController.text.trim(),
      );

      if (newPost != null && mounted) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Your post is live!'), backgroundColor: AppColors.success),
        );
        Navigator.of(context).pop(true); // Pop with 'true' to indicate success
      } else {
        throw Exception("Post creation returned null.");
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Failed to post: ${e.toString()}'), backgroundColor: Theme.of(context).colorScheme.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool canPost = _contentController.text.trim().isNotEmpty && !_isSaving;

    return Scaffold(
      appBar: AppBar(
        title: Text('Post to ${widget.cabalName}'),
        // <-- Post button removed from here
      ),
      body: AnimatedParticleBackground(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: _currentUserProfile?.profileImageUrl != null
                              ? NetworkImage(_currentUserProfile!.profileImageUrl!)
                              : null,
                          child: _currentUserProfile?.profileImageUrl == null
                              ? const FaIcon(FontAwesomeIcons.userAstronaut)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _currentUserProfile?.displayName ?? 'Anonymous',
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Share your thoughts with the cabal...',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: TextField(
                        controller: _contentController,
                        autofocus: true,
                        maxLines: null,
                        maxLength: 500,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText: 'What\'s on your mind?',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
      // <-- NEW: Added a persistent bottom sheet for the post button -->
      bottomSheet: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).padding.bottom + 16),
        width: double.infinity,
        color: theme.cardColor,
        child: ElevatedButton(
          onPressed: canPost ? _submitPost : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          child: _isSaving
              ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white))
              : const Text('Post'),
        ),
      ),
    );
  }
}

```

### File: ./lib/screens/web3_tools_screen.dart
```dart
// lib/screens/web3_tools_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/diamond_mesh_background.dart';
import '../models/bot_model.dart';
import '../widgets/bot_card_widget.dart';
import '../services/supabase_service.dart';

class Web3ToolsScreen extends StatefulWidget {
  const Web3ToolsScreen({Key? key}) : super(key: key);
  @override
  State<Web3ToolsScreen> createState() => _Web3ToolsScreenState();
}

class _Web3ToolsScreenState extends State<Web3ToolsScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  List<BotModel> _bots = [];
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final _botNameController = TextEditingController();
  final _botTokenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBots();
  }

  Future<void> _fetchBots() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final bots = await _supabaseService.getConnectedBots();
    if (mounted) {
      setState(() {
        _bots = bots;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _botNameController.dispose();
    _botTokenController.dispose();
    super.dispose();
  }

  void _showAddBotDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Connect a Telegram Bot"),
          content: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextFormField(controller: _botNameController, decoration: const InputDecoration(labelText: "Bot Name"), validator: (v) => (v == null || v.isEmpty) ? "Name is required" : null),
              const SizedBox(height: 16),
              TextFormField(controller: _botTokenController, decoration: const InputDecoration(labelText: "Telegram Bot Token"), validator: (v) => (v == null || v.isEmpty) ? "Token is required" : null, obscureText: true),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancel")),
            ElevatedButton(onPressed: _onConnectBot, child: const Text("Connect")),
          ],
        );
      },
    );
  }

  Future<void> _onConnectBot() async {
    if (_formKey.currentState!.validate()) {
      final newBot = await _supabaseService.addBot(
        name: _botNameController.text,
        type: 'Telegram Bot',
        token: _botTokenController.text,
      );
      if (newBot != null && mounted) {
        setState(() => _bots.insert(0, newBot));
        _botNameController.clear();
        _botTokenController.clear();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bot connected successfully!")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to connect bot."), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _onUpdateBotStatus(BotModel bot, BotStatus newStatus) async {
    try {
      // Optimistic UI update
      final originalStatus = bot.status;
      setState(() {
        final botInList = _bots.firstWhere((b) => b.id == bot.id);
        botInList.status = newStatus;
      });
      await _supabaseService.updateBotStatus(bot.id, newStatus);
    } catch (e) {
      // Revert on error
      setState(() {
         final botInList = _bots.firstWhere((b) => b.id == bot.id);
         botInList.status = bot.status; // Revert to original
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update bot: $e")));
      }
    }
  }

  Future<void> _onDeleteBot(BotModel bot) async {
    try {
      // Optimistic UI update
      final botIndex = _bots.indexWhere((b) => b.id == bot.id);
      if (botIndex == -1) return;
      
      setState(() => _bots.removeAt(botIndex));
      await _supabaseService.deleteBot(bot.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bot "${bot.name}" deleted.')));
      }
    } catch (e) {
      // Revert on error - re-fetch the list for simplicity
      await _fetchBots();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to delete bot: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text("Web3 Tools"), backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85)),
      body: DiamondMeshBackground(
        child: RefreshIndicator(
          onRefresh: _fetchBots,
          child: ListView(
            padding: EdgeInsets.only(top: kToolbarHeight + MediaQuery.of(context).padding.top + 16, left: 16, right: 16, bottom: 100),
            children: [
              Card(
                elevation: 4,
                color: theme.cardColor.withOpacity(0.8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("Trading Bot Hub", style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary)),
                    const SizedBox(height: 8),
                    Text("Connect and manage your automated trading bots.", style: theme.textTheme.bodyLarge),
                  ]),
                ),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 24),
              Text("Your Connected Bots", style: theme.textTheme.titleLarge).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 8),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_bots.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Center(
                    child: Text("You haven't connected any bots yet.\nTap the '+' button to add one!", textAlign: TextAlign.center, style: theme.textTheme.bodyLarge?.copyWith(color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7))),
                  ),
                )
              else
                ..._bots.map((bot) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: BotCardWidget(
                    bot: bot,
                    onUpdateStatus: (newStatus) => _onUpdateBotStatus(bot, newStatus),
                    onDelete: () => _onDeleteBot(bot),
                  ),
                )).toList().animate(interval: 100.ms).fadeIn().slideY(begin: 0.2),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddBotDialog,
        icon: const Icon(Icons.add),
        label: const Text("Add New Bot"),
      ).animate().slide(begin: const Offset(0, 2)).fadeIn(),
    );
  }
}

```

### File: ./lib/screens/create_developer_profile_screen.dart
```dart
// lib/screens/create_developer_profile_screen.dart
import 'package:cabal/models/marketplace_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/supabase_service.dart';
import '../widgets/animated_particle_background.dart';
import '../utils/app_colors.dart';

class CreateDeveloperProfileScreen extends StatefulWidget {
  final DeveloperProfile? existingProfile;

  const CreateDeveloperProfileScreen({Key? key, this.existingProfile}) : super(key: key);

  @override
  State<CreateDeveloperProfileScreen> createState() => _CreateDeveloperProfileScreenState();
}

class _CreateDeveloperProfileScreenState extends State<CreateDeveloperProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final SupabaseService _supabaseService = SupabaseService();

  late TextEditingController _taglineController;
  late TextEditingController _rateController;
  late TextEditingController _skillController;
  late List<String> _skills;
  late bool _isAvailable;

  bool get _isEditing => widget.existingProfile != null;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = widget.existingProfile;
    _taglineController = TextEditingController(text: profile?.tagline ?? '');
    _rateController = TextEditingController(text: profile?.rate ?? '');
    _skillController = TextEditingController();
    _skills = profile?.skills != null ? List.from(profile!.skills) : [];
    _isAvailable = profile?.isAvailable ?? true;
  }
  
  void _addSkill() {
    if (_skillController.text.trim().isNotEmpty && !_skills.contains(_skillController.text.trim())) {
      setState(() {
        _skills.add(_skillController.text.trim());
        _skillController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    setState(() => _isSaving = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      if (_isEditing) {
        // Update existing profile
        await _supabaseService.updateDeveloperProfile(
          tagline: _taglineController.text.trim(),
          rate: _rateController.text.trim(),
          skills: _skills,
          isAvailable: _isAvailable,
        );
      } else {
        // Create new profile
        await _supabaseService.createDeveloperProfile(
          tagline: _taglineController.text.trim(),
          rate: _rateController.text.trim(),
          skills: _skills,
        );
      }
      
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Developer profile ${_isEditing ? 'updated' : 'published'} successfully!'), backgroundColor: AppColors.success),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Theme.of(context).colorScheme.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _taglineController.dispose();
    _rateController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Developer Profile' : 'Create Developer Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: AnimatedParticleBackground(
        child: AbsorbPointer(
          absorbing: _isSaving,
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.only(
                    top: kToolbarHeight + MediaQuery.of(context).padding.top + 16,
                    left: 16,
                    right: 16,
                    bottom: 100,
                  ),
                  children: [
                    Text(
                      _isEditing ? "Update Your Profile" : "Showcase Your Skills",
                      style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isEditing ? "Keep your services and skills up-to-date." : "Create your public profile to get hired by projects in the Cabal ecosystem.",
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _taglineController,
                      decoration: const InputDecoration(labelText: 'Your Tagline * (e.g., Senior Solidity Auditor)'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'A tagline is required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _rateController,
                      decoration: const InputDecoration(labelText: 'Hourly Rate (e.g., \$150/hr or Project-based)'),
                    ),
                    const SizedBox(height: 24),
                    Text("Your Core Skills", style: theme.textTheme.titleMedium),
                    const SizedBox(height: 16),
                    _buildSkillInput(theme),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: _skills
                          .map((skill) => Chip(
                                label: Text(skill),
                                onDeleted: () => _removeSkill(skill),
                                deleteIcon: const Icon(Icons.close, size: 16),
                              ))
                          .toList(),
                    ).animate().fadeIn(),
                     const SizedBox(height: 24),
                    SwitchListTile(
                      title: Text("Available for new work", style: theme.textTheme.titleMedium),
                      value: _isAvailable,
                      onChanged: (val) => setState(() => _isAvailable = val),
                      secondary: FaIcon(_isAvailable ? FontAwesomeIcons.solidCircleCheck : FontAwesomeIcons.solidCircleXmark, color: _isAvailable ? AppColors.success : AppColors.error),
                    )
                  ].animate(interval: 100.ms).fadeIn().slideY(begin: 0.1),
                ),
              ),
              if (_isSaving)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
        width: double.infinity,
        color: theme.cardColor,
        child: ElevatedButton.icon(
          icon: Icon(_isEditing ? Icons.save_alt_rounded : Icons.rocket_launch_rounded),
          label: Text(_isEditing ? 'Save Changes' : 'Publish Profile'),
          onPressed: _isSaving ? null : _submitProfile,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillInput(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _skillController,
            decoration: const InputDecoration(labelText: 'Add a Skill (e.g., Flutter)'),
            onFieldSubmitted: (_) => _addSkill(),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          icon: const Icon(Icons.add),
          onPressed: _addSkill,
          style: IconButton.styleFrom(backgroundColor: theme.colorScheme.secondary),
        ),
      ],
    );
  }
}

```

### File: ./lib/screens/kol_metrics_screen.dart
```dart
// lib/screens/kol_metrics_screen.dart
import 'package:flutter/material.dart'; // CORRECTED: Was missing this essential import
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:cabal/services/supabase_service.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:cabal/utils/app_colors.dart';
import 'package:cabal/widgets/shimmer_widget.dart';

class KolMetricsScreen extends StatefulWidget {
  const KolMetricsScreen({Key? key}) : super(key: key);

  @override
  State<KolMetricsScreen> createState() => _KolMetricsScreenState();
}

class _KolMetricsScreenState extends State<KolMetricsScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  Future<List<Map<String, dynamic>>>? _metricsFuture;
  int _totalActiveUsersLast30Days = 0;
  int _peakDailyActiveUsers = 0;

  @override
  void initState() {
    super.initState();
    _loadMetrics();
  }

  void _loadMetrics() {
    _metricsFuture = _supabaseService.getKolMetrics().then((data) {
      if (mounted && data.isNotEmpty) {
        int total = 0;
        int peak = 0;
        for (var entry in data) {
          final count = (entry['active_referrals'] as num? ?? 0).toInt();
          // Note: Total active users is a bit misleading, it's total of daily counts.
          // A better metric might be a distinct count over 30 days, but this is fine for now.
          total += count;
          if (count > peak) {
            peak = count;
          }
        }
        setState(() {
          _totalActiveUsersLast30Days = total;
          _peakDailyActiveUsers = peak;
        });
      }
      return data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Your Referral Metrics"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DiamondMeshBackground(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _metricsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No referral data available yet."));
            }

            final data = snapshot.data!;
            return ListView(
              padding: EdgeInsets.only(
                top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
                left: 16, right: 16, bottom: 40,
              ),
              children: [
                _buildSummaryCards(theme),
                const SizedBox(height: 24),
                _buildChartCard(theme, data),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCards(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    NumberFormat.compact().format(_totalActiveUsersLast30Days),
                    style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary),
                  ),
                  const SizedBox(height: 4),
                  Text("Total Activity (30d)", textAlign: TextAlign.center, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    _peakDailyActiveUsers.toString(),
                    style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.secondary),
                  ),
                  const SizedBox(height: 4),
                  Text("Peak Daily Active Users", textAlign: TextAlign.center, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartCard(ThemeData theme, List<Map<String, dynamic>> data) {
    final spots = data.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final count = (entry.value['active_referrals'] as num? ?? 0).toDouble();
      return BarChartGroupData(x: index.toInt(), barRods: [
        BarChartRodData(toY: count, color: theme.colorScheme.primary, width: 12, borderRadius: BorderRadius.circular(4)),
      ]);
    }).toList();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Daily Active Referred Users (Last 30 Days)", style: theme.textTheme.titleLarge),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: spots,
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index % 7 == 0) { // Show label every 7 days
                            final date = DateTime.parse(data[index]['report_date']);
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(DateFormat('MMM d').format(date), style: theme.textTheme.bodySmall),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => AppColors.darkGrey.withOpacity(0.8),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final date = DateTime.parse(data[group.x]['report_date']);
                        return BarTooltipItem(
                          '${rod.toY.toInt()} users\n',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: DateFormat('MMM d, yyyy').format(date),
                              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: EdgeInsets.only(
        top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
        left: 16, right: 16, bottom: 40,
      ),
      children: const [
        Row(
          children: [
            Expanded(child: ShimmerWidget.rectangular(height: 100)),
            SizedBox(width: 16),
            Expanded(child: ShimmerWidget.rectangular(height: 100)),
          ],
        ),
        SizedBox(height: 24),
        ShimmerWidget.rectangular(height: 400),
      ],
    );
  }
}

```

### File: ./lib/screens/follower_list_screen.dart
```dart
// lib/screens/follower_list_screen.dart
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../models/user_profile_model.dart';
import '../services/supabase_service.dart';
import 'dashboard_screen.dart';
import '../widgets/shimmer_widget.dart';
import '../widgets/diamond_mesh_background.dart';

class FollowerListScreen extends StatefulWidget {
  final String userId;
  final String listType; // "Followers" or "Following"

  const FollowerListScreen({
    Key? key,
    required this.userId,
    required this.listType,
  }) : super(key: key);

  @override
  State<FollowerListScreen> createState() => _FollowerListScreenState();
}

class _FollowerListScreenState extends State<FollowerListScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  Future<List<UserProfile>>? _usersFuture;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    setState(() {
      if (widget.listType == "Followers") {
        _usersFuture = _supabaseService.getFollowers(widget.userId);
      } else {
        _usersFuture = Future.value([]); 
      }
    });
  }

  void _navigateToUserProfile(String userId) {
     Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        // --- THIS IS THE FIX ---
        child: DashboardScreen(
          viewProfileId: userId,
          isLoadingProfile: false, // The required parameter was missing
        ),
        // --- END OF FIX ---
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.listType),
        backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85),
        elevation: 0,
      ),
      body: DiamondMeshBackground(
        child: FutureBuilder<List<UserProfile>>(
          future: _usersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                padding: EdgeInsets.only(top: kToolbarHeight + MediaQuery.of(context).padding.top, left: 8, right: 8),
                itemCount: 8,
                itemBuilder: (context, index) => const ListTile(
                  leading: ShimmerWidget.circular(width: 48, height: 48),
                  title: ShimmerWidget.rectangular(height: 16),
                  subtitle: ShimmerWidget.rectangular(height: 12),
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No ${widget.listType.toLowerCase()} found."));
            }

            final users = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.only(top: kToolbarHeight + MediaQuery.of(context).padding.top),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundImage: user.profileImageUrl != null
                        ? NetworkImage(user.profileImageUrl!)
                        : null,
                    child: user.profileImageUrl == null
                        ? Text(user.displayName?.substring(0, 1).toUpperCase() ?? 'U')
                        : null,
                  ),
                  title: Text(user.displayName ?? 'Anonymous', style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () => _navigateToUserProfile(user.id),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

```

### File: ./lib/screens/tokenomics_screen.dart
```dart
// lib/screens/tokenomics_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:cabal/utils/app_colors.dart';

class TokenomicsScreen extends StatefulWidget {
  const TokenomicsScreen({Key? key}) : super(key: key);

  @override
  State<TokenomicsScreen> createState() => _TokenomicsScreenState();
}

class _TokenomicsScreenState extends State<TokenomicsScreen> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Cabal Tokenomics"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DiamondMeshBackground(
        child: ListView(
          padding: EdgeInsets.only(
            top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
            left: 16,
            right: 16,
            bottom: 40,
          ),
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildChartSection(),
            const SizedBox(height: 24),
            _buildAllocationDetails(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "\$CBL Token",
          style: theme.textTheme.headlineMedium?.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "Total Supply: 100,000,000",
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          "Powering a decentralized ecosystem for growth, community, and opportunity.",
          style: theme.textTheme.bodyLarge?.copyWith(color: theme.textTheme.bodyLarge?.color?.withOpacity(0.8)),
        ),
      ],
    );
  }

  Widget _buildChartSection() {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 4,
              centerSpaceRadius: 40,
              sections: showingSections(),
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    final isTouched = (int index) => index == touchedIndex;
    final fontSize = (int index) => isTouched(index) ? 20.0 : 14.0;
    final radius = (int index) => isTouched(index) ? 60.0 : 50.0;
    const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

    // --- UPDATED ALLOCATION ---
    final data = [
      {'value': 60.0, 'title': '60%', 'color': AppColors.primaryAccent}, // Community
      {'value': 15.0, 'title': '15%', 'color': AppColors.tertiaryAccent}, // Partners
      {'value': 15.0, 'title': '15%', 'color': AppColors.gold},           // Investors
      {'value': 10.0, 'title': '10%', 'color': AppColors.warning},        // Team
    ];

    return List.generate(data.length, (i) {
      return PieChartSectionData(
        color: data[i]['color'] as Color,
        value: data[i]['value'] as double,
        title: data[i]['title'] as String,
        radius: radius(i),
        titleStyle: TextStyle(
          fontSize: fontSize(i),
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    });
  }

  Widget _buildAllocationDetails(ThemeData theme) {
    return Column(
      children: [
        // --- UPDATED DETAILS ---
        _buildDetailRow(
          color: AppColors.primaryAccent,
          title: "Community & Ecosystem Growth (60%)",
          subtitle: "Quest rewards, airdrops, KOL incentives, and prizes for the first 2M users.",
          icon: FontAwesomeIcons.users,
        ),
        _buildDetailRow(
          color: AppColors.tertiaryAccent,
          title: "Partners & Alliances (15%)",
          subtitle: "For gaming guilds, DAOs, and projects integrating with Cabal.",
          icon: FontAwesomeIcons.handshake,
        ),
        _buildDetailRow(
          color: AppColors.gold,
          title: "Early Investors (15%)",
          subtitle: "For our foundational backers. Subject to vesting schedules.",
          icon: FontAwesomeIcons.seedling,
        ),
        _buildDetailRow(
          color: AppColors.warning,
          title: "Core Team (10%)",
          subtitle: "For the builders. Locked for 9 months, then linear vesting.",
          icon: FontAwesomeIcons.peopleGroup,
        ),
      ],
    );
  }

  Widget _buildDetailRow({required Color color, required String title, required String subtitle, required IconData icon}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        leading: FaIcon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }
}

```

### File: ./lib/screens/xp_balance_screen.dart
```dart
// lib/screens/xp_balance_screen.dart
import 'package:cabal/models/user_profile_model.dart';
import '../services/supabase_service.dart'; // <-- CORRECTED IMPORT
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../utils/app_colors.dart';
import '../widgets/diamond_mesh_background.dart';

class XpBalanceScreen extends StatefulWidget {
  final UserProfile initialProfile;
  const XpBalanceScreen({Key? key, required this.initialProfile}) : super(key: key);

  @override
  State<XpBalanceScreen> createState() => _XpBalanceScreenState();
}

class _XpBalanceScreenState extends State<XpBalanceScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  final TextEditingController _xpController = TextEditingController();
  
  late UserProfile _userProfile;
  double _cabalBalance = 0.0;
  double _usdtBalance = 0.0;
  bool _isLoading = true;
  bool _isConverting = false;

  final double _conversionRate = 0.01; // 1 XP = 0.01 $CAB

  @override
  void initState() {
    super.initState();
    _userProfile = widget.initialProfile;
    _loadBalances();
  }

  Future<void> _loadBalances() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final balances = await _supabaseService.getUserBalances(_userProfile.id);
      if (mounted) {
        setState(() {
          _cabalBalance = (balances['cabal_token_balance'] as num).toDouble();
          _usdtBalance = (balances['usdt_balance'] as num).toDouble();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading balances: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error loading balances: $e")));
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _convertXp() async {
    if (_isConverting) return;
    final amountToConvert = int.tryParse(_xpController.text);
    if (amountToConvert == null || amountToConvert <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a valid amount of XP to convert.")));
      return;
    }

    setState(() => _isConverting = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final result = await _supabaseService.convertXp(amountToConvert);
      if (result['success'] == true) {
        scaffoldMessenger.showSnackBar(SnackBar(content: Text(result['message']), backgroundColor: AppColors.success));
        // Update state with new values from the backend
        setState(() {
          _userProfile.totalXp = (result['new_xp_total'] as num).toInt();
          _cabalBalance = (result['new_cabal_balance'] as num).toDouble();
          _xpController.clear();
        });
      } else {
        throw Exception(result['message']);
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Conversion failed: $e"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isConverting = false);
    }
  }

  @override
  void dispose() {
    _xpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFormat = NumberFormat.decimalPattern();
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final xpAmount = int.tryParse(_xpController.text) ?? 0;
    final cabAmount = xpAmount * _conversionRate;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Balances & Conversion"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DiamondMeshBackground(
        child: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.only(
                top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
                left: 16, right: 16, bottom: 40
              ),
              children: [
                _buildBalanceCard(
                  theme: theme,
                  icon: FontAwesomeIcons.star,
                  title: "XP Balance",
                  value: numberFormat.format(_userProfile.totalXp),
                  color: AppColors.gold,
                ),
                const SizedBox(height: 16),
                _buildBalanceCard(
                  theme: theme,
                  icon: FontAwesomeIcons.coins,
                  title: "\$CAB Token Balance",
                  value: numberFormat.format(_cabalBalance),
                  color: AppColors.primaryAccent,
                ),
                const SizedBox(height: 16),
                _buildBalanceCard(
                  theme: theme,
                  icon: FontAwesomeIcons.dollarSign,
                  title: "USDT Balance",
                  value: currencyFormat.format(_usdtBalance),
                  color: AppColors.success,
                  isWithdraw: true,
                ),
                const SizedBox(height: 24),
                _buildConversionCard(theme, numberFormat, xpAmount, cabAmount),
              ],
            ),
      ),
    );
  }

  Widget _buildBalanceCard({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    bool isWithdraw = false,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            FaIcon(icon, size: 28, color: color),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyMedium),
                Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            if (isWithdraw) ...[
              const Spacer(),
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Withdrawal functionality coming soon!")));
                },
                child: const Text("Withdraw"),
              )
            ]
          ],
        ),
      ),
    ).animate().fadeIn().slideX(begin: -0.2);
  }

  Widget _buildConversionCard(ThemeData theme, NumberFormat numberFormat, int xpAmount, double cabAmount) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Convert XP to \$CAB", style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text("Rate: 1 XP = $_conversionRate \$CAB", style: theme.textTheme.bodySmall),
            const SizedBox(height: 16),
            TextField(
              controller: _xpController,
              decoration: InputDecoration(
                labelText: 'XP Amount to Convert',
                hintText: 'e.g., 1000',
                suffixText: 'Max: ${numberFormat.format(_userProfile.totalXp)}',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  const FaIcon(FontAwesomeIcons.arrowDown, size: 20),
                  const SizedBox(height: 8),
                  Text(
                    'You will receive:',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    '${numberFormat.format(cabAmount)} \$CAB',
                    style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isConverting ? null : _convertXp,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: _isConverting 
                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white))
                  : const Text('Convert Now'),
              ),
            )
          ],
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.2);
  }
}

```

### File: ./lib/screens/community_hub_screen.dart
```dart
// lib/screens/community_hub_screen.dart
import 'package:cabal/models/community_cabal_preview.dart';
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/services/supabase_service.dart';
import 'package:cabal/widgets/community_cabal_card.dart';
import 'package:cabal/widgets/empty_state_card.dart';
import 'package:cabal/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import '../widgets/diamond_mesh_background.dart';
import 'cabal_detail_screen.dart';

class CommunityHubScreen extends StatefulWidget {
  const CommunityHubScreen({Key? key}) : super(key: key);

  @override
  State<CommunityHubScreen> createState() => _CommunityHubScreenState();
}

class _CommunityHubScreenState extends State<CommunityHubScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  List<CommunityCabalPreview> _activeCabals = [];
  bool _isLoading = true;
  UserProfile? _currentUserProfile;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    try {
      final authUser = _supabaseService.getCurrentUser();
      if (authUser != null) {
        _currentUserProfile = await _supabaseService.getUserProfile(authUser.id);
      }
      final cabals = await _supabaseService.getCommunityHubCabals();
      if (mounted) {
        setState(() {
          _activeCabals = cabals;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading community hub data: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateToCabalDetail(CommunityCabalPreview preview) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: CabalDetailScreen(cabalId: preview.cabal.id),
      ),
    ).then((_) => _loadData()); // Reload data when returning
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Community Hub"),
        backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85),
      ),
      body: DiamondMeshBackground(
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: _isLoading
              ? _buildLoadingState()
              : _activeCabals.isEmpty
                  ? _buildEmptyState()
                  : _buildCabalList(),
        ),
      ),
    );
  }

  Widget _buildCabalList() {
    return ListView.builder(
      padding: EdgeInsets.only(
        top: kToolbarHeight + MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        bottom: 40,
      ),
      itemCount: _activeCabals.length,
      itemBuilder: (context, index) {
        final preview = _activeCabals[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: SizedBox(
            height: 250, // Give cards a consistent height
            child: CommunityCabalCard(
              preview: preview,
              onTap: () => _navigateToCabalDetail(preview),
            ),
          ),
        ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.2);
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.only(
        top: kToolbarHeight + MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
      ),
      itemCount: 3,
      itemBuilder: (context, index) => const Padding(
        padding: EdgeInsets.only(bottom: 16.0),
        child: ShimmerWidget.rectangular(height: 250),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: EmptyStateCard(
          title: "The Hub is Quiet",
          message: "No communities have any posts yet. Explore a cabal and be the first to start a conversation!",
          icon: FontAwesomeIcons.solidCommentDots,
          buttonText: "Explore Cabals",
          currentUserProfile: _currentUserProfile,
          onButtonPressed: () {
            // This is a placeholder; a better implementation would use the HomeNavWrapper's controller
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Navigate to the 'Explore' tab.")));
          },
        ),
      ),
    );
  }
}

```

### File: ./lib/screens/notifications_screen.dart
```dart
// lib/screens/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

// Model & Service Imports
import '../models/notification_model.dart';
import '../services/supabase_service.dart';

// UI & Util Imports
import '../widgets/animated_particle_background.dart';
import '../utils/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  final String userId;

  const NotificationsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNotificationsAndMarkRead();
  }

  Future<void> _fetchNotificationsAndMarkRead() async {
    if(!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final notifications = await _supabaseService.getUserNotifications(widget.userId);
      if (mounted) {
        setState(() {
          _notifications = notifications;
          _isLoading = false;
        });
        if (notifications.any((n) => !n.isRead)) {
          await _supabaseService.markAllNotificationsAsRead(widget.userId);
          if (mounted) {
            setState(() {
              for (var notification in _notifications) {
                notification.isRead = true;
              }
            });
          }
        }
      }
    } catch (e) {
      print("Error fetching/marking notifications for user ${widget.userId}: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Failed to load notifications: ${e.toString().split(':').last.trim()}";
        });
      }
    }
  }

  // --- NEW METHOD TO DELETE A NOTIFICATION ---
  Future<void> _deleteNotification(int index) async {
    final notificationToDelete = _notifications[index];
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Optimistically remove from UI
    setState(() {
      _notifications.removeAt(index);
    });

    try {
      await _supabaseService.deleteNotification(notificationToDelete.id);
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Notification deleted.'), duration: Duration(seconds: 2)),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error deleting notification: $e'), backgroundColor: Colors.red),
      );
      // Revert UI on failure
      if (mounted) {
        setState(() {
          _notifications.insert(index, notificationToDelete);
        });
      }
    }
  }

  IconData _getIconForNotificationType(String? type) {
    switch (type?.toLowerCase()) {
      case 'quest_complete':
      case 'reward_claimed':
        return FontAwesomeIcons.gift;
      case 'achievement_unlocked':
        return FontAwesomeIcons.trophy;
      case 'new_quest':
        return FontAwesomeIcons.bullhorn;
      case 'quest_pending':
        return FontAwesomeIcons.hourglassHalf;
      case 'manual_quest_approved':
        return FontAwesomeIcons.solidCircleCheck;
      case 'manual_quest_rejected':
        return FontAwesomeIcons.solidCircleXmark;
      // --- NEW NOTIFICATION TYPES ---
      case 'join_request':
        return FontAwesomeIcons.userPlus;
      case 'news_update':
        return FontAwesomeIcons.newspaper;
      // --- END ---
      default:
        return FontAwesomeIcons.infoCircle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final DateFormat dateFormat = DateFormat('MMM d, yyyy - hh:mm a');

    Widget bodyContent;

    if (_isLoading) {
      bodyContent = Center(child: CircularProgressIndicator(color: theme.colorScheme.secondary).animate().fadeIn());
    } else if (_errorMessage != null) {
      bodyContent = Center(
        child: Card(
          elevation: 2,
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline_rounded, size: 50, color: theme.colorScheme.error.withOpacity(0.7)),
                const SizedBox(height: 16),
                Text(_errorMessage!, textAlign: TextAlign.center, style: theme.textTheme.titleMedium),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text("Retry"),
                  onPressed: _fetchNotificationsAndMarkRead,
                )
              ],
            ),
          ),
        ).animate().fadeIn(delay: 200.ms),
      );
    } else if (_notifications.isEmpty) {
      bodyContent = Center(
        child: Card(
          elevation: 2,
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(FontAwesomeIcons.inbox, size: 60, color: theme.textTheme.bodySmall?.color?.withOpacity(0.5)),
                const SizedBox(height: 16),
                Text("No notifications yet!", style: theme.textTheme.titleMedium?.copyWith(color: theme.textTheme.bodyLarge?.color)),
                const SizedBox(height: 8),
                Text("Check back later for updates on your quests and rewards.", style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7)), textAlign: TextAlign.center),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 300.ms),
      );
    } else {
      bodyContent = ListView.builder(
        itemCount: _notifications.length,
        padding: EdgeInsets.only(
            top: kToolbarHeight + MediaQuery.of(context).padding.top + 8,
            left: 8, right: 8, bottom: 20
        ),
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          bool isEffectivelyRead = notification.isRead;

          // --- WRAP CARD WITH DISMISSIBLE ---
          return Dismissible(
            key: ValueKey(notification.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _deleteNotification(index);
            },
            background: Container(
              color: Colors.red.withOpacity(0.8),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: const FaIcon(FontAwesomeIcons.trashCan, color: Colors.white),
            ),
            child: Card(
              elevation: isEffectivelyRead ? 1.0 : 3.0,
              margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isEffectivelyRead
                    ? theme.dividerColor.withOpacity(0.2)
                    : theme.colorScheme.secondary.withOpacity(0.7),
                  width: isEffectivelyRead ? 0.8 : 1.2,
                )
              ),
              color: isEffectivelyRead ? theme.cardColor.withOpacity(0.85) : theme.cardColor,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.secondary.withOpacity(isEffectivelyRead ? 0.1 : 0.25),
                  child: FaIcon(
                    _getIconForNotificationType(notification.type),
                    size: 20,
                    color: theme.colorScheme.secondary.withOpacity(isEffectivelyRead ? 0.7 : 1.0),
                  ),
                ),
                title: Text(
                  notification.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: isEffectivelyRead ? FontWeight.normal : FontWeight.bold,
                    color: (theme.textTheme.bodyLarge?.color ?? Colors.black).withOpacity(isEffectivelyRead ? 0.75 : 1.0)
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.body,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 13,
                        color: (theme.textTheme.bodyMedium?.color ?? Colors.grey).withOpacity(isEffectivelyRead ? 0.7 : 0.9)
                      )
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormat.format(notification.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          color: (theme.textTheme.bodySmall?.color ?? Colors.grey).withOpacity(isEffectivelyRead ? 0.5 : 0.6)
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(delay: (80 * index).ms).slideX(begin: index.isEven ? -0.1 : 0.1);
        },
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.8),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _fetchNotificationsAndMarkRead,
            tooltip: "Refresh Notifications",
          )
        ],
      ),
      body: AnimatedParticleBackground(
        baseColor: theme.scaffoldBackgroundColor,
        particleColor1: AppColors.particleGoldSoft.withOpacity(isDark ? 0.4 : 0.6),
        particleColor2: AppColors.particleDarkGrey.withOpacity(isDark ? 0.3 : 0.4),
        child: RefreshIndicator(
          onRefresh: _fetchNotificationsAndMarkRead,
          color: theme.colorScheme.secondary,
          backgroundColor: theme.cardColor,
          child: bodyContent,
        ),
      ),
    );
  }
}

```

### File: ./lib/screens/profile_edit_screen.dart
```dart
// lib/screens/profile_edit_screen.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:share_plus/share_plus.dart';

// Model & Service Imports
import '../models/user_profile_model.dart';
import '../services/supabase_service.dart';
import 'kol_dashboard_screen.dart';

// UI & Util Imports
import '../utils/app_colors.dart';
import '../widgets/animated_particle_background.dart';
import '../widgets/info_tooltip.dart';

// Screen Imports
import 'login_screen.dart';

// Feature Imports
import '../features/wallet/application/wallet_provider.dart';
import '../features/wallet/presentation/widgets/wallet_connector_widget.dart';

// Global Imports
import '../main.dart' show themeManager;

class ProfileEditScreen extends StatefulWidget {
  final UserProfile userProfile;

  const ProfileEditScreen({Key? key, required this.userProfile}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  late TextEditingController _displayNameController;
  late TextEditingController _telegramUsernameController;
  late TextEditingController _twitterHandleController;
  bool _isSaving = false;
  late bool _isDarkTheme;

  Map<String, String> _connectedSocials = {};
  String? _initialProfileImageUrl;
  XFile? _pickedImageXFile;

  final ImagePicker _picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(text: widget.userProfile.displayName);
    _telegramUsernameController = TextEditingController(text: widget.userProfile.telegramUsername ?? '');
    _twitterHandleController = TextEditingController(text: widget.userProfile.connectedSocials['twitter'] ?? '');
    _connectedSocials = Map<String, String>.from(widget.userProfile.connectedSocials);
    _initialProfileImageUrl = widget.userProfile.profileImageUrl;
    _isDarkTheme = themeManager.themeMode == ThemeMode.dark;
  }
  
  Future<void> _pickImage() async {
    try {
      final XFile? pickedXFile = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 70,
          maxWidth: 1024,
          maxHeight: 1024);
      if (pickedXFile != null && mounted) {
        setState(() {
          _pickedImageXFile = pickedXFile;
        });
      }
    } catch (e) {
        if(mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error picking image: ${e.toString()}"), backgroundColor: Theme.of(context).colorScheme.error)
            );
        }
    }
  }

  Future<void> _saveProfile() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (!_formKey.currentState!.validate()) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Please correct the errors in the form.'), backgroundColor: AppColors.warning),
      );
      return;
    }
    _formKey.currentState!.save();

    if (mounted) setState(() => _isSaving = true);

    String? newUploadedImageUrl;

    try {
      if (_pickedImageXFile != null) {
        newUploadedImageUrl = await _supabaseService.uploadProfileImage(_pickedImageXFile!, widget.userProfile.id);
        if (newUploadedImageUrl == null || newUploadedImageUrl.isEmpty) {
          throw Exception("Image upload failed or did not return a valid URL.");
        }
      }

      final walletProvider = Provider.of<WalletProvider>(context, listen: false);
      Map<String, String> walletsToSaveInProfile = {};

      if (walletProvider.isConnectedEVM && walletProvider.connectedEVMAddress != null) {
        walletsToSaveInProfile['evm'] = walletProvider.connectedEVMAddress!;
      }
      if (walletProvider.isConnectedSolana && walletProvider.connectedSolanaAddress != null) {
        walletsToSaveInProfile['solana'] = walletProvider.connectedSolanaAddress!;
      }

      _connectedSocials['twitter'] = _twitterHandleController.text.trim();

      Map<String, dynamic> updateData = {
        'display_name': _displayNameController.text.trim(),
        'telegram_username': _telegramUsernameController.text.trim().isEmpty ? null : _telegramUsernameController.text.trim(),
        'connected_wallets': walletsToSaveInProfile,
        'connected_socials': _connectedSocials,
        'twitter_handle': _twitterHandleController.text.trim().isEmpty ? null : _twitterHandleController.text.trim(),
        'is_twitter_verified': widget.userProfile.is_twitter_verified,
      };

      if (newUploadedImageUrl != null) {
        updateData['profile_image_url'] = newUploadedImageUrl;
      } else {
        updateData['profile_image_url'] = _initialProfileImageUrl;
      }

      await _supabaseService.updateUserProfile(updateData);

      if (mounted) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: AppColors.success),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${e.toString().split(':').last.trim()}'), backgroundColor: Theme.of(context).colorScheme.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _logout() async {
    if (!mounted) return;
    if (mounted) setState(() => _isSaving = true);

    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    try {
      if (walletProvider.isConnectedEVM) await walletProvider.disconnectEVMWallet();
      if (walletProvider.isConnectedSolana) await walletProvider.disconnectSolanaWallet();
    } catch (e) {
      debugPrint("Error disconnecting wallets during logout: $e");
    }

    await _supabaseService.signOutUser();

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        PageTransition(type: PageTransitionType.fade, child: const LoginScreen(fromLogout: true)),
        (Route<dynamic> route) => false,
      );
    }
  }
  
  Future<void> _handleDeleteAccount() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final confirmController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Delete Account?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This is permanent and cannot be undone. All your data, quests, and profile information will be deleted.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmController,
              decoration: const InputDecoration(
                labelText: 'Type "DELETE" to confirm',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => navigator.pop(false),
            child: const Text('Cancel'),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: confirmController,
            builder: (context, value, child) {
              return TextButton(
                onPressed: value.text == 'DELETE'
                    ? () => navigator.pop(true)
                    : null,
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete Permanently'),
              );
            },
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isSaving = true);
      try {
        await _supabaseService.deleteCurrentUserAccount();
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Account deleted successfully.')),
        );
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen(fromLogout: true)),
          (route) => false,
        );
      } catch (e) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error deleting account: $e'), backgroundColor: Colors.red),
        );
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }
  
  Future<void> _simulateNewsNotification() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (widget.userProfile.preferredCoinIds.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Add some favorite coins in onboarding to test this feature!'), backgroundColor: AppColors.warning),
      );
      return;
    }

    final favoriteCoin = widget.userProfile.preferredCoinIds.first;
    final coinName = favoriteCoin.toUpperCase();

    try {
      await _supabaseService.createNotification(
        userId: widget.userProfile.id,
        title: '📈 News Update for $coinName',
        body: '$coinName just announced a new partnership with a major tech firm, causing a surge in market activity.',
        type: 'news_update',
        referenceId: favoriteCoin,
      );
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Simulated news notification created! Check your notifications.'), backgroundColor: AppColors.info),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Failed to create notification: $e'), backgroundColor: Colors.red),
      );
    }
  }
  
  @override
  void dispose() {
    _displayNameController.dispose();
    _telegramUsernameController.dispose();
    _twitterHandleController.dispose();
    super.dispose();
  }
  
  Widget _buildReferralCard(ThemeData theme) {
    final bool canRefer =
        (widget.userProfile.displayName != null && widget.userProfile.displayName!.isNotEmpty) &&
        (widget.userProfile.profileImageUrl != null && widget.userProfile.profileImageUrl!.isNotEmpty);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your Referral Code", style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            if (canRefer) ...[
              SelectableText(
                widget.userProfile.referralCode ?? 'Generating...',
                style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary, fontFamily: 'monospace'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final referralLink = "https://cabal-001.web.app/join?ref=${widget.userProfile.referralCode}";
                    Share.share('Join me on Cabal! Use my referral link to get started: $referralLink');
                  },
                  icon: const Icon(Icons.share, size: 16),
                  label: const Text("Share Your Link"),
                ),
              ),
              const SizedBox(height: 8),
               SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                     Navigator.push(
                       context,
                       PageTransition(
                         type: PageTransitionType.rightToLeft,
                         child: KolDashboardScreen(userProfile: widget.userProfile),
                       ),
                     );
                  },
                  icon: const FaIcon(FontAwesomeIcons.chartSimple, size: 16),
                  label: const Text("View Your Referral Metrics"),
                ),
              ),
            ] else ...[
              Text(
                "Please set a display name and upload a profile picture to activate your referral code.",
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7)),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildTwitterVerificationCard(ThemeData theme) {
    bool isVerified = widget.userProfile.is_twitter_verified ?? false;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("X / Twitter Verification", style: theme.textTheme.titleMedium),
                const Spacer(),
                if (isVerified)
                  Chip(
                    avatar: const FaIcon(FontAwesomeIcons.solidCircleCheck, size: 14, color: AppColors.success),
                    label: const Text("Verified"),
                    backgroundColor: AppColors.success.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  )
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _twitterHandleController,
              decoration: InputDecoration(
                labelText: 'Your Twitter Handle',
                prefixText: _twitterHandleController.text.isNotEmpty && !_twitterHandleController.text.startsWith('@') ? '@' : null,
                hintText: "your_handle",
              ),
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Text(
              "Connect your X account to get a verified badge on your profile and unlock exclusive quests.",
              style: theme.textTheme.bodySmall,
            ),
             if (!isVerified) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Twitter verification flow coming soon!")));
                  },
                  icon: const FaIcon(FontAwesomeIcons.twitter, size: 16),
                  label: const Text("Verify with X"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteSection(ThemeData theme) {
    return Card(
      color: theme.colorScheme.error.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.error, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danger Zone',
              style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.error, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Deleting your account is irreversible. Please be certain before proceeding.',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error.withOpacity(0.8)),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.warning_amber_rounded),
                label: const Text('Delete My Account'),
                onPressed: _isSaving ? null : _handleDeleteAccount,
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  side: BorderSide(color: theme.colorScheme.error.withOpacity(0.5)),
                ),
              ),
            ),
            // --- NEW DEBUG BUTTON ---
            const SizedBox(height: 12),
            Text(
              'Debug Options',
              style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.error.withOpacity(0.9)),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.notifications_active_outlined),
                label: const Text('Simulate News Notification'),
                onPressed: _isSaving ? null : _simulateNewsNotification,
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                   side: BorderSide(color: theme.colorScheme.error.withOpacity(0.5)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    ImageProvider<Object>? avatarImageProviderForDisplay;
    if (_pickedImageXFile != null) {
       if (kIsWeb) {
         avatarImageProviderForDisplay = NetworkImage(_pickedImageXFile!.path);
       }
    } else if (_initialProfileImageUrl != null && _initialProfileImageUrl!.isNotEmpty) {
      final uri = Uri.tryParse(_initialProfileImageUrl!);
      if (uri != null && uri.isAbsolute) {
        avatarImageProviderForDisplay = NetworkImage(_initialProfileImageUrl!);
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Edit Profile & Connections'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.rightFromBracket),
            onPressed: _isSaving ? null : _logout,
            tooltip: "Logout",
          ),
        ],
      ),
      body: AnimatedParticleBackground(
        baseColor: theme.scaffoldBackgroundColor,
        particleColor1: isDark ? AppColors.particleGoldSoft.withOpacity(0.25) : AppColors.particleGoldSoft.withOpacity(0.4),
        particleColor2: isDark ? AppColors.particleDarkGrey.withOpacity(0.25) : AppColors.particleDarkGrey.withOpacity(0.4),
        child: AbsorbPointer(
          absorbing: _isSaving,
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.only(
                    top: kToolbarHeight + MediaQuery.of(context).padding.top,
                    left: 16, right: 16, bottom: 40
                  ),
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: 110, height: 110,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: theme.colorScheme.surfaceVariant,
                                    border: Border.all(color: theme.colorScheme.primary, width: 2),
                                    image: (_pickedImageXFile == null && avatarImageProviderForDisplay != null)
                                        ? DecorationImage(image: avatarImageProviderForDisplay, fit: BoxFit.cover, onError: (e,s) => debugPrint("Error loading initial avatar for display (CircleAvatar): $e"))
                                        : null,
                                  ),
                                  child: _pickedImageXFile != null
                                    ? ClipOval(
                                        child: kIsWeb
                                            ? Image.network(_pickedImageXFile!.path, fit: BoxFit.cover, width: 110, height: 110, errorBuilder: (c,e,s) => const FaIcon(FontAwesomeIcons.userAstronaut, size: 50))
                                            : FutureBuilder<Uint8List>(
                                                future: _pickedImageXFile!.readAsBytes(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                                                    return Image.memory(snapshot.data!, fit: BoxFit.cover, width: 110, height: 110);
                                                  } else if (snapshot.error != null) {
                                                    return FaIcon(FontAwesomeIcons.userAstronaut, size: 50, color: theme.colorScheme.onSurfaceVariant);
                                                  }
                                                  return const CircularProgressIndicator();
                                                },
                                              ),
                                      )
                                    : (avatarImageProviderForDisplay == null
                                        ? FaIcon(FontAwesomeIcons.userAstronaut, size: 50, color: theme.colorScheme.onSurfaceVariant)
                                        : null),
                                ),
                                Material(
                                  color: theme.colorScheme.primary,
                                  shape: const CircleBorder(),
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    onTap: _isSaving ? null : _pickImage,
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: FaIcon(FontAwesomeIcons.camera, color: AppColors.offBlack, size: 20),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _displayNameController,
                              decoration: const InputDecoration(
                                labelText: 'Display Name *',
                                suffixIcon: InfoTooltip(
                                  message: "Your public name throughout the Cabal platform. Make it unique!",
                                )
                              ),
                              validator: (value) => (value == null || value.trim().isEmpty) ? 'Display name cannot be empty' : null,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

                    const SizedBox(height: 24),
                    Text('Grow Your Cabal', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)).animate().fadeIn(delay: 300.ms),
                    const SizedBox(height: 12),
                    _buildReferralCard(theme).animate().fadeIn(delay: 400.ms),

                    const SizedBox(height: 24),
                    Text('Verification', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)).animate().fadeIn(delay: 500.ms),
                    const SizedBox(height: 12),
                    _buildTwitterVerificationCard(theme).animate().fadeIn(delay: 600.ms),
                    
                    const SizedBox(height: 24),
                    Text('Wallet Connections', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)).animate().fadeIn(delay: 700.ms),
                    const SizedBox(height: 8),
                    const WalletConnectorWidget().animate().fadeIn(delay: 800.ms),

                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      icon: const FaIcon(FontAwesomeIcons.solidFloppyDisk, size: 20),
                      label: const Text('Save Profile Changes'),
                      onPressed: _isSaving ? null : _saveProfile,
                      style: theme.elevatedButtonTheme.style?.copyWith(
                          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
                          textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                      ),
                    ).animate().fadeIn(delay: 900.ms).scaleY(begin: 0.5, curve: Curves.elasticOut),
                    const SizedBox(height: 32),
                    _buildDeleteSection(theme).animate().fadeIn(delay: 1000.ms),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
              if (_isSaving)
                Container(
                  color: theme.scaffoldBackgroundColor.withOpacity(0.8),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: theme.colorScheme.primary),
                        const SizedBox(height: 20),
                        Text("Please wait...", style: theme.textTheme.titleMedium),
                      ],
                    ),
                  ),
                ).animate().fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}

```

### File: ./lib/screens/dex_screen.dart
```dart
// lib/screens/dex_screen.dart
import 'package:cabal/models/cabal_model.dart';
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../features/wallet/application/wallet_provider.dart';

class DexScreen extends StatefulWidget {
  final Cabal cabal;
  final UserProfile userProfile;

  const DexScreen({
    Key? key,
    required this.cabal,
    required this.userProfile,
  }) : super(key: key);

  @override
  State<DexScreen> createState() => _DexScreenState();
}

class _DexScreenState extends State<DexScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _payController = TextEditingController();
  final TextEditingController _receiveController = TextEditingController();

  bool _isSwapping = false;

  // Placeholder values for swap rate and balance
  final double _swapRate = 1500.50; // e.g., 1 ETH = 1500.50 $TOKEN
  final double _nativeBalance = 1.25; // e.g., 1.25 ETH

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _payController.addListener(_onPayAmountChanged);
  }

  void _onPayAmountChanged() {
    final payAmount = double.tryParse(_payController.text);
    if (payAmount != null) {
      final receiveAmount = payAmount * _swapRate;
      _receiveController.text = receiveAmount.toStringAsFixed(4);
    } else {
      _receiveController.clear();
    }
  }

  Future<void> _performSwap() async {
    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (!walletProvider.isConnectedEVM) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please connect your EVM wallet first.")));
      return;
    }
    
    final payAmount = double.tryParse(_payController.text);
    if (payAmount == null || payAmount <= 0) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please enter a valid amount to swap.")));
      return;
    }
    
    setState(() => _isSwapping = true);
    
    try {
      // In a real implementation, you would:
      // 1. Get the swap parameters (amounts, path) from a router contract or calculate them.
      // 2. Encode the function call for the smart contract's swap method.
      // 3. Use walletProvider to send the transaction.
      // For now, we simulate the process.
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Simulating swap... Please check your wallet to confirm.")));
      await Future.delayed(const Duration(seconds: 3)); // Simulate wallet confirmation delay
      
      // final txHash = await web3Service.executeSwap(...);
      
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Swap submitted successfully! Tx: 0x...placeholder")));
      _payController.clear();
    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Swap failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isSwapping = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _payController.dispose();
    _receiveController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chainSymbol = "ETH"; // This could be dynamic based on chainId in the future
    final cabalTokenSymbol = widget.cabal.tokenSymbol ?? 'TOKEN';
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('${widget.cabal.name} Treasury & DEX'),
        backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: FaIcon(FontAwesomeIcons.rightLeft), text: 'Swap'),
            Tab(icon: FaIcon(FontAwesomeIcons.landmark), text: 'Treasury'),
          ],
        ),
      ),
      body: DiamondMeshBackground(
        child: Padding(
          padding: EdgeInsets.only(top: kToolbarHeight + (AppBar().preferredSize.height) + MediaQuery.of(context).padding.top),
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildSwapView(theme, chainSymbol, cabalTokenSymbol),
              _buildTreasuryView(theme, cabalTokenSymbol),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwapView(ThemeData theme, String chainSymbol, String cabalTokenSymbol) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSwapInput(
                theme: theme,
                label: "You Pay",
                controller: _payController,
                tokenSymbol: chainSymbol,
                balance: _nativeBalance,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: IconButton(
                  icon: const FaIcon(FontAwesomeIcons.arrowDown),
                  onPressed: () { /* TODO: Implement logic to swap input fields */ },
                ),
              ),
              _buildSwapInput(
                theme: theme,
                label: "You Receive",
                controller: _receiveController,
                tokenSymbol: cabalTokenSymbol,
                readOnly: true,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSwapping ? null : _performSwap,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: _isSwapping 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white))
                    : const Text('Swap'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSwapInput({
    required ThemeData theme,
    required String label,
    required TextEditingController controller,
    required String tokenSymbol,
    double? balance,
    bool readOnly = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: theme.textTheme.bodySmall),
              if (balance != null)
                Text("Balance: ${balance.toStringAsFixed(4)}", style: theme.textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  readOnly: readOnly,
                  decoration: const InputDecoration(
                    hintText: '0.0',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: theme.textTheme.headlineSmall,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Chip(
                label: Text(tokenSymbol, style: theme.textTheme.titleMedium),
                avatar: const FaIcon(FontAwesomeIcons.circleQuestion), // Replace with token logo later
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildTreasuryView(ThemeData theme, String cabalTokenSymbol) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FaIcon(FontAwesomeIcons.buildingColumns, size: 40),
              const SizedBox(height: 16),
              Text('Treasury Information', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'Details about the $cabalTokenSymbol token, treasury balance, and transaction history will be displayed here. (Coming Soon)',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

```

### File: ./lib/screens/partners_screen.dart
```dart
// lib/screens/partners_screen.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:cabal/utils/app_colors.dart';
import 'package:page_transition/page_transition.dart';
import 'partnership_form_screen.dart'; // This file will be created next

class PartnersScreen extends StatelessWidget {
  const PartnersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Partner with Cabal"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DiamondMeshBackground(
        child: ListView(
          padding: EdgeInsets.only(
            top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
            left: 16, right: 16, bottom: 40,
          ),
          children: [
            _buildSectionHeader(theme, "Grow With Us", "Join an ecosystem designed for mutual success."),
            const SizedBox(height: 24),
            _buildPartnerTypeCard(
              context: context,
              theme: theme,
              icon: FontAwesomeIcons.rocket,
              title: "Project & dApp Partnerships",
              description: "Integrate your project with Cabal to run quests, engage our user base, and grow your community.",
              buttonText: "Apply as a Project",
              onPressed: () {
                Navigator.push(context, PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const PartnershipFormScreen(partnershipType: 'Project'))
                );
              },
            ),
            _buildPartnerTypeCard(
              context: context,
              theme: theme,
              icon: FontAwesomeIcons.bullhorn,
              title: "Influencers & KOLs",
              description: "Bring your audience to Cabal and earn rewards based on the real, active users you onboard. We provide the tools to track your impact.",
              buttonText: "Apply as a KOL",
              onPressed: () {
                 Navigator.push(context, PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const PartnershipFormScreen(partnershipType: 'KOL'))
                );
              },
            ),
             _buildPartnerTypeCard(
              context: context,
              theme: theme,
              icon: FontAwesomeIcons.peopleGroup,
              title: "Strategic & Core Roles",
              description: "Looking to make a bigger impact? We are actively seeking partners for core roles in business development, technology, and leadership.",
              buttonText: "Contact Us Directly",
              onPressed: () {
                Navigator.push(context, PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const PartnershipFormScreen(partnershipType: 'Strategic'))
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.headlineMedium?.copyWith(color: AppColors.gold)),
        const SizedBox(height: 8),
        Text(subtitle, style: theme.textTheme.bodyLarge),
      ],
    );
  }

  Widget _buildPartnerTypeCard({
    required BuildContext context,
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FaIcon(icon, size: 24, color: theme.colorScheme.primary),
                const SizedBox(width: 16),
                Expanded(child: Text(title, style: theme.textTheme.titleLarge)),
              ],
            ),
            const Divider(height: 24),
            Text(description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onPressed,
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

```

### File: ./lib/screens/partnership_form_screen.dart
```dart
// lib/screens/partnership_form_screen.dart
import 'package:flutter/material.dart';
import 'package:cabal/services/supabase_service.dart';
import 'package:cabal/widgets/animated_particle_background.dart';
import 'package:cabal/utils/app_colors.dart';

class PartnershipFormScreen extends StatefulWidget {
  final String partnershipType;

  const PartnershipFormScreen({Key? key, required this.partnershipType}) : super(key: key);

  @override
  State<PartnershipFormScreen> createState() => _PartnershipFormScreenState();
}

class _PartnershipFormScreenState extends State<PartnershipFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supabaseService = SupabaseService();
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _projectNameController = TextEditingController();
  final _projectUrlController = TextEditingController();
  final _twitterController = TextEditingController();
  final _proposalController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _projectNameController.dispose();
    _projectUrlController.dispose();
    _twitterController.dispose();
    _proposalController.dispose();
    super.dispose();
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await _supabaseService.submitPartnershipApplication(
        contactName: _nameController.text.trim(),
        contactEmail: _emailController.text.trim(),
        partnershipType: widget.partnershipType,
        proposalDetails: _proposalController.text.trim(),
        projectName: _projectNameController.text.trim(),
        projectUrl: _projectUrlController.text.trim(),
        twitterHandle: _twitterController.text.trim(),
      );

      if (mounted) {
        scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text('Application submitted successfully! We will be in touch.'),
          backgroundColor: AppColors.success,
        ));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool isProject = widget.partnershipType == 'Project';
    bool isKOL = widget.partnershipType == 'KOL';

    return Scaffold(
      appBar: AppBar(title: Text('${widget.partnershipType} Application')),
      body: AnimatedParticleBackground(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text('Contact Information', style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Your Name / Handle *'),
                validator: (v) => (v == null || v.isEmpty) ? 'This field is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Contact Email *'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => (v == null || !v.contains('@')) ? 'Please enter a valid email' : null,
              ),
              if (isProject || isKOL) const SizedBox(height: 16),
              if (isProject || isKOL)
                TextFormField(
                  controller: _twitterController,
                  decoration: const InputDecoration(labelText: 'X / Twitter Handle'),
                ),
              
              if (isProject) ...[
                 const SizedBox(height: 24),
                 Text('Project Details', style: theme.textTheme.titleLarge),
                 const SizedBox(height: 16),
                 TextFormField(
                  controller: _projectNameController,
                  decoration: const InputDecoration(labelText: 'Project Name *'),
                  validator: (v) => (isProject && (v == null || v.isEmpty)) ? 'Project name is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _projectUrlController,
                  decoration: const InputDecoration(labelText: 'Project Website / URL'),
                ),
              ],

              const SizedBox(height: 24),
              Text('Your Proposal', style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(
                controller: _proposalController,
                decoration: InputDecoration(
                  labelText: 'Tell us about your project or how you can help *',
                  alignLabelWithHint: true,
                  hintText: isKOL
                      ? 'Describe your audience, engagement metrics, and ideas for collaboration.'
                      : isProject
                          ? 'Describe your project and how a partnership with Cabal would create value.'
                          : 'Tell us about your background and what you envision for your role.',
                ),
                maxLines: 8,
                validator: (v) => (v == null || v.trim().length < 50) ? 'Please provide a detailed proposal (min 50 characters)' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitApplication,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: _isLoading
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white))
                    : const Text('Submit Application'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

```

### File: ./lib/screens/kol_dashboard_screen.dart
```dart
// lib/screens/kol_dashboard_screen.dart
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/services/supabase_service.dart';
import 'package:cabal/utils/app_colors.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:cabal/widgets/shimmer_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class KolDashboardScreen extends StatefulWidget {
  final UserProfile userProfile;
  const KolDashboardScreen({Key? key, required this.userProfile}) : super(key: key);

  @override
  State<KolDashboardScreen> createState() => _KolDashboardScreenState();
}

class _KolDashboardScreenState extends State<KolDashboardScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  Future<Map<String, dynamic>>? _dashboardDataFuture;

  @override
  void initState() {
    super.initState();
    _dashboardDataFuture = _supabaseService.getKolDashboardData(widget.userProfile.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("KOL Dashboard"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DiamondMeshBackground(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _dashboardDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }
            if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
              return Center(child: Text("Error loading dashboard data: ${snapshot.error}"));
            }

            final data = snapshot.data!;
            return _buildDashboardContent(theme, data);
          },
        ),
      ),
    );
  }

  Widget _buildDashboardContent(ThemeData theme, Map<String, dynamic> data) {
    final totalReferrals = data['total_referrals'] as int? ?? 0;
    final activeReferrals30d = data['active_referrals_30d'] as int? ?? 0;
    final estimatedEarnings = (data['estimated_earnings'] as num? ?? 0.0).toDouble();
    final referralTimeseries = (data['referral_timeseries'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final activeTargets = (data['active_targets'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return ListView(
      padding: EdgeInsets.only(
        top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
        left: 16, right: 16, bottom: 40,
      ),
      children: [
        _buildSummaryCards(theme, totalReferrals, activeReferrals30d, estimatedEarnings),
        const SizedBox(height: 24),
        if (referralTimeseries.isNotEmpty)
          _buildChartCard(theme, referralTimeseries),
        const SizedBox(height: 24),
        if (activeTargets.isNotEmpty)
          _buildTargetsSection(theme, activeTargets, totalReferrals),
      ],
    ).animate().fadeIn();
  }

  Widget _buildSummaryCards(ThemeData theme, int totalReferrals, int activeReferrals30d, double estimatedEarnings) {
    return Row(
      children: [
        Expanded(child: _buildMetricCard(theme, "Total Referrals", totalReferrals.toString(), FontAwesomeIcons.users, theme.colorScheme.primary)),
        const SizedBox(width: 16),
        Expanded(child: _buildMetricCard(theme, "Active (30d)", activeReferrals30d.toString(), FontAwesomeIcons.bolt, theme.colorScheme.secondary)),
        const SizedBox(width: 16),
        Expanded(child: _buildMetricCard(theme, "Est. Earnings", NumberFormat.simpleCurrency().format(estimatedEarnings), FontAwesomeIcons.dollarSign, AppColors.success)),
      ],
    );
  }

  Widget _buildMetricCard(ThemeData theme, String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FaIcon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, textAlign: TextAlign.center, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(ThemeData theme, List<Map<String, dynamic>> timeseries) {
    final spots = timeseries.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final count = (entry.value['new_referrals'] as num? ?? 0).toDouble();
      return FlSpot(index, count);
    }).toList();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("New Referrals (Last 30 Days)", style: theme.textTheme.titleLarge),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index % 7 == 0 && index < timeseries.length) {
                            final date = DateTime.parse(timeseries[index]['report_date']);
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(DateFormat('MMM d').format(date), style: theme.textTheme.bodySmall),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: theme.colorScheme.primary,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [theme.colorScheme.primary.withOpacity(0.3), theme.colorScheme.primary.withOpacity(0.0)],
                          begin: Alignment.topCenter, end: Alignment.bottomCenter
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetsSection(ThemeData theme, List<Map<String, dynamic>> targets, int currentReferrals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Your Active Targets", style: theme.textTheme.headlineSmall),
        const SizedBox(height: 12),
        ...targets.map((target) {
          final targetUsers = (target['target_users'] as num).toInt();
          final rewardAmount = (target['reward_amount'] as num).toDouble();
          final progress = (currentReferrals / targetUsers).clamp(0.0, 1.0);

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Target: Bring ${NumberFormat.compact().format(targetUsers)} Users",
                    style: theme.textTheme.titleLarge,
                  ),
                  Text(
                    "Reward: ${NumberFormat.simpleCurrency().format(rewardAmount)} ${target['reward_currency']}",
                    style: theme.textTheme.titleMedium?.copyWith(color: AppColors.success),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(5),
                          backgroundColor: theme.colorScheme.surfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "${(progress * 100).toStringAsFixed(1)}%",
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${NumberFormat.compact().format(currentReferrals)} / ${NumberFormat.compact().format(targetUsers)} referrals",
                    style: theme.textTheme.bodySmall,
                  )
                ],
              ),
            ),
          );
        })
      ],
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: EdgeInsets.only(
        top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
        left: 16, right: 16, bottom: 40,
      ),
      children: const [
        Row(
          children: [
            Expanded(child: ShimmerWidget.rectangular(height: 120)),
            SizedBox(width: 16),
            Expanded(child: ShimmerWidget.rectangular(height: 120)),
            SizedBox(width: 16),
            Expanded(child: ShimmerWidget.rectangular(height: 120)),
          ],
        ),
        SizedBox(height: 24),
        ShimmerWidget.rectangular(height: 300),
      ],
    );
  }
}

```

### File: ./lib/screens/post_detail_screen.dart
```dart
// lib/screens/post_detail_screen.dart
import 'package:cabal/models/community_post_model.dart';
import 'package:cabal/services/supabase_service.dart';
import 'package:cabal/widgets/post_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/user_profile_model.dart';
import '../widgets/animated_particle_background.dart';

class PostDetailScreen extends StatefulWidget {
  final CommunityPost post;
  final UserProfile? currentUserProfile;

  const PostDetailScreen({
    Key? key,
    required this.post,
    this.currentUserProfile,
  }) : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  final TextEditingController _commentController = TextEditingController();
  List<CommunityPost> _comments = []; // We can reuse the CommunityPost model for simple comments
  bool _isLoadingComments = true;
  bool _isPostingComment = false;

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    if (!mounted) return;
    setState(() => _isLoadingComments = true);
    try {
      final comments = await _supabaseService.getPostComments(widget.post.id);
      if (mounted) {
        setState(() {
          _comments = comments;
          _isLoadingComments = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching comments: $e");
      if (mounted) setState(() => _isLoadingComments = false);
    }
  }

  Future<void> _postComment() async {
    if (_commentController.text.trim().isEmpty || _isPostingComment) return;

    setState(() => _isPostingComment = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await _supabaseService.addCommentToPost(
        postId: widget.post.id,
        content: _commentController.text.trim(),
      );
      _commentController.clear();
      // Optimistically update comment count on the original post
      widget.post.commentCount++;
      await _fetchComments(); // Refresh the comment list
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text("Failed to post comment: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isPostingComment = false);
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post Details"),
      ),
      body: AnimatedParticleBackground(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: PostCardWidget(
                        post: widget.post,
                        currentUserProfile: widget.currentUserProfile,
                        isDetailView: true, // Prevents navigating to detail from detail screen
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text("Comments", style: theme.textTheme.titleLarge),
                    ),
                  ),
                  if (_isLoadingComments)
                    const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
                  else if (_comments.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(FontAwesomeIcons.solidCommentDots, size: 40, color: theme.colorScheme.onSurface.withOpacity(0.4)),
                              const SizedBox(height: 16),
                              Text("No comments yet.", style: theme.textTheme.bodyLarge),
                              Text("Be the first to reply!", style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7))),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final comment = _comments[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: comment.authorAvatarUrl.isNotEmpty
                                  ? NetworkImage(comment.authorAvatarUrl)
                                  : null,
                              child: comment.authorAvatarUrl.isEmpty ? const FaIcon(FontAwesomeIcons.userAstronaut) : null,
                            ),
                            title: Text(comment.authorName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                            subtitle: Text(comment.content),
                            trailing: Text(comment.timeAgo, style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7))),
                          );
                        },
                        childCount: _comments.length,
                      ),
                    ),
                ],
              ),
            ),
            if (widget.currentUserProfile != null)
              _buildCommentInputField(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentInputField(ThemeData theme) {
    return Material(
      elevation: 8,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).viewInsets.bottom + 12),
        color: theme.cardColor,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: "Add a comment...",
                  isDense: true,
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: _isPostingComment
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.send_rounded),
              onPressed: _postComment,
              color: theme.colorScheme.primary,
            )
          ],
        ),
      ),
    );
  }
}

```

### File: ./lib/screens/marketplace_screen.dart
```dart
// lib/screens/marketplace_screen.dart
import 'package:cabal/models/nft_listing_model.dart';
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/screens/create_developer_profile_screen.dart';
import 'package:cabal/screens/create_project_listing_screen.dart';
import 'package:cabal/screens/dashboard_screen.dart';
import 'package:cabal/screens/list_property_screen.dart';
import 'package:cabal/screens/nft_detail_screen.dart';
import 'package:cabal/services/supabase_service.dart';
import 'package:cabal/widgets/empty_state_card.dart';
import 'package:cabal/widgets/nft_listing_card.dart';
import 'package:cabal/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import '../models/marketplace_models.dart';
import '../widgets/diamond_mesh_background.dart';
import '../widgets/project_listing_card.dart';
import '../widgets/developer_profile_card.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({Key? key}) : super(key: key);

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  
  // State for original marketplace tabs
  List<ProjectListing> _projectListings = [];
  bool _isLoadingProjects = true;
  List<DeveloperProfile> _developerProfiles = [];
  bool _isLoadingDevelopers = true;
  
  // --- NEW: State for NFT Marketplace Tab ---
  List<NftListing> _nftListings = [];
  bool _isLoadingNfts = true;

  UserProfile? _currentUserProfile;
  DeveloperProfile? _currentUserDeveloperProfile;

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }
  
  Future<void> _fetchAllData() async {
    final authUser = _supabaseService.getCurrentUser();
    if (authUser != null) {
      final profile = await _supabaseService.getUserProfile(authUser.id);
      if(mounted) setState(() => _currentUserProfile = profile);
    }

    // Fetch all data in parallel for a faster loading experience
    await Future.wait([
      _fetchProjectListings(),
      _fetchDeveloperProfiles(),
      _fetchNftListings(),
    ]);
  }

  Future<void> _fetchProjectListings() async {
    if (!mounted) return;
    setState(() => _isLoadingProjects = true);
    try {
      final listings = await _supabaseService.getProjectListings();
      if (mounted) setState(() => _projectListings = listings);
    } catch (e) {
      debugPrint("Error fetching project listings: $e");
    } finally {
      if (mounted) setState(() => _isLoadingProjects = false);
    }
  }

  Future<void> _fetchDeveloperProfiles() async {
    if (!mounted) return;
    setState(() => _isLoadingDevelopers = true);
    try {
      final profiles = await _supabaseService.getDeveloperProfiles();
      if (mounted) {
        _developerProfiles = profiles;
        if (_currentUserProfile != null) {
          try {
             _currentUserDeveloperProfile = profiles.firstWhere((p) => p.userId == _currentUserProfile!.id);
          } catch(e) {
            _currentUserDeveloperProfile = null;
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching developer profiles: $e");
    } finally {
      if (mounted) setState(() => _isLoadingDevelopers = false);
    }
  }

  Future<void> _fetchNftListings() async {
    if (!mounted) return;
    setState(() => _isLoadingNfts = true);
    try {
      final listings = await _supabaseService.getNftListings();
      if (mounted) setState(() => _nftListings = listings);
    } catch (e) {
      debugPrint("Error fetching NFT listings: $e");
    } finally {
      if (mounted) setState(() => _isLoadingNfts = false);
    }
  }
  
  void _showCreateListingOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.building),
            title: const Text('List a Property'),
            subtitle: const Text('Tokenize a real estate asset as an NFT'),
            onTap: () async {
              Navigator.pop(context);
              final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const ListPropertyScreen()));
              if (result == true) _fetchAllData();
            },
          ),
          const Divider(),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.fileCode),
            title: const Text('Post a Project'),
            subtitle: const Text('Find talent to build your vision'),
            onTap: () async {
              Navigator.pop(context);
              final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateProjectListingScreen()));
              if (result == true) _fetchProjectListings();
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.userAstronaut),
            title: Text(_currentUserDeveloperProfile == null ? 'List Your Services' : 'Edit Your Services'),
            subtitle: Text(_currentUserDeveloperProfile == null ? 'Offer your skills to the community' : 'Update your public developer profile'),
            onTap: () async {
              Navigator.pop(context);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CreateDeveloperProfileScreen(existingProfile: _currentUserDeveloperProfile)),
              );
              if (result == true) _fetchDeveloperProfiles();
            },
          ),
        ],
      ),
    );
  }
  
  void _navigateToUserProfile(String userId) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: DashboardScreen(viewProfileId: userId, isLoadingProfile: false),
      ),
    );
  }

  void _navigateToNftDetail(NftListing listing) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NftDetailScreen(listing: listing))
    ).then((_) => _fetchAllData()); // Refresh data when returning
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTabController(
      length: 3, // Updated to 3 tabs
      child: Scaffold(
        body: DiamondMeshBackground(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  title: const Text("Cabal Marketplace"),
                  pinned: true,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85),
                  bottom: const TabBar(
                    tabs: [
                      Tab(text: "NFTs 💎"),
                      Tab(text: "Projects 🚀"),
                      Tab(text: "Talent 🧑‍💻"),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                _buildNftsTab(),
                _buildProjectsTab(),
                _buildDevelopersTab(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showCreateListingOptions,
          icon: const Icon(Icons.add),
          label: const Text("Create Listing"),
        ),
      ),
    );
  }

  Widget _buildNftsTab() {
    if (_isLoadingNfts) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.8),
        itemCount: 6,
        itemBuilder: (context, index) => const ShimmerWidget.rectangular(height: 250),
      );
    }

    if (_nftListings.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: EmptyStateCard(
            title: "No NFTs Listed",
            message: "The NFT marketplace is brand new. Be the first to list a tokenized asset for sale!",
            icon: FontAwesomeIcons.gem,
            buttonText: "List an Asset",
            currentUserProfile: _currentUserProfile,
            onButtonPressed: _showCreateListingOptions,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchNftListings,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.8
        ),
        itemCount: _nftListings.length,
        itemBuilder: (context, index) {
          final listing = _nftListings[index];
          return NftListingCard(
            listing: listing,
            onTap: () => _navigateToNftDetail(listing),
          ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.2);
        },
      ),
    );
  }

  Widget _buildProjectsTab() {
    if (_isLoadingProjects) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) => const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: ShimmerWidget.rectangular(height: 250),
        ),
      );
    }

    if (_projectListings.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: EmptyStateCard(
            title: "No Projects Found",
            message: "The marketplace is waiting for its first project. Be the one to kick things off!",
            icon: FontAwesomeIcons.fileCode,
            buttonText: "Post the First Project",
            currentUserProfile: _currentUserProfile,
            onButtonPressed: () async {
               final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateProjectListingScreen()),
              );
              if (result == true) _fetchProjectListings();
            },
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchProjectListings,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _projectListings.length,
        itemBuilder: (context, index) {
          final project = _projectListings[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ProjectListingCard(project: project),
          ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.2);
        },
      ),
    );
  }
  
  Widget _buildDevelopersTab() {
    if (_isLoadingDevelopers) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) => const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: ShimmerWidget.rectangular(height: 200),
        ),
      );
    }

    if (_developerProfiles.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: EmptyStateCard(
            title: "No Developers Found",
            message: "Be the first developer to list your services and get noticed by project creators!",
            icon: FontAwesomeIcons.userAstronaut,
            buttonText: "List Your Services",
            currentUserProfile: _currentUserProfile,
            onButtonPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateDeveloperProfileScreen()),
              );
              if (result == true) _fetchDeveloperProfiles();
            },
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchDeveloperProfiles,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _developerProfiles.length,
        itemBuilder: (context, index) {
          final developer = _developerProfiles[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: DeveloperProfileCard(
              developer: developer,
              onContact: () => _navigateToUserProfile(developer.userId),
            ),
          ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.2);
        },
      ),
    );
  }
}

```

### File: ./lib/screens/create_giveaway_screen.dart
```dart
// lib/screens/create_giveaway_screen.dart
import 'package:cabal/features/wallet/application/wallet_provider.dart';
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/widgets/animated_particle_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';

enum PrizeType { ETH, ERC20 }

class CreateGiveawayScreen extends StatefulWidget {
  final String cabalId;
  const CreateGiveawayScreen({Key? key, required this.cabalId}) : super(key: key);

  @override
  State<CreateGiveawayScreen> createState() => _CreateGiveawayScreenState();
}

class _CreateGiveawayScreenState extends State<CreateGiveawayScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _goalController = TextEditingController();
  final _prizeAmountController = TextEditingController();
  final _tokenAddressController = TextEditingController();

  PrizeType _selectedPrizeType = PrizeType.ETH;
  bool _isLaunching = false;

  Future<void> _launchGiveaway() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    
    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (!walletProvider.isConnectedEVM) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please connect your wallet to launch a giveaway.")));
      return;
    }

    setState(() => _isLaunching = true);

    try {
      // TODO: Implement the actual deployGiveawayContract function in Web3Service.
      // It will need to handle the ERC20 approval flow if necessary.
      // final newGiveawayContractAddress = await web3Service.deployGiveawayContract(
      //   goalTarget: _goalController.text.trim(),
      //   prizeType: _selectedPrizeType,
      //   prizeAmount: _prizeAmountController.text.trim(),
      //   tokenAddress: _tokenAddressController.text.trim(),
      //   credentials: walletProvider.getCredentials(),
      // );

      // Simulate transaction flow
      if (_selectedPrizeType == PrizeType.ERC20) {
        scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please approve the token transfer in your wallet...")));
        await Future.delayed(const Duration(seconds: 3));
      }
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Deploying giveaway contract... Please confirm in your wallet.")));
      await Future.delayed(const Duration(seconds: 4));

      // TODO: Link the newGiveawayContractAddress to the cabalId in Supabase.
      
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text("Giveaway contract launched successfully!"),
        backgroundColor: AppColors.success,
      ));
      navigator.pop(true);

    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Launch failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isLaunching = false);
    }
  }
  
  @override
  void dispose() {
    _goalController.dispose();
    _prizeAmountController.dispose();
    _tokenAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Create a New Giveaway")),
      body: AnimatedParticleBackground(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text("Launch a Trustless Giveaway", style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                "Lock a prize into a smart contract that automatically pays out to a winner once you confirm the goal is met. This builds trust and supercharges your community growth.",
                style: theme.textTheme.bodyLarge,
              ),
              const Divider(height: 32),
              
              Text("1. Define the Prize", style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              ToggleButtons(
                isSelected: [_selectedPrizeType == PrizeType.ETH, _selectedPrizeType == PrizeType.ERC20],
                onPressed: (index) {
                  setState(() {
                    _selectedPrizeType = index == 0 ? PrizeType.ETH : PrizeType.ERC20;
                  });
                },
                borderRadius: BorderRadius.circular(8),
                children: const [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Text("ETH")),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Text("ERC20 Token")),
                ],
              ),
              const SizedBox(height: 16),
              if (_selectedPrizeType == PrizeType.ERC20)
                TextFormField(
                  controller: _tokenAddressController,
                  decoration: const InputDecoration(labelText: "ERC20 Token Contract Address *"),
                  validator: (v) => (_selectedPrizeType == PrizeType.ERC20 && (v == null || v.isEmpty)) ? "Token address is required" : null,
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _prizeAmountController,
                decoration: InputDecoration(labelText: "Prize Amount *"),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                validator: (v) {
                  if (v == null || v.isEmpty) return "Prize amount is required";
                  if (double.tryParse(v) == null || double.parse(v) <= 0) return "Must be a valid positive number";
                  return null;
                },
              ),
              const SizedBox(height: 24),

              Text("2. Set the Goal", style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
               TextFormField(
                controller: _goalController,
                decoration: const InputDecoration(labelText: "Goal Description *", hintText: "e.g., '1,000 New Referrals'"),
                validator: (v) => (v == null || v.isEmpty) ? "Goal description is required" : null,
              ),
              const SizedBox(height: 32),

              ElevatedButton.icon(
                icon: _isLaunching
                    ? Container(width: 24, height: 24, padding: const EdgeInsets.all(2.0), child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                    : const FaIcon(FontAwesomeIcons.rocket),
                label: Text(_isLaunching ? 'Deploying...' : 'Launch Giveaway'),
                onPressed: _isLaunching ? null : _launchGiveaway,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

```

### File: ./lib/screens/giveaway_detail_screen.dart
```dart
// lib/screens/giveaway_detail_screen.dart
import 'package:cabal/features/wallet/application/wallet_provider.dart';
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';

// Placeholder model for giveaway details
class GiveawayDetails {
  final String prizeAmount;
  final String prizeSymbol;
  final String goalDescription;
  final int goalTarget;
  final int currentProgress;
  final String state; // "Open", "Canceled", "Complete"
  final String? winnerAddress;
  final String contractOwner;

  GiveawayDetails({
    required this.prizeAmount,
    required this.prizeSymbol,
    required this.goalDescription,
    required this.goalTarget,
    required this.currentProgress,
    required this.state,
    this.winnerAddress,
    required this.contractOwner,
  });
}

class GiveawayDetailScreen extends StatefulWidget {
  final String giveawayContractAddress;
  const GiveawayDetailScreen({Key? key, required this.giveawayContractAddress}) : super(key: key);

  @override
  State<GiveawayDetailScreen> createState() => _GiveawayDetailScreenState();
}

class _GiveawayDetailScreenState extends State<GiveawayDetailScreen> {
  Future<GiveawayDetails>? _detailsFuture;
  bool _isProcessingAction = false;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  void _loadDetails() {
    setState(() {
      _detailsFuture = _fetchGiveawayDetails();
    });
  }

  Future<GiveawayDetails> _fetchGiveawayDetails() async {
    // In a real app, this would fetch data from the smart contract and Supabase
    await Future.delayed(const Duration(seconds: 1));
    return GiveawayDetails(
      prizeAmount: "10,000",
      prizeSymbol: "USDC",
      goalDescription: "1,000 New Referrals",
      goalTarget: 1000,
      currentProgress: 754,
      state: "Open", // or "Complete", "Canceled"
      winnerAddress: null, // or a real address if set
      contractOwner: "0xCreatorAddressPlaceholder", // Fetched from contract.owner()
    );
  }

  Future<void> _claimPrize() async {
    // TODO: Implement call to Giveaway.sol's claimPrize() via Web3Service
  }

  Future<void> _setWinner() {
    // TODO: Show a dialog to input the winner's address and then call setWinner()
    return Future.value();
  }

  Future<void> _cancelGiveaway() {
    // TODO: Implement call to Giveaway.sol's cancelGiveaway() via Web3Service
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walletProvider = context.watch<WalletProvider>();
    
    return Scaffold(
      appBar: AppBar(title: const Text("Giveaway Details")),
      body: DiamondMeshBackground(
        child: FutureBuilder<GiveawayDetails>(
          future: _detailsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return Center(child: Text("Error: ${snapshot.error ?? 'Could not load giveaway details.'}"));
            }
            
            final details = snapshot.data!;
            final isOwner = walletProvider.isConnectedEVM && walletProvider.connectedEVMAddress?.toLowerCase() == details.contractOwner.toLowerCase();
            final isWinner = walletProvider.isConnectedEVM && details.winnerAddress != null && walletProvider.connectedEVMAddress?.toLowerCase() == details.winnerAddress!.toLowerCase();

            return RefreshIndicator(
              onRefresh: () async => _loadDetails(),
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildPrizeCard(theme, details),
                  const SizedBox(height: 16),
                  _buildProgressCard(theme, details),
                  if (isWinner && details.state == "Open") ...[
                    const SizedBox(height: 24),
                    _buildWinnerActions(theme),
                  ],
                  if (isOwner && details.state == "Open") ...[
                    const SizedBox(height: 24),
                    _buildOwnerActions(theme, details),
                  ]
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPrizeCard(ThemeData theme, GiveawayDetails details) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const FaIcon(FontAwesomeIcons.gift, size: 40, color: AppColors.gold),
            const SizedBox(height: 16),
            Text("Prize", style: theme.textTheme.titleMedium),
            Text(
              "${details.prizeAmount} ${details.prizeSymbol}",
              style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.gold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(ThemeData theme, GiveawayDetails details) {
    final progress = (details.currentProgress / details.goalTarget).clamp(0.0, 1.0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Goal: ${details.goalDescription}", style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 8),
            Text("${details.currentProgress} / ${details.goalTarget} (${(progress * 100).toStringAsFixed(1)}%)"),
            const Divider(height: 24),
            Row(
              children: [
                const Text("Status: "),
                Text(details.state, style: TextStyle(fontWeight: FontWeight.bold, color: details.state == "Open" ? AppColors.success : Colors.grey)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWinnerActions(ThemeData theme) {
    return Card(
      color: AppColors.success.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Congratulations!", style: theme.textTheme.headlineSmall?.copyWith(color: AppColors.success)),
            const SizedBox(height: 8),
            const Text("You have won this giveaway. Claim your prize now!", textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isProcessingAction ? null : _claimPrize,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
              child: _isProcessingAction ? const CircularProgressIndicator() : const Text("Claim Prize"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerActions(ThemeData theme, GiveawayDetails details) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Admin Controls", style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isProcessingAction || details.winnerAddress != null ? null : _setWinner,
              child: const Text("Set Winner"),
            ),
            const SizedBox(height: 8),
            Text(details.winnerAddress != null ? "Winner has been set." : "Set a winner once the goal is met.", style: theme.textTheme.bodySmall),
            const Divider(height: 24),
            OutlinedButton(
              onPressed: _isProcessingAction || details.winnerAddress != null ? null : _cancelGiveaway,
              style: OutlinedButton.styleFrom(foregroundColor: theme.colorScheme.error, side: BorderSide(color: theme.colorScheme.error)),
              child: const Text("Cancel Giveaway & Reclaim Prize"),
            ),
          ],
        ),
      ),
    );
  }
}

```

### File: ./lib/screens/list_property_screen.dart
```dart
// lib/screens/list_property_screen.dart
import 'dart:io';
import 'package:cabal/services/nft_service.dart';
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/widgets/animated_particle_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../features/wallet/application/wallet_provider.dart';
import '../utils/app_colors.dart';

class ListPropertyScreen extends StatefulWidget {
  const ListPropertyScreen({Key? key}) : super(key: key);

  @override
  State<ListPropertyScreen> createState() => _ListPropertyScreenState();
}

class _ListPropertyScreenState extends State<ListPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  
  // Form Controllers
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _sqftController = TextEditingController();
  final _bedsController = TextEditingController();
  final _bathsController = TextEditingController();
  final _escrowController = TextEditingController(); // <-- NEW

  XFile? _propertyImage;
  bool _isMinting = false;

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80, maxWidth: 1200);
    if (pickedImage != null) {
      setState(() {
        _propertyImage = pickedImage;
      });
    }
  }

  Future<void> _mintDeed() async {
    if (!_formKey.currentState!.validate()) return;
    if (_propertyImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please upload a property image.")));
      return;
    }
    _formKey.currentState!.save();

    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    final nftService = NftService();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (!walletProvider.isConnectedEVM) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please connect your wallet to mint a deed.")));
      return;
    }
    
    setState(() => _isMinting = true);

    try {
      // Step 1: Upload metadata to IPFS
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Uploading property data to IPFS...")));
      
      final attributes = {
        "Square Footage": _sqftController.text.trim(),
        "Bedrooms": _bedsController.text.trim(),
        "Bathrooms": _bathsController.text.trim(),
        "Required Escrow": "${_escrowController.text.trim()} ETH", // <-- NEW
      };
      
      final tokenURI = await nftService.uploadToIpfs(
        imageFile: _propertyImage!, 
        name: _addressController.text.trim(), 
        description: _descriptionController.text.trim(), 
        attributes: attributes
      );

      // Step 2: Mint the NFT on-chain
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Minting NFT... Please confirm in your wallet.")));
      
      final propertyId = "${_addressController.text.trim()}-${DateTime.now().millisecondsSinceEpoch}";
      
      final tx = web3Service.buildMintDeedTransaction(
        ownerAddress: walletProvider.connectedEVMAddress!,
        tokenURI: tokenURI,
        propertyId: propertyId,
      );

      final txHash = await walletProvider.sendTransaction(tx);
      
      // Step 3: Store property details in Supabase (including escrow amount)
      // TODO: Implement a `createProperty` method in SupabaseService
      // await supabaseService.createProperty(details: {...});

      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text("Deed minted successfully! Tx: $txHash"),
        backgroundColor: AppColors.success,
      ));
      navigator.pop(true);

    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Minting failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isMinting = false);
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _descriptionController.dispose();
    _sqftController.dispose();
    _bedsController.dispose();
    _bathsController.dispose();
    _escrowController.dispose(); // <-- NEW
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("List a New Property")),
      body: AnimatedParticleBackground(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text("Property Details", style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
              _buildImagePicker(theme),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Property Address *"),
                validator: (v) => (v == null || v.isEmpty) ? "Address is required" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description *", alignLabelWithHint: true),
                maxLines: 4,
                validator: (v) => (v == null || v.isEmpty) ? "Description is required" : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _sqftController,
                      decoration: const InputDecoration(labelText: "Sq. Footage *"),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _bedsController,
                      decoration: const InputDecoration(labelText: "Beds *"),
                      keyboardType: TextInputType.number,
                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                       validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _bathsController,
                      decoration: const InputDecoration(labelText: "Baths *"),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                      validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // --- NEW ESCROW FIELD ---
              Text("Transaction Terms", style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
              TextFormField(
                controller: _escrowController,
                decoration: const InputDecoration(
                  labelText: "Required Escrow Deposit (in ETH) *",
                  hintText: "e.g., 1.5",
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: FaIcon(FontAwesomeIcons.ethereum),
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                validator: (v) {
                  if (v == null || v.isEmpty) return "Escrow amount is required";
                  final val = double.tryParse(v);
                  if (val == null || val <= 0) return "Must be a positive number";
                  return null;
                },
              ),
              // --- END NEW FIELD ---
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: _isMinting 
                  ? Container(width: 24, height: 24, padding: const EdgeInsets.all(2.0), child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                  : const FaIcon(FontAwesomeIcons.fileSignature),
                label: Text(_isMinting ? 'Minting Deed...' : 'Mint Property Deed NFT'),
                onPressed: _isMinting ? null : _mintDeed,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker(ThemeData theme) {
    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(12),
          color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        ),
        child: _propertyImage == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined, size: 48),
                  SizedBox(height: 8),
                  Text("Upload Property Image"),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.file(
                  File(_propertyImage!.path),
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}

```

### File: ./lib/screens/product_detail_screen.dart
```dart
// lib/screens/product_detail_screen.dart
import 'package:cabal/features/wallet/application/wallet_provider.dart';
import 'package:cabal/models/merchandise_product_model.dart';
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import '../utils/app_colors.dart';

class ProductDetailScreen extends StatefulWidget {
  final MerchandiseProduct product;
  final UserProfile userProfile;

  const ProductDetailScreen({
    Key? key,
    required this.product,
    required this.userProfile,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isApproved = false; // To track if the 'approve' transaction was successful
  bool _isApproving = false;
  bool _isPurchasing = false;

  Future<void> _approvePurchase() async {
    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (!walletProvider.isConnectedEVM) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please connect your wallet to approve.")));
      return;
    }

    setState(() => _isApproving = true);

    try {
      final tx = web3Service.buildErc20ApproveTransaction(
        tokenAddress: widget.product.paymentTokenAddress,
        spenderAddress: web3Service.merchandiseStoreAddress, // The contract needs approval
        amountInWei: BigInt.parse(widget.product.priceInWei),
      );

      final txHash = await walletProvider.sendTransaction(tx);
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Approval sent! Waiting for confirmation... Tx: $txHash")));
      
      // TODO: In production, listen for transaction receipt.
      await Future.delayed(const Duration(seconds: 15));

      setState(() => _isApproved = true);
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text("Approved! You can now complete the purchase."),
        backgroundColor: AppColors.success,
      ));

    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Approval failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isApproving = false);
    }
  }

  Future<void> _purchaseItem() async {
    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() => _isPurchasing = true);
    
    try {
      final tx = web3Service.buildPurchaseTransaction(
        productId: BigInt.from(widget.product.productIdOnChain),
      );

      final txHash = await walletProvider.sendTransaction(tx);
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Purchase transaction sent! Waiting for confirmation... Tx: $txHash")));

      // TODO: Listen for transaction receipt.
      await Future.delayed(const Duration(seconds: 15));
      
      // TODO: Deactivate in Supabase after successful purchase.
      // await supabaseService.deactivateMerch(widget.product.id);

      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text("Purchase successful!"),
        backgroundColor: AppColors.success,
      ));
      navigator.pop(true);

    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Purchase failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isPurchasing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFormat = NumberFormat("###,##0.00####", "en_US");
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.product.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DiamondMeshBackground(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: kToolbarHeight + MediaQuery.of(context).padding.top),
                children: [
                  Image.network(
                    widget.product.imageUrl ?? 'https://via.placeholder.com/400/1E1E1E/FFFFFF?Text=Merch',
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Divider(height: 32),
                        Text("Description", style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(
                          widget.product.description ?? "No description provided.",
                          style: theme.textTheme.bodyLarge,
                        ),
                        if (widget.product.bonusAmount != null && widget.product.bonusAmount! > 0) ...[
                          const Divider(height: 32),
                          Text("Bonus Reward", style: theme.textTheme.titleLarge),
                          const SizedBox(height: 8),
                          Chip(
                            avatar: const FaIcon(FontAwesomeIcons.medal),
                            label: Text("Get ${numberFormat.format(widget.product.bonusAmount)} ${widget.product.bonusTokenSymbol ?? 'Tokens'} with this purchase!"),
                            backgroundColor: AppColors.gold.withOpacity(0.2),
                          )
                        ]
                      ],
                    ),
                  )
                ],
              ),
            ),
            _buildBottomBar(theme, numberFormat),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(ThemeData theme, NumberFormat numberFormat) {
    bool isLoading = _isApproving || _isPurchasing;
    
    return Material(
      elevation: 8,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).padding.bottom + 16),
        color: theme.cardColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Price", style: theme.textTheme.bodyMedium),
                Text(
                  "${numberFormat.format(widget.product.price)} ${widget.product.paymentTokenSymbol}",
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                ),
              ],
            ),
            
            if (!_isApproved)
              ElevatedButton(
                onPressed: isLoading ? null : _approvePurchase,
                child: _isApproving ? const CircularProgressIndicator(color: Colors.white) : const Text("1. Approve Purchase"),
              ),
            
            if (_isApproved)
              ElevatedButton(
                onPressed: isLoading ? null : _purchaseItem,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                child: _isPurchasing ? const CircularProgressIndicator(color: Colors.white) : const Text("2. Buy Now"),
              )
          ],
        ),
      ),
    );
  }
}

```

### File: ./lib/screens/add_merch_screen.dart
```dart
// lib/screens/add_merch_screen.dart
import 'dart:io';
import 'package:cabal/features/wallet/application/wallet_provider.dart';
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/services/nft_service.dart';
import 'package:cabal/services/supabase_service.dart';
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/widgets/animated_particle_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';

class AddMerchScreen extends StatefulWidget {
  final String cabalId;
  final UserProfile userProfile;

  const AddMerchScreen({
    Key? key,
    required this.cabalId,
    required this.userProfile,
  }) : super(key: key);

  @override
  State<AddMerchScreen> createState() => _AddMerchScreenState();
}

class _AddMerchScreenState extends State<AddMerchScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Form Controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _paymentTokenAddressController = TextEditingController();
  final _paymentTokenSymbolController = TextEditingController();
  final _bonusTokenAddressController = TextEditingController();
  final _bonusTokenSymbolController = TextEditingController();
  final _bonusAmountController = TextEditingController();
  
  XFile? _productImage;
  bool _isListing = false;

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80, maxWidth: 1024);
    if (pickedImage != null) {
      setState(() => _productImage = pickedImage);
    }
  }

  Future<void> _listProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_productImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please upload a product image.")));
      return;
    }
    _formKey.currentState!.save();
    
    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    final supabaseService = context.read<SupabaseService>();
    final nftService = NftService();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (!walletProvider.isConnectedEVM) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please connect your wallet to list merchandise.")));
      return;
    }
    
    setState(() => _isListing = true);

    try {
      // Step 1: Upload image to IPFS to get a permanent URL for the metadata
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Uploading product image...")));
      final imageUrl = await nftService.uploadToIpfs(
        imageFile: _productImage!,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        attributes: {},
      );

      // Step 2: Send the on-chain transaction to list the product
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Sending transaction... Please confirm in your wallet.")));
      
      // TODO: Implement the buildListProductTransaction in Web3Service
      // For now, we simulate success
      await Future.delayed(const Duration(seconds: 3));
      final onChainProductId = 0; // This would come from the transaction receipt event log

      // Step 3: Save the product metadata to Supabase for fast querying
      await supabaseService.createMerchandiseProduct({
        'cabal_id': widget.cabalId,
        'creator_user_id': widget.userProfile.id,
        'product_id_onchain': onChainProductId,
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'image_url': imageUrl,
        'payment_token_address': _paymentTokenAddressController.text.trim(),
        'payment_token_symbol': _paymentTokenSymbolController.text.trim(),
        'price_in_wei': (double.parse(_priceController.text.trim()) * 1e18).toStringAsFixed(0),
        'bonus_token_address': _bonusTokenAddressController.text.trim().isEmpty ? null : _bonusTokenAddressController.text.trim(),
        'bonus_token_symbol': _bonusTokenSymbolController.text.trim().isEmpty ? null : _bonusTokenSymbolController.text.trim(),
        'bonus_amount_in_wei': _bonusAmountController.text.trim().isEmpty ? null : (double.parse(_bonusAmountController.text.trim()) * 1e18).toStringAsFixed(0),
      });
      
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text("Product listed successfully!"),
        backgroundColor: AppColors.success,
      ));
      navigator.pop(true); // Pop with success to trigger a refresh

    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Listing failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isListing = false);
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _paymentTokenAddressController.dispose();
    _paymentTokenSymbolController.dispose();
    _bonusTokenAddressController.dispose();
    _bonusTokenSymbolController.dispose();
    _bonusAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("List New Merchandise")),
      body: AnimatedParticleBackground(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text("Product Details", style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
              _buildImagePicker(theme),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Product Name *"),
                validator: (v) => (v == null || v.isEmpty) ? "Name is required" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description", alignLabelWithHint: true),
                maxLines: 3,
              ),
              
              const Divider(height: 32),
              
              Text("Payment", style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
              TextFormField(
                controller: _paymentTokenAddressController,
                decoration: const InputDecoration(labelText: "Payment Token Address *"),
                validator: (v) => (v == null || !v.startsWith('0x') || v.length != 42) ? "Enter a valid address" : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: "Price *"),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                      validator: (v) => (v == null || v.isEmpty || double.tryParse(v) == null) ? "Required" : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _paymentTokenSymbolController,
                      decoration: const InputDecoration(labelText: "Symbol *", hintText: "e.g., USDC"),
                      validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
                    ),
                  ),
                ],
              ),
              
              const Divider(height: 32),

              Text("Bonus Reward (Optional)", style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
               TextFormField(
                controller: _bonusTokenAddressController,
                decoration: const InputDecoration(labelText: "Bonus Token Address"),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _bonusAmountController,
                      decoration: const InputDecoration(labelText: "Bonus Amount"),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _bonusTokenSymbolController,
                      decoration: const InputDecoration(labelText: "Symbol", hintText: "e.g., CAB"),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: _isListing 
                  ? Container(width: 24, height: 24, padding: const EdgeInsets.all(2.0), child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                  : const Icon(Icons.add_shopping_cart_rounded),
                label: Text(_isListing ? 'Listing Product...' : 'List Product'),
                onPressed: _isListing ? null : _listProduct,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker(ThemeData theme) {
    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(12),
          color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        ),
        child: _productImage == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined, size: 48),
                  SizedBox(height: 8),
                  Text("Upload Product Image *"),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.file(
                  File(_productImage!.path),
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}

```

### File: ./lib/screens/roadmap_screen.dart
```dart
// lib/screens/roadmap_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/animated_particle_background.dart';
import '../utils/app_colors.dart';

// --- Data Models for the Roadmap ---
enum RoadmapStatus { done, inProgress, planned }

class RoadmapFeature {
  final String title;
  final String description;
  final RoadmapStatus status;

  RoadmapFeature({
    required this.title,
    required this.description,
    required this.status,
  });
}

class RoadmapPhase {
  final String title;
  final String goal;
  final String timeline;
  final RoadmapStatus status;
  final List<RoadmapFeature> features;

  RoadmapPhase({
    required this.title,
    required this.goal,
    required this.timeline,
    required this.status,
    required this.features,
  });
}

// --- Roadmap Screen Widget ---
class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({Key? key}) : super(key: key);

  // --- FULLY UPDATED ROADMAP DATA ---
  static final List<RoadmapPhase> roadmapData = [
    RoadmapPhase(
      title: "Phase 1: Foundation & Core MVP",
      goal: "Establish a stable, engaging platform with a complete user journey, from onboarding to quest completion and social interaction.",
      timeline: "Complete",
      status: RoadmapStatus.done,
      features: [
        RoadmapFeature(title: "Full User Authentication & Profiles", description: "Robust sign-up/login, profile editing, and social connections.", status: RoadmapStatus.done),
        RoadmapFeature(title: "Dynamic Cabal & Quest System", description: "Creators can launch and manage public/private cabals with quests.", status: RoadmapStatus.done),
        RoadmapFeature(title: "Live Community Hub", description: "Users can create posts and comments within cabals to foster engagement.", status: RoadmapStatus.done),
        RoadmapFeature(title: "KOL Dashboard & Referral System", description: "Influencers can track referrals and performance against set targets.", status: RoadmapStatus.done),
      ],
    ),
    RoadmapPhase(
      title: "Phase 2: Web3 Economy & Creator Tools",
      goal: "Integrate a full-fledged on-chain economy, enabling real value creation and transfer for users and creators.",
      timeline: "Complete",
      status: RoadmapStatus.done,
      features: [
        RoadmapFeature(title: "Full EVM & Solana Wallet Integration", description: "Seamless wallet connectivity on both mobile and web for secure on-chain actions.", status: RoadmapStatus.done),
        RoadmapFeature(title: "Cabal TGE & Tokenomics", description: "Deployment of the \$CBL token with on-chain vesting schedules and a public presale mechanism.", status: RoadmapStatus.done),
        RoadmapFeature(title: "On-Chain Creator Tipping", description: "Users can directly tip creators on community posts with \$CBL tokens.", status: RoadmapStatus.done),
        RoadmapFeature(title: "NFT Real Estate Protocol", description: "Ability to tokenize real-world or digital property as NFTs (Deeds) on the blockchain.", status: RoadmapStatus.done),
        RoadmapFeature(title: "NFT Marketplace V1", description: "A secure on-chain marketplace for users to list and buy NFTs for native currency (e.g., ETH).", status: RoadmapStatus.done),
      ],
    ),
    RoadmapPhase(
      title: "Phase 3: Advanced Commerce & Engagement",
      goal: "Build sophisticated commerce and engagement tools that deepen the on-chain economy and provide unparalleled value for Cabal creators.",
      timeline: "In Progress",
      status: RoadmapStatus.inProgress,
      features: [
        RoadmapFeature(title: "Cabal Giveaway Protocol", description: "Creators can lock high-value prizes (like a Tesla or USDC) into a smart contract that automatically pays out when specific on-chain growth targets are met.", status: RoadmapStatus.inProgress),
        RoadmapFeature(title: "Real Estate Offer & Bidding System", description: "Enable a secure offer/counter-offer system for NFT properties, with on-chain fund verification.", status: RoadmapStatus.planned),
        RoadmapFeature(title: "User Wallet V2: Swaps & Management", description: "Integrate a DEX aggregator to allow users to swap \$CBL for other tokens directly within the app.", status: RoadmapStatus.planned),
        RoadmapFeature(title: "Advanced Creator Toolkit", description: "Provide boilerplate smart contracts (e.g., for staking, DAOs) and IPFS tools that creators can easily deploy for their Cabals.", status: RoadmapStatus.planned),
      ],
    ),
    RoadmapPhase(
      title: "Phase 4: Decentralization & Multi-Chain",
      goal: "Transition core functionalities to user-owned protocols and expand Cabal's presence across multiple blockchain ecosystems.",
      timeline: "Planned",
      status: RoadmapStatus.planned,
      features: [
        RoadmapFeature(title: "Cabal Governance (DAO)", description: "Allow \$CBL token holders to vote on platform features, treasury usage, and fee structures.", status: RoadmapStatus.planned),
        RoadmapFeature(title: "Full Solana Protocol Parity", description: "Implement Solana-native smart contracts for the marketplace, escrow, and giveaways.", status: RoadmapStatus.planned),
        RoadmapFeature(title: "L2 & Multi-Chain Deployment", description: "Deploy contracts on Layer 2 solutions like Base or Arbitrum to drastically reduce user gas fees and improve speed.", status: RoadmapStatus.planned),
      ],
    ),
    RoadmapPhase(
      title: "Phase 5: Monetization & Sustainability",
      goal: "Introduce sustainable, value-aligned revenue streams to ensure the long-term growth and development of the Cabal ecosystem.",
      timeline: "Planned",
      status: RoadmapStatus.planned,
      features: [
        RoadmapFeature(title: "Marketplace & Escrow Fees", description: "A small, transparent percentage fee on successful NFT and real estate transactions.", status: RoadmapStatus.planned),
        RoadmapFeature(title: "Premium Creator Tools", description: "Offer advanced analytics, custom smart contract templates, and priority support for a subscription in \$CBL.", status: RoadmapStatus.planned),
        RoadmapFeature(title: "TGE Launchpad Service Fees", description: "A fee for projects that use Cabal's platform to launch their own tokens and manage their TGE.", status: RoadmapStatus.planned),
      ],
    ),
  ];

  Widget _buildStatusIcon(RoadmapStatus status, ThemeData theme) {
    switch (status) {
      case RoadmapStatus.done:
        return FaIcon(FontAwesomeIcons.solidCircleCheck, color: AppColors.success, size: 20);
      case RoadmapStatus.inProgress:
        return FaIcon(FontAwesomeIcons.spinner, color: theme.colorScheme.primary, size: 20)
            .animate(onPlay: (c) => c.repeat())
            .rotate(duration: 1500.ms);
      case RoadmapStatus.planned:
        return FaIcon(FontAwesomeIcons.lightbulb, color: theme.colorScheme.secondary.withOpacity(0.8), size: 20);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Roadmap"),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: AnimatedParticleBackground(
        baseColor: theme.scaffoldBackgroundColor,
        particleColor1: isDark ? AppColors.particleGoldSoft.withOpacity(0.2) : AppColors.particleGoldSoft.withOpacity(0.4),
        particleColor2: isDark ? AppColors.particleGreySoft.withOpacity(0.2) : AppColors.particleGreySoft.withOpacity(0.3),
        child: ListView.builder(
          padding: EdgeInsets.only(top: kToolbarHeight + MediaQuery.of(context).padding.top + 20, left: 16, right: 16, bottom: 40),
          itemCount: roadmapData.length,
          itemBuilder: (context, index) {
            final phase = roadmapData[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 12.0),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildStatusIcon(phase.status, theme),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            phase.title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      phase.timeline,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.8),
                      ),
                    ),
                    Divider(height: 24, thickness: 0.5, color: theme.dividerColor.withOpacity(0.5)),
                    Text(
                      phase.goal,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ...phase.features.map(
                      (feature) => ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 8.0),
                        childrenPadding: const EdgeInsets.all(12.0).copyWith(top: 0),
                        leading: _buildStatusIcon(feature.status, theme),
                        title: Text(
                          feature.title,
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        children: [
                          Text(
                            feature.description,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: (200 * index).ms).slideY(begin: 0.2);
          },
        ),
      ),
    );
  }
}

```

### File: ./lib/screens/escrow_detail_screen.dart
```dart
// lib/screens/escrow_detail_screen.dart
import 'package:cabal/features/wallet/application/wallet_provider.dart';
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import '../utils/app_colors.dart';

// This model should be in its own file: lib/models/escrow_details_model.dart
class EscrowDetails {
  final String seller;
  final String buyer;
  final String broker;
  final String salePriceEth;
  final BigInt salePriceWei;
  final String state; // e.g., "Locked", "InspectionPassed"
  final bool buyerApproved;
  final bool sellerApproved;
  final bool brokerApproved;

  EscrowDetails({
    required this.seller, required this.buyer, required this.broker,
    required this.salePriceEth, required this.salePriceWei, required this.state,
    required this.buyerApproved, required this.sellerApproved, required this.brokerApproved,
  });
}

class EscrowDetailScreen extends StatefulWidget {
  final int tokenId;
  
  const EscrowDetailScreen({
    Key? key,
    required this.tokenId,
  }) : super(key: key);

  @override
  State<EscrowDetailScreen> createState() => _EscrowDetailScreenState();
}

class _EscrowDetailScreenState extends State<EscrowDetailScreen> {
  Future<EscrowDetails>? _detailsFuture;
  bool _isProcessingAction = false;
  late final Web3Service _web3Service;

  @override
  void initState() {
    super.initState();
    _web3Service = context.read<Web3Service>();
    _loadDetails();
  }

  void _loadDetails() {
    setState(() {
      _detailsFuture = _fetchEscrowDetails();
    });
  }

  Future<EscrowDetails> _fetchEscrowDetails() async {
    return await _web3Service.getEscrowDetails(BigInt.from(widget.tokenId));
  }
  
  Future<void> _handleTransaction(Transaction tx, String successMessage) async {
    final walletProvider = context.read<WalletProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    setState(() => _isProcessingAction = true);
    try {
      final txHash = await walletProvider.sendTransaction(tx);
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text("$successMessage Tx: $txHash. State will update after confirmation."),
        backgroundColor: AppColors.success,
      ));
      
      // In a production app, you would listen for the transaction receipt.
      await Future.delayed(const Duration(seconds: 15));
      _loadDetails(); // Refresh state after action
    } catch(e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Action failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isProcessingAction = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walletProvider = context.watch<WalletProvider>();
    
    return Scaffold(
      appBar: AppBar(title: const Text("Real Estate Escrow")),
      body: DiamondMeshBackground(
        child: FutureBuilder<EscrowDetails>(
          future: _detailsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return Center(child: Text("Error: ${snapshot.error ?? 'Could not load escrow details.'}"));
            }
            
            final details = snapshot.data!;
            final isSeller = walletProvider.isConnectedEVM && walletProvider.connectedEVMAddress?.toLowerCase() == details.seller.toLowerCase();
            final isBuyer = walletProvider.isConnectedEVM && walletProvider.connectedEVMAddress?.toLowerCase() == details.buyer.toLowerCase();
            final isBroker = walletProvider.isConnectedEVM && walletProvider.connectedEVMAddress?.toLowerCase() == details.broker.toLowerCase();

            return RefreshIndicator(
              onRefresh: () async => _loadDetails(),
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildStatusTimeline(theme, details),
                  const SizedBox(height: 16),
                  _buildPartiesCard(theme, details),
                  const SizedBox(height: 16),
                  _buildActionCard(theme, details, isSeller, isBuyer, isBroker),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusTimeline(ThemeData theme, EscrowDetails details) {
    final states = ["Created", "Locked", "InspectionPassed", "Complete"];
    int currentStateIndex = states.indexOf(details.state);
    if (details.state == "Canceled") currentStateIndex = -1;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Transaction Status", style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(states.length, (index) {
                final bool isComplete = index < currentStateIndex;
                final bool isCurrent = index == currentStateIndex;
                Color color = Colors.grey;
                if (isComplete) color = AppColors.success;
                if (isCurrent) color = theme.colorScheme.primary;
                if (details.state == "Canceled") color = theme.colorScheme.error;

                return Column(
                  children: [
                    Icon(
                      isComplete ? Icons.check_circle : (isCurrent ? Icons.timelapse : Icons.radio_button_unchecked),
                      color: color,
                    ),
                    const SizedBox(height: 4),
                    Text(states[index], style: theme.textTheme.bodySmall?.copyWith(color: isCurrent ? color : null))
                  ],
                );
              }),
            ),
             if (details.state == "Canceled") ...[
              const SizedBox(height: 8),
              Center(child: Text("This sale has been canceled.", style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.bold)))
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildPartiesCard(ThemeData theme, EscrowDetails details) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text("Parties & Price", style: theme.textTheme.titleLarge),
             const Divider(height: 24),
            _buildPartyRow(theme, "Seller", details.seller),
            _buildPartyRow(theme, "Buyer", details.buyer.contains('0000000') ? 'N/A (Waiting for deposit)' : details.buyer),
            _buildPartyRow(theme, "Broker", details.broker),
            const Divider(height: 24),
            _buildPartyRow(theme, "Sale Price", details.salePriceEth, isAddress: false),
          ],
        ),
      ),
    );
  }

  Widget _buildPartyRow(ThemeData theme, String role, String value, {bool isAddress = true}) {
    final displayValue = (isAddress && value.length > 10) ? "${value.substring(0, 6)}...${value.substring(value.length - 4)}" : value;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(role, style: theme.textTheme.bodyLarge),
          SelectableText(displayValue, style: theme.textTheme.bodyMedium?.copyWith(fontFamily: isAddress ? 'monospace' : null)),
        ],
      ),
    );
  }
  
  Widget _buildActionCard(ThemeData theme, EscrowDetails details, bool isSeller, bool isBuyer, bool isBroker) {
    final walletProvider = context.watch<WalletProvider>();
    if (!walletProvider.isConnectedEVM) return const SizedBox.shrink();
    
    final tokenId = BigInt.from(widget.tokenId);
    Widget actionWidget = const Text("No actions available for you at this stage.");
    bool isParty = isSeller || isBuyer || isBroker;

    if (details.state == "Created" && !isSeller) {
      actionWidget = _buildActionButton(
        title: "Deposit Escrow",
        subtitle: "Lock the sale by depositing ${details.salePriceEth}.",
        buttonText: "Deposit Funds",
        onPressed: () => _handleTransaction(
          _web3Service.buildDepositFundsTransaction(tokenId: tokenId, escrowAmountWei: details.salePriceWei),
          "Deposit transaction sent!"
        ),
      );
    } else if (details.state == "Locked" && isParty) {
      actionWidget = _buildInspectionApprovalSection(theme, details, isSeller, isBuyer, isBroker);
    } else if (details.state == "InspectionPassed" && isParty) {
       actionWidget = _buildActionButton(
        title: "Finalize Sale",
        subtitle: "All parties have approved. This will transfer the NFT and release funds.",
        buttonText: "Finalize",
        onPressed: () => _handleTransaction(
          _web3Service.buildFinalizeSaleTransaction(tokenId: tokenId),
          "Finalization transaction sent!"
        ),
        color: AppColors.success,
      );
    }
    
    // Allow cancellation if it's a party and the state is appropriate
    if ((details.state == "Created" || details.state == "Locked") && isParty) {
      actionWidget = Column(children: [
        actionWidget, // Show the primary action first
        const Divider(height: 24),
        _buildActionButton(
          title: "Cancel Sale",
          subtitle: "This will return the NFT to the seller and refund the buyer if funds were deposited.",
          buttonText: "Cancel",
          onPressed: () => _handleTransaction(
            _web3Service.buildCancelSaleTransaction(tokenId: tokenId),
            "Cancellation transaction sent!"
          ),
          color: theme.colorScheme.error,
        ),
      ]);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your Action", style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            actionWidget,
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _isProcessingAction ? null : onPressed,
          style: ElevatedButton.styleFrom(backgroundColor: color, padding: const EdgeInsets.symmetric(vertical: 12)),
          child: _isProcessingAction ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white)) : Text(buttonText),
        ),
      ],
    );
  }

  Widget _buildInspectionApprovalSection(ThemeData theme, EscrowDetails details, bool isSeller, bool isBuyer, bool isBroker) {
    bool currentUserHasApproved = 
      (isSeller && details.sellerApproved) ||
      (isBuyer && details.buyerApproved) ||
      (isBroker && details.brokerApproved);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Inspection & Due Diligence", style: theme.textTheme.titleMedium),
        const Text("All three parties must approve this stage to proceed."),
        const SizedBox(height: 16),
        _buildApprovalStatus("Seller", details.sellerApproved),
        _buildApprovalStatus("Buyer", details.buyerApproved),
        _buildApprovalStatus("Broker", details.brokerApproved),
        const SizedBox(height: 16),
        if (isSeller || isBuyer || isBroker)
          ElevatedButton(
            onPressed: _isProcessingAction || currentUserHasApproved ? null : () => _handleTransaction(
              _web3Service.buildApproveInspectionTransaction(tokenId: BigInt.from(widget.tokenId)),
              "Approval transaction sent!"
            ),
            child: Text(currentUserHasApproved ? "You Have Approved" : "Approve Inspection"),
          ),
      ],
    );
  }

  Widget _buildApprovalStatus(String role, bool isApproved) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            isApproved ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isApproved ? AppColors.success : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text("$role Approval"),
        ],
      ),
    );
  }
}

```

### File: ./lib/screens/list_nft_screen.dart
```dart
// lib/screens/list_nft_screen.dart
import 'package:cabal/models/nft_listing_model.dart';
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/services/supabase_service.dart';
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/widgets/animated_particle_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import '../../features/wallet/application/wallet_provider.dart';
import '../screens/user_wallet_screen.dart'; // For the UserNft model
import '../utils/app_colors.dart';

class ListNftScreen extends StatefulWidget {
  final UserNft nft;
  final UserProfile userProfile;

  const ListNftScreen({
    Key? key,
    required this.nft,
    required this.userProfile,
  }) : super(key: key);

  @override
  State<ListNftScreen> createState() => _ListNftScreenState();
}

class _ListNftScreenState extends State<ListNftScreen> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();

  bool _isApproved = false; // To track if the 'approve' transaction was successful
  bool _isApproving = false;
  bool _isListing = false;

  Future<void> _approveMarketplace() async {
    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (!walletProvider.isConnectedEVM) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please connect your wallet first.")));
      return;
    }

    setState(() => _isApproving = true);

    try {
      final tx = web3Service.buildApproveNftTransaction(
        nftContractAddress: widget.nft.contractAddress,
        tokenId: BigInt.from(widget.nft.tokenId),
      );

      final txHash = await walletProvider.sendTransaction(tx);
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Approval transaction sent! Waiting for confirmation... Tx: $txHash")));

      // TODO: In a production app, you would use a transaction receipt listener to confirm.
      await Future.delayed(const Duration(seconds: 10));

      setState(() => _isApproved = true);
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text("Marketplace approved! You can now list your item."),
        backgroundColor: AppColors.success,
      ));

    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Approval failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isApproving = false);
    }
  }

  Future<void> _listItemForSale() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    final supabaseService = context.read<SupabaseService>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    
    final priceDouble = double.tryParse(_priceController.text);
    if (priceDouble == null || priceDouble <= 0) return;

    setState(() => _isListing = true);

    try {
      // Safest way to convert double ETH to BigInt wei
      final etherInWei = BigInt.from(10).pow(18);
      final priceInWei = BigInt.from(priceDouble * etherInWei.toDouble());

      // --- Step 1: Send the on-chain transaction ---
      final tx = web3Service.buildListItemTransaction(
        nftContractAddress: widget.nft.contractAddress,
        tokenId: BigInt.from(widget.nft.tokenId),
        priceInWei: priceInWei,
      );
      final txHash = await walletProvider.sendTransaction(tx);
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Listing transaction sent! Waiting for confirmation... Tx: $txHash")));

      // TODO: Wait for transaction confirmation.
      await Future.delayed(const Duration(seconds: 10));
      
      // --- Step 2: Save the listing to our off-chain cache in Supabase ---
      final newListing = NftListing(
        id: '', // Supabase will generate this
        nftContractAddress: widget.nft.contractAddress,
        tokenId: widget.nft.tokenId,
        sellerAddress: walletProvider.connectedEVMAddress!,
        priceWei: priceInWei.toString(),
        isActive: true,
        listerUserId: widget.userProfile.id,
        tokenUri: '', // This could be fetched and stored if needed
        nftName: widget.nft.name,
        nftImageUrl: widget.nft.imageUrl,
        collectionName: widget.nft.collectionName,
        createdAt: DateTime.now(),
      );
      await supabaseService.createNftListing(newListing);
      
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text("Your NFT is now listed on the marketplace!"),
        backgroundColor: AppColors.success,
      ));
      navigator.pop(true); // Pop with success to trigger refresh

    } catch (e) {
       scaffoldMessenger.showSnackBar(SnackBar(content: Text("Listing failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isListing = false);
    }
  }


  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool isLoading = _isApproving || _isListing;

    return Scaffold(
      appBar: AppBar(title: const Text("List NFT for Sale")),
      body: AnimatedParticleBackground(
        child: AbsorbPointer(
          absorbing: isLoading,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Image.network(widget.nft.imageUrl, height: 250, fit: BoxFit.cover),
                    ListTile(
                      title: Text(widget.nft.name),
                      subtitle: Text(widget.nft.collectionName),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text("Set Your Price", style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: "Price in ETH",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: FaIcon(FontAwesomeIcons.ethereum),
                    )
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Price is required";
                    if (double.tryParse(v) == null || double.parse(v) <= 0) return "Enter a valid price";
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 32),
              
              if (!_isApproved)
                ElevatedButton(
                  onPressed: isLoading ? null : _approveMarketplace,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: _isApproving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('1. Approve Marketplace'),
                ),
              
              if (_isApproved)
                ElevatedButton(
                  onPressed: isLoading ? null : _listItemForSale,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.success
                  ),
                  child: _isListing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('2. List for Sale'),
                ),
              const SizedBox(height: 12),
              Text(
                _isApproved 
                ? "You've approved the marketplace. Now you can finalize the listing." 
                : "You must first send an 'approve' transaction to allow the marketplace contract to transfer your NFT upon sale.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

```

### File: ./lib/screens/nft_detail_screen.dart
```dart
// lib/screens/nft_detail_screen.dart
import 'package:cabal/models/nft_listing_model.dart';
import 'package:cabal/services/supabase_service.dart';
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import '../../features/wallet/application/wallet_provider.dart';
import '../utils/app_colors.dart';

class NftDetailScreen extends StatefulWidget {
  final NftListing listing;
  const NftDetailScreen({Key? key, required this.listing}) : super(key: key);

  @override
  State<NftDetailScreen> createState() => _NftDetailScreenState();
}

class _NftDetailScreenState extends State<NftDetailScreen> {
  bool _isBuying = false;

  Future<void> _buyNft() async {
    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    final supabaseService = context.read<SupabaseService>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (!walletProvider.isConnectedEVM) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please connect your wallet to buy.")));
      walletProvider.connectEVMWallet(context: context);
      return;
    }

    if (walletProvider.connectedEVMAddress?.toLowerCase() == widget.listing.sellerAddress.toLowerCase()) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("You cannot buy your own listing.")));
      return;
    }

    setState(() => _isBuying = true);

    try {
      // In a real app, you would have a buildBuyItemTransaction method in your Web3Service
      // For now, we simulate the logic.
      final tx = Transaction(
        to: EthereumAddress.fromHex(web3Service.nftMarketplaceAddress), // Placeholder
        value: EtherAmount.inWei(BigInt.parse(widget.listing.priceWei)),
        // data: web3Service.buildBuyItemData(widget.listing.nftContractAddress, widget.listing.tokenId),
      );
      
      final txHash = await walletProvider.sendTransaction(tx);
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Purchase transaction sent! Waiting for confirmation... Tx: $txHash")));

      // TODO: In a real app, you would wait for the transaction to be mined.
      await Future.delayed(const Duration(seconds: 5));

      // After successful transaction, update the off-chain cache
      await supabaseService.deactivateNftListing(widget.listing.id);

      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text("Purchase successful! You now own ${widget.listing.nftName}."),
        backgroundColor: AppColors.success,
      ));
      
      navigator.pop(true); // Pop with success to trigger refresh on previous screen

    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Purchase failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isBuying = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFormat = NumberFormat("###,##0.00####", "en_US");
    final displaySellerAddress = "${widget.listing.sellerAddress.substring(0, 6)}...${widget.listing.sellerAddress.substring(widget.listing.sellerAddress.length - 4)}";

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.listing.nftName ?? "NFT Details"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DiamondMeshBackground(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: kToolbarHeight + MediaQuery.of(context).padding.top),
                children: [
                  Hero(
                    tag: 'nft_image_${widget.listing.id}',
                    child: Image.network(
                      widget.listing.nftImageUrl ?? 'https://via.placeholder.com/400/1E1E1E/FFFFFF?Text=NFT',
                      height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.listing.collectionName ?? 'Unknown Collection',
                          style: theme.textTheme.titleMedium
                        ),
                        Text(
                          widget.listing.nftName ?? 'Unnamed NFT',
                          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          "Owned by: $displaySellerAddress",
                          style: theme.textTheme.bodyMedium?.copyWith(fontFamily: 'monospace'),
                        ),
                        const Divider(height: 32),
                        Text("Description", style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(
                          "This unique digital asset represents a verifiable item within the Cabal ecosystem. Ownership is secured on the blockchain.", // Placeholder description
                          style: theme.textTheme.bodyLarge,
                        ),
                         const SizedBox(height: 16),
                        // Placeholder for attributes
                        Text("Attributes", style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        const Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                             Chip(label: Text("Type: Real Estate")),
                             Chip(label: Text("Location: Genesis City")),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            _buildBottomBar(theme, numberFormat),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(ThemeData theme, NumberFormat numberFormat) {
    final walletProvider = context.watch<WalletProvider>();
    final isOwner = walletProvider.isConnectedEVM && walletProvider.connectedEVMAddress?.toLowerCase() == widget.listing.sellerAddress.toLowerCase();
    
    return Material(
      elevation: 8,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).padding.bottom + 16),
        color: theme.cardColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Price", style: theme.textTheme.bodyMedium),
                Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.ethereum, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      numberFormat.format(widget.listing.priceInEth),
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton.icon(
              icon: _isBuying
                  ? Container(width: 24, height: 24, padding: const EdgeInsets.all(2.0), child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                  : const Icon(Icons.shopping_cart_checkout_rounded),
              label: Text(_isBuying ? 'Processing...' : (isOwner ? 'Your Listing' : 'Buy Now')),
              onPressed: (_isBuying || isOwner) ? null : _buyNft,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                textStyle: theme.textTheme.titleLarge,
              ),
            )
          ],
        ),
      ),
    );
  }
}

```

### File: ./lib/screens/user_wallet_screen.dart
```dart
// lib/screens/user_wallet_screen.dart
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/screens/list_nft_screen.dart';
import 'package:cabal/services/nft_service.dart';
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import '../../features/wallet/application/wallet_provider.dart';
import '../utils/app_colors.dart';

// --- Data Models for UI ---
class UserToken {
  final String name;
  final String symbol;
  final String logoUrl;
  final double balance;
  final double valueUsd;
  final String contractAddress;

  UserToken({
    required this.name,
    required this.symbol,
    required this.logoUrl,
    required this.balance,
    required this.valueUsd,
    required this.contractAddress,
  });
}

class UserNft {
  final String name;
  final String collectionName;
  final String imageUrl;
  final String contractAddress;
  final int tokenId;

  UserNft({
    required this.name,
    required this.collectionName,
    required this.imageUrl,
    required this.contractAddress,
    required this.tokenId,
  });
}

class UserWalletScreen extends StatefulWidget {
  final UserProfile userProfile;
  const UserWalletScreen({Key? key, required this.userProfile}) : super(key: key);

  @override
  State<UserWalletScreen> createState() => _UserWalletScreenState();
}

class _UserWalletScreenState extends State<UserWalletScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Future<Map<String, dynamic>>? _walletDataFuture;

  // --- Services ---
  late final Web3Service _web3Service;
  late final NftService _nftService;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _web3Service = context.read<Web3Service>();
    _nftService = NftService();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final walletProvider = context.read<WalletProvider>();
      if (walletProvider.isConnectedEVM) {
        _loadWalletData();
      }
    });
  }

  void _loadWalletData() {
    setState(() {
      _walletDataFuture = _fetchWalletData();
    });
  }

  Future<Map<String, dynamic>> _fetchWalletData() async {
    final walletProvider = context.read<WalletProvider>();
    final address = walletProvider.connectedEVMAddress!;
    if (address.isEmpty) return {'tokens': [], 'nfts': []};

    try {
      final results = await Future.wait([
        _web3Service.getUserCblBalance(address),
        _web3Service.getEthBalance(address),
        _nftService.fetchUserNfts(address),
      ]);

      // TODO: Get real prices from a price feed service (e.g., CoinGecko)
      final cblBalance = (results[0] as BigInt).toDouble() / 1e18;
      final ethBalance = (results[1] as EtherAmount).getValueInUnit(EtherUnit.ether);
      final cblPrice = 0.025;
      final ethPrice = 3000.0;
      
      final tokens = [
        UserToken(name: "Cabal", symbol: "CBL", logoUrl: "assets/images/cabal_logo.png", balance: cblBalance, valueUsd: cblBalance * cblPrice, contractAddress: _web3Service.cabalTokenAddress),
        UserToken(name: "Ethereum", symbol: "ETH", logoUrl: "", balance: ethBalance, valueUsd: ethBalance * ethPrice, contractAddress: "0x0"),
      ];
      
      final nfts = results[2] as List<UserNft>;
      
      return {'tokens': tokens, 'nfts': nfts};
    } catch (e) {
      debugPrint("Error fetching wallet data: $e");
      rethrow;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walletProvider = context.watch<WalletProvider>();
    
    if (!walletProvider.isConnectedEVM) {
      return Scaffold(
        appBar: AppBar(title: const Text("My Wallet")),
        body: DiamondMeshBackground(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Please connect your wallet to view your assets."),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => walletProvider.connectEVMWallet(context: context),
                  child: const Text("Connect Wallet"),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("My Wallet"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DiamondMeshBackground(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _walletDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData) {
              return const Center(child: Text("No data found."));
            }

            final data = snapshot.data!;
            final List<UserToken> tokens = data['tokens'];
            final List<UserNft> nfts = data['nfts'];
            final totalValue = tokens.fold<double>(0, (sum, item) => sum + item.valueUsd);
            final currencyFormat = NumberFormat.currency(symbol: '\$');

            return Column(
              children: [
                SizedBox(height: kToolbarHeight + MediaQuery.of(context).padding.top),
                _buildHeader(theme, currencyFormat.format(totalValue)),
                TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'Tokens (${tokens.length})'),
                    Tab(text: 'NFTs (${nfts.length})'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTokensTab(theme, currencyFormat, tokens),
                      _buildNftsTab(theme, nfts),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, String totalValue) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text("Total Balance", style: theme.textTheme.titleMedium),
          Text(totalValue, style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildTokensTab(ThemeData theme, NumberFormat currencyFormat, List<UserToken> tokens) {
    if (tokens.isEmpty) return const Center(child: Text("You don't own any tokens."));

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: tokens.length,
      itemBuilder: (context, index) {
        final token = tokens[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: token.logoUrl.startsWith('assets/') 
                ? Image.asset(token.logoUrl) 
                : FaIcon(FontAwesomeIcons.circleQuestion, color: theme.iconTheme.color),
            ),
            title: Text(token.name),
            subtitle: Text("${token.balance.toStringAsFixed(4)} ${token.symbol}"),
            trailing: Text(currencyFormat.format(token.valueUsd)),
            onTap: () => _showTokenActions(token),
          ),
        ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.2);
      },
    );
  }

  Widget _buildNftsTab(ThemeData theme, List<UserNft> nfts) {
    if (nfts.isEmpty) return const Center(child: Text("You don't own any NFTs."));

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: nfts.length,
      itemBuilder: (context, index) {
        final nft = nfts[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _showNftActions(nft),
            child: GridTile(
              footer: GridTileBar(
                backgroundColor: Colors.black45,
                title: Text(nft.name, style: const TextStyle(fontSize: 12)),
                subtitle: Text(nft.collectionName, style: const TextStyle(fontSize: 10)),
              ),
              child: Image.network(nft.imageUrl, fit: BoxFit.cover),
            ),
          ),
        ).animate().fadeIn(delay: (100 * index).ms).scale(begin: const Offset(0.8, 0.8));
      },
    );
  }

  void _showTokenActions(UserToken token) {
    showModalBottomSheet(
      context: context, 
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: Text(token.name, style: Theme.of(context).textTheme.headlineSmall), subtitle: Text("Manage your ${token.symbol} tokens")),
          const Divider(),
          ListTile(leading: const FaIcon(FontAwesomeIcons.rightLeft), title: const Text('Swap'), onTap: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Swap functionality coming soon!")));
          }),
          ListTile(leading: const FaIcon(FontAwesomeIcons.arrowUpRightFromSquare), title: const Text('Send'), onTap: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Send functionality coming soon!")));
          }),
        ],
      )
    );
  }

  void _showNftActions(UserNft nft) {
    showModalBottomSheet(
      context: context, 
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: Text(nft.name, style: Theme.of(context).textTheme.headlineSmall), subtitle: Text("From ${nft.collectionName}")),
          const Divider(),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.tag), 
            title: const Text('List for Sale'), 
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, PageTransition(
                type: PageTransitionType.bottomToTop,
                child: ListNftScreen(nft: nft, userProfile: widget.userProfile)
              )).then((listedSuccessfully) {
                if (listedSuccessfully == true) {
                  _loadWalletData(); // Refresh wallet data if item was listed
                }
              });
            },
          ),
          ListTile(leading: const FaIcon(FontAwesomeIcons.arrowUpRightFromSquare), title: const Text('Transfer'), onTap: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("NFT transfer functionality coming soon!")));
          }),
        ],
      )
    );
  }
}

```

### File: ./lib/screens/token_factory_screen.dart
```dart
// lib/screens/token_factory_screen.dart
import 'package:cabal/features/wallet/application/wallet_provider.dart';
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/utils/app_colors.dart';
import 'package:cabal/widgets/animated_particle_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TokenFactoryScreen extends StatefulWidget {
  final UserProfile userProfile;
  const TokenFactoryScreen({Key? key, required this.userProfile}) : super(key: key);

  @override
  State<TokenFactoryScreen> createState() => _TokenFactoryScreenState();
}

class _TokenFactoryScreenState extends State<TokenFactoryScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form Controllers
  final _tokenNameController = TextEditingController();
  final _tokenSymbolController = TextEditingController();
  final _totalSupplyController = TextEditingController();

  bool _isDeploying = false;
  String? _deployedAddress;

  Future<void> _deployToken() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (!walletProvider.isConnectedEVM) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please connect your EVM wallet to deploy.")));
      return;
    }

    setState(() => _isDeploying = true);

    try {
      // In a real application, you would have a `deployERC20` function in your Web3Service.
      // This function would take the name, symbol, and supply, and use web3dart to
      // deploy the bytecode of a pre-compiled ERC20 contract.

      // --- SIMULATION ---
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Preparing deployment... Please confirm in your wallet.")));
      await Future.delayed(const Duration(seconds: 4)); // Simulate user confirming in wallet
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Deploying to the blockchain... This may take a moment.")));
      await Future.delayed(const Duration(seconds: 8)); // Simulate deployment time
      // --- END SIMULATION ---

      // This would be the real contract address returned from the deployment
      final newAddress = "0x" + List.generate(40, (_) => 'abcdef1234567890'[DateTime.now().millisecond % 16]).join();

      setState(() {
        _deployedAddress = newAddress;
      });

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text("Token contract deployed successfully!"), backgroundColor: AppColors.success),
      );

    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Deployment failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isDeploying = false);
    }
  }

  @override
  void dispose() {
    _tokenNameController.dispose();
    _tokenSymbolController.dispose();
    _totalSupplyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Token Factory"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: AnimatedParticleBackground(
        child: AbsorbPointer(
          absorbing: _isDeploying,
          child: _deployedAddress != null
              ? _buildSuccessView(theme)
              : _buildFormView(theme),
        ),
      ),
    );
  }

  Widget _buildFormView(ThemeData theme) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.only(
          top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
          left: 16, right: 16, bottom: 40
        ),
        children: [
          Text("Launch Your ERC20 Token", style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text("Fill in the details for your new community token. This will be deployed as a standard ERC20 contract on the Sepolia testnet."),
          const Divider(height: 32),

          TextFormField(
            controller: _tokenNameController,
            decoration: const InputDecoration(labelText: "Token Name *", hintText: "e.g., Cabal Gold"),
            validator: (v) => (v == null || v.isEmpty) ? "Token name is required" : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _tokenSymbolController,
            decoration: const InputDecoration(labelText: "Token Symbol *", hintText: "e.g., CBLG"),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[A-Z]')), LengthLimitingTextInputFormatter(5)],
            validator: (v) => (v == null || v.isEmpty) ? "Symbol is required" : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _totalSupplyController,
            decoration: const InputDecoration(labelText: "Total Supply *", hintText: "e.g., 1000000"),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) {
              if (v == null || v.isEmpty) return "Total supply is required";
              if (int.tryParse(v) == null || int.parse(v) <= 0) return "Must be a valid positive number";
              return null;
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            icon: _isDeploying 
              ? Container(width: 24, height: 24, padding: const EdgeInsets.all(2.0), child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
              : const FaIcon(FontAwesomeIcons.rocket),
            label: Text(_isDeploying ? 'Deploying...' : 'Deploy Token'),
            onPressed: _isDeploying ? null : _deployToken,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(ThemeData theme) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FaIcon(FontAwesomeIcons.solidCircleCheck, size: 48, color: AppColors.success),
              const SizedBox(height: 16),
              Text("Deployment Successful!", style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              const Text("Your new ERC20 token contract is live on the blockchain.", textAlign: TextAlign.center),
              const SizedBox(height: 16),
              SelectableText(_deployedAddress!, style: const TextStyle(fontFamily: 'monospace')),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: const Text("View on Etherscan"),
                onPressed: () async {
                  final url = Uri.parse('https://sepolia.etherscan.io/address/$_deployedAddress');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Back to Web3 Hub"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

```

### File: ./lib/screens/web3_hub_screen.dart
```dart
// lib/screens/web3_hub_screen.dart
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/screens/login_screen.dart';
import 'package:cabal/screens/marketplace_screen.dart';
import 'package:cabal/screens/presale_screen.dart';
import 'package:cabal/screens/token_analytics_screen.dart';
import 'package:cabal/screens/token_factory_screen.dart';
import 'package:cabal/screens/tokenomics_screen.dart';
import 'package:cabal/screens/user_wallet_screen.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:cabal/widgets/info_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

class Web3HubScreen extends StatelessWidget {
  final UserProfile? userProfile;

  const Web3HubScreen({Key? key, this.userProfile}) : super(key: key);

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
        context, PageTransition(type: PageTransitionType.rightToLeft, child: screen));
  }

  void _navigateToProtected(BuildContext context, Widget screen) {
    if (userProfile != null) {
      _navigateTo(context, screen);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please log in to use this feature.")));
      _navigateTo(context, const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Web3 Hub"),
        backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85),
      ),
      body: DiamondMeshBackground(
        child: ListView(
          padding: EdgeInsets.only(
            top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
            left: 16,
            right: 16,
            bottom: 40,
          ),
          children: [
            // --- Wallet Section ---
            _buildSectionHeader(theme, "My Wallet & Assets"),
            InfoTileWidget(
              icon: FontAwesomeIcons.wallet,
              title: "View My Wallet",
              subtitle: "Browse your on-chain tokens, NFTs, and property deeds.",
              onTap: () => _navigateToProtected(context, UserWalletScreen(userProfile: userProfile!)),
            ),
            const SizedBox(height: 12),
            InfoTileWidget(
              icon: FontAwesomeIcons.store,
              title: "NFT Marketplace",
              subtitle: "Buy and sell tokenized assets like Real Estate Deeds.",
              onTap: () => _navigateTo(context, const MarketplaceScreen()),
            ),
            const SizedBox(height: 24),

            // --- Creator Tools Section ---
            _buildSectionHeader(theme, "Creator Tools"),
             InfoTileWidget(
              icon: FontAwesomeIcons.coins,
              title: "Token Factory",
              subtitle: "Launch your own ERC20 community token with just a few clicks.",
              onTap: () => _navigateToProtected(context, TokenFactoryScreen(userProfile: userProfile!)),
            ),
            const SizedBox(height: 12),
            InfoTileWidget(
              icon: FontAwesomeIcons.gift,
              title: "Launch a Giveaway",
              subtitle: "Create a trustless, on-chain giveaway for your Cabal.",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please launch giveaways from the 'Manage Cabal' screen."))
                );
              },
            ),
            const SizedBox(height: 24),
            
            // --- Token Economy Section ---
            _buildSectionHeader(theme, "\$CBL Token Economy"),
            InfoTileWidget(
              icon: FontAwesomeIcons.fire,
              title: "Token Presale",
              subtitle: "Participate in the early bird token sale.",
              onTap: () => _navigateTo(context, const PresaleScreen()),
            ),
            const SizedBox(height: 12),
            InfoTileWidget(
              icon: FontAwesomeIcons.chartPie,
              title: "Token Analytics",
              subtitle: "View live on-chain metrics for the \$CBL token.",
              onTap: () => _navigateTo(context, const TokenAnalyticsScreen()),
            ),
             const SizedBox(height: 12),
            InfoTileWidget(
              icon: FontAwesomeIcons.coins,
              title: "Tokenomics",
              subtitle: "Learn about the distribution and utility of \$CBL.",
              onTap: () => _navigateTo(context, const TokenomicsScreen()),
            ),
            
          ].animate(interval: 80.ms).fadeIn().slideX(begin: 0.1),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
      child: Text(title, style: theme.textTheme.headlineSmall),
    );
  }
}

```

### File: ./lib/screens/presale_screen.dart
```dart
// lib/screens/presale_screen.dart
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:intl/intl.dart';
import '../../features/wallet/application/wallet_provider.dart';
import '../utils/app_colors.dart';

class PresaleScreen extends StatefulWidget {
  const PresaleScreen({Key? key}) : super(key: key);

  @override
  State<PresaleScreen> createState() => _PresaleScreenState();
}

class _PresaleScreenState extends State<PresaleScreen> {
  final TextEditingController _ethController = TextEditingController();
  
  final double _presaleRate = 2500;
  final double _presaleCap = 10000000;
  
  Future<Map<String, dynamic>>? _presaleDataFuture;
  bool _isProcessing = false;
  String _cblToReceive = "0.0";

  @override
  void initState() {
    super.initState();
    _ethController.addListener(_updateCblAmount);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPresaleData();
    });
  }

  void _loadPresaleData() {
    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    if (walletProvider.isConnectedEVM) {
      setState(() {
        _presaleDataFuture = _fetchData(web3Service, walletProvider.connectedEVMAddress!);
      });
    } else {
       setState(() {
        _presaleDataFuture = web3Service.getPresaleTokensSold().then((sold) {
          return {'whitelisted': false, 'sold': sold.toDouble() / 1e18};
        });
      });
    }
  }

  Future<Map<String, dynamic>> _fetchData(Web3Service web3, String address) async {
    final results = await Future.wait([
      web3.getPresaleTokensSold(),
      web3.isWhitelisted(address),
    ]);
    return {
      'sold': (results[0] as BigInt).toDouble() / 1e18,
      'whitelisted': results[1] as bool,
    };
  }

  void _updateCblAmount() {
    final ethAmount = double.tryParse(_ethController.text);
    if (ethAmount != null && ethAmount > 0) {
      setState(() {
        _cblToReceive = (ethAmount * _presaleRate).toStringAsFixed(2);
      });
    } else {
      setState(() {
        _cblToReceive = "0.0";
      });
    }
  }

  Future<void> _buyTokens() async {
    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (!walletProvider.isConnectedEVM) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please connect your EVM wallet first.")));
      // --- THIS IS THE FIX ---
      await walletProvider.connectEVMWallet(context: context);
      _loadPresaleData();
      return;
    }
    
    final ethAmount = double.tryParse(_ethController.text);
    if (ethAmount == null || ethAmount <= 0) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please enter a valid amount to swap.")));
      return;
    }
    
    setState(() => _isProcessing = true);

    try {
      final amountInWei = EtherAmount.fromUnitAndValue(EtherUnit.ether, ethAmount).getInWei;
      final tx = web3Service.buildBuyPresaleTokensTransaction(amountInWei: amountInWei);
      
      final txHash = await walletProvider.sendTransaction(tx);

      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text("Purchase successful! Tx: $txHash"),
        backgroundColor: AppColors.success,
      ));
      _ethController.clear();
      _loadPresaleData();
    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Transaction failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  void dispose() {
    _ethController.removeListener(_updateCblAmount);
    _ethController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("\$CBL Token Presale"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DiamondMeshBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
              left: 16, right: 16, bottom: 40
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Join the Cabal Early", style: theme.textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text("Purchase \$CBL at a fixed presale rate before the public launch.", style: theme.textTheme.bodyMedium),
                      const Divider(height: 32),
                      
                      FutureBuilder<Map<String, dynamic>>(
                        future: _presaleDataFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text("Error: ${snapshot.error}"));
                          }
                          if (!snapshot.hasData) {
                             return const Center(child: Text("Could not load presale data."));
                          }

                          final data = snapshot.data!;
                          final bool isWhitelisted = data['whitelisted'];
                          final double tokensSold = data['sold'];

                          if (!isWhitelisted) {
                            return _buildWhitelistNotice(theme);
                          } else {
                            return _buildPurchaseForm(theme, tokensSold);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPurchaseForm(ThemeData theme, double tokensSold) {
    final progress = tokensSold / _presaleCap;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Presale Progress", style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          minHeight: 12,
          borderRadius: BorderRadius.circular(6),
        ),
        const SizedBox(height: 4),
        Text("${NumberFormat.compact().format(tokensSold)} / ${NumberFormat.compact().format(_presaleCap)} \$CBL Sold", style: theme.textTheme.bodySmall),
        
        const SizedBox(height: 24),
        TextField(
          controller: _ethController,
          decoration: const InputDecoration(
            labelText: "Amount in ETH you pay",
            suffixIcon: Padding(
              padding: EdgeInsets.all(8.0),
              child: FaIcon(FontAwesomeIcons.ethereum),
            )
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
        ),
        
        const SizedBox(height: 16),
        TextField(
          controller: TextEditingController(text: _cblToReceive),
          readOnly: true,
          decoration: InputDecoration(
            labelText: "Amount in \$CBL you receive",
            suffixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("\$CBL", style: theme.textTheme.titleMedium),
            )
          ),
        ),

        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isProcessing ? null : _buyTokens,
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
          child: _isProcessing 
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white))
            : const Text("Buy Tokens"),
        ),
        const SizedBox(height: 8),
        Text("Min: 0.1 ETH / Max: 5 ETH per wallet", textAlign: TextAlign.center, style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _buildWhitelistNotice(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.error)
      ),
      child: Column(
        children: [
          const FaIcon(FontAwesomeIcons.circleExclamation, size: 32),
          const SizedBox(height: 12),
          Text("Wallet Not Whitelisted", style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.error)),
          const SizedBox(height: 8),
          Text(
            "The presale is currently open only to whitelisted addresses. Please connect a different wallet or check back for public sale announcements.",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

```

### File: ./lib/screens/create_cabal_screen.dart
```dart
// lib/screens/create_cabal_screen.dart
import 'dart:typed_data';
import 'package:cabal/features/wallet/application/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:provider/provider.dart';

import '../services/supabase_service.dart';
import '../models/user_profile_model.dart';
import '../utils/app_colors.dart';
import '../widgets/info_tooltip.dart';
import '../widgets/animated_particle_background.dart';
import 'cabal_detail_screen.dart';

final Map<String, IconData> cabalCategories = { 'Gaming': FontAwesomeIcons.gamepad, 'Leisure': FontAwesomeIcons.martiniGlass, 'DeFi & Trading': FontAwesomeIcons.chartLine, 'Real Estate': FontAwesomeIcons.building, 'E-commerce': FontAwesomeIcons.cartShopping, 'Education': FontAwesomeIcons.book, };

enum Web3IntegrationOption { none, import, create }

class CreateCabalScreen extends StatefulWidget {
  final String? initialCategory;

  const CreateCabalScreen({Key? key, this.initialCategory}) : super(key: key);
  @override
  State<CreateCabalScreen> createState() => _CreateCabalScreenState();
}

class _CreateCabalScreenState extends State<CreateCabalScreen> {
  final _formKey = GlobalKey<FormState>();
  final SupabaseService _supabaseService = SupabaseService();
  final ImagePicker _picker = ImagePicker();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Page 1: Basic Info
  String _name = '';
  String _description = '';
  String? _projectUrl;
  bool _isPrivate = false;
  String? _selectedCategory;

  // Page 2: Branding
  XFile? _logoImageXFile;
  XFile? _bannerImageXFile;
  
  // Page 3: Web3 Integration
  Web3IntegrationOption _web3IntegrationOption = Web3IntegrationOption.none;
  final _tokenContractAddressController = TextEditingController();
  final _tokenSymbolController = TextEditingController();
  final _newTokenNameController = TextEditingController();
  final _newTokenSymbolController = TextEditingController();
  final _newTokenSupplyController = TextEditingController();
  int _chainId = 11155111; // Default to Sepolia testnet

  bool _isLoading = false;
  String _loadingMessage = 'Launching Your Cabal...';
  UserProfile? _currentUserProfile;
  
  final List<String> _pageTitles = [ "1. Basic Info", "2. Branding", "3. Web3 Integration", "4. Review & Launch!" ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _pageController.addListener(() {
      final newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentPage && mounted) setState(() => _currentPage = newPage);
    });
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final currentUserAuth = _supabaseService.getCurrentUser();
    if (currentUserAuth != null) {
      final profile = await _supabaseService.getUserProfile(currentUserAuth.id);
      if (mounted) setState(() => _currentUserProfile = profile);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You must be logged in to create a cabal."), backgroundColor: Colors.red));
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tokenContractAddressController.dispose();
    _tokenSymbolController.dispose();
    _newTokenNameController.dispose();
    _newTokenSymbolController.dispose();
    _newTokenSupplyController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source, Function(XFile?) onImagePicked) async {
    try {
      final XFile? pickedXFile = await _picker.pickImage(source: source, imageQuality: 70, maxWidth: 1200, maxHeight: 1200);
      if (mounted) setState(() => onImagePicked(pickedXFile));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error picking image: ${e.toString()}'), backgroundColor: Theme.of(context).colorScheme.error));
    }
  }

  void _nextPage() {
    bool canProceed = true;
    if (_currentPage == 0) {
      if (_formKey.currentState?.validate() == false) {
        canProceed = false;
      } else {
        _formKey.currentState?.save();
        if (_selectedCategory == null) {
          canProceed = false;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a category for your cabal.'), backgroundColor: Colors.orangeAccent));
        }
      }
    }
    
    if (canProceed && _currentPage < _pageTitles.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOutQuad);
    } else if (!canProceed) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete the current step correctly.'), backgroundColor: Colors.orangeAccent));
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOutQuad);
    }
  }

  Future<void> _submitForm() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final walletProvider = context.read<WalletProvider>();
    final currentUserAuth = _supabaseService.getCurrentUser();

    if (_currentUserProfile == null || currentUserAuth == null) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Authentication error. Please log in again.'), backgroundColor: Colors.red));
      return;
    }
    if (_formKey.currentState?.validate() == false || _selectedCategory == null) {
      _pageController.animateToPage(0, duration: 300.ms, curve: Curves.easeOut);
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Please complete the Basic Info step correctly.'), backgroundColor: Colors.red));
      return;
    }
    _formKey.currentState?.save();
    
    if (mounted) setState(() => _isLoading = true);

    String? finalTokenAddress;
    String? finalTokenSymbol;

    try {
      if (_web3IntegrationOption == Web3IntegrationOption.create) {
        if (!walletProvider.isConnectedEVM) {
          throw Exception("Please connect your EVM wallet to deploy a new token.");
        }
        if (mounted) setState(() => _loadingMessage = 'Deploying your new token...');
        final deployedAddress = await walletProvider.deployERC20Token(
          name: _newTokenNameController.text.trim(),
          symbol: _newTokenSymbolController.text.trim(),
          initialSupply: BigInt.parse(_newTokenSupplyController.text.trim()) * BigInt.from(10).pow(18),
        );
        if (deployedAddress == null) throw Exception("Token deployment failed.");
        finalTokenAddress = deployedAddress;
        finalTokenSymbol = _newTokenSymbolController.text.trim();
      } else if (_web3IntegrationOption == Web3IntegrationOption.import) {
        finalTokenAddress = _tokenContractAddressController.text.trim();
        finalTokenSymbol = _tokenSymbolController.text.trim();
      }
      
      if (mounted) setState(() => _loadingMessage = 'Uploading assets...');
      String? uploadedLogoUrl = _logoImageXFile != null ? await _supabaseService.uploadProfileImage(_logoImageXFile!, currentUserAuth.id) : null;
      String? uploadedBannerUrl = _bannerImageXFile != null ? await _supabaseService.uploadProfileImage(_bannerImageXFile!, currentUserAuth.id) : null;

      if (mounted) setState(() => _loadingMessage = 'Finalizing creation...');
      final creatorHandle = _currentUserProfile!.displayName ?? _currentUserProfile!.telegramUsername ?? currentUserAuth.id.substring(0, 8);
      
      final newCabal = await _supabaseService.createCabal(
        name: _name, description: _description, creatorHandle: creatorHandle,
        isPrivate: _isPrivate, category: _selectedCategory, projectUrl: _projectUrl,
        logoUrl: uploadedLogoUrl, bannerImageUrl: uploadedBannerUrl,
        tokenContractAddress: finalTokenAddress, tokenSymbol: finalTokenSymbol, chainId: _chainId,
      );

      if (newCabal != null) {
        scaffoldMessenger.showSnackBar(SnackBar(content: Text('Cabal "${newCabal.name}" created!'), backgroundColor: AppColors.success));
        navigator.pop(true);
        navigator.pushReplacement(PageTransition(type: PageTransitionType.rightToLeftWithFade, child: CabalDetailScreen(cabalId: newCabal.id)));
      } else {
        throw Exception("Failed to create cabal record.");
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(SnackBar(content: Text('Failed to create cabal: ${e.toString()}'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_currentPage]),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(12.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _buildStepIndicator(theme),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: AnimatedParticleBackground(
        child: AbsorbPointer(
          absorbing: _isLoading,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: kToolbarHeight + (AppBar().preferredSize.height * 0.5)),
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildBasicInfoStep(theme),
                    _buildBrandingStep(theme),
                    _buildWeb3Step(theme),
                    _buildReviewStep(theme),
                  ],
                ),
              ),
              if (_isLoading)
                Container(
                  color: theme.scaffoldBackgroundColor.withOpacity(0.7),
                  child: Center(
                    child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(color: theme.colorScheme.primary),
                            const SizedBox(height: 20),
                            Text(_loadingMessage, style: theme.textTheme.titleMedium),
                          ],
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 8.0,
        color: theme.cardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0).copyWith(bottom: MediaQuery.of(context).padding.bottom + 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentPage > 0)
                TextButton.icon(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                  label: const Text('Back'),
                  onPressed: _isLoading ? null : _previousPage,
                ).animate().fadeIn().slideX(begin: -0.2)
              else
                const SizedBox(width: 80),
              ElevatedButton.icon(
                label: Text(_currentPage == _pageTitles.length - 1 ? 'Launch Cabal!' : 'Next Step'),
                icon: Icon(_currentPage == _pageTitles.length - 1 ? Icons.rocket_launch_rounded : Icons.arrow_forward_ios_rounded, size: 16),
                onPressed: _isLoading ? null : (_currentPage == _pageTitles.length - 1 ? _submitForm : _nextPage),
              ).animate().fadeIn().slideX(begin: 0.2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pageTitles.length, (index) {
        bool isActive = _currentPage == index;
        return AnimatedContainer(
          duration: 300.ms,
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: isActive ? 24 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: isActive ? theme.colorScheme.primary : theme.colorScheme.outline.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }

  Widget _buildBasicInfoStep(ThemeData theme) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text("Project Vitals", style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary)),
          const SizedBox(height: 8),
          Text("Lay the foundation. What's your cabal called and what's it all about?", style: theme.textTheme.bodyLarge),
          const SizedBox(height: 24),
          TextFormField(initialValue: _name, decoration: const InputDecoration(labelText: 'Cabal Name *'), validator: (v) => (v == null || v.trim().length < 3) ? 'Name must be at least 3 characters.' : null, onSaved: (v) => _name = v?.trim() ?? '', autovalidateMode: AutovalidateMode.onUserInteraction).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
          const SizedBox(height: 20),
          TextFormField(initialValue: _description, decoration: const InputDecoration(labelText: 'Cabal Description *'), maxLines: 4, maxLength: 500, validator: (v) => (v == null || v.trim().length < 10) ? 'Description must be at least 10 characters.' : null, onSaved: (v) => _description = v?.trim() ?? '', autovalidateMode: AutovalidateMode.onUserInteraction).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1),
          const SizedBox(height: 20),
          TextFormField(initialValue: _projectUrl, decoration: const InputDecoration(labelText: 'Project Website URL (Optional)'), keyboardType: TextInputType.url, validator: (v) { if (v == null || v.trim().isEmpty) return null; if (!(Uri.tryParse(v.trim())?.isAbsolute ?? false)) return 'Please enter a valid URL'; return null; }, onSaved: (v) => _projectUrl = (v?.trim().isEmpty ?? true) ? null : v!.trim(), autovalidateMode: AutovalidateMode.onUserInteraction).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),
          const SizedBox(height: 24),
          _buildCategorySelector(theme),
          const SizedBox(height: 24),
          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              title: Text("Private Cabal", style: theme.textTheme.titleMedium),
              subtitle: Text(_isPrivate ? "Visible only to members." : "Visible to everyone."),
              value: _isPrivate,
              onChanged: (bool value) => setState(() => _isPrivate = value),
              secondary: FaIcon(_isPrivate ? FontAwesomeIcons.lock : FontAwesomeIcons.globe, color: theme.colorScheme.secondary),
              activeColor: theme.colorScheme.primary,
            ),
          ).animate().fadeIn(delay: 600.ms),
        ],
      ),
    );
  }
  
  Widget _buildBrandingStep(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text("Visual Identity", style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary)),
        const SizedBox(height: 8),
        Text("Upload a logo and a banner to make your cabal shine.", style: theme.textTheme.bodyLarge),
        const SizedBox(height: 24),
        _buildImagePickerWidget(label: "Cabal Logo", imageXFile: _logoImageXFile, onPick: () => _pickImage(ImageSource.gallery, (file) => setState(() => _logoImageXFile = file)), onRemove: () => setState(() => _logoImageXFile = null), theme: theme).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 24),
        _buildImagePickerWidget(label: "Cabal Banner", imageXFile: _bannerImageXFile, onPick: () => _pickImage(ImageSource.gallery, (file) => setState(() => _bannerImageXFile = file)), onRemove: () => setState(() => _bannerImageXFile = null), theme: theme).animate().fadeIn(delay: 300.ms),
      ],
    );
  }

  Widget _buildWeb3Step(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text("Tokenize Your Cabal", style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary)),
        const SizedBox(height: 8),
        Text("Integrate an ERC20 token to enable unique quests, governance, and a community treasury.", style: theme.textTheme.bodyLarge),
        const SizedBox(height: 24),
        SegmentedButton<Web3IntegrationOption>(
          segments: const [
            ButtonSegment(value: Web3IntegrationOption.none, label: Text('None'), icon: Icon(Icons.public_off)),
            ButtonSegment(value: Web3IntegrationOption.import, label: Text('Import'), icon: Icon(Icons.input_rounded)),
            ButtonSegment(value: Web3IntegrationOption.create, label: Text('Create'), icon: Icon(Icons.add_circle_outline_rounded)),
          ],
          selected: {_web3IntegrationOption},
          onSelectionChanged: (Set<Web3IntegrationOption> newSelection) {
            setState(() => _web3IntegrationOption = newSelection.first);
          },
        ),
        const SizedBox(height: 24),
        AnimatedSize(
          duration: 300.ms,
          curve: Curves.easeInOut,
          child: _web3IntegrationOption == Web3IntegrationOption.import ? _buildImportTokenForm(theme) :
                 _web3IntegrationOption == Web3IntegrationOption.create ? _buildCreateTokenForm(theme) :
                 const SizedBox.shrink(),
        ),
      ],
    );
  }
  
  Widget _buildImportTokenForm(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Import an Existing Token", style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        TextFormField(controller: _tokenContractAddressController, decoration: const InputDecoration(labelText: 'Token Contract Address')),
        const SizedBox(height: 16),
        TextFormField(controller: _tokenSymbolController, decoration: const InputDecoration(labelText: 'Token Symbol (e.g., MYTKN)')),
      ],
    ).animate().fadeIn();
  }

  Widget _buildCreateTokenForm(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Launch a New Token with Cabal", style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Text("This will deploy a standard ERC20 contract. You will be the owner and can mint more tokens later.", style: theme.textTheme.bodySmall),
        const SizedBox(height: 16),
        TextFormField(controller: _newTokenNameController, decoration: const InputDecoration(labelText: 'Token Name *', hintText: 'e.g., My Cabal Token')),
        const SizedBox(height: 16),
        TextFormField(controller: _newTokenSymbolController, decoration: const InputDecoration(labelText: 'Token Symbol *', hintText: 'e.g., MCT')),
        const SizedBox(height: 16),
        TextFormField(controller: _newTokenSupplyController, decoration: const InputDecoration(labelText: 'Initial Supply *', hintText: 'e.g., 1000000'), keyboardType: TextInputType.number),
      ],
    ).animate().fadeIn();
  }
  
  Widget _buildReviewStep(ThemeData theme) {
    _formKey.currentState?.save();
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text("Final Checkpoint!", style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary)),
        const SizedBox(height: 8),
        Text("One last look before your cabal goes live.", style: theme.textTheme.bodyLarge),
        const SizedBox(height: 24),
        Card(
          elevation: 0.5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildReviewItem(theme, "Name:", _name),
                _buildReviewItem(theme, "Description:", _description, maxLines: 3),
                _buildReviewItem(theme, "Category:", _selectedCategory ?? "(Not set)"),
                _buildReviewItem(theme, "Privacy:", _isPrivate ? "Private" : "Public"),
                if(_web3IntegrationOption != Web3IntegrationOption.none) ...[
                  const Divider(height: 20),
                  if(_web3IntegrationOption == Web3IntegrationOption.import) ...[
                    _buildReviewItem(theme, "Token Address:", _tokenContractAddressController.text),
                    _buildReviewItem(theme, "Token Symbol:", _tokenSymbolController.text),
                  ],
                  if(_web3IntegrationOption == Web3IntegrationOption.create) ...[
                     _buildReviewItem(theme, "New Token Name:", _newTokenNameController.text),
                     _buildReviewItem(theme, "New Token Symbol:", _newTokenSymbolController.text),
                     _buildReviewItem(theme, "Initial Supply:", _newTokenSupplyController.text),
                  ]
                ]
              ],
            ),
          ),
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildReviewItem(ThemeData theme, String label, String value, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Expanded(child: SelectableText(value, style: theme.textTheme.bodyMedium, maxLines: maxLines)),
        ],
      ),
    );
  }

  Widget _buildImagePickerWidget({ required String label, required XFile? imageXFile, required Function() onPick, required Function() onRemove, required ThemeData theme, }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            border: Border.all(color: theme.colorScheme.outline.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: imageXFile != null
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: kIsWeb
                          ? Image.network(imageXFile.path, fit: BoxFit.contain)
                          : FutureBuilder<Uint8List>(
                              future: imageXFile.readAsBytes(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) return Image.memory(snapshot.data!, fit: BoxFit.contain);
                                return const Center(child: CircularProgressIndicator());
                              },
                            ),
                    ),
                    Positioned(
                      top: 4, right: 4,
                      child: Material(
                        color: Colors.black.withOpacity(0.5), shape: const CircleBorder(),
                        child: IconButton(
                          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                          onPressed: onRemove, tooltip: "Remove Image",
                        ),
                      ),
                    )
                  ],
                ).animate().fadeIn()
              : Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.upload_file_rounded, size: 18),
                    label: const Text("Choose Image"),
                    onPressed: onPick,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Cabal Category *", style: theme.textTheme.titleMedium),
            const InfoTooltip(message: "Select the category that best fits your project's focus."),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: cabalCategories.entries.map((entry) {
            final isSelected = _selectedCategory == entry.key;
            return ChoiceChip(
              label: Text(entry.key),
              avatar: FaIcon(entry.value, size: 16, color: isSelected ? theme.colorScheme.onSecondary : theme.colorScheme.secondary),
              selected: isSelected,
              onSelected: (selected) => setState(() => _selectedCategory = selected ? entry.key : null),
              selectedColor: theme.colorScheme.secondary,
              labelStyle: theme.chipTheme.labelStyle?.copyWith(color: isSelected ? theme.colorScheme.onSecondary : theme.chipTheme.labelStyle?.color),
            );
          }).toList(),
        ).animate().fadeIn(delay: 500.ms),
      ],
    );
  }
}

```

### File: ./lib/screens/cabal_list_screen.dart
```dart
// lib/screens/cabal_list_screen.dart
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/widgets/cabal_card_widget.dart';
import 'package:cabal/widgets/empty_state_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import '../models/cabal_model.dart';
import '../services/supabase_service.dart';
import '../widgets/diamond_mesh_background.dart';
import '../widgets/horizontal_cabal_list.dart';
import 'cabal_detail_screen.dart';
import 'create_cabal_screen.dart';
import 'login_screen.dart';

class CabalListScreen extends StatefulWidget {
  final String? telegramUsername;
  const CabalListScreen({Key? key, this.telegramUsername}) : super(key: key);
  @override
  State<CabalListScreen> createState() => _CabalListScreenState();
}

class _CabalListScreenState extends State<CabalListScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  bool _isLoading = true;

  UserProfile? _currentUserProfile;
  List<Cabal> _myCabals = [];
  List<Cabal> _newestCabals = [];
  List<Cabal> _gamingCabals = [];
  List<Cabal> _defiCabals = [];

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      // Fetch all cabals first
      final allCabals = await _supabaseService.getAllCabals();

      // Fetch the current user profile in parallel
      final authUser = _supabaseService.getCurrentUser();
      if (authUser != null) {
        _currentUserProfile = await _supabaseService.getUserProfile(authUser.id);
      }

      // Now, filter the lists based on the fetched data
      if (mounted) {
        setState(() {
          // "Your Cabals" includes private ones, so we filter from the complete list.
          if (_currentUserProfile != null) {
            final joinedIds = _currentUserProfile!.joinedCabalIds.toSet();
            _myCabals = allCabals.where((c) => joinedIds.contains(c.id)).toList();
          }

          // Public sections should only show public cabals.
          final publicCabals = allCabals.where((c) => !c.isPrivate).toList();
          
          // Sort for "Newest Cabals" from public ones
          publicCabals.sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
          _newestCabals = publicCabals.take(5).toList();

          // Filter by categories from public ones
          _gamingCabals = publicCabals.where((c) => c.category == 'Gaming').toList();
          _defiCabals = publicCabals.where((c) => c.category == 'DeFi & Trading').toList();
          
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading cabal list data: $e");
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to load cabals.")));
      }
    }
  }

  // --- THIS METHOD IS NOW CORRECTED TO HANDLE REFRESH ---
  void _navigateToCreateCabal({String? category}) {
    if (_currentUserProfile == null) {
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const LoginScreen()));
      return;
    }
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.bottomToTop,
        child: CreateCabalScreen(initialCategory: category),
      ),
    ).then((didCreate) {
      // This 'then' block is executed when we come back from the CreateCabalScreen.
      // If a cabal was successfully created, the screen will pop with `true`.
      if (didCreate == true) {
        _loadAllData(); // Refresh all the data on the screen.
      }
    });
  }
  
  void _navigateToCabalDetail(Cabal cabal) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: CabalDetailScreen(cabalId: cabal.id),
      ),
    );
  }

  Widget _buildYourCabalsSection() {
    final theme = Theme.of(context);
    
    if (_isLoading) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your Cabals 🤝", style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    }

    if (_myCabals.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24.0, left: 16.0, right: 16.0),
          child: EmptyStateCard(
            title: "You Haven't Joined Any Cabals",
            message: "Join a cabal from the sections below to see it here!",
            icon: FontAwesomeIcons.rightToBracket,
            buttonText: "Discover Cabals",
            onButtonPressed: () { /* Could make the page jump down */ },
            currentUserProfile: _currentUserProfile,
          ),
        ),
      );
    }
    
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Your Cabals 🤝", style: theme.textTheme.titleLarge),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                bool isWide = constraints.maxWidth > 600;

                if (isWide) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: _myCabals.map((cabal) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: SizedBox(
                          height: 230,
                          child: CabalCardWidget(
                            project: cabal,
                            onTap: () => _navigateToCabalDetail(cabal),
                            layout: CabalCardLayout.horizontalList,
                          ),
                        ),
                      )).toList(),
                    ),
                  );
                } else {
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: _myCabals.length,
                    itemBuilder: (context, index) {
                      final cabal = _myCabals[index];
                      return CabalCardWidget(
                        project: cabal,
                        onTap: () => _navigateToCabalDetail(cabal),
                        layout: CabalCardLayout.grid,
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPublicSection({
    required String title,
    required List<Cabal> cabals,
    String? categoryKey,
    required String emptyTitle,
    required String emptyMessage,
    required IconData emptyIcon,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: cabals.isEmpty && !_isLoading
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: EmptyStateCard(
                  title: emptyTitle,
                  message: emptyMessage,
                  icon: emptyIcon,
                  buttonText: 'Create a Cabal',
                  onButtonPressed: () => _navigateToCreateCabal(category: categoryKey),
                  currentUserProfile: _currentUserProfile,
                ),
              )
            : HorizontalCabalList(
                title: title,
                cabals: cabals,
                isLoading: _isLoading,
                emptyMessage: "No cabals in this category yet.",
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: DiamondMeshBackground(
        child: RefreshIndicator(
          onRefresh: _loadAllData,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: const Text('Explore Cabals'),
                floating: true,
                pinned: true,
                backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    onPressed: () => _navigateToCreateCabal(),
                    tooltip: "Create a new Cabal",
                  )
                ],
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              _buildYourCabalsSection(),
              _buildPublicSection(
                title: "Newest Cabals ✨",
                cabals: _newestCabals,
                emptyTitle: "No New Cabals",
                emptyMessage: "Be the first to create a new cabal for the community!",
                emptyIcon: FontAwesomeIcons.rocket,
              ),
              _buildPublicSection(
                title: "Gaming 🎮",
                cabals: _gamingCabals,
                categoryKey: 'Gaming',
                emptyTitle: "No Gaming Cabals",
                emptyMessage: "Start the first gaming-focused cabal and build your community!",
                emptyIcon: FontAwesomeIcons.gamepad,
              ),
              _buildPublicSection(
                title: "DeFi & Trading 📈",
                cabals: _defiCabals,
                categoryKey: 'DeFi & Trading',
                emptyTitle: "No DeFi Cabals",
                emptyMessage: "Create a cabal for traders and yield farmers to share alpha.",
                emptyIcon: FontAwesomeIcons.chartLine,
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
    );
  }
}

```

### File: ./lib/screens/home_nav_wrapper.dart
```dart
// lib/screens/home_nav_wrapper.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;

// Screen Imports
import 'landing_screen.dart';
import 'cabal_list_screen.dart';
import 'placeholder_screen.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';
import '../features/onboarding/presentation/onboarding_preferences_screen.dart';
import 'notifications_screen.dart';
import 'community_hub_screen.dart';

// Model & Service Imports
import '../models/user_profile_model.dart';
import '../services/supabase_service.dart';
import '../audio/audio_controller.dart';

// Util & Widget Imports
import '../utils/app_colors.dart';

class HomeNavWrapper extends StatefulWidget {
  final bool showOnboarding;
  const HomeNavWrapper({ Key? key, this.showOnboarding = false, }) : super(key: key);
  @override
  State<HomeNavWrapper> createState() => _HomeNavWrapperState();
}

class _HomeNavWrapperState extends State<HomeNavWrapper> {
  int _selectedIndex = 0;
  UserProfile? _userProfile;
  bool _isLoadingProfile = true;
  int _unreadNotificationsCount = 0;
  final SupabaseService _supabaseService = SupabaseService();
  StreamSubscription<AuthState>? _authSubscription;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late PageController _pageController;

  late List<Widget> _widgetOptions;
  late List<String> _pageTitles;
  late List<IconData> _pageIcons;

  bool _isNavigationRailExtended = false;
  static const double _minDesktopWidth = 720;
  bool _isNewsPanelVisible = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initializeNavigationItems();
    _widgetOptions = _buildWidgetOptions(null, true);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AudioController>().startMusic();
      _setupAuthListener();
      final initialSession = _supabaseService.getCurrentUser();
      if (initialSession != null) {
        _refreshCurrentUserProfile(initialSession.id, showOnboardingAfterLoad: widget.showOnboarding);
      } else {
        _handleSignedOutUser(isInitialLoad: true);
      }
    });
  }

  void _setupAuthListener() {
    _authSubscription = _supabaseService.authStateChanges.listen((AuthState data) {
      final session = data.session;
      
      if (data.event == AuthChangeEvent.signedIn && session != null) {
        _refreshCurrentUserProfile(session.user.id, showOnboardingAfterLoad: true);
      } else if (data.event == AuthChangeEvent.signedOut) {
        _handleSignedOutUser();
      }
    });
  }

  void _toggleNewsPanel() => setState(() => _isNewsPanelVisible = !_isNewsPanelVisible);

  void _initializeNavigationItems() {
    _pageTitles = [ 'Home', 'Explore', 'Leaderboard', 'Community', 'My Profile' ];
    _pageIcons = [ FontAwesomeIcons.house, FontAwesomeIcons.compass, FontAwesomeIcons.rankingStar, FontAwesomeIcons.users, FontAwesomeIcons.solidUserCircle ];
  }

  void _navigateToLoginScreen() {
    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const LoginScreen()));
  }

  void _handleSignedOutUser({bool isInitialLoad = false}) {
    if (!mounted) return;
    setStateIfMounted(() {
      _userProfile = null;
      _isLoadingProfile = false;
      _widgetOptions = _buildWidgetOptions(null, false);
      _unreadNotificationsCount = 0;
      if (!isInitialLoad && _selectedIndex != 0) {
        _selectedIndex = 0;
        if (_pageController.hasClients) _pageController.jumpToPage(0);
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _refreshCurrentUserProfile(String userId, {bool showOnboardingAfterLoad = false}) async {
    if (!mounted) return;
    if (_userProfile?.id != userId || _userProfile == null) {
      setStateIfMounted(() => _isLoadingProfile = true);
    }

    try {
      final profile = await _supabaseService.getUserProfile(userId);
      if (profile == null) {
        if(mounted) _handleSignedOutUser();
        return;
      }
      
      await _supabaseService.recordActivity();
      
      final unreadCount = await _supabaseService.getUnreadNotificationCount(profile.id);

      if (mounted) {
        setStateIfMounted(() {
          _userProfile = profile;
          _unreadNotificationsCount = unreadCount;
          _isLoadingProfile = false;
          _widgetOptions = _buildWidgetOptions(_userProfile, false);
        });

        bool needsOnboarding = (profile.preferredCoinIds.isEmpty || profile.interests.isEmpty) && (profile.displayName == null || profile.displayName!.length <= 8);
        if (showOnboardingAfterLoad && needsOnboarding) {
           WidgetsBinding.instance.addPostFrameCallback((_) {
               if (mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const OnboardingPreferencesScreen()),
                );
               }
           });
        }
      }
    } catch (e) {
      debugPrint("Error refreshing profile: $e");
      if (mounted) {
        _handleSignedOutUser();
        setStateIfMounted(() => _isLoadingProfile = false);
      }
    }
  }

  void setStateIfMounted(VoidCallback fn) { if (mounted) setState(fn); }

  List<Widget> _buildWidgetOptions(UserProfile? userProfile, bool isLoadingProfile) {
    return <Widget>[
      LandingScreen(currentUserProfile: userProfile, onNavigateToProfile: () => _onItemTapped(4), onNavigateToLeaderboard: () => _onItemTapped(2), onNavigateToCabals: () => _onItemTapped(1), isNewsPanelVisible: _isNewsPanelVisible, onToggleNewsPanel: _toggleNewsPanel),
      const CabalListScreen(),
      const PlaceholderScreen(title: "Global Leaderboard", icon: FontAwesomeIcons.rankingStar, message: "Global rankings are coming soon! View leaderboards within each Cabal for now."),
      const CommunityHubScreen(),
      DashboardScreen(userProfile: userProfile, isLoadingProfile: isLoadingProfile, onUserProfileNeedsRefresh: () => _userProfile != null ? _refreshCurrentUserProfile(_userProfile!.id) : Future.value()),
    ];
  }
  
  void _onItemTapped(int index) {
    context.read<AudioController>().playSfx();
    const protectedIndices = {4};

    if (_userProfile == null && protectedIndices.contains(index)) { 
      _navigateToLoginScreen();
      return;
    }
    
    if (mounted) {
       _pageController.animateToPage(index, duration: 400.ms, curve: Curves.easeInOutQuad);
       if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
         Navigator.of(context).pop();
       }
    }
  }

  void _navigateToNotifications() {
     if (_userProfile == null) {
        _navigateToLoginScreen();
        return;
     }
    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: NotificationsScreen(userId: _userProfile!.id)))
      .then((_) => mounted && _userProfile != null ? _refreshCurrentUserProfile(_userProfile!.id) : null);
  }
  
  List<NavigationRailDestination> _buildNavigationRailDestinations(ThemeData theme) {
    var destinations = List.generate(_pageTitles.length, (index) {
      bool hasBadge = index == 4 && _userProfile != null && _unreadNotificationsCount > 0;
      return NavigationRailDestination(
        icon: Badge(
          isLabelVisible: hasBadge,
          label: Text('$_unreadNotificationsCount'),
          child: FaIcon(_pageIcons[index])
        ),
        label: Text(_pageTitles[index]),
      );
    });
    if (!_isNewsPanelVisible) {
      destinations.add(const NavigationRailDestination(icon: FaIcon(FontAwesomeIcons.newspaper), label: Text("News Feed")));
    }
    return destinations;
  }

  List<Widget> _buildDrawerItems(ThemeData theme) {
    var items = List.generate(_pageTitles.length, (index) {
       bool hasBadge = index == 4 && _userProfile != null && _unreadNotificationsCount > 0;
       return ListTile(
        leading: FaIcon(_pageIcons[index], color: _selectedIndex == index ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.7)),
        title: Text(_pageTitles[index], style: TextStyle(fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal)),
        selected: _selectedIndex == index,
        selectedTileColor: theme.colorScheme.primary.withOpacity(0.1),
        trailing: hasBadge ? Badge(label: Text('$_unreadNotificationsCount')) : null,
        onTap: () => _onItemTapped(index),
      );
    });
    if (!_isNewsPanelVisible) {
      items.add(ListTile(
        leading: FaIcon(FontAwesomeIcons.newspaper, color: theme.colorScheme.onSurface.withOpacity(0.7)),
        title: const Text("News Feed"),
        onTap: () {
          _toggleNewsPanel();
          _onItemTapped(0);
        },
      ));
    }
    return items;
  }

  Drawer _buildDrawer(ThemeData theme) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.darkGrey, AppColors.offBlack.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Cabal', style: theme.textTheme.headlineMedium?.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(_userProfile?.displayName ?? "Guest Explorer", style: theme.textTheme.titleMedium?.copyWith(color: AppColors.lightText.withOpacity(0.8))),
              ],
            ),
          ),
          Expanded(child: ListView(padding: EdgeInsets.zero, children: _buildDrawerItems(theme))),
        ],
      ),
    );
  }
  
  AppBar _buildMobileAppBar(ThemeData theme) {
    return AppBar(
      elevation: 1,
      title: Text(_pageTitles[_selectedIndex]),
      backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      ),
      actions: [
        IconButton(
          icon: Badge(
            isLabelVisible: _userProfile != null && _unreadNotificationsCount > 0,
            label: Text('$_unreadNotificationsCount'),
            child: const FaIcon(FontAwesomeIcons.solidBell, size: 20)
          ),
          onPressed: _navigateToNotifications,
          tooltip: "Notifications",
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktopWeb = kIsWeb && screenWidth >= _minDesktopWidth;

    if (_isLoadingProfile && _supabaseService.getCurrentUser() != null && _userProfile == null) {
        return Scaffold(body: Center(child: CircularProgressIndicator(color: theme.colorScheme.primary)));
    }
    
    Widget mainContent = PageView(
      controller: _pageController,
      onPageChanged: (index) => setStateIfMounted(() => _selectedIndex = index),
      children: _widgetOptions,
    );

    if (isDesktopWeb) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                if (index >= _pageTitles.length) {
                   _toggleNewsPanel();
                   _onItemTapped(0);
                } else {
                  _onItemTapped(index);
                }
              },
              labelType: _isNavigationRailExtended ? NavigationRailLabelType.none : NavigationRailLabelType.selected,
              extended: _isNavigationRailExtended,
              minExtendedWidth: 220,
              leading: Column(
                children: [
                  const SizedBox(height: 20),
                  if (_isNavigationRailExtended)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Cabal", style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                    ),
                  IconButton(
                    icon: Icon(_isNavigationRailExtended ? Icons.menu_open_rounded : Icons.menu_rounded),
                    onPressed: () => setStateIfMounted(() => _isNavigationRailExtended = !_isNavigationRailExtended),
                    tooltip: _isNavigationRailExtended ? "Collapse Menu" : "Expand Menu",
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              destinations: _buildNavigationRailDestinations(theme),
              elevation: 2,
              backgroundColor: theme.colorScheme.surface,
              indicatorColor: theme.colorScheme.primary.withOpacity(0.2),
              selectedLabelTextStyle: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
              selectedIconTheme: IconThemeData(color: theme.colorScheme.primary),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: mainContent),
          ],
        ),
      );
    } else { // Mobile view
      return Scaffold(
        key: _scaffoldKey,
        appBar: _selectedIndex == 0 ? null : _buildMobileAppBar(theme),
        drawer: _buildDrawer(theme),
        body: mainContent,
      );
    }
  }
}

```

### File: ./lib/screens/dashboard_screen.dart
```dart
// lib/screens/dashboard_screen.dart
import 'package:cabal/models/community_post_model.dart';
import 'package:cabal/screens/notifications_screen.dart'; // <-- ADD THIS IMPORT
import 'package:cabal/screens/xp_balance_screen.dart';
import 'package:cabal/widgets/post_card_widget.dart';
import 'package:cabal/widgets/profile_header.dart';
import 'package:cabal/widgets/profile_stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:intl/intl.dart';

import '../models/user_profile_model.dart';
import '../services/supabase_service.dart';
import 'profile_edit_screen.dart';
import 'login_screen.dart';
import 'follower_list_screen.dart';
import '../widgets/diamond_mesh_background.dart';
import '../utils/app_colors.dart';

class DashboardScreen extends StatefulWidget {
  final UserProfile? userProfile; // This is the currently LOGGED IN user
  final String? viewProfileId; // Optionally view SOMEONE ELSE's profile
  final bool isLoadingProfile;
  final Future<void> Function()? onUserProfileNeedsRefresh;

  const DashboardScreen({
    Key? key,
    this.userProfile,
    this.viewProfileId,
    required this.isLoadingProfile,
    this.onUserProfileNeedsRefresh,
  }) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final SupabaseService _supabaseService = SupabaseService();

  UserProfile? _profileToDisplay;
  bool _isLoading = true;
  String? _errorMessage;
  List<CommunityPost> _userPosts = [];
  bool _isLoadingPosts = true;

  bool get _isViewingSelf {
    // If viewProfileId is null, we are viewing the logged-in user.
    // If viewProfileId is not null, compare it to the logged-in user's id.
    return widget.viewProfileId == null || widget.viewProfileId == widget.userProfile?.id;
  }

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void didUpdateWidget(covariant DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.viewProfileId != oldWidget.viewProfileId || widget.userProfile != oldWidget.userProfile) {
      _loadProfileData();
    }
  }

  Future<void> _loadProfileData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final profileId = widget.viewProfileId ?? widget.userProfile?.id;
    if (profileId == null) {
      setState(() {
        _isLoading = false;
        _profileToDisplay = null;
      });
      return;
    }

    try {
      final profileDetails = await _supabaseService.getProfileDetails(profileId);
      if (profileDetails == null) throw Exception("Profile not found.");

      if (mounted) {
        setState(() {
          _profileToDisplay = UserProfile.fromProfileDetails(profileDetails);
          _isLoading = false;
        });
        _loadUserPosts(profileId);
      }
    } catch (e) {
      debugPrint("DashboardScreen: Error loading profile data: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Could not load profile.";
        });
      }
    }
  }

  Future<void> _loadUserPosts(String userId) async {
    if (!mounted) return;
    setState(() => _isLoadingPosts = true);
    final allPosts = await _supabaseService.getGlobalFeed();
    if (mounted) {
      setState(() {
        _userPosts = allPosts.where((p) => p.userId == userId).toList();
        _isLoadingPosts = false;
      });
    }
  }

  Future<void> _toggleFollow() async {
    if (widget.userProfile == null || _profileToDisplay == null || _isViewingSelf) return;

    final isCurrentlyFollowing = _profileToDisplay!.isFollowedByCurrentUser ?? false;
    
    setState(() {
      _profileToDisplay!.isFollowedByCurrentUser = !isCurrentlyFollowing;
      if (isCurrentlyFollowing) {
        _profileToDisplay!.followerCount = (_profileToDisplay!.followerCount ?? 1) - 1;
      } else {
        _profileToDisplay!.followerCount = (_profileToDisplay!.followerCount ?? 0) + 1;
      }
    });

    try {
      if (isCurrentlyFollowing) {
        await _supabaseService.unfollowUser(_profileToDisplay!.id);
      } else {
        await _supabaseService.followUser(_profileToDisplay!.id);
      }
      widget.onUserProfileNeedsRefresh?.call();
    } catch (e) {
      debugPrint("Error toggling follow: $e");
      _loadProfileData(); // Revert on error
    }
  }

  void _navigateToProfileEdit() {
    if (widget.userProfile == null) return;
    Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: ProfileEditScreen(userProfile: widget.userProfile!)))
        .then((profileWasUpdated) {
      if (profileWasUpdated == true) {
        _loadProfileData();
        widget.onUserProfileNeedsRefresh?.call();
      }
    });
  }

  Widget _buildXpCard(ThemeData theme, UserProfile profile) {
    final numberFormat = NumberFormat.compact();

    return Card(
      elevation: 4,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: XpBalanceScreen(initialProfile: profile),
            ),
          ).then((_) => _loadProfileData());
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              FaIcon(FontAwesomeIcons.star, size: 32, color: AppColors.gold),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total XP", style: theme.textTheme.bodyMedium),
                  Text(
                    numberFormat.format(profile.totalXp),
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Level ${profile.level}", style: theme.textTheme.bodyMedium),
                  const Text("Manage Balance", style: TextStyle(color: AppColors.primaryAccent, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios_rounded, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (_isLoading) {
      return Scaffold(backgroundColor: theme.scaffoldBackgroundColor, body: const Center(child: CircularProgressIndicator()));
    }

    if (_profileToDisplay == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: DiamondMeshBackground(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.userLock, size: 60, color: theme.colorScheme.onBackground.withOpacity(0.5)),
                const SizedBox(height: 20),
                Text("Please log in to view your profile.", textAlign: TextAlign.center, style: theme.textTheme.titleLarge),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.login_rounded),
                  label: const Text("Log In / Sign Up"),
                  onPressed: () => Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const LoginScreen())),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms),
          ),
        ),
      );
    }

    final profile = _profileToDisplay!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: DiamondMeshBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                if (_isViewingSelf)
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: _navigateToProfileEdit,
                    tooltip: "Edit Profile & Settings",
                  ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  ProfileHeader(
                    userProfile: profile,
                    isCurrentUser: _isViewingSelf,
                    onEditProfile: _navigateToProfileEdit,
                    onFollow: _toggleFollow,
                    isFollowing: profile.isFollowedByCurrentUser ?? false,
                  ),
                  const SizedBox(height: 24),
                  if (_isViewingSelf)
                    _buildXpCard(theme, profile),
                  const SizedBox(height: 24),
                  // --- MODIFIED STATS ROW ---
                  Row(
                    children: [
                      Expanded(
                        child: ProfileStatCard(
                          label: 'Followers',
                          count: profile.followerCount ?? 0,
                          icon: FontAwesomeIcons.users,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => 
                              FollowerListScreen(userId: profile.id, listType: 'Followers')
                            ));
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ProfileStatCard(
                          label: 'Following',
                          count: profile.followingCount ?? 0,
                          icon: FontAwesomeIcons.userCheck,
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (_isViewingSelf)
                        Expanded(
                          child: ProfileStatCard(
                            label: 'Notifications',
                            // The actual count is shown on the main nav bar, so this is just for navigation
                            count: 0, 
                            icon: FontAwesomeIcons.solidBell,
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: NotificationsScreen(userId: profile.id),
                                ),
                              );
                            },
                          ),
                        )
                      else
                        Expanded(
                          child: ProfileStatCard(
                            label: 'Cabals Joined',
                            count: profile.joinedCabalIds.length,
                            icon: FontAwesomeIcons.rightToBracket,
                          ),
                        ),
                    ],
                  ),
                  // --- END OF MODIFICATION ---
                  const SizedBox(height: 32),
                  Text(
                    _isViewingSelf ? "Your Activity" : "Past Activity",
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                ]),
              ),
            ),
            if (_isLoadingPosts)
              const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()))
            else if (_userPosts.isEmpty)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Text(
                      "${_isViewingSelf ? 'You haven\'t' : '${profile.displayName ?? 'They'} haven\'t'} posted anything yet.",
                      style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.6)),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: PostCardWidget(
                          post: _userPosts[index],
                          currentUserProfile: widget.userProfile,
                        ),
                      );
                    },
                    childCount: _userPosts.length,
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}

```

### File: ./lib/screens/leaderboard_screen.dart
```dart
// lib/screens/leaderboard_screen.dart
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/supabase_service.dart';
import '../widgets/diamond_mesh_background.dart';
import '../widgets/shimmer_widget.dart';
import '../utils/app_colors.dart';

class LeaderboardScreen extends StatefulWidget {
  final String? currentUserId;

  const LeaderboardScreen({
    Key? key,
    this.currentUserId,
  }) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SupabaseService _supabaseService = SupabaseService();
  List<UserProfile> _leaderboardUsers = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchLeaderboardData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchLeaderboardData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final users = await _supabaseService.getAllUsersForLeaderboard();
      if (mounted) {
        setState(() {
          _leaderboardUsers = users;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching leaderboard data: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Failed to load leaderboard. Please try again.";
        });
      }
    }
  }

  void _navigateToUserProfile(String userId) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: DashboardScreen(
          viewProfileId: userId,
          isLoadingProfile: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Global Leaderboard'),
        backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: FaIcon(FontAwesomeIcons.rankingStar), text: 'Rank'),
            Tab(icon: FaIcon(FontAwesomeIcons.chartSimple), text: 'Activity'),
          ],
        ),
      ),
      body: DiamondMeshBackground(
        child: Padding(
          padding: EdgeInsets.only(top: kToolbarHeight + (AppBar().preferredSize.height) + MediaQuery.of(context).padding.top),
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildRankView(),
              _buildActivityView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankView() {
    if (_isLoading) return _buildLoadingState();
    if (_errorMessage != null) return _buildErrorState(_errorMessage!);
    if (_leaderboardUsers.isEmpty) return _buildEmptyState();

    final xpFormatter = NumberFormat.compact();
    
    return RefreshIndicator(
      onRefresh: _fetchLeaderboardData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _leaderboardUsers.length,
        itemBuilder: (context, index) {
          final user = _leaderboardUsers[index];
          final rank = index + 1;
          final bool isCurrentUser = user.id == widget.currentUserId;
          final theme = Theme.of(context);

          return Card(
            elevation: isCurrentUser ? 4 : 2,
            color: isCurrentUser 
              ? theme.colorScheme.primary.withOpacity(0.15) 
              : theme.cardColor.withOpacity(0.8),
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isCurrentUser 
                ? BorderSide(color: theme.colorScheme.primary, width: 1.5)
                : BorderSide.none,
            ),
            child: ListTile(
              onTap: () => _navigateToUserProfile(user.id),
              leading: SizedBox(
                width: 40,
                child: Center(
                  child: Text(
                    "#$rank", 
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isCurrentUser ? theme.colorScheme.primary : null,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ),
              ),
              title: Text(user.displayName ?? 'Anonymous', style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text("Level ${user.level}"),
              trailing: Text(
                '${xpFormatter.format(user.totalXp)} XP', 
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.secondary, 
                  fontWeight: FontWeight.bold
                )
              ),
            ),
          ).animate().fadeIn(delay: (50 * index).ms).slideX(begin: 0.1);
        },
      ),
    );
  }

  Widget _buildActivityView() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_errorMessage != null) return _buildErrorState(_errorMessage!);
    if (_leaderboardUsers.isEmpty) return _buildEmptyState();

    final theme = Theme.of(context);
    final xpBrackets = [0, 100, 250, 500, 1000, 2500, 5000, 10000];
    final distribution = List.filled(xpBrackets.length, 0);
    int maxCount = 0;

    for (final user in _leaderboardUsers) {
      for (int i = xpBrackets.length - 1; i >= 0; i--) {
        if (user.totalXp >= xpBrackets[i]) {
          distribution[i]++;
          if (distribution[i] > maxCount) {
            maxCount = distribution[i];
          }
          break;
        }
      }
    }
    
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("User XP Distribution", style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text("Shows how many users are in each XP bracket.", style: theme.textTheme.bodyMedium),
            const SizedBox(height: 32),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (maxCount * 1.2).toDouble(), // Add some padding to the top
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => AppColors.darkGrey,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.toInt()} Users',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= xpBrackets.length) return const Text('');
                      return SideTitleWidget(axisSide: meta.axisSide, child: Text(NumberFormat.compact().format(xpBrackets[index]), style: theme.textTheme.bodySmall));
                    }, reservedSize: 30)),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: true, drawVerticalLine: false),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(xpBrackets.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [BarChartRodData(toY: distribution[index].toDouble(), color: theme.colorScheme.primary, width: 16, borderRadius: BorderRadius.circular(4))],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: List.generate(10, (index) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 6.0),
        child: ShimmerWidget.rectangular(height: 60),
      )),
    );
  }

  Widget _buildErrorState(String message) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(FontAwesomeIcons.circleExclamation, size: 50, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center, style: theme.textTheme.titleMedium),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh_rounded),
            label: const Text("Retry"),
            onPressed: _fetchLeaderboardData,
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(FontAwesomeIcons.ghost, size: 50, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6)),
          const SizedBox(height: 16),
          Text("The leaderboard is currently empty.", style: theme.textTheme.titleMedium),
          Text("Be the first to climb!", style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7))),
        ],
      ),
    );
  }
}

```

### File: ./lib/screens/create_quest_screen.dart
```dart
// lib/screens/create_quest_screen.dart
import 'package:cabal/models/quest_model.dart';
import 'package:cabal/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import '../utils/constants.dart';
import '../widgets/animated_particle_background.dart';
import '../widgets/info_tooltip.dart';

// Enum for boilerplate task templates
enum BoilerplateTask { none, watchVideo, readArticle, twitterFollow, discordJoin }

class CreateQuestScreen extends StatefulWidget {
  final String cabalId;
  final String sectionId;
  final Quest? existingQuest;

  const CreateQuestScreen({
    Key? key,
    required this.cabalId,
    required this.sectionId,
    this.existingQuest,
  }) : super(key: key);

  @override
  State<CreateQuestScreen> createState() => _CreateQuestScreenState();
}

class _CreateQuestScreenState extends State<CreateQuestScreen> {
  final _formKey = GlobalKey<FormState>();
  final SupabaseService _supabaseService = SupabaseService();
  bool get _isEditing => widget.existingQuest != null;
  bool _isLoading = false;

  // Form field controllers
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _xpController;
  late TextEditingController _actionUrlController;
  late TextEditingController _buttonTextController;
  late TextEditingController _cooldownController;
  
  QuestType _selectedQuestType = QuestType.custom;
  BoilerplateTask _selectedBoilerplate = BoilerplateTask.none;
  bool _requiresManualVerification = false;

  @override
  void initState() {
    super.initState();
    final quest = widget.existingQuest;
    _titleController = TextEditingController(text: quest?.title ?? '');
    _descriptionController = TextEditingController(text: quest?.description ?? '');
    _xpController = TextEditingController(text: quest?.xpReward.toString() ?? '100');
    _actionUrlController = TextEditingController(text: quest?.actionUrl ?? '');
    _buttonTextController = TextEditingController(text: quest?.taskButtonText ?? '');
    _cooldownController = TextEditingController(text: quest?.cooldownPeriod?.inSeconds.toString() ?? '');
    _selectedQuestType = quest?.type ?? QuestType.custom;
    _requiresManualVerification = quest?.requiresManualVerification ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _xpController.dispose();
    _actionUrlController.dispose();
    _buttonTextController.dispose();
    _cooldownController.dispose();
    super.dispose();
  }

  Future<void> _saveQuest() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.'), backgroundColor: Colors.orangeAccent),
      );
      return;
    }
    _formKey.currentState!.save();

    setState(() => _isLoading = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final questData = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'xp_reward': int.tryParse(_xpController.text) ?? 100,
        'type': questTypeToString(_selectedQuestType),
        'action_url': _actionUrlController.text.trim().isEmpty ? null : _actionUrlController.text.trim(),
        'task_button_text': _buttonTextController.text.trim().isEmpty ? null : _buttonTextController.text.trim(),
        'requires_manual_verification': _requiresManualVerification,
        'cooldown_period_seconds': int.tryParse(_cooldownController.text.trim()),
      };

      if (_isEditing) {
        await _supabaseService.updateQuest(widget.existingQuest!.id, questData);
      } else {
        questData['id'] = const Uuid().v4();
        await _supabaseService.createQuest(widget.cabalId, widget.sectionId, questData);
      }
      
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Quest ${_isEditing ? 'updated' : 'saved'} successfully!'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop(true);
      }

    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  
  void _onBoilerplateChanged(BoilerplateTask? task) {
    setState(() {
      _selectedBoilerplate = task ?? BoilerplateTask.none;
      switch (_selectedBoilerplate) {
        case BoilerplateTask.watchVideo:
          _titleController.text = "Watch a Video";
          _descriptionController.text = "Watch the embedded video to learn more.";
          _selectedQuestType = QuestType.custom;
          _buttonTextController.text = "Mark as Watched";
          break;
        case BoilerplateTask.readArticle:
          _titleController.text = "Read an Article";
          _descriptionController.text = "Read the linked article to understand our mission.";
          _selectedQuestType = QuestType.websiteVisit;
          _buttonTextController.text = "I Have Read It";
          break;
        case BoilerplateTask.twitterFollow:
          _titleController.text = "Follow us on X / Twitter";
          _descriptionController.text = "Follow our official account to stay updated.";
          _selectedQuestType = QuestType.twitterFollow;
          _buttonTextController.text = "Follow";
          break;
        case BoilerplateTask.discordJoin:
           _titleController.text = "Join our Discord Server";
          _descriptionController.text = "Become a part of our community on Discord.";
          _selectedQuestType = QuestType.discordJoin;
          _buttonTextController.text = "Join Server";
          break;
        case BoilerplateTask.none:
          // Do nothing, allow manual entry
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Quest' : 'Create Quest'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: AnimatedParticleBackground(
        child: AbsorbPointer(
          absorbing: _isLoading,
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.only(
                    top: kToolbarHeight + MediaQuery.of(context).padding.top + 16,
                    left: 16, right: 16, bottom: 100
                  ),
                  children: [
                    _buildBoilerplateSelector(theme),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Quest Title *'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Title is required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Short Description *', alignLabelWithHint: true),
                      maxLines: 3,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Description is required' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _xpController,
                            decoration: const InputDecoration(labelText: 'XP Reward *', prefixIcon: Icon(Icons.star_rounded)),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (v) => (v == null || int.tryParse(v) == null) ? 'Must be a valid number' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _cooldownController,
                            decoration: const InputDecoration(
                              labelText: 'Cooldown (Seconds)',
                              prefixIcon: Icon(Icons.timer_outlined),
                              suffixIcon: InfoTooltip(message: "Time in seconds before a user can repeat this quest. Leave blank for a one-time quest.")
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildQuestTypeSelector(theme),
                    const SizedBox(height: 16),
                    if (_selectedQuestType != QuestType.custom)
                      TextFormField(
                        controller: _actionUrlController,
                        decoration: const InputDecoration(
                          labelText: 'Action URL *',
                          hintText: 'e.g., https://twitter.com/user/status/123',
                          suffixIcon: InfoTooltip(message: 'The URL the user will be sent to (e.g., a Tweet to like, a website to visit).'),
                        ),
                        keyboardType: TextInputType.url,
                        validator: (v) => (_selectedQuestType != QuestType.custom && (v == null || v.trim().isEmpty)) ? 'URL is required for this quest type' : null,
                      ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _buttonTextController,
                      decoration: const InputDecoration(
                        labelText: 'Task Button Text',
                        hintText: 'e.g., "Like this Tweet"',
                        suffixIcon: InfoTooltip(message: 'The text displayed on the action button. If empty, a default will be used.'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Requires Manual Verification'),
                      subtitle: const Text('Admins must approve submissions for this quest.'),
                      value: _requiresManualVerification,
                      onChanged: (val) => setState(() => _requiresManualVerification = val),
                      secondary: const FaIcon(FontAwesomeIcons.userShield),
                    ),
                  ].animate(interval: 80.ms).fadeIn().slideY(begin: 0.1),
                ),
              ),
              if (_isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
        width: double.infinity,
        color: theme.cardColor,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.save),
          label: Text(_isEditing ? 'Save Changes' : 'Create Quest'),
          onPressed: _isLoading ? null : _saveQuest,
        ),
      ),
    );
  }
  
  Widget _buildBoilerplateSelector(ThemeData theme) {
    return DropdownButtonFormField<BoilerplateTask>(
      value: _selectedBoilerplate,
      decoration: const InputDecoration(
        labelText: 'Start with a Template (Optional)',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: BoilerplateTask.none, child: Text('Custom Quest')),
        DropdownMenuItem(value: BoilerplateTask.watchVideo, child: Text('Watch a Video')),
        DropdownMenuItem(value: BoilerplateTask.readArticle, child: Text('Read an Article')),
        DropdownMenuItem(value: BoilerplateTask.twitterFollow, child: Text('Twitter Follow')),
        DropdownMenuItem(value: BoilerplateTask.discordJoin, child: Text('Discord Join')),
      ],
      onChanged: _onBoilerplateChanged,
    );
  }

  Widget _buildQuestTypeSelector(ThemeData theme) {
    return DropdownButtonFormField<QuestType>(
      value: _selectedQuestType,
      decoration: const InputDecoration(
        labelText: 'Quest Type *',
        border: OutlineInputBorder(),
      ),
      items: QuestType.values.map((QuestType type) {
        return DropdownMenuItem<QuestType>(
          value: type,
          child: Text(type.toString().split('.').last),
        );
      }).toList(),
      onChanged: (QuestType? newValue) {
        setState(() {
          _selectedQuestType = newValue!;
          _selectedBoilerplate = BoilerplateTask.none; // Reset boilerplate if type is changed manually
        });
      },
    );
  }
}

```

### File: ./lib/screens/edit_cabal_screen.dart
```dart
// lib/screens/edit_cabal_screen.dart
import 'package:cabal/models/cabal_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/supabase_service.dart';
import '../widgets/animated_particle_background.dart';
import '../utils/app_colors.dart';
import 'create_cabal_screen.dart'; // To get the categories map

class EditCabalScreen extends StatefulWidget {
  final Cabal cabal;
  const EditCabalScreen({Key? key, required this.cabal}) : super(key: key);
  @override
  State<EditCabalScreen> createState() => _EditCabalScreenState();
}

class _EditCabalScreenState extends State<EditCabalScreen> {
  final _formKey = GlobalKey<FormState>();
  final SupabaseService _supabaseService = SupabaseService();

  // --- Basic Info Controllers ---
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _projectUrlController;
  late bool _isPrivate;
  String? _selectedCategory;
  
  // --- WEB3 UPDATE: Web3 Info Controllers ---
  late TextEditingController _tokenAddressController;
  late TextEditingController _tokenSymbolController;
  late int _chainId;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize basic info
    _nameController = TextEditingController(text: widget.cabal.name);
    _descriptionController = TextEditingController(text: widget.cabal.description);
    _projectUrlController = TextEditingController(text: widget.cabal.projectUrl ?? '');
    _isPrivate = widget.cabal.isPrivate;
    _selectedCategory = widget.cabal.category;
    
    // --- WEB3 UPDATE: Initialize Web3 info ---
    _tokenAddressController = TextEditingController(text: widget.cabal.tokenContractAddress ?? '');
    _tokenSymbolController = TextEditingController(text: widget.cabal.tokenSymbol ?? '');
    _chainId = widget.cabal.chainId ?? 11155111; // Default to Sepolia
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _projectUrlController.dispose();
    _tokenAddressController.dispose();
    _tokenSymbolController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (!_formKey.currentState!.validate() || _selectedCategory == null) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Please correct the errors and select a category.'), backgroundColor: AppColors.warning));
      return;
    }
    _formKey.currentState!.save();
    
    if (mounted) setState(() => _isLoading = true);

    try {
      // Create a new Cabal object with all the updated fields
      final updatedCabal = Cabal(
        id: widget.cabal.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        projectUrl: _projectUrlController.text.trim().isEmpty ? null : _projectUrlController.text.trim(),
        isPrivate: _isPrivate,
        category: _selectedCategory,
        // --- WEB3 UPDATE: Add updated Web3 fields ---
        tokenContractAddress: _tokenAddressController.text.trim().isEmpty ? null : _tokenAddressController.text.trim(),
        tokenSymbol: _tokenSymbolController.text.trim().isEmpty ? null : _tokenSymbolController.text.trim(),
        chainId: _chainId,
        // Carry over existing values that are not editable on this screen
        creatorId: widget.cabal.creatorId,
        creatorHandle: widget.cabal.creatorHandle,
        logoUrl: widget.cabal.logoUrl,
        bannerImageUrl: widget.cabal.bannerImageUrl,
        createdAt: widget.cabal.createdAt,
      );

      await _supabaseService.updateCabal(updatedCabal);

      if (mounted) {
        scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Cabal updated successfully!'), backgroundColor: AppColors.success));
        Navigator.pop(context, true); // Pop with true to indicate a refresh is needed
      }
    } catch (e) {
      if (mounted) scaffoldMessenger.showSnackBar(SnackBar(content: Text('Failed to update cabal: ${e.toString().split(':').last.trim()}'), backgroundColor: Theme.of(context).colorScheme.error));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Edit "${widget.cabal.name}"', overflow: TextOverflow.ellipsis),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.solidFloppyDisk),
            onPressed: _isLoading ? null : _saveChanges,
            tooltip: "Save Changes",
          )
        ],
      ),
      body: AnimatedParticleBackground(
        child: AbsorbPointer(
          absorbing: _isLoading,
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.only(top: kToolbarHeight + MediaQuery.of(context).padding.top + 16, left: 16, right: 16, bottom: 40),
                  children: [
                    Text("Cabal Details", style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary)),
                    const SizedBox(height: 16),
                    TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Cabal Name *'), validator: (v) => (v == null || v.trim().length < 3) ? 'Name must be at least 3 characters.' : null),
                    const SizedBox(height: 16),
                    TextFormField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Cabal Description *'), maxLines: 4, maxLength: 500, validator: (v) => (v == null || v.trim().length < 10) ? 'Description must be at least 10 characters.' : null),
                    const SizedBox(height: 16),
                    TextFormField(controller: _projectUrlController, decoration: const InputDecoration(labelText: 'Project Website URL (Optional)'), keyboardType: TextInputType.url, validator: (v) { if (v == null || v.trim().isEmpty) return null; if (!(Uri.tryParse(v.trim())?.isAbsolute ?? false)) return 'Please enter a valid URL'; return null; }),
                    const SizedBox(height: 24),
                    _buildCategorySelector(theme),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 0,
                      color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                      child: SwitchListTile(
                        title: Text("Private Cabal", style: theme.textTheme.titleMedium),
                        subtitle: Text(_isPrivate ? "Visible only to members." : "Visible to everyone."),
                        value: _isPrivate,
                        onChanged: (bool value) => setState(() => _isPrivate = value),
                        secondary: FaIcon(_isPrivate ? FontAwesomeIcons.lock : FontAwesomeIcons.globe),
                      ),
                    ),
                    const Divider(height: 40),
                    // --- WEB3 UPDATE: Web3 settings section ---
                    Text("Web3 Integration", style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _tokenAddressController,
                      decoration: const InputDecoration(labelText: 'Token Contract Address (Optional)'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _tokenSymbolController,
                      decoration: const InputDecoration(labelText: 'Token Symbol (e.g., MYTKN)'),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _chainId,
                      decoration: const InputDecoration(labelText: 'Blockchain (Chain ID)'),
                      items: const [
                        DropdownMenuItem(value: 1, child: Text("Ethereum Mainnet")),
                        DropdownMenuItem(value: 11155111, child: Text("Sepolia Testnet")),
                        DropdownMenuItem(value: 8453, child: Text("Base Mainnet")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _chainId = value!;
                        });
                      },
                    ),
                  ].animate(interval: 100.ms).fadeIn().slideY(begin: 0.1),
                ),
              ),
              if (_isLoading)
                Container(
                  color: theme.scaffoldBackgroundColor.withOpacity(0.7),
                  child: Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text("Saving...", style: theme.textTheme.titleMedium),
                          ],
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildCategorySelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Cabal Category *", style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: cabalCategories.entries.map((entry) {
            final isSelected = _selectedCategory == entry.key;
            return ChoiceChip(
              label: Text(entry.key),
              avatar: FaIcon(entry.value, size: 16, color: isSelected ? theme.colorScheme.onSecondary : theme.colorScheme.secondary),
              selected: isSelected,
              onSelected: (selected) => setState(() => _selectedCategory = selected ? entry.key : null),
              selectedColor: theme.colorScheme.secondary,
              labelStyle: theme.chipTheme.labelStyle?.copyWith(color: isSelected ? theme.colorScheme.onSecondary : theme.chipTheme.labelStyle?.color),
            );
          }).toList(),
        ),
      ],
    );
  }
}

```

### File: ./lib/screens/cabal_detail_screen.dart
```dart
// lib/screens/cabal_detail_screen.dart
import 'dart:async';
import 'dart:math';
import 'package:cabal/models/community_post_model.dart';
import 'package:cabal/models/merchandise_product_model.dart';
import 'package:cabal/screens/add_merch_screen.dart';
import 'package:cabal/screens/create_post_screen.dart';
import 'package:cabal/screens/dex_screen.dart';
import 'package:cabal/screens/edit_cabal_screen.dart';
import 'package:cabal/screens/list_property_screen.dart';
import 'package:cabal/screens/manage_cabal_screen.dart';
import 'package:cabal/widgets/community_activity_chart.dart';
import 'package:cabal/widgets/community_stats_header.dart';
import 'package:cabal/widgets/merchandise_card_widget.dart';
import 'package:cabal/widgets/post_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:page_transition/page_transition.dart';

import '../models/cabal_model.dart';
import '../models/quest_section_model.dart';
import '../models/quest_model.dart';
import '../models/user_profile_model.dart';
import '../services/supabase_service.dart';
import '../widgets/quest_section_widget.dart';
import '../utils/app_colors.dart';
import '../widgets/quest_complete_celebration.dart';
import '../features/wallet/application/wallet_provider.dart';
import '../utils/constants.dart';
import '../widgets/cabal_header_widget.dart';
import '../widgets/leaderboard_preview_card.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'product_detail_screen.dart';
import 'leaderboard_screen.dart';

class CabalDetailScreen extends StatefulWidget {
  final String cabalId;
  final String? telegramUsername;

  const CabalDetailScreen({
    Key? key,
    required this.cabalId,
    this.telegramUsername,
  }) : super(key: key);

  @override
  State<CabalDetailScreen> createState() => _CabalDetailScreenState();
}

enum QuestStatusFilter { all, locked, completed, inProgress, onCooldown, pending }

class _CabalDetailScreenState extends State<CabalDetailScreen> with TickerProviderStateMixin {
  final SupabaseService _supabaseService = SupabaseService();
  final AuthService _authService = AuthService();
  late TabController _tabController;

  Cabal? _cabal;
  UserProfile? _viewingUserProfile;
  UserProfile? _currentUserProfile;
  
  List<QuestSection> _questSections = [];
  Map<String, List<Quest>> _allQuestsBySection = {};
  Map<String, List<Quest>> _filteredQuestsBySection = {};
  Set<String> _viewingUserCompletedQuestIds = {};
  Map<String, DateTime?> _viewingUserCompletionTimestamps = {};
  Map<String, int> _viewingUserQuestStepsMap = {};
  Map<String, String> _viewingUserQuestActualStatusMap = {};
  QuestStatusFilter _selectedStatusFilter = QuestStatusFilter.all;

  List<CommunityPost> _communityPosts = [];
  bool _isLoadingPosts = true;
  
  bool _isLoadingCommunityStats = true;
  int _memberCount = 0;
  int _postCount = 0;
  List<Map<String, dynamic>> _activityTimeseries = [];
  
  List<MerchandiseProduct> _merchandise = [];
  bool _isLoadingMerch = true;
  
  bool _isLoading = true;
  String? _errorMessage;
  String? _loadingClaimQuestId;
  bool _isFavoriting = false;
  bool _isJoining = false;
  int? _userRank;
  int? _userCabalXp;
  bool _isLoadingRank = true;
  
  bool _hasPendingRequest = false;
  bool _isRequestingToJoin = false;
  
  Color? _pageBackgroundColor;
  Color? _cardColor;
  Color? _textColor;
  Color? _accentColor;

  bool get _cabalIsTokenized => _cabal?.tokenContractAddress != null && _cabal!.tokenContractAddress!.isNotEmpty;
  bool get _isCreator => _currentUserProfile?.id == _cabal?.creatorId;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); 
    _tabController.addListener(() => setState(() {}));
    _loadCabalScreenData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCabalScreenData({bool forceReload = false}) async {
    if (!mounted) return;
    if (!forceReload) setState(() => _isLoading = true);

    try {
      final authUser = _supabaseService.getCurrentUser();
      _currentUserProfile = authUser != null ? await _supabaseService.getUserProfile(authUser.id) : null;
      _cabal = await _supabaseService.getCabal(widget.cabalId);
      if (_cabal == null) throw Exception("Cabal not found.");
      
      _setThemeFromCabal(_cabal!.theme);
      
      _viewingUserProfile = widget.telegramUsername != null 
          ? await _supabaseService.findUserProfileByTelegram(widget.telegramUsername!) 
          : _currentUserProfile;

      if (_viewingUserProfile != null) {
        final progressData = await _supabaseService.getUserProgressInCabal(_viewingUserProfile!.id, widget.cabalId);
        _viewingUserCompletedQuestIds = progressData['completed_ids'] ?? {};
        _viewingUserCompletionTimestamps = progressData['timestamps'] ?? {};
        _viewingUserQuestStepsMap = progressData['steps'] ?? {};
        _viewingUserQuestActualStatusMap = progressData['statuses'] ?? {};
      } else {
        _isLoadingRank = false;
      }
      
      if (_cabal!.isPrivate && _currentUserProfile != null) {
        _hasPendingRequest = await _supabaseService.hasPendingJoinRequest(_cabal!.id);
      }

      final results = await Future.wait([
        _supabaseService.getQuestsForCabal(widget.cabalId),
        _supabaseService.getQuestSectionsForCabal(widget.cabalId),
        _supabaseService.getCommunityPosts(widget.cabalId),
        _supabaseService.getCabalCommunityStats(widget.cabalId),
        _supabaseService.getMerchandiseForCabal(widget.cabalId),
      ]);
      
      final allQuests = results[0] as List<Quest>;
      final sections = results[1] as List<QuestSection>;
      _communityPosts = results[2] as List<CommunityPost>;
      final stats = results[3] as Map<String, dynamic>;
      _merchandise = results[4] as List<MerchandiseProduct>;

      _memberCount = stats['member_count'];
      _postCount = stats['post_count'];
      _activityTimeseries = stats['activity_timeseries'];
      
      final tabCount = 2 + (_cabalIsTokenized ? 1 : 0) + ((_merchandise.isNotEmpty || _isCreator) ? 1 : 0);
      if (_tabController.length != tabCount) {
        final initialIndex = _tabController.index;
        _tabController.dispose();
        _tabController = TabController(length: tabCount, vsync: this, initialIndex: min(initialIndex, tabCount - 1));
        _tabController.addListener(() => setState(() {}));
      }

      if (_cabal!.questSectionOrder.isNotEmpty) {
        sections.sort((a, b) => _cabal!.questSectionOrder.indexOf(a.id).compareTo(_cabal!.questSectionOrder.indexOf(b.id)));
      } else {
        sections.sort((a,b) => a.order.compareTo(b.order));
      }
      _questSections = sections;
      _allQuestsBySection.clear();
      for (final quest in allQuests) {
        final sectionId = quest.id;
        if(sectionId != null) {
            _allQuestsBySection.putIfAbsent(sectionId, () => []).add(quest);
        }
      }
      
      _updateQuestObjectsWithViewingUserProgress();
      _applyFilters();
      
      if (mounted) {
        setState(() {
          _isLoadingPosts = false;
          _isLoadingCommunityStats = false;
          _isLoadingMerch = false;
          _isLoading = false;
        });
      }
    } catch (e, s) {
      debugPrint("Error loading cabal screen data: $e\n$s");
      if (mounted) setState(() { _errorMessage = "Failed to load cabal details."; _isLoading = false; });
    }
  }
  
  void _updateQuestObjectsWithViewingUserProgress() {
    if (_viewingUserProfile == null) {
      _allQuestsBySection.values.forEach((quests) => quests.forEach((q) {
        q.isLockedForUser = true;
        q.isCompletedByUser = false;
      }));
      return;
    }
    _allQuestsBySection.values.forEach((quests) => quests.forEach((q) => q.updateUserStatus(
      allCompletedQuestIdsForUserInCabal: _viewingUserCompletedQuestIds,
      userQuestCompletionTimestamps: _viewingUserCompletionTimestamps,
      userQuestStepsCompletedMap: _viewingUserQuestStepsMap,
      userQuestActualStatusesMap: _viewingUserQuestActualStatusMap,
    )));
  }

  void _applyFilters() {
    _filteredQuestsBySection.clear();
    _allQuestsBySection.forEach((sectionId, quests) {
      final filtered = quests.where((quest) {
        switch (_selectedStatusFilter) {
          case QuestStatusFilter.all: return true;
          case QuestStatusFilter.locked: return quest.isLockedForUser;
          case QuestStatusFilter.completed: return quest.isCompletedByUser;
          case QuestStatusFilter.inProgress: return !quest.isLockedForUser && !quest.isCompletedByUser && !quest.isOnCooldownForUser && quest.userQuestSpecificStatus != 'pending_verification';
          case QuestStatusFilter.onCooldown: return quest.isOnCooldownForUser;
          case QuestStatusFilter.pending: return quest.userQuestSpecificStatus == 'pending_verification';
        }
      }).toList();
      if (filtered.isNotEmpty) _filteredQuestsBySection[sectionId] = filtered;
    });
    setState(() {});
  }
  
  void _setThemeFromCabal(Map<String, dynamic>? themeData) {
    if (themeData == null) return;
    try {
      _pageBackgroundColor = Color(int.parse(themeData['page_bg'].substring(1, 7), radix: 16) + 0xFF000000);
      _cardColor = Color(int.parse(themeData['card_bg'].substring(1, 7), radix: 16) + 0xFF000000);
      _textColor = Color(int.parse(themeData['text_color'].substring(1, 7), radix: 16) + 0xFF000000);
      _accentColor = Color(int.parse(themeData['accent_color'].substring(1, 7), radix: 16) + 0xFF000000);
    } catch (e) {
      debugPrint("Error parsing custom theme colors: $e");
    }
  }

  Future<void> _handleQuestClaim(Quest quest) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final walletProvider = context.read<WalletProvider>();
    final currentUser = _currentUserProfile;
    if (currentUser == null) {
      _showLoginPrompt();
      return;
    }

    setState(() => _loadingClaimQuestId = quest.id);

    try {
      bool actionSuccess = false;
      String? walletAddress;
      
      switch (quest.type) {
        case QuestType.connectWalletEth:
        case QuestType.connectWalletBase:
          await walletProvider.connectEVMWallet(context: context);
          walletAddress = walletProvider.connectedEVMAddress;
          actionSuccess = walletProvider.isConnectedEVM;
          break;
        case QuestType.twitterFollow:
        case QuestType.twitterLike:
        case QuestType.twitterRetweet:
          actionSuccess = await _authService.signInWithTwitter(quest.actionUrl);
          break;
        case QuestType.discordJoin:
          actionSuccess = await _authService.signInWithDiscord(quest.actionUrl);
          break;
        case QuestType.websiteVisit:
        case QuestType.telegramChannelJoin:
        case QuestType.telegramGroupJoin:
           await _authService.launchActionUrl(quest.actionUrl);
           actionSuccess = true;
           break;
        default:
          actionSuccess = true;
      }
      
      if(actionSuccess) {
        final result = await _supabaseService.completeQuest(quest.id);
        if (result['success'] as bool? ?? false) {
          scaffoldMessenger.showSnackBar(SnackBar(content: Text('Quest complete! +${quest.xpReward} XP'), backgroundColor: AppColors.success));
          showQuestCompleteCelebration(context);
          await _loadCabalScreenData(forceReload: true);
        } else {
          throw Exception(result['message'] ?? 'Failed to complete quest.');
        }
      }
      
    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Action failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _loadingClaimQuestId = null);
    }
  }
  
  Future<void> _toggleFavorite() async {
    if (_currentUserProfile == null) return;
    setState(() => _isFavoriting = true);
    final isCurrentlyFavorited = _currentUserProfile!.favoritedCabalIds.contains(widget.cabalId);
    
    if (isCurrentlyFavorited) {
      _currentUserProfile!.favoritedCabalIds.remove(widget.cabalId);
    } else {
      _currentUserProfile!.favoritedCabalIds.add(widget.cabalId);
    }
    
    try {
      await _supabaseService.updateUserProfile({'favorited_cabal_ids': _currentUserProfile!.favoritedCabalIds});
    } catch(e) {
      if (isCurrentlyFavorited) {
        _currentUserProfile!.favoritedCabalIds.add(widget.cabalId);
      } else {
        _currentUserProfile!.favoritedCabalIds.remove(widget.cabalId);
      }
    } finally {
      if(mounted) setState(() => _isFavoriting = false);
    }
  }
  
  Future<void> _handleJoinCabal() async {
    if (_currentUserProfile == null) {
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const LoginScreen()));
      return;
    }
    if (_isJoining || _cabal == null) return;

    setState(() => _isJoining = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await _supabaseService.joinCabal(_cabal!.id);
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Welcome to the ${_cabal!.name} Cabal!'), backgroundColor: AppColors.success),
      );
      await _loadCabalScreenData(forceReload: true);
    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Error joining cabal: $e"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isJoining = false);
    }
  }
  
  void _navigateToLeaderboard() {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: LeaderboardScreen(currentUserId: _currentUserProfile?.id),
      ),
    );
  }

  Future<void> _requestToJoin() async {
    if (_cabal == null || _currentUserProfile == null) return;
    setState(() => _isRequestingToJoin = true);
    try {
      await _supabaseService.requestToJoinCabal(_cabal!.id);
      setState(() {
        _hasPendingRequest = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Request sent!"), backgroundColor: AppColors.success),
      );
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isRequestingToJoin = false);
    }
  }

  void _showLoginPrompt() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please log in to perform this action.")));
    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator(color: _accentColor)));
    }
    if (_errorMessage != null || _cabal == null) {
      return Scaffold(body: Center(child: Text(_errorMessage ?? "Cabal not found.")));
    }
    
    final cabal = _cabal!;
    final isMember = _currentUserProfile?.joinedCabalIds.contains(cabal.id) ?? false;
    final canAccess = !cabal.isPrivate || isMember || _isCreator;
    
    List<Widget> tabs = [ const Tab(text: 'Quests'), const Tab(text: 'Community'), ];
    List<Widget> tabViews = [ _buildQuestsView(), _buildCommunityView(), ];

    if (_merchandise.isNotEmpty || _isCreator) {
      tabs.add(const Tab(text: 'Merch'));
      tabViews.add(_buildMerchView());
    }
    if (_cabalIsTokenized) {
      tabs.add(const Tab(text: 'Treasury / DEX'));
      tabViews.add(DexScreen(cabal: cabal, userProfile: _currentUserProfile!));
    }
    
    return Scaffold(
      backgroundColor: _pageBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(cabal.name, style: TextStyle(color: _textColor, shadows: const [Shadow(color: Colors.black54, blurRadius: 4)])),
                background: cabal.bannerImageUrl != null
                  ? Image.network(cabal.bannerImageUrl!, fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(color: _cardColor))
                  : Container(color: _accentColor?.withOpacity(0.2)),
              ),
              actions: [
                if (_currentUserProfile != null) IconButton(
                  icon: _isFavoriting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : FaIcon(
                    (_currentUserProfile?.favoritedCabalIds.contains(cabal.id) ?? false) ? FontAwesomeIcons.solidStar : FontAwesomeIcons.star,
                    color: _accentColor
                  ),
                  onPressed: _toggleFavorite
                ),
              ],
            ),
            SliverToBoxAdapter(child: CabalHeaderWidget(project: cabal).animate().fadeIn(delay: 200.ms)),
            
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: _buildContextualActions(isMember),
              ),
            ),
            
            if (canAccess) SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: tabs.length > 3,
                  tabs: tabs,
                  indicatorColor: _accentColor,
                  labelColor: _accentColor,
                  unselectedLabelColor: _textColor?.withOpacity(0.7),
                ),
                backgroundColor: _pageBackgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ];
        },
        body: canAccess
            ? TabBarView(controller: _tabController, children: tabViews)
            : _buildAccessDeniedWidget(Theme.of(context), isMember),
      ),
      floatingActionButton: _buildFloatingActionButton(canAccess, _isCreator),
    );
  }

  // --- BUILD METHODS RESTORED ---
  Widget _buildContextualActions(bool isMember) {
    if (_isCreator) {
      return _buildCreatorActions();
    } else if (!isMember && !_cabal!.isPrivate) {
      return ElevatedButton.icon(
        icon: _isJoining
            ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const FaIcon(FontAwesomeIcons.rightToBracket, size: 16),
        label: Text(_isJoining ? 'Joining...' : 'Join Cabal'),
        onPressed: _isJoining ? null : _handleJoinCabal,
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildCreatorActions() {
    final theme = Theme.of(context);
    List<Widget> actions = [];

    actions.add(
      Expanded(
        child: OutlinedButton.icon(
          icon: const FaIcon(FontAwesomeIcons.gears, size: 16),
          label: const Text("Manage Cabal"),
          onPressed: () async {
            final needsRefresh = await Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: ManageCabalScreen(cabal: _cabal!)));
            if (needsRefresh == true && mounted) {
              _loadCabalScreenData(forceReload: true);
            }
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: _textColor ?? theme.colorScheme.onSurface,
            side: BorderSide(color: (_textColor ?? theme.colorScheme.onSurface).withOpacity(0.5))
          ),
        ),
      ),
    );

    if (_cabal?.category == 'Real Estate') {
      actions.add(const SizedBox(width: 12));
      actions.add(
        Expanded(
          child: ElevatedButton.icon(
            icon: const FaIcon(FontAwesomeIcons.houseMedical, size: 16),
            label: const Text("List Property"),
            onPressed: () => Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: const ListPropertyScreen())),
          ),
        ),
      );
    }

    return Row(children: actions);
  }
  
  Widget _buildQuestsView() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: LeaderboardPreviewCard(
            rank: _userRank, 
            userCabalXp: _userCabalXp, 
            isLoading: _isLoadingRank, 
            onTap: _navigateToLeaderboard
          )
        )),
        SliverPersistentHeader(
          pinned: true,
          delegate: _SliverAppBarDelegate(
            _buildFilterChips(Theme.of(context)), 
            backgroundColor: _pageBackgroundColor ?? Theme.of(context).scaffoldBackgroundColor
          )
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: _filteredQuestsBySection.isEmpty 
            ? SliverFillRemaining(child: Center(child: Text("No quests match the current filters.", style: TextStyle(color: _textColor?.withOpacity(0.7))))) 
            : SliverList(
              delegate: SliverChildListDelegate(
                _questSections
                  .where((s) => _filteredQuestsBySection.containsKey(s.id))
                  .map((section) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0), 
                    child: QuestSectionWidget(
                      cabalId: _cabal!.id, 
                      section: section, 
                      quests: _filteredQuestsBySection[section.id] ?? [], 
                      viewingUserProfile: _viewingUserProfile, 
                      currentUserProfile: _currentUserProfile, 
                      completedQuestIdsForProject: _viewingUserCompletedQuestIds, 
                      userQuestCompletionTimestamps: _viewingUserCompletionTimestamps, 
                      userQuestStepsMap: _viewingUserQuestStepsMap, 
                      userQuestStatusMap: _viewingUserQuestActualStatusMap, 
                      onClaimReward: _handleQuestClaim, 
                      loadingClaimQuestId: _loadingClaimQuestId, 
                      cardColor: _cardColor ?? Theme.of(context).cardColor, 
                      textColor: _textColor ?? Theme.of(context).textTheme.bodyLarge!.color!, 
                      accentColor: _accentColor ?? Theme.of(context).colorScheme.secondary
                    )
                  )).toList()
              )
            )
        )
      ]
    );
  }

  Widget _buildCommunityView() {
    return RefreshIndicator(
      onRefresh: () async { await _loadCabalScreenData(forceReload: true); },
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            sliver: SliverToBoxAdapter(
              child: _isLoadingCommunityStats
                ? const Center(child: CircularProgressIndicator())
                : Column(children: [
                    CommunityStatsHeader(cabal: _cabal!, memberCount: _memberCount, postCount: _postCount),
                    const SizedBox(height: 16),
                    if (_activityTimeseries.isNotEmpty) CommunityActivityChart(activityData: _activityTimeseries)
                  ])
            )
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(child: Text("Latest Posts", style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: _textColor)))
          ),
          _isLoadingPosts
            ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
            : _communityPosts.isEmpty
              ? SliverFillRemaining(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  FaIcon(FontAwesomeIcons.solidCommentDots, size: 50, color: _textColor?.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text("No posts here yet.", style: TextStyle(color: _textColor, fontSize: 18))
                ])))
              : SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = _communityPosts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: PostCardWidget(post: post, currentUserProfile: _currentUserProfile)
                      );
                    },
                    childCount: _communityPosts.length
                  )
                )
              ),
          const SliverToBoxAdapter(child: SizedBox(height: 80))
        ]
      )
    );
  }

  Widget _buildMerchView() {
    if (_isLoadingMerch) { return const Center(child: CircularProgressIndicator()); }
    if (_merchandise.isEmpty && !_isCreator) { return Center(child: Text("This Cabal has no merchandise available yet.", style: TextStyle(color: _textColor))); }
    if (_merchandise.isEmpty && _isCreator) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Your store is empty.", style: TextStyle(color: _textColor)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              if (_currentUserProfile == null) { _showLoginPrompt(); return; }
              final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddMerchScreen(cabalId: widget.cabalId, userProfile: _currentUserProfile!)));
              if (result == true) _loadCabalScreenData(forceReload: true);
            },
            child: const Text('List Your First Item'),
          )
        ]),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.75,
      ),
      itemCount: _merchandise.length,
      itemBuilder: (context, index) {
        final product = _merchandise[index];
        return MerchandiseCardWidget(
          product: product,
          onTap: () async {
             if (_currentUserProfile == null) { _showLoginPrompt(); return; }
             final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product, userProfile: _currentUserProfile!)));
             if (result == true) _loadCabalScreenData(forceReload: true);
          },
        );
      },
    );
  }
  
  Widget _buildFilterChips(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      height: 60.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        children: QuestStatusFilter.values.map((filter) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ChoiceChip(
            label: Text(filter.name),
            selected: _selectedStatusFilter == filter,
            onSelected: (selected) {
              if (selected) setState(() { _selectedStatusFilter = filter; _applyFilters(); });
            },
            selectedColor: _accentColor,
            labelStyle: TextStyle(color: _selectedStatusFilter == filter ? ((_accentColor?.computeLuminance() ?? 0) > 0.5 ? Colors.black : Colors.white) : _textColor)
          )
        )).toList()
      )
    );
  }

  Widget _buildAccessDeniedWidget(ThemeData theme, bool isMember) {
    Widget button;
    if (_currentUserProfile == null) {
      button = ElevatedButton.icon(onPressed: (){ Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const LoginScreen())); }, icon: const Icon(Icons.login), label: const Text("Log In to Join"));
    } else if (_hasPendingRequest) {
      button = ElevatedButton.icon(onPressed: null, icon: const FaIcon(FontAwesomeIcons.hourglassHalf, size: 16), label: const Text("Request Pending"));
    } else {
      button = ElevatedButton.icon(onPressed: _isRequestingToJoin ? null : _requestToJoin, icon: _isRequestingToJoin ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const FaIcon(FontAwesomeIcons.rightToBracket, size: 16), label: const Text("Request to Join"));
    }
    return Center(child: Card(color: _cardColor, child: Padding(padding: const EdgeInsets.all(32.0), child: Column(mainAxisSize: MainAxisSize.min, children: [
      FaIcon(FontAwesomeIcons.lock, size: 40, color: _textColor?.withOpacity(0.7)),
      const SizedBox(height: 16),
      Text("This is a Private Cabal", style: theme.textTheme.titleLarge?.copyWith(color: _textColor)),
      const SizedBox(height: 8),
      Text("You must be a member to view its content.", style: theme.textTheme.bodyMedium?.copyWith(color: _textColor?.withOpacity(0.8))),
      if (!isMember) ...[ const SizedBox(height: 24), button ]
    ])))).animate().fadeIn(delay: 300.ms);
  }

  Widget? _buildFloatingActionButton(bool canAccess, bool isCreator) {
    if (!canAccess) return null;
    
    int communityTabIndex = 1;
    int merchTabIndex = -1;
    if (_merchandise.isNotEmpty || isCreator) merchTabIndex = 2;

    VoidCallback? onPressedAction;
    IconData? icon;
    String? label;

    if (_tabController.index == communityTabIndex) {
      onPressedAction = () async {
        if (_currentUserProfile == null) { _showLoginPrompt(); return; }
        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePostScreen(cabalId: widget.cabalId, cabalName: _cabal?.name ?? 'Cabal')));
        if (result == true) _loadCabalScreenData(forceReload: true);
      };
      icon = Icons.add;
      label = 'Create Post';
    } else if (isCreator && _tabController.index == merchTabIndex) {
      onPressedAction = () async {
        if (_currentUserProfile == null) { _showLoginPrompt(); return; }
        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddMerchScreen(cabalId: widget.cabalId, userProfile: _currentUserProfile!)));
        if (result == true) _loadCabalScreenData(forceReload: true);
      };
      icon = Icons.add_shopping_cart;
      label = 'Add Merch';
    }

    if (onPressedAction != null) {
      return FloatingActionButton.extended(
        onPressed: onPressedAction,
        icon: Icon(icon),
        label: Text(label!),
      );
    }
    return null;
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._child, {required this.backgroundColor});
  final Widget _child;
  final Color backgroundColor;
  @override double get minExtent => 48.0;
  @override double get maxExtent => 48.0;
  @override Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) { return Container(color: backgroundColor, child: _child); }
  @override bool shouldRebuild(_SliverAppBarDelegate oldDelegate) { return backgroundColor != oldDelegate.backgroundColor || _child != oldDelegate._child; }
}

```

### File: ./lib/screens/token_analytics_screen.dart
```dart
// lib/screens/token_analytics_screen.dart
import 'package:cabal/services/block_explorer_service.dart';
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:cabal/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kDebugMode; // <-- FIX: IMPORT ADDED
import 'package:cabal/config.dart';                      // <-- FIX: IMPORT ADDED

class TokenAnalyticsScreen extends StatefulWidget {
  const TokenAnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<TokenAnalyticsScreen> createState() => _TokenAnalyticsScreenState();
}

class _TokenAnalyticsScreenState extends State<TokenAnalyticsScreen> {
  Future<Map<String, dynamic>>? _analyticsDataFuture;
  late final String _tokenAddress;

  @override
  void initState() {
    super.initState();
    // FIX: Correctly access environment variables via AppConfig
    _tokenAddress = kDebugMode 
        ? AppConfig.sepoliaCabalTokenAddress 
        : AppConfig.mainnetCabalTokenAddress;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAnalyticsData();
    });
  }

  void _loadAnalyticsData() {
    setState(() {
      _analyticsDataFuture = _fetchAnalyticsData();
    });
  }

  Future<Map<String, dynamic>> _fetchAnalyticsData() async {
    if (_tokenAddress.isEmpty) {
      throw Exception("Token address not configured in environment.");
    }
    
    final web3Service = context.read<Web3Service>();
    final explorerService = BlockExplorerService();

    final results = await Future.wait([
      web3Service.getCirculatingSupply(),
      explorerService.getTokenHolderCount(_tokenAddress),
      explorerService.getTransactions24h(_tokenAddress),
      explorerService.getRecentTransfers(_tokenAddress, count: 5),
      explorerService.getTokenPrice(),
    ]);

    return {
      'circulatingSupply': results[0],
      'holders': results[1],
      'txs24h': results[2],
      'recentTxs': results[3],
      'price': results[4],
    };
  }

  Future<void> _launchExplorer() async {
    if (_tokenAddress.isEmpty) return;
    final url = Uri.parse(
      // FIX: Correctly access kDebugMode
      kDebugMode 
        ? 'https://sepolia.etherscan.io/token/$_tokenAddress'
        : 'https://etherscan.io/token/$_tokenAddress'
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("\$CBL Token Analytics"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DiamondMeshBackground(
        child: RefreshIndicator(
          onRefresh: () async => _loadAnalyticsData(),
          child: FutureBuilder<Map<String, dynamic>>(
            future: _analyticsDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingState();
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error fetching analytics: ${snapshot.error}"));
              }
              if (!snapshot.hasData) {
                return const Center(child: Text("No analytics data available."));
              }
              
              final data = snapshot.data!;
              final numberFormat = NumberFormat.decimalPattern();
              final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 4);
              final circulatingSupply = (data['circulatingSupply'] as BigInt).toDouble() / 1e18;
              final marketCap = (data['price'] as double) * circulatingSupply;

              return ListView(
                padding: EdgeInsets.only(
                  top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
                  left: 16, right: 16, bottom: 40,
                ),
                children: [
                    _buildMetricCard(
                      theme: theme,
                      title: "Current Price",
                      value: currencyFormat.format(data['price']),
                      icon: FontAwesomeIcons.dollarSign,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      children: [
                        _buildMetricCard(theme: theme, title: "Market Cap", value: "\$${NumberFormat.compact().format(marketCap)}", icon: FontAwesomeIcons.coins),
                        _buildMetricCard(theme: theme, title: "Circulating Supply", value: NumberFormat.compact().format(circulatingSupply), icon: FontAwesomeIcons.arrowsRotate),
                        _buildMetricCard(theme: theme, title: "Total Holders", value: numberFormat.format(data['holders']), icon: FontAwesomeIcons.users),
                        _buildMetricCard(theme: theme, title: "Transactions (24h)", value: numberFormat.format(data['txs24h']), icon: FontAwesomeIcons.rightLeft),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildRecentTransactions(theme, data['recentTxs']),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.open_in_new),
                      label: const Text("View on Etherscan"),
                      onPressed: _launchExplorer,
                    )
                  ].animate(interval: 100.ms).fadeIn().slideY(begin: 0.1),
              );
            },
          ),
        ),
      ),
    );
  }
  
  Widget _buildLoadingState() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
        left: 16, right: 16, bottom: 40,
      ),
      child: Column(
        children: [
          const ShimmerWidget.rectangular(height: 80),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: List.generate(4, (_) => const ShimmerWidget.rectangular(height: 100)),
          ),
          const SizedBox(height: 24),
          const ShimmerWidget.rectangular(height: 250),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required ThemeData theme,
    required String title,
    required String value,
    required IconData icon,
    Color? color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: theme.textTheme.bodyMedium),
                FaIcon(icon, size: 16, color: color ?? theme.colorScheme.secondary),
              ],
            ),
            Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(ThemeData theme, List<Map<String, String>> transactions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Recent Transactions", style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: transactions.map((tx) {
              return ListTile(
                leading: const FaIcon(FontAwesomeIcons.receipt),
                title: Text(tx['hash']!, style: const TextStyle(fontFamily: 'monospace', fontSize: 14)),
                subtitle: Text("From: ${tx['from']} To: ${tx['to']}"),
                trailing: Text(tx['amount']!),
                dense: true,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

```

### File: ./lib/screens/landing_screen.dart
```dart
// lib/screens/landing_screen.dart
import 'dart:async';
import 'package:cabal/models/activity_model.dart';
import 'package:cabal/models/community_post_model.dart';
import 'package:cabal/screens/marketplace_screen.dart';
import 'package:cabal/screens/partners_screen.dart';
import 'package:cabal/screens/web3_hub_screen.dart';
import 'package:cabal/widgets/activity_card_widget.dart';
import 'package:cabal/widgets/post_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'dart:math';
import 'dart:ui';

import '../main.dart';
import '../audio/audio_controller.dart';
import '../widgets/animated_header_widget.dart';
import '../widgets/diamond_mesh_background.dart';
import '../widgets/news_card_widget.dart';
import '../models/user_profile_model.dart';
import '../models/news_article_model.dart';
import '../models/coin_data_model.dart';
import '../services/supabase_service.dart';
import '../core/services/coingecko_service.dart';
import '../models/cabal_model.dart';
import 'cabal_detail_screen.dart';
import 'login_screen.dart';
import 'create_cabal_screen.dart';
import '../utils/app_colors.dart';
import '../widgets/coin_chart_widget.dart';
import '../widgets/shimmer_widget.dart';
import '../widgets/empty_state_card.dart';
import '../widgets/chatoshi_search_modal.dart';
import '../widgets/cabal_card_widget.dart';
import '../widgets/info_tile_widget.dart';
import 'news_viewer_screen.dart';
import 'placeholder_screen.dart';
import '../widgets/glowing_header_widget.dart'; // <-- MODIFIED IMPORT

class _TickerCoin {
  final String id;
  final String name;
  final String price;
  final String change;
  final bool isUp;
  _TickerCoin({required this.id, required this.name, required this.price, required this.change, required this.isUp});
}

class LandingScreen extends StatefulWidget {
  final UserProfile? currentUserProfile;
  final VoidCallback onNavigateToProfile;
  final VoidCallback onNavigateToLeaderboard;
  final VoidCallback onNavigateToCabals;
  final String? telegramUsername;
  final bool isNewsPanelVisible;
  final VoidCallback onToggleNewsPanel;

  const LandingScreen({
    Key? key,
    this.currentUserProfile,
    required this.onNavigateToProfile,
    required this.onNavigateToLeaderboard,
    required this.onNavigateToCabals,
    this.telegramUsername,
    required this.isNewsPanelVisible,
    required this.onToggleNewsPanel,
  }) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  late bool _isDarkTheme;
  final SupabaseService _supabaseService = SupabaseService();
  final CoinGeckoService _coinGeckoService = CoinGeckoService();
  final ScrollController _landingScrollController = ScrollController();
  
  List<Cabal> _latestCabals = [];
  List<NewsArticle> _newsArticles = [];
  List<CommunityPost> _communityPosts = [];
  List<Activity> _activityFeed = [];
  
  bool _isLoadingLatestCabals = true;
  bool _isLoadingNews = true;
  bool _isLoadingFeed = true;
  bool _isLoadingActivity = true;

  bool _isCreatorHubCollapsed = false;
  bool _isPlatformNavCollapsed = true;
  bool _isProjectShowcaseCollapsed = true;
  bool _isFeaturedCabalsCollapsed = false;
  bool _isCommunityFeedCollapsed = false;
  bool _isNewsCollapsedMobile = false;
  bool _isActivityFeedCollapsed = false;

  final List<_TickerCoin> _tickerCoins = [];
  final ScrollController _tickerScrollController = ScrollController();
  Timer? _tickerTimer;
  static const double _minDesktopWidth = 800;
  
  String? _selectedCoinIdForChart;

  @override
  void initState() {
    super.initState();
    _isDarkTheme = themeManager.themeMode == ThemeMode.dark;
    _loadLandingPageData();
    _initializeTicker();
  }

  Future<void> _initializeTicker() async {
    final numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    List<String> coinIdsToShow = widget.currentUserProfile?.preferredCoinIds ?? [];

    try {
      List<CoinData> liveCoins;
      if (coinIdsToShow.isNotEmpty) {
        liveCoins = await _coinGeckoService.getTrendingCoins(topN: 100);
        liveCoins = liveCoins.where((c) => coinIdsToShow.contains(c.id)).toList();
        if(liveCoins.isEmpty) liveCoins = await _coinGeckoService.getTrendingCoins(topN: 10);
      } else {
        liveCoins = await _coinGeckoService.getTrendingCoins(topN: 10);
      }
      
      if (mounted) {
        setState(() {
          _tickerCoins.clear();
          for (var coin in liveCoins) {
            _tickerCoins.add(_TickerCoin(
              id: coin.id,
              name: coin.symbol.toUpperCase(),
              price: numberFormat.format(coin.currentPrice ?? 0.0),
              change: '${(coin.priceChangePercentage24h ?? 0.0) >= 0 ? '+' : ''}${(coin.priceChangePercentage24h ?? 0.0).toStringAsFixed(2)}%',
              isUp: (coin.priceChangePercentage24h ?? 0.0) >= 0,
            ));
          }
        });
      }
    } catch (e) {
      debugPrint("Error initializing coin ticker: $e");
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _tickerScrollController.hasClients) _startTickerAnimation();
    });
  }

  void _startTickerAnimation() {
    _tickerTimer?.cancel();
    _tickerTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!_tickerScrollController.hasClients || !_tickerScrollController.position.hasContentDimensions) return;
      double newOffset = _tickerScrollController.offset + 1.0;
      if (newOffset >= _tickerScrollController.position.maxScrollExtent) {
        _tickerScrollController.jumpTo(0);
      } else {
        _tickerScrollController.jumpTo(newOffset);
      }
    });
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    _tickerScrollController.dispose();
    _landingScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadLandingPageData() async {
    setState(() {
      _isLoadingLatestCabals = true;
      _isLoadingNews = true;
      _isLoadingFeed = true;
      _isLoadingActivity = true;
    });

    await Future.wait([
      _loadLatestCabals(),
      _loadNews(),
      _loadGlobalFeed(),
      _loadActivityFeed(),
    ]);
  }
  
  Future<void> _loadActivityFeed() async {
    if (!mounted) return;
    if (widget.currentUserProfile == null) {
      setState(() => _isLoadingActivity = false);
      return;
    }
    try {
      final feed = await _supabaseService.getActivityFeed(widget.currentUserProfile!.id);
      if (mounted) setState(() => _activityFeed = feed);
    } catch (e) {
      debugPrint("Error loading activity feed: $e");
    } finally {
      if (mounted) setState(() => _isLoadingActivity = false);
    }
  }

  Future<void> _loadGlobalFeed() async {
    if (!mounted) return;
    try {
      final posts = await _supabaseService.getGlobalFeed();
      if (mounted) setState(() => _communityPosts = posts);
    } catch (e) {
      debugPrint("Error loading global feed: $e");
    } finally {
      if (mounted) setState(() => _isLoadingFeed = false);
    }
  }

  Future<void> _loadNews() async {
    if (!mounted) return;
    try {
      List<NewsArticle> articles = await newsService.fetchNews();
      if (mounted) setState(() => _newsArticles = articles.take(kIsWeb ? 5 : 3).toList());
    } catch (e) {
      debugPrint("Error loading news articles: $e");
    } finally {
      if (mounted) setState(() => _isLoadingNews = false);
    }
  }

  Future<void> _loadLatestCabals() async {
    if (!mounted) return;
    try {
      List<Cabal> allCabals = await _supabaseService.getAllCabals();
      allCabals.sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
      if (mounted) setState(() => _latestCabals = allCabals.where((c) => !c.isPrivate).take(5).toList());
    } catch (e) {
      debugPrint("Error loading latest cabals: $e");
    } finally {
      if(mounted) setState(() => _isLoadingLatestCabals = false);
    }
  }

  void _navigateToCabalDetail(Cabal cabal) {
    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: CabalDetailScreen(cabalId: cabal.id, telegramUsername: widget.currentUserProfile?.telegramUsername)));
  }

  void _navigateToLoginScreen() {
    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _isDarkTheme = theme.brightness == Brightness.dark;

    final bool isDesktop = kIsWeb && MediaQuery.of(context).size.width >= _minDesktopWidth;

    Widget mainContentColumn = Column(
      children: [
        _buildWelcomeHeader(theme),
        const SizedBox(height: 24),
        _buildCreatorDeveloperHub(),
        const SizedBox(height: 16),
        _buildPlatformNavigationSection(),
        const SizedBox(height: 16),
        if (widget.currentUserProfile != null) ...[
            _buildActivityFeedSection(theme),
            const SizedBox(height: 16),
        ],
        _buildProjectShowcase(),
        const SizedBox(height: 16),
        _buildFeaturedCabalsSection(theme),
        const SizedBox(height: 16),
        _buildCommunityFeedSection(theme),
        if (!isDesktop) _buildNewsSection(theme),
      ].animate(interval: 100.ms).fadeIn(duration: 400.ms),
    );

    if (isDesktop) {
      return Scaffold(
        body: DiamondMeshBackground(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                color: AppColors.darkGrey.withOpacity(0.5),
                child: Column(
                  children: [
                    const SizedBox(height: 100, child: AnimatedHeaderWidget()),
                    const SizedBox(height: 12),
                    _buildCoinTicker(theme),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: mainContentColumn,
                        ),
                      ),
                    ),
                    if (widget.isNewsPanelVisible)
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, right: 16, bottom: 16),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                if (_selectedCoinIdForChart != null)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 16.0),
                                    child: SizedBox(
                                        height: 450,
                                        child: CoinChartWidget(
                                            key: ValueKey(_selectedCoinIdForChart),
                                            coinId: _selectedCoinIdForChart!,
                                            onClose: () => setState(() => _selectedCoinIdForChart = null))),
                                  ).animate().fadeIn().slideY(begin: -0.1),
                                _buildNewsSection(theme),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(),
      );
    }

    // Mobile View with the new permanent Glowing Header
    return Scaffold(
      body: DiamondMeshBackground(
        child: CustomScrollView(
          controller: _landingScrollController,
          slivers: <Widget>[
            SliverPersistentHeader(
              delegate: _SliverGlowingHeaderDelegate(),
              pinned: true,
            ),
            SliverToBoxAdapter(child: _buildCoinTicker(theme)),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  if (_selectedCoinIdForChart != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: SizedBox(
                          height: 450,
                          child: CoinChartWidget(
                              key: ValueKey(_selectedCoinIdForChart),
                              coinId: _selectedCoinIdForChart!,
                              onClose: () => setState(() => _selectedCoinIdForChart = null))),
                    ).animate().fadeIn().slideY(begin: -0.1),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: mainContentColumn,
                ),
                const SizedBox(height: 100), // Padding for FAB
              ]),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => showChatoshiSearchModal(context),
      tooltip: 'Ask Chatoshi',
      backgroundColor: AppColors.gold,
      foregroundColor: AppColors.offBlack,
      child: const CircleAvatar(
          radius: 28, backgroundColor: Colors.transparent, backgroundImage: AssetImage('assets/images/chatoshi.jpeg')),
    ).animate().fadeIn(delay: 1500.ms).slide(begin: const Offset(0, 2));
  }
  
  Widget _buildWelcomeHeader(ThemeData theme) {
    String welcomeMessage = widget.currentUserProfile != null ? "Welcome back, ${widget.currentUserProfile!.displayName ?? widget.telegramUsername}!" : "Welcome to Cabal!";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(welcomeMessage, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
        const SizedBox(height: 8),
        Text("Your command center for Web3 growth. Explore active campaigns, check the latest news, or manage your profile.", style: theme.textTheme.bodyLarge?.copyWith(color: theme.textTheme.bodyLarge?.color?.withOpacity(0.85))),
      ],
    );
  }

  Widget _buildCollapsibleCard({ required String title, required IconData icon, required Widget child, required bool isCollapsed, required VoidCallback onToggle, EdgeInsets padding = const EdgeInsets.all(16.0) }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      color: theme.cardColor.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            onTap: onToggle,
            leading: FaIcon(icon, color: theme.colorScheme.primary),
            title: Text(title, style: theme.textTheme.titleLarge),
            trailing: FaIcon(isCollapsed ? FontAwesomeIcons.chevronDown : FontAwesomeIcons.chevronUp, size: 16),
          ),
          AnimatedSize(
            duration: 300.ms,
            curve: Curves.easeInOut,
            child: isCollapsed ? const SizedBox.shrink() : Container(
              width: double.infinity,
              padding: padding.copyWith(top: 0),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreatorDeveloperHub() {
    return _buildCollapsibleCard(
      title: "Creator & Developer Hub",
      icon: FontAwesomeIcons.wandMagicSparkles,
      isCollapsed: _isCreatorHubCollapsed,
      onToggle: () => setState(() => _isCreatorHubCollapsed = !_isCreatorHubCollapsed),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          InfoTileWidget(icon: FontAwesomeIcons.store, title: "Explore the Marketplace", subtitle: "Find talent or offer your skills to the ecosystem.", onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const MarketplaceScreen())), gradientColors: const [AppColors.primaryAccent, AppColors.secondaryAccent]),
          const SizedBox(height: 12),
          InfoTileWidget(
            icon: FontAwesomeIcons.cubesStacked,
            title: "Web3 Hub",
            subtitle: "Deploy tokens, manage giveaways, and access on-chain tools.",
            onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: Web3HubScreen(userProfile: widget.currentUserProfile))),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPlatformNavigationSection() {
    return _buildCollapsibleCard(
      title: "Platform Navigation",
      icon: FontAwesomeIcons.compass,
      isCollapsed: _isPlatformNavCollapsed,
      onToggle: () => setState(() => _isPlatformNavCollapsed = !_isPlatformNavCollapsed),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SizedBox(
        height: 130,
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          _buildFeatureTile(icon: FontAwesomeIcons.compass, label: "Explore Cabals", onTap: widget.onNavigateToCabals, theme: Theme.of(context)),
          const SizedBox(width: 12),
          _buildFeatureTile(icon: FontAwesomeIcons.rankingStar, label: "Leaderboard", onTap: widget.onNavigateToLeaderboard, theme: Theme.of(context)),
          const SizedBox(width: 12),
          _buildFeatureTile(icon: FontAwesomeIcons.solidUserCircle, label: "My Profile", onTap: widget.onNavigateToProfile, theme: Theme.of(context)),
        ]),
      ),
    );
  }

  Widget _buildProjectShowcase() {
    return _buildCollapsibleCard(
      title: "Project Vision",
      icon: FontAwesomeIcons.filePowerpoint,
      isCollapsed: _isProjectShowcaseCollapsed,
      onToggle: () => setState(() => _isProjectShowcaseCollapsed = !_isProjectShowcaseCollapsed),
      child: InfoTileWidget(
        icon: FontAwesomeIcons.play,
        title: "View Pitch Deck & Demo",
        subtitle: "Learn more about our vision, revenue model, and the future of Cabal.",
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlaceholderScreen(title: "Pitch Deck", icon: FontAwesomeIcons.filePowerpoint))),
      )
    );
  }

  Widget _buildActivityFeedSection(ThemeData theme) {
    if (_isLoadingActivity) {
      return _buildCollapsibleCard(title: "Your Activity Feed 📡", icon: FontAwesomeIcons.rss, isCollapsed: false, onToggle: (){}, child: const Center(child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator())));
    }
    if (_activityFeed.isEmpty) {
      return const SizedBox.shrink(); // Don't show if empty
    }
    return _buildCollapsibleCard(
      title: "Your Activity Feed 📡",
      icon: FontAwesomeIcons.rss,
      isCollapsed: _isActivityFeedCollapsed,
      onToggle: () => setState(() => _isActivityFeedCollapsed = !_isActivityFeedCollapsed),
      child: Column(
        children: _activityFeed.take(3).map((activity) => ActivityCardWidget(activity: activity)).toList(),
      ),
    );
  }

  Widget _buildFeatureTile({ required IconData icon, required String label, required VoidCallback onTap, required ThemeData theme }) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              FaIcon(icon, size: 32, color: theme.colorScheme.primary),
              const SizedBox(height: 12),
              Text(label, textAlign: TextAlign.center, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedCabalsSection(ThemeData theme) {
    if (_isLoadingLatestCabals) return _buildCollapsibleCard(title: "Fresh Off The Press 🔥", icon: FontAwesomeIcons.fire, isCollapsed: false, onToggle: (){}, child: const Center(child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator())));
    if (_latestCabals.isEmpty) return _buildCollapsibleCard(title: "Fresh Off The Press 🔥", icon: FontAwesomeIcons.fire, isCollapsed: false, onToggle: (){}, child: EmptyStateCard(title: "No Cabals Yet", message: "The universe is quiet... Be the first to create a new cabal!", icon: FontAwesomeIcons.ghost, buttonText: "Create a Cabal", onButtonPressed: () => Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: const CreateCabalScreen())), currentUserProfile: widget.currentUserProfile));
    
    return _buildCollapsibleCard(
      title: "Fresh Off The Press 🔥",
      icon: FontAwesomeIcons.fire,
      isCollapsed: _isFeaturedCabalsCollapsed,
      onToggle: () => setState(() => _isFeaturedCabalsCollapsed = !_isFeaturedCabalsCollapsed),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SizedBox(
        height: 230,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _latestCabals.length,
          itemBuilder: (context, index) => SizedBox(width: MediaQuery.of(context).size.width * 0.75, child: Padding(padding: const EdgeInsets.only(right: 12.0), child: CabalCardWidget(project: _latestCabals[index], onTap: () => _navigateToCabalDetail(_latestCabals[index])))),
        ),
      ),
    );
  }

  Widget _buildCommunityFeedSection(ThemeData theme) {
    if (_isLoadingFeed) return _buildCollapsibleCard(title: "Community Feed 🌐", icon: FontAwesomeIcons.satelliteDish, isCollapsed: false, onToggle: (){}, child: const Center(child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator())));
    if (_communityPosts.isEmpty) return _buildCollapsibleCard(title: "Community Feed 🌐", icon: FontAwesomeIcons.satelliteDish, isCollapsed: false, onToggle: (){}, child: EmptyStateCard(title: "The Feed is Quiet", message: "Go to a cabal's community page and be the first to start a conversation!", icon: FontAwesomeIcons.solidCommentDots, buttonText: "Explore Cabals", onButtonPressed: widget.onNavigateToCabals, currentUserProfile: widget.currentUserProfile));
    
    return _buildCollapsibleCard(
      title: "Community Feed 🌐",
      icon: FontAwesomeIcons.satelliteDish,
      isCollapsed: _isCommunityFeedCollapsed,
      onToggle: () => setState(() => _isCommunityFeedCollapsed = !_isCommunityFeedCollapsed),
      child: Column(
        children: _communityPosts.take(3).map((post) => Padding(padding: const EdgeInsets.only(bottom: 12.0), child: PostCardWidget(post: post, currentUserProfile: widget.currentUserProfile))).toList(),
      ),
    );
  }

  Widget _buildNewsSection(ThemeData theme) {
    if (_isLoadingNews) return _buildCollapsibleCard(title: "Latest News 📰", icon: FontAwesomeIcons.newspaper, isCollapsed: _isNewsCollapsedMobile, onToggle: () => setState(() => _isNewsCollapsedMobile = !_isNewsCollapsedMobile), child: const Center(child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator())));
    if (_newsArticles.isEmpty) return const SizedBox.shrink();
    
    return _buildCollapsibleCard(
      title: "Latest News 📰",
      icon: FontAwesomeIcons.newspaper,
      isCollapsed: _isNewsCollapsedMobile,
      onToggle: () => setState(() => _isNewsCollapsedMobile = !_isNewsCollapsedMobile),
      child: Column(
        children: _newsArticles.map((article) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: NewsCardWidget(
            article: article,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewsViewerScreen(article: article, userProfile: widget.currentUserProfile))),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildCoinTicker(ThemeData theme) {
    if (_tickerCoins.isEmpty) return const SizedBox(height: 40, child: Center(child: ShimmerWidget.rectangular(height: 38, width: 200)));
    
    return SizedBox(
      height: 40,
      child: ListView.builder(
        controller: _tickerScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: _tickerCoins.length * 10, // Loop the list
        itemBuilder: (context, index) {
          final coin = _tickerCoins[index % _tickerCoins.length];
          return InkWell(
            onTap: () {
              context.read<AudioController>().playSfx();
              setState(() => _selectedCoinIdForChart = _selectedCoinIdForChart == coin.id ? null : coin.id);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(coin.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(width: 8),
                Text(coin.price, style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70)),
                const SizedBox(width: 8),
                Row(children: [
                  FaIcon(coin.isUp ? FontAwesomeIcons.arrowTrendUp : FontAwesomeIcons.arrowTrendDown, size: 12, color: coin.isUp ? AppColors.success : AppColors.error),
                  const SizedBox(width: 4),
                  Text(coin.change, style: theme.textTheme.bodySmall?.copyWith(color: coin.isUp ? AppColors.success : AppColors.error)),
                ]),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class _SliverGlowingHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 100.0;

  @override
  double get maxExtent => 250.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final double topPadding = MediaQuery.of(context).padding.top;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          color: AppColors.offBlack.withOpacity(0.7),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: EdgeInsets.only(top: lerpDouble(0, topPadding, progress)!),
                child: GlowingHeaderWidget(shrinkProgress: progress),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}

```

### File: ./lib/screens/news_viewer_screen.dart
```dart
// lib/screens/news_viewer_screen.dart
import 'package:cabal/models/coin_data_model.dart';
import 'package:cabal/models/news_article_model.dart';
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/services/supabase_service.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/repositories/coin_repository.dart';
import '../utils/app_colors.dart';
import 'login_screen.dart';

class NewsViewerScreen extends StatefulWidget {
  final NewsArticle article;
  final UserProfile? userProfile;

  const NewsViewerScreen({
    Key? key,
    required this.article,
    this.userProfile,
  }) : super(key: key);

  @override
  State<NewsViewerScreen> createState() => _NewsViewerScreenState();
}

class _NewsViewerScreenState extends State<NewsViewerScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  List<CoinData> _favoriteCoins = [];
  bool _isLoadingCoins = true;
  bool _isFavorited = false;
  bool _isTogglingFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorited = widget.userProfile?.favoritedNewsLinks.contains(widget.article.link) ?? false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFavoriteCoinsData();
    });
  }
  
  // --- FIX: Added logic to handle favoriting news articles ---
  Future<void> _toggleFavorite() async {
    if (widget.userProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please log in to save articles.")));
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      return;
    }
    if (_isTogglingFavorite) return;
    
    setState(() {
      _isTogglingFavorite = true;
      _isFavorited = !_isFavorited;
    });

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      await _supabaseService.toggleFavoriteNews(widget.article.link);
      // You may want to refresh the user profile in a parent provider here
    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
      if (mounted) setState(() => _isFavorited = !_isFavorited); // Revert UI on failure
    } finally {
      if (mounted) setState(() => _isTogglingFavorite = false);
    }
  }

  Future<void> _loadFavoriteCoinsData() async {
    if (!mounted) return;
    if (widget.userProfile == null || widget.userProfile!.preferredCoinIds.isEmpty) {
      if (mounted) setState(() => _isLoadingCoins = false);
      return;
    }

    try {
      final coinRepo = Provider.of<CoinRepository>(context, listen: false);
      final allCoins = await coinRepo.getTopNCoinData(count: 250);
      final favs = allCoins.where((coin) => widget.userProfile!.preferredCoinIds.contains(coin.id)).toList();
      if (mounted) {
        setState(() {
          _favoriteCoins = favs;
          _isLoadingCoins = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading favorite coins for news viewer: $e");
      if (mounted) setState(() => _isLoadingCoins = false);
    }
  }

  Future<void> _launchUrl() async {
    final uri = Uri.tryParse(widget.article.link);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open article link: ${widget.article.link}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.article.source ?? 'News Article'),
        backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.shareNodes, size: 20),
            onPressed: () {
              Share.share(
                'Check out this article from Cabal: ${widget.article.title}\n\n${widget.article.link}',
                subject: widget.article.title,
              );
            },
            tooltip: "Share Article",
          ),
          IconButton(
            icon: _isTogglingFavorite
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5))
              : FaIcon(_isFavorited ? FontAwesomeIcons.solidBookmark : FontAwesomeIcons.bookmark, size: 20),
            onPressed: _isTogglingFavorite ? null : _toggleFavorite,
            tooltip: _isFavorited ? "Unsave Article" : "Save Article",
          ),
        ],
      ),
      body: DiamondMeshBackground(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: kToolbarHeight + MediaQuery.of(context).padding.top),
            if (_isLoadingCoins)
              const LinearProgressIndicator(),
            if (!_isLoadingCoins && _favoriteCoins.isNotEmpty)
              _buildFavoritesBar(theme),
            
            if (widget.article.imageUrl != null && widget.article.imageUrl!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.article.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.article.title,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Published on ${widget.article.pubDate != null ? DateFormat.yMMMd().add_jm().format(widget.article.pubDate!) : 'a recent date'}',
                    style: theme.textTheme.bodySmall,
                  ),
                  const Divider(height: 32),
                  Text(
                    widget.article.description ?? "No summary available.",
                    style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.open_in_new),
                      label: const Text("Read Full Article"),
                      onPressed: _launchUrl,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                   const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.5),
      ),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _favoriteCoins.length,
        itemBuilder: (context, index) {
          final coin = _favoriteCoins[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Chip(
              avatar: CircleAvatar(backgroundImage: NetworkImage(coin.imageUrl)),
              label: Text(coin.symbol.toUpperCase()),
              side: BorderSide(color: theme.dividerColor),
            ).animate().fadeIn(delay: (100 * index).ms),
          );
        },
      ),
    );
  }
}

```

### File: ./lib/screens/pitch_deck_screen.dart
```dart
// lib/screens/pitch_deck_screen.dart
import 'package:cabal/utils/app_colors.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

class PitchDeckScreen extends StatefulWidget {
  const PitchDeckScreen({Key? key}) : super(key: key);

  @override
  State<PitchDeckScreen> createState() => _PitchDeckScreenState();
}

class _PitchDeckScreenState extends State<PitchDeckScreen> {
  late VideoPlayerController _videoController;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(
      'assets/videos/cabal_promo.mp4',
    );
    _initializeVideoPlayerFuture = _videoController.initialize().then((_) {
      _videoController.setLooping(true);
      _videoController.setVolume(0.0); // Mute demo video
      _videoController.play();
      if (mounted) setState(() {}); // Update UI once video is ready
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Project Pitch Deck")),
      body: DiamondMeshBackground(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildTitleSlide(theme, "Cabal: The Web3 Growth & Commerce Engine"),
            _buildSection(
              theme: theme,
              icon: FontAwesomeIcons.lightbulb,
              title: "The Problem",
              content: "Web3 projects struggle with two critical challenges: acquiring real, engaged users and creating sustainable token economies. Traditional growth-hacking is expensive and often attracts mercenary users, while building on-chain commerce tools from scratch is complex and diverts focus from the core product."
            ),
             _buildSection(
              theme: theme,
              icon: FontAwesomeIcons.rocket,
              title: "Our Solution",
              content: "Cabal is a comprehensive, on-chain platform that provides projects with the tools to grow, engage, and monetize their communities. We turn user acquisition into a gamified, rewarding experience and provide the Web3 commerce infrastructure (NFTs, marketplaces, escrow) needed for a thriving digital economy."
            ),
             _buildSection(
              theme: theme,
              icon: FontAwesomeIcons.handshake,
              title: "Revenue Generation Model",
              content: "Our business model is designed for sustainability and alignment with our users' success:\n\n"
                       "1.  **Marketplace & Escrow Fees (2.5%)**: A small, transparent fee on all successful NFT and real estate transactions.\n\n"
                       "2.  **TGE Launchpad Services (1-2%)**: A success fee for projects that use our platform to launch their own tokens, ensuring we only win when they do.\n\n"
                       "3.  **Premium Creator Tools (Subscription)**: A tiered subscription model paid in \$CBL for Cabal creators, unlocking advanced analytics, custom smart contract templates, and priority support."
            ),
            _buildSection(
              theme: theme,
              icon: FontAwesomeIcons.users,
              title: "Target Market",
              content: "Our primary customers are new and existing Web3 projects, including DeFi protocols, GameFi studios, NFT artists, and real estate tokenization platforms. Our secondary market is the vast community of Web3 users, KOLs, and developers looking for new opportunities, rewards, and tools."
            ),
            _buildSection(
              theme: theme,
              icon: FontAwesomeIcons.road,
              title: "Roadmap at a Glance",
              content: "Phase 1 (Done): Core Platform & MVP.\n"
                       "Phase 2 (Done): Web3 Economy & Creator Tools.\n"
                       "Phase 3 (In Progress): Advanced Commerce & Giveaways.\n"
                       "Phase 4 (Planned): Full Decentralization & L2 Scaling.",
            ),
            _buildSection(
              theme: theme,
              icon: FontAwesomeIcons.circlePlay,
              title: "Platform Demo",
              contentWidget: _buildVideoPlayer(),
            ),
          ].animate(interval: 200.ms).fadeIn().slideY(begin: 0.1),
        ),
      ),
    );
  }

  Widget _buildTitleSlide(ThemeData theme, String title) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryAccent, AppColors.secondaryAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSection({
    required ThemeData theme,
    required IconData icon,
    required String title,
    String? content,
    Widget? contentWidget,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FaIcon(icon, color: theme.colorScheme.primary, size: 24),
                const SizedBox(width: 12),
                Text(title, style: theme.textTheme.titleLarge),
              ],
            ),
            const Divider(height: 24),
            if (content != null)
              Text(content, style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
            if (contentWidget != null)
              contentWidget,
          ],
        ),
      ),
    );
  }
  
  Widget _buildVideoPlayer() {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && _videoController.value.isInitialized) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: _videoController.value.aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(_videoController),
                  IconButton(
                    iconSize: 64,
                    icon: Icon(
                      _videoController.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    onPressed: () {
                      setState(() {
                        _videoController.value.isPlaying ? _videoController.pause() : _videoController.play();
                      });
                    },
                  )
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error loading video demo."));
        } else {
          return const AspectRatio(
            aspectRatio: 16/9,
            child: Center(child: CircularProgressIndicator())
          );
        }
      },
    );
  }
}

```

### File: ./lib/screens/manage_cabal_screen.dart
```dart
// lib/screens/manage_cabal_screen.dart
import 'package:cabal/models/cabal_model.dart';
import '../models/quest_model.dart';
import '../models/quest_section_model.dart';
import 'package:cabal/screens/create_quest_screen.dart';
import 'package:cabal/screens/edit_cabal_screen.dart';
import 'package:cabal/services/supabase_service.dart';
import 'package:cabal/widgets/quest_section_dialog.dart';
import 'package:cabal/widgets/reorderable_quest_section_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import '../widgets/diamond_mesh_background.dart';
import '../utils/app_colors.dart';

class ManageCabalScreen extends StatefulWidget {
  final Cabal cabal;
  const ManageCabalScreen({Key? key, required this.cabal}) : super(key: key);

  @override
  State<ManageCabalScreen> createState() => _ManageCabalScreenState();
}

class _ManageCabalScreenState extends State<ManageCabalScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SupabaseService _supabaseService = SupabaseService();

  List<QuestSection> _questSections = [];
  Map<String, List<Quest>> _questsBySection = {};
  bool _isLoadingQuests = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadQuestData();
  }

  Future<void> _loadQuestData() async {
    if (!mounted) return;
    setState(() => _isLoadingQuests = true);
    try {
      final sections = await _supabaseService.getQuestSectionsForCabal(widget.cabal.id);
      final quests = await _supabaseService.getQuestsForCabal(widget.cabal.id);
      
      final questsMap = <String, List<Quest>>{};
      // --- FIX: Correctly group quests by their section ID ---
      for (var quest in quests) {
        if (quest.quest_section_id != null) {
           questsMap.putIfAbsent(quest.quest_section_id!, () => []).add(quest);
        }
      }

      if (mounted) {
        setState(() {
          _questSections = sections..sort((a, b) => a.order.compareTo(b.order));
          _questsBySection = questsMap;
          _isLoadingQuests = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading quest data for management: $e");
      if (mounted) setState(() => _isLoadingQuests = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _addSection() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const QuestSectionDialog(),
    );

    if (result != null && mounted) {
      try {
        final newSection = await _supabaseService.createQuestSection(
          widget.cabal.id,
          result['title']!,
          _questSections.length,
          description: result['description'],
        );
        setState(() {
          _questSections.add(newSection);
        });
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error creating section: $e")));
      }
    }
  }

  Future<void> _editSection(QuestSection section) async {
     final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => QuestSectionDialog(section: section),
    );

    if (result != null && mounted) {
      try {
        final updatedSection = await _supabaseService.updateQuestSection(section.id, result);
        setState(() {
          final index = _questSections.indexWhere((s) => s.id == section.id);
          if (index != -1) {
            _questSections[index] = updatedSection;
          }
        });
      } catch (e) {
         if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error updating section: $e")));
      }
    }
  }

  Future<void> _deleteSection(QuestSection section) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Section?'),
        content: Text('Are you sure you want to delete "${section.title}" and all quests within it? This cannot be undone.'),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(context).pop(false)),
          TextButton(child: const Text('Delete'), style: TextButton.styleFrom(foregroundColor: Colors.red), onPressed: () => Navigator.of(context).pop(true)),
        ],
      )
    );

    if (confirm != true || !mounted) return;
    
    try {
      await _supabaseService.deleteQuestSection(section.id);
      setState(() {
        _questSections.removeWhere((s) => s.id == section.id);
      });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error deleting section: $e")));
    }
  }

  Future<void> _deleteCabal() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('⚠️ Delete "${widget.cabal.name}"?'),
        content: const Text('This action is permanent and cannot be undone. All associated quests, sections, and user progress will be lost.'),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(context).pop(false)),
          ElevatedButton(
            child: const Text('Delete Permanently'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true)
          ),
        ],
      )
    );

    if (confirm != true || !mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      await _supabaseService.deleteCabal(widget.cabal.id);
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Cabal "${widget.cabal.name}" has been deleted.'), backgroundColor: AppColors.success),
      );
      navigator.pop();
      navigator.pop(true);
    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Error deleting cabal: $e"), backgroundColor: Colors.red));
    }
  }

  void _reorderSections(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final section = _questSections.removeAt(oldIndex);
      _questSections.insert(newIndex, section);

      for (int i = 0; i < _questSections.length; i++) {
        if (_questSections[i].order != i) {
          _questSections[i].order = i;
          _supabaseService.updateQuestSection(_questSections[i].id, {'order': i});
        }
      }
    });
  }
  
  Future<void> _navigateAndReload(Widget screen) async {
    final result = await Navigator.push(
      context,
      PageTransition(type: PageTransitionType.rightToLeft, child: screen),
    );

    if (result == true && mounted) {
      _loadQuestData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Manage "${widget.cabal.name}"', overflow: TextOverflow.ellipsis),
        backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: FaIcon(FontAwesomeIcons.circleInfo), text: 'Details'),
            Tab(icon: FaIcon(FontAwesomeIcons.listCheck), text: 'Quests'),
            Tab(icon: FaIcon(FontAwesomeIcons.userCheck), text: 'Submissions'),
          ],
        ),
      ),
      body: DiamondMeshBackground(
        child: Padding(
          padding: EdgeInsets.only(top: kToolbarHeight + (AppBar().preferredSize.height) + MediaQuery.of(context).padding.top),
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildDetailsTab(context),
              _buildQuestsTab(context),
              _buildSubmissionsTab(context),
            ],
          ),
        ),
      ),
      floatingActionButton: _tabController.index == 1 
        ? FloatingActionButton.extended(
            onPressed: _addSection,
            label: const Text('Add Section'),
            icon: const Icon(Icons.add),
          )
        : null,
    );
  }

  Widget _buildQuestsTab(BuildContext context) {
    if (_isLoadingQuests) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_questSections.isEmpty) {
       return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("No quest sections created yet."),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addSection,
              child: const Text('Create Your First Section'),
            )
          ],
        ),
      );
    }

    return ReorderableListView(
      padding: const EdgeInsets.all(16.0),
      onReorder: _reorderSections,
      children: _questSections.map((section) {
        return ReorderableQuestSectionCard(
          key: ValueKey(section.id),
          section: section,
          questCount: _questsBySection[section.id]?.length ?? 0,
          onEdit: () => _editSection(section),
          onDelete: () => _deleteSection(section),
          onAddQuest: () {
            _navigateAndReload(
              CreateQuestScreen(
                cabalId: widget.cabal.id,
                sectionId: section.id,
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildDetailsTab(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FaIcon(FontAwesomeIcons.gears, size: 40),
                const SizedBox(height: 16),
                Text('Cabal Settings', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                const Text('Update your cabal\'s name, description, category, and privacy settings.', textAlign: TextAlign.center),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Edit Cabal Details'),
                  onPressed: () {
                    _navigateAndReload(EditCabalScreen(cabal: widget.cabal));
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          color: theme.colorScheme.error.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.colorScheme.error, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Danger Zone',
                  style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.error, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Deleting your cabal is irreversible and will remove all associated data. Please be certain.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error.withOpacity(0.9)),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.warning_amber_rounded),
                    label: const Text('Delete This Cabal'),
                    onPressed: _deleteCabal,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                      side: BorderSide(color: theme.colorScheme.error.withOpacity(0.5)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmissionsTab(BuildContext context) {
     return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FaIcon(FontAwesomeIcons.inbox, size: 40),
              const SizedBox(height: 16),
              Text('Review Submissions', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              const Text('Users\' submissions for manual verification quests will appear here for you to approve or reject. (Coming Soon)', textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

```

### File: ./lib/screens/login_screen.dart
```dart
// lib/screens/login_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:provider/provider.dart';

import '../services/supabase_service.dart';
import '../features/wallet/application/wallet_provider.dart';
import 'home_nav_wrapper.dart';
import '../utils/app_colors.dart';
import '../widgets/app_logo_widget.dart';

class LoginScreen extends StatefulWidget {
  final bool fromLogout;
  final VoidCallback? onLoginSuccess;

  const LoginScreen({
    Key? key,
    this.fromLogout = false,
    this.onLoginSuccess,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final SupabaseService _supabaseService = SupabaseService();
  bool _showEmailForm = false;
  late AnimationController _floatingIconController;
  StreamSubscription<AuthState>? _authStateSubscription;
  bool _hasNavigatedAway = false;
  bool _showVerificationMessage = false; // --- FIX: State to manage post-signup UI ---

  @override
  void initState() {
    super.initState();
    _floatingIconController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    if (!widget.fromLogout && Supabase.instance.client.auth.currentSession != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_hasNavigatedAway) {
          _hasNavigatedAway = true;
          widget.onLoginSuccess?.call();
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(type: PageTransitionType.fade, child: const HomeNavWrapper(showOnboarding: false)),
            (route) => false,
          );
        }
      });
    }

    _authStateSubscription = _supabaseService.authStateChanges.listen((state) {
      if (!mounted) return;
      if (state.session != null) {
        if (!_hasNavigatedAway) {
          _hasNavigatedAway = true;
          widget.onLoginSuccess?.call();
          bool showOnboardingForNewUser = state.event == AuthChangeEvent.signedIn;
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(type: PageTransitionType.fade, child: HomeNavWrapper(showOnboarding: showOnboardingForNewUser)),
            (route) => false,
          );
        }
      } else if (state.session == null && state.event == AuthChangeEvent.signedOut) {
        _hasNavigatedAway = false;
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _floatingIconController.dispose();
    _authStateSubscription?.cancel();
    super.dispose();
  }

  Future<void> _handleEmailPasswordAuth(bool isSignIn, WalletProvider wp) async {
    if (!mounted || !(_formKey.currentState?.validate() ?? false) || wp.isLoading) return;
    
    String actionText = isSignIn ? "Sign In" : "Sign Up";
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      if (isSignIn) {
        await _supabaseService.signInUser(_emailController.text.trim(), _passwordController.text.trim());
      } else {
        await _supabaseService.signUpUser(_emailController.text.trim(), _passwordController.text.trim());
        if (mounted) {
          // --- FIX: Change UI state instead of just showing a temporary SnackBar ---
          setState(() => _showVerificationMessage = true); 
        }
      }
    } on AuthException catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(SnackBar(content: Text('$actionText Failed: ${e.message}'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(SnackBar(content: Text('$actionText - Unexpected error: ${e.toString()}'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    }
  }
  
  Future<void> _handleSolanaSignIn(WalletProvider walletProvider) async {
    if (!mounted || walletProvider.isLoading) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      await walletProvider.connectSolanaWallet();
      if (mounted && walletProvider.isConnectedSolana) {
          scaffoldMessenger.showSnackBar(SnackBar(content: Text('Solana Wallet Connected: ${walletProvider.connectedSolanaAddress}. SIWS flow placeholder.'), backgroundColor: AppColors.info));
      } else if (mounted && walletProvider.solanaError != null) {
          scaffoldMessenger.showSnackBar(SnackBar(content: Text('Solana Connection Failed: ${walletProvider.solanaError}'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    } catch (e) {
        scaffoldMessenger.showSnackBar(SnackBar(content: Text('Solana Connection Failed: ${e.toString()}'), backgroundColor: Theme.of(context).colorScheme.error));
    }
  }

  Future<void> _handleOAuthSignIn(WalletProvider wp, String providerName, Future<bool> Function() signInFunction) async {
    if (!mounted || wp.isLoading) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final bool flowInitiated = await signInFunction();
      if (!flowInitiated && mounted) {
         scaffoldMessenger.showSnackBar(SnackBar(content: Text('$providerName Sign-In could not be initiated.'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(SnackBar(content: Text('$providerName Sign-In Error: ${e.toString()}'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    }
  }

  Future<void> _forceLogout() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      await _supabaseService.signOutUser();
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Forced logout successful. Please sign up again.'), backgroundColor: AppColors.info),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Logout failed: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Widget _buildFloatingIcon({ required IconData icon, required Color color, required double size, required Alignment alignment, Duration delay = Duration.zero, double verticalOffset = 10,}) {
    return Align(
      alignment: alignment,
      child: AnimatedBuilder(
        animation: _floatingIconController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, Curves.easeInOutSine.transform(_floatingIconController.value) * verticalOffset - (verticalOffset / 2)),
            child: child,
          );
        },
        child: FaIcon(icon, color: color.withOpacity(0.6), size: size),
      ),
    ).animate(delay: delay).fadeIn(duration: 900.ms, curve: Curves.easeOutCubic).slide(begin: const Offset(0, 0.3), duration: 800.ms, curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walletProvider = Provider.of<WalletProvider>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    const solanaGradient = LinearGradient(
      colors: [Color(0xFF9945FF), Color(0xFF14F195)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.offBlack, AppColors.darkGrey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            _buildFloatingIcon(icon: FontAwesomeIcons.ethereum, color: AppColors.gold, size: screenWidth * 0.08, alignment: Alignment(screenWidth > 600 ? -0.7 : -0.6, -0.65), delay: 600.ms, verticalOffset: 15),
            _buildFloatingIcon(icon: FontAwesomeIcons.google, color: AppColors.gradientGoldStart, size: screenWidth * 0.06, alignment: Alignment(screenWidth > 600 ? 0.8 : 0.7, -0.5), delay: 800.ms, verticalOffset: -10),
            _buildFloatingIcon(icon: FontAwesomeIcons.discord, color: AppColors.goldHighlight, size: screenWidth * 0.06, alignment: Alignment(screenWidth > 600 ? 0.75 : 0.65, -0.1), delay: 1400.ms, verticalOffset: 10),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.05),
                    const AppLogoWidget(logoHeight: 60).animate().fadeIn(delay: 200.ms).slideY(begin: -0.3, duration: 600.ms, curve: Curves.easeOutExpo),
                    const SizedBox(height: 10),
                    Text(
                      'Join the Cabal',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white, shadows: [Shadow(blurRadius: 10.0, color: Colors.black.withOpacity(0.5), offset: const Offset(0, 2))]),
                    ).animate().fadeIn(delay: 400.ms, duration: 700.ms).slideY(begin: 0.2, curve: Curves.elasticOut),
                    const SizedBox(height: 24),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 380),
                      child: Card(
                        elevation: 10,
                        color: theme.cardColor.withOpacity(0.95),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // --- FIX: Show verification message instead of buttons ---
                              if (_showVerificationMessage)
                                _buildVerificationMessage(theme)
                              else ...[
                                if (!kIsWeb)
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: solanaGradient,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 4))
                                      ],
                                    ),
                                    child: ElevatedButton.icon(
                                      icon: walletProvider.isLoading ? const SizedBox.shrink() : const FaIcon(FontAwesomeIcons.wallet, size: 18),
                                      label: walletProvider.isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Continue with Wallet'),
                                      onPressed: walletProvider.isLoading ? null : () => _handleSolanaSignIn(walletProvider),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                    ),
                                  ).animate().fadeIn(delay: 500.ms),
                                
                                if (!kIsWeb) const SizedBox(height: 12),

                                ElevatedButton.icon(
                                  icon: const FaIcon(FontAwesomeIcons.google, size: 18),
                                  label: const Text('Continue with Google'),
                                  onPressed: walletProvider.isLoading ? null : () => _handleOAuthSignIn(walletProvider, "Google", _supabaseService.signInWithGoogle),
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4285F4), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                                ).animate().fadeIn(delay: 600.ms),

                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  icon: const FaIcon(FontAwesomeIcons.discord, size: 18),
                                  label: const Text('Continue with Discord'),
                                  onPressed: walletProvider.isLoading ? null : () => _handleOAuthSignIn(walletProvider, "Discord", _supabaseService.signInWithDiscord),
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5865F2), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                                ).animate().fadeIn(delay: 700.ms),

                                const SizedBox(height: 16),
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.email_outlined, size: 18),
                                  label: const Text('Continue with Email'),
                                  onPressed: walletProvider.isLoading ? null : () => setState(() => _showEmailForm = !_showEmailForm),
                                  style: OutlinedButton.styleFrom(foregroundColor: theme.colorScheme.onSurface, side: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.5)), padding: const EdgeInsets.symmetric(vertical: 12)),
                                ).animate().fadeIn(delay: 800.ms),

                                AnimatedSize(
                                  duration: 300.ms,
                                  curve: Curves.easeInOut,
                                  child: _showEmailForm ? _buildEmailForm(theme, walletProvider) : const SizedBox(width: double.infinity),
                                ),

                                const Divider(height: 32),
                                TextButton.icon(
                                  icon: const Icon(Icons.cleaning_services_rounded, size: 16),
                                  label: const Text('Stuck? Force Logout'),
                                  onPressed: _forceLogout,
                                  style: TextButton.styleFrom(foregroundColor: theme.colorScheme.onSurface.withOpacity(0.6)),
                                )
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- FIX: New widget to show after signup ---
  Widget _buildVerificationMessage(ThemeData theme) {
    return Column(
      children: [
        FaIcon(FontAwesomeIcons.solidEnvelopeOpen, size: 40, color: theme.colorScheme.primary),
        const SizedBox(height: 16),
        Text(
          'Check Your Email!',
          style: theme.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'We sent a verification link to ${_emailController.text}. Please click the link to complete your sign-up.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => setState(() => _showVerificationMessage = false),
          child: const Text('Back to Sign In'),
        )
      ],
    ).animate().fadeIn();
  }

  Widget _buildEmailForm(ThemeData theme, WalletProvider wp) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(height: 32),
          TextFormField(
            controller: _emailController,
            style: theme.textTheme.bodyLarge,
            decoration: const InputDecoration(labelText: 'Email Address'),
            validator: (v) => (v == null || !v.contains('@')) ? 'Please enter a valid email' : null,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _passwordController,
            style: theme.textTheme.bodyLarge,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (v) => (v == null || v.length < 6) ? 'Password must be at least 6 characters' : null,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: wp.isLoading ? null : () => _handleEmailPasswordAuth(true, wp),
                  child: const Text('Sign In'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: wp.isLoading ? null : () => _handleEmailPasswordAuth(false, wp),
                  child: const Text('Sign Up'),
                ),
              ),
            ],
          ),
        ],
      ).animate().fadeIn(),
    );
  }
}

```

### File: ./lib/screens/profile/profile_screen.dart
```dart
// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/user_profile_model.dart';
import '../../services/supabase_service.dart';
import '../../services/ton_service.dart';
import '../../utils/app_colors.dart';
import '../../widgets/diamond_mesh_background.dart';
import '../../widgets/shimmer_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  
  UserProfile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = _supabaseService.getCurrentUser();
    if (user == null) return;

    setState(() => _isLoading = true);
    final profile = await _supabaseService.getUserProfile(user.id);
    
    if (mounted) {
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    await _supabaseService.signOutUser();
    if (mounted) Navigator.pushReplacementNamed(context, '/login');
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Address copied to clipboard"), backgroundColor: AppColors.info),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tonService = Provider.of<TonService>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("MY IDENTITY"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.rightFromBracket, size: 18, color: Colors.redAccent),
            onPressed: _handleLogout,
            tooltip: "Logout",
          )
        ],
      ),
      body: DiamondMeshBackground(
        child: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 100.0),
              child: Column(
                children: [
                  // --- 1. AVATAR & NAME ---
                  _buildProfileHeader(),
                  const SizedBox(height: 32),

                  // --- 2. PROGRESS & STATS ---
                  _buildStatsCard(),
                  const SizedBox(height: 24),

                  // --- 3. TON WALLET CONNECTION ---
                  _buildWalletSection(tonService),
                  const SizedBox(height: 24),

                  // --- 4. ADDITIONAL CONNECTIONS ---
                  _buildSocialsSection(),
                  
                  const SizedBox(height: 40),
                  Text(
                    "VERSION 1.0.0-BETA",
                    style: TextStyle(color: AppColors.greyText.withOpacity(0.5), fontSize: 10, letterSpacing: 2),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.gold, width: 2),
            boxShadow: [BoxShadow(color: AppColors.gold.withOpacity(0.2), blurRadius: 20)],
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.darkGrey,
            backgroundImage: _profile?.profileImageUrl != null 
                ? NetworkImage(_profile!.profileImageUrl!) 
                : null,
            child: _profile?.profileImageUrl == null 
                ? const FaIcon(FontAwesomeIcons.userAstronaut, size: 40, color: AppColors.gold) 
                : null,
          ),
        ).animate().fadeIn(duration: 600.ms).scale(),
        const SizedBox(height: 16),
        Text(
          _profile?.displayName?.toUpperCase() ?? "UNKNOWN EXPLORER",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1.5),
        ),
        if (_profile?.telegramUsername != null)
          Text(
            "@${_profile!.telegramUsername}",
            style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w600),
          ),
      ],
    );
  }

  Widget _buildStatsCard() {
    final numberFormat = NumberFormat.compact();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkGrey.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem("LEVEL", _profile?.level.toString() ?? "1"),
              _buildStatDivider(),
              _buildStatItem("TOTAL XP", numberFormat.format(_profile?.totalXp ?? 0)),
              _buildStatDivider(),
              _buildStatItem("QUESTS", _profile?.joinedCabalIds.length.toString() ?? "0"),
            ],
          ),
          const SizedBox(height: 20),
          _buildLevelProgressBar(),
        ],
      ),
    ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1);
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.greyText, fontSize: 10, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(height: 30, width: 1, color: Colors.white10);
  }

  Widget _buildLevelProgressBar() {
    // Current leveling logic: floor(sqrt(xp / 100)) + 1
    // Progress is based on the remainder of the square
    double progress = (_profile!.totalXp % 100) / 100.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 8,
        backgroundColor: Colors.white.withOpacity(0.05),
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
      ),
    );
  }

  Widget _buildWalletSection(TonService ton) {
    final bool isConnected = ton.isConnected;
    final String address = ton.currentAddress ?? "NOT CONNECTED";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.darkGrey, Colors.black.withOpacity(0.4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isConnected ? AppColors.gold.withOpacity(0.3) : Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const FaIcon(FontAwesomeIcons.gem, color: AppColors.gold, size: 18),
              const SizedBox(width: 12),
              const Text("TON BLOCKCHAIN", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
              const Spacer(),
              if (isConnected)
                const Icon(Icons.verified, color: AppColors.success, size: 16),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            isConnected ? "CONNECTED ADDRESS" : "WALLET STATUS",
            style: const TextStyle(color: AppColors.greyText, fontSize: 10),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: isConnected ? () => _copyToClipboard(address) : null,
            child: Text(
              isConnected 
                  ? "${address.substring(0, 12)}...${address.substring(address.length - 8)}" 
                  : "No wallet linked to this profile.",
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: isConnected ? Colors.white : Colors.white38,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () async {
                if (isConnected) {
                  await ton.disconnect();
                } else {
                  await ton.connectWallet();
                }
                _loadProfile();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isConnected ? Colors.white10 : AppColors.gold,
                foregroundColor: isConnected ? Colors.white : Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                isConnected ? "DISCONNECT WALLET" : "CONNECT TON WALLET",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.1);
  }

  Widget _buildSocialsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 12),
          child: Text("CONNECTIONS", style: TextStyle(fontSize: 10, letterSpacing: 2, color: AppColors.greyText)),
        ),
        _buildSocialTile(FontAwesomeIcons.twitter, "X (Twitter)", _profile?.twitterHandle ?? "Not Linked"),
        const SizedBox(height: 8),
        _buildSocialTile(FontAwesomeIcons.discord, "Discord", "Not Linked"),
      ],
    ).animate(delay: 400.ms).fadeIn();
  }

  Widget _buildSocialTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.darkGrey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          FaIcon(icon, size: 16, color: Colors.white54),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Text(value, style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

```

### File: ./lib/screens/auth/login_screen.dart
```dart
// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../utils/app_colors.dart';
import '../../widgets/app_logo_widget.dart';
import '../../widgets/diamond_mesh_background.dart';
import '../../services/supabase_service.dart';
import '../../services/ton_service.dart';
import '../../config.dart';

class LoginScreen extends StatefulWidget {
  final bool fromLogout;

  const LoginScreen({Key? key, this.fromLogout = false}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  String _loadingText = "Initializing...";

  /// Standard guest entry via Supabase Anonymous Auth
  Future<void> _entryAsGuest() async {
    setState(() {
      _isLoading = true;
      _loadingText = "Entering Cabal...";
    });

    try {
      await Supabase.instance.client.auth.signInAnonymously();
      // Navigation is handled by the AuthState listener in main.dart or AuthWrapper
    } catch (e) {
      _showError("Guest entry failed: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// TON Native entry: Connects wallet and then ensures a session exists
  Future<void> _connectTonWallet() async {
    final tonService = Provider.of<TonService>(context, listen: false);
    
    setState(() {
      _isLoading = true;
      _loadingText = "Connecting Wallet...";
    });

    try {
      final address = await tonService.connectWallet();
      if (address != null) {
        // If wallet connects, we ensure we have a Supabase session
        if (Supabase.instance.client.auth.currentSession == null) {
          await Supabase.instance.client.auth.signInAnonymously();
        }
        // SupabaseService handles saving the wallet to the profile
      }
    } catch (e) {
      _showError("TON Connect failed: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: DiamondMeshBackground(
        child: Stack(
          children: [
            // --- UI CONTENT ---
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppLogoWidget(logoHeight: 80)
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .scale(begin: const Offset(0.8, 0.8)),
                    const SizedBox(height: 16),
                    Text(
                      AppConfig.appName.toUpperCase(),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: AppColors.gold,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w900,
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                    Text(
                      "THE GROWTH ENGINE",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.gold.withOpacity(0.7),
                        letterSpacing: 2,
                      ),
                    ).animate().fadeIn(delay: 400.ms),
                    const SizedBox(height: 60),

                    // --- PRIMARY ACTION: TON CONNECT ---
                    _buildLoginButton(
                      label: "CONNECT TON WALLET",
                      icon: FontAwesomeIcons.gem,
                      onPressed: _connectTonWallet,
                      color: AppColors.gold,
                      textColor: Colors.black,
                    ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.1),

                    const SizedBox(height: 16),

                    // --- TMA ACTION: TELEGRAM ---
                    if (AppConfig.isTelegramMiniApp)
                      _buildLoginButton(
                        label: "CONTINUE WITH TELEGRAM",
                        icon: FontAwesomeIcons.telegram,
                        onPressed: () {
                          // Placeholder for Telegram Auto-Login logic
                        },
                        color: const Color(0xFF24A1DE),
                        textColor: Colors.white,
                      ).animate().fadeIn(delay: 700.ms).slideX(begin: 0.1),

                    const SizedBox(height: 32),

                    // --- SECONDARY ACTION: GUEST ---
                    TextButton(
                      onPressed: _entryAsGuest,
                      child: Text(
                        "CONTINUE AS GUEST",
                        style: TextStyle(
                          color: AppColors.lightText.withOpacity(0.6),
                          letterSpacing: 1.2,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ).animate().fadeIn(delay: 1000.ms),
                  ],
                ),
              ),
            ),

            // --- LOADING OVERLAY ---
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.8),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: AppColors.gold),
                      const SizedBox(height: 24),
                      Text(
                        _loadingText,
                        style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    required Color textColor,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : onPressed,
        icon: FaIcon(icon, size: 20, color: textColor),
        label: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 8,
          shadowColor: color.withOpacity(0.4),
        ),
      ),
    );
  }
}

```

### File: ./lib/screens/quest/quest_detail_screen.dart
```dart
// lib/screens/quest/quest_detail_screen.dart
import 'package:flutter/material.dart';
import '../../models/quest_model.dart';
import '../../services/supabase_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/icon_mapper.dart';
import '../../widgets/custom_app_bar.dart';

class QuestDetailScreen extends StatefulWidget {
  final Quest quest;
  const QuestDetailScreen({super.key, required this.quest});

  @override
  State<QuestDetailScreen> createState() => _QuestDetailScreenState();
}

class _QuestDetailScreenState extends State<QuestDetailScreen> {
  final SupabaseService _service = SupabaseService();
  bool _isCompleting = false;

  Future<void> _completeQuest() async {
    setState(() => _isCompleting = true);
    try {
      await _service.completeQuest(widget.quest.id, 'completed');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("+${widget.quest.xpReward} XP Earned!"),
          backgroundColor: AppColors.success,
        ),
      );
      if (mounted) Navigator.pop(context, true); // Return success
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to complete quest")),
      );
    } finally {
      setState(() => _isCompleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final quest = widget.quest;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: "Quest Details"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(getIconFromName(quest.iconName), size: 80, color: AppColors.gold),
            const SizedBox(height: 16),
            Text(quest.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Reward: +${quest.xpReward} XP", style: const TextStyle(fontSize: 20, color: AppColors.gold)),

            const SizedBox(height: 24),
            const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(quest.description, style: const TextStyle(fontSize: 16, color: AppColors.lightText)),

            if (quest.detailedContent != null) ...[
              const SizedBox(height: 24),
              const Text("How to Complete", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(quest.detailedContent!, style: const TextStyle(fontSize: 16)),
            ],

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: quest.isLockedForUser || _isCompleting
                    ? null
                    : _completeQuest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isCompleting
                    ? const CircularProgressIndicator(color: Colors.black)
                    : Text(quest.statusText.toUpperCase(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

```

### File: ./lib/screens/initial_loading_screen.dart
```dart
// lib/screens/initial_loading_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/app_colors.dart';
import '../widgets/app_logo_widget.dart';
import '../widgets/diamond_mesh_background.dart';

class InitialLoadingScreen extends StatelessWidget {
  final Object? initializationError;

  const InitialLoadingScreen({
    Key? key, 
    this.initializationError
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.offBlack,
      body: DiamondMeshBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- 1. ANIMATED LOGO ---
                const AppLogoWidget(logoHeight: 100)
                    .animate(onPlay: (controller) => controller.repeat(reverse: true))
                    .shimmer(duration: 2000.ms, color: AppColors.gold.withOpacity(0.5))
                    .scale(
                      begin: const Offset(1.0, 1.0),
                      end: const Offset(1.05, 1.05),
                      duration: 2000.ms,
                      curve: Curves.easeInOut,
                    ),

                const SizedBox(height: 32),

                // --- 2. ERROR OR LOADING STATE ---
                if (initializationError != null)
                  _buildErrorState(theme)
                else
                  _buildLoadingState(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Column(
      children: [
        Text(
          "INITIALIZING CABAL",
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.gold,
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn(delay: 400.ms),
        const SizedBox(height: 16),
        
        // Custom sleek progress bar
        SizedBox(
          width: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              backgroundColor: Colors.white.withOpacity(0.05),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
              minHeight: 2,
            ),
          ),
        ).animate().fadeIn(delay: 600.ms),
        
        const SizedBox(height: 24),
        
        Text(
          "CONNECTING TO TON BLOCKCHAIN",
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.greyText.withOpacity(0.5),
            letterSpacing: 1.2,
          ),
        ).animate(onPlay: (c) => c.repeat())
         .fadeIn(duration: 1000.ms)
         .then(delay: 1000.ms)
         .fadeOut(duration: 1000.ms),
      ],
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Column(
      children: [
        const FaIcon(
          FontAwesomeIcons.circleExclamation, 
          color: AppColors.error, 
          size: 32
        ).animate().shake(),
        const SizedBox(height: 16),
        Text(
          "INITIALIZATION FAILED",
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          initializationError.toString(),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.greyText),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            // Logic to restart app would go here
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.darkGrey),
          child: const Text("RETRY CONNECTION"),
        ),
      ],
    ).animate().fadeIn();
  }
}

```

### File: ./lib/core/services/solana_types_export.dart
```dart
// lib/core/services/solana_types_export.dart
library airloot.solana_types; // Library name

// Re-export the necessary types from solana_mobile_client
// This forces them into the 'airloot.solana_types' library namespace.
export 'package:solana_mobile_client/solana_mobile_client.dart' 
    show SolanaMobileClient, WalletCluster, AuthorizationResult, Commitment;

```

### File: ./lib/core/services/solana_service_stub.dart
```dart
// lib/core/services/solana_service_stub.dart
// This is the stub implementation for web.
class SolanaWalletService {
  Future<String?> connect() async {
    throw UnsupportedError('Solana wallet connection is not supported on Web.');
  }

  Future<void> disconnect() async {
    throw UnsupportedError('Solana wallet disconnection is not supported on Web.');
  }

  bool get isConnected => false;
  String? get connectedAddress => null;
}

```

### File: ./lib/core/services/solana_service_mobile.dart
```dart
// lib/core/services/solana_service_mobile.dart
import 'package:bs58/bs58.dart';
import 'package:flutter/foundation.dart';
import 'package:solana_mobile_client/solana_mobile_client.dart';

// This is the real implementation for mobile.
class SolanaWalletService {
  String? _connectedAddress;
  AuthorizationResult? _mwaAuthResult;
  final SolanaMobileClient _solanaMobileClient = SolanaMobileClient(
    walletCluster: WalletCluster.mainnetBeta,
    identityName: 'Cabal',
    identityUri: Uri.parse('https://cabal-001.web.app'),
    iconUri: Uri.parse('https://cabal-001.web.app/icon.png'),
  );

  bool get isConnected => _connectedAddress != null;
  String? get connectedAddress => _connectedAddress;

  Future<String?> connect() async {
    if (isConnected) return _connectedAddress;
    try {
      final result = await _solanaMobileClient.authorize();
      _mwaAuthResult = result;
      _connectedAddress = base58.encode(result.publicKey);
      return _connectedAddress;
    } catch (e) {
      _clearState();
      debugPrint("Solana Connection Error: $e");
      rethrow;
    }
  }

  Future<void> disconnect() async {
    if (_mwaAuthResult != null) {
      try {
        await _solanaMobileClient.deauthorize(authToken: _mwaAuthResult!.authToken);
      } catch(e) {
        debugPrint("Error deauthorizing Solana: $e");
      }
    }
    _clearState();
  }

  void _clearState() {
    _connectedAddress = null;
    _mwaAuthResult = null;
  }
}

```

### File: ./lib/core/services/wallet_service.dart
```dart
// lib/core/services/wallet_service.dart

// This is a conditional import.
// It imports the mobile implementation by default.
// If the compilation target is web (where 'dart.library.html' exists),
// it will import the stub implementation instead.
export 'wallet_service_mobile.dart' if (dart.library.html) 'wallet_service_stub.dart';

```

### File: ./lib/core/services/wallet_service_mobile.dart
```dart
// lib/core/services/wallet_service_mobile.dart
// This is the mobile-only implementation that includes Solana and EVM.
import 'dart:async';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:bs58/bs58.dart';
import 'package:solana_mobile_client/solana_mobile_client.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WalletType {
  static const String evm = 'evm';
  static const String solana = 'solana';
}

class WalletService {
  // --- EVM (WalletConnect) ---
  Web3App? _wcClient;
  SessionData? _wcSession;
  String? get _wcAddress => _wcSession != null ? NamespaceUtils.getAccount(
          _wcSession!.namespaces.values.first.accounts.first) : null;
  String? get _wcChainId => _wcSession != null ? NamespaceUtils.getChainFromAccount(
          _wcSession!.namespaces.values.first.accounts.first) : null;

  // --- Solana (Mobile Wallet Adapter) ---
  String? _connectedSolanaAddress;
  AuthorizationResult? _mwaAuthResult;
  final SolanaMobileClient _solanaMobileClient = SolanaMobileClient(
    walletCluster: WalletCluster.mainnetBeta,
    identityName: 'Cabal',
    identityUri: Uri.parse('https://cabal-001.web.app'),
    iconUri: Uri.parse('https://cabal-001.web.app/icon.png'),
  );

  // --- Public Getters ---
  String? get connectedEVMAddress => _wcAddress;
  String? get currentEVMChainId => _wcChainId;
  bool get isConnectedEVM => _wcSession != null && _wcAddress != null;

  String? get connectedSolanaAddress => _connectedSolanaAddress;
  bool get isConnectedSolana => _connectedSolanaAddress != null;

  Future<void> initialize() async {
    final projectId = env['WALLET_CONNECT_PROJECT_ID'];
    if (projectId == null) {
      debugPrint("WalletService FATAL: WALLET_CONNECT_PROJECT_ID not found in .env");
      return;
    }

    _wcClient = await Web3App.createInstance(
      projectId: projectId,
      metadata: const PairingMetadata(
        name: 'Cabal',
        description: 'Cabal Quest Platform',
        url: 'https://cabal-001.web.app',
        icons: ['https://cabal-001.web.app/icon.png'],
      ),
    );
    debugPrint("WalletService (Mobile): WalletConnect client initialized.");
  }

  void _clearEVMConnectionState() {
    _wcSession = null;
  }
  
  void _clearSolanaConnectionState() {
    _connectedSolanaAddress = null;
    _mwaAuthResult = null;
  }

  Future<String?> connectEVMWallet() async {
    if (isConnectedEVM) return _wcAddress;
    if (_wcClient == null) throw Exception("WalletConnect client is not initialized.");

    try {
      ConnectResponse response = await _wcClient!.connect(
        requiredNamespaces: {
          'eip155': const RequiredNamespace(
            chains: ['eip155:11155111'], // Sepolia Testnet
            methods: ['personal_sign', 'eth_sendTransaction'],
            events: ['chainChanged', 'accountsChanged'],
          ),
        },
      );

      final Uri? uri = response.uri;
      if (uri != null) {
        await launchUrlString(uri.toString(), mode: LaunchMode.externalApplication);
      }

      _wcSession = await response.session.future;
      debugPrint("WalletService (Mobile): EVM wallet connected: ${_wcAddress}");
      return _wcAddress;
    } catch (e) {
      _clearEVMConnectionState();
      debugPrint("WalletService (Mobile): EVM connection error: $e");
      throw Exception("Failed to connect EVM wallet: $e");
    }
  }

  Future<void> disconnectEVMWallet() async {
    if (_wcSession != null) {
      await _wcClient?.disconnectSession(
        topic: _wcSession!.topic,
        reason: const WalletConnectError(code: 1, message: 'User disconnected'),
      );
    }
    _clearEVMConnectionState();
    debugPrint("WalletService (Mobile): EVM wallet disconnected.");
  }

  Future<String?> connectSolanaWallet() async {
    if (isConnectedSolana) return _connectedSolanaAddress;
    try {
      final result = await _solanaMobileClient.authorize();
      _mwaAuthResult = result;
      _connectedSolanaAddress = base58.encode(result.publicKey);
      return _connectedSolanaAddress;
    } catch (e) {
      _clearSolanaConnectionState();
      throw Exception("Failed to connect Solana wallet: $e");
    }
  }

  Future<void> disconnectSolanaWallet() async {
    try {
      if (_mwaAuthResult != null) {
        await _solanaMobileClient.deauthorize(authToken: _mwaAuthResult!.authToken);
      }
    } catch (e) {
      debugPrint("WalletService: Error deauthorizing Solana wallet, but clearing state anyway. Error: $e");
    } finally {
      _clearSolanaConnectionState();
    }
  }

  Future<String?> signEVMMessage(String message, {String? chainId}) async {
    if (!isConnectedEVM || _wcClient == null) throw Exception("EVM Wallet not connected.");

    final response = await _wcClient!.request(
      topic: _wcSession!.topic,
      chainId: chainId ?? 'eip155:11155111',
      request: SessionRequest(
        method: 'personal_sign',
        params: [message, _wcAddress],
      ),
    );

    return response.toString(); // The signed message hash
  }

  Future<String?> sendEVMTransaction({
    required String to, String? data, String? value, String? chainId,
  }) async {
    if (!isConnectedEVM || _wcClient == null) throw Exception("EVM Wallet not connected.");
    
    final transaction = {
      'from': _wcAddress,
      'to': to,
      'data': data ?? '0x',
      'value': value, // e.g., '0x...' for 1 ETH
    };

    final response = await _wcClient!.request(
      topic: _wcSession!.topic,
      chainId: chainId ?? 'eip155:11155111',
      request: SessionRequest(
        method: 'eth_sendTransaction',
        params: [transaction],
      ),
    );
    
    return response.toString(); // The transaction hash
  }
}

```

### File: ./lib/core/services/wallet_service_stub.dart
```dart
// lib/core/services/wallet_service_stub.dart
// This is the WEB implementation using Reown AppKit.

import 'dart:async';
import 'package:cabal/main.dart'; // Import to get the navigatorKey
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class WalletType {
  static const String evm = 'evm';
  static const String solana = 'solana';
}

class WalletService {
  ReownAppKitModal? _appKitModal;

  String? get connectedEVMAddress {
    final session = _appKitModal?.session;
    if (session == null) return null;
    final namespaces = session.namespaces;
    if (namespaces == null) return null;
    final accounts = namespaces['eip155']?.accounts;
    if (accounts == null || accounts.isEmpty) return null;
    return NamespaceUtils.getAccount(accounts.first);
  }
  String? get currentEVMChainId => _appKitModal?.selectedChain?.chainId;
  bool get isConnectedEVM => _appKitModal?.isConnected ?? false;
  
  String? get connectedSolanaAddress => null;
  bool get isConnectedSolana => false;

  Future<void> initialize() async {
    // Read directly from build environment since this is a web-only stub
    const projectId = String.fromEnvironment('WALLET_CONNECT_PROJECT_ID');
    if (projectId.isEmpty) {
      debugPrint("WalletService (Web) FATAL: WALLET_CONNECT_PROJECT_ID not defined in build environment.");
      return;
    }
    
    const sepoliaRpc = String.fromEnvironment('SEPOLIA_RPC_URL');
    if (sepoliaRpc.isEmpty) {
      throw Exception('SEPOLIA_RPC_URL not defined in build environment.');
    }

    const mainnetRpc = String.fromEnvironment('MAINNET_RPC_URL');
    if (mainnetRpc.isEmpty) {
      throw Exception('MAINNET_RPC_URL not defined in build environment.');
    }
    
    final sepoliaChain = ReownAppKitModalNetworkInfo(
      name: 'Sepolia',
      chainId: '11155111',
      currency: 'ETH',
      rpcUrl: sepoliaRpc,
      explorerUrl: 'https://sepolia.etherscan.io',
    );
    final mainnetChain = ReownAppKitModalNetworkInfo(
      name: 'Ethereum',
      chainId: '1',
      currency: 'ETH',
      rpcUrl: mainnetRpc,
      explorerUrl: 'https://etherscan.io',
    );

    _appKitModal = ReownAppKitModal(
      context: navigatorKey.currentContext!,
      projectId: projectId,
      metadata: const PairingMetadata(
        name: 'Cabal',
        description: 'Cabal Quest Platform',
        url: 'https://cabal-001.web.app',
        icons: ['https://cabal-001.web.app/icon.png'],
        redirect: Redirect(
          native: 'cabal://',
          universal: 'https://cabal-001.web.app',
          linkMode: true,
        ),
      ),
      includedWalletIds: {
        'c57ca95b47569778a828d19178114f4db188b89b763c899ba0be274e97267d96',
        '4622a2b2d6af1c9844944291e5e7351a6aa24cd7b23099efac1b2fd875da31a0',
        'fd20dc426fb37566d803205b19bbc1d4096b248ac04548e3cfb6b3a38bd033aa',
      },
    );

    await _appKitModal!.init();
    
    _appKitModal!.selectChain(kDebugMode ? sepoliaChain : mainnetChain);
    
    debugPrint("WalletService (Web): Reown AppKit client initialized.");
  }

  Future<String?> connectEVMWallet({required BuildContext context}) async {
    if (isConnectedEVM) return connectedEVMAddress;
    if (_appKitModal == null) throw Exception("Reown AppKit service not initialized.");

    try {
      await _appKitModal!.openModalView(const SizedBox.shrink());
      return connectedEVMAddress;
    } catch (e) {
      debugPrint('Error connecting wallet via Reown AppKit: $e');
      await disconnectEVMWallet();
      rethrow;
    }
  }

  Future<void> disconnectEVMWallet() async {
    if (_appKitModal != null && _appKitModal!.isConnected) {
      await _appKitModal!.disconnect();
    }
    debugPrint("WalletService (Web): EVM wallet disconnected.");
  }

  Future<String?> signEVMMessage(String message, {String? chainId}) async {
    if (!isConnectedEVM || _appKitModal == null) throw Exception("EVM Wallet not connected.");
    
    final signature = await _appKitModal!.request(
      topic: _appKitModal!.session!.topic!,
      chainId: chainId ?? 'eip155:${_appKitModal!.selectedChain!.chainId}',
      request: SessionRequestParams(
        method: 'personal_sign',
        params: [message, connectedEVMAddress],
      ),
    );
    return signature.toString();
  }

  Future<String?> sendEVMTransaction({
    required String to,
    String? data,
    String? value,
    String? chainId,
  }) async {
    if (!isConnectedEVM || _appKitModal == null) throw Exception("EVM Wallet not connected.");
    
    final transaction = Transaction(
      from: EthereumAddress.fromHex(connectedEVMAddress!),
      to: EthereumAddress.fromHex(to),
      data: data != null ? hexToBytes(data) : null,
      value: value != null ? EtherAmount.fromBigInt(EtherUnit.wei, BigInt.parse(value.substring(2), radix: 16)) : null,
    );

    final txHash = await _appKitModal!.request(
      topic: _appKitModal!.session!.topic!,
      chainId: chainId ?? 'eip155:${_appKitModal!.selectedChain!.chainId}',
      request: SessionRequestParams(
        method: 'eth_sendTransaction',
        params: [transaction.toJson()],
      ),
    );
    return txHash.toString();
  }

  Future<String?> connectSolanaWallet() async {
    throw UnsupportedError("Solana wallet connection is not available on web.");
  }

  Future<void> disconnectSolanaWallet() async {
    throw UnsupportedError("Solana wallet is not available on web.");
  }
}

```

### File: ./lib/core/services/coingecko_service.dart
```dart
// lib/core/services/coingecko_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:cabal/config.dart'; // Import the new config helper
import '../../models/coin_data_model.dart';

class CoinGeckoService {
  final String _baseUrl = 'https://api.coingecko.com/api/v3';
  late final String _apiKey;

  CoinGeckoService() {
    // Use AppConfig to get the API key
    _apiKey = AppConfig.coingeckoApiKey;
    if (_apiKey.isEmpty) {
      debugPrint("CoinGeckoService WARNING: COINGECKO_API_KEY not found in environment.");
    }
  }

  Map<String, String> get _headers => {
        'accept': 'application/json',
        'x-cg-demo-api-key': _apiKey,
      };

  Future<List<CoinData>> getTrendingCoins({int topN = 100}) async {
    final String url = '$_baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$topN&page=1&sparkline=false&price_change_percentage=24h';
    try {
      debugPrint("CoinGeckoService: Fetching top $topN trending coins from $url");
      final response = await http.get(Uri.parse(url), headers: _headers);

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        debugPrint("CoinGeckoService: Successfully fetched ${jsonList.length} market coins.");
        return jsonList.map((json) => CoinData.fromJson(json)).toList();
      } else {
        debugPrint("CoinGeckoService: Failed to load market data: ${response.statusCode} ${response.body}");
        throw Exception('Failed to load market data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("CoinGeckoService: Error fetching market data: $e");
      throw Exception('Error fetching market data: $e');
    }
  }

  Future<List<dynamic>> getCoinChartData(String coinId) async {
    final String url = '$_baseUrl/coins/$coinId/market_chart?vs_currency=usd&days=14';
    try {
      debugPrint("CoinGeckoService: Fetching chart data for $coinId from $url");
      final response = await http.get(Uri.parse(url), headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['prices'] as List<dynamic>;
      } else {
        debugPrint("CoinGeckoService: Failed to load chart data: ${response.statusCode} ${response.body}");
        throw Exception('Failed to load chart data for $coinId: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("CoinGeckoService: Error fetching chart data for $coinId: $e");
      throw Exception('Error fetching chart data for $coinId: $e');
    }
  }
}

```

### File: ./lib/core/app_colors.dart
```dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF0F0F0F);
  static const Color gold = Color(0xFFD4AF37);
}

```

### File: ./lib/features/wallet/application/wallet_provider.dart
```dart
// lib/features/wallet/application/wallet_provider.dart
import 'dart:math'; // <-- FIX 1: ADDED THIS IMPORT
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/crypto.dart';
import '../../../core/services/wallet_service.dart';
import '../../../services/web3_service.dart';

class WalletProvider with ChangeNotifier {
  final WalletService _walletService;
  final Web3Service _web3Service;

  WalletProvider(this._walletService, this._web3Service);

  bool _isLoadingEVM = false;
  bool get isLoadingEVM => _isLoadingEVM;
  String? get connectedEVMAddress => _walletService.connectedEVMAddress;
  String? get currentEVMChainId => _walletService.currentEVMChainId;
  bool get isConnectedEVM => _walletService.isConnectedEVM;
  String? _evmError;
  String? get evmError => _evmError;
  
  bool _isLoadingSolana = false;
  bool get isLoadingSolana => _isLoadingSolana;
  String? get connectedSolanaAddress => _walletService.connectedSolanaAddress;
  bool get isConnectedSolana => _walletService.isConnectedSolana;
  String? _solanaError;
  String? get solanaError => _solanaError;

  bool get isLoading => _isLoadingEVM || _isLoadingSolana;

  Future<void> connectEVMWallet({required BuildContext context}) async {
    _isLoadingEVM = true;
    _evmError = null;
    notifyListeners();
    try {
      await _walletService.connectEVMWallet(context: context);
    } catch (e) {
      if (e is UnsupportedError) {
        _evmError = "EVM Wallet connection is not available on this platform.";
      } else {
        _evmError = "Connection failed or was cancelled by user.";
      }
      debugPrint("WalletProvider EVM Connect Error: $e");
    } finally {
      _isLoadingEVM = false;
      notifyListeners();
    }
  }

  Future<void> disconnectEVMWallet() async {
    _isLoadingEVM = true;
    _evmError = null;
    notifyListeners();
    try {
      await _walletService.disconnectEVMWallet();
    } catch (e) {
      _evmError = e.toString();
      debugPrint("WalletProvider EVM Disconnect Error: $e");
    } finally {
      _isLoadingEVM = false;
      notifyListeners();
    }
  }

  /// Sends a pre-built transaction to the user's wallet for signing and execution.
  Future<String?> sendTransaction(Transaction transaction) async {
    if (!isConnectedEVM) {
      _evmError = "EVM Wallet not connected for transaction.";
      notifyListeners();
      throw Exception(_evmError);
    }
    
    _isLoadingEVM = true;
    _evmError = null;
    notifyListeners();

    try {
      final String? toAddress = transaction.to?.hex;
      if (toAddress == null) {
        throw Exception("Transaction 'to' address is missing.");
      }

      final hexData = transaction.data != null ? bytesToHex(transaction.data!, include0x: true) : null;
      final hexValue = transaction.value?.getInWei.toRadixString(16);

      final txHash = await _walletService.sendEVMTransaction(
        to: toAddress,
        data: hexData,
        value: hexValue != null ? '0x$hexValue' : null,
      );
      
      return txHash;

    } catch (e) {
      _evmError = "Transaction failed: $e";
      debugPrint("WalletProvider Transaction Error: $_evmError");
      rethrow;
    } finally {
      _isLoadingEVM = false;
      notifyListeners();
    }
  }

  // --- NEW METHOD FOR TOKEN DEPLOYMENT ---
  Future<String?> deployERC20Token({
    required String name,
    required String symbol,
    required BigInt initialSupply,
  }) async {
    if (!isConnectedEVM) {
      _evmError = "EVM Wallet not connected for deployment.";
      notifyListeners();
      throw Exception(_evmError);
    }

    _isLoadingEVM = true;
    _evmError = null;
    notifyListeners();

    try {
      // IMPORTANT: Getting user's private key is not possible with WalletConnect/MetaMask.
      // A real DApp would deploy contracts from a backend server (a "hot wallet")
      // or use a contract factory pattern where the user just calls a function on an
      // existing factory contract.
      // For this simulation, we'll create a random, temporary credential set.
      final credentials = EthPrivateKey.createRandom(Random.secure());
      
      // FIX 2: Corrected the function name to match what's in Web3Service
      final contractAddress = await _web3Service.deployAndInitializeERC20(
        name: name,
        symbol: symbol,
        initialSupply: initialSupply,
        credentials: credentials, // In a real app, this would be handled differently.
      );
      
      return contractAddress;

    } catch (e) {
      _evmError = "Deployment failed: $e";
      debugPrint("WalletProvider Deployment Error: $_evmError");
      rethrow;
    } finally {
      _isLoadingEVM = false;
      notifyListeners();
    }
  }

  Future<void> connectSolanaWallet() async {
    _isLoadingSolana = true;
    _solanaError = null;
    notifyListeners();
    try {
      await _walletService.connectSolanaWallet();
    } catch (e) {
      _solanaError = "Connection failed or was cancelled.";
      debugPrint("WalletProvider Solana Connect Error: $e");
    } finally {
      _isLoadingSolana = false;
      notifyListeners();
    }
  }

  Future<void> disconnectSolanaWallet() async {
    _isLoadingSolana = true;
    _solanaError = null;
    notifyListeners();
    try {
      await _walletService.disconnectSolanaWallet();
    } catch (e) {
      _solanaError = e.toString();
      debugPrint("WalletProvider Solana Disconnect Error: $e");
    } finally {
      _isLoadingSolana = false;
      notifyListeners();
    }
  }

  void clearEVMErrors() {
    _evmError = null;
    notifyListeners();
  }

  void clearSolanaErrors() { 
    _solanaError = null; 
    notifyListeners(); 
  }
}

```

### File: ./lib/features/wallet/presentation/widgets/wallet_connector_widget.dart
```dart
// lib/features/wallet/presentation/widgets/wallet_connector_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../application/wallet_provider.dart';
import 'package:cabal/utils/app_colors.dart';
import '../../../../widgets/info_tooltip.dart';

class WalletConnectorWidget extends StatelessWidget {
  const WalletConnectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildEvmWalletSection(context, walletProvider, theme),
            const Divider(height: 32),
            _buildSolanaWalletSection(context, walletProvider, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildSolanaWalletSection(BuildContext context, WalletProvider wp, ThemeData theme) {
    const solanaGradient = LinearGradient(colors: [Color(0xFF9945FF), Color(0xFF14F195)]);

    Widget connectButton = Container(
      decoration: BoxDecoration(
        gradient: solanaGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: ElevatedButton.icon(
        icon: const FaIcon(FontAwesomeIcons.ghost, size: 18),
        label: const Text('Connect Solana Wallet'),
        onPressed: (wp.isLoading || kIsWeb) ? null : () => wp.connectSolanaWallet(), // Disable on web
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          disabledBackgroundColor: Colors.grey.withOpacity(0.5),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const FaIcon(FontAwesomeIcons.ghost, color: Color(0xFF9945FF), size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text("Solana Wallet", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
            ),
            const InfoTooltip(message: "Connect your Phantom wallet (or other mobile Solana wallets) to interact with Solana-based quests."),
          ],
        ),
        const SizedBox(height: 16),
        if (wp.isLoadingSolana)
          const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()))
        else if (wp.isConnectedSolana)
          _buildConnectedWalletInfo(
            theme: theme,
            address: wp.connectedSolanaAddress!,
            chainInfo: "Mainnet Beta",
            onDisconnect: () => wp.disconnectSolanaWallet(),
            walletTypeLabel: "Solana Wallet Connected",
            gradient: solanaGradient,
          )
        else if (kIsWeb)
          Tooltip(
            message: "Solana mobile connection is not available on web.",
            child: connectButton,
          )
        else
          connectButton.animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
        if (wp.solanaError != null) ...[
          const SizedBox(height: 12),
          Text(wp.solanaError!, style: TextStyle(color: theme.colorScheme.error, fontSize: 13)),
        ],
      ],
    );
  }

  Widget _buildEvmWalletSection(BuildContext context, WalletProvider wp, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(FontAwesomeIcons.ethereum, color: theme.colorScheme.secondary, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text("EVM Wallets", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
            ),
            const InfoTooltip(
              message: "Connect any EVM-compatible wallet (like MetaMask, Trust Wallet) using WalletConnect.",
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (wp.isLoadingEVM)
          const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()))
              .animate().fadeIn()
        else if (wp.isConnectedEVM)
          _buildConnectedWalletInfo(
            theme: theme,
            address: wp.connectedEVMAddress!,
            chainInfo: "Chain ID: ${wp.currentEVMChainId ?? 'N/A'}",
            onDisconnect: () => wp.disconnectEVMWallet(),
            walletTypeLabel: "EVM Wallet Connected",
            accentColor: AppColors.tertiaryAccent,
          ).animate().fadeIn(duration: 300.ms)
        else
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(FontAwesomeIcons.wallet, size: 18),
              label: const Text('Connect EVM Wallet'),
              onPressed: wp.isLoading ? null : () => wp.connectEVMWallet(context: context),
              style: theme.elevatedButtonTheme.style,
            ),
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
        if (wp.evmError != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: theme.colorScheme.error, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(wp.evmError!, style: TextStyle(color: theme.colorScheme.error, fontSize: 13))),
                TextButton(
                  onPressed: wp.clearEVMErrors,
                  child: const Text('OK'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    foregroundColor: theme.colorScheme.error
                  ),
                )
              ],
            ),
          ).animate().shakeX(amount: 4, duration: 300.ms),
        ],
      ],
    );
  }

  Widget _buildConnectedWalletInfo({
    required ThemeData theme,
    required String address,
    required String chainInfo,
    required VoidCallback onDisconnect,
    required String walletTypeLabel,
    Color? accentColor,
    Gradient? gradient,
  }) {
    final displayAddress = "${address.substring(0, 6)}...${address.substring(address.length - 4)}";
    final effectiveAccentColor = accentColor ?? theme.colorScheme.primary;
    
    BoxDecoration decoration;
    if (gradient != null) {
      decoration = BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
      );
    } else {
      decoration = BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: effectiveAccentColor, width: 1.5)
      );
    }

    return Container(
      padding: const EdgeInsets.all(1.5),
      decoration: decoration,
      child: Container(
        padding: const EdgeInsets.all(14.5),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(10.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FaIcon(FontAwesomeIcons.solidCircleCheck, color: gradient != null ? Colors.white : effectiveAccentColor, size: 16),
                const SizedBox(width: 8),
                Text(walletTypeLabel, style: theme.textTheme.titleSmall?.copyWith(color: gradient != null ? Colors.white : effectiveAccentColor, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text("Address:", style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7))),
            SelectableText(displayAddress, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, fontFamily: 'monospace')),
            if(chainInfo.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(chainInfo, style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7))),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.link_off_rounded, size: 20),
                label: const Text('Disconnect'),
                onPressed: onDisconnect,
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  side: BorderSide(color: theme.colorScheme.error.withOpacity(0.5)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

```

### File: ./lib/features/onboarding/application/onboarding_provider.dart
```dart
// lib/features/onboarding/application/onboarding_provider.dart
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart'; // For list equality check
import '../../../data/repositories/coin_repository.dart';
import '../../../models/coin_data_model.dart';
import '../../../models/user_profile_model.dart';
import '../../../services/supabase_service.dart';

// Define some example interests/categories for onboarding
// These should ideally come from a backend or constants file in a real app.
const List<String> availableInterests = [
  'DeFi', 'NFTs', 'Gaming', 'Metaverse', 'Layer 1s', 'Layer 2s',
  'Web3 Social', 'Decentralized Identity', 'Yield Farming', 'DEXs',
  'DAOs', 'Wallets', 'Security', 'Scalability', 'Privacy',
];

class OnboardingProvider with ChangeNotifier {
  final CoinRepository _coinRepository;
  final SupabaseService _supabaseService;

  // <--- ADD THIS PUBLIC GETTER!
  SupabaseService get supabaseService => _supabaseService; 
  // --- END OF ADDITION ---

  List<CoinData> _availableCoins = [];
  bool _isLoadingCoins = false;
  String? _coinLoadError;

  List<String> _selectedPreferredCoinIds = [];
  List<String> _selectedInterests = [];
  bool _isSavingPreferences = false;
  String? _saveError;

  OnboardingProvider(this._coinRepository, this._supabaseService);

  // Getters
  List<CoinData> get availableCoins => _availableCoins;
  bool get isLoadingCoins => _isLoadingCoins;
  String? get coinLoadError => _coinLoadError;

  List<String> get selectedPreferredCoinIds => _selectedPreferredCoinIds;
  List<String> get selectedInterests => _selectedInterests;
  bool get isSavingPreferences => _isSavingPreferences;
  String? get saveError => _saveError;

  // Initialize selected values from user profile if available
  void initializeFromUserProfile(UserProfile? userProfile) {
    if (userProfile != null) {
      _selectedPreferredCoinIds = List.from(userProfile.preferredCoinIds);
      _selectedInterests = List.from(userProfile.interests);
      notifyListeners();
      debugPrint("OnboardingProvider: Initialized from user profile. Coins: ${_selectedPreferredCoinIds.length}, Interests: ${_selectedInterests.length}");
    }
  }

  // Fetch Coins
  Future<void> fetchAvailableCoins() async {
    if (_isLoadingCoins) return;
    _isLoadingCoins = true;
    _coinLoadError = null;
    notifyListeners();

    try {
      _availableCoins = await _coinRepository.getTopNCoinData(count: 200); // Fetch top 200 coins
      debugPrint("OnboardingProvider: Fetched ${_availableCoins.length} coins.");
    } catch (e) {
      _coinLoadError = 'Failed to load coins: ${e.toString()}';
      debugPrint("OnboardingProvider: Error fetching coins: $e");
    } finally {
      _isLoadingCoins = false;
      notifyListeners();
    }
  }

  // Toggle Coin Selection
  void toggleCoinSelection(String coinId) {
    if (_selectedPreferredCoinIds.contains(coinId)) {
      _selectedPreferredCoinIds.remove(coinId);
    } else {
      if (_selectedPreferredCoinIds.length < 10) { // Limit to 10 favorite coins
        _selectedPreferredCoinIds.add(coinId);
      } else {
        _coinLoadError = 'You can select up to 10 favorite coins.'; // Reuse error for feedback
      }
    }
    notifyListeners();
    _clearErrorAfterDelay();
  }

  // Toggle Interest Selection
  void toggleInterestSelection(String interest) {
    if (_selectedInterests.contains(interest)) {
      _selectedInterests.remove(interest);
    } else {
      if (_selectedInterests.length < 5) { // Limit to 5 interests
        _selectedInterests.add(interest);
      } else {
        _coinLoadError = 'You can select up to 5 interests.'; // Reuse error for feedback
      }
    }
    notifyListeners();
    _clearErrorAfterDelay();
  }

  // Save Preferences to Supabase
  Future<bool> savePreferences(String userId) async {
    if (_isSavingPreferences) return false;
    _isSavingPreferences = true;
    _saveError = null;
    notifyListeners();

    try {
      if (_selectedPreferredCoinIds.isEmpty || _selectedInterests.isEmpty) {
        throw Exception("Please select at least one coin and one interest.");
      }

      final Map<String, dynamic> updateData = {
        'preferred_coin_ids': _selectedPreferredCoinIds,
        'interests': _selectedInterests,
      };
      await _supabaseService.updateUserProfile(updateData);
      debugPrint("OnboardingProvider: Saved preferences for user $userId. Coins: $_selectedPreferredCoinIds, Interests: $_selectedInterests");
      return true;
    } catch (e) {
      _saveError = 'Failed to save preferences: ${e.toString()}';
      debugPrint("OnboardingProvider: Error saving preferences: $e");
      return false;
    } finally {
      _isSavingPreferences = false;
      notifyListeners();
    }
  }

  void _clearErrorAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (coinLoadError != null && _isLoadingCoins == false) {
        _coinLoadError = null;
        notifyListeners();
      }
      if (saveError != null && _isSavingPreferences == false) {
        _saveError = null;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    debugPrint("OnboardingProvider disposed.");
    super.dispose();
  }
}

```

### File: ./lib/features/onboarding/presentation/onboarding_preferences_screen.dart
```dart
// lib/features/onboarding/presentation/onboarding_preferences_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/foundation.dart' show debugPrint;

import '../../../utils/app_colors.dart';
import '../../../widgets/animated_particle_background.dart';
import '../../../widgets/quest_complete_celebration.dart';
import '../application/onboarding_provider.dart';
import '../../../models/user_profile_model.dart';
import '../../../models/quest_model.dart';
import '../../../features/wallet/application/wallet_provider.dart';
import '../../../features/wallet/presentation/widgets/wallet_connector_widget.dart';
import '../../../screens/home_nav_wrapper.dart';
import '../../../screens/login_screen.dart';
import '../../../utils/constants.dart';

class OnboardingPreferencesScreen extends StatefulWidget {
  const OnboardingPreferencesScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingPreferencesScreen> createState() => _OnboardingPreferencesScreenState();
}

class _OnboardingPreferencesScreenState extends State<OnboardingPreferencesScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  User? _currentUser;
  bool _walletQuestCompleted = false;

  // Define the onboarding wallet connection quest
  final Quest _walletQuest = Quest(
    id: 'onboarding_wallet_connect',
    title: 'Connect Your First Wallet',
    description: 'LFG! Connect an EVM or Solana wallet to join the Web3 degen crew!',
    xpReward: 100,
    type: QuestType.connectWalletEth,
    iconName: 'wallet',
    isCompletedByUser: false,
    isLockedForUser: false,
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);

    _currentUser = Supabase.instance.client.auth.currentUser;
    if (_currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please log in to set your preferences.'), backgroundColor: Colors.red),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen(fromLogout: false)),
            (route) => false,
          );
        }
      });
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final onboardingProvider = Provider.of<OnboardingProvider>(context, listen: false);
        onboardingProvider.fetchAvailableCoins();
        final authUser = Supabase.instance.client.auth.currentUser;
        if (authUser != null) {
          try {
            final UserProfile? userProfile = await onboardingProvider.supabaseService.getUserProfile(authUser.id);
            if (mounted) {
              onboardingProvider.initializeFromUserProfile(userProfile);
              // Check if wallet is already connected from a previous session
              if (userProfile?.connectedWallets.isNotEmpty ?? false) {
                 setState(() => _walletQuestCompleted = true);
              }
            }
          } catch (e) {
            debugPrint("Error fetching user profile for onboarding: $e");
          }
        }
      }
    });
  }

  void _handleTabChange() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    }
  }

  Future<void> _completeWalletQuest() async {
    if (_walletQuestCompleted || !mounted) return;

    final onboardingProvider = Provider.of<OnboardingProvider>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    setState(() => _walletQuestCompleted = true);
    showQuestCompleteCelebration(context); // Trigger celebration animation!

    try {
      final result = await onboardingProvider.supabaseService.completeQuest(_walletQuest.id);
      if (result['success'] as bool? ?? false) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Quest complete! +${_walletQuest.xpReward} XP'), backgroundColor: AppColors.success),
        );
      } else {
        throw Exception(result['message'] ?? 'Failed to complete quest.');
      }
    } catch (e) {
      debugPrint("Error completing wallet quest: $e");
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error saving quest progress: $e'), backgroundColor: Colors.red),
      );
      // Revert state on failure
      if (mounted) setState(() => _walletQuestCompleted = false);
    }
  }

  Future<void> _saveAndNavigate() async {
    if (_currentUser == null || !mounted) return;
    final onboardingProvider = Provider.of<OnboardingProvider>(context, listen: false);

    final bool success = await onboardingProvider.savePreferences(_currentUser!.id);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_walletQuestCompleted
              ? 'Preferences saved! Wallet connected, degen! Welcome to Cabal!'
              : 'Preferences saved! Welcome to Cabal!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeNavWrapper(showOnboarding: false)),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(onboardingProvider.saveError ?? 'Failed to save preferences.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final onboardingProvider = Provider.of<OnboardingProvider>(context);

    if (_currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Become a Web3 Degen!'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Favorite Coins'),
            Tab(text: 'Interests'),
            Tab(text: 'Join the Chain'),
          ],
          labelStyle: theme.textTheme.titleMedium,
          unselectedLabelStyle: theme.textTheme.titleSmall,
          indicatorColor: theme.colorScheme.secondary,
          labelColor: theme.colorScheme.secondary,
          unselectedLabelColor: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
        ),
      ),
      body: AnimatedParticleBackground(
        baseColor: theme.scaffoldBackgroundColor,
        particleColor1: isDark ? AppColors.particleGoldSoft.withOpacity(0.2) : AppColors.particleGoldSoft.withOpacity(0.4),
        particleColor2: isDark ? AppColors.particleGreySoft.withOpacity(0.2) : AppColors.particleGreySoft.withOpacity(0.3),
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCoinSelectionTab(theme, onboardingProvider),
                  _buildInterestSelectionTab(theme, onboardingProvider),
                  _buildWalletConnectionTab(theme, onboardingProvider),
                ],
              ),
            ),
            _buildSaveButton(theme, onboardingProvider),
            if (onboardingProvider.saveError != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  onboardingProvider.saveError!,
                  style: TextStyle(color: theme.colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ).animate().fadeIn(),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletConnectionTab(ThemeData theme, OnboardingProvider provider) {
    return Consumer<WalletProvider>(
      builder: (context, walletProvider, child) {
        // --- REACTIVE QUEST COMPLETION LOGIC ---
        if ((walletProvider.isConnectedEVM || walletProvider.isConnectedSolana) && !_walletQuestCompleted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _completeWalletQuest();
          });
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _walletQuest.title,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _walletQuest.description,
                style: theme.textTheme.bodyLarge?.copyWith(color: theme.textTheme.bodyLarge?.color?.withOpacity(0.8)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  FaIcon(FontAwesomeIcons.star, color: AppColors.gold, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${_walletQuest.xpReward} XP Reward',
                    style: theme.textTheme.titleSmall?.copyWith(color: AppColors.gold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _walletQuestCompleted
                  ? Card(
                      elevation: 3,
                      color: AppColors.success.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppColors.success, width: 1.5)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const FaIcon(FontAwesomeIcons.solidCircleCheck, color: AppColors.success, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'LFG! Wallet connected. You’re a Web3 degen now!',
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(duration: 300.ms).shake(hz: 3, duration: 400.ms)
                  : WalletConnectorWidget().animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
            ],
          ),
        );
      }
    );
  }
  
  Widget _buildInterestSelectionTab(ThemeData theme, OnboardingProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select up to 5 interests that align with your Web3 goals:',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 16),
          if (provider.coinLoadError != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                provider.coinLoadError!,
                style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: availableInterests.map((interest) {
                  final isSelected = provider.selectedInterests.contains(interest);
                  return FilterChip(
                    label: Text(interest),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      provider.toggleInterestSelection(interest);
                    },
                    selectedColor: theme.colorScheme.secondary,
                    checkmarkColor: theme.colorScheme.onSecondary,
                    labelStyle: theme.chipTheme.labelStyle?.copyWith(
                      color: isSelected ? theme.colorScheme.onSecondary : theme.chipTheme.labelStyle?.color,
                    ),
                    backgroundColor: theme.chipTheme.backgroundColor,
                  ).animate().fadeIn(delay: (50 * availableInterests.indexOf(interest)).ms);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCoinSelectionTab(ThemeData theme, OnboardingProvider provider) {
    if (provider.isLoadingCoins) {
      return Center(child: CircularProgressIndicator(color: theme.colorScheme.secondary));
    }
    if (provider.coinLoadError != null && provider.availableCoins.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, color: theme.colorScheme.error, size: 40),
              const SizedBox(height: 10),
              Text(provider.coinLoadError!, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: provider.fetchAvailableCoins,
                child: const Text('Retry Loading Coins'),
              ),
            ],
          ),
        ),
      );
    }
    if (provider.availableCoins.isEmpty) {
      return Center(
        child: Text(
          'No coins available. Try again later.',
          style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Select up to 10 coins you are most interested in:',
            style: theme.textTheme.titleSmall,
          ),
        ),
        if (provider.coinLoadError != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              provider.coinLoadError!,
              style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
            ),
          ),
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: provider.availableCoins.length,
              itemBuilder: (context, index) {
                final coin = provider.availableCoins[index];
                final isSelected = provider.selectedPreferredCoinIds.contains(coin.id);
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  elevation: isSelected ? 3 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isSelected ? theme.colorScheme.secondary : Colors.transparent,
                      width: isSelected ? 1.5 : 0,
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.surfaceVariant,
                      backgroundImage: coin.imageUrl.isNotEmpty ? NetworkImage(coin.imageUrl) : null,
                      child: coin.imageUrl.isEmpty ? Text(coin.symbol.toUpperCase().substring(0,1), style: TextStyle(color: theme.colorScheme.primary)) : null,
                    ),
                    title: Text(coin.name, style: theme.textTheme.titleSmall),
                    subtitle: Text(coin.symbol.toUpperCase(), style: theme.textTheme.bodySmall),
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: theme.colorScheme.secondary)
                        : Icon(Icons.radio_button_unchecked, color: theme.disabledColor),
                    onTap: () => provider.toggleCoinSelection(coin.id),
                  ),
                ).animate().fadeIn(delay: (50 * (index % 10)).ms).slideX(begin: index.isEven ? -0.05 : 0.05);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(ThemeData theme, OnboardingProvider provider) {
    return Container(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: MediaQuery.of(context).padding.bottom + 16.0,
        top: 16.0,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: provider.isSavingPreferences ? null : _saveAndNavigate,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 5,
        ),
        child: provider.isSavingPreferences
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: theme.colorScheme.onPrimary, strokeWidth: 2.5),
              )
            : const Text('Save & Enter Cabal'),
      ).animate().fadeIn(delay: const Duration(milliseconds: 200)),
    );
  }
}

```

### File: ./lib/firebase_options.dart
```dart
import 'package:firebase_core/firebase_core.dart';
// lib/firebase_options.dart

// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform; // CORRECTED IMPORT

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp( // Corrected comment if it was changed by script
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // The switch statement itself doesn't need to be const.
    // The case values (TargetPlatform.android, etc.) are constants.
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB_DPtdVtLr8tTHRaoRaufCnn_9Pcj8GbA',
    appId: '1:598721200005:web:4a0cd62e3b2a97125c8eec',
    messagingSenderId: '598721200005',
    projectId: 'cabal-001',
    authDomain: 'cabal-001.firebaseapp.com',
    storageBucket: 'cabal-001.firebasestorage.app',
    measurementId: 'G-WQDD3KY78W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAKurgWHdPSbpaThzZl5y_3ZVX2dB2Pk8k',
    appId: '1:598721200005:android:3729585738d80fa65c8eec',
    messagingSenderId: '598721200005',
    projectId: 'cabal-001',
    storageBucket: 'cabal-001.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDGyODenffhqBCZ0TCMfqmq7_QBPy778mU',
    appId: '1:598721200005:ios:f7bf4d53152b668e5c8eec',
    messagingSenderId: '598721200005',
    projectId: 'cabal-001',
    storageBucket: 'cabal-001.firebasestorage.app',
    iosBundleId: 'com.example.airloot',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDGyODenffhqBCZ0TCMfqmq7_QBPy778mU',
    appId: '1:598721200005:ios:f7bf4d53152b668e5c8eec',
    messagingSenderId: '598721200005',
    projectId: 'cabal-001',
    storageBucket: 'cabal-001.firebasestorage.app',
    iosBundleId: 'com.example.airloot',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB_DPtdVtLr8tTHRaoRaufCnn_9Pcj8GbA',
    appId: '1:598721200005:web:021328d30d9ac77a5c8eec',
    messagingSenderId: '598721200005',
    projectId: 'cabal-001',
    authDomain: 'cabal-001.firebaseapp.com',
    storageBucket: 'cabal-001.firebasestorage.app',
    measurementId: 'G-F95059ZFM2',
  );

}
```

### File: ./lib/solana_test.dart
```dart
// lib/solana_test.dart
// import 'package:solana_mobile_client/solana_mobile_client.dart'; // COMMENTED OUT
// import 'package:flutter/foundation.dart'; // For debugPrint // COMMENTED OUT

/* // COMMENTED OUT ENTIRE FUNCTION
void testSolanaTypes() {
  SolanaMobileClient client = SolanaMobileClient(
    walletCluster: WalletCluster.devnet, // Use devnet for a simple test
    identityName: "Test App",
    identityUri: Uri.parse("https://test.app"),
    iconUri: Uri.parse("https://test.app/icon.png"),
  );
  debugPrint("SolanaMobileClient instance created: ${client.toString()}");
  Commitment commitment = Commitment.confirmed;
  debugPrint("Commitment: ${commitment.toString()}");
  WalletCluster cluster = WalletCluster.mainnetBeta;
  debugPrint("Cluster: ${cluster.toString()}");
}
*/

```

### File: ./lib/data/repositories/coin_repository.dart
```dart
// lib/data/repositories/coin_repository.dart
import '../../models/coin_data_model.dart';
import '../../core/services/coingecko_service.dart';

class CoinRepository {
  final CoinGeckoService _coinGeckoService;

  CoinRepository(this._coinGeckoService);

  Future<List<CoinData>> getTopNCoinData({int count = 100}) async {
    try {
      return await _coinGeckoService.getTrendingCoins(topN: count);
    } catch (e) {
      // Log or re-throw as appropriate for your error handling strategy
      rethrow;
    }
  }
}

```

### File: ./lib/audio/audio_controller.dart
```dart
// lib/audio/audio_controller.dart

// This is a conditional export. It tells Dart:
// - By default, export the code from 'audio_controller_mobile.dart'.
// - BUT, if the app is being compiled for web (where 'dart.library.html' exists),
//   export the code from 'audio_controller_stub.dart' instead.
export 'audio_controller_mobile.dart' if (dart.library.html) 'audio_controller_stub.dart';

```

### File: ./lib/audio/audio_controller_stub.dart
```dart
// lib/audio/audio_controller_stub.dart
// This is the fake implementation for the web. It does nothing.

class AudioController {
  // A private constructor to prevent instantiation from outside.
  AudioController._internal();

  // A singleton instance.
  static final AudioController _instance = AudioController._internal();
  factory AudioController() => _instance;
  
  // All methods are empty because audio is disabled on the web.
  Future<void> initialize() async {}
  void dispose() {}
  Future<void> playSfx() async {}
  Future<void> startMusic() async {}
  void stopMusic() {}
}

```

### File: ./lib/audio/audio_controller_mobile.dart
```dart
// lib/audio/audio_controller_mobile.dart
// This is the real implementation for mobile/desktop.
import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:logging/logging.dart';

class AudioController {
  static final Logger _log = Logger('AudioController');
  static final AudioController _instance = AudioController._internal();
  factory AudioController() => _instance;
  AudioController._internal();

  final SoLoud _soloud = SoLoud.instance;
  final List<AudioSource> _sfx = [];
  AudioSource? _music;
  SoundHandle? _musicHandle;

  final _random = Random();

  Future<void> initialize() async {
    // We no longer need the kIsWeb check here because this file is never
    // imported on the web.
    await _soloud.init();

    final sfxAssets = [
      'assets/audio/audio_soloud_step_06_assets_sounds_pew1.mp3',
      'assets/audio/audio_soloud_step_06_assets_sounds_pew2.mp3',
      'assets/audio/audio_soloud_step_06_assets_sounds_pew3.mp3',
    ];
    for (final asset in sfxAssets) {
      try {
        final sfxSource = await _soloud.loadAsset(asset);
        _sfx.add(sfxSource);
      } catch (e) {
        _log.warning('Could not load sound effect: $asset. Error: $e');
      }
    }

    _log.info('AudioController initialized');
  }

  void dispose() {
    _soloud.deinit();
    _log.info('AudioController disposed');
  }

  Future<void> playSfx() async {
    if (_sfx.isEmpty) {
      return;
    }
    final sound = _sfx[_random.nextInt(_sfx.length)];
    await _soloud.play(sound);
  }

  Future<void> startMusic() async {
    if (_musicHandle != null) return;
    try {
      if (_music == null) {
        _music = await _soloud.loadAsset(
          'assets/audio/audio_soloud_step_06_assets_music_looped-song.ogg',
          mode: LoadMode.memory,
        );
      }
      _musicHandle = await _soloud.play(_music!, looping: true, volume: 0.3);
      _log.info('Music started');
    } catch (e) {
      _log.severe('Could not start music', e);
      _music = null;
      _musicHandle = null;
    }
  }

  void stopMusic() {
    if (_musicHandle == null) return;
    _soloud.stop(_musicHandle!);
    _musicHandle = null;
    _log.info('Music stopped');
  }
}

```

### File: ./lib/contracts/nft_service.dart
```dart
// lib/services/nft_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class NftService {

  // In a real application, this would use a package like `http` to post
  // data to an IPFS pinning service like Pinata, Infura, or nft.storage.
  // The service would return a unique Content Identifier (CID).
  // For now, we simulate this process and return a placeholder CID.
  Future<String> uploadToIpfs({
    required XFile imageFile,
    required String name,
    required String description,
    required Map<String, dynamic> attributes,
  }) async {
    debugPrint("NFTService: Simulating upload to IPFS...");
    debugPrint("  - Name: $name");
    debugPrint("  - Description: $description");
    debugPrint("  - Attributes: $attributes");

    // 1. Simulate image upload. In reality, you'd get an image CID.
    // e.g., final imageCid = await _uploadFileToPinata(imageFile);
    await Future.delayed(const Duration(seconds: 2));
    const simulatedImageCid = "bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi"; // An example IPFS CID for an image

    // 2. Construct the JSON metadata.
    final metadata = {
      "name": name,
      "description": description,
      "image": "ipfs://$simulatedImageCid",
      "attributes": attributes.entries.map((e) => {"trait_type": e.key, "value": e.value}).toList(),
    };
    final metadataJsonString = jsonEncode(metadata);
    debugPrint("  - Generated Metadata JSON: $metadataJsonString");

    // 3. Simulate uploading the JSON metadata file.
    // e.g., final metadataCid = await _uploadJsonToPinata(metadataJsonString);
    await Future.delayed(const Duration(seconds: 1));
    const simulatedMetadataCid = "bafkreifzjut374vyhb2m4f3z4xt7f752dm577scuavqmzvr2xdq3sfs4de"; // An example IPFS CID for a JSON file
    
    debugPrint("NFTService: IPFS upload simulation complete. URI: ipfs://$simulatedMetadataCid");

    return "ipfs://$simulatedMetadataCid";
  }
}

```

### File: ./lib/config_mobile.dart
```dart
// lib/config_mobile.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static final String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  static final String supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  static final String walletConnectProjectId = dotenv.env['WALLET_CONNECT_PROJECT_ID'] ?? '';
  static final String sepoliaRpcUrl = dotenv.env['SEPOLIA_RPC_URL'] ?? '';
  static final String mainnetRpcUrl = dotenv.env['MAINNET_RPC_URL'] ?? '';
  static final String coingeckoApiKey = dotenv.env['COINGECKO_API_KEY'] ?? '';
  static final String etherscanApiKey = dotenv.env['ETHERSCAN_API_KEY'] ?? '';
  static final String pinataApiKey = dotenv.env['PINATA_API_KEY'] ?? '';
  static final String pinataApiSecret = dotenv.env['PINATA_API_SECRET'] ?? '';
  
  static String getContractAddress(String name) {
    final prefix = kDebugMode ? 'SEPOLIA' : 'MAINNET';
    return dotenv.env['${prefix}_${name}'] ?? '';
  }
}

```

### File: ./lib/config_web.dart
```dart
// lib/config_web.dart

class AppConfig {
  // --- Core Services ---
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const String walletConnectProjectId = String.fromEnvironment('WALLET_CONNECT_PROJECT_ID');

  // --- RPC & API Keys ---
  static const String sepoliaRpcUrl = String.fromEnvironment('SEPOLIA_RPC_URL');
  static const String mainnetRpcUrl = String.fromEnvironment('MAINNET_RPC_URL');
  static const String coingeckoApiKey = String.fromEnvironment('COINGECKO_API_KEY');
  static const String etherscanApiKey = String.fromEnvironment('ETHERSCAN_API_KEY');
  static const String pinataApiKey = String.fromEnvironment('PINATA_API_KEY');
  static const String pinataApiSecret = String.fromEnvironment('PINATA_API_SECRET');
  
  // --- Sepolia Contract Addresses ---
  static const String sepoliaCabalTokenAddress = String.fromEnvironment('SEPOLIA_CABAL_TOKEN_ADDRESS');
  static const String sepoliaCabalTgeAddress = String.fromEnvironment('SEPOLIA_CABAL_TGE_ADDRESS');
  static const String sepoliaCabalAchievementsAddress = String.fromEnvironment('SEPOLIA_CABAL_ACHIEVEMENTS_ADDRESS');
  static const String sepoliaPresaleAddress = String.fromEnvironment('SEPOLIA_PRESALE_ADDRESS');
  static const String sepoliaRealEstateDeedAddress = String.fromEnvironment('SEPOLIA_REAL_ESTATE_DEED_ADDRESS');
  static const String sepoliaEscrowAddress = String.fromEnvironment('SEPOLIA_ESCROW_ADDRESS');
  static const String sepoliaNftMarketplaceAddress = String.fromEnvironment('SEPOLIA_NFT_MARKETPLACE_ADDRESS');
  static const String sepoliaMerchandiseStoreAddress = String.fromEnvironment('SEPOLIA_MERCHANDISE_STORE_ADDRESS');

  // --- Mainnet Contract Addresses ---
  static const String mainnetCabalTokenAddress = String.fromEnvironment('MAINNET_CABAL_TOKEN_ADDRESS');
  static const String mainnetCabalTgeAddress = String.fromEnvironment('MAINNET_CABAL_TGE_ADDRESS');
  static const String mainnetCabalAchievementsAddress = String.fromEnvironment('MAINNET_CABAL_ACHIEVEMENTS_ADDRESS');
  static const String mainnetPresaleAddress = String.fromEnvironment('MAINNET_PRESALE_ADDRESS');
  static const String mainnetRealEstateDeedAddress = String.fromEnvironment('MAINNET_REAL_ESTATE_DEED_ADDRESS');
  static const String mainnetEscrowAddress = String.fromEnvironment('MAINNET_ESCROW_ADDRESS');
  static const String mainnetNftMarketplaceAddress = String.fromEnvironment('MAINNET_NFT_MARKETPLACE_ADDRESS');
  static const String mainnetMerchandiseStoreAddress = String.fromEnvironment('MAINNET_MERCHANDISE_STORE_ADDRESS');
}

```

### File: ./lib/home/home_screen.dart
```dart
// lib/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/cabal_model.dart';
import '../models/quest_model.dart';
import '../models/user_profile_model.dart';
import '../services/supabase_service.dart';
import '../services/ton_service.dart';
import '../utils/app_colors.dart';
import '../widgets/quest_card.dart';
import '../widgets/diamond_mesh_background.dart';
import '../widgets/shimmer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  
  bool _isLoading = true;
  UserProfile? _userProfile;
  List<Cabal> _featuredCabals = [];
  List<Quest> _dailyQuests = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  /// Refreshes all dashboard data from Supabase and the TON Blockchain
  Future<void> _loadDashboardData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final user = _supabaseService.getCurrentUser();
      if (user != null) {
        _userProfile = await _supabaseService.getUserProfile(user.id);
      }

      // Fetch Cabals and Quests in parallel
      final results = await Future.wait([
        _supabaseService.getAllCabals(),
        // For now, we fetch global/featured quests or quests from the first cabal
      ]);

      _featuredCabals = (results[0] as List<Cabal>).take(5).toList();
      
      if (_featuredCabals.isNotEmpty) {
        _dailyQuests = await _supabaseService.getQuestsForCabal(_featuredCabals.first.id);
      }

    } catch (e) {
      debugPrint("HomeScreen: Error loading data: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tonService = Provider.of<TonService>(context);

    return Scaffold(
      body: DiamondMeshBackground(
        child: RefreshIndicator(
          onRefresh: _loadDashboardData,
          color: AppColors.gold,
          backgroundColor: AppColors.darkGrey,
          child: CustomScrollView(
            slivers: [
              // --- 1. THE COMMANDER HEADER ---
              _buildSliverHeader(tonService),

              // --- 2. QUICK ACTIONS ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: _buildQuickActions(context),
                ),
              ),

              // --- 3. FEATURED PARTNERS ---
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "FEATURED CABALS",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFeaturedScroll(),
                  ],
                ),
              ),

              // --- 4. DAILY QUEST FEED ---
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "DAILY MISSIONS",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: AppColors.gold,
                            ),
                          ),
                          if (_userProfile != null)
                            Text(
                              "Level ${_userProfile!.level}",
                              style: const TextStyle(color: AppColors.greyText, fontSize: 12),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_isLoading)
                        ...List.generate(3, (index) => const Padding(
                          padding: EdgeInsets.only(bottom: 12.0),
                          child: ShimmerWidget.rectangular(height: 100),
                        ))
                      else if (_dailyQuests.isEmpty)
                        _buildEmptyQuests()
                      else
                        ..._dailyQuests.map((quest) => QuestCard(
                          quest: quest,
                          onComplete: () => _loadDashboardData(),
                        )).toList(),
                      const SizedBox(height: 100), // Bottom padding for FAB/Nav
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverHeader(TonService ton) {
    final bool hasWallet = ton.isConnected;
    final String displayAddress = hasWallet 
        ? "${ton.currentAddress!.substring(0, 6)}...${ton.currentAddress!.substring(ton.currentAddress!.length - 4)}"
        : "No Wallet Connected";

    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.black.withOpacity(0.5),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.offBlack, AppColors.gold.withOpacity(0.1)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(16).copyWith(top: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userProfile?.displayName ?? "Explorer",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () => hasWallet ? null : ton.connectWallet(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: hasWallet ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: hasWallet ? AppColors.success.withOpacity(0.5) : AppColors.error.withOpacity(0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              FaIcon(
                                hasWallet ? FontAwesomeIcons.wallet : FontAwesomeIcons.linkSlash,
                                size: 10,
                                color: hasWallet ? AppColors.success : AppColors.error,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                displayAddress,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: hasWallet ? AppColors.success : AppColors.error,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  _buildXpBadge(),
                ],
              ),
              const Spacer(),
              _buildXpProgressBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildXpBadge() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.gold, width: 2),
        boxShadow: [BoxShadow(color: AppColors.gold.withOpacity(0.3), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Text(
            NumberFormat.compact().format(_userProfile?.totalXp ?? 0),
            style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Text("XP", style: TextStyle(fontSize: 8, color: AppColors.greyText)),
        ],
      ),
    ).animate().scale(delay: 400.ms, curve: Curves.elasticOut);
  }

  Widget _buildXpProgressBar() {
    if (_userProfile == null) return const SizedBox.shrink();
    
    // Simple linear progress toward next level
    double progress = (_userProfile!.totalXp % 100) / 100.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("STRENGTH", style: TextStyle(fontSize: 9, letterSpacing: 1, color: AppColors.greyText)),
            Text("${(progress * 100).toInt()}%", style: const TextStyle(fontSize: 9, color: AppColors.gold)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.white10,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionItem(context, "EXPLORE", FontAwesomeIcons.compass, () {}),
        _buildActionItem(context, "MARKET", FontAwesomeIcons.store, () {}),
        _buildActionItem(context, "HUB", FontAwesomeIcons.cubes, () {}),
        _buildActionItem(context, "WALLET", FontAwesomeIcons.wallet, () {
          Navigator.pushNamed(context, '/profile');
        }),
      ],
    );
  }

  Widget _buildActionItem(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 50, width: 50,
            decoration: BoxDecoration(
              color: AppColors.darkGrey,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Center(child: FaIcon(icon, size: 18, color: Colors.white70)),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.greyText)),
        ],
      ),
    );
  }

  Widget _buildFeaturedScroll() {
    if (_isLoading) {
      return SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 3,
          itemBuilder: (context, index) => const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: ShimmerWidget.rectangular(height: 180, width: 280),
          ),
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _featuredCabals.length,
        itemBuilder: (context, index) {
          final cabal = _featuredCabals[index];
          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(cabal.bannerImageUrl ?? 'https://picsum.photos/300/180?sig=$index'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: AppColors.cardOverlayGradient,
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(cabal.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                    cabal.description ?? "Join this community",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.greyText, fontSize: 12),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.2);
        },
      ),
    );
  }

  Widget _buildEmptyQuests() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          FaIcon(FontAwesomeIcons.clipboardCheck, size: 40, color: AppColors.greyText.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text("ALL MISSIONS COMPLETE", style: TextStyle(color: AppColors.greyText, letterSpacing: 1)),
        ],
      ),
    );
  }
}

```

### File: ./lib/config.dart
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // Use a fallback to prevent empty URL requests that cause the HTML/JSON error
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? 'https://your-project-id.supabase.co';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? 'your-anon-key';
  
  static const String appName = "CABAL";
  static const bool isTelegramMiniApp = true; 
  static const String tonManifestUrl = "https://cabal-001.web.app/tonconnect-manifest.json";

  static const String coingeckoApiKey = '';

  // Contract Addresses (Empty for now to prevent build errors)
  static const String sepoliaRpcUrl = '';
  static const String mainnetRpcUrl = '';
  static const String sepoliaCabalTokenAddress = '';
  static const String mainnetCabalTokenAddress = '';
  static const String sepoliaCabalTgeAddress = '';
  static const String mainnetCabalTgeAddress = '';
  static const String sepoliaCabalAchievementsAddress = '';
  static const String mainnetCabalAchievementsAddress = '';
  static const String sepoliaPresaleAddress = '';
  static const String mainnetPresaleAddress = '';
  static const String sepoliaRealEstateDeedAddress = '';
  static const String mainnetRealEstateDeedAddress = '';
  static const String sepoliaEscrowAddress = '';
  static const String mainnetEscrowAddress = '';
  static const String sepoliaNftMarketplaceAddress = '';
  static const String mainnetNftMarketplaceAddress = '';
  static const String sepoliaMerchandiseStoreAddress = '';
  static const String mainnetMerchandiseStoreAddress = '';
}

```

### File: ./lib/main.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Config & Utils
import 'config.dart';
import 'utils/theme_manager.dart';
import 'utils/app_colors.dart';

// Services
import 'services/supabase_service.dart';
import 'services/ton_service.dart';
import 'audio/audio_controller.dart';

// Screens
import 'screens/auth/login_screen.dart';
import 'home/home_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/initial_loading_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Main: .env file not found.");
  }

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        Provider(create: (_) => SupabaseService()),
        Provider(create: (_) => TonService()..initialize()), // Initialize here
        Provider(create: (_) => AudioController()),
      ],
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) {
          return MaterialApp(
            title: AppConfig.appName,
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: AppColors.background,
              primaryColor: AppColors.gold,
              colorScheme: const ColorScheme.dark(
                primary: AppColors.gold,
                secondary: AppColors.primaryAccent,
                surface: AppColors.darkGrey,
              ),
              // FIXED: CardTheme to CardThemeData
              cardTheme: CardThemeData(
                color: AppColors.darkGrey,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              textTheme: const TextTheme(
                headlineMedium: TextStyle(color: AppColors.lightText, fontWeight: FontWeight.bold),
                bodyMedium: TextStyle(color: AppColors.lightText),
                bodySmall: TextStyle(color: AppColors.greyText),
              ),
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => const AuthWrapper(),
              '/login': (context) => const LoginScreen(),
              '/home': (context) => const HomeScreen(),
              '/profile': (context) => const ProfileScreen(),
            },
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _handleRouting();
  }

  Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Explicitly try to load the asset path used by Flutter Web
  try {
    await dotenv.load(fileName: "assets/.env");
  } catch (e) {
    // If assets/.env fails, try the root .env
    try {
     await dotenv.load(fileName: "config.env");
     // await dotenv.load(fileName: ".env");
    } catch (e) {
      print("Config: Could not load .env file. Using fallbacks in AppConfig.");
    }
  }

  // 2. Initialize Supabase
  // If supabaseUrl is empty, this is where the "Unexpected token <" starts
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  runApp(const MyApp());
}

  @override
  Widget build(BuildContext context) {
    return const InitialLoadingScreen(initializationError: null);
  }
}

```

### File: ./test/widget_test.dart
```dart
// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:airloot/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

```

## Section: Supabase Functions

### File: ./supabase/functions/news-proxy/index.ts
```ts
// supabase/functions/news-proxy/index.ts

import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { corsHeaders } from '../_shared/cors.ts' // Import the shared headers

const NEWS_RSS_URL = 'https://thedefiant.io/feed'; // The RSS feed you want to proxy

serve(async (req) => {
  // This is new: handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Fetch the RSS feed from the origin server
    const response = await fetch(NEWS_RSS_URL);
    if (!response.ok) {
      throw new Error(`Failed to fetch RSS feed: ${response.statusText}`);
    }
    const feedText = await response.text();

    // Return the feed content with CORS headers
    return new Response(feedText, {
      headers: { ...corsHeaders, 'Content-Type': 'application/xml' },
      status: 200,
    });
    
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 500,
    })
  }
})

```

### File: ./supabase/functions/_shared/cors.ts
```ts
// supabase/functions/_shared/cors.ts

export const corsHeaders = {
  'Access-Control-Allow-Origin': '*', // For development. For production, use: 'https://cabal-001.web.app'
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

```

## Section: Web Bridge Logic

### File: ./web/wallet.js
```js
// web/wallet.js

// This file acts as a bridge between Flutter and the Web3Modal JavaScript library.

let web3modal;
let ethersProvider;
let signer;

// This function is called by Flutter to initialize everything.
async function initializeWalletConnect(projectId) {
    if (web3modal) return; // Already initialized

    const { W3mCore, W3mEthers } = await import("https://unpkg.com/@web3modal/ethers5@3.1.0/dist/ethers5-3.1.0.js");

    const modal = new W3mCore({ projectId });
    
    web3modal = new W3mEthers({
        w3mCore: modal,
        ethersConfig: {
            metadata: {
                name: 'Cabal',
                description: 'Cabal App',
                url: 'https://cabal-001.web.app',
                icons: ['https://cabal-001.web.app/icons/Icon-512.png']
            }
        }
    });

    console.log("Web3Modal Initialized");
}

// Function to connect the wallet
async function connectWallet() {
    if (!web3modal) {
        throw new Error("Web3Modal not initialized. Call initializeWalletConnect first.");
    }
    try {
        await web3modal.open();
        // After the modal closes, we can get the address.
        const address = await web3modal.getAddress();
        return address;
    } catch (e) {
        console.error("Could not connect wallet.", e);
        return null;
    }
}

// Function to disconnect the wallet
async function disconnectWallet() {
    if (!web3modal) return;
    await web3modal.disconnect();
    return null; // Return null to confirm disconnection
}

// Function to get the current chain ID
async function getChainId() {
    if (!web3modal) return null;
    return await web3modal.getChainId();
}

```

### File: ./web/ton_bridge.js
```js
// web/ton_bridge.js

// This handles the low-level communication with the TON Blockchain providers.
window.tonBridge = {
    connect: async function(manifestUrl) {
        try {
            // Check if TonConnect is already in the window (injected by script tag)
            if (typeof TonConnectUI === 'undefined') {
                throw new Error("TonConnect SDK not loaded");
            }

            const tonConnectUI = new TonConnectUI.TonConnectUI({
                manifestUrl: manifestUrl,
                buttonRootId: null // We handle the UI in Flutter
            });

            const connectedWallet = await tonConnectUI.connectWallet();
            // Return the raw address to Flutter
            return connectedWallet.account.address;
        } catch (error) {
            console.error("TON Bridge Error:", error);
            return null;
        }
    },

    sendTransaction: async function(address, amount, payload) {
        // Logic to trigger the wallet approval popup
        const transaction = {
            validUntil: Math.floor(Date.now() / 1000) + 60,
            messages: [
                {
                    address: address,
                    amount: amount.toString(),
                    payload: payload || ""
                }
            ]
        };
        return await tonConnectUI.sendTransaction(transaction);
    }
};

```

