// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "hardhat/console.sol";
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
    function selectWinner() internal {
        if(userA!=address(0)&&userB!=address(0)){
            bool userAWin = userAOption==Option.PAPER&&userBOption==Option.ROCK
                            ||userAOption==Option.SCISSORS&&userBOption==Option.PAPER
                            ||userAOption==Option.ROCK&&userBOption==Option.SCISSORS;
           if(userAOption==userBOption){
            ERC20(tokenAddress).transfer(userA,bettingAmount);
            ERC20(tokenAddress).transfer(userB,bettingAmount);
           }else if(userAWin){
            ERC20(tokenAddress).transfer(userA,bettingAmount*2);
           }else{
            ERC20(tokenAddress).transfer(userB,bettingAmount*2);
           }
           
        }
    }

    function setOption(Option _option) public {
        if(userA==address(0)){
            userAOption = _option;
            userA = msg.sender;
            ERC20(tokenAddress).transferFrom(msg.sender, address(this), bettingAmount);
        }else{
            userBOption = _option;
            userB = msg.sender;
            ERC20(tokenAddress).transferFrom(msg.sender, address(this), bettingAmount);
        }
        selectWinner();
    }
}