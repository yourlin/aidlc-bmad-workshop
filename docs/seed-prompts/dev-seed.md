# 开发工程师 — Amelia Agent Seed Prompt

## 角色
开发工程师 — 对应 BMAD 的 Amelia Agent

## AIDLC 阶段
Construction（实现）

## 命令
```
DS
```

## Prompt

```
DS

Implement the first story: "Create Room Inventory" endpoint.

Tech: Node.js/TypeScript + Lambda + DynamoDB
Requirements:
- POST /api/v1/rooms
- Input validation (Zod schema)
- DynamoDB put operation
- Unit tests (Jest)
- Follow TDD: write test first, then implement

Keep code clean and minimal.
```

## 预期产出
- Lambda handler 代码（TypeScript）
- Zod 输入验证 schema
- DynamoDB 操作封装
- Jest 单元测试
- 代码保存在 `src/` 目录

## 注意事项
- 在 Sprint Planning 之后开始
- 遵循 TDD：先写测试，再实现
- 与 QA 和运维并行执行（B 组）
- 完成后参与 Review Gate #2
