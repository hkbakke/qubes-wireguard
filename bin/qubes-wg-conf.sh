#!/usr/bin/env bash
#
# This script can safely be ran multiple times.
#
set -e -u

. ./config

exit 1

# /etc/wireguard is symlinked to this location in the template
[[ -d /rw/config/wireguard ]] || mkdir -m 700 /rw/config/wireguard

cat << EOF > /rw/config/wireguard/wg0.conf
[Interface]
Address = $WG_ADDRESS
DNS = $WG_DNS
PrivateKey = $WG_PRIVATE_KEY
PostUp = nft "add chain wg-quick-%i forward { type filter hook forward priority filter - 1; policy accept; }"
PostUp = nft "add rule wg-quick-%i forward oifname %i tcp flags syn tcp option maxseg size set rt mtu"
PostUp = /usr/lib/qubes/qubes-setup-dnat-to-ns
PostDown = /usr/lib/qubes/qubes-setup-dnat-to-ns

[Peer]
PublicKey = $WG_PEER_PUBLIC_KEY
AllowedIPs = 0.0.0.0/0
Endpoint = $WG_ENDPOINT
EOF

# Protect the key in the config file
chmod 600 /rw/config/wireguard/wg0.conf

# Start the wireguard connection at boot
cat << EOF > /rw/config/rc.local
#!/bin/sh

systemctl start wg-quick@wg0
EOF

# Ensure only traffic destined for the wireguard interface is forwarded
cat << EOF > /rw/config/qubes-firewall-user-script
#!/bin/sh

iptables -F QBS-FORWARD
iptables -A QBS-FORWARD -i vif+ -o wg+ -j ACCEPT
iptables -A QBS-FORWARD -j DROP
EOF
