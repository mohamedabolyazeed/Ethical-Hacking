# Introduction to JWT

JSON Web Token (JWT) is an open standard (RFC 7519) that defines a compact, URL-safe means of representing claims to be transferred between two parties. These claims can be verified and trusted because they are digitally signed. JWT is commonly used to authenticate users, as it ensures the integrity and authenticity of the transferred information.

## Common Uses of JWT:

- **Authentication**: JWT is used for stateless authentication, meaning that each token represents a fully self-contained user identity.
- **Authorization**: After a user is authenticated, JWT can be used to grant access to different resources or services.
- **Information exchange**: JWT allows safe information exchange between parties due to its signature mechanism.

## JWT Structure

A JWT consists of three parts:

### 1. Header

The header typically consists of two parts: the type of token, which is JWT, and the signing algorithm, such as HMAC SHA256 or RSA.

#### Example:

```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```

### 2. Payload

The payload contains the claims, which are the statements about an entity (typically, the user) and additional data. Claims can be of three types:

- **Registered claims**: Predefined claims like `iss` (issuer), `exp` (expiration time), `sub` (subject), etc.
- **Public claims**: Claims that are registered in the public domain.
- **Private claims**: Custom claims defined between the two parties.

#### Example:

```json
{
  "sub": "1234567890",
  "name": "John Doe",
  "admin": true
}
```

### 3. Signature

To create the signature part you have to take the encoded header, the encoded payload, a secret, and the algorithm specified in the header. The signature is used to verify that the sender is who it says it is and to ensure that the message wasn't changed along the way.

#### Example (HMAC SHA256):

```scss
HMACSHA256(
  base64UrlEncode(header) + "." + base64UrlEncode(payload),
  secret)
```

## JWT Creation and Verification

### How JWT is created:

1. Construct the Header and base64Url encode it.
2. Create the Payload with the necessary claims and base64Url encode it.
3. Combine the encoded header and payload and apply the appropriate signing algorithm (e.g., HMAC SHA256) with a secret or a private key to create the signature.
4. Concatenate the three parts with dots (.), forming the JWT:

#### Example:

```css
header.payload.signature
```

### How JWT is verified:

The receiving party needs to perform the following steps:

1. Decode the JWT to retrieve the header and payload.
2. Validate the signature by recomputing it using the original secret key or public key.
3. Ensure that the claims, such as expiration time (`exp`) and issuer (`iss`), match expected values.

## Benefits of Using JWT

- **Compact and Portable**: The JWT is compact, URL-safe, and can be easily passed in web environments, including URL parameters, HTTP headers, or cookies.
- **Stateless**: Once a JWT is issued, the server does not need to store any information about the user, making it suitable for distributed systems.
- **Security**: JWTs are signed, and this helps in verifying their integrity and authenticity. Additionally, when using JWT with HTTPS, the data is secure during transmission.
- **Cross-platform Support**: JWT can be used across different systems and technologies, making it a cross-platform solution for authentication.

## Example Use Cases

### Authentication:

JWT is typically used for authentication, where once a user logs in, a JWT token is issued and used to authenticate further requests.

#### Example of issuing a token after login:

```python
import jwt
import datetime

secret = "your-SECRET-key"
payload = {
    "sub": "user_id",
    "exp": datetime.datetime.utcnow() + datetime.timedelta(hours=1)
}

# Create JWT
token = jwt.encode(payload, secret, algorithm="HS256")
print(f"Generated Token: {token}")
```

### Authorization:

Once the user has a JWT token, they can use this token in the Authorization header to access secured resources:

#### Example:

```makefile
Authorization: Bearer <JWT_TOKEN>
```

# Common JWT Libraries

Explore the most popular JWT libraries for different programming languages. Click on each link to learn more about their usage and documentation:

## JavaScript

- **Library**: [jsonwebtoken](https://www.npmjs.com/package/jsonwebtoken)
- **Description**: A simple and easy-to-use JWT library for Node.js, widely used for secure token signing and verification.

## Python

- **Library**: [PyJWT](https://pyjwt.readthedocs.io/en/stable/)
- **Description**: A Python library that allows you to work with JSON Web Tokens (JWT). It supports both encoding and decoding JWTs.

## Java

- **Library**: [jjwt](https://github.com/jwtk/jjwt)
- **Description**: A popular Java library for working with JSON Web Tokens. It allows signing, parsing, and validation of JWTs with ease.

## Ruby

- **Library**: [ruby-jwt](https://github.com/jwt/ruby-jwt)
- **Description**: A simple Ruby gem for encoding and decoding JWTs, providing an easy-to-use interface for secure authentication.

---

> **Note:** Make sure to follow the respective documentation for each library to understand its full capabilities and security practices.

## Conclusion

JWTs are a powerful and flexible method for securing web applications, handling both user authentication and data transmission in a stateless manner. With proper management and implementation, JWT offers a scalable and secure solution suitable for various modern applications.
