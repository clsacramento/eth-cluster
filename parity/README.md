# Setup a Parity cluster with docker-compose

Parity is a private Ethereum cluster by default.

This is based on the instructions found here: https://github.com/ethcore/parity/wiki/Demo-PoA-tutorial


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

Also create a user account node0
~~~
$ curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["user", "user"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8540
{"jsonrpc":"2.0","result":"0x004ec07d2329997267ec62b4166639513386f32e","id":0}
~~~


### Restart nodes as miners

I am still not sure this couldn't have been started with this conf but now we add the mining role to the nodes.

to do that we use node0.toml and node1.toml files for each node instead of node.toml for both.

We also stop the current running cluster (ctrl+c) on the docker-compose console and up again with a slight modification of the docker-compose.

Stopping looks like this:

~~~
^CGracefully stopping... (press Ctrl+C again to force)
Stopping parity_eth2_1 ... done
Stopping parity_eth1_1 ... done
$
$ vim docker-compose.yml 
~~~

Modify docker-compose.yml to like this:
~~~
$ cat docker-compose.yml 
version: '2'
services:
  eth1:
    image: "ethcore/parity:v1.5.2"
    ports:
     - "8180:8180"
     - "30300:30300"
     - "8080:8080"
     - "8540:8540"
    volumes:
     - .:/parityconf
     #TODO: add volumes to persist the nodes states
     #TODO: add some automation to add one node to the other
    entrypoint: bash /parityconf/myparity.sh /parityconf node0.toml
  eth2:
    image: "ethcore/parity:v1.5.2"
    ports:
     - "8181:8180"
     - "30301:30300"
     - "8081:8080"
     - "8541:8540"
    volumes:
     - .:/parityconf
    entrypoint: bash /parityconf/myparity.sh /parityconf node1.toml
~~~

And then restart the cluster with docker compose.

~~~
$ sudo docker-compose up
Recreating parity_eth2_1
Recreating parity_eth1_1
Attaching to parity_eth2_1, parity_eth1_1
eth2_1  | Loading config file from node.toml
eth2_1  | 2017-02-09 15:14:09 UTC Starting Parity/v1.6.0-nightly-4fa1717-20170205/x86_64-linux-gnu/rustc1.15.0
eth2_1  | 2017-02-09 15:14:09 UTC State DB configuration: fast
eth2_1  | 2017-02-09 15:14:09 UTC Operating mode: active
eth2_1  | 2017-02-09 15:14:09 UTC Configured for DemoPoA using AuthorityRound engine
eth1_1  | Loading config file from node.toml
eth1_1  | 2017-02-09 15:14:10 UTC Starting Parity/v1.6.0-nightly-4fa1717-20170205/x86_64-linux-gnu/rustc1.15.0
eth1_1  | 2017-02-09 15:14:10 UTC State DB configuration: fast
eth1_1  | 2017-02-09 15:14:10 UTC Operating mode: active
eth1_1  | 2017-02-09 15:14:10 UTC Configured for DemoPoA using AuthorityRound engine
eth2_1  | 2017-02-09 15:14:15 UTC Public node URL: enode://ffe7f9618241de8bbefe45819afaa502ab8d51001426ebd565911f3e4f366c0021ea34534387e562d56dbf27531d264b0ddb6c10da5bca2919a4f549c0eb508e@172.21.0.2:30300
eth1_1  | 2017-02-09 15:14:15 UTC Public node URL: enode://a666df485a53ca8592af957bdddfbf0ec358dd33d28736c80e9e89a91a0f9b23a783d0a34faf9ffc955186625461cd9b3a91b7292e461755233edcd7409052af@172.21.0.3:30300
eth1_1  | 2017-02-09 15:14:15 UTC Received old authentication request. (1486653255 vs 1486653211)
eth1_1  | 2017-02-09 15:14:15 UTC Unauthorized connection to Signer API blocked.
eth2_1  | 2017-02-09 15:14:45 UTC    0/ 0/25 peers     7 KiB db    7 KiB chain  0 bytes queue 448 bytes sync  RPC:  0 conn,  0 req/s,   0 µs
eth1_1  | 2017-02-09 15:14:45 UTC    0/ 0/25 peers     7 KiB db    7 KiB chain  0 bytes queue 448 bytes 
~~~


### Link the two nodes

On the first node get its enode:

~~~
$ curl --data '{"jsonrpc":"2.0","method":"parity_enode","params":[],"id":0}' -H "Content-Type: application/json" -X POST localhost:8540
{"jsonrpc":"2.0","result":"enode://a666df485a53ca8592af957bdddfbf0ec358dd33d28736c80e9e89a91a0f9b23a783d0a34faf9ffc955186625461cd9b3a91b7292e461755233edcd7409052af@172.21.0.3:30300","id":0}
~~~

Than add its enode on the seconde node (using the enode from the result of the previous command):

~~~
$ curl --data '{"jsonrpc":"2.0","method":"parity_addReservedPeer","params":["enode://a666df485a53ca8592af957bdddfbf0ec358dd33d28736c80e9e89a91a0f9b23a783d0a34faf9ffc955186625461cd9b3a91b7292e461755233edcd7409052af@172.21.0.3:30300"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8541
{"jsonrpc":"2.0","result":true,"id":0}
~~~
