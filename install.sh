#!/bin/bash

# iPhone 語音轉文字工具 - 一鍵安裝腳本
# OpenAI Speech-to-Text Tool Installer
# 
# 這個腳本會自動設置所有必要的環境和依賴

set -e  # 遇到錯誤時停止執行

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# 輸出函數
print_header() { echo -e "${PURPLE}$1${NC}"; }
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
print_step() { echo -e "${PURPLE}🔧 $1${NC}"; }

# 顯示歡迎訊息
show_welcome() {
    clear
    print_header "============================================"
    print_header "🎤 iPhone 語音轉文字工具 - 一鍵安裝"
    print_header "============================================"
    echo ""
    print_info "此工具將幫您自動安裝所有必要的環境和依賴"
    print_info "包含 OpenAI Whisper API 語音轉錄功能"
    print_info "以及 ChatGPT 智能文字整理功能"
    echo ""
    print_warning "安裝前請確保您有穩定的網路連線"
    echo ""
}

# 檢查作業系統
check_os() {
    print_step "檢查作業系統..."
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macOS"
        print_success "檢測到 macOS 系統"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="Linux"
        print_success "檢測到 Linux 系統"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        OS="Windows"
        print_success "檢測到 Windows 系統 (Git Bash/WSL)"
    else
        print_error "不支援的作業系統: $OSTYPE"
        exit 1
    fi
}

# 檢查 Python
check_python() {
    print_step "檢查 Python 環境..."
    
    # 檢查 Python 3
    if command -v python3 &> /dev/null; then
        PYTHON_CMD="python3"
        PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2)
        print_success "找到 Python 3: $PYTHON_VERSION"
    elif command -v python &> /dev/null; then
        PYTHON_VERSION=$(python --version 2>&1)
        if [[ $PYTHON_VERSION == *"Python 3"* ]]; then
            PYTHON_CMD="python"
            print_success "找到 Python 3: $PYTHON_VERSION"
        else
            print_error "需要 Python 3，但只找到 Python 2"
            print_info "請安裝 Python 3.8 或更新版本"
            exit 1
        fi
    else
        print_error "未找到 Python"
        print_info "請先安裝 Python 3.8 或更新版本："
        if [[ "$OS" == "macOS" ]]; then
            print_info "- 使用 Homebrew: brew install python3"
            print_info "- 或從官網下載: https://www.python.org/downloads/"
        elif [[ "$OS" == "Linux" ]]; then
            print_info "- Ubuntu/Debian: sudo apt update && sudo apt install python3 python3-pip python3-venv"
            print_info "- CentOS/RHEL: sudo yum install python3 python3-pip"
        fi
        exit 1
    fi
    
    # 檢查 Python 版本
    PYTHON_VERSION_NUMBER=$(echo $PYTHON_VERSION | grep -oE '([0-9]+\.){1}[0-9]+' | head -1)
    if [[ $(echo "$PYTHON_VERSION_NUMBER >= 3.8" | bc -l 2>/dev/null || echo 0) -eq 1 ]] || 
       [[ "$PYTHON_VERSION_NUMBER" > "3.8" ]] || [[ "$PYTHON_VERSION_NUMBER" == "3.8"* ]]; then
        print_success "Python 版本符合需求"
    else
        print_error "Python 版本太舊: $PYTHON_VERSION_NUMBER"
        print_info "需要 Python 3.8 或更新版本"
        exit 1
    fi
}

# 檢查 pip
check_pip() {
    print_step "檢查 pip..."
    
    if command -v pip3 &> /dev/null; then
        PIP_CMD="pip3"
        print_success "找到 pip3"
    elif command -v pip &> /dev/null; then
        PIP_CMD="pip"
        print_success "找到 pip"
    else
        print_error "未找到 pip"
        print_info "嘗試安裝 pip..."
        
        if [[ "$OS" == "macOS" ]]; then
            $PYTHON_CMD -m ensurepip --upgrade
        elif [[ "$OS" == "Linux" ]]; then
            sudo apt install python3-pip -y 2>/dev/null || sudo yum install python3-pip -y 2>/dev/null || {
                print_error "無法自動安裝 pip，請手動安裝"
                exit 1
            }
        fi
        
        if command -v pip3 &> /dev/null; then
            PIP_CMD="pip3"
            print_success "pip 安裝成功"
        else
            print_error "pip 安裝失敗"
            exit 1
        fi
    fi
}

# 創建虛擬環境
create_venv() {
    print_step "創建 Python 虛擬環境..."
    
    if [ -d "venv" ]; then
        print_warning "虛擬環境已存在，將重新創建..."
        rm -rf venv
    fi
    
    $PYTHON_CMD -m venv venv
    
    if [ -d "venv" ]; then
        print_success "虛擬環境創建成功"
    else
        print_error "虛擬環境創建失敗"
        exit 1
    fi
}

# 啟動虛擬環境並安裝依賴
install_dependencies() {
    print_step "啟動虛擬環境並安裝依賴..."
    
    # 啟動虛擬環境
    source venv/bin/activate
    
    # 升級 pip
    print_info "升級 pip..."
    $PIP_CMD install --upgrade pip
    
    # 安裝依賴
    print_info "安裝 OpenAI 套件..."
    $PIP_CMD install openai
    
    print_info "安裝 python-dotenv..."
    $PIP_CMD install python-dotenv
    
    print_success "所有依賴安裝完成"
}

# 創建必要的目錄和檔案
setup_directories() {
    print_step "設置目錄結構..."
    
    # 創建 recordings 目錄
    if [ ! -d "recordings" ]; then
        mkdir recordings
        print_success "創建 recordings 資料夾"
    fi
    
    # 創建 .gitkeep 檔案
    touch recordings/.gitkeep
    
    # 創建 .env.example 檔案（如果不存在）
    if [ ! -f ".env.example" ]; then
        cat > .env.example << 'EOF'
# OpenAI API 金鑰設定
# 請到 https://platform.openai.com/api-keys 取得您的 API 金鑰
# 然後複製這個檔案為 .env 並填入真實的金鑰

OPENAI_API_KEY=your_openai_api_key_here
EOF
        print_success "創建 .env.example 檔案"
    fi
    
    # 創建 .gitignore 檔案（如果不存在）
    if [ ! -f ".gitignore" ]; then
        cat > .gitignore << 'EOF'
# API 金鑰保護
.env
.env.local
.env.*.local

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# 虛擬環境
venv/
env/
ENV/

# 音訊檔案
*.mp3
*.m4a
*.wav
*.mp4
*.mpeg
*.mpga
*.webm

# 轉錄結果檔案
recordings/*.txt
*.txt

# IDE
.vscode/
.idea/
*.swp
*.swo

# macOS
.DS_Store

# Windows
Thumbs.db
ehthumbs.db
Desktop.ini
EOF
        print_success "創建 .gitignore 檔案"
    fi
}

# 設置執行權限
set_permissions() {
    print_step "設置執行權限..."
    
    chmod +x start.sh
    chmod +x install.sh
    
    if [ -f "debug_file.py" ]; then
        chmod +x debug_file.py
    fi
    
    print_success "執行權限設置完成"
}

# 驗證安裝
verify_installation() {
    print_step "驗證安裝..."
    
    # 檢查虛擬環境
    if [ -d "venv" ]; then
        print_success "虛擬環境: OK"
    else
        print_error "虛擬環境: 失敗"
        return 1
    fi
    
    # 檢查 Python 套件
    source venv/bin/activate
    
    if $PIP_CMD show openai &> /dev/null; then
        print_success "OpenAI 套件: OK"
    else
        print_error "OpenAI 套件: 失敗"
        return 1
    fi
    
    if $PIP_CMD show python-dotenv &> /dev/null; then
        print_success "python-dotenv: OK"
    else
        print_error "python-dotenv: 失敗"
        return 1
    fi
    
    # 檢查主要檔案
    if [ -f "speech_to_text.py" ]; then
        print_success "主程式: OK"
    else
        print_error "主程式: 缺少 speech_to_text.py"
        return 1
    fi
    
    if [ -f "start.sh" ]; then
        print_success "啟動腳本: OK"
    else
        print_error "啟動腳本: 缺少 start.sh"
        return 1
    fi
    
    return 0
}

# 顯示完成訊息和使用說明
show_completion() {
    echo ""
    print_header "============================================"
    print_header "🎉 安裝完成！"
    print_header "============================================"
    echo ""
    
    print_success "iPhone 語音轉文字工具已成功安裝！"
    echo ""
    
    print_info "📋 接下來的步驟："
    echo ""
    print_step "1. 設定 OpenAI API 金鑰："
    echo "   • 複製 .env.example 為 .env："
    echo "     cp .env.example .env"
    echo ""
    echo "   • 編輯 .env 檔案，填入您的 OpenAI API 金鑰："
    echo "     nano .env  (或使用其他編輯器)"
    echo ""
    echo "   • 到這裡取得 API 金鑰: https://platform.openai.com/api-keys"
    echo ""
    
    print_step "2. 開始使用："
    echo "   • 啟動工具: ./start.sh"
    echo "   • 或直接轉錄: ./start.sh your_audio_file.m4a"
    echo ""
    
    print_step "3. 功能介紹："
    echo "   • 🎤 單一檔案轉錄"
    echo "   • 🗂️ 批次轉錄處理"
    echo "   • 🤖 ChatGPT 智能整理 (重點整理、會議紀錄、筆記整理、摘要總結)"
    echo "   • 📁 檔案診斷工具"
    echo "   • 📋 互動式選單界面"
    echo ""
    
    print_step "4. 支援的音訊格式："
    echo "   • iPhone 錄音: .m4a"
    echo "   • 其他格式: .mp3, .wav, .mp4, .mpeg, .mpga, .webm"
    echo ""
    
    print_warning "注意事項："
    echo "   • 需要穩定的網路連線 (使用 OpenAI API)"
    echo "   • 音訊檔案大小限制: 25MB"
    echo "   • 使用會產生 API 費用，請查看 OpenAI 定價"
    echo ""
    
    print_info "📖 更多說明請參考："
    echo "   • README.md - 基本使用說明"
    echo "   • USAGE.md - 完整使用指南"
    echo "   • AI_SUMMARY_DEMO.md - 智能整理功能演示"
    echo ""
    
    print_header "準備好開始了嗎？執行: ./start.sh"
    echo ""
}

# 主安裝流程
main() {
    show_welcome
    
    # 詢問是否繼續
    echo "按 Enter 開始安裝，或按 Ctrl+C 取消..."
    read
    
    echo ""
    print_header "開始安裝..."
    echo ""
    
    # 執行安裝步驟
    check_os
    check_python
    check_pip
    create_venv
    install_dependencies
    setup_directories
    set_permissions
    
    echo ""
    print_header "驗證安裝結果..."
    echo ""
    
    if verify_installation; then
        show_completion
    else
        echo ""
        print_error "安裝驗證失敗，請檢查上述錯誤訊息"
        exit 1
    fi
}

# 執行主程式
main "$@" 