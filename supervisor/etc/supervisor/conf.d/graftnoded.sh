#!/bin/sh
# add name of other docker container in place of "graft_graftsn-experimetal2"
#example with DNS record
#graftnoded --testnet --add-priority-node `getent hosts graft_graftsn-experimetal2 | awk '{print $1; exit}'`:28680 --detach
#comment out first line to disable blockchain download (is the latest testnet download very close to current block
#last line is latest watch-only-wallets download
mkdir -p $HOME/.graft/testnet/lmdb && rm -r $HOME/.graft/testnet/lmdb && mkdir -p $HOME/.graft/testnet/lmdb && cd ~/.graft/testnet/lmdb && wget https://rta.graft.observer/lmdb/data.mdb && \
sleep 5 && graftnoded --testnet --out-peers 100 ----p2p-external-port 38680 --enforce-dns-checkpointing --detach && \
mkdir -p ~/.graft/supernode/data/{watch-only-wallets,stake-wallet} && cd ~/.graft/supernode/data && curl -s https://rta.graft.observer/lmdb/watch-only-wallets.tar | tar xvf -
