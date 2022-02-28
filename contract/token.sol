// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "./dateTime.sol";
import "./admin.sol";


contract NTToken is ERC20, Ownable, Admin{
    DateTime DateTranser;
    uint constant initialUint = 10 ** 18;
    
    mapping(address => uint[32]) loginTable;

    constructor() ERC20("Decentral-TH token", "NT") {    
        admin[msg.sender] = true;
        _mint(msg.sender, 1000000 * initialUint);
        DateTranser = new DateTime();
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
        uint nowDay = DateTranser.getDay(nowTime);
        uint nowMonth = DateTranser.getMonth(nowTime);
        uint nowYear = DateTranser.getYear(nowTime);
        uint oldMonth = DateTranser.getMonth(loginTable[msg.sender][nowDay]);
        uint oldYear = DateTranser.getYear(loginTable[msg.sender][nowDay]);
        require(oldYear != nowYear || oldMonth != nowMonth, "You have login");
        loginTable[msg.sender][nowDay] = nowTime;
        _mint(msg.sender, 1 * initialUint);
    }
}