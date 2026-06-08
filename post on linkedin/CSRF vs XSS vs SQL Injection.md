# CSRF vs XSS vs SQL Injection

## The 3 most common and most misunderstood web vulnerabilities

One of the most common mistakes among developers is confusing CSRF, XSS, and SQL Injection, as if they were the same type of vulnerability.

The truth: Each vulnerability targets a different layer in the application, and understanding the difference between them is fundamental for any Backend Developer or Security Engineer.

---

## 💉 SQL Injection

**Occurs when an attacker succeeds in injecting malicious SQL commands into database queries.**

**Potential impacts:**

- Reading sensitive data
- Modifying or deleting data
- Bypassing login

**Protection:**

- Use Parameterized Queries and Prepared Statements
- Avoid directly concatenating inputs into queries

---

## ⚡ XSS (Cross-Site Scripting)

**Here the attacker doesn't target the database, but the user's browser.**
**They inject malicious JavaScript code that executes on the victim's device.**

**Potential impacts:**

- Stealing Session Cookies or Access Tokens
- Account Takeover
- Redirecting to phishing sites
- Executing actions on behalf of the user

**Protection:**

- Output Encoding
- Content Security Policy (CSP)
- Input Sanitization

---

## 🔄 CSRF (Cross-Site Request Forgery)

**The attacker exploits the user's already authenticated session.**
**Classic example:** User is logged into a banking site, and the attacker sends them a link or hidden image that executes a money transfer request.

**Protection:**

- CSRF Tokens
- SameSite Cookies (Strict/Lax)
- Verify Origin and Referer Headers

---

## 📊 The Difference in Summary

- **SQL Injection** → Targets the database
- **XSS** → Targets the user's browser
- **CSRF** → Exploits the user's authenticated session

---

## 💡 Summary

Most of these vulnerabilities don't occur due to complex attacks, but due to simple mistakes in handling inputs or the absence of basic controls.

**Rule:** Every Input should be considered untrusted until proven otherwise.

---

CyberSecurity #WebSecurity #SQLInjection #XSS #CSRF #OWASP #SecureCoding #BackendDevelopment #InfoSec #SoftwareEngineering
