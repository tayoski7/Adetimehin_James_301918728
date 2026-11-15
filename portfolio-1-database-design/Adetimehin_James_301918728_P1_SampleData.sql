-- Fictional sample records for TrustHand: Local Artisan Marketplace with Escrow.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."artisan" ("artisan_id", "display_name", "trade") VALUES (101, 'Avery Stone', 'Carpentry');
INSERT INTO portfolio."buyer" ("buyer_id", "display_name", "created_at") VALUES (201, 'Jordan Reed', '2026-01-10T09:00:00Z');
INSERT INTO portfolio."listing" ("listing_id", "artisan_id", "title", "quote_amount") VALUES (301, 101, 'Custom oak shelf', 240);
INSERT INTO portfolio."purchase" ("purchase_id", "buyer_id", "listing_id", "escrow_amount", "escrow_status", "purchased_at") VALUES (401, 201, 301, 240, 'HELD', '2026-02-01T10:30:00Z');
INSERT INTO portfolio."purchase" ("purchase_id", "buyer_id", "listing_id", "escrow_amount", "escrow_status", "purchased_at") VALUES (402, 201, 301, 120, 'FUNDED', '2026-02-02T10:30:00Z');
INSERT INTO portfolio."dispute" ("dispute_id", "purchase_id", "reason", "status", "opened_at") VALUES (501, 401, 'Work differs from agreed scope', 'OPEN', '2026-02-03T14:15:00Z');
COMMIT;
