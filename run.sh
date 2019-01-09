#!/usr/bin/env bash
set -e
/usr/sbin/sshd -D &
/usr/local/tomcat/bin/catalina.sh run
