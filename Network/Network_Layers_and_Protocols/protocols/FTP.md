# 🔒 FTP & Secure File Transfer
> *A comprehensive guide to FTP protocols, security implications, and modern file transfer methods*

![FTP](media/FTP.jpg)

---

## 🌐 FTP Fundamentals

### Core Concepts
- **Protocol**: FTP operates on TCP port 21 (control) and port 20 (data)
- **Architecture**: Client-server model with separate control and data channels
- **Authentication Types**: 
  - Anonymous access
  - User/password authentication
  - Certificate-based (FTPS)
  
### Operation Modes
1. **Active Mode**
   - Client opens random port > 1023
   - Server initiates data connection from port 20
   - Can cause firewall issues

2. **Passive Mode**
   - Server opens random port > 1023
   - Client initiates all connections
   - Better for firewalled environments

## 🔌 Connection Methods

### Traditional FTP Client
```bash
# Basic connection
ftp <target-ip> <target-port>

# Enhanced FTP client
lftp X.X.X.X
```

### Browser Access
```plaintext
ftp://username:password@X.X.X.X
```

### Programmatic Access
```python
from ftplib import FTP

ftp = FTP('host')
ftp.login(user='user', passwd='password')
```

## 🔍 Reconnaissance & Enumeration

### Service Detection
```bash
# Basic port scan
nmap -p 21 X.X.X.X

# Version detection
nmap -sV -p 21 X.X.X.X

# Banner grabbing
nc -nv X.X.X.X 21

# Advanced FTP scanning
nmap -p 21 --script ftp-* X.X.X.X
```

### Directory Enumeration
```bash
# Using gobuster
gobuster dir -u ftp://<target-ip> -w <wordlist-path>

# Using medusa
medusa -h <target-ip> -u user -P passwords.txt -M ftp
```

## ⚔️ Attack Vectors

### Anonymous Access
```bash
ftp X.X.X.X
Username: anonymous
Password: anything@example.com
```

### Credential Attacks
```bash
# Hydra brute force
hydra -L users.txt -P passes.txt ftp://X.X.X.X

# Metasploit
use auxiliary/scanner/ftp/ftp_login
set RHOSTS X.X.X.X
run
```

### FTP Bounce Attacks
```bash
# Nmap bounce scan
nmap -b <FTP_server>:<port> <target_network>

# Manual bounce
ftp> PORT 127,0,0,1,0,80
ftp> LIST
```

## 📝 FTP Commands Reference

### Essential Commands
| Command | Description | Example | Notes |
|---------|-------------|---------|--------|
| `lcd` | Change local directory | `lcd /path/to/dir` | Client-side only |
| `cd` | Change remote directory | `cd /public` | Server-side |
| `ls` | List files | `ls -la` | Supports flags |
| `get` | Download file | `get file.txt` | Binary/ASCII modes |
| `put` | Upload file | `put file.txt` | Check permissions |
| `mget` | Multiple downloads | `mget *.txt` | Wildcards supported |
| `mput` | Multiple uploads | `mput *.txt` | Wildcards supported |
| `binary` | Set binary mode | `binary` | For non-text files |
| `ascii` | Set ASCII mode | `ascii` | For text files |
| `passive` | Toggle passive mode | `passive` | Firewall friendly |

## 🔄 Alternative File Transfer Methods

### PowerShell Methods
```powershell
# Using wget
wget http://server/file.txt -O file.txt

# Using WebClient
(New-Object Net.WebClient).DownloadFile('http://server/file.txt', 'file.txt')

# Using Invoke-WebRequest
Invoke-WebRequest -Uri "http://server/file.txt" -OutFile "file.txt"
```

### SMB Transfer
```bash
# Server setup (Linux)
impacket-smbserver share $(pwd) -smb2support

# Windows client
copy \\192.168.31.141\share\file.txt .
```

### SCP (Secure Copy)
```bash
# Upload
scp file.txt user@remote:/path

# Download
scp user@remote:/path/file.txt .

# Directory transfer
scp -r directory/ user@remote:/path
```

## 🖥️ Server Setup

### Python Servers
```bash
# Python 3 HTTP server
python3 -m http.server 80

# Python 2 HTTP server
python2 -m SimpleHTTPServer 80

# PyFTPdlib server
python3 -m pyftpdlib -w -p 21 -u user -P pass
```

### Alternative Servers
```bash
# PHP server
php -S 0.0.0.0:8081

# Node.js server
npx http-server

# Updog enhanced server
updog -p 80
```

## 🛡️ Security Best Practices

### Server Hardening
1. **Access Control**
   - Implement strong password policies
   - Use IP whitelisting
   - Enable account lockout
   - Disable anonymous access

2. **Encryption**
   - Use FTPS (FTP over SSL/TLS)
   - Configure proper SSL/TLS versions
   - Maintain valid certificates

3. **Monitoring**
   - Enable detailed logging
   - Monitor failed login attempts
   - Set up alerts for suspicious activities
   - Regular security audits

4. **File System Security**
   - Implement proper permissions
   - Separate user directories
   - Regular backup procedures
   - Scan uploaded files for malware

## 🚀 Modern Alternatives

### Secure Alternatives to FTP
1. **SFTP (SSH File Transfer Protocol)**
   - Built-in encryption
   - Key-based authentication
   - Better security model

2. **AWS S3/Azure Blob Storage**
   - Cloud-native solution
   - Fine-grained access control
   - Scalable and reliable

3. **WebDAV**
   - Works over HTTPS
   - Integration with modern tools
   - Better firewall compatibility

4. **Rsync over SSH**
   - Efficient delta transfers
   - Secure by default
   - Great for backups

### API-Based Solutions
```javascript
// Example using AWS SDK
const AWS = require('aws-sdk');
const s3 = new AWS.S3();

async function uploadFile(file, bucket, key) {
  await s3.putObject({
    Bucket: bucket,
    Key: key,
    Body: file
  }).promise();
}
```

## 🔍 Troubleshooting Tips

1. **Connection Issues**
   - Check firewall rules
   - Verify passive/active mode settings
   - Confirm DNS resolution
   - Test with different clients

2. **Performance Optimization**
   - Use binary mode for non-text files
   - Enable compression when available
   - Consider connection limiting
   - Implement retry mechanisms

3. **Common Error Codes**
   - 530: Authentication failed
   - 550: File/directory unavailable
   - 425: Can't open data connection
   - 421: Service not available
