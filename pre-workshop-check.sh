#!/usr/bin/env bash
# ============================================================================
# Workshop 项目体检脚本 (Pre-Workshop Health Check)
# 用法: chmod +x pre-workshop-check.sh && ./pre-workshop-check.sh
# 建议: Workshop 前 2-3 天运行，确保环境就绪
# ============================================================================

set -euo pipefail

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

SCORE=0
MAX_SCORE=100
ISSUES=()
WARNINGS=()

# --- Helper Functions ---
pass() { echo -e "  ${GREEN}✓${NC} $1"; }
warn() { echo -e "  ${YELLOW}⚠${NC} $1"; WARNINGS+=("$1"); }
fail() { echo -e "  ${RED}✗${NC} $1"; ISSUES+=("$1"); }
header() { echo -e "\n${BOLD}${BLUE}[$1]${NC}"; }

add_score() { SCORE=$((SCORE + $1)); }

# --- Banner ---
echo -e "${BOLD}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║     AIDLC × BMAD Workshop — 环境体检 Health Check       ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo "运行时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# =============================================================================
# 1. Node.js (20 points)
# =============================================================================
header "Node.js (权重: 20分)"

if command -v node &>/dev/null; then
    NODE_VERSION=$(node --version | sed 's/v//')
    NODE_MAJOR=$(echo "$NODE_VERSION" | cut -d. -f1)
    if [ "$NODE_MAJOR" -ge 20 ]; then
        pass "Node.js v${NODE_VERSION} (>= 20 ✓)"
        add_score 20
    else
        fail "Node.js v${NODE_VERSION} — 需要 v20+，请升级"
    fi
else
    fail "Node.js 未安装 — 请安装 v20+ (https://nodejs.org)"
fi

# =============================================================================
# 2. Python (10 points)
# =============================================================================
header "Python (权重: 10分)"

PYTHON_CMD=""
if command -v python3 &>/dev/null; then
    PYTHON_CMD="python3"
elif command -v python &>/dev/null; then
    PYTHON_CMD="python"
fi

if [ -n "$PYTHON_CMD" ]; then
    PY_VERSION=$($PYTHON_CMD --version 2>&1 | awk '{print $2}')
    PY_MAJOR=$(echo "$PY_VERSION" | cut -d. -f1)
    PY_MINOR=$(echo "$PY_VERSION" | cut -d. -f2)
    if [ "$PY_MAJOR" -ge 3 ] && [ "$PY_MINOR" -ge 10 ]; then
        pass "Python ${PY_VERSION} (>= 3.10 ✓)"
        add_score 10
    else
        fail "Python ${PY_VERSION} — 需要 3.10+，请升级"
    fi
else
    fail "Python 未安装 — 请安装 3.10+ (https://python.org)"
fi

# =============================================================================
# 3. uv (5 points)
# =============================================================================
header "uv 包管理器 (权重: 5分)"

if command -v uv &>/dev/null; then
    UV_VER=$(uv --version 2>&1 | head -1)
    pass "uv 已安装 ($UV_VER)"
    add_score 5
else
    warn "uv 未安装 — 建议安装: curl -LsSf https://astral.sh/uv/install.sh | sh"
    add_score 2
fi

# =============================================================================
# 4. Git (10 points)
# =============================================================================
header "Git (权重: 10分)"

if command -v git &>/dev/null; then
    GIT_VER=$(git --version | awk '{print $3}')
    pass "Git ${GIT_VER}"
    add_score 10
else
    fail "Git 未安装 — 请安装 git"
fi

# =============================================================================
# 5. GitHub Token (15 points)
# =============================================================================
header "GitHub Token (权重: 15分)"

TOKEN="${GITHUB_TOKEN:-${GH_TOKEN:-}}"
if [ -n "$TOKEN" ]; then
    if [[ "$TOKEN" == ghp_* ]] || [[ "$TOKEN" == github_pat_* ]]; then
        pass "GitHub Token 已配置 (${TOKEN:0:7}...)"
        add_score 15
    else
        warn "Token 格式异常 — 应以 ghp_ 或 github_pat_ 开头"
        add_score 5
    fi
else
    fail "GitHub Token 未配置 — 安装 BMAD 时会触发 API rate limit"
    echo -e "    ${YELLOW}修复: export GITHUB_TOKEN=ghp_你的token${NC}"
    echo -e "    ${YELLOW}获取: https://github.com/settings/tokens${NC}"
fi

# =============================================================================
# 6. AI IDE (15 points)
# =============================================================================
header "AI IDE (权重: 15分)"

IDE_FOUND=false
if command -v kiro &>/dev/null; then
    pass "Kiro 已安装"; IDE_FOUND=true
fi
if command -v claude &>/dev/null; then
    pass "Claude Code 已安装"; IDE_FOUND=true
fi
if command -v cursor &>/dev/null; then
    pass "Cursor 已安装"; IDE_FOUND=true
fi
if command -v codex &>/dev/null; then
    pass "CodeX 已安装"; IDE_FOUND=true
fi
# Check for app bundles on macOS
if [ "$(uname)" = "Darwin" ]; then
    if [ -d "/Applications/Kiro.app" ]; then
        pass "Kiro.app 已安装"; IDE_FOUND=true
    fi
    if [ -d "/Applications/Cursor.app" ]; then
        pass "Cursor.app 已安装"; IDE_FOUND=true
    fi
fi

if $IDE_FOUND; then
    add_score 15
else
    fail "未检测到支持的 AI IDE (Kiro/Claude Code/Cursor/CodeX)"
    echo -e "    ${YELLOW}至少安装一个 AI IDE 才能参加 Workshop${NC}"
fi

# =============================================================================
# 7. Network Connectivity (10 points)
# =============================================================================
header "网络连通性 (权重: 10分)"

NET_SCORE=0
if curl -s --max-time 5 https://registry.npmjs.org/ &>/dev/null; then
    pass "npm registry 可达"
    NET_SCORE=$((NET_SCORE + 5))
else
    fail "npm registry 不可达 — 检查网络或代理设置"
fi

if curl -s --max-time 5 https://api.github.com/ &>/dev/null; then
    pass "GitHub API 可达"
    NET_SCORE=$((NET_SCORE + 5))
else
    fail "GitHub API 不可达 — 检查网络或代理设置"
fi
add_score $NET_SCORE

# =============================================================================
# 8. Disk Space (5 points)
# =============================================================================
header "磁盘空间 (权重: 5分)"

if [ "$(uname)" = "Darwin" ]; then
    FREE_KB=$(df -k . | tail -1 | awk '{print $4}')
else
    FREE_KB=$(df -k . | tail -1 | awk '{print $4}')
fi
FREE_GB=$((FREE_KB / 1024 / 1024))

if [ "$FREE_GB" -ge 5 ]; then
    pass "可用空间: ${FREE_GB}GB (>= 5GB ✓)"
    add_score 5
elif [ "$FREE_GB" -ge 1 ]; then
    warn "可用空间: ${FREE_GB}GB — 建议至少 5GB"
    add_score 3
else
    fail "可用空间不足: ${FREE_GB}GB — 需要至少 1GB"
fi

# =============================================================================
# 9. npx / BMAD (10 points)
# =============================================================================
header "npx & BMAD (权重: 10分)"

if command -v npx &>/dev/null; then
    pass "npx 可用"
    add_score 5
    if npx bmad-method --version &>/dev/null 2>&1; then
        BMAD_VER=$(npx bmad-method --version 2>&1 | head -1)
        pass "bmad-method 已缓存 ($BMAD_VER)"
        add_score 5
    else
        warn "bmad-method 未缓存 — Workshop 时会自动下载"
        add_score 3
    fi
else
    fail "npx 不可用 — 请确认 Node.js 安装完整"
fi

# =============================================================================
# REPORT
# =============================================================================
echo ""
echo -e "${BOLD}══════════════════════════════════════════════════════════════${NC}"

# Score color
if [ "$SCORE" -ge 90 ]; then
    SCORE_COLOR=$GREEN
    STATUS="🎉 完美就绪"
elif [ "$SCORE" -ge 70 ]; then
    SCORE_COLOR=$YELLOW
    STATUS="⚡ 基本就绪，有小问题"
elif [ "$SCORE" -ge 50 ]; then
    SCORE_COLOR=$YELLOW
    STATUS="⚠️  需要修复才能参加"
else
    SCORE_COLOR=$RED
    STATUS="🚨 环境未就绪"
fi

echo -e "  ${BOLD}Workshop 就绪度: ${SCORE_COLOR}${SCORE}/${MAX_SCORE}${NC}  — ${STATUS}"
echo -e "${BOLD}══════════════════════════════════════════════════════════════${NC}"

# Action items
if [ ${#ISSUES[@]} -gt 0 ]; then
    echo -e "\n${RED}${BOLD}必须修复 (${#ISSUES[@]} 项):${NC}"
    for i in "${ISSUES[@]}"; do
        echo -e "  ${RED}•${NC} $i"
    done
fi

if [ ${#WARNINGS[@]} -gt 0 ]; then
    echo -e "\n${YELLOW}${BOLD}建议改进 (${#WARNINGS[@]} 项):${NC}"
    for w in "${WARNINGS[@]}"; do
        echo -e "  ${YELLOW}•${NC} $w"
    done
fi

if [ ${#ISSUES[@]} -eq 0 ] && [ ${#WARNINGS[@]} -eq 0 ]; then
    echo -e "\n  ${GREEN}所有检查通过，Workshop 环境完美就绪！${NC}"
fi

# Write report file
REPORT_FILE="workshop-readiness-report.txt"
{
    echo "AIDLC × BMAD Workshop 就绪度报告"
    echo "生成时间: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "得分: ${SCORE}/${MAX_SCORE}"
    echo ""
    if [ ${#ISSUES[@]} -gt 0 ]; then
        echo "=== 必须修复 ==="
        for i in "${ISSUES[@]}"; do echo "  • $i"; done
        echo ""
    fi
    if [ ${#WARNINGS[@]} -gt 0 ]; then
        echo "=== 建议改进 ==="
        for w in "${WARNINGS[@]}"; do echo "  • $w"; done
    fi
} > "$REPORT_FILE"

echo -e "\n📄 报告已保存: ${BLUE}${REPORT_FILE}${NC}"
echo ""
