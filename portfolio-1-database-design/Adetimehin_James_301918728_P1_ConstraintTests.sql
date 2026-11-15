-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. artisan pk. Expected: pk_artisan, SQLSTATE 23505.
INSERT INTO portfolio."artisan" ("artisan_id", "display_name", "trade")
VALUES (101, 'Casey Vale', 'Masonry');

-- 2. artisan nn id. Expected: artisan_id, SQLSTATE 23502.
INSERT INTO portfolio."artisan" ("artisan_id", "display_name", "trade")
VALUES (NULL, 'Morgan Lane', 'Painting');

-- 3. artisan nn name. Expected: display_name, SQLSTATE 23502.
INSERT INTO portfolio."artisan" ("artisan_id", "display_name", "trade")
VALUES (901, NULL, 'Painting');

-- 4. artisan nn trade. Expected: trade, SQLSTATE 23502.
INSERT INTO portfolio."artisan" ("artisan_id", "display_name", "trade")
VALUES (902, 'Morgan Lane', NULL);

-- 5. buyer pk. Expected: pk_buyer, SQLSTATE 23505.
INSERT INTO portfolio."buyer" ("buyer_id", "display_name", "created_at")
VALUES (201, 'Taylor Finch', '2026-03-01T08:00:00Z');

-- 6. buyer nn id. Expected: buyer_id, SQLSTATE 23502.
INSERT INTO portfolio."buyer" ("buyer_id", "display_name", "created_at")
VALUES (NULL, 'Riley West', '2026-03-02T08:00:00Z');

-- 7. buyer nn name. Expected: display_name, SQLSTATE 23502.
INSERT INTO portfolio."buyer" ("buyer_id", "display_name", "created_at")
VALUES (903, NULL, '2026-03-03T08:00:00Z');

-- 8. buyer nn created. Expected: created_at, SQLSTATE 23502.
INSERT INTO portfolio."buyer" ("buyer_id", "display_name", "created_at")
VALUES (904, 'Riley West', NULL);

-- 9. listing pk. Expected: pk_listing, SQLSTATE 23505.
INSERT INTO portfolio."listing" ("listing_id", "artisan_id", "title", "quote_amount")
VALUES (301, 101, 'Repair garden gate', 90);

-- 10. listing fk artisan. Expected: fk_listing_0, SQLSTATE 23503.
INSERT INTO portfolio."listing" ("listing_id", "artisan_id", "title", "quote_amount")
VALUES (905, 9905, 'Repair garden gate', 90);

-- 11. listing nn id. Expected: listing_id, SQLSTATE 23502.
INSERT INTO portfolio."listing" ("listing_id", "artisan_id", "title", "quote_amount")
VALUES (NULL, 101, 'Repair garden gate', 90);

-- 12. listing nn artisan. Expected: artisan_id, SQLSTATE 23502.
INSERT INTO portfolio."listing" ("listing_id", "artisan_id", "title", "quote_amount")
VALUES (906, NULL, 'Repair garden gate', 90);

-- 13. listing nn title. Expected: title, SQLSTATE 23502.
INSERT INTO portfolio."listing" ("listing_id", "artisan_id", "title", "quote_amount")
VALUES (907, 101, NULL, 90);

-- 14. listing nn quote. Expected: quote_amount, SQLSTATE 23502.
INSERT INTO portfolio."listing" ("listing_id", "artisan_id", "title", "quote_amount")
VALUES (908, 101, 'Repair garden gate', NULL);

-- 15. purchase pk. Expected: pk_purchase, SQLSTATE 23505.
INSERT INTO portfolio."purchase" ("purchase_id", "buyer_id", "listing_id", "escrow_amount", "escrow_status", "purchased_at")
VALUES (401, 201, 301, 75, 'FUNDED', '2026-03-04T11:00:00Z');

-- 16. purchase fk buyer. Expected: fk_purchase_0, SQLSTATE 23503.
INSERT INTO portfolio."purchase" ("purchase_id", "buyer_id", "listing_id", "escrow_amount", "escrow_status", "purchased_at")
VALUES (909, 9909, 301, 75, 'FUNDED', '2026-03-04T11:00:00Z');

-- 17. purchase fk listing. Expected: fk_purchase_1, SQLSTATE 23503.
INSERT INTO portfolio."purchase" ("purchase_id", "buyer_id", "listing_id", "escrow_amount", "escrow_status", "purchased_at")
VALUES (910, 201, 9910, 75, 'FUNDED', '2026-03-04T11:00:00Z');

-- 18. purchase nn id. Expected: purchase_id, SQLSTATE 23502.
INSERT INTO portfolio."purchase" ("purchase_id", "buyer_id", "listing_id", "escrow_amount", "escrow_status", "purchased_at")
VALUES (NULL, 201, 301, 75, 'FUNDED', '2026-03-04T11:00:00Z');

-- 19. purchase nn buyer. Expected: buyer_id, SQLSTATE 23502.
INSERT INTO portfolio."purchase" ("purchase_id", "buyer_id", "listing_id", "escrow_amount", "escrow_status", "purchased_at")
VALUES (911, NULL, 301, 75, 'FUNDED', '2026-03-04T11:00:00Z');

-- 20. purchase nn listing. Expected: listing_id, SQLSTATE 23502.
INSERT INTO portfolio."purchase" ("purchase_id", "buyer_id", "listing_id", "escrow_amount", "escrow_status", "purchased_at")
VALUES (912, 201, NULL, 75, 'FUNDED', '2026-03-04T11:00:00Z');

-- 21. purchase nn amount. Expected: escrow_amount, SQLSTATE 23502.
INSERT INTO portfolio."purchase" ("purchase_id", "buyer_id", "listing_id", "escrow_amount", "escrow_status", "purchased_at")
VALUES (913, 201, 301, NULL, 'FUNDED', '2026-03-04T11:00:00Z');

-- 22. purchase nn status. Expected: escrow_status, SQLSTATE 23502.
INSERT INTO portfolio."purchase" ("purchase_id", "buyer_id", "listing_id", "escrow_amount", "escrow_status", "purchased_at")
VALUES (914, 201, 301, 75, NULL, '2026-03-04T11:00:00Z');

-- 23. purchase nn time. Expected: purchased_at, SQLSTATE 23502.
INSERT INTO portfolio."purchase" ("purchase_id", "buyer_id", "listing_id", "escrow_amount", "escrow_status", "purchased_at")
VALUES (915, 201, 301, 75, 'FUNDED', NULL);

-- 24. purchase check status. Expected: valid_escrow_status, SQLSTATE 23514.
INSERT INTO portfolio."purchase" ("purchase_id", "buyer_id", "listing_id", "escrow_amount", "escrow_status", "purchased_at")
VALUES (916, 201, 301, 75, 'PENDING', '2026-03-04T11:00:00Z');

-- 25. dispute pk. Expected: pk_dispute, SQLSTATE 23505.
INSERT INTO portfolio."dispute" ("dispute_id", "purchase_id", "reason", "status", "opened_at")
VALUES (501, 402, 'Schedule concern', 'OPEN', '2026-03-05T12:00:00Z');

-- 26. dispute unique purchase. Expected: uq_dispute_0, SQLSTATE 23505.
INSERT INTO portfolio."dispute" ("dispute_id", "purchase_id", "reason", "status", "opened_at")
VALUES (917, 401, 'Schedule concern', 'OPEN', '2026-03-05T12:00:00Z');

-- 27. dispute fk purchase. Expected: fk_dispute_0, SQLSTATE 23503.
INSERT INTO portfolio."dispute" ("dispute_id", "purchase_id", "reason", "status", "opened_at")
VALUES (918, 9918, 'Schedule concern', 'OPEN', '2026-03-05T12:00:00Z');

-- 28. dispute nn id. Expected: dispute_id, SQLSTATE 23502.
INSERT INTO portfolio."dispute" ("dispute_id", "purchase_id", "reason", "status", "opened_at")
VALUES (NULL, 402, 'Schedule concern', 'OPEN', '2026-03-05T12:00:00Z');

-- 29. dispute nn purchase. Expected: purchase_id, SQLSTATE 23502.
INSERT INTO portfolio."dispute" ("dispute_id", "purchase_id", "reason", "status", "opened_at")
VALUES (919, NULL, 'Schedule concern', 'OPEN', '2026-03-05T12:00:00Z');

-- 30. dispute nn reason. Expected: reason, SQLSTATE 23502.
INSERT INTO portfolio."dispute" ("dispute_id", "purchase_id", "reason", "status", "opened_at")
VALUES (920, 402, NULL, 'OPEN', '2026-03-05T12:00:00Z');

-- 31. dispute nn status. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."dispute" ("dispute_id", "purchase_id", "reason", "status", "opened_at")
VALUES (921, 402, 'Schedule concern', NULL, '2026-03-05T12:00:00Z');

-- 32. dispute nn opened. Expected: opened_at, SQLSTATE 23502.
INSERT INTO portfolio."dispute" ("dispute_id", "purchase_id", "reason", "status", "opened_at")
VALUES (922, 402, 'Schedule concern', 'OPEN', NULL);
