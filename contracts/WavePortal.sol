// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";
// with this ^^ library, we can use console logging and util.format() to print statements
// see [util.format](https://nodejs.org/dist/latest-v12.x/docs/api/util.html#util_util_format_format_args) for full list

contract WavePortal {
  address owner;
  address[] prizeWinners;
  uint256 totalWaves;
  uint256 private seed;

  event NewWave(address indexed from, uint256 timestamp, string message, bool prizeWon);

  struct Wave {
    address waver;
    uint256 timestamp;
    string message;
    bool prizeWon;
  }

  Wave[] waves;

  // store the address with the last time the user waved at us
  mapping(address => uint256) public lastWavedAt;

  constructor() payable {
    owner = msg.sender;
    console.log("Hi, I am a smart contract. I am a program deployed to the blockchain by %s.", owner);
  }

  function wave(string memory _message) public {
    require(
      lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
      "Wait 15m"
    );

    lastWavedAt[msg.sender] = block.timestamp;

    totalWaves += 1;
    bool prizeWon = false;
    uint256 randomNumber = (block.difficulty + block.timestamp + seed) % 100;
    console.log("Random # generated: %s", randomNumber);
    seed = randomNumber;

    if (owner == msg.sender) {
      console.log("itsPanicky has waved!");
    } else if (senderAlreadyWonPrize(msg.sender)) {
      console.log("%s has won the prize already!", msg.sender);
    } else {
      console.log("%s has waved!", msg.sender);

      if (randomNumber < 50) {
        console.log("%s won!", msg.sender);

        uint256 prizeAmount = 0.0001 ether;
        require(
            prizeAmount <= address(this).balance,
            "Trying to withdraw more money than the contract has."
        );
        (bool success, ) = (msg.sender).call{value: prizeAmount}("");
        require(success, "Failed to withdraw money from contract.");
        addWinner(msg.sender);
        prizeWon = true;
      }
    }

    waves.push(Wave(msg.sender, block.timestamp, _message, prizeWon));
    emit NewWave(msg.sender, block.timestamp, _message, prizeWon);
  }

  function getAllWaves() public view returns (Wave[] memory){
    return waves;
  }

  function getTotalWaves() public view returns (uint256) {
    console.log("Total waves: %d!", totalWaves);
    return totalWaves;
  }

  function senderAlreadyWonPrize(address _sender) private view returns (bool) {
    for (uint i = 0; i < prizeWinners.length; i++) {
      if (prizeWinners[i] == _sender) {
        return true;
      }
    }
    return false;
  }

  function addWinner(address _sender) private {
    prizeWinners.push(_sender);
  }
}

// whenever we change our contract, we want to change run.js to test new functionality added