# James Adetimehin — MIT 8103

Student ID: 301918728

TrustHand — Local Artisan Marketplace with Escrow Services

TrustHand is a two-sided local marketplace designed to eliminate payment anxiety between homeowners and skilled artisans—such as plumbers, electricians, and carpenters—by integrating an automated escrow protection engine. In traditional local service transactions, buyers risk losing deposits to incomplete work while artisans face delayed payments, so TrustHand holds buyer funds securely in escrow until work milestones are verified.

To guarantee financial integrity and prevent race conditions during contested jobs, the platform's core ledger is built on a relational database structured around five primary entities: Artisan, Buyer, Listing, Purchase, and Dispute. In this schema, a Listing belongs to a specific Artisan, a Purchase links a Buyer to that Listing while tracking the escrow state, and a Dispute references the contested Purchase. To enforce the strict business rule of allowing at most one dispute per transaction, the database applies a UNIQUE foreign key constraint on the purchase reference within the dispute table.

When a buyer contests a job, the system protects the locked funds by executing an ACID-compliant SQL transaction that atomically inserts the new dispute record and updates the purchase's escrow status to HELD in a single unit of work. Using row-level locking during this transaction ensures that an artisan cannot withdraw funds at the exact moment a dispute is filed, while rolling back both operations automatically if any error occurs. For operational oversight, the mediation team runs an indexed relational join across artisans, listings, purchases, and disputes to query open dispute counts and aggregate total held escrow amounts per artisan in real time.

Finally, to maintain an immutable audit trail without slowing down the transactional ledger, TrustHand pairs its relational database with MongoDB. Whenever a dispute is opened or updated, the system captures a complete, denormalized JSON event snapshot containing the exact state of the purchase, buyer, listing, and artisan at that moment in time, providing mediators with tamper-evident historical context even if user profiles or listing prices change later.

The portfolio is being generated. Completed stages will appear in the commit history.
