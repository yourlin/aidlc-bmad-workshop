# PM — John Agent Seed Prompt

## 角色
PM（产品经理）— 对应 BMAD 的 John Agent

## AIDLC 阶段
Inception（需求分析）

## 命令
```
CP
```

## Prompt

```
CP

Based on the existing product brief at 
_bmad-output/planning-artifacts/product-brief.md, 
create a PRD for the Hotel Booking Inventory API.

Focus on:
- 5 core API endpoints (CRUD + availability query)
- JWT authentication flow
- Error handling standards
- API versioning strategy

Keep it concise — this is a small-scale MVP.
```

## 预期产出
- PRD 文档（保存在 `_bmad-output/planning-artifacts/prd.md`）
- 包含 API 端点定义、认证流程、错误处理标准

## 注意事项
- 基于预置的 Product Brief，无需从零开始
- 保持 MVP 范围，不要过度设计
- 完成后进入 Review Gate #1
