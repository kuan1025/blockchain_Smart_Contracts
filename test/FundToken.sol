// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;


contract FundToken{
   
    // 1. Token name
    // 2. Token abbreviation
    // 3. Token issuance amount
    // 4. Owner address
    // 5. balance address => uint256
    
    string public tokenName;
    string public tokenSymbol;
    uint256 public totalSupply;
    address public owner;
    mapping (address => uint256) public balances;

    constructor(string memory _tokenName,string memory _tokenSymbol ){
        
        tokenName = _tokenName;
        tokenSymbol = _tokenSymbol;
        owner = msg.sender;

    }

    // Function
    // mint : get token
    // transfer : token
    // balanceOf : Review the address that owns the token number


    function mint(uint256 amountToMint) public {
        balances[msg.sender] += amountToMint;
        totalSupply += amountToMint;
    }

    function transfer(address reveicer, uint256 amount) public {
        require((balances[msg.sender] >= amount),"Insufficient balances");
        balances[msg.sender] -= amount;
        balances[reveicer] += amount;
    }

    function balancesOf(address _addr) public view returns(uint256){
        return balances[_addr];
    }


}