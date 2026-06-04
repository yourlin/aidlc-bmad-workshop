# Workshop 前置准备邮件模板

> 讲师在 Workshop 前 2-3 天发送给学员

---

**邮件标题：** 【行动项】AIDLC Workshop 前置准备（请于 XX 日前完成）

---

各位同学好，

我们的 AIDLC × BMAD Workshop 将于 **[日期] [时间]** 进行。为确保现场时间 100% 用于动手实操，请在 Workshop **前一天**完成以下环境准备。

---

## 必须完成的 3 步

### 第 1 步：确认工具版本（2 分钟）

打开终端运行以下命令，确认输出符合要求：

```bash
node --version          # 需要 >= v20（如: v20.11.0）
python3 --version       # 需要 >= 3.10（如: Python 3.11.5）
```

**未安装？**
- Node.js: https://nodejs.org/ 下载 LTS 版本
- Python: https://www.python.org/downloads/

### 第 2 步：配置 GitHub Personal Access Token（5 分钟）

> ⚠️ **重要**：BMAD 安装需要从 GitHub 下载资源。未配置 Token 会触发 API rate limit 导致安装失败。

**操作步骤：**

1. 打开 https://github.com/settings/tokens
2. 点击 **"Generate new token (classic)"**
3. 设置：
   - Note: `bmad-workshop`
   - Expiration: `7 days`（Workshop 后自动过期）
   - Scopes: 只勾选 **`public_repo`**（不需要其他权限）
4. 点击 **"Generate token"**，复制生成的 token（以 `ghp_` 开头）
5. 在终端配置：

**macOS / Linux：**
```bash
# 方式一：写入 shell 配置（推荐，永久生效）
echo 'export GITHUB_TOKEN=ghp_你的token' >> ~/.zshrc
source ~/.zshrc

# 方式二：仅当前会话生效
export GITHUB_TOKEN=ghp_你的token
```

**Windows PowerShell：**
```powershell
# 设置用户环境变量（永久）
[Environment]::SetEnvironmentVariable("GITHUB_TOKEN", "ghp_你的token", "User")

# 刷新当前会话
$env:GITHUB_TOKEN = "ghp_你的token"
```

**验证配置成功：**
```bash
echo $GITHUB_TOKEN   # 应输出你的 token（ghp_...）
```

### 第 3 步：运行安装脚本（10 分钟）

```bash
# 解压 Workshop 材料
unzip aidlc-bmad-workflow.zip
cd aidlc-bmad-workshop-main

# 运行初始化
chmod +x setup-workshop.sh
./setup-workshop.sh

# 安装 BMAD
npx bmad-method install
# 按提示选择: Modules → BMM, AI IDE → 你使用的工具, 语言 → Chinese
```

**安装成功标志：**
```bash
npx bmad-method status   # 应显示已安装的模块列表
```

---

## 自检清单

完成上述步骤后，确认以下全部 ✅：

- [ ] `node --version` 输出 >= v20
- [ ] `python3 --version` 输出 >= 3.10
- [ ] `echo $GITHUB_TOKEN` 输出 token 值
- [ ] `npx bmad-method status` 显示已安装模块
- [ ] AI IDE（Kiro / Claude Code / Cursor / CodeX）已安装且可正常使用

---

## 遇到问题？

| 问题 | 解决方案 |
|------|---------|
| `npm ERR! 403` 或 `rate limit` | 确认 GITHUB_TOKEN 已配置且有效 |
| `npx bmad-method` 命令找不到 | 确认 Node.js >= v20，运行 `npm cache clean --force` 后重试 |
| Python 版本过低 | macOS 用 `brew install python@3.11`，其他系统从官网下载 |
| 安装超时 | 检查网络连接，尝试切换网络后重试 |

如果以上方案无法解决，请将错误截图发到 [Workshop 沟通群/邮件]，技术助教会在 Workshop 前为你解决。

---

## Workshop 当天

- 请提前 **10 分钟**到场
- 携带已完成环境准备的笔记本电脑
- 如果是 Brownfield 项目：请确保你的项目代码已 clone 到本地

期待与大家一起探索 AI 驱动开发的全新工作方式！

[讲师签名]
