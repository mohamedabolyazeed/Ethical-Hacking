# 🛡️ Lab Guide: File Path Traversal with Non-Recursive Sequence Stripping

This guide shows how to exploit a **file path traversal vulnerability** where traversal sequences (`../`) are stripped non-recursively, allowing a crafted payload to bypass the filter using **Burp Suite**. Let’s dive in! 🚀

---

## 📋 Objective
Bypass the application’s non-recursive traversal sequence stripping by using nested `../` sequences to access the `/etc/passwd` file.

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

### 2️⃣ Inject the Nested Traversal Payload
- In **Repeater**, modify the `filename` parameter to:
  ```
  ....//....//....//etc/passwd
  ```
- **Note**: The `....//` sequence bypasses non-recursive stripping, as the filter removes `../` once, leaving a functional traversal path.
- Submit the request and check the response.
- **Observation**: The response contains the contents of the `/etc/passwd` file, indicating the filter was bypassed.