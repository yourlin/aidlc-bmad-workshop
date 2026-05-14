# ============================================================
# AIDLC Workshop × BMAD 一键初始化脚本 (Windows PowerShell)
# 用法: powershell -ExecutionPolicy Bypass -File setup-workshop.ps1
# ============================================================

$ErrorActionPreference = "Stop"

function Write-Color {
    param([string]$Text, [string]$Color = "White")
    Write-Host $Text -ForegroundColor $Color
}

Write-Host ""
Write-Color "╔══════════════════════════════════════════════════╗" "Cyan"
Write-Color "║   AIDLC Workshop × BMAD 环境初始化脚本          ║" "Cyan"
Write-Color "╚══════════════════════════════════════════════════╝" "Cyan"
Write-Host ""

# ============================================================
# Step 1: 环境检查
# ============================================================
Write-Color "[1/4] 检查前置依赖..." "Yellow"

$Errors = 0

# 检查 Node.js
try {
    $nodeVersion = (node --version 2>$null)
    if ($nodeVersion) {
        $major = [int]($nodeVersion -replace 'v','').Split('.')[0]
        if ($major -ge 20) {
            Write-Host "  ✓ Node.js $nodeVersion" -ForegroundColor Green
        } else {
            Write-Host "  ✗ Node.js $nodeVersion (需要 >= v20)" -ForegroundColor Red
            $Errors++
        }
    } else { throw }
} catch {
    Write-Host "  ✗ Node.js 未安装" -ForegroundColor Red
    $Errors++
}

# 检查 Python
try {
    $pythonVersion = (python3 --version 2>$null) -replace 'Python ',''
    if (-not $pythonVersion) {
        $pythonVersion = (python --version 2>$null) -replace 'Python ',''
    }
    if ($pythonVersion) {
        $minor = [int]$pythonVersion.Split('.')[1]
        if ($minor -ge 10) {
            Write-Host "  ✓ Python $pythonVersion" -ForegroundColor Green
        } else {
            Write-Host "  ✗ Python $pythonVersion (需要 >= 3.10)" -ForegroundColor Red
            $Errors++
        }
    } else { throw }
} catch {
    Write-Host "  ✗ Python3 未安装" -ForegroundColor Red
    $Errors++
}

# 检查 uv
try {
    $uvVersion = (uv --version 2>$null)
    if ($uvVersion) {
        Write-Host "  ✓ uv $uvVersion" -ForegroundColor Green
    } else { throw }
} catch {
    Write-Host "  ⚠ uv 未安装（可选，用于 MCP server）" -ForegroundColor Yellow
}

# 检查 AI IDE
$aiIdes = @()
if (Get-Command claude -ErrorAction SilentlyContinue) { $aiIdes += "Claude Code" }
if (Get-Command cursor -ErrorAction SilentlyContinue) { $aiIdes += "Cursor" }
if (Get-Command kiro -ErrorAction SilentlyContinue) { $aiIdes += "Kiro" }
if (Test-Path "$env:LOCALAPPDATA\Programs\Kiro\Kiro.exe" -ErrorAction SilentlyContinue) { $aiIdes += "Kiro" }
if (Get-Command codex -ErrorAction SilentlyContinue) { $aiIdes += "CodeX" }
$aiIdes = $aiIdes | Select-Object -Unique

if ($aiIdes.Count -gt 0) {
    Write-Host "  ✓ 检测到 AI IDE: $($aiIdes -join ', ')" -ForegroundColor Green
} else {
    Write-Host "  ℹ 请确认 AI IDE（Kiro / Claude Code / Cursor / CodeX）已就绪" -ForegroundColor Yellow
}

if ($Errors -gt 0) {
    Write-Host ""
    Write-Color "发现 $Errors 个环境问题，请先修复后再运行此脚本。" "Red"
    exit 1
}

Write-Host ""

# ============================================================
# Step 2: 创建目录结构
# ============================================================
Write-Color "[2/4] 创建目录结构..." "Yellow"

$dirs = @(
    "_bmad/core",
    "_bmad/bmm/agents",
    "_bmad/bmm/workflows",
    "_bmad-output/planning-artifacts",
    "_bmad-output/implementation-artifacts",
    "docs/seed-prompts",
    "src"
)

foreach ($dir in $dirs) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
}

Write-Host "  ✓ 目录结构已创建" -ForegroundColor Green
Write-Host ""

# ============================================================
# Step 3: 生成配置文件
# ============================================================
Write-Color "[3/4] 生成配置文件..." "Yellow"

# --- _bmad/core/config.yaml ---
@'
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
'@ | Set-Content -Path "_bmad/core/config.yaml" -Encoding UTF8
Write-Host "  ✓ _bmad/core/config.yaml" -ForegroundColor Green

# --- _bmad/bmm/config.yaml ---
@'
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
'@ | Set-Content -Path "_bmad/bmm/config.yaml" -Encoding UTF8
Write-Host "  ✓ _bmad/bmm/config.yaml" -ForegroundColor Green

# --- Product Brief ---
@'
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
'@ | Set-Content -Path "_bmad-output/planning-artifacts/product-brief.md" -Encoding UTF8
Write-Host "  ✓ _bmad-output/planning-artifacts/product-brief.md" -ForegroundColor Green

# --- Seed Prompts ---
@'
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
'@ | Set-Content -Path "docs/seed-prompts/pm-seed.md" -Encoding UTF8
Write-Host "  ✓ docs/seed-prompts/pm-seed.md" -ForegroundColor Green

@'
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
'@ | Set-Content -Path "docs/seed-prompts/architect-seed.md" -Encoding UTF8
Write-Host "  ✓ docs/seed-prompts/architect-seed.md" -ForegroundColor Green

@'
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
'@ | Set-Content -Path "docs/seed-prompts/dev-seed.md" -Encoding UTF8
Write-Host "  ✓ docs/seed-prompts/dev-seed.md" -ForegroundColor Green

@'
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
'@ | Set-Content -Path "docs/seed-prompts/qa-seed.md" -Encoding UTF8
Write-Host "  ✓ docs/seed-prompts/qa-seed.md" -ForegroundColor Green

@'
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
'@ | Set-Content -Path "docs/seed-prompts/tester-seed.md" -Encoding UTF8
Write-Host "  ✓ docs/seed-prompts/tester-seed.md" -ForegroundColor Green

Write-Host ""

# ============================================================
# Step 4: 验证
# ============================================================
Write-Color "[4/4] 验证文件完整性..." "Yellow"

$files = @(
    "_bmad/core/config.yaml",
    "_bmad/bmm/config.yaml",
    "_bmad-output/planning-artifacts/product-brief.md",
    "docs/seed-prompts/pm-seed.md",
    "docs/seed-prompts/architect-seed.md",
    "docs/seed-prompts/dev-seed.md",
    "docs/seed-prompts/qa-seed.md",
    "docs/seed-prompts/tester-seed.md"
)

$allOk = $true
foreach ($f in $files) {
    if (Test-Path $f) {
        Write-Host "  ✓ $f" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $f (缺失)" -ForegroundColor Red
        $allOk = $false
    }
}

Write-Host ""

if ($allOk) {
    Write-Color "╔══════════════════════════════════════════════════╗" "Green"
    Write-Color "║   ✅ Workshop 环境初始化完成！                    ║" "Green"
    Write-Color "╚══════════════════════════════════════════════════╝" "Green"
    Write-Host ""
    Write-Host "目录结构："
    Write-Host "  aidlc-bmad-workshop/"
    Write-Host "  ├── _bmad/"
    Write-Host "  │   ├── core/config.yaml"
    Write-Host "  │   └── bmm/config.yaml"
    Write-Host "  ├── _bmad-output/"
    Write-Host "  │   ├── planning-artifacts/product-brief.md"
    Write-Host "  │   └── implementation-artifacts/"
    Write-Host "  ├── docs/"
    Write-Host "  │   ├── seed-prompts/ (5 个 prompt 文件)"
    Write-Host "  │   └── workshop-guide.md"
    Write-Host "  └── src/ (开发时创建)"
    Write-Host ""
    Write-Host "下一步："
    Write-Host "  1. 阅读 docs/workshop-guide.md 了解流程" -ForegroundColor Cyan
    Write-Host "  2. 根据你的角色，打开对应的 seed prompt 文件" -ForegroundColor Cyan
    Write-Host "  3. 在 AI IDE 中粘贴 prompt 开始工作" -ForegroundColor Cyan
} else {
    Write-Color "部分文件缺失，请检查错误信息。" "Red"
    exit 1
}
