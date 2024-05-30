#!/bin/bash

# Vider les tables actuelles
iptables -t filter -F

# Vider les regles personnelles
iptables -t filter -X

# Interdire toute connexion
iptables -t filter -P INPUT DROP
iptables -t filter -P FORWARD ACCEPT
iptables -t filter -P OUTPUT ACCEPT

# Interdire IPs
#iptables -A INPUT -s 198.27.83.122 -j REJECT

# Ne pas casser les connexions etablies
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# INTERNET
#iptables -I INPUT -p tcp --dport 80 -m string --to 700 --algo bm --string 'Host: 51.158.152.141' -j DROP
#iptables -I INPUT -p tcp --dport 80 -m string --to 700 --algo bm --string 'Host: 195.154.50.159' -j DROP

# ROBOTS
#iptables -I INPUT -d 51.158.152.141 -p tcp --dport 80 -m string --to 70 --algo bm --string 'GET /w00tw00t.at.ISC.SANS.' -j DROP
#iptables -I INPUT -d 195.154.50.159 -p tcp --dport 80 -m string --to 70 --algo bm --string 'GET /w00tw00t.at.ISC.SANS.' -j DROP

# DDOS
#iptables -A INPUT -p tcp -m state --state NEW -m recent --name BLACKLIST --set
#iptables -A INPUT -p tcp -m state --state NEW -m recent --name BLACKLIST --update --seconds 10 --hitcount 10 --rttl -j DROP

# LOOPBACK 
iptables -t filter -A INPUT -i lo -j ACCEPT
iptables -t filter -A OUTPUT -o lo -j ACCEPT

# ICMP
#iptables -t filter -A INPUT -p icmp -d 51.158.152.141 -j DROP
#iptables -t filter -A INPUT -p icmp -d 195.154.50.159 -j DROP
iptables -t filter -A INPUT -p icmp -j ACCEPT
iptables -t filter -A OUTPUT -p icmp -j ACCEPT

# SSH
iptables -t filter -A INPUT -p tcp -d 51.158.152.141 --dport 555 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp -d 51.158.152.141 --dport 555 -j ACCEPT

# DNS
iptables -t filter -A OUTPUT -p tcp -d 51.158.152.141 --dport 53 -j ACCEPT
iptables -t filter -A OUTPUT -p udp -d 51.158.152.141 --dport 53 -j ACCEPT

# HTTP
iptables -t filter -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT

# HTTPS
iptables -t filter -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 443 -j ACCEPT

# SMTP
iptables -t filter -A INPUT -p tcp -d 51.158.152.141 --dport 25 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp -d 51.158.152.141 --dport 25 -j ACCEPT

# IMAP
iptables -t filter -A INPUT -p tcp -d 51.158.152.141 --dport 143 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp -d 51.158.152.141 --dport 143 -j ACCEPT

# WAZUH
iptables -t filter -A INPUT -p tcp -d 51.158.152.141 --dport 55000 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp -d 51.158.152.141 --dport 55000 -j ACCEPT
