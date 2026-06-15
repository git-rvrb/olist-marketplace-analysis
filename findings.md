Olist EDA - Analytical Findings



Working document capturing analytical observations from the data. These are the findings that will shape the dashboard and recommendations.





\---

**Dataset shape and scope:**



**Time span:** Sept 2016 → Oct 2018. First "real" sales month: January 2017.

* **Customers (unique people):** \~96,096
* **Customer-order records:** 99,441
* **Orders:** 99,441 (96,478 delivered)
* **Line items:** 112,650
* **Products sold:** 32,951 across 73 categories
* **Sellers:** 3,095 (all active)
* **Geographic coverage:** 4,119 customer cities; 19,015 zip prefixes



\---

**Geographic breakdown:** 

São Paulo and Rio de Janeiro dominate both sides of the marketplace



**Top 10 customer cities:**

|Rank|City|Customers|% of total|
|-|-|-|-|
|1|São Paulo|15,540|15.6%|
|2|Rio de Janeiro|6,882|6.9%|
|3|Belo Horizonte|2,773|2.8%|
|4|Brasília|2,131|2.1%|
|5|Curitiba|1,521|1.5%|
|6|Campinas|1,444|1.5%|
|7|Porto Alegre|1,379|1.4%|
|8|Salvador|1,245|1.3%|
|9|Guarulhos|1,189|1.2%|
|10|São Bernardo do Campo|938|0.9%|



**Top 5 seller states:** SP (60%), PR (11%), MG (8%), SC (6%), RJ (6%).



Sellers concentrate in São Paulo state (60% of all sellers). Customer freight scales with distance from the South:

|State|Region|n\_orders|freight\_pct\_of\_gmv|avg\_freight|
|-|-|-|-|-|
|SP|Southeast (sellers' base)|40,501|13.85%|$17|
|RJ|Southeast|12,350|16.81%|$24|
|MG|Southeast|11,354|17.16%|$23|
|RS|South|5,345|18.19%|$25|
|BA|Northeast|3,256|19.76%|$30|
|PE|Northeast|1,593|22.66%|$36|
|PA|North (Amazon)|946|21.52%|$40|
|MA|Far North|717|**26.32%**|$43|

**Key insights:**

1. Remote-state customers pay \~2.5× the freight per order vs. São Paulo customers ($43 vs. $17), while spending only \~45% more on goods. Freight scales much faster than order value with distance.
2. Top 3 Southeast states (SP, RJ, MG) account for \~65% of orders. Remote North/Northeast states are <10% combined.

The marketplace is functionally a Southeast Brazil marketplace.



\---

**Order status distribution:** 

97% delivered. Remaining 3%:

* 609 `unavailable` — low/no-stock maybe
* 625 `cancelled` — customer experience signal
* 1,107 `shipped` — in-transit



\---

**Payment behaviour:**

* 74% credit card, 19% boleto, 5% voucher, 2% debit card
* Boleto is Brazilian — printable invoice paid at a bank/convenience store
* 50% of payments made in installments, with a long tail up to 24 months
* Majority of orders use one payment instrument; multi-instrument splits uncommon



\---

**Review score distribution:**

* 5★: 58%
* 4★: 19%
* 3★: 8.5%
* 2★: 3% (least common)
* 1★: 11.5%

indifferent customers don't review. The 1★ population is the key for understanding what goes wrong



\---

**Cohort retention:**

Olist's monthly retention is essentially zero.

January 2017 cohort (717 customers, first real cohort): monthly returns of 0.14% – 0.7%. February 2017 (1,628): 0.12% – 0.43%.

**Dashboard implication:** Heatmap will need a clipped colour scale for the low variance to be visible. 



\---

**RFM segmentation — adapted to Olist's data shape:**



Custom segmentation oriented to R × M plane (F as 3-tier marker: 1/3/5 = 1/2/3+ orders) yields the following:

|Segment|Customers|%|Revenue ($)|Avg spend|Avg orders|
|-|-|-|-|-|-|
|Lapsed — High Value|13,780|14.8%|4,240,936|307.76|1.00|
|Promising|14,156|15.2%|4,130,222|291.76|1.00|
|New — High Value|7,168|7.7%|2,156,661|300.87|1.00|
|Lapsed — Low Value|22,568|24.2%|1,640,577|72.69|1.00|
|Hibernating|22,003|23.6%|1,596,301|72.55|1.00|
|New — Low Value|10,882|11.7%|790,888|72.68|1.00|
|Repeat — Lapsing|1,491|1.6%|427,696|286.85|2.00|
|Repeat — Active|1,082|1.2%|321,114|296.78|2.00|
|Loyal — Active|121|0.1%|66,885|552.77|3.52|
|Loyal — Lapsing|107|0.1%|48,490|453.18|3.26|

**Key insights:**

1. **Lapsed — High Value** is the biggest revenue contributor (28% of revenue from 14.8% of customers). \~14,000 customers who once spent \~$308 but have gone cold, represents a win-back opportunity.
2. **True loyal customers exist but are rare** — 228 total across both Loyal segments, avg lifetime spend \~$500 across 3+ orders. Investigating what's distinctive about their first orders could inform acquisition strategy.
3. **Promising customers** (15.2%, 27% of revenue) — single-purchase, decent spend, not too old.

**Hibernating + Lapsed Low + New Low** (\~55,000 customers, \~27% of revenue)



\---

**Seller revenue concentration:**

NTILE-based percentile summary (top X% of sellers by revenue rank):

* Top 1% of sellers → \~25% of revenue
* Top 5% → \~52% of revenue
* Top 10% → \~66% of revenue
* Top 20% → \~81% of revenue



\---

**Delivery performance vs. review score:**



**Delivery lateness is the strongest predictor of review score**

|Delivery status|Orders|% of total|Avg score|% 1★|% bad reviews (1-2★)|
|-|-|-|-|-|-|
|On time / early|89,944|93.3%|4.29|6.6%|9.3%|
|Late 1-3 days|1,856|1.9%|3.29|25.2%|32.2%|
|Late 4-7 days|1,756|1.8%|2.10|58.5%|67.7%|
|Late 8+ days|2,797|2.9%|1.70|69.7%|79.2%|

* **Orders delivered 8+ days late are 8.5× more likely to receive a bad review** than on-time orders.
* **70% of orders 8+ days late receive a 1-star review**.
* **Even 1-3 days of lateness triples the bad-review rate from 9% to 32%**.



\~9% of on-time orders still receive bad reviews. Non-delivery factors (product quality, expectations mismatch, customer service etc) 



**key insight:** Late deliveries (7% of orders) drag review scores down disproportionately. Reducing late deliveries is the single most leveraged action available for improving review scores/customer experience and would likely help with acquisition as well (strong overall review scores drive new purchases).



