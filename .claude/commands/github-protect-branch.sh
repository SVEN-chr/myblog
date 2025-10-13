#!/bin/bash

# GitHub 分支保护规则设置脚本
# 用法: ./github-protect-branch.sh [branch-name]

set -e

# 默认分支名称
BRANCH_NAME=${1:-master}

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印函数
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查 GitHub CLI 是否安装
check_gh_cli() {
    print_info "检查 GitHub CLI..."
    if ! command -v gh &> /dev/null; then
        print_error "GitHub CLI (gh) 未安装"
        print_info "请访问 https://cli.github.com/manual/installation 安装 GitHub CLI"
        exit 1
    fi

    local version=$(gh --version)
    print_success "GitHub CLI 已安装: $version"
}

# 检查认证状态
check_auth() {
    print_info "检查 GitHub CLI 认证状态..."
    if ! gh auth status &> /dev/null; then
        print_error "GitHub CLI 未认证"
        print_info "请运行: gh auth login"
        exit 1
    fi
    print_success "GitHub CLI 已认证"
}

# 获取仓库信息
get_repo_info() {
    print_info "获取仓库信息..."

    local repo_info
    repo_info=$(gh repo view --json name,owner 2>/dev/null)

    if [ $? -ne 0 ]; then
        print_error "无法获取仓库信息，请确保在 Git 仓库目录中运行"
        exit 1
    fi

    REPO_NAME=$(echo "$repo_info" | jq -r '.name')
    REPO_OWNER=$(echo "$repo_info" | jq -r '.owner.login')

    print_success "仓库: $REPO_OWNER/$REPO_NAME"
    print_info "目标分支: $BRANCH_NAME"
}

# 检查分支是否存在
check_branch() {
    print_info "检查分支 '$BRANCH_NAME' 是否存在..."

    if ! gh api "repos/$REPO_OWNER/$REPO_NAME/branches/$BRANCH_NAME" &> /dev/null; then
        print_error "分支 '$BRANCH_NAME' 不存在"
        print_info "可用分支:"
        gh api "repos/$REPO_OWNER/$REPO_NAME/branches" --jq '.[].name' | sed 's/^/  - /'
        exit 1
    fi

    print_success "分支 '$BRANCH_NAME' 存在"
}

# 创建分支保护规则
create_protection() {
    print_info "为分支 '$BRANCH_NAME' 创建保护规则..."

    local response
    response=$(gh api \
        --method PUT \
        "repos/$REPO_OWNER/$REPO_NAME/branches/$BRANCH_NAME/protection" \
        --input - << EOF
{
  "required_status_checks": {
    "strict": false,
    "contexts": []
  },
  "enforce_admins": true,
  "required_pull_request_reviews": null,
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
EOF
    )

    if [ $? -eq 0 ]; then
        print_success "分支保护规则创建成功"
    else
        print_error "创建分支保护规则失败"
        exit 1
    fi
}

# 验证保护规则
verify_protection() {
    print_info "验证分支保护规则..."

    local protection
    protection=$(gh api "repos/$REPO_OWNER/$REPO_NAME/branches/$BRANCH_NAME/protection" 2>/dev/null)

    if [ $? -ne 0 ]; then
        print_warning "无法获取保护规则详情（可能是权限问题）"
        return
    fi

    local enforce_admins=$(echo "$protection" | jq -r '.enforce_admins.enabled')
    local allow_force_pushes=$(echo "$protection" | jq -r '.allow_force_pushes.enabled')
    local allow_deletions=$(echo "$protection" | jq -r '.allow_deletions.enabled')

    echo
    print_info "分支保护规则详情:"
    echo "  📁 分支: $BRANCH_NAME"
    echo "  🔒 强制推送: $([ "$allow_force_pushes" = "false" ] && echo "已禁止" || echo "已允许")"
    echo "  🗑️  删除分支: $([ "$allow_deletions" = "false" ] && echo "已禁止" || echo "已允许")"
    echo "  👑 管理员约束: $([ "$enforce_admins" = "true" ] && echo "已启用" || echo "已禁用")"
    echo "  ✅ 状态检查: 已禁用（个人项目）"
    echo "  👥 代码审核: 已禁用（个人项目）"
    echo
}

# 显示使用说明
show_usage() {
    echo "用法: $0 [branch-name]"
    echo
    echo "参数:"
    echo "  branch-name    要保护的分支名称（默认: master）"
    echo
    echo "示例:"
    echo "  $0              # 保护 master 分支"
    echo "  $0 main         # 保护 main 分支"
    echo "  $0 develop      # 保护 develop 分支"
    echo
}

# 主函数
main() {
    # 处理帮助参数
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        show_usage
        exit 0
    fi

    echo "=========================================="
    echo "🔐 GitHub 分支保护规则设置工具"
    echo "=========================================="
    echo

    # 执行步骤
    check_gh_cli
    check_auth
    get_repo_info
    check_branch
    create_protection
    verify_protection

    print_success "分支保护规则设置完成！"
    echo
    print_info "你可以在 GitHub 上查看保护规则:"
    print_info "https://github.com/$REPO_OWNER/$REPO_NAME/settings/branches"
}

# 运行主函数
main "$@"