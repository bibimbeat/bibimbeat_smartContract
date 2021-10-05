
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
// import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

interface updateOwnedTokenList {
   function updateOwnedTokenList(uint256 tokenId, uint256 amount, address newOwner, address oldOwner) external
}




contract MusicMarket is IERC1155Receiver, updateOwnedTokenList {
        struct Trade {
        address poster;
        uint256 item;
        uint256 amount;
        uint price;
        bytes32 status; // Open, Executed, Cancelled
    }
    
    mapping(uint256 => Trade) public trades;
    
    IERC20 currencyToken;
    IERC1155 itemToken;
    uint256 tradeCounter;
    
    event TradeStatusChange(uint256 tradeCounter, bytes32 status);
    
    constructor(address _currencyTokenAddress, address _itemTokenAddress) {
        currencyToken = IERC20(_currencyTokenAddress);
        itemToken = IERC1155(_itemTokenAddress);
        tradeCounter = 0;
    }
    

    
    function openTrade(uint256 _item, uint256 _price, uint _amount) public {
        require(itemToken.balanceOf(msg.sender, _item) >= _amount, "insufficient amount of NFT!");
        
        itemToken.safeTransferFrom(msg.sender, address(this), _item, _amount, "");
        trades[tradeCounter] = Trade(msg.sender, _item, _amount, _price, "OPEN");
        tradeCounter++;
        emit TradeStatusChange(tradeCounter - 1, "OPEN");
    }
    
    function executeTrade(uint256 _tradeCounter) public {
        Trade memory trade = trades[_tradeCounter];
        require(trade.status == "OPEN", "Trade is not open.");
        currencyToken.transferFrom(msg.sender, trade.poster, trade.price);
        itemToken.safeTransferFrom(address(this), msg.sender, trade.item, trade.amount, "");
        trades[_tradeCounter].status = "EXECUTED";
        emit TradeStatusChange(_tradeCounter, "EXECUTED");
    }
    
    function cancelTrade(uint256 _tradeCounter) public {
        Trade memory trade = trades[_tradeCounter];
        require(msg.sender == trade.poster, "Trade can be cancelled only by poster.");
        require(trade.status == "OPEN", "Trade is not open.");
        itemToken.safeTransferFrom(address(this), trade.poster, trade.item, trade.amount, "");
        trades[_tradeCounter].status = "CANCELLED";
        emit TradeStatusChange(_tradeCounter, "CANCELLED");
    }
    
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
    
  function onERC1155Received(
    address operator,
    address from,
    uint256 id,
    uint256 value,
    bytes calldata data
    )
    external
    // override
    returns(bytes4)
    {
      return   this.onERC1155Received.selector;
    }

function onERC1155BatchReceived(
    address operator,
    address from,
    uint256[] calldata ids,
    uint256[] calldata values,
    bytes calldata data
    )
    external
    // override
    returns(bytes4)
    {
      return   this.onERC1155BatchReceived.selector;
    }
    
}
