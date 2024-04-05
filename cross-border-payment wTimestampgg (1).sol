// SPDX-License-Identifier: MIT
pragma solidity ^0.7;


contract CrossBorderPayment {
    address public owner;
    uint256 dW = 301672780000000; // dollars to wei conversion ratio.
    uint256 pW = 301672780000000; // pesos to wei conversion ratio.
    // calculated from https://www.coinbase.com/converter/RATIO/USD. 

    // Event declaration for transaction completion
    event PaymentProcessed(address sender, address receiver, uint amount, string currency, uint time);

    constructor() {
        owner = msg.sender;
        
    }
    function processPayment(address payable receiver, uint amount, string memory currency) public {
        // require the currency to be to be in USD, PESO, ETHER, GWEI, WEI.
        // GWEI and WEI are both just denominations of Ether. 
        require(
            keccak256(abi.encodePacked(currency)) == keccak256(abi.encodePacked("USD")) ||
            keccak256(abi.encodePacked(currency)) == keccak256(abi.encodePacked("PESO")) ||
            keccak256(abi.encodePacked(currency)) == keccak256(abi.encodePacked("ETHER")) ||
            keccak256(abi.encodePacked(currency)) == keccak256(abi.encodePacked("GWEI")) ||
            keccak256(abi.encodePacked(currency)) == keccak256(abi.encodePacked("WEI")),
            "Cannot transact");
        // Payment processing logic
        if (keccak256(abi.encodePacked(currency)) == keccak256(abi.encodePacked("USD"))) {
            // Transfer USD amount in wei to the receiver
            receiver.transfer(amount * dW);
        }

         if (keccak256(abi.encodePacked(currency)) == keccak256(abi.encodePacked("PESO"))) {
            // Transfer USD amount in wei to the receiver
            receiver.transfer(amount *pW);
        }
        if (keccak256(abi.encodePacked(currency)) == keccak256(abi.encodePacked("ETHER"))) {
            // Transfer USD amount in wei to the receiver
            receiver.transfer(amount * 1 ether);
        }
        if (keccak256(abi.encodePacked(currency)) == keccak256(abi.encodePacked("GWEI"))) {
            // Transfer USD amount in wei to the receiver
            receiver.transfer(amount * 1 gwei);
        }
        if (keccak256(abi.encodePacked(currency)) == keccak256(abi.encodePacked("Wei"))) {
            // Transfer USD amount in wei to the receiver
            receiver.transfer(amount);
        }
        // Emitting an event after successful payment processing
        emit PaymentProcessed(msg.sender, receiver, amount, currency, block.timestamp);

        

        // Automatically transfers the specified amount to the receiver
        checkAutomaticWithdrawal();


    }

// verifies that balence being withdrawn  from the smart contract acccount falls within the given range. 
// This is represented in Dollars. 
function checkAutomaticWithdrawal() private {
    uint nbalance = address(this).balance / dW;
    uint minBalance = 5; // mininmum transfer bound is $ 5.
    uint maxBalance = 20; // maximum transfer amount is $ 20
    if (nbalance < maxBalance && nbalance > minBalance  ) {
        withdraw(); // Withdraw if balance is within the desired ranges.
    }
}
//deposits etherum into the smart contract.
    function deposit()public payable {

    }
//checks the balence in the crossboader smart contract, which is represented in Wei.
    function checkBalance() public view returns (uint) {
    return address(this).balance;
}

    // Function to deposit funds in the contract to the reciving account.
    receive() external payable {}

    // Ensure only the owner can withdraw funds (for simplicity)
    function withdraw() public {
        payable(owner).transfer(address(this).balance);
    }
}