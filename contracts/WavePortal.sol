// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";
// with this ^^ library, we can use console logging and util.format() to print statements
// see [util.format](https://nodejs.org/dist/latest-v12.x/docs/api/util.html#util_util_format_format_args) for full list

contract WavePortal {
  address owner;
  address[] senders;
  uint256 totalWaves;

  constructor() {
    owner = msg.sender;
    console.log("Hi, I am a smart contract. I am a program deployed to the blockchain by %s.", owner);
  }

  function wave() public {

    if (owner == msg.sender) {
      console.log("The contract owner has waved!");
    } else if (senderAlreadyWaved(msg.sender)) {
      console.log("%s has waved again!", msg.sender);
    } else {
      addSender(msg.sender);
      console.log("%s has waved!", msg.sender);
    }
    totalWaves += 1;
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