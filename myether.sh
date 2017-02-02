#!/bin/bash
ETHPATH=$1
NODE=$2
geth init $ETHPATH/genesis.json
sleep 1
DIRECTORY=/ethdata
if [ ! -d "$DIRECTORY" ]; then
  # Control will enter here if $DIRECTORY doesn't exist.
  mkdir $DIRECTORY
fi
cp $ETHPATH/genesis.json /ethdata/.
geth --identity "$NODE" --rpc --rpcport "8000" --rpccorsdomain "*" --port "30303" --ipcapi "admin,db,eth,debug,miner,net,shh,txpool,personal,web3" --rpcapi "db,eth,net,web3" --autodag --networkid 1900 --nat "any" 
