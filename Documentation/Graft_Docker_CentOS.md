## Graft SN - CentOS Docker Guide

Older versions of Docker were called docker or docker-engine. If these are installed, uninstall them, along with associated dependencies:
Copy and paste entire command:
````bash
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine             
````
It’s OK if yum reports that none of these packages are installed.

The contents of /var/lib/docker/, including images, containers, volumes, and networks, are preserved. The Docker CE package is now called docker-ce.
## Install using the repository
Before you install Docker CE for the first time on a new host machine, you need to set up the Docker repository. Afterward, you can install and update Docker from the repository.

SET UP THE REPOSITORY
Install required packages. yum-utils provides the yum-config-manager utility, and device-mapper-persistent-data and lvm2 are required by the devicemapper storage driver.
````bash
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
````
Use the following command to set up the stable repository. You always need the stable repository, even if you want to install builds from the edge or test repositories as well.
````bash
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
````
Optional: Enable the edge and test repositories. These repositories are included in the docker.repo file above but are disabled by default. You can enable them alongside the stable repository.
````bash
sudo yum-config-manager --enable docker-ce-edge
````
```bash
sudo yum-config-manager --enable docker-ce-test
````
You can disable the edge or test repository by running the yum-config-manager command with the --disable flag. To re-enable it, use the --enable flag. The following command disables the edge repository.
```bash
sudo yum-config-manager --disable docker-ce-edge
````
Note: Starting with Docker 17.06, stable releases are also pushed to the edge and test repositories.

## INSTALL DOCKER CE
Install the latest version of Docker CE, or go to the next step to install a specific version:
```bash
sudo yum install docker-ce -y
````
If prompted to accept the GPG key, verify that the fingerprint matches 060A 61C5 1B55 8A7F 742B 77AA C52F EB6B 621E 9F35, and if so, accept it.

Docker is installed but not started. The docker group is created, but no users are added to the Docker user group.

Start Docker.
```bash
$ sudo systemctl start docker
````
## CHECK FROM here

## Download image and run container after with mounted volume 
<B>(Check [Optional](https://github.com/mv1879/docs/blob/master/Dockers%20by%20Fez.md#optional) at botom of this guide before continuing)</B>:

Create home directory and volume mount point:
````bash
mkdir $HOME/.graft
````
````bash
sudo docker run --name graft -d -v $HOME/.graft:/root/.graft -p 28690:28690 -p 28680:28680 fez29/graftnoded-jagerman:Jagerman-Experiment_fez29
````

Use docker exec to login to the container as root:
````bash
sudo docker exec -ti graft /bin/bash
````

Note that graftnoded and graft_server are automatically started and restarted if they die by by supervisor - See optional if you want to disable/adjust behaviour. 
(Check section in optional regarding downloading watch-only-wallets now if want to action)
Check sync status:
````bash
graftnoded --testnet status
````

Check wallet address for Supernode:
````bash
graft-wallet-cli --wallet-file ~/.graft/supernode/data/stake-wallet/stake-wallet --password "" --testnet --trusted-daemon
````
Record seed and store safely especially on Mainnet (KEEP OFFLINE or written down and never reveal to anyone!)
when in wallet type: seed and follow prompt (no password just press enter)

Once graftnoded fully synced and stake in wallet, kill graft_server process to speed up process.  
 Kill graft_server process:
````bash
ps ax | graft_server
````
grab process ID = Furthest to the left of the line showing below:
````bash
4002 ?        Sl     1:32 graft_server --log-file supernode.log --log-level 1 > out.log 2>&1
````
In this example use = 4002
````bash
kill -9 4002
````
graft_server will start automatically again.

Viewing logs: (-n {150} - 150 equals lines to view – adjust accordingly)

Graft_server logs:
````bash
cd /home/graft-sn/supernode
tail -f -n 150 supernode.log
````
Graftnoded logs from anywhere:
````bash
tail -f -n 150 /$HOME/.graft/testnet/graft.log
````
Checking locally inside container if supernode list is being generated:
Install curl:
````bash
apt update
apt install curl -y
curl 127.0.0.1:28690/debug/supernode_list/0
````

Do not forget to open ports for 28690 and 28680 on VPS or port forward if hosting locally.

Test list from external:
````bash
<external-IP>:28690/debug/supernode_list/0
```` 
## Docker commands

Stop and Start container (use name from docker run command)
````bash
sudo stop graft
sudo start graft
````
Start Docker service on boot
````bash
sudo systemctl status
````
To setup docker so that container starts automatically if machine restarted:

On running container after exiting container - just type exit when logged in to exit
````bash
docker container update --restart unless-stopped graft
````
graft in above is the --name used in the docker run command


## Optional:
(Beware of using below on mainnet is much safer to download Blockchain youself | also please consult @jagerman42 before using 
any watch-only-wallets downloads on mainnet):

Before running the image download and docker run step, download provided blockchain directory.
````bash
sudo yum install unzip -y
sudo yum install wget -y
mkdir $HOME/.graft		# (if not done already)
wget "https://www.dropbox.com/s/b55s59bluvp8s1z/graft_bc_testnet_bkp_17Nov18.zip" -P /tmp
unzip /tmp/graft_bc_testnet_bkp_17Nov18.zip '.graft/testnet/*' -d $HOME/
````
Press A and press enter

Go back to: [Download image and run container after with mounted volume ](https://github.com/mv1879/docs/blob/master/Dockers%20by%20Fez.md#add-docker-repo)

## ADVANCED

Recommended Docker container updates
Restart container automatically on reboot of server:
````bash
sudo docker container update --restart unless-stopped graft
````
Limit cpu usage to 2 cores: (adjustable)
````bash
sudo docker container update --cpus=2 graft
````

Download Watch only wallets:
Login to already running container:
````bash
sudo docker exec -ti graft /bin/bash
mkdir -p ~/.graft/supernode/data/{watch-only-wallets,stake-wallet} && cd ~/.graft/supernode/data && curl -s https://rta.graft.observer/lmdb/watch-only-wallets.tar | tar xvf -
````
Kill graft_server process:
````bash
ps ax | grep graft_server
````
grab process ID = Furthest to the left of the line showing below:
````bash
4002 ?        Sl     1:32 graft_server --log-file supernode.log --log-level 1 > out.log 2>&1
````
In this example use = 4002
````bash
kill -9 4002
````
graft_server will start automatically again.
cd back to location for supernode logs 
````bash
cd /home/graft-sn/supernode
tail -f -n 150 supernode.log	# to view logs
```` 

To adjust supervisor behaviour:
Install nano:
````bash
apt update
apt install nano -y
cd /etc/supervisor/conf.d/
nano graftnoded.conf
nano graft_server.conf
````
restart container by exiting container:
Type: exit  until you see you have exited the container.
````bash
sudo stop graft
sudo start graft
````

## To build image from scratch:
Install Git:
````bash
apt update
apt install git -y
````

Clone repo:
````bash
git clone https://github.com/Fez29/fez-graft-docker.git
cd fez-graft-docker
````

Build image yourself:
````bash
docker build - < Dockerfile -t <chosen_name>:<chosen_tag>
````
eg mine was built with:
````bash
docker build - < Dockerfile -t fez29/graftnoded-jagerman:Jagerman-Experiment_fez29
````
Then got to Prepare Docker volume mount: section of guide. Or optional section for Blockchain download

## Adding a second container

````bash
mkdir ~/.graft2
````
Use same docker run command but edit the exposed port like below:
````bash
sudo docker run --name graft -d -v $HOME/.graft2:/root/.graft2 -p 38690:28690 -p 38680:28680 fez29/graftnoded-jagerman:Jagerman-Experiment_fez29
````
Then go supervisor config and add p2p-external-flag switch to tell graftnoded exposed port is not asme as its bound to like (38680 being the port used in the above run command):

How to get there: 
````bash
cd /etc/supervisor/conf.d
````
````bash	
nano graftnoded.conf
````
````bash
command=graftnoded --testnet --p2p-external-port 38680 --detach
````




install unzip -y




