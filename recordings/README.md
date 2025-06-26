# 📁 錄音檔案資料夾

這個資料夾專門用來放置需要轉錄的音訊檔案。

## 🎤 支援的檔案格式

- iPhone 錄音：`.m4a`
- 常見音訊：`.mp3`, `.wav`, `.mp4`, `.mpeg`, `.mpga`, `.webm`

## 🚀 批次轉錄使用方法

### 1. 放入音訊檔案
將你的音訊檔案拖放到這個資料夾中：
```
recordings/
├── voice_memo_001.m4a
├── meeting_recording.mp3
├── interview.wav
└── phone_call.m4a
```

### 2. 執行批次轉錄
回到專案根目錄，執行：
```bash
./start.sh recordings
# 或
./start.sh batch
```

### 3. 查看結果
轉錄完成後，會在相同位置生成 `.txt` 檔案：
```
recordings/
├── voice_memo_001.m4a
├── voice_memo_001.txt      ← 轉錄結果
├── meeting_recording.mp3
├── meeting_recording.txt   ← 轉錄結果
└── ...
```

## 📊 批次處理特色

- **自動掃描**：自動找到所有支援的音訊檔案
- **進度顯示**：即時顯示轉錄進度
- **錯誤處理**：即使某個檔案失敗，也會繼續處理其他檔案
- **統計報告**：完成後顯示成功/失敗統計

## 🔒 安全說明

- 這個資料夾中的所有檔案（除了 `.gitkeep`）都不會被 git 上傳
- 你可以安全地放入任何音訊檔案，不用擔心意外公開
- 轉錄結果 `.txt` 檔案也不會被上傳

## 💡 小提示

- 檔案大小限制：25MB (OpenAI API 限制)
- 建議壓縮大檔案以節省 API 費用
- 可以建立子資料夾來分類不同類型的錄音 