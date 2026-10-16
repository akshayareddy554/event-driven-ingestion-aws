import boto3, json, time, uuid, random

kinesis = boto3.client("kinesis", region_name="us-east-1")

def send_event():
    event = {
        "eventId": str(uuid.uuid4()),
        "orderId": f"o{random.randint(1,1000)}",
        "customerId": f"c{random.randint(1,50)}",
        "eventType": random.choice(["ORDER_CREATED", "PAID", "SHIPPED"]),
        "ts": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    }
    kinesis.put_record(StreamName="order-stream",
                       Data=json.dumps(event).encode(),
                       PartitionKey=event["customerId"])
    print("sent", event["eventId"])

if __name__ == "__main__":
    for _ in range(100):
        send_event()
        time.sleep(0.1)
