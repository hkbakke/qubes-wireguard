# Description
Wireguard configuration script for Fedora 38 template in Qubes OS

After setup you will have the following:

* A reusable wireguard template
* A wireguard VPN managed by wg-quick that starts automatically at boot
* Properly configured firewall that only forwards app VM traffic connected to the VPN qube network to the VPN. If the VPN is down, the app VM traffic to WAN is dropped.
    * Only the app VMs connected to the VPN qube network are protected
    * The VPN qube's own output traffic is not protected if the VPN is down. So _don't_ use the VPN qube for applications. This is by design as it has to speak directly to the WAN to establish the tunnel. By using a dedicated VPN qube and the Qubes OS network design properly we can work around this for our client apps without having complicated and hard to verify rulesets in place to contain locally generated traffic, and the more challenging DNS requests, as one would need to have if the VPN client runs on the same host as the application that needs protection. Also I don't personally like the concept of the VPN client host to be responsible (and hence trusted) for its own protection to avoid leaks, so I would avoid it and use the dedicated VPN gateway approach in all cases if possible. In qubes we have the luxury option to put another network gateway in front of the VPN gateway that may enforce the leak-protection policy externally without implicitly trusting the VPN client host if you for some reason want to use the VPN qube for sensitive applications.
* TCP MSS clamping to avoid MTU issues when used as a network provider
* Wireguard DNS handled via Qubes' DNS DNAT rules

# Reusable wireguard template
First clone the fedora 38 template to e.g. `fedora-38-wireguard`. Then run the
template configuration script.

    sudo ./bin/wg-template-conf

Stop the template VM before continuing.

# VPN Qube
* Create a new qube based on the wireguard template
* Ensure `Provides network` is enabled
* You probably also want to enable `Start qube automatically on boot`

## Configuration
* Clone this repo
* Copy `config.example` to `config` and change permissions to protect it

        cp config.example config
        chmod 600 config

* Edit the configuration file
* Run the configuration script

        sudo ./bin/wg-appvm-conf

* Reboot the VPN qube to activate the changes
