-- Show related buyer, purchase, listing records (up to 20).
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

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
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

-- Find dispute records where purchase_id matches 401 (up to 20).
SELECT * FROM portfolio."dispute"
WHERE "purchase_id" IS NOT DISTINCT FROM 401
ORDER BY "dispute_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."dispute"
WHERE "purchase_id" IS NOT DISTINCT FROM 401
ORDER BY "dispute_id"
LIMIT 20;

-- Count listing records for each artisan_id (up to 20 groups).
SELECT "artisan_id", count(*) AS record_count
FROM portfolio."listing"
GROUP BY "artisan_id"
ORDER BY record_count DESC, "artisan_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "artisan_id", count(*) AS record_count
FROM portfolio."listing"
GROUP BY "artisan_id"
ORDER BY record_count DESC, "artisan_id" NULLS LAST
LIMIT 20;

-- Find purchase records where escrow_status matches "HELD" (up to 20).
SELECT * FROM portfolio."purchase"
WHERE "escrow_status" IS NOT DISTINCT FROM 'HELD'
ORDER BY "purchase_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."purchase"
WHERE "escrow_status" IS NOT DISTINCT FROM 'HELD'
ORDER BY "purchase_id"
LIMIT 20;
