#!/bin/sh

set -eu
apt-get -qq update
DEBIAN_FRONTEND=noninteractive apt-get install -qy \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    gnupg-agent \
    openjdk-11-jdk-headless \
    python3 \
    python3-venv \
    software-properties-common \
    unzip

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get -qq update
DEBIAN_FRONTEND=noninteractive apt-get install -qy --no-install-recommends \
    docker-ce \
    docker-ce-cli

update-alternatives --install /usr/bin/python python /usr/bin/python3 1

if [ $(uname -m) = "aarch64" ]
then
    AWS_ZIP=https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip
else
    AWS_ZIP=https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
fi

curl "$AWS_ZIP" -o "/tmp/awscli-bundle.zip"
unzip -q -d /tmp/awscli /tmp/awscli-bundle.zip
/tmp/awscli/aws/install -i /usr/local/aws
aws --version

adduser ubuntu docker

mkdir /home/ubuntu/.aws
echo '[default]' >> /home/ubuntu/.aws/config
echo 'region = us-east-1' >> /home/ubuntu/.aws/config

# Disable unattended-upgrade
systemctl disable unattended-upgrades.service
apt-get -y remove unattended-upgrades

sed -i -e 's/#PermitTTY.*/PermitTTY yes/g' /etc/ssh/sshd_config
 
# install packer.  We are using an older version because current 1.8.5 has
# a bug in it that prevents the temp ssh key from being setup for freebsd
curl --output packer.zip https://releases.hashicorp.com/packer/1.5.1/packer_1.5.1_linux_amd64.zip  
unzip -o packer.zip
install -m 755 packer /usr/bin/packer
