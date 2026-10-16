#!/usr/bin/env bash
# AP2
aws dynamodb get-item --table-name OrdersTable --key '{"PK":{"S":"ORDER#o2"},"SK":{"S":"META"}}'
# AP3
aws dynamodb query --table-name OrdersTable --key-condition-expression "PK = :p" \
  --expression-attribute-values '{":p":{"S":"ORDER#o2"}}'
# AP4
aws dynamodb query --table-name OrdersTable --index-name GSI1 \
  --key-condition-expression "GSI1PK = :c" \
  --expression-attribute-values '{":c":{"S":"CUSTOMER#c1"}}' --no-scan-index-forward
# AP5
aws dynamodb query --table-name OrdersTable --index-name GSI2 \
  --key-condition-expression "GSI2PK = :s" \
  --expression-attribute-values '{":s":{"S":"STATUS#PENDING#2026-10-16"}}'
# Conditional write (fails if item exists)
aws dynamodb put-item --table-name OrdersTable \
  --item '{"PK":{"S":"ORDER#o3"},"SK":{"S":"META"},"status":{"S":"PENDING"}}' \
  --condition-expression "attribute_not_exists(PK)"
# Query vs Scan cost comparison
aws dynamodb query --table-name OrdersTable --key-condition-expression "PK = :p" \
  --expression-attribute-values '{":p":{"S":"ORDER#o2"}}' --return-consumed-capacity TOTAL
aws dynamodb scan --table-name OrdersTable --return-consumed-capacity TOTAL
