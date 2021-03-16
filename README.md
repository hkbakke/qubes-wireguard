# Description
Wireguard configuration script for Fedora 33 template in Qubes OS. After setup
you will have the following:

* A reusable wireguard template
* A wireguard VPN managed by wg-quick that starts automatically at boot
* Properly configured firewall that only forwards traffic to the VPN
* TCP MSS clamping to avoid MTU issues when used as a network provider
* Wireguard DNS handled via Qubes' DNS DNAT rules

# Reusable wireguard template
First clone the fedora 33 template to e.g. `fedora-33-wireguard`. Then install
the wireguard tools in this template. I also like to include a couple of extra
tools for easier trobuleshooting.

    sudo dnf install -y wireguard-tools tcpdump bind-utils bash-completion
    sudo rm -r /etc/wireguard
    sudo ln -s /rw/config/wireguard /etc/wireguard

Then stop the template VM.

After the template is shut down, you have to change the kernel from the default
dom0 kernel to the one in the VM as the wireguard modules is only included in
kernel 5.8 and newer.

* Open the wireguard template settings -> Advanced
* Change `Kernel` to `(none)`
* Change `Virtualization` to `HVM`

This template is now ready to be used.

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

        ./bin/qubes-wg-conf
