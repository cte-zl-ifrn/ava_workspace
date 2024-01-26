# Instalação do pre requisitos em Debian 12

## Atualiza o debian (parece funcionar corretamente no Ubuntu)

```bash
sudo apt -y update
sudo apt -y upgrade
```

## curl, git e build-essential

```bash
sudo apt-get -y install curl git build-essential wget
```

## Python 3

```bash
sudo apt-get -y install python3 python3-dev python3-pip python3-venv virtualenvwrapper python3-setuptools
sudo apt-get -y install libncurses5-dev libncursesw5-dev libreadline6-dev libdb-dev libgdbm-dev libsqlite3-dev libssl-dev libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev libxml2-dev libxslt1-dev
```

## Docker

```bash
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo groupadd docker
sudo usermod -aG docker $USER

docker compose version
docker-compose --version
docker run --rm hello-world
```
