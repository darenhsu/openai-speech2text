# iPhone 語音轉文字工具

使用 OpenAI Whisper API 將 iPhone 錄音檔案轉換為文字的 Python 工具。

## 📦 快速安裝

### 🎯 一鍵安裝（推薦新用戶）

**macOS/Linux 用戶**：
```bash
./install.sh
```

**Windows 用戶**：
雙擊 `install.bat`

📖 **完整安裝指南**: [INSTALL.md](INSTALL.md)

### ⚡ 直接使用（已安裝用戶）

```bash
./start.sh  # 啟動互動式選單
```

---

## 🚀 互動式選單界面

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
  3️⃣  轉錄+整理 (單一檔案)
  4️⃣  批次轉錄+整理
  5️⃣  整理現有文字檔案
  6️⃣  查看系統狀態
  7️⃣  說明與幫助
  0️⃣  退出程式

請輸入選項 (0-7): 
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
- 🤖 **ChatGPT 智能整理**: 自動整理轉錄內容成結構化格式
- 📝 **多種整理模式**: 重點整理、會議紀錄、筆記整理、摘要總結
- 💾 自動儲存轉錄結果到文字檔案
- 📏 自動檢查檔案大小 (OpenAI 限制 25MB)
- 🚀 簡單易用的互動式選單界面

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
# 基本轉錄
python speech_to_text.py recording.m4a

# 轉錄+自動整理
python speech_to_text.py recording.m4a --summarize

# 指定整理類型
python speech_to_text.py recording.m4a --summarize --type=會議紀錄
python speech_to_text.py recording.m4a --summarize --type=重點整理
python speech_to_text.py recording.m4a --summarize --type=筆記整理
python speech_to_text.py recording.m4a --summarize --type=摘要總結
```

### Python 程式中使用
```python
from speech_to_text import SpeechToText

# 建立實例
stt = SpeechToText()

# 基本轉錄
text, _ = stt.process_file("recording.m4a")
print(text)

# 轉錄+自動整理
text, summary = stt.process_file("recording.m4a", auto_summarize=True, summary_type="重點整理")
print("原始轉錄:", text)
print("整理結果:", summary)

# 只整理現有文字檔案
summary = stt.process_text_file("recording.txt", "會議紀錄")
print("整理結果:", summary)
```

## 🤖 ChatGPT 智能整理功能

### 整理類型說明
- **🎯 重點整理**: 提取主要觀點和重要資訊，整理成條列式要點
- **📝 會議紀錄**: 將內容整理成正式的會議記錄格式，包含議題、決議和行動項目
- **📚 筆記整理**: 按主題分類整理，適合學習和知識管理
- **📋 摘要總結**: 用 2-3 段文字簡潔總結主要內容

### 使用方式
1. **轉錄+整理一體化**: 選擇選單的 3️⃣ 或 4️⃣ 選項
2. **只整理現有文字**: 選擇選單的 5️⃣ 選項
3. **命令列整理**: 使用 `--summarize` 參數

### 輸出檔案
- **原始轉錄**: `檔名.txt`
- **整理結果**: `檔名.重點整理.txt` (依選擇的類型命名)

### 使用範例
```bash
# 通過選單選擇整理類型
./start.sh  # 選擇 3️⃣ 轉錄+整理

# 命令列指定整理類型
python speech_to_text.py meeting.m4a --summarize --type=會議紀錄
```

## 📁 批次處理功能

### 使用 recordings 資料夾
1. 將多個音訊檔案放入 `recordings/` 資料夾
2. 執行批次轉錄：
   ```bash
   ./start.sh recordings  # 只轉錄
   ```
3. 或選擇選單的 4️⃣ 選項進行批次轉錄+整理

### 批次處理特色
- 🔍 **自動掃描**：找到所有支援的音訊檔案
- 📊 **進度顯示**：即時顯示處理進度 (1/5, 2/5...)
- 🛡️ **錯誤處理**：單一檔案失敗不影響其他檔案
- 📈 **統計報告**：完成後顯示成功/失敗統計
- 🤖 **智能整理**：可選擇統一的整理類型套用到所有檔案
- 🔒 **安全性**：recordings 資料夾內容不會被 git 上傳

## 支援的檔案格式

- **iPhone 錄音**: `.m4a` (主要格式)
- **其他音訊**: `.mp3`, `.wav`, `.mp4`, `.mpeg`, `.mpga`, `.webm`

## 輸出結果

### 基本轉錄
- **控制台顯示**: 轉錄完成後會在控制台顯示結果
- **文字檔案**: 自動儲存到與原檔案同名的 `.txt` 檔案

### 智能整理 (使用 `--summarize` 或選單選項)
- **原始轉錄檔**: `檔名.txt` - 完整的語音轉錄內容
- **整理後檔案**: `檔名.整理類型.txt` - ChatGPT 整理後的結構化內容
- **控制台顯示**: 同時顯示原始轉錄和整理結果

範例輸出檔案：
```
meeting_20240101.m4a          # 原始音訊檔案
├── meeting_20240101.txt      # 原始轉錄
└── meeting_20240101.會議紀錄.txt  # 整理後內容
```

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