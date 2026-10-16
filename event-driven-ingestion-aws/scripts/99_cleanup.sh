#!/usr/bin/env bash
aws kinesis delete-stream --stream-name order-stream --enforce-consumer-deletion
aws dynamodb delete-table --table-name OrdersTable
aws sns delete-topic --topic-arn "$(aws sns list-topics --query "Topics[?contains(TopicArn,'order-events')].TopicArn" --output text)"
for q in inventory billing notification; do
  for n in $q-queue $q-dlq; do
    aws sqs delete-queue --queue-url "$(aws sqs get-queue-url --queue-name $n --query QueueUrl --output text)"
  done
done
echo "Also delete Lambdas, event source mappings, Firehose, S3 bucket, alarms manually."
