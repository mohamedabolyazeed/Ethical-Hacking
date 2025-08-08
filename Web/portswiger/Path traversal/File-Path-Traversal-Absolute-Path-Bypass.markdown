# 🛡️ Lab Guide: File Path Traversal with Absolute Path Bypass

This guide demonstrates how to exploit a **file path traversal vulnerability** where traversal sequences (`../`) are blocked, but absolute paths are allowed, using **Burp Suite**. Let’s get started! 🚀

---

## 📋 Objective
Bypass the application’s traversal sequence blocking by using an absolute path to access the `/etc/passwd` file.

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

### 2️⃣ Inject the Absolute Path Payload
- In **Repeater**, modify the `filename` parameter to:
  ```
  /etc/passwd
  ```
- Submit the request and check the response.
- **Observation**: The response contains the contents of the `/etc/passwd` file, indicating the absolute path bypassed the traversal sequence block.