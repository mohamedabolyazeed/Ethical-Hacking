# Host Header Vulnerabilities

This guide provides a clear, practical, and organized resource for testing **Host header-based vulnerabilities** on external websites during authorized security assessments. Designed for real-world applications beyond controlled lab environments like PortSwigger, it leverages common `Host` header values (`localhost`, `test`, `dev`, `stage`) and other techniques to identify vulnerabilities such as **Server-Side Request Forgery (SSRF)**, **authentication bypass**, or **web cache poisoning**. Always ensure you have explicit permission to test any external site to stay compliant with legal and ethical standards.

## Objective
Learn how to test for `Host` header vulnerabilities using alternative values and techniques to identify misconfigurations that could allow unauthorized access to internal resources, cache manipulation, or other exploits.

## Prerequisites
- **Tools**: Burp Suite (Proxy, Repeater, Intruder) or similar HTTP interception tools.
- **Authorization**: Explicit permission from the website owner to perform security testing (e.g., via a bug bounty program or contract).
- **Knowledge**: Basic understanding of HTTP headers, SSRF, authentication bypass, and web caching.
- **Environment**: A safe testing setup, avoiding production systems unless explicitly permitted.

## Background on Host Header Vulnerabilities
The `Host` header in HTTP requests specifies the target domain, but weak validation can lead to:
- **SSRF**: Tricking the server to make requests to internal hosts (e.g., `localhost` or private IPs).
- **Authentication Bypass**: Accessing restricted endpoints by posing as a trusted host.
- **Cache Poisoning**: Injecting malicious hosts to serve harmful content to users.
- **Routing Issues**: Exploiting misconfigured middleware or load balancers.

Common hostnames like `localhost`, `test`, `dev`, and `stage` are often used in development or internal systems and may be overlooked in validation, making them prime candidates for testing.

## Testing Methodology

### Step 1: Understand the Application
1. **Map the Application**:
   - Browse the website and identify key functionalities (e.g., login, password reset, API endpoints, or redirects).
   - Check for `/robots.txt`, `/sitemap.xml`, or error messages that reveal internal paths (e.g., `/admin`, `/api`).
2. **Identify Host-Sensitive Features**:
   - Look for features like password resets, file imports, or API calls that may rely on the `Host` header.
   - Note any external URL inputs (e.g., webhooks, stock check APIs) that could be vulnerable to SSRF.

### Step 2: Capture and Analyze Requests
1. **Intercept Traffic**:
   - Use Burp Suite’s Proxy to capture HTTP requests (e.g., `GET /`, `POST /api`).
   - Send relevant requests to Repeater for manual testing or Intruder for automated probing.
2. **Examine Host Header Behavior**:
   - Modify the `Host` header to an arbitrary value (e.g., `example.com`) and observe the response:
     ```
     GET / HTTP/1.1
     Host: example.com
     ```
   - **Observation**: Responses like 200 OK, redirects, or errors may indicate loose validation.

### Step 3: Test Alternative Host Values
1. **Try Common Hostnames**:
   - Based on the `README.md`, test these values in the `Host` header:
     - `localhost`
     - `test`
     - `dev`
     - `stage`
   - Example in Repeater:
     ```
     GET /admin HTTP/1.1
     Host: localhost
     ```
   - Test variations:
     - With ports: `localhost:80`, `localhost:8080`
     - Subdomains: `test.local`, `dev.internal`, `stage.example.com`
     - Internal IPs: `127.0.0.1`, `192.168.0.1`, `10.0.0.1`
2. **Observation**:
   - **Success**: Responses containing sensitive data (e.g., admin panel HTML) or functionality (e.g., user deletion) indicate a bypass.
   - **Failure**: Errors or redirects suggest stricter validation, but try other values or techniques.

### Step 4: Explore SSRF Scenarios
1. **Target Internal Endpoints**:
   - Test paths like `/admin`, `/api`, `/debug`, or `/metrics` with alternative hosts:
     ```
     GET /admin HTTP/1.1
     Host: dev
     ```
2. **Probe Internal IPs**:
   - Use Intruder to brute-force IP ranges (e.g., `192.168.0.1` to `192.168.0.255`):
     ```
     Host: 192.168.0.§1§
     ```
     - Payload settings: Numbers, 1 to 255, step 1.
   - **Observation**: Look for 200 OK or 302 redirects indicating internal resource access.
3. **Test Cloud Metadata**:
   - For cloud-hosted apps, try SSRF against metadata endpoints:
     ```
     Host: 169.254.169.254
     ```
     - Common for AWS, GCP, or Azure metadata services.

### Step 5: Test Cache Poisoning
1. **Inject Malicious Hosts**:
   - Add a second `Host` header or manipulate the first:
     ```
     GET /?cb=123 HTTP/1.1
     Host: legitimate.com
     Host: attacker.com
     ```
   - Check if the response reflects the malicious host in scripts, links, or redirects.
2. **Poison the Cache**:
   - Host a malicious file (e.g., `alert(document.cookie)`) at `attacker.com/path`.
   - Re-send requests until the cache is poisoned (consistent response with malicious host).
   - Test in a browser to confirm payload execution.

### Step 6: Test Authentication Bypass
1. **Access Restricted Endpoints**:
   - Target admin or sensitive paths (e.g., `/admin/delete?username=target`):
     ```
     GET /admin HTTP/1.1
     Host: stage
     ```
   - **Observation**: Access to admin panels or user actions (e.g., deletion) indicates a bypass.
2. **Craft POST Requests**:
   - If forms require CSRF tokens or cookies, extract them from successful responses and craft requests:
     ```
     POST /admin/delete HTTP/1.1
     Host: localhost
     Cookie: session=your-session-token
     Content-Type: application/x-www-form-urlencoded
     
     csrf=your-csrf-token&username=target
     ```

### Step 7: Document and Report
1. **Record Findings**:
   - Note which `Host` values (e.g., `localhost`, `dev`) triggered vulnerabilities.
   - Capture request/response pairs showing successful bypasses or sensitive data exposure.
2. **Ethical Reporting**:
   - If testing in a bug bounty program, submit findings with clear evidence, impact, and remediation steps.
   - Avoid exploiting beyond proof-of-concept without permission.

## Success!
You’ve wielded a versatile toolkit of `Host` header tricks, probing external sites for weaknesses and uncovering potential exploits with finesse, all while staying ethical!

## Key Takeaways
- **Host Header Flexibility**: Values like `localhost`, `test`, `dev`, and `stage` exploit weak validation in routing, authentication, or caching.
- **Impact**: Vulnerabilities can lead to SSRF, authentication bypass, or cache poisoning, compromising sensitive data or functionality.
- **Mitigation**: Validate `Host` headers against a strict whitelist, normalize inputs, and secure internal endpoints.
- **Testing Tip**: Use Burp Repeater for manual tests, Intruder for brute-forcing IPs, and Collaborator for detecting external requests.

## Additional Host Values to Test
Beyond the `README.md` values (`localhost`, `test`, `dev`, `stage`), consider:
- **Internal IPs**: `127.0.0.1`, `192.168.0.1`, `10.0.0.1`, `172.16.0.1`
- **Cloud Metadata**: `169.254.169.254` (AWS/GCP/Azure)
- **Subdomains**: `internal`, `staging`, `prod`, `test.local`, `dev.example.com`
- **Ports**: `localhost:8080`, `localhost:8000`
- **Bypass Tricks**: `127.1`, `0.0.0.0`, or double `Host` headers.

## Legal and Ethical Notes
- **Permission is Critical**: Only test websites where you have explicit authorization (e.g., bug bounty programs or client engagements).
- **Scope Compliance**: Adhere to the scope and rules of engagement to avoid legal issues.
- **Responsible Disclosure**: Report vulnerabilities promptly with detailed evidence and suggested fixes.
- **Avoid Harm**: Do not exploit vulnerabilities beyond proof-of-concept or access sensitive user data without permission.