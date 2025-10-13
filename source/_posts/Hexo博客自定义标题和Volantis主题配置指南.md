---
title: Hexo博客自定义标题和Volantis主题配置指南
date: 2025-10-14 03:36:53
tags:
  - Hexo
  - Volantis
  - 静态博客
  - 博客搭建
  - 教程
categories:
  - 技术
  - 博客
toc: true
---

# Hexo博客自定义标题和Volantis主题配置指南

在使用Hexo搭建博客时，很多小伙伴都会遇到一个常见问题：如何自定义网站的标题和主题显示名称？特别是使用Volantis主题时，如何将默认的"Volantis"改成自己的名字？今天就来详细介绍一下如何进行这些配置。

## 问题描述

刚搭建好的Hexo博客通常会遇到以下情况：

1. **网页标签页标题**显示为默认的"Hexo"
2. **主页封面标题**显示为"Volantis"
3. 想要个性化这些显示内容，但不知道如何正确配置

## 解决方案

### 1. 修改网页标签页标题

网页标签页的标题通过Hexo的主配置文件 `_config.yml` 中的 `title` 字段控制。

#### 步骤：

1. 打开根目录下的 `_config.yml` 文件
2. 找到 `title` 字段（通常在第6行左右）
3. 修改为你想要显示的标题

```yaml
# Site
title: sven的博客  # 将 "Hexo" 改为你想要的标题
subtitle: ''
description: ''
keywords:
author: SVEN
language: en
timezone: ''
```

> 💡 **提示**：这个标题会显示在浏览器的标签页上，同时也是SEO优化的重要元素。

### 2. 修改Volantis主题主页标题

Volantis主题的主页标题需要通过 `theme_config` 配置来设置。这是一个很多人容易踩坑的地方！

#### 常见错误做法：

```yaml
# ❌ 错误配置 - 这样设置不会生效
volantis:
  cover:
    title: 'SVEN'
```

#### 正确配置方法：

```yaml
# ✅ 正确配置
theme_config:
  cover:
    title: 'SVEN'
```

#### 完整配置示例：

```yaml
# Extensions
## Plugins: https://hexo.io/plugins/
## Themes: https://hexo.io/themes/
theme: volantis

# Volantis theme configuration
theme_config:
  cover:
    title: 'SVEN'

# Deployment
## Docs: https://hexo.io/docs/one-command-deployment
```

### 3. 为什么必须使用 `theme_config`？

通过分析Volantis主题的源代码（`node_modules/hexo-theme-volantis/scripts/events/lib/config.js`），我发现主题会通过以下逻辑来合并配置：

```javascript
// 来自主题配置文件
module.exports = hexo => {
  if (!hexo.locals.get) return;

  // ...

  if (data.volantis) {
    // 处理 volantis.yml 配置文件
  } else {
    // 这一行是关键！合并 theme_config 配置
    merge(hexo.theme.config, hexo.config.theme_config);
  }
  // ...
};
```

这意味着：
- 主题默认配置存储在 `hexo.theme.config` 中
- 用户自定义配置需要放在 `hexo.config.theme_config` 中
- 通过 `theme_config` 节点的配置会被正确合并到主题配置中

#### 踩坑经历分享

我一开始也是直接这样配置：

```yaml
# ❌ 我的错误尝试
volantis:
  cover:
    title: 'SVEN'
```

结果发现主页还是显示"Volantis"。通过查看主题的模板文件（`layout/_partial/_cover/dock.ejs`），我找到了原因：

```ejs
<% if (theme.cover.title) { %>
  <p class="title"><%- theme.cover.title ? theme.cover.title : config.title %></p>
<% } %>
```

这里的 `theme.cover.title` 指的是 `hexo.theme.config.cover.title`，而不是 `hexo.config.volantis.cover.title`！

### 4. 完整配置示例

这是完整的 `_config.yml` 相关配置部分：

```yaml
# Site
title: sven的博客        # 网页标签页标题
subtitle: ''
description: ''
keywords:
author: SVEN
language: en
timezone: ''

# URL
url: https://yourusername.github.io
# ... 其他配置

# Extensions
## Plugins: https://hexo.io/plugins/
## Themes: https://hexo.io/themes/
theme: volantis

# Volantis theme configuration - 重要！
theme_config:
  cover:
    title: 'SVEN'        # 主页封面标题

# ... 其他配置
```

## 验证配置

配置完成后，需要重新生成网站来验证效果：

```bash
# 清理缓存并重新生成
hexo clean && hexo generate

# 或者启动本地服务器预览
hexo server
```

### 检查生成的HTML

你可以通过检查生成的 `public/index.html` 文件来验证配置是否生效：

```bash
# 检查网页标题
grep "<title>" public/index.html
# 应该显示：<title>sven的博客</title>

# 检查主页标题
grep 'class="title"' public/index.html
# 应该显示：<p class="title">SVEN</p>
```

### 实际验证过程

让我展示一下实际的验证过程：

```bash
$ hexo clean && hexo generate
INFO  Validating config
INFO  ============================================
  Volantis 5.8.1
  ...
INFO  Start processing
INFO  Generated: index.html
INFO  56 files generated in 402 ms

$ grep "<title>" public/index.html
<title>sven的博客</title>

$ grep 'class="title"' public/index.html
<p class="title">SVEN</p>
```

看到这样的输出，说明配置已经成功生效了！

## 进阶配置

### 添加副标题

如果你想在主页添加副标题，可以继续配置：

```yaml
theme_config:
  cover:
    title: 'SVEN'
    subtitle: '技术分享 | 生活记录'
```

### 修改Logo

```yaml
theme_config:
  cover:
    title: 'SVEN'
    logo: '/images/logo.png'  # 你的logo路径
```

### 自定义封面背景

```yaml
theme_config:
  cover:
    title: 'SVEN'
    background: 'https://your-image-url.jpg'
```

## 常见问题

### Q: 为什么我的修改没有生效？

A: 可能的原因：
1. 配置位置不正确，确保使用 `theme_config` 节点
2. 没有重新生成网站，运行 `hexo clean && hexo generate`
3. 浏览器缓存，尝试刷新或清除缓存

### Q: 可以设置不同的标题吗？

A: 可以，网页标签页标题和主页标题是完全独立的：
- `title`: 控制浏览器标签页
- `theme_config.cover.title`: 控制主页封面显示

### Q: 如何支持多语言？

A: Volantis主题支持多语言，可以通过修改 `language` 配置：

```yaml
language: zh-CN  # 改为中文
```

## 总结

通过以上配置，你就可以成功自定义Hexo博客的标题了：

### 🎯 配置要点总结

1. **网页标签页标题** → 修改 `_config.yml` 中的 `title` 字段
2. **主页封面标题** → 在 `_config.yml` 中添加 `theme_config.cover.title` 配置

### 🔑 关键记忆点

- **必须使用 `theme_config` 节点**：这是Volantis主题配置的核心要求
- **重新生成网站**：配置修改后一定要运行 `hexo clean && hexo generate`
- **验证HTML输出**：通过检查生成的文件确认配置是否生效

### 📝 完整配置模板

```yaml
# Hexo Configuration
# Site
title: sven的博客
subtitle: ''
description: ''
keywords:
author: SVEN
language: zh-CN  # 建议改为中文
timezone: ''

# Extensions
theme: volantis

# Volantis theme configuration - 关键配置
theme_config:
  cover:
    title: 'SVEN'
    subtitle: '技术分享 | 生活记录'
    # logo: '/images/logo.png'
    # background: 'https://your-image.jpg'
```

### 🎉 效果展示

配置完成后，你会看到：
- 浏览器标签页显示 "sven的博客"
- 博客主页封面显示 "SVEN"
- 搜索引擎收录时使用自定义标题
- 更专业的个人品牌展示

记住关键点：Volantis主题的配置必须放在 `theme_config` 节点下，这是很多初学者容易忽略的地方！

希望这篇教程对你有帮助。如果还有其他问题，欢迎在评论区讨论！

## 相关链接

- [Hexo官方文档](https://hexo.io/docs/)
- [Volantis主题文档](https://volantis.js.org/)
- [Hexo配置参考](https://hexo.io/docs/configuration.html)
