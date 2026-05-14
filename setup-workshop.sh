#!/bin/bash
# ============================================================
# AIDLC Workshop × BMAD 一键初始化脚本 (macOS / Linux)
# 用法: chmod +x setup-workshop.sh && ./setup-workshop.sh
# Windows 用户请使用: setup-workshop.ps1
#   powershell -ExecutionPolicy Bypass -File setup-workshop.ps1
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
echo -e "${YELLOW}[1/4] 检查前置依赖...${NC}"

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
echo -e "${YELLOW}[2/4] 创建目录结构...${NC}"

mkdir -p _bmad/core
mkdir -p _bmad/bmm/agents
mkdir -p _bmad/bmm/workflows
mkdir -p _bmad-output/planning-artifacts
mkdir -p _bmad-output/implementation-artifacts
mkdir -p docs/seed-prompts
mkdir -p src

echo -e "  ${GREEN}✓${NC} 目录结构已创建"
echo ""

# ============================================================
# Step 3: 生成配置文件
# ============================================================
echo -e "${YELLOW}[3/4] 生成配置文件...${NC}"

# --- _bmad/core/config.yaml ---
cat > _bmad/core/config.yaml << 'EOF'
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
EOF
echo -e "  ${GREEN}✓${NC} _bmad/core/config.yaml"

# --- _bmad/bmm/config.yaml ---
cat > _bmad/bmm/config.yaml << 'EOF'
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
EOF
echo -e "  ${GREEN}✓${NC} _bmad/bmm/config.yaml"

# --- Product Brief ---
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

# --- Seed Prompts ---
cat > docs/seed-prompts/pm-seed.md << 'EOF'
# PM — John Agent Seed Prompt

## 命令
```
CP
```

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

## 命令
```
CA
```

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

## 命令
```
DS
```

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
EOF
echo -e "  ${GREEN}✓${NC} docs/seed-prompts/qa-seed.md"

cat > docs/seed-prompts/tester-seed.md << 'EOF'
# 测试工程师 — Quinn + TEA Agent Seed Prompt

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
EOF
echo -e "  ${GREEN}✓${NC} docs/seed-prompts/tester-seed.md"

echo ""

# ============================================================
# Step 4: 验证
# ============================================================
echo -e "${YELLOW}[4/4] 验证文件完整性...${NC}"

FILES=(
    "_bmad/core/config.yaml"
    "_bmad/bmm/config.yaml"
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

echo ""

if [ "$ALL_OK" = true ]; then
    echo -e "${GREEN}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║   ✅ Workshop 环境初始化完成！                    ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "目录结构："
    echo -e "  aidlc-bmad-workshop/"
    echo -e "  ├── _bmad/"
    echo -e "  │   ├── core/config.yaml"
    echo -e "  │   └── bmm/config.yaml"
    echo -e "  ├── _bmad-output/"
    echo -e "  │   ├── planning-artifacts/product-brief.md"
    echo -e "  │   └── implementation-artifacts/"
    echo -e "  ├── docs/"
    echo -e "  │   ├── seed-prompts/ (5 个 prompt 文件)"
    echo -e "  │   └── workshop-guide.md"
    echo -e "  └── src/ (开发时创建)"
    echo ""
    echo -e "下一步："
    echo -e "  1. 阅读 ${BLUE}docs/workshop-guide.md${NC} 了解流程"
    echo -e "  2. 根据你的角色，打开对应的 seed prompt 文件"
    echo -e "  3. 在 AI IDE 中粘贴 prompt 开始工作"
else
    echo -e "${RED}部分文件缺失，请检查错误信息。${NC}"
    exit 1
fi
