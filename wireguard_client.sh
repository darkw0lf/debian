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
