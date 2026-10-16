#!/usr/bin/env bash
set -euo pipefail
TOPIC_ARN=$(aws sns create-topic --name order-events --query TopicArn --output text)
echo "TOPIC_ARN=$TOPIC_ARN"

declare -A FILTERS=(
  [inventory]='{"eventType":["ORDER_CREATED"]}'
  [billing]='{"eventType":["ORDER_CREATED","PAID"]}'
  [notification]='{"eventType":["PAID","SHIPPED"]}'
)

for q in inventory billing notification; do
  DLQ_URL=$(aws sqs create-queue --queue-name $q-dlq --query QueueUrl --output text)
  DLQ_ARN=$(aws sqs get-queue-attributes --queue-url "$DLQ_URL" \
            --attribute-names QueueArn --query Attributes.QueueArn --output text)
  Q_URL=$(aws sqs create-queue --queue-name $q-queue --query QueueUrl --output text)
  Q_ARN=$(aws sqs get-queue-attributes --queue-url "$Q_URL" \
            --attribute-names QueueArn --query Attributes.QueueArn --output text)

  DLQ_ARN="$DLQ_ARN" Q_ARN="$Q_ARN" TOPIC_ARN="$TOPIC_ARN" python3 - > /tmp/attr.json <<'PY'
import json, os
print(json.dumps({
 "VisibilityTimeout": "60",
 "RedrivePolicy": json.dumps({"deadLetterTargetArn": os.environ["DLQ_ARN"], "maxReceiveCount": "3"}),
 "Policy": json.dumps({"Version":"2012-10-17","Statement":[{
   "Effect":"Allow","Principal":{"Service":"sns.amazonaws.com"},
   "Action":"sqs:SendMessage","Resource":os.environ["Q_ARN"],
   "Condition":{"ArnEquals":{"aws:SourceArn":os.environ["TOPIC_ARN"]}}}]})
}))
PY
  aws sqs set-queue-attributes --queue-url "$Q_URL" --attributes file:///tmp/attr.json

  FP="${FILTERS[$q]}" python3 - > /tmp/sub.json <<'PY'
import json, os
print(json.dumps({"RawMessageDelivery":"true","FilterPolicy":os.environ["FP"]}))
PY
  aws sns subscribe --topic-arn "$TOPIC_ARN" --protocol sqs \
    --notification-endpoint "$Q_ARN" --attributes file:///tmp/sub.json
  echo "$q queue wired"
done
