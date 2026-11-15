# MIT 8103 Advanced Database Systems

**TrustHand: Local Artisan Marketplace with Escrow** · James Adetimehin · Student ID 301918728

## Case study

My case study is TrustHand: Local Artisan Marketplace with Escrow. I designed the database for homeowners buying services, artisans offering services and mediators reviewing disputes, with separate tables named artisan, buyer, listing, purchase and dispute. It supports these operations: create artisan listings and purchases; record escrow status and open a dispute; review open disputes and held escrow by artisan.

## Portfolio 1: Database Design and Modelling

I organised the relational design into 5 tables. Primary keys identify records, foreign keys preserve the links, and checks enforce the stated business rules. A purchase escrow_status must be one of FUNDED, HELD, RELEASED, or REFUNDED. The normalisation examples show the sample data at 1NF, 2NF and 3NF. All 32 deliberately invalid inserts were rejected without changing the valid sample rows.

![TrustHand: Local Artisan Marketplace with Escrow ER diagram](images/Adetimehin_James_301918728_ERDiagram.png)

Figure 1. Tables, keys and relationships. PK: primary key; FK: foreign key; UK: unique value.

<!-- PAGE BREAK -->

## Portfolio 2: Query Processing and Optimisation

I ran four SQL queries against the sample records. The join returned 2 rows and included Jordan Reed with Custom oak shelf. For the index comparison, I used 50,000 separate performance rows. The median lookup time changed from 2.678 ms to 0.36 ms. Both phases returned the same records. The measured plan used the new index. These timings apply to this lookup and environment.

## Portfolio 3: Transactions and Concurrency

I used a temporary counter on dispute to test COMMIT, ROLLBACK and READ COMMITTED isolation. The uncommitted update remained hidden from the other session, and ROLLBACK restored the earlier committed value. Without locking, two increments left the counter at 2. With SELECT FOR UPDATE, Session B waited for Session A and the final value was 3. The helper is confined to this exercise; the case's original business fields stay unchanged.

## Portfolio 4: NoSQL and Advanced Data Models

I used dispute_events for the case's event documents. MongoDB inserted 2 sample events and returned the expected results for 4 queries. Validation rejected an invalid date type and a duplicate event ID. Embedded snapshots keep related details with an event, while the details field can differ by event type. These are fictional events; PostgreSQL continues to enforce its relational rules.

## Repository and evidence

https://github.com/tayoski7/Adetimehin_James_301918728

The portfolio folders contain the SQL and JavaScript, explanations, query plans, result tables and screenshots.


<!-- PAGE BREAK -->

## Portfolio 5: Distributed and Cloud Database Exercise

I proposed three MongoDB replica members across separate failure zones. The discussion covers primary elections, majority acknowledgement, secondary lag and sharding trade-offs for dispute_events. Replication supports availability, while backups address recovery. PostgreSQL needs its own availability plan. This is the permitted discussion option; no live replica set or failover test was deployed.

## Individual reflection

I kept artisan, buyer, listing, purchase, dispute in separate tables so their details could be maintained without repeating them in every related record. A purchase escrow_status must be one of FUNDED, HELD, RELEASED, or REFUNDED. The constraint tests check this alongside the required values and record links. One issue illustrated by the two-session exercise is that both sessions can read the same value before either update is committed. Locking the row before reading preserves both increments. The index comparison also shows why I need to check the execution plan as well as the final answer: the same result can require different amounts of database work.

## AI-use declaration

I used GitHub Copilot and the portfolio generator to help prepare the database model, scripts and explanations. The generator ran the PostgreSQL and MongoDB exercises, checked their outputs and captured the result images.  I remain responsible for checking and explaining the submitted work.

## References

- [PostgreSQL: constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)
- [PostgreSQL: EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)
- [PostgreSQL: isolation](https://www.postgresql.org/docs/17/transaction-iso.html)
- [PostgreSQL: row locks](https://www.postgresql.org/docs/17/explicit-locking.html)
- [MongoDB: data modelling](https://www.mongodb.com/docs/manual/data-modeling/)
- [MongoDB: replication](https://www.mongodb.com/docs/manual/replication/)
- [MongoDB: sharding](https://www.mongodb.com/docs/manual/sharding/)
- [Mermaid: ER diagrams](https://mermaid.js.org/syntax/entityRelationshipDiagram.html)

