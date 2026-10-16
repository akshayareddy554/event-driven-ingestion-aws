import json

def handler(event, context):
    failures = []
    for rec in event["Records"]:
        try:
            body = json.loads(rec["body"])
            print("Reserving stock for", body["orderId"])
        except Exception:
            failures.append({"itemIdentifier": rec["messageId"]})
    return {"batchItemFailures": failures}
