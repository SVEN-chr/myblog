---
title: "🐧 Fedora 中安装 Visual Studio Code 完整指南"
date: 2025-10-13 16:00:00
tags: [Fedora, VS Code, Linux, 开发环境, 教程]
categories:
  - 技术
  - Linux
  - 开发工具
toc: true
pin: false
---

> 详细介绍如何在 Fedora Linux 系统中安装和配置 Visual Studio Code，包括官方仓库配置、命令行安装以及常用扩展推荐。

---

## 📋 前言

Visual Studio Code 是微软推出的免费开源代码编辑器，具有强大的代码补全、调试、Git 集成等功能。在 Fedora Linux 中安装 VS Code 有多种方式，本文介绍官方推荐的方法，确保获得最新版本和自动更新支持。

---

## 🔧 系统要求

- **操作系统**：Fedora 38+ / RHEL 9+ / CentOS 9+
- **权限**：管理员权限（sudo）
- **网络**：互联网连接（下载安装包）

---

## 🚀 方法一：官方仓库安装（推荐）

这是官方推荐的安装方式，可以自动获得更新。

### 步骤 1：导入 Microsoft GPG 密钥

首先导入 Microsoft 的 GPG 密钥，用于验证软件包的真实性：

```bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
```

### 步骤 2：添加 VS Code YUM 仓库

创建并配置 VS Code 的仓库文件：

```bash
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
```

这个命令会创建 `/etc/yum.repos.d/vscode.repo` 文件，内容如下：

```ini
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
autorefresh=1
type=rpm-md
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
```

### 步骤 3：安装 VS Code

使用 DNF（推荐）或 YUM 包管理器安装：

```bash
# Fedora 系统使用 dnf
sudo dnf install code

# 或者使用 yum（兼容性更好）
sudo yum install code
```

安装过程中系统会自动：
- 下载最新版本的 VS Code
- 验证软件包签名
- 处理依赖关系
- 创建桌面快捷方式

---

## 📦 方法二：RPM 包直接安装

如果不希望添加仓库，也可以直接下载 RPM 包安装：

### 步骤 1：下载 RPM 包

访问 [VS Code 官网下载页面](https://code.visualstudio.com/Download) 或使用命令行下载：

```bash
# 下载最新版本（请根据实际情况调整版本号）
wget https://packages.microsoft.com/yumrepos/vscode/code-1.85.1-1696985482.el9.x86_64.rpm

# 或者使用 curl
curl -L -o code.rpm https://packages.microsoft.com/yumrepos/vscode/code-1.85.1-1696985482.el9.x86_64.rpm
```

### 步骤 2：安装 RPM 包

```bash
sudo dnf install ./code.rpm
# 或
sudo rpm -i code.rpm
```

> ⚠️ **注意**：这种方式安装后需要手动更新，推荐使用方法一。

---

## 🎉 启动和验证

### 启动 VS Code

安装完成后，可以通过以下方式启动：

1. **命令行启动**：
   ```bash
   code
   # 或打开特定目录
   code /path/to/your/project
   ```

2. **图形界面启动**：
   - 在应用菜单中找到 "Visual Studio Code"
   - 或使用桌面快捷方式

### 验证安装

检查 VS Code 是否正确安装：

```bash
# 查看版本信息
code --version

# 输出示例：
# 1.85.1
# 1696985482
# x64
```

---

## ⚙️ 基础配置

### 1. 更新 VS Code

如果使用方法一安装，可以通过系统包管理器更新：

```bash
sudo dnf update code
```

或者在 VS Code 内部：`Help > Check for Updates`

### 2. 设置命令行工具

VS Code 安装后会自动添加 `code` 命令到系统 PATH。如果遇到命令找不到的问题：

```bash
# 重新加载 shell 配置
source ~/.bashrc
# 或
source ~/.zshrc

# 手动添加到 PATH（如果需要）
echo 'export PATH="$PATH:/usr/share/code/bin"' >> ~/.bashrc
```

### 3. 配置中文界面

1. 安装中文语言包：
   - 按 `Ctrl+Shift+X` 打开扩展面板
   - 搜索 "Chinese"
   - 安装 "Chinese (Simplified) Language Pack for Visual Studio Code"
   - 重启 VS Code

2. 或者在扩展面板搜索 `ms-ceintl.vscode-language-pack-zh-hans`

---

## 🔌 推荐扩展

### 🎨 界面和主题

- **Material Theme**: `PKief.material-icon-theme`
- **One Dark Pro**: `zhuangtongfa.Material-theme`
- **GitHub Theme**: `GitHub.github-vscode-theme`

### 💻 编程语言支持

- **Python**: `ms-python.python`
- **JavaScript/TypeScript**: `ms-vscode.vscode-typescript-next`
- **Go**: `golang.go`
- **Rust**: `rust-lang.rust-analyzer`
- **C++**: `ms-vscode.cpptools`

### 🛠️ 开发工具

- **GitLens**: `eamodio.gitlens` (增强 Git 功能)
- **Docker**: `ms-azuretools.vscode-docker`
- **Live Server**: `ritwickdey.LiveServer` (前端开发)
- **Prettier**: `esbenp.prettier-vscode` (代码格式化)
- **ESLint**: `ms-vscode.eslint` (代码检查)

### 📝 Markdown 支持

- **Markdown All in One**: `yzhang.markdown-all-in-one`
- **Markdown Preview Enhanced**: `shd101wyy.markdown-preview-enhanced`

---

## 🔧 常见问题排查

### Q1: 安装时出现 GPG 密钥验证失败

**解决方案**：
```bash
# 重新导入密钥
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

# 清理缓存并重新安装
sudo dnf clean all
sudo dnf install code
```

### Q2: 命令行找不到 `code` 命令

**解决方案**：
```bash
# 检查安装位置
which code
whereis code

# 如果没有，重新加载环境变量
source ~/.bashrc

# 或者创建符号链接
sudo ln -s /usr/share/code/bin/code /usr/local/bin/code
```

### Q3: VS Code 无法启动或闪退

**解决方案**：
```bash
# 检查系统依赖
sudo dnf install libXScrnSaver

# 尝试以安全模式启动
code --safe-mode

# 查看详细错误信息
code --verbose
```

### Q4: 扩展安装失败

**解决方案**：
1. 检查网络连接
2. 重启 VS Code
3. 手动下载 `.vsix` 文件安装：
   ```bash
   code --install-extension extension.vsix
   ```

---

## 🔄 卸载 VS Code

如果需要卸载 VS Code：

```bash
# 卸载软件包
sudo dnf remove code

# 删除仓库配置
sudo rm /etc/yum.repos.d/vscode.repo

# 删除用户配置（可选）
rm -rf ~/.config/Code
rm -rf ~/.vscode
```

---

## 📚 相关资源

- [VS Code 官网](https://code.visualstudio.com/)
- [VS Code 文档](https://code.visualstudio.com/docs)
- [VS Code 扩展市场](https://marketplace.visualstudio.com/VSCode)
- [Fedora 官方文档](https://docs.fedoraproject.org/)

---

## 🎯 总结

通过以上步骤，你应该已经在 Fedora 系统中成功安装了 Visual Studio Code。推荐使用官方仓库安装方式，这样可以：

✅ **自动获得更新** - 系统会自动检查并更新 VS Code
✅ **安全性高** - 通过 GPG 密钥验证软件包真实性
✅ **依赖完整** - 自动处理所有必要的依赖关系
✅ **集成度高** - 与系统包管理器完美集成

安装完成后，记得安装常用扩展和配置主题，让 VS Code 更适合你的开发需求！

---

**🎉 享受在 Fedora 中使用 VS Code 的愉快体验！**