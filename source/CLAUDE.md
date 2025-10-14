[根目录](../../CLAUDE.md) > **source**

# Source 内容管理模块

## 变更记录 (Changelog)

- **2025-10-14**: 模块文档初始化，建立内容管理规范
- **Previous**: 基础内容结构

## 模块职责

`source/` 目录是 Hexo 博客的内容核心，负责存储所有博客文章、静态资源和页面内容。该模块是博客系统的数据源，所有用户可见的内容都由此模块管理。

## 目录结构

```
source/
├── _posts/              # 博客文章目录
│   ├── 2025-10-10-hexo-full-guide.md
│   ├── 2025-10-13-hexo-github-actions-踩坑记录.md
│   └── ...
├── _drafts/             # 草稿目录（可选）
├── categories/          # 分类页面（可选）
├── tags/               # 标签页面（可选）
├── about/              # 关于页面（可选）
├── uploads/            # 上传资源目录（可选）
└── assets/             # 静态资源目录（可选）
```

## 内容类型管理

### 博客文章 (`_posts/`)

**文件命名规范**: `YYYY-MM-DD-title.md`

**Front Matter 结构**:
```yaml
---
title: "文章标题"
date: YYYY-MM-DD HH:mm:ss
tags: [标签1, 标签2]
categories:
  - 主分类
  - 子分类
toc: true           # 目录开关
cover: /images/cover.jpg  # 封面图片（可选）
excerpt: 文章摘要   # 自定义摘要（可选）
---
```

**内容规范**:
- 使用 Markdown 语法编写
- 代码块指定语言类型
- 图片使用相对路径
- 内部链接使用 Hexo 格式

### 静态资源管理

**资源目录结构**:
```
source/
├── assets/
│   ├── css/         # 自定义样式
│   ├── js/          # JavaScript 文件
│   ├── images/      # 图片资源
│   └── fonts/       # 字体文件
└── uploads/         # 上传文件
```

**资源引用方式**:
```markdown
# 相对路径引用
![图片描述](/images/example.jpg)

# 资源文件夹引用（需要开启 post_asset_folder）
![图片描述](example.jpg)
```

## 入口与启动

### 文章创建流程

```bash
# 创建新文章
hexo new "文章标题"

# 创建草稿
hexo new draft "草稿标题"

# 发布草稿
hexo publish "草稿标题"
```

### 内容发布流程

1. **写作阶段**: 在 `_posts/` 或 `_drafts/` 中编写
2. **预览检查**: 本地服务器预览效果
3. **元数据完善**: 检查 Front Matter 信息
4. **资源整理**: 确认图片和链接正确
5. **提交发布**: 推送到仓库触发自动部署

## 对外接口

### Hexo 引擎接口

- **内容解析**: Hexo 读取 Markdown 文件并解析
- **模板渲染**: 将内容渲染到主题模板
- **静态生成**: 生成最终的 HTML 文件
- **资源处理**: 处理静态资源引用

### 主题系统集成

- **变量传递**: Front Matter 数据传递给主题
- **自定义字段**: 支持扩展字段用于主题功能
- **分类标签**: 自动生成分类和标签页面
- **搜索索引**: 为搜索功能提供内容数据

## 关键依赖与配置

### Hexo 配置依赖

```yaml
# _config.yml 相关配置
source_dir: source          # 源文件目录
new_post_name: :title.md    # 新文章命名格式
default_layout: post        # 默认布局
post_asset_folder: false    # 资源文件夹功能
```

### 主题配置集成

```yaml
# Volantis 主题相关配置
theme_config:
  # 文章列表配置
  list:
    title_overflow: false

  # 文章页面配置
  post:
    toc: true              # 目录显示
    copyright: true        # 版权信息
```

## 数据模型

### 文章数据结构

```json
{
  "title": "文章标题",
  "date": "2025-10-14T18:31:52+08:00",
  "updated": "2025-10-14T18:31:52+08:00",
  "tags": ["Hexo", "博客"],
  "categories": ["技术", "建站"],
  "toc": true,
  "content": "Markdown 内容",
  "excerpt": "文章摘要",
  "cover": "/images/cover.jpg",
  "_id": "unique_post_id",
  "_path": "source/_posts/file.md"
}
```

### 分类标签关系

```json
{
  "categories": [
    {
      "name": "技术",
      "slug": "tech",
      "path": "categories/tech/",
      "posts": ["post1", "post2"]
    }
  ],
  "tags": [
    {
      "name": "Hexo",
      "slug": "hexo",
      "path": "tags/hexo/",
      "posts": ["post1", "post3"]
    }
  ]
}
```

## 测试与质量

### 内容验证

1. **Markdown 语法检查**: 确保语法正确
2. **链接有效性**: 检查内部和外部链接
3. **图片路径**: 验证图片资源路径
4. **元数据完整性**: Front Matter 必填字段检查

### 性能优化

1. **图片优化**: 压缩图片，使用合适格式
2. **内容分割**: 使用 `<!-- more -->` 分割摘要
3. **SEO 优化**: 合理设置标题和描述
4. **加载优化**: 懒加载图片和资源

## 常见问题 (FAQ)

### Q: 文章图片不显示怎么办？
A: 检查图片路径是否正确，确保使用相对路径，图片文件存在于 `source/` 目录中。

### Q: 如何修改文章发布日期？
A: 直接编辑 Front Matter 中的 `date` 字段，格式为 `YYYY-MM-DD HH:mm:ss`。

### Q: 文章分类不显示？
A: 确保 `categories` 字段格式正确，支持多级分类，使用数组格式。

### Q: 如何修改文章 URL？
A: 在 `_config.yml` 中修改 `permalink` 配置，或在 Front Matter 中设置自定义路径。

## 相关文件清单

### 核心文件
- `source/_posts/*.md` - 博客文章
- `source/assets/` - 静态资源
- `source/categories/` - 分类页面
- `source/tags/` - 标签页面

### 配置文件
- `_config.yml` - Hexo 主配置
- `scaffolds/post.md` - 文章模板

### 生成文件
- `public/` - 生成的静态文件（不要手动编辑）

## 最佳实践

### 写作建议
1. **结构化写作**: 使用清晰的标题层级
2. **代码示例**: 提供完整可运行的代码
3. **图文并茂**: 适当使用图片和图表
4. **SEO 友好**: 合理设置关键词和描述

### 内容管理
1. **定期备份**: 重要内容及时提交到仓库
2. **版本管理**: 使用 Git 跟踪内容变更
3. **分类整理**: 保持分类和标签的一致性
4. **链接维护**: 定期检查外部链接有效性

---

*最后更新: 2025-10-14*