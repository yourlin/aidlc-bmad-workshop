# AWS Serverless 事件驱动项目模板 (Lambda + EventBridge + SQS)

## PM — 创建 PRD

```
CP

Create a PRD for [PROJECT_NAME] — an AWS serverless event-driven application.

Cloud provider: AWS
Trigger types:
- API Gateway → Lambda (同步 API 调用)
- SQS/SNS/EventBridge → Lambda (异步事件处理)
- CloudWatch Events / EventBridge Scheduler (定时任务)

Core functions:
- [FUNCTION_1]: triggered by [TRIGGER], does [ACTION]
- [FUNCTION_2]: triggered by [TRIGGER], does [ACTION]
- [FUNCTION_3]: triggered by [TRIGGER], does [ACTION]

Data stores:
- [DynamoDB] for [PURPOSE]
- [S3] for [PURPOSE]
- [ElastiCache] for [PURPOSE] (if needed)

Focus on:
- Event flow between functions
- Data consistency (eventual vs strong)
- Cold start impact on user experience
- Cost estimation (pay-per-invocation model)
- Error handling and DLQ strategy

Constraints:
- [TIME_CONSTRAINT]
- Lambda memory/timeout: [LIMITS]
- Concurrency limits: [IF APPLICABLE]

Output: _bmad-output/planning-artifacts/prd.md
```

## Architect — 创建架构

```
CA

Create serverless architecture for [PROJECT_NAME].

Stack: [e.g. AWS Lambda + API Gateway + DynamoDB + CDK]
Requirements:
- Serverless-first (no long-running processes)
- [DATABASE] with [ACCESS_PATTERN_DESCRIPTION]
- [AUTH_METHOD] via [e.g. Lambda Authorizer / Cognito]
- Observability: [CloudWatch / X-Ray / Datadog]
- IaC: [CDK / Terraform / SAM / Serverless Framework]

Design decisions:
- Single-table DynamoDB vs multi-table (justify choice)
- Lambda packaging strategy (individual vs shared layer)
- API versioning approach
- Event-driven vs synchronous communication
- Retry and DLQ strategy for async operations
- Cold start mitigation (provisioned concurrency? / keep-warm?)

Output: Architecture document including:
- System context diagram
- Event flow diagram
- DynamoDB access patterns table
- Lambda function inventory
- IAM permission matrix (least privilege)
```

## Developer — 实现 Lambda

```
DS

Implement the "[FUNCTION_NAME]" Lambda function.

Tech: [LANGUAGE] + [RUNTIME]
Trigger: [API Gateway / SQS / EventBridge / Schedule]
Requirements:
- Input: [DESCRIBE INPUT/EVENT SHAPE]
- Processing: [BUSINESS LOGIC]
- Output: [RESPONSE FORMAT / SIDE EFFECTS]
- DynamoDB operations: [GET/PUT/QUERY/UPDATE]
- Error handling: catch, log, return appropriate response
- Cold start optimized: initialize clients outside handler

Unit tests:
- Mock [AWS SDK CLIENTS]
- Test happy path + error scenarios
- Test input validation

Follow patterns from [REFERENCE_FUNCTION].
```

## Architect — CDK/IaC

```
CI

Create CDK infrastructure for [PROJECT_NAME].

Based on architecture at _bmad-output/planning-artifacts/architecture.md:
- DynamoDB table(s): [DESCRIBE PK/SK PATTERNS]
- Lambda functions: [LIST FUNCTIONS WITH TRIGGERS]
- API Gateway: [ROUTES AND METHODS]
- IAM roles: least privilege per function
- CloudWatch alarms: [error rate, latency P95, throttles]
- [ADDITIONAL RESOURCES: SQS, SNS, S3, etc.]

Requirements:
- CDK v2 + [LANGUAGE]
- Separate stacks by concern (API, Database, Monitoring)
- Environment-aware (dev/staging/prod via context)
- Outputs: API URL, table names, function ARNs

Output: src/infra/
```

## Test Architect — E2E 测试

```
E2E

Create E2E tests for [PROJECT_NAME] serverless app.

Stack: [TEST_FRAMEWORK] + [HTTP_CLIENT]
Environment: [LOCAL_EMULATION or DEPLOYED_STAGE]

Scenarios:
1. API flow: authenticated request → Lambda → DynamoDB → response
2. Event flow: publish event → Lambda triggered → side effect verified
3. Error scenarios: invalid auth → 401, bad input → 400, DDB throttle → retry

Local testing strategy:
- [DynamoDB Local / LocalStack / SAM Local]
- Environment variables for local vs deployed

Output: src/__tests__/e2e/
```
