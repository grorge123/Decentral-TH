// Library Imports
const Web3 = require('web3');
const EthereumTx = require('ethereumjs-tx').Transaction;

// Connection Initialization

const address = '0xdb52AfE620ABBfE8C78d88ab65229aBFd14dAB4f';
const address2 = '0xa7CD335f79DF10C24770f2E69d47c5233D9d5835'
const pri = process.env.eth_pri;
const rpcURL = "https://speedy-nodes-nyc.moralis.io/918f72084ae65bfdd0f7b7de/eth/rinkeby";

// const address = '0x4eC746228343dDfa025E19D58A9E6BB592025B47';
// const address2 = '0xb5D0f6134248d2471504Cf3c0633AC949B3E4409'
// const pri = '0xab112fdcd282475b7c191f7f441c60d90e38e224360f9e919253181d7f6675e4'
// const rpcURL = 'http://127.0.0.1:8545';

const web3 = new Web3(rpcURL);
var acc = web3.eth.accounts.privateKeyToAccount(pri);
web3.eth.accounts.wallet.add(acc);
function sleep(milliseconds) { 
    var start = new Date().getTime(); 
    while(1)
        if ((new Date().getTime() - start) > milliseconds)
        break;
}
// Function Call
function deployContract(abi, bytecode, arguments) {
    //Contract object and account info
    let deploy_contract = new web3.eth.Contract(JSON.parse(abi));
    
    let payload = {
        data: bytecode,
        arguments:arguments
    }

    let parameter = {
        from: address,
        gas: 8000000
    }
    return new Promise((resolve, reject) => {
        deploy_contract.deploy(payload).send(parameter, (err, transactionHash) => {
            // console.log('Transaction Hash :', transactionHash);
        }).on('confirmation', () => {}).then((newContractInstance) => {
            // console.log('Deployed Contract Address : ', newContractInstance.options.address);
            resolve(newContractInstance.options.address)
        }).catch(err => {
            console.log(err);
            reject();
        })
    });
    
}

async function getRevertReason(txHash){

    const tx = await web3.eth.getTransaction(txHash)
  
    var result = await web3.eth.call(tx, tx.blockNumber)
  
    result = result.startsWith('0x') ? result : `0x${result}`
  
    if (result && result.substr(138)) {
  
      const reason = web3.utils.toAscii(result.substr(138))
      console.log('Revert reason:', reason)
  
    } else {
  
      console.log('Cannot get reason - No return value')
  
    }
  
  }

async function main() {
    NFTAbi = require('../bin/nftabi.json');
    NFTByte = require('../bin/nftbyte.json');
    NFTAbi = JSON.stringify(NFTAbi);
    NFTByte = NFTByte.object;
    NFTArguments = ["FirstNFT", "FN", "ipfs://bafkreid4jqgen3erpgaua7u7iywzzdatolmopwpkldtnjiali2wy5qwanq"]
    NFTAddr = await deployContract(NFTAbi, NFTByte, NFTArguments);
    NFTContract = new web3.eth.Contract(JSON.parse(NFTAbi), NFTAddr);
    console.log("NFTAddr:", NFTAddr);

    fusionNFTAbi = require('../bin/fusionnftabi.json');
    fusionNFTByte = require('../bin/fusionnftbyte.json');
    fusionNFTAbi = JSON.stringify(fusionNFTAbi);
    fusionNFTByte = fusionNFTByte.object;
    fusionNFTArguments = [];
    fusionNFTAddr = await deployContract(fusionNFTAbi, fusionNFTByte, fusionNFTArguments);
    fusionNFTContract = new web3.eth.Contract(JSON.parse(fusionNFTAbi), fusionNFTAddr);
    console.log("fusionNFTAddr:", fusionNFTAddr);

    tokenAbi = require('../bin/tokenabi.json');
    tokenByte = require('../bin/tokenbyte.json');
    tokenAbi = JSON.stringify(tokenAbi);
    tokenByte = tokenByte.object;
    tokenArguments = [];
    tokenAddr = await deployContract(tokenAbi, tokenByte, tokenArguments);
    tokenContract = new web3.eth.Contract(JSON.parse(tokenAbi), tokenAddr);
    console.log("tokenAddr:", tokenAddr);

    auctionAbi = require('../bin/auctionabi.json');
    auctionByte = require('../bin/auctionbyte.json');
    auctionAbi = JSON.stringify(auctionAbi);
    auctionByte = auctionByte.object;
    auctionArguments = [tokenAddr];
    auctionAddr = await deployContract(auctionAbi, auctionByte, auctionArguments);
    auctionContract = new web3.eth.Contract(JSON.parse(auctionAbi), auctionAddr);
    console.log("auctionAddr:", auctionAddr);
    try {
        
        // set whiteList
        await auctionContract.methods.setWhiteList(1, NFTAddr).send({ from: address, gas: 3500000 })
        sleep(3000)
        await auctionContract.methods.setWhiteList(2, fusionNFTAddr).send({ from: address, gas: 3500000 })
        console.log("Finish whiteList")
        // mint NFT
        sleep(3000)
        await NFTContract.methods.mint(address, "bafkreibe3woikuhs26nkeoo2acgtjhwz5nzd4epp2nqnno7246rs4r4ouy").send({ from: address, gas: 3500000 });
        sleep(3000)
        await NFTContract.methods.mint(address, "bafkreidsvfuuvx2amgg4vlui4f6v267gkzhb5s5t5xkripbxro6tbjqsvq").send({ from: address, gas: 3500000 });
        sleep(3000)
        await NFTContract.methods.mint(address2, "bafkreidsvfuuvx2amgg4vlui4f6v267gkzhb5s5t5xkripbxro6tbjqsvq").send({ from: address, gas: 3500000 });
        sleep(3000)
        await NFTContract.methods.mint(address2, "bafkreic2jxz3yygsomqcrvoulbrpbpk44pvouuctutcdheysxwaozmg5vq").send({ from: address, gas: 3500000 });
        sleep(3000)
        await NFTContract.methods.mint(address2, "bafkreibdylxhwh7yp2sp5rrkktvqet6h3s27bfgotjtckkkclgsnfw6mya").send({ from: address, gas: 3500000 });
        sleep(3000)
        console.log("Finish mint NFT")
        await fusionNFTContract.methods.mint(address, "bafkreibe3woikuhs26nkeoo2acgtjhwz5nzd4epp2nqnno7246rs4r4ouy").send({ from: address, gas: 3500000 });
        sleep(3000)
        await fusionNFTContract.methods.mint(address, "bafkreidsvfuuvx2amgg4vlui4f6v267gkzhb5s5t5xkripbxro6tbjqsvq").send({ from: address, gas: 3500000 });
        sleep(3000)
        await fusionNFTContract.methods.mint(address2, "bafkreidsvfuuvx2amgg4vlui4f6v267gkzhb5s5t5xkripbxro6tbjqsvq").send({ from: address, gas: 3500000 });
        sleep(3000)
        await fusionNFTContract.methods.mint(address2, "bafkreic2jxz3yygsomqcrvoulbrpbpk44pvouuctutcdheysxwaozmg5vq").send({ from: address, gas: 3500000 });
        sleep(3000)
        await fusionNFTContract.methods.mint(address2, "bafkreibdylxhwh7yp2sp5rrkktvqet6h3s27bfgotjtckkkclgsnfw6mya").send({ from: address, gas: 3500000 });
        sleep(3000)
        await fusionNFTContract.methods.mint(address2).send({ from: address, gas: 3500000 });
        sleep(3000)
        console.log("Finish mint fusion")
        // create order
        await NFTContract.methods.approve(auctionAddr, 0).send({ from: address, gas: 3500000 });
        sleep(3000)
        await auctionContract.methods.createLimitPriceOrder(0, 0, 5).send({ from: address, gas: 3500000 });
        sleep(3000)
        console.log("Finish create order")
    }catch (err) {
        console.log(err)
    }
    console.log("Finish")
}
main()