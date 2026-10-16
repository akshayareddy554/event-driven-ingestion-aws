#!/usr/bin/env bash
aws kinesis put-record --stream-name order-stream --partition-key c1 \
  --cli-binary-format raw-in-base64-out \
  --data '{"eventId":"e1","orderId":"o1","customerId":"c1","eventType":"PAID","ts":"2026-10-16T10:01:00Z"}'

aws kinesis list-shards --stream-name order-stream
IT=$(aws kinesis get-shard-iterator --stream-name order-stream \
   --shard-id shardId-000000000000 --shard-iterator-type TRIM_HORIZON \
   --query ShardIterator --output text)
aws kinesis get-records --shard-iterator $IT --limit 10    # Data is base64

# Consumer lag
aws cloudwatch get-metric-statistics --namespace AWS/Kinesis \
  --metric-name GetRecords.IteratorAgeMilliseconds \
  --dimensions Name=StreamName,Value=order-stream \
  --start-time $(date -u -d '-1 hour' +%FT%TZ) --end-time $(date -u +%FT%TZ) \
  --period 300 --statistics Maximum
