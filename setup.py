#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
快速設定腳本
"""

import os
import sys
from pathlib import Path

def create_env_file():
    """建立 .env 檔案"""
    env_content = """# OpenAI API 金鑰
# 請到 https://platform.openai.com/api-keys 取得您的 API 金鑰
OPENAI_API_KEY=your_openai_api_key_here"""
    
    env_path = Path('.env')
    if env_path.exists():
        print("⚠️  .env 檔案已存在")
        return
    
    with open(env_path, 'w', encoding='utf-8') as f:
        f.write(env_content)
    
    print("✅ 已建立 .env 檔案")
    print("🔑 請編輯 .env 檔案，填入您的 OpenAI API 金鑰")

def check_dependencies():
    """檢查依賴是否已安裝"""
    try:
        import openai
        import dotenv
        print("✅ 所有 Python 套件已安裝")
        return True
    except ImportError as e:
        print(f"❌ 缺少套件: {e}")
        print("📦 請執行: pip install -r requirements.txt")
        print("💡 建議使用虛擬環境:")
        print("   python3 -m venv venv")
        print("   source venv/bin/activate")
        print("   pip install -r requirements.txt")
        return False

def main():
    """主函式"""
    print("🎤 iPhone 語音轉文字工具 - 設定檢查")
    print("=" * 40)
    
    # 建立 .env 檔案
    create_env_file()
    print()
    
    # 檢查依賴
    deps_ok = check_dependencies()
    print()
    
    # 總結
    if deps_ok:
        print("🎉 Python 套件設定完成！")
        print("📝 接下來請:")
        print("   1. 編輯 .env 檔案，填入您的 OpenAI API 金鑰")
        print("   2. 到 https://platform.openai.com/api-keys 取得金鑰")
        print("🚀 使用方法: python speech_to_text.py your_recording.m4a")
        print("\n📋 支援的檔案格式: .mp3, .m4a, .wav, .mp4, .mpeg, .mpga, .webm")
    else:
        print("⚠️  請先安裝必要的套件後再使用")

if __name__ == "__main__":
    main() 