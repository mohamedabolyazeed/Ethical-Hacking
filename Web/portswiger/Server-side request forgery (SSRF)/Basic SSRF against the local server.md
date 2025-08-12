# Exploiting Basic Server-Side Request Forgery (SSRF) Against the Local Server

This guide delivers a clear, creative, and organized walkthrough to exploit a **Server-Side Request Forgery (SSRF)** vulnerability. Picture yourself as a digital infiltrator, tricking the server into revealing its hidden admin panel and deleting a target user with a single, well-crafted request! The objective is to manipulate the `stockApi` parameter to access and interact with the local server's admin interface, deleting the user `carlos` to solve the lab.

## Objective
Use SSRF to access the restricted `/admin` endpoint on the local server, identify the URL to delete the user `carlos`, and execute the deletion via the `stockApi` parameter.

## Prerequisites
- Burp Suite with Proxy and Repeater modules configured.
- Access to the lab application with a product page and stock check feature.
- Basic understanding of SSRF and HTTP request manipulation.

## Background on the Vulnerability
The application’s stock check feature sends a user-controlled `stockApi` URL to the server, which fetches it without proper validation. This allows an attacker to force the server to make requests to internal endpoints (e.g., `http://localhost/admin`), bypassing access controls and enabling unauthorized actions like user deletion.

## Steps to Solve the Lab

### Step 1: Test Access to the Admin Panel
1. In the browser, navigate to `/admin`.
2. **Observation**: Direct access to the admin page is blocked, indicating restricted access.

### Step 2: Capture the Stock Check Request
1. Visit a product page and click **Check stock**.
2. In Burp Suite, go to **Proxy > HTTP history** and locate the `POST /product/stock` request.
3. Right-click the request and select **Send to Repeater**.
4. **Observation**: The request includes a `stockApi` parameter (e.g., `/stock/check?productId=1&storeId=1`), which the server fetches.

### Step 3: Exploit SSRF to Access the Admin Panel
1. In Repeater, modify the `stockApi` parameter to point to the local admin endpoint:
   ```
   stockApi=http://localhost/admin
   ```
2. Send the request.
3. **Observation**: The response contains the HTML of the admin interface, confirming SSRF vulnerability.

### Step 4: Identify the Delete User URL
1. Inspect the response HTML to locate the URL for deleting a user.
2. **Observation**: The URL to delete the user `carlos` is:
   ```
   http://localhost/admin/delete?username=carlos
   ```

### Step 5: Execute the Delete Action via SSRF
1. In Repeater, update the `stockApi` parameter to the delete URL:
   ```
   stockApi=http://localhost/admin/delete?username=carlos
   ```
2. Send the request.
3. **Observation**: The server processes the request, deleting the user `carlos`, which solves the lab.

![payload suc](./img/Basic%20SSRF%20against%20the%20local%20server/Basic%20SSRF%20against%20the%20local%20server(1).png)
![payload suc](./img/Basic%20SSRF%20against%20the%20local%20server/Basic%20SSRF%20against%20the%20local%20server(2).png)
![payload suc](./img/Basic%20SSRF%20against%20the%20local%20server/Basic%20SSRF%20against%20the%20local%20server(3).png)

### Step 6: Verify Success
1. If the lab does not confirm completion, verify:
   - The `stockApi` URL is correctly formatted (`http://localhost/admin/delete?username=carlos`).
   - The request is sent as a `POST` to `/product/stock`.
   - The response indicates a successful operation (e.g., a 200 OK or redirect).
2. **Observation**: Successful deletion of `carlos` completes the lab.