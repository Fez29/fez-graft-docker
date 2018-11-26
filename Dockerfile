FROM ubuntu:18.04

ENV SRC_DIR $HOME/GraftNetwork

ENV BUILD_PACKAGES ca-certificates git build-essential cmake pkg-config libboost-all-dev libssl-dev autoconf automake check libpcre3-dev rapidjson-dev libreadline-dev

RUN apt-get update && apt-get install --no-install-recommends -y $BUILD_PACKAGES

RUN cd $HOME

RUN git clone --recursive https://github.com/jagerman/GraftNetwork.git && \
        cd GraftNetwork && \
        git checkout multi-sn && \
        git submodule update --init --recursive

RUN cd && \
        mkdir -p ~/supernode/bin && \
        cd ~/supernode/bin && \
        cmake -DENABLE_SYSLOG=ON $SRC_DIR && \
        make

RUN cd ~/supernode/bin/bin && \
        cp ** //opt

RUN apt-get update && apt-get install --no-install-recommends -y supervisor

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /opt && git clone https://github.com/MustDie95/graft.git

RUN cp -r /opt/graft/supervisor/etc/supervisor/ /etc/

RUN mkdir /root/.graft

EXPOSE 28690

WORKDIR /opt

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
