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

==========
# /etc/wireguard/wg0.conf (CLIENT — 10.8.0.2)
[Interface]
Address    = 10.8.0.2/24
PrivateKey = <CLEF_PRIVEE_CLIENT>
DNS        = 10.8.0.1          # DNS via VPN (prévention DNS Leak)

[Peer]
PublicKey           = <CLEF_PUBLIQUE_SERVEUR>
Endpoint            = vpn.entreprise.com:51820
AllowedIPs          = 0.0.0.0/0    # Full Tunnel — tout le trafic
PersistentKeepalive = 25            # Maintenir connexion derrière NAT
