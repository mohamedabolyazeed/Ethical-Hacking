# Exploiting Flawed Enforcement of Business Rules

This guide delivers a clear, creative, and organized walkthrough to exploit a **flawed enforcement of business rules** in an e-commerce application's coupon system. Picture yourself as a savvy deal-hunter, stacking discounts like a master strategist to snag a luxury item for a fraction of its cost! The objective is to bypass coupon application restrictions by alternating two coupon codes, reducing the order total below your store credit, and purchasing a leather jacket to solve the lab.

## Objective
Exploit weak coupon validation by repeatedly applying two coupon codes (`NEWCUST5` and `SIGNUP30`) in an alternating pattern to reduce the order total below your available store credit, enabling the purchase of the leather jacket.

## Prerequisites
- Burp Suite with Proxy configured (optional for monitoring, but not strictly required).
- Access to the lab application with a user account, a store, a cart, and a newsletter signup feature.
- Basic understanding of business logic vulnerabilities and coupon mechanics.

## Background on the Vulnerability
The application allows applying multiple coupon codes but rejects consecutive uses of the same code, enforcing a "one-use-per-code" rule. However, it fails to limit the total number of coupon applications or prevent alternating between different codes. By repeatedly applying two valid coupons (`NEWCUST5` and `SIGNUP30`) in sequence, attackers can stack discounts to reduce the order total arbitrarily, bypassing financial restrictions.

## Steps to Solve the Lab

### Step 1: Log In and Identify Coupon Codes
1. Open the lab’s browser, log in to your account, and navigate to the homepage.
2. **Observation**: A coupon code `NEWCUST5` is displayed (likely offering a small discount, e.g., 5% or $5 off).
3. Scroll to the bottom of the page and sign up for the newsletter.
4. **Observation**: You receive a second coupon code `SIGNUP30` (likely offering a larger discount, e.g., 30% or $30 off).

![image](img/Flawed%20enforcement%20of%20business%20rules/Flawed%20enforcement%20of%20business%20rules(1).png)
![image](img/Flawed%20enforcement%20of%20business%20rules/Flawed%20enforcement%20of%20business%20rules(2).png)

### Step 2: Add the Leather Jacket to the Cart
1. Navigate to the store and add the leather jacket to your cart.
2. Proceed to the checkout page.
3. **Observation**: The cart displays the leather jacket’s price (e.g., $1000) and an option to apply coupon codes.

### Step 3: Apply Coupon Codes
1. On the checkout page, apply the `NEWCUST5` coupon code.
2. **Observation**: The order total is reduced (e.g., by 5% or $5).
3. Apply the `SIGNUP30` coupon code.
4. **Observation**: The order total is further reduced (e.g., by 30% or $30), confirming both codes can be applied once.

### Step 4: Test Coupon Reuse Restrictions
1. Try applying `NEWCUST5` again.
2. **Observation**: The application rejects the second consecutive use, indicating a "coupon already applied" restriction.
3. Apply `SIGNUP30` followed by `NEWCUST5` again.
4. **Observation**: The application accepts the alternating coupons, applying additional discounts and further reducing the total.

### Step 5: Stack Coupons to Reduce Total
1. Alternate between `NEWCUST5` and `SIGNUP30`, applying them repeatedly:
   - Enter `NEWCUST5`, submit, then enter `SIGNUP30`, submit, and repeat.
2. Monitor the order total after each application.
3. **Example Calculation**:
   - Initial total: $1000 (leather jacket).
   - `NEWCUST5`: Assume 5% off → $1000 × 0.95 = $950.
   - `SIGNUP30`: Assume 30% off → $950 × 0.7 = $665.
   - Repeat `NEWCUST5`: $665 × 0.95 = $631.75.
   - Repeat `SIGNUP30`: $631.75 × 0.7 ≈ $442.23.
   - Continue alternating until the total is below your store credit (e.g., $100).
4. **Observation**: After several iterations, the total drops significantly (e.g., to $50), within your credit limit.

### Step 6: Complete the Order
1. With the order total below your store credit, proceed to checkout and place the order for the leather jacket.
2. **Observation**: The order is successful, solving the lab.

![image](img/Flawed%20enforcement%20of%20business%20rules/Flawed%20enforcement%20of%20business%20rules(3).png)

### Step 7: Verify Success
1. If the lab does not confirm completion, verify:
   - Both `NEWCUST5` and `SIGNUP30` were applied multiple times in an alternating pattern.
   - The final order total is less than your available store credit.
   - The cart contains the leather jacket.
2. **Observation**: Successful purchase of the leather jacket completes the lab.