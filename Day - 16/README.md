# SQL Product Pair Recommendation Analysis

## Problem Statement

Find product pairs that were purchased together in the same order and calculate how many times each pair appeared.

This type of problem is commonly used in:

* Recommendation systems
* Market basket analysis
* E-commerce analytics
* Association rule mining

---

# Tables Used

## Orders Table

| order_id | customer_id | product_id |
| -------- | ----------- | ---------- |
| 1        | 1           | 1          |
| 1        | 1           | 2          |
| 1        | 1           | 3          |
| 2        | 2           | 1          |
| 2        | 2           | 2          |
| 2        | 2           | 4          |
| 3        | 1           | 5          |

---

## Products Table

| id | name |
| -- | ---- |
| 1  | A    |
| 2  | B    |
| 3  | C    |
| 4  | D    |
| 5  | E    |

---

# SQL Solution

```sql
select
    p1.name as product_1,
    p2.name as product_2,
    count(*) as purchase_frequency

from orders o1

join orders o2
    on o1.order_id = o2.order_id
    and o1.product_id < o2.product_id

join products p1
    on o1.product_id = p1.id

join products p2
    on o2.product_id = p2.id

group by
    p1.name,
    p2.name

order by purchase_frequency desc;
```

---

# Explanation

## Step 1: Self Join

The `orders` table is joined with itself.

```sql
from orders o1
join orders o2
```

This helps compare products within the same order.

---

## Step 2: Match Same Orders

```sql
o1.order_id = o2.order_id
```

This ensures only products belonging to the same order are compared.

---

## Step 3: Remove Duplicate Pairs

```sql
o1.product_id < o2.product_id
```

This condition:

* Removes self-pairs like `A-A`
* Removes duplicate reverse pairs like:

  * `A-B`
  * `B-A`

Only one unique combination is kept.

---

## Step 4: Count Pair Frequency

```sql
count(*)
```

Counts how many times each product pair appeared together.

---

# Output

| product_1 | product_2 | purchase_frequency |
| --------- | --------- | ------------------ |
| A         | B         | 2                  |
| A         | C         | 1                  |
| B         | C         | 1                  |
| A         | D         | 1                  |
| B         | D         | 1                  |

---

# Key Concepts Learned

* Self Join
* Pair Generation
* Aggregation
* Group By
* Recommendation System Foundations
* Market Basket Analysis

---

# Important Learning

A self join is not simply joining tables.

It is:

> Comparing rows inside the same dataset to discover relationships.
