# Exploiting Routing-Based SSRF

This guide delivers a clear, creative, and organized walkthrough to exploit a **Routing-Based Server-Side Request Forgery (SSRF)** vulnerability. Imagine yourself as a digital cartographer, mapping hidden internal networks to infiltrate a restricted admin stronghold and eliminate the user `carlos`! The objective is to manipulate the `Host` header to probe internal IPs, access the admin panel, and craft a request to delete `carlos`, solving the lab.

## Objective
Use SSRF to brute-force internal IP addresses via the `Host` header, access the admin panel, and delete the user `carlos` by crafting a POST request with the correct session and CSRF tokens.

## Prerequisites
- Burp Suite with Proxy, Repeater, Intruder, and Collaborator modules configured.
- Access to the lab application with a homepage and admin panel.
- Basic understanding of SSRF, HTTP headers, and session/CSRF token handling.

## Background on the Vulnerability
The application’s middleware processes the `Host` header to route requests, allowing SSRF to target internal IPs. By manipulating the `Host` header, attackers can probe internal networks, access restricted endpoints like `/admin`, and perform actions such as user deletion, bypassing external access controls.

## Steps to Solve the Lab

### Step 1: Test Host Header Manipulation
1. In Burp Suite, go to **Proxy > HTTP history** and locate the `GET /` request that returns a 200 OK response.
2. Right-click and select **Send to Repeater**.
3. In Repeater, highlight the `Host` header value, right-click, and select **Insert Collaborator payload** to replace it with a Burp Collaborator domain (e.g., `xyz.burpcollaborator.net`).
4. Send the request.
5. Go to the **Collaborator** tab and click **Poll now**.
6. **Observation**: The table shows network interactions, including an HTTP request, confirming the middleware sends requests to arbitrary hosts.

### Step 2: Brute-Force Internal IPs
1. In Proxy history, right-click the `GET /` request and select **Send to Intruder**.
2. In Intruder, go to the **Target** tab and deselect **Update Host header to match target**.
3. In the **Positions** tab, replace the `Host` header value with:
   ```
   Host: 192.168.0.§0§
   ```
4. Go to the **Payloads** tab, set **Payload type** to **Numbers**, and configure:
   - **From**: 0
   - **To**: 255
   - **Step**: 1
5. Click **Start attack** (ignore the warning about the Host header mismatch).
6. When the attack finishes, sort results by the **Status** column.
7. **Observation**: A single request with a 302 response redirects to `/admin`, indicating the correct internal IP (e.g., `192.168.0.X`).

### Step 3: Access the Admin Panel
1. Right-click the 302 response in Intruder and select **Send to Repeater**.
2. In Repeater, change the request line to:
   ```
   GET /admin HTTP/1.1
   Host: 192.168.0.X
   ```
   (Replace `X` with the discovered octet.)
3. Send the request.
4. **Observation**: The response contains the admin panel HTML, including a form for deleting users.

### Step 4: Analyze the Delete Functionality
1. Study the admin panel response. The delete form uses a `POST` request to `/admin/delete` with:
   - A `csrf` token parameter.
   - A `username` parameter.
2. Note the `Set-Cookie` header in the response, containing a session cookie.

### Step 5: Craft the Delete Request
1. In Repeater, modify the request line to:
   ```
   GET /admin/delete?csrf=QCT5OmPeAAPnyTKyETt29LszLL7CbPop&username=carlos HTTP/1.1
   Host: 192.168.0.X
   ```
   (Replace the `csrf` token with the one from the admin panel response.)
2. Add the session cookie from the `Set-Cookie` header:
   ```
   Cookie: session=your-session-token
   ```
3. Right-click the request and select **Change request method** to convert it to:
   ```
   POST /admin/delete?csrf=QCT5OmPeAAPnyTKyETt29LszLL7CbPop&username=carlos HTTP/1.1
   Host: 192.168.0.X
   Cookie: session=your-session-token
   ```
4. Send the request.
5. **Observation**: The server processes the request, deleting the user `carlos`, solving the lab.

### Step 6: Verify Success
1. If the lab does not confirm completion, verify:
   - The `Host` header uses the correct internal IP (`192.168.0.X`).
   - The `csrf` token and session cookie are accurate.
   - The request is a `POST` to `/admin/delete?csrf=...&username=carlos`.
2. **Observation**: Successful deletion of `carlos` completes the lab.