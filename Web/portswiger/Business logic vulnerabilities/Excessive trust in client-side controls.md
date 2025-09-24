# Exploiting Excessive Trust in Client-Side Controls

This guide delivers a clear, creative, and organized walkthrough to exploit a vulnerability caused by **excessive trust in client-side controls**. Picture yourself as a cunning shopper, rewriting the price tags in a digital store to snag a luxury item for pocket change! The objective is to manipulate the `price` parameter in the cart request to bypass credit restrictions, purchase a leather jacket, and solve the lab.

## Objective
Modify the client-controlled `price` parameter in the cart request to set an affordable price within your store credit, allowing you to complete the purchase of the leather jacket.

## Prerequisites
- Burp Suite with Proxy and Repeater modules configured.
- Access to the lab application with a user account, a store, and a cart feature.
- Basic understanding of HTTP requests and parameter manipulation.

## Background on the Vulnerability
The application trusts the client-side `price` parameter in the `POST /cart` request without server-side validation, allowing attackers to arbitrarily set the price of items. This enables bypassing financial restrictions, such as insufficient store credit, to purchase items at a manipulated cost.

## Steps to Solve the Lab

### Step 1: Attempt to Purchase the Leather Jacket
1. Open Burp’s browser, log in to your lab account, and navigate to the store.
2. Add the leather jacket to your cart and attempt to complete the order.
3. **Observation**: The order is rejected due to insufficient store credit.

### Step 2: Analyze the Cart Request
1. In Burp Suite, go to **Proxy > HTTP history** and locate the `POST /cart` request sent when adding the leather jacket to the cart.
2. **Observation**: The request includes a `price` parameter (e.g., `price=1000`) alongside other parameters like `productId` or `quantity`.
3. Right-click the request and select **Send to Repeater**.

### Step 3: Manipulate the Price Parameter
1. In Repeater, modify the `price` parameter to an arbitrary value (e.g., `price=10`):
   ```
   POST /cart HTTP/1.1
   Host: YOUR-LAB-ID.web-security-academy.net
   Content-Type: application/x-www-form-urlencoded
   
   productId=1&quantity=1&price=133700
   ```
2. Send the request.
3. Refresh the cart page in the browser.
4. **Observation**: The cart reflects the modified price, confirming the server trusts the client-side `price` value.

![payload suc](./img/Excessive%20trust%20in%20client-side%20controls/Excessive%20trust%20in%20client-side%20controls(1).png)

### Step 4: Set an Affordable Price
1. In Repeater, adjust the `price` parameter to a value less than your available store credit (e.g., if you have 50 credits, set `price=49`):
   ```
   POST /cart HTTP/1.1
   Host: YOUR-LAB-ID.web-security-academy.net
   Content-Type: application/x-www-form-urlencoded
   
   productId=1&quantity=1&price=10
   ```
2. Send the request.
3. Refresh the cart page to confirm the price update.
4. **Observation**: The cart now shows a price within your credit limit.

![payload suc](./img/Excessive%20trust%20in%20client-side%20controls/Excessive%20trust%20in%20client-side%20controls(2).png)

### Step 5: Complete the Order
1. In the browser, proceed to checkout and complete the order for the leather jacket.
2. **Observation**: The order is successful, solving the lab.

### Step 6: Verify Success
1. If the lab does not confirm completion, verify:
   - The `price` parameter is set to a value less than your store credit.
   - The `POST /cart` request includes correct `productId` and `quantity` values.
   - The cart page reflects the manipulated price before checkout.
2. **Observation**: Successful purchase of the leather jacket completes the lab.

![payload suc](./img/Excessive%20trust%20in%20client-side%20controls/Excessive%20trust%20in%20client-side%20controls(3).png)