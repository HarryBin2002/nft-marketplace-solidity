// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// This Contract is only use to test
contract MyUSDT is ERC20 {
    constructor() ERC20("MyUSDT", "USDT") {}

    // Default call function: mint USDt to msg.sender with 100000 token USDT.
    function mintUSDT() public {
        _mint(msg.sender, 100000 * (10**18));
    }
}