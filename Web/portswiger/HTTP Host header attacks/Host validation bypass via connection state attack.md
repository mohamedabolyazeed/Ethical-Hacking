# Exploiting Host Validation Bypass via Connection State Attack

This guide delivers a clear, creative, and organized walkthrough to exploit a **Host validation bypass** vulnerability using a connection state attack. Imagine slipping through the server’s defenses by riding the coattails of a trusted connection, sneaking into the admin lair to vanquish the user `carlos`! The objective is to manipulate HTTP requests over a single connection to bypass `Host` header validation, access the admin panel, and delete `carlos` to solve the lab.

## Objective
Use a connection state attack to bypass `Host` header validation, access the internal admin panel via `192.168.0.1`, and delete the user `carlos` with a crafted POST request.

## Prerequisites
- Burp Suite with Proxy and Repeater modules configured.
- Access to the lab application with a homepage and admin panel.
- Basic understanding of HTTP headers, connection state attacks, and form-based requests.

## Background on the Vulnerability
The application validates the `Host` header to restrict access to the admin panel, allowing only internal hosts like `192.168.0.1`. By sending a legitimate request followed by a malicious one over the same connection (using `Connection: keep-alive`), attackers can exploit the server’s connection state to bypass validation, accessing restricted endpoints and performing unauthorized actions.

## Steps to Solve the Lab

### Step 1: Set Up a Connection State Attack
1. In Repeater, duplicate the `/` request tab (right-click > **Duplicate**).
2. Add both tabs to a new group (right-click > **Add to group** > **New group**).
3. In the first tab, configure a legitimate request:
   - Change the path back to `/`.
   - Change the `Host` header to the lab’s domain:
     ```
     GET / HTTP/1.1
     Host: YOUR-LAB-ID.h1-web-security-academy.net
     Connection: keep-alive
     ```

     ![payload suc](./img/Host%20validation%20bypass%20via%20connection%20state%20attack/Host%20validation%20bypass%20via%20connection%20state%20attack(1).png)
     
4. In the second tab, keep the malicious request:
   ```
   GET / HTTP/1.1
   Host: 192.168.0.1
   Connection: keep-alive
   ```

   ![payload suc](./img/Host%20validation%20bypass%20via%20connection%20state%20attack/Host%20validation%20bypass%20via%20connection%20state%20attack(2).png)

5. Select **Send group in sequence (single connection)** from the **Send** dropdown menu in Repeater.
6. Send the sequence.
7. **Observation**: The second response contains the admin panel HTML, confirming the bypass via connection state.

![payload suc](./img/Host%20validation%20bypass%20via%20connection%20state%20attack/Host%20validation%20bypass%20via%20connection%20state%20attack(3).png)

### Step 2: Analyze the Admin Panel
1. Study the admin panel response in the second tab.
2. Note the delete user form details:
   - **Action**: `/admin/delete`
   - **Input name**: `username`
   - **CSRF token**: Extract the value (e.g., `QCT5OmPeAAPnyTKyETt29LszLL7CbPop`).
   - **Session cookie**: From the `Set-Cookie` header (e.g., `_lab=YOUR-LAB-COOKIE; session=YOUR-SESSION-COOKIE`).

![payload suc](./img/Host%20validation%20bypass%20via%20connection%20state%20attack/Host%20validation%20bypass%20via%20connection%20state%20attack(4).png)
![payload suc](./img/Host%20validation%20bypass%20via%20connection%20state%20attack/Host%20validation%20bypass%20via%20connection%20state%20attack(5).png)
![payload suc](./img/Host%20validation%20bypass%20via%20connection%20state%20attack/Host%20validation%20bypass%20via%20connection%20state%20attack(6).png)
### Step 3: Craft the Delete Request
1. In the second Repeater tab, modify the request to replicate the form submission:
   ```
   POST /admin/delete HTTP/1.1
   Host: 192.168.0.1
   Cookie: _lab=YOUR-LAB-COOKIE; session=YOUR-SESSION-COOKIE
   Content-Type: application/x-www-form-urlencoded
   Content-Length: <CORRECT-LENGTH>
   
   csrf=YOUR-CSRF-TOKEN&username=carlos
   ```
2. Replace placeholders:
   - `YOUR-CSRF-TOKEN` with the token from the admin panel.
   - `YOUR-LAB-COOKIE` and `YOUR-SESSION-COOKIE` with values from the response.
   - Calculate and set the correct `Content-Length` (e.g., length of `csrf=...&username=carlos`).
3. Send the request.
4. **Observation**: The server processes the request, deleting the user `carlos`, solving the lab.

![payload suc](./img/Host%20validation%20bypass%20via%20connection%20state%20attack/Host%20validation%20bypass%20via%20connection%20state%20attack(7).png)