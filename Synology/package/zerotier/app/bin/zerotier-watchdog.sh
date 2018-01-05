#!/bin/bash

CURRENT_PATH=$(pwd)
PIDFOLDER="/var/lib/zerotier-one"
WATCHDOGPIDFILE=$PIDFOLDER"/watchdog.pid"
LOG_FILE="/var/log/zerotier-one.log"
ZEROTIER="/usr/local/zerotier/bin/zerotier-one"

ZT_HOME_DIR="/var/lib/zerotier-one"
PID_FILE="${ZT_HOME_DIR}/zerotier-one.pid"

start() {
    echo "starting"
}

stop() {
    echo "stopping"
}

stopdaemon() {
    stop
    rm $WATCHDOGPIDFILE
    exit 0
}

log() {
    echo "$(date)" $1 >> ${LOG_FILE}
}

keep_alive() {
    if [ -e $NODEPIDFILE ]; then
        PID=$(cat $NODEPIDFILE)
        if [ $(ps -o pid | grep $PID) ]; then
            return;
        else
            log "Dead. Trying to restart"
            start
        fi
    else
        start
    fi
}

daemon_status ()
{
    PID=$(cat ${PID_FILE})
    if [ -f ${PID_FILE} ] && ps -p ${PID} > /dev/null ; then 
        return 0
    else
        rm -f ${PID_FILE}
        return 1
    fi
}

case "$1" in
    start )
        log "Starting daemon watchdog (to protect /dev/net/tun)"
        nohup "$0" daemon &> /dev/null &

    ;;

    daemon )
        if [ -e $WATCHDOGPIDFILE ]; then
            PID=$(cat $WATCHDOGPIDFILE)
            if [ $(ps -o pid | grep $PID) ]; then
                exit 0;
            fi
        fi

        touch $WATCHDOGPIDFILE

        echo $$ > $WATCHDOGPIDFILE

        #trap the interruption or kill signal
        trap stopdaemon INT SIGINT TERM SIGTERM

        start

        while true; do
            
            if daemon_status; then
                :
            else
                ${ZEROTIER} -d ;
            fi

            sleep 1

            # Check that tun module is loaded
            SERVICE="zerotier"
            ZEROTIER_MODULE="tun.ko"
            BIN_SYNOMODULETOOL="/usr/syno/bin/synomoduletool"

            # Make device if not present (not devfs)
            if ( [ ! -c /dev/net/tun ] ) then
                 # Make /dev/net directory if needed
                if ( [ ! -d /dev/net ] ) then
                    mkdir -m 755 /dev/net
                fi
                mknod /dev/net/tun c 10 200
                # Load TUN kernel module
                if [ -x ${BIN_SYNOMODULETOOL} ]; then
                        $BIN_SYNOMODULETOOL --insmod $SERVICE ${ZEROTIER_MODULE}
                else
                        /sbin/insmod /lib/modules/${ZEROTIER_MODULE}
                fi

                # also restart zerotier
                pkill -f zerotier-one
                sleep 1
                ${ZEROTIER} -d
            fi
        done
    ;;

    stop )

        log "Stopping daemon watchdog"
        PID=$(cat $WATCHDOGPIDFILE)
        kill $PID

    ;;

    status )
        #check if process is running and PID file exists, and report it back
    ;;
    * )
        echo "Usage {start|stop|status}"
esac

exit 0