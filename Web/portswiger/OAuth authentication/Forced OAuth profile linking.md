# Exploiting Forced OAuth Profile Linking

This guide provides a clear, creative, and organized walkthrough to exploit a **forced OAuth profile linking** vulnerability. Imagine yourself as a digital matchmaker, forcing an unwanted connection between accounts to steal admin privileges! The objective is to intercept an OAuth linking code, craft a malicious iframe to link your social profile to the admin account, and delete the user `carlos` to solve the lab.

## Objective
Intercept the OAuth linking code during profile attachment, use it in a malicious iframe to force-link your social profile to the admin account, log in as admin, and delete `carlos`.

## Prerequisites
- Burp Suite with Proxy and Repeater modules configured.
- Access to the lab application with OAuth login, social media profile linking, and an admin panel.
- Two accounts: your lab account and a social media account.
- An exploit server provided by the lab (e.g., `YOUR-EXPLOIT-SERVER-ID.exploit-server.net`).
- Basic understanding of OAuth flows, redirects, and iframes.

## Background on the Vulnerability
The application allows linking social media profiles to existing accounts via OAuth, but the linking endpoint (`/oauth-linking`) does not properly validate or secure the authorization code. By intercepting the code during the linking process and embedding it in an iframe on an exploit server, attackers can force the victim (or admin) to link the attacker’s social profile to their account, enabling unauthorized access and actions like user deletion.

## Steps to Solve the Lab

### Step 1: Log In and Study OAuth Flow
1. In Burp’s browser, click **My account** and log in using the classic form (not social media).
2. **Observation**: The login page offers "Log in with social media," but use the direct login for now.
3. In **Proxy > HTTP history**, study the OAuth flow starting from `GET /auth?client_id=[...]`.

### Step 2: Attach Social Profile
1. In the application, go to the option to **Attach a social profile**.
2. **Observation**: You are redirected to the social media site; log in with your social credentials to complete the OAuth flow.
3. Forward to the blog site.
4. Log out, then click **My account** and select **Log in with social media**.
5. **Observation**: You log in instantly via the linked social profile.

### Step 3: Intercept the Linking Code
1. Repeat the "Attach a social profile" process while proxying traffic.
2. In **Proxy > Intercept**, intercept the `GET /oauth-linking?code=[...]` request (contains the authorization code).
3. Right-click and select **Copy URL** (e.g., `https://YOUR-LAB-ID.web-security-academy.net/oauth-linking?code=STOLEN-CODE`).
4. Drop the request to prevent linking.
5. Turn off interception.

- **Forwarded Request**
![payload suc](./img/Forced%20OAuth%20profile%20linking/Screenshot_2026-01-28_02_11_07.png)

- **Drop Request**
![payload suc](./img/Forced%20OAuth%20profile%20linking/Screenshot_2026-01-28_02_11_19.png)

### Step 4: Create Malicious Iframe on Exploit Server
1. Go to the exploit server and create an exploit at `/` with an iframe:
   ```html
   <iframe src="https://YOUR-LAB-ID.web-security-academy.net/oauth-linking?code=STOLEN-CODE"></iframe>
   ```
2. Store the exploit.
3. **Observation**: The iframe loads the linking endpoint with the stolen code.

### Step 5: Deliver the Exploit
1. On the exploit server, click **Deliver to victim**.
2. **Observation**: The victim’s browser loads the iframe, completing the OAuth flow and linking your social profile to the admin account.

![payload suc](./img/Forced%20OAuth%20profile%20linking/Screenshot_2026-01-28_02_09_24.png)

### Step 6: Log In as Admin
1. Return to the blog site and select **Log in with social media**.
2. **Observation**: You are logged in as the admin user.

### Step 7: Delete the User `carlos`
1. Navigate to the admin panel and delete `carlos`.
2. **Observation**: The server processes the request, deleting `carlos`, solving the lab.

![payload suc](./img/Forced%20OAuth%20profile%20linking/Screenshot_2026-01-28_02_22_08.png)