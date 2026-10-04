\# Business Requirements: Food Delivery SQL Project



\## 1. Business problem



A food delivery company connects customers, restaurants and drivers. It tracks every order: the restaurant it came from, the customer who placed it, and the driver who delivered it.



The data helps the business understand:

\- which restaurants are most and least popular

\- how many orders each driver delivers per period, and how long deliveries take compared with order time

\- how satisfied customers are, and what they complain about

\- whether customers keep returning or drift away



If a restaurant's customer numbers are steadily dropping, the marketing team uses this data to decide whether to promote it. They can also check whether complaints or slow deliveries appear alongside the decline. This does not establish that either one caused it.



\## 2. Objective



Design, build and analyze a relational database (SQL Server / T-SQL) that answers the questions above, and document the reasoning behind every design and analysis decision.



\## 3. Stakeholders



| Stakeholder | Needs from the data |

|---|---|

| Marketing team | Restaurant popularity trends, customer retention |

| Restaurant owners | Their own order volume over time |

| Customers | Order confirmation, timing, driver identity |

| Drivers | Pickup and drop-off details for each order |



\## 3a. Scope



\*\*In scope:\*\* single-city operation; restaurant popularity; cancellation rate; late delivery rate; driver performance; repeat customers; customer satisfaction and complaints; descriptive restaurant order trend over time.



\*\*Out of scope, with reasons:\*\*



| Item | Reason |

|---|---|

| Menu and food-item analysis | No item data; Order Items was deliberately excluded |

| Cancellation reasons | Only a single `Cancelled` status exists |

| Preparation time, driver assignment time | No timestamps for these events |

| Real-time tracking, GPS, routes | No location-event data |

| Revenue and profitability | Payments was reviewed and removed; no KPI requires money data |

| Churn prediction | No defined observation window or enough history |

| Causal analysis | Data can show association only |

| Demographics | Not collected and not needed |

| Marketing campaign effectiveness | No campaign or promotion data |



\## 4. Business rules



1\. Every order belongs to exactly one restaurant, one registered customer and, once assigned, one driver.

2\. An order may exist without a driver. A driver is assigned after the order is placed.

3\. Valid order statuses are `Placed`, `Delivered` and `Cancelled`.

4\. A `Placed` or `Cancelled` order has no delivery time.

5\. A `Delivered` order has a driver and a delivery time.

6\. A delivered order cannot be cancelled afterwards.

7\. Each order has at most one feedback entry.

8\. A rating is a whole number from 1 to 5. The complaint text is optional.



Status: rules 1, 2 and 3 are partly enforced by foreign keys. Rules 3-8 will be enforced by constraints, or checked by validation queries, in the constraints phase.



\## 5. KPI definitions



All KPIs are reported monthly.



| # | KPI | Definition |

|---|---|---|

| 1 | Restaurant popularity | Number of `Delivered` orders per restaurant |

| 2 | Cancellation rate | Cancelled ÷ (Delivered + Cancelled) × 100, overall and per restaurant. `Placed` is excluded because it is unresolved. |

| 3 | Late delivery rate | Delivered orders with order-to-delivery time of 45 minutes or more ÷ delivered orders × 100 |

| 4 | Driver performance | Three metrics shown side by side: deliveries completed, late delivery rate, average delivery time. Only delivered orders with an assigned driver count. |

| 5 | Repeat customer rate | Customers with 2 or more `Delivered` orders ÷ customers with at least 1 `Delivered` order × 100 |

| 6 | Customer satisfaction | Four metrics: average rating, feedback response rate, percentage of feedback with a complaint, percentage of ratings of 2 or below |



\## 6. Assumptions



1\. A delivery taking 45 minutes or more counts as late. This threshold is a project-defined rule, not a real service-level agreement.

2\. The data is synthetic. Findings demonstrate method and do not describe a real company.

3\. The data has no cancellation reason, so we cannot say who or what caused a cancellation.

4\. Timestamps are recorded consistently, in a single time zone.

5\. All activity is in one city, so restaurant comparisons are fair.

6\. Driver productivity depends on how orders are dispatched. Dispatch is not modeled.

7\. Each customer account is a different real person, with no duplicates.

8\. Feedback is optional. Missing feedback does not mean satisfaction or dissatisfaction.

9\. Ratings and complaints describe only the customers who responded.

10\. Associations between delivery performance, complaints, cancellations and customer behaviour do not prove causation.



\## 7. Success criteria



\*\*Goal:\*\* the data lets marketing answer which restaurants are most popular, how cancellation and delivery performance vary, and whether customers are returning. I can show that the database is correctly designed and validated, and that the SQL analysis produces defensible business insights and recommendations.



\*\*Measurable criteria:\*\*

1\. Scripts 01 and 02 rebuild the database from scratch with zero errors, and row counts match the documentation.

2\. Every business rule is enforced by a constraint or checked by a validation query that returns zero violations.

3\. Each KPI has a saved query whose result matches a hand calculation on a small sample.

4\. Every finding states its denominator, period and limitation, and makes no causal claim.

5\. The dataset spans at least 3 months, so a restaurant trend can be shown.

6\. I can explain every table, column, relationship and constraint without notes.

