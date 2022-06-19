// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title RockPaperScissors
 */

contract RockPaperScissors {
    // Rock (1) Paper (2) Scissors (3)
    address public userA;
    address public userB;
    mapping(address => uint8) private options;
    mapping(address => bytes32) private hashes;
    address public tokenAddress;
    uint256 public bettingAmount;

    constructor(address _tokenAddress, uint256 _bettingAmount) {
        tokenAddress = _tokenAddress;
        bettingAmount = _bettingAmount;
    }

    modifier RoomNotFull(){
        require(userA==address(0)||userB==address(0),"Room is full");
        _;
    }

    modifier TwoHashesReady(){
        require(hashes[userA]!=0&&hashes[userB]!=0,"Two Hashes are not Ready");
        _;
    }

    function reveal(string calldata salt) public TwoHashesReady{
        assignOption(salt,msg.sender);
        if(options[userA]!=0&&options[userB]!=0){
            selectWinner();
            // reset
            options[userA]=0;
            options[userA]=0;
            hashes[userB]=0;
            hashes[userB]=0;
            userA=address(0);
            userB=address(0);
        }
    }

    function assignOption(string calldata salt,address _userAddress) internal{
        bool isROCK = keccak256(abi.encodePacked("1", salt))==hashes[_userAddress];
        bool isPAPER = keccak256(abi.encodePacked("2", salt))==hashes[_userAddress];
        bool isSCISSORS = keccak256(abi.encodePacked("3", salt))==hashes[_userAddress];
        if(isROCK){
            options[_userAddress] = 1;
        }else if(isPAPER) {
            options[_userAddress] = 2;
        }else if (isSCISSORS){
            options[_userAddress] = 3;
        }
    }
    
    function selectWinner() internal {
            uint8 userAOption = options[userA];
            uint8 userBOption = options[userB];
            bool userAWin = (userAOption == 1 &&
                userBOption == 3) ||
                (userAOption == 2 &&
                    userBOption == 1) ||
                (userAOption == 3 && userBOption == 2);
            if (userAOption == userBOption) {
                ERC20(tokenAddress).transfer(userA, bettingAmount);
                ERC20(tokenAddress).transfer(userB, bettingAmount);
            } else if (userAWin) {
                ERC20(tokenAddress).transfer(userA, bettingAmount * 2);
            } else {
                ERC20(tokenAddress).transfer(userB, bettingAmount * 2);
            }
    }

    function commit(bytes32 _hash) public RoomNotFull{
        if (userA == address(0)) {
            userA = msg.sender;
            hashes[userA] = _hash;
            ERC20(tokenAddress).transferFrom(
                msg.sender,
                address(this),
                bettingAmount
            );
        } else {
            userB = msg.sender;
            hashes[userB] = _hash;
            ERC20(tokenAddress).transferFrom(
                msg.sender,
                address(this),
                bettingAmount
            );
        }
    }

    function getHash(string calldata option,string calldata salt) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(option,salt));
    }
}
