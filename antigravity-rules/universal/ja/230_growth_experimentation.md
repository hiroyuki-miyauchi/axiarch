# 230. グロースと実験 (Growth & Experimentation)

## 1. A/Bテストインフラ (A/B Testing Infrastructure)
*   **Feature Flag**:
    *   **デプロイとリリースの分離**: 新機能は必ず Feature Flag（LaunchDarkly, Firebase Remote Config）でラップし、コードのデプロイ（Deploy）とユーザーへの公開（Release）を分離します。
    *   **サーバーサイド制御**: アプリの審査を待たずに機能をオン/オフできるよう、原則としてサーバーサイドでフラグを制御します。
*   **実験の文化**:
    *   **仮説駆動**: 全ての新機能は「仮説（Hypothesis）」と「成功指標（Success Metric）」を定義してから開発します。「なんとなく作る」ことは禁止です。

## 2. 分析アーキテクチャ (Analytics Architecture)
*   **Event Dictionary**:
    *   **信頼できる唯一の情報源**: 全てのイベント定義（イベント名、プロパティ、トリガー条件）を管理するドキュメント（Event Dictionary）を作成し、実装前にPMとエンジニアが合意します。
    *   **命名規則**: `Object + Action` （例: `Button_Clicked`, `Screen_Viewed`）の形式を厳守し、表記ゆれを防ぎます。
*   **二重送信防止**:
    *   同一イベントが重複して送信されないよう、クライアント側でデバウンス処理やID管理を徹底します。

## 3. オンボーディング最適化 (Onboarding Optimization)
*   **マジックナンバー**:
    *   ユーザーが定着するために必要な行動回数（例: 「7日以内に3人の友達を追加」）を見つけ出し、その行動を促すようにUIを設計します。
*   **摩擦の排除**:
    *   サインアップフローでの入力項目は極限まで減らします。メール確認などは後回し（Lazy Registration）にできるか検討します。
