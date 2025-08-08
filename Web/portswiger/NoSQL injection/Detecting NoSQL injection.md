# 🛡️ Lab Guide: Detecting NoSQL Injection Vulnerabilities

This guide walks you through detecting and exploiting a **NoSQL injection vulnerability** in a web application using **Burp Suite**. Follow these steps to identify and manipulate the application's behavior, ultimately revealing unreleased products. Let's dive in! 🚀

---

## 📋 Objective
Learn how to identify a NoSQL injection vulnerability by manipulating query parameters, injecting JavaScript payloads, and crafting boolean conditions to alter the server's response.

---

## 🛠️ Tools Needed
- **Burp Suite** (with Burp's browser)
- **Repeater** module in Burp Suite
- Basic understanding of URL encoding and JavaScript payloads

---

## 📝 Step-by-Step Instructions

### 1️⃣ Access the Application
- Open **Burp's browser** and navigate to the target web application.
- Click on a **product category filter** (e.g., "Gifts") to generate a request.

### 2️⃣ Capture the Request
- In **Burp Suite**, go to **Proxy > HTTP history**.
- Locate the request triggered by the category filter.
- **Right-click** the request and select **Send to Repeater** to analyze it further.

### 3️⃣ Test for Injection
- In the **Repeater** tab, modify the `category` parameter by injecting a single quote: `'`.
- Submit the request and observe the response.
- **Observation**: A **JavaScript syntax error** indicates that the input is not properly filtered or sanitized, suggesting a potential injection vulnerability.

### 4️⃣ Inject a JavaScript Payload
- Replace the `category` parameter with the following payload:
  ```
  Gifts'+
  ```
- **URL-encode** the payload:
  - Highlight the payload in Repeater.
  - Press **Ctrl+U** to encode it (e.g., `Gifts%27%2B`).
- Submit the request and check the response.
- **Observation**: No syntax error occurs, confirming that server-side injection is likely happening.

### 5️⃣ Test Boolean Conditions
Test how the application handles boolean conditions to manipulate the response.

#### a) False Condition
- Set the `category` parameter to:
  ```
  Gifts' && 0 && 'x
  ```
- **URL-encode** the payload (e.g., `Gifts%27%20%26%26%200%20%26%26%20%27x`).
- Submit the request.
- **Observation**: No products are retrieved, indicating the condition evaluates to **false**.

#### b) True Condition
- Set the `category` parameter to:
  ```
  Gifts' && 1 && 'x
  ```
- **URL-encode** the payload (e.g., `Gifts%27%20%26%26%201%20%26%26%20%27x`).
- Submit the request.
- **Observation**: Products in the "Gifts" category are retrieved, indicating the condition evaluates to **true**.

### 6️⃣ Exploit with a Persistent True Condition
- Set the `category` parameter to a condition that **always evaluates to true**:
  ```
  Gifts'||1||'
  ```
- **URL-encode** the payload (e.g., `Gifts%27%7C%7C1%7C%7C%27`).
- Submit the request in Repeater.

---

---

## Final Answer
The final payload used to URL:

```json
https://0aab00b60392d9b780f21c7500f30044.web-security-academy.net/filter?category=Gifts%27||1||%27
```