#!/bin/sh
HUBOT_ROOT="/opt/hubot"
HUBOT_HOME="$HUBOT_ROOT/node_modules/hubot"
DAEMON="$HUBOT_HOME/bin/hubot"
PIDFILE=$HUBOT_ROOT/hubot.pid
LOGFILE="$HUBOT_ROOT/hubot.log"

case "$1" in
start)
        echo "Starting"
        . $HUBOT_ROOT/.hubotrc
        /sbin/start-stop-daemon --start --background --pidfile $PIDFILE --make-pidfile -d $HUBOT_ROOT --startas /bin/bash -- -c "exec $DAEMON >> $LOGFILE 2>&1"
        echo "."
        ;;
debug)
        echo "Debug mode: no backgrounding"
        . $HUBOT_ROOT/.hubotrc
        /sbin/start-stop-daemon --start --pidfile $PIDFILE --make-pidfile -d $HUBOT_ROOT --exec $DAEMON >> $LOGFILE 2>&1
        echo "."
        ;;        
stop)
        echo "Stopping"
        /sbin/start-stop-daemon --stop --pidfile $PIDFILE
        rm -f $PIDFILE
        echo "."
        ;;  
restart)
        echo "Restarting"
        /sbin/start-stop-daemon --stop --pidfile $PIDFILE
        rm -f $PIDFILE
        . $HUBOT_ROOT/.hubotrc
        /sbin/start-stop-daemon --start --background --pidfile $PIDFILE --make-pidfile -d $HUBOT_ROOT --startas /bin/bash -- -c "exec $DAEMON >> $LOGFILE 2>&1"
        echo "."
        ;;


    *)
        echo "Usage: $0 {start|stop|restart|debug}" >&2
        exit 1
        ;;  
    esac
    exit
