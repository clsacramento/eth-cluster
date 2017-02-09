# Setup a Parity cluster with docker-compose

Parity is a private Ethereum cluster by default.

## Setup an initial Cluster

~~~
git clone https://github.com/clsacramento/eth-cluster
cd eth-cluster/parity
docker-compose up
~~~

Extected output (may take a few minutes):

~~~
$ sudo docker-compose up
Recreating parity_eth2_1
Starting parity_eth1_1
Attaching to parity_eth1_1, parity_eth2_1
eth1_1  | Loading config file from node.toml
eth1_1  | 2017-02-09 11:17:33 UTC Starting Parity/v1.6.0-nightly-4fa1717-20170205/x86_64-linux-gnu/rustc1.15.0
eth1_1  | 2017-02-09 11:17:33 UTC State DB configuration: fast
eth1_1  | 2017-02-09 11:17:33 UTC Operating mode: active
eth1_1  | 2017-02-09 11:17:33 UTC Configured for DemoPoA using AuthorityRound engine
eth2_1  | Loading config file from node.toml
eth2_1  | 2017-02-09 11:17:33 UTC Starting Parity/v1.6.0-nightly-4fa1717-20170205/x86_64-linux-gnu/rustc1.15.0
eth2_1  | 2017-02-09 11:17:33 UTC State DB configuration: fast
eth2_1  | 2017-02-09 11:17:33 UTC Operating mode: active
eth2_1  | 2017-02-09 11:17:33 UTC Configured for DemoPoA using AuthorityRound engine
eth1_1  | 2017-02-09 11:17:39 UTC Public node URL: enode://aafcbed78d77944676c644f3b9eb8549976ff31a4c0c2e759b9d38ab796ffc2e82c768ded71abb2e04b58c653c72dea19dc139d24489d539d26d791cd4cfe91f@172.21.0.2:30300
eth2_1  | 2017-02-09 11:17:39 UTC Public node URL: enode://bee69283cdf1d719b77b1a5c489dcdb1272b5116f5dfea191906d387e5eeaf4dab0673d516c7aa112e173e780c6f466841a1238f46c5a419f2d616d8ae33a00f@172.21.0.3:30300
eth1_1  | 2017-02-09 11:18:04 UTC    0/ 0/25 peers     7 KiB db    7 KiB chain  0 bytes queue 448 bytes sync  RPC:  0 conn,  0 req/s,   0 µs
eth2_1  | 2017-02-09 11:18:04 UTC    0/ 0/25 peers     7 KiB db    7 KiB chain  0 bytes queue 448 bytes sync  RPC:  1 conn,  3 req/s,  29 µs

CONTAINER ID        IMAGE                   COMMAND                  CREATED             STATUS              PORTS                                                                                                        NAMES
c20c7703814c        ethcore/parity:v1.5.2   "bash /parityconf/..."   32 minutes ago      Up 32 minutes       8545/tcp, 0.0.0.0:8081->8080/tcp, 0.0.0.0:8181->8180/tcp, 0.0.0.0:8541->8540/tcp, 0.0.0.0:30301->30300/tcp   parity_eth2_1
72956fab7b6a        ethcore/parity:v1.5.2   "bash /parityconf/..."   About an hour ago   Up 32 minutes       0.0.0.0:8080->8080/tcp, 0.0.0.0:8180->8180/tcp, 0.0.0.0:8540->8540/tcp, 0.0.0.0:30300->30300/tcp, 8545/tcp   parity_eth1_1
~~~


## Steps after initial setup

I am planning on automate this soon, but for now it is manually...

### Create accounts for each node

So, for example: node0 user with node0 password and node1 user with node1 password

~~~
$ curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["node0", "node0"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8540
{"jsonrpc":"2.0","result":"0x00bd138abd70e2f00903268f3db08f2d25677c9e","id":0}

$ curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["node1", "node1"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8541
{"jsonrpc":"2.0","result":"0x00aa39d30f0d20ff03a22ccfc30b7efbfca597c2","id":0}
~~~


