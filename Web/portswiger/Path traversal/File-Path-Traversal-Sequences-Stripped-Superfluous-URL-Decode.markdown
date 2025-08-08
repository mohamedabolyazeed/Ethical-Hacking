# 🛡️ Lab Guide: File Path Traversal with Superfluous URL-Decode Stripping

This guide shows how to exploit a **file path traversal vulnerability** where traversal sequences (`../`) are stripped, but a superfluous URL-decode allows bypassing this filter using **Burp Suite**. Let’s get started! 🚀

---

## 📋 Objective
Bypass the application’s traversal sequence stripping by using double URL-encoded `../` sequences to access the `/etc/passwd` file.

---

## 🛠️ Tools Needed
- **Burp Suite** (with Burp’s browser)
- Basic understanding of file path traversal, URL encoding, and HTTP requests

---

## 📝 Step-by-Step Instructions

### 1️⃣ Intercept the Image Request
- Open **Burp Suite** and ensure **Intercept** is on.
- In **Burp’s browser**, navigate to a product page (e.g., `https://YOUR-LAB-ID.web-security-academy.net/product`) and view a product image.
- In **Proxy > HTTP history**, locate the GET request that fetches the image (e.g., `/image?filename=product.jpg`).
- **Right-click** the request and select **Send to Repeater**.

### 2️⃣ Inject the Double-Encoded Payload
- In **Repeater**, modify the `filename` parameter to:
  ```
  ..%252f..%252f..%252fetc/passwd
  ```
- **Note**: `%252f` is the double URL-encoded form of `/` (first encoded as `%2f`, then `%2f` is encoded as `%252f`), bypassing the `../` stripping filter.
- Submit the request and check the response.
- **Observation**: The response contains the contents of the `/etc/passwd` file, indicating the filter was bypassed due to superfluous URL-decoding.