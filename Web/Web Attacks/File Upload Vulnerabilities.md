
# File Upload Vulnerabilities

### What are File Upload Vulnerabilities?
These occur when a server allows users to upload files without sufficient validation. This could enable attackers to upload malicious files, including server-side scripts, leading to remote code execution (RCE).

---

### How to Find This Vulnerability:
1. **Attempt to upload a malicious file** (e.g., .php).
2. **Use steganography** to hide scripts in image files.
3. **Bypass file extension restrictions:**
   - If the server only checks content types, modify the content type header to bypass restrictions.
   - Test for alternative executable extensions like `.php5`, `.phtml`, etc.

### Scenario (Collected from PortSwigger Labs)

#### 1. No Restrictions:
**Outcome**: Allows uploading of any file without limitations.

#### 2. Requires Content Type image/jpg:
**Behavior**: The server only checks the content type and not the file extension.  
**Bypass**: Modify the content type header to match the required `image/jpg`.

#### 3. Directory Restrictions:
**Behavior**: The uploaded file is placed in a directory where execution is restricted.  
**Bypass**: Attempt to change the directory to one that allows execution.

#### 4. PHP File Upload Restriction:
**Behavior**: The server blocks files with `.php` extensions by blacklisting executable file types.  
**Bypass**: Check if alternative executable extensions like `.phtml`, `.php5`, or similar are allowed.

---

### How to Protect Against File Upload Vulnerabilities:
1. **Limit Allowed File Types:**
   - Example in PHP:
   ```php
   $allowed_types = ['image/jpeg', 'image/png', 'application/pdf'];
   if (!in_array($_FILES['file']['type'], $allowed_types)) {
       die('File type not allowed');
   }
   ```

2. **Check File Content:**
   - Verify files using `getimagesize()` for images.

3. **Restrict File Size:**
   - Example:
   ```php
   $max_size = 5 * 1024 * 1024; // 5 MB
   if ($_FILES['file']['size'] > $max_size) {
       die('File size exceeds the allowed limit');
   }
   ```

4. **Store Files Outside the Web Root:**
   - Use directories like `/var/uploads/` to store files, preventing direct access.

5. **Disable Script Execution:**
   - Example for Apache (.htaccess):
   ```apache
   php_flag engine off
   ```

---

### Impacts of File Upload Vulnerabilities:
1. **Remote Code Execution (RCE):**  
   Attackers can execute arbitrary code and gain full control of the server.
   
2. **Unauthorized Access:**  
   Sensitive data can be exposed.

3. **Website Defacement:**  
   Malicious content can replace legitimate website content.

4. **Denial of Service (DoS):**  
   Uploading large or resource-intensive files can exhaust server resources.

5. **Privilege Escalation:**  
   Malicious files can grant administrative access.

6. **Malware Distribution:**  
   Uploaded files can contain viruses or ransomware.

7. **Data Integrity Compromise:**  
   Critical business data can be altered or corrupted.

---
