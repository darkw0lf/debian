#!/bin/bash
# Politique par défaut : tout refuser
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Loopback autorisé
iptables -A INPUT -i lo -j ACCEPT

# Connexions établies et relatives (réponses)
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# SSH depuis réseau d'administration uniquement (192.168.10.0/24)
iptables -A INPUT -s 192.168.10.0/24 -p tcp --dport 22 -m state --state NEW -j ACCEPT

# HTTPS depuis n'importe quelle source
iptables -A INPUT -p tcp --dport 443 -m state --state NEW -j ACCEPT

# HTTP → HTTPS redirection
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# ICMP ping (limité par taux pour anti-flood)
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT

# Logging des paquets refusés (avant DROP final)
iptables -A INPUT -j LOG --log-prefix "[IPTABLES-DROP] " --log-level 4
iptables -A INPUT -j DROP
