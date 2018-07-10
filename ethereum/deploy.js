const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const compiledCampaign = require('./build/Campaign.json');

const provider = new HDWalletProvider(
    process.env.MNEMONIC,
    process.env.INFURA_URL
);

// console.log(JSON.parse(compiedCampaign.interface));

const web3 = new Web3(provider);

const deploy = async () => {
    const accounts = await web3.eth.getAccounts();
    console.log('Attempting to deploy from account ', accounts[0]);

    const result = await new web3.eth.Contract(JSON.parse(compiledCampaign.interface))
        .deploy({
            data: '0x' + compiledCampaign.bytecode
        })
        .send({
            from: accounts[0]
        });
    console.log('Contract deployed to ', result.options.address)
}

deploy();