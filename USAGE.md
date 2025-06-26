# 📖 完整使用指南

## 🎯 快速開始

### 最簡單的方式
```bash
# 1. 取得專案
git clone https://github.com/your-repo/openai-speech2text.git
cd openai-speech2text

# 2. 設定環境 (第一次執行)
./start.sh

# 3. 按提示設定 OpenAI API 金鑰

# 4. 開始使用！
./start.sh your_recording.m4a
```

## 📁 三種使用方式

### 1️⃣ 單一檔案轉錄
```bash
# 轉錄當前目錄的檔案
./start.sh recording.m4a

# 轉錄其他路徑的檔案
./start.sh /path/to/voice.mp3
./start.sh ~/Downloads/meeting.wav
```

### 2️⃣ 批次轉錄 (推薦用於多檔案)
```bash
# 步驟 1: 將檔案放入 recordings 資料夾
cp *.m4a recordings/

# 步驟 2: 批次轉錄
./start.sh recordings
# 或使用別名
./start.sh batch
```

### 3️⃣ Python 程式調用
```python
from speech_to_text import SpeechToText

stt = SpeechToText()
text = stt.process_file("recording.m4a")
print(text)
```

## 🎨 批次處理功能詳解

### 資料夾結構
```
recordings/
├── .gitkeep          # 保持資料夾存在
├── README.md         # 使用說明
├── voice_001.m4a     # 你的音訊檔案
├── voice_001.txt     # 轉錄結果 (自動生成)
├── meeting.mp3       # 另一個音訊檔案
└── meeting.txt       # 對應的轉錄結果
```

### 批次處理流程
1. **掃描階段**：自動找到所有支援的音訊檔案
2. **處理階段**：逐一轉錄，顯示進度
3. **統計階段**：顯示成功/失敗數量

### 進度顯示範例
```
🎤 iPhone 語音轉文字工具
==========================
ℹ️  開始批次處理 recordings 資料夾...
ℹ️  找到 3 個音訊檔案

🔄 [1/3] 處理: voice_001.m4a
🎤 正在轉錄: voice_001.m4a
📁 檔案大小: 2.1MB
⏳ 請稍候...
✅ 轉錄完成！文字已儲存到: recordings/voice_001.txt
✅ ✓ voice_001.m4a 轉錄成功

─────────────────────────────────────────────

🔄 [2/3] 處理: meeting.mp3
...

📊 批次處理完成統計:
總檔案數: 3
成功: 3
失敗: 0
✅ 🎉 所有檔案都成功轉錄完成！
```

## 🔧 進階設定

### 環境變數 (.env)
```bash
# 必要設定
OPENAI_API_KEY=sk-your-actual-api-key-here

# 可選設定
DEFAULT_LANGUAGE=zh    # 預設語言
```

### 支援的語言代碼
- `zh` - 中文 (預設)
- `en` - 英文
- `ja` - 日文
- `ko` - 韓文
- 更多語言請參考 OpenAI 文檔

## 📊 檔案格式和限制

### 支援的格式
| 格式 | 說明 | iPhone 錄音 |
|------|------|-------------|
| .m4a | iPhone 預設格式 | ✅ |
| .mp3 | 常見音訊格式 | ✅ |
| .wav | 無損音訊格式 | ✅ |
| .mp4 | 視訊檔案 (只處理音軌) | ✅ |
| .mpeg | MPEG 音訊 | ✅ |
| .mpga | MPEG 音訊 | ✅ |
| .webm | Web 音訊格式 | ✅ |

### 限制
- **檔案大小**：最大 25MB (OpenAI API 限制)
- **網路連線**：需要穩定的網路連線
- **API 費用**：按使用量收費

## 🔒 安全性

### Git 保護
- ✅ `.env` 檔案不會被上傳
- ✅ `recordings/` 中的音訊檔案不會被上傳
- ✅ 轉錄結果 `.txt` 檔案不會被上傳
- ✅ 只有程式碼和說明檔案會被版本控制

### API 金鑰安全
- ✅ 自動檢查是否為範例金鑰
- ✅ 詳細的安全說明文檔
- ✅ 意外提交的應急處理步驟

## 🆘 錯誤排除

### 常見問題

**Q: 執行 `./start.sh` 時顯示 "command not found"**
```bash
# 解決方法：給予執行權限
chmod +x start.sh
```

**Q: API 金鑰錯誤**
```bash
# 檢查 .env 檔案是否正確設定
cat .env
# 確保格式為：OPENAI_API_KEY=sk-your-actual-key
```

**Q: 檔案格式不支援**
```bash
# 轉換為支援的格式 (使用 ffmpeg)
ffmpeg -i input.aac -codec:a libmp3lame output.mp3
```

**Q: 檔案太大**
```bash
# 壓縮音訊檔案
ffmpeg -i input.m4a -b:a 64k output.m4a
```

## 💡 使用技巧

### 最佳實踐
1. **批次處理**：多個檔案時使用 `./start.sh recordings`
2. **檔案命名**：使用描述性的檔案名稱
3. **檔案壓縮**：大檔案建議先壓縮
4. **網路穩定**：確保網路連線穩定

### 節省費用
1. **壓縮音訊**：較低的位元率可以節省費用
2. **剪輯檔案**：移除不需要的靜音部分
3. **批次處理**：一次處理多個檔案更有效率

## 📞 支援

如有問題，請參考：
- `README.md` - 基本使用說明
- `SECURITY.md` - 安全配置
- `quick_start.md` - 快速開始指南
- `recordings/README.md` - 批次處理說明 