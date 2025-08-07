# Exploiting Web Shell Upload via Content-Type Restriction Bypass

This guide provides a clear, creative, and organized solution to exploit a **web shell upload** vulnerability by bypassing Content-Type restrictions. The objective is to upload a malicious PHP script disguised as an image, execute it to retrieve the contents of Carlos's secret file (`/home/carlos/secret`), and submit the secret to solve the lab.

## Objective
Bypass the avatar upload’s MIME type restrictions to upload a PHP web shell, execute it to read a sensitive file, and submit the secret to complete the lab.

## Prerequisites
- Burp Suite with Proxy and Repeater modules configured.
- A user account with access to the avatar upload feature.
- Basic understanding of web shells, PHP scripting, and MIME type manipulation.

## Background on the Vulnerability
The application restricts avatar uploads to `image/jpeg` or `image/png` MIME types but fails to properly validate the file content. By manipulating the `Content-Type` header in the upload request, an attacker can upload a malicious PHP script that executes on the server, enabling remote code execution (RCE).

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
4. **Observation**: The image is served from the `/files/avatars/` directory, indicating where uploaded files are stored.

### Step 3: Create a Malicious PHP Web Shell
1. On your local system, create a file named `exploit.php` with the following content:
   ```php
   <?php echo file_get_contents('/home/carlos/secret'); ?>
   ```
2. **Explanation**: This PHP script reads and outputs the contents of the file `/home/carlos/secret`.

### Step 4: Attempt to Upload the Web Shell
1. Return to the avatar upload functionality and attempt to upload `exploit.php`.
2. **Observation**: The response indicates that only files with MIME types `image/jpeg` or `image/png` are allowed, confirming a Content-Type restriction.

### Step 5: Bypass Content-Type Restriction
1. In Burp Suite, return to **Proxy > HTTP history** and locate the `POST /my-account/avatar` request used for the file upload.
2. Right-click the request and select **Send to Repeater**.
3. In the Repeater tab, locate the part of the message body related to the uploaded file (e.g., within the multipart form data).
4. Change the `Content-Type` of the file to `image/jpeg`. For example:
   ```
   Content-Disposition: form-data; name="avatar"; filename="exploit.php"
   Content-Type: image/jpeg
   ```
5. Ensure the file content remains the PHP script from `exploit.php`.
6. Send the modified request.
7. **Observation**: The response confirms successful upload, indicating the Content-Type restriction was bypassed.

### Step 6: Execute the Web Shell
1. In the Repeater tab containing the `GET /files/avatars/<YOUR-IMAGE>` request, modify the path to:
   ```http
   GET /files/avatars/exploit.php HTTP/1.1
   ```
2. Send the request.
3. **Observation**: The server executes the PHP script, and the response contains the contents of `/home/carlos/secret`.

### Step 7: Submit the Secret
1. Copy the secret from the Repeater response.
2. Submit the secret via the lab’s submission mechanism.
3. **Observation**: Submitting the correct secret solves the lab.

### Step 8: Verify Success
1. If the lab does not confirm completion, verify:
   - The `exploit.php` file was uploaded with the correct `Content-Type: image/jpeg`.
   - The `GET /files/avatars/exploit.php` request is correctly formatted.
   - The PHP script syntax and file path `/home/carlos/secret` are accurate.
2. **Observation**: Successful retrieval and submission of the secret completes the lab.