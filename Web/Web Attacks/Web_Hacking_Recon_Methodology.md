# 🌐 Web Hacking Reconnaissance Methodology

A structured, creative, and comprehensive guide to performing reconnaissance for web hacking. This methodology combines **passive** and **active** techniques with a focus on OSINT, automation, and thorough documentation. Let’s dive into the art of uncovering hidden attack surfaces! 🕵️‍♂️

---

## 🛡️ Phase 1: Passive Reconnaissance (OSINT)

Gather intelligence without direct interaction to minimize detection risk. Think like a digital detective!

### 🔍 **1. Initial Broad Search**

- **Search Engines**:
  - Use **Google**, **Shodan**, and **ProgrammableWeb** to uncover:
    - **API usage**: Design, architecture, and endpoints.
    - **Business insights**: Purpose, industry trends, and partnerships.
    - **Documentation**: Publicly available tech or API docs.
  - **Google Dorks**: Craft queries like `site:*.target.com inurl:(api | docs)`.

- **Domain Information**:
  - **WHOIS & Reverse WHOIS**: Use services like **Whoxy** to identify domain owners and related domains.
  - **DNS Mapping**: Leverage **DNS Dumpster** or **Fierce** for DNS records (A, MX, TXT, etc.).
  - **SSL Certificate Parsing**: Extract subdomains using **crt.sh**, **Censys**, or **Cert Spotter**.

### 🌍 **2. Subdomain Enumeration**

Discover hidden subdomains to expand the attack surface.

- **Tools**:
  - **Sublist3r**, **SubBrute**, **Amass**, **Gobuster**.
  - Combine with **Cloudflare Enum** for cloud-hosted assets.
- **Wordlists**:
  - Use **SecLists** by Daniel Miessler for robust subdomain wordlists.
  - Generate custom wordlists with **Commonspeak2** based on target-specific keywords.
- **Advanced Techniques**:
  - **Altdns**: Brute-force subdomain permutations (e.g., dev-admin.target.com).
  - Check for **wildcard DNS** misconfigurations.

### 📜 **3. Public Exposure & Code Leaks**

Hunt for sensitive data left in plain sight.

- **GitHub Recon**:
  - Search for exposed API keys, credentials, or proprietary code using **Gitrob** or manual queries like `target.com password`.
  - Look for `.env`, `config.yml`, or backup files.
- **Paste Sites**:
  - Use **Pastehunter** or manually search **Pastebin**, **Ghostbin** for leaks related to the target.
- **Wayback Machine**:
  - Explore historical snapshots on **archive.org** for:
    - Deprecated API endpoints.
    - Old features or sensitive paths.
    - Exposed credentials or configs.
- **Developer Comments**:
  - Inspect public files (JS, HTML, CSS) for debug info or hardcoded secrets.

### 📚 **4. API Documentation Discovery**

APIs are goldmines for attackers—find their blueprints!

- **Common Paths**:
  - Check `/api`, `/swagger/index.html`, `/openapi.json`, `/api/swagger/v1`, `/docs`.
  - Try accessing documentation post-authentication.
- **API Wordlists**:
  - Use wordlists from **hAPI-hacker/Hacking-APIs** or custom-built lists.
- **Import Specs**:
  - If you find **OpenAPI**, **Swagger**, **RAML**, or **Postman collections**, import them into **Postman** or **Insomnia** for analysis.

### 🖥️ **5. Tech Stack Fingerprinting**

Understand the target’s technology to tailor attacks.

- **Identify**:
  - Programming languages (e.g., Python, PHP, Node.js).
  - Frameworks (e.g., Django, Laravel, Express).
  - CMS or platforms (e.g., WordPress, Drupal).
- **Tools**:
  - **WhatWeb** or **Wappalyzer** for web tech detection.
  - **StackShare** for industry-standard stack insights.
  - **Retire.js** to detect outdated or vulnerable JavaScript libraries.

---

## ⚔️ Phase 2: Active Reconnaissance

Time to interact with the target! Be cautious to avoid detection while probing deeper.

### 🌐 **1. Baseline Detection**

Establish a footprint of the target’s infrastructure.

- **Port Scanning**:
  - Use **Nmap** (`nmap -sC -sV -p-`) or **Masscan** for high-speed scans.
  - Identify open ports, services, and versions.
- **Vulnerability Scanning**:
  - Run **OWASP ZAP** or **Nikto** to detect low-hanging vulnerabilities (e.g., misconfigured headers, outdated software).

### 🔎 **2. Hands-on Analysis**

Interact with the application like a user—and a hacker.

- **Manual Browsing**:
  - Explore all features as different user roles (guest, user, admin).
  - Look for hidden or role-specific endpoints.
- **Traffic Interception**:
  - Use **Burp Suite Proxy** to capture and analyze HTTP/HTTPS requests.
  - Modify requests to test for weak input validation.
- **Browser DevTools**:
  - Inspect **Network** tab for API calls and responses.
  - Check **Sources** for client-side scripts or hardcoded secrets.
  - Explore **Storage** for cookies, localStorage, or session tokens.
- **API Response Analysis**:
  - Look for:
    - **Information disclosures**: User data, server details.
    - **Security misconfigurations**: CORS, CSRF, or weak auth.
    - **Excessive data exposure**: Hidden fields or sensitive attributes.

### 🛠️ **3. Targeted Scanning & Fuzzing**

Probe for weaknesses with precision.

- **Directory Brute-Forcing**:
  - Tools: **Gobuster**, **Burp Intruder**, **dirb**.
  - Use API-focused wordlists (e.g., `/api/v1`, `/admin`, `/backup`).
- **Hidden Parameter Discovery**:
  - Use **Param Miner** or **Burp Intruder** to uncover undocumented parameters.
- **API Fuzzing**:
  - **Endpoints**: Fuzz to discover hidden or undocumented APIs.
  - **HTTP Methods**: Test for unsupported methods (e.g., PUT, DELETE).
  - **Mass Assignment**: Add extra parameters to API requests.
  - **Parameter Pollution**: Test for server-side logic flaws.
- **GraphQL Introspection**:
  - Query the schema with tools like **GraphiQL** or **Altair**.
  - Attempt to bypass disabled introspection protections.

### 📝 **4. Note Taking**

Stay organized to maximize efficiency.

- **Document**:
  - URLs, parameters, request/response pairs.
  - Potential vulnerabilities with proof-of-concept details.
  - Screenshots or video recordings of findings.
- **Tools**:
  - Use **Obsidian** for markdown-based notes.
  - **XMind** for mind-mapping complex attack surfaces.
  - **Notion** for collaborative or cloud-based documentation.

---

## 🔄 Continuous Recon & Automation

Recon is a living process—keep it running in the background!

### 🤖 **Automate Where Possible**

- **Bash/Python Scripts**:
  - Automate subdomain enumeration, directory brute-forcing, or API discovery.
  - Example: Combine **Amass** with **Gobuster** in a cron job.
- **Scheduling**:
  - Run periodic scans to detect new subdomains, ports, or endpoints.
  - Use **Cron** or **GitHub Actions** for scheduling.
- **Alerting**:
  - Set up notifications for new findings using **Slack**, **Discord**, or email.
  - Tools like **Notify** can integrate with recon pipelines.

### 🚀 **Pro Tip: Stay Stealthy**

- Use proxies or VPNs to avoid IP bans.
- Randomize scan intervals to mimic organic traffic.
- Respect legal boundaries and scope agreements.