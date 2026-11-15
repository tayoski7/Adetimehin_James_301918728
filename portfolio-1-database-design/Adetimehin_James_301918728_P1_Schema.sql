-- TrustHand: Local Artisan Marketplace with Escrow: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."artisan" (
  "artisan_id" bigint NOT NULL,
  "display_name" text NOT NULL,
  "trade" text NOT NULL,
  CONSTRAINT "pk_artisan" PRIMARY KEY ("artisan_id")
);
CREATE TABLE portfolio."buyer" (
  "buyer_id" bigint NOT NULL,
  "display_name" text NOT NULL,
  "created_at" timestamptz NOT NULL,
  CONSTRAINT "pk_buyer" PRIMARY KEY ("buyer_id")
);
CREATE TABLE portfolio."listing" (
  "listing_id" bigint NOT NULL,
  "artisan_id" bigint NOT NULL,
  "title" text NOT NULL,
  "quote_amount" numeric(18,2) NOT NULL,
  CONSTRAINT "pk_listing" PRIMARY KEY ("listing_id")
);
CREATE TABLE portfolio."purchase" (
  "purchase_id" bigint NOT NULL,
  "buyer_id" bigint NOT NULL,
  "listing_id" bigint NOT NULL,
  "escrow_amount" numeric(18,2) NOT NULL,
  "escrow_status" text NOT NULL,
  "purchased_at" timestamptz NOT NULL,
  CONSTRAINT "pk_purchase" PRIMARY KEY ("purchase_id")
);
CREATE TABLE portfolio."dispute" (
  "dispute_id" bigint NOT NULL,
  "purchase_id" bigint NOT NULL,
  "reason" text NOT NULL,
  "status" text NOT NULL,
  "opened_at" timestamptz NOT NULL,
  CONSTRAINT "pk_dispute" PRIMARY KEY ("dispute_id"),
  CONSTRAINT "uq_dispute_0" UNIQUE ("purchase_id")
);
ALTER TABLE portfolio."listing" ADD CONSTRAINT "fk_listing_0" FOREIGN KEY ("artisan_id") REFERENCES portfolio."artisan" ("artisan_id");
ALTER TABLE portfolio."purchase" ADD CONSTRAINT "fk_purchase_0" FOREIGN KEY ("buyer_id") REFERENCES portfolio."buyer" ("buyer_id");
ALTER TABLE portfolio."purchase" ADD CONSTRAINT "fk_purchase_1" FOREIGN KEY ("listing_id") REFERENCES portfolio."listing" ("listing_id");
ALTER TABLE portfolio."dispute" ADD CONSTRAINT "fk_dispute_0" FOREIGN KEY ("purchase_id") REFERENCES portfolio."purchase" ("purchase_id");
ALTER TABLE portfolio."purchase" ADD CONSTRAINT "valid_escrow_status" CHECK (("escrow_status" = 'FUNDED') OR ("escrow_status" = 'HELD') OR ("escrow_status" = 'RELEASED') OR ("escrow_status" = 'REFUNDED'));
COMMIT;
