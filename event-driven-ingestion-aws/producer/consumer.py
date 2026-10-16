import boto3, json, time
k = boto3.client("kinesis", region_name="us-east-1")
shards = k.list_shards(StreamName="order-stream")["Shards"]
iters = {s["ShardId"]: k.get_shard_iterator(StreamName="order-stream",
         ShardId=s["ShardId"], ShardIteratorType="TRIM_HORIZON")["ShardIterator"]
         for s in shards}
while True:
    for sid, it in list(iters.items()):
        resp = k.get_records(ShardIterator=it, Limit=100)
        for r in resp["Records"]:
            print(sid, json.loads(r["Data"]))
        iters[sid] = resp["NextShardIterator"]
    time.sleep(1)
