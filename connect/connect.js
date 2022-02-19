
async function checkNetwork() {
    if (window.ethereum.chainId != 4) {
		console.log("Please connect to the Rinkeby Testnet!");
		return false;
	}
	return true;
}

async function getAccount() {
    if (!window.ethereum) {
        console.log("MetaMask not installed")
        return false;
    }

    let status = false;
    await window.ethereum.request({ method: 'eth_requestAccounts' })
    .then((accounts) => {
        if (accounts.length) {
            acc = accounts[0];
            status = true;
        }
    })
    .catch((err) => {
        // Some unexpected error.
        // For backwards compatibility reasons, if no accounts are available,
        // eth_accounts will return an empty array.
        console.error(err);
    });
    return status;
}
getAccount().then(console.log)
checkNetwork().then(console.log)