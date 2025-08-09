# Lab Guide: File Path Traversal with Null Byte Bypass

This guide demonstrates how to exploit a **file path traversal vulnerability** where file extension validation is bypassed using a null byte (`%00`). Using **Burp Suite**, you’ll access the `/etc/passwd` file. Let’s dive in!

---

## Objective
Bypass the application’s file extension validation by appending a null byte to the path traversal payload, allowing access to the `/etc/passwd` file.

---

## Tools Needed
- **Burp Suite** (with Burp’s browser)
- Basic understanding of file path traversal, null byte attacks, and HTTP requests

---

## Step-by-Step Instructions

### 1- Intercept the Image Request
- Open **Burp Suite** and ensure **Intercept** is on.
- In **Burp’s browser**, navigate to a product page (e.g., `https://YOUR-LAB-ID.web-security-academy.net/product`) and view a product image.
- In **Proxy > HTTP history**, locate the GET request that fetches the image (e.g., `/image?filename=product.jpg`).
- **Right-click** the request and select **Send to Repeater**.

### 2- Inject the Null Byte Payload
- In **Repeater**, modify the `filename` parameter to:
  ```
  ../../../etc/passwd%00.png
  ```
- **Note**: The `%00` (null byte) terminates the string, bypassing the `.png` extension check while still accessing `/etc/passwd`.
- Submit the request and check the response.
- **Observation**: The response contains the contents of the `/etc/passwd` file, indicating the null byte bypassed the extension validation.