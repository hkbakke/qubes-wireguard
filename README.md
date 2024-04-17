# Description
After setup you will have the following:

* A reusable wireguard template
* A wireguard VPN managed by network manager that starts automatically at boot
* A network GUI indicator
* Properly configured firewall that only forwards app VM traffic connected to the VPN qube network to the VPN. If the VPN is down, the app VM traffic to WAN is dropped.
    * App VMs connected to the VPN qube network are protected
    * The VPN qube's own output traffic is not protected if the VPN is down (intentional)
* TCP MSS clamping to avoid MTU issues when used as a network provider

# Compatibility

| Version | Qubes OS | Template | Comment |
|:-:|:-:|---|---|
| 1 | 4.1 | Fedora 38 |  |
| 2 | 4.2 | Fedora 38 | No SELinux support |
| >=3 | >=4.2 | Fedora >=38 | Network Manager based with SELinux support |


# Reusable wireguard template
First create a template based on the fedora 38 template. Name the template
`fedora-38-wireguard` or some other useful name. Ensure the template has
internet access unless you have some other way to get the repository code to
the template (e.g. download via another AppVM).

    mkdir -p ~/src
    cd ~/src
    git clone https://github.com/hkbakke/qubes-wireguard.git
    cd qubes-wireguard

Then run the template configuration script.

    sudo ./bin/wg-template-conf

Stop the template VM before continuing.

# AppVM VPN Qube
* Create a new qube based on the wireguard template
* Add `network-manager` to Services
* Ensure `Provides network` is enabled
* You may want to enable `Start qube automatically on boot`

## Configuration
* Create a wireguard config file named `wg0.conf` and change permissions to protect it. See `wg0.conf.example` for syntax.

        chmod 600 wg0.conf

* Add the configuration file to network-manager

        nmcli con import type wireguard file wg0.conf

* You should now see a new network indicator icon in Qubes where you can toggle the wireguard tunnel
