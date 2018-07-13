# smart-contract-basics
A project that can compile, test and deploy smart contracts on ethereum. 

## Get the project

```
$ git clone https://github.com/wahanepankaj/smart-contract-basics.git
```

## Compiling the contracts
      
Inside the project directory, type following commands

```
$ cd ethereum
$ node compile.js
```

The compilation output is stored as JSON file(s) in build directory.

## Testing

Inside the project directory, type following commands

```
$ npm test
```

# Deploying the smart contract

The deployment script needs two environment variables:

|Variable|Description|
|----|---|
|MNEMONIC| Wallet Seed mnemonic string|
|INFURA_URL| Infura url for the target ethereum network with api key|
|FACTORY_ADDRESS| Address for Factory Contract|


```
$ cd ethereum
$ node deploy.js
```

# Running

```
$ npm run dev
```