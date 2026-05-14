# AIDLC Workshop × BMAD 配置工具

> 半天（4 小时）端到端 AIDLC 生命周期演练，使用 BMAD 方法驱动 AI Agent 协作开发。
> 
> 项目名：**aidlc-bmad-workshop**
>
> 📺 **[在线演示](https://yourlin.github.io/aidlc-bmad-workshop/)**

---

## 快速开始

### 1. 克隆/下载本项目

```bash
git clone <repo-url> aidlc-bmad-workshop
cd aidlc-bmad-workshop
```

### 2. 运行初始化脚本

**macOS / Linux：**

```bash
chmod +x setup-workshop.sh
./setup-workshop.sh
```

**Windows (PowerShell)：**

```powershell
powershell -ExecutionPolicy Bypass -File setup-workshop.ps1
```

脚本会自动完成：
- ✅ 检查前置依赖（Node.js >= 20、Python >= 3.10、uv）
- ✅ 检测已安装的 AI IDE（Kiro / Claude Code / Cursor / CodeX）
- ✅ 创建完整目录结构
- ✅ 生成所有配置文件和预置内容
- ✅ 验证文件完整性

### 3. 安装 BMAD Method

```bash
npx bmad-method install
```

按提示选择：
- Modules → **BMM**（核心框架）
- AI IDE → **kiro**（推荐）/ codex / cursor / claude-code / github-copilot
- 语言 → Chinese
- 项目名 → 你的项目名

> 💡 非交互式安装（Kiro）：`npx bmad-method install --yes --modules bmm --tools kiro`
>
> 其他 IDE：`--tools codex` / `--tools cursor` / `--tools claude-code` / `--tools github-copilot`
>
> 查看所有支持的 IDE：`npx bmad-method install --list-tools`

> ⚠️ **注意**：如果 `setup-workshop.sh` 已创建了 `_bmad/` 目录，`--yes` 模式会走 quick-update 而非全新安装，导致模块不完整。解决方法：先 `rm -rf _bmad/` 再运行 `npx bmad-method install`。

### 4. 验证并开始 Workshop

```bash
npx bmad-method status   # 确认 BMAD 已安装
ls _bmad/bmm/agents/     # 确认 Agent 文件存在
```

在 AI IDE 中输入 `/bmad-help` 确认可以正常响应，然后根据分配的角色打开对应的 Seed Prompt 文件开始。

---

## 前置要求

| 依赖 | 最低版本 | 用途 |
|------|---------|------|
| Node.js | v20+ | BMAD 运行时 |
| Python | 3.10+ | MCP Server 支持 |
| uv | 最新 | MCP Server 包管理（可选） |
| AI IDE | — | Kiro / Claude Code / Cursor / CodeX 任选其一 |

### AI IDE 配置

确保你的 AI IDE 已配置好 API Key，能正常与 AI 模型交互。

---

## 项目结构

```
aidlc-bmad-workshop/
├── _bmad/                              # BMAD 配置目录
│   ├── core/config.yaml                # 核心配置（语言、输出目录、Party Mode）
│   ├── bmm/
│   │   ├── config.yaml                 # 模块配置（项目名、技能级别）
│   │   ├── agents/                     # Agent 定义（BMAD 安装后自动生成）
│   │   └── workflows/                  # 工作流定义（BMAD 安装后自动生成）
│   └── custom/                         # ⭐ Agent 自定义配置（Workshop 核心）
│       ├── bmad-agent-pm.toml          # PM: 跳过 Analysis，快速创建 PRD
│       ├── bmad-agent-architect.toml   # 架构: 技术栈锁定，聚焦文档+CDK
│       ├── bmad-agent-dev.toml         # 开发: TDD 模式，TypeScript+Zod+Jest
│       ├── bmad-agent-qa.toml          # QA: 测试策略设计+验收用例
│       └── bmad-agent-tester.toml      # 测试工程师: E2E+性能+安全测试
├── _bmad-output/                       # AI Agent 产出物
│   ├── planning-artifacts/             # 规划阶段产出
│   │   └── product-brief.md           # 预置 Product Brief（跳过 Analysis）
│   └── implementation-artifacts/       # 实现阶段产出
├── docs/                               # 文档目录
│   ├── seed-prompts/                   # 各角色启动 Prompt
│   │   ├── pm-seed.md                 # PM 角色
│   │   ├── architect-seed.md          # 运维/架构角色
│   │   ├── dev-seed.md                # 开发工程师
│   │   ├── qa-seed.md                 # QA（测试策略与设计）
│   │   └── tester-seed.md            # 测试工程师（测试执行与自动化）
│   └── workshop-guide.md              # 参与者完整指南
├── src/                                # 源代码（开发阶段创建）
├── setup-workshop.sh                   # 初始化脚本（macOS/Linux）
├── setup-workshop.ps1                  # 初始化脚本（Windows）
├── AIDLC Workshop BMAD 配置规划.md      # 原始规划文档
└── README.md                           # 本文件
```

---

## Agent 自定义配置（Workshop 核心简化）

`_bmad/custom/` 目录下的 5 个 `.toml` 文件是本 Workshop 的核心——它们通过 BMAD 的三层覆盖机制，将通用 Agent 定制为 Workshop 专用模式：

| 配置文件 | 简化了什么 |
|---------|-----------|
| `bmad-agent-pm.toml` | 跳过 Analysis 阶段，自动加载 Brief，菜单直接给"快速创建 PRD" |
| `bmad-agent-architect.toml` | 技术栈锁定不讨论选型，菜单含"创建架构"+"生成 CDK 骨架" |
| `bmad-agent-dev.toml` | TDD 流程固化，自动读取 PRD+架构，菜单含"实现 Story" |
| `bmad-agent-qa.toml` | 测试策略模板化，菜单含"创建策略"+"编写验收用例" |
| `bmad-agent-tester.toml` | 三类测试预定义，菜单含"E2E"+"性能"+"安全" |

每个配置通过以下字段实现简化：

- **`persistent_facts`** — 注入时间约束和技术栈锁定，Agent 不再追问已确定的事项
- **`activation_steps_prepend`** — 自动加载相关文档（Brief/PRD/架构），用户不需要手动指定
- **`menu`** — 预定义快捷操作，选一个代码就能启动，不需要写完整 Prompt
- **`principles`** — 约束 Agent 行为（如"30 分钟内完成"、"MVP 优先"）

### Greenfield 项目

直接使用这些配置即可。`setup-workshop.sh` + `npx bmad-method install` 后，Agent 会自动加载 `_bmad/custom/` 中的定制。

### Brownfield 项目

需要在配置基础上做两处调整：

1. **修改 `persistent_facts`**：将技术栈描述改为你的实际技术栈
2. **添加约束**：在对应 Agent 的 `.toml` 中追加 Brownfield 安全护栏

示例——在 `bmad-agent-dev.toml` 中追加：

```toml
# _bmad/custom/bmad-agent-dev.toml（追加到 persistent_facts 数组）
persistent_facts = [
  "这是 Brownfield 项目，已有代码库不可破坏。",
  "修改前必须先读取现有代码模式，保持风格一致。",
  "所有变更必须通过已有测试（npm test 必须全绿）。",
  "不得修改 src/core/ 和 src/auth/ 目录下的文件。",
]
```

或者创建个人覆盖文件 `_bmad/custom/bmad-agent-dev.user.toml`（不提交到 git）：

```toml
[agent]
persistent_facts = [
  "我的项目用 Java/Spring Boot，不是 TypeScript。",
  "数据库是 PostgreSQL，不是 DynamoDB。",
]
```

---

## Workshop 角色与分工

| 角色 | BMAD Agent | 命令 | AIDLC 阶段 | Seed Prompt |
|------|-----------|------|-----------|-------------|
| PM | John | `CP` | Inception | `docs/seed-prompts/pm-seed.md` |
| 运维/架构 | Winston | `CA` | Operations | `docs/seed-prompts/architect-seed.md` |
| 开发工程师 | Amelia | `DS` | Construction | `docs/seed-prompts/dev-seed.md` |
| QA | Quinn | `QA` | Construction | `docs/seed-prompts/qa-seed.md` |
| 测试工程师 | Quinn + TEA | `QA` | Construction | `docs/seed-prompts/tester-seed.md` |

---

## Workshop 流程概览（4 小时）

```
时间        活动                              角色          命令
──────────────────────────────────────────────────────────────────────
0:00-0:25   开场：AIDLC/BMAD 介绍 + 环境验证   全员          验证安装
0:25-1:00   PRD + 架构 + 测试策略（并行）       PM+运维+QA    CP / CA / QA
1:00-1:20   Review Gate #1                    全员          Party Mode
1:20-1:30   休息                              —             —
1:30-1:45   Sprint Planning                   全员          SP
1:45-2:55   并行开发/QA/测试/IaC（70min）      全员          DS / QA / CA
2:55-3:05   休息                              —             —
3:05-3:30   Review Gate #2 + 测试演示          全员          Party Mode
3:30-4:00   总结 + 经验分享 + Q&A              全员          —
```

---

## 使用方式

### 方式一：直接使用 Seed Prompt

1. 打开你角色对应的 Seed Prompt 文件（如 `docs/seed-prompts/dev-seed.md`）
2. 复制 `## Prompt` 部分的内容
3. 粘贴到 AI IDE 的对话窗口中
4. AI Agent 会根据 BMAD 配置自动执行任务

### 方式二：使用 BMAD 命令

安装 BMAD 后（`npx bmad-method install`），在 AI IDE 中直接输入命令：

```
/bmad-help                    → 获取帮助（任何时候可用）
/pm                           → 启动 PM Agent（John）
/architect                    → 启动架构 Agent（Winston）
/dev                          → 启动开发 Agent（Amelia）
/qa                           → 启动 QA Agent（Quinn）
/create-prd                   → 直接启动 PRD 创建工作流
/create-architecture          → 直接启动架构设计工作流
/create-epics-and-stories     → 拆分 Epic 和 Story
/sprint-planning              → Sprint 规划
/develop-story                → 实现一个 Story
/party-mode                   → 启动多 Agent 联合评审
/quick-flow-solo-dev          → 快速开发模式（小功能/bug fix）
```

> ⚠️ **重要**：每个工作流结束后开新聊天！上下文残留是 AI 质量下降的头号原因。

### 方式三：Party Mode（联合评审）

在 Review Gate 环节，使用 Party Mode 让多个 Agent 协作评审：

```
"Start Party Mode with John, Winston, and Quinn.
Review the PRD and Architecture documents for consistency..."
```

---

## 配置说明

### 核心配置 (`_bmad/core/config.yaml`)

| 配置项 | 默认值 | 说明 |
|--------|--------|------|
| `user_name` | Workshop Team | Agent 对用户的称呼 |
| `communication_language` | Chinese | Agent 沟通语言 |
| `document_output_language` | Chinese | 文档输出语言 |
| `output_folder` | _bmad-output | 产出物存放目录 |
| `tool_supports_subagents` | true | 启用多 Agent 协作 |
| `tool_supports_agent_teams` | true | 启用 Party Mode |

### 模块配置 (`_bmad/bmm/config.yaml`)

| 配置项 | 默认值 | 说明 |
|--------|--------|------|
| `project_name` | hotel-booking-api | 项目名称 |
| `user_skill_level` | intermediate | 技能级别（影响 Agent 输出详细度） |
| `planning_artifacts` | _bmad-output/planning-artifacts | 规划产出目录 |
| `implementation_artifacts` | _bmad-output/implementation-artifacts | 实现产出目录 |

### 自定义配置

如需修改项目名称或语言，直接编辑对应的 YAML 文件即可。例如改为英文输出：

```yaml
communication_language:
  default: "English"
document_output_language:
  default: "English"
```

---

## 预置内容说明

### Product Brief（跳过 Analysis 阶段）

文件：`_bmad-output/planning-artifacts/product-brief.md`

这是一个预置的产品简介，描述了 Hotel Booking Inventory API 的核心需求。通过预置此文件，Workshop 可以跳过耗时的 Analysis 阶段，直接从 PRD 创建开始，节省约 45 分钟。

### 演练项目：Hotel Booking Inventory API

| 特性 | 说明 |
|------|------|
| 类型 | RESTful API 微服务 |
| 功能 | 酒店房间库存管理（CRUD + 可用性查询） |
| 技术栈 | AWS Lambda + API Gateway + DynamoDB + CDK |
| 认证 | JWT（Lambda Authorizer） |
| 规模 | MVP，单 Sprint 交付 |

---

## 应急预案

| 问题 | 解决方案 |
|------|---------|
| Agent 响应太慢/出错 | 切换到 Quick Flow（`Barry` Agent） |
| 某角色环境有问题 | 使用 Party Mode 让同一终端扮演多角色 |
| PRD 生成超时 | 使用预置的 PRD 模板直接跳过 |
| 网络/API 限流 | 准备离线 mock 数据做演示 |
| 全流程时间不够 | 砍掉 IaC，只做到 Code + Test |

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

---

## Brownfield 项目使用指南

> Brownfield = 在已有代码库中引入 AIDLC + BMAD 工作流

### 核心差异

| 维度 | Greenfield（新项目） | Brownfield（已有项目） |
|------|---------------------|----------------------|
| 目录 | 从零创建 | 在已有结构中叠加 `_bmad/` |
| Product Brief | 从需求出发 | 从现有代码/文档逆向提取 |
| 架构 | 全新设计 | 基于现有架构做增量设计 |
| 约束 | 自由选择技术栈 | 必须兼容已有技术栈 |
| 风险 | 低（无破坏性） | 需要保护已有功能不被破坏 |

### 使用步骤

#### Step 1：在已有项目中安装 BMAD

```bash
cd your-existing-project

# 直接在已有项目根目录安装 BMAD（只创建 _bmad/ 目录，不动已有代码）
npx bmad-method install
```

安装时按提示选择：
- Modules → **BMM**（核心框架）
- AI IDE → **Kiro** / Claude Code / Cursor
- 项目名 → 你的实际项目名

> ⚠️ **禁止**：删除或移动已有文件、修改已有的 package.json / pom.xml 等

#### Step 2：让 BMAD 生成项目上下文

不需要手动编写 `project-context.md`，使用 BMAD 自带的 Agent 自动分析：

```
# 在 AI IDE 中激活 PM Agent
/pm

# 选择 Create Product Brief（BP）
# Agent 会自动扫描代码库并追问你关键信息
```

或者直接告诉 Agent：

```
Analyze this existing codebase and create a product brief
that documents the current architecture, tech stack,
constraints, and areas I want to change.
```

Agent 会自动读取代码结构，生成包含技术栈、约束和变更范围的上下文文档。

#### Step 3：验证已有代码健康

```bash
# 已有测试必须先跑通
npm test  # 或 mvn test / pytest / go test

# git 状态必须干净（只有 _bmad/ 是新增）
git status
```

> ❌ 测试失败 → 先修复再开始 Workshop
> ❌ 有未提交变更 → 先 `git commit` 或 `git stash`

#### Step 4：确认 BMAD 可用

```bash
npx bmad-method status   # 显示已安装模块
ls _bmad/bmm/agents/     # 确认 Agent 文件存在
```

在 AI IDE 中测试：
- 输入 `/bmad-help` → 应看到帮助菜单
- 输入 `/pm` → 应看到 PM Agent 菜单

> ✅ 全部通过 → 可以开始 Workshop！

#### Step 4：调整 Seed Prompt（安全护栏）

Brownfield 场景下，Seed Prompt 需要增加约束声明，防止 AI 破坏已有代码。示例：

**PM Prompt（Brownfield 版）：**
```
CP

Based on the project context at _bmad-output/planning-artifacts/project-context.md,
create a PRD for [你的新功能].

Important constraints:
- Must be backward compatible with existing API v1
- Must use existing auth mechanism (not introduce new one)
- Database changes must be additive (no breaking schema changes)

Focus on:
- What's NEW (don't re-document existing features)
- Integration points with existing modules
- Migration/rollback plan
```

**架构 Prompt（Brownfield 版）：**
```
CA

Design the technical architecture for [新功能] within the existing system.

Current stack: [你的技术栈]
Existing patterns to follow:
- [如：Repository pattern for data access]
- [如：Event-driven communication between services]
- [如：Existing error handling middleware]

Constraints:
- Must integrate with existing [模块名]
- Cannot change [受保护的组件]
- Must support gradual rollout (feature flag)

Output: Architecture delta document (what changes, what stays)
```

**开发 Prompt（Brownfield 版）：**
```
DS

Implement [Story 名称] in the existing codebase.

Before writing code:
1. Read existing patterns in [相关目录]
2. Follow the same coding style and conventions
3. Use existing utilities/helpers where available

Requirements:
- [具体需求]
- Must have unit tests matching existing test patterns
- Must not break existing tests (run full test suite)
```

### Brownfield 安全护栏配置（可选）

在 `_bmad/core/config.yaml` 中增加 Brownfield 特有配置：

```yaml
# Brownfield 保护规则
brownfield_mode:
  default: true
  result: "{value}"

protected_paths:
  default: "src/core/,src/auth/,database/migrations/"
  result: "{value}"

require_backward_compatibility:
  default: true
  result: "{value}"
```

### Brownfield 最佳实践

1. **先理解再动手** — 让 Agent 先阅读现有代码，输出理解摘要，确认无误后再开始
2. **增量而非重写** — 每次变更范围要小，避免大规模重构
3. **测试先行** — 先确保现有测试全部通过，再添加新功能
4. **Feature Flag** — 新功能用 feature flag 包裹，支持快速回滚
5. **Review Gate 更严格** — Brownfield 的 Party Mode 评审要额外关注：
   - 是否破坏了已有接口契约？
   - 是否引入了与现有模式不一致的新模式？
   - 数据库变更是否可逆？

### Brownfield Party Mode 评审 Prompt

```
"Start Party Mode with Amelia, Quinn, and Winston.

Review the implementation against the EXISTING codebase:
1. Does new code follow existing patterns and conventions?
2. Are there any breaking changes to existing APIs or data models?
3. Do all existing tests still pass with the new changes?
4. Is the new code properly integrated (not a disconnected island)?
5. Is there a safe rollback path if something goes wrong?"
```

---

## FAQ

**Q: 必须使用哪个 AI IDE？**
A: Kiro、Claude Code、Cursor、CodeX 均可。只要能与 AI 模型交互即可。

**Q: 可以用英文做 Workshop 吗？**
A: 可以。修改 `_bmad/core/config.yaml` 中的 `communication_language` 和 `document_output_language` 为 `English`。

**Q: 如果没有安装 BMAD 怎么办？**
A: 可以直接使用 Seed Prompt 文件中的内容，手动粘贴到 AI IDE 中。BMAD 安装是可选的增强。

**Q: 可以换一个演练项目吗？**
A: 可以。修改 `_bmad-output/planning-artifacts/product-brief.md` 的内容，并相应调整 Seed Prompt 中的项目描述。

**Q: Windows 上运行脚本报错 "无法加载文件" 怎么办？**
A: 以管理员身份运行 PowerShell，或使用：
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

---

## 相关资源

- [BMAD Method 官方文档](https://github.com/bmad-method/bmad-method)
- [AIDLC 方法论](https://aidlc.dev)
- 内部规划文档：`AIDLC Workshop BMAD 配置规划.md`
