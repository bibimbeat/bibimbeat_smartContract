// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MusicFactory is ERC1155 {
    
    using Counters for Counters.Counter;
    
    // address public owner;
    // address private _tokenAddress;
    Counters.Counter private _tokenId;
    
    struct TokenStruct {
        uint256[] tokenIDs;
        mapping(uint256 => bytes) URIs;
        mapping(uint256 => uint256) amount;
    }

    mapping(address => TokenStruct) OwnedTokenList;

    constructor() ERC1155("")  {
        // owner = msg.sender;
        // _tokenAddress = address(this);
    }
    
    function mintMusic(uint256 _amount, string memory _uri) public {
        bytes memory tokenUri = bytes(_uri);
        _mint(msg.sender, _tokenId.current(), _amount, tokenUri);
        OwnedTokenList[msg.sender].tokenIDs.push(_tokenId.current());
        OwnedTokenList[msg.sender].amount[_tokenId.current()] = _amount;
        OwnedTokenList[msg.sender].URIs[_tokenId.current()] = tokenUri;
        _tokenId.increment();
    }
    
    // client need to call getTokenIDs prior to call getTokenURI or getTokenAmount
    
    function getTokenIDs() public view returns(uint256[] memory tokenIDs) {
        tokenIDs = OwnedTokenList[msg.sender].tokenIDs;
    }
    
    function getTokenURI(uint256 tokenId) public view returns(bytes memory uri) {
        uri = OwnedTokenList[msg.sender].URIs[tokenId];
    }
    
    function getTokenAmount(uint256 tokenId) public view returns(uint256 amount) {
        amount = OwnedTokenList[msg.sender].amount[tokenId];
    }
}