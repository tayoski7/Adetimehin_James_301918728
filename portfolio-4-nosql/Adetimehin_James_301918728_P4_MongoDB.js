// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("dispute_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("dispute_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "dispute_opened",
                    "dispute_updated"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "dispute"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "dispute_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("dispute_events").insertMany([
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
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "dispute_updated",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "dispute",
                    "key": {
                        "dispute_id": 501
                    },
                    "field": "reason",
                    "value": "Work differs from agreed scope"
                },
                {
                    "entity": "dispute",
                    "key": {
                        "dispute_id": 501
                    },
                    "field": "status",
                    "value": "OPEN"
                }
            ]
        }
    }
]));
  await db.getCollection("dispute_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("dispute_events").find({"eventType":"dispute_opened"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("dispute_events").find({"source.key.dispute_id":501}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("dispute_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("dispute_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("dispute_events").insertOne({...{
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
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("dispute_events").insertOne({
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
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("dispute_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
