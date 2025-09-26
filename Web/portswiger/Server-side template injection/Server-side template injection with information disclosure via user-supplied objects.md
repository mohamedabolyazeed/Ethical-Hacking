# Exploiting Server-Side Template Injection with Information Disclosure

This guide provides a clear, creative, and organized walkthrough to exploit a **Server-Side Template Injection (SSTI)** vulnerability in a Django-based web application. Imagine yourself as a digital sleuth, prying open the server’s secrets to uncover a hidden key! The objective is to manipulate a product description template to confirm SSTI, use Django’s `debug` tag to explore accessible objects, extract the `SECRET_KEY` from the `settings` object, and submit it to solve the lab.

## Objective
Inject Django template code into a product description to identify the template engine, use the `{% debug %}` tag to reveal accessible objects, extract the `settings.SECRET_KEY`, and submit it to complete the lab.

## Prerequisites
- Burp Suite with Proxy configured (optional for monitoring requests).
- Access to the lab application with a user account and the ability to edit product description templates.
- Basic understanding of SSTI, Django template syntax, and information disclosure vulnerabilities.
- Access to the [Django documentation](https://docs.djangoproject.com/en/stable/) for research.

## Background on the Vulnerability
The application uses Django’s template engine to render product description templates, allowing user-supplied input without proper sanitization. By injecting invalid syntax, attackers can trigger error messages to identify the template engine. The `{% debug %}` tag exposes sensitive objects, including the `settings` object, which contains the `SECRET_KEY`—a critical secret used for cryptographic operations. Leaking this key via SSTI can compromise the application’s security.

## Steps to Solve the Lab

### Step 1: Test for Template Injection
1. Log in to the lab application using the browser.
2. Navigate to the product description template editor (e.g., via an admin or user panel).
3. Edit a product description template and insert a fuzz string to test for SSTI:
   ```
   ${{<%[%'"}}%\
   ```
4. Save the template and view the product page.
5. **Observation**: An error message reveals the use of the Django template engine, confirming an SSTI vulnerability.

![image](img/Server-side%20template%20injection%20with%20information%20disclosure%20via%20user-supplied%20objects/Server-side%20template%20injection%20with%20information%20disclosure%20via%20user-supplied%20objects(1).png)

### Step 2: Research Django Template Tags
1. Consult the [Django template documentation](https://docs.djangoproject.com/en/stable/ref/templates/builtins/).
2. **Observation**: The `{% debug %}` built-in tag outputs debugging information, including accessible objects and their properties.

### Step 3: Use the Debug Tag
1. Return to the product description template editor.
2. Remove the fuzz string and insert the following Django template tag:
   ```
   {% debug %}
   ```
3. Save the template and view the product page.
4. **Observation**: The page displays a list of accessible objects, including the `settings` object, which is available within the template context.

![image](img/Server-side%20template%20injection%20with%20information%20disclosure%20via%20user-supplied%20objects/Server-side%20template%20injection%20with%20information%20disclosure%20via%20user-supplied%20objects(2).png)

### Step 4: Research the Settings Object
1. In the [Django settings documentation](https://docs.djangoproject.com/en/stable/ref/settings/), locate the `settings` object.
2. **Observation**: The `settings` object contains a `SECRET_KEY` property, which is a sensitive value with significant security implications if exposed.

### Step 5: Extract the Secret Key
1. Return to the template editor and remove the `{% debug %}` tag.
2. Insert the following expression to output the `SECRET_KEY`:
   ```
   {{settings.SECRET_KEY}}
   ```
3. Save the template and view the product page.
4. **Observation**: The page displays the Django framework’s `SECRET_KEY` (e.g., a long string like `xyz123...`).

![image](img/Server-side%20template%20injection%20with%20information%20disclosure%20via%20user-supplied%20objects/Server-side%20template%20injection%20with%20information%20disclosure%20via%20user-supplied%20objects(3).png)

### Step 6: Submit the Secret Key
1. Copy the displayed `SECRET_KEY` from the product page.
2. Click the **Submit solution** button in the lab interface.
3. Paste the `SECRET_KEY` into the submission field and submit.
4. **Observation**: The lab confirms the correct key, solving the lab.

![image](img/Server-side%20template%20injection%20with%20information%20disclosure%20via%20user-supplied%20objects/Server-side%20template%20injection%20with%20information%20disclosure%20via%20user-supplied%20objects(4).png)