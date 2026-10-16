import base64, json, boto3
table = boto3.resource("dynamodb").Table("OrdersTable")

def handler(event, context):
    failures = []
    for rec in event["Records"]:
        try:
            e = json.loads(base64.b64decode(rec["kinesis"]["data"]))
            table.put_item(Item={
                "PK": f"ORDER#{e['orderId']}",
                "SK": f"EVENT#{e['ts']}#{e['eventId']}",   # eventId makes writes idempotent
                "type": e["eventType"],
                "customerId": e["customerId"],
            })
        except Exception:
            failures.append({"itemIdentifier": rec["kinesis"]["sequenceNumber"]})
    return {"batchItemFailures": failures}
