#!/bin/bash

### BEGIN INIT INFO
# Provides:          server
# Required-Start:    $network
# Required-Stop:     $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: NAT
# Description:       Active le NAT et le firewall
### END INIT INFO

# Vider les tables actuelles
iptables -t filter -F

# Vider les regles personnelles
iptables -t filter -X

# Interdire toute connexion
iptables -t filter -P INPUT DROP
iptables -t filter -P FORWARD ACCEPT
iptables -t filter -P OUTPUT ACCEPT

# Interdire IPs
#iptables -A INPUT -s -j DROP

# Ne pas casser les connexions etablies
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# INTERNET
iptables -I INPUT -d IP_INTERNET -p tcp --dport 80 -m string --to 700  --algo bm --string 'Host: IP_INTERNET' -j DROP
iptables -I INPUT -d IP_INTERNET -p tcp --dport 80 -m string --to 70 --algo bm --string 'GET /w00tw00t.at.ISC.SANS.' -j DROP
iptables -A INPUT -p tcp --dport 80 -m state --state NEW -m recent --name BLACKLIST --set
iptables -A INPUT -p tcp --dport 80 -m state --state NEW -m recent --name BLACKLIST --update --seconds 10 --hitcount 10 --rttl -j DROP

# LOOPBACK 
iptables -t filter -A INPUT -i lo -j ACCEPT
iptables -t filter -A OUTPUT -o lo -j ACCEPT

# ICMP
iptables -t filter -A INPUT -p icmp -j ACCEPT
iptables -t filter -A OUTPUT -p icmp -j ACCEPT

# SSH
iptables -t filter -A INPUT -p tcp --dport 555 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 555 -j ACCEPT

# DNS
iptables -t filter -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -t filter -A INPUT -p udp --dport 53 -j ACCEPT

# FTP
iptables -t filter -A INPUT -p tcp --dport 20:21 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 20:21 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 20000:20050 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 20000:20050 -j ACCEPT

# HTTP
iptables -t filter -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT

# HTTPS
iptables -t filter -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 443 -j ACCEPT

# SMTP
iptables -t filter -A INPUT -p tcp --dport 25 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 25 -j ACCEPT

# IMAPS
iptables -t filter -A INPUT -p tcp --dport 993 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 993 -j ACCEPT

# POP3
iptables -t filter -A INPUT -p tcp --dport 110 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 110 -j ACCEPT

# SPAMASSASSIN
iptables -t filter -A INPUT -p tcp --dport 783 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 783 -j ACCEPT

# NTP
iptables -t filter -A OUTPUT -p udp --dport 123 -j ACCEPT

# WEBMIN
#iptables -t filter -A INPUT -p tcp --dport 10000 -j ACCEPT
#iptables -t filter -A OUTPUT -p tcp --dport 10000 -j ACCEPT

# VPN
#iptables -t nat -A POSTROUTING -s RESEAU_PRIVE -o eth0 -j MASQUERADE
#iptables -t nat -A POSTROUTING -o venet0 -j SNAT --to-source IP_INTERNET 
#iptables -t filter -A OUTPUT -p udp --dport 1194 -j ACCEPT
#iptables -t filter -A INPUT -p udp --dport 1194 -j ACCEPT
####    Debut NAT       ####

# Active l'ip forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# NAT VM subnet to external ip
#iptables -t nat -A POSTROUTING -s RESEAU_LOCAL -o eth0 -j SNAT --to 88.190.22.217

# Allow all traffic for venet0 interface
#iptables -A INPUT -i venet0 -j ACCEPT

#iptables -t nat -I PREROUTING -p tcp -d IP_INTERNET --dport 80 -j DNAT --to IP_LOCAL:80
#iptables -I FORWARD -p tcp -d IP_LOCAL --dport 80
#iptables -t nat -I PREROUTING -p tcp -d IP_INTERNET --dport 443 -j DNAT --to IP_LOCAL:443
#iptables -I FORWARD -p tcp -d IP_LOCAL --dport 443
