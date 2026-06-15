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

## Kiro 在流程中的角色

BMAD 定义了 Agent 约束和工作流，但需要一个执行环境把它们变成可运行的交互。[Kiro](https://kiro.dev/)（AWS 的 AI IDE）是本流程推荐的执行载体，其"约束优先"的设计哲学与 AIDLC 天然对齐：

- **Spec 驱动——约束在执行之前**：PRD 和架构文档在 Kiro 中以 Spec 形式成为 AI 编码时不可违反的前提条件。
- **Skills 是 BMAD Agent 的运行时**：每个 Agent（PM/Architect/Dev/TEA）以 Kiro Skill 形式存在，斜杠命令触发、自动加载 TOML 的 `persistent_facts`，启动即携带全部约束。
- **执行中需变更要回流上游**：当执行暴露需求遗漏或设计缺陷时，**不要在 Kiro 里直接改代码绕过约束**，而是回到 BMAD 改配置/重跑工作流、回到 Spec 修订规格，再重新驱动一次执行。约束始终是上游的 PRD/架构/Spec，代码只是它们的产物。

> 💡 Kiro 不是唯一选择——Claude Code / Cursor / CodeX 同样可用。但 Kiro 的 Spec + Skills 机制最贴合本流程的"先约束后执行"理念。

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

Review Gate 由**两道工序**组成，缺一不可：

**第一道——Party Mode AI 交叉评审**：用 Party Mode 快速捞出格式错位、字段缺失、端点数量对不上这类机器能发现的硬性不一致（prompt 见下文「Party Mode」章节）。

**第二道——全角色强制人工评审**：Party Mode 跑完后，所有相关角色（PM、架构师、开发、QA）必须再坐下来人工评审，确认以下几点，并验收本阶段产出、为下一阶段做准备：
1. API 端点是否在架构中有对应？
2. DynamoDB schema 是否与 API 数据模型对齐？
3. 非功能需求（延迟、认证）是否被满足？
4. 测试策略是否覆盖所有验收标准？

> ⚠️ **只跑 Party Mode 而跳过人工评审，等于让 AI 给 AI 的产出签字——这恰恰是 AIDLC 要避免的。** 人工评审才是决定本阶段能否放行的"闸门"，负责发现 AI 看不出的语义分歧（领域惯例、隐含假设、跨文档间接依赖）。

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

同样两道工序：**先 Party Mode AI 交叉评审，再全角色人工评审**。Party Mode 扫一遍代码与文档的硬性对齐问题，随后所有角色共同做一次人工验收：
1. 代码是否符合架构设计？
2. 测试是否覆盖验收标准？
3. IaC 是否可部署？
4. 安全性检查（认证、输入验证）
5. 测试工程师现场演示测试执行

> ⚠️ 人工评审聚焦**业务语义、跨文档一致性和关键决策**，而非逐行审读代码——代码正确性由 TDD（测试即可执行合同）承担。

### 总结 + Q&A（30 分钟）
- 各角色分享 AI 协作心得
- AIDLC 方法论回顾
- 后续行动项讨论

---

## Party Mode（Review Gate 的第一道工序）

> Party Mode 是 Review Gate 内的 **AI 交叉评审**工序，是"加速器"而非"放行闸"。它负责快速比对、捞出硬性冲突；跑完后**仍必须进行全角色人工评审**才能放行（见上文两个 Review Gate 章节）。

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
- [ ] 2 次完整的 Review Gate（Party Mode AI 评审 + 全角色人工评审）
- [ ] 测试执行演示（Review Gate #2 现场跑通）

**所有产出物都是 AI Agent 生成 + 人工 Review 确认，完整体现 AIDLC 方法论。**
