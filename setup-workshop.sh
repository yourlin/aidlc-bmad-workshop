#!/bin/bash
# ============================================================
# AIDLC Workshop × BMAD 一键初始化脚本 (macOS / Linux)
# 用法: chmod +x setup-workshop.sh && ./setup-workshop.sh
# Windows 用户请使用: setup-workshop.ps1
#   powershell -ExecutionPolicy Bypass -File setup-workshop.ps1
#
# 职责划分：
#   本脚本 → Workshop 专属内容（Product Brief、Agent 定制、Seed Prompts）
#   npx bmad-method install → BMAD 核心框架（agents、workflows、IDE 集成）
# ============================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   AIDLC Workshop × BMAD 环境初始化脚本          ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"
echo ""

# ============================================================
# Step 1: 环境检查
# ============================================================
echo -e "${YELLOW}[1/5] 检查前置依赖...${NC}"

ERRORS=0

# 检查 Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version | sed 's/v//')
    NODE_MAJOR=$(echo "$NODE_VERSION" | cut -d. -f1)
    if [ "$NODE_MAJOR" -ge 20 ]; then
        echo -e "  ${GREEN}✓${NC} Node.js v${NODE_VERSION}"
    else
        echo -e "  ${RED}✗${NC} Node.js v${NODE_VERSION} (需要 >= v20)"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo -e "  ${RED}✗${NC} Node.js 未安装"
    ERRORS=$((ERRORS + 1))
fi

# 检查 Python
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version | sed 's/Python //')
    PYTHON_MINOR=$(echo "$PYTHON_VERSION" | cut -d. -f2)
    if [ "$PYTHON_MINOR" -ge 10 ]; then
        echo -e "  ${GREEN}✓${NC} Python ${PYTHON_VERSION}"
    else
        echo -e "  ${RED}✗${NC} Python ${PYTHON_VERSION} (需要 >= 3.10)"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo -e "  ${RED}✗${NC} Python3 未安装"
    ERRORS=$((ERRORS + 1))
fi

# 检查 uv
if command -v uv &> /dev/null; then
    UV_VERSION=$(uv --version 2>/dev/null || echo "unknown")
    echo -e "  ${GREEN}✓${NC} uv ${UV_VERSION}"
else
    echo -e "  ${YELLOW}⚠${NC} uv 未安装（可选，用于 MCP server）"
fi

# 检查 AI IDE
AI_IDES=""
if command -v claude &> /dev/null; then
    AI_IDES="${AI_IDES} Claude Code"
fi
if command -v cursor &> /dev/null; then
    AI_IDES="${AI_IDES} Cursor"
fi
if command -v kiro &> /dev/null || [ -d "/Applications/Kiro.app" ]; then
    AI_IDES="${AI_IDES} Kiro"
fi
if command -v codex &> /dev/null; then
    AI_IDES="${AI_IDES} CodeX"
fi

if [ -n "$AI_IDES" ]; then
    echo -e "  ${GREEN}✓${NC} 检测到 AI IDE:${AI_IDES}"
else
    echo -e "  ${YELLOW}ℹ${NC} 请确认 AI IDE（Kiro / Claude Code / Cursor / CodeX）已就绪"
fi

if [ "$ERRORS" -gt 0 ]; then
    echo ""
    echo -e "${RED}发现 ${ERRORS} 个环境问题，请先修复后再运行此脚本。${NC}"
    exit 1
fi

echo ""

# ============================================================
# Step 2: 创建目录结构
# ============================================================
echo -e "${YELLOW}[2/5] 创建目录结构...${NC}"

mkdir -p _bmad/custom
mkdir -p _bmad-output/planning-artifacts
mkdir -p _bmad-output/implementation-artifacts
mkdir -p docs/seed-prompts
mkdir -p src

echo -e "  ${GREEN}✓${NC} 目录结构已创建"
echo ""

# ============================================================
# Step 3: 生成 Workshop 专属内容
# ============================================================
echo -e "${YELLOW}[3/5] 生成 Workshop 内容...${NC}"

# --- Product Brief（预置，跳过 Analysis 阶段）---
cat > _bmad-output/planning-artifacts/product-brief.md << 'EOF'
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
EOF
echo -e "  ${GREEN}✓${NC} _bmad-output/planning-artifacts/product-brief.md"

# --- Agent 自定义配置（Workshop 核心简化）---
cat > _bmad/custom/bmad-agent-pm.toml << 'EOF'
# PM Agent (John) — AIDLC Workshop 定制
[agent]
icon = "📋"
role = "Workshop PM — 基于预置 Product Brief 快速创建 PRD。聚焦 MVP 范围，不做过度设计。"
communication_style = "简洁直接，中文沟通。API 端点用 Method + Path + 简述格式。验收标准用 Given-When-Then。"

persistent_facts = [
  "这是一个半天 Workshop，PRD 必须在 30 分钟内完成。",
  "Product Brief 已预置在 _bmad-output/planning-artifacts/product-brief.md。",
  "技术栈已锁定：AWS Lambda + DynamoDB + API Gateway + CDK。",
  "MVP 范围：5 个 API 端点（CRUD + 可用性查询），JWT 认证。",
  "不需要做市场研究、竞品分析——直接基于 Brief 工作。",
]

principles = [
  "MVP 优先——只写 V1 需要的，明确标注不包含什么。",
  "每个端点必须有：Method、Path、Request Body、Response、Error Codes。",
  "30 分钟内产出可评审的 PRD。",
]

activation_steps_prepend = [
  "读取 {project-root}/_bmad-output/planning-artifacts/product-brief.md 作为输入。",
]

[[agent.menu]]
code = "CP"
description = "基于预置 Brief 创建 PRD（Workshop 快速模式）"
prompt = "读取 product-brief.md，创建 PRD：5 个 API 端点 + JWT 认证 + 错误处理 + 版本策略。输出到 {planning_artifacts}/prd.md"
EOF
echo -e "  ${GREEN}✓${NC} _bmad/custom/bmad-agent-pm.toml"

cat > _bmad/custom/bmad-agent-architect.toml << 'EOF'
# Architect Agent (Winston) — AIDLC Workshop 定制
[agent]
icon = "🏗️"
role = "Workshop 架构师 — 技术栈已确定（AWS Serverless），聚焦架构文档和 IaC 结构。"
communication_style = "技术化、结构化，中文沟通。DynamoDB 用 Access Pattern 表格，CDK 用目录树。"

persistent_facts = [
  "这是一个半天 Workshop，架构文档必须在 30 分钟内完成。",
  "技术栈已锁定：AWS Lambda + API Gateway + DynamoDB + CDK (TypeScript)。",
  "认证：JWT via Lambda Authorizer。监控：CloudWatch + X-Ray。",
  "DynamoDB 使用单表设计（Single-Table Design）。",
]

principles = [
  "Serverless 优先——所有计算用 Lambda。",
  "单表设计——一个 DynamoDB 表覆盖所有实体。",
  "IaC 即文档——CDK 代码本身就是架构的可执行描述。",
]

activation_steps_prepend = [
  "读取 {project-root}/_bmad-output/planning-artifacts/product-brief.md 了解需求。",
]

[[agent.menu]]
code = "CA"
description = "创建技术架构文档（Workshop 快速模式）"
prompt = "创建架构文档：系统概览 + DynamoDB 单表设计 + API Gateway 路由 + Lambda Authorizer + CDK 结构 + 监控方案。输出到 {planning_artifacts}/architecture.md"

[[agent.menu]]
code = "CI"
description = "生成 CDK IaC 代码骨架"
prompt = "生成 CDK TypeScript 项目骨架到 src/infra/：主 Stack + Auth Stack + App 入口 + package.json。只生成骨架。"
EOF
echo -e "  ${GREEN}✓${NC} _bmad/custom/bmad-agent-architect.toml"

cat > _bmad/custom/bmad-agent-dev.toml << 'EOF'
# Dev Agent (Amelia) — AIDLC Workshop 定制
[agent]
icon = "💻"
role = "Workshop 开发工程师 — TDD 模式实现 API endpoint。先写测试，再写实现。"
communication_style = "代码优先，中文注释。不做冗长解释，直接给可运行的代码。"

persistent_facts = [
  "这是一个半天 Workshop，每个 Story 约 25 分钟。",
  "技术栈：TypeScript + AWS Lambda + DynamoDB + Zod + Jest。",
  "遵循 TDD：先写 Jest 测试（红），再写实现（绿）。",
  "输入验证用 Zod，DynamoDB 用 @aws-sdk/lib-dynamodb。",
  "代码到 src/，测试到 src/__tests__/。",
]

principles = [
  "TDD 铁律——没有测试的代码不算完成。",
  "单一职责——每个 Lambda handler 只做一件事。",
  "代码精简——能用 10 行解决的不写 20 行。",
]

activation_steps_prepend = [
  "读取 {project-root}/_bmad-output/planning-artifacts/prd.md（如果存在）。",
  "读取 {project-root}/_bmad-output/planning-artifacts/architecture.md（如果存在）。",
]

[[agent.menu]]
code = "DS"
description = "实现一个 Story（TDD 模式）"
prompt = "按 TDD 实现 Story：先 Jest 测试 → 再 Lambda handler → Zod schema → DynamoDB 封装。问用户要实现哪个端点。"

[[agent.menu]]
code = "D2"
description = "实现第二个 Story"
prompt = "基于第一个 Story 的模式，实现第二个 API 端点。复用已有封装，同样 TDD。"
EOF
echo -e "  ${GREEN}✓${NC} _bmad/custom/bmad-agent-dev.toml"

cat > _bmad/custom/bmad-agent-qa.toml << 'EOF'
# QA Agent (Quinn) — AIDLC Workshop 定制
[agent]
icon = "✅"
role = "Workshop QA — 设计测试策略、编写验收标准、定义质量门禁。"
communication_style = "结构化、表格化，中文沟通。测试用例用表格（ID/场景/输入/预期/优先级）。"

persistent_facts = [
  "这是一个半天 Workshop，测试策略 30 分钟内完成。",
  "项目：Hotel Booking API，5 个端点 + JWT 认证。",
  "工具链：Jest + supertest + Artillery。",
  "非功能需求：<200ms (p95)，覆盖率 >80%。",
]

principles = [
  "风险驱动——高风险路径优先（认证、数据一致性）。",
  "测试金字塔——单元多、集成适中、E2E 少而精。",
  "边界值优先——正常路径一个用例够，边界和异常是重点。",
]

activation_steps_prepend = [
  "读取 {project-root}/_bmad-output/planning-artifacts/product-brief.md。",
]

[[agent.menu]]
code = "TS"
description = "创建测试策略文档"
prompt = "创建测试策略：范围 + 分层 + 覆盖率矩阵 + 优先级 + 质量门禁 + 工具链。输出到 {planning_artifacts}/test-strategy.md"

[[agent.menu]]
code = "AC"
description = "编写验收测试用例"
prompt = "基于 PRD 每个端点写验收用例：每端点 5 个（1 正常 + 2 边界 + 2 异常），表格格式。输出到 {planning_artifacts}/acceptance-tests.md"
EOF
echo -e "  ${GREEN}✓${NC} _bmad/custom/bmad-agent-qa.toml"

cat > _bmad/custom/bmad-agent-tester.toml << 'EOF'
# Test Engineer Agent (Quinn + TEA) — AIDLC Workshop 定制
[agent]
icon = "🧪"
role = "Workshop 测试工程师 — 实现 E2E、性能、安全测试代码。可直接运行。"
communication_style = "代码优先，中文注释。产出可直接 npm test 运行的脚本。"

persistent_facts = [
  "这是一个半天 Workshop，测试代码在 50 分钟并行阶段完成。",
  "E2E：Jest + supertest。性能：Artillery。安全：JWT bypass + 注入。",
  "非功能需求：<200ms (p95)，并发 100 用户无错误。",
  "测试到 src/__tests__/，性能到 src/performance/。",
  "Review Gate #2 需要现场演示测试执行。",
]

principles = [
  "可运行优先——产出必须能直接跑通。",
  "CI 友好——用 mock 隔离，不依赖外部服务。",
  "幂等性——每次运行结果一致。",
]

activation_steps_prepend = [
  "读取 {project-root}/_bmad-output/planning-artifacts/test-strategy.md（如果存在）。",
  "读取 {project-root}/_bmad-output/planning-artifacts/architecture.md（如果存在）。",
]

[[agent.menu]]
code = "E2E"
description = "编写 E2E 自动化测试"
prompt = "为 5 个 API 端点写 E2E 测试（Jest + supertest），含认证成功/失败场景，mock DynamoDB。输出到 src/__tests__/e2e/"

[[agent.menu]]
code = "PF"
description = "编写性能测试（Artillery）"
prompt = "创建 Artillery 配置：CRUD 流程 + 高并发查询，目标 p95<200ms，阶梯 10→50→100 用户。输出到 src/performance/"

[[agent.menu]]
code = "ST"
description = "编写安全测试"
prompt = "创建安全测试：JWT 安全 + 输入注入 + 速率限制 + 权限边界。Jest + supertest 实现。输出到 src/__tests__/security/"
EOF
echo -e "  ${GREEN}✓${NC} _bmad/custom/bmad-agent-tester.toml"

# --- Seed Prompts（备选方案：未安装 BMAD 时手动使用）---
cat > docs/seed-prompts/pm-seed.md << 'EOF'
# PM — John Agent Seed Prompt
> 备选方案：如果 BMAD 已安装，直接在 AI IDE 中输入 `/pm` → 选择 `CP` 即可，无需手动粘贴。

## Prompt
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
EOF
echo -e "  ${GREEN}✓${NC} docs/seed-prompts/pm-seed.md"

cat > docs/seed-prompts/architect-seed.md << 'EOF'
# 运维/架构 — Winston Agent Seed Prompt
> 备选方案：如果 BMAD 已安装，直接在 AI IDE 中输入 `/architect` → 选择 `CA` 即可。

## Prompt
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
EOF
echo -e "  ${GREEN}✓${NC} docs/seed-prompts/architect-seed.md"

cat > docs/seed-prompts/dev-seed.md << 'EOF'
# 开发工程师 — Amelia Agent Seed Prompt
> 备选方案：如果 BMAD 已安装，直接在 AI IDE 中输入 `/dev` → 选择 `DS` 即可。

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
EOF
echo -e "  ${GREEN}✓${NC} docs/seed-prompts/dev-seed.md"

cat > docs/seed-prompts/qa-seed.md << 'EOF'
# QA — Quinn Agent Seed Prompt
> 备选方案：如果 BMAD 已安装，直接在 AI IDE 中输入 `/qa` → 选择 `TS` 即可。

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
EOF
echo -e "  ${GREEN}✓${NC} docs/seed-prompts/qa-seed.md"

cat > docs/seed-prompts/tester-seed.md << 'EOF'
# 测试工程师 — Quinn + TEA Agent Seed Prompt
> 备选方案：如果 BMAD 已安装，直接在 AI IDE 中输入 `/qa` → 选择 `E2E` / `PF` / `ST` 即可。

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
EOF
echo -e "  ${GREEN}✓${NC} docs/seed-prompts/tester-seed.md"

echo ""

# ============================================================
# Step 4: 安装 BMAD Method
# ============================================================
echo -e "${YELLOW}[4/5] 安装 BMAD Method...${NC}"
echo -e "  运行: npx bmad-method install --yes --modules bmm --tools kiro --directory $(pwd)"
echo ""

if npx bmad-method install --yes --modules bmm --tools kiro --directory "$(pwd)" --set core.communication_language="Chinese" --set core.document_output_language="Chinese" --set bmm.project_name="aidlc-bmad-workshop" 2>&1 | tail -5; then
    echo ""
    echo -e "  ${GREEN}✓${NC} BMAD Method 安装完成"
else
    echo ""
    echo -e "  ${YELLOW}⚠${NC} BMAD 自动安装未成功，请手动运行："
    echo -e "    ${BLUE}npx bmad-method install${NC}"
    echo -e "  选择: Modules → BMM, AI IDE → kiro, 语言 → Chinese"
fi

echo ""

# ============================================================
# Step 5: 验证
# ============================================================
echo -e "${YELLOW}[5/5] 验证文件完整性...${NC}"

FILES=(
    "_bmad/custom/bmad-agent-pm.toml"
    "_bmad/custom/bmad-agent-architect.toml"
    "_bmad/custom/bmad-agent-dev.toml"
    "_bmad/custom/bmad-agent-qa.toml"
    "_bmad/custom/bmad-agent-tester.toml"
    "_bmad-output/planning-artifacts/product-brief.md"
    "docs/seed-prompts/pm-seed.md"
    "docs/seed-prompts/architect-seed.md"
    "docs/seed-prompts/dev-seed.md"
    "docs/seed-prompts/qa-seed.md"
    "docs/seed-prompts/tester-seed.md"
)

ALL_OK=true
for f in "${FILES[@]}"; do
    if [ -f "$f" ]; then
        echo -e "  ${GREEN}✓${NC} $f"
    else
        echo -e "  ${RED}✗${NC} $f (缺失)"
        ALL_OK=false
    fi
done

# 检查 BMAD 安装
if [ -f "_bmad/_config/manifest.yaml" ]; then
    echo -e "  ${GREEN}✓${NC} BMAD 核心已安装"
else
    echo -e "  ${YELLOW}⚠${NC} BMAD 核心未检测到（请手动运行 npx bmad-method install）"
fi

echo ""

if [ "$ALL_OK" = true ]; then
    echo -e "${GREEN}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║   ✅ Workshop 环境初始化完成！                    ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "目录结构："
    echo -e "  aidlc-bmad-workshop/"
    echo -e "  ├── _bmad/"
    echo -e "  │   ├── custom/ (5 个 Agent 定制配置)"
    echo -e "  │   ├── bmm/   (BMAD 核心模块)"
    echo -e "  │   └── core/  (BMAD 核心配置)"
    echo -e "  ├── _bmad-output/"
    echo -e "  │   └── planning-artifacts/product-brief.md"
    echo -e "  ├── docs/seed-prompts/ (5 个备选 Prompt)"
    echo -e "  └── src/ (开发时创建)"
    echo ""
    echo -e "${BLUE}使用方式（二选一）：${NC}"
    echo -e "  ${GREEN}推荐${NC}: 在 AI IDE 中输入 /pm → 选择 CP（Agent 自动加载定制配置）"
    echo -e "  备选: 复制 docs/seed-prompts/ 中的 Prompt 手动粘贴到 AI IDE"
    echo ""
    echo -e "下一步："
    echo -e "  1. 用 Kiro 打开本目录"
    echo -e "  2. 输入 ${BLUE}/bmad-help${NC} 确认 BMAD 可用"
    echo -e "  3. 根据角色输入对应命令开始 Workshop"
else
    echo -e "${RED}部分文件缺失，请检查错误信息。${NC}"
    exit 1
fi
