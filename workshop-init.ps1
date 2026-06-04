# ============================================================
# AIDLC Workshop Brownfield 项目自动初始化 (Windows PowerShell)
# 用法: powershell -ExecutionPolicy Bypass -File workshop-init.ps1
#
# 功能:
#   1. 自动扫描项目技术栈（语言/框架/依赖）
#   2. 推断架构模式（分层/微服务/Serverless）
#   3. 提取项目组织结构和业务信息
#   4. 生成 BMAD Agent TOML 配置（persistent_facts 预填）
#   5. 生成 project-context.md（四层理解）
#   6. 输出确认卡供学员审核
# ============================================================

$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   AIDLC Workshop Brownfield 自动初始化           ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# ============================================================
# 配置
# ============================================================
$OutputDir = "_bmad-output/planning-artifacts"
$CustomDir = "_bmad/custom"
$ProjectRoot = Get-Location
$ProjectName = Split-Path -Leaf $ProjectRoot

New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
New-Item -ItemType Directory -Path $CustomDir -Force | Out-Null

# ============================================================
# Step 1: 技术栈扫描
# ============================================================
Write-Host "[1/5] 扫描技术栈..." -ForegroundColor Yellow

$Languages = @()
$Frameworks = @()
$BuildTools = @()
$Databases = @()
$CloudServices = @()
$Testing = @()

# --- 语言检测 ---
if ((Test-Path "tsconfig.json")) { $Languages += "TypeScript" }
elseif ((Test-Path "package.json")) { $Languages += "JavaScript" }
if ((Test-Path "pom.xml") -or (Test-Path "build.gradle") -or (Test-Path "build.gradle.kts")) {
    if (Get-ChildItem -Recurse -Depth 3 -Filter "*.kt" -ErrorAction SilentlyContinue | Select-Object -First 1) {
        $Languages += "Kotlin"
    } else { $Languages += "Java" }
}
if ((Test-Path "requirements.txt") -or (Test-Path "pyproject.toml") -or (Test-Path "setup.py") -or (Test-Path "Pipfile")) { $Languages += "Python" }
if (Test-Path "go.mod") { $Languages += "Go" }
if (Test-Path "Cargo.toml") { $Languages += "Rust" }
if (Test-Path "Gemfile") { $Languages += "Ruby" }
if (Get-ChildItem -Recurse -Depth 2 -Filter "*.cs" -ErrorAction SilentlyContinue | Select-Object -First 1) { $Languages += "C#" }

$LanguagesStr = if ($Languages.Count -gt 0) { $Languages -join ", " } else { "Unknown" }
Write-Host "  ✓ 语言: $LanguagesStr" -ForegroundColor Green

# --- 框架检测 ---
if (Test-Path "package.json") {
    $pkgContent = Get-Content "package.json" -Raw -ErrorAction SilentlyContinue
    if ($pkgContent) {
        if ($pkgContent -match '"react"') { $Frameworks += "React" }
        if ($pkgContent -match '"vue"') { $Frameworks += "Vue" }
        if ($pkgContent -match '"angular"') { $Frameworks += "Angular" }
        if ($pkgContent -match '"next"') { $Frameworks += "Next.js" }
        if ($pkgContent -match '"nuxt"') { $Frameworks += "Nuxt" }
        if ($pkgContent -match '"svelte"') { $Frameworks += "Svelte" }
        if ($pkgContent -match '"express"') { $Frameworks += "Express" }
        if ($pkgContent -match '"fastify"') { $Frameworks += "Fastify" }
        if ($pkgContent -match '"@nestjs/core"') { $Frameworks += "NestJS" }
        if ($pkgContent -match '"koa"') { $Frameworks += "Koa" }
        if ($pkgContent -match '"jest"') { $Testing += "Jest" }
        if ($pkgContent -match '"vitest"') { $Testing += "Vitest" }
        if ($pkgContent -match '"mocha"') { $Testing += "Mocha" }
        if ($pkgContent -match '"cypress"') { $Testing += "Cypress" }
        if ($pkgContent -match '"playwright"') { $Testing += "Playwright" }
        if ($pkgContent -match '"webpack"') { $BuildTools += "Webpack" }
        if ($pkgContent -match '"vite"') { $BuildTools += "Vite" }
        if ($pkgContent -match '"esbuild"') { $BuildTools += "esbuild" }
        if ($pkgContent -match '"turbo"') { $BuildTools += "Turborepo" }
        if ($pkgContent -match '"aws-cdk"') { $CloudServices += "AWS CDK" }
        if ($pkgContent -match '"@aws-sdk"') { $CloudServices += "AWS SDK" }
        if ($pkgContent -match '"serverless"') { $CloudServices += "Serverless Framework" }
    }
}

if (Test-Path "pom.xml") {
    $pomContent = Get-Content "pom.xml" -Raw -ErrorAction SilentlyContinue
    if ($pomContent) {
        if ($pomContent -match "spring-boot") { $Frameworks += "Spring Boot" }
        if ($pomContent -match "quarkus") { $Frameworks += "Quarkus" }
        if ($pomContent -match "micronaut") { $Frameworks += "Micronaut" }
        if ($pomContent -match "mybatis") { $Frameworks += "MyBatis" }
        if ($pomContent -match "hibernate") { $Frameworks += "Hibernate" }
    }
}

$gradleFiles = @("build.gradle", "build.gradle.kts") | Where-Object { Test-Path $_ }
if ($gradleFiles) {
    $gradleContent = ($gradleFiles | ForEach-Object { Get-Content $_ -Raw -ErrorAction SilentlyContinue }) -join "`n"
    if ($gradleContent -match "spring-boot") { $Frameworks += "Spring Boot" }
    if ($gradleContent -match "ktor") { $Frameworks += "Ktor" }
}

$pyFiles = @("requirements.txt", "pyproject.toml") | Where-Object { Test-Path $_ }
if ($pyFiles) {
    $pyContent = ($pyFiles | ForEach-Object { Get-Content $_ -Raw -ErrorAction SilentlyContinue }) -join "`n"
    if ($pyContent -match "(?i)django") { $Frameworks += "Django" }
    if ($pyContent -match "(?i)flask") { $Frameworks += "Flask" }
    if ($pyContent -match "(?i)fastapi") { $Frameworks += "FastAPI" }
    if ($pyContent -match "(?i)pytest") { $Testing += "pytest" }
}

$FrameworksStr = if ($Frameworks.Count -gt 0) { ($Frameworks | Select-Object -Unique) -join ", " } else { "" }
$BuildToolsStr = if ($BuildTools.Count -gt 0) { ($BuildTools | Select-Object -Unique) -join ", " } else { "" }
$TestingStr = if ($Testing.Count -gt 0) { ($Testing | Select-Object -Unique) -join ", " } else { "" }
$CloudServicesStr = if ($CloudServices.Count -gt 0) { ($CloudServices | Select-Object -Unique) -join ", " } else { "" }

if ($FrameworksStr) { Write-Host "  ✓ 框架: $FrameworksStr" -ForegroundColor Green }
if ($BuildToolsStr) { Write-Host "  ✓ 构建工具: $BuildToolsStr" -ForegroundColor Green }
if ($TestingStr) { Write-Host "  ✓ 测试: $TestingStr" -ForegroundColor Green }
if ($CloudServicesStr) { Write-Host "  ✓ 云服务: $CloudServicesStr" -ForegroundColor Green }

# --- 数据库检测 ---
$configFiles = Get-ChildItem -Recurse -Depth 3 -Include "*.yml","*.yaml","*.properties","*.json","*.toml","*.env*","docker-compose*" -ErrorAction SilentlyContinue | Where-Object { $_.FullName -notmatch "node_modules|\.git|target|build|dist" } | Select-Object -First 20
if ($configFiles) {
    $configContent = ($configFiles | ForEach-Object { Get-Content $_.FullName -Raw -ErrorAction SilentlyContinue }) -join "`n"
    if ($configContent -match "(?i)mysql") { $Databases += "MySQL" }
    if ($configContent -match "(?i)postgres") { $Databases += "PostgreSQL" }
    if ($configContent -match "(?i)mongodb") { $Databases += "MongoDB" }
    if ($configContent -match "(?i)redis") { $Databases += "Redis" }
    if ($configContent -match "(?i)dynamodb") { $Databases += "DynamoDB" }
    if ($configContent -match "(?i)elasticsearch") { $Databases += "Elasticsearch" }
    if ($configContent -match "(?i)sqlite") { $Databases += "SQLite" }
}
$DatabasesStr = if ($Databases.Count -gt 0) { ($Databases | Select-Object -Unique) -join ", " } else { "" }
if ($DatabasesStr) { Write-Host "  ✓ 数据库: $DatabasesStr" -ForegroundColor Green }

Write-Host ""

# ============================================================
# Step 2: 架构模式推断
# ============================================================
Write-Host "[2/5] 推断架构模式..." -ForegroundColor Yellow

$ArchPattern = ""
$ArchLayers = ""

$hasControllers = Get-ChildItem -Recurse -Depth 2 -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "^controllers?$" } | Select-Object -First 1
$hasHandlers = Get-ChildItem -Recurse -Depth 2 -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "^(handlers|lambda)$" } | Select-Object -First 1
$hasRoutes = Get-ChildItem -Recurse -Depth 2 -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq "routes" } | Select-Object -First 1
$hasServices = Get-ChildItem -Recurse -Depth 2 -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq "services" } | Select-Object -First 1
$hasPackages = Get-ChildItem -Depth 1 -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "^(packages|apps)$" } | Select-Object -First 1

if ($hasControllers) {
    $ArchPattern = "MVC / 分层架构"
    $ArchLayers = "Controller → Service → Repository"
} elseif ($hasHandlers) {
    $ArchPattern = "Serverless / 函数式"
    $ArchLayers = "Handler → Service → Data"
} elseif ($hasRoutes -and $hasServices) {
    $ArchPattern = "Service-oriented"
    $ArchLayers = "Route → Service → Model"
} elseif ($hasPackages) {
    $ArchPattern = "Monorepo / 多包"
    $ArchLayers = "Apps/Packages → Shared Libraries"
}

# 微服务检测
$dockerComposeExists = Test-Path "docker-compose*"
$dockerfileCount = (Get-ChildItem -Recurse -Depth 2 -Filter "Dockerfile" -ErrorAction SilentlyContinue).Count
if ($dockerComposeExists -and $dockerfileCount -gt 1) { $ArchPattern = "微服务" }

if (-not $ArchPattern) { $ArchPattern = "待确认（建议在 Agent 对话中进一步明确）" }

Write-Host "  ✓ 架构模式: $ArchPattern" -ForegroundColor Green
if ($ArchLayers) { Write-Host "  ✓ 分层: $ArchLayers" -ForegroundColor Green }
Write-Host ""

# ============================================================
# Step 3: 项目组织结构扫描
# ============================================================
Write-Host "[3/5] 扫描项目组织结构..." -ForegroundColor Yellow

$excludeDirs = @("node_modules", ".git", "__pycache__", ".idea", ".vscode", "target", "build", "dist", "_bmad", "_bmad-output")
$topDirs = Get-ChildItem -Directory -Depth 0 -ErrorAction SilentlyContinue | Where-Object { $_.Name -notin $excludeDirs } | Select-Object -First 15 | ForEach-Object { $_.Name }

# 统计代码规模
$codeExtensions = @("*.ts","*.tsx","*.js","*.jsx","*.java","*.py","*.go","*.rs","*.kt","*.cs","*.rb")
$codeFiles = Get-ChildItem -Recurse -Include $codeExtensions -ErrorAction SilentlyContinue | Where-Object { $_.FullName -notmatch "node_modules|\.git|target|build|dist" }
$TotalFiles = $codeFiles.Count
$TotalLines = 0
if ($codeFiles.Count -gt 0) {
    $TotalLines = ($codeFiles | ForEach-Object { (Get-Content $_.FullName -ErrorAction SilentlyContinue).Count } | Measure-Object -Sum).Sum
}

Write-Host "  ✓ 源文件数: $TotalFiles" -ForegroundColor Green
Write-Host "  ✓ 代码行数: ~$TotalLines" -ForegroundColor Green
Write-Host "  ✓ 顶层目录:" -ForegroundColor Green
foreach ($dir in $topDirs) { Write-Host "      $dir/" -ForegroundColor Cyan }

# 测试目录
$testDirs = Get-ChildItem -Recurse -Depth 3 -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "^(tests?|__tests__|spec)$" -and $_.FullName -notmatch "node_modules" } | Select-Object -First 5
if ($testDirs) { Write-Host "  ✓ 测试目录: 已发现" -ForegroundColor Green }
else { Write-Host "  ⚠ 未发现测试目录" -ForegroundColor Yellow }

Write-Host ""

# ============================================================
# Step 4: 业务信息提取
# ============================================================
Write-Host "[4/5] 提取业务信息..." -ForegroundColor Yellow

$BusinessContext = ""
if (Test-Path "README.md") {
    $readmeLines = Get-Content "README.md" -ErrorAction SilentlyContinue | Where-Object { $_ -notmatch "^#" -and $_ -ne "" } | Select-Object -First 5
    if ($readmeLines) {
        $BusinessContext = $readmeLines -join "`n"
        Write-Host "  ✓ 从 README.md 提取业务描述" -ForegroundColor Green
    }
}

# 检测 API 路由（JS/TS）
$apiFiles = Get-ChildItem -Recurse -Depth 4 -Include "*.ts","*.js" -ErrorAction SilentlyContinue | Where-Object { $_.FullName -notmatch "node_modules" } | Where-Object { (Get-Content $_.FullName -Raw -ErrorAction SilentlyContinue) -match "router\.|app\.(get|post|put|delete)" } | Select-Object -First 20
if ($apiFiles) { Write-Host "  ✓ API 路由文件: ~$($apiFiles.Count) 个" -ForegroundColor Green }

# 检测 Java Controller
$controllerFiles = Get-ChildItem -Recurse -Depth 4 -Filter "*Controller.java" -ErrorAction SilentlyContinue | Where-Object { $_.FullName -notmatch "target" }
if ($controllerFiles) { Write-Host "  ✓ Controller 类: $($controllerFiles.Count) 个" -ForegroundColor Green }

# Git 信息
if (Test-Path ".git") {
    try {
        $activeBranch = git branch --show-current 2>$null
        $recentAuthors = (git log --format='%an' -20 2>$null | Sort-Object -Unique).Count
        Write-Host "  ✓ Git: 分支=$activeBranch, 最近活跃作者=$recentAuthors" -ForegroundColor Green
    } catch {}
}

Write-Host ""

# ============================================================
# Step 5: 生成配置和文档
# ============================================================
Write-Host "[5/5] 生成配置和文档..." -ForegroundColor Yellow

$dateStr = Get-Date -Format "yyyy-MM-dd HH:mm"
$topDirsFormatted = ($topDirs | ForEach-Object { "├── $_" }) -join "`n"
if ($topDirsFormatted) { $topDirsFormatted = $topDirsFormatted -replace '├── (?=[^\n]*$)', '└── ' }

# --- 生成 project-context.md ---
@"
# Project Context: $ProjectName

> 由 workshop-init.ps1 自动生成于 $dateStr
> ⚠️ 请审核以下内容，修正不准确的部分

---

## 第一层：技术栈

| 维度 | 检测结果 |
|------|---------|
| 语言 | $LanguagesStr |
| 框架 | $(if($FrameworksStr){$FrameworksStr}else{"未检测到"}) |
| 构建工具 | $(if($BuildToolsStr){$BuildToolsStr}else{"未检测到"}) |
| 测试框架 | $(if($TestingStr){$TestingStr}else{"未检测到"}) |
| 数据库 | $(if($DatabasesStr){$DatabasesStr}else{"未检测到"}) |
| 云服务 | $(if($CloudServicesStr){$CloudServicesStr}else{"未检测到"}) |

## 第二层：架构

| 维度 | 检测结果 |
|------|---------|
| 架构模式 | $ArchPattern |
| 分层结构 | $(if($ArchLayers){$ArchLayers}else{"待确认"}) |
| 代码规模 | $TotalFiles 文件, ~$TotalLines 行 |

## 第三层：项目组织

**顶层目录结构：**
``````
$ProjectName/
$topDirsFormatted
``````

**测试：** $(if($testDirs){"已发现测试目录"}else{"未发现测试目录"})

## 第四层：业务逻辑与目标

$(if($BusinessContext){$BusinessContext}else{"⚠️ 未能从 README 自动提取业务描述，请手动补充："})

**[需要你补充]：**
- 这个项目的核心业务是什么？
- 主要服务哪些用户/系统？
- 当前阶段的开发目标是什么？

---

## 受保护路径（AI 不应修改的目录/文件）

> 请标注哪些目录是稳定的、不应被 AI 修改的

- [ ] ``src/core/`` — 核心基础设施（如适用）
- [ ] ``src/auth/`` — 认证模块（如适用）
- [ ] ``database/migrations/`` — 数据库迁移（如适用）
- [ ] 其他: ___

---

## 置信度说明

| 层级 | 置信度 | 说明 |
|------|--------|------|
| 技术栈 | 🟢 高 | 基于 package.json / pom.xml 等配置文件直接读取 |
| 架构 | 🟡 中 | 基于目录结构推断，可能不完全准确 |
| 项目组织 | 🟢 高 | 直接扫描文件系统 |
| 业务逻辑 | 🔴 低 | 仅从 README 提取，需要人工补充 |
"@ | Set-Content -Path "$OutputDir/project-context.md" -Encoding UTF8

Write-Host "  ✓ 已生成 $OutputDir/project-context.md" -ForegroundColor Green

# --- 生成 Brownfield Agent TOML ---
@"
# PM Agent — Brownfield Workshop 定制
# 由 workshop-init.ps1 自动生成

[agent]
persistent_facts = [
  "这是 Brownfield 项目，项目名: $ProjectName",
  "技术栈: $LanguagesStr + $FrameworksStr",
  "数据库: $(if($DatabasesStr){$DatabasesStr}else{"待确认"})",
  "架构模式: $ArchPattern",
  "Workshop 时间约束: 30 分钟内完成 PRD",
  "PRD 应聚焦增量变更，不要重新描述已有功能",
  "project-context.md 包含现有系统描述，请先阅读",
]

[agent.activation_steps_prepend]
steps = [
  "读取 _bmad-output/planning-artifacts/project-context.md 了解现有系统",
]

[[agent.menu]]
code = "CP"
label = "快速创建增量 PRD"
description = "基于 project-context 描述增量变更需求"

[[agent.menu]]
code = "BP"
label = "生成 Product Brief"
description = "从现有代码推断产品简介"
"@ | Set-Content -Path "$CustomDir/bmad-agent-pm.toml" -Encoding UTF8

Write-Host "  ✓ 已生成 $CustomDir/bmad-agent-pm.toml" -ForegroundColor Green

@"
# Architect Agent — Brownfield Workshop 定制
# 由 workshop-init.ps1 自动生成

[agent]
persistent_facts = [
  "这是 Brownfield 项目: $ProjectName",
  "现有技术栈: $LanguagesStr + $FrameworksStr",
  "架构模式: $ArchPattern",
  "数据库: $(if($DatabasesStr){$DatabasesStr}else{"待确认"})",
  "云服务: $(if($CloudServicesStr){$CloudServicesStr}else{"待确认"})",
  "新架构决策必须兼容已有技术栈",
  "不得引入与现有模式冲突的新技术",
  "Workshop 时间约束: 30 分钟内完成架构增量文档",
]

[agent.activation_steps_prepend]
steps = [
  "读取 _bmad-output/planning-artifacts/project-context.md 了解现有架构",
]

[[agent.menu]]
code = "CA"
label = "创建增量架构文档"
description = "仅描述新增/变更的架构决策，保持与现有系统一致"

[[agent.menu]]
code = "CI"
label = "生成 IaC 代码"
description = "基于现有模式生成基础设施代码"
"@ | Set-Content -Path "$CustomDir/bmad-agent-architect.toml" -Encoding UTF8

Write-Host "  ✓ 已生成 $CustomDir/bmad-agent-architect.toml" -ForegroundColor Green

@"
# Dev Agent — Brownfield Workshop 定制
# 由 workshop-init.ps1 自动生成

[agent]
persistent_facts = [
  "这是 Brownfield 项目，已有代码库不可破坏",
  "技术栈: $LanguagesStr + $FrameworksStr",
  "测试框架: $(if($TestingStr){$TestingStr}else{"待确认"})",
  "修改前必须先读取现有代码模式，保持风格一致",
  "所有变更必须通过已有测试",
  "遵循 TDD: 先写测试再实现",
  "Workshop 时间约束: 每个 Story 25 分钟内完成",
]

[agent.activation_steps_prepend]
steps = [
  "读取 _bmad-output/planning-artifacts/project-context.md 了解项目结构",
  "读取 _bmad-output/planning-artifacts/architecture.md 了解架构（如存在）",
]

[[agent.menu]]
code = "DS"
label = "实现 Story"
description = "TDD 模式实现当前 Story"

[[agent.menu]]
code = "D2"
label = "继续实现"
description = "继续上一个 Story 的实现"
"@ | Set-Content -Path "$CustomDir/bmad-agent-dev.toml" -Encoding UTF8

Write-Host "  ✓ 已生成 $CustomDir/bmad-agent-dev.toml" -ForegroundColor Green

@"
# QA Agent — Brownfield Workshop 定制
# 由 workshop-init.ps1 自动生成

[agent]
persistent_facts = [
  "这是 Brownfield 项目: $ProjectName",
  "测试框架: $(if($TestingStr){$TestingStr}else{"待确认"})",
  "测试策略必须考虑已有测试的兼容性",
  "新测试应遵循已有测试的组织模式和命名规范",
  "Workshop 时间约束: 30 分钟内完成测试策略",
]

[agent.activation_steps_prepend]
steps = [
  "读取 _bmad-output/planning-artifacts/project-context.md 了解项目",
]

[[agent.menu]]
code = "TS"
label = "创建测试策略"
description = "基于现有测试模式创建增量测试策略"

[[agent.menu]]
code = "AC"
label = "编写验收测试"
description = "为新增功能编写 Given/When/Then 验收用例"
"@ | Set-Content -Path "$CustomDir/bmad-testarch-test-design.toml" -Encoding UTF8

Write-Host "  ✓ 已生成 $CustomDir/bmad-testarch-test-design.toml" -ForegroundColor Green

Write-Host ""

# ============================================================
# 输出确认卡
# ============================================================
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "           项目理解确认卡                            " -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "  📁 项目: $ProjectName" -ForegroundColor Green
Write-Host "  💻 语言: $LanguagesStr" -ForegroundColor Green
Write-Host "  🏗️  框架: $(if($FrameworksStr){$FrameworksStr}else{'未检测到'})" -ForegroundColor Green
Write-Host "  🗄️  数据库: $(if($DatabasesStr){$DatabasesStr}else{'未检测到'})" -ForegroundColor Green
Write-Host "  ☁️  云服务: $(if($CloudServicesStr){$CloudServicesStr}else{'未检测到'})" -ForegroundColor Green
Write-Host "  🧪 测试: $(if($TestingStr){$TestingStr}else{'未检测到'})" -ForegroundColor Green
Write-Host "  📐 架构: $ArchPattern" -ForegroundColor Green
Write-Host "  📊 规模: $TotalFiles 文件 / ~$TotalLines 行" -ForegroundColor Green
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║   ✅ Brownfield 初始化完成！                      ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "已生成文件:"
Write-Host "  $OutputDir/project-context.md" -ForegroundColor Cyan -NoNewline; Write-Host " ← 请审核并补充业务描述"
Write-Host "  $CustomDir/bmad-agent-pm.toml" -ForegroundColor Cyan
Write-Host "  $CustomDir/bmad-agent-architect.toml" -ForegroundColor Cyan
Write-Host "  $CustomDir/bmad-agent-dev.toml" -ForegroundColor Cyan
Write-Host "  $CustomDir/bmad-testarch-test-design.toml" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步:" -ForegroundColor Yellow
Write-Host "  1. 审核 $OutputDir/project-context.md（补充业务描述和受保护路径）"
Write-Host "  2. 运行 npx bmad-method install（如未安装）"
Write-Host "  3. 在 AI IDE 中输入 /bmad-help 开始 Workshop"
Write-Host ""
