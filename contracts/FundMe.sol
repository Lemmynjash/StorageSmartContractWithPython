// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract FundMe{

    address public owner; //stores the owner of the deployed contract
    address[] public funders;// the guys who have been funding lemmy 

    mapping(address => uint256) public addressToAmountFunded;

    constructor() public{
      owner=msg.sender;
    }

    function fund() public payable{
        uint256 minimumUSD = 50 * 10 ** 18; //raised to 18
        require(getConvertionRate(msg.value) >= minimumUSD, "You need to send more ETH to Lemmy");
        addressToAmountFunded[msg.sender]+=msg.value;
        //what the eth to usd conversion rate
        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256){
        AggregatorV3Interface priceFeed =AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);  
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256){
        AggregatorV3Interface priceFeed =AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);  
        (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )= priceFeed.latestRoundData();
        return uint256(answer * 10000000000);
    }

    //1000000000 gwei
    function getConvertionRate(uint256 _ethAmount) public view returns (uint256){
      uint256 ethPrice=getPrice();
      uint256 ethAmountInUsd=(ethPrice*_ethAmount)/ 1000000000000000000; //from gwei to ether
      return ethAmountInUsd;
    }


    //only the admin/owner is the one who does the withdrawal
    //want to withdraw the funds
    function withdraw() public payable{
        require(msg.sender == owner,"Yo! you are not the owner");
        msg.sender.transfer(address(this).balance);

        //after funding we want to reset
        for(uint256 funderIndex=0; funderIndex> funders.length();funderIndex++){
          address funder=funders[funderIndex];
          addressToAmountFunded[funder]=0;
        }

        funders=new address[](0);
    }

}