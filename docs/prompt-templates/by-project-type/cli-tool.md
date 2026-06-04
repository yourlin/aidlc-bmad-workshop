# AWS CLI 工具 / SDK 项目模板

## PM — 创建 PRD

```
CP

Create a PRD for [PROJECT_NAME] — an AWS CLI/SDK tool.

Purpose: [WHAT AWS-RELATED PROBLEM DOES IT SOLVE]
Target users: [DevOps / Developers / Platform Engineers]

Commands:
- [COMMAND_1] — [e.g. deploy Lambda function with canary]
- [COMMAND_2] — [e.g. scan DynamoDB table and export to CSV]
- [COMMAND_3] — [e.g. rotate Secrets Manager credentials]

AWS Services involved:
- [Lambda / DynamoDB / S3 / CloudFormation / ECS / etc.]

Features:
- AWS credential handling: [AWS profile / SSO / environment vars]
- Multi-region support: [yes/no]
- Output formats: [JSON / table / plain text]
- Dry-run mode: [show what would change without executing]

Focus on:
- AWS API call patterns and error handling
- Rate limiting and retry strategies (exponential backoff)
- IAM permissions required (document minimal policy)
- Cross-account operation support (if applicable)

Constraints:
- [TIME_CONSTRAINT]
- Target: npm package (npx executable)
- Must handle AWS credential chain correctly

Output: _bmad-output/planning-artifacts/prd.md
```

## Architect — 创建架构

```
CA

Create architecture for [PROJECT_NAME] AWS CLI tool.

Tech: Node.js/TypeScript + AWS SDK v3 + Commander.js
Requirements:
- Command parsing: Commander.js
- AWS credentials: @aws-sdk/credential-providers (chain)
- AWS clients: modular SDK v3 (tree-shakeable)
- Output formatting: table (cli-table3) + JSON
- Progress: ora spinner for long operations
- Logging: structured, --verbose flag

Design:
- Command → Handler → AWS Service Client → Output
- Credential resolution order (profile → SSO → env → instance)
- Error handling: AWS SDK errors → user-friendly messages
- Retry strategy: built-in SDK retry + custom for rate limits
- Testability: mock AWS SDK clients

Output: Architecture document + module structure
```

## Developer — 实现命令

```
DS

Implement the "[COMMAND_NAME]" command.

Tech: TypeScript + AWS SDK v3 + Commander.js
AWS services: [LIST SERVICES AND OPERATIONS]
Requirements:
- Command signature: [FULL COMMAND WITH FLAGS]
- AWS operations: [LIST API CALLS]
- Error handling: [SPECIFIC AWS ERRORS TO HANDLE]
- Output: [WHAT GETS PRINTED]
- Dry-run: show planned actions without executing

Unit tests:
- Mock AWS SDK clients (aws-sdk-client-mock)
- Test successful operation
- Test AWS error handling (throttle, access denied, not found)
- Test dry-run mode

IAM permissions needed:
- [LIST SPECIFIC ACTIONS, e.g. dynamodb:Scan, lambda:UpdateFunctionCode]
```

## QA — 测试策略

```
TS

Generate test strategy for [PROJECT_NAME] AWS CLI tool.

Coverage:
- Unit tests: command handlers with mocked AWS SDK
- Integration tests: against LocalStack or real AWS (sandbox account)
- Error scenarios: expired credentials, throttling, permission denied
- Edge cases: empty results, pagination, large payloads
- Cross-platform: Windows path handling

Tools: Jest + aws-sdk-client-mock
Special: 
- Use LocalStack for integration tests (docker-compose)
- Document required IAM policy for CI/CD testing

Output: Test strategy document
```
