---
title: "🚨 Hexo GitHub Actions 部署踩坑记录：从 ESM 错误到 Node.js 版本问题"
date: 2025-10-13 14:00:00
tags: [Hexo, GitHub Actions, 踩坑, ESM, Node.js]
categories:
  - 技术
  - 博客
  - 故障排查
toc: true
---

> 记录一次完整的 Hexo + GitHub Actions 部署问题排查过程：从 `hexo: command not found` 到 ESM 模块错误，再到最终的 Node.js 版本兼容性解决方案。

## 背景说明

正在将 Hexo 博客从传统的 `hexo-deployer-git` 方式迁移到现代化的 GitHub Pages 部署方式，遇到了一系列依赖和兼容性问题。

---

## 🔴 问题一：`hexo: command not found`

### 现象
```bash
Run npx hexo clean
/home/runner/work/_temp/0b03d745-88c2-4991-a01f-22bd91c0e9dd.sh: line 1: hexo: command not found
Error: Process completed with exit code 127.
```

### 原因分析
GitHub Actions 环境中 Hexo 没有全局安装，只能通过 `npx` 运行本地版本。

### 解决方案
将工作流中的 `hexo` 命令改为 `npx hexo`：

```yaml
# 错误写法
- name: Build
  run: |
    hexo clean
    hexo generate

# 正确写法
- name: Build
  run: |
    npx hexo clean
    npx hexo generate
```

---

## 🔴 问题二：ESM 模块兼容性错误

### 现象
```bash
FATAL
Error [ERR_REQUIRE_ESM]: require() of ES Module /home/runner/work/myblog/myblog/node_modules/strip-ansi/index.js from /home/runner/work/myblog/myblog/node_modules/hexo/dist/plugins/console/list/common.js not supported.
```

### 原因分析
- `strip-ansi@7.1.2` 是纯 ESM 模块
- Hexo 8.0.0 使用 CommonJS `require()` 加载
- Node.js 18 对 ESM 兼容性不够完善

### 尝试的解决方案

#### 方案 A：降级 strip-ansi 版本
```bash
npm install strip-ansi@6.0.1 --save-exact
```
**结果**：部分成功，但 GitHub Actions 中 Hexo 内部的 `strip-ansi@7.1.2` 仍然覆盖了修复。

#### 方案 B：使用 npm overrides
```json
{
  "overrides": {
    "strip-ansi": "6.0.1"
  }
}
```
**结果**：理论上可行，但配置复杂。

---

## ✅ 最终解决方案：升级 Node.js 版本

### 原理
Node.js 22 对 ESM 模块支持更加完善，可以正确处理 CommonJS 和 ESM 的互操作。

### 实施步骤

1. **修改 GitHub Actions 工作流**：
```yaml
- name: Setup Node.js
  uses: actions/setup-node@v4
  with:
    node-version: '22'  # 从 18 升级到 22
    cache: 'npm'
```

2. **简化依赖安装**：
```yaml
- name: Install dependencies
  run: |
    npm ci
    # 确保安装所有必需的渲染器
    npm install hexo-renderer-pug hexo-renderer-stylus --save
```

3. **本地环境保持一致**：
```bash
# 确保本地也是 Node.js 22
node --version  # 应该显示 v22.x.x
```

### 关键要点

1. **环境一致性**：本地和 CI 环境使用相同 Node.js 版本
2. **简化依赖**：不再强制指定 strip-ansi 版本，让 Node.js 22 自动处理兼容性
3. **移除冗余**：删除 hexo-deployer-git 等不再需要的依赖

---

## 🔧 完整的 GitHub Pages 部署工作流

### 文件：`.github/workflows/pages.yml`
```yaml
name: Build and Deploy to GitHub Pages

on:
  push:
    branches: [ master ]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          submodules: recursive

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '22'  # 关键：使用 Node.js 22
          cache: 'npm'

      - name: Install dependencies
        run: |
          npm ci
          # 确保安装所有必需的渲染器
          npm install hexo-renderer-pug hexo-renderer-stylus --save

      - name: Build
        run: |
          npx hexo clean
          npx hexo generate

      - name: Setup Pages
        uses: actions/configure-pages@v4

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./public

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

---

## 📋 部署配置更新

### 1. 更新 `_config.yml`
```yaml
# 注释掉旧的部署配置
# deploy:
#   type: git
#   repo: https://github.com/SVEN-chr/SVEN-chr.github.io.git
#   branch: main

# 更新 URL 为正确的 GitHub Pages 地址
url: https://SVEN-chr.github.io/myblog
```

### 2. 清理不需要的依赖
```bash
# 移除 hexo-deployer-git
npm uninstall hexo-deployer-git

# 更新 package.json 中的 deploy 脚本
"deploy": "echo 'Deploy handled by GitHub Actions'"
```

---

## 🎯 验证步骤

1. **本地测试**：
```bash
npx hexo clean && npx hexo generate
```

2. **推送代码**：
```bash
git add . && git commit -m "migrate: 升级到 GitHub Pages 部署" && git push
```

3. **启用 GitHub Pages**：
- 进入仓库 Settings → Pages
- Source 选择 "GitHub Actions"

4. **检查部署**：
- 访问 `https://username.github.io/repo-name`
- 查看 Actions 运行日志确认成功

---

## 📚 经验总结

### ✅ 正确的做法
1. **使用 npx 运行 Hexo**：避免全局依赖问题
2. **Node.js 版本一致**：本地和 CI 环境使用相同版本
3. **优先使用现代方案**：GitHub Pages 部署比 hexo-deployer-git 更可靠
4. **环境变量管理**：使用 `npm ci` 而非 `npm install` 确保依赖一致性

### ❌ 避免的坑
1. **不要混用部署方案**：要么 hexo-deployer-git，要么 GitHub Pages
2. **不要忽略 Node.js 版本**：不同版本的 ESM 支持差异很大
3. **不要强制依赖版本**：除非必要，否则让包管理器处理兼容性
4. **不要忽略权限配置**：GitHub Pages 需要正确的 permissions 设置

---

## 🔄 迁移对比

| 方面 | hexo-deployer-git | GitHub Pages |
|------|------------------|-------------|
| **配置复杂度** | 中等（需配置 SSH） | 简单（自动认证） |
| **部署速度** | 慢（需推送两个仓库） | 快（直接部署） |
| **可靠性** | 中等（依赖 SSH 配置） | 高（官方支持） |
| **维护成本** | 高（需维护两个仓库） | 低（单仓库） |
| **推荐度** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

---

## 结语

通过这次踩坑经历，深刻体会到：

1. **环境一致性的重要性**：本地和 CI 环境的差异是很多问题的根源
2. **Node.js 版本升级的价值**：新版本对现代 JS 生态支持更好
3. **选择合适的技术方案**：GitHub Pages 部署比传统方式更可靠
4. **系统化排查问题**：从命令错误到依赖兼容性，需要层层深入

如果你也遇到类似问题，希望这篇踩坑记录能帮你节省时间！

---

## 📚 参考链接

- [Hexo 官方文档](https://hexo.io/docs/)
- [GitHub Pages 官方文档](https://docs.github.com/en/pages)
- [Node.js ESM 文档](https://nodejs.org/api/esm.html)
- [GitHub Actions 文档](https://docs.github.com/en/actions)