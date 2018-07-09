const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3')

const web3 = new Web3(ganache.provider());

const compiledCampaign = require('../ethereum/build/Campaign.json');

let accounts;
let campaign;

beforeEach(async () => {
    accounts = await web3.eth.getAccounts();
    campaign = await new web3.eth.Contract(JSON.parse(compiledCampaign.interface))
        .deploy({ data:compiledCampaign.bytecode })
        .send({ from:accounts[0], gas:'1000000' });
});

describe('Campaign',() => {
    it('Deploys the contract',() => {
        assert.ok(campaign.options.address);
    });
})