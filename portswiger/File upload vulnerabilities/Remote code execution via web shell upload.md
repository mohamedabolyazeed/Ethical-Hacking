# Exploiting Remote Code Execution via Web Shell Upload

This guide provides a clear, creative, and organized solution to exploit a **web shell upload** vulnerability, enabling remote code execution (RCE). The objective is to upload a malicious PHP script disguised as an avatar image, execute it to retrieve the contents of a sensitive file (`/home/carlos/secret`), and submit the secret to solve the lab.

## Objective
Upload a PHP web shell via the avatar upload functionality, execute it to read Carlos's secret file, and submit the secret to complete the lab.

## Prerequisites
- Burp Suite with Proxy and Repeater modules configured.
- A user account with access to the avatar upload feature.
- Basic understanding of web shells and PHP scripting.

## Background on the Vulnerability
The application allows users to upload avatar images without proper validation of file types or content. By uploading a malicious PHP script disguised as an image, an attacker can execute arbitrary code on the server, leading to RCE. In this lab, we exploit this to read a sensitive file and extract its contents.

## Steps to Solve the Lab

### Step 1: Log In and Test Avatar Upload
1. Log in to your account while proxying traffic through Burp Suite.
2. Navigate to the account page and locate the **avatar upload** option.
3. Upload an arbitrary image file (e.g., a `.jpg` or `.png`).
4. Return to the account page.
5. **Observation**: The uploaded image is displayed as a preview, indicating the avatar is stored and accessible.

### Step 2: Identify the Avatar Retrieval Request
1. In Burp Suite, go to **Proxy > HTTP history**.
2. Click the filter bar to open the HTTP history filter window.
3. Under **Filter by MIME type**, enable the **Images** checkbox and apply the changes.
4. Locate the `GET` request fetching the uploaded image, e.g., `GET /files/avatars/<YOUR-IMAGE>`.
5. Right-click the request and select **Send to Repeater**.

### Step 3: Create a Malicious PHP Web Shell
1. On your local system, create a file named `exploit.php` with the following content:
   ```php
   <?php echo file_get_contents('/home/carlos/secret'); ?>
   ```
2. **Explanation**: This PHP script reads and outputs the contents of the file `/home/carlos/secret`.

### Step 4: Upload the Web Shell
1. Return to the avatar upload functionality in the application.
2. Upload the `exploit.php` file as if it were an image.
3. **Observation**: The response confirms successful upload, indicating the server did not validate the file type.

### Step 5: Execute the Web Shell
1. In Burp Repeater, modify the `GET` request from Step 2 to point to the uploaded PHP file:
   ```http
   GET /files/avatars/exploit.php HTTP/1.1
   ```
2. Send the request.
3. **Observation**: The server executes the PHP script, and the response contains the contents of `/home/carlos/secret`.

### Step 6: Submit the Secret
1. Copy the secret from the Repeater response.
2. Submit the secret via the lab’s submission mechanism.
3. **Observation**: Submitting the correct secret solves the lab.

### Step 7: Verify Success
1. If the lab does not confirm completion, verify:
   - The `exploit.php` file was uploaded successfully.
   - The Repeater request correctly targets `/files/avatars/exploit.php`.
   - The PHP script syntax is correct and the file path `/home/carlos/secret` is accurate.
2. **Observation**: Successful retrieval and submission of the secret completes the lab.