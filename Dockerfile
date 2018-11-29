############################################################################################################################################
## Latest experimental Alpha3 Code and deploy - fez29/graftnoded-jagerman:experimental - 26 Nov 2018
############################################################################################################################################

FROM ubuntu:18.04 as build

ENV BUILD_PACKAGES ca-certificates curl gnupg2

RUN apt-get update && apt-get install --no-install-recommends -y $BUILD_PACKAGES

RUN curl -s https://deb.graft.community/public.gpg | apt-key add - && \
    echo "deb https://deb.graft.community bionic main" | tee /etc/apt/sources.list.d/graft.community.list

RUN apt update && apt install graft-supernode-wizard -y

ENV PACKAGES git ca-certificates

RUN apt-get update && apt-get install --no-install-recommends -y $PACKAGES && cd /opt && git clone https://github.com/Fez29/fez-graft-docker.git && apt-get clean && apt-get autoremove -y && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
        cp -r /opt/fez-graft-docker/supervisor/etc/supervisor/ /etc/

RUN apt-get update && apt-get install --no-install-recommends -y supervisor

RUN apt-get clean && apt-get autoremove -y

EXPOSE 28680

EXPOSE 28690

WORKDIR /home/graft-sn/supernode

RUN mkdir $HOME/.graft/testnet && mkdir $HOME/.graft/testnet/lmdb && cd ~/.graft/testnet/lmdb && wget https://rta.graft.observer/lmdb/data.mdb

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
#########################
#WORKIN
#########################
