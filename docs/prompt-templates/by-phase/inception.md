# Inception 阶段通用模板

> 适用于任何 AWS 项目的 Inception 阶段 Prompt 模式

## PRD 创建（PM Agent）

### 标准模式

```
/bmad-agent-pm

CP

Create a PRD for [PROJECT_NAME].

Business context: [WHY are we building this?]
Target users: [WHO will use it?]

Core features (P0 — must have):
1. [FEATURE_1]
2. [FEATURE_2]
3. [FEATURE_3]

Nice-to-have (P1 — if time allows):
4. [FEATURE_4]
5. [FEATURE_5]

Technical constraints:
- AWS services: [LIST SERVICES]
- Time: [TIME_CONSTRAINT]
- Scale: [EXPECTED LOAD]

Non-functional requirements:
- Latency: [TARGET]
- Availability: [TARGET]
- Security: [REQUIREMENTS]

Output: _bmad-output/planning-artifacts/prd.md
```

### 共创对话模式

```
/bmad-agent-pm

我想用对话模式创建 PRD。请逐步提问，每轮最多 3 个问题。
根据我的回答实时组织 PRD 结构。5 轮对话后输出完整文档。

项目背景：[一句话描述]
技术栈：AWS [主要服务]
```

### Brownfield 增量模式

```
/bmad-agent-pm

CP

Based on project context at _bmad-output/planning-artifacts/project-context.md,
create a DELTA PRD for adding [NEW_FEATURE] to the existing system.

What's NEW (only document changes):
- [NEW_ENDPOINT_1]
- [NEW_ENDPOINT_2]

Constraints:
- Backward compatible with existing APIs
- Use existing auth mechanism
- Database changes must be ADDITIVE only
- Follow existing error response format

Focus on integration points with existing [ENTITY_NAME].
```

## 架构创建（Architect Agent）

```
/bmad-agent-architect

CA

Create AWS architecture for [PROJECT_NAME].

Stack: [AWS SERVICES LIST]
Requirements:
- [REQUIREMENT_1]
- [REQUIREMENT_2]
- [REQUIREMENT_3]

Design decisions needed:
- Database schema / access patterns
- API structure
- Auth mechanism
- Observability strategy

Output: Architecture document + deployment diagram
```

## 测试策略（QA Agent）

```
/bmad-testarch-test-design

TS

Generate test strategy for [PROJECT_NAME].

Coverage requirements:
- Unit: [WHAT TO UNIT TEST]
- Integration: [WHAT TO INTEGRATION TEST]
- E2E: [KEY USER FLOWS]
- Edge cases: [SPECIFIC SCENARIOS]

Tools: [TEST FRAMEWORK] + [MOCK LIBRARY]
Quality gate: [MINIMUM COVERAGE %]

Output: Test strategy document
```
