# GitHub 分支保护规则设置

使用 GitHub CLI 设置仓库分支保护规则，为个人项目提供基础安全保护。

## 用法

```bash
/github-protect-branch [branch-name]
```

## 参数

- `branch-name` (可选): 要保护的分支名称，默认为 `master`

## 功能

这个命令会为指定分支设置以下保护规则：

- ✅ **防止强制推送**: 禁止 `git push --force` 操作
- ✅ **防止删除分支**: 禁止删除分支
- ✅ **对管理员强制执行**: 管理员也需遵守规则
- ⚪ **不要求状态检查**: 个人项目灵活性优先
- ⚪ **不要求代码审核**: 保持开发便利性

## 实现步骤

1. 检查 GitHub CLI 是否可用
2. 获取当前仓库信息
3. 为指定分支创建保护规则
4. 验证设置结果

## 示例

```bash
# 保护 master 分支（默认）
/github-protect-branch

# 保护 main 分支
/github-protect-branch main

# 保护 develop 分支
/github-protect-branch develop
```

## 注意事项

- 需要安装 GitHub CLI (`gh`)
- 需要先进行 `gh auth login` 认证
- 需要对仓库有管理员权限
- 适合个人项目或小团队使用

## 相关链接

- [GitHub 分支保护文档](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/about-protected-branches)
- [GitHub CLI 文档](https://cli.github.com/manual/)