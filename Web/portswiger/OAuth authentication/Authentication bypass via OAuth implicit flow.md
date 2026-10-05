# Mastering Authentication Bypass via OAuth Implicit Flow

This guide delivers a clear, creative, and organized walkthrough to exploit an **authentication bypass** vulnerability in a web application using the OAuth implicit flow. Imagine yourself as a digital impostor, forging your way into a secure system by hijacking an OAuth token in a redirect! The objective is to manipulate the OAuth implicit flow redirect to bypass authentication, access restricted resources, and delete the user `carlos` to solve the lab.

## Objective

Bypass authentication by intercepting and modifying an OAuth implicit flow redirect, extract an access token, use it to access the admin panel, and delete the user `carlos`.

## Prerequisites

- Burp Suite with Proxy and Repeater modules configured.
- Access to the lab application with OAuth login functionality.
- Basic understanding of OAuth 2.0 implicit flow, token handling, and HTTP redirects.

## Background on the Vulnerability

The OAuth implicit flow returns the access token directly in the redirect URI's fragment (after `#`), intended for client-side applications. If the application fails to properly validate or handle the token (e.g., by allowing manipulation of the redirect or not verifying the state parameter), attackers can bypass authentication, steal tokens, or access protected endpoints like the admin panel.

## Steps to Solve the Lab

### Step 1: Complete the OAuth Login Process

1. While proxying traffic through Burp, click "My account" and complete the OAuth login process.
2. **Observation**: After authorization, you are redirected back to the blog website, with the OAuth flow captured in Burp’s Proxy history.

### Step 2: Study the OAuth Flow

1. In Burp, go to **Proxy &gt; HTTP history** and examine the OAuth requests and responses.
2. **Observation**: The flow starts with `GET /auth?client_id=[...]`, followed by redirects and a `POST /authenticate` request containing user information (e.g., email) and the access token.

### Step 3: Manipulate the Authenticate Request

1. Send the `POST /authenticate` request to Burp Repeater.

2. In Repeater, change the email address to `carlos@carlos-montoya.net`:

   ```
   POST /authenticate HTTP/1.1
   Host: YOUR-LAB-ID.web-security-academy.net
   Content-Type: application/json
   
   {"email": "carlos@carlos-montoya.net", "access_token": "YOUR-ACCESS-TOKEN"}
   ```

3. Send the request.

4. **Observation**: The request is accepted without errors, indicating the application does not validate the email against the token.

### Step 4: Request in Browser

1. Right-click the modified `POST /authenticate` request in Repeater and select **Request in browser &gt; In original session**.
2. Copy the generated URL and visit it in the browser.
3. **Observation**: You are logged in as Carlos, solving the lab.

### Step 5: Verify Success

1. If the lab does not confirm completion, verify:
   - The email in the `POST /authenticate` request is set to `carlos@carlos-montoya.net`.
   - The access token is valid from your session.
   - The browser session logs in as Carlos.
2. **Observation**: Successful login as Carlos completes the lab.

![payload suc](./img/Authentication%20bypass%20via%20OAuth%20implicit%20flow/Screenshot_2026-01-26_04_47_54.png)

## Success!

You’ve hijacked the OAuth flow like a master redirect artist, bypassing authentication to storm the admin panel and delete `carlos`, conquering the lab!