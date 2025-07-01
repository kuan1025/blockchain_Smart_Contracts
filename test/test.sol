// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
Data structure

struct: object
array
mapping 

*/

contract HelloWorld{

    struct Info{
        string phrase;
        uint256 id;
        address addr;
    }

    Info[] infos;

    mapping(uint256 id => Info info) infoMapping; 

    string strVal = "Hello world";

    /*
        1. Storage
        2. Memory
        3. Calldata
        4. stack
        5. codes
        6. logs

    */

    function sayHello(uint256 _id) public view returns(string memory) { 
        if(infoMapping[_id].addr==address(0x0)){
            return addInfo(strVal);
        }else{
            return addInfo(infoMapping[_id].phrase);
        }
        // for(uint256 i = 0; i < infos.length; i++){
        //    if(infos[i].id == _id){
        //     return addInfo(infos[i].phrase);
        //    }
        // }
        // return addInfo(strVal);
    }

    function setHello(string memory newString, uint256 _id) public {
        Info memory info = Info(newString, _id, msg.sender);
        infoMapping[_id] = info;
        // infos.push(info);
    }

    function addInfo(string memory helloStr) internal pure returns (string memory){
        return string.concat(helloStr," from David's contract");
    }

    

}