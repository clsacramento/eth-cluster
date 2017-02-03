# Deploying a contract

I was following this tutorial: https://github.com/ethereum/go-ethereum/wiki/Contract-Tutorial

## Solidity compiler (Solidity is the Ethereum Programming Languag)
It is possible to use some online compilers but they are annoying. Better to install.

To install:
~~~
sudo add-apt-repository ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install solc
which solc
~~~

If you download the binary you can link it to the geth with this command on the console (so after doing geth attach):

~~~
admin.setSolc("path/to/solc")
~~~


Check if you get the compiler from the console:

~~~
> eth.getCompilers()
["Solidity"]
~~~

## Create a Smart Contract

This example creates a hello world contract that is so that its full source code is created on a string. Here (from geth console):
~~~
> var greeterSource = 'contract mortal { address owner; function mortal() { owner = msg.sender; } function kill() { if (msg.sender == owner) suicide(owner); } } contract greeter is mortal { string greeting; function greeter(string _greeting) public { greeting = _greeting; } function greet() constant returns (string) { return greeting; } }'
undefined
~~~

Then it gets compiled with the following line:
~~~
> var greeterCompiled = web3.eth.compile.solidity(greeterSource)
undefined
~~~
We can see the contents of both this source code variable and the actual compiled result by following:
~~~
> greeterSource
"contract mortal { address owner; function mortal() { owner = msg.sender; } function kill() { if (msg.sender == owner) suicide(owner); } } contract greeter is mortal { string greeting; function greeter(string _greeting) public { greeting = _greeting; } function greet() constant returns (string) { return greeting; } }"
> greeterCompiled
{
  greeter: {
    code: "0x60606040523461000057604051610284380380610284833981016040528051015b5b60008054600160a060020a0319166c01000000000000000000000000338102041790555b8060019080519060200190828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f1061009157805160ff19168380011785556100be565b828001600101855582156100be579182015b828111156100be5782518255916020019190600101906100a3565b5b506100df9291505b808211156100db57600081556001016100c7565b5090565b50505b505b610192806100f26000396000f3606060405260e060020a600035046341c0e1b58114610029578063cfae321714610038575b610000565b34610000576100366100b3565b005b34610000576100456100f5565b60405180806020018281038252838181518152602001915080519060200190808383829060006004602084601f0104600302600f01f150905090810190601f1680156100a55780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b6000543373ffffffffffffffffffffffffffffffffffffffff908116911614156100f25760005473ffffffffffffffffffffffffffffffffffffffff16ff5b5b565b604080516020808201835260008252600180548451600282841615610100026000190190921691909104601f8101849004840282018401909552848152929390918301828280156101875780601f1061015c57610100808354040283529160200191610187565b820191906000526020600020905b81548152906001019060200180831161016a57829003601f168201915b505050505090505b9056",
    info: {
      abiDefinition: [{...}, {...}, {...}],
      compilerOptions: "--combined-json bin,abi,userdoc,devdoc --add-std --optimize",
      compilerVersion: "0.4.6",
      developerDoc: {
        methods: {}
      },
      language: "Solidity",
      languageVersion: "0.4.6",
      source: "contract mortal { address owner; function mortal() { owner = msg.sender; } function kill() { if (msg.sender == owner) suicide(owner); } } contract greeter is mortal { string greeting; function greeter(string _greeting) public { greeting = _greeting; } function greet() constant returns (string) { return greeting; } }",
      userDoc: {
        methods: {}
      }
    }
  },
  mortal: {
    code: "0x606060405234610000575b60008054600160a060020a0319166c01000000000000000000000000338102041790555b5b60698061003c6000396000f3606060405260e060020a600035046341c0e1b58114601c575b6000565b3460005760266028565b005b6000543373ffffffffffffffffffffffffffffffffffffffff9081169116141560665760005473ffffffffffffffffffffffffffffffffffffffff16ff5b5b56",
    info: {
      abiDefinition: [{...}, {...}],
      compilerOptions: "--combined-json bin,abi,userdoc,devdoc --add-std --optimize",
      compilerVersion: "0.4.6",
      developerDoc: {
        methods: {}
      },
      language: "Solidity",
      languageVersion: "0.4.6",
      source: "contract mortal { address owner; function mortal() { owner = msg.sender; } function kill() { if (msg.sender == owner) suicide(owner); } } contract greeter is mortal { string greeting; function greeter(string _greeting) public { greeting = _greeting; } function greet() constant returns (string) { return greeting; } }",
      userDoc: {
        methods: {}
      }
    }
  }
}
> 
~~~

Now create a contract model (or class?) from this compiled source:
~~~
> var greeterContract = web3.eth.contract(greeterCompiled.greeter.info.abiDefinition);
undefined
~~~
An than create an instance of that contract model. You can parametrize the greeting message this hellow world contract will output:
~~~
var _greeting = "Hello World!"
var greeter = greeterContract.new(_greeting,{from:web3.eth.accounts[0], data: greeterCompiled.greeter.code, gas: 1000000}, function(e, contract){
  if(!e) {

    if(!contract.address) {
      console.log("Contract transaction send: TransactionHash: " + contract.transactionHash + " waiting to be mined...");

    } else {
      console.log("Contract mined! Address: " + contract.address);
      console.log(contract);
    }

  }
})
~~~

