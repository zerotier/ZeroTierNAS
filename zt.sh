#! /bin/sh

case "$1" in
  start)
    if ( pidof zerotier-one )
    then echo "ZeroTier-One is already running."
    else
        echo "Starting ZeroTier-One" ;
        /usr/sbin/zerotier-one -d ;
        echo "$(date) Started ZeroTier-One" >> /opt/var/log/zerotier-one.log ;
    fi
    ;;
  stop)
    if ( pidof zerotier-one )
    then
        echo "Stopping ZeroTier-One";
        killall zerotier-one
        echo "$(date) Stopped ZeroTier-One" >> /opt/var/log/zerotier-one.log
    else
        echo "ZeroTier-One was not running" ;
    fi
    ;;
  status)
    if ( pidof zerotier-one )
    then echo "ZeroTier-One is running."
    else echo "ZeroTier-One is NOT running"
    fi
    ;;
  *)
    echo "Usage: /etc/init.d/zerotier-one {start|stop|status}"
    exit 1
    ;;
esac

exit 0
