# 🐧 The Ultimate Linux Commands Reference Guide

## 1. Hardware Information Commands
```bash
lscpu                    # See CPU information
lsblk                    # See information about block devices
lspci -tv                # Show PCI devices in tree-like diagram
lsusb -tv                # Display USB devices in tree-like diagram
lshw                     # List hardware configuration information
cat /proc/cpuinfo        # Show detailed CPU information
cat /proc/meminfo        # View detailed system memory information
cat /proc/mounts         # See mounted file systems
free -h                  # Display free and used memory
sudo dmidecode           # Show hardware information from BIOS
hdparm -i /dev/[device]  # Display disk data information
hdparm -tT /dev/[device] # Conduct read speed test on device/disk
badblocks -s /dev/[device] # Test for unreadable blocks
fsck /dev/[device]       # Run disk check on unmounted disk
```

## 2. Searching Commands
```bash
find [path] -name [pattern]     # Find files/directories matching pattern
find [path] -size [+100M]       # Find files larger than specified size
grep [pattern] [file]           # Search for pattern in file
grep -r [pattern] [directory]   # Recursively search in directory
locate [name]                   # Locate files and directories
which [command]                 # Search command in $PATH
whereis [command]               # Find source, binary, and manual page
awk '[pattern] {print $0}' [file] # Print lines matching pattern
sed 's/[old]/[new]/' [file]    # Find and replace text
```

## 3. File Commands
```bash
mkdir [directory]               # Create new directory
rm [file]                      # Remove file
rm -r [directory]              # Remove directory recursively
rm -rf [directory]             # Force remove directory
cp [source] [destination]      # Copy file
cp -r [source] [destination]   # Copy directory recursively
mv [source] [destination]      # Move or rename files
ln -s [path/file] [link]       # Create symbolic link
touch [file]                   # Create new file
cat [file]                     # Show file contents
cat [source] >> [destination]  # Append file contents
head [file]                    # Show first 10 lines
tail [file]                    # Show last 10 lines
more [file]                    # Display contents page by page
less [file]                    # Show contents with navigation
nano [file]                    # Open with nano editor
vi [file]                      # Open with vi editor
vim [file]                     # Open with vim editor
gpg -c [file]                 # Encrypt file
gpg [file].gpg                # Decrypt file
wc -w [file]                  # Count words/lines/bytes
ls | xargs wc                 # Count in all files
cut -d [delimiter] [file]     # Cut sections of lines
shred -u [file]               # Securely delete file
diff [file1] [file2]          # Compare two files
source [file]                 # Execute file in current shell
[command] | tee [file]        # Store output in file
```

## 4. Directory Navigation Commands
```bash
ls                            # List files and directories
ls -a                         # List all (including hidden)
ls -l                         # List in long format
pwd                          # Show current directory
cd                           # Change to home directory
cd ~                         # Change to home directory
cd ..                        # Move up one level
cd -                         # Go to previous directory
cd [path]                    # Change to specified directory
dirs                         # Show directory stack
```

## 5. File Compression Commands
```bash
tar cf [archive.tar] [file]   # Create tar archive
tar xf [archive.tar]          # Extract tar archive
tar czf [archive.tar.gz]      # Create compressed tar
gzip [file]                   # Compress file
gunzip [file.gz]              # Decompress .gz file
bzip2 [file]                  # Compress with bzip2
bunzip2 [file.bz2]            # Decompress .bz2 file
```

## 6. File Transfer Commands
```bash
scp [file] [user@host:path]   # Secure copy to remote
rsync -a [src] [dest]         # Sync directories
wget [link]                   # Download from web
curl -O [link]                # Transfer data
ftp [host]                    # FTP transfer
sftp [user@host]              # Secure FTP
```

## 7. User and Group Commands
```bash
id                            # Show user details
last                          # Show last logins
who                           # Show logged in users
w                            # Show user activity
finger [user]                 # Show user info
sudo useradd [user]           # Create new user
sudo adduser [user]           # Add user (interactive)
sudo userdel [user]           # Delete user
sudo usermod -aG [group] [user] # Add user to group
passwd                        # Change password
sudo passwd [user]            # Change user password
sudo groupadd [group]         # Add new group
sudo groupdel [group]         # Delete group
sudo groupmod -n [new] [old]  # Rename group
sudo [command]                # Run as superuser
su - [user]                   # Switch user
chgrp [group] [file]          # Change file group
```

## 8. Package Installation Commands
```bash
sudo apt-get install [package] # Install with apt-get
sudo apt install [package]     # Install with apt
apt search [keyword]           # Search packages
apt list                      # List installed packages
apt show [package]            # Show package info
sudo dpkg -i [package.deb]    # Install .deb package
sudo dpkg -l                  # List installed packages
```

## 9. Red Hat-Based Distribution Commands
```bash
sudo yum install [package]     # Install with YUM
yum search [keyword]           # Search packages
yum list installed            # List installed packages
yum info [package]            # Show package info
sudo dnf install [package]     # Install with DNF
sudo rpm -i [package.rpm]      # Install RPM package
```

## 10. Universal Linux Package Commands
```bash
# Install from source
tar zxvf [file.tar.gz]
cd [directory]
./configure
make
make install

sudo snap install [package]    # Install Snap package
sudo snap find [keyword]       # Search Snap store
sudo snap list                # List Snap packages
flatpak install [package]      # Install Flatpak
flatpak search [keyword]       # Search Flatpak
flatpak list                  # List Flatpak packages
```

## 11. Process Related Commands
```bash
ps                            # List processes
pstree                        # Show process tree
pmap                          # Show memory map
top                          # Show running processes
htop                         # Interactive process viewer
kill [pid]                    # Kill process by ID
pkill [name]                  # Kill process by name
killall [label]               # Kill all processes
pgrep [keyword]               # List matching processes
pidof [process]               # Show process ID
bg                           # Background jobs
fg                           # Foreground jobs
fg [job]                      # Bring job to foreground
lsof                         # List open files
trap "[commands]" [signal]    # Catch signals
wait                         # Wait for process
nohup [command] &             # Run in background
```

## 12. System Management Commands
```bash
uname -r                      # Show kernel release
uname -a                      # Show system info
uptime                        # Show system uptime
hostname                      # Show hostname
hostname -i                   # Show IP address
last reboot                   # Show reboot history
date                         # Show date and time
timedatectl                  # Query system clock
cal                          # Show calendar
w                            # List logged in users
whoami                        # Show current user
finger [user]                 # Show user info
ulimit [flags] [limit]        # Set resource limits
shutdown [time]               # Schedule shutdown
shutdown now                  # Immediate shutdown
modprobe [module]             # Add kernel module
dmesg                        # Show boot messages
```

## 13. Disk Usage Commands
```bash
df -h                         # Check disk space
df -i                         # Show free inodes
fdisk -l                      # Show disk partitions
du -ah                        # Show file sizes
du -sh                        # Show directory size
mount                         # Show mounted systems
findmnt                       # Show mount points
mount [device] [point]        # Mount device
```

## 14. SSH Login Commands
```bash
ssh [user@host]               # Connect via SSH
ssh [host]                    # Connect to host
ssh -p [port] [user@host]     # Connect on port
ssh-keygen                    # Generate SSH keys
sudo service sshd start       # Start SSH daemon
scp [file] [user@host:path]   # Secure copy
sftp [user@host]              # SFTP session
telnet [host]                 # Telnet connection
```

## 15. File Permission Commands
```bash
chmod 777 [file]              # Full permission
chmod 755 [file]              # Execute permission
chmod 766 [file]              # Read/write permission
chown [user] [file]           # Change owner
chown [user:group] [file]     # Change owner and group
```

## 16. Network Commands
```bash
ip addr show                  # Show IP addresses
ip address add [IP]           # Add IP address
ifconfig                      # Show interfaces
ping [host]                   # Ping host
netstat -pnltu               # Show active ports
netstat -tuln                # Show TCP/UDP ports
whois [domain]               # Domain information
dig [domain]                 # DNS information
dig -x [domain]              # Reverse DNS lookup
dig -x [IP]                  # IP reverse lookup
host [domain]                # IP lookup
hostname -I                   # Show local IP
nslookup [domain]            # Domain information
```

## 17. Variable Commands
```bash
let "var=[value]"             # Set integer variable
export [var]                  # Export variable
declare [var]="[value]"       # Declare variable
set                          # List variables
unset [var]                  # Remove variable
echo $[var]                  # Show variable value
```

## 18. Shell Command Management
```bash
alias [name]='[command]'      # Create command alias
watch -n [seconds] [command]  # Run command periodically
sleep [time] && [command]     # Delay command
at [time]                     # Schedule command
man [command]                 # Show manual
history                       # Show command history
```

## 19. Linux Shell Keyboard Shortcuts
```bash
Ctrl + C                      # Kill process
Ctrl + Z                      # Stop process
Ctrl + W                      # Delete word
Ctrl + U                      # Clear line before
Ctrl + K                      # Clear line after
Ctrl + Y                      # Paste from buffer
Ctrl + R                      # Search history
Ctrl + O                      # Execute found command
Ctrl + G                      # Exit history search
clear                        # Clear screen
!!                           # Repeat last command
exit                         # Exit session
```

---

💡 **Pro Tips:**
- Always use `sudo` with caution
- Create aliases for frequently used commands
- Use tab completion to save time
- Check command documentation with `man` pages
- Keep your system updated regularly
- Back up important data before major changes
- Use keyboard shortcuts to increase productivity

⚠️ **Warning:** Always be careful with system-altering commands, especially when using `sudo`, `rm -rf`, or modifying system files.
