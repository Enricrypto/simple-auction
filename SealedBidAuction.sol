// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract SealedBidAuction {
    // Auction parameters
    address public immutable beneficiary;
    uint256 public biddingEnd;
    uint256 public revealEnd;

    // State of the auction
    uint256 public highestBid;
    address public highestBidder;
    bool public hasEnded;

    // Allowed withdrawals of previous bids
    mapping(address => uint256) public pendingReturns;

    event AuctionEnded(address winner, uint256 amount);

    constructor(
        address _beneficiary,
        uint256 _durationBiddingMinutes,
        uint256 _durationRevealMinutes
    ) {
        beneficiary = _beneficiary;
        biddingEnd = block.timestamp + _durationBiddingMinutes * 1 minutes;
        revealEnd = biddingEnd + _durationRevealMinutes * 1 minutes;
    }

    function withdraw() external returns (uint256 amount) {
        amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;
            payable(msg.sender).transfer(amount);
        }
    }

    function generateSealedBid(
        uint _bidAmount,
        bool _isLegit,
        string memory _secret
    ) public pure returns (bytes32 sealedBid) {
        sealedBid = keccak256(abi.encodePacked(_bidAmount, _isLegit, _secret));
    }
}
