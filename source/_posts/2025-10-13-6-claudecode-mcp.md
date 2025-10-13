---
title: 6 个 ClaudeCode 必装 MCP，开发效率直接起飞！（附安装命令）
date: 2025-10-13 14:20:00
tags:
  - Claude Code
  - MCP
  - AI编程
  - 开发工具
categories:
  - AI编程
  - 开发工具
toc: true
---

最近一直在用 Claude Code 开发，虽然能力足够强大，但依旧有挺大限制。

所以今天分享几个我常用的 MCP，帮助开发效率起飞。

## 1. Context 7 ：文档查询必备

🚀 称为 vibe coding 必备的 MCP 一点也不过分！

**前 AI 时代**，程序员编程通常就是"**面向 Google 编程**"，没想到 **AI 程序员** 也继承了这个传统～

在去年所有大模型还没有**联网搜索、MCP** 的时候，提问时经常给出一个过时的用法。

比如提问一个 Python 的问题，它可能给你一个 2.7 的解决方案。

**现在 Context 7 完美的解决了这个问题。**

它将 45k+ 库的文档转换成了 AI 能看懂的格式，同时区分了版本。

意思是当你使用 `next.js 15` 进行开发的时候，使用这个 MCP，不用担心它给你一个 `next.js 13` 的实现。

**例如：**
```bash
我的项目是 next.js 15 开发，帮我实现一个路由中间件，检测用户是否登录。use context7
```

**安装命令：**
```bash
claude mcp add -s user context7 -- npx @upstash/context7-mcp@latest
```

## 2. DeepWiki MCP：快速解读开源项目

以前要查某个库的功能、接口，可能要**开浏览器、跳文档网站、搜、定位、复制、翻译**。

用 `DeepWiki MCP`，再也不用花半天时间读 README 了。

在 prompt 加一句 `"用 deepwiki"`，就能让 AI 帮你拉这些文档、整合成回答。

**安装方法：**
```bash
claude mcp add -s user -t http deepwiki https://mcp.deepwiki.com/mcp
```

## 3. Playwright MCP：浏览器自动化

**Playwright** 已经是目前增长最快、最受欢迎的网页自动化工具。

**Playwright MCP** 的存在，更是彻底解决了 AI 模型在网页操作上的核心痛点，让 AI 驱动的网页自动化成为了现实。

目前在 GitHub 上已经收获了 **21.7k** 的 star。

无论是自动化测试，还是爬取网页数据，这个 MCP 通通可以搞定！

并且提供无头版的，再也不用手动点点点了。

**安装命令：**
```bash
# 无头版
claude mcp add -s user playwright -- npx @playwright/mcp@latest --headless
# 窗口版
claude mcp add -s user playwright -- npx @playwright/mcp@latest
```

## 4. Exa MCP：AI 搜索新星

这是一个新兴的搜索 MCP，目前在 GitHub 也是拥有 2.8k 的 star。

为 vibe coding 提供强大的实时搜索能力，搜索内容专为 coding 进行优化，结果也专为 AI 进行了优化，提供干净、最新的搜索结果。

并且专为 code 进行优化，查找技术资料比传统更加准确。

**安装命令：**
```bash
claude mcp add exa -e EXA_API_KEY=YOUR_API_KEY -- npx -y exa-mcp-server
```

## 5. Supabase MCP：让 AI 成为你的数据库管理员

Supabase 不仅仅是一个数据库服务，更是一个全面的后端解决方案。

如果你的项目后端依赖 Supabase，没有它，Claude Code 就只是个编程助手；

有了它，Claude Code 就升级成了**"全栈开发助手"**，既能写前端代码，又能管理后端数据。

**安装命令：**
```bash
claude mcp add --transport http supabase "https://mcp.supabase.com/mcp"
```

## 6. Brave Search MCP：实时搜索能力

如果觉得上面的 Exa MCP 免费额度不够用，那么也可以试试 Brave Search MCP。

每个月 2000 次的免费查询，对一般开发者来讲完全够用。

而且 Brave Search 以保护用户隐私和中立的搜索结果著称，这为依赖其信息的 AI 提供了更可靠、无偏见的数据基础。

**安装命令：**
```bash
claude mcp add search -s user -e BRAVE_API_KEY={your-key} -- npx -y @modelcontextprotocol/server-brave-search
```

## 总结

这 6 个 MCP 工具涵盖了：

1. **Context 7** - 最新文档查询
2. **DeepWiki MCP** - 开源项目快速解读
3. **Playwright MCP** - 浏览器自动化
4. **Exa MCP** - AI 优化的搜索引擎
5. **Supabase MCP** - 数据库管理
6. **Brave Search MCP** - 实时搜索能力

每个工具都能显著提升 Claude Code 的开发效率，建议大家根据自己的需求选择安装。