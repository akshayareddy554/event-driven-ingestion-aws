import boto3, json, os
sns = boto3.client("sns")
TOPIC = os.environ["TOPIC_ARN"]      # set as Lambda environment variable

def handler(event, context):
    for rec in event["Records"]:
        if rec["eventName"] == "INSERT":
            new = rec["dynamodb"]["NewImage"]
            if new["SK"]["S"] == "META":
                sns.publish(TopicArn=TOPIC,
                    Message=json.dumps({"orderId": new["PK"]["S"]}),
                    MessageAttributes={"eventType": {"DataType": "String",
                                                     "StringValue": "ORDER_CREATED"}})
