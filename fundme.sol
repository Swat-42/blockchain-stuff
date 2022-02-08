//SPDX-License_Identifier: MIT

pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe{
    using SafeMathChainlink for uint256;
    mapping(address => uint256) public addressToAmountFunded;
    address public owner;
    address[] public funders;

    function fund() public payable {
        uint256 minimumUSD = 50 * 10 ** 18;
        require(getConversionRate(msg.value)>= minimumUSD, "You need to spend more ethereum");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }
    
    constructor() public{
        owner = msg.sender;
    }

    function getVersion() public view returns(uint256){
        AggregatorV3Interface pricefeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return pricefeed.version();
    }
    
    function getPrice() public view returns(uint256){
        AggregatorV3Interface pricefeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        ( ,int256 answer, , , ) = pricefeed.latestRoundData();
        return uint256(answer * 10000000000);
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUSD = ethPrice *ethAmount/1000000000000000000;
        return ethAmountInUSD;
    }

    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }
    function withdraw() payable onlyOwner public{
        msg.sender.transfer(address(this).balance);
        for(uint256 i=0; i<funders.length; i++){
            address funder = funders[i];
            addressToAmountFunded[funder]= 0;
        }
        funders = new address[](0);
    }
}