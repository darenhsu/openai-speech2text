#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
檔案診斷工具
用於檢查文字檔案的編碼、格式和內容問題
"""

import sys
import os
from pathlib import Path

def diagnose_file(file_path):
    """診斷檔案問題"""
    file_path = Path(file_path)
    
    print("🔍 檔案診斷工具")
    print("=" * 50)
    print(f"📁 檔案路徑: {file_path}")
    
    # 檢查檔案是否存在
    if not file_path.exists():
        print("❌ 檔案不存在")
        return
    
    # 檢查檔案大小
    file_size = file_path.stat().st_size
    print(f"📏 檔案大小: {file_size} bytes")
    
    if file_size == 0:
        print("❌ 檔案是空的")
        return
    
    # 嘗試不同編碼讀取檔案
    encodings = ['utf-8', 'big5', 'cp950', 'gbk', 'latin-1']
    content = None
    used_encoding = None
    
    for encoding in encodings:
        try:
            with open(file_path, 'r', encoding=encoding) as f:
                content = f.read()
            used_encoding = encoding
            print(f"✅ 成功使用 {encoding} 編碼讀取")
            break
        except UnicodeDecodeError:
            print(f"❌ {encoding} 編碼讀取失敗")
            continue
    
    if content is None:
        print("❌ 無法使用任何常見編碼讀取檔案")
        return
    
    # 分析內容
    print(f"📝 使用編碼: {used_encoding}")
    print(f"📄 總字元數: {len(content)}")
    
    lines = content.splitlines()
    print(f"📊 總行數: {len(lines)}")
    
    non_empty_lines = [line.strip() for line in lines if line.strip()]
    print(f"📊 非空行數: {len(non_empty_lines)}")
    
    # 檢查內容類型
    import re
    chinese_chars = re.findall(r'[\u4e00-\u9fff]', content)
    english_chars = re.findall(r'[a-zA-Z]', content)
    digits = re.findall(r'\d', content)
    
    print(f"🈳 中文字符數: {len(chinese_chars)}")
    print(f"🔤 英文字符數: {len(english_chars)}")
    print(f"🔢 數字字符數: {len(digits)}")
    
    # 顯示前幾行內容
    print("\n📄 檔案前 5 行內容:")
    print("-" * 50)
    for i, line in enumerate(lines[:5]):
        if line.strip():
            print(f"{i+1:2}: {line[:100]}{'...' if len(line) > 100 else ''}")
        else:
            print(f"{i+1:2}: [空行]")
    print("-" * 50)
    
    # 檢查特殊字符
    special_chars = set()
    for char in content:
        if ord(char) < 32 and char not in '\n\r\t':
            special_chars.add(repr(char))
    
    if special_chars:
        print(f"⚠️  發現特殊控制字符: {', '.join(list(special_chars)[:10])}")
    
    # 檢查是否適合整理
    if len(content.strip()) < 50:
        print("⚠️  內容太短，可能不適合進行 AI 整理")
    elif len(chinese_chars) < 10:
        print("⚠️  中文內容較少，整理效果可能不佳")
    else:
        print("✅ 檔案內容適合進行 AI 整理")
    
    print("\n💡 如果檔案有問題，請檢查:")
    print("   1. 檔案是否為純文字格式")
    print("   2. 檔案編碼是否正確")
    print("   3. 檔案是否包含有意義的文字內容")

def main():
    if len(sys.argv) != 2:
        print("使用方法: python debug_file.py <檔案路徑>")
        print("範例: python debug_file.py recordings/新錄音\\ 5.txt")
        sys.exit(1)
    
    file_path = sys.argv[1]
    diagnose_file(file_path)

if __name__ == "__main__":
    main() 