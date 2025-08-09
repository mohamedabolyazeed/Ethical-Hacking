# Exploiting Web Shell Upload via Obfuscated File Extension

This guide provides a clear, creative, and organized solution to exploit a **web shell upload** vulnerability by obfuscating the file extension with a null byte. The objective is to upload a malicious PHP script as an avatar, bypass the JPG/PNG restriction, execute the script to retrieve the contents of Carlos's secret file (`/home/carlos/secret`), and submit the secret to solve the lab.

## Objective
Bypass the file extension restriction using a URL-encoded null byte (`%00`) in the filename, upload a PHP web shell, execute it to read a sensitive file, and submit the secret.

## Prerequisites
- Burp Suite with Proxy and Repeater modules configured.
- A user account with access to the avatar upload feature.
- Basic understanding of web shells, PHP scripting, and null byte injection.

## Background on the Vulnerability
The application restricts avatar uploads to JPG and PNG files but processes filenames in a way that allows null byte (`%00`) injection. By appending `%00.jpg` to a `.php` filename, the server strips the extension after the null byte, storing the file as `.php` while bypassing validation, enabling remote code execution (RCE).

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
2. **Observation**: The response indicates that only JPG and PNG files are allowed, confirming an extension restriction.

### Step 5: Identify the Upload Request
1. In Burp Suite, return to **Proxy > HTTP history** and locate the `POST /my-account/avatar` request used for the file upload.
2. Right-click the request and select **Send to Repeater**.

### Step 6: Obfuscate the File Extension with Null Byte
1. In the Repeater tab containing the `POST /my-account/avatar` request, locate the part of the request body related to the uploaded file.
2. Modify the `Content-Disposition` header to obfuscate the filename with a URL-encoded null byte (`%00`) followed by `.jpg`:
   ```
   Content-Disposition: form-data; name="avatar"; filename="exploit.php%00.jpg"
   ```
3. **Explanation**: The null byte terminates the filename processing, stripping `.jpg` and storing the file as `exploit.php`.
4. Send the request.
5. **Observation**: The file is successfully uploaded, and the response refers to it as `exploit.php`, confirming the null byte bypass.

### Step 7: Execute the Web Shell
1. In the Repeater tab containing the `GET /files/avatars/<YOUR-IMAGE>` request, modify the path to:
   ```http
   GET /files/avatars/exploit.php HTTP/1.1
   ```
2. Send the request.
3. **Observation**: The server executes the PHP script, and the response contains the contents of `/home/carlos/secret`.

### Step 8: Submit the Secret
1. Copy the secret from the Repeater response.
2. Submit the secret via the lab’s submission mechanism.
3. **Observation**: Submitting the correct secret solves the lab.

### Step 9: Verify Success
1. If the lab does not confirm completion, verify:
   - The `filename="exploit.php%00.jpg"` is correctly formatted with the URL-encoded null byte.
   - The `GET /files/avatars/exploit.php` request targets the correct path.
   - The PHP script syntax and file path `/home/carlos/secret` are accurate.
2. **Observation**: Successful retrieval and submission of the secret completes the lab.