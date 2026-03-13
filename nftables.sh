#!/usr/sbin/nft -f
# nftables — Syntaxe moderne (Linux 3.13+)

flush ruleset

table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;
        
        iif lo accept                                    # Loopback
        ct state established,related accept              # Connexions établies
        ct state invalid drop                            # Paquets invalides
        
        tcp dport 22 ip saddr 192.168.10.0/24 accept    # SSH admin seulement
        tcp dport { 80, 443 } accept                    # HTTP/HTTPS
        ip protocol icmp icmp type echo-request         \
            limit rate 5/second accept                   # ICMP limité
        
        log prefix "nft-drop: " drop                    # Log + DROP
    }
    chain forward { type filter hook forward priority 0; policy drop; }
    chain output  { type filter hook output  priority 0; policy accept; }
}
