# Exploiting Inconsistent Security Controls

This guide delivers a clear, creative, and organized walkthrough to exploit a vulnerability caused by **inconsistent security controls** in an application's access control system. Picture yourself as a cunning insider, forging a VIP pass to slip into the admin’s exclusive lounge! The objective is to bypass access restrictions by registering with a specific email domain, updating your email to a privileged `@dontwannacry.com` address, and deleting the user `carlos` to solve the lab.

## Objective
Exploit weak access control by registering an account, changing the email to a privileged `@dontwannacry.com` address, accessing the admin panel, and deleting the user `carlos`.

## Prerequisites
- Burp Suite with Proxy and Content Discovery tools configured.
- Access to the lab application with account registration, email client, and admin panel features.
- Basic understanding of access control vulnerabilities and email-based privilege escalation.

## Background on the Vulnerability
The application restricts the `/admin` panel to users with `@dontwannacry.com` email addresses but allows users to change their email post-registration without validation. This inconsistency enables attackers to register with a non-privileged email, update it to a privileged domain, and gain unauthorized admin access.

## Steps to Solve the Lab

### Step 1: Discover the Admin Panel
1. Open the lab in Burp’s browser.
2. In Burp Suite, go to **Target > Site map**, right-click the lab domain, and select **Engagement tools > Discover content**.
3. Click **Session is not running** to start content discovery.
4. Monitor the **Site map** tab in the content discovery dialog.
5. **Observation**: The tool discovers the `/admin` path.

### Step 2: Attempt to Access the Admin Panel
1. In the browser, navigate to `/admin`.
2. **Observation**: Access is denied, but the error message indicates that users with `@dontwannacry.com` email addresses (DontWannaCry employees) have access.

### Step 3: Register a New Account
1. Navigate to the account registration page in the browser.
2. **Observation**: A message instructs DontWannaCry employees to use their company email address.
3. Click the **Email client** button to find your lab-provided email domain (e.g., `your-email-id.web-security-academy.net`).
4. Register an account using an arbitrary email in the format:
   ```
   anything@your-email-id.web-security-academy.net
   ```
5. Submit the registration form.

### Step 4: Confirm the Account
1. Go to the lab’s email client and open the confirmation email.
2. Click the link in the email to complete the registration.
3. **Observation**: The account is now active.

### Step 5: Change the Email Address
1. Log in to the application using your new account.
2. Navigate to the **My account** page.
3. Locate the option to change your email address.
4. Update your email to an arbitrary address in the `@dontwannacry.com` domain (e.g., `test@dontwannacry.com`).
5. Submit the change.
6. **Observation**: The email update is successful without validation.

### Step 6: Access the Admin Panel
1. Navigate to `/admin` in the browser.
2. **Observation**: You now have access to the admin panel, which includes options to delete users.

### Step 7: Delete the User `carlos`
1. In the admin panel, locate the functionality to delete users.
2. Select or input `carlos` as the target user and submit the deletion request.
3. **Observation**: The server processes the request, deleting `carlos`, solving the lab.

### Step 8: Verify Success
1. If the lab does not confirm completion, verify:
   - The email was changed to an `@dontwannacry.com` address.
   - The `/admin` panel is accessible.
   - The delete action targets `carlos` correctly.
2. **Observation**: Successful deletion of `carlos` completes the lab.

## Success!
You’ve exploited a chink in the application’s armor, upgraded your account to VIP status with a sneaky email change, and banished `carlos` from the system, conquering the lab!

## Key Takeaways
- **Inconsistent Security Controls**: Allowing email changes without validation creates privilege escalation vulnerabilities.
- **Impact**: Unauthorized access to admin functionality can lead to destructive actions like user deletion.
- **Mitigation**: Validate email domains during registration and updates, restrict admin access to verified accounts, and implement role-based access control.
- **Testing Tip**: Use Burp’s Content Discovery tool to uncover hidden endpoints and test for privilege escalation via user-controlled inputs like email addresses.