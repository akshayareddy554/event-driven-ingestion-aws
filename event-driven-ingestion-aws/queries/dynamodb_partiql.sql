-- Run in DynamoDB console -> PartiQL editor (one statement at a time)
INSERT INTO "OrdersTable" VALUE {'PK':'CUSTOMER#c1','SK':'PROFILE','name':'Asha','email':'asha@example.com'};
INSERT INTO "OrdersTable" VALUE {'PK':'ORDER#o2','SK':'META','status':'PENDING','total':2599,'customerId':'c1','GSI1PK':'CUSTOMER#c1','GSI1SK':'2026-10-16T11:00:00Z#o2','GSI2PK':'STATUS#PENDING#2026-10-16','GSI2SK':'2026-10-16T11:00:00Z#o2'};
INSERT INTO "OrdersTable" VALUE {'PK':'ORDER#o2','SK':'ITEM#001','sku':'SKU-9','qty':2,'price':1299};

-- AP1
SELECT * FROM "OrdersTable" WHERE PK='CUSTOMER#c1' AND SK='PROFILE';
-- AP2
SELECT * FROM "OrdersTable" WHERE PK='ORDER#o2' AND SK='META';
-- AP3
SELECT * FROM "OrdersTable" WHERE PK='ORDER#o2' AND begins_with(SK,'ITEM#');
SELECT * FROM "OrdersTable" WHERE PK='ORDER#o2' AND begins_with(SK,'EVENT#');
-- AP4 (GSI1)
SELECT * FROM "OrdersTable"."GSI1" WHERE GSI1PK='CUSTOMER#c1' ORDER BY GSI1SK DESC;
-- AP5 (GSI2)
SELECT * FROM "OrdersTable"."GSI2" WHERE GSI2PK='STATUS#PENDING#2026-10-16'
  AND GSI2SK BETWEEN '2026-10-16T00:00:00Z' AND '2026-10-16T23:59:59Z';
-- Status change (moves item in GSI2)
UPDATE "OrdersTable" SET status='PAID', GSI2PK='STATUS#PAID#2026-10-16'
WHERE PK='ORDER#o2' AND SK='META';
