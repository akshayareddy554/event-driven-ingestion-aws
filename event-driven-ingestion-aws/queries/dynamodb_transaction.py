import boto3
c = boto3.client("dynamodb")
c.transact_write_items(TransactItems=[
 {"Put":{"TableName":"OrdersTable","Item":{"PK":{"S":"ORDER#o4"},"SK":{"S":"META"},"status":{"S":"PENDING"}},
         "ConditionExpression":"attribute_not_exists(PK)"}},
 {"Put":{"TableName":"OrdersTable","Item":{"PK":{"S":"ORDER#o4"},"SK":{"S":"ITEM#001"},"sku":{"S":"SKU-1"}}}}
])
print("transaction committed")
