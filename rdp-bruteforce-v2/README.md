# RDP Brute Force Detection (v2)

## Objective
Simulate an RDP brute force attack against a Windows target and validate that the SOC lab's detection stack (Sysmon + Wazuh) correctly identifies and alerts on the activity, mapped to the MITRE ATT&CK framework.

## Lab Setup
| Component | Details |
|---|---|
| Attacker | Kali Linux — `xfreerdp3` |
| Target | Windows 10 VM (`demoWIN`) |
| SIEM | Wazuh (deployed on Ubuntu Server) |
| Network | Isolated NAT network (`soclab`) |

## Attack Simulation
Repeated failed RDP login attempts were launched from the Kali VM against `demoWIN` using `xfreerdp3`, simulating a credential brute force attack against a Windows Remote Desktop service.

```bash
xfreerdp3 /v:<target-ip> /u:<username> /p:<wrong-password>
```
*(Repeated with varying credentials to simulate multiple failed authentication attempts.)*

## Detection
- Wazuh generated alerts under **Rule 60122**, correctly flagging the repeated failed authentication events.
- Alerts were correlated against Windows Security event logs forwarded via the Wazuh agent.

## MITRE ATT&CK Mapping
| Technique | ID | Rationale |
|---|---|---|
| Valid Accounts | T1078 | Attacker attempting to gain access using account credentials via brute force |
| Account Access Removal | T1531 | Related to the account lockout behavior triggered during the simulation |

## Bonus Finding: Account Lockout Policy
During testing, Windows' native **Account Lockout Policy** locked the target account after a threshold of failed login attempts was reached. This was not a Wazuh detection — it was Windows' own preventive control kicking in.

**Takeaway:** This highlighted how detective controls (Wazuh alerting) and preventive controls (Windows account lockout) work together as layered defenses — one flags the activity, the other actively stops it.

## Screenshots
*(See `/screenshots` folder for Wazuh alert dashboard, Rule 60122 detail view, and Windows lockout confirmation.)*

## Notes
- A timestamp mismatch between attack logs and Wazuh dashboard alerts (an issue encountered in the original SOC-Home-Lab build) was resolved in this v2 iteration — attack and alert timestamps now align correctly.

---
*Part of [HOME_SOC_LAB-V2](../) — SOC Analyst / Blue Team learning journey.*
