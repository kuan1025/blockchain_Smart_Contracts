// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// 1. Create a payment collection function.
// 2. Record funders and view them.
// 3. During the lock-up period, once the investment target amount 
//    is reached, the producer can withdraw.
// 4. During the lock-up period, if the target amount is not met,
//    investors can request a refund after the lock-up period.

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    uint256 constant TARGET = 500 * 10 ** 18;

    uint256 constant MINIMUN_VAL = 100 * 10 ** 18; //usd

    mapping (address => uint256) public fundersToAmount;

    address owner;

    // lock-up period 
    uint256 deploymentTimestamp;
    uint256 lockedTime;

    AggregatorV3Interface internal dataFeed;


    constructor(uint256 _lockedTime){
        //sepolia testnet  ETH <-> USD
        dataFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        owner = msg.sender;
        // init  
        deploymentTimestamp = block.timestamp;
        lockedTime = _lockedTime;

    }

    // keyword : payable
    function fund() external payable {
        require( convertEthToUsd(msg.value) >= MINIMUN_VAL,"Need more ETH");// fail -> revert
        // timer
        require((block.timestamp - deploymentTimestamp) <= lockedTime,"window is closed");
        fundersToAmount[msg.sender] = msg.value;
    }


    function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundId */,
            int256 answer,
            /*uint256 startedAt*/,
            /*uint256 updatedAt*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return answer;
    }

    function convertEthToUsd(uint256 ethAmount) internal view returns(uint256){
        uint256 ethPrice = uint256(getChainlinkDataFeedLatestAnswer());
        return ethAmount * ethPrice/(10**8);
    }

    function getFund() external windowClose onlyOwner{
        require(convertEthToUsd(address(this).balance) >= TARGET,"Target is not reach");
         // timer
       

        // transfer: transfer ETH and revert if tx fail
        // payable(msg.sender).transfer(address(this).balance);

        // send:  transfer ETH and return false if tx fail
        // bool success =  payable(msg.sender).send(address(this).balance);
        // require(success,"tx fail");


        // call: transfer EFH with data (return value of function)
        bool success ;
        (success, ) = payable(msg.sender).call{value:address(this).balance}("");
        require(success,"tx fail");
        fundersToAmount[msg.sender] = 0;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }
    
    function refund() external windowClose{
        
        require(convertEthToUsd(address(this).balance) < TARGET,"Target is reach");
        require(fundersToAmount[msg.sender] != 0,"There is no fund for u");
   
          bool success ;
        (success, ) = payable(msg.sender).call{value:fundersToAmount[msg.sender]}("");
        require(success,"tx fail");
        fundersToAmount[msg.sender] = 0;

    }


    modifier windowClose(){
        require((block.timestamp - deploymentTimestamp) >= lockedTime,"window is closed");
        _; // means run the content of function after this line
    }

    modifier onlyOwner(){
         require(msg.sender==owner, "This function can only be called by owner");
         _;
    }

}