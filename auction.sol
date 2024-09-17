// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract SimpleAuction {
    // auction parameters
    address public immutable beneficiary;
    uint public endTime; // As UNIX timestamp

    // State of the auction
    uint public highestBid;
    address public highestBidder;
    bool public hasEnded;

    constructor(address _beneficiary, uint _durationMinutes) {
        beneficiary = _beneficiary;
        endTime = block.timestamp + _durationMinutes * 1 minutes; //need to add the 1 for syntax purposes
    }

    // allows withdrawals of previous bids
    mapping(address => uint) public pendingReturns;

    // Events
    event NewBid(address indexed bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    function bid() public payable {
        // payable modifier allows the contract to receive ether
        require(block.timestamp < endTime, "Auction has ended");
        require(msg.value > highestBid, "Bid too low"); // if msg.value is the highest bid then:
        if (highestBid != 0) {
            pendingReturns[highestBidder] += highestBid;
        }
        highestBid = msg.value; // msg.value gets stored in the highestBid variable and...
        highestBidder = msg.sender; // msg.sender gets stored in the highestBidder variable
        emit NewBid(msg.sender, msg.value);
    }

    function withdraw() external returns (uint256 amount) {
        // TWO OPTIONS:
        // refund as part of the new bid transaction ---> Passing execution to another addres introduces significant security risk
        // allow the user to withdraw his invalidated bids --> preferred option

        amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;
            payable(msg.sender).transfer(amount);
        }
        return amount;
    }

    function auctionEnd() external {
        // 1. Check all conditions
        require(!hasEnded, "Auction already ended");
        require(block.timestamp >= endTime, "Wait for auction to end");

        // 2.  Apply all internal state changes
        hasEnded = true;
        emit AuctionEnded(highestBidder, highestBid);

        // 3. Interact with other addresses
        payable(beneficiary).transfer(highestBid);
    }
}
