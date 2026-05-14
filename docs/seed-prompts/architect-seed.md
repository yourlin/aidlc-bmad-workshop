# 运维/架构 — Winston Agent Seed Prompt

## 角色
运维工程师/架构师 — 对应 BMAD 的 Winston Agent

## AIDLC 阶段
Construction → Operations（设计→部署运维）

## 命令
```
CA
```

## Prompt

```
CA

Create the technical architecture for Hotel Booking Inventory API.

Stack: AWS Lambda + API Gateway + DynamoDB + CDK
Requirements:
- Serverless, pay-per-use
- DynamoDB single-table design
- JWT auth via Lambda Authorizer
- CloudWatch monitoring + X-Ray tracing
- CI/CD via CodePipeline

Output: Architecture document + CDK project structure
```

## 预期产出
- 技术架构文档（含 DynamoDB schema + API Gateway 配置）
- CDK 项目结构定义
- 监控和可观测性方案

## 注意事项
- 与 PM 的 PRD 并行启动（A 组同步）
- 确保架构与 PRD 中的 API 端点一致
- 完成后参与 Review Gate #1
