# 🛡️ Lab Guide: File Path Traversal with Start of Path Validation

This guide walks you through exploiting a **file path traversal vulnerability** where the application validates the start of the path but fails to prevent directory traversal. Using **Burp Suite**, you'll access sensitive files like `/etc/passwd`. Let’s dive in! 🚀

---

## 📋 Objective
Bypass the application's path validation to access the `/etc/passwd` file by crafting a malicious `filename` parameter that starts with the expected directory but traverses upward.

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

### 2️⃣ Inject the Path Traversal Payload
- In **Repeater**, modify the `filename` parameter to:
  ```
  /var/www/images/../../../etc/passwd
  ```
- Submit the request and check the response.
- **Observation**: The response contains the contents of the `/etc/passwd` file, indicating successful traversal past the validated starting path (`/var/www/images`).