#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
iPhone 語音檔轉文字工具
使用 OpenAI Whisper API 將語音檔案轉換為文字
增加 ChatGPT 文字整理功能
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
    
    def summarize_text(self, text, summary_type="重點整理"):
        """
        使用 ChatGPT 整理文字內容
        
        Args:
            text (str): 需要整理的文字
            summary_type (str): 整理類型
        
        Returns:
            str: 整理後的文字
        """
        print(f"🤖 正在使用 ChatGPT 進行{summary_type}...")
        print(f"📝 文字長度: {len(text)} 字元")
        
        # 檢查文字長度，如果太長需要特殊處理
        if len(text) > 8000:  # 保守的長度限制
            print("⚠️  文字內容較長，可能需要分段處理...")
            print("請選擇處理方式：")
            print("1️⃣  只處理前 8000 字元")
            print("2️⃣  分段處理並合併結果")
            print("3️⃣  取消整理")
            
            try:
                choice = input("請選擇 (1-3): ").strip()
            except:
                choice = "1"  # 默認選擇
            
            if choice == "1":
                text = text[:8000]
                print(f"📝 已截取前 8000 字元進行處理")
            elif choice == "2":
                return self._process_long_text(text, summary_type)
            else:
                raise Exception("用戶取消整理")
        
        print("⏳ 正在連接 OpenAI API...")
        
        # 根據不同類型設定不同的提示詞
        prompts = {
            "重點整理": """
            請幫我整理以下文字內容的重點：

            1. 提取主要觀點和重要資訊
            2. 整理成條列式要點
            3. 保持原文的語言風格
            4. 如果有時間、地點、人名等重要細節，請特別標註

            請用繁體中文回覆。

            原文內容：
            """,
            "會議紀錄": """
            請幫我將以下內容整理成正式的會議紀錄格式：

            1. 主要議題和討論內容
            2. 重要決議和行動項目
            3. 責任歸屬和時間點
            4. 如有具體數字、日期請特別標註

            請用繁體中文回覆，格式要清晰易讀。

            會議內容：
            """,
            "筆記整理": """
            請幫我將以下內容整理成結構化的筆記：

            1. 按主題分類整理
            2. 重要概念和關鍵字標註
            3. 補充說明和細節
            4. 如有可行動項目請列出

            請用繁體中文回覆。

            筆記內容：
            """,
            "摘要總結": """
            請幫我將以下內容寫成簡潔的摘要：

            1. 用 2-3 段文字總結主要內容
            2. 保留最重要的資訊
            3. 語言要簡潔清晰
            4. 保持客觀中性的語調

            請用繁體中文回覆。

            原文內容：
            """
        }
        
        system_prompt = prompts.get(summary_type, prompts["重點整理"])
        
        try:
            print("🔄 正在處理中，請稍候...")
            response = self.client.chat.completions.create(
                model="gpt-3.5-turbo",
                messages=[
                    {"role": "system", "content": "你是一個專業的文字整理助手，擅長將語音轉錄內容整理成清晰易讀的格式。"},
                    {"role": "user", "content": system_prompt + text}
                ],
                max_tokens=2000,
                temperature=0.3
            )
            print("✅ API 呼叫成功")
            return response.choices[0].message.content
        except Exception as e:
            raise Exception(f"文字整理失敗: {e}")
    
    def _process_long_text(self, text, summary_type):
        """
        處理長文本，分段處理並合併結果
        """
        print("🔄 開始分段處理長文本...")
        
        # 將文字分成多段，每段約 6000 字元
        chunk_size = 6000
        chunks = []
        for i in range(0, len(text), chunk_size):
            chunks.append(text[i:i + chunk_size])
        
        print(f"📝 文字已分成 {len(chunks)} 段進行處理")
        
        summaries = []
        for i, chunk in enumerate(chunks):
            print(f"🔄 正在處理第 {i+1}/{len(chunks)} 段...")
            try:
                # 為分段添加特殊提示
                chunk_prompt = f"這是第{i+1}段，共{len(chunks)}段內容。請整理這段內容的重點："
                
                response = self.client.chat.completions.create(
                    model="gpt-3.5-turbo",
                    messages=[
                        {"role": "system", "content": "你是一個專業的文字整理助手，正在處理分段內容。"},
                        {"role": "user", "content": chunk_prompt + "\n\n" + chunk}
                    ],
                    max_tokens=1500,
                    temperature=0.3
                )
                summaries.append(response.choices[0].message.content)
                print(f"✅ 第 {i+1} 段處理完成")
            except Exception as e:
                print(f"⚠️  第 {i+1} 段處理失敗: {e}")
                summaries.append(f"[第 {i+1} 段處理失敗]")
        
        # 合併所有摘要
        print("🔄 正在合併分段結果...")
        combined_summary = "\n\n".join([f"## 第 {i+1} 段摘要\n{summary}" for i, summary in enumerate(summaries)])
        
        # 對合併結果進行最終整理
        try:
            final_prompt = f"以下是分段整理的結果，請將它們合併成一個完整的{summary_type}：\n\n{combined_summary}"
            
            response = self.client.chat.completions.create(
                model="gpt-3.5-turbo",
                messages=[
                    {"role": "system", "content": f"請將分段整理的內容合併成一個完整的{summary_type}。"},
                    {"role": "user", "content": final_prompt}
                ],
                max_tokens=2000,
                temperature=0.3
            )
            
            print("✅ 分段處理完成，已合併結果")
            return response.choices[0].message.content
            
        except Exception as e:
            print(f"⚠️  最終合併失敗: {e}")
            print("返回分段結果...")
            return combined_summary
    
    def process_file(self, input_path, output_txt_path=None, language="zh", auto_summarize=False, summary_type="重點整理"):
        """
        處理語音檔案並轉錄，可選擇自動整理
        
        Args:
            input_path (str): 輸入檔案路徑
            output_txt_path (str): 輸出文字檔案路徑 (可選)
            language (str): 語言代碼
            auto_summarize (bool): 是否自動整理文字
            summary_type (str): 整理類型
        
        Returns:
            tuple: (轉錄文字, 整理後文字 或 None)
        """
        input_path = Path(input_path)
        
        # 轉錄音訊
        text = self.transcribe_audio(input_path, language)
        
        # 儲存原始轉錄檔案
        if output_txt_path is None:
            output_txt_path = input_path.with_suffix('.txt')
        
        with open(output_txt_path, 'w', encoding='utf-8') as f:
            f.write(text)
        
        print(f"✅ 轉錄完成！文字已儲存到: {output_txt_path}")
        
        summarized_text = None
        if auto_summarize:
            try:
                print("")
                print("🤖 開始智能整理流程...")
                print(f"📝 整理類型: {summary_type}")
                print("─" * 50)
                summarized_text = self.summarize_text(text, summary_type)
                
                # 儲存整理後的檔案
                summary_path = input_path.with_suffix(f'.{summary_type}.txt')
                print(f"💾 正在儲存整理結果到: {summary_path.name}")
                with open(summary_path, 'w', encoding='utf-8') as f:
                    f.write(summarized_text)
                
                print(f"🤖 文字整理完成！已儲存到: {summary_path}")
                print("─" * 50)
            except Exception as e:
                print(f"⚠️  文字整理失敗: {e}")
                print("原始轉錄檔案已保存")
        
        return text, summarized_text
    
    def process_text_file(self, text_file_path, summary_type="重點整理"):
        """
        處理已存在的文字檔案，進行整理
        
        Args:
            text_file_path (str): 文字檔案路徑
            summary_type (str): 整理類型
        
        Returns:
            str: 整理後的文字
        """
        text_file_path = Path(text_file_path)
        
        if not text_file_path.exists():
            raise FileNotFoundError(f"找不到檔案: {text_file_path}")
        
        print(f"📄 正在處理文字檔案: {text_file_path.name}")
        print(f"📂 檔案路徑: {text_file_path}")
        
        # 讀取文字檔案
        print("📖 正在讀取檔案內容...")
        try:
            with open(text_file_path, 'r', encoding='utf-8') as f:
                text = f.read()
        except UnicodeDecodeError:
            print("⚠️  UTF-8 編碼讀取失敗，嘗試其他編碼...")
            try:
                with open(text_file_path, 'r', encoding='big5') as f:
                    text = f.read()
                print("✅ 使用 Big5 編碼成功讀取")
            except UnicodeDecodeError:
                try:
                    with open(text_file_path, 'r', encoding='cp950') as f:
                        text = f.read()
                    print("✅ 使用 CP950 編碼成功讀取")
                except UnicodeDecodeError:
                    raise ValueError("檔案編碼無法識別，請檢查檔案格式")
        
        # 檢查檔案內容
        original_length = len(text)
        if not text.strip():
            raise ValueError("文字檔案內容是空的或只包含空白字元")
        
        # 清理和預處理文字
        text = text.strip()
        lines = text.splitlines()
        non_empty_lines = [line.strip() for line in lines if line.strip()]
        
        print(f"✅ 檔案讀取完成")
        print(f"📏 原始長度: {original_length} 字元")
        print(f"📏 處理後長度: {len(text)} 字元") 
        print(f"📊 總行數: {len(lines)} 行")
        print(f"📊 非空行數: {len(non_empty_lines)} 行")
        
        # 顯示文字樣本
        sample_text = text[:200] + "..." if len(text) > 200 else text
        print(f"📄 內容預覽: {sample_text}")
        
        # 檢查是否有足夠的內容進行整理
        if len(text) < 50:
            print("⚠️  警告：檔案內容較短，整理結果可能不理想")
        
        # 整理文字
        print(f"🎯 開始進行 {summary_type} 整理...")
        summarized_text = self.summarize_text(text, summary_type)
        
        # 儲存整理後的檔案
        summary_path = text_file_path.with_suffix(f'.{summary_type}.txt')
        print(f"💾 正在儲存整理結果...")
        with open(summary_path, 'w', encoding='utf-8') as f:
            f.write(summarized_text)
        
        print(f"🤖 文字整理完成！已儲存到: {summary_path}")
        
        return summarized_text

def main():
    """主函式"""
    print("🎤 iPhone 語音轉文字工具")
    print("=" * 40)
    
    if len(sys.argv) < 2:
        print("使用方法: python speech_to_text.py <音訊檔案路徑> [--summarize] [--type=類型]")
        print("範例: python speech_to_text.py recording.m4a")
        print("範例: python speech_to_text.py recording.m4a --summarize --type=會議紀錄")
        print("\n支援的格式: .mp3, .m4a, .wav, .mp4, .mpeg, .mpga, .webm")
        print("\n整理類型: 重點整理, 會議紀錄, 筆記整理, 摘要總結")
        sys.exit(1)
    
    input_file = sys.argv[1]
    auto_summarize = "--summarize" in sys.argv
    
    # 解析整理類型
    summary_type = "重點整理"
    for arg in sys.argv:
        if arg.startswith("--type="):
            summary_type = arg.split("=", 1)[1]
    
    try:
        # 建立語音轉文字實例
        stt = SpeechToText()
        
        # 處理檔案
        text, summarized_text = stt.process_file(input_file, auto_summarize=auto_summarize, summary_type=summary_type)
        
        print("\n" + "="*60)
        print("🎯 轉錄結果:")
        print("="*60)
        print(text)
        print("="*60)
        
        if summarized_text:
            print("\n" + "="*60)
            print(f"🤖 {summary_type}結果:")
            print("="*60)
            print(summarized_text)
            print("="*60)
        
    except Exception as e:
        print(f"❌ 錯誤: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main() 