# SQL vs NoSQL Decision Matrix

## Workload
- ~5,000 writes/sec with unpredictable spikes
- Key-based reads, single-digit ms latency
- Variable event attributes, no ad-hoc joins on the hot path
- Needs auto-scaling and multi-AZ availability

| Criterion | SQL (RDS/Aurora) | NoSQL (DynamoDB) | Winner |
|---|---|---|---|
| Schema | Fixed, migrations | Flexible per item | NoSQL |
| Write scaling | Vertical, single writer | Horizontal, near-unlimited | NoSQL |
| Latency at scale | Varies with joins/load | Consistent single-digit ms | NoSQL |
| Query flexibility | Ad-hoc SQL, joins | Designed access patterns only | SQL |
| Transactions | Full multi-table ACID | Limited TransactWriteItems | SQL |
| Ops effort | Patching, sizing | Fully managed | NoSQL |
| Cost, spiky load | Provisioned capacity | On-demand per request | NoSQL |
| Analytics | Excellent | Weak (use S3 + Athena) | SQL |

## Justification
DynamoDB fits a write-heavy, spiky, key-based workload with flexible event
attributes. Reporting is handled by exporting to S3 and querying with Athena.
Trade-off accepted: access patterns must be designed up front.

## When SQL would win
Complex joins, ad-hoc analytics, or strict multi-table transactions.
