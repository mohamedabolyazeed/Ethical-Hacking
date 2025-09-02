# Exploiting Host Header Authentication Bypass

This guide delivers a clear, creative, and organized walkthrough to exploit a **Host header authentication bypass** vulnerability. Imagine slipping past a digital bouncer by flashing a fake ID that says you're a local VIP! The objective is to manipulate the `Host` header to gain unauthorized access to the admin panel and delete the user `carlos`, solving the lab.

## Objective
Bypass authentication controls by altering the `Host` header to `localhost`, access the restricted admin panel, and delete the user `carlos`.

## Prerequisites
- Burp Suite with Proxy and Repeater modules configured.
- Access to the lab application with a homepage and `/robots.txt`.
- Basic understanding of HTTP headers and authentication bypass techniques.

## Background on the Vulnerability
The application uses the `Host` header to determine access permissions, granting local users (e.g., `localhost`) access to the admin panel. By manipulating the `Host` header, attackers can trick the server into treating external requests as local, bypassing authentication and accessing restricted functionality.

## Steps to Solve the Lab

### Step 1: Test Host Header Manipulation
1. In Burp Suite, go to **Proxy > HTTP history** and locate the `GET /` request that returns a 200 OK response.
2. Right-click the request and select **Send to Repeater**.
3. In Repeater, change the `Host` header to an arbitrary value (e.g., `example.com`):
   ```
   Host: example.com
   ```
4. Send the request.
5. **Observation**: The homepage is still accessible, indicating the `Host` header is not strictly validated.

![payload suc](./img/Host%20header%20authentication%20bypass/Host%20header%20authentication%20bypass(1).png)

### Step 2: Discover the Admin Panel
1. In the browser, navigate to `/robots.txt`.
2. **Observation**: The file reveals an admin panel at `/admin`.

![payload suc](./img/Host%20header%20authentication%20bypass/Host%20header%20authentication%20bypass(2).png)

### Step 3: Attempt to Access the Admin Panel
1. Browse to `/admin` in the browser.
2. **Observation**: Access is denied, with an error message indicating the panel is restricted to local users.

![payload suc](./img/Host%20header%20authentication%20bypass/Host%20header%20authentication%20bypass(3).png)

### Step 4: Test Admin Access with Host Header
1. In Burp Suite, locate the `GET /admin` request in **Proxy > HTTP history**.
2. Right-click and select **Send to Repeater**.
3. In Repeater, change the `Host` header to `localhost`:
   ```
   Host: localhost
   ```
4. Send the request.
5. **Observation**: The response contains the admin panel HTML, including options to delete users, confirming the bypass.

![payload suc](./img/Host%20header%20authentication%20bypass/Host%20header%20authentication%20bypass(4).png)
![payload suc](./img/Host%20header%20authentication%20bypass/Host%20header%20authentication%20bypass(5).png)

### Step 5: Delete the User `carlos`
1. In Repeater, modify the request line to target the delete endpoint:
   ```
   GET /admin/delete?username=carlos HTTP/1.1
   Host: localhost
   ```
2. Send the request.
3. **Observation**: The server processes the request, deleting the user `carlos`, which solves the lab.

![payload suc](./img/Host%20header%20authentication%20bypass/Host%20header%20authentication%20bypass(6).png)

### Step 6: Verify Success
1. If the lab does not confirm completion, verify:
   - The `Host` header is set to `localhost`.
   - The request line is correctly formatted as `GET /admin/delete?username=carlos`.
   - The response indicates a successful deletion (e.g., 200 OK or redirect).
2. **Observation**: Successful deletion of `carlos` completes the lab.

