# 🎯 Cross-Site Request Forgery (CSRF) Guide

A comprehensive and creative guide to understanding **Cross-Site Request Forgery (CSRF)** vulnerabilities, testing methodologies, exploitation techniques, and insights from solving PortSwigger labs. This guide also covers **CRLF Injection** as a related attack vector. Let’s dive into the world of web security! 🕵️‍♂️

---

## 🔍 **What is CSRF in Simple Terms?**

**Cross-Site Request Forgery (CSRF)** is a type of attack where a malicious actor tricks a user into performing an unwanted action on a website where they are authenticated, without their knowledge or consent. The attacker exploits the trust that the website has in the user’s browser session.

### 🛠️ **Simple Example**

- You’re logged into your online banking website.
- At the same time, you click on a malicious link (e.g., from an email, ad, or shady website).
- The malicious site sends a request to your bank’s website, such as transferring money or changing your password.
- Since your browser has valid session cookies, the bank trusts the request and processes it, thinking it came from you.

### 🛡️ **How to Protect Against CSRF?**

1. **CSRF Tokens**: Websites should use unique, unpredictable tokens for each user session to validate requests.
2. **Avoid Suspicious Links**: Don’t click on unknown links while logged into sensitive accounts (e.g., banking, email).
3. **Use Modern Browsers**: They include advanced security features like SameSite cookies to mitigate CSRF risks.

> **In Short**: CSRF tricks your browser into making unauthorized requests on a trusted site using your active session.

---

## 🔎 **How to Test for CSRF Vulnerabilities?**

Here’s a structured approach to identify CSRF vulnerabilities:

- **Check for CSRF Tokens**:
  - If a request lacks a CSRF token, the endpoint is likely vulnerable.
- **Manipulate the Token**:
  - Try altering or removing the CSRF token and resending the request.
  - Observe if the server still processes the request.
- **Change Request Methods**:
  - Switch the request method (e.g., from `POST` to `GET` or vice versa) and check if the server accepts it.
- **Use a Different Account’s Token**:
  - Create a new account, grab its CSRF token, and use it to modify another account’s information (e.g., email).
- **Combine with Other Vulnerabilities**:
  - Chain CSRF with vulnerabilities like **XSS** or **CRLF Injection** for more impact (explained below).

---

## 🧪 **Solving PortSwigger CSRF Labs**

Here’s how I approached solving PortSwigger’s CSRF labs, with insights into each lab’s unique challenge:

### **Lab 1: No CSRF Token**
- **Issue**: The request didn’t include a CSRF token, making it trivially exploitable.
- **Solution**: Crafted an HTML form to submit a malicious request (e.g., change email) without any token validation.

### **Lab 2: Bypassing CSRF with Method Change**
- **Issue**: Changing the request method from `POST` to `GET` bypassed CSRF token validation.
- **Solution**: Modified the form’s method to `GET` and submitted the request, which the server accepted.

### **Lab 3: Ignoring Missing CSRF Token**
- **Issue**: The server validated the CSRF token if present but ignored its absence entirely.
- **Solution**: Removed the CSRF token from the request, and the server processed it without validation.

### **Lab 4: No Session-Token Binding**
- **Issue**: The CSRF token wasn’t tied to the user’s session, allowing a token from one account to work for another.
- **Solution**:
  - Created a new account and extracted its CSRF token.
  - Used this token to change the email of the original account, which succeeded.

### **Lab 5: CSRF with CRLF Injection**
- **Issue**: A `csrfKey` in the cookie was tied to the CSRF token, but the site was vulnerable to **CRLF Injection** via a search bar.
- **Solution**:
  - Discovered that the search bar set a `latest-search` cookie with the input value.
  - Confirmed CRLF injection by injecting `%0D%0A` (CRLF) to manipulate headers.
  - Crafted an exploit using an `<img>` tag to trigger a search that sets a malicious `csrfKey`, followed by a form submission:
  
```html
<img src='https://[Lab ID].web-security-academy.net/?search=%0D%0ASet-Cookie:%20csrfKey=9zJdZsnRI6AB4uD8dWtcnQPOsQp1mBOo' onerror='document.forms[0].submit()'>
<form action="https://[Lab ID].web-security-academy.net/my-account/change-email" method="POST">
  <input required type="email" name="email" value="hacker@exploit.com">
  <input required type="hidden" name="csrf" value="UtYvJNDm9Y8jlPWzRz47kVQBV0LNliyP">
</form>
```

- **Explanation**: The `<img>` tag triggers a CRLF injection to set a malicious `csrfKey`. If the image fails to load (`onerror`), the form auto-submits with the attacker’s CSRF token.

### **Lab 6: CSRF Token and Cookie Matching**
- **Issue**: The `csrfKey` in the cookie had to match the CSRF token, but CRLF injection allowed manipulation of both.
- **Solution**:
  - Set both the `csrfKey` and CSRF token to the same value (e.g., `hesham`) via CRLF injection.
  - Used a similar `<img>` tag exploit to manipulate the cookie and submit the form.

### **Example Exploit Form**

Here’s how I modified a form for exploitation (e.g., to change an email):

**Original Form**:
```html
<form class="login-form" name="change-email-form" action="/my-account/change-email" method="POST">
  <label>Email</label>
  <input required type="email" name="email" value="">
  <button class='button' type='submit'>Update email</button>
</form>
```

**Modified Exploit Form**:
```html
<form name="change-email-form" action="[YOUR LAB LINK]/my-account/change-email" method="POST">
  <input required type="email" name="email" value="hacker@gmail.com">
</form>
<script>
  document.forms[0].submit();
</script>
```

- **Tweak**: Adjusted the `method` (e.g., `POST` to `GET`) or other parameters based on the lab’s requirements.

---

## 🛑 **What is CRLF Injection?**

**CRLF Injection** (Carriage Return Line Feed) is a vulnerability that exploits improper handling of user input containing special characters `\r` (Carriage Return) and `\n` (Line Feed). These characters are used to end lines in text-based protocols like HTTP.

### **How Does It Work?**

If a web application doesn’t sanitize input containing `%0D%0A` (encoded CRLF), an attacker can inject new headers or manipulate server responses. This can lead to session hijacking, cookie manipulation, or enabling CSRF attacks.

### **Example**

**Malicious Input**:
```jsx
http://example.com/page?name=Hesham%0D%0ASet-Cookie:%20Admin=true
```

**Resulting HTTP Response**:
```jsx
HTTP/1.1 200 OK
Content-Type: text/html
Set-Cookie: Admin=true

<!DOCTYPE html>
<html>
...
```

- The attacker injects a new `Set-Cookie` header, escalating privileges or bypassing CSRF protections.

### **Protection Against CRLF Injection**

1. **Input Sanitization**: Strip or encode CRLF characters (`\r`, `\n`) from user input.
2. **URL Encoding**: Ensure inputs are properly encoded before processing.
3. **Secure Coding**: Use libraries that safely handle user input.
4. **Code Reviews**: Regularly audit code for improper input handling.

---

## 🚀 **Key Takeaways**

- **CSRF** exploits trust in a user’s authenticated session to execute unauthorized actions.
- Testing involves checking for missing tokens, bypassing validations, or chaining with other vulnerabilities like **CRLF Injection**.
- PortSwigger labs teach practical exploitation techniques, from simple token bypasses to advanced header manipulation.
- Always test responsibly within legal boundaries and scope agreements.