#!/bin/sh
### BEGIN INIT INFO
# Provides:          ibeacon
# Required-Start:    $bluetooth
# Required-Stop:     
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# X-Interactive:     true
# Short-Description: Start/stop Bluetooth iBeacon
### END INIT INFO

# Init script for starting an iBeacon
#
# Thanks to http://developer.radiusnetworks.com/2013/10/09/how-to-make-an-ibeacon-out-of-a-raspberry-pi.html
#
# Author Gabriel Birke <gb@birke-software.de>

BLUETOOTH_DEVICE=hci0
UUID="62 0E 34 5D 69 62 43 8F 99 45 59 DD B4 83 0C 18"
MAJOR="00 00"
MINOR="00 00"
POWER="c9"

HCITOOL=/usr/local/bin/hcitool
HCICONFIG=/usr/local/bin/hciconfig

LOG=/dev/null


start() {
	$HCICONFIG $BLUETOOTH_DEVICE up
	$HCICONFIG $BLUETOOTH_DEVICE noleadv
	$HCITOOL -i hci0 cmd 0x08 0x0008 1e 02 01 1a 1a ff 4c 00 02 15 $UUID $MAJOR $MINOR $POWER 00 > $LOG
	$HCICONFIG $BLUETOOTH_DEVICE leadv 3
}

stop() {
	$HCICONFIG $BLUETOOTH_DEVICE noleadv
	$HCICONFIG $BLUETOOTH_DEVICE down
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    stop
    start
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
esac
