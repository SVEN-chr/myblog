#!/bin/bash

# Git 用户信息配置脚本
# 用法: ./git-setup-user.sh [用户名] [邮箱]

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

# 交互式输入用户信息
get_user_input() {
    echo
    print_step "请输入你的Git用户信息："
    echo

    # 获取用户名
    if [ -z "$USER_NAME" ]; then
        DEFAULT_NAME=$(git config --global user.name 2>/dev/null || echo "")
        if [ -n "$DEFAULT_NAME" ]; then
            read -p "用户名 [$DEFAULT_NAME]: " INPUT_NAME
            USER_NAME=${INPUT_NAME:-$DEFAULT_NAME}
        else
            SYSTEM_USER=$(whoami)
            read -p "用户名 [$SYSTEM_USER]: " INPUT_NAME
            USER_NAME=${INPUT_NAME:-$SYSTEM_USER}
        fi
    fi

    # 获取邮箱
    if [ -z "$USER_EMAIL" ]; then
        DEFAULT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")
        if [ -n "$DEFAULT_EMAIL" ]; then
            read -p "邮箱 [$DEFAULT_EMAIL]: " INPUT_EMAIL
            USER_EMAIL=${INPUT_EMAIL:-$DEFAULT_EMAIL}
        else
            # 基于用户名生成建议邮箱
            SUGGEST_EMAIL="${USER_NAME}@users.noreply.github.com"
            read -p "邮箱 [$SUGGEST_EMAIL]: " INPUT_EMAIL
            USER_EMAIL=${INPUT_EMAIL:-$SUGGEST_EMAIL}
        fi
    fi

    echo
}

# 验证邮箱格式
validate_email() {
    local email="$1"
    if [[ ! "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        print_warning "邮箱格式可能不正确: $email"
        read -p "是否继续？(y/N): " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# 检查Git仓库状态
check_git_repo() {
    print_step "检查Git仓库状态..."

    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "当前目录不是Git仓库"
        print_info "请先初始化Git仓库: git init"
        exit 1
    fi

    print_success "Git仓库检查通过"
}

# 显示当前配置
show_current_config() {
    print_step "显示当前Git配置..."

    echo
    print_info "全局配置:"
    local global_name=$(git config --global user.name || echo "未设置")
    local global_email=$(git config --global user.email || echo "未设置")
    echo "  用户名: $global_name"
    echo "  邮箱: $global_email"

    print_info "本地配置:"
    local local_name=$(git config user.name || echo "未设置")
    local local_email=$(git config user.email || echo "未设置")
    echo "  用户名: $local_name"
    echo "  邮箱: $local_email"
    echo
}

# 设置Git用户信息
set_git_config() {
    print_step "设置本地Git用户信息..."

    git config user.name "$USER_NAME"
    git config user.email "$USER_EMAIL"

    print_success "本地Git配置已更新"
}

# 验证配置
verify_config() {
    print_step "验证Git配置..."

    local current_name=$(git config user.name)
    local current_email=$(git config user.email)

    if [ "$current_name" = "$USER_NAME" ] && [ "$current_email" = "$USER_EMAIL" ]; then
        print_success "配置验证成功"
    else
        print_error "配置验证失败"
        exit 1
    fi
}

# 显示GitHub关联信息
show_github_info() {
    print_step "GitHub关联信息..."

    # 检查是否有远程仓库
    if git remote get-url origin >/dev/null 2>&1; then
        local remote_url=$(git remote get-url origin)
        print_info "远程仓库: $remote_url"

        # 尝试提取GitHub用户名
        if [[ "$remote_url" =~ github\.com[/:](.+)/(.+)\.git$ ]]; then
            local github_user="${BASH_REMATCH[1]}"
            print_info "GitHub用户: $github_user"

            if [ "$github_user" != "$(echo "$USER_EMAIL" | cut -d'@' -f1)" ]; then
                print_warning "邮箱用户名与GitHub用户名不匹配"
                print_info "建议使用GitHub关联邮箱以获得更好的贡献统计"
            fi
        fi
    else
        print_warning "未发现远程仓库"
    fi
}

# 显示后续操作建议
show_next_steps() {
    echo
    print_success "Git用户信息配置完成！"
    echo
    print_info "配置摘要:"
    echo "  👤 用户名: $USER_NAME"
    echo "  📧 邮箱: $USER_EMAIL"
    echo "  📁 作用域: 当前仓库 ($(pwd))"
    echo

    print_info "后续操作建议:"
    echo "  🚀 使用个人提交: /git-personal-commit \"你的提交信息\""
    echo "  📊 查看提交历史: git log --oneline -5"
    echo "  🔗 关联GitHub: 确保邮箱与GitHub账号关联"
    echo

    print_info "常用Git命令:"
    echo "  git status                    # 查看状态"
    echo "  git add .                     # 添加所有文件"
    echo "  git commit -m \"message\"       # 创建提交"
    echo "  git push origin branch        # 推送到远程"
    echo
}

# 显示使用说明
show_usage() {
    echo "用法: $0 [用户名] [邮箱]"
    echo
    echo "参数:"
    echo "  用户名    Git用户名（可选，未提供时交互式输入）"
    echo "  邮箱      Git邮箱（可选，未提供时交互式输入）"
    echo
    echo "示例:"
    echo "  $0                           # 交互式配置"
    echo "  $0 \"张三\"                     # 只设置用户名"
    echo "  $0 \"张三\" \"zhangsan@email.com\"  # 设置用户名和邮箱"
    echo
}

# 主函数
main() {
    # 处理帮助参数
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        show_usage
        exit 0
    fi

    # 解析命令行参数
    USER_NAME="$1"
    USER_EMAIL="$2"

    echo "=========================================="
    echo "⚙️  Git 用户信息配置工具"
    echo "=========================================="
    echo

    # 执行步骤
    check_git_repo
    show_current_config
    get_user_input
    validate_email "$USER_EMAIL"
    set_git_config
    verify_config
    show_github_info
    show_next_steps
}

# 运行主函数
main "$@"