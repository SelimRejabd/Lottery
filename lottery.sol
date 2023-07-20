//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 < 0.9.0;
contract Lottery
{
    address public manager;
    address payable[] public perticipants;

    constructor()
    {
        manager = msg.sender;

    }

    receive() external payable
    {
        require(msg.value ==1 ether, "Lottery fee is 0.1 ether.");
        perticipants.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint)
    {
        require(msg.sender == manager, "Only manager can check balance of the contract.");
        return address(this).balance;
    }

    function random() internal returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,perticipants.length)))%perticipants.length;
    }
    function selectWinner() public {
        require(msg.sender==manager);
        require(perticipants.length>=3,"At least three participants needed to draw lottery.");
        uint r = random();
        perticipants[r].transfer(getBalance());
        perticipants = new address payable[](0);
    }
}