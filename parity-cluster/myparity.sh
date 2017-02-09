#!/bin/bash

DIRECTORY=$1

if [ ! -d "$DIRECTORY" ]; then
  # Control will enter here if $DIRECTORY doesn't exist.
  DIRECTORY=/parityconf
fi

cp -a /build/parity/target/release/parity /usr/bin/.


cd /parityconf

parity --config node.toml --jsonrpc-interface all --jsonrpc-hosts all --ui-interface $(hostname -i)
