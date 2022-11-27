// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

contract AgeOfEmpires is
    ERC1155,
    Ownable,
    Pausable,
    ERC1155Burnable,
    ERC1155Supply
{
    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;
    string public name;

    address private MINT_DESTINATION =
        0x85a1b7ad92c3d354582F9F858E5fF7a6b7A615ce;

    // Modifiers
    modifier enoughResources(uint256 id) {
        if (id == 4) {
            require(
                balanceOf(msg.sender, 0) >= 25,
                "Not enough wood to build a house"
            );
        } else if (id == 5) {
            require(
                balanceOf(msg.sender, 0) >= 100,
                "Not enough wood to build a fortress"
            );
            require(
                balanceOf(msg.sender, 1) >= 150,
                "Not enough stone to build a fortress"
            );
        } else if (id == 6) {
            require(
                balanceOf(msg.sender, 0) >= 120,
                "Not enough wood to build a cathedral"
            );
            require(
                balanceOf(msg.sender, 1) >= 180,
                "Not enough stone to build a cathedral"
            );
            require(
                balanceOf(msg.sender, 2) >= 50,
                "Not enough copper to build a cathedral"
            );
        } else if (id == 7) {
            require(
                balanceOf(msg.sender, 0) >= 140,
                "Not enough wood to build a sanctuary"
            );
            require(
                balanceOf(msg.sender, 1) >= 200,
                "Not enough stone to build a sanctuary"
            );
            require(
                balanceOf(msg.sender, 2) >= 100,
                "Not enough copper to build a sanctuary"
            );
            require(
                balanceOf(msg.sender, 3) >= 50,
                "Not enough gold to build a sanctuary"
            );
        }
        _;
    }

    constructor(string memory _name)
        ERC1155(
            /* nft storage
            "ipfs://bafybeiatlk3xsofqa476cfkmohohmf2d5m7tbpibkp5yape2jgmic6enzy/{id}" */
            // pinata
            "https://ipfs.io/ipfs/QmVMf4t7d5DjfgdB9pwL6kBWowFxN7jaVxSxQRewSWkrgy/{id}"
        )
    {
        name = _name;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public enoughResources(id) {
        _mint(account, id, amount, data);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyOwner {
        _mintBatch(to, ids, amounts, data);
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override(ERC1155, ERC1155Supply) whenNotPaused {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
