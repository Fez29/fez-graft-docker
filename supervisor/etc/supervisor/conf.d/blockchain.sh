#!/bin/sh
# add name of other docker container in place of "graft_graftsn-experimetal2"
#example with DNS record
#graftnoded --testnet --add-priority-node `getent hosts graft_graftsn-experimetal2 | awk '{print $1; exit}'`:28680 --detach
#comment out first line to disable blockchain download (is the latest testnet download very close to current block and do same with second line to disable downloading watch-only-wallets on each restart
#second line is latest watch-only-wallets download
#Be sure to test the script after making changes
mkdir -p $HOME/.graft/testnet/lmdb && rm -r $HOME/.graft/testnet/lmdb && mkdir -p $HOME/.graft/testnet/lmdb && cd ~/.graft/testnet/lmdb && wget https://rta.graft.observer/lmdb/data.mdb &&
mkdir -p ~/.graft/supernode/data/watch-only-wallets && cd ~/.graft/supernode/data && curl -s https://rta.graft.observer/lmdb/watch-only-wallets.tar | tar xvf -
