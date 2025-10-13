#!/bin/bash

# 个人 Git 提交和推送脚本
# 用法: ./git-personal-commit.sh "提交信息"

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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

print_step() {
    echo -e "${CYAN}[STEP]${NC} $1"
}

# 检查参数
check_args() {
    if [ $# -eq 0 ]; then
        print_error "请提供提交信息"
        echo
        echo "用法: $0 \"提交信息\""
        echo
        echo "示例:"
        echo "  $0 \"修复博客标题显示问题\""
        echo "  $0 \"添加新的博客文章\""
        exit 1
    fi

    COMMIT_MSG="$1"
    print_success "提交信息: $COMMIT_MSG"
}

# 检查Git仓库状态
check_git_repo() {
    print_step "检查Git仓库状态..."

    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "当前目录不是Git仓库"
        exit 1
    fi

    # 检查是否有未提交的更改
    if ! git diff --quiet || ! git diff --cached --quiet; then
        print_success "发现未提交的更改"
    else
        print_warning "没有发现更改，但会继续执行"
    fi
}

# 获取个人Git配置
get_personal_git_config() {
    print_step "获取个人Git配置..."

    # 尝试从全局配置获取
    GLOBAL_NAME=$(git config --global user.name || echo "")
    GLOBAL_EMAIL=$(git config --global user.email || echo "")

    # 尝试从当前用户信息获取
    if [ -z "$GLOBAL_NAME" ]; then
        GLOBAL_NAME=$(git config user.name || echo "")
    fi
    if [ -z "$GLOBAL_EMAIL" ]; then
        GLOBAL_EMAIL=$(git config user.email || echo "")
    fi

    # 如果仍然没有，尝试从系统获取
    if [ -z "$GLOBAL_NAME" ]; then
        GLOBAL_NAME=$(whoami)
    fi

    # 设置默认邮箱（如果需要）
    if [ -z "$GLOBAL_EMAIL" ]; then
        GLOBAL_EMAIL="${GLOBAL_NAME}@users.noreply.github.com"
        print_warning "使用默认邮箱: $GLOBAL_EMAIL"
    fi

    print_info "用户名: $GLOBAL_NAME"
    print_info "邮箱: $GLOBAL_EMAIL"
}

# 备份当前Git配置
backup_git_config() {
    print_step "备份当前Git配置..."

    ORIGINAL_NAME=$(git config user.name || echo "")
    ORIGINAL_EMAIL=$(git config user.email || echo "")

    # 创建临时备份文件
    echo "ORIGINAL_NAME=\"$ORIGINAL_NAME\"" > /tmp/git_config_backup_$$
    echo "ORIGINAL_EMAIL=\"$ORIGINAL_EMAIL\"" >> /tmp/git_config_backup_$$

    print_info "原始配置已备份"
}

# 设置个人Git配置
set_personal_git_config() {
    print_step "设置个人Git配置..."

    git config user.name "$GLOBAL_NAME"
    git config user.email "$GLOBAL_EMAIL"

    print_success "已设置个人Git配置"
}

# 智能添加文件
smart_add_files() {
    print_step "智能添加文件到暂存区..."

    # 显示修改的文件
    print_info "修改的文件:"
    git status --porcelain | head -10

    # 添加所有修改的文件
    git add .

    # 显示暂存状态
    local staged_files=$(git diff --cached --name-only | wc -l)
    print_success "已添加 $staged_files 个文件到暂存区"
}

# 创建提交
create_commit() {
    print_step "创建提交..."

    # 格式化提交信息
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local formatted_msg="$COMMIT_MSG"

    # 创建提交
    git commit -m "$(cat << EOF
$formatted_msg

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"

    if [ $? -eq 0 ]; then
        print_success "提交创建成功"
        print_info "提交哈希: $(git rev-parse --short HEAD)"
    else
        print_error "创建提交失败"
        restore_git_config
        exit 1
    fi
}

# 获取当前分支和远程信息
get_branch_info() {
    print_step "获取分支信息..."

    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    print_info "当前分支: $CURRENT_BRANCH"

    # 检查是否有远程分支
    if git rev-parse --verify origin/$CURRENT_BRANCH >/dev/null 2>&1; then
        HAS_REMOTE=true
        print_info "发现远程分支: origin/$CURRENT_BRANCH"
    else
        HAS_REMOTE=false
        print_warning "未发现远程分支: origin/$CURRENT_BRANCH"
    fi
}

# 推送到远程仓库
push_to_remote() {
    if [ "$HAS_REMOTE" = true ]; then
        print_step "推送到远程仓库..."

        git push origin $CURRENT_BRANCH

        if [ $? -eq 0 ]; then
            print_success "推送成功"
        else
            print_error "推送失败"
            restore_git_config
            exit 1
        fi
    else
        print_warning "跳过推送（无远程分支）"
        print_info "如果需要推送，请先设置远程仓库"
    fi
}

# 恢复Git配置
restore_git_config() {
    print_step "恢复原始Git配置..."

    if [ -f "/tmp/git_config_backup_$$" ]; then
        source /tmp/git_config_backup_$$

        if [ -n "$ORIGINAL_NAME" ]; then
            git config user.name "$ORIGINAL_NAME"
        else
            git config --unset user.name 2>/dev/null || true
        fi

        if [ -n "$ORIGINAL_EMAIL" ]; then
            git config user.email "$ORIGINAL_EMAIL"
        else
            git config --unset user.email 2>/dev/null || true
        fi

        # 清理备份文件
        rm -f /tmp/git_config_backup_$$

        print_success "Git配置已恢复"
    else
        print_warning "未找到备份文件"
    fi
}

# 显示提交统计
show_commit_stats() {
    print_step "显示提交统计..."

    local commit_count=$(git rev-list --count HEAD 2>/dev/null || echo "0")
    local repo_size=$(du -sh .git 2>/dev/null | cut -f1 || echo "unknown")

    echo
    print_info "仓库统计:"
    echo "  📊 总提交数: $commit_count"
    echo "  💾 仓库大小: $repo_size"
    echo "  🌿 当前分支: $CURRENT_BRANCH"
    echo "  👤 提交者: $GLOBAL_NAME"
    echo
}

# 显示最终状态
show_final_status() {
    print_success "个人提交和推送完成！"
    echo
    print_info "提交详情:"
    echo "  📝 提交信息: $COMMIT_MSG"
    echo "  👤 提交者: $GLOBAL_NAME"
    echo "  🌿 分支: $CURRENT_BRANCH"

    if [ "$HAS_REMOTE" = true ]; then
        echo "  🚀 远程: 已推送到 origin/$CURRENT_BRANCH"
    fi

    echo
    print_info "你可以在GitHub上查看提交:"
    echo "  🔗 https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[:\/]\(.*\)\.git/\1/')/commits/$CURRENT_BRANCH"
}

# 清理函数
cleanup() {
    restore_git_config
}

# 设置退出时清理
trap cleanup EXIT

# 显示使用说明
show_usage() {
    echo "用法: $0 \"提交信息\""
    echo
    echo "参数:"
    echo "  提交信息    提交的描述信息"
    echo
    echo "示例:"
    echo "  $0 \"修复博客标题显示问题\""
    echo "  $0 \"添加新的博客文章\""
    echo "  $0 \"更新文档\""
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
    echo "🚀 个人 Git 提交和推送工具"
    echo "=========================================="
    echo

    # 执行步骤
    check_args "$@"
    check_git_repo
    get_personal_git_config
    backup_git_config
    set_personal_git_config
    smart_add_files
    create_commit
    get_branch_info
    push_to_remote
    show_commit_stats
    show_final_status

    # 恢复配置会在退出时自动执行
}

# 运行主函数
main "$@"