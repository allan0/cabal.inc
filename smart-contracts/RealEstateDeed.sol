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
