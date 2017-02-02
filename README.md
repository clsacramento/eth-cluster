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


## Linking the two nodes
Connect to one of the nodes with docker 'exec' and 'geth attach'. Execute 'admin' and 'admin.peers' on the console. This will show information about this nodes and that the list of peers is empty.
~~~
> admin
{
  datadir: "/root/.ethereum",
  nodeInfo: {
    enode: "enode://294fe4e312ee391a23cde92b371e4060d07aa0b83034a8c06518f195a15776f1822f229af00da3c27cb44a38dc7efecac9552589bf916c6c7106803b1fdc4157@[::]:30303",
    id: "294fe4e312ee391a23cde92b371e4060d07aa0b83034a8c06518f195a15776f1822f229af00da3c27cb44a38dc7efecac9552589bf916c6c7106803b1fdc4157",
    ip: "::",
    listenAddr: "[::]:30303",
    name: "Geth/eth1/v1.5.4-stable-b70acf3c/linux/go1.7.3",
    ports: {
      discovery: 30303,
      listener: 30303
    },
    protocols: {
      eth: {
        difficulty: 131072,
        genesis: "0xb40c0d596cb579a0bd27423ff5f5a9c0b311ccfd8e1ec1ec92dc9f2db8a32d41",
        head: "0xb40c0d596cb579a0bd27423ff5f5a9c0b311ccfd8e1ec1ec92dc9f2db8a32d41",
        network: 1900
      }
    }
  },
  peers: [],
  addPeer: function(),
  exportChain: function(),
  getDatadir: function(callback),
  getNodeInfo: function(callback),
  getPeers: function(callback),
  importChain: function(),
  removePeer: function(),
  setSolc: function(),
  sleep: function github.com/ethereum/go-ethereum/console.(*bridge).Sleep-fm(),
  sleepBlocks: function github.com/ethereum/go-ethereum/console.(*bridge).SleepBlocks-fm(),
  startRPC: function(),
  startWS: function(),
  stopRPC: function(),
  stopWS: function()
}
> admin.peers[]
~~~


Copy the enode URL, so this one: "enode://294fe4e312ee391a23cde92b371e4060d07aa0b83034a8c06518f195a15776f1822f229af00da3c27cb44a38dc7efecac9552589bf916c6c7106803b1fdc4157@[::]:30303"


Replace '[::]' with the node ip. You can find it with docker inspect or by running 'ip a' on the container. In my case the ip of container is '172.19.0.3', so the final enode url becomes: "enode://294fe4e312ee391a23cde92b371e4060d07aa0b83034a8c06518f195a15776f1822f229af00da3c27cb44a38dc7efecac9552589bf916c6c7106803b1fdc4157@172.19.0.3:30303"



Now I can connect to the second node (same idea docker exec and geth attach). On the console execute admin.addPeer(enode_url). So in this case: admin.addPeer("enode://294fe4e312ee391a23cde92b371e4060d07aa0b83034a8c06518f195a15776f1822f229af00da3c27cb44a38dc7efecac9552589bf916c6c7106803b1fdc4157@172.19.0.3:30303")

Check 'admin.peers' now on both nodes to see they know each other. For example, on the second node I get:
~~~
> admin.peers
[{
    caps: ["eth/62", "eth/63"],
    id: "294fe4e312ee391a23cde92b371e4060d07aa0b83034a8c06518f195a15776f1822f229af00da3c27cb44a38dc7efecac9552589bf916c6c7106803b1fdc4157",
    name: "Geth/eth1/v1.5.4-stable-b70acf3c/linux/go1.7.3",
    network: {
      localAddress: "172.19.0.2:37552",
      remoteAddress: "172.19.0.3:30303"
    },
    protocols: {
      eth: {
        difficulty: 131072,
        head: "0xb40c0d596cb579a0bd27423ff5f5a9c0b311ccfd8e1ec1ec92dc9f2db8a32d41",
        version: 63
      }
    }
}]
~~~
