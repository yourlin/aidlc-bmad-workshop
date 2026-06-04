#!/bin/bash
# ============================================================
# AIDLC Workshop Brownfield 项目自动初始化
# 用法: 在学员的真实项目根目录运行
#   curl -sL <workshop-url>/workshop-init.sh | bash
#   或: chmod +x workshop-init.sh && ./workshop-init.sh
#
# 功能:
#   1. 自动扫描项目技术栈（语言/框架/依赖）
#   2. 推断架构模式（分层/微服务/Serverless）
#   3. 提取项目组织结构和业务信息
#   4. 生成 BMAD Agent TOML 配置（persistent_facts 预填）
#   5. 生成 project-context.md（四层理解）
#   6. 输出确认卡供学员审核
# ============================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   AIDLC Workshop Brownfield 自动初始化           ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"
echo ""

# ============================================================
# 配置
# ============================================================
OUTPUT_DIR="_bmad-output/planning-artifacts"
CUSTOM_DIR="_bmad/custom"
PROJECT_ROOT="$(pwd)"
PROJECT_NAME="$(basename "$PROJECT_ROOT")"

mkdir -p "$OUTPUT_DIR"
mkdir -p "$CUSTOM_DIR"

# ============================================================
# Step 1: 技术栈扫描
# ============================================================
echo -e "${YELLOW}[1/5] 扫描技术栈...${NC}"

LANGUAGES=""
FRAMEWORKS=""
BUILD_TOOLS=""
DATABASES=""
CLOUD_SERVICES=""
TESTING=""
DEPENDENCIES=""

# --- 语言检测 ---
if [ -f "package.json" ] || [ -f "tsconfig.json" ]; then
    if [ -f "tsconfig.json" ]; then
        LANGUAGES="${LANGUAGES}TypeScript, "
    else
        LANGUAGES="${LANGUAGES}JavaScript, "
    fi
fi
if [ -f "pom.xml" ] || [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
    if find . -maxdepth 3 -name "*.kt" -print -quit 2>/dev/null | grep -q .; then
        LANGUAGES="${LANGUAGES}Kotlin, "
    else
        LANGUAGES="${LANGUAGES}Java, "
    fi
fi
if [ -f "requirements.txt" ] || [ -f "pyproject.toml" ] || [ -f "setup.py" ] || [ -f "Pipfile" ]; then
    LANGUAGES="${LANGUAGES}Python, "
fi
if [ -f "go.mod" ]; then
    LANGUAGES="${LANGUAGES}Go, "
fi
if [ -f "Cargo.toml" ]; then
    LANGUAGES="${LANGUAGES}Rust, "
fi
if [ -f "Gemfile" ]; then
    LANGUAGES="${LANGUAGES}Ruby, "
fi
if find . -maxdepth 2 -name "*.cs" -print -quit 2>/dev/null | grep -q . || [ -f "*.csproj" ]; then
    LANGUAGES="${LANGUAGES}C#, "
fi

LANGUAGES="${LANGUAGES%, }"
[ -z "$LANGUAGES" ] && LANGUAGES="Unknown"
echo -e "  ${GREEN}✓${NC} 语言: ${LANGUAGES}"

# --- 框架检测 ---
if [ -f "package.json" ]; then
    PKG_CONTENT=$(cat package.json 2>/dev/null || echo "{}")

    # Frontend frameworks
    echo "$PKG_CONTENT" | grep -q '"react"' && FRAMEWORKS="${FRAMEWORKS}React, "
    echo "$PKG_CONTENT" | grep -q '"vue"' && FRAMEWORKS="${FRAMEWORKS}Vue, "
    echo "$PKG_CONTENT" | grep -q '"angular"' && FRAMEWORKS="${FRAMEWORKS}Angular, "
    echo "$PKG_CONTENT" | grep -q '"next"' && FRAMEWORKS="${FRAMEWORKS}Next.js, "
    echo "$PKG_CONTENT" | grep -q '"nuxt"' && FRAMEWORKS="${FRAMEWORKS}Nuxt, "
    echo "$PKG_CONTENT" | grep -q '"svelte"' && FRAMEWORKS="${FRAMEWORKS}Svelte, "

    # Backend frameworks
    echo "$PKG_CONTENT" | grep -q '"express"' && FRAMEWORKS="${FRAMEWORKS}Express, "
    echo "$PKG_CONTENT" | grep -q '"fastify"' && FRAMEWORKS="${FRAMEWORKS}Fastify, "
    echo "$PKG_CONTENT" | grep -q '"nestjs"' && FRAMEWORKS="${FRAMEWORKS}NestJS, "
    echo "$PKG_CONTENT" | grep -q '"@nestjs/core"' && FRAMEWORKS="${FRAMEWORKS}NestJS, "
    echo "$PKG_CONTENT" | grep -q '"koa"' && FRAMEWORKS="${FRAMEWORKS}Koa, "

    # Testing
    echo "$PKG_CONTENT" | grep -q '"jest"' && TESTING="${TESTING}Jest, "
    echo "$PKG_CONTENT" | grep -q '"vitest"' && TESTING="${TESTING}Vitest, "
    echo "$PKG_CONTENT" | grep -q '"mocha"' && TESTING="${TESTING}Mocha, "
    echo "$PKG_CONTENT" | grep -q '"cypress"' && TESTING="${TESTING}Cypress, "
    echo "$PKG_CONTENT" | grep -q '"playwright"' && TESTING="${TESTING}Playwright, "

    # Build tools
    echo "$PKG_CONTENT" | grep -q '"webpack"' && BUILD_TOOLS="${BUILD_TOOLS}Webpack, "
    echo "$PKG_CONTENT" | grep -q '"vite"' && BUILD_TOOLS="${BUILD_TOOLS}Vite, "
    echo "$PKG_CONTENT" | grep -q '"esbuild"' && BUILD_TOOLS="${BUILD_TOOLS}esbuild, "
    echo "$PKG_CONTENT" | grep -q '"turbo"' && BUILD_TOOLS="${BUILD_TOOLS}Turborepo, "

    # AWS
    echo "$PKG_CONTENT" | grep -q '"aws-cdk"' && CLOUD_SERVICES="${CLOUD_SERVICES}AWS CDK, "
    echo "$PKG_CONTENT" | grep -q '"@aws-sdk"' && CLOUD_SERVICES="${CLOUD_SERVICES}AWS SDK, "
    echo "$PKG_CONTENT" | grep -q '"serverless"' && CLOUD_SERVICES="${CLOUD_SERVICES}Serverless Framework, "
fi

if [ -f "pom.xml" ]; then
    POM_CONTENT=$(cat pom.xml 2>/dev/null || echo "")
    echo "$POM_CONTENT" | grep -q "spring-boot" && FRAMEWORKS="${FRAMEWORKS}Spring Boot, "
    echo "$POM_CONTENT" | grep -q "quarkus" && FRAMEWORKS="${FRAMEWORKS}Quarkus, "
    echo "$POM_CONTENT" | grep -q "micronaut" && FRAMEWORKS="${FRAMEWORKS}Micronaut, "
    echo "$POM_CONTENT" | grep -q "mybatis" && FRAMEWORKS="${FRAMEWORKS}MyBatis, "
    echo "$POM_CONTENT" | grep -q "hibernate" && FRAMEWORKS="${FRAMEWORKS}Hibernate, "
fi

if [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
    GRADLE_CONTENT=$(cat build.gradle build.gradle.kts 2>/dev/null || echo "")
    echo "$GRADLE_CONTENT" | grep -q "spring-boot" && FRAMEWORKS="${FRAMEWORKS}Spring Boot, "
    echo "$GRADLE_CONTENT" | grep -q "ktor" && FRAMEWORKS="${FRAMEWORKS}Ktor, "
fi

if [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
    PY_DEPS=$(cat requirements.txt pyproject.toml 2>/dev/null || echo "")
    echo "$PY_DEPS" | grep -qi "django" && FRAMEWORKS="${FRAMEWORKS}Django, "
    echo "$PY_DEPS" | grep -qi "flask" && FRAMEWORKS="${FRAMEWORKS}Flask, "
    echo "$PY_DEPS" | grep -qi "fastapi" && FRAMEWORKS="${FRAMEWORKS}FastAPI, "
    echo "$PY_DEPS" | grep -qi "pytest" && TESTING="${TESTING}pytest, "
fi

FRAMEWORKS="${FRAMEWORKS%, }"
BUILD_TOOLS="${BUILD_TOOLS%, }"
TESTING="${TESTING%, }"
CLOUD_SERVICES="${CLOUD_SERVICES%, }"

[ -n "$FRAMEWORKS" ] && echo -e "  ${GREEN}✓${NC} 框架: ${FRAMEWORKS}"
[ -n "$BUILD_TOOLS" ] && echo -e "  ${GREEN}✓${NC} 构建工具: ${BUILD_TOOLS}"
[ -n "$TESTING" ] && echo -e "  ${GREEN}✓${NC} 测试: ${TESTING}"
[ -n "$CLOUD_SERVICES" ] && echo -e "  ${GREEN}✓${NC} 云服务: ${CLOUD_SERVICES}"

# --- 数据库检测 ---
ALL_FILES=$(find . -maxdepth 3 -type f \( -name "*.yml" -o -name "*.yaml" -o -name "*.properties" -o -name "*.json" -o -name "*.toml" -o -name "*.env*" -o -name "docker-compose*" \) 2>/dev/null | head -20)
if [ -n "$ALL_FILES" ]; then
    CONFIG_CONTENT=$(cat $ALL_FILES 2>/dev/null || echo "")
    echo "$CONFIG_CONTENT" | grep -qi "mysql" && DATABASES="${DATABASES}MySQL, "
    echo "$CONFIG_CONTENT" | grep -qi "postgres" && DATABASES="${DATABASES}PostgreSQL, "
    echo "$CONFIG_CONTENT" | grep -qi "mongodb" && DATABASES="${DATABASES}MongoDB, "
    echo "$CONFIG_CONTENT" | grep -qi "redis" && DATABASES="${DATABASES}Redis, "
    echo "$CONFIG_CONTENT" | grep -qi "dynamodb" && DATABASES="${DATABASES}DynamoDB, "
    echo "$CONFIG_CONTENT" | grep -qi "elasticsearch" && DATABASES="${DATABASES}Elasticsearch, "
    echo "$CONFIG_CONTENT" | grep -qi "sqlite" && DATABASES="${DATABASES}SQLite, "
fi
DATABASES="${DATABASES%, }"
[ -n "$DATABASES" ] && echo -e "  ${GREEN}✓${NC} 数据库: ${DATABASES}"

echo ""

# ============================================================
# Step 2: 架构模式推断
# ============================================================
echo -e "${YELLOW}[2/5] 推断架构模式...${NC}"

ARCH_PATTERN=""
ARCH_LAYERS=""

# 检测分层模式
if find . -maxdepth 2 -type d -name "controller*" -print -quit 2>/dev/null | grep -q . || \
   find . -maxdepth 2 -type d -name "controllers" -print -quit 2>/dev/null | grep -q .; then
    ARCH_PATTERN="MVC / 分层架构"
    ARCH_LAYERS="Controller → Service → Repository"
elif find . -maxdepth 2 -type d -name "handlers" -print -quit 2>/dev/null | grep -q . || \
     find . -maxdepth 2 -type d -name "lambda" -print -quit 2>/dev/null | grep -q .; then
    ARCH_PATTERN="Serverless / 函数式"
    ARCH_LAYERS="Handler → Service → Data"
elif find . -maxdepth 2 -type d -name "routes" -print -quit 2>/dev/null | grep -q . && \
     find . -maxdepth 2 -type d -name "services" -print -quit 2>/dev/null | grep -q .; then
    ARCH_PATTERN="Service-oriented"
    ARCH_LAYERS="Route → Service → Model"
elif find . -maxdepth 1 -type d -name "packages" -print -quit 2>/dev/null | grep -q . || \
     find . -maxdepth 1 -type d -name "apps" -print -quit 2>/dev/null | grep -q .; then
    ARCH_PATTERN="Monorepo / 多包"
    ARCH_LAYERS="Apps/Packages → Shared Libraries"
fi

# 检测微服务
if find . -maxdepth 2 -name "docker-compose*" -print -quit 2>/dev/null | grep -q . && \
   [ $(find . -maxdepth 2 -name "Dockerfile" 2>/dev/null | wc -l) -gt 1 ]; then
    ARCH_PATTERN="微服务"
fi

[ -z "$ARCH_PATTERN" ] && ARCH_PATTERN="待确认（建议在 Agent 对话中进一步明确）"

echo -e "  ${GREEN}✓${NC} 架构模式: ${ARCH_PATTERN}"
[ -n "$ARCH_LAYERS" ] && echo -e "  ${GREEN}✓${NC} 分层: ${ARCH_LAYERS}"
echo ""

# ============================================================
# Step 3: 项目组织结构扫描
# ============================================================
echo -e "${YELLOW}[3/5] 扫描项目组织结构...${NC}"

# 获取顶层目录结构
TOP_DIRS=$(find . -maxdepth 1 -type d ! -name "." ! -name "node_modules" ! -name ".git" ! -name "__pycache__" ! -name ".idea" ! -name ".vscode" ! -name "target" ! -name "build" ! -name "dist" ! -name "_bmad" ! -name "_bmad-output" | sed 's|./||' | sort | head -15)

# 统计代码规模
TOTAL_FILES=$(find . -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" -o -name "*.java" -o -name "*.py" -o -name "*.go" -o -name "*.rs" -o -name "*.kt" -o -name "*.cs" -o -name "*.rb" \) ! -path "*/node_modules/*" ! -path "*/.git/*" ! -path "*/target/*" ! -path "*/build/*" ! -path "*/dist/*" 2>/dev/null | wc -l | tr -d ' ')
TOTAL_LINES=$(find . -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" -o -name "*.java" -o -name "*.py" -o -name "*.go" -o -name "*.rs" -o -name "*.kt" -o -name "*.cs" -o -name "*.rb" \) ! -path "*/node_modules/*" ! -path "*/.git/*" ! -path "*/target/*" ! -path "*/build/*" ! -path "*/dist/*" -exec cat {} \; 2>/dev/null | wc -l | tr -d ' ')

echo -e "  ${GREEN}✓${NC} 源文件数: ${TOTAL_FILES}"
echo -e "  ${GREEN}✓${NC} 代码行数: ~${TOTAL_LINES}"
echo -e "  ${GREEN}✓${NC} 顶层目录:"
echo "$TOP_DIRS" | while read dir; do
    echo -e "      ${CYAN}${dir}/${NC}"
done

# 检测测试目录
TEST_DIRS=$(find . -maxdepth 3 -type d \( -name "test" -o -name "tests" -o -name "__tests__" -o -name "spec" \) ! -path "*/node_modules/*" 2>/dev/null | head -5)
if [ -n "$TEST_DIRS" ]; then
    echo -e "  ${GREEN}✓${NC} 测试目录: 已发现"
else
    echo -e "  ${YELLOW}⚠${NC} 未发现测试目录"
fi

echo ""

# ============================================================
# Step 4: 业务信息提取
# ============================================================
echo -e "${YELLOW}[4/5] 提取业务信息...${NC}"

BUSINESS_CONTEXT=""

# 从 README 提取
if [ -f "README.md" ]; then
    README_FIRST=$(head -20 README.md | grep -v "^#" | grep -v "^$" | head -5)
    if [ -n "$README_FIRST" ]; then
        BUSINESS_CONTEXT="$README_FIRST"
        echo -e "  ${GREEN}✓${NC} 从 README.md 提取业务描述"
    fi
elif [ -f "README.rst" ] || [ -f "readme.md" ]; then
    echo -e "  ${GREEN}✓${NC} 发现 README 文件"
fi

# 检测 API 路由
API_ROUTES=""
if find . -maxdepth 3 -name "*.ts" -o -name "*.js" 2>/dev/null | head -5 | xargs grep -l "router\.\|app\.\(get\|post\|put\|delete\)" 2>/dev/null | head -1 > /dev/null 2>&1; then
    API_COUNT=$(find . -maxdepth 4 -type f \( -name "*.ts" -o -name "*.js" \) ! -path "*/node_modules/*" -exec grep -l "router\.\|app\.\(get\|post\|put\|delete\)" {} \; 2>/dev/null | wc -l | tr -d ' ')
    echo -e "  ${GREEN}✓${NC} API 路由文件: ~${API_COUNT} 个"
fi

# 检测 Java Controller
if find . -maxdepth 4 -name "*Controller.java" 2>/dev/null | head -1 > /dev/null 2>&1; then
    CONTROLLER_COUNT=$(find . -maxdepth 4 -name "*Controller.java" ! -path "*/target/*" 2>/dev/null | wc -l | tr -d ' ')
    echo -e "  ${GREEN}✓${NC} Controller 类: ${CONTROLLER_COUNT} 个"
fi

# Git 活跃度
GIT_HOTSPOTS=""
GIT_RECENT_INTENT=""
GIT_COMMIT_COUNT=0
if [ -d ".git" ]; then
    RECENT_COMMITS=$(git log --oneline -10 2>/dev/null | wc -l | tr -d ' ')
    RECENT_AUTHORS=$(git log --format='%an' -20 2>/dev/null | sort -u | wc -l | tr -d ' ')
    ACTIVE_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
    GIT_COMMIT_COUNT=$(git rev-list --count HEAD 2>/dev/null || echo "0")
    echo -e "  ${GREEN}✓${NC} Git: 分支=${ACTIVE_BRANCH}, 最近活跃作者=${RECENT_AUTHORS}, 总提交=${GIT_COMMIT_COUNT}"

    # --- Git 历史深度探测 ---
    echo -e "\n${YELLOW}[4.5/5] Git 历史分析...${NC}"

    # 高频变更区域（最近 100 次提交中变更最多的文件/目录）
    GIT_HOTSPOTS=$(git log --pretty=format: --name-only -100 2>/dev/null | \
        grep -v "^$" | \
        sed 's|/[^/]*$||' | \
        sort | uniq -c | sort -rn | head -8 | \
        awk '{printf "  %s (%d次变更)\n", $2, $1}')

    if [ -n "$GIT_HOTSPOTS" ]; then
        echo -e "  ${GREEN}✓${NC} 高频变更区域（近 100 次提交）:"
        echo "$GIT_HOTSPOTS" | while read line; do
            echo -e "      ${CYAN}${line}${NC}"
        done
    fi

    # 最近 10 次提交的意图分析
    GIT_RECENT_INTENT=$(git log --oneline -10 2>/dev/null | \
        sed 's/^[a-f0-9]* //' | \
        awk '{print "  - "$0}')
    echo -e "  ${GREEN}✓${NC} 最近提交意图:"
    echo "$GIT_RECENT_INTENT" | head -5 | while read line; do
        echo -e "      ${CYAN}${line}${NC}"
    done

    # 按月活跃度
    MONTHLY_ACTIVITY=$(git log --format='%ai' -200 2>/dev/null | cut -d- -f1-2 | sort | uniq -c | tail -3 | awk '{printf "  %s: %d commits\n", $2, $1}')
    if [ -n "$MONTHLY_ACTIVITY" ]; then
        echo -e "  ${GREEN}✓${NC} 最近月度活跃:"
        echo "$MONTHLY_ACTIVITY" | while read line; do
            echo -e "      ${CYAN}${line}${NC}"
        done
    fi
fi

echo ""

# ============================================================
# Step 4.8: 项目就绪度分级
# ============================================================
echo -e "${YELLOW}[4.8/5] 评估项目就绪度...${NC}"

READINESS_SCORE=0
READINESS_DETAILS=""

# 文档完整性检查
HAS_README=false
HAS_API_DOCS=false
HAS_ARCH_DOCS=false
HAS_CHANGELOG=false

[ -f "README.md" ] || [ -f "readme.md" ] && HAS_README=true && READINESS_SCORE=$((READINESS_SCORE + 20))
(find . -maxdepth 2 -name "swagger*" -o -name "openapi*" -o -name "api-docs*" 2>/dev/null | head -1 | grep -q .) && HAS_API_DOCS=true && READINESS_SCORE=$((READINESS_SCORE + 15))
(find . -maxdepth 2 -name "architecture*" -o -name "ARCHITECTURE*" -o -name "design*" 2>/dev/null | head -1 | grep -q .) && HAS_ARCH_DOCS=true && READINESS_SCORE=$((READINESS_SCORE + 15))
[ -f "CHANGELOG.md" ] || [ -f "changelog.md" ] && HAS_CHANGELOG=true && READINESS_SCORE=$((READINESS_SCORE + 5))

# 测试覆盖检查
[ -n "$TEST_DIRS" ] && READINESS_SCORE=$((READINESS_SCORE + 15))
[ -n "$TESTING" ] && READINESS_SCORE=$((READINESS_SCORE + 10))

# Git 健康度
[ -d ".git" ] && READINESS_SCORE=$((READINESS_SCORE + 10))
[ "$GIT_COMMIT_COUNT" -gt 50 ] && READINESS_SCORE=$((READINESS_SCORE + 5))

# 依赖管理
([ -f "package-lock.json" ] || [ -f "yarn.lock" ] || [ -f "pnpm-lock.yaml" ] || [ -f "Pipfile.lock" ] || [ -f "go.sum" ]) && READINESS_SCORE=$((READINESS_SCORE + 5))

# 分级
if [ "$READINESS_SCORE" -ge 70 ]; then
    READINESS_GRADE="A"
    READINESS_LABEL="文档齐全 — 预计 3 分钟内完成上下文发现"
    READINESS_COLOR=$GREEN
elif [ "$READINESS_SCORE" -ge 40 ]; then
    READINESS_GRADE="B"
    READINESS_LABEL="文档部分缺失 — 预计 10 分钟完成上下文发现"
    READINESS_COLOR=$YELLOW
else
    READINESS_GRADE="C"
    READINESS_LABEL="文档严重缺失 — 需要 AI 深度探索，预计 15+ 分钟"
    READINESS_COLOR=$RED
fi

echo -e "  就绪度评级: ${READINESS_COLOR}${BOLD}${READINESS_GRADE}${NC} (${READINESS_SCORE}/100)"
echo -e "  ${READINESS_COLOR}${READINESS_LABEL}${NC}"
echo -e ""
echo -e "  评分明细:"
$HAS_README && echo -e "    ${GREEN}✓${NC} README.md (+20)" || echo -e "    ${RED}✗${NC} README.md 缺失"
$HAS_API_DOCS && echo -e "    ${GREEN}✓${NC} API 文档 (+15)" || echo -e "    ${YELLOW}○${NC} API 文档未发现"
$HAS_ARCH_DOCS && echo -e "    ${GREEN}✓${NC} 架构文档 (+15)" || echo -e "    ${YELLOW}○${NC} 架构文档未发现"
[ -n "$TEST_DIRS" ] && echo -e "    ${GREEN}✓${NC} 测试目录 (+15)" || echo -e "    ${RED}✗${NC} 测试目录缺失"
[ -n "$TESTING" ] && echo -e "    ${GREEN}✓${NC} 测试框架配置 (+10)" || echo -e "    ${YELLOW}○${NC} 测试框架未配置"
[ -d ".git" ] && echo -e "    ${GREEN}✓${NC} Git 仓库 (+10)" || echo -e "    ${RED}✗${NC} 非 Git 仓库"

echo ""

# ============================================================
# Step 5: 生成配置和文档
# ============================================================
echo -e "${YELLOW}[5/5] 生成配置和文档...${NC}"

# --- 生成 project-context.md ---
cat > "$OUTPUT_DIR/project-context.md" << CTXEOF
# Project Context: ${PROJECT_NAME}

> 由 workshop-init.sh 自动生成于 $(date '+%Y-%m-%d %H:%M')
> ⚠️ 请审核以下内容，修正不准确的部分

---

## 第一层：技术栈

| 维度 | 检测结果 |
|------|---------|
| 语言 | ${LANGUAGES} |
| 框架 | ${FRAMEWORKS:-未检测到} |
| 构建工具 | ${BUILD_TOOLS:-未检测到} |
| 测试框架 | ${TESTING:-未检测到} |
| 数据库 | ${DATABASES:-未检测到} |
| 云服务 | ${CLOUD_SERVICES:-未检测到} |

## 第二层：架构

| 维度 | 检测结果 |
|------|---------|
| 架构模式 | ${ARCH_PATTERN} |
| 分层结构 | ${ARCH_LAYERS:-待确认} |
| 代码规模 | ${TOTAL_FILES} 文件, ~${TOTAL_LINES} 行 |

## 第三层：项目组织

**顶层目录结构：**
\`\`\`
${PROJECT_NAME}/
$(echo "$TOP_DIRS" | sed 's/^/├── /' | sed '$ s/├/└/')
\`\`\`

**测试：** ${TEST_DIRS:-未发现测试目录}

## 第四层：业务逻辑与目标

${BUSINESS_CONTEXT:-⚠️ 未能从 README 自动提取业务描述，请手动补充：}

**[需要你补充]：**
- 这个项目的核心业务是什么？
- 主要服务哪些用户/系统？
- 当前阶段的开发目标是什么？

## Git 历史洞察

**高频变更区域：**
\`\`\`
${GIT_HOTSPOTS:-无 Git 历史}
\`\`\`

**最近提交意图：**
${GIT_RECENT_INTENT:-无 Git 历史}

## 项目就绪度

| 评级 | 得分 | 建议 |
|------|------|------|
| **${READINESS_GRADE:-?}** | ${READINESS_SCORE:-0}/100 | ${READINESS_LABEL:-待评估} |

---

## 受保护路径（AI 不应修改的目录/文件）

> 请标注哪些目录是稳定的、不应被 AI 修改的

- [ ] \`src/core/\` — 核心基础设施（如适用）
- [ ] \`src/auth/\` — 认证模块（如适用）
- [ ] \`database/migrations/\` — 数据库迁移（如适用）
- [ ] 其他: ___

---

## 置信度说明

| 层级 | 置信度 | 说明 |
|------|--------|------|
| 技术栈 | 🟢 高 | 基于 package.json / pom.xml 等配置文件直接读取 |
| 架构 | 🟡 中 | 基于目录结构推断，可能不完全准确 |
| 项目组织 | 🟢 高 | 直接扫描文件系统 |
| 业务逻辑 | 🔴 低 | 仅从 README 提取，需要人工补充 |
CTXEOF

echo -e "  ${GREEN}✓${NC} 已生成 ${OUTPUT_DIR}/project-context.md"

# --- 生成 Brownfield Agent TOML ---
cat > "$CUSTOM_DIR/bmad-agent-pm.toml" << PMEOF
# PM Agent — Brownfield Workshop 定制
# 由 workshop-init.sh 自动生成

[agent]
persistent_facts = [
  "这是 Brownfield 项目，项目名: ${PROJECT_NAME}",
  "技术栈: ${LANGUAGES} + ${FRAMEWORKS}",
  "数据库: ${DATABASES:-待确认}",
  "架构模式: ${ARCH_PATTERN}",
  "Workshop 时间约束: 30 分钟内完成 PRD",
  "PRD 应聚焦增量变更，不要重新描述已有功能",
  "project-context.md 包含现有系统描述，请先阅读",
]

activation_steps_prepend = [
  "读取 {project-root}/_bmad-output/planning-artifacts/project-context.md 了解现有系统",
]

[[agent.menu]]
code = "CP"
label = "快速创建增量 PRD"
description = "基于 project-context 描述增量变更需求"

[[agent.menu]]
code = "BP"
label = "生成 Product Brief"
description = "从现有代码推断产品简介"
PMEOF

echo -e "  ${GREEN}✓${NC} 已生成 ${CUSTOM_DIR}/bmad-agent-pm.toml"

cat > "$CUSTOM_DIR/bmad-agent-architect.toml" << ARCHEOF
# Architect Agent — Brownfield Workshop 定制
# 由 workshop-init.sh 自动生成

[agent]
persistent_facts = [
  "这是 Brownfield 项目: ${PROJECT_NAME}",
  "现有技术栈: ${LANGUAGES} + ${FRAMEWORKS}",
  "架构模式: ${ARCH_PATTERN}",
  "数据库: ${DATABASES:-待确认}",
  "云服务: ${CLOUD_SERVICES:-待确认}",
  "新架构决策必须兼容已有技术栈",
  "不得引入与现有模式冲突的新技术",
  "Workshop 时间约束: 30 分钟内完成架构增量文档",
]

activation_steps_prepend = [
  "读取 {project-root}/_bmad-output/planning-artifacts/project-context.md 了解现有架构",
]

[[agent.menu]]
code = "CA"
label = "创建增量架构文档"
description = "仅描述新增/变更的架构决策，保持与现有系统一致"

[[agent.menu]]
code = "CI"
label = "生成 IaC 代码"
description = "基于现有模式生成基础设施代码"
ARCHEOF

echo -e "  ${GREEN}✓${NC} 已生成 ${CUSTOM_DIR}/bmad-agent-architect.toml"

cat > "$CUSTOM_DIR/bmad-agent-dev.toml" << DEVEOF
# Dev Agent — Brownfield Workshop 定制
# 由 workshop-init.sh 自动生成

[agent]
persistent_facts = [
  "这是 Brownfield 项目，已有代码库不可破坏",
  "技术栈: ${LANGUAGES} + ${FRAMEWORKS}",
  "测试框架: ${TESTING:-待确认}",
  "修改前必须先读取现有代码模式，保持风格一致",
  "所有变更必须通过已有测试",
  "遵循 TDD: 先写测试再实现",
  "Workshop 时间约束: 每个 Story 25 分钟内完成",
]

activation_steps_prepend = [
  "读取 {project-root}/_bmad-output/planning-artifacts/project-context.md 了解项目结构",
  "读取 {project-root}/_bmad-output/planning-artifacts/architecture.md 了解架构（如存在）",
]

[[agent.menu]]
code = "DS"
label = "实现 Story"
description = "TDD 模式实现当前 Story"

[[agent.menu]]
code = "D2"
label = "继续实现"
description = "继续上一个 Story 的实现"
DEVEOF

echo -e "  ${GREEN}✓${NC} 已生成 ${CUSTOM_DIR}/bmad-agent-dev.toml"

cat > "$CUSTOM_DIR/bmad-testarch-test-design.toml" << QAEOF
# QA 测试设计 Workflow — Brownfield Workshop 定制
# 由 workshop-init.sh 自动生成

[workflow]
persistent_facts = [
  "这是 Brownfield 项目: ${PROJECT_NAME}",
  "测试框架: ${TESTING:-待确认}",
  "测试策略必须考虑已有测试的兼容性",
  "新测试应遵循已有测试的组织模式和命名规范",
  "Workshop 时间约束: 30 分钟内完成测试策略",
]

activation_steps_prepend = [
  "读取 {project-root}/_bmad-output/planning-artifacts/project-context.md 了解项目",
  "读取 {project-root}/_bmad-output/planning-artifacts/architecture.md 了解架构和测试约束（如存在）",
]
QAEOF

echo -e "  ${GREEN}✓${NC} 已生成 ${CUSTOM_DIR}/bmad-testarch-test-design.toml"

echo ""

# ============================================================
# 输出确认卡
# ============================================================
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}           项目理解确认卡                            ${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  📁 项目: ${GREEN}${PROJECT_NAME}${NC}"
echo -e "  💻 语言: ${GREEN}${LANGUAGES}${NC}"
echo -e "  🏗️  框架: ${GREEN}${FRAMEWORKS:-未检测到}${NC}"
echo -e "  🗄️  数据库: ${GREEN}${DATABASES:-未检测到}${NC}"
echo -e "  ☁️  云服务: ${GREEN}${CLOUD_SERVICES:-未检测到}${NC}"
echo -e "  🧪 测试: ${GREEN}${TESTING:-未检测到}${NC}"
echo -e "  📐 架构: ${GREEN}${ARCH_PATTERN}${NC}"
echo -e "  📊 规模: ${GREEN}${TOTAL_FILES} 文件 / ~${TOTAL_LINES} 行${NC}"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   ✅ Brownfield 初始化完成！                      ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "已生成文件:"
echo -e "  ${BLUE}${OUTPUT_DIR}/project-context.md${NC} ← 请审核并补充业务描述"
echo -e "  ${BLUE}${CUSTOM_DIR}/bmad-agent-pm.toml${NC}"
echo -e "  ${BLUE}${CUSTOM_DIR}/bmad-agent-architect.toml${NC}"
echo -e "  ${BLUE}${CUSTOM_DIR}/bmad-agent-dev.toml${NC}"
echo -e "  ${BLUE}${CUSTOM_DIR}/bmad-testarch-test-design.toml${NC}"
echo ""
echo -e "${YELLOW}下一步:${NC}"
echo -e "  1. 审核 ${OUTPUT_DIR}/project-context.md（补充业务描述和受保护路径）"
echo -e "  2. 运行 npx bmad-method install（如未安装）"
echo -e "  3. 在 AI IDE 中输入 /bmad-help 开始 Workshop"
echo ""
