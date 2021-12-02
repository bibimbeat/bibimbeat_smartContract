// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
// import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

// interface UpdateOwnedToken {
//    function updateOwnedTokenList(uint256 tokenId, uint256 amount, address newOwner, address oldOwner) external;
// }

contract MusicMarket is IERC1155Receiver{
     
     using SafeMath for uint256;
    
    struct Trade {
        address poster;
        address creator;
        uint256 item;
        uint256 amount;
        uint price;
        bytes32 status; // Open, Executed, Cancelled
    }
    
    mapping(uint256 => Trade) public trades;
    
    IERC20 currencyToken;
    IERC1155 itemToken;
    uint256 public tradeCounter;
    address public marketAddress;
    
    event TradeStatusChange(uint256 tradeCounter, bytes32 status);
    
    // NFTs not minted not from our smart cotract should not pass
    
    constructor(address _currencyTokenAddress, address _itemTokenAddress) {
        currencyToken = IERC20(_currencyTokenAddress);
        itemToken = IERC1155(_itemTokenAddress);
        tradeCounter = 0;
        marketAddress = msg.sender; // 
    }
    

    //  Logged in EoA should be able to see tradeblock status of his MTs. mapping(eoa => tradeCounter[]);
    
    // when the trade is open, it should also adjust struct in MusicFactory.
    
    function openTrade(address _creator, uint256 _item, uint256 _price, uint _amount) public {
        require(itemToken.balanceOf(msg.sender, _item) >= _amount, "insufficient amount of NFT!");
        itemToken.safeTransferFrom(msg.sender, address(this), _item, _amount, "");
        trades[tradeCounter] = Trade(msg.sender, _creator, _item, _amount, _price, "OPEN");
        tradeCounter++;
        emit TradeStatusChange(tradeCounter - 1, "OPEN");
    }
    
    function executeTrade(uint256 _tradeCounter, uint256 _amount) payable public {
        Trade memory trade = trades[_tradeCounter];
        require(trade.amount >= _amount, "insufficient amount of NFT!");
        require(trade.status == "OPEN", "Trade is not open.");
        
        uint256 totalPrice = trade.price.mul(_amount); // 100 * 100 = 10000
        
        uint256 creatorFee = totalPrice.mul(25).div(1000); // 2250
        uint256 marketFee = totalPrice.mul(25).div(1000); // 2250
        uint256 priceWithoutFee = totalPrice.sub(creatorFee.add(marketFee)); // 90000 - 4500 = 85500
        
        currencyToken.transferFrom(msg.sender, trade.poster, priceWithoutFee);
        currencyToken.transferFrom(msg.sender, trade.creator, creatorFee);
        currencyToken.transferFrom(msg.sender, marketAddress, marketFee);
        
        itemToken.safeTransferFrom(address(this), msg.sender, trade.item, _amount, "");
        if (trades[_tradeCounter].amount == _amount) {
            trades[_tradeCounter].status = "EXECUTED";
            emit TradeStatusChange(_tradeCounter, "EXECUTED");
        }
        else {
            trades[_tradeCounter].amount -= _amount;
            trades[_tradeCounter].status = "OPEN";
            emit TradeStatusChange(_tradeCounter, "OPEN");
        }
                
        // UpdateOwnedToken(factoryAddress).updateOwnedTokenList(trade.item, trade.amount, msg.sender, trade.poster);
        
    }
    
    //cancel trade should also shange state in Music Factory's amoutn state
    
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
    override
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
    override
    returns(bytes4)
    {
      return   this.onERC1155BatchReceived.selector;
    }
    
}