pragma solidity ^0.7.6;

import "@openzeppelin/contracts/presets/ERC1155PresetMinterPauser.sol";

contract NFTMinterPauser is ERC1155PresetMinterPauser {
    constructor() ERC1155PresetMinterPauser("") {
    }
}