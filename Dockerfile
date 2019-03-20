FROM debian:buster

RUN apt update && apt install sudo -y \
	&& cp /etc/sudoers /etc/sudoers.bak \
	&& echo "graft-sn ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN useradd graft-sn && usermod -aG sudo graft-sn

ENV BUILD_PACKAGES ca-certificates curl gnupg2 sed git ca-certificates wget curl

RUN apt-get update && apt-get install --no-install-recommends -y $BUILD_PACKAGES

RUN curl -s https://deb.graft.community/public.gpg | apt-key add - && \
    echo "deb https://deb.graft.community sid main" | tee /etc/apt/sources.list.d/graft.community.list

RUN apt update && apt install graftnoded graft-supernode graft-blockchain-tools graft-wallet selinux-basics -y && mkdir -p /home/graft-sn/supernode

#ENV PACKAGES git ca-certificates

RUN sudo apt-get update && cd /opt && sudo git clone --recursive -b non_root_user https://github.com/Fez29/fez-graft-docker.git && sudo apt-get clean && sudo apt-get autoremove -y && \
        sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
        sudo cp -r /opt/fez-graft-docker/supervisor/etc/supervisor/ /etc/ && \
	    sudo rm -r /opt/fez-graft-docker && \
	    sudo apt-get clean && apt-get autoremove -y

RUN sudo apt-get update && \
	sudo apt-get clean && sudo apt-get autoremove -y

RUN sudo cp /etc/supervisor/conf.d/blockchain.sh /home/graft-sn/supernode/blockchain.sh && sudo cp /etc/supervisor/conf.d/blockchain.sh_usage /home/graft-sn/supernode/blockchain.sh_usage && sudo chmod +x /etc/supervisor/conf.d/graftnoded.sh && sudo chmod +x /etc/supervisor/conf.d/graftnoded_second.sh && sudo chmod +x /home/graft-sn/supernode/blockchain.sh

RUN cd /home/graft-sn/supernode && sudo git clone --recursive -b master https://github.com/Fez29/graft-sn-watchdog.git \
		&& cd graft-sn-watchdog \ 
		&& sudo chmod +x gn.sh \ 
		&& sudo chmod +x gs.sh \
		&& sudo apt-get install python3-pip -y \
		&& sudo pip3 install requests

EXPOSE 28880

EXPOSE 28690

RUN cd /home/graft-sn/supernode/ \
	## OLD && sudo cp config.ini /home/graft-sn/supernode/graft-sn-watchdog/config.ini \
    && cp graftnoded.service /etc/systemd/system/graftnoded.service \
    && cp supernode@.service /etc/systemd/system/supernode@.service \
	&& cp /usr/share/doc/graft-supernode/config.ini /home/graft-sn/supernode/config.ini \
	&& sudo mkdir -p /home/graft-sn/.graft \
	&& sudo groupadd supernode \
	&& sudo usermod -a -G supernode graft-sn \
	&& sudo chgrp -R supernode /home/graft-sn \
	&& sudo chmod -R g+w /home/graft-sn \
    && sudo systemctl enable graftnoded.service \
    #&& sudo systemctl start graftnoded.service \

	####OLD
	#&& sudo chown -R graft-sn: /home /opt /home/graft-sn \
	#&& sudo chmod -R 777 /home /opt /home/graft-sn

RUN sudo cat /etc/sudoers

RUN sudo ln -sf bash /bin/sh

USER graft-sn

WORKDIR /home/graft-sn/supernode/

ENTRYPOINT ["bash","-c","sudo systemctl start graftnoded.service"]
#########################
#WORKIN
#########################
