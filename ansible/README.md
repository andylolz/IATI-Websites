# Ansible test

Based on guide at http://ryaneschinger.com/blog/ansible-quick-start/


## Set-up

Ansible uses an inventory file to determine what hosts to work against. This file is stored by default at '/etc/ansible/hosts', although a bespoke path can be set using an option `–inventory=/path/to/inventory/file`.


## Sample commands

```
# Ping a server
ansible all --inventory-file=inventory.ini --module-name ping -u root
ansible all -i inventory.ini --m ping -u root

# Remotely execute code 
ansible all -i inventory.ini -m command -u root --args "uptime"
ansible all -i inventory.ini -m command -u root -a "uptime"
```
