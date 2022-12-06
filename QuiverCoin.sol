// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

//The following smart contarct coincides with the BEP-20 Binance BNB Smart Chain (BSC)Token Standard
contract QuiverCoin {

    //API Grabbers Constant Values
    uint public totalSupply = 1000000 * 10 ** 18;
    string public name = "QuiverCoin";
    string public symbol = "QIVC";

    //decimals refers to how divisible a token can be, from 0 (not at all divisible) 
    //to 18 (pretty much continuous) and even higher if required. 
    uint public decimals = 18;

    //Balances Mapping Record
    mapping(address => uint) public balances; 
    
    //Outer address is the owner of the token, each token owner have series of nested mapping 
    //with address of sender Maps to how much spender can spend
    mapping(address => mapping(address => uint)) public allowance;

    //Emit Event
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value); 

    constructor() {
        //Update Record, Deploy Token
        balances[msg.sender] = totalSupply;
    }

    //Read balances for any address
    function balanceOf(address owner) public view returns(uint) {
        //Find address in mapping record
        return balances[owner];
    }

    //
    function transfer(address to, uint value) public returns(bool) {
        //Check Effect Interacts Security Pattern Design Here
        require(balanceOf(msg.sender) >= value, 'Failed: Insuffcient Balance Avaliable'); //Check
        balances[to] += value; //Effect
        balances[msg.sender] -= value; //Effect
        emit Transfer(msg.sender, to, value); //Interacts
        return true;
    }

    function transferFrom(address from, address to, uint value) public returns(bool) {
        //Check Effect Interacts Security Pattern Design Here
        require(balanceOf(from) >= value, 'Failed: Insuffcient Balance Avaliable'); //Check
        //Check sender of this transaction is an approved spender for the from address
        require(allowance[from][msg.sender] >= value, 'Failed: Allowance To Low'); //Check
        balances[to] += value; //Effect
        balances[from] -= value; //Effect
        emit Transfer(from, to, value); //Interact
        return true;  
    }

    function approve(address spender, uint value) public returns(bool) {
        //Access nested mapping
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true; 
    }

}