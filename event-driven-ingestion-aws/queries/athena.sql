-- Run in Athena console after Firehose has written to S3
CREATE DATABASE IF NOT EXISTS ingestion;

CREATE EXTERNAL TABLE ingestion.order_events (
  eventId string, orderId string, customerId string, eventType string, ts string)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
LOCATION 's3://<your-bucket>/orders/';

SELECT eventType, COUNT(*) AS cnt FROM ingestion.order_events GROUP BY eventType ORDER BY cnt DESC;

SELECT customerId, substr(ts,1,13) AS hour, COUNT(*) AS events
FROM ingestion.order_events GROUP BY customerId, substr(ts,1,13) ORDER BY events DESC LIMIT 20;

SELECT orderId FROM ingestion.order_events GROUP BY orderId
HAVING bool_or(eventType='PAID') AND NOT bool_or(eventType='SHIPPED');
