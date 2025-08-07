# OSINT Investigation Report: Tracking Cybercriminal *DarkWebX*  
**Student**: Mohamed Abolyazeed  
**Course**: Sprints x Microsoft Summer Camp - Cybersecurity - OSINT 
**Date**: August 5, 2025  

---

## 1. Introduction  
This Open Source Intelligence (OSINT) investigation targets the cybercriminal alias **DarkWebX**, aiming to uncover their digital footprint using publicly available data. The objective is to identify associated social media accounts, email addresses, compromised credentials, and potential IP addresses linked to the threat actor. By leveraging ethical OSINT tools and techniques, this report provides a structured analysis of *DarkWebX*'s online presence, ensuring compliance with legal and ethical boundaries.

---

## 2. Methodology  
The investigation was conducted in a controlled **Kali Linux** environment, utilizing a suite of OSINT tools and techniques to systematically collect and analyze data. The following methods were employed:  

- **Sherlock**: Scanned for social media accounts associated with the alias *DarkWebX* across multiple platforms.  
- **theHarvester**: Searched for email addresses linked to domains and forums potentially associated with *DarkWebX*.  
- **h8mail**: Checked for compromised credentials in public breach databases.  
- **Google Dorking**: Used advanced search queries to uncover hidden information in forums, paste sites, and logs.  

---

## 3. 🔍 Findings  

### 3.1 Social Media Accounts (Sherlock)  
**Objective**: Identify and verify social media accounts associated with *DarkWebX*.  

**Steps Taken**:  
- Executed Sherlock with the command:  
  ```bash
  sherlock DarkWebX --output DarkWebX_accounts.txt
  ```  
- Analyzed results across 28 platforms to identify active and relevant accounts.  
- Manually verified accounts for activity and relevance to cybercriminal behavior.  

**Results**:  
Sherlock identified 28 accounts associated with the alias *DarkWebX*. Key findings include:  
![DarkWebX Accounts](<./DarkWebX_accounts.png>)  
- **Twitter**: `https://x.com/DarkWebX`  
- **GitHub**: `https://www.github.com/DarkWebX`  
- **Reddit**: `https://www.reddit.com/user/DarkWebX`  
- **TorrentGalaxy**: `https://torrentgalaxy.to/profile/DarkWebX`  
- **Behance**: `https://www.behance.net/DarkWebX`  
- **Blogger**: `https://darkwebx.blogspot.com`  

**Deliverable**:  
  - Twitter: `https://x.com/DarkWebX`  
  - GitHub: `https://www.github.com/DarkWebX`  
  - Reddit: `https://www.reddit.com/user/DarkWebX`  
  - TorrentGalaxy: `https://torrentgalaxy.to/profile/DarkWebX`  
  - Behance: `https://www.behance.net/DarkWebX` (dormant)  
  - Blogger: `https://darkwebx.blogspot.com` (potentially active)  

---

### 3.2 Associated Emails (theHarvester)  
**Objective**: Discover email addresses linked to *DarkWebX*.  

**Steps Taken**:  
- Executed theHarvester with multiple search engines:  
  ```bash
  theHarvester -d hackerforums.net -l 100 -b duckduckgo,bing,yahoo
  ```  
  ```bash
  theHarvester -d protonmail.com -l 100 -b yahoo
  ```  
  ```bash
  theHarvester -d torrentgalaxy.to -l 100 -b bing
  ```  
  ![theHarvester](<./theHarvester.png>)  
- Conducted Google Dorking with queries:  
  ```
  site:hackerforums.net "DarkWebX"
  "DarkWebX" "@protonmail.com"
  "DarkWebX" filetype:log
  ```  

**Results**:  
- No email addresses were identified using theHarvester across the specified domains (`hackerforums.net`, `protonmail.com`, `torrentgalaxy.to`).  
- Google Dorking queries did not yield email addresses directly linked to *DarkWebX*.  

---

### 3.3 Leaked Passwords (h8mail)  
**Objective**: Check for compromised credentials associated with *DarkWebX*.  

**Steps Taken**:  
- Executed h8mail to check the email `darkwebx@protonmail.com`:  
  ```bash
  python3 -m h8mail -t darkwebx@protonmail.com
  ```  

**Results**:  
- **Target**: `darkwebx@protonmail.com`  
- **Status**: Not Compromised.  
- No breaches were found for the email in public databases.  

---

### 3.4 Potential IP Addresses  
**Objective**: Identify IP addresses linked to *DarkWebX* from forums or logs.  

**Steps Taken**:  
- Conducted Google Dorking with queries:  
  ```
  site:hackerforums.net "DarkWebX" "IP"
  "DarkWebX" filetype:log
  "DarkWebX" "last login IP"
  ```  
- Planned to use WHOIS and Nmap for IP analysis if addresses were discovered.  

**Results**:  
- No IP addresses were identified through Google Dorking or forum searches.    

---

## 4. Conclusion  
The OSINT investigation into *DarkWebX* revealed a broad online presence across 28 platforms, including Twitter, GitHub, Reddit, and TorrentGalaxy, though manual verification is required to confirm their relevance to cybercriminal activity. No email addresses or IP addresses were identified, suggesting *DarkWebX* employs strong OPSEC measures, such as anonymized services (e.g., ProtonMail, VPNs). The email `darkwebx@protonmail.com` was not found in public breach databases, indicating no compromised credentials at this stage.  

---

## 5. Recommendations  
- **Continuous Monitoring**: Track *DarkWebX* on platforms like Twitter, Reddit, and TorrentGalaxy for new activity.  
- **Premium APIs**: Utilize services like HaveIBeenPwned API or HudsonRock for deeper breach analysis.  
- **Dark Web Search**: Explore dark web forums using tools like Ahmia or DarkSearch to identify unindexed activity.  
- **Collaboration**: Share findings with cybersecurity communities or authorities for further investigation.  

---

```
Prepared by**: Mohamed Abolyazeed
Contact**: [mohamedaboelyazeed9i20@gmail.com]  
Submission Date**: August 5, 2025  
```