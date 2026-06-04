# ============================================================================
# Workshop 项目体检脚本 (Pre-Workshop Health Check) - Windows PowerShell
# 用法: powershell -ExecutionPolicy Bypass -File pre-workshop-check.ps1
# 建议: Workshop 前 2-3 天运行，确保环境就绪
# ============================================================================

$ErrorActionPreference = "Continue"

$Score = 0
$MaxScore = 100
$Issues = @()
$Warnings = @()

function Pass($msg) { Write-Host "  ✓ $msg" -ForegroundColor Green }
function Warn($msg) { Write-Host "  ⚠ $msg" -ForegroundColor Yellow; $script:Warnings += $msg }
function Fail($msg) { Write-Host "  ✗ $msg" -ForegroundColor Red; $script:Issues += $msg }
function Header($msg) { Write-Host "`n[$msg]" -ForegroundColor Cyan }

# --- Banner ---
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════╗" -ForegroundColor White
Write-Host "║     AIDLC × BMAD Workshop — 环境体检 Health Check       ║" -ForegroundColor White
Write-Host "╚══════════════════════════════════════════════════════════╝" -ForegroundColor White
Write-Host ""
Write-Host "运行时间: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Host ""

# =============================================================================
# 1. Node.js (20 points)
# =============================================================================
Header "Node.js (权重: 20分)"

try {
    $nodeVer = (node --version 2>$null) -replace '^v', ''
    $nodeMajor = [int]($nodeVer.Split('.')[0])
    if ($nodeMajor -ge 20) {
        Pass "Node.js v$nodeVer (>= 20 ✓)"
        $Score += 20
    } else {
        Fail "Node.js v$nodeVer — 需要 v20+，请升级"
    }
} catch {
    Fail "Node.js 未安装 — 请安装 v20+ (https://nodejs.org)"
}

# =============================================================================
# 2. Python (10 points)
# =============================================================================
Header "Python (权重: 10分)"

$pythonCmd = $null
try { $null = python3 --version 2>$null; $pythonCmd = "python3" } catch {}
if (-not $pythonCmd) {
    try { $null = python --version 2>$null; $pythonCmd = "python" } catch {}
}

if ($pythonCmd) {
    $pyVer = & $pythonCmd --version 2>&1 | ForEach-Object { ($_ -split ' ')[1] }
    $pyParts = $pyVer.Split('.')
    $pyMajor = [int]$pyParts[0]
    $pyMinor = [int]$pyParts[1]
    if ($pyMajor -ge 3 -and $pyMinor -ge 10) {
        Pass "Python $pyVer (>= 3.10 ✓)"
        $Score += 10
    } else {
        Fail "Python $pyVer — 需要 3.10+，请升级"
    }
} else {
    Fail "Python 未安装 — 请安装 3.10+ (https://python.org)"
}

# =============================================================================
# 3. uv (5 points)
# =============================================================================
Header "uv 包管理器 (权重: 5分)"

try {
    $uvVer = uv --version 2>$null
    if ($uvVer) {
        Pass "uv 已安装 ($uvVer)"
        $Score += 5
    } else { throw "not found" }
} catch {
    Warn "uv 未安装 — 建议安装: powershell -c 'irm https://astral.sh/uv/install.ps1 | iex'"
    $Score += 2
}

# =============================================================================
# 4. Git (10 points)
# =============================================================================
Header "Git (权重: 10分)"

try {
    $gitVer = git --version 2>$null
    if ($gitVer) {
        Pass "$gitVer"
        $Score += 10
    } else { throw "not found" }
} catch {
    Fail "Git 未安装 — 请安装 git (https://git-scm.com)"
}

# =============================================================================
# 5. GitHub Token (15 points)
# =============================================================================
Header "GitHub Token (权重: 15分)"

$token = if ($env:GITHUB_TOKEN) { $env:GITHUB_TOKEN } elseif ($env:GH_TOKEN) { $env:GH_TOKEN } else { "" }

if ($token) {
    if ($token.StartsWith("ghp_") -or $token.StartsWith("github_pat_")) {
        Pass "GitHub Token 已配置 ($($token.Substring(0,7))...)"
        $Score += 15
    } else {
        Warn "Token 格式异常 — 应以 ghp_ 或 github_pat_ 开头"
        $Score += 5
    }
} else {
    Fail "GitHub Token 未配置 — 安装 BMAD 时会触发 API rate limit"
    Write-Host "    修复: `$env:GITHUB_TOKEN = 'ghp_你的token'" -ForegroundColor Yellow
    Write-Host "    获取: https://github.com/settings/tokens" -ForegroundColor Yellow
}

# =============================================================================
# 6. AI IDE (15 points)
# =============================================================================
Header "AI IDE (权重: 15分)"

$ideFound = $false
$ides = @("kiro", "claude", "cursor", "codex")
foreach ($ide in $ides) {
    try {
        $null = Get-Command $ide -ErrorAction Stop
        Pass "$ide 已安装"
        $ideFound = $true
    } catch {}
}
# Check common install paths on Windows
$winPaths = @(
    "$env:LOCALAPPDATA\Programs\Kiro\Kiro.exe",
    "$env:LOCALAPPDATA\Programs\cursor\Cursor.exe"
)
foreach ($p in $winPaths) {
    if (Test-Path $p) {
        $name = (Split-Path $p -Leaf) -replace '\.exe$', ''
        Pass "$name 已安装 ($p)"
        $ideFound = $true
    }
}

if ($ideFound) {
    $Score += 15
} else {
    Fail "未检测到支持的 AI IDE (Kiro/Claude Code/Cursor/CodeX)"
    Write-Host "    至少安装一个 AI IDE 才能参加 Workshop" -ForegroundColor Yellow
}

# =============================================================================
# 7. Network Connectivity (10 points)
# =============================================================================
Header "网络连通性 (权重: 10分)"

$netScore = 0
try {
    $resp = Invoke-WebRequest -Uri "https://registry.npmjs.org/" -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
    Pass "npm registry 可达"
    $netScore += 5
} catch {
    Fail "npm registry 不可达 — 检查网络或代理设置"
}

try {
    $resp = Invoke-WebRequest -Uri "https://api.github.com/" -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
    Pass "GitHub API 可达"
    $netScore += 5
} catch {
    Fail "GitHub API 不可达 — 检查网络或代理设置"
}
$Score += $netScore

# =============================================================================
# 8. Disk Space (5 points)
# =============================================================================
Header "磁盘空间 (权重: 5分)"

$drive = (Get-Location).Drive
$freeGB = [math]::Round((Get-PSDrive $drive.Name).Free / 1GB, 1)

if ($freeGB -ge 5) {
    Pass "可用空间: ${freeGB}GB (>= 5GB ✓)"
    $Score += 5
} elseif ($freeGB -ge 1) {
    Warn "可用空间: ${freeGB}GB — 建议至少 5GB"
    $Score += 3
} else {
    Fail "可用空间不足: ${freeGB}GB — 需要至少 1GB"
}

# =============================================================================
# 9. npx & BMAD (10 points)
# =============================================================================
Header "npx & BMAD (权重: 10分)"

try {
    $null = Get-Command npx -ErrorAction Stop
    Pass "npx 可用"
    $Score += 5
    try {
        $bmadVer = npx bmad-method --version 2>$null
        if ($bmadVer) {
            Pass "bmad-method 已缓存 ($bmadVer)"
            $Score += 5
        } else { throw "not cached" }
    } catch {
        Warn "bmad-method 未缓存 — Workshop 时会自动下载"
        $Score += 3
    }
} catch {
    Fail "npx 不可用 — 请确认 Node.js 安装完整"
}

# =============================================================================
# REPORT
# =============================================================================
Write-Host ""
Write-Host "══════════════════════════════════════════════════════════════" -ForegroundColor White

if ($Score -ge 90) {
    $scoreColor = "Green"; $status = "完美就绪"
} elseif ($Score -ge 70) {
    $scoreColor = "Yellow"; $status = "基本就绪，有小问题"
} elseif ($Score -ge 50) {
    $scoreColor = "Yellow"; $status = "需要修复才能参加"
} else {
    $scoreColor = "Red"; $status = "环境未就绪"
}

Write-Host "  Workshop 就绪度: " -NoNewline
Write-Host "$Score/$MaxScore" -ForegroundColor $scoreColor -NoNewline
Write-Host "  — $status"
Write-Host "══════════════════════════════════════════════════════════════" -ForegroundColor White

if ($Issues.Count -gt 0) {
    Write-Host "`n必须修复 ($($Issues.Count) 项):" -ForegroundColor Red
    foreach ($i in $Issues) { Write-Host "  • $i" -ForegroundColor Red }
}

if ($Warnings.Count -gt 0) {
    Write-Host "`n建议改进 ($($Warnings.Count) 项):" -ForegroundColor Yellow
    foreach ($w in $Warnings) { Write-Host "  • $w" -ForegroundColor Yellow }
}

if ($Issues.Count -eq 0 -and $Warnings.Count -eq 0) {
    Write-Host "`n  所有检查通过，Workshop 环境完美就绪！" -ForegroundColor Green
}

# Write report file
$reportFile = "workshop-readiness-report.txt"
$report = @"
AIDLC × BMAD Workshop 就绪度报告
生成时间: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
得分: $Score/$MaxScore

"@

if ($Issues.Count -gt 0) {
    $report += "=== 必须修复 ===`n"
    foreach ($i in $Issues) { $report += "  • $i`n" }
    $report += "`n"
}
if ($Warnings.Count -gt 0) {
    $report += "=== 建议改进 ===`n"
    foreach ($w in $Warnings) { $report += "  • $w`n" }
}

$report | Out-File -FilePath $reportFile -Encoding UTF8
Write-Host "`n报告已保存: $reportFile" -ForegroundColor Cyan
Write-Host ""
