# Vidconf Setup

This repository hosts an Ansible script designed to configure an Ubuntu-like
Linux distro (e.g. I've tested this on Linux 4 Tegra) such that it hosts
an instance of Apache Guacamole, enabling full remote desktop access via
VNC (or RDP).

The ultimate goal of this configuration is to allow for a nice living room
video conferencing/chatting setup where a small device like a Jetson Nano or
a Raspberry Pi 4 is connected to your living room TV, a microphone, and a
webcam.  The use case is that when a user wants to join a video chat, they
remote desktop in to the video conference device, open a browser, and enter
the video conference URL.  Then you can turn off the remote desktop and sit
back in your couch and chat.

## Install

To execute the script, first make sure that Ansible is installed on the host
machine:

```bash
sudo apt install ansible
```

The client does not need any setup besides ensuring that it has a SSH server
running and reachable.

Once it is installed, add your device to the list of Ansible hosts by opening
the file `/etc/ansible/hosts` (with sudo) and adding to the end of it:

```
[vidconf_device]
<IP_OF_YOUR_DEVICE> ansible_user=<USER_TO_RUN_AS>
```

You must supply the device IP (`<IP_OF_YOUR_DEVICE>`) and the user that you wish
to run the setup scripts as (`<USER_TO_RUN_AS>`).

```bash
ansible-playbook -K ansible_setup.yaml -e guac_login_password=<PASSWORD>
```

where `<PASSWORD>` is the password that will be presented to users when they
access the website.

Note that NGINX will be installed as a reverse proxy to the Apache Tomcat based
Guacamole web app.  It is configured to run through TLS using a self-signed
certificate.  The assumption here is that the device will only ever be
running in an internal network.

You can reboot the device as you wish, all required services will be restarted
on bootup.

## Accessing the remote desktop

Once the script has executed successfully, you should be able to remote desktop
in to your device by navigating any browser to `https://<IP_OF_YOUR_DEVICE>`.
Note again that as mentioned above, the certificate is self-signed, and so
you will need to bypass a security warning in your browser on your first
visit.

When the page loads, you will be presented with a login screen.  For user you
can enter either `vnc` or `rdp`, to access either the VNC server that is running
(which is [x11vnc](http://www.karlrunge.com/x11vnc/)), or the RDP server that
is running (which is [xrdp](http://xrdp.org/)).

The password will be the `<PASSWORD>` value you supplied above on the
command line invokation of `ansible-playbook`.

The credentials are defined by the file [user-mapping.xml](user-mapping.xml).