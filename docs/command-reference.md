# BMAD Workshop 命令速查表

> 适用版本：BMAD Method v6.8+ | 最后验证日期：2026-06-03

---

## Agent 激活命令

| 角色 | Agent 名称 | 激活命令 | 说明 |
|------|-----------|---------|------|
| PM | John | `/bmad-agent-pm` | 产品需求管理 |
| 架构师 | Winston | `/bmad-agent-architect` | 技术架构设计 |
| 开发工程师 | Amelia | `/bmad-agent-dev` | 代码实现 |
| QA | Quinn (TEA) | `/bmad-testarch-test-design` | 测试策略设计（工作流） |
| 测试架构师 | Murat (TEA) | `/bmad-tea` | 测试 Agent 对话（E2E/性能/安全） |

## Workshop 菜单快捷码

激活 Agent 后，输入以下快捷码触发预定义操作：

### PM Agent (`/bmad-agent-pm`)

| 快捷码 | 操作 |
|--------|------|
| `CP` | 基于 Product Brief 创建 PRD |

### 架构师 Agent (`/bmad-agent-architect`)

| 快捷码 | 操作 |
|--------|------|
| `CA` | 创建技术架构文档 |
| `CI` | 生成 CDK IaC 代码骨架 |

### 开发 Agent (`/bmad-agent-dev`)

| 快捷码 | 操作 |
|--------|------|
| `DS` | 实现一个 Story（TDD 模式） |
| `D2` | 实现第二个 Story |

### QA 测试设计 (`/bmad-testarch-test-design`)

> 这是一个工作流命令（非 Agent 对话模式），执行后直接进入测试策略设计流程。

| 快捷码 | 操作 |
|--------|------|
| `TD` | 风险驱动测试设计（默认） |

### TEA Agent (`/bmad-tea`)

| 快捷码 | 操作 |
|--------|------|
| `TMT` | 测试管理与跟踪 |
| `TD` | 测试设计 |
| `TF` | 测试框架选型 |
| `CI` | CI/CD 测试集成 |
| `AT` | 自动化测试计划 |
| `TA` | 测试自动化（E2E + 性能 + 安全） |
| `GATE` | 质量门禁定义 |
| `RV` | 测试评审 |
| `NR` | 需求分析 |
| `TR` | 测试报告 |

## 通用命令

| 命令 | 说明 |
|------|------|
| `/bmad-help` | 查看当前可用的 BMAD 技能和状态 |
| `/bmad-brainstorming` | 启动头脑风暴会话 |
| `/bmad-generate-project-context` | 生成项目上下文文档 |

## 使用流程

```
┌─────────────────────────────────────────────────────────┐
│  1. 激活 Agent      /bmad-agent-pm                            │
│  2. 选择操作        从菜单选择 CP                        │
│  3. AI 执行         Agent 自动读取上下文并产出文档        │
│  4. 人工评审        确认产出质量，必要时修改              │
│  5. 下一步          开启新对话，激活下一个 Agent          │
└─────────────────────────────────────────────────────────┘
```

## 重要提示

:::alert{type="warning"}
**每个阶段完成后，建议开启新的 AI 对话（新 session）再激活下一个 Agent。** 这样可以避免上下文污染，保持 Agent 角色纯净。
:::

| 阶段完成 | 动作 | 下一步 |
|---------|------|--------|
| PRD 完成 | 开启新对话 | `/bmad-agent-architect` → `CA` |
| 架构完成 | 开启新对话 | `/bmad-testarch-test-design` → `TS` |
| Review Gate #1 通过 | 开启新对话 | `/bmad-agent-dev` → `DS` |
| Story #1 完成 | 开启新对话 | `/bmad-agent-dev` → `DS`（下一个 Story） |
| 所有 Story 完成 | 开启新对话 | `/bmad-tea` → `TA` |

## 降级方案

如果 Agent 无法通过 `/bmad-xxx` 激活（安装问题），可使用 Seed Prompt 手动模式：

1. 打开 `docs/seed-prompts/` 目录
2. 找到对应角色的 `.md` 文件
3. 复制 Prompt 内容粘贴到 AI IDE 中
4. 手动提供上下文文件路径
