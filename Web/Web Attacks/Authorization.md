# Explanation of the Vulnerability

Authorization vulnerabilities occur when an application does not properly enforce access controls, allowing unauthorized users to access resources or perform actions they shouldn’t be able to. This can be due to improper user role management, weak access control mechanisms, or missing checks before granting permissions.

For example, if a user with "guest" access is allowed to view or modify administrative settings, that's an authorization issue.

---

## Examples

### Real-world scenarios where authorization vulnerabilities have been exploited:

1. **Facebook Breach (2018):**  
   Hackers exploited weak session management and API access controls to retrieve private user data. Sensitive information was exposed because the application did not validate access levels properly, allowing attackers to impersonate legitimate users.

2. **SuperAdmin Bug in Web Applications:**  
   Attackers can elevate their access levels through poorly designed user-role management (e.g., changing user parameters in the URL), gaining unrestricted access to back-end systems.

---

## Root Cause

1. **Poor Access Control Policies:**  
   Permission systems often do not segregate users properly or check for sufficient authorization.

2. **Inadequate Input Validation:**  
   Weak or improper role checks can be bypassed by changing parameters directly (such as URLs, session tokens, or headers).

3. **Over-permissioned roles:**  
   Assigning overly broad permissions to lower-level users or misconfigurations in role management systems.

---

## Mitigation Strategies

1. **Use the Principle of Least Privilege:**  
   Ensure users have only the minimum permissions necessary to perform their tasks.

2. **Role-based Access Control (RBAC):**  
   Define specific roles and responsibilities, and tie access control to roles rather than users.

3. **Implement Proper Access Checks:**  
   Check for valid permissions before granting access, ensuring there are no overlooked pathways.

4. **Secure Session Management:**  
   Implement techniques such as token expiration, session timeouts, and secure storage.

5. **Code Audits & Penetration Testing:**  
   Regular audits and tests to find and patch authorization flaws.

6. **Use of Strong Authentication:**  
   Implement robust authentication methods alongside authorization checks.

---

### Practical Example of Mitigation

#### Python code implementing RBAC (Role-Based Access Control)

```python
def is_user_authorized(user, resource):
    if user.role != 'admin':
        raise PermissionError("You are not authorized to access this resource.")
    return True

# Access control example
user = get_user_from_db()  # Get user details
if is_user_authorized(user, 'restricted_resource'):
    # Proceed with sensitive operation
    print("Access granted!")
```

---

# Transaction Authorization Cheat Sheet

## Purpose and Audience

This cheat sheet discusses how developers can secure transaction authorizations and prevent bypass vulnerabilities. Targeted audience includes:

- Banks
- Developers
- Penetration testers

## Functional Guidelines

1. **Transaction authorization method should allow a user to identify and acknowledge significant transaction data.**

   - Use the "What You See Is What You Sign" principle.

2. **Change of authorization token should be authorized using the current token.**

3. **Ensure users can distinguish the authentication process from the authorization process.**

4. **Each transaction must be authorized with unique credentials.**

---

## Non-functional Guidelines

1. **Server-Side Enforcement:**  
   All security controls must be enforced server-side.

2. **Prevent Authorization Brute-Forcing:**  
   Restart the authorization process after a limited number of failed attempts.

3. **Transaction Data Protection:**

   - Invalidate previously entered authorization data if transaction data is modified.
   - Reset the authorization process for tampered transactions.

4. **Confidentiality Protection:**  
   Secure communication between client and server to protect transaction data.
