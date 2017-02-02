# Eth Cluster

Setting up a private Ethereum cluster with docker compose

## Creating a private network
~~~
git clone https://github.com/clsacramento/eth-cluster
cd eth-cluster
docker-compose up
~~~


## Running nodes
~~~
$ sudo docker ps
CONTAINER ID        IMAGE                  COMMAND                  CREATED             STATUS              PORTS                         NAMES
4eab72f5c42e        ethereum/client-go     "bash /ethconf/mye..."   35 hours ago        Up 35 hours         8545/tcp, 30303/tcp           ethcluster_eth1_1
99ed6bd60010        ethereum/client-go     "bash /ethconf/mye..."   35 hours ago        Up 35 hours         8545/tcp, 30303/tcp           ethcluster_eth2_1
~~~

## Connecting to the nodes
~~~
$ sudo docker exec -ti ethcluster_eth1_1 /bin/bash
root@4eab72f5c42e:/# geth attach
Welcome to the Geth JavaScript console!

instance: Geth/eth1/v1.5.4-stable-b70acf3c/linux/go1.7.3
coinbase: 0xdda4612d74b9489404001de442fcfd8db0eca59b
at block: 0 (Thu, 01 Jan 1970 00:00:00 UTC)
 datadir: /root/.ethereum
 modules: admin:1.0 debug:1.0 eth:1.0 miner:1.0 net:1.0 personal:1.0 rpc:1.0 txpool:1.0 web3:1.0

> 
~~~

Checking configured accounts
~~~
> personal
{
  listAccounts: ["0xdda4612d74b9489404001de442fcfd8db0eca59b", "0xf0b462ef19bba9366c4bf229dc3e438e0c1cca7b"],
  ecRecover: function(),
  getListAccounts: function(callback),
  importRawKey: function(),
  lockAccount: function(),
  newAccount: function github.com/ethereum/go-ethereum/console.(*bridge).NewAccount-fm(),
  sendTransaction: function(),
  sign: function github.com/ethereum/go-ethereum/console.(*bridge).Sign-fm(),
  unlockAccount: function github.com/ethereum/go-ethereum/console.(*bridge).UnlockAccount-fm()
}
~~~
