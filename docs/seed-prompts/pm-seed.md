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

> **Review Gate 由两道工序组成**：① 先用 Party Mode 做 AI 交叉评审（机器比对，捞硬性冲突），② 再由全角色（PM/架构/开发/QA）做强制人工评审签字放行。人工评审聚焦业务语义、跨文档一致性和关键决策，**不可由 AI 替代**——只跑 Party Mode 跳过人工评审，等于让 AI 给 AI 签字。
