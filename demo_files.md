# 📁 iPhone 語音轉文字工具 - 安裝檔案說明

## 🎯 安裝相關檔案

### macOS/Linux 用戶
- **`install.sh`** - Unix/Linux 一鍵安裝腳本
- **`start.sh`** - Unix/Linux 啟動腳本

### Windows 用戶  
- **`install.bat`** - Windows 一鍵安裝腳本
- **`start.bat`** - Windows 啟動腳本

### 通用檔案
- **`requirements.txt`** - Python 套件依賴清單
- **`.env.example`** - 環境變數範例檔案
- **`INSTALL.md`** - 詳細安裝指南

## 🚀 使用方式

### 首次安裝

**macOS/Linux:**
```bash
# 1. 設置執行權限並安裝
chmod +x install.sh
./install.sh

# 2. 設定 API 金鑰
cp .env.example .env
nano .env  # 填入您的 OpenAI API 金鑰

# 3. 開始使用
./start.sh
```

**Windows:**
```cmd
# 1. 雙擊安裝
install.bat

# 2. 設定 API 金鑰
copy .env.example .env
notepad .env

# 3. 開始使用
start.bat
```

### 已安裝用戶

**macOS/Linux:**
```bash
./start.sh
```

**Windows:**
```cmd
start.bat
```

## ✨ 特色功能

### 一鍵安裝腳本特色
- ✅ 自動檢測作業系統
- ✅ 驗證 Python 環境和版本
- ✅ 自動建立虛擬環境
- ✅ 安裝所需套件
- ✅ 建立必要目錄結構
- ✅ 設置執行權限
- ✅ 驗證安裝結果
- ✅ 提供完整的後續步驟指導

### 啟動腳本特色
- ✅ 自動啟動虛擬環境
- ✅ 檢查 API 金鑰設定
- ✅ 支援命令列參數
- ✅ 友善的錯誤提示

## 🔧 技術細節

### 安裝腳本做了什麼？

1. **環境檢查**
   - 檢測作業系統類型
   - 驗證 Python 3.8+ 版本
   - 確認 pip 可用性

2. **環境建立**
   - 建立 Python 虛擬環境
   - 升級 pip 到最新版本
   - 安裝 OpenAI 和 python-dotenv 套件

3. **檔案設置**
   - 建立 recordings 目錄
   - 產生 .env.example 範例檔案
   - 設置適當的 .gitignore 規則

4. **權限設置**
   - 為腳本檔案設置執行權限
   - 確保檔案結構正確

5. **驗證測試**
   - 測試虛擬環境
   - 驗證套件安裝
   - 檢查主要程式檔案

### 啟動腳本做了什麼？

1. **環境檢查**
   - 檢查虛擬環境是否存在
   - 驗證 .env 檔案設定
   - 提供設定指導

2. **程式啟動**
   - 啟動虛擬環境
   - 執行主程式
   - 支援命令列參數傳遞

## 🛡️ 安全性

- `.env` 檔案包含在 .gitignore 中，不會被版本控制
- API 金鑰保存在本地環境變數中
- 虛擬環境隔離避免系統套件衝突

## 📞 支援

如果遇到安裝問題：
1. 查看 [INSTALL.md](INSTALL.md) 詳細指南
2. 檢查系統需求是否符合
3. 確認網路連線正常
4. 嘗試手動安裝步驟 