# Exploiting SSRF with Whitelist-Based Input Filter Bypass

This guide delivers a clear, creative, and organized walkthrough to exploit a **Server-Side Request Forgery (SSRF)** vulnerability by bypassing a whitelist-based input filter. Picture yourself as a digital alchemist, crafting a cunning URL potion to trick the server into opening its secret admin vault! The objective is to manipulate the `stockApi` parameter with embedded credentials and double-URL encoding to access the internal admin interface and delete the user `carlos`, solving the lab.

## Objective
Bypass the whitelist filter on the `stockApi` parameter by exploiting URL parsing with embedded credentials and double-URL encoding, access the internal admin panel, and delete the user `carlos`.

## Prerequisites
- Burp Suite with Proxy and Repeater modules configured.
- Access to the lab application with a product page and stock check feature.
- Basic understanding of SSRF, URL parsing, and encoding techniques.

## Background on the Vulnerability
The stock check feature allows the `stockApi` parameter to specify URLs, but the server validates the hostname against a whitelist (e.g., `stock.weliketoshop.net`). The URL parser supports embedded credentials (e.g., `username@host`), and improper handling of special characters like `#` allows attackers to trick the server into making requests to internal hosts like `localhost`, enabling SSRF to access restricted endpoints.

## Steps to Solve the Lab

### Step 1: Capture the Stock Check Request
1. Visit a product page and click **Check stock**.
2. In Burp Suite, go to **Proxy > HTTP history** and locate the `POST /product/stock` request.
3. Right-click the request and select **Send to Repeater**.
4. **Observation**: The request includes a `stockApi` parameter (e.g., `/stock/check?productId=1&storeId=1`), which is vulnerable but filtered.


### Step 2: Test Whitelist Filtering
1. In Repeater, modify the `stockApi` parameter to target the local server:
   ```
   stockApi=http://127.0.0.1/
   ```
2. Send the request.
3. **Observation**: The request is blocked, indicating the server parses the URL and validates the hostname against a whitelist.

![payload suc](./img/SSRF%20with%20whitelist-based%20input%20filter/SSRF%20with%20whitelist-based%20input%20filter(1).png)

### Step 3: Test Embedded Credentials
1. Change the `stockApi` parameter to include embedded credentials with a whitelisted hostname:
   ```
   stockApi=http://username@stock.weliketoshop.net/
   ```
2. Send the request.
3. **Observation**: The request is accepted, confirming that the URL parser supports embedded credentials and only checks the hostname (`stock.weliketoshop.net`).

![payload suc](./img/SSRF%20with%20whitelist-based%20input%20filter/SSRF%20with%20whitelist-based%20input%20filter(2).png)

### Step 4: Test Special Characters
1. Append a `#` to the username:
   ```
   stockApi=http://username#@stock.weliketoshop.net/
   ```
2. Send the request.
3. **Observation**: The request is rejected, suggesting the `#` disrupts parsing or validation.

![payload suc](./img/SSRF%20with%20whitelist-based%20input%20filter/SSRF%20with%20whitelist-based%20input%20filter(3).png)

### Step 5: Obfuscate with Double-URL Encoding
1. Double-URL encode the `#` character:
   - `#` → URL encode → `%23`
   - `%23` → URL encode again → `%2523`
2. Update the `stockApi` parameter:
   ```
   stockApi=http://username%2523@stock.weliketoshop.net/
   ```
3. Send the request.
4. **Observation**: The response returns an "Internal Server Error," indicating the server attempted to connect to `username` as a hostname, revealing a parsing flaw.

![payload suc](./img/SSRF%20with%20whitelist-based%20input%20filter/SSRF%20with%20whitelist-based%20input%20filter(4).png)

### Step 6: Test Access to Internal Host
1. Craft a URL to target `localhost` using the double-encoded `#`:
   ```
   stockApi=http://localhost:80%2523@stock.weliketoshop.net/
   ```
2. Send the request.
3. **Observation**: The response indicates the server connected to `localhost`, confirming the bypass of the whitelist filter.

![payload suc](./img/SSRF%20with%20whitelist-based%20input%20filter/SSRF%20with%20whitelist-based%20input%20filter(5).png)

### Step 7: Access the Admin Panel
1. Modify the `stockApi` parameter to target the admin interface:
   ```
   stockApi=http://localhost:80%2523@stock.weliketoshop.net/admin
   ```
2. Send the request.
3. **Observation**: The response contains the admin panel HTML, confirming successful access to the internal endpoint.

![payload suc](./img/SSRF%20with%20whitelist-based%20input%20filter/SSRF%20with%20whitelist-based%20input%20filter(6).png)

### Step 8: Delete the User `carlos`
1. Update the `stockApi` parameter to target the delete endpoint:
   ```
   stockApi=http://localhost:80%2523@stock.weliketoshop.net/admin/delete?username=carlos
   ```
2. Send the request.
3. **Observation**: The server processes the request, deleting the user `carlos`, which solves the lab.

![payload suc](./img/SSRF%20with%20whitelist-based%20input%20filter/SSRF%20with%20whitelist-based%20input%20filter(7).png)

### Step 9: Verify Success
1. If the lab does not confirm completion, verify:
   - The `stockApi` URL uses `localhost:80%2523@stock.weliketoshop.net` correctly.
   - The delete path (`/admin/delete?username=carlos`) is accurate.
   - The request is sent as a `POST` to `/product/stock`.
2. **Observation**: Successful deletion of `carlos` completes the lab.

![payload suc](./img/SSRF%20with%20whitelist-based%20input%20filter/SSRF%20with%20whitelist-based%20input%20filter(8).png)