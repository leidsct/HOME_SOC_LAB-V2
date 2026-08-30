# HOME_SOC_LAB-V2

**Status:** 🟢 In Progress — actively being built and documented

Second iteration of my home SOC lab build, following up on [SOC-Home-Lab](https://github.com/leidsct/SOC-Home-Lab). This version expands on the original setup with improved detection coverage and additional attack simulation scenarios.

## Simulations

| Simulation | Status | Description |
|---|---|---|
| [RDP Brute Force Detection v2](./rdp-bruteforce-v2/) | ✅ Documented | Simulated RDP brute force attack from Kali against a Windows target, detected via Wazuh, mapped to MITRE ATT&CK |

## What's Planned

- 🖥️ Updated Wazuh SIEM configuration
- 🔍 Expanded Sysmon logging and detection rules
- 🎯 New attack simulations mapped to MITRE ATT&CK
- 📊 Improved dashboards and alerting workflow

## Lab Environment

- **Attacker:** Kali Linux (xfreerdp3)
- **Target:** Windows 10 VM (demoWIN)
- **SIEM:** Wazuh, deployed on Ubuntu Server
- **Network:** Isolated NAT network ("soclab")

More simulations and writeups will be added as they're completed. Follow [@leidsct](https://github.com/leidsct) for progress.

---

*Part of my SOC Analyst / Blue Team learning journey.*
