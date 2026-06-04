# ============================================================
# AIDLC Workshop × BMAD 一键初始化脚本 (Windows PowerShell)
# 用法: powershell -ExecutionPolicy Bypass -File setup-workshop.ps1
#
# 职责划分：
#   本脚本 → Workshop 专属内容（Product Brief、Agent 定制、Seed Prompts）
#   npx bmad-method install → BMAD 核心框架（agents、workflows、IDE 集成）
# ============================================================

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   AIDLC Workshop × BMAD 环境初始化脚本          ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# ============================================================
# Step 1: 环境检查
# ============================================================
Write-Host "[1/5] 检查前置依赖..." -ForegroundColor Yellow

$Errors = 0

try {
    $nodeVersion = (node --version 2>$null)
    if ($nodeVersion) {
        $major = [int]($nodeVersion -replace 'v','').Split('.')[0]
        if ($major -ge 20) { Write-Host "  ✓ Node.js $nodeVersion" -ForegroundColor Green }
        else { Write-Host "  ✗ Node.js $nodeVersion (需要 >= v20)" -ForegroundColor Red; $Errors++ }
    } else { throw }
} catch { Write-Host "  ✗ Node.js 未安装" -ForegroundColor Red; $Errors++ }

try {
    $pythonVersion = (python3 --version 2>$null) -replace 'Python ',''
    if (-not $pythonVersion) { $pythonVersion = (python --version 2>$null) -replace 'Python ','' }
    if ($pythonVersion) {
        $minor = [int]$pythonVersion.Split('.')[1]
        if ($minor -ge 10) { Write-Host "  ✓ Python $pythonVersion" -ForegroundColor Green }
        else { Write-Host "  ✗ Python $pythonVersion (需要 >= 3.10)" -ForegroundColor Red; $Errors++ }
    } else { throw }
} catch { Write-Host "  ✗ Python3 未安装" -ForegroundColor Red; $Errors++ }

# 检查 GitHub Token（BMAD 安装需要，避免 rate limit）
if ($env:GITHUB_TOKEN) {
    $tokenPrefix = $env:GITHUB_TOKEN.Substring(0, 4)
    Write-Host "  ✓ GitHub Token 已配置 ($tokenPrefix...)" -ForegroundColor Green
} elseif ($env:GH_TOKEN) {
    $tokenPrefix = $env:GH_TOKEN.Substring(0, 4)
    Write-Host "  ✓ GitHub Token 已配置 via GH_TOKEN ($tokenPrefix...)" -ForegroundColor Green
} else {
    Write-Host "  ✗ GitHub Token 未配置（BMAD 安装可能因 rate limit 失败）" -ForegroundColor Red
    Write-Host ""
    Write-Host "  配置方法：" -ForegroundColor Yellow
    Write-Host "  1. 打开 https://github.com/settings/tokens"
    Write-Host "  2. Generate new token (classic) → Scopes 勾选 public_repo → 生成"
    Write-Host "  3. PowerShell 临时设置: `$env:GITHUB_TOKEN = 'ghp_你的token'"
    Write-Host "  4. 永久设置: [Environment]::SetEnvironmentVariable('GITHUB_TOKEN', 'ghp_你的token', 'User')"
    Write-Host ""
    Write-Host "  配置完成后重新运行本脚本。" -ForegroundColor Yellow
    $Errors++
}

try {
    $uvVersion = (uv --version 2>$null)
    if ($uvVersion) { Write-Host "  ✓ uv $uvVersion" -ForegroundColor Green }
    else { throw }
} catch { Write-Host "  ⚠ uv 未安装（可选）" -ForegroundColor Yellow }

$aiIdes = @()
if (Get-Command claude -ErrorAction SilentlyContinue) { $aiIdes += "Claude Code" }
if (Get-Command cursor -ErrorAction SilentlyContinue) { $aiIdes += "Cursor" }
if (Get-Command kiro -ErrorAction SilentlyContinue) { $aiIdes += "Kiro" }
if (Test-Path "$env:LOCALAPPDATA\Programs\Kiro\Kiro.exe" -ErrorAction SilentlyContinue) { $aiIdes += "Kiro" }
if (Get-Command codex -ErrorAction SilentlyContinue) { $aiIdes += "CodeX" }
$aiIdes = $aiIdes | Select-Object -Unique
if ($aiIdes.Count -gt 0) { Write-Host "  ✓ 检测到 AI IDE: $($aiIdes -join ', ')" -ForegroundColor Green }
else { Write-Host "  ℹ 请确认 AI IDE（Kiro / Claude Code / Cursor / CodeX）已就绪" -ForegroundColor Yellow }

if ($Errors -gt 0) { Write-Host "`n发现 $Errors 个环境问题，请先修复。" -ForegroundColor Red; exit 1 }
Write-Host ""

# ============================================================
# Step 2: 创建目录结构
# ============================================================
Write-Host "[2/5] 创建目录结构..." -ForegroundColor Yellow
@("_bmad/custom", "_bmad-output/planning-artifacts", "_bmad-output/implementation-artifacts", "docs/seed-prompts", "src") | ForEach-Object { New-Item -ItemType Directory -Path $_ -Force | Out-Null }
Write-Host "  ✓ 目录结构已创建" -ForegroundColor Green
Write-Host ""

# ============================================================
# Step 3: 生成 Workshop 内容
# ============================================================
Write-Host "[3/5] 生成 Workshop 内容..." -ForegroundColor Yellow

# --- 中央配置覆盖（强制中文）---
@'
[core]
communication_language = "Chinese"
document_output_language = "Chinese"

[modules.bmm]
project_name = "aidlc-bmad-workshop"
user_skill_level = "intermediate"
'@ | Set-Content -Path "_bmad/custom/config.toml" -Encoding UTF8
Write-Host "  ✓ _bmad/custom/config.toml" -ForegroundColor Green

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
Write-Host "  ✓ Product Brief" -ForegroundColor Green

# --- Agent 定制配置 ---
@'
[agent]
icon = "📋"
role = "Workshop PM — 基于预置 Brief 快速创建 PRD。聚焦 MVP。"
communication_style = "简洁直接，中文沟通。API 用 Method+Path 格式。"
persistent_facts = ["半天 Workshop，PRD 30 分钟内完成。","技术栈已锁定：Lambda+DynamoDB+API GW+CDK。","MVP：5 端点+JWT。"]
principles = ["MVP 优先。","每端点有 Method/Path/Body/Response/Errors。"]
activation_steps_prepend = ["读取 {project-root}/_bmad-output/planning-artifacts/product-brief.md。"]
[[agent.menu]]
code = "CP"
description = "基于预置 Brief 创建 PRD"
prompt = "读取 product-brief.md，创建 PRD：5 端点+JWT+错误处理+版本策略。输出到 {planning_artifacts}/prd.md"
'@ | Set-Content -Path "_bmad/custom/bmad-agent-pm.toml" -Encoding UTF8

@'
[agent]
icon = "🏗️"
role = "Workshop 架构师 — 技术栈已确定，聚焦架构文档和 CDK 结构。"
communication_style = "技术化结构化，中文沟通。DynamoDB 用 Access Pattern 表格。"
persistent_facts = ["半天 Workshop，架构 30 分钟内完成。","技术栈：Lambda+API GW+DynamoDB+CDK(TS)。","JWT via Lambda Authorizer。CloudWatch+X-Ray。"]
principles = ["Serverless 优先。","单表设计。","IaC 即文档。"]
activation_steps_prepend = ["读取 {project-root}/_bmad-output/planning-artifacts/product-brief.md。"]
[[agent.menu]]
code = "CA"
description = "创建技术架构文档"
prompt = "创建架构：系统概览+DynamoDB 单表+API GW 路由+Authorizer+CDK 结构+监控。输出到 {planning_artifacts}/architecture.md"
[[agent.menu]]
code = "CI"
description = "生成 CDK 骨架"
prompt = "生成 CDK TS 骨架到 src/infra/：主 Stack+Auth Stack+App 入口。"
'@ | Set-Content -Path "_bmad/custom/bmad-agent-architect.toml" -Encoding UTF8

@'
[agent]
icon = "💻"
role = "Workshop 开发 — TDD 模式实现 API endpoint。"
communication_style = "代码优先，中文注释。直接给可运行代码。"
persistent_facts = ["半天 Workshop，每 Story 约 25 分钟。","TS+Lambda+DynamoDB+Zod+Jest。","TDD：先测试再实现。"]
principles = ["TDD 铁律。","单一职责。","代码精简。"]
activation_steps_prepend = ["读取 {project-root}/_bmad-output/planning-artifacts/prd.md（如果存在）。","读取 {project-root}/_bmad-output/planning-artifacts/architecture.md（如果存在）。"]
[[agent.menu]]
code = "DS"
description = "实现 Story（TDD）"
prompt = "TDD 实现：先 Jest 测试→Lambda handler→Zod schema→DynamoDB 封装。问用户哪个端点。"
[[agent.menu]]
code = "D2"
description = "实现第二个 Story"
prompt = "基于第一个 Story 模式实现第二个端点。复用封装，同样 TDD。"
'@ | Set-Content -Path "_bmad/custom/bmad-agent-dev.toml" -Encoding UTF8

@'
# QA 测试设计 Workflow — AIDLC Workshop 定制
[workflow]
persistent_facts = ["半天 Workshop，策略 30 分钟完成。","5 端点+JWT。Jest+supertest+Artillery。","<200ms p95，覆盖率>80%。","风险驱动——高风险路径优先。","测试金字塔——单元多、集成适中、E2E 少。","边界值优先。"]
activation_steps_prepend = ["读取 {project-root}/_bmad-output/planning-artifacts/product-brief.md。"]
'@ | Set-Content -Path "_bmad/custom/bmad-testarch-test-design.toml" -Encoding UTF8

@'
# TEA Agent (Murat) — AIDLC Workshop 定制
[agent]
icon = "🧪"
persistent_facts = ["半天 Workshop，50 分钟完成。","Jest+supertest+Artillery。","<200ms p95，并发 100 无错误。","Review Gate #2 现场演示。","可运行优先。","CI 友好。","幂等性。"]
activation_steps_prepend = ["读取 {project-root}/_bmad-output/planning-artifacts/test-strategy.md（如果存在）。","读取 {project-root}/_bmad-output/planning-artifacts/architecture.md（如果存在）。"]
'@ | Set-Content -Path "_bmad/custom/bmad-tea.toml" -Encoding UTF8
Write-Host "  ✓ 5 个 Agent/Workflow 定制配置" -ForegroundColor Green

# --- Seed Prompts（备选）---
@'
# PM Seed Prompt (备选：BMAD 已装时用 /bmad-agent-pm → CP)
```
CP
Based on product-brief.md, create PRD: 5 endpoints + JWT + error handling + versioning. MVP scope.
```
'@ | Set-Content -Path "docs/seed-prompts/pm-seed.md" -Encoding UTF8
@'
# Architect Seed Prompt (备选：BMAD 已装时用 /bmad-agent-architect → CA)
```
CA
Create architecture: Lambda+API GW+DynamoDB+CDK. Single-table design, JWT Authorizer, CloudWatch+X-Ray.
```
'@ | Set-Content -Path "docs/seed-prompts/architect-seed.md" -Encoding UTF8
@'
# Dev Seed Prompt (备选：BMAD 已装时用 /bmad-agent-dev → DS)
```
DS
Implement "Create Room" endpoint. TypeScript+Lambda+DynamoDB. POST /api/v1/rooms. Zod+Jest. TDD.
```
'@ | Set-Content -Path "docs/seed-prompts/dev-seed.md" -Encoding UTF8
@'
# QA Seed Prompt (备选：BMAD 已装时用 /bmad-testarch-test-design → TS)
```
QA
Test strategy + automated tests: unit+integration+contract+edge cases. Jest+supertest.
```
'@ | Set-Content -Path "docs/seed-prompts/qa-seed.md" -Encoding UTF8
@'
# Tester Seed Prompt (备选：BMAD 已装时用 /bmad-tea → E2E/PF/ST)
```
QA
E2E + Performance(<200ms p95) + Security(JWT bypass, injection). Jest+supertest+Artillery.
```
'@ | Set-Content -Path "docs/seed-prompts/tester-seed.md" -Encoding UTF8
Write-Host "  ✓ 5 个 Seed Prompts" -ForegroundColor Green
Write-Host ""

# ============================================================
# Step 4: 安装 BMAD Method
# ============================================================
Write-Host "[4/5] 安装 BMAD Method..." -ForegroundColor Yellow
Write-Host "  运行: npx bmad-method install --yes --modules bmm,tea --tools kiro"
Write-Host ""

try {
    $output = npx bmad-method install --yes --modules bmm,tea --tools kiro --directory (Get-Location).Path --communication-language "Chinese" --document-output-language "Chinese" --set bmm.project_name="aidlc-bmad-workshop" 2>&1
    Write-Host "  ✓ BMAD Method 安装完成" -ForegroundColor Green
} catch {
    Write-Host "  ⚠ BMAD 自动安装未成功，请手动运行：" -ForegroundColor Yellow
    Write-Host "    npx bmad-method install" -ForegroundColor Cyan
    Write-Host "    选择: Modules → BMM, AI IDE → kiro, 语言 → Chinese"
}
Write-Host ""

# ============================================================
# Step 5: 验证
# ============================================================
Write-Host "[5/5] 验证..." -ForegroundColor Yellow

$files = @(
    "_bmad/custom/config.toml",
    "_bmad/custom/bmad-agent-pm.toml",
    "_bmad/custom/bmad-agent-architect.toml",
    "_bmad/custom/bmad-agent-dev.toml",
    "_bmad/custom/bmad-testarch-test-design.toml",
    "_bmad/custom/bmad-tea.toml",
    "_bmad/custom/bmad-tea.toml",
    "_bmad-output/planning-artifacts/product-brief.md"
)

$allOk = $true
foreach ($f in $files) {
    if (Test-Path $f) { Write-Host "  ✓ $f" -ForegroundColor Green }
    else { Write-Host "  ✗ $f" -ForegroundColor Red; $allOk = $false }
}

if (Test-Path "_bmad/_config/manifest.yaml") { Write-Host "  ✓ BMAD 核心已安装" -ForegroundColor Green }
else { Write-Host "  ⚠ BMAD 核心未检测到（请手动 npx bmad-method install）" -ForegroundColor Yellow }

if ((Test-Path "_bmad/tea") -or (Test-Path "_bmad/custom/bmad-tea.toml")) {
    Write-Host "  ✓ TEA (Test Architecture) 模块已配置" -ForegroundColor Green
} else {
    Write-Host "  ⚠ TEA 模块未检测到（可手动运行: npx bmad-method install --modules tea）" -ForegroundColor Yellow
}

Write-Host ""
if ($allOk) {
    Write-Host "╔══════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║   ✅ Workshop 环境初始化完成！                    ║" -ForegroundColor Green
    Write-Host "╚══════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "使用方式：" -ForegroundColor Cyan
    Write-Host "  推荐: 在 Kiro 中输入 /bmad-agent-pm → CP（Agent 自动加载定制）"
    Write-Host "  备选: 复制 docs/seed-prompts/ 中的 Prompt 手动粘贴"
    Write-Host ""
    Write-Host "下一步："
    Write-Host "  1. 用 Kiro 打开本目录"
    Write-Host "  2. 输入 /bmad-help 确认可用"
    Write-Host "  3. 根据角色开始 Workshop"
} else {
    Write-Host "部分文件缺失，请检查错误。" -ForegroundColor Red
    exit 1
}
