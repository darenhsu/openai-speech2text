# 🚀 iPhone 語音轉文字工具 - 安裝指南

## 📋 一鍵安裝（推薦）

### macOS / Linux 用戶

1. **下載或克隆專案**
   ```bash
   git clone [repository_url]
   # 或直接下載 ZIP 檔案並解壓縮
   ```

2. **執行一鍵安裝**
   ```bash
   cd openai-speech2text
   ./install.sh
   ```

3. **設定 API 金鑰**
   ```bash
   cp .env.example .env
   nano .env  # 編輯並填入您的 OpenAI API 金鑰
   ```

4. **開始使用**
   ```bash
   ./start.sh
   ```

### Windows 用戶

1. **下載專案檔案**
   - 下載 ZIP 檔案並解壓縮到您的電腦

2. **執行一鍵安裝**
   - 雙擊 `install.bat`
   - 或在命令提示字元中執行：
     ```cmd
     install.bat
     ```

3. **設定 API 金鑰**
   ```cmd
   copy .env.example .env
   notepad .env
   ```

4. **開始使用**
   - 雙擊 `start.bat`

---

## 🔧 手動安裝

如果一鍵安裝遇到問題，可以手動安裝：

### 前置需求

- **Python 3.8+**
  - macOS: `brew install python3`
  - Ubuntu/Debian: `sudo apt install python3 python3-pip python3-venv`
  - Windows: 從 [python.org](https://python.org) 下載安裝
- **穩定的網路連線**（用於 OpenAI API 呼叫）

### 安裝步驟

1. **創建虛擬環境**
   ```bash
   python3 -m venv venv
   ```

2. **啟動虛擬環境**
   ```bash
   # macOS/Linux
   source venv/bin/activate
   
   # Windows
   venv\Scripts\activate
   ```

3. **安裝依賴**
   ```bash
   pip install -r requirements.txt
   ```

4. **設定環境變數**
   ```bash
   cp .env.example .env
   # 編輯 .env 檔案，填入您的 OpenAI API 金鑰
   ```

5. **創建必要目錄**
   ```bash
   mkdir -p recordings
   ```

---

## 🔑 OpenAI API 金鑰設定

1. **取得 API 金鑰**
   - 前往 [OpenAI API Keys](https://platform.openai.com/api-keys)
   - 登入您的 OpenAI 帳號
   - 點擊「Create new secret key」
   - 複製產生的金鑰

2. **設定環境變數**
   - 編輯 `.env` 檔案
   - 將 `your_openai_api_key_here` 替換為您的實際 API 金鑰
   - 例如：`OPENAI_API_KEY=sk-abcd1234...`

3. **確認設定**
   - 執行工具時會自動檢查 API 金鑰
   - 如果設定錯誤會顯示相應的錯誤訊息

---

## 🚨 常見問題排除

### Python 相關問題

**Q: 找不到 Python 命令**
```bash
# macOS (使用 Homebrew)
brew install python3

# Ubuntu/Debian
sudo apt update
sudo apt install python3 python3-pip python3-venv

# CentOS/RHEL
sudo yum install python3 python3-pip
```

**Q: pip 安裝失敗**
```bash
# 升級 pip
python3 -m pip install --upgrade pip

# 使用國內鏡像（中國大陸用戶）
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple openai python-dotenv
```

### API 相關問題

**Q: OpenAI API 金鑰錯誤**
- 確認 `.env` 檔案格式正確
- 檢查 API 金鑰是否有效
- 確認 OpenAI 帳號有足夠的額度

**Q: 網路連線問題**
- 確認網路連線正常
- 檢查防火牆設定
- 嘗試使用 VPN（如果需要）

### 檔案權限問題

**Q: 權限被拒絕 (Permission denied)**
```bash
# 給予執行權限
chmod +x install.sh start.sh

# 檢查目錄權限
ls -la
```

---

## 📊 系統需求

| 項目 | 需求 |
|------|------|
| 作業系統 | macOS 10.14+, Ubuntu 18.04+, Windows 10+ |
| Python | 3.8 或更新版本 |
| 記憶體 | 至少 512MB |
| 儲存空間 | 至少 100MB（不含音訊檔案） |
| 網路 | 穩定的網路連線 |

---

## 📞 技術支援

如果安裝過程中遇到問題：

1. 檢查本文件的「常見問題排除」段落
2. 確認系統需求是否符合
3. 查看錯誤訊息並參考相應的解決方案
4. 嘗試手動安裝步驟

---

## 🎯 安裝成功確認

安裝完成後，您應該能夠：

- ✅ 執行 `./start.sh`（Linux/macOS）或雙擊 `start.bat`（Windows）
- ✅ 看到工具的主選單界面
- ✅ 成功轉錄音訊檔案
- ✅ 使用 ChatGPT 整理功能

如果以上功能都正常，恭喜您安裝成功！🎉 