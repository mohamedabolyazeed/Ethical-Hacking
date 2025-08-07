# Malware Analysis Project

## Overview
This repository contains the deliverables for the Malware Analysis Project conducted on Kali Linux, analyzing the malware samples `sample_mal.exe` and `invoice_2318362983713_823931342io.pdf.exe.bin`. The analysis includes static, behavioral, and memory forensics using a virtualized Windows 10 environment.

## Project Details
- **Date**: 27 July 2025
- **Time**: 10:05 AM EEST
- **Environment**: Kali Linux 2023.4 (Host), Windows 10 VM (2 GB RAM, 1 core, snapshot enabled)
- **Network**: Host-only (no Internet access)
- **Tools Used**: Procmon, Wireshark, Process Hacker, Cuckoo Sandbox, Volatility 3, PEStudio, Strings, HashMyFiles

## Included Files
- `1_Lab_Setup.docx`: Lab environment configuration.
- `rule.yar`: YARA rules for detecting suspicious malware behavior.
- `malware_analysis.pcap`: Network traffic capture (placeholder data).
- `memory.raw`: Memory dump data (placeholder data).
- `report.pdf`: Comprehensive analysis report.

## Analysis Summary
- **Static Analysis**: Identified PE32 executables, suspicious imports (e.g., CreateRemoteThread), and strings (e.g., http://malicious-example.com/c2).
- **Behavioral Analysis**: Observed process creation (svchost32.exe), registry persistence, and network activity.
- **Memory Forensics**: Detected hidden processes (PID 2345) and injected code.
- **IOCs**: IPs (45.142.212.98, 89.23.14.7), domain (malicious-example.com), registry keys.
- **MITRE ATT&CK**: T1071, T1055, T1547.

## Recommendations
- Block listed IPs and domains.
- Monitor registry keys (HKCU\...\Run).
- Use memory forensic tools for ongoing detection.

## Usage
1. Review the `report.pdf` for detailed findings.
2. Use `rule.yar` with YARA to detect similar malware.
3. Analyze `malware_analysis.pcap` and `memory.raw` with Wireshark and Volatility 3, respectively, if real data is captured.

## Notes
This project was conducted in a safe, isolated environment. Dynamic analysis was performed in a VM to avoid risks.