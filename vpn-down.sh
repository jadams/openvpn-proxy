#!/bin/sh
ip rule del fwmark 1 table 200
ip route flush table 200
iptables -t mangle -F PREROUTING
