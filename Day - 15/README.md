# Amazon Music to Prime Conversion Analysis

## Problem Statement

Calculate the conversion rate of users who:

1. Accessed Amazon Music
2. Later upgraded to Prime membership
3. Upgraded within 30 days of signing up

---

## Assumption

This solution assumes the following customer journey:

```text
User Signup → Music Access → Prime Subscription
```

Meaning:
- A user must access Music first
- Then subscribe to Prime
- Prime subscription must happen within 30 days of signup

---

## Tables Used

### users

Contains user signup information.

| Column | Description |
|---|---|
| user_id | Unique user identifier |
| name | User name |
| join_date | Signup date |

---

### events

Contains user activity events.

| Column | Description |
|---|---|
| user_id | Unique user identifier |
| type | Event type |
| access_date | Event date |

Event Types:
- `Music` → User accessed Amazon Music
- `P` → User subscribed to Prime

---

## SQL Concepts Used

- Common Table Expressions (CTEs)
- LEFT JOIN
- Filtering with date conditions
- Interval arithmetic
- Aggregations
- Conversion ratio calculation
- DISTINCT counting

---

## Approach

The query is divided into multiple CTEs for readability and debugging.

### Step 1 — Combine Users and Events

Create a base dataset containing:
- user information
- event information

---

### Step 2 — Separate Music Users

Filter users who accessed Music.

---

### Step 3 — Separate Prime Users

Filter users who subscribed to Prime.

---

### Step 4 — Match Music and Prime Events

Join Music and Prime activity for the same user.

---

### Step 5 — Apply Business Conditions

Keep users where:
- Prime subscription happened after Music access
- Prime subscription happened within 30 days of signup

---

### Step 6 — Calculate Metrics

- Total Music users
- Total converted users
- Conversion ratio

---

## Final Output

| music_users | req_users | conv_ratio |
|---|---|---|
| 3 | 2 | 0.67 |

---

## Learning Outcomes

This project demonstrates:

- Breaking complex SQL logic into modular CTEs
- Handling ambiguous business requirements using assumptions
- Building conversion funnel logic
- Writing readable analytical SQL
- Using date-based filtering effectively

---

## Author

Pavan Kumar