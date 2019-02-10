############################################################################################################################################
## Latest experimental Alpha4 Code and deploy - fez29/graftnoded-jagerman:experimental - 09 Feb 2019
############################################################################################################################################

FROM ubuntu:18.04

ENV BUILD_PACKAGES ca-certificates curl gnupg2 sed

RUN apt-get update && apt-get install --no-install-recommends -y $BUILD_PACKAGES

RUN curl -s https://deb.graft.community/public.gpg | apt-key add - && \
    echo "deb https://deb.graft.community bionic main" | tee /etc/apt/sources.list.d/graft.community.list

RUN apt update && apt install graft-supernode-wizard selinux-basics -y

ENV PACKAGES git ca-certificates

RUN apt-get update && apt-get install --no-install-recommends -y $PACKAGES && cd /opt && git clone --recursive -b non_root_user https://github.com/Fez29/fez-graft-docker.git && apt-get clean && apt-get autoremove -y && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
        cp -r /opt/fez-graft-docker/supervisor/etc/supervisor/ /etc/ && \
		rm -r /opt/fez-graft-docker && \
		apt-get clean && apt-get autoremove -y

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates supervisor wget curl && \
	apt-get clean && apt-get autoremove -y

RUN cp /etc/supervisor/conf.d/blockchain.sh /home/graft-sn/supernode/blockchain.sh && cp /etc/supervisor/conf.d/blockchain.sh_usage /home/graft-sn/supernode/blockchain.sh_usage && chmod +x /etc/supervisor/conf.d/graftnoded.sh && chmod +x /etc/supervisor/conf.d/graftnoded_second.sh && chmod +x /home/graft-sn/supernode/blockchain.sh

RUN cd /home/graft-sn/supernode && git clone --recursive -b master https://github.com/Fez29/graft-sn-watchdog.git \
		&& cd graft-sn-watchdog \ 
		&& chmod +x gn.sh \ 
		&& chmod +x gs.sh \
		&& apt-get install python3-pip -y \
		&& pip3 install requests

EXPOSE 28680

EXPOSE 28690

RUN mkdir -p /.graft

RUN groupadd -g 999 gareth && \
    useradd -r -u 999 -g gareth gareth

RUN apt install sudo -y && \
	cp /etc/sudoers /etc/sudoers.bak

RUN cd /home/graft-sn/supernode/ \
	&& mkdir -p /home/graft-sn/supernode/graft-sn-watchdog/scripts \
	&& cp config.ini /home/graft-sn/supernode/graft-sn-watchdog/scripts/config.ini \
	&& cp /home/graft-sn/supernode/graft-sn-watchdog/gn.sh /home/graft-sn/supernode/graft-sn-watchdog/scripts/gn.sh \
	&& cp /home/graft-sn/supernode/graft-sn-watchdog/gs.sh /home/graft-sn/supernode/graft-sn-watchdog/scripts/gs.sh

RUN echo "gareth ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN mkdir -p /home/gareth/.graft

RUN chown -R gareth: /home /opt /.graft /home/graft-sn /home/gareth
RUN chmod 777 /home /opt /.graft /home/graft-sn /home/gareth

RUN cat /etc/sudoers

RUN ln -sf bash /bin/sh

WORKDIR /home/graft-sn/supernode/

ENTRYPOINT ["bash","-c","/home/graft-sn/supernode/graft-sn-watchdog/scripts/all_scripts.sh"]

USER gareth
#########################
#WORKIN
#########################
