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

> 📖 **BMAD 官方仓库**：[https://github.com/bmad-code-org/BMAD-METHOD](https://github.com/bmad-code-org/BMAD-METHOD)
>
> 完整安装文档：[https://docs.bmad-method.org/how-to/install-bmad/](https://docs.bmad-method.org/how-to/install-bmad/)

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

> ⚠️ **注意**：`setup-workshop.sh` 不会自动安装 BMAD，你必须手动运行 `npx bmad-method install`。如果目录中已有 `_bmad/core/`（由之前的安装生成），`--yes` 模式会走 quick-update。解决方法：先 `rm -rf _bmad/core _bmad/bmm _bmad/_config` 保留 `_bmad/custom/`，再运行安装命令。

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
│   ├── core/                           # （npx bmad-method install 生成，不提交）
│   ├── bmm/                            # （npx bmad-method install 生成，不提交）
│   └── custom/                         # ⭐ Agent 自定义配置（Workshop 核心，提交到 git）
│       ├── bmad-agent-pm.toml          # PM: 跳过 Analysis，快速创建 PRD
│       ├── bmad-agent-architect.toml   # 架构: 技术栈锁定，聚焦文档+CDK
│       ├── bmad-agent-dev.toml         # 开发: TDD 模式，TypeScript+Zod+Jest
│       ├── bmad-testarch-test-design.toml # QA: 测试设计 workflow 定制
│       └── bmad-tea.toml               # 测试工程师: TEA Agent 定制
├── _bmad-output/                       # AI Agent 产出物
│   ├── planning-artifacts/             # 规划阶段产出
│   │   └── product-brief.md           # Greenfield 预置 / Brownfield 用 /bmad-agent-pm→BP 生成
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
├── setup-workshop.sh                   # Greenfield 初始化脚本（macOS/Linux）
├── setup-workshop.ps1                  # Greenfield 初始化脚本（Windows）
├── workshop-init.sh                    # Brownfield 初始化脚本（自动检测技术栈）
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
| `bmad-testarch-test-design.toml` | QA workflow 定制：时间约束 + 测试策略 persistent_facts |
| `bmad-tea.toml` | TEA Agent 定制：时间约束 + 三类测试 persistent_facts |

每个配置通过以下字段实现简化：

- **`persistent_facts`** — 注入时间约束和技术栈锁定，Agent 不再追问已确定的事项
- **`activation_steps_prepend`** — 自动加载相关文档（Brief/PRD/架构），用户不需要手动指定
- **`menu`** — 预定义快捷操作，选一个代码就能启动，不需要写完整 Prompt
- **`principles`** — 约束 Agent 行为（如"30 分钟内完成"、"MVP 优先"）

### Greenfield 项目

直接使用这些配置即可。`setup-workshop.sh` + `npx bmad-method install` 后，Agent 会自动加载 `_bmad/custom/` 中的定制。

### Brownfield 项目

运行 `workshop-init.sh` 脚本自动完成适配：

```bash
chmod +x workshop-init.sh
./workshop-init.sh
```

脚本会自动检测技术栈并修改所有 Agent TOML 的 `persistent_facts`。完成后需要人工审核：

1. **审核确认卡**：确认技术栈、架构模式、规模等信息正确
2. **补充业务描述**：在 `project-context.md` 末尾添加项目做什么、本次加什么功能
3. **追加受保护路径**：在对应 Agent 的 `.toml` 中添加不可修改的目录

如需手动追加约束，在 `bmad-agent-dev.toml` 中编辑：

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
| PM | John | `/bmad-agent-pm` → `CP` | Inception | `docs/seed-prompts/pm-seed.md` |
| 运维/架构 | Winston | `/bmad-agent-architect` → `CA` | Operations | `docs/seed-prompts/architect-seed.md` |
| 开发工程师 | Amelia | `/bmad-agent-dev` → `DS` | Construction | `docs/seed-prompts/dev-seed.md` |
| QA | Quinn | `/bmad-testarch-test-design` → `TS` / `AC` | Construction | `docs/seed-prompts/qa-seed.md` |
| 测试工程师 | Quinn + TEA | `/bmad-tea` → `E2E` / `PF` / `ST` | Construction | `docs/seed-prompts/tester-seed.md` |

---

## Workshop 工作流全景

### Day 1 Agenda（14:00 - 18:00）

| 时间 | 环节 | 角色 |
|------|------|------|
| 14:00-14:10 | Opening | 全员 |
| 14:10-14:55 | 📢 讲师：AIDLC — Agentic AI 时代的软件工程 | 全员 |
| 14:55-15:25 | 🛠️ 讲解如何使用 BMAD | 全员 |
| 15:25-15:35 | 🚀 各组启动 | 各组 |
| 15:35-16:05 | ▶ PRD + 架构 + 测试策略（并行） | PM / 运维 / QA |
| 16:05-16:20 | 🔍 Review Gate #1 | 全员 |
| 16:20-16:30 | ☕ 休息 | — |
| 16:30-16:40 | Sprint Planning | 全员 |
| 16:40-17:30 | ⚡ 并行开发 | 开发 / QA / 测试 / 运维 |
| 17:30-17:45 | 🔍 Review Gate #2 + 测试演示 | 全员 |
| 17:45-18:00 | Wrap-up | 全员 |

### Day 2 Agenda（10:00 - 12:00）

| 时间 | 环节 | 角色 |
|------|------|------|
| 10:00-11:20 | 🎬 小组演示（每组 10 分钟） | 各组轮流 |
| 11:20-11:50 | 💡 讲师点评 + 方法论回顾 | 全员 |
| 11:50-12:00 | 📋 后续行动项 + 闭幕 | 全员 |

### 并行工作流详图

```
阶段         PM               架构师                  QA                       开发             测试工程师
命令         /bmad-agent-pm   /bmad-agent-architect   /bmad-testarch-test-design  /bmad-agent-dev  /bmad-tea
─────────────────────────────────────────────────────────────────────────────────────────────
Inception       ┌─────────┐    ┌─────────┐    ┌─────────┐
(15:35-16:05)   │ CP      │    │ CA      │    │ TS      │      (等待)          (等待)
 并行 ×3        │ 创建PRD │    │ 架构文档│    │ 测试策略│
                └────┬────┘    └────┬────┘    └────┬────┘
                     │              │              │
                     ▼              ▼              ▼
              ═══════════════ Review Gate #1 ═══════════════════
                     Party Mode 联合评审（PRD + 架构 + 测试策略）
              ═════════════════════════════════════════════════════

Construction                   ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐
(16:40-17:30)   (支持)         │ CI      │    │ AC      │    │ DS → D2 │    │E2E/PF/ST│
 并行 ×4                       │ CDK代码 │    │ 验收用例│    │ 实现代码│    │ 测试代码│
                               └────┬────┘    └────┬────┘    └────┬────┘    └────┬────┘
                                    │              │              │              │
                                    ▼              ▼              ▼              ▼
              ═══════════════ Review Gate #2 ═══════════════════
                     Party Mode 联合评审 + 测试执行演示
              ═════════════════════════════════════════════════════
```

### 各角色命令速查

| 角色 | Agent 命令 | 菜单代码 | 产出物 |
|------|-----------|---------|--------|
| PM | `/bmad-agent-pm` | `CP` | prd.md |
| 架构师 | `/bmad-agent-architect` | `CA` / `CI` | architecture.md, src/infra/ |
| QA | `/bmad-testarch-test-design` | `TS` / `AC` | test-strategy.md, acceptance-tests.md |
| 开发 | `/bmad-agent-dev` | `DS` / `D2` | src/handlers/, src/__tests__/ |
| 测试工程师 | `/bmad-tea` | `E2E` / `PF` / `ST` | src/__tests__/e2e/, src/performance/ |

---

## 使用方式

### 方式一（推荐）：BMAD 命令 + Agent 定制

安装完成后，`_bmad/custom/*.toml` 中的定制会自动生效。在 AI IDE 中直接输入命令：

```
/bmad-help                    → 获取帮助（任何时候可用）
/bmad-agent-pm                → 启动 PM Agent（对话模式）
/bmad-agent-architect         → 启动架构 Agent（对话模式）
/bmad-agent-dev               → 启动开发 Agent（对话模式）
/bmad-testarch-test-design    → 启动测试设计工作流（QA 角色用）
/bmad-tea                     → 启动 TEA Agent（测试工程师用）
/bmad-prd                     → 直接启动 PRD 创建工作流
/bmad-create-architecture     → 直接启动架构设计工作流
/bmad-sprint-planning         → Sprint 规划
/bmad-dev-story               → 实现一个 Story
/bmad-party-mode              → 启动多 Agent 联合评审
```

> ⚠️ **重要**：每个工作流结束后开新聊天！上下文残留是 AI 质量下降的头号原因。

### 方式二（备选）：手动粘贴 Seed Prompt

如果 BMAD 未安装或遇到问题，可以手动使用 `docs/seed-prompts/` 中的 Prompt：

1. 打开对应角色的文件（如 `docs/seed-prompts/dev-seed.md`）
2. 复制 Prompt 内容粘贴到 AI IDE
3. AI 会根据 Prompt 内容执行任务

> 💡 Seed Prompts 是 Agent 定制的"降级方案"——功能相同，但没有 `persistent_facts` 和 `activation_steps` 的自动加载。

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

### Product Brief

文件：`_bmad-output/planning-artifacts/product-brief.md`

**Greenfield 项目**：预置了 Hotel Booking Inventory API 的产品简介，Workshop 可以跳过 Analysis 阶段直接从 PRD 创建开始，节省约 45 分钟。

**Brownfield 项目**：不要使用预置的 Brief！运行 `workshop-init.sh` 后会自动生成 `project-context.md`。如需更详细的 Product Brief，可在 Inception 阶段用 `/bmad-agent-pm` → `BP` 让 Agent 基于已有上下文扩展生成。

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

#### Step 1：验证现有代码健康

```bash
# 已有测试必须先跑通
npm test  # 或 mvn test / pytest / go test

# git 状态必须干净
git status
```

> ❌ 测试失败 → 先修复再开始 Workshop
> ❌ 有未提交变更 → 先 `git commit` 或 `git stash`

#### Step 2：在已有项目中安装 BMAD

```bash
cd your-existing-project

# 只创建 _bmad/ 目录，不动已有代码
npx bmad-method install --yes --modules bmm --tools kiro
```

> ⚠️ **禁止**：删除或移动已有文件、修改已有的 package.json / pom.xml 等

#### Step 3：运行 Brownfield 初始化脚本

```bash
chmod +x workshop-init.sh
./workshop-init.sh
```

脚本自动完成：
- 检测技术栈（package.json / pom.xml / requirements.txt / Cargo.toml）
- 推断架构模式（微服务 / Serverless / 单体 / Monorepo）
- 生成 `_bmad-output/planning-artifacts/project-context.md`
- 为所有 Agent TOML 写入实际 `persistent_facts`
- 输出项目理解确认卡

#### Step 4：讲师带领审核 + 补充

1. 审核确认卡内容（技术栈 / 架构 / 规模）
2. 在 `project-context.md` 末尾补充业务描述
3. 检查 `_bmad/custom/*.toml` 中的 `persistent_facts`
4. 追加受保护路径

#### Step 5：确认 BMAD 可用

```bash
npx bmad-method status   # 显示已安装模块
ls _bmad/bmm/agents/     # 确认 Agent 文件存在
```

在 AI IDE 中测试：
- 输入 `/bmad-help` → 应看到帮助菜单
- 输入 `/bmad-agent-pm` → 应看到 PM Agent 菜单

> ✅ 全部通过 → 可以开始 Workshop！

#### Step 6：调整 Seed Prompt（安全护栏，可选）

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
