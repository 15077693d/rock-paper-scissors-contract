// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title RockPaperScissors
 */

contract RockPaperScissors{
    enum Option{ ROCK, PAPER, SCISSORS}
    address public userA;
    address public userB;
    Option private  userAOption;
    Option private  userBOption;
    address public tokenAddress;
    uint256 public bettingAmount;
    constructor(address _tokenAddress, uint256 _bettingAmount){
        tokenAddress = _tokenAddress;
        bettingAmount = _bettingAmount;
    }

    function selectWinner() public{
        ERC20(tokenAddress).transferFrom(address(this),userA, bettingAmount*2);
    }

    function setOption(Option _option) public {
        if(userA==address(0)){
            userAOption = _option;
            userA = msg.sender;
            ERC20(tokenAddress).transfer(address(this), bettingAmount);
        }else{
            userBOption = _option;
            userB = msg.sender;
            ERC20(tokenAddress).transfer(address(this), bettingAmount);
        }
    }
}