# AIDLC Workshop × BMAD 配置规划（优化版）

> **时长**：半天（约 4 小时）  
> **目标**：使用 BMAD 方法完成一个端到端的 AIDLC 生命周期演练  
> **参与角色**：PM、QA、开发工程师、测试工程师、运维工程师  
> **核心原则**：AI 执行 + Human-in-the-Loop 监督

---

## 0. Workshop 前置准备（必须提前完成）

### 0.1 环境检查清单

```bash
# 每位参与者提前验证：
node --version          # >= v20
python3 --version       # >= 3.10
uv --version            # 已安装
# AI IDE 已就绪（Claude Code / Cursor）+ API Key 已配置
```

### 0.2 提前安装 BMAD

```bash
mkdir aidlc-workshop && cd aidlc-workshop

# 非交互式安装（Workshop 统一配置）
npx bmad-method install --yes \
  --modules bmm \
  --tools kiro \
  --set core.user_name="Workshop Team" \
  --set core.communication_language="Chinese" \
  --set core.document_output_language="Chinese" \
  --set bmm.project_name="aidlc-bmad-workshop" \
  --set bmm.user_skill_level="intermediate" \
  --set bmm.project_knowledge="docs"
```

### 0.3 验证安装成功

```bash
ls _bmad/bmm/agents/     # 应看到 pm/architect/dev/qa agent yaml
ls _bmad-output/         # 应看到 planning-artifacts/ 和 implementation-artifacts/
```

---

## 1. 角色映射：AIDLC × BMAD Agent

| Workshop 角色 | BMAD Agent | 命令 | AIDLC 阶段 | 并行分组 |
|---|---|---|---|---|
| **PM** | John (PM) | `CP` | Inception | A 组 |
| **QA** | Quinn (QA) | `QA` | Inception + Construction | A 组 → B 组 |
| **开发工程师** | Amelia (Dev) | `DS` | Construction | B 组 |
| **测试工程师** | Quinn + TEA | `QA` | Construction | B 组 |
| **运维工程师** | Winston (Arch) | `CA` | Operations | A 组 → B 组 |

---

## 2. 核心配置文件

### 2.1 `_bmad/core/config.yaml`

```yaml
code: core
name: "AIDLC Workshop Core"

header: "AIDLC Workshop Configuration"
subheader: "半天 Workshop 核心配置 — 所有 Agent 共享"

user_name:
  prompt: "Agent 如何称呼你？"
  default: "Workshop Team"
  result: "{value}"

communication_language:
  prompt: "Agent 沟通语言？"
  default: "Chinese"
  result: "{value}"

document_output_language:
  prompt: "文档输出语言？"
  default: "Chinese"
  result: "{value}"

output_folder:
  prompt: "输出文件位置？"
  default: "_bmad-output"
  result: "{project-root}/{value}"

# 启用多 Agent 协作（Party Mode）
tool_supports_subagents:
  default: true
  result: "{value}"

tool_supports_agent_teams:
  default: true
  result: "{value}"
```

### 2.2 `_bmad/bmm/config.yaml`

```yaml
code: bmm
name: "AIDLC Workshop Module"
description: "半天 AIDLC Workshop 演练 — 优化版（跳过 Analysis）"
default_selected: true

project_name:
  prompt: "项目名称？"
  default: "hotel-booking-api"
  result: "{value}"

user_skill_level:
  default: "intermediate"
  result: "{value}"
  single-select:
    - value: "beginner"
      label: "初级 - 详细解释"
    - value: "intermediate"
      label: "中级 - 平衡速度与细节"
    - value: "expert"
      label: "高级 - 直接技术化"

planning_artifacts:
  default: "{output_folder}/planning-artifacts"
  result: "{project-root}/{value}"

implementation_artifacts:
  default: "{output_folder}/implementation-artifacts"
  result: "{project-root}/{value}"

project_knowledge:
  default: "docs"
  result: "{project-root}/{value}"

directories:
  - "{planning_artifacts}"
  - "{implementation_artifacts}"
  - "{project_knowledge}"
```

---

## 3. 预置 Product Brief（跳过 Analysis 阶段）

将以下内容保存到 `_bmad-output/planning-artifacts/product-brief.md`：

```markdown
# Product Brief: Hotel Booking Inventory API

## Overview
A RESTful API microservice for managing hotel room inventory,
supporting CRUD operations for room availability, pricing, and reservations.

## Target Users
- Hotel property management systems (PMS)
- Online travel agencies (OTA)
- Channel managers

## Core Features
1. Room inventory CRUD (create/read/update/delete)
2. Real-time availability queries
3. Rate plan management
4. JWT-based authentication
5. Webhook notifications for inventory changes

## Technical Constraints
- Serverless architecture (AWS Lambda)
- DynamoDB for data storage
- API Gateway for HTTP routing
- Response time < 200ms (p95)

## Success Criteria
- API coverage: 5 core endpoints
- Test coverage: > 80%
- Deployment: IaC (CDK/CloudFormation)
- Documentation: OpenAPI spec

## Scale
- Small project (MVP scope)
- Single-sprint delivery
```

---

## 4. 各角色 Seed Prompt（开箱即用）

### 4.1 PM — John Agent Seed Prompt

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

### 4.2 运维/架构 — Winston Agent Seed Prompt

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

### 4.3 开发工程师 — Amelia Agent Seed Prompt

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

### 4.4 QA/测试工程师 — Quinn Agent Seed Prompt

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

---

## 5. 优化后的 Workshop 时间表（4 小时）

```
┌──────────┬──────────────────────────────────────┬───────────┬──────────────────────┐
│ 时间      │ 活动                                 │ 角色       │ BMAD 命令             │
├──────────┼──────────────────────────────────────┼───────────┼──────────────────────┤
│ 0:00-0:25│ 开场：AIDLC/BMAD 方法论介绍            │ 全员       │ —                    │
│          │ + 环境验证 + 角色分配                   │           │ 验证安装              │
├──────────┼──────────────────────────────────────┼───────────┼──────────────────────┤
│ 0:25-1:00│ ▶ PRD 创建（基于预置 Brief）            │ PM        │ CP                   │
│          │ ▶ 架构设计（同步启动）                  │ 运维       │ CA                   │
│          │ ▶ QA 编写测试策略（同步启动）            │ QA        │ QA                   │
├──────────┼──────────────────────────────────────┼───────────┼──────────────────────┤
│ 1:00-1:20│ 🔍 Review Gate #1                    │ 全员       │ Party Mode Review    │
│          │ PRD + Architecture + 测试策略 联合评审  │           │                      │
├──────────┼──────────────────────────────────────┼───────────┼──────────────────────┤
│ 1:20-1:30│ ☕ 休息                               │           │                      │
├──────────┼──────────────────────────────────────┼───────────┼──────────────────────┤
│ 1:30-1:45│ Sprint Planning                       │ 全员       │ SP                   │
│          │ 拆分 Story + 分配任务                   │           │                      │
├──────────┼──────────────────────────────────────┼───────────┼──────────────────────┤
│ 1:45-2:55│ ⚡ 并行开发（核心环节，70 分钟）        │           │                      │
│          │ ├─ 开发：实现 Story #1 + Story #2      │ 开发       │ DS                   │
│          │ ├─ QA：编写验收测试用例                 │ QA        │ QA                   │
│          │ ├─ 测试工程师：E2E + 性能测试脚本       │ 测试       │ QA (TEA)             │
│          │ └─ 运维：编写 CDK/IaC 代码             │ 运维       │ CA (IaC section)     │
├──────────┼──────────────────────────────────────┼───────────┼──────────────────────┤
│ 2:55-3:05│ ☕ 休息                               │           │                      │
├──────────┼──────────────────────────────────────┼───────────┼──────────────────────┤
│ 3:05-3:30│ 🔍 Review Gate #2                    │ 全员       │ Party Mode Review    │
│          │ 代码 + 测试 + IaC 联合评审              │           │                      │
│          │ + 测试执行演示                          │ 测试       │                      │
├──────────┼──────────────────────────────────────┼───────────┼──────────────────────┤
│ 3:30-4:00│ 总结 + 经验分享 + Q&A                  │ 全员       │                      │
│          │ ├─ 各角色分享 AI 协作心得               │           │                      │
│          │ ├─ AIDLC 方法论回顾                    │           │                      │
│          │ └─ 后续行动项讨论                       │           │                      │
└──────────┴──────────────────────────────────────┴───────────┴──────────────────────┘
```

### 4 小时版 vs 3 小时版对比

| 环节 | 3h 版 | 4h 版 | 改进 |
|------|-------|-------|------|
| 开场 | 20min | 25min | 更充分的方法论介绍 |
| PRD + 架构 | 30min | 35min | QA 同步启动测试策略 |
| Review Gate #1 | 10min | 20min | 更深入的评审讨论 |
| Sprint Planning | 10min | 15min | 充分拆分 Story |
| 并行开发 | 60min | 70min | 可完成 2 个 Story |
| Review Gate #2 | 20min | 25min | 含测试执行演示 |
| 总结 | 20min | 30min | 经验分享 + 行动项 |
| 休息 | 1 次 10min | 2 次 10min+10min | 更合理的节奏 |

### 关键优化点

| 优化项 | 效果 |
|---|---|
| QA 提前到第一阶段并行 | 测试策略与 PRD/架构同步产出，Review Gate #1 更完整 |
| 测试工程师独立角色 | 并行开发阶段有专人做 E2E 和性能测试 |
| 并行开发扩展到 70min | 开发可完成 2 个 Story，产出更丰富 |
| 增加第二次休息 | 避免后半段疲劳，保持专注度 |
| Review Gate #2 含演示 | 测试工程师现场跑测试，更有说服力 |
| 总结环节扩展 | 各角色分享心得，形成可复用的经验 |

---

## 6. Party Mode 配置（联合评审）

### Review Gate #1 — PRD + Architecture

```
"Start Party Mode with John, Winston, and Quinn.

Review the PRD and Architecture documents for consistency:
1. Are API endpoints in PRD reflected in Architecture?
2. Is the DynamoDB schema aligned with API data models?
3. Are non-functional requirements (latency, auth) addressed?
4. Any gaps between requirements and technical solution?"
```

### Review Gate #2 — Code + Test + IaC

```
"Start Party Mode with Amelia, Quinn, and Winston.

Review the implementation artifacts:
1. Does code match the architecture design?
2. Are tests covering the defined acceptance criteria?
3. Is IaC deployable and does it match infra requirements?
4. Any security concerns (auth, input validation)?"
```

---

## 7. 应急预案

| 风险 | 应对方案 |
|---|---|
| Agent 响应太慢/出错 | 切换到 Quick Flow（`Barry` Agent） |
| 某角色环境有问题 | 使用 Party Mode 让同一终端扮演多角色 |
| PRD 生成超时 | 使用预置的 PRD 模板直接跳过 |
| 网络/API 限流 | 准备离线 mock 数据做演示 |
| 全流程时间不够 | 砍掉 IaC，只做到 Code + Test |

---

## 8. 文件清单（Workshop 开始前确认）

```
aidlc-bmad-workshop/
├── _bmad/
│   ├── core/config.yaml                    ✅ 已配置
│   └── bmm/
│       ├── config.yaml                     ✅ 已配置
│       ├── agents/                         ✅ 自动生成
│       └── workflows/                      ✅ 自动生成
├── _bmad-output/
│   └── planning-artifacts/
│       └── product-brief.md                ✅ 预置（第3节）
├── docs/
│   ├── seed-prompts/
│   │   ├── pm-seed.md                      ✅ 预置（第4节）
│   │   ├── architect-seed.md               ✅ 预置
│   │   ├── dev-seed.md                     ✅ 预置
│   │   ├── qa-seed.md                      ✅ 预置
│   │   └── tester-seed.md                  ✅ 预置
│   └── workshop-guide.md                   ✅ 参与者指南
├── setup-workshop.sh                       ✅ 初始化脚本（macOS/Linux）
├── setup-workshop.ps1                      ✅ 初始化脚本（Windows）
└── src/                                    🔲 开发时创建
```

---

## 9. AIDLC 三阶段与 BMAD 最终对照

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    AIDLC × BMAD 对照（4 小时版）                          │
├────────────────┬─────────────────────┬──────────────────────────────────┤
│ AIDLC 阶段     │ BMAD Phase           │ Workshop 实际操作                │
├────────────────┼─────────────────────┼──────────────────────────────────┤
│ Inception      │ Planning             │ PRD + 测试策略（基于预置 Brief）  │
│ (需求分析)      │ (跳过 Analysis)      │ Review Gate #1                  │
├────────────────┼─────────────────────┼──────────────────────────────────┤
│ Construction   │ Solutioning +        │ Architecture + Sprint Plan      │
│ (设计→实现)     │ Implementation       │ + 并行开发/QA/测试工程师          │
├────────────────┼─────────────────────┼──────────────────────────────────┤
│ Operations     │ Implementation       │ IaC（CDK）+ 测试执行演示          │
│ (部署运维)      │ (Ops extension)      │ + Review Gate #2                │
└────────────────┴─────────────────────┴──────────────────────────────────┘

核心理念：AI 执行 + Human-in-the-Loop（Review Gate = 人工审核门禁）
```

---

## 10. 成功标准

Workshop 结束时，团队应该完成：

- [x] 一份完整的 PRD 文档
- [x] 一份测试策略文档
- [x] 一份技术架构文档（含 DynamoDB schema + API Gateway 配置）
- [x] 至少 2 个 API endpoint 的完整实现（代码 + 单元测试）
- [x] E2E 自动化测试 + 性能测试脚本
- [x] IaC 模板（CDK stack 定义）
- [x] 2 次成功的 Party Mode 联合评审
- [x] 测试执行演示（Review Gate #2 现场跑通）

**所有产出物都是 AI Agent 生成 + 人工 Review 确认，完整体现 AIDLC 方法论。**
