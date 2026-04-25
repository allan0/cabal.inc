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
