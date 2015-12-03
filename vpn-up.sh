#!/bin/sh
#sleep 10s

sh /jffs/vpn-down.sh

for i in $(ls /proc/sys/net/ipv4/conf); do echo 0 > /proc/sys/net/ipv4/conf/$i/rp_filter; done

ip rule add fwmark 1 table 200

VPN_GW=`ifconfig tun11 | awk '/inet addr/ {split ($3,A,":"); print A[2]}'`

ip route del 0.0.0.0/1 via $VPN_GW dev tun11
ip route del 128.0.0.0/1 via $VPN_GW dev tun11

ip route add table 200 default via $VPN_GW dev tun11

iptables -t mangle -I PREROUTING -i br0 -p tcp -m multiport --dport 80,443 -j MARK --set-mark 1
iptables -t mangle -I PREROUTING -i br0 -p tcp -s 10.10.92.7 -j MARK --set-mark 1
iptables -t mangle -I PREROUTING -i br0 -p tcp -s 10.10.92.214 -j ACCEPT
