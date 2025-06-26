# 🚀 快速開始指南

## 三步驟完成語音轉文字

### 第一步：取得程式碼
```bash
# 如果你有 git
git clone https://github.com/your-repo/openai-speech2text.git
cd openai-speech2text

# 或者直接下載壓縮檔並解壓縮
```

### 第二步：一鍵設定
```bash
./start.sh
```

首次執行會看到：
```
🎤 iPhone 語音轉文字工具
==========================
ℹ️  Python3 已安裝 ✓
ℹ️  建立 Python 虛擬環境...
✅ 虛擬環境建立完成
ℹ️  啟動虛擬環境...
✅ Python 套件已安裝
❌ 請先設定 OpenAI API 金鑰！

步驟：
1. 到 https://platform.openai.com/api-keys 取得 API 金鑰
2. 編輯 .env 檔案，將 your_openai_api_key_here 替換為您的金鑰
```

### 第三步：設定 API 金鑰
1. 到 [OpenAI Platform](https://platform.openai.com/api-keys) 取得 API 金鑰
2. 編輯 `.env` 檔案：
   ```bash
   # 將這行
   OPENAI_API_KEY=your_openai_api_key_here
   
   # 改成
   OPENAI_API_KEY=sk-你的實際金鑰
   ```

### 完成！開始使用
```bash
# 轉錄 iPhone 錄音
./start.sh recording.m4a

# 轉錄其他音訊檔案
./start.sh voice_memo.mp3
```

## 🎯 使用範例

轉錄成功會看到：
```
🎤 iPhone 語音轉文字工具
==========================
ℹ️  Python3 已安裝 ✓
ℹ️  虛擬環境已存在 ✓
ℹ️  啟動虛擬環境...
✅ Python 套件已安裝
✅ API 金鑰已設定
ℹ️  開始處理語音檔案: recording.m4a

🎤 正在轉錄: recording.m4a
📁 檔案大小: 2.3MB
⏳ 請稍候...
✅ 轉錄完成！文字已儲存到: recording.txt

============================================================
🎯 轉錄結果:
============================================================
這是您的語音轉錄內容...
============================================================

🎉 轉錄完成！
```

## 💡 小提示

- 支援拖放：可以直接把音訊檔案拖到終端機
- 批次處理：可以寫簡單的 loop 來處理多個檔案
- 檔案大小：建議壓縮大檔案以節省 API 費用 