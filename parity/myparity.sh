#!/bin/bash

DIRECTORY=$1

CONF_FILE=$2

if [ ! -d "$DIRECTORY" ]; then
  # Control will enter here if $DIRECTORY doesn't exist.
  DIRECTORY=/parityconf
fi

if [ ! -d "$CONF_FILE" ]; then
  # Control will enter here if $DIRECTORY doesn't exist.
  CONF_FILE=node.toml
fi


cp -a /build/parity/target/release/parity /usr/bin/.


cd /parityconf

parity --config $CONF_FILE --jsonrpc-interface all --jsonrpc-hosts all --ui-interface $(hostname -i)
