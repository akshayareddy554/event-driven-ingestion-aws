#!/usr/bin/env bash
TOPIC_ARN=$(aws sns list-topics --query "Topics[?contains(TopicArn,'order-events')].TopicArn" --output text)
INV_URL=$(aws sqs get-queue-url --queue-name inventory-queue --query QueueUrl --output text)

# Publish test events (check filtering: SHIPPED must NOT reach inventory)
aws sns publish --topic-arn $TOPIC_ARN --message '{"orderId":"o5","customerId":"c1"}' \
  --message-attributes '{"eventType":{"DataType":"String","StringValue":"ORDER_CREATED"}}'
aws sns publish --topic-arn $TOPIC_ARN --message '{"orderId":"o6"}' \
  --message-attributes '{"eventType":{"DataType":"String","StringValue":"SHIPPED"}}'

# Inspect
aws sqs get-queue-attributes --queue-url $INV_URL \
  --attribute-names ApproximateNumberOfMessages ApproximateNumberOfMessagesNotVisible
aws sqs receive-message --queue-url $INV_URL --max-number-of-messages 10 --wait-time-seconds 5
aws sns list-subscriptions-by-topic --topic-arn $TOPIC_ARN

# DLQ replay (replace ARNs)
# aws sqs start-message-move-task --source-arn <DLQ_ARN> --destination-arn <QUEUE_ARN>
# Clear a test queue
# aws sqs purge-queue --queue-url $INV_URL

# DLQ alarm (replace OPS_TOPIC_ARN)
# aws cloudwatch put-metric-alarm --alarm-name inventory-dlq-not-empty \
#  --namespace AWS/SQS --metric-name ApproximateNumberOfMessagesVisible \
#  --dimensions Name=QueueName,Value=inventory-dlq --statistic Maximum --period 60 \
#  --evaluation-periods 1 --threshold 0 --comparison-operator GreaterThanThreshold \
#  --alarm-actions <OPS_TOPIC_ARN>
