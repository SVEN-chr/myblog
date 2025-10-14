[根目录](../../CLAUDE.md) > [scaffolds](../) > **scaffolds**

# Scaffolds 模板系统模块

## 变更记录 (Changelog)

- **2025-10-14**: 模块文档初始化，建立模板系统规范
- **Previous**: 基础模板配置

## 模块职责

`scaffolds/` 目录存储 Hexo 的内容模板，用于快速创建不同类型的内容。这些模板定义了新文章、草稿和页面的默认结构和 Front Matter 配置，确保内容创建的一致性和效率。

## 模板文件结构

```
scaffolds/
├── post.md      # 文章模板
├── draft.md     # 草稿模板
├── page.md      # 页面模板
└── custom.md    # 自定义模板（可选）
```

## 模板详情

### 文章模板 (`post.md`)

```markdown
---
title: {{ title }}
date: {{ date }}
tags:
---
```

**用途**: 创建标准的博客文章
**触发命令**: `hexo new "文章标题"`
**生成路径**: `source/_posts/YYYY-MM-DD-title.md`

### 草稿模板 (`draft.md`)

```markdown
---
title: {{ title }}
tags:
---
```

**用途**: 创建未发布的草稿文章
**触发命令**: `hexo new draft "草稿标题"`
**生成路径**: `source/_drafts/title.md`

### 页面模板 (`page.md`)

```markdown
---
title: {{ title }}
date: {{ date }}
---
```

**用途**: 创建独立页面（如关于页面、联系方式等）
**触发命令**: `hexo new page "页面名称"`
**生成路径**: `source/页面名称/index.md`

## 模板变量系统

### Hexo 内置变量

| 变量名 | 说明 | 示例值 |
|--------|------|--------|
| `{{ title }}` | 文章标题 | "我的新文章" |
| `{{ date }}` | 当前时间 | "2025-10-14 18:31:52" |
| `{{ layout }}` | 布局类型 | "post", "draft", "page" |

### 扩展变量（可选）

可以在模板中添加自定义变量：

```markdown
---
title: {{ title }}
date: {{ date }}
author: {{ author }}
categories:
  - {{ category }}
tags: [{{ tags }}]
toc: true
cover: /images/default-cover.jpg
excerpt:
---
```

## 入口与使用

### 基本命令

```bash
# 创建新文章（使用 post.md 模板）
hexo new "文章标题"

# 创建草稿（使用 draft.md 模板）
hexo new draft "草稿标题"

# 创建页面（使用 page.md 模板）
hexo new page "关于我"

# 使用自定义模板
hexo new custom "自定义内容"
```

### 高级用法

```bash
# 指定布局
hexo new "文章标题" --layout post

# 创建带路径的页面
hexo new page "docs/guide"

# 从模板创建并立即编辑
hexo new "新文章" && code source/_posts/$(date +%Y-%m-%d)-新文章.md
```

## 对外接口

### Hexo 命令行接口

- **`hexo new`**: 创建新内容
- **`hexo publish`**: 发布草稿
- **`hexo generate`**: 生成静态文件
- **`hexo server`**: 本地预览

### 模板渲染接口

- **变量替换**: Hexo 引擎替换模板变量
- **文件生成**: 根据模板类型生成对应文件
- **路径管理**: 自动处理文件命名和路径

## 自定义模板创建

### 创建技术教程模板

创建 `scaffolds/tutorial.md`:

```markdown
---
title: {{ title }}
date: {{ date }}
tags: [教程, {{ technology }}]
categories:
  - 技术
  - {{ category }}
toc: true
difficulty: {{ difficulty }}
prerequisites:
  - {{ prerequisite }}
estimated_time: {{ time }}分钟
---

> 本教程将带你学习 {{ title }}，适合有一定基础的读者。

## 学习目标

完成本教程后，你将能够：
- [ ] 目标一
- [ ] 目标二
- [ ] 目标三

## 准备工作

开始之前，请确保你已经准备好：

## 正文内容

## 总结

## 相关资源
```

### 创建工具评测模板

创建 `scaffolds/review.md`:

```markdown
---
title: {{ title }} 评测
date: {{ date }}
tags: [评测, {{ product_type }}]
categories:
  - 评测
product_name: {{ product_name }}
rating: {{ rating }}/5
pros:
  - 优点一
  - 优点二
cons:
  - 缺点一
  - 缺点二
toc: true
---

> 本文是对 {{ product_name }} 的详细评测，包含实际使用体验。

## 产品概述

## 核心功能

## 使用体验

### 优点

### 缺点

## 适用人群

## 竞品对比

## 总结与建议
```

## 最佳实践

### 模板设计原则

1. **一致性**: 保持模板结构的一致性
2. **完整性**: 包含所有必要的 Front Matter 字段
3. **灵活性**: 预留扩展字段用于特殊需求
4. **简洁性**: 避免过于复杂的模板结构

### 字段命名规范

```yaml
# 推荐的字段命名
title: "文章标题"           # 必需
date: "2025-10-14 18:31:52" # 必需
tags: ["标签1", "标签2"]    # 数组格式
categories:                 # 分层级分类
  - 主分类
  - 子分类
toc: true                   # 布尔值
cover: "/images/cover.jpg"  # 路径格式
```

### 内容组织建议

1. **摘要前置**: 在正文开始前提供内容摘要
2. **结构清晰**: 使用层级分明的标题结构
3. **代码规范**: 代码块指定语言类型
4. **图片管理**: 统一的图片命名和引用规范

## 质量控制

### 模板验证

1. **语法检查**: 确保 YAML Front Matter 语法正确
2. **字段验证**: 检查必需字段是否存在
3. **路径测试**: 验证生成的文件路径正确
4. **渲染测试**: 确认模板能正确渲染

### 内容规范

1. **标题规范**: 统一的标题大小写和长度限制
2. **分类标准**: 建立分类和标签的命名标准
3. **日期格式**: 统一的日期时间格式
4. **SEO 优化**: 合理设置关键词和描述

## 扩展功能

### 主题集成

```yaml
# Volantis 主题相关字段
theme_config:
  article:
    meta: true
    copyright: true
    donate: false
```

### SEO 增强

```yaml
# SEO 相关字段
description: "文章描述，用于搜索引擎"
keywords: ["关键词1", "关键词2"]
robots: "index, follow"
canonical: "https://example.com/post-url"
```

### 社交媒体

```yaml
# 社交媒体分享
og_image: "/images/og-image.jpg"
twitter_card: "summary_large_image"
facebook_appid: "your-app-id"
```

## 常见问题 (FAQ)

### Q: 如何修改默认模板？
A: 直接编辑 `scaffolds/` 目录下的对应模板文件即可。

### Q: 模板中的变量不生效？
A: 确保使用正确的变量格式 `{{ variable_name }}`，并检查变量名是否正确。

### Q: 如何添加自定义字段？
A: 在模板中添加所需的字段，Hexo 会自动识别并保留在 Front Matter 中。

### Q: 模板支持条件逻辑吗？
A: Hexo 模板不支持复杂的条件逻辑，如需动态内容请考虑使用 Hexo 插件或脚本。

## 相关文件清单

### 核心模板文件
- `scaffolds/post.md` - 标准文章模板
- `scaffolds/draft.md` - 草稿模板
- `scaffolds/page.md` - 页面模板

### 配置文件
- `_config.yml` - Hexo 主配置文件
- `package.json` - 项目依赖配置

### 生成文件
- `source/_posts/` - 生成的文章文件
- `source/_drafts/` - 生成的草稿文件
- `source/[page]/index.md` - 生成的页面文件

## 模板维护

### 版本控制

1. **Git 跟踪**: 将模板文件纳入版本控制
2. **变更记录**: 重要修改记录在变更日志中
3. **备份策略**: 定期备份模板配置
4. **测试流程**: 模板修改后进行充分测试

### 性能优化

1. **模板大小**: 保持模板文件精简
2. **字段数量**: 避免添加过多不必要的字段
3. **默认值**: 设置合理的默认值
4. **文档更新**: 及时更新模板使用文档

---

*最后更新: 2025-10-14*