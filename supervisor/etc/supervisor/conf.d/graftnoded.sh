#!/bin/sh
# add name of other docker container in place of "graft_graftsn-experimetal2"
#example with DNS record
#graftnoded --testnet --add-priority-node `getent hosts graft_graftsn-experimetal2 | awk '{print $1; exit}'`:28680 --detach
bash -c 'sleep 4 && graftnoded --testnet --out-peers 100 --enforce-dns-checkpointing --detach'



