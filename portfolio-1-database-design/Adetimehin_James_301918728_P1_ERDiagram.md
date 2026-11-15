# TrustHand: Local Artisan Marketplace with Escrow — ER diagram

```mermaid
erDiagram
    direction LR
    artisan {
        bigint artisan_id PK
        text display_name
        text trade
    }
    buyer {
        bigint buyer_id PK
        text display_name
        timestamptz created_at
    }
    listing {
        bigint listing_id PK
        bigint artisan_id FK
        text title
        numeric quote_amount
    }
    purchase {
        bigint purchase_id PK
        bigint buyer_id FK
        bigint listing_id FK
        numeric escrow_amount
        text escrow_status
        timestamptz purchased_at
    }
    dispute {
        bigint dispute_id PK
        bigint purchase_id FK,UK
        text reason
        text status
        timestamptz opened_at
    }
    artisan ||--o{ listing : "artisan_id"
    buyer ||--o{ purchase : "buyer_id"
    listing ||--o{ purchase : "listing_id"
    purchase ||--o| dispute : "purchase_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Adetimehin_James_301918728_ERDiagram.png)
