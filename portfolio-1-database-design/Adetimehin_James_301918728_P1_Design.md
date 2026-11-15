# TrustHand: Local Artisan Marketplace with Escrow — database design

My case study records artisan, buyer, listing, purchase, dispute.

## Users

- Homeowners buying services
- Artisans offering services
- Mediators reviewing disputes

## Main operations

- Create artisan listings and purchases
- Record escrow status and open a dispute
- Review open disputes and held escrow by artisan

## Entities

| Entity | Information stored |
| --- | --- |
| artisan | A skilled service provider offering work through TrustHand. |
| buyer | A homeowner who purchases an artisan's listed service. |
| listing | A service listing owned by one artisan. |
| purchase | A buyer's purchase of a listing, including its escrow amount and state. |
| dispute | A buyer's dispute concerning a purchase. |

## artisan

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| artisan_id | BIGINT | PK | Yes |
| display_name | TEXT |  | Yes |
| trade | TEXT |  | Yes |


## buyer

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| buyer_id | BIGINT | PK | Yes |
| display_name | TEXT |  | Yes |
| created_at | TIMESTAMPTZ |  | Yes |


## listing

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| listing_id | BIGINT | PK | Yes |
| artisan_id | BIGINT | FK | Yes |
| title | TEXT |  | Yes |
| quote_amount | NUMERIC(18,2) |  | Yes |
- artisan_id → artisan.artisan_id

## purchase

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| purchase_id | BIGINT | PK | Yes |
| buyer_id | BIGINT | FK | Yes |
| listing_id | BIGINT | FK | Yes |
| escrow_amount | NUMERIC(18,2) |  | Yes |
| escrow_status | TEXT |  | Yes |
| purchased_at | TIMESTAMPTZ |  | Yes |
- buyer_id → buyer.buyer_id
- listing_id → listing.listing_id

## dispute

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| dispute_id | BIGINT | PK | Yes |
| purchase_id | BIGINT | FK, Unique | Yes |
| reason | TEXT |  | Yes |
| status | TEXT |  | Yes |
| opened_at | TIMESTAMPTZ |  | Yes |
- purchase_id → purchase.purchase_id
- Unique key: (purchase_id).

## Relationships and business rules

- At most one dispute may reference a purchase; the unique purchase_id key is the database backstop under concurrent dispute attempts.
- A purchase escrow_status must be one of FUNDED, HELD, RELEASED, or REFUNDED.
- Every listing must reference an existing artisan.
- Every purchase must reference an existing buyer.
- Every purchase must reference an existing listing.
- Every dispute must reference an existing purchase.

## Assumptions

- All identifiers and benchmark rows are synthetic; no real people or transactions are represented.
- Listing quote amounts and purchase escrow amounts are in USD.
- A dispute refers to exactly one purchase, and each purchase can have at most one dispute.
- The relational model does not specify payment processing or identity verification.

