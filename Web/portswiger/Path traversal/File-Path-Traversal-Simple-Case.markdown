# 🛡️ Lab Guide: File Path Traversal, Simple Case

This guide walks you through exploiting a **simple file path traversal vulnerability** in a web application using **Burp Suite**. You’ll access the `/etc/passwd` file with a straightforward traversal payload. Let’s get started! 🚀

---

## 📋 Objective
Exploit a basic file path traversal vulnerability in the `filename` parameter to access the `/etc/passwd` file without any filtering or validation bypasses.

---

## 🛠️ Tools Needed
- **Burp Suite** (with Burp’s browser)
- Basic understanding of file path traversal and HTTP requests

---

## 📝 Step-by-Step Instructions

### 1️⃣ Intercept the Image Request
- Open **Burp Suite** and ensure **Intercept** is on.
- In **Burp’s browser**, navigate to a product page (e.g., `https://YOUR-LAB-ID.web-security-academy.net/product`) and view a product image.
- In **Proxy > HTTP history**, locate the GET request that fetches the image (e.g., `/image?filename=product.jpg`).
- **Right-click** the request and select **Send to Repeater**.

### 2️⃣ Inject the Traversal Payload
- In **Repeater**, modify the `filename` parameter to:
  ```
  ../../../etc/passwd
  ```
- Submit the request and check the response.
- **Observation**: The response contains the contents of the `/etc/passwd` file, indicating successful directory traversal.