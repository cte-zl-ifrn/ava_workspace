# AVA ecosystem

> **_APENAS PARA DESENVOLVIMENTO NO IFRN, não suba em produção usando em projeto, existem outro projeto para isso._**

O Ecossistema AVA do IFRN é composto do sistema de integração (Painel e Middlware) e vários Moodles construídos como imagens Docker.

> Neste projeto usamos o [Docker 24+](https://docs.docker.com/engine/install/). O setup foi todo testado usando o Linux, Mac OS e WSL2.

> Os containeres terão o prefixo `ava-`, que é um acrônimo para "Ambiente Virtual de ensino e Aprendizagem".

## Design

-   [Novo design web](https://xd.adobe.com/view/6ec2ea24-e5c8-494b-a676-fd253d89b352-3b91/).
-   Novo design mobile - a fazer.
-   [Antigo design web](https://xd.adobe.com/view/00dc014e-8919-47ad-ab16-74ac81ca0c2a-558f/).
-   [Antigo design mobile](https://xd.adobe.com/view/28b2f455-b115-4363-954f-77b5bcf1dba1-7de1/).

## Como iniciar o desenvolvimento

Este projeto em docker compose assume que você não tenha aplicações rodando na porta 80, ou seja, pare o serviço que está na porta 80 ou faça as configurações necessárias vocês mesmo. O script `ava` tem atalhos para a maioria dos comandos que você necessitará. A instrução `curl ...` criará automaticamente uma entrada no `/etc/hosts` para o hostname `ava` apontando para `127.0.0.2`. Isso é necessário para simplificar o cenário de desenvolvimento local. Se você estiver em WSL2 será necessário editar o `c:\windows\System32\drivers\etc\hosts` usando um editor de textos como administrador no Windows.

> **ATENÇÃO: Antes de mais nada, você precisa ter permissão nos repositórios Git dos projetos.**

```bash
curl https://raw.githubusercontent.com/cte-zl-ifrn/.github/main/profile/ava-setup-env-dev.sh | $SHELL

cd ~/projetos/IFRN/ava/ava_workspace

code ava_workspace.code-workspace
```

Uma vez no VS Code, abra o terminal e:

```bash
ava deploy
```

> O **Painel** estará disponível em http://ava/painel, o primeiro usuário a acessar será declarado como superusuário e poderá fazer tudo no sistema.
> O **Moodle** estará disponível em http://ava, a credencial é admin/admin.

Caso você deseje fazer debug do Painel AVA (no momento com defeito), tente:

```bash
ava down painel
ava debug painel
```

## Padrões de editor

Neste projeto usamos o editor VSCode como referência, com os seguintes plugins instaldos:

-   ms-python.black-formatter
-   esbenp.prettier-vscode
-   bmewburn.vscode-intelephense-client
-   njpwerner.autodocstring

## Instalar o pyenv

### AlmaLinux 9

```bash
curl https://pyenv.run | bash

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc

source ~/.bashrc

sudo yum groupinstall -y "Development Tools"
sudo yum install -y openssl-devel tk-devel sqlite-devel ncurses-devel readline-devel
curl https://pyenv.run | bash
pyenv install -f 3.12
git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
pyenv virtualenv 3.12 painel-ava
```

## Tipo de commits

-   `feat:` novas funcionalidades.
-   `fix:` correção de bugs.
-   `refactor:` refatoração ou performances (sem impacto em lógica).
-   `style:` estilo ou formatação de código (sem impacto em lógica).
-   `test:` testes.
-   `doc:` documentação no código ou do repositório.
-   `env:` CI/CD ou settings.
-   `build:` build ou dependências.
