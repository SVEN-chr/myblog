---
title: Claude Code 插件系统发布：轻松定制和分享你的开发环境
date: 2025-10-13 15:53:19
tags:
  - Claude Code
  - 插件系统
  - 开发工具
  - AI编程
categories:
  - 技术资讯
  - AI工具
toc: true
---

## 前言

Anthropic 在 2025 年 10 月 10 日发布了 Claude Code 的插件系统，这是一个令人兴奋的新功能。插件系统让开发者能够轻松地定制和分享他们的 Claude Code 开发环境，包括斜杠命令、专用代理、MCP 服务器和钩子等扩展功能。

![Claude Code Plugins](https://maas-log-prod.cn-wlcb.ufileos.com/anthropic/a1f2e0fc-84e7-4888-84c9-36273f7bc9ff/59290d3df7224c478c7d85ae52661200.png?UCloudPublicKey=TOKEN_e15ba47a-d098-4fbd-9afc-a0dcf0e4e621&Expires=1760343738&Signature=mD%2BvoE%2FFZnHBY9EYCL%2F0UdvkWPY%3D)

## 什么是 Claude Code 插件？

Claude Code 现在支持插件：这是一个轻量级的方式来包装和共享任何组合的自定义功能集合，包括：

- **斜杠命令（Slash commands）**：为常用操作创建自定义快捷方式
- **子代理（Subagents）**：安装用于专门开发任务的专用代理
- **MCP 服务器（MCP servers）**：通过模型上下文协议连接到工具和数据源
- **钩子（Hooks）**：在工作流程的关键点自定义 Claude Code 的行为

### 插件的优势

插件设计为可以按需开启和关闭。当你需要特定功能时启用它们，不需要时禁用它们，这样可以减少系统提示上下文和复杂性。

## 插件的使用场景

插件帮助您围绕一套共享的最佳实践来标准化 Claude Code 环境。常见的插件使用场景包括：

### 1. 强制执行标准
工程领导者可以通过使用插件确保特定的钩子在代码审查或测试工作流程中运行，从而在整个团队中保持一致性。

### 2. 支持用户
开源维护者可以提供斜杠命令，帮助开发者正确使用他们的包。

### 3. 共享工作流程
构建生产力提升工作流程的开发者——如调试设置、部署管道或测试工具——可以轻松地与他人分享。

### 4. 连接工具
需要通过 MCP 服务器连接内部工具和数据源的团队，可以使用具有相同安全和配置协议的插件来加速这个过程。

### 5. 打包自定义设置
框架作者或技术负责人可以打包多个适用于特定用例的自定义功能。

## 插件市场

为了让共享这些自定义设置变得更加容易，任何人都可以构建和托管插件并创建插件市场——这是其他开发者可以发现和安装插件的精选集合。

### 使用插件市场

你可以使用插件市场与社区共享插件，在组织内分发已批准的插件，并基于现有解决方案构建针对常见开发挑战的解决方案。

要托管市场，你只需要一个 git 仓库、GitHub 仓库或带有格式正确的 `.claude-plugin/marketplace.json` 文件的 URL。

要从市场使用插件，运行 `/plugin marketplace add user-or-org/repo-name`，然后使用 `/plugin` 菜单浏览和安装插件。

## 社区案例

插件市场放大了我们的社区已经开发出的最佳实践，社区成员正在引领道路。例如：

- 工程师 Dan Ávila 的[插件市场](https://www.aitmpl.com/plugins)提供了 DevOps 自动化、文档生成、项目管理和测试套件的插件。
- 工程师 Seth Hobson 在他的 [GitHub 仓库](https://github.com/wshobson/agents)中策划了 80 多个专门的子代理，让开发者可以通过插件即时访问。

你也可以查看我们开发的一些[示例插件](https://github.com/anthropics/claude-code)，用于 PR 审查、安全指导、[Claude Agent SDK](https://www.anthropic.com/engineering/building-agents-with-the-claude-agent-sdk)开发，甚至是用于创建新插件的元插件。

## 如何开始使用

插件现已进入公开测试阶段，所有 Claude Code 用户都可以使用。使用 `/plugin` 命令安装它们，它们将在你的终端和 VS Code 中工作。

### 快速开始

1. 添加 Anthropic 官方插件市场：
   ```bash
   /plugin marketplace add anthropics/claude-code
   ```

2. 安装功能开发插件：
   ```bash
   /plugin install feature-dev
   ```

### 学习资源

查看我们的文档来：
- [开始使用](https://docs.claude.com/en/docs/claude-code/plugins-reference)
- [构建自己的插件](https://docs.claude.com/en/docs/claude-code/plugins)
- [发布市场](https://docs.claude.com/en/docs/claude-code/plugin-marketplaces)

## 总结

Claude Code 插件系统的发布标志着 AI 辅助编程工具定制化的重要里程碑。它不仅让个人开发者能够根据自己的需求定制开发环境，还促进了团队间的最佳实践共享和社区的协作创新。

随着插件生态系统的发展，我们可以期待看到更多专门化的工具和工作流程出现，这将进一步提升开发效率和代码质量。

如果你是 Claude Code 用户，现在就开始探索插件系统吧！如果你还没有尝试过 Claude Code，这可能是开始使用的最佳时机。

---
