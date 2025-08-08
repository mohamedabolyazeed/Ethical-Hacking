# 🐧 The Ultimate Linux Command Reference Guide

## 🖥️ Hardware Information

```bash
# CPU Information
lscpu                      # Display CPU architecture details
cat /proc/cpuinfo          # Show detailed CPU information

# Memory Information
free -h                    # Display memory usage (human-readable)
cat /proc/meminfo          # Show detailed memory statistics

# Device Information
lsblk                      # List block devices
lspci -tv                  # Show PCI devices in tree view
lsusb -tv                  # Display USB devices in tree view
lshw                       # List all hardware
sudo dmidecode             # Show BIOS/system information

# Disk Operations
hdparm -i /dev/sda         # Show disk information
hdparm -tT /dev/sda        # Test disk reading speed
badblocks -s /dev/sda      # Check for bad blocks
fsck /dev/sda              # Check filesystem integrity
```

## 🔍 Searching Commands

```bash
# Find Files
find /home -name "*.log"   # Find .log files in /home
find /var -size +100M      # Find files larger than 100MB

# Search File Content
grep "error" /var/log/syslog        # Search for "error" in syslog
grep -r "TODO" ~/projects           # Search recursively for "TODO"

# Location Commands
locate "*.conf"                     # Find config files
which python3                       # Find python3 executable
whereis gcc                         # Find gcc binary and docs

# Text Processing
awk '/error/ {print $0}' syslog    # Print lines with "error"
sed 's/oldtext/newtext/' file.txt  # Replace text in file
```

## 📂 File Operations

```bash
# Basic File Operations
touch newfile.txt          # Create empty file
cp file1.txt backup/       # Copy file
mv file.txt newname.txt    # Move/rename file
rm file.txt               # Delete file
rm -r directory           # Delete directory
rm -rf directory          # Force delete directory

# File Content
cat file.txt              # Display file content
head -n 5 file.txt        # Show first 5 lines
tail -n 5 file.txt        # Show last 5 lines
more largefile.txt        # Page through file
less largefile.txt        # Better file navigation

# File Editors
nano file.txt             # Simple text editor
vi file.txt              # Vi text editor
vim file.txt             # Enhanced Vi editor

# File Security
gpg -c secrets.txt        # Encrypt file
gpg secrets.txt.gpg       # Decrypt file
shred -u file.txt         # Securely delete file

# File Analysis
wc -w file.txt           # Count words
diff file1 file2         # Compare files
```

## 📁 Directory Navigation

```bash
pwd                      # Show current directory
cd                       # Go to home directory
cd ..                    # Go up one level
cd -                     # Go to previous directory
cd /path/to/dir         # Go to specific directory

# Directory Listing
ls                      # List files
ls -a                   # Show hidden files
ls -l                   # Detailed listing
ls -lh                  # Human-readable sizes
dirs                    # Show directory stack
```

## 🗜️ File Compression

```bash
# Tar Operations
tar cf archive.tar files/     # Create tar archive
tar xf archive.tar           # Extract tar archive
tar czf archive.tar.gz dir/  # Create compressed archive

# Compression Tools
gzip file                    # Compress with gzip
gunzip file.gz              # Decompress gzip file
bzip2 file                  # Compress with bzip2
bunzip2 file.bz2            # Decompress bzip2 file
```

## 💡 Pro Tips

1. **Command History**
   - Use `Ctrl + R` to search command history
   - Use `!!` to repeat last command
   - Use `!$` to use last argument of previous command

2. **Keyboard Shortcuts**
   - `Ctrl + A`: Move to beginning of line
   - `Ctrl + E`: Move to end of line
   - `Ctrl + U`: Clear line before cursor
   - `Ctrl + K`: Clear line after cursor

3. **File Operations**
   - Always use `-i` flag with `rm`, `mv`, and `cp` for interactive mode
   - Use `{}` for batch operations: `touch file{1..10}.txt`

4. **System Safety**
   - Always backup before major system changes
   - Use `sudo` with caution
   - Test commands that could be dangerous on test files first

## ⚠️ Important Notes

1. Always verify commands before execution, especially when using `sudo`
2. Back up important data regularly
3. Be extra careful with `rm -rf` commands
4. Check system logs regularly for errors
5. Keep your system updated with latest security patches

