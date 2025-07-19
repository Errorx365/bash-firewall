#!/bin/bash

#===============================
# Bash Firewall Script (VAPT)
# Author: Your Name
#===============================

echo "[+] Flushing existing iptables rules..."
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X

echo "[+] Setting default policies..."
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

echo "[+] Allowing localhost (loopback)..."
iptables -A INPUT -i lo -j ACCEPT

echo "[+] Allowing established connections..."
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

echo "[+] Allowing SSH (port 22)..."
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

echo "[+] Allowing HTTP/HTTPS..."
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

echo "[+] Logging dropped packets (rate-limited)..."
iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "Firewall DROP: " --log-level 7

echo "[+] Firewall rules applied successfully."
