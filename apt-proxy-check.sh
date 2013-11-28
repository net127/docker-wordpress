#!/bin/sh

PROXYIP=10.137.0.10

if eval "ping -c 1 $PROXYIP"
then
	echo "Acquire::http::Proxy \"http://$PROXYIP:3142\";" > /etc/apt/apt.conf.d/01proxy
        echo "Proxy host is available!"
else
    	echo "Proxy host is NOT available!"
fi
