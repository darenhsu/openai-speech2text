@echo off
chcp 65001 >nul
title iPhone 語音轉文字工具

:: iPhone 語音轉文字工具 - Windows 啟動腳本

:: 檢查虛擬環境
if not exist venv (
    echo ❌ 虛擬環境不存在，請先執行 install.bat
    pause
    exit /b 1
)

:: 啟動虛擬環境
call venv\Scripts\activate.bat

:: 檢查 .env 檔案
if not exist .env (
    echo ❌ 未找到 .env 檔案
    echo ℹ️  請先設定 OpenAI API 金鑰：
    echo    1. 複製 .env.example 為 .env：
    echo       copy .env.example .env
    echo    2. 編輯 .env 檔案，填入您的 API 金鑰
    echo    3. 取得 API 金鑰: https://platform.openai.com/api-keys
    pause
    exit /b 1
)

:: 執行主程式
if "%1"=="" (
    python speech_to_text.py
) else (
    python speech_to_text.py "%1"
)

pause 