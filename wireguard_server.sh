# /etc/wireguard/wg0.conf (SERVEUR — 10.8.0.1)
[Interface]
Address = 10.8.0.1/24
ListenPort = 51820
PrivateKey = <CLEF_PRIVEE_SERVEUR>
# Activer le forwarding IP et le NAT pour les clients
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

[Peer]
PublicKey  = <CLEF_PUBLIQUE_CLIENT>
AllowedIPs = 10.8.0.2/32     # Seul cet IP est autorisé pour ce peer
