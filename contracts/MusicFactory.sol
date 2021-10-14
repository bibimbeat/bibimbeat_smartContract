// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MusicFactory is ERC1155 {
    
    using Counters for Counters.Counter;
    
    Counters.Counter public tokenId;

    mapping(uint256 => bytes) URIs;

    constructor() ERC1155("")  {
        tokenId.increment();
    }
    
    function mintMusic(uint256 _amount, string memory _uri) public {
        bytes memory tokenUri = bytes(_uri);
        _mint(msg.sender, tokenId.current(), _amount, tokenUri);
        URIs[tokenId.current()] = tokenUri;
        tokenId.increment();
    }

    
    function getTokenURI(uint256 tokenId) public view returns(bytes memory uri) {
        uri = URIs[tokenId];
    }
}