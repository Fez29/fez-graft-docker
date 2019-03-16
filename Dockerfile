FROM debian:buster

ENV BUILD_PACKAGES ca-certificates curl gnupg2 sed sudo

RUN apt-get update && apt-get install --no-install-recommends -y $BUILD_PACKAGES

RUN curl -s https://deb.graft.community/public.gpg | apt-key add - && \
    echo "deb https://deb.graft.community sid main" | tee /etc/apt/sources.list.d/graft.community.list

RUN apt update && apt install graft-supernode-wizard selinux-basics -y && mkdir -p /home/graft-sn/supernode

ENV PACKAGES git ca-certificates

RUN apt-get update && apt-get install --no-install-recommends -y $PACKAGES && cd /opt && git clone --recursive -b non_root_user https://github.com/Fez29/fez-graft-docker.git && apt-get clean && apt-get autoremove -y && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
        cp -r /opt/fez-graft-docker/supervisor/etc/supervisor/ /etc/ && \
		rm -r /opt/fez-graft-docker && \
		apt-get clean && apt-get autoremove -y

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates wget curl && \
	apt-get clean && apt-get autoremove -y

RUN cp /etc/supervisor/conf.d/blockchain.sh /home/graft-sn/supernode/blockchain.sh && cp /etc/supervisor/conf.d/blockchain.sh_usage /home/graft-sn/supernode/blockchain.sh_usage && chmod +x /etc/supervisor/conf.d/graftnoded.sh && chmod +x /etc/supervisor/conf.d/graftnoded_second.sh && chmod +x /home/graft-sn/supernode/blockchain.sh

RUN cd /home/graft-sn/supernode && git clone --recursive -b master https://github.com/Fez29/graft-sn-watchdog.git \
		&& cd graft-sn-watchdog \ 
		##&& chmod +x gn.sh \ 
		##&& chmod +x gs.sh \
		&& apt-get install python3-pip -y \
		&& pip3 install requests

EXPOSE 28680

EXPOSE 28690

RUN apt install sudo -y \
	&& cp /etc/sudoers /etc/sudoers.bak \
	&& echo "graft-sn ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER graft-sn

RUN cd /home/graft-sn/supernode/ \
	## OLD && sudo cp config.ini /home/graft-sn/supernode/graft-sn-watchdog/config.ini \
	&& cp /usr/share/doc/graft-supernode/config.ini ~/supernode/config.ini \
	&& sudo mkdir -p /home/graft-sn/.graft \
	&& sudo groupadd supernode \
	&& sudo usermod -a -G supernode graft-sn \
	&& sudo chgrp -R supernode /home/graft-sn \
	&& sudo chmod -R g+w /home/graft-sn

	####OLD
	#&& sudo chown -R graft-sn: /home /opt /home/graft-sn \
	#&& sudo chmod -R 777 /home /opt /home/graft-sn

RUN sudo cat /etc/sudoers

RUN sudo ln -sf bash /bin/sh

WORKDIR /home/graft-sn/supernode/

#ENTRYPOINT ["bash","-c","/home/graft-sn/supernode/graft-sn-watchdog/gn.sh"]
#########################
#WORKIN
#########################
