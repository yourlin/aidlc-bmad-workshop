# AWS 全栈 Web 应用模板 (Amplify / CloudFront + Lambda)

## PM — 创建 PRD

```
CP

Create a PRD for [PROJECT_NAME] — an AWS full-stack web application.

Frontend:
- [FRAMEWORK: React/Vue/Next.js] hosted on [AWS Amplify / CloudFront + S3]
- Key pages: [LIST PAGES, e.g. Dashboard, User Profile, Settings]
- Target devices: [desktop/mobile/both]

Backend:
- API Gateway + Lambda (REST or GraphQL via AppSync)
- Database: [DynamoDB / Aurora Serverless]
- Auth: Amazon Cognito (User Pool + Identity Pool)

User flows:
1. [PRIMARY_FLOW, e.g. Cognito signup → Email verify → Login → Dashboard]
2. [SECONDARY_FLOW, e.g. Create item → Edit → Share → Delete]

Focus on:
- User journey for each page
- Cognito auth flow (signup, login, MFA, password reset)
- API contract between frontend and backend
- Real-time features (AppSync subscriptions / WebSocket API)

Constraints:
- [TIME_CONSTRAINT]
- MVP: [describe minimum pages/features]
- AWS region: [REGION]

Output: _bmad-output/planning-artifacts/prd.md
```

## Architect — 创建架构

```
CA

Create AWS architecture for [PROJECT_NAME] full-stack web app.

Frontend: [FRAMEWORK] + [STATE_MANAGEMENT] → CloudFront + S3 (or Amplify Hosting)
Backend: API Gateway + Lambda + [DynamoDB / Aurora Serverless]
Auth: Amazon Cognito
CDN: CloudFront
IaC: AWS CDK v2

Design:
- Frontend: component hierarchy, Cognito auth integration, API client
- Backend: Lambda handlers, DynamoDB access patterns
- Auth: Cognito User Pool config (attributes, MFA, email verify)
- File uploads: S3 + presigned URLs (if applicable)
- Real-time: AppSync / API Gateway WebSocket (if applicable)

Key decisions:
- REST API vs GraphQL (AppSync)
- SSR (Lambda@Edge) vs CSR (S3 + CloudFront)
- DynamoDB single-table vs Aurora Serverless
- Amplify vs custom CDK deployment

Output: Architecture document with AWS service diagram
```

## Developer — 前端 Story

```
DS

Implement the "[PAGE_NAME]" page.

Tech: [FRAMEWORK] + [UI_LIBRARY] + AWS Amplify client SDK
Requirements:
- Route: /[path]
- Cognito auth: [require login? / specific group?]
- API calls: [LIST Lambda-backed API endpoints]
- S3 operations: [file upload/download if applicable]
- Loading/error states with Cognito token refresh

Follow existing patterns from [REFERENCE_COMPONENT].
```

## Developer — 后端 Lambda

```
DS

Implement Lambda handler for "[FEATURE_NAME]".

Tech: Node.js/TypeScript + AWS SDK v3
Requirements:
- API Gateway event → Lambda → DynamoDB → response
- Cognito authorizer: extract userId from event.requestContext
- DynamoDB: [DESCRIBE OPERATIONS]
- Input validation: Zod schema
- Error handling: consistent format

Unit tests: mock DynamoDB client, test handler logic
```

## Architect — CDK IaC

```
CI

Create CDK infrastructure for [PROJECT_NAME] AWS full-stack app.

Stacks:
1. AuthStack: Cognito User Pool, Identity Pool, App Client
2. ApiStack: API Gateway, Lambda functions, Authorizer
3. DatabaseStack: DynamoDB table(s)
4. FrontendStack: S3 bucket, CloudFront distribution, OAC
5. MonitoringStack: CloudWatch dashboards, alarms

Requirements:
- CDK v2 + TypeScript
- Outputs: CloudFront URL, API URL, Cognito config
- Environment-aware (dev/prod via CDK context)

Output: src/infra/
```
