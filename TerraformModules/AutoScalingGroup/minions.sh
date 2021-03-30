#!/bin/bash
sudo apt-get update
sudo apt-get upgrade -y
sudo cat << StringName >> .ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCjm+q8+H8vVG3bHUI/yXmW50k3Na5eN9I7wJdrTM9H0e3Tnrft+Xg6bH4buzmCRo082FIy77BZQUK5IOuWDSD9wjPYFYzbLj+ibSFcZLT6ATov3EY65RPMLaY8O6TnD2alosncL1camioEfUJB+IBzzVwELojd66UzT0VT30Z0XaFmiXM7OWkau1wW9Ab6IUAIs9tm0cRoBlAKtP23IhQ7ovL9WEe7CWYLt6rUsUbL0DVGCmSR9Xgmo3WagqE/PdP8upjkvoGJnAk3EiBPBM/KyX8oTDjyTXL5t0C10SYvewoIkIzshdqWoIc2vjNEkc/L3joAvervxGqRlA2s2vFR juand@DESKTOP-O461ERP
StringName
curl -L https://bootstrap.saltstack.com -o install-salt.sh
sudo sh install-salt.sh -P -A 10.0.4.40 git v3000.3
sudo salt-call --local key.finger

