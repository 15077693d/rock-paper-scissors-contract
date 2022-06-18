// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title RPS
 * @dev Create a sample ERC20 standard token
 * @custom:dev-run-script scripts/ERC20.ts
 */
contract RPS is ERC20("RockPaperScissorsCoin", "RPS") {
    function faucet(uint256 amount) external {
        _mint(_msgSender(), amount);
    }
}
