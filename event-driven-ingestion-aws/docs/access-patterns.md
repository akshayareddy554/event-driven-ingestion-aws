# Access Patterns and Single-Table Design

| # | Pattern | Index | Key condition |
|---|---|---|---|
| AP1 | Customer profile | Table | PK=CUSTOMER#id, SK=PROFILE |
| AP2 | Order by ID | Table | PK=ORDER#id, SK=META |
| AP3 | Order items/events | Table | PK=ORDER#id, SK begins_with ITEM#/EVENT# |
| AP4 | Customer orders, newest first | GSI1 | GSI1PK=CUSTOMER#id, GSI1SK desc |
| AP5 | Orders by status + day | GSI2 | GSI2PK=STATUS#<s>#<date>, GSI2SK range |

No Scans are used anywhere. GSI2PK includes a date bucket to avoid hot partitions.

## Item layout
| PK | SK | Attributes |
|---|---|---|
| CUSTOMER#c1 | PROFILE | name, email |
| ORDER#o1 | META | status, total, customerId, GSI1/GSI2 keys |
| ORDER#o1 | ITEM#001 | sku, qty, price |
| ORDER#o1 | EVENT#<ts>#<eventId> | type, customerId |
