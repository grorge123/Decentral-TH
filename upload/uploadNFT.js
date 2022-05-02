
const { NFTStorage, Blob } = require('nft.storage')
const { pack } = require('ipfs-car/pack');
const fs = require('fs');



async function main(fileName) {
	const basePath = "./images/";
	const path = basePath + fileName;
	const name = "Test Image" + fileName;
	const description = "This is test image";
	const external_url = "https://openseacreatures.io/3";
	// const { attributes } = require('./images/attributes.json');
	const attributes = [];
	
	const endpoint = 'https://api.nft.storage' // the default
	const token = process.env.NFTKey
	uploadJson = { name: name, description: description, external_url: external_url, attributes: attributes };
	const storage = new NFTStorage({ endpoint, token })
	const data = await fs.promises.readFile(path)
	const cid = await storage.storeBlob(new Blob([data]))
	const status = await storage.status(cid)
	console.log("image:",cid)
	uploadJson["image"] = "ipfs://" + cid
	const cid2 = await storage.storeBlob(new Blob([JSON.stringify(uploadJson)]))
	const status2 = await storage.status(cid2)
	console.log("metadata:",cid2)
	
}
for (let i = 1; i <= 10; i += 1){
	let fileName = String(i) + ".jpg";
	main(fileName)
}