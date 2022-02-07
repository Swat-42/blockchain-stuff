//SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract simpleStorage{
    uint256 public num;
    struct People{
        uint256 num;
        string name;
    }
    People[] public people;
    mapping(string => uint256) public nameToNum;
    function store(uint256 _num) public {
        num=_num;
    }
    function retrieve() public view returns(uint256){
        return num;
    }
    function addPerson(string memory _name, uint256 _num) public{
        people.push(People({num:_num, name:_name}));
        nameToNum[_name]= _num;
    }
}