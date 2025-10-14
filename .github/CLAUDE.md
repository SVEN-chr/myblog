[根目录](../../CLAUDE.md) > **.github**

# GitHub 自动化模块

## 变更记录 (Changelog)

- **2025-10-14**: 模块文档初始化，建立 CI/CD 规范
- **Previous**: 基础 GitHub Actions 配置

## 模块职责

`.github/` 目录管理项目的自动化工作流程，包括持续集成、自动部署和依赖管理。该模块确保博客内容的自动化构建、测试和部署，以及依赖包的安全更新。

## 目录结构

```
.github/
├── workflows/           # GitHub Actions 工作流
│   ├── pages.yml       # Pages 部署工作流
│   └── ci.yml          # 持续集成工作流（可选）
├── dependabot.yml      # 依赖自动更新配置
├── ISSUE_TEMPLATE/     # Issue 模板（可选）
└── PULL_REQUEST_TEMPLATE.md # PR 模板（可选）
```

## 核心工作流程

### Pages 部署工作流 (`workflows/pages.yml`)

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
          node-version: '22'
          cache: 'npm'

      - name: Install dependencies
        run: |
          npm ci
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

**工作流特性**:
- **触发条件**: 推送到 master 分支或手动触发
- **构建环境**: Ubuntu + Node.js 22
- **缓存策略**: npm 依赖缓存
- **权限管理**: 最小权限原则
- **并发控制**: 避免重复部署

## 依赖管理

### Dependabot 配置 (`dependabot.yml`)

```yaml
version: 2
updates:
- package-ecosystem: npm
  directory: "/"
  schedule:
    interval: daily
  open-pull-requests-limit: 20
```

**配置说明**:
- **监控范围**: npm 包管理
- **检查频率**: 每日检查
- **PR 限制**: 最多 20 个并发 PR
- **自动合并**: 需要手动审查合并

## 入口与启动

### 自动触发流程

```mermaid
graph LR
    A[推送代码] --> B[触发 Actions]
    B --> C[环境准备]
    C --> D[依赖安装]
    D --> E[Hexo 构建]
    E --> F[Pages 部署]
    F --> G[网站上线]
```

### 手动触发方式

1. **GitHub 页面**: Actions 页面手动运行
2. **API 调用**: 通过 GitHub API 触发
3. **Webhook**: 外部系统 webhook 触发

### 本地调试

```bash
# 安装 GitHub Actions CLI
# 需要先安装 act 工具
act workflow_dispatch

# 查看工作流日志
gh run list
gh run view <run-id>
```

## 对外接口

### GitHub Actions 接口

- **触发器**: push, workflow_dispatch, schedule
- **环境变量**: GitHub 提供的内置变量
- **密钥管理**: GitHub Secrets 安全存储
- **工件上传**: 构建产物上传和下载

### Pages 部署接口

- **部署 API**: GitHub Pages 部署接口
- **域名管理**: 自定义域名配置
- **HTTPS 支持**: 自动 SSL 证书
- **CDN 分发**: 全球 CDN 加速

## 关键依赖与配置

### Actions 依赖

```yaml
# 核心 Actions
- actions/checkout@v4          # 代码检出
- actions/setup-node@v4        # Node.js 环境
- actions/configure-pages@v4   # Pages 配置
- actions/upload-pages-artifact@v3  # 工件上传
- actions/deploy-pages@v4      # Pages 部署
```

### 环境配置

```yaml
# 环境变量
NODE_VERSION: '22'
NPM_CACHE: 'npm'
HEXO_COMMAND: 'npx hexo'
BUILD_PATH: './public'
```

### 权限配置

```yaml
# 工作流权限
permissions:
  contents: read      # 读取代码
  pages: write        # Pages 写入
  id-token: write     # OIDC 令牌
```

## 数据模型

### 工作流数据

```json
{
  "workflow_id": "pages.yml",
  "run_id": "123456789",
  "status": "success",
  "conclusion": "success",
  "created_at": "2025-10-14T18:31:52Z",
  "jobs": [
    {
      "name": "build",
      "status": "completed",
      "steps": [
        {"name": "Checkout", "status": "completed"},
        {"name": "Setup Node.js", "status": "completed"},
        {"name": "Install dependencies", "status": "completed"},
        {"name": "Build", "status": "completed"}
      ]
    }
  ]
}
```

### 部署信息

```json
{
  "deployment": {
    "environment": "github-pages",
    "url": "https://sven-chr.github.io/myblog",
    "status": "active",
    "custom_domain": null,
    "https_enforced": true
  }
}
```

## 测试与质量

### 工作流测试

1. **本地测试**: 使用 act 工具本地运行
2. **分支测试**: 在测试分支验证工作流
3. **回滚策略**: 部署失败时的回滚方案
4. **监控告警**: 构建失败通知机制

### 性能优化

1. **缓存策略**: 依赖缓存优化构建时间
2. **并行执行**: 独立任务并行处理
3. **资源限制**: 合理配置资源使用
4. **超时设置**: 避免长时间运行

## 监控与维护

### 监控指标

- **构建时间**: 平均构建耗时
- **成功率**: 部署成功率统计
- **错误率**: 构建失败频率
- **资源使用**: 计算资源消耗

### 日志管理

```bash
# 查看工作流日志
gh run list --repo SVEN-chr/myblog
gh run view <run-id> --repo SVEN-chr/myblog

# 下载日志
gh run download <run-id> --repo SVEN-chr/myblog
```

### 故障排查

1. **权限问题**: 检查仓库和工作流权限
2. **依赖问题**: 确认 Node.js 和 npm 版本
3. **配置问题**: 验证 _config.yml 配置
4. **网络问题**: 检查网络连接和代理设置

## 安全配置

### 密钥管理

```yaml
# 使用 GitHub Secrets
secrets:
  NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
  GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  CUSTOM_SECRET: ${{ secrets.CUSTOM_SECRET }}
```

### 安全最佳实践

1. **最小权限**: 只授予必要的权限
2. **密钥轮换**: 定期更新访问密钥
3. **审计日志**: 监控操作审计日志
4. **依赖扫描**: Dependabot 安全扫描

## 扩展功能

### 增强工作流

```yaml
# 添加评论系统部署
- name: Deploy comments
  run: |
    # 部署 Giscus 或其他评论系统

# 添加性能测试
- name: Performance test
  run: |
    # Lighthouse CI 性能测试

# 添加安全扫描
- name: Security scan
  run: |
    # npm audit 或其他安全扫描
```

### 多环境部署

```yaml
# 开发环境
- name: Deploy to staging
  if: github.ref == 'refs/heads/develop'

# 生产环境
- name: Deploy to production
  if: github.ref == 'refs/heads/main'
```

## 常见问题 (FAQ)

### Q: 工作流构建失败怎么办？
A: 检查 Actions 日志，常见原因包括依赖安装失败、配置错误、权限问题。

### Q: 如何修改 Node.js 版本？
A: 在 `workflow.yml` 中修改 `node-version` 字段，建议使用 LTS 版本。

### Q: 部署后网站无法访问？
A: 检查 GitHub Pages 设置，确认域名配置和 DNS 设置正确。

### Q: 如何添加自定义域名？
A: 在仓库 Settings > Pages 中配置自定义域名，并添加 DNS 记录。

## 相关文件清单

### 核心配置文件
- `.github/workflows/pages.yml` - 主要部署工作流
- `.github/dependabot.yml` - 依赖自动更新配置

### 项目配置文件
- `_config.yml` - Hexo 站点配置
- `package.json` - 项目依赖配置

### 生成的部署文件
- `public/` - 静态网站文件（由工作流生成）

## 最佳实践

### 工作流设计

1. **幂等性**: 工作流可以安全重复执行
2. **快速失败**: 尽早发现和报告错误
3. **资源优化**: 合理使用计算资源
4. **安全第一**: 遵循安全最佳实践

### 维护建议

1. **定期更新**: 保持 Actions 版本最新
2. **监控告警**: 设置构建失败通知
3. **文档维护**: 及时更新配置文档
4. **备份策略**: 重要配置多重备份

---

*最后更新: 2025-10-14*