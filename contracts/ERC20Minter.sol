// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Minter is ERC20 {
    constructor() ERC20("Bibimbeat", "BBB") {
        _mint(msg.sender, 1000000000 * 10 ** decimals());
    }
}