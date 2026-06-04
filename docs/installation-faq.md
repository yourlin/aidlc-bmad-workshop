# 安装常见问题 FAQ

> Workshop 前置准备和现场环境问题的快速解决方案

---

## 问题 1: GitHub API Rate Limit（最常见）

**症状：**
```
npm ERR! 403 Forbidden
npm ERR! rate limit exceeded
```
或
```
Error: API rate limit exceeded for xxx.xxx.xxx.xxx
```

**原因：** 未配置 GitHub Token，匿名请求限制为 60 次/小时，BMAD 安装过程中会超限。

**解决方案：**

```bash
# 1. 生成 Token: https://github.com/settings/tokens
#    → Generate new token (classic)
#    → Scopes: 勾选 public_repo
#    → Generate token

# 2. 配置环境变量
export GITHUB_TOKEN=ghp_你的token

# 3. 写入 shell 配置（推荐）
echo 'export GITHUB_TOKEN=ghp_你的token' >> ~/.zshrc  # macOS
echo 'export GITHUB_TOKEN=ghp_你的token' >> ~/.bashrc # Linux
source ~/.zshrc  # 或 source ~/.bashrc

# 4. 验证
echo $GITHUB_TOKEN  # 应输出 ghp_...

# 5. 重新运行安装
npx bmad-method install
```

**Windows PowerShell:**
```powershell
[Environment]::SetEnvironmentVariable("GITHUB_TOKEN", "ghp_你的token", "User")
$env:GITHUB_TOKEN = "ghp_你的token"
npx bmad-method install
```

---

## 问题 2: npx bmad-method 命令找不到

**症状：**
```
npx: command not found
# 或
npm ERR! could not determine executable to run
```

**解决方案：**

```bash
# 确认 Node.js 版本
node --version  # 必须 >= v20

# 如果版本过低，升级 Node.js
# macOS:
brew install node@20
# 或使用 nvm:
nvm install 20
nvm use 20

# 清除 npm 缓存后重试
npm cache clean --force
npx bmad-method install
```

---

## 问题 3: Python 版本过低

**症状：**
```
Python 3.8.x（需要 >= 3.10）
```

**解决方案：**

```bash
# macOS
brew install python@3.11

# Ubuntu/Debian
sudo apt update && sudo apt install python3.11

# 验证
python3 --version
```

---

## 问题 4: BMAD 安装后模块不完整

**症状：**
- `npx bmad-method status` 不显示预期模块
- `_bmad/bmm/` 目录为空或不存在

**解决方案：**

```bash
# 清除已有安装，保留 custom 配置
rm -rf _bmad/core _bmad/bmm _bmad/_config

# 重新安装
npx bmad-method install
# 选择: Modules → BMM, AI IDE → 你的工具
```

---

## 问题 5: setup-workshop.sh 权限问题

**症状：**
```
Permission denied
```

**解决方案：**

```bash
chmod +x setup-workshop.sh
./setup-workshop.sh
```

---

## 问题 6: Windows 脚本执行策略

**症状：**
```
无法加载文件 setup-workshop.ps1，因为在此系统上禁止运行脚本
```

**解决方案：**

```powershell
# 以管理员身份运行 PowerShell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# 然后运行脚本
powershell -ExecutionPolicy Bypass -File setup-workshop.ps1
```

---

## 问题 7: 网络超时

**症状：**
```
npm ERR! network timeout
npm ERR! ETIMEDOUT
```

**解决方案：**

```bash
# 设置 npm 超时时间
npm config set fetch-timeout 120000

# 如果使用代理
npm config set proxy http://your-proxy:port
npm config set https-proxy http://your-proxy:port

# 重试
npx bmad-method install
```

---

## 问题 8: AI IDE 中 /bmad-help 无响应

**症状：** 输入 `/bmad-help` 后 AI IDE 无反应或报错

**解决方案：**

1. 确认 `_bmad/` 目录存在且包含 `core/` 和 `bmm/` 子目录
2. 确认 AI IDE 的工作目录是项目根目录（包含 `_bmad/`）
3. 重启 AI IDE
4. 如果使用 Claude Code：确认 `.claude/` 目录下有 skills 文件

```bash
# 验证目录结构
ls _bmad/core/ _bmad/bmm/
npx bmad-method status
```

---

## 紧急降级方案

如果安装始终无法完成，Workshop 仍可进行：

1. **使用 Seed Prompt 手动模式**：复制 `docs/seed-prompts/` 中对应角色的 Prompt，粘贴到 AI IDE
2. **功能完全相同**：Seed Prompt 是 Agent 定制的降级方案，只是少了自动加载上下文的便利性
3. **如何使用**：
   ```
   # 打开对应角色文件
   cat docs/seed-prompts/dev-seed.md
   # 复制内容粘贴到 AI IDE 对话框
   ```
