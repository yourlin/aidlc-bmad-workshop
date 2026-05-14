# 测试工程师 — Quinn + TEA Agent Seed Prompt

## 角色
测试工程师 — 对应 BMAD 的 Quinn Agent + TEA（Test Engineering Agent）

## AIDLC 阶段
Construction（测试执行与验证）

## 命令
```
QA
```

## Prompt

```
QA

As a Test Engineer, create and execute comprehensive test suites 
for the Hotel Booking Inventory API.

Focus areas:
- E2E test scenarios (happy path + error paths)
- Performance testing (response time < 200ms p95)
- Security testing (JWT auth bypass attempts, injection attacks)
- Data integrity tests (DynamoDB consistency)
- API contract validation (request/response schema)

Tools: Jest + supertest + Artillery (load testing)

Deliverables:
1. Test execution plan with priority matrix
2. E2E test code (automated, CI-ready)
3. Performance test scripts (Artillery config)
4. Security test checklist with automated checks
5. Bug report template for found issues
```

## 与 QA 角色的区别

| 维度 | QA（Quinn） | 测试工程师（Quinn + TEA） |
|------|------------|------------------------|
| 重点 | 测试策略和测试设计 | 测试执行和自动化实现 |
| 产出 | 测试计划、用例设计 | 可运行的测试代码、性能脚本 |
| 关注 | 覆盖率、验收标准 | 执行效率、CI 集成、缺陷发现 |
| 工具 | 文档为主 | 代码为主（Jest/Artillery/OWASP） |

## 预期产出
- E2E 自动化测试代码（可直接在 CI 中运行）
- 性能测试配置（Artillery YAML）
- 安全测试脚本（常见攻击向量验证）
- 测试执行报告模板
- 发现的缺陷清单（如有）

## 注意事项
- 在 Sprint Planning 之后开始
- 与 QA 协作：QA 设计策略，测试工程师实现和执行
- 与开发并行执行（B 组）
- 测试必须可重复、幂等、CI 友好
- 完成后参与 Review Gate #2
- 关注测试的可维护性，避免脆弱测试（flaky tests）

## Brownfield 项目补充 Prompt

```
QA

As a Test Engineer working on an EXISTING codebase:

Before writing new tests:
1. Read existing test patterns in [test directory]
2. Identify existing test utilities and helpers
3. Ensure new tests follow the same structure

Additional focus:
- Regression tests for areas affected by new changes
- Integration tests verifying new code works with existing modules
- Backward compatibility tests (old API contracts still honored)
- Database migration tests (data integrity after schema changes)

Constraint: All existing tests must continue to pass.
Run the full test suite before and after adding new tests.
```
