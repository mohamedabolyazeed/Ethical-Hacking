# Exploiting Web Shell Upload via Path Traversal

This guide provides a clear, creative, and organized solution to exploit a **web shell upload** vulnerability using **path traversal** to achieve remote code execution (RCE). The objective is to upload a malicious PHP script, bypass directory restrictions using path traversal, execute the script to retrieve the contents of Carlos's secret file (`/home/carlos/secret`), and submit the secret to solve the lab.

## Objective
Upload a PHP web shell to a higher directory using path traversal, execute it to read a sensitive file, and submit the secret to complete the lab.

## Prerequisites
- Burp Suite with Proxy and Repeater modules configured.
- A user account with access to the avatar upload feature.
- Basic understanding of web shells, PHP scripting, and path traversal attacks.

## Background on the Vulnerability
The application allows avatar uploads without restricting PHP file extensions but fails to execute files in the `/files/avatars/` directory. By exploiting a path traversal vulnerability in the file upload process, an attacker can place a PHP script in a higher directory (e.g., `/files/`), where it can be executed, enabling RCE.

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

### Step 4: Upload the Web Shell
1. Return to the avatar upload functionality and upload `exploit.php`.
2. **Observation**: The upload is successful, indicating no restriction on PHP file extensions.

### Step 5: Test Web Shell Execution
1. In the Repeater tab containing the `GET /files/avatars/<YOUR-IMAGE>` request, modify the path to:
   ```http
   GET /files/avatars/exploit.php HTTP/1.1
   ```
2. Send the request.
3. **Observation**: The server returns the contents of `exploit.php` as plain text, indicating that PHP files in `/files/avatars/` are not executed.

### Step 6: Identify the Upload Request
1. In Burp Suite, return to **Proxy > HTTP history** and locate the `POST /my-account/avatar` request used for the file upload.
2. Right-click the request and select **Send to Repeater**.

### Step 7: Attempt Path Traversal
1. In the Repeater tab containing the `POST /my-account/avatar` request, locate the part of the request body related to the uploaded file.
2. Modify the `Content-Disposition` header to include a path traversal sequence:
   ```
   Content-Disposition: form-data; name="avatar"; filename="../exploit.php"
   ```
3. Send the request.
4. **Observation**: The response indicates `The file avatars/exploit.php has been uploaded`, suggesting the server strips the `../` from the filename.

### Step 8: Obfuscate Path Traversal
1. Obfuscate the path traversal by URL-encoding the forward slash (`/`):
   ```
   Content-Disposition: form-data; name="avatar"; filename="..%2fexploit.php"
   ```
2. Send the modified request.
3. **Observation**: The response confirms `The file avatars/../exploit.php has been uploaded`, indicating the server decodes the filename and places the file in a higher directory (`/files/`).

### Step 9: Execute the Web Shell
1. In Burp Suite, go to **Proxy > HTTP history** and locate the `GET /files/avatars/..%2fexploit.php` request, or manually craft a request in Repeater:
   ```http
   GET /files/exploit.php HTTP/1.1
   ```
2. Send the request.
3. **Observation**: The server executes the PHP script, and the response contains the contents of `/home/carlos/secret`, confirming the file was uploaded to `/files/` and executed.

### Step 10: Submit the Secret
1. Copy the secret from the Repeater response.
2. Submit the secret via the lab’s submission mechanism.
3. **Observation**: Submitting the correct secret solves the lab.

### Step 11: Verify Success
1. If the lab does not confirm completion, verify:
   - The `filename="..%2fexploit.php"` is correctly URL-encoded.
   - The `GET /files/exploit.php` request targets the correct path.
   - The PHP script syntax and file path `/home/carlos/secret` are accurate.
2. **Observation**: Successful retrieval and submission of the secret completes the lab.