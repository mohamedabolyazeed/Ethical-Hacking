# Exploiting Server-Side Template Injection with Freemarker Documentation

This guide provides a clear, creative, and organized walkthrough to exploit a **Server-Side Template Injection (SSTI)** vulnerability in a web application using the Freemarker template engine. Picture yourself as a digital sorcerer, wielding the arcane knowledge of Freemarker’s documentation to cast a command-execution spell! The objective is to inject malicious Freemarker template code into a product description, leverage the `Execute` class to run a shell command, and delete the file `/home/carlos/morale.txt` to solve the lab.

## Objective
Inject a Freemarker template payload using the `new()` built-in to instantiate the `Execute` class, execute a system command to delete `carlos`’s file, and solve the lab by viewing the affected product page.

## Prerequisites
- Burp Suite with Proxy configured (optional for monitoring requests).
- Access to the lab application with a user account and the ability to edit product description templates.
- Basic understanding of SSTI, Freemarker template syntax, and Java classes.
- Access to the [Freemarker documentation](https://freemarker.apache.org/docs/) and JavaDoc for research.

## Background on the Vulnerability
The application uses the Freemarker template engine to render product description templates with the `${someExpression}` syntax. Unsanitized user input in these templates allows attackers to inject arbitrary Freemarker expressions. By leveraging the `new()` built-in to instantiate the `Execute` class (from the `freemarker.template.utility` package), attackers can execute shell commands, such as deleting files, due to inadequate template sandboxing.

## Steps to Solve the Lab

### Step 1: Identify the Template Engine
1. Log in to the lab application using Burp’s browser.
2. Navigate to the product description template editor (e.g., via an admin or user panel).
3. Edit a product description template and insert a test expression, such as:
   ```
   ${foobar}
   ```
4. Save the template and view the product page.
5. **Observation**: An error message indicates the use of the Freemarker template engine, confirming that `${someExpression}` is evaluated and `foobar` is an undefined object.

### Step 2: Research Freemarker Vulnerabilities
1. Consult the [Freemarker documentation](https://freemarker.apache.org/docs/) and locate the FAQs section in the appendix.
2. Find the question: *"Can I allow users to upload templates and what are the security implications?"*
3. **Observation**: The answer highlights the `new()` built-in as a security risk, as it can create arbitrary Java objects implementing the `TemplateModel` interface.
4. Navigate to the **Built-in reference** section and find the `new()` entry, confirming its ability to instantiate risky classes.

### Step 3: Identify Command Execution Class
1. Access the [JavaDoc for `TemplateModel`](https://freemarker.apache.org/docs/api/freemarker/template/TemplateModel.html).
2. Review the list of *"All Known Implementing Classes"*.
3. **Observation**: The `Execute` class (in `freemarker.template.utility`) can execute arbitrary shell commands.

### Step 4: Craft the Malicious Payload
1. Construct a Freemarker payload to instantiate the `Execute` class and delete `/home/carlos/morale.txt`:
   ```
   <#assign ex="freemarker.template.utility.Execute"?new()> ${ ex("rm /home/carlos/morale.txt") }
   ```
   - `<#assign ex="freemarker.template.utility.Execute"?new()>`: Creates an instance of the `Execute` class.
   - `${ex("rm /home/carlos/morale.txt")}`: Executes the `rm` command to delete the file.
2. **Alternative**: Reference @albinowax’s exploit from the lab’s research page, adapting it to the above format if needed.

### Step 5: Inject the Payload
1. Return to the product description template editor.
2. Remove the invalid test syntax (e.g., `${foobar}`).
3. Insert the malicious payload:
   ```
   <#assign ex="freemarker.template.utility.Execute"?new()> ${ ex("rm /home/carlos/morale.txt") }
   ```
4. Save the template.

![image](img/Server-side%20template%20injection%20using%20documentation/Server-side%20template%20injection%20using%20documentation.png)

### Step 6: Execute the Exploit
1. Navigate to the product page associated with the edited template.
2. **Observation**: The server executes the payload, running the `rm` command and deleting `/home/carlos/morale.txt`, solving the lab.

### Step 7: Verify Success
1. If the lab does not confirm completion, verify:
   - The payload syntax is correct and matches the Freemarker format.
   - The product page triggers the template execution.
   - No errors occur due to incorrect class paths or command syntax.
2. **Observation**: Successful deletion of the file completes the lab.