# Exploiting Basic Server-Side Request Forgery (SSRF) Against a Back-End System

This guide delivers a clear, creative, and organized walkthrough to exploit a **Server-Side Request Forgery (SSRF)** vulnerability targeting an internal back-end system. Envision yourself as a network explorer, scanning hidden IP ranges to uncover a secret admin panel and eliminate a target user with precision strikes! The objective is to brute-force internal IP addresses via the `stockApi` parameter, access the admin interface on a back-end server, and delete the user `carlos` to solve the lab.

## Objective
Brute-force internal IP addresses to locate and access a hidden admin panel on a back-end system, then delete the user `carlos` using SSRF.

## Prerequisites
- Burp Suite with Proxy, Repeater, and Intruder modules configured.
- Access to the lab application with a product page and stock check feature.
- Basic understanding of SSRF, IP scanning, and Burp Intruder.

## Background on the Vulnerability
The stock check feature sends a user-controlled `stockApi` URL to the server, which fetches it without restricting internal IPs. This allows SSRF to probe back-end systems (e.g., `192.168.0.x`), accessing restricted endpoints like `/admin` and performing actions such as user deletion.

## Steps to Solve the Lab

### Step 1: Capture the Stock Check Request
1. Visit a product page and click **Check stock**.
2. In Burp Suite, go to **Proxy > HTTP history** and locate the `POST /product/stock` request.
3. Right-click the request and select **Send to Intruder**.
4. **Observation**: The request includes a `stockApi` parameter (e.g., `/stock/check?productId=1&storeId=1`), vulnerable to manipulation.

### Step 2: Brute-Force Internal IP Addresses
1. In Burp Intruder, go to the **Positions** tab.
2. Change the `stockApi` parameter to `http://192.168.0.1:8080/admin`.
3. Highlight the last octet of the IP (e.g., `1`) and click **Add §** to mark it as a payload position.
4. Go to the **Payloads** tab.
5. Set **Payload type** to **Numbers**.
6. Configure:
   - **From**: 1
   - **To**: 255
   - **Step**: 1
7. Click **Start attack**.
8. **Observation**: The attack scans `192.168.0.1` to `192.168.0.255`. Sort results by **Status** (ascending) to find a 200 OK response, indicating the admin interface.

### Step 3: Access the Admin Panel
1. Select the 200 OK request from the Intruder results.
2. Right-click and select **Send to Repeater**.
3. **Observation**: The response contains the admin panel HTML, confirming SSRF access to the back-end system.

### Step 4: Delete the User `carlos`
1. In Repeater, modify the `stockApi` parameter to the delete endpoint:
   ```
   stockApi=http://192.168.0.<FOUND-OCTET>:8080/admin/delete?username=carlos
   ```
   (Replace `<FOUND-OCTET>` with the octet from the successful Intruder result.)
2. Send the request.
3. **Observation**: The server processes the request, deleting the user `carlos`, which solves the lab.

![payload suc](./img/Basic_SSRF_against_another_back-end_system/Basic%20SSRF%20against%20another%20back-end%20system(1).png)
![payload suc](./img/Basic_SSRF_against_another_back-end_system/Basic%20SSRF%20against%20another%20back-end%20system(2).png)
![payload suc](./img/Basic_SSRF_against_another_back-end_system/Basic%20SSRF%20against%20another%20back-end%20system(3).png)

### Step 5: Verify Success
1. If the lab does not confirm completion, verify:
   - The IP octet from Intruder is correct.
   - The `stockApi` URL is properly formatted.
   - The response indicates a successful deletion (e.g., 200 OK or redirect).
2. **Observation**: Successful deletion of `carlos` completes the lab.
