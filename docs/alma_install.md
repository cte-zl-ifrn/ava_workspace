# Instalação do pre requisitos em AlmaLinux 9

```bash
function put_line_to_profile {
    sudo su -c "echo $1 >> /etc/bash.bashrc"
}
```

## Instalação dos pacotes gerais

```bash
sudo su -c "dnf upgrade -y"
sudo dnf install epel-release -y
sudo dnf install curl git wget -y
```

# Python 3

```bash
sudo dnf -y install python3 python3-pip python3-setuptools
sudo ln -s /usr/bin/python3 /usr/bin/python
sudo ln -s /usr/bin/pip3 /usr/bin/pip
sudo pip install virtualenvwrapper
sudo su -c "echo '' >> /etc/bash.bashrc"
sudo su -c "echo 'export WORKON_HOME=\$HOME/.virtualenvs' >> /etc/bash.bashrc"
sudo su -c "echo 'export PROJECT_HOME=\$HOME/devel' >> /etc/bash.bashrc"
sudo su -c "echo 'source /usr/local/bin/virtualenvwrapper.sh' >> /etc/bash.bashrc"
```

# Install “docker, docker-compose e docker compose plugin”

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo systemctl start docker

docker --version
docker compose version
docker-compose --version
docker run --rm hello-world
```
