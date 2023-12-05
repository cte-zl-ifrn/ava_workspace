# wordpress__workspace
Workspace para desenvolvimento do Wordpress no ZL/IFRN

> O pasta `projetos` usada neste tutorial é de sua escolha e responsabilidade.

Baixar o projeto e abrir

```bash
mkdir -p ~/projetos/IFRN/ava
git clone git@gitlab.ifrn.edu.br:ead/ava/ava_workspace.git ~/projetos/IFRN/ava/ava_workspace
~/projetos/IFRN/ava/ava_workspace
./clonar.sh

docker compose build
docker compose up -d 

code ava_workspace.code-workspace
```

Restaure o banco (em outro terminal)



Acesse http://localhost/portal/

Para restaurar o portal:
1. Coloque o arquivo de restore do **banco** em `~/projetos/IFRN/cms/backups/portal`
2. Coloque o arquivo de restore do **wordpress** em `~/projetos/IFRN/cms/portal/wordpress`


Para parar tudo e limpar tudo.

```bash
cd ~/projetos/IFRN/cms/cms_workspace
docker compose down && sudo rm -rf ../volumes/data-portal && docker compose up
```
