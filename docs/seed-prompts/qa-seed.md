# QA — Quinn Agent Seed Prompt

## 角色
QA — 对应 BMAD 的 Quinn Agent（侧重测试策略与设计）

## AIDLC 阶段
Construction（测试策略）

## 命令
```
QA
```

## Prompt

```
QA

Generate test strategy and automated tests for Hotel Booking API.

Coverage:
- Unit tests for each Lambda handler
- Integration tests for DynamoDB operations
- API contract tests (against OpenAPI spec)
- Edge cases: auth failure, validation error, rate limiting

Tools: Jest + supertest
Output: Test plan + test code files
```

## 与测试工程师的分工

| 维度 | QA（本角色） | 测试工程师 |
|------|------------|-----------|
| 重点 | 测试策略设计、覆盖率规划 | 测试执行、自动化实现 |
| 产出 | 测试计划、用例设计文档 | 可运行的测试代码、性能脚本 |
| 关注 | 验收标准、质量门禁 | CI 集成、执行效率、缺陷发现 |

## 预期产出
- 测试策略文档
- 测试用例设计（覆盖矩阵）
- 自动化测试代码框架（Jest + supertest）
- 验收标准定义

## 注意事项
- 在 Sprint Planning 之后开始
- 与开发和运维并行执行（B 组）
- 测试策略应覆盖 PRD 中定义的验收标准
- 与测试工程师协作：QA 设计策略，测试工程师负责执行
- 完成后参与 Review Gate #2

> **Review Gate 由两道工序组成**：① Party Mode AI 交叉评审，② 全角色强制人工评审签字放行。人工评审聚焦业务语义、跨文档一致性和关键决策，**不可由 AI 替代**。
