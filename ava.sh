#!/usr/bin/env bash

NO_COLOR='\033[0m'
SERVICE_NAME=$(basename $(dirname $0))

AVA_PWD=~/projetos/IFRN/ava

cd $AVA_PWD/ava_workspace

source .env

echo_warning() {
    ORANGE_COLOR='\033[0;33m'
    echo ${@:3} -e "$ORANGE_COLOR WARN: $(date +\"%F\ %T\") $1$NO_COLOR"
}

echo_danger() {
    RED_COLOR='\033[0;31m'
    echo ${@:3} -e "$RED_COLOR DANG: $(date +\"%F\ %T\") $1$NO_COLOR"
}

echo_info() {
    BLUE_COLOR='\033[1;34m'
    echo ${@:3} -e "$BLUE_COLOR INFO: $(date +\"%F\ %T\") $1$NO_COLOR"
}

echo_success() {
    GREEN_COLOR='\033[1;32m'
    echo ${@:3} -e "$GREEN_COLOR SUCC: $(date +\"%F\ %T\") $1$NO_COLOR"
}

restart_service() {
    docker compose down $1
    docker compose up -d $1
}

exec_service() {
    if [[ `docker container ls | grep $COMPOSE_PROJECT_NAME-$1-1` ]]; then 
        docker compose exec $1 $@
    else
        echo_warning "O container $COMPOSE_PROJECT_NAME-$1-1 não está em execução, executando com run"
        docker compose run --rm $1 $@
    fi
}

setup_env() {
    echo cp -r $AVA_PWD/integracao/painel-ava/confs/examples $AVA_PWD/integracao/painel-ava/confs/enabled
    echo ""; echo_info "Parar o mundo"
    docker compose down

    if ! grep -q 'PAINEL-AVA' /etc/hosts; then
        echo '

    ######################################################################
    ## PAINEL-AVA
    ######################################################################
    127.0.0.2    ava

        ' | sudo tee -a /etc/hosts
    fi

    git clone git@gitlab.ifrn.edu.br:ead/sass.git                          ~/projetos/IFRN/sass

    mkdir $AVA_PWD/integration
    git clone git@gitlab.ifrn.edu.br:ead/ava/integration/painel-ava.git    $AVA_PWD/integration/painel-ava

    mkdir $AVA_PWD/lms
    git clone git@gitlab.ifrn.edu.br:ead/ava/lms/moodle.git                $AVA_PWD/lms/moodle
    git clone git@gitlab.ifrn.edu.br:ead/ava/lms/local_suap.git            $AVA_PWD/lms/local_suap
    git clone git@gitlab.ifrn.edu.br:ead/ava/lms/theme_moove.git           $AVA_PWD/lms/theme_moove
    git clone git@gitlab.ifrn.edu.br:ead/ava/lms/auth_suap.git             $AVA_PWD/lms/auth_suap
    git clone git@gitlab.ifrn.edu.br:ead/ava/lms/enrol_suap.git            $AVA_PWD/lms/enrol_suap
    git clone git@gitlab.ifrn.edu.br:ead/ava/lms/block_suapattendance.git  $AVA_PWD/lms/block_suapattendance
    git clone git@gitlab.ifrn.edu.br:ead/ava/lms/format_suap.git           $AVA_PWD/lms/format_suap

    mkdir $AVA_PWD/h5p
    git clone git@gitlab.ifrn.edu.br:ead/ava/h5p/codehighlighter.git       $AVA_PWD/h5p/codehighlighter
    git clone git@gitlab.ifrn.edu.br:ead/ava/h5p/texteditor.git            $AVA_PWD/h5p/texteditor

    sudo mkdir -p $AVA_PWD/volumes/moodle_data
    sudo chmod 777 $AVA_PWD/volumes/moodle_data

    if [[ -f ~/.zshrc ]]; then
        if ! grep -q 'ava_workspace' ~/.zshrc; then
            echo 'PATH=$PATH:~/projetos/IFRN/ava/ava_workspace' >> ~/.zshrc
        fi
    fi

    if [[ -f ~/.bashrc ]]; then
        if ! grep -q 'ava_workspace' ~/.bashrc; then
            echo 'PATH=$PATH:~/projetos/IFRN/ava/ava_workspace' >> ~/.bashrc
        fi
    fi

}

deploy_env() {
    setup_env

    echo ""; echo_info "Sobe o cache e o db em background"
    restart_service cache
    restart_service db

    echo ""; echo_info "Construir as imagens"
    docker compose build

    echo ""; echo_info "Reiniciando o mundo novamente"
    docker compose up -d
    # noreplyaddress
    docker compose logs -f
}

service_running() {
    if [[ `docker container ls | grep $COMPOSE_PROJECT_NAME-$1-1` ]]; then 
        echo "ON"
    else
        echo "OFF"
    fi
}

db_wait() {
    echo_info "Aguardando a base de dados..."
    until docker compose exec -u postgres $1 psql -A -c '\l'>/dev/null 2>&1; do
        E=$(docker compose logs --tail 1 $1 | tail -1)
        echo_warning "Postgres is unavailable - sleeping. ERROR: $E"
        sleep 1
    done
    echo_success "Conectado com sucesso!"
}

# ALL_SERVICES=`grep -Po '^    [a-z].*:$' docker-compose.yml | sed -e 's/:/ | /g' | xargs`

case $1 in
  env)
    case $2 in
        backs)
            restart_service cache
            restart_service db
            ;;
        build)
            docker compose build
            ;;
        deploy)
            deploy_env
            ;;
        down)
            docker compose down
            ;;
        logs)
            docker compose logs -f
            ;;
        restart)
            restart_service
            ;;
        setup)
            setup_env
            ;;
        status)
            docker compose ps
            ;;
        undeploy)
            docker compose down

            echo_info "Remove AVA confs"
            rm -rf $AVA_PWD/integracao/painel-ava/confs/enabled/*

            echo_info "Remove AVA volumes"
            sudo rm -rf $AVA_PWD/volumes
            ;;
        up)
            docker compose up
            ;;
        *)
            echo -n "As instruções são: backs, build, deploy, down, logs, restart, status, undeploy, up"            
            ;;
    esac
    ;;
  db | cache | ava | nginx | painel | sass_painel)
    case $2 in
        down)
            docker compose down $1
            ;;
        exec)
            exec_service $1
            ;;
        logs)
            docker compose logs $1 -f
            ;;
        restart)
            restart_service $1
            ;;
        shell)
            if [[ `service_running $1` == 'ON' ]]; then 
                docker compose exec $1 bash
            else
                docker compose run --rm $1 bash
            fi
            ;;
        status)
            echo $1 is `service_running $1`
            ;;
        up)
            case $2 in
                db)
                    if [[ `service_running $1` == 'OFF' ]]; then 
                        docker compose up -d $1
                    fi
                    db_wait $1
                    ;;
                *)
                    docker compose up $1
                    ;;
            esac
            ;;
        build)
            case $1 in
                painel | ava)
                    docker compose build $1
                    ;;
                *)
                    echo -n "Só os serviços 'painel' e 'ava' tem instruções 'build'"
                    ;;
            esac
            ;;
        publish)
            echo "[$2]"
            case $1 in
                ava)
                    docker login gitlab.ifrn.edu.br:4567
                    docker compose push $1
                    ;;
                *)
                    echo -n "Só o serviço 'ava' tem instruções 'publish'"
                    ;;
            esac
            ;;
        cli)
            case $1 in
                cache)
                    if [[ `service_running $1` == 'OFF' ]]; then 
                        docker compose up -d $1
                    fi
                    db_wait $1
                    ;;
                *)
                    echo -n "Só o serviço 'cache' tem instruções 'cli'"
                    ;;
            esac
            ;;
        psql)
            case $1 in
                db)
                    docker compose exec -u postgres $1 psql
                    ;;
                *)
                    echo -n "Só o serviço 'db' tem instruções 'psql'"
                    ;;
            esac
            ;;
        undeploy)
            case $1 in
                db)
                    docker compose down $1

                    echo_info "Remove volume do DB"
                    sudo rm -rf $AVA_PWD/volumes/db_data
                    ;;
                *)
                    echo -n "Só o serviço 'db' tem instruções 'undeploy'"
                    ;;
            esac
            ;;

        wait)
            case $1 in
                db)
                    db_wait $1
                    ;;
                *)
                    echo -n "Só o serviço 'db' tem instruções 'wait'"
                    ;;
            esac
            ;;
        *)
            echo "As instruções são: down exec logs psql restart shell status up"
            echo "Se for cache, também tem: cli"
            echo "Se for db, também tem: psql undeploy wait"
            echo "Se for ava, também tem: build publish"
            ;;
    esac
    ;;

  *)
    echo "Os contextos são: env, db, cache, ava, nginx,  sass_painel"
    ;;
esac
