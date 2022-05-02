// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";

contract Admin is Ownable{

	mapping(address => bool) admin;

	constructor() {
        setAdmin(_msgSender(), true);
    }

	modifier onlyAdmin() {
        require(admin[msg.sender] == true, "Permission denied.");
        _;
    }

    function setAdmin(address _addr, bool _type) public onlyOwner{
        admin[_addr] = _type;
    }

    function isAdmin(address _addr) public view returns(bool){
        return admin[_addr];
    }

}