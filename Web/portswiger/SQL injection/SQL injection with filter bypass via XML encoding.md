# Exploiting SQL Injection with Filter Bypass via XML Encoding

This guide provides a clear, creative, and organized solution to exploit a **SQL injection** vulnerability hidden within XML-encoded parameters. Imagine slipping through a digital fortress by disguising your attack as innocent XML— that's the art of this bypass! The objective is to inject SQL payloads into the `storeId` parameter, bypass the web application firewall (WAF) using XML entities, extract user credentials from the database, and log in as the administrator to solve the lab.

## Objective
Bypass the WAF filtering SQL injection attempts by encoding payloads in XML entities, extract usernames and passwords from the `users` table, and use the administrator's credentials to complete the lab.

## Prerequisites
- Burp Suite with Repeater module and the Hackvertor extension installed (from the BApp Store).
- Access to the lab application with a stock check feature.
- Basic understanding of SQL injection and XML encoding.

## Background on the Vulnerability
The application sends `productId` and `storeId` in XML format for stock checks, evaluating the `storeId` dynamically. This allows SQL injection, but a WAF blocks obvious payloads. By obfuscating injections with XML entities (e.g., via decimal/hex encoding), attackers can bypass the WAF and execute arbitrary SQL queries.

## Steps to Solve the Lab

### Step 1: Identify the Vulnerability
1. Interact with the stock check feature on a product page, selecting different stores.
2. In Burp Suite, go to **Proxy > HTTP history** and locate the `POST /product/stock` request.
3. Right-click the request and select **Send to Repeater**.
4. In Repeater, modify the `storeId` parameter to test evaluation, e.g.:
   ```
   <storeId>1+1</storeId>
   ```
5. Send the request.
6. **Observation**: The response shows stock for a different store (e.g., store ID 2), confirming dynamic evaluation of `storeId`.
7. Probe for SQL injection by appending a `UNION SELECT`:
   ```
   <storeId>1 UNION SELECT NULL</storeId>
   ```
8. Send the request.
9. **Observation**: The request is blocked by the WAF, indicating detection of SQL keywords.

### Step 2: Bypass the WAF with XML Encoding
1. Since the injection is in XML, obfuscate the payload using XML entities.
2. Install the **Hackvertor** extension if not already (via **Extender > BApp Store**).
3. In Repeater, highlight the payload (e.g., `1 UNION SELECT NULL`).
4. Right-click and select **Extensions > Hackvertor > Encode > dec_entities/hex_entities** to encode it.
5. Replace the `storeId` with the encoded version, e.g.:
   ```
   <storeId><@hex_entities>1 UNION SELECT NULL</@hex_entities></storeId>
   ```
6. Send the request.
7. **Observation**: The response is normal (no WAF block), confirming the bypass. The query likely returns stock data, indicating successful injection.

### Step 3: Determine the Number of Columns
1. Continue probing with encoded payloads to find the column count.
2. Test `UNION SELECT NULL` (encoded):
   - If it succeeds (returns data), the query has 1 column.
3. Test `UNION SELECT NULL,NULL` (encoded):
   - If it returns 0 units (implying an error), confirm only 1 column.
4. **Observation**: The original query returns a single column, as multi-column tests fail.

### Step 4: Craft the Exploit to Extract Credentials
1. Concatenate usernames and passwords for extraction in a single column:
   ```
   <storeId><@hex_entities>1 UNION SELECT username || '~' || password FROM users</@hex_entities></storeId>
   ```
2. **Explanation**: The `||` concatenates fields with a `~` separator; `FROM users` targets the user table.
3. Send the encoded request.
4. **Observation**: The response contains concatenated credentials (e.g., `administrator~password123`), separated by `~`.

![payload suc](./img/SQL%20injection%20with%20filter%20bypass%20via%20XML%20encoding.png)

### Step 5: Log In as Administrator
1. Extract the administrator's credentials from the response.
2. Log in to the application using the administrator username and password.
3. **Observation**: Successful login solves the lab.

### Step 6: Verify Success
1. If the lab does not confirm completion, verify:
   - The encoding is applied correctly via Hackvertor.
   - The SQL payload syntax matches the database (e.g., `||` for concatenation in PostgreSQL-like DBs).
   - Credentials are extracted and used accurately.
2. **Observation**: Logging in as administrator completes the lab.