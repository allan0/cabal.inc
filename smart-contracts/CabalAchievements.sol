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
