# ShieldBuy — 防衝動購物模式 計畫文件

## Top-Level Overview

**目標**：開發一款行動 App（iOS + Android，Flutter），UI 設計模仿手機系統模式開關（如飛航模式、勿擾模式），讓中老年使用者能一鍵啟動「防衝動購物模式」，同時啟動三大保護機制：Scam 詐騙偵測、三天冷靜期、跨平台追蹤防護。

**核心理念**：操作極簡（一個大開關），保護全面（背景自動運作），不打擾日常使用。

**平台**：iOS + Android（Flutter）

**範圍內**：
- 防衝動購物模式主開關 UI
- Scam 詐騙廣告偵測（AI + 用戶回報）
- 三天冷靜期（偵測購物連結 → 鎖定 72 小時）
- 跨平台追蹤防護（封鎖 Cookie / 追蹤像素，切斷蝦皮 ↔ SNS 資料流）

**範圍外**：
- 系統層級 ROM 整合
- 電商平台官方 API 串接

---

## Sub-Task 1 — 主畫面：防衝動購物模式開關

**Status**：[ ] pending

### Intent
設計 App 主畫面，核心是一個大型模式切換開關，讓使用者直覺理解「開 = 全面保護、關 = 正常瀏覽」。介面針對中老年使用者優化（大字、高對比、簡單圖示）。

### Expected Outcomes
- 主畫面有一個大型開關，開啟後顯示「防衝動購物模式已啟動」
- 開關下方顯示三個功能的啟用狀態（Scam 偵測 / 冷靜期 / 追蹤防護）
- 可個別開關三個子功能
- 字體大、對比高，符合中老年使用體驗

### Todo List
- [ ] 設計主畫面 Wireframe（大開關 + 三個子功能狀態卡片）
- [ ] 實作 Flutter 主畫面 UI 元件（Switch、StatusCard）
- [ ] 實作模式開關的全局狀態管理（Riverpod）
- [ ] 開關動畫與顏色變化（關閉=灰、開啟=綠）
- [ ] 無障礙設定：字體縮放支援、高對比主題

### Relevant Context
- 參考 iOS 控制中心模式按鈕設計風格
- Flutter 套件：flutter_riverpod、google_fonts

---

## Sub-Task 2 — Scam 詐騙偵測功能

**Status**：[ ] pending

### Intent
當模式啟動時，使用者可將社群平台上的廣告連結分享給 App，透過 AI 分析是否為詐騙，並提供用戶回報機制建立共享黑名單資料庫。

### Expected Outcomes
- 使用者分享廣告連結至 App，回傳風險評分（低 / 中 / 高風險）
- 高風險廣告顯示紅色警告彈窗
- 使用者可手動回報可疑廣告，累積後列入黑名單
- 黑名單資料庫雲端同步，所有用戶共享

### Todo List
- [ ] 設計 Scam 風險評分 API（串接 OpenAI GPT-4o）
- [ ] 實作 Share Extension（iOS）/ Intent Filter（Android）接收分享連結
- [ ] 設計風險結果頁面（評分 + 理由說明 + 建議行動）
- [ ] 實作用戶回報 UI 與後端黑名單（Firebase Firestore）
- [ ] 黑名單比對：開啟連結前自動查詢

### Relevant Context
- OpenAI GPT-4o 分析廣告文字、價格異常、賣家資訊
- Firebase Firestore 即時同步黑名單

---

## Sub-Task 3 — 三天冷靜期功能

**Status**：[ ] pending

### Intent
偵測購物連結後啟動 72 小時冷靜期計時，鎖定連結直到時間到才能開啟，防止衝動消費。

### Expected Outcomes
- 偵測到購物連結時，彈出冷靜期提醒對話框
- 連結被鎖定並加入「冷靜清單」，顯示剩餘倒數時間
- 72 小時到期後發送推播通知
- 可設定緊急解鎖（需填寫原因增加摩擦成本）

### Todo List
- [ ] 實作購物網域偵測清單（蝦皮、momo、PChome 等，可擴充 JSON）
- [ ] 實作連結攔截機制（Share Extension / App 內瀏覽器）
- [ ] 設計冷靜期提醒彈窗 UI
- [ ] 實作冷靜清單頁面（商品名稱、縮圖、倒數計時器）
- [ ] 實作推播通知（flutter_local_notifications）
- [ ] 實作緊急解鎖流程（填寫原因 + 二次確認）

### Relevant Context
- 本地儲存：shared_preferences 或 sqflite
- 推播套件：flutter_local_notifications

---

## Sub-Task 4 — 跨平台追蹤防護功能

**Status**：[ ] pending

### Intent
封鎖蝦皮等電商平台埋入社群媒體的追蹤像素與第三方 Cookie，防止瀏覽紀錄被 SNS 平台取得，避免投放精準廣告。

### Expected Outcomes
- App 內建隱私瀏覽器，自動封鎖已知追蹤網域
- Facebook Pixel、Google Analytics 等追蹤腳本被阻擋
- 顯示「本次已封鎖 X 個追蹤器」防護報告
- 防護狀態儀表板顯示歷史封鎖統計

### Todo List
- [ ] 建立追蹤網域黑名單（參考 EasyPrivacy、uBlock Origin）
- [ ] 實作 App 內建隱私瀏覽器（webview_flutter + 請求攔截）
- [ ] 實作本地 VPN 攔截追蹤請求（Android VpnService / iOS NEPacketTunnelProvider）
- [ ] 設計防護報告頁面
- [ ] 防護狀態儀表板（歷史統計圖表）

### Relevant Context
- webview_flutter 可攔截 navigation request
- 本地 VPN 不實際連外，純本機過濾
- 追蹤清單來源：https://easylist.to/

---

## Sub-Task 5 — 後端與資料架構

**Status**：[ ] pending

### Intent
建立後端服務：Scam 黑名單資料庫、AI 分析 API、用戶回報系統、匿名使用者管理。

### Expected Outcomes
- Firebase 專案建立（Auth、Firestore、Functions）
- Scam 分析 Cloud Function 可接收連結並回傳風險評分
- 黑名單 Firestore 集合可新增、查詢、同步
- 匿名登入（不需帳號）

### Todo List
- [ ] 建立 Firebase 專案（Firestore + Cloud Functions + Anonymous Auth）
- [ ] 實作 Scam 分析 Cloud Function（呼叫 OpenAI API）
- [ ] 設計 Firestore 資料結構（scam_reports、blacklist、cooldown_items）
- [ ] 實作匿名登入流程
- [ ] 設定 Firestore Security Rules

### Relevant Context
- 匿名登入保護隱私，無需用戶提供個人資料
- Cloud Functions 負責 AI 分析，避免 API Key 暴露在前端

---

## Sub-Task 6 — 中老年使用者體驗優化

**Status**：[ ] pending

### Intent
針對中老年族群優化整體使用體驗，確保 App 簡單易懂、不易誤操作。

### Expected Outcomes
- 字體最小 18sp，點擊區域最小 48dp
- 功能說明使用白話文
- Onboarding 3 步驟內完成
- 支援系統字體大小設定

### Todo List
- [ ] 設計 Onboarding 流程（3 頁：是什麼 / 怎麼用 / 開始保護）
- [ ] 全域字體與間距設定（大字、寬行距）
- [ ] 所有說明文字改為白話文
- [ ] 測試最大字體下的版面適應性
- [ ] 加入「需要幫助嗎？」常見問題頁面

---

## 技術架構總覽

| 層級 | 技術選擇 |
|------|---------|
| 前端框架 | Flutter（iOS + Android） |
| 狀態管理 | Riverpod |
| 後端 | Firebase（Firestore + Cloud Functions） |
| AI 分析 | OpenAI GPT-4o API |
| 推播通知 | flutter_local_notifications |
| 隱私瀏覽 | webview_flutter + 本地 VPN |
| 追蹤清單 | EasyPrivacy 黑名單 |
