# Event-Driven Data Ingestion on AWS

A scalable, event-driven data ingestion project demonstrating how AWS services can ingest, buffer, process, route, store, and analyze data using asynchronous workflows.

## Project Overview

This project explores event-driven ingestion patterns using Amazon Kinesis, AWS Lambda, Amazon DynamoDB, Amazon SNS, Amazon SQS, Amazon S3, Amazon Data Firehose, and Amazon Athena. It also includes PostgreSQL examples for relational data and SQL operations.

## Architecture

### Streaming ingestion
```text
Producer → Kinesis Data Streams → Lambda → DynamoDB
                                      ↓
                             DynamoDB Streams
                                      ↓
                                    Lambda
                                      ↓
                                SNS Topic
                                      ↓
                           SQS Queues (fan-out)
                                      ↓
                             Consumer Lambdas
```

### API and analytics paths
```text
API → SQS Buffer → Lambda → DynamoDB

Data → Firehose → S3 → Athena (analytics)
```

> These diagrams describe the intended architecture. Deploy the required AWS resources and event-source mappings before running end-to-end tests.

## Key Features

- Event-driven data ingestion and asynchronous processing.
- Streaming ingestion with Kinesis and Lambda.
- DynamoDB storage, access patterns, and Global Secondary Indexes (GSIs).
- SNS-to-SQS fan-out for distributing events to multiple consumers.
- Dead-letter queue (DLQ) patterns for handling failed messages.
- S3-based data storage and Athena queries for analytics.
- SQL examples using PostgreSQL.
- Operational queries for SQS, SNS, Kinesis, and CloudWatch Logs Insights.

## Technology Stack

- **Language:** Python
- **Python dependency:** boto3
- **AWS:** DynamoDB, Kinesis Data Streams, Lambda, SNS, SQS, S3, Data Firehose, CloudWatch, Athena
- **Database:** PostgreSQL
- **Tools:** AWS CLI / CloudShell, Docker, `psql` or DBeaver

## Repository Guide

| Path | Purpose |
|---|---|
| `producer/` | Kinesis producer code |
| `lambdas/` | Lambda consumer and processing code |
| `scripts/01_create_table.sh` | Create DynamoDB table resources |
| `scripts/02_sns_sqs.sh` | Configure SNS/SQS resources |
| `scripts/03_kinesis.sh` | Configure or exercise Kinesis resources |
| `scripts/99_cleanup.sh` | Remove resources created for the project |
| `sql/` | PostgreSQL SQL scripts |
| `queries/` | DynamoDB, SQS/SNS, Kinesis, CloudWatch, and Athena queries |
| `docs/` | Design decisions and access-pattern documentation |
| `requirements.txt` | Python dependencies |

Paths above reflect the intended repository layout; ensure these files and folders are present in your GitHub repository.

## Prerequisites

- Python 3
- An AWS account and appropriately configured AWS credentials
- AWS CLI, with permissions for the AWS services used
- Bash-compatible shell (Linux, macOS, WSL, or AWS CloudShell)
- Docker and PostgreSQL client tools if you want to run the local PostgreSQL example

**Security:** Never commit AWS access keys, secret keys, `.env` files, private certificates, or other credentials. Use an IAM role or a locally configured AWS profile with least-privilege permissions.

## Setup and Run

### 1. Clone the repository

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
cd <YOUR_REPOSITORY_FOLDER>
```

Replace the placeholders with your repository URL and folder name.

### 2. Create a virtual environment and install dependencies

Linux, macOS, WSL, or CloudShell:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Windows PowerShell:

```powershell
py -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

### 3. Configure AWS credentials

Configure a named AWS CLI profile or use an IAM role in your execution environment. Verify the identity before running scripts:

```bash
aws sts get-caller-identity
```

Do not put credentials directly in source code.

### 4. Create and configure resources

Run the scripts from the repository root in the intended order, after reviewing their contents and required permissions:

```bash
bash scripts/01_create_table.sh
bash scripts/02_sns_sqs.sh
bash scripts/03_kinesis.sh
```

Create the Lambda functions and configure their event-source mappings and permissions as documented in `lambdas/` and `docs/`.

### 5. Run the producer and operational queries

```bash
python producer/producer.py
bash queries/sqs_sns_ops.sh
```

Use the query files in `queries/` in their intended environment. For example, DynamoDB PartiQL queries run in the DynamoDB PartiQL editor, CloudWatch Logs Insights queries run in CloudWatch, and Athena SQL runs in the Athena query editor.

### 6. Clean up resources

When finished, review the cleanup script and run it if appropriate:

```bash
bash scripts/99_cleanup.sh
```

AWS resources may incur charges while they exist. Confirm which resources the cleanup script removes; delete any remaining resources manually if needed.

## Local PostgreSQL Example

Start a local PostgreSQL container:

```bash
docker run --name pg -e POSTGRES_PASSWORD=pass -p 5432:5432 -d postgres:16
```

Apply the schema, if `sql/schema.sql` is present:

```bash
psql -h localhost -U postgres -f sql/schema.sql
```

The example password is for local demonstration only. Do not use it in production.

## Design and Learning Outcomes

- Compare SQL and NoSQL trade-offs for a given access pattern.
- Design DynamoDB tables and GSIs around query requirements.
- Use SNS and SQS to distribute events to multiple consumers.
- Explore retries and dead-letter queues for failed messages.
- Produce and consume streaming records with Kinesis and Lambda.
- Store data in S3 and query it with Athena.
- Inspect operational behavior using CloudWatch and service-specific queries.

## Current Scope and Limitations

This README documents the project's intended architecture and run sequence. Successful deployment depends on the actual scripts, Lambda code, IAM policies, event-source mappings, and AWS configuration in the repository. Validate each component and test the complete flow before describing it as production-ready.

## License

Add a license file if you intend to publish this project for reuse. Until then, no license is specified.
