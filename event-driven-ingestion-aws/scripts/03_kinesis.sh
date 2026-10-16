#!/usr/bin/env bash
set -euo pipefail
aws kinesis create-stream --stream-name order-stream --stream-mode-details StreamMode=ON_DEMAND
aws kinesis wait stream-exists --stream-name order-stream
aws kinesis describe-stream-summary --stream-name order-stream
