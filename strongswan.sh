# /etc/ipsec.conf (SITE A)
config setup
    charondebug="ike 1, knl 1, cfg 0"

conn %default
    ikelifetime=60m
    keylife=20m
    keyingtries=%forever

conn site-a-to-b
    left=%defaultroute
    leftid=@site-a.entreprise.com
    leftcert=site-a-cert.pem          # Certificat X.509 site A
    leftsubnet=192.168.1.0/24         # Réseau local site A
    right=203.0.113.2                  # IP publique passerelle site B
    rightid=@site-b.entreprise.com
    rightcert=site-b-cert.pem         # Certificat attendu de site B
    rightsubnet=192.168.2.0/24        # Réseau local site B
    ike=aes256gcm16-sha384-ecp384!    # Suite IKEv2 (! = strict)
    esp=aes256gcm16-sha384-ecp384!    # Suite ESP avec PFS groupe 20
    keyexchange=ikev2
    dpdaction=restart
    auto=start

# Vérifier l'état : ipsec statusall | grep "site-a-to-b"
# Diagnostiquer  : ipsec stroke loglevel ike 3
