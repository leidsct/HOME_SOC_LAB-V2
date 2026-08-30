# RDP Brute Force Attack Detection – V2

## Overview
This is a follow-up brute force exercise (V2) building on the original RDP brute force test. This version uses a larger wordlist (100 attempts instead of 20) to observe account lockout behavior and Wazuh alert scaling under a heavier attack volume.

## Lab Environment
| Host | Role | IP |
|---|---|---|
| Ubuntu Server | Wazuh Manager / Dashboard | 10.0.2.4 |
| demoWIN (Windows 10) | Attack target | 10.0.2.3 |
| Kali Linux | Attacker | 10.0.2.15 |

This test was run in one continuous session to keep all timestamps consistent.

## Step 1 — Baseline (before attack)
Dashboard checked before running any attack to record a clean starting point:
- **Total alerts:** 106
- **Authentication failure:** 2
- **Authentication success:** 27

![Wazuh baseline dashboard](screenshots/01-wazuh-baseline.png)

## Step 2 — Launch the attack
From Kali, ran repeated RDP logon attempts against `demoWIN` using a larger wordlist (100 attempts):

```bash
for pass in $(head -100 /usr/share/wordlists/rockyou.txt); do
  xfreerdp3 /v:10.0.2.3 /u:Administrator /p:"$pass" /cert:ignore +auth-only 2>&1 | grep -i "authentication\|error"
done
```

The terminal showed repeated `ERRCONNECT_ACCOUNT_LOCKED_OUT` and NLA authentication failures as attempts progressed, confirming the target account locked out partway through the run.

## Step 3 — Detection in Wazuh
After the attack, the dashboard was refreshed:
- **Authentication failure:** 14 (up from 2)
- **Total alerts:** 155 (up from 106)

![Wazuh dashboard after attack](screenshots/02-wazuh-detection-dashboard.png)

## Step 4 — Alert list (Events tab)
Switched to the Events tab to see the full list of alerts generated during the attack window (167 hits), including:

| Rule ID | Level | Description | MITRE Technique |
|---|---|---|---|
| 60122 | 5 | Logon failure – Unknown user or bad password | T1078 |
| 60204 | 10 | Multiple Windows logon failures | T1110 (Brute Force) |
| 60115 | 9 | User account locked out (multiple login errors) | T1110 / T1531 |

![Events tab alert list](screenshots/03-events-tab-alert-list.png)

## Step 5 — Verifying the source (Rule 60204 expanded)
Expanded the Rule 60204 event (Windows Security Event ID 4625) to confirm it genuinely originated from the attack:
- **Source Network Address:** `10.0.2.15` (Kali) — confirms the attack source
- **Workstation Name:** `kali`
- **Account For Which Logon Failed:** `Administrator`
- **Failure Reason:** Unknown user name or bad password
- **rule.frequency:** 8 (alert fired after 8 failed logons within the correlation window — threshold-based detection, not a single event)

![Event expanded - table view](screenshots/04-event-expanded-table.png)
![Event expanded - source IP verified](screenshots/05-event-source-ip-verified.png)

## Step 6 — MITRE and compliance mapping
The rule detail also includes MITRE ATT&CK and compliance framework mappings:
- **MITRE:** T1110, Tactic: Credential Access, Technique: Brute Force
- **Compliance mappings:** GDPR IV_32.2 / IV_35.7.d, HIPAA 164.312.b, NIST 800-53 AC.7 / AU.14 / SI.4, PCI DSS 10.2.4 / 10.2.5 / 11.4, TSC CC6.1 / CC6.8 / CC7.2 / CC7.3

![Event compliance mapping](screenshots/06-event-compliance-mapping.png)

## Summary
| Stage | Authentication Failures |
|---|---|
| Baseline (before attack) | 2 |
| After attack | 14 |

End-to-end chain confirmed: attack execution → Windows Security event logging → Wazuh correlation rule triggering → account lockout, mapped to MITRE ATT&CK T1110 (Brute Force). Compared to the V1 test (20 attempts, 0 → 11 failures), this larger 100-attempt run produced a higher alert volume (2 → 14 failures) and total alert count (106 → 155), demonstrating that Wazuh's correlation-based detection scales appropriately with attack volume.
