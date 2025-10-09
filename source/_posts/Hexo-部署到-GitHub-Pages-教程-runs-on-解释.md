---
title: "🚀 Hexo 博客部署到 GitHub Pages（含 runs-on 详解）"
date: 2025-10-10 20:00:00
tags: [Hexo, GitHub Pages, 部署, 教程, Actions]
categories:
  - 技术
  - 博客
toc: true
---

> 本文详细介绍如何将 Hexo 博客部署到 **GitHub Pages**，并解释 `runs-on` 是什么意思、为什么不需要修改，即使你本地用的是 Fedora。

---

## 🧱 一、前提条件

在开始前，请确保你已经完成以下步骤：

1. 本地 Hexo 博客可正常运行：
   ```bash
   hexo clean && hexo g && hexo s
   ```

打开浏览器访问 `http://localhost:4000` 能正常显示页面。

2. 安装了 Git 并能连接 GitHub：

   ```bash
   git --version
   ```

   若没有配置 SSH，请执行：

   ```bash
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
   cat ~/.ssh/id_rsa.pub
   ```

   然后把公钥粘贴到：
   👉 [https://github.com/settings/keys](https://github.com/settings/keys)

---

## ⚙️ 二、创建 GitHub 仓库

1️⃣ 登录 GitHub
2️⃣ 点击右上角 **New repository**
3️⃣ 命名为：

```
yourusername.github.io
```

⚠️ 注意：

* 仓库名必须与用户名一致；
* 仓库必须是 **Public**；
* 不要勾选 README 或 LICENSE（否则 Hexo 无法推送）。

---

## 📦 三、安装部署插件

进入你的博客根目录（含 `_config.yml` 的那个），执行：

```bash
npm install hexo-deployer-git --save
```

这个插件让 Hexo 能将生成的静态文件推送到 GitHub 仓库。

---

## 🧩 四、配置 `_config.yml`

在你的 Hexo 根目录中找到 `_config.yml`，
在末尾添加或修改以下内容：

```yaml
deploy:
  type: git
  repo: git@github.com:yourusername/yourusername.github.io.git
  branch: main
```

> 💡 `repo:` 推荐使用 SSH 地址（安全且免输入密码）
> 如果你的仓库默认分支是 `master`，记得改成对应分支。

---

## 🚀 五、生成与部署

执行以下命令：

```bash
hexo clean
hexo generate
hexo deploy
```

或者简写：

```bash
hexo clean && hexo g && hexo d
```

部署完成后，访问：

> 🌐 [https://yourusername.github.io](https://yourusername.github.io)

几分钟后，你的博客就上线啦 🎉

---

## 🧰 六、自动化部署（GitHub Actions）

你可以让 GitHub 自动帮你部署博客，不需要每次手动执行命令。

### 1️⃣ 推送源码到仓库

你可以将 Hexo 源码放在另一个仓库（比如 `hexo-source`）。

### 2️⃣ 新建 GitHub Actions 文件

在你的仓库中新建路径：

```
.github/workflows/deploy.yml
```

内容如下：

```yaml
name: Hexo Deploy

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: 18

      - name: Install Dependencies
        run: npm install

      - name: Build Hexo
        run: npx hexo generate

      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
```

---

## 🧠 七、`runs-on` 是什么？为什么不用改？

你可能注意到这一行：

```yaml
runs-on: ubuntu-latest
```

很多人会问：

> 我本地是 Fedora（或 Windows、macOS），要改成自己的系统吗？

答案是 —— ❌ **不需要改！**

### 💡 原因：

* GitHub Actions 是在 **GitHub 的服务器上** 执行的；
* 它运行在一个虚拟环境中，与本地电脑无关；
* 你本地系统只是开发环境，不影响构建。

### 🧩 可选值：

| 值                 | 说明              |
| ----------------- | --------------- |
| `ubuntu-latest` ✅ | 默认推荐（最快最稳定）     |
| `ubuntu-22.04`    | 固定 Ubuntu 版本    |
| `windows-latest`  | Windows 环境（极少用） |
| `macos-latest`    | macOS 环境（慢且贵）   |

> ⚠️ GitHub **不支持 Fedora 作为 runs-on 环境**，所以写成 `fedora-latest` 会报错：
>
> ```
> Error: The runner 'fedora-latest' does not exist.
> ```

因此，即使你在 Fedora 上写博客，也应保留：

```yaml
runs-on: ubuntu-latest
```

---

## 🧩 八、常见问题排查

| 问题         | 原因                         | 解决方法                                   |
| ---------- | -------------------------- | -------------------------------------- |
| 页面 404     | 仓库名或分支错误                   | 仓库必须是 `username.github.io` 且分支为 `main` |
| 样式错乱       | `_config.yml` 的 `url` 配置错误 | 确保写成 `https://username.github.io/`     |
| 无法推送       | SSH 未配置                    | 执行 `ssh -T git@github.com` 检查连接        |
| 页面未更新      | GitHub 缓存未刷新               | 强制刷新（Ctrl+F5）或清除缓存                     |
| Actions 失败 | Node 版本过低或包未装全             | 检查 `node-version` 和 `npm install` 步骤   |

---

## ✅ 九、完整命令回顾

```bash
# 安装部署插件
npm install hexo-deployer-git --save

# 配置 _config.yml
deploy:
  type: git
  repo: git@github.com:yourusername/yourusername.github.io.git
  branch: main

# 生成与部署
hexo clean && hexo g && hexo d
```

---

## 🌈 十、总结

* 本地系统是什么（Fedora、Windows、macOS）无所谓；
* GitHub Actions 在云端运行，用 `ubuntu-latest` 即可；
* Hexo 部署 GitHub Pages 只需几行命令；
* 结合 Actions 实现自动化部署更优雅。

---

## 🧭 延伸阅读

* 🔗 Hexo 官方文档：[https://hexo.io/docs/](https://hexo.io/docs/)
* 🔗 GitHub Pages 官方文档：[https://pages.github.com/](https://pages.github.com/)
* 🔗 Actions 模板库：[https://github.com/actions](https://github.com/actions)
