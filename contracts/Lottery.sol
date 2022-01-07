//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Lottery is Ownable {
    uint minimum;
    address[] players;

    constructor(uint _minimum) {
        //conversion from wei to ether
        minimum = _minimum*1000000000000000000;
    }

    function enterLottery() public payable {
        require(msg.value >= minimum);
        players.push(msg.sender);
    }

    function pseudoRandomize() private view returns (uint256) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }

    function pickWinner() public onlyOwner {
        uint winningIndex = pseudoRandomize() % players.length;
        payable(players[winningIndex]).transfer(address(this).balance);
        players = new address[](0);
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }


}