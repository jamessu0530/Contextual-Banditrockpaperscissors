# 猜拳 App（Contextual Bandit）

猜拳遊戲，電腦使用 Contextual Bandit（decaying epsilon-greedy）學習玩家習慣並提高勝率。勝率統計不含平手，僅計算「勝 / (勝+負)」。介面為黑白主題。

## 檔案結構

```
lib/
  main.dart                 # 程式入口，MyApp 與 Theme
  pages/
    janken_page.dart        # 猜拳主畫面
  widgets/
    janken_buttons.dart     # 剪刀 / 石頭 / 布 按鈕元件
  styles/
    app_styles.dart         # 主題與樣式（黑白主題）
  services/
    bandit_service.dart     # 強化學習邏輯（Contextual Bandit）
  models/
    q_entry.dart            # Q 表單一項目資料結構
```

## 如何執行

```bash
flutter pub get
flutter run
```

指定裝置（例如 iOS 模擬器）：

```bash
flutter devices
flutter run -d <device_id>
```

## 技術說明

- **狀態（context）**：玩家上一局出拳。
- **動作**：電腦出剪刀、石頭或布。
- **獎勵**：電腦贏 +1、平手 0、電腦輸 -1。
- **策略**：在每個 context 下以 Q 值選動作，搭配 decaying epsilon-greedy 探索；同分時隨機挑選。Q 表使用 Laplace 先驗（count 從 1 起）。

## 授權

此專案為 Flutter 預設範本，可依需求自行修改與使用。
