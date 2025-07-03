// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {FundMe} from "./FundMe.sol";



contract FundTokenERC20 is ERC20{


    FundMe fundMe;

    constructor(address fundMeAddr) ERC20("FundTokenERC20", "FTN"){
        fundMe = FundMe(fundMeAddr);
    }


    // FundMe
    // 1. Allow FundMe participants to retrieve their own tokens based on mapping
    // 2. Allow participants to transfer their tokens
    // 3. Burn used token   


    function mint(uint256 amountToMint) public {
        require(fundMe.fundersToAmount(msg.sender) >= amountToMint, "you can not mint this much of tokens");
        require(fundMe.getFundSuccess(),"The Fundme is not completed yet");
        _mint(msg.sender, amountToMint);
        fundMe.setFundersToAmount(msg.sender, fundMe.fundersToAmount(msg.sender) - amountToMint);
    }

    function claim(uint256 amountClaimed) public {
    
        // complete claim
        require(balanceOf(msg.sender) >= amountClaimed,"You don't have enough ERC20 tokens");
        require(fundMe.getFundSuccess(),"The Fundme is not completed yet");
        // burn amountToClaim Token
        _burn(msg.sender, amountClaimed);
    }

  
}