# Testing 阶段通用模板

> 适用于 AWS 项目的测试阶段 Prompt 模式

## 测试策略（QA Agent）

```
/bmad-testarch-test-design

TS

Generate test strategy for [PROJECT_NAME].

Existing test framework: [Jest / pytest / JUnit]
AWS services to test against: [DynamoDB / S3 / Lambda / etc.]

Coverage matrix:
| Layer | What | How |
|-------|------|-----|
| Unit | Lambda handlers | Mock AWS SDK |
| Integration | DB operations | DynamoDB Local / LocalStack |
| E2E | Full API flow | HTTP calls to deployed/local |
| Contract | API schema | OpenAPI validation |

Quality gates:
- Line coverage > [X]%
- Branch coverage > [Y]%
- All critical paths tested
- No security vulnerabilities

Output: Test strategy + priority matrix
```

## 验收测试用例（QA Agent）

```
/bmad-testarch-test-design

AC

Write acceptance test cases for [FEATURE_NAME].

Based on PRD at _bmad-output/planning-artifacts/prd.md.

For each endpoint/function, create:
1. Happy path scenario
2. Validation error scenarios
3. Auth failure scenarios
4. Business logic edge cases

Format: Given / When / Then
Output: acceptance-tests.md
```

## E2E 测试（Test Architect Agent）

```
/bmad-tea

E2E

Create end-to-end tests for [PROJECT_NAME].

Stack: [TEST_FRAMEWORK] + [HTTP_CLIENT]
Test against: [LOCAL / DEPLOYED_STAGE_URL]

Scenarios:
1. [SCENARIO_1: describe full user flow]
2. [SCENARIO_2: describe error flow]
3. [SCENARIO_3: describe auth flow]

AWS Local testing:
- DynamoDB: [DynamoDB Local / docker]
- Lambda: [SAM local / direct handler invocation]
- API Gateway: [local HTTP server / SAM local]

Setup/teardown:
- Before all: create test data
- After all: clean up test data
- Isolate: each test uses unique identifiers

Output: src/__tests__/e2e/
```

## 性能测试（Test Architect Agent）

```
/bmad-tea

PF

Create performance test scripts for [PROJECT_NAME].

Tool: [Artillery / k6 / aws-load-testing]
Target: [API_URL or Lambda function]

Scenarios:
- Sustained load: [X] RPS for [Y] seconds
- Spike test: ramp from [A] to [B] RPS in [C] seconds
- Cold start measurement: invoke after 15 min idle

Success criteria:
- P50 latency < [X]ms
- P95 latency < [Y]ms
- P99 latency < [Z]ms
- Error rate < [N]%
- No Lambda throttling

Output: src/performance/ + results interpretation guide
```

## 安全测试（Test Architect Agent）

```
/bmad-tea

ST

Create security test cases for [PROJECT_NAME].

Check for:
1. Auth bypass: access protected endpoints without token
2. Injection: SQL/NoSQL injection in input fields
3. IDOR: access another user's resources
4. Rate limiting: verify throttle at [N] requests
5. Input size: oversized payloads handled gracefully
6. Secrets: no hardcoded credentials in code

AWS-specific checks:
- Lambda environment variables don't contain secrets (use SSM/Secrets Manager)
- IAM roles follow least privilege
- DynamoDB: no scan operations exposed to users
- S3: no public buckets, presigned URLs expire properly

Output: security-test-cases.md
```

## Review Gate #2 评审

```
Start Party Mode with Amelia, Quinn, and Winston.

Review all implementation artifacts:
1. Does code match architecture design?
2. Are tests covering defined acceptance criteria?
3. Is IaC deployable and matching requirements?
4. Security: auth, validation, IAM permissions?
5. Code quality: naming, structure, error handling?
6. Can this be safely deployed to production?
```
