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

> **TDD 在 AI 编码场景的价值**：测试是 AI 产出代码的可执行合同——通过测试即符合预期，失败即偏离规格，比人工逐行 review 更高效可靠。用 Zod 一处定义 Schema，即可让 PRD 字段约束、测试验收标准、代码运行时校验三者天然对齐。
>
> **Review Gate 由两道工序组成**：① Party Mode AI 交叉评审，② 全角色强制人工评审。人工评审聚焦业务语义而非逐行读码（行级正确性交给 TDD），**不可由 AI 替代**。
