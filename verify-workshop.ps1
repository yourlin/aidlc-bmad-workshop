# ============================================================
# AIDLC Workshop 环境验证脚本（Workshop 当天使用）
# 用法: powershell -ExecutionPolicy Bypass -File verify-workshop.ps1
#
# 目的: 30 秒快速验证环境是否就绪，不做任何安装或修改
# ============================================================

$Pass = 0
$Fail = 0
$Warn = 0

function Check-Pass($msg) { Write-Host "  ✅ $msg" -ForegroundColor Green; $script:Pass++ }
function Check-Fail($msg) { Write-Host "  ❌ $msg" -ForegroundColor Red; $script:Fail++ }
function Check-Warn($msg) { Write-Host "  ⚠️ $msg" -ForegroundColor Yellow; $script:Warn++ }

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   AIDLC Workshop 环境验证（30 秒快速检查）       ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# --- 1. 基础工具 ---
Write-Host "[1/4] 基础工具..." -ForegroundColor Yellow

try {
    $nodeVersion = (node --version 2>$null)
    if ($nodeVersion) {
        $major = [int]($nodeVersion -replace 'v','').Split('.')[0]
        if ($major -ge 20) { Check-Pass "Node.js $nodeVersion" }
        else { Check-Fail "Node.js $nodeVersion — 需要 >= v20" }
    } else { throw }
} catch { Check-Fail "Node.js 未安装" }

try {
    $pythonVersion = (python3 --version 2>$null) -replace 'Python ',''
    if (-not $pythonVersion) { $pythonVersion = (python --version 2>$null) -replace 'Python ','' }
    if ($pythonVersion) {
        $minor = [int]$pythonVersion.Split('.')[1]
        if ($minor -ge 10) { Check-Pass "Python $pythonVersion" }
        else { Check-Fail "Python $pythonVersion — 需要 >= 3.10" }
    } else { throw }
} catch { Check-Fail "Python3 未安装" }

# --- 2. GitHub Token ---
Write-Host ""
Write-Host "[2/4] GitHub Token..." -ForegroundColor Yellow

if ($env:GITHUB_TOKEN) {
    Check-Pass "GITHUB_TOKEN 已配置"
} elseif ($env:GH_TOKEN) {
    Check-Pass "GH_TOKEN 已配置"
} else {
    Check-Fail "GitHub Token 未配置 — BMAD 安装会因 rate limit 失败"
    Write-Host "        配置方法: `$env:GITHUB_TOKEN = 'ghp_你的token'" -ForegroundColor Gray
}

# --- 3. BMAD 安装状态 ---
Write-Host ""
Write-Host "[3/4] BMAD 安装..." -ForegroundColor Yellow

try {
    $bmadStatus = npx bmad-method status 2>$null
    if ($LASTEXITCODE -eq 0) { Check-Pass "BMAD 已安装" }
    else { throw }
} catch { Check-Fail "BMAD 未安装或状态异常 — 运行: npx bmad-method install" }

if ((Test-Path "_bmad/core") -and (Test-Path "_bmad/bmm")) {
    Check-Pass "_bmad/core 和 _bmad/bmm 目录存在"
} elseif ((Test-Path "_bmad/core") -or (Test-Path "_bmad/bmm")) {
    Check-Warn "_bmad 目录不完整"
} else {
    Check-Fail "_bmad 目录不存在 — 请先运行 setup-workshop.ps1 + npx bmad-method install"
}

if (Test-Path "_bmad-output/planning-artifacts/product-brief.md") {
    Check-Pass "Product Brief 预置文件存在"
} else {
    Check-Warn "Product Brief 不存在（Brownfield 项目可忽略）"
}

# --- 4. AI IDE ---
Write-Host ""
Write-Host "[4/4] AI IDE..." -ForegroundColor Yellow

$ideFound = $false
if (Get-Command claude -ErrorAction SilentlyContinue) { Check-Pass "Claude Code 已安装"; $ideFound = $true }
if (Get-Command kiro -ErrorAction SilentlyContinue) { Check-Pass "Kiro 已安装"; $ideFound = $true }
if (Test-Path "$env:LOCALAPPDATA\Programs\Kiro\Kiro.exe") { Check-Pass "Kiro 已安装"; $ideFound = $true }
if (Get-Command cursor -ErrorAction SilentlyContinue) { Check-Pass "Cursor 已安装"; $ideFound = $true }
if (Get-Command codex -ErrorAction SilentlyContinue) { Check-Pass "CodeX 已安装"; $ideFound = $true }

if (-not $ideFound) {
    Check-Warn "未检测到 AI IDE — 请确认已安装 Kiro/Claude Code/Cursor/CodeX"
}

# --- 结果汇总 ---
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

if ($Fail -eq 0) {
    Write-Host "╔══════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║   🟢 环境就绪！可以开始 Workshop                 ║" -ForegroundColor Green
    Write-Host "╚══════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host "  通过: $Pass | 警告: $Warn | 失败: $Fail"
} else {
    Write-Host "╔══════════════════════════════════════════════════╗" -ForegroundColor Red
    Write-Host "║   🔴 环境未就绪！请先解决以上 ❌ 标记的问题       ║" -ForegroundColor Red
    Write-Host "╚══════════════════════════════════════════════════╝" -ForegroundColor Red
    Write-Host "  通过: $Pass | 警告: $Warn | 失败: $Fail" -ForegroundColor Red
    Write-Host ""
    Write-Host "  请举手或翻红灯牌，技术助教将协助您解决问题。"
}
Write-Host ""
