# 51. 営業・ビジネス開発 (Sales & Business Development)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-04-06

> [!IMPORTANT]
> **Supreme Directive（最高指令）**
> 「営業は欺くことではなく、顧客が正しい意思決定を下せるよう支援することである」
> 営業プロセスは **「顧客の学習と意思決定を最短・最適化するシステム」** として設計する。
> 売り込み（Push）ではなく、引き寄せ（Pull）を設計せよ。
> **10パート・38セクション構成。**

---

## 目次

- [Part I. 営業哲学と文化](#part-i-営業哲学と文化)
- [Part II. 営業プロセスの設計](#part-ii-営業プロセスの設計)
- [Part III. 資格確認フレームワーク（MEDDIC）](#part-iii-資格確認フレームワークmeddic)
- [Part IV. アウトバウンド営業プロトコル](#part-iv-アウトバウンド営業プロトコル)
- [Part V. デモ・プレゼンテーション設計](#part-v-デモプレゼンテーション設計)
- [Part VI. 提案・価格交渉プロトコル](#part-vi-提案価格交渉プロトコル)
- [Part VII. CRM・パイプライン管理](#part-vii-crmパイプライン管理)
- [Part VIII. Sales Enablement](#part-viii-sales-enablement)
- [Part IX. ビジネス開発（BizDev）](#part-ix-ビジネス開発bizdev)
- [Part X. Appendix: 逆引き索引・クロスリファレンス](#part-x-appendix-逆引き索引クロスリファレンス)

---

## Part I. 営業哲学と文化

### 1.1. Modern Sales Philosophy（現代の営業哲学）

- **Rule 51.001**: 「営業」を「欺き・押し売り」とする文化を完全排除する
- **Rule 51.002**: 最高の営業活動とは **「顧客が買う理由を見つけるのを手伝うこと」** と定義する
- **The Challenger Sale 原則（Matthew Dixon & Brent Adamson）**:

| セールス類型 | 特徴 | 成果 |
|:-----------|:----|:----|
| **Relationship Builder** | 関係構築重視 | 並（最多タイプ） |
| **Hard Worker** | 努力・継続 | 平均 |
| **Lone Wolf** | 独自手法 | 高い（再現困難） |
| **Problem Solver** | 課題解決志向 | 高い |
| **Challenger** ★ | 教え・変える・制御する | **最高** |

- **Rule 51.003**: Challenger型の営業（顧客に新たな視点を提供し、思考を変える）を標準として育成する

### 1.2. Value Selling（価値販売）の原則

- **Rule 51.004**: 全ての営業活動において価格ではなく価値を中心に据える
  - 顧客が「ROI」で納得できない場合、「機能説明」に戻ることを禁止する
  - ROI が計算できない場合は §3 の MEDDIC で Economic Buyer に立ち戻る

### 1.3. Customer-Centric Selling（Selling = 顧客視点）

- **Rule 51.005**: 全ての営業コミュニケーションを「顧客の業務成果」に紐付ける

```
禁止トーク（機能中心）:
「このツールにはリアルタイム同期機能があります」

推奨トーク（成果中心）:
「現在、承認フローに平均3日かかっているとのことでしたが、
 リアルタイム同期を使うことで当日中に完了する可能性があります。
 月10件の承認であれば、月30時間の圧縮が期待できます」
```

---

## Part II. 営業プロセスの設計

### 2.1. Sales Funnel の定義

- **Rule 51.010**: 営業プロセスを以下のステージで定義し、ステージ間の進行条件を Blueprint で明文化する

```
Lead（リード）
  ↓ [条件: ICP一致度スコア ≥ 60]
MQL（Marketing Qualified Lead）
  ↓ [条件: 問い合わせ・資料DL等のインテント行動確認]
SQL（Sales Qualified Lead）
  ↓ [条件: BANT/MEDDIC の初期確認]
SAL（Sales Accepted Lead）
  ↓ [条件: 初回ミーティング完了・継続意欲確認]
Opportunity（商談）
  ↓ [条件: 予算・決裁者・タイムラインの把握]
Proposal（提案）
  ↓ [条件: 提案書・見積書送付]
Negotiation（交渉）
  ↓ [条件: 条件合意）]
Closed Won / Closed Lost
```

### 2.2. Opportunity Stage の確率管理

- **Rule 51.011**: 各ステージに Close確率（Win Rate）を定義し、パイプライン予測の精度を高める

| ステージ | 確率（例） | 
|:--------|:---------|
| SQL | 10% |
| SAL | 20% |
| Opportunity | 30% |
| Proposal | 60% |
| Negotiation | 80% |
| Verbal Commit | 95% |

- **Rule 51.012**: パイプライン予測は楽観・現実・悲観の3シナリオで毎週計算する

### 2.3. Sales Cycle の定義と管理

- **Rule 51.013**: 初回接触から成約までの平均 Sales Cycle を計測し、短縮施策を継続的に実施する

```
Sales Cycle 短縮の主要施策:
1. ミーティングの次のステップを毎回その場で確定する（Float しない）
2. 決裁者を早期に巻き込む（Championだけでなくpower sponsorを特定）
3. Mutual Close Plan（相互合意の進行表）を作成し共有する
4. 競合が存在する場合は「なぜ我々か」を早期に明確化する
```

---

## Part III. 資格確認フレームワーク（MEDDIC）

### 3.1. MEDDIC フレームワークの定義

- **Rule 51.020**: B2B営業の機会評価には **MEDDIC** フレームワークを使用する

| 要素 | 定義 | 確認すべき質問 |
|:----|:----|:------------|
| **M** Metrics | ROIの定量的根拠 | 「現状と目標の差は何ですか？」 |
| **E** Economic Buyer | 予算執行権者 | 「最終的にGoを出す人は誰ですか？」 |
| **D** Decision Criteria | 意思決定の基準 | 「選定にあたって最重要な条件は？」 |
| **D** Decision Process | 意思決定のプロセス | 「稟議から契約まで通常何週間？」 |
| **I** Identify Pain | 顕在化している課題 | 「今最もつらいことは何ですか？」 |
| **C** Champion | 社内の推進者 | 「あなたは社内でこれを推進できますか？」 |

### 3.2. Champion の特定プロトコル

- **Rule 51.021**: Champion（社内の支持者）の有無が成約率を最も左右する要素と定義する

```
Champion の3条件:
1. Power（社内での影響力がある）
2. Access（Economic Buyerに直接アクセスできる）
3. Advocate（製品の成功を自分事として推進する動機がある）

Champion ではない人:
- 「いい製品だと思いますよ」とだけ言う
- ミーティングに上位者を連れてきてくれない
- 「上の人に確認してみます」から進まない
```

### 3.3. MEDDIC スコアリングの実装

- **Rule 51.022**: CRM の各 Opportunity に MEDDIC の充足度をスコアリングし、パイプライン品質を管理する

```javascript
// MEDDIC スコアリング例
const meddicScore = {
  metrics: hasQuantifiedROI ? 1 : 0,
  economicBuyer: hasMetEB ? 2 : hasIdentifiedEB ? 1 : 0,
  decisionCriteria: hasDocumentedCriteria ? 1 : 0,
  decisionProcess: hasTimelineAgreed ? 1 : 0,
  identifyPain: hasDocumentedPain ? 1 : 0,
  champion: isValidated ? 2 : hasSuspect ? 1 : 0,
};
// Total ≤ 4: 低品質 / 5-6: 普通 / 7+: 高品質
```

---

## Part IV. アウトバウンド営業プロトコル

### 4.1. Cold Email の設計原則

- **Rule 51.030**: Cold Email は以下の5要素で構成し、200文字以内に収める

```
1. Personalization（なぜあなたに送っているか）:
   「○○の記事を読みました。御社が○○に取り組んでいると伺い...」

2. Problem（課題の提起）:
   「同じ規模の企業では、一般的に○○という課題を抱えています」

3. Solution（提案・バリュー）:
   「私たちは○○により、这个問題を○○で解決します」

4. Social Proof（実績・信頼）:
   「○○社では導入後3ヶ月で○○%改善しました」

5. CTA（明確な次のアクション）:
   「15分だけお時間をいただけますか？」
```

### 4.2. Sequence の設計

- **Rule 51.031**: アウトバウンドは単一メールではなく、以下のシーケンスで実施する

```
Day 1: Email（メイン本文）
Day 3: LinkedIn コネクション + メッセージ
Day 5: Follow-up Email（価値追加）
Day 8: Email（別のアングルで提起）
Day 12: Final Attempt（ソフトブレイクアップ）

件数目安: 1シーケンスで5タッチ、返信なし=次のターゲットへ
```

### 4.3. Anti-Spam 遵守プロトコル

- **Rule 51.032**: 全アウトバウンドメール活動は以下の法令を遵守する
  - 日本: 特定電子メール法（受信拒否意思表示から直ちに停止）
  - EU: GDPR + ePrivacy Directive
  - 米国: CAN-SPAM Act
  - 必ず Unsubscribe リンクを含め、その処理を自動化する

---

## Part V. デモ・プレゼンテーション設計

### 5.1. デモの構成原則

- **Rule 51.040**: デモは以下の順序で構成する

```
1. Agenda の確認（5%）: 今日の目的とゴールを共有
2. Discovery の確認（15%）: 事前ヒアリングの確認。「最も重要な課題は○○でしたが合っていますか？」
3. ストーリーベースのデモ（60%）: 「○○のシナリオで見ていきましょう」
4. Q&A + 質疑（15%）: 顧客の疑問解消
5. Next Steps（5%）: 次のアクションをその場で決める
```

### 5.2. デモの禁止事項

- **Rule 51.041**: デモにおける以下の行為を禁止する

```
禁止:
❌ フルプロダクトツアー（顧客の課題に関係ない機能も全部見せる）
❌ 「質問がありましたら最後にどうぞ」（疑問は生じた時点で解消すべき）
❌ 「えーとですね...」という準備不足が伝わる表現
❌ バグ・エラー発生の想定外の対処（デモ環境は専用環境を使う）
❌ 時間切れでNext Stepsが曖昧になる
```

### 5.3. Discovery の設計（デモ前の課題ヒアリング）

- **Rule 51.042**: デモの前に必ず **Discovery** を実施し、顧客の具体的な課題・状況を把握する

```
Discovery必須ヒアリング項目:
□ 今の業務フローと課題点
□ 解決策を探し始めたきっかけ
□ 今使っているツールとその不満
□ 成功の定義（何が改善したら「成功」と感じるか）
□ 決裁スケジュールと意思決定者
□ 予算感（直接または間接的に確認）
```

---

## Part VI. 提案・価格交渉プロトコル

### 6.1. 提案書の構成標準

- **Rule 51.050**: 提案書は以下の構成で作成する

```
1. Executive Summary（1ページ）: 顧客の課題と提案の要約
2. Current State & Problem（課題の確認）: 顧客の言葉で課題を再述
3. Proposed Solution（提案内容）: スコープ・機能・実装計画
4. ROI Calculation（投資対効果）: Before/After の定量化
5. Social Proof（事例・実績）: 類似企業のCase Study
6. Pricing（価格）: 明確な費用内訳
7. Timeline（スケジュール）: 導入から成果までの予測
8. Next Steps（次のアクション）: 明確なDeadline付き
```

### 6.2. 値引き要求への対応（§13 価格戦略と連携）

- → **`400_pricing_strategy.md` §7** を参照

### 6.3. PoC（概念実証）の設計プロトコル

- **Rule 51.051**: PoC（Proof of Concept）を実施する場合、以下の条件を先に合意する

```
PoC 開始前の合意事項（Mutual Close Plan）:
□ PoC の成功基準を定量で定義する
   例: 「3週間でユーザー10名が週3回以上使用すること」
□ PoC 期間を限定する（最大30日）
□ PoC 成功時の次のアクション（契約！）を合意しておく
□ 双方のコミットメント（担当割当、データ準備）を明確化する

禁止: 成功基準なしのPoC（永遠に続く評価期間になるリスク）
```

---

## Part VII. CRM・パイプライン管理

### 7.1. CRM 入力のルール

- **Rule 51.060**: CRM の活用は営業の義務であり、以下を入力必須フィールドとする

```
Opportunity 必須フィールド:
- Account Name / Contact Name
- Deal Size（予測）
- Stage（MEDDIC スコア付き）
- Close Date（予測）
- Next Step（具体的なアクション + 日付）
- Last Activity Date（自動更新）
- Source（Lead獲得チャネル）
```

### 7.2. パイプラインレビューの標準

- **Rule 51.061**: 以下の頻度でパイプラインレビューを実施する

| レビュー | 頻度 | 参加者 | フォーカス |
|:--------|:----|:------|:---------|
| **Pipeline Review** | 週次 | AE + Sales Manager | Stage 更新・ブッキング予測 |
| **Deal Review** | 隔週 | AE + Sales Manager + SE | スタックディール解消 |
| **Forecast Review** | 月次 | Sales Leader + CEO | 売上予測・リソース計画 |
| **Win/Loss Review** | 四半期 | 全営業 + PM | 勝率改善・製品フィードバック |

### 7.3. Win/Loss 分析プロトコル

- **Rule 51.062**: Closed Lost の商談は必ず以下の分類で理由を記録する

| 失注理由 | 改善担当 |
|:--------|:--------|
| **No Budget** | タイミング・予算サイクルの理解改善 |
| **Chose Competitor** | 差別化強化・競合分析 |
| **No Timeline** | MEDDIC での早期確認強化 |
| **Lost Champion** | Champion 多元化の必要性 |
| **Product Gap** | PM へのフィードバック |
| **Price** | 価格戦略・ROI計算の改善 |

---

## Part VIII. Sales Enablement

### 8.1. Sales Playbook の構成

- **Rule 51.070**: Sales Playbook を Blueprint で管理し、以下の内容を含める

```
Sales Playbook 必須コンテンツ:
1. ICP 定義と資格確認チェックリスト
2. Product Positioning（各ペルソナ向けのメッセージ）
3. Competitor Battle Cards（競合比較の反論シート）
4. Objection Handling Guide（よくある質問と回答）
5. デモスクリプト（シナリオ別）
6. Email テンプレート（Cold / Follow-up / Closing）
7. Proposal テンプレート
8. Reference Customer リスト（紹介可能な顧客）
```

### 8.2. Sales Training の義務

- **Rule 51.071**: 新入AEは以下のオンボーディングプログラムを完了してから顧客担当に入る

```
Onboarding プログラム（30日間）:
Week 1: 製品理解（自ら使い込む） + ICP理解
Week 2: シャドウ（先輩AEのデモ・コール同席）
Week 3: リバースシャドウ（先輩AEが自分を観察）
Week 4: 最初の担当商談（先輩サポートあり）

合格基準: デモを見た Sales Manager が「顧客に見せられる」と認定
```

---

## Part IX. ビジネス開発（BizDev）

### 9.1. BizDev と Sales の違い

- **Rule 51.080**: BizDev（Business Development）と Sales を明確に区別する

| 観点 | Sales | BizDev |
|:----|:------|:------|
| 目的 | 収益獲得（短期） | 新しい市場・チャネルの開拓（中長期） |
| 対象 | 個別顧客 | パートナー・プラットフォーム・ルート |
| 成果指標 | MRR / Closed Deals | Pipeline からの間接MRR / 新市場アクセス |

### 9.2. パートナーシップの評価基準

- **Rule 51.081**: 新しいBizDevパートナーシップは以下の基準で評価する

```
パートナーシップ評価フレームワーク:
1. Market Access（どれだけのICP に到達できるか）: スコア 1-5
2. Complementarity（自社の補完 / 競合しないか）: スコア 1-5
3. Credibility（信頼性・評判）: スコア 1-5
4. Commitment（先方のリソース投下意欲）: スコア 1-5
5. Economic Viability（収益共有モデルの持続可能性）: スコア 1-5

合計25点中 ≥ 15点のみ追求する
```

### 9.3. Technology Partnership の設計

- **Rule 51.082**: テクノロジーパートナー（統合・コネクター）を設計する場合の原則

```
Integration Partnership の戦略:
1. Integration 先は顧客がすでに使っているツール（Tech Stack）
2. 統合により「乗り換えコスト（Switching Cost）」が高まる
3. パートナーのマーケットプレイス掲載で発見可能性を高める
4. Co-marketing（共同ウェビナー・事例・キャンペーン）を設計する
```

---

## Part X. Appendix: 逆引き索引・クロスリファレンス

### 逆引き索引（キーワード → セクション）

| キーワード | 対応セクション |
|:---------|:------------|
| Challenger Sale・Value Selling | §1 営業哲学 |
| Sales Funnel・Stage・Deal Velocity | §2 営業プロセス |
| MEDDIC・Champion・Economic Buyer | §3 資格確認 |
| Cold Email・Sequence・Outbound | §4 アウトバウンド |
| デモ設計・Discovery・禁止事項 | §5 デモ設計 |
| 提案書・PoC・Mutual Close Plan | §6 提案交渉 |
| CRM・パイプライン・Win/Loss | §7 CRM管理 |
| Sales Playbook・Battle Card | §8 Enablement |
| BizDev・パートナー評価 | §9 BizDev |

### クロスリファレンス（セクション → 関連ルール）

| セクション | 関連 Universal ルール |
|:---------|:------------------|
| §3 MEDDIC | `200_go_to_market`（ICP定義） |
| §5 デモ | `000_product_strategy`（バリュープロポジション）|
| §6 価格交渉 | `400_pricing_strategy`（エンタープライズ価格） |
| §7 CRM | `100_data_analytics`（データ管理） |
| §9 Technology Partnership | `700_partnership_ecosystem` |
