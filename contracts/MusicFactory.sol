// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MusicFactory is ERC1155 {
    
    using Counters for Counters.Counter;
    
    Counters.Counter public tokenId;

    mapping(uint256 => bytes) URIs;

    event AddMintedMusic(uint256 tokenId, address account, uint256 amount, string uri);
    event GetMintedMusic(address account);

    constructor() ERC1155("")  {
        tokenId.increment();
    }
    
    function mintMusic(uint256 _amount, string memory _uri) public {
        bytes memory tokenUri = bytes(_uri);
        _mint(msg.sender, tokenId.current(), _amount, tokenUri);
        URIs[tokenId.current()] = tokenUri;
        emit AddMintedMusic(tokenId.current(), msg.sender, _amount, _uri);
        tokenId.increment();
    }
    
    function airdrop(uint256 tokenId, uint256[] memory amounts, address[] memory addresses) public {
        for (uint i = 0; i < addresses.length; i++) {
            safeTransferFrom(msg.sender, addresses[i], tokenId, amounts[i], "");
        }
    }


    function getMyMusicList() public {
        emit GetMintedMusic(msg.sender);
    }

    function getTokenURI(uint256 tokenId) public view returns(bytes memory uri) {
        uri = URIs[tokenId];
    }
}