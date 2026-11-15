# TrustHand: Local Artisan Marketplace with Escrow — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| purchase_id | dispute records (list) |
| --- | --- |
| 401 | [501] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| dispute.dispute_id | dispute.purchase_id | dispute.reason | purchase.purchase_id | purchase.buyer_id | purchase.listing_id | purchase.escrow_status | buyer.buyer_id |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 501 | 401 | Work differs from agreed scope | 401 | 201 | 301 | HELD | 201 |

Key: dispute_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## dispute_example

| dispute.dispute_id | dispute.purchase_id | dispute.reason | purchase.purchase_id | purchase.buyer_id | purchase.listing_id | purchase.escrow_status | buyer.buyer_id |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 501 | 401 | Work differs from agreed scope | 401 | 201 | 301 | HELD | 201 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## artisan

| artisan_id | display_name | trade |
| --- | --- | --- |
| 101 | Avery Stone | Carpentry |

## buyer

| buyer_id | display_name | created_at |
| --- | --- | --- |
| 201 | Jordan Reed | 2026-01-10T09:00:00+00:00 |

## listing

| listing_id | artisan_id | title | quote_amount |
| --- | --- | --- | --- |
| 301 | 101 | Custom oak shelf | 240 |

## purchase

| purchase_id | buyer_id | listing_id | escrow_amount | escrow_status | purchased_at |
| --- | --- | --- | --- | --- | --- |
| 401 | 201 | 301 | 240 | HELD | 2026-02-01T10:30:00+00:00 |
| 402 | 201 | 301 | 120 | FUNDED | 2026-02-02T10:30:00+00:00 |

## dispute

| dispute_id | purchase_id | reason | status | opened_at |
| --- | --- | --- | --- | --- |
| 501 | 401 | Work differs from agreed scope | OPEN | 2026-02-03T14:15:00+00:00 |

## Dependencies

- artisan: (artisan_id) → display_name, trade
- buyer: (buyer_id) → display_name, created_at
- listing: (listing_id) → artisan_id, title, quote_amount
- purchase: (purchase_id) → buyer_id, listing_id, escrow_amount, escrow_status, purchased_at
- dispute: (dispute_id) → purchase_id, reason, status, opened_at

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
