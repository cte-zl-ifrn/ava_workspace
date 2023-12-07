# AVA ecosystem

> ***APENAS PARA DESENVOLVIMENTO NO IFRN, não suba em produção usando em projeto, existem outro projeto para isso.***

O Ecossistema AVA do IFRN é composto do sistema de integração (Painel e Middlware) e vários Moodles construídos como imagens Docker.

> Neste projeto usamos o [Docker](https://docs.docker.com/engine/install/) e o [Docker Compose Plugin](https://docs.docker.com/compose/install/compose-plugin/#:~:text=%20Install%20the%20plugin%20manually%20%F0%9F%94%97%20%201,of%20Compose%20you%20want%20to%20use.%20More%20) (não o [docker-compose](https://docs.docker.com/compose/install/) 😎). O setup foi todo testado usando o Linux, Mac OS e WSL2.

> Os containeres terão o prefixo `ava-`, que é um acrônimo para "Ambiente Virtual de ensino e Aprendizagem".

## Como iniciar o desenvolvimento

Este projeto em docker compose assume que você não tenha aplicações rodando na porta 80, ou seja, pare o serviço que está na porta 80 ou faça as configurações necessárias vocês mesmo. O script `./ava` tem atalhos para a maioria dos comandos que você necessitará. A instrução `./ava env setup` no seu PC criará automaticamente uma entrada no `/etc/hosts` para o hostname `ava` apontando para `127.0.02`. Isso é necessário para simplificar o cenário de desenvolvimento local.

```bash
curl https://gist.githubusercontent.com/cte-ead/4cbd7b0eda1be2a2622027aff6d219b2/raw/7bc5bd588167554343fc80845a5d149f4c64ce60/ava-setup-env-dev | bash
```

> O **Painel** estará disponível em http://ava/painel, o primeiro usuário a acessar será declarado como superusuário e poderá fazer tudo no sistema.
> O **Moodle** estará disponível em http://ava, o primeiro usuário a acessar será declarado como superusuário e poderá fazer tudo no sistema.

Caso você deseje fazer debug do Painel AVA, tente:

```bash
ava painel down
ava painel debug
```

### Configurar o PATH do para o script ava

Se você configurar o `PATH` o script poderá ser executado como `ava` ao invés de `./ava`.
