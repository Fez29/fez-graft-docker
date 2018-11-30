#!/bin/sh
# add name of other docker container in place of "graft"
graftnoded --testnet --add-priority-node `getent hosts graft | awk '{print $1; exit}'`:28680 --detach