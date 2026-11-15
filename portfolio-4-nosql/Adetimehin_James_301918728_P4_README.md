# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection dispute_events for dispute_opened and dispute_updated events. These are fictional event examples based on dispute, purchase, buyer, listing, artisan.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related purchase, buyer, listing, artisan details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "dispute_opened",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "dispute",
        "key": {
            "dispute_id": 501
        },
        "snapshot": {
            "dispute_id": 501,
            "purchase_id": 401,
            "reason": "Work differs from agreed scope",
            "status": "OPEN",
            "opened_at": "2026-02-03T14:15:00Z"
        }
    },
    "embedded": {
        "purchase": [
            {
                "key": {
                    "purchase_id": 401
                },
                "snapshot": {
                    "purchase_id": 401,
                    "buyer_id": 201,
                    "listing_id": 301,
                    "escrow_amount": 240,
                    "escrow_status": "HELD",
                    "purchased_at": "2026-02-01T10:30:00Z"
                },
                "via": [
                    "dispute.purchase_id → purchase"
                ]
            }
        ],
        "buyer": [
            {
                "key": {
                    "buyer_id": 201
                },
                "snapshot": {
                    "buyer_id": 201,
                    "display_name": "Jordan Reed",
                    "created_at": "2026-01-10T09:00:00Z"
                },
                "via": [
                    "dispute.purchase_id → purchase.buyer_id → buyer"
                ]
            }
        ],
        "listing": [
            {
                "key": {
                    "listing_id": 301
                },
                "snapshot": {
                    "listing_id": 301,
                    "artisan_id": 101,
                    "title": "Custom oak shelf",
                    "quote_amount": 240
                },
                "via": [
                    "dispute.purchase_id → purchase.listing_id → listing"
                ]
            }
        ],
        "artisan": [
            {
                "key": {
                    "artisan_id": 101
                },
                "snapshot": {
                    "artisan_id": 101,
                    "display_name": "Avery Stone",
                    "trade": "Carpentry"
                },
                "via": [
                    "dispute.purchase_id → purchase.listing_id → listing.artisan_id → artisan"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 1 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 2 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("dispute_events").find({"eventType":"dispute_opened"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "dispute_opened",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "dispute_id": 501
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("dispute_events").find({"source.key.dispute_id":501}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "dispute_opened",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "dispute_id": 501
    }
  },
  {
    "_id": "event_000002",
    "eventType": "dispute_updated",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "dispute_id": 501
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("dispute_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "dispute_opened",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "dispute_id": 501
    }
  },
  {
    "_id": "event_000002",
    "eventType": "dispute_updated",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "dispute_id": 501
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("dispute_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| dispute_opened | 1 |
| dispute_updated | 1 |

## Validation and suitability

MongoDB inserted 2 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 2 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Adetimehin_James_301918728_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Adetimehin_James_301918728_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

