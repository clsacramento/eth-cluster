#!/bin/bash
ETHPATH=$1
NODE=$2
geth init $ETHPATH/genesis.json
sleep 1
mkdir /ethdata
geth --identity "$NODE" --rpc --rpcport "8000" --rpccorsdomain "*" --datadir "/ethdata" --port "30303" --nodiscover --ipcapi "admin,db,eth,debug,miner,net,shh,txpool,personal,web3" --rpcapi "db,eth,net,web3" --autodag --networkid 1900 --nat "any" 
