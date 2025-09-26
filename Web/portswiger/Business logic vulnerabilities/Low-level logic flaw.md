# Exploiting Low-Level Logic Flaw in Cart Quantity Handling

This guide provides a clear, creative, and organized walkthrough to exploit a **low-level logic flaw** in an e-commerce application’s cart system. Imagine yourself as a digital mathematician, bending the rules of integer arithmetic to trick the store into selling you a luxury item for pennies! The objective is to manipulate the `quantity` parameter to overflow the cart’s total price, bring it within your $100 store credit, and purchase a leather jacket, solving the lab.

## Objective
Exploit an integer overflow vulnerability by adding a large number of items to the cart, causing the total price to wrap around to a negative value, then adjust it to a positive value between $0 and $100 using another item, enabling the purchase of the leather jacket.

## Prerequisites
- Burp Suite with Proxy, Repeater, and Intruder modules configured.
- Access to the lab application with a user account, a store, and a cart feature.
- Basic understanding of integer overflow vulnerabilities and HTTP request manipulation.

## Background on the Vulnerability
The application stores the cart’s total price in a 32-bit signed integer, with a maximum value of 2,147,483,647 (2³¹-1) and a minimum of -2,147,483,648 (-2³¹). The leather jacket’s price is 133,700 cents ($1337.00), and the `quantity` parameter is capped at two digits (1–99). By adding a large quantity repeatedly, the total price can exceed the maximum integer value, causing an overflow that wraps to a large negative value. This can be fine-tuned with additional items to bring the total within the $100 store credit limit.

## Steps to Solve the Lab

### Step 1: Attempt to Purchase the Leather Jacket
1. Open Burp’s browser, log in to your lab account, and navigate to the store.
2. Add the leather jacket to your cart and attempt to complete the order.
3. **Observation**: The order is rejected due to insufficient store credit (e.g., you have $100, but the jacket costs $1337.00).

### Step 2: Analyze the Cart Request
1. In Burp Suite, go to **Proxy > HTTP history** and locate the `POST /cart` request sent when adding the leather jacket.
2. **Observation**: The request includes a `quantity` parameter (e.g., `quantity=1`), a `productId` (e.g., `productId=1`), and possibly a `price` (e.g., `price=133700` in cents).
3. Right-click the request and select **Send to Repeater**.

### Step 3: Test Quantity Constraints
1. In Repeater, modify the `quantity` parameter to a three-digit value (e.g., `quantity=100`):
   ```
   POST /cart HTTP/1.1
   Host: YOUR-LAB-ID.web-security-academy.net
   Content-Type: application/x-www-form-urlencoded
   
   productId=1&quantity=100&price=133700
   ```
2. Send the request.
3. **Observation**: The server rejects quantities above 99, confirming a two-digit limit.

### Step 4: Trigger Integer Overflow
1. Right-click the `POST /cart` request and select **Send to Intruder**.
2. In Intruder, set the `quantity` parameter to `99`:
   ```
   productId=1&quantity=§99§&price=133700
   ```
3. Go to the **Payloads** tab, select **Payload type: Null payloads**, and under **Payload configuration**, choose **Continue indefinitely**.
4. Start the attack.
5. While the attack runs, periodically refresh the cart page in the browser and monitor the total price.
6. **Observation**: The total price increases, then suddenly flips to a large negative value (e.g., near -2,147,483,648) and starts counting up toward 0, indicating an integer overflow due to exceeding 2,147,483,647 cents.

### Step 5: Clear the Cart
1. Clear all items from the cart in the browser to reset the quantity and total.
2. **Observation**: The cart is now empty, ready for a controlled overflow.

### Step 6: Calculate and Execute Precise Overflow
1. In Intruder, recreate the attack with the same `POST /cart` request and `quantity=§99§`.
2. In the **Payloads** tab, select **Null payloads** and set **Generate exactly: 323 payloads** (to add 323 × 99 = 31,977 jackets).
3. Go to the **Resource pool** tab, add the attack to a resource pool, and set **Maximum concurrent requests** to 1 to ensure sequential requests.
4. Start the attack and wait for it to complete.
5. In Repeater, send a single `POST /cart` request with `quantity=47` for the leather jacket:
   ```
   POST /cart HTTP/1.1
   Host: YOUR-LAB-ID.web-security-academy.net
   Content-Type: application/x-www-form-urlencoded
   
   productId=1&quantity=47&price=133700
   ```
6. Refresh the cart page.
7. **Observation**: The total price is approximately -$1221.96, calculated as:
   - Total jackets: 31,977 (from Intruder) + 47 (from Repeater) = 32,024.
   - Price: 32,024 × 133,700 = 4,281,608,800 cents.
   - Overflow: 4,281,608,800 - (2 × 2,147,483,648) = -122,196 cents (-$1221.96).

### Step 7: Adjust Total with Another Item
1. Add a cheap item (e.g., a t-shirt with `productId=2`, `price=1000` cents or $10.00) to the cart.
2. In Repeater, send a `POST /cart` request with a suitable `quantity` to bring the total between $0 and $100:
   - Current total: -$1221.96.
   - Target: $0 to $100 (e.g., $50 = 5,000 cents).
   - Required adjustment: -$1221.96 + $1271.96 = $50 (127,196 cents).
   - T-shirt quantity: 127,196 ÷ 1,000 ≈ 127.
   - Request:
     ```
     POST /cart HTTP/1.1
     Host: YOUR-LAB-ID.web-security-academy.net
     Content-Type: application/x-www-form-urlencoded
     
     productId=2&quantity=127&price=1000
     ```
3. Send the request and refresh the cart.
4. **Observation**: The total is now approximately $50 (e.g., -$1221.96 + 127 × $10 = -$1221.96 + $1270 = $48.04), within your $100 credit.

### Step 8: Complete the Order
1. In the browser, proceed to checkout and place the order for the cart containing the leather jacket and t-shirts.
2. **Observation**: The order is successful, solving the lab.

### Step 9: Verify Success
1. If the lab does not confirm completion, verify:
   - The Intruder attack added exactly 323 × 99 jackets.
   - The Repeater request added 47 jackets, resulting in a negative total.
   - The cheap item’s quantity (e.g., 127 t-shirts) adjusted the total to between $0 and $100.
2. **Observation**: Successful purchase of the leather jacket completes the lab.