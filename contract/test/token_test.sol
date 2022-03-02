
pragma solidity ^0.8.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "../token.sol";

contract tokenTest{

	NTToken token;
	uint constant initialUint = 10 ** 18;

	function beforeAll() public {
        token = new NTToken();
    }
    
	function initialMint() public{
		Assert.equal(token.balanceOf(address(this)), 1000000 * initialUint, "It should mint 1000000 token");	
	}

    function Login() public {
        token.Login();
        Assert.equal(token.balanceOf(address(this)), 1000001 * initialUint, "It should get 1 token");
        try token.Login(){
            Assert.ok(false,"It should't success");
        }catch (bytes memory _err){
            Assert.ok(true, "It should't fail");
        }
    }
}