# AIDLC Workshop 参与者指南

## 概览

| 项目 | 内容 |
|------|------|
| **时长** | Day 1: 4 小时动手实操 + Day 2: 2 小时成果分享 |
| **目标** | 使用 BMAD 方法完成端到端 AIDLC 生命周期演练 |
| **核心理念** | AI 执行 + Human-in-the-Loop 监督 |

---

## 你的角色

| 角色 | BMAD Agent | 命令 | 阶段 |
|------|-----------|------|------|
| PM | John | `/bmad-agent-pm` → `CP` | Inception |
| 运维/架构 | Winston | `/bmad-agent-architect` → `CA` | Operations |
| 开发工程师 | Amelia | `/bmad-agent-dev` → `DS` | Construction |
| QA | Quinn | `/bmad-testarch-test-design` → `TS` | Construction |
| 测试工程师 | Murat (TEA) | `/bmad-tea` → `TA` | Construction |

---

## 环境准备

### 前置要求

```bash
node --version          # >= v20
python3 --version       # >= 3.10
uv --version            # 已安装
```

确保你的 AI IDE（Claude Code / Cursor）已就绪，API Key 已配置。

### 快速开始

**macOS / Linux：**
```bash
chmod +x setup-workshop.sh
./setup-workshop.sh
```

**Windows (PowerShell)：**
```powershell
powershell -ExecutionPolicy Bypass -File setup-workshop.ps1
```

### 验证安装

```bash
ls _bmad/core/config.yaml          # 核心配置
ls _bmad/bmm/config.yaml           # 模块配置
ls _bmad-output/planning-artifacts/product-brief.md  # 预置 Brief
ls docs/seed-prompts/              # Seed Prompts
```

---

## Workshop 流程

### 第一阶段：开场（25 分钟）
- AIDLC 和 BMAD 方法论介绍
- 环境验证
- 角色分配

### 第二阶段：PRD + 架构 + 测试策略（35 分钟）
- **PM**：使用 `docs/seed-prompts/pm-seed.md` 中的 prompt 创建 PRD
- **运维**：使用 `docs/seed-prompts/architect-seed.md` 中的 prompt 创建架构文档
- **QA**：使用 `docs/seed-prompts/qa-seed.md` 中的 prompt 编写测试策略
- 三者并行执行

### Review Gate #1（20 分钟）
全员评审 PRD、架构文档和测试策略的一致性：
1. API 端点是否在架构中有对应？
2. DynamoDB schema 是否与 API 数据模型对齐？
3. 非功能需求（延迟、认证）是否被满足？
4. 测试策略是否覆盖所有验收标准？

### 休息（10 分钟）

### Sprint Planning（15 分钟）
使用 `SP` 命令进行 Sprint 规划，拆分 Story 并分配任务

### 第三阶段：并行开发（70 分钟）
- **开发**：使用 `docs/seed-prompts/dev-seed.md` 实现 Story #1 + Story #2
- **QA**：编写验收测试用例
- **测试工程师**：使用 `docs/seed-prompts/tester-seed.md` 编写 E2E + 性能测试
- **运维**：编写 CDK/IaC 代码
- 四者并行执行

### 休息（10 分钟）

### Review Gate #2（25 分钟）
全员评审代码、测试和 IaC：
1. 代码是否符合架构设计？
2. 测试是否覆盖验收标准？
3. IaC 是否可部署？
4. 安全性检查（认证、输入验证）
5. 测试工程师现场演示测试执行

### 总结 + Q&A（30 分钟）
- 各角色分享 AI 协作心得
- AIDLC 方法论回顾
- 后续行动项讨论

---

## Party Mode（联合评审）

### Review Gate #1 Prompt
```
"Start Party Mode with John, Winston, and Quinn.

Review the PRD and Architecture documents for consistency:
1. Are API endpoints in PRD reflected in Architecture?
2. Is the DynamoDB schema aligned with API data models?
3. Are non-functional requirements (latency, auth) addressed?
4. Any gaps between requirements and technical solution?"
```

### Review Gate #2 Prompt
```
"Start Party Mode with Amelia, Quinn, and Winston.

Review the implementation artifacts:
1. Does code match the architecture design?
2. Are tests covering the defined acceptance criteria?
3. Is IaC deployable and does it match infra requirements?
4. Any security concerns (auth, input validation)?"
```

---

## 应急预案

| 问题 | 解决方案 |
|------|---------|
| Agent 响应太慢 | 切换到 Quick Flow（`Barry` Agent） |
| 环境有问题 | 使用 Party Mode 让同一终端扮演多角色 |
| PRD 生成超时 | 使用预置的 PRD 模板直接跳过 |
| 网络/API 限流 | 准备离线 mock 数据做演示 |
| 时间不够 | 砍掉 IaC，只做到 Code + Test |

---

## 成功标准

Workshop 结束时，团队应完成：

- [ ] 一份完整的 PRD 文档
- [ ] 一份测试策略文档
- [ ] 一份技术架构文档（含 DynamoDB schema + API Gateway 配置）
- [ ] 至少 2 个 API endpoint 的完整实现（代码 + 单元测试）
- [ ] E2E 自动化测试 + 性能测试脚本
- [ ] IaC 模板（CDK stack 定义）
- [ ] 2 次成功的 Party Mode 联合评审
- [ ] 测试执行演示（Review Gate #2 现场跑通）

**所有产出物都是 AI Agent 生成 + 人工 Review 确认，完整体现 AIDLC 方法论。**
