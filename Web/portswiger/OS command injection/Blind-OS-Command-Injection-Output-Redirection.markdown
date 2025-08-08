# 🛡️ Lab Guide: Blind OS Command Injection with Output Redirection

This guide demonstrates how to exploit a **blind OS command injection vulnerability** in a feedback form to execute a command and redirect its output to a file, which is then retrieved via a separate request using **Burp Suite**. Let’s get started! 🚀

---

## 📋 Objective
Exploit a blind OS command injection vulnerability in the `email` parameter to execute a command, redirect its output to a file, and retrieve the file’s contents to confirm the injection.

---

## 🛠️ Tools Needed
- **Burp Suite** (with Burp’s browser)
- Basic understanding of OS command injection and HTTP requests

---

## 📝 Step-by-Step Instructions

### 1️⃣ Intercept the Feedback Submission Request
- Open **Burp Suite** and ensure **Intercept** is on.
- In **Burp’s browser**, navigate to the feedback submission form (e.g., `https://YOUR-LAB-ID.web-security-academy.net/feedback`).
- Fill out the form with sample data (e.g., `name=mohamed`, `email=ahmed@gmail.com`, `subject=any`, `message=any`) and submit it.
- In **Proxy > HTTP history**, locate the POST request to `/feedback/submit`.

### 2️⃣ Inject a Command with Output Redirection
- **Right-click** the feedback submission request and select **Send to Repeater**.
- In **Repeater**, modify the `email` parameter to:
  ```
  email=||whoami>/var/www/images/output.txt||
  ```
- Submit the request.
- **Note**: This command executes `whoami` and redirects the output to `/var/www/images/output.txt` on the server.

### 3️⃣ Retrieve the Output File
- In **Burp’s browser**, navigate to a product page that loads an image (e.g., `https://YOUR-LAB-ID.web-security-academy.net/product`).
- In **Proxy > HTTP history**, locate the request that loads an image (likely a GET request with a `filename` parameter).
- **Right-click** the image request and select **Send to Repeater**.
- In **Repeater**, modify the `filename` parameter to:
  ```
  filename=output.txt
  ```
- Submit the request and check the response.
- **Observation**: The response contains the output of the `whoami` command (e.g., the username of the current user).