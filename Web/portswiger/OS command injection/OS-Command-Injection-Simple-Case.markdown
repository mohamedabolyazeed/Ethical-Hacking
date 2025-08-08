# 🛡️ Lab Guide: OS Command Injection, Simple Case

This guide walks you through exploiting a **simple OS command injection vulnerability** in a stock-checking feature using **Burp Suite**. You’ll inject a command to retrieve the current user’s name directly in the response. Let’s dive in! 🚀

---

## 📋 Objective
Exploit an OS command injection vulnerability in the `storeId` parameter of a stock-checking request to execute a command and retrieve its output in the response.

---

## 🛠️ Tools Needed
- **Burp Suite** (with Burp’s browser)
- **Commix** (for reverse shell payload, optional)
- Basic understanding of OS command injection and HTTP requests

---

## 📝 Step-by-Step Instructions

### 1️⃣ Intercept the Stock-Checking Request
- Open **Burp Suite** and ensure **Intercept** is on.
- In **Burp’s browser**, navigate to a product page (e.g., `https://YOUR-LAB-ID.web-security-academy.net/product`) and click **Check stock**.
- In **Proxy > HTTP history**, locate the POST request to `/product/stock` with parameters like `productId=1` and `storeId=1`.
- Note the session cookie (e.g., `oWBZLTSa2Dmq2OwnhIGd1zkwXPxBRiCE`).

### 2️⃣ Inject a Command
- **Right-click** the stock-checking request and select **Send to Repeater**.
- In **Repeater**, modify the `storeId` parameter to:
  ```
  storeId=1|whoami
  ```
- Submit the request and check the response.
- **Observation**: The response contains the output of the `whoami` command (e.g., the username of the current user).

### 3️⃣ Explore a Reverse Shell (Optional)
- To escalate the attack, use **Commix** to attempt a reverse shell. Run the following command, replacing the URL, data, and cookie with your lab-specific values:
  ```bash
  commix \
  --url="https://YOUR-LAB-ID.web-security-academy.net/product/stock" \
  --data="productId=1&storeId=1" \
  --cookie="YOUR-SESSION-COOKIE"
  ```
- **Note**: This step is for advanced exploration and may not be required to solve the lab.