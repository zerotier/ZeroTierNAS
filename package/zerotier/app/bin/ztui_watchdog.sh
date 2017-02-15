#!/bin/bash
CURRENT_PATH=$(pwd)

LOGFOLDER=$CURRENT_PATH"/logs/"
PIDFOLDER=$CURRENT_PATH"/pid/"

#PID file where the this script process ID is stored
WATCHDOGPIDFILE=$PIDFOLDER"watchdog-admin.pid"
#PID file where the node process ID is stored
NODEPIDFILE=$PIDFOLDER"node-admin.pid"
#Watchdog process error log file
WATCHDOGLOGFILE=$LOGFOLDER"admin-watchdog-error.log"
#Node process error log file
NODELOGFILE=$LOGFOLDER"admin-error.log"
#Command to be executed on daemon start
COMMAND="node /var/lib/zerotier-one/ztui_server.js 1> /dev/null 2>> $NODELOGFILE"

ARG_1=$1


zt_PORTFILE="zerotier-one.port"
zt_AUTHFILE="authtoken.secret"
ztserviceaddr="0.0.0.0"
ztport=$(cat $zt_PORTFILE)


start() {
    if [ -e $NODEPIDFILE ]; then
        PID=$(cat $NODEPIDFILE)
        if [ $(ps -o pid | grep $PID) ]; then
            return;
        else
            touch $NODEPIDFILE
            nohup $COMMAND &
            echo $! > $NODEPIDFILE
        fi
    else
        touch $NODEPIDFILE
        nohup $COMMAND &
        echo $! > $NODEPIDFILE
    fi
}

stop() {
    if [ -e $NODEPIDFILE ]; then
        PID=$(cat $NODEPIDFILE)
        if [ $(ps -o pid | grep $PID) ]; then
            kill -9 $PID
        fi
        rm $NODEPIDFILE
    fi
}

stopdaemon() {
    stop
    rm $WATCHDOGPIDFILE
    exit 0
}

log() {
    echo $1 >> $WATCHDOGLOGFILE
}

keep_alive() {
    if [ -e $NODEPIDFILE ]; then
        PID=$(cat $NODEPIDFILE)
        if [ $(ps -o pid | grep $PID) ]; then
            return;
        else
            log "Jim, he is dead!! Trying ressurection spell..."
            start
        fi
    else
        start
    fi
}

case x${ARG_1} in
    x-start )

        echo "Starting daemon watchdog"
        nohup "$0" -daemon &> /dev/null &

    ;;

    x-daemon )

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
            keep_alive
            # wait
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
                killall zerotier-one
                sleep 1
                /usr/sbin/zerotier-one -d
            fi

        # Re-Add routes
            device=""
            route=""

            for i in $(curl http://$ztserviceaddr:$ztport/network?auth=$(sudo cat $zt_AUTHFILE) | grep -E "portDeviceName|route" | grep -o -e '[0-9]\+[.][0-9]\+[.][0-9]\+[.][0-9]\+[\][/][0-9]\+' -e 'zt[0-9]\+' | sed 's/[\_-]//g') ; do
                    #log $i
                    if [[ $i =~ "zt" ]]
                    then
                        device=$i
                    else
                        #if [[ -n $route ]]
                        #then
                        #    log "two routes in a row?"
                        #fi
                        echo ""
                        route=$i
                    fi
                if [[ -n $device && -n $route ]]
                    then
                        echo ""
                        exec_str=$(ip route add dev $device $route)
                        #log $exec_str
                        device=""
                        route=""
               fi
            done
        done
    ;;

    x-stop )

        echo "Stopping daemon watchdog"
        PID=$(cat $WATCHDOGPIDFILE)
        kill $PID

    ;;

    x-status )
        #check if process is running and PID file exists, and report it back
    ;;
    x )
        echo "Usage {start|stop|status}"
esac

exit 0