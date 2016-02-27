#!/bin/sh
# this is the dash shell

mkdir -p /tmp/rsyslogd

envsubst < /etc/rsyslogd.conf.template > /tmp/rsyslogd/rsyslogd.conf

exec rsyslogd  -4 -n -f /tmp/rsyslogd/rsyslogd.conf -i /tmp/test.pid
