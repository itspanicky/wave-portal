// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";
// with this ^^ library, we can use console logging and util.format() to print statements
// see [util.format](https://nodejs.org/dist/latest-v12.x/docs/api/util.html#util_util_format_format_args) for full list

contract WavePortal {
  address owner;
  address[] senders;
  uint256 totalWaves;

  event NewWave(address indexed from, uint256 timestamp, string message);

  struct Wave {
    address waver;
    string message;
    uint256 timestamp;
  }

  Wave[] waves;

  constructor() payable {
    owner = msg.sender;
    console.log("Hi, I am a smart contract. I am a program deployed to the blockchain by %s.", owner);
  }

  function wave(string memory _message) public {
    totalWaves += 1;
    if (owner == msg.sender) {
      console.log("itsPanicky has waved!");
    } else if (senderAlreadyWaved(msg.sender)) {
      console.log("%s has waved again!", msg.sender);
    } else {
      addSender(msg.sender);
      console.log("%s has waved!", msg.sender);
    }

    waves.push(Wave(msg.sender, _message, block.timestamp));
    emit NewWave(msg.sender, block.timestamp, _message);

    uint256 prizeAmount = 0.0001 ether;
    require(
      prizeAmount <= address(this).balance,
      "Trying to withdraw more money"
    );
    (bool success, ) = (msg.sender).call{ value: prizeAmount }("");
    require(success, "Failed to withdraw money from contract." );
  }

  function getAllWaves() public view returns (Wave[] memory){
    return waves;
  }

  function getTotalWaves() public view returns (uint256) {
    console.log("Total waves: %d!", totalWaves);
    return totalWaves;
  }

  function senderAlreadyWaved(address _sender) private view returns (bool) {
    for (uint i = 0; i < senders.length; i++) {
      if (senders[i] == _sender) {
        return true;
      }
    }
    return false;
  }

  function addSender(address _sender) private {
    senders.push(_sender);
  }
}

// whenever we change our contract, we want to change run.js to test new functionality added