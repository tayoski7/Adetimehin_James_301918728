# TrustHand: Local Artisan Marketplace with Escrow — Portfolio 5

This is the proposed distributed design for the case study.

## Case and proposed deployment

TrustHand: Local Artisan Marketplace with Escrow keeps its relational records in PostgreSQL. MongoDB stores dispute_events: Proposed append-oriented audit events snapshot the dispute and its purchase, buyer, listing, and artisan at event time, preserving historical context when source records later change. This is an audit-oriented model, not a claim of tamper-proof storage. Proposed deployment: the application connects to a three-member MongoDB replica set across three availability zones in one region. PostgreSQL also needs its own managed high-availability configuration. These are separate databases; a MongoDB replica set does not replicate PostgreSQL.

## Replication and availability

One primary accepts writes. Two secondaries copy the oplog asynchronously. If the primary fails, eligible members can elect a replacement when a voting majority is available. Writes can pause during election. A partition without a majority cannot elect a primary. Three containers on one computer would not protect against loss of that computer.

## Consistency and the case

For dispute_events, a proposed client policy is majority write concern with a finite timeout, primary reads and majority read concern where committed data is required. Secondary reads can lag. Application retries need an idempotency key so the same event is not recorded twice. PostgreSQL constraints remain authoritative for At most one dispute may reference a purchase; the unique purchase_id key is the database backstop under concurrent dispute attempts. These settings do not create an atomic transaction across PostgreSQL and MongoDB. An outbox and retrying consumer would be a separate implementation.

## Sharding trade-off

Sharding partitions documents; replication copies them for availability. The small sample in this portfolio does not need sharding. If dispute_events becomes large, evaluate a high-cardinality source-record identifier as a possible hashed shard key against actual query and write patterns. A time-only increasing key can concentrate new writes, while a hashed key can make time-range queries contact multiple shards. Validate distribution and query plans before choosing a key.

## Cloud deployment and recovery

A real deployment would use private networking, authentication, least-privilege roles, TLS, monitoring and tested backups. Replication also copies accidental deletions, so it does not replace backups. Availability zones do not provide regional disaster recovery. No cloud service was provisioned and no failover, replication, sharding or recovery experiment was run for this discussion.

## References

- [MongoDB: replication](https://www.mongodb.com/docs/manual/replication/)
- [MongoDB: sharding](https://www.mongodb.com/docs/manual/sharding/)

![Proposed architecture](screenshots/Adetimehin_James_301918728_P5_ProposedDesign.png)
