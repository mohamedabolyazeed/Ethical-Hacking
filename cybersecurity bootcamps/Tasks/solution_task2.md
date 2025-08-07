# 🐧 Linux Tasks 2
## Task 1: Create user account for islam
**Question:**
Create a user account with the following attributes:
- Username: islam
- Fullname: Islam Askar
- Password: islam

**Solution:**
```bash
sudo useradd -c "Islam Askar" islam
echo "islam" | sudo passwd --stdin islam
```

## Task 2: Create user account for baduser
**Question:**
Create a user account with the following attributes:
- Username: baduser
- Full name: Bad User
- Password: baduser

**Solution:**
```bash
sudo useradd -c "Bad User" baduser
echo "baduser" | sudo passwd --stdin baduser
```

## Task 3: Create supplementary group pgroup
**Question:**
Create a supplementary (Secondary) group called pgroup with group ID of 30000

**Solution:**
```bash
sudo groupadd -g 30000 pgroup
```

## Task 4: Create supplementary group badgroup
**Question:**
Create a supplementary group called badgroup

**Solution:**
```bash
sudo groupadd badgroup
```

## Task 5: Add user to group
**Question:**
Add islam user to the pgroup group as a supplementary group

**Solution:**
```bash
sudo usermod -aG pgroup islam
```

## Task 6: Modify password
**Question:**
Modify the password of islam's account to password

**Solution:**
```bash
echo "password" | sudo passwd --stdin islam
```

## Task 7: Lock user account
**Question:**
Lock bad user account so he can't log in

**Solution:**
```bash
sudo usermod -L baduser
```

## Task 8: Delete user account
**Question:**
Delete bad user account

**Solution:**
```bash
sudo userdel -r baduser
```

## Task 9: Delete group
**Question:**
Delete the supplementary group called badgroup

**Solution:**
```bash
sudo groupdel badgroup
```

## Task 10: Create multiple users
**Question:**
Using the useradd command, add accounts for the following users in your system: user1, user2, user3, user4, user5, user6 and user7.
Note: Remember to give each user a password.

**Solution:**
```bash
# Create users
for i in {1..7}; do
    sudo useradd "user$i"
    echo "password$i" | sudo passwd --stdin "user$i"
done
```

## Task 11: Create groups with specific GIDs
**Question:**
Using the groupadd command, add the following groups to your system:
- sales (GID: 10000)
- hr (GID: 10001)
- web (GID: 10002)

**Solution:**
```bash
sudo groupadd -g 10000 sales
sudo groupadd -g 10001 hr
sudo groupadd -g 10002 web
```

## Task 12: Add users to groups
**Question:**
Using the usermod command:
- Add user1 and user2 to the sales auxiliary group
- Add user3 and user4 to the hr auxiliary group
- Add user5 and user6 to web auxiliary group
- Add user7 to all auxiliary groups

**Solution:**
```bash
# Add to sales group
sudo usermod -aG sales user1
sudo usermod -aG sales user2

# Add to hr group
sudo usermod -aG hr user3
sudo usermod -aG hr user4

# Add to web group
sudo usermod -aG web user5
sudo usermod -aG web user6

# Add user7 to all groups
sudo usermod -aG sales,hr,web user7
```

## Task 13: Verify group membership
**Question:**
Login as each user and use id command to verify that they are in the appropriate groups. How else might you verify this information?

**Solution:**
```bash
# Method 1: Using id command
id user1  # Repeat for each user

# Method 2: Check group file
getent group sales
getent group hr
getent group web

# Method 3: Check groups command
groups user1  # Repeat for each user
```

## Task 14: Account Aging Management
**Question:**
1. Create user account xyz with comment testing
2. Change the expiry date of the account & Inactive time for xyz account
3. Change the min number of days to change password to be 3 days for xyz
4. Change the maximum number of days to change the password after 90 day for xyz
5. Change the warning before the account disabled
6. Change the minimum password length
7. Display the account information for xyz user

**Solution:**
```bash
# 1. Create user
sudo useradd -c "testing" xyz
echo "password" | sudo passwd --stdin xyz

# 2. Set expiry and inactive time
sudo chage -E 2025-12-31 xyz  # Set expiry date
sudo chage -I 30 xyz          # Set inactive time

# 3. Set minimum password change interval
sudo chage  3 xyz

# 4. Set maximum password age
sudo chage  90 xyz

# 5. Set warning period
sudo chage -W 7 xyz

# 6. Change minimum password length
sudo sed -i 's/PASS_MIN_LEN.*/PASS_MIN_LEN    8/' /etc/login.defs

# 7. Display account information
sudo chage -l xyz
```

## Task 15: Create Users with Supplementary Group
**Question:**
Create User accounts with supplementary group:
- Group: sysadms
- Users: natasha, harry, sarah (with nologin shell)
- natasha and harry should be members of sysadms group
- Password for all users should be "trootent"

**Solution:**
```bash
# Create group
sudo groupadd sysadms

# Create users
sudo useradd natasha
sudo useradd harry
sudo useradd -s /sbin/nologin sarah

# Set passwords
echo "trootent" | sudo passwd --stdin natasha
echo "trootent" | sudo passwd --stdin harry
echo "trootent" | sudo passwd --stdin sarah

# Add users to sysadms group
sudo usermod -aG sysadms natasha
sudo usermod -aG sysadms harry
```

## Task 16: Create User with Specific UID
**Question:**
Create user 'bob' with 2112 uid and set the password 'trootent'

**Solution:**
```bash
sudo useradd -u 2112 bob
echo "trootent" | sudo passwd --stdin bob
```
