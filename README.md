# Description
Wireguard configuration script for Fedora 33 template in Qubes OS running at
least kernel 5.4 in dom0. After setup you will have the following:

* A reusable wireguard template
* A wireguard VPN managed by wg-quick that starts automatically at boot
* Properly configured firewall that only forwards traffic to the VPN
* TCP MSS clamping to avoid MTU issues when used as a network provider
* Wireguard DNS handled via Qubes' DNS DNAT rules

# Reusable wireguard template
First clone the fedora 33 template to e.g. `fedora-33-wireguard`. Then install
the wireguard tools in this template. I also like to include a couple of extra
tools for easier troubleshooting.

    sudo dnf install -y wireguard-tools tcpdump bind-utils bash-completion
    sudo mkdir /rw/config/wireguard
    sudo ln -s /rw/config/wireguard/wg0.conf /etc/wireguard/wg0.conf

Then stop the template VM.

# VPN Qube
* Create a new qube based on the wireguard template
* Ensure `Provides network` is enabled
* You probably also want to enable `Start qube automatically on boot`

## Configuration
* Clone this repo
* Copy `config.example` to `config`

        cp config.example config

* Edit the configuration file
* Run the configuration script

        sudo ./bin/qubes-wg-conf
