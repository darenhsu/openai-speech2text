#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
iPhone 語音檔轉文字工具
使用 OpenAI Whisper API 將語音檔案轉換為文字
"""

import os
import sys
from pathlib import Path
from openai import OpenAI
from dotenv import load_dotenv

class SpeechToText:
    def __init__(self):
        """初始化語音轉文字類別"""
        # 載入環境變數
        load_dotenv()
        
        # 設定 OpenAI API 金鑰
        api_key = os.getenv('OPENAI_API_KEY')
        if not api_key or api_key == 'your_openai_api_key_here':
            print("❌ 請設定 OpenAI API 金鑰")
            print("1. 建立 .env 檔案")
            print("2. 在檔案中加入: OPENAI_API_KEY=您的金鑰")
            print("3. 到 https://platform.openai.com/api-keys 取得金鑰")
            raise ValueError("請在 .env 檔案中設定 OPENAI_API_KEY")
        
        self.client = OpenAI(api_key=api_key)
        
        # OpenAI Whisper API 支援的音訊格式
        self.supported_formats = ['.mp3', '.mp4', '.mpeg', '.mpga', '.m4a', '.wav', '.webm']
        
    def transcribe_audio(self, file_path, language="zh"):
        """
        使用 Whisper API 轉錄音訊檔案
        
        Args:
            file_path (str): 音訊檔案路徑
            language (str): 語言代碼 (預設為中文)
        
        Returns:
            str: 轉錄的文字
        """
        file_path = Path(file_path)
        
        if not file_path.exists():
            raise FileNotFoundError(f"找不到檔案: {file_path}")
        
        # 檢查檔案格式
        if file_path.suffix.lower() not in self.supported_formats:
            print(f"⚠️  檔案格式 {file_path.suffix} 可能不被支援")
            print(f"建議的格式: {', '.join(self.supported_formats)}")
        
        # 檢查檔案大小 (OpenAI 限制 25MB)
        file_size = file_path.stat().st_size / (1024 * 1024)  # MB
        if file_size > 25:
            raise ValueError(f"檔案太大 ({file_size:.1f}MB)，OpenAI 限制為 25MB")
        
        print(f"🎤 正在轉錄: {file_path.name}")
        print(f"📁 檔案大小: {file_size:.1f}MB")
        print("⏳ 請稍候...")
        
        try:
            with open(file_path, "rb") as audio_file:
                transcript = self.client.audio.transcriptions.create(
                    model="whisper-1",
                    file=audio_file,
                    language=language
                )
            return transcript.text
        except Exception as e:
            raise Exception(f"轉錄失敗: {e}")
    
    def process_file(self, input_path, output_txt_path=None, language="zh"):
        """
        處理語音檔案並轉錄
        
        Args:
            input_path (str): 輸入檔案路徑
            output_txt_path (str): 輸出文字檔案路徑 (可選)
            language (str): 語言代碼
        
        Returns:
            str: 轉錄的文字
        """
        input_path = Path(input_path)
        
        # 轉錄音訊
        text = self.transcribe_audio(input_path, language)
        
        # 儲存文字檔案
        if output_txt_path is None:
            output_txt_path = input_path.with_suffix('.txt')
        
        with open(output_txt_path, 'w', encoding='utf-8') as f:
            f.write(text)
        
        print(f"✅ 轉錄完成！文字已儲存到: {output_txt_path}")
        
        return text

def main():
    """主函式"""
    print("🎤 iPhone 語音轉文字工具")
    print("=" * 40)
    
    if len(sys.argv) != 2:
        print("使用方法: python speech_to_text.py <音訊檔案路徑>")
        print("範例: python speech_to_text.py recording.m4a")
        print("\n支援的格式: .mp3, .m4a, .wav, .mp4, .mpeg, .mpga, .webm")
        sys.exit(1)
    
    input_file = sys.argv[1]
    
    try:
        # 建立語音轉文字實例
        stt = SpeechToText()
        
        # 處理檔案
        text = stt.process_file(input_file)
        
        print("\n" + "="*60)
        print("🎯 轉錄結果:")
        print("="*60)
        print(text)
        print("="*60)
        
    except Exception as e:
        print(f"❌ 錯誤: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main() 