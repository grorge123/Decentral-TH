// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "./dateTime.sol";


contract NTToken is ERC20, Ownable{

    uint constant initialUint = 10 ** 18;
    mapping(address => bool) admin;
    mapping(address => uint[32]) loginTable;

    constructor() ERC20("Decentral-TH token", "NT") {    
        admin[msg.sender] = true;
        _mint(msg.sender, 1000000 * initialUint);
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
	
    function burnToken(address _addr, uint number) public onlyAdmin{
        _burn(_addr, number);
    }

    function getLoginTable(address _addr) public view returns(uint[32] memory){
        return loginTable[_addr];
    }
    
    function Time_call() public view returns (uint256){
        return block.timestamp; 
    }

    function Login() public {
        uint nowTime = Time_call();
        uint nowDay = DateTime.getDay(nowTime);
        uint nowMonth = DateTime.getMonth(nowTime);
        uint nowYear = DateTime.getYear(nowTime);
        uint oldMonth = DateTime.getMonth(loginTable[msg.sender][nowDay]);
        uint oldYear = DateTime.getYear(loginTable[msg.sender][nowDay]);
        require(oldYear != nowYear || oldMonth != nowMonth, "You have login");
        loginTable[msg.sender][nowDay] = nowTime;
        _mint(msg.sender, 1 * initialUint);
    }
}