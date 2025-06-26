#!/bin/bash

# iPhone 語音轉文字工具 - 一鍵執行腳本
# 使用方法: 
#   ./start.sh                      - 顯示互動式選單
#   ./start.sh [音訊檔案路徑]         - 直接轉錄單一檔案
#   ./start.sh recordings          - 直接批次轉錄
#   ./start.sh batch              - 直接批次轉錄 (別名)

set -e  # 遇到錯誤就停止

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 印出帶顏色的訊息
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_progress() {
    echo -e "${PURPLE}🔄 $1${NC}"
}

print_menu() {
    echo -e "${CYAN}$1${NC}"
}

# 標題
show_title() {
    clear
    echo -e "${BLUE}"
    echo "🎤 iPhone 語音轉文字工具"
    echo "=========================="
    echo -e "${NC}"
}

# 環境檢查函數
check_environment() {
    # 檢查 Python
    if ! command -v python3 &> /dev/null; then
        print_error "找不到 Python3，請先安裝 Python"
        exit 1
    fi

    print_info "Python3 已安裝 ✓"

    # 建立虛擬環境 (如果不存在)
    if [ ! -d "venv" ]; then
        print_info "建立 Python 虛擬環境..."
        python3 -m venv venv
        print_success "虛擬環境建立完成"
    else
        print_info "虛擬環境已存在 ✓"
    fi

    # 啟動虛擬環境
    print_info "啟動虛擬環境..."
    source venv/bin/activate

    # 安裝或更新依賴
    print_info "檢查並安裝 Python 套件..."
    pip install -q -r requirements.txt
    print_success "Python 套件已安裝"

    # 檢查 .env 檔案
    if [ ! -f ".env" ]; then
        print_info "建立 .env 設定檔..."
        if [ -f ".env.example" ]; then
            cp .env.example .env
            print_success ".env 檔案已從 .env.example 建立"
        else
            cat > .env << 'EOF'
# OpenAI API 金鑰
# 請到 https://platform.openai.com/api-keys 取得您的 API 金鑰
OPENAI_API_KEY=your_openai_api_key_here
EOF
            print_success ".env 檔案已建立"
        fi
        print_warning "請編輯 .env 檔案，填入您的 OpenAI API 金鑰"
    fi

    # 檢查 API 金鑰是否已設定
    if grep -q "your_openai_api_key_here" .env; then
        print_error "請先設定 OpenAI API 金鑰！"
        echo ""
        echo "步驟："
        echo "1. 到 https://platform.openai.com/api-keys 取得 API 金鑰"
        echo "2. 編輯 .env 檔案，將 your_openai_api_key_here 替換為您的金鑰"
        echo ""
        echo "範例："
        echo "OPENAI_API_KEY=sk-your-actual-api-key-here"
        echo ""
        echo "設定完成後，再次執行此腳本即可使用"
        exit 1
    fi

    print_success "API 金鑰已設定"

    # 確保 recordings 資料夾存在
    if [ ! -d "recordings" ]; then
        print_info "建立 recordings 資料夾..."
        mkdir -p recordings
        echo "# 這個檔案用來保持 recordings 資料夾在 git 中的存在" > recordings/.gitkeep
        echo "# 但資料夾內的音訊檔案會被 .gitignore 忽略" >> recordings/.gitkeep
        print_success "recordings 資料夾已建立"
    fi

    # 啟動虛擬環境 (確保後續命令在虛擬環境中執行)
    source venv/bin/activate
}

# 顯示主選單
show_main_menu() {
    echo ""
    print_menu "📋 請選擇操作："
    echo ""
    print_menu "  1️⃣  轉錄單一檔案"
    print_menu "  2️⃣  批次轉錄 recordings 資料夾"
    print_menu "  3️⃣  轉錄+整理 (單一檔案)"
    print_menu "  4️⃣  批次轉錄+整理"
    print_menu "  5️⃣  整理現有文字檔案"
    print_menu "  6️⃣  檔案診斷工具"
    print_menu "  7️⃣  查看系統狀態"
    print_menu "  8️⃣  說明與幫助"
    print_menu "  0️⃣  退出程式"
    echo ""
    print_menu "請輸入選項 (0-8): "
}

# 單一檔案轉錄
single_file_transcription() {
    echo ""
    print_info "🎤 單一檔案轉錄"
    echo "─────────────────────────────────────────────"
    echo ""
    
    echo "請輸入音訊檔案路徑："
    echo "💡 提示：可以直接拖放檔案到終端機"
    echo "💡 支援格式：.mp3, .m4a, .wav, .mp4, .mpeg, .mpga, .webm"
    echo ""
    read -p "檔案路徑: " file_path
    
    # 移除可能的引號
    file_path=$(echo "$file_path" | sed 's/^["'"'"']//;s/["'"'"']$//')
    
    if [ -z "$file_path" ]; then
        print_warning "未輸入檔案路徑"
        return
    fi
    
    if [ ! -f "$file_path" ]; then
        print_error "找不到檔案: $file_path"
        return
    fi
    
    echo ""
    print_info "開始處理語音檔案: $(basename "$file_path")"
    echo ""
    
    if source venv/bin/activate && python speech_to_text.py "$file_path"; then
        echo ""
        print_success "🎉 轉錄完成！"
    else
        print_error "轉錄失敗"
    fi
}

# 批次處理函數
process_recordings_folder() {
    echo ""
    print_info "🗂️  批次處理 recordings 資料夾"
    echo "─────────────────────────────────────────────"
    echo ""
    
    # 支援的音訊格式
    audio_extensions=("*.mp3" "*.m4a" "*.wav" "*.mp4" "*.mpeg" "*.mpga" "*.webm")
    
    # 收集所有音訊檔案
    audio_files=()
    for ext in "${audio_extensions[@]}"; do
        while IFS= read -r -d '' file; do
            audio_files+=("$file")
        done < <(find recordings -name "$ext" -type f -print0 2>/dev/null)
    done
    
    if [ ${#audio_files[@]} -eq 0 ]; then
        print_warning "recordings 資料夾中沒有找到音訊檔案"
        echo ""
        echo "支援的格式: .mp3, .m4a, .wav, .mp4, .mpeg, .mpga, .webm"
        echo "請將音訊檔案放入 recordings 資料夾後再試"
        echo ""
        print_info "💡 按任意鍵返回主選單..."
        read -n 1
        return
    fi
    
    total_files=${#audio_files[@]}
    successful=0
    failed=0
    
    print_info "找到 $total_files 個音訊檔案"
    echo ""
    
    # 選擇整理類型
    print_menu "📝 請選擇整理類型："
    echo ""
    print_menu "  1️⃣  重點整理 (提取要點)"
    print_menu "  2️⃣  會議紀錄 (正式格式)"
    print_menu "  3️⃣  筆記整理 (結構化)"
    print_menu "  4️⃣  摘要總結 (簡潔版)"
    echo ""
    print_menu "請選擇整理類型 (1-4): "
    
    read type_choice
    echo ""
    
    case $type_choice in
        1) summary_type="重點整理" ;;
        2) summary_type="會議紀錄" ;;
        3) summary_type="筆記整理" ;;
        4) summary_type="摘要總結" ;;
        *) 
            print_warning "無效選擇，使用預設的重點整理"
            summary_type="重點整理" 
            ;;
    esac
    
    print_success "✅ 已選擇整理類型: $summary_type"
    echo ""
    
    # 確認是否繼續
    echo "即將開始批次轉錄，這可能需要一些時間..."
    read -p "是否繼續？ (y/N): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        print_info "已取消批次處理"
        return
    fi
    
    echo ""
    print_progress "開始批次處理..."
    echo ""
    
    # 逐一處理每個檔案
    for i in "${!audio_files[@]}"; do
        file="${audio_files[$i]}"
        current=$((i + 1))
        
        print_progress "[$current/$total_files] 處理: $(basename "$file")"
        echo ""
        
        if source venv/bin/activate && python speech_to_text.py "$file" --summarize --type="$summary_type"; then
            ((successful++))
            print_success "✓ $(basename "$file") 轉錄成功"
        else
            ((failed++))
            print_error "✗ $(basename "$file") 轉錄失敗"
        fi
        
        echo ""
        echo "─────────────────────────────────────────────"
        echo ""
    done
    
    # 顯示統計結果
    echo -e "${BLUE}📊 批次處理完成統計:${NC}"
    echo "總檔案數: $total_files"
    echo -e "${GREEN}成功: $successful${NC}"
    echo -e "${RED}失敗: $failed${NC}"
    
    if [ $failed -eq 0 ]; then
        print_success "🎉 所有檔案都成功轉錄完成！"
    else
        print_warning "⚠️  部分檔案轉錄失敗，請檢查錯誤訊息"
    fi
    
    echo ""
    print_info "💡 按任意鍵返回主選單..."
    read -n 1
}

# 查看系統狀態
show_system_status() {
    echo ""
    print_info "🔧 系統狀態檢查"
    echo "─────────────────────────────────────────────"
    echo ""
    
    # Python 環境
    echo "🐍 Python 環境:"
    python3 --version
    echo ""
    
    # 虛擬環境狀態
    if [ -d "venv" ]; then
        print_success "虛擬環境: 已建立 ✓"
    else
        print_warning "虛擬環境: 未建立"
    fi
    
    # API 金鑰狀態
    if [ -f ".env" ]; then
        if grep -q "your_openai_api_key_here" .env; then
            print_warning "API 金鑰: 尚未設定"
        else
            print_success "API 金鑰: 已設定 ✓"
        fi
    else
        print_warning "API 金鑰: .env 檔案不存在"
    fi
    
    # recordings 資料夾狀態
    if [ -d "recordings" ]; then
        audio_count=$(find recordings -name "*.mp3" -o -name "*.m4a" -o -name "*.wav" -o -name "*.mp4" -o -name "*.mpeg" -o -name "*.mpga" -o -name "*.webm" 2>/dev/null | wc -l)
        print_success "recordings 資料夾: 已建立 ✓ (包含 $audio_count 個音訊檔案)"
    else
        print_warning "recordings 資料夾: 不存在"
    fi
    
    # 套件狀態
    echo ""
    echo "📦 已安裝套件:"
    pip list | grep -E "(openai|python-dotenv)" || echo "部分套件可能未安裝"
    
    echo ""
    print_info "💡 按任意鍵返回主選單..."
    read -n 1
}

# 顯示說明與幫助
show_help() {
    echo ""
    print_info "📖 說明與幫助"
    echo "─────────────────────────────────────────────"
    echo ""
    
    echo "🎯 快速開始："
    echo "1. 確保已設定 OpenAI API 金鑰 (.env 檔案)"
    echo "2. 將音訊檔案放入專案目錄或 recordings 資料夾"
    echo "3. 選擇對應的轉錄選項"
    echo ""
    
    echo "🎤 主要功能："
    echo "1️⃣  轉錄單一檔案 - 基本語音轉文字"
    echo "2️⃣  批次轉錄 - 處理整個資料夾"
    echo "3️⃣  轉錄+整理 - 自動整理轉錄結果"
    echo "4️⃣  批次轉錄+整理 - 批次處理並整理"
    echo "5️⃣  整理文字檔案 - 整理已有的轉錄檔案"
    echo ""
    
    echo "🤖 ChatGPT 整理類型："
    echo "• 重點整理 - 提取要點和關鍵資訊"
    echo "• 會議紀錄 - 正式會議記錄格式"
    echo "• 筆記整理 - 結構化學習筆記"
    echo "• 摘要總結 - 簡潔版內容摘要"
    echo ""
    
    echo "📁 檔案放置建議："
    echo "• 單一檔案: 放在專案根目錄"
    echo "• 多個檔案: 放入 recordings 資料夾，使用批次處理"
    echo ""
    
    echo "🎤 支援的音訊格式："
    echo "• iPhone 錄音: .m4a"
    echo "• 常見格式: .mp3, .wav, .mp4, .mpeg, .mpga, .webm"
    echo ""
    
    echo "📝 相關文檔："
    echo "• README.md - 基本使用說明"
    echo "• USAGE.md - 完整使用指南"
    echo "• recordings/README.md - 批次處理說明"
    echo "• SECURITY.md - 安全配置說明"
    echo ""
    
    echo "🔧 直接命令列使用："
    echo "• ./start.sh recording.m4a                        - 轉錄單一檔案"
    echo "• ./start.sh recordings                          - 批次轉錄"
    echo "• python speech_to_text.py file.m4a --summarize  - 轉錄+整理"
    echo ""
    
    print_info "💡 按任意鍵返回主選單..."
    read -n 1
}

# 轉錄+整理 (單一檔案)
transcribe_and_summarize_single() {
    echo ""
    print_info "🎤+🤖 轉錄並整理單一檔案"
    echo "─────────────────────────────────────────────"
    echo ""
    
    echo "請輸入音訊檔案路徑："
    echo "💡 提示：可以直接拖放檔案到終端機"
    echo "💡 支援格式：.mp3, .m4a, .wav, .mp4, .mpeg, .mpga, .webm"
    echo ""
    read -p "檔案路徑: " file_path
    
    # 移除可能的引號
    file_path=$(echo "$file_path" | sed 's/^["'"'"']//;s/["'"'"']$//')
    
    if [ -z "$file_path" ]; then
        print_warning "未輸入檔案路徑"
        return
    fi
    
    if [ ! -f "$file_path" ]; then
        print_error "找不到檔案: $file_path"
        return
    fi
    
    echo ""
    print_info "開始處理語音檔案: $(basename "$file_path")"
    
    # 移除確認步驟，直接開始整理流程
    echo ""
    print_info "🚀 檔案檢查完成，開始整理流程..."
    
    # 直接內嵌選擇整理類型的邏輯，避免函數調用問題
    echo ""
    print_menu "📝 請選擇整理類型："
    echo ""
    print_menu "  1️⃣  重點整理 (提取要點)"
    print_menu "  2️⃣  會議紀錄 (正式格式)"
    print_menu "  3️⃣  筆記整理 (結構化)"
    print_menu "  4️⃣  摘要總結 (簡潔版)"
    echo ""
    print_menu "請選擇整理類型 (1-4): "
    
    read type_choice
    echo ""
    
    case $type_choice in
        1) summary_type="重點整理" ;;
        2) summary_type="會議紀錄" ;;
        3) summary_type="筆記整理" ;;
        4) summary_type="摘要總結" ;;
        *) 
            print_warning "無效選擇，使用預設的重點整理"
            summary_type="重點整理" 
            ;;
    esac
    
    print_success "✅ 已選擇整理類型: $summary_type"
    
    if source venv/bin/activate && python speech_to_text.py "$file_path" --summarize --type="$summary_type"; then
        echo ""
        print_success "🎉 轉錄和整理完成！"
    else
        print_error "處理失敗"
    fi
}

# 批次轉錄+整理
batch_transcribe_and_summarize() {
    echo ""
    print_info "🗂️+🤖 批次轉錄並整理"
    echo "─────────────────────────────────────────────"
    echo ""
    
    # 支援的音訊格式
    audio_extensions=("*.mp3" "*.m4a" "*.wav" "*.mp4" "*.mpeg" "*.mpga" "*.webm")
    
    # 收集所有音訊檔案
    audio_files=()
    for ext in "${audio_extensions[@]}"; do
        while IFS= read -r -d '' file; do
            audio_files+=("$file")
        done < <(find recordings -name "$ext" -type f -print0 2>/dev/null)
    done
    
    if [ ${#audio_files[@]} -eq 0 ]; then
        print_warning "recordings 資料夾中沒有找到音訊檔案"
        echo ""
        echo "支援的格式: .mp3, .m4a, .wav, .mp4, .mpeg, .mpga, .webm"
        echo "請將音訊檔案放入 recordings 資料夾後再試"
        echo ""
        print_info "💡 按任意鍵返回主選單..."
        read -n 1
        return
    fi
    
    total_files=${#audio_files[@]}
    print_info "找到 $total_files 個音訊檔案"
    echo ""
    
    # 選擇整理類型
    print_menu "📝 請選擇整理類型："
    echo ""
    print_menu "  1️⃣  重點整理 (提取要點)"
    print_menu "  2️⃣  會議紀錄 (正式格式)"
    print_menu "  3️⃣  筆記整理 (結構化)"
    print_menu "  4️⃣  摘要總結 (簡潔版)"
    echo ""
    print_menu "請選擇整理類型 (1-4): "
    
    read type_choice
    echo ""
    
    case $type_choice in
        1) summary_type="重點整理" ;;
        2) summary_type="會議紀錄" ;;
        3) summary_type="筆記整理" ;;
        4) summary_type="摘要總結" ;;
        *) 
            print_warning "無效選擇，使用預設的重點整理"
            summary_type="重點整理" 
            ;;
    esac
    
    print_success "✅ 已選擇整理類型: $summary_type"
    echo ""
    
    # 確認是否繼續
    echo "即將開始批次轉錄並整理，這可能需要較長時間..."
    read -p "是否繼續？ (y/N): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        print_info "已取消批次處理"
        return
    fi
    
    echo ""
    print_progress "開始批次處理..."
    echo ""
    
    successful=0
    failed=0
    
    # 逐一處理每個檔案
    for i in "${!audio_files[@]}"; do
        file="${audio_files[$i]}"
        current=$((i + 1))
        
        print_progress "[$current/$total_files] 轉錄並整理: $(basename "$file")"
        echo ""
        
        if source venv/bin/activate && python speech_to_text.py "$file" --summarize --type="$summary_type"; then
            ((successful++))
            print_success "✓ $(basename "$file") 處理成功"
        else
            ((failed++))
            print_error "✗ $(basename "$file") 處理失敗"
        fi
        
        echo ""
        echo "─────────────────────────────────────────────"
        echo ""
    done
    
    # 顯示統計結果
    echo -e "${BLUE}📊 批次處理完成統計:${NC}"
    echo "總檔案數: $total_files"
    echo -e "${GREEN}成功: $successful${NC}"
    echo -e "${RED}失敗: $failed${NC}"
    
    if [ $failed -eq 0 ]; then
        print_success "🎉 所有檔案都成功處理完成！"
    else
        print_warning "⚠️  部分檔案處理失敗，請檢查錯誤訊息"
    fi
    
    echo ""
    print_info "💡 按任意鍵返回主選單..."
    read -n 1
}

# 整理現有文字檔案
summarize_existing_text() {
    echo ""
    print_info "📄+🤖 整理現有文字檔案"
    echo "─────────────────────────────────────────────"
    echo ""
    
    echo "請選擇操作方式："
    echo "1️⃣  輸入文字檔案路徑"
    echo "2️⃣  選擇 recordings 資料夾中的檔案"
    echo ""
    read -p "請選擇 (1/2): " choice
    echo ""
    
    case $choice in
        1)
            echo "請輸入文字檔案路徑："
            echo "💡 提示：可以直接拖放檔案到終端機"
            echo "💡 支援格式：.txt"
            echo ""
            read -p "檔案路徑: " file_path
            
            # 移除可能的引號
            file_path=$(echo "$file_path" | sed 's/^["'"'"']//;s/["'"'"']$//')
            
            if [ -z "$file_path" ]; then
                print_warning "未輸入檔案路徑"
                return
            fi
            
            if [ ! -f "$file_path" ]; then
                print_error "找不到檔案: $file_path"
                return
            fi
            ;;
        2)
            # 尋找 recordings 資料夾中的 txt 檔案
            txt_files=()
            while IFS= read -r -d '' file; do
                txt_files+=("$file")
            done < <(find recordings -name "*.txt" -type f -print0 2>/dev/null)
            
            if [ ${#txt_files[@]} -eq 0 ]; then
                print_warning "recordings 資料夾中沒有找到文字檔案"
                echo ""
                print_info "💡 按任意鍵返回主選單..."
                read -n 1
                return
            fi
            
            echo "找到以下文字檔案："
            for i in "${!txt_files[@]}"; do
                echo "$((i + 1)). $(basename "${txt_files[$i]}")"
            done
            echo ""
            read -p "請選擇檔案編號: " file_num
            
            if [[ ! $file_num =~ ^[0-9]+$ ]] || [ $file_num -lt 1 ] || [ $file_num -gt ${#txt_files[@]} ]; then
                print_error "無效的檔案編號"
                return
            fi
            
            file_path="${txt_files[$((file_num - 1))]}"
            print_success "✅ 已選擇檔案: $(basename "$file_path")"
            ;;
        *)
            print_warning "無效的選擇"
            return
            ;;
    esac
    
    echo ""
    print_info "📖 正在讀取檔案內容..."
    
    # 檢查檔案是否可讀取且不為空
    if [ ! -r "$file_path" ]; then
        print_error "無法讀取檔案: $file_path"
        return
    fi
    
    # 顯示檔案基本資訊
    file_size=$(wc -c < "$file_path")
    line_count=$(wc -l < "$file_path")
    print_info "檔案大小: $file_size bytes"
    print_info "行數: $line_count 行"
    
    # 檢查檔案內容
    print_info "🔍 正在檢查檔案內容..."
    
    # 檢查檔案是否為空
    if [ $file_size -eq 0 ]; then
        print_error "檔案是空的"
        return
    fi
    
    # 讀取檔案內容進行檢查
    if command -v python3 >/dev/null 2>&1; then
        # 使用 Python 來檢查檔案內容
        content_info=$(python3 -c "
import sys
try:
    with open('$file_path', 'r', encoding='utf-8') as f:
        content = f.read()
    lines = content.splitlines()
    non_empty_lines = [line.strip() for line in lines if line.strip()]
    
    # 如果沒有換行符號，整個檔案是一行
    if len(lines) <= 1 and len(content.strip()) > 0:
        lines = [content.strip()]
        non_empty_lines = [content.strip()]
    
    print(f'actual_lines={len(lines)}')
    print(f'non_empty_lines={len(non_empty_lines)}')
    print(f'char_count={len(content)}')
    print(f'has_content={len(content.strip()) > 0}')
    
    # 顯示內容預覽
    preview = content.strip()[:200]
    print(f'preview={preview}')
except Exception as e:
    print(f'error={e}')
")
        
        # 解析檢查結果
        actual_lines=$(echo "$content_info" | grep "actual_lines=" | cut -d'=' -f2)
        non_empty_lines=$(echo "$content_info" | grep "non_empty_lines=" | cut -d'=' -f2)
        char_count=$(echo "$content_info" | grep "char_count=" | cut -d'=' -f2)
        has_content=$(echo "$content_info" | grep "has_content=" | cut -d'=' -f2)
        preview=$(echo "$content_info" | grep "preview=" | cut -d'=' -f2-)
        
        if [ "$has_content" = "True" ]; then
            print_info "實際內容行數: $actual_lines 行"
            print_info "非空行數: $non_empty_lines 行"
            print_info "字元數: $char_count 個"
            
            print_info "📄 檔案內容預覽："
            echo "────────────────────────────────────────"
            echo "  $preview..."
            echo "────────────────────────────────────────"
            
            # 特別處理單行文件
            if [ "$line_count" -eq 0 ] && [ "$actual_lines" -eq 1 ]; then
                print_warning "⚠️  檔案沒有換行符號，所有內容在一行"
                print_info "💡 這是常見的語音轉錄格式，可以正常整理"
            fi
            
            print_success "✅ 檔案內容正常，包含 $char_count 個字元"
        else
            print_error "檔案內容讀取失敗或為空"
            return
        fi
    else
        # 如果沒有 Python，使用傳統方法
        print_info "📄 檔案前 3 行內容預覽："
        echo "────────────────────────────────────────"
        head -n 3 "$file_path" | while IFS= read -r line; do
            if [ -n "$line" ]; then
                echo "  $line" | cut -c1-80
            else
                echo "  [空行]"
            fi
        done
        echo "────────────────────────────────────────"
        
        # 檢查是否包含中文內容
        if grep -q "[\u4e00-\u9fff]" "$file_path" 2>/dev/null; then
            print_info "✅ 檔案包含中文內容"
        else
            print_warning "⚠️  檔案可能不包含中文內容"
        fi
        
        # 檢查檔案編碼
        if command -v file >/dev/null 2>&1; then
            encoding_info=$(file -bi "$file_path")
            print_info "📝 檔案編碼: $encoding_info"
        fi
    fi
    
    # 移除確認步驟，直接開始整理流程
    echo ""
    print_info "🚀 檔案檢查完成，開始整理流程..."
    
    # 直接內嵌選擇整理類型的邏輯，避免函數調用問題
    echo ""
    print_menu "📝 請選擇整理類型："
    echo ""
    print_menu "  1️⃣  重點整理 (提取要點)"
    print_menu "  2️⃣  會議紀錄 (正式格式)"
    print_menu "  3️⃣  筆記整理 (結構化)"
    print_menu "  4️⃣  摘要總結 (簡潔版)"
    echo ""
    print_menu "請選擇整理類型 (1-4): "
    
    read type_choice
    echo ""
    
    case $type_choice in
        1) summary_type="重點整理" ;;
        2) summary_type="會議紀錄" ;;
        3) summary_type="筆記整理" ;;
        4) summary_type="摘要總結" ;;
        *) 
            print_warning "無效選擇，使用預設的重點整理"
            summary_type="重點整理" 
            ;;
    esac
    
    print_success "✅ 已選擇整理類型: $summary_type"
    
    # 選擇整理類型
    echo ""
    print_info "🎯 準備開始整理..."
    print_info "📄 檔案: $(basename "$file_path")"
    print_info "🤖 整理類型: $summary_type"
    print_info "⏳ 這可能需要一些時間，請稍候..."
    echo ""
    
    # 使用 Python 腳本的文字整理功能
    if source venv/bin/activate && python -c "
from speech_to_text import SpeechToText
import sys
try:
    stt = SpeechToText()
    result = stt.process_text_file('$file_path', '$summary_type')
    print()
    print('='*60)
    print('🤖 整理結果:')
    print('='*60)
    print(result)
    print('='*60)
except Exception as e:
    print(f'❌ 錯誤: {e}')
    sys.exit(1)
"; then
        echo ""
        print_success "🎉 文字整理完成！"
        
        # 顯示輸出檔案位置
        summary_file="${file_path%.*}.$summary_type.txt"
        print_info "📁 整理結果已儲存到: $(basename "$summary_file")"
    else
        print_error "整理失敗"
    fi
}

# 檔案診斷工具
diagnose_file_function() {
    echo ""
    print_info "🔍 檔案診斷工具"
    echo "─────────────────────────────────────────────"
    echo ""
    
    echo "請選擇診斷方式："
    echo "1️⃣  輸入檔案路徑"
    echo "2️⃣  選擇 recordings 資料夾中的檔案"
    echo ""
    read -p "請選擇 (1/2): " choice
    echo ""
    
    case $choice in
        1)
            echo "請輸入要診斷的檔案路徑："
            echo "💡 提示：可以直接拖放檔案到終端機"
            echo ""
            read -p "檔案路徑: " file_path
            
            # 移除可能的引號
            file_path=$(echo "$file_path" | sed 's/^["'"'"']//;s/["'"'"']$//')
            
            if [ -z "$file_path" ]; then
                print_warning "未輸入檔案路徑"
                return
            fi
            
            if [ ! -f "$file_path" ]; then
                print_error "找不到檔案: $file_path"
                return
            fi
            ;;
        2)
            # 尋找所有檔案 (不限於 txt)
            all_files=()
            while IFS= read -r -d '' file; do
                all_files+=("$file")
            done < <(find recordings -type f -print0 2>/dev/null)
            
            if [ ${#all_files[@]} -eq 0 ]; then
                print_warning "recordings 資料夾中沒有找到檔案"
                echo ""
                print_info "💡 按任意鍵返回主選單..."
                read -n 1
                return
            fi
            
            echo "找到以下檔案："
            for i in "${!all_files[@]}"; do
                echo "$((i + 1)). $(basename "${all_files[$i]}")"
            done
            echo ""
            read -p "請選擇檔案編號: " file_num
            
            if [[ ! $file_num =~ ^[0-9]+$ ]] || [ $file_num -lt 1 ] || [ $file_num -gt ${#all_files[@]} ]; then
                print_error "無效的檔案編號"
                return
            fi
            
            file_path="${all_files[$((file_num - 1))]}"
            ;;
        *)
            print_warning "無效的選擇"
            return
            ;;
    esac
    
    echo ""
    print_info "🔍 開始診斷檔案: $(basename "$file_path")"
    echo ""
    
    # 使用 Python 診斷腳本
    if source venv/bin/activate && python debug_file.py "$file_path"; then
        echo ""
        print_success "✅ 診斷完成"
    else
        print_error "診斷失敗"
    fi
}

# 主程式邏輯
main() {
    # 如果有參數，直接執行對應功能（向後相容）
    if [ $# -gt 0 ]; then
        # 先進行環境檢查
        show_title
        check_environment
        
        if [ "$1" = "recordings" ] || [ "$1" = "batch" ]; then
            process_recordings_folder
            exit 0
        else
            # 單一檔案轉錄
            AUDIO_FILE="$1"
            if [ ! -f "$AUDIO_FILE" ]; then
                print_error "找不到檔案: $AUDIO_FILE"
                exit 1
            fi
            
            print_info "開始處理語音檔案: $AUDIO_FILE"
            echo ""
            source venv/bin/activate && python speech_to_text.py "$AUDIO_FILE"
            echo ""
            print_success "🎉 轉錄完成！"
            exit 0
        fi
    fi
    
    # 互動式選單模式
    while true; do
        show_title
        
        # 第一次進入時進行環境檢查
        if [ ! -f ".env_checked" ]; then
            check_environment
            touch .env_checked
            print_success "✅ 環境檢查完成"
        fi
        
        show_main_menu
        read -n 1 choice
        echo ""
        
        case $choice in
            1)
                single_file_transcription
                echo ""
                print_info "💡 按任意鍵繼續..."
                read -n 1
                ;;
            2)
                process_recordings_folder
                ;;
            3)
                transcribe_and_summarize_single
                echo ""
                print_info "💡 按任意鍵繼續..."
                read -n 1
                ;;
            4)
                batch_transcribe_and_summarize
                ;;
            5)
                summarize_existing_text
                echo ""
                print_info "💡 按任意鍵繼續..."
                read -n 1
                ;;
            6)
                diagnose_file_function
                echo ""
                print_info "💡 按任意鍵繼續..."
                read -n 1
                ;;
            7)
                show_system_status
                ;;
            8)
                show_help
                ;;
            0)
                echo ""
                print_success "👋 謝謝使用！"
                exit 0
                ;;
            *)
                echo ""
                print_warning "無效的選項，請輸入 0-8"
                echo ""
                print_info "💡 按任意鍵繼續..."
                read -n 1
                ;;
        esac
    done
}

# 執行主程式
main "$@" 