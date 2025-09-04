# Exploiting CSRF with Token Not Tied to User Session

This guide delivers a clear, creative, and organized walkthrough to exploit a **Cross-Site Request Forgery (CSRF)** vulnerability where the CSRF token is not bound to a user’s session. Imagine wielding a skeleton key that unlocks any user’s account by swapping a single token! The objective is to craft a malicious form using a valid CSRF token from one account to forge an email change request for a victim, solving the lab by exploiting the lack of session-specific token validation.

## Objective
Bypass CSRF protection by using a token from one account to forge a request for another, create an auto-submitting form to change a victim’s email address, and deliver it via the exploit server to solve the lab.

## Prerequisites
- Burp Suite (Professional or Community Edition) with Proxy and Repeater modules configured.
- Access to the lab application with two accounts (your primary and secondary account).
- An exploit server provided by the lab (e.g., `YOUR-EXPLOIT-SERVER-ID.exploit-server.net`).
- Basic understanding of CSRF attacks, session management, and HTML form manipulation.

## Background on the Vulnerability
The application’s "Update email" feature requires a CSRF token in `POST` requests but does not tie the token to a specific user session. This allows attackers to use a valid token from one account to forge requests for another user. Since tokens are single-use, a fresh token must be obtained for the exploit, enabling unauthorized actions like changing a victim’s email address.

## Steps to Solve the Lab

### Step 1: Capture the Update Email Request
1. Open Burp’s browser and log in to your primary lab account.
2. Navigate to the account page and submit the "Update email" form with a test email.
3. In Burp Suite, go to **Proxy > HTTP history**, locate the `POST /my-account/change-email` request, and intercept it.
4. Note the `csrf` token value (e.g., `csrf=abc123`) and the `email` parameter (e.g., `email=your-email@web-security-academy.net`).
5. Drop the intercepted request to avoid processing it.

### Step 2: Test Token Validation Across Sessions
1. Open a private/incognito browser window and log in to your secondary lab account.
2. Submit the "Update email" form again, and send the `POST /my-account/change-email` request to **Repeater**.
3. In Repeater, swap the `csrf` token in the secondary account’s request with the token from the primary account.
4. Send the modified request:
   ```
   POST /my-account/change-email HTTP/1.1
   Host: YOUR-LAB-ID.web-security-academy.net
   Cookie: session=SECONDARY-ACCOUNT-SESSION
   Content-Type: application/x-www-form-urlencoded
   
   csrf=PRIMARY-ACCOUNT-TOKEN&email=test@web-security-academy.net
   ```
5. **Observation**: The request is accepted, confirming that CSRF tokens are not tied to user sessions.

### Step 3: Obtain a Fresh CSRF Token
1. In the primary account, submit the "Update email" form again to generate a new `POST /my-account/change-email` request.
2. In Proxy history, note the fresh `csrf` token (tokens are single-use).
3. **Observation**: A fresh token is required for the exploit to ensure validity.

### Step 4: Generate the CSRF Exploit
#### Option 1: Burp Suite Professional
1. Right-click the latest `POST /my-account/change-email` request in Proxy history.
2. Select **Engagement tools > Generate CSRF PoC**.
3. Enable the **Include auto-submit script** option.
4. Click **Regenerate** to create the exploit HTML, including the fresh `csrf` token:
   ```html
   <form method="POST" action="https://YOUR-LAB-ID.web-security-academy.net/my-account/change-email">
       <input type="hidden" name="csrf" value="FRESH-CSRF-TOKEN">
       <input type="hidden" name="email" value="anything@web-security-academy.net">
   </form>
   <script>
       document.forms[0].submit();
   </script>
   ```
5. Copy the generated HTML.

#### Option 2: Burp Suite Community Edition
1. Right-click the `POST /my-account/change-email` request and select **Copy URL** to get the action URL (e.g., `https://YOUR-LAB-ID.web-security-academy.net/my-account/change-email`).
2. Use the following HTML template, inserting the fresh `csrf` token:
   ```html
   <form method="POST" action="https://YOUR-LAB-ID.web-security-academy.net/my-account/change-email">
       <input type="hidden" name="csrf" value="FRESH-CSRF-TOKEN">
       <input type="hidden" name="email" value="anything@web-security-academy.net">
   </form>
   <script>
       document.forms[0].submit();
   </script>
   ```
3. **Observation**: The form auto-submits a `POST` request with the valid token, exploiting the lack of session binding.

### Step 5: Host the Exploit
1. Go to the exploit server provided by the lab.
2. Paste the CSRF exploit HTML into the **Body** section, ensuring the `csrf` token is fresh.
3. Click **Store** to save the exploit.
4. **Observation**: The exploit is hosted at `https://YOUR-EXPLOIT-SERVER-ID.exploit-server.net`.

### Step 6: Test the Exploit on Yourself
1. Click **View exploit** on the exploit server to load the malicious page in Burp’s browser.
2. Monitor **Proxy > HTTP history** to confirm the `POST /my-account/change-email` request is sent with the correct `csrf` and `email` parameters.
3. Check the response to verify the email was updated.
4. **Observation**: The exploit successfully changes your email, confirming it works.

### Step 7: Modify the Exploit for the Victim
1. Edit the exploit HTML on the exploit server, changing the `email` value to a different address (e.g., `victim@attacker.com`):
   ```html
   <form method="POST" action="https://YOUR-LAB-ID.web-security-academy.net/my-account/change-email">
       <input type="hidden" name="csrf" value="FRESH-CSRF-TOKEN">
       <input type="hidden" name="email" value="victim@attacker.com">
   </form>
   <script>
       document.forms[0].submit();
   </script>
   ```
2. Click **Store** to save the updated exploit.

### Step 8: Deliver the Exploit
1. On the exploit server, click **Deliver to victim**.
2. **Observation**: The lab simulates the victim visiting the malicious page, executing the `POST` request, and changing their email, solving the lab.

### Step 9: Verify Success
1. If the lab does not confirm completion, verify:
   - The `action` URL matches the lab’s `/my-account/change-email` endpoint.
   - The `csrf` token is fresh and valid.
   - The `email` value is different from your own.
   - The exploit server’s log shows the malicious page was accessed.
2. **Observation**: Successful email change for the victim completes the lab.