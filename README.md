🕵️‍♂️ Sealed Bid Auction – Solidity Smart Contract
This repository contains a Sealed-Bid, Two-Phase Auction smart contract written in Solidity. Participants submit encrypted (sealed) bids during the bidding phase and reveal them in the reveal phase. This preserves privacy and fairness until all bids are disclosed. The highest valid bid wins, and the winner’s funds are transferred to the beneficiary at the end of the auction.

🔑 How It Works
The auction occurs in two distinct phases:

Bidding Phase

Users submit a sealed bid (a hash of their actual bid amount, legitimacy flag, and a secret).

The bid is accompanied by a deposit (must be ≥ potential bid).

Reveal Phase

Users reveal their actual bid, whether it's legitimate (true/false), and their original secret.

If the reveal matches the hash and is valid, the bid is considered for winning.

The highest valid bid becomes the winner.

📦 Features
Sealed Bidding: Prevents front-running or early disclosure of bid amounts.

Two-Phase Auction: Encourages fair play by separating commitment and reveal.

Refund Mechanism: Participants reclaim excess deposit or lose nothing if their bid is invalid.

Safe Withdrawals: Outbid users can safely withdraw their deposits.

Secure Finalization: Only callable once, ensuring funds go to the beneficiary.

🧾 Contract Details
Parameter	Description
beneficiary	Recipient of the winning bid funds
biddingEnd	Timestamp marking the end of the bidding phase
revealEnd	Timestamp marking the end of the reveal phase
highestBid	Current highest valid bid revealed
highestBidder	Address of the top bidder
pendingReturns	Tracks withdrawable amounts for users who were outbid

⌛ Phases and Timeline
Bidding Phase: Submit a sealed bid (hash) with a deposit → ends at biddingEnd.

Reveal Phase: Reveal bid amount, flag, and secret to validate → ends at revealEnd.

End Auction: Finalize auction and transfer funds to beneficiary.

⚙️ Core Functions
solidity
Copy
Edit
bid(bytes32 _sealedBid)
Submit a hashed (sealed) bid with ETH deposit.

Only allowed before biddingEnd.

solidity
Copy
Edit
reveal(uint _bidAmount, bool _isLegit, string _secret)
Reveal the bid after bidding has ended.

Validates bid hash, legitimacy, and deposit size.

Updates the highest bid if valid.

solidity
Copy
Edit
auctionEnd()
Callable only after the reveal phase.

Transfers the highest bid to the beneficiary.

solidity
Copy
Edit
withdraw()
Allows non-winning bidders to withdraw unused deposits.

solidity
Copy
Edit
generateSealedBid(uint, bool, string)
Public utility function for off-chain hash generation.

📤 Events
AuctionEnded(address winner, uint256 amount): Emitted once at the end of the auction.

🧪 How to Use (Simplified)
Off-chain:
Generate sealed bid hash
keccak256(abi.encodePacked(bidAmount, isLegit, secret))

On-chain:

Call bid() with the sealed hash and ETH deposit.

Wait until biddingEnd.

Reveal:

Call reveal(bidAmount, isLegit, secret) during reveal phase.

Contract checks your hash and updates the winner.

Finalize:

Anyone can call auctionEnd() after revealEnd.

Withdraw:

Losing bidders can reclaim funds via withdraw().
