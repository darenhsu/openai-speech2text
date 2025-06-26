@echo off
chcp 65001 >nul
title iPhone 語音轉文字工具 - 一鍵安裝

:: iPhone 語音轉文字工具 - Windows 一鍵安裝腳本
:: OpenAI Speech-to-Text Tool Installer for Windows

echo.
echo ============================================
echo 🎤 iPhone 語音轉文字工具 - 一鍵安裝
echo ============================================
echo.
echo 此工具將幫您自動安裝所有必要的環境和依賴
echo 包含 OpenAI Whisper API 語音轉錄功能
echo 以及 ChatGPT 智能文字整理功能
echo.
echo ⚠️  安裝前請確保您有穩定的網路連線
echo.
pause

echo.
echo 🔧 開始安裝...
echo.

:: 檢查 Python
echo 🔧 檢查 Python 環境...
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ 未找到 Python
    echo ℹ️  請先安裝 Python 3.8 或更新版本:
    echo    • 從官網下載: https://www.python.org/downloads/
    echo    • 安裝時記得勾選 "Add Python to PATH"
    pause
    exit /b 1
) else (
    echo ✅ 找到 Python
    python --version
)

:: 檢查 pip
echo.
echo 🔧 檢查 pip...
pip --version >nul 2>&1
if errorlevel 1 (
    echo ❌ 未找到 pip
    echo ℹ️  嘗試安裝 pip...
    python -m ensurepip --upgrade
) else (
    echo ✅ 找到 pip
)

:: 創建虛擬環境
echo.
echo 🔧 創建 Python 虛擬環境...
if exist venv (
    echo ⚠️  虛擬環境已存在，將重新創建...
    rmdir /s /q venv
)
python -m venv venv
if exist venv (
    echo ✅ 虛擬環境創建成功
) else (
    echo ❌ 虛擬環境創建失敗
    pause
    exit /b 1
)

:: 啟動虛擬環境並安裝依賴
echo.
echo 🔧 啟動虛擬環境並安裝依賴...
call venv\Scripts\activate.bat

echo ℹ️  升級 pip...
python -m pip install --upgrade pip

echo ℹ️  安裝 OpenAI 套件...
pip install openai

echo ℹ️  安裝 python-dotenv...
pip install python-dotenv

echo ✅ 所有依賴安裝完成

:: 創建必要目錄
echo.
echo 🔧 設置目錄結構...
if not exist recordings mkdir recordings
echo ✅ 創建 recordings 資料夾

:: 創建 .env.example
if not exist .env.example (
    echo # OpenAI API 金鑰設定 > .env.example
    echo # 請到 https://platform.openai.com/api-keys 取得您的 API 金鑰 >> .env.example
    echo # 然後複製這個檔案為 .env 並填入真實的金鑰 >> .env.example
    echo. >> .env.example
    echo OPENAI_API_KEY=your_openai_api_key_here >> .env.example
    echo ✅ 創建 .env.example 檔案
)

:: 驗證安裝
echo.
echo 🔧 驗證安裝...
call venv\Scripts\activate.bat
pip show openai >nul 2>&1
if errorlevel 1 (
    echo ❌ OpenAI 套件: 失敗
    pause
    exit /b 1
) else (
    echo ✅ OpenAI 套件: OK
)

pip show python-dotenv >nul 2>&1
if errorlevel 1 (
    echo ❌ python-dotenv: 失敗
    pause
    exit /b 1
) else (
    echo ✅ python-dotenv: OK
)

:: 檢查主要檔案
if exist speech_to_text.py (
    echo ✅ 主程式: OK
) else (
    echo ❌ 主程式: 缺少 speech_to_text.py
    pause
    exit /b 1
)

:: 顯示完成訊息
echo.
echo ============================================
echo 🎉 安裝完成！
echo ============================================
echo.
echo ✅ iPhone 語音轉文字工具已成功安裝！
echo.
echo 📋 接下來的步驟：
echo.
echo 🔧 1. 設定 OpenAI API 金鑰：
echo    • 複製 .env.example 為 .env：
echo      copy .env.example .env
echo.
echo    • 編輯 .env 檔案，填入您的 OpenAI API 金鑰
echo      notepad .env
echo.
echo    • 到這裡取得 API 金鑰: https://platform.openai.com/api-keys
echo.
echo 🔧 2. 開始使用：
echo    • 雙擊 start.bat 啟動工具
echo    • 或在命令列執行: python speech_to_text.py your_audio_file.m4a
echo.
echo 🔧 3. 功能介紹：
echo    • 🎤 單一檔案轉錄
echo    • 🗂️ 批次轉錄處理
echo    • 🤖 ChatGPT 智能整理 (重點整理、會議紀錄、筆記整理、摘要總結)
echo    • 📁 檔案診斷工具
echo    • 📋 互動式選單界面
echo.
echo 🔧 4. 支援的音訊格式：
echo    • iPhone 錄音: .m4a
echo    • 其他格式: .mp3, .wav, .mp4, .mpeg, .mpga, .webm
echo.
echo ⚠️  注意事項：
echo    • 需要穩定的網路連線 (使用 OpenAI API)
echo    • 音訊檔案大小限制: 25MB
echo    • 使用會產生 API 費用，請查看 OpenAI 定價
echo.
echo 準備好開始了嗎？
echo.
pause 