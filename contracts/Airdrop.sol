// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Airdrop {

    address public bbb;
    constructor(address _token) {
        bbb = _token;
    }
    function airdrop(address[] memory addresses) public {
        for (uint i = 0; i < addresses.length; i++) {
            IERC20(bbb).transfer(addresses[i], 100*10**18);
        }
    }
}