// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MusicFactory is ERC1155 {
    
    using Counters for Counters.Counter;
    
    Counters.Counter private _tokenId;
    
    struct TokenStruct {
        uint256[] tokenIDs;
        mapping(uint256 => bytes) URIs;
        mapping(uint256 => uint256) amount;
    }

    mapping(address => TokenStruct) OwnedTokenList;

    constructor() ERC1155("")  {
        _tokenId.increment();
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
    
    function getTokenURI(address account, uint256 tokenId) public view returns(bytes memory uri) {
        uri = OwnedTokenList[account].URIs[tokenId];
    }
    
    function getTokenAmount(uint256 tokenId) public view returns(uint256 amount) {
        amount = OwnedTokenList[msg.sender].amount[tokenId];
    }
    
    //function below should only be called by the market logic. but for now, leave it this way.
    // at the moment everyone can call this... it is a problem
    
    // Also, SetapproveForAll doesnot have amount parameter and not have time limit.
    // Also...whatever we are doing here... we still cannot get access to tokens minted from other markets. 
    
    function updateOwnedTokenList(uint256 tokenId, uint256 amount, address newOwner, address oldOwner) external
    {
        //New Owner token struct update
        //the amount in funtion parameter above is the amount that is on the tradeblock in market smart contract.
        OwnedTokenList[newOwner].tokenIDs.push(tokenId);
        OwnedTokenList[newOwner].amount[tokenId] += amount;
        OwnedTokenList[newOwner].URIs[tokenId] = OwnedTokenList[oldOwner].URIs[tokenId];
    
        //Old Owner token struct update
        //when the amount is 0, front end should not display MTs on the client side.
        OwnedTokenList[oldOwner].amount[tokenId] -= amount;
        
        //possible issue  -  If the market logic would make trade for MTs that are not minted from this smart contract, updateOwnedTokenList will
        //throw errors and may cause serious issues. For now we are solving this problem since it is a prototype stage.
        
    }
}