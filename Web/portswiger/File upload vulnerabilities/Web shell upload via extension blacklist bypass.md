# Exploiting Web Shell Upload via Extension Blacklist Bypass

This guide provides a clear, creative, and organized solution to exploit a **web shell upload** vulnerability by bypassing an extension blacklist. The objective is to upload a malicious PHP script with a custom extension, use a `.htaccess` file to make it executable, retrieve the contents of Carlos's secret file (`/home/carlos/secret`), and submit the secret to solve the lab.

## Objective
Bypass the `.php` extension blacklist by uploading a `.htaccess` file to enable execution of a custom extension (`.l33t`), upload a PHP web shell with that extension, execute it to read a sensitive file, and submit the secret.

## Prerequisites
- Burp Suite with Proxy and Repeater modules configured.
- A user account with access to the avatar upload feature.
- Basic understanding of web shells, PHP scripting, and Apache `.htaccess` directives.

## Background on the Vulnerability
The application blacklists `.php` extensions for uploads but runs on an Apache server with `mod_php` enabled. By uploading a `.htaccess` file to add a custom executable MIME type for a non-blacklisted extension (e.g., `.l33t`), an attacker can upload and execute a PHP script, achieving remote code execution (RCE).

## Steps to Solve the Lab

### Step 1: Test Avatar Upload
1. Log in to your account while proxying traffic through Burp Suite.
2. Navigate to the account page and use the **avatar upload** feature to upload a legitimate image file (e.g., a `.jpg` or `.png`).
3. Return to the account page.
4. **Observation**: The uploaded image is displayed as a preview, confirming that avatars are stored and accessible.

### Step 2: Analyze the Image Retrieval Request
1. In Burp Suite, go to **Proxy > HTTP history**.
2. Locate the `GET` request fetching the uploaded image, e.g., `GET /files/avatars/<YOUR-IMAGE>`.
3. Right-click the request and select **Send to Repeater**.
4. **Observation**: The image is served from the `/files/avatars/` directory, indicating the storage location.

### Step 3: Create a Malicious PHP Web Shell
1. On your local system, create a file named `exploit.php` with the following content:
   ```php
   <?php echo file_get_contents('/home/carlos/secret'); ?>
   ```
2. **Explanation**: This PHP script reads and outputs the contents of the file `/home/carlos/secret`.

### Step 4: Attempt to Upload the Web Shell
1. Return to the avatar upload functionality and attempt to upload `exploit.php`.
2. **Observation**: The response indicates that `.php` extensions are not allowed, confirming an extension blacklist.

### Step 5: Identify the Upload Request
1. In Burp Suite, return to **Proxy > HTTP history** and locate the `POST /my-account/avatar` request used for the file upload.
2. Note the response headers revealing an **Apache server**.
3. Right-click the request and select **Send to Repeater**.

### Step 6: Upload a Malicious `.htaccess` File
1. In the Repeater tab containing the `POST /my-account/avatar` request, locate the part of the request body related to the uploaded file.
2. Make the following changes:
   - Change the `filename` parameter to `.htaccess`.
   - Change the `Content-Type` header to `text/plain`.
   - Replace the file contents with the following Apache directive:
     ```
     AddType application/x-httpd-php .l33t
     ```
3. **Explanation**: This directive maps the `.l33t` extension to the executable MIME type `application/x-httpd-php`, allowing PHP execution for `.l33t` files.
4. Send the request.
5. **Observation**: The `.htaccess` file is successfully uploaded.

### Step 7: Upload the Web Shell with Custom Extension
1. Use the back arrow in Burp Repeater to return to the original `POST /my-account/avatar` request for `exploit.php`.
2. Change the `filename` parameter to `exploit.l33t`.
3. Send the request.
4. **Observation**: The file is uploaded successfully, as `.l33t` is not blacklisted.

### Step 8: Execute the Web Shell
1. In the Repeater tab containing the `GET /files/avatars/<YOUR-IMAGE>` request, modify the path to:
   ```http
   GET /files/avatars/exploit.l33t HTTP/1.1
   ```
2. Send the request.
3. **Observation**: Thanks to the `.htaccess` file, the server executes the `.l33t` file as PHP, and the response contains the contents of `/home/carlos/secret`.

### Step 9: Submit the Secret
1. Copy the secret from the Repeater response.
2. Submit the secret via the lab’s submission mechanism.
3. **Observation**: Submitting the correct secret solves the lab.

### Step 10: Verify Success
1. If the lab does not confirm completion, verify:
   - The `.htaccess` file was uploaded with the correct directive.
   - The `exploit.l33t` file was uploaded and targeted correctly.
   - The PHP script syntax and file path `/home/carlos/secret` are accurate.
2. **Observation**: Successful retrieval and submission of the secret completes the lab.