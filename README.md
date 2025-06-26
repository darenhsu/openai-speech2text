# iPhone 語音轉文字工具

使用 OpenAI Whisper API 將 iPhone 錄音檔案轉換為文字的 Python 工具。

## 🚀 一鍵執行 (推薦)

### 互動式選單（全新功能！）

```bash
# 1. 下載或複製這個專案
git clone https://github.com/your-repo/openai-speech2text.git
cd openai-speech2text

# 2. 啟動互動式選單
./start.sh
```

選單界面：
```
🎤 iPhone 語音轉文字工具
==========================

📋 請選擇操作：

  1️⃣  轉錄單一檔案
  2️⃣  批次轉錄 recordings 資料夾
  3️⃣  查看系統狀態
  4️⃣  說明與幫助
  0️⃣  退出程式

請輸入選項 (0-4): 
```

### 傳統命令列（向後相容）

```bash
# 直接轉錄單一檔案
./start.sh your_recording.m4a

# 直接批次轉錄 recordings 資料夾
./start.sh recordings
```

腳本會自動：
- ✅ 檢查 Python 環境
- ✅ 建立虛擬環境
- ✅ 安裝必要套件  
- ✅ 檢查 API 金鑰設定
- ✅ 執行語音轉文字

## 功能特色

- 🎤 支援 iPhone 錄音格式 (.m4a)
- 🎵 支援多種音訊格式 (mp3, wav, mp4, mpeg, mpga, webm)
- 🇨🇳 優化中文語音辨識
- 💾 自動儲存轉錄結果到文字檔案
- 📏 自動檢查檔案大小 (OpenAI 限制 25MB)
- 🚀 簡單易用的命令列介面

## 手動安裝 (進階使用者)

### 1. 安裝 Python 套件

使用虛擬環境 (建議):
```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

或直接安裝:
```bash
pip install openai python-dotenv
```

### 2. 設定 OpenAI API 金鑰

1. 到 [OpenAI Platform](https://platform.openai.com/api-keys) 取得 API 金鑰
2. 複製 `.env.example` 到 `.env`：
   ```bash
   cp .env.example .env
   ```
3. 編輯 `.env` 檔案，填入您的 API 金鑰：
   ```bash
   # 在 .env 檔案中，將這行
   OPENAI_API_KEY=your_openai_api_key_here
   
   # 改成
   OPENAI_API_KEY=sk-your-actual-api-key-here
   ```

⚠️ **重要安全提醒**：
- `.env` 檔案已設定為被 git 忽略，不會被上傳到版本控制
- 請勿將包含真實 API 金鑰的 `.env` 檔案分享給他人
- 使用 `.env.example` 作為範本分享給其他人

### 3. 使用工具

```bash
# 啟動虛擬環境 (如果使用的話)
source venv/bin/activate

# 轉錄語音檔案
python speech_to_text.py your_recording.m4a
```

## 使用範例

### 一鍵執行 (推薦)
```bash
# 轉錄單一檔案
./start.sh recording.m4a

# 批次轉錄整個資料夾
./start.sh recordings
./start.sh batch           # 別名
```

### 命令列使用
```bash
python speech_to_text.py recording.m4a
```

### Python 程式中使用
```python
from speech_to_text import SpeechToText

# 建立實例
stt = SpeechToText()

# 轉錄檔案
text = stt.process_file("recording.m4a")
print(text)
```

## 📁 批次處理功能

### 使用 recordings 資料夾
1. 將多個音訊檔案放入 `recordings/` 資料夾
2. 執行批次轉錄：
   ```bash
   ./start.sh recordings
   ```

### 批次處理特色
- 🔍 **自動掃描**：找到所有支援的音訊檔案
- 📊 **進度顯示**：即時顯示處理進度 (1/5, 2/5...)
- 🛡️ **錯誤處理**：單一檔案失敗不影響其他檔案
- 📈 **統計報告**：完成後顯示成功/失敗統計
- 🔒 **安全性**：recordings 資料夾內容不會被 git 上傳

## 支援的檔案格式

- **iPhone 錄音**: `.m4a` (主要格式)
- **其他音訊**: `.mp3`, `.wav`, `.mp4`, `.mpeg`, `.mpga`, `.webm`

## 輸出結果

- **控制台顯示**: 轉錄完成後會在控制台顯示結果
- **文字檔案**: 自動儲存到與原檔案同名的 `.txt` 檔案

## 設定檢查

執行設定檢查腳本:
```bash
python setup.py
```

這會檢查:
- ✅ Python 套件是否已安裝
- ✅ .env 檔案是否存在
- 💡 提供設定指導

## 注意事項

- 📁 **檔案大小限制**: 25MB (OpenAI API 限制)
- 🌐 **需要網路連線**: 使用 OpenAI API
- 💰 **API 費用**: 使用會產生費用，請查看 [OpenAI 定價](https://openai.com/pricing)
- 🔑 **API 金鑰**: 需要有效的 OpenAI API 金鑰

## 錯誤排除

### ❌ API 金鑰錯誤
檢查 `.env` 檔案中的 `OPENAI_API_KEY` 是否正確設定。

### ❌ 檔案格式不支援
雖然工具支援多種格式，但如果遇到問題，建議先轉換為 `.mp3` 格式。

### ❌ 檔案太大
OpenAI 限制檔案大小為 25MB，請壓縮或裁剪音訊檔案。

### ❌ 缺少套件
確保在正確的環境中安裝了所需套件:
```bash
pip install -r requirements.txt
```

## 授權

請參考 LICENSE 檔案。 