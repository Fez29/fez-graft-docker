#!/bin/sh
# add name of other docker container in place of "graft_graftsn-experimetal2"
graftnoded --testnet --add-priority-node `getent hosts graft2 | awk '{print $1; exit}'`:28680 --detach