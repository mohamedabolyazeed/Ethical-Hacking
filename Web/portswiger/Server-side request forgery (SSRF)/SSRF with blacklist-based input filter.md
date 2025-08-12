# Exploiting SSRF with Blacklist-Based Input Filter Bypass

This guide delivers a clear, creative, and organized walkthrough to exploit a **Server-Side Request Forgery (SSRF)** vulnerability by bypassing a blacklist-based input filter. Imagine outsmarting a vigilant gatekeeper by slipping through with a cleverly disguised address! The objective is to manipulate the `stockApi` parameter to access the internal admin interface on `127.0.0.1`, bypass the blacklist using obfuscation, and delete the user `carlos` to solve the lab.

## Objective
Bypass the blacklist filter blocking `127.0.0.1` and `/admin` by using alternative IP representations and double-URL encoding, access the admin panel, and delete the user `carlos` via SSRF.

## Prerequisites
- Burp Suite with Proxy and Repeater modules configured.
- Access to the lab application with a product page and stock check feature.
- Basic understanding of SSRF, URL encoding, and blacklist bypass techniques.

## Background on the Vulnerability
The application’s stock check feature allows the `stockApi` parameter to specify URLs for server-side requests, but a blacklist filter blocks `127.0.0.1` and certain paths like `/admin`. By using alternative IP notations (e.g., `127.1`) and obfuscating sensitive keywords (e.g., double-URL encoding `a` in `admin`), attackers can bypass the filter and access internal endpoints, enabling unauthorized actions.

## Steps to Solve the Lab

### Step 1: Capture the Stock Check Request
1. Visit a product page and click **Check stock**.
2. In Burp Suite, go to **Proxy > HTTP history** and locate the `POST /product/stock` request.
3. Right-click the request and select **Send to Repeater**.
4. **Observation**: The request includes a `stockApi` parameter (e.g., `/stock/check?productId=1&storeId=1`), which is vulnerable to SSRF.

### Step 2: Test for Blacklist Filtering
1. In Repeater, modify the `stockApi` parameter to target the local server:
   ```
   stockApi=http://localhost/
   stockApi=http://127.0.0.1/
   ```
2. Send the request.
3. **Observation**: The request is blocked, indicating a blacklist filter for `localhost`.
4. **Observation**: The request is blocked, indicating a blacklist filter for `127.0.0.1`.

![payload suc](./img/SSRF%20with%20blacklist-based%20input%20filter/SSRF%20with%20blacklist-based%20input%20filter(1).png)
![payload suc](./img/SSRF%20with%20blacklist-based%20input%20filter/SSRF%20with%20blacklist-based%20input%20filter(2).png)

### Step 3: Bypass the IP Blacklist
1. Change the `stockApi` parameter to use an alternative representation of `127.0.0.1`:
   ```
   stockApi=http://127.1/
   ```
2. Send the request.
3. **Observation**: The request succeeds, confirming that `127.1` bypasses the blacklist while resolving to `127.0.0.1`.

![payload suc](./img/SSRF%20with%20blacklist-based%20input%20filter/SSRF%20with%20blacklist-based%20input%20filter(3).png)

### Step 4: Attempt to Access the Admin Panel
1. Modify the `stockApi` parameter to access the admin interface:
   ```
   stockApi=http://127.1/admin
   ```
2. Send the request.
3. **Observation**: The request is blocked again, suggesting the `/admin` path is blacklisted.

![payload suc](./img/SSRF%20with%20blacklist-based%20input%20filter/SSRF%20with%20blacklist-based%20input%20filter(6).png)

### Step 5: Obfuscate the Admin Path
1. Obfuscate the letter `a` in `admin` using double-URL encoding:
   - `a` → URL encode → `%61`
   - `%61` → URL encode again → `%2561`
2. Update the `stockApi` parameter:
   ```
   stockApi=http://127.1/%2561dmin
   ```

![payload suc](./img/SSRF%20with%20blacklist-based%20input%20filter/SSRF%20with%20blacklist-based%20input%20filter(7).png)
![payload suc](./img/SSRF%20with%20blacklist-based%20input%20filter/SSRF%20with%20blacklist-based%20input%20filter(8).png)

3. Send the request.
4. **Observation**: The response contains the admin panel HTML, confirming successful bypass of the blacklist.

### Step 6: Delete the User `carlos`
1. From the admin panel HTML (or prior knowledge), identify the delete endpoint: `/admin/delete?username=carlos`.
2. Modify the `stockApi` parameter to include the obfuscated delete URL:
   ```
   stockApi=http://127.1/%2561dmin/delete?username=carlos
   ```
3. Send the request.
4. **Observation**: The server processes the request, deleting the user `carlos`, which solves the lab.

![payload suc](./img/SSRF%20with%20blacklist-based%20input%20filter/SSRF%20with%20blacklist-based%20input%20filter(9).png)

### Step 7: Verify Success
1. If the lab does not confirm completion, verify:
   - The `stockApi` URL uses `127.1` and `%2561dmin` correctly.
   - The request is sent as a `POST` to `/product/stock`.
   - The response indicates a successful deletion (e.g., 200 OK or redirect).
2. **Observation**: Successful deletion of `carlos` completes the lab.