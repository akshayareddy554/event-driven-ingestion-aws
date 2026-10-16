INSERT INTO customers VALUES ('c1','Asha','asha@example.com');
INSERT INTO orders (order_id,customer_id,status,total) VALUES ('o1','c1','PENDING',1499);

-- AP2
SELECT * FROM orders WHERE order_id='o1';
-- AP3
SELECT o.*, i.sku, i.qty, e.event_type
FROM orders o
LEFT JOIN order_items i  ON i.order_id=o.order_id
LEFT JOIN order_events e ON e.order_id=o.order_id
WHERE o.order_id='o1';
-- AP4
SELECT * FROM orders WHERE customer_id='c1' ORDER BY created_at DESC;
-- AP5
SELECT * FROM orders WHERE status='PENDING'
  AND created_at BETWEEN '2026-10-16' AND '2026-10-17';
-- Where SQL wins: ad-hoc analytics
SELECT c.name, SUM(o.total) AS revenue, COUNT(*) AS orders
FROM orders o JOIN customers c USING (customer_id)
WHERE o.created_at > now() - interval '30 days'
GROUP BY c.name ORDER BY revenue DESC LIMIT 10;
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id='c1';
