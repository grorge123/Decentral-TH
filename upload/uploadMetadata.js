const { NFTStorage, File } = require('nft.storage');
const { pack } = require('ipfs-car/pack');
const fs = require('fs');

  
const basePath = "./images/";
const fileName = "1.jpg";
const path = basePath + fileName;
const name = "Test Image";
const description = "This is test image";
const external_url = "https://openseacreatures.io/3";
const { attributes } = require('./images/attributes.json');
const apiKey = process.env.NFTKey;
const client = new NFTStorage({ token: apiKey });

fs.promises.readFile(path).then(fileData => {
	client.store({
		name: name,
		description: description,
		image: new File([fileData], fileName, { type: 'image/jpg' }),
		external_url: external_url,
		attributes: attributes,
	}).then(metadata => {
		console.log(metadata.url)
		console.log(metadata)
	});
});

upload();