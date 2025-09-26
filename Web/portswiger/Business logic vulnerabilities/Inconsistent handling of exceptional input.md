# Exploiting Inconsistent Handling of Exceptional Input

This guide provides a clear, creative, and organized walkthrough to exploit a vulnerability caused by **inconsistent handling of exceptional input** in an application's email validation logic. Picture yourself as a digital sculptor, chiseling a perfectly crafted email address to trick the system into granting you admin access! The objective is to register an account with a long email address that gets truncated to mimic a privileged `@dontwannacry.com` domain, access the admin panel, and delete the user `carlos` to solve the lab.

## Objective
Craft a long email address that, when truncated to 255 characters, ends with `@dontwannacry.com`, register an account to gain admin access, and delete `carlos` to complete the lab.

## Prerequisites
- Burp Suite with Proxy and Content Discovery tools configured.
- Access to the lab application with account registration, email client, and admin panel features.
- Basic understanding of input validation vulnerabilities and string truncation.

## Background on the Vulnerability
The application truncates email addresses to 255 characters but uses the truncated version for access control checks. By registering with a carefully crafted email address that includes `dontwannacry.com` as a subdomain and truncates to exactly `@dontwannacry.com`, attackers can bypass restrictions that grant admin access to `@dontwannacry.com` users, enabling unauthorized actions like user deletion.

## Steps to Solve the Lab

### Step 1: Discover the Admin Panel
1. Open the lab in Burp’s browser.
2. In Burp Suite, go to **Target > Site map**, right-click the lab domain, and select **Engagement tools > Discover content**.
3. Click **Session is not running** to start content discovery.
4. Monitor the **Site map** tab in the content discovery dialog.
5. **Observation**: The tool discovers the `/admin` path.

### Step 2: Attempt to Access the Admin Panel
1. In the browser, navigate to `/admin`.
2. **Observation**: Access is denied, but an error message indicates that users with `@dontwannacry.com` email addresses (DontWannaCry employees) have access.

### Step 3: Identify the Email Domain
1. From the lab banner, click the **Email client** button to access the email client.
2. Note the unique email domain provided (e.g., `@YOUR-EMAIL-ID.web-security-academy.net`).
3. **Observation**: This domain is used for receiving confirmation emails during registration.

### Step 4: Test Email Truncation
1. Navigate to the account registration page in the browser.
2. Register with an exceptionally long email address (at least 200 characters):
   ```
   aaaaaa...aaaaa@YOUR-EMAIL-ID.web-security-academy.net
   ```
   (Use a string of ~200 `a` characters before the `@` to ensure length.)
3. Submit the registration form.
4. Go to the email client, open the confirmation email, and click the link to complete registration.
5. Log in and navigate to the **My account** page.
6. **Observation**: The email address is truncated to 255 characters, confirming the application’s length restriction.

### Step 5: Craft a Malicious Email Address
1. Log out and return to the account registration page.
2. Craft a new email address that includes `dontwannacry.com` as a subdomain, ensuring the `@dontwannacry.com` ends exactly at the 255th character:
   - Structure: `very-long-string@dontwannacry.com.YOUR-EMAIL-ID.web-security-academy.net`
   - Calculate length:
     - `dontwannacry.com` = 15 characters.
     - `@` = 1 character (total 16).
     - `YOUR-EMAIL-ID.web-security-academy.net` = Assume ~39 characters (adjust based on actual ID length).
     - Total suffix length: 16 + 39 = 55 characters.
     - Characters needed for `very-long-string`: 255 - 55 = 200.
   - Example email (with 200 `a` characters):
     ```
     aaaaaa...aaaaa@dontwannacry.com.YOUR-EMAIL-ID.web-security-academy.net
     ```
     (Replace with 200 `a` characters to reach exactly 255 characters, ending with `m` in `dontwannacry.com`.)
3. Submit the registration form.

### Step 6: Confirm the New Account
1. Go to the email client and open the confirmation email for the new account.
2. Click the link to complete registration.
3. Log in to the new account.
4. **Observation**: On the **My account** page, the email is truncated to `aaaaa...aaaaa@dontwannacry.com` (255 characters), mimicking a privileged domain.

### Step 7: Access the Admin Panel
1. Navigate to `/admin` in the browser.
2. **Observation**: The application grants access to the admin panel due to the truncated `@dontwannacry.com` email.

### Step 8: Delete the User `carlos`
1. In the admin panel, locate the functionality to delete users.
2. Select or input `carlos` as the target user and submit the deletion request.
3. **Observation**: The server processes the request, deleting `carlos`, solving the lab.

### Step 9: Verify Success
1. If the lab does not confirm completion, verify:
   - The email address was crafted to truncate exactly to `@dontwannacry.com` at 255 characters.
   - The `/admin` panel is accessible after login.
   - The delete action targets `carlos` correctly.
2. **Observation**: Successful deletion of `carlos` completes the lab.