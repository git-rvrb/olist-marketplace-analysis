Olist EDA — Data Quality Notes



Working document capturing data quality issues identified during profiling





\---

**orders table**



Date columns become progressively more NULL down the fulfillment chain:

* order\_approved\_at — 160 NULLs
* order\_delivered\_carrier\_date — 1,783 NULLs
* order\_delivered\_customer\_date — 2,695 NULLs
* order\_estimated\_delivery\_date — 0 NULLs

**Interpretation:** NULLs reflect orders that didn't progress past that stage of the funnel.

**Decision:** Retain all rows. For delivery-time metrics, filter to non-NULL columns. For revenue, filter to order\_status = 'delivered'



166 orders have order\_delivered\_carrier\_date earlier than order\_purchase\_timestamp — impossible in reality.



Delivered orders with NULL delivery dates

* 2 orders delivered, NULL order\_delivered\_carrier\_date
* 8 orders delivered, NULL order\_delivered\_customer\_date

Logical inconsistency, only 10 records - exclude from delivery-performance analysis, retain for revenue.



Order status distribution

* delivered: 96,478 (97.0%)
* shipped: 1,107 (1.1%)
* canceled: 625 (0.6%)
* unavailable: 609 (0.6%)
* invoiced: 314 (0.3%)
* processing: 301 (0.3%)
* created: 5 (0.0%)
* approved: 2 (0.0%)

**Decision:** Revenue analyses → delivered only. Operational analyses → all statuses.



\---

**customers table**

Grain trap — customer\_id vs customer\_unique\_id

* customer\_id — order-scoped pseudonym, regenerated per order.
* customer\_unique\_id — actual person identifier, stable across orders.

99,441 rows / 99,441 distinct customer\_id / \~96,096 distinct customer\_unique\_id.

**Decision:** All "unique customer" counts use COUNT(DISTINCT customer\_unique\_id).



Orders per customer distribution:

* 1 order: 93,099 (96.6%)
* 2 orders: 2,745 (2.8%)
* 3 orders: 203 (0.2%)
* 4-9 orders: 48 customers
* 17 orders: 1 customer



\---

**order\_items table**

Composite primary key - PK is (order\_id, order\_item\_id). 

Grain — one order item per row

No `quantity` column. Multiple units of same product = multiple rows.

* "Units sold" = COUNT(\*) FROM order\_items
* "Distinct products sold" = COUNT(DISTINCT product\_id)



Freight cost anomalies

* 383 line items with zero freight (free shipping).

Zero orphan product\_id, zero orphan seller\_id.



\---

**order\_payments table**

Composite primary key - (order\_id, payment\_sequential)

Orders can use multiple payment instruments. Grain is one payment instrument per order, not per line item.



Voucher stacking

A minority of orders are paid entirely with multiple vouchers — up to 7 observed for a single order.

Nine zero-value payment rows - all `voucher` or `not\_defined`. 



Payment reconciliation

Sum of `payment\_value` per order should ≈ SUM(price + freight\_value) from order\_items. 



\---

**order\_reviews table**

Composite primary key - (review\_id, order\_id)

Same review\_id can apply to multiple orders when one review covers a multi-order purchase shipped together. Verified via customer\_unique\_id consistency across duplicates.

**Implication:** COUNT(\*) FROM order\_reviews counts review-order pairs. COUNT(DISTINCT review\_id) counts actual reviews.



Review timing semantics

* review\_creation\_date — Olist's review invitation sent (system-generated, midnight timestamps indicate batch process).
* review\_answer\_timestamp — customer submitted response



NULLs in comment fields

* review\_comment\_title: 88% NULL
* review\_comment\_message: 59% NULL

Score-only reviews. Not a quality issue.



\---

**products table**

610 NULL category names

Coalesce to '(unknown)' in dim\_product.



Two missing English translations

* `portateis\_cozinha\_e\_preparadores\_de\_alimentos` → "portable kitchen and food preparers"
* `pc\_gamer` → "pc gamer"

13 products affected. manually translate in `dim\_product`



Four zero-weight products

All in `cama\_mesa\_banho`

Two products with NULL physical dimensions



\---

**sellers table**

* 3,095 unique sellers, no NULLs.
* All have at least one sale.
* Top 5 states: SP (1,849, 60%), PR (349), MG (244), SC (190), RJ (171).



\---

**geolocation table**

Massive zip-prefix duplication

* 1,000,163 rows for 19,015 distinct zip prefixes (\~52 rows per zip).
* City naming inconsistent (spacing, alternate spellings)

**Decision for dim\_geography:**

* Aggregate to one row per zip prefix.
* Average lat/lng
* Pick modal city/state name



\---

**product\_category\_translation table**

71 rows. Clean — unique PK, no NULLs, no orphan rows.



