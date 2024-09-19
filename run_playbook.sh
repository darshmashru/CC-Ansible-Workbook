#!/bin/bash

# Load environment variables from .env file
source .env

# Run Ansible playbook
ansible-playbook -i inventory.ini install_nginx_podman.yaml --ask-become-pass -vvv