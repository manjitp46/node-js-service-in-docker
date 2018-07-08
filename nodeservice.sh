#!/bin/bash
### BEGIN INIT INFO
# Provides:          zivame
# Required-Start:    $local_fs
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# X-Interactive:     false
# Short-Description: Example init script
# Description:       Start/stop an example script
### END INIT INFO

DESC="Script to satrt node js app as linux service inside docker container"
NAME=newstack
App_path='/home/manjit/docker-test'
#DAEMON=

CMD="$1"

# docker-test mode requires V2 docker-compose as it uses `docker-compose run` and needs
# a different order to containers start (i.e. nginx needs to be started before
# hubot even though the actual dependency is the other direction). V2 creates
# a special network where all the containers see each other we we leverage that
# in docker-test.
validate_compose_1_6_plus() {
    local docker_compose_verson="$(docker-compose --version | cut -d' ' -f3)"
    if [[ !  "${docker_compose_verson}" =~ ^[1-9]\.[6-9] && ! "${docker_compose_verson}" =~ ^[1-9]\.1[0-9] ]]; then
        echo "This command requires docker-compose 1.6.0+"
        exit 1
    fi
}
validate_compose_1_6_plus

case "${CMD}" in
    start)
        start_status=$(docker-compose -f /home/manjit/docker-test/docker-compose.yml up -d)
        echo "start_status"
        status=$(docker-compose -f /home/manjit/docker-test/docker-compose.yml ps)
        echo "$status" 
        echo "Staring ...."
        ;;
    restart)
        restop_status=$(docker-compose -f /home/manjit/docker-test/docker-compose.yml down)
        echo "start_status"
        restart_status=$(docker-compose -f /home/manjit/docker-test/docker-compose.yml up -d)
        echo "$status" 
        echo "Staring ...."
        ;;
    scale)
        docker-compose -f /home/manjit/docker-test/docker-compose.yml scale nodeapp-service-build=$2 
        sudo docker exec -it nginx /bin/bash -c 'service nginx reload'     
        ;;        
    stop)
        docker-compose -f /home/manjit/docker-test/docker-compose.yml down 
        ;;
    rebuild)
        docker-compose -f /home/manjit/docker-test/docker-compose.yml build 
        ;;
    status)
        status=$(docker-compose -f /home/manjit/docker-test/docker-compose.yml ps)
        echo "$status" 
        ;;    
    logs)
        log_status=$(docker-compose -f /home/manjit/docker-test/docker-compose.yml logs)
        echo "$log_status" 
        ;;
    *)
        echo
        echo "Usage: $0 start|stop|status|rebuild|scale|rebuild|logs docker-test"
        echo
        exit 1
esac

exit 0