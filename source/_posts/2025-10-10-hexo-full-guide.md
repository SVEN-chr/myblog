---
title: "🚀 Hexo 博客搭建完整教程（超详细）+ 踩坑记录"
date: 2025-10-10 10:00:00
tags: [Hexo, 博客搭建, 静态博客, 教程, 踩坑]
categories:
  - 技术
  - 博客
toc: true
---

> 一文打通 Hexo 从 0 到上线：安装、建站、换主题、写作、部署，以及我真实遇到的报错与解决方案（**Pug 模板未渲染**）。

## 为什么选 Hexo？
- 生成快、部署简单、主题超多（NexT/Butterfly/Volantis/Fluid…）
- Markdown 写作友好，插件齐全（评论、搜索、统计、RSS）

---

## 环境准备
**要求：** Node.js（建议 LTS ≥ 18）、Git

**安装检查：**
```bash
node -v
npm -v
git --version
````

---

## 全局安装 Hexo

```bash
npm install -g hexo-cli
hexo -v
```

---

## 初始化站点

```bash
hexo init myblog
cd myblog
npm install
```

核心目录：

```
.
├── _config.yml        # 站点配置
├── source/            # 文章与资源
│   └── _posts/
├── themes/            # 主题
└── public/            # 生成后的静态文件
```

---

## 写第一篇文章 & 本地预览

```bash
hexo new "Hello World"
hexo server      # http://localhost:4000
```

---

## 更换漂亮主题（以 Butterfly 为例）

```bash
git clone -b master https://github.com/jerryc127/hexo-theme-butterfly themes/butterfly
```

在站点根目录 `_config.yml` 里设定：

```yaml
theme: butterfly
```

预览：

```bash
hexo clean && hexo g && hexo s
```

---

## 🚨 踩坑记录：页面直接显示 Pug 源码（未渲染）

**现象：**
浏览器页面不是主题样式，而是原样显示：

```
extends includes/layout.pug
block content
  include ./includes/mixins/indexPostUI.pug
  +indexPostUI
```

**根因：**
Hexo **没有启用 Pug 渲染器**，导致 `.pug` 模板被当作纯文本输出。

**解决：**在站点根目录安装渲染器插件（很多主题必需）

```bash
npm install hexo-renderer-pug --save
# 有些主题的样式用 Stylus，也建议装上：
npm install hexo-renderer-stylus --save
```

然后重试：

```bash
hexo clean && hexo g && hexo s
```

刷新页面即可正常渲染主题 🎉

**附加排查：**

* 确认 `_config.yml` 里的 `theme:` 与 `themes/` 下的目录同名
* 看 `themes/<你的主题>/layout/` 文件扩展名，若是 `.pug` 就必须装 `hexo-renderer-pug`
* 仍异常 → 再 `hexo clean` 后启动；必要时删除 `.deploy_git/` 与 `public/` 重新生成

---

## 常用命令速查

| 命令                         | 说明                       |
| -------------------------- | ------------------------ |
| `hexo new "标题"`            | 新建文章（在 `source/_posts/`） |
| `hexo server` / `hexo s`   | 本地预览                     |
| `hexo generate` / `hexo g` | 生成静态文件到 `public/`        |
| `hexo clean`               | 清理缓存与旧构建                 |
| `hexo deploy` / `hexo d`   | 部署（安装部署插件后可用）            |

---

## 一键部署到 GitHub Pages

1）安装部署插件：

```bash
npm install hexo-deployer-git --save
```

2）配置 `_config.yml`：

```yaml
deploy:
  type: git
  repo: git@github.com:你的用户名/你的用户名.github.io.git
  branch: main
```

3）部署：

```bash
hexo clean && hexo g && hexo d
```

访问：`https://你的用户名.github.io`

**常见问题：**

* 404 或空白：检查仓库名是否为 `username.github.io`，分支设置是否匹配
* 样式丢失：确认 `_config.yml` 的 `url:` 写对（含 `https://` 与自定义域名时的正确域）

---

## 常用插件推荐

```bash
npm i hexo-generator-sitemap --save     # 站点地图
npm i hexo-generator-feed --save        # RSS
npm i hexo-generator-searchdb --save    # 本地搜索
npm i hexo-wordcount --save             # 字数/阅读时长
```

---

## 进阶：GitHub Actions 自动构建发布

**推荐方案：使用 GitHub Pages 部署（2025年最佳实践）**

在你的仓库中新增 `.github/workflows/pages.yml`：

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
          node-version: '22'  # 推荐使用最新 LTS
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

**重要配置：**
1. **启用 GitHub Pages**：Settings → Pages → Source 选择 "GitHub Actions"
2. **更新 `_config.yml`**：
   ```yaml
   url: https://username.github.io/repo-name
   ```
3. **移除 hexo-deployer-git**：不再需要传统的 git 部署

以后只需 `git push`，自动发布到 `https://username.github.io/repo-name`。

⚠️ **注意**：如果遇到 `hexo: command not found` 错误，确保使用 `npx hexo` 而不是 `hexo`。

---

## 主题与功能个性化建议

* **评论**：Giscus / Waline / Utterances
* **统计**：Google Analytics / Cloudflare Web Analytics / 不蒜子
* **搜索**：`hexo-generator-searchdb` + 本地搜索脚本
* **封面与摘要**：多数主题支持 `excerpt`、`cover` 字段，按主题文档配置

---

## 完整命令回顾（可复制）

```bash
# 1. 安装
npm i -g hexo-cli
hexo init myblog && cd myblog && npm i

# 2. 主题（以 Butterfly 为例）
git clone -b master https://github.com/jerryc127/hexo-theme-butterfly themes/butterfly
sed -i 's/^theme:.*/theme: butterfly/' _config.yml  # 手动改也行

# 3. 必需渲染器（避免 Pug 未渲染的坑）
npm i hexo-renderer-pug hexo-renderer-stylus --save

# 4. 预览
hexo new "Hello World"
hexo clean && hexo g && hexo s   # http://localhost:4000

# 5. 部署（GitHub Pages）
npm i hexo-deployer-git --save
# _config.yml 写好 deploy 节
hexo clean && hexo g && hexo d
```

---

## 结语

如果你也遇到“页面显示 Pug 源码”的问题，十有八九就是 **缺少 `hexo-renderer-pug`**。按上文安装并清理重启，基本一次解决。其余个性化配置（评论/搜索/统计/CDN/图床）可按主题文档循序渐进添加。