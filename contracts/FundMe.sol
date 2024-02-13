// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
import "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public minimunUsd = 15 * 1e18;
    address[] public funders;
    mapping (address => uint256) public  addressToAmountFunded;

    function fund() public payable  {
        //want to be able to set a minimun fund amount
        // 1. How to send ETH to this contract?
        require((msg.value.getConvertionRate()) >= minimunUsd,"Didnt' send enough ETH!");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender]= msg.value;
    }

    address public  owner;

    constructor (){
        owner = msg.sender;
    }

    function withDraw() public onlyOwner{
        //withDrawContract:
        //Transfer
        payable( msg.sender).transfer(address(this).balance);

        //Send
       bool sendSucess = payable(msg.sender).send(address(this).balance);
       require(sendSucess, "Sending money fails");
        //Call Most Used
       (bool callSuccess, ) =  payable (msg.sender).call{value:address(this).balance}("");

        require(callSuccess, "Call failed");


       for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) 
       {
           address funder = funders[funderIndex];
           addressToAmountFunded[funder] = 0;
       }
       //reset the array
       funders = new address[](0);
    }

    modifier onlyOwner{
        require(msg.sender == owner, "You cannot withdraw!");
        _;
    }
}