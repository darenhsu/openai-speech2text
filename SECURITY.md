# 🔒 安全配置說明

## API 金鑰保護

這個專案已經設定了完整的 API 金鑰保護機制：

### ✅ 已設定的安全措施

1. **`.env` 檔案被 git 忽略**
   - 包含真實 API 金鑰的 `.env` 檔案不會被上傳到 GitHub
   - 在 `.gitignore` 中明確排除

2. **`.env.example` 範本檔案**
   - 只包含範例格式，沒有真實金鑰
   - 可以安全地分享和上傳到版本控制

3. **自動檢查機制**
   - `start.sh` 腳本會檢查是否還是預設值
   - 防止意外使用範例金鑰

### 🚨 重要安全提醒

- **絕對不要** 將真實的 API 金鑰提交到 git
- **絕對不要** 在程式碼中硬編碼 API 金鑰
- **絕對不要** 分享包含真實金鑰的 `.env` 檔案

### 📋 安全檢查清單

- [ ] `.env` 檔案在 `.gitignore` 中
- [ ] 只分享 `.env.example` 檔案
- [ ] API 金鑰以 `sk-` 開頭且長度正確
- [ ] 定期輪換 API 金鑰

### 🔧 如何安全地設定

1. **複製範例檔案**：
   ```bash
   cp .env.example .env
   ```

2. **編輯 .env 檔案**：
   ```bash
   # 將這行
   OPENAI_API_KEY=your_openai_api_key_here
   
   # 改成您的實際金鑰
   OPENAI_API_KEY=sk-your-actual-api-key-here
   ```

3. **確認 git 狀態**：
   ```bash
   git status
   # .env 檔案不應該出現在待提交列表中
   ```

### 🆘 如果不小心提交了金鑰

1. **立即撤銷 API 金鑰**（在 OpenAI 平台）
2. **生成新的 API 金鑰**
3. **從 git 歷史中移除敏感資訊**：
   ```bash
   git filter-branch --force --index-filter \
   'git rm --cached --ignore-unmatch .env' \
   --prune-empty --tag-name-filter cat -- --all
   ```

### 📞 聯絡資訊

如果發現安全問題，請立即聯絡專案維護者。 