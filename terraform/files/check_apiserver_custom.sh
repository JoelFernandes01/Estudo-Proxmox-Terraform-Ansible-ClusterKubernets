#!/bin/sh
errorExit() {
    echo "*** $*" 1>&2
    exit 1
}
curl --silent --max-time 2 --insecure https://k8s-master1.connect.local:6443/ -o /dev/null || errorExit "Error GET https://k8s-master1.connect.local:6443/"
if ip addr | grep -q lb.connect.local; then
    curl --silent --max-time 2 --insecure https://lb.connect.local: 6443/ -o /dev/null || errorExit "Error GET https://lb.connect.local:6443/"
fi
