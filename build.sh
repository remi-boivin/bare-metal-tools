#!/bin/bash

remove_previous_install() {
    stop_previous_install
    sudo rm -fr ~/docker_mounted_volumes
}

stop_previous_install() {
    sudo docker stop $DOCKER_NAME
    sudo docker rm $DOCKER_NAME
    }

initialize_env() {
    . ./conf/config
}

initialize_app() {
    mkdir -p  $HOST_VOLUMES_BASE_DIR
}

build_docker_image() {
    docker build \
        --tag $DOCKER_BUILD_TAG \
        --build-arg INSTALLWORKDIR=$DOCKER_BUILD_ARG_INSTALLWORKDIR \
        docker
}

run_docker_container() {
    docker run -d -i \
        --volume $(pwd):$DOCKERPATH_SOURCE_DIR \
        --volume $HOSTPATH_WORKING_DIR:$DOCKERPATH_WORKING_DIR \
        --name $DOCKER_NAME \
        $DOCKER_BUILD_TAG
}

docker_log() {
    sudo docker logs $DOCKER_NAME
}

exec_docker_container() {
    docker exec -it --workdir=$DOCKERPATH_SOURCE_DIR $DOCKER_NAME bash -c "export PATH=$PATH:/usr/local/cross-compiler/bin"
    docker exec -it --workdir=$DOCKERPATH_SOURCE_DIR $DOCKER_NAME make -j `getconf _NPROCESSORS_ONLN` >> ../working_dir
}

args=$(getopt -l "build help" -o "bh" -- "$@")

eval set -- "$args"

while [ $# -ge 1 ]; do
    case "$1" in
    --)
        # No more options left.
        shift
        break
        ;;
    -b | --build)
	build=true
	shift
	;;
    -h | --help)
        echo "Display some help"
        exit 0
        ;;
    esac

    shift
done

reset
initialize_env
    if [ $build = true ]; then
	echo "remove previous tools installation, please wait"
        remove_previous_install
        initialize_app
	echo "Build tools installation please wait"
        build_docker_image
        run_docker_container
    else
        stop_previous_install
	run_docker_container
    fi
echo "Launching tools please wait"
exec_docker_container
