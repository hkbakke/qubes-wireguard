#!/usr/bin/env sh

nft -f - << EOF
flush chain ip qubes custom-forward
flush chain ip6 qubes custom-forward
table ip qubes {
    chain custom-forward {
        ct state related,established counter accept
        oifname "wg*" tcp flags syn tcp option maxseg size set rt mtu counter
        iifname "vif*" oifname "wg*" counter accept
        counter reject
    }
}
table ip6 qubes {
    chain custom-forward {
        ct state related,established counter accept
        oifname "wg*" tcp flags syn tcp option maxseg size set rt mtu counter
        iifname "vif*" oifname "wg*" counter accept
        counter reject
    }
}
EOF
