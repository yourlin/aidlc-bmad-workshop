# 提示词模板库 (Prompt Template Library)

> 按 AWS 项目类型分类的 Seed Prompt 模板，可根据实际项目快速定制。
> 所有模板基于 AWS 技术栈（Lambda、DynamoDB、API Gateway、CDK 等）。

## 使用方法

1. 根据你的 AWS 项目类型选择对应模板
2. 复制适合的模板
3. 替换 `[占位符]` 为你的实际内容
4. 粘贴到对应 Agent 中使用

## 目录结构

```
prompt-templates/
├── by-project-type/
│   ├── rest-api.md          — AWS RESTful API (API Gateway + Lambda + DynamoDB)
│   ├── fullstack-web.md     — AWS 全栈 Web (Amplify/CloudFront + Lambda + Cognito)
│   ├── serverless.md        — AWS 事件驱动 (Lambda + EventBridge + SQS)
│   └── cli-tool.md          — AWS CLI/SDK 工具 (AWS SDK v3 + Commander)
├── by-phase/
│   ├── inception.md         — Inception 阶段通用模板
│   ├── architecture.md      — 架构阶段通用模板
│   ├── development.md       — 开发阶段通用模板
│   └── testing.md           — 测试阶段通用模板
└── README.md                — 本文件
```

## 模板中的占位符约定

| 占位符 | 含义 | 示例 |
|--------|------|------|
| `[PROJECT_NAME]` | 项目名称 | Hotel Booking API |
| `[TECH_STACK]` | 技术栈 | Node.js + Lambda + DynamoDB |
| `[ENDPOINTS]` | API 端点列表 | POST /rooms, GET /rooms/{id} |
| `[DATABASE]` | 数据库类型 | DynamoDB single-table |
| `[AUTH_METHOD]` | 认证方式 | JWT Lambda Authorizer |
| `[TIME_CONSTRAINT]` | 时间限制 | 30 minutes |
| `[EXISTING_CONTEXT]` | 已有上下文路径 | _bmad-output/planning-artifacts/project-context.md |
