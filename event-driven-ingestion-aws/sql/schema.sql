CREATE TABLE customers (customer_id VARCHAR(20) PRIMARY KEY, name TEXT, email TEXT);

CREATE TABLE orders (
  order_id VARCHAR(20) PRIMARY KEY,
  customer_id VARCHAR(20) REFERENCES customers(customer_id),
  status VARCHAR(20), total NUMERIC(10,2),
  created_at TIMESTAMPTZ DEFAULT now());

CREATE TABLE order_items (
  order_id VARCHAR(20) REFERENCES orders(order_id),
  line_no INT, sku VARCHAR(30), qty INT, price NUMERIC(10,2),
  PRIMARY KEY (order_id, line_no));

CREATE TABLE order_events (
  event_id UUID PRIMARY KEY,
  order_id VARCHAR(20) REFERENCES orders(order_id),
  event_type VARCHAR(20), payload JSONB, ts TIMESTAMPTZ);

CREATE INDEX idx_orders_customer ON orders(customer_id, created_at DESC);
CREATE INDEX idx_orders_status   ON orders(status, created_at);
