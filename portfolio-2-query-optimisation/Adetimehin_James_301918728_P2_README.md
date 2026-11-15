# TrustHand: Local Artisan Marketplace with Escrow — SQL queries

## 1. Show related buyer, purchase, listing records (up to 20).

```sql
SELECT t0."buyer_id" AS "buyer_buyer_id",
       t0."display_name" AS "buyer_display_name",
       t1."purchase_id" AS "purchase_purchase_id",
       t1."escrow_amount" AS "purchase_escrow_amount",
       t2."listing_id" AS "listing_listing_id",
       t2."title" AS "listing_title"
FROM portfolio."buyer" t0
JOIN portfolio."purchase" t1 ON t1."buyer_id" = t0."buyer_id"
JOIN portfolio."listing" t2 ON t1."listing_id" = t2."listing_id"
ORDER BY t0."buyer_id", t1."purchase_id", t2."listing_id"
LIMIT 20;
```

| buyer_buyer_id | buyer_display_name | purchase_purchase_id | purchase_escrow_amount | listing_listing_id | listing_title |
| --- | --- | --- | --- | --- | --- |
| 201 | Jordan Reed | 401 | 240 | 301 | Custom oak shelf |
| 201 | Jordan Reed | 402 | 120 | 301 | Custom oak shelf |

## 2. Find dispute records where purchase_id matches 401 (up to 20).

```sql
SELECT * FROM portfolio."dispute"
WHERE "purchase_id" IS NOT DISTINCT FROM 401
ORDER BY "dispute_id"
LIMIT 20;
```

| dispute_id | purchase_id | reason | status | opened_at |
| --- | --- | --- | --- | --- |
| 501 | 401 | Work differs from agreed scope | OPEN | 2026-02-03T14:15:00+00:00 |

## 3. Count listing records for each artisan_id (up to 20 groups).

```sql
SELECT "artisan_id", count(*) AS record_count
FROM portfolio."listing"
GROUP BY "artisan_id"
ORDER BY record_count DESC, "artisan_id" NULLS LAST
LIMIT 20;
```

| artisan_id | record_count |
| --- | --- |
| 101 | 1 |

## 4. Find purchase records where escrow_status matches "HELD" (up to 20).

```sql
SELECT * FROM portfolio."purchase"
WHERE "escrow_status" IS NOT DISTINCT FROM 'HELD'
ORDER BY "purchase_id"
LIMIT 20;
```

| purchase_id | buyer_id | listing_id | escrow_amount | escrow_status | purchased_at |
| --- | --- | --- | --- | --- | --- |
| 401 | 201 | 301 | 240 | HELD | 2026-02-01T10:30:00+00:00 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 2.678 | 3.155, 2.658, 2.678 | Sort → Seq Scan | 322 |
| After index | 0.36 | 0.334, 0.364, 0.36 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 2.678 ms to 0.36 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=3.118..3.121 rows=50 loops=1)
  Seq Scan on purchase (actual time=0.021..3.055 rows=50 loops=1)
Planning Time: 0.448 ms
Execution Time: 3.155 ms
```

### Before index, run 2

```text
Sort (actual time=2.624..2.627 rows=50 loops=1)
  Seq Scan on purchase (actual time=0.016..2.583 rows=50 loops=1)
Planning Time: 0.383 ms
Execution Time: 2.658 ms
```

### Before index, run 3

```text
Sort (actual time=2.641..2.644 rows=50 loops=1)
  Seq Scan on purchase (actual time=0.017..2.598 rows=50 loops=1)
Planning Time: 0.386 ms
Execution Time: 2.678 ms
```

### After index, run 1

```text
Sort (actual time=0.278..0.281 rows=50 loops=1)
  Bitmap Heap Scan on purchase (actual time=0.029..0.238 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.017 rows=50 loops=1)
Planning Time: 0.609 ms
Execution Time: 0.334 ms
```

### After index, run 2

```text
Sort (actual time=0.298..0.301 rows=50 loops=1)
  Bitmap Heap Scan on purchase (actual time=0.028..0.257 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=50 loops=1)
Planning Time: 0.605 ms
Execution Time: 0.364 ms
```

### After index, run 3

```text
Sort (actual time=0.303..0.305 rows=50 loops=1)
  Bitmap Heap Scan on purchase (actual time=0.029..0.24 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.017..0.017 rows=50 loops=1)
Planning Time: 0.598 ms
Execution Time: 0.36 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Adetimehin_James_301918728_P2_Queries.sql, then Adetimehin_James_301918728_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Adetimehin_James_301918728_P2_QueryResults.png) · [Index comparison](screenshots/Adetimehin_James_301918728_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

