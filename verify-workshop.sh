#!/bin/bash
# ============================================================
# AIDLC Workshop 环境验证脚本（Workshop 当天使用）
# 用法: chmod +x verify-workshop.sh && ./verify-workshop.sh
#
# 目的: 30 秒快速验证环境是否就绪，不做任何安装或修改
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   AIDLC Workshop 环境验证（30 秒快速检查）       ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"
echo ""

PASS=0
FAIL=0
WARN=0

check_pass() {
    echo -e "  ${GREEN}✅${NC} $1"
    PASS=$((PASS + 1))
}

check_fail() {
    echo -e "  ${RED}❌${NC} $1"
    FAIL=$((FAIL + 1))
}

check_warn() {
    echo -e "  ${YELLOW}⚠️${NC} $1"
    WARN=$((WARN + 1))
}

# --- 1. 基础工具 ---
echo -e "${YELLOW}[1/4] 基础工具...${NC}"

if command -v node &> /dev/null; then
    NODE_MAJOR=$(node --version | sed 's/v//' | cut -d. -f1)
    if [ "$NODE_MAJOR" -ge 20 ]; then
        check_pass "Node.js $(node --version)"
    else
        check_fail "Node.js $(node --version) — 需要 >= v20"
    fi
else
    check_fail "Node.js 未安装"
fi

if command -v python3 &> /dev/null; then
    PY_MINOR=$(python3 --version | sed 's/Python 3\.//' | cut -d. -f1)
    if [ "$PY_MINOR" -ge 10 ]; then
        check_pass "Python $(python3 --version | sed 's/Python //')"
    else
        check_fail "Python $(python3 --version | sed 's/Python //') — 需要 >= 3.10"
    fi
else
    check_fail "Python3 未安装"
fi

# --- 2. GitHub Token ---
echo ""
echo -e "${YELLOW}[2/4] GitHub Token...${NC}"

if [ -n "$GITHUB_TOKEN" ]; then
    check_pass "GITHUB_TOKEN 已配置"
elif [ -n "$GH_TOKEN" ]; then
    check_pass "GH_TOKEN 已配置"
else
    check_fail "GitHub Token 未配置 — BMAD 安装会因 rate limit 失败"
    echo -e "        配置方法: export GITHUB_TOKEN=ghp_你的token"
fi

# --- 3. BMAD 安装状态 ---
echo ""
echo -e "${YELLOW}[3/4] BMAD 安装...${NC}"

if command -v npx &> /dev/null && npx bmad-method status &> /dev/null; then
    check_pass "BMAD 已安装"
else
    check_fail "BMAD 未安装或状态异常 — 运行: npx bmad-method install"
fi

if [ -d "_bmad/core" ] && [ -d "_bmad/bmm" ]; then
    check_pass "_bmad/core 和 _bmad/bmm 目录存在"
else
    if [ -d "_bmad/core" ] || [ -d "_bmad/bmm" ]; then
        check_warn "_bmad 目录不完整"
    else
        check_fail "_bmad 目录不存在 — 请先运行 setup-workshop.sh + npx bmad-method install"
    fi
fi

if [ -f "_bmad-output/planning-artifacts/product-brief.md" ]; then
    check_pass "Product Brief 预置文件存在"
else
    check_warn "Product Brief 不存在（Brownfield 项目可忽略）"
fi

# --- 4. AI IDE ---
echo ""
echo -e "${YELLOW}[4/4] AI IDE...${NC}"

IDE_FOUND=false
if command -v claude &> /dev/null; then
    check_pass "Claude Code 已安装"
    IDE_FOUND=true
fi
if command -v kiro &> /dev/null || [ -d "/Applications/Kiro.app" ]; then
    check_pass "Kiro 已安装"
    IDE_FOUND=true
fi
if command -v cursor &> /dev/null; then
    check_pass "Cursor 已安装"
    IDE_FOUND=true
fi
if command -v codex &> /dev/null; then
    check_pass "CodeX 已安装"
    IDE_FOUND=true
fi

if [ "$IDE_FOUND" = false ]; then
    check_warn "未检测到 AI IDE — 请确认已安装 Kiro/Claude Code/Cursor/CodeX"
fi

# --- 结果汇总 ---
echo ""
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ "$FAIL" -eq 0 ]; then
    echo -e "${GREEN}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║   🟢 环境就绪！可以开始 Workshop                 ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════╝${NC}"
    echo -e "  通过: ${PASS} | 警告: ${WARN} | 失败: ${FAIL}"
else
    echo -e "${RED}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║   🔴 环境未就绪！请先解决以上 ❌ 标记的问题       ║${NC}"
    echo -e "${RED}╚══════════════════════════════════════════════════╝${NC}"
    echo -e "  通过: ${PASS} | 警告: ${WARN} | ${RED}失败: ${FAIL}${NC}"
    echo ""
    echo -e "  请举手或翻红灯牌，技术助教将协助您解决问题。"
fi
echo ""
