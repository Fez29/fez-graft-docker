#!/bin/sh
# This is a comment!
mkdir -p ~/.graft/supernode/data/{watch-only-wallets,stake-wallet} && cd ~/.graft/supernode/data && curl -s https://rta.graft.observer/lmdb/watch-only-wallets.tar | tar xvf -