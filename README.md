# Ansible

This repository contains a few things in Ansible:  

- [Libvirt Dinamic inventory](libvirt).

    - `ansible-playbook -i inventory-manage-vms.yml list-vms.yml`
    - `ansible-playbook -i inventory execute-ls-cmd-on-guest.yml`

- [Manage private wireless infrastructure](openwrt).

    I use this [Ansible role](https://github.com/gekmihesg/ansible-openwrt) as a base
    to manage my OpenWrt wireless infra.

- [Do Puppet runs](puppet).

    This role will execute `puppet agent -t` in a non-interactive way
    and will determine if subsequent Puppet runs are required.
