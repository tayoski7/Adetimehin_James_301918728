# Portfolio 1 — Database Design and Modelling

I organised the data into artisan, buyer, listing, purchase, dispute. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| artisan | 1 |
| buyer | 1 |
| listing | 1 |
| purchase | 2 |
| dispute | 1 |

The 32 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](Adetimehin_James_301918728_P1_Design.md)
- [ER diagram](Adetimehin_James_301918728_P1_ERDiagram.md)
- [Normalisation](Adetimehin_James_301918728_P1_Normalisation.md)
- [Schema](Adetimehin_James_301918728_P1_Schema.sql)
- [Sample data](Adetimehin_James_301918728_P1_SampleData.sql)
- [Constraint tests](Adetimehin_James_301918728_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/Adetimehin_James_301918728_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

