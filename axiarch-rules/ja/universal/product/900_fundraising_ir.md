# 15. 資金調達・IR戦略 (Fundraising & Investor Relations)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-05-06

> [!IMPORTANT]
> **Primary Directive（主要方針）**
> 「資金調達は手段であり目的ではない。希薄化と引き換えに得るリソースを、最も高い確率で価値に転換する責任がある」
> 投資家との関係は短期的な契約ではなく **長期的なパートナーシップ** である。**信頼は取り戻せない。**
> **15 Part / 約 80+ ルール構成。**

---

## 目次 (Table of Contents)

| # | Part | 主要トピック |
|---|---|---|
| 0 | Primary Directive & Scope Manifesto | 守備範囲・優先順位 |
| I | 資金調達の哲学 | Default Alive / Ramen Profitability / 3 Errors |
| II | ステージとタイミング | Pre-seed → Series C+ / Runway 12ヶ月則 |
| III | Cap Table & ESOP 設計 | Vesting / Cliff / Option Pool / Dilution Math |
| IV | SAFE / Convertible Note / Bridge | YC SAFE / KISS / Discount / Cap |
| V | ピッチ設計プロトコル | 15 Slide / Narrative / Traction |
| VI | 投資家選定・アウトリーチ | Warm Intro / Funnel / Investor Fit |
| VII | タームシート完全ガイド | Liquidation / Anti-Dilution / Pro-Rata 数学 |
| VIII | デューデリジェンス対応 | Data Room / Proactive Disclosure |
| IX | 投資家リレーションズ（IR） | 月次レポート / Board Meeting / Early Warning |
| X | 規制コンプライアンス | FEFTA / CFIUS / MNPI / Tax / EDINET |
| XI | IPO 準備プロトコル | JPX / NYSE / NASDAQ / S-1 / 上場前監査 |
| XII | M&A Exit プロトコル | Indemnification / Escrow / Earnout |
| XIII | Founder Wellbeing & Crisis Communication | メンタルヘルス / 危機伝達 |
| XIV | Investor Tech Stack & AI 自動化 | Carta / Pulley / Visible / AI レポート |
| XV | Anti-Pattern Catalog | 禁則行為統合表 |
| App A | 逆引き索引 | キーワード逆引き |
| App B | クロスリファレンス | 他 Universal ルール接続 |

---

## Part 0: Primary Directive & Scope Manifesto

### 0.1. 守備範囲

✅ **抽出基準（含める）**:
- スタートアップ・成長期企業の資金調達戦略全般
- Cap Table / ESOP / Vesting 設計
- SAFE / Convertible Note / Equity Round の構造
- タームシート交渉・希薄化数学
- 投資家リレーションズ（IR）プロトコル
- IPO / M&A 等の Exit 準備
- 規制コンプライアンス（外資規制・MNPI・税務）
- Investor Tech Stack（Carta 等）

❌ **残置基準（含めない・各ドメインファイル参照）**:
- 製品戦略・ユニットエコノミクス → `product/000_product_strategy.md`
- 価格戦略・収益化 → `product/300_revenue_monetization.md` / `product/400_pricing_strategy.md`
- ピッチ用市場検証データ → `product/100_market_validation.md`
- GTM ローンチ → `product/200_go_to_market.md`
- KPI / Analytics 基盤 → `ai/100_data_analytics.md`
- 法務・IP DD → `security/300_ip_due_diligence.md`
- 一般組織 / HR → `operations/200_hr_organization.md`

### 0.2. 優先順位

**長期投資家パートナーシップ > 調達条件最適化 > 短期額面最大化**

理由: VC は **永続的株主**。1 ラウンドで関係を壊すと将来 5 ラウンドの調達と Exit に影響する。

---

## Part I: 資金調達の哲学

### 1.1. 資金調達の 3 つの誤り

- **Rule 15.001**: 以下の思考パターンは **危険なアンチパターン** である:

  | アンチパターン | 問題点 |
  |:------------|:------|
  | **Fundraising as Validation** | 調達額を成功の証明と錯覚。VC マネーは PMF の代替にならない |
  | **Raise as Much as Possible** | 過剰調達は希薄化拡大と規律喪失。Burn Multiple 悪化 |
  | **Valuation Maximization** | 高すぎる評価額は次ラウンド・Exit を困難化（Down Round リスク） |

### 1.2. Default Alive の原則

- **Rule 15.002**: 調達前に **Default Alive** 状態を目指す（Paul Graham）
  - Default Alive = 現在の成長率とコストのまま進めば自然黒字化
  - Default Alive でない段階での調達は **リスクを明示** した上で実行
- **計算式**: `現在の月次成長率 × 12ヶ月の複利成長 - Burn` がプラスなら Default Alive

### 1.3. Ramen Profitability First

- **Rule 15.003**: 外部資本に依存しない最小生存状態（**Ramen Profitability**）の早期達成を優先
  - 創業者の生活費が賄える最低限の収益
  - 調達交渉での「強い立場」を作る（Desperate な状態は常に不利）

### 1.4. Burn Multiple 規律

- **Rule 15.004**: **Burn Multiple = Net Burn / Net New ARR** を主要 efficiency 指標とする（David Sacks）

  | Burn Multiple | 評価 |
  |:--|:--|
  | < 1 | Amazing — 1 ドルの burn で 1 ドル超の ARR |
  | 1 - 1.5 | Great — 効率的成長 |
  | 1.5 - 2 | Good |
  | 2 - 3 | Suspect |
  | > 3 | Bad — 即 burn rate 削減 |

### 1.5. ZIRP 後の世界（2022+）

- **Rule 15.005**: ゼロ金利政策（ZIRP）が終わり、Growth at All Costs 時代は終焉。**Rule of 40**（Growth Rate + Profit Margin ≥ 40%）が SaaS の標準健康指標。
- **Capital Efficiency**: 同じ ARR を半分の調達額で実現するチームが評価される。

### 1.6. クロスリファレンス
- `product/000_product_strategy.md` Unit Economics（CAC/LTV）
- `product/300_revenue_monetization.md` ARR / NRR

---

## Part II: 資金調達ステージとタイミング

### 2.1. ステージ別の特徴と基準指標

- **Rule 15.010**: 調達ステージと達成基準（2026 年 SF Bay Area / 東京）

  | ステージ | 調達額 | 達成基準 | 主な投資家 | Pre-money 評価額目安 |
  |:--|:--|:--|:--|:--|
  | **Pre-seed** | $300K-$1M | アイデア + チーム + Prototype | Angels / FFF / Pre-seed VC | $3M-$10M |
  | **Seed** | $1M-$5M | PMF の兆し + MRR $20K | Seed VC / Angels | $8M-$30M |
  | **Series A** | $5M-$25M | PMF 確認 + ARR $1M-$3M + MoM 10%+ | Series A VC | $30M-$100M |
  | **Series B** | $20M-$80M | Unit Economics 成立 + ARR $5M-$20M | Growth VC / CVC | $100M-$500M |
  | **Series C+** | $50M+ | スケール確認 + 市場リーダーシップ | PE / 大手 VC | $500M-$5B |
  | **Pre-IPO** | $100M+ | IPO Path 明確 | Crossover / Mutual Funds | $1B+ |

### 2.2. 調達タイミング法則

- **Rule 15.011**: 調達タイミングは以下の鉄則:

```
1. 必要になる 12 ヶ月前から動き始める（クロージングまで 3-6 ヶ月）
2. ランウェイが 12 ヶ月以上ある状態で開始
3. 強いモメンタム（成長数字）がある時に動く
4. Desperate な状態での交渉は条件が悪化する

「お金が余っている時に借り、足りない時に借りてはいけない」
```

### 2.3. エクイティ vs デット vs ブートストラップ

- **Rule 15.012**: 資金調達形態の選択基準:

  | 方法 | 適しているケース | 注意点 |
  |:--|:--|:--|
  | **エクイティ** | 高成長一気がけが必要 | 希薄化 / 株主への説明責任 |
  | **デット（融資）** | キャッシュフロー安定 | 返済義務 / 担保要件 |
  | **Revenue-based Financing** | 安定 MRR がある SaaS | 返済条件は精査 |
  | **Venture Debt** | 既に VC エクイティ調達済み | Warrant / Covenant 確認 |
  | **ブートストラップ** | ニッチ高利益 / 長期所有 | 成長速度に限界 |
  | **政府系（中小企業庁・JIC・NEDO）** | R&D / Deep Tech | 監査義務・利用制限 |
  | **Crowdfunding（FUNDINNO 等）** | 個人ファン基盤 | 開示義務 / 運用コスト |

### 2.4. ランウェイ計算

- **Rule 15.013**: ランウェイ = `現預金 / 月次 Net Burn`
  - **Net Burn** = 月次支出 − 月次収益
  - **Gross Burn** = 月次支出のみ
  - 投資家報告では Net Burn を使用（誤魔化さない）

### 2.5. Bridge Round の判断

- **Rule 15.014**: Bridge Round（ランウェイ延長目的の小規模調達）の判断基準:
  - 次のラウンドに必要な KPI まであと 6 ヶ月以内に到達できる場合 → Bridge OK
  - そうでなければ **Down Round** を覚悟するか、Burn 大幅削減
  - Bridge は SAFE / Convertible で実行することが多い（バリュエーション議論回避）

---

## Part III: Cap Table & ESOP 設計

### 3.1. Cap Table の基本

- **Rule 15.020**: Cap Table（資本構成表）は **創業 Day 1 から正確に維持** する。Excel での手動管理は早期に Carta / Pulley に移行。
- **Cap Table 構成要素**:
  - Founders（共同創業者持分・Vesting Schedule）
  - Common Stock（普通株）
  - Preferred Stock（Series A/B/C 等の優先株）
  - Option Pool（ESOP / Stock Options）
  - SAFE / Convertible Notes（未転換）
  - Warrants（Venture Debt 等）

### 3.2. Founder Vesting & Cliff

- **Rule 15.021**: 全ての創業者株は **4 年 Vesting + 1 年 Cliff** が標準
  - **Cliff**: 1 年経過前に退職した場合、全株を失う
  - **4-year Vesting**: 1 年経過後、月次 1/48 ずつ vest
  - **Acceleration**:
    - **Single Trigger**: M&A 時に未 Vesting 分も自動 Vest（創業者保護寄り）
    - **Double Trigger**: M&A + 解雇時のみ自動 Vest（バランス型、推奨）
- **Re-vesting on Round**: Series A 等で投資家から要求される場合あり（既存 Vesting をリセット）

### 3.3. ESOP（Employee Stock Option Plan）設計

- **Rule 15.022**: ESOP は以下のサイズで設計:

  | ステージ | ESOP サイズ（Pre-money 比） |
  |:--|:--|
  | Pre-seed | 5-10% |
  | Seed | 10-15% |
  | Series A | 15-20% |
  | Series B | 18-22% |
  | Series C+ | 20-25% |
- **Option Pool Shuffle**: VC 要求で Pre-money に Option Pool 拡張を含める → 創業者希薄化を増大させる「ステルス希薄化」。**Post-money 拡張に交渉する** ことが望ましい。

### 3.4. 株主構成のヘルスチェック

- **Rule 15.023**: Series A 時点での健全な持分構成（米国スタートアップ典型値）:

  | 主体 | 持分（Series A 後） |
  |:--|:--|
  | 創業者（共同 2-3 名） | 50-65% |
  | Series A 投資家 | 20-25% |
  | Seed 投資家 | 10-15% |
  | ESOP（残） | 8-12% |

  創業者持分が 40% を切ると Series B/C で経営権リスク。Founder Friendly ストラクチャは早期から意識。

### 3.5. Dilution（希薄化）数学

- **Rule 15.024**: 希薄化計算の基本

```
Pre-money Valuation = $20M
New Investment = $5M
Post-money Valuation = $25M
New Investor Ownership = $5M / $25M = 20%
既存株主の希薄化 = 20%（つまり 1 - 80% = 20% 持分減少）
```

- **Pre-money vs Post-money SAFE / Note の影響**:
  - **Pre-money SAFE**: SAFE 投資家の持分は Pre-money に含まれる（既存株主が更に希薄化）
  - **Post-money SAFE (YC v2.0+)**: SAFE 投資家の持分は固定 → 計算が透明、現在の標準

### 3.6. Cap Table Tools（必須）

- **Rule 15.025**: Excel での手動管理は **Seed 以降禁止**。以下のいずれかを採用:
  - **Carta** — 米国最大手、ESOP 管理・409A 評価・Secondary 機能
  - **Pulley** — Carta 競合、価格優位
  - **Capdesk** — 欧州系
  - **Shareworks (Morgan Stanley)** — 大企業向け

### 3.7. 409A Valuation（米国）

- **Rule 15.026**: ESOP 行使価格決定のため、**年次 + 重大イベント後** に 409A Valuation（独立評価）を取得する義務（IRS 規定）。Carta は社内ツールで自動化提供。

### 3.8. クロスリファレンス
- `security/300_ip_due_diligence.md` 法人格・株主名簿の法務管理
- `operations/200_hr_organization.md` 人事・採用・報酬設計

---

## Part IV: SAFE / Convertible Note / Bridge

### 4.1. SAFE (Simple Agreement for Future Equity)

- **Rule 15.030**: Y Combinator 標準の **SAFE v2.0+（Post-money SAFE）** を採用する。Pre-money SAFE はレガシー。
- **SAFE の主要パラメータ**:

  | パラメータ | 説明 |
  |:--|:--|
  | **Valuation Cap** | 上限評価額（次ラウンドで Cap または Discount 適用される評価額） |
  | **Discount** | 次ラウンドの評価額に対する割引（典型 20%） |
  | **Most Favored Nation (MFN)** | 後の SAFE が良い条件なら適用される条項 |
  | **Pro-rata Side Letter** | 次ラウンド参加権（別契約） |

### 4.2. SAFE 計算例

```
SAFE 投資: $1M @ $10M Valuation Cap
次の Series A: $5M @ $20M Pre-money / $25M Post-money

SAFE 投資家の取り分:
  Cap 適用: $1M / $10M = 10%
  Discount 20% 適用: $1M / ($25M × 0.8) = 5%
  → 有利な方（10%）を SAFE 投資家が選択
```

### 4.3. Convertible Note との比較

| 特徴 | SAFE | Convertible Note |
|:--|:--|:--|
| **法的構造** | Equity 予約 | 負債（Debt） |
| **金利** | なし | 5-8% 標準 |
| **Maturity Date** | なし | 18-24 ヶ月で要転換 or 返済 |
| **シンプルさ** | ◎ | △（金利・期限） |
| **米国普及度** | 主流 | レガシー |
| **日本普及度** | 増加中 | 主流（J-KISS 含む） |

### 4.4. KISS (Keep It Simple Security) / J-KISS

- **KISS** (500 Startups): SAFE と Convertible の中間
- **J-KISS** (Coral Capital 公開): 日本法準拠のシード調達雛形
- **使い分け**: 米国法人 → SAFE、日本法人 → J-KISS が現代の主流

### 4.5. Bridge Financing

- **Rule 15.031**: Bridge Round（次ラウンドまでの繋ぎ）の使い分け:
  - **SAFE / Convertible Bridge**: バリュエーション議論を回避、次ラウンドで一括処理
  - **Equity Bridge**: 既存投資家からの追加投資（条件は同等）
  - **Venture Debt Bridge**: SVB / Hercules 等から（破綻リスク低い場合）

### 4.6. クロスリファレンス
- `product/300_revenue_monetization.md` ARR 等の財務指標

---

## Part V: ピッチ設計プロトコル

### 5.1. ピッチデック標準 15 スライド

- **Rule 15.040**: ピッチデックの標準構成:

```
必須スライド（10 枚）:
1. Cover（会社名・タグライン・ロゴ）
2. Problem（課題の定義・規模・Why Now）
3. Solution（プロダクトの解決策・デモ）
4. Market Size（TAM / SAM / SOM）
5. Business Model（収益の仕組み・価格）
6. Traction（実績・KPI・成長グラフ）
7. Go-to-Market（獲得戦略）
8. Competition（競合比較・ポジショニング）
9. Team（創業者・主要メンバーの背景）
10. Financials（3 年予測・調達額・使途）

補足スライド（5 枚 Appendix）:
11. Unit Economics（CAC / LTV / Magic Number / Burn Multiple）
12. Product Roadmap
13. Customer Testimonials / Case Study
14. Technology / Architecture / Moat
15. Cap Table（現在の持分構成）+ Use of Funds
```

### 5.2. Traction スライドの設計原則

- **Rule 15.041**: Traction スライドは **最も重要**

```
良い Traction の示し方:
✅ 成長率を強調（MoM 20% = 年率 792%）
✅ ロゴを見せる（著名顧客・ブランド名）
✅ 定性 + 定量（NPS + MRR）
✅ Before/After で顧客成功を示す
✅ コホート分析（Retention curve）

避けること:
❌ 絶対値のみ（"10 万ユーザー" だけでは不明）
❌ Vanity Metrics（PV / DL のみ。エンゲージメントを示せ）
❌ 恣意的な期間選択（成長が良い期間だけを切り取る）
❌ 二軸グラフでミスリード
```

### 5.3. The Narrative（物語）の設計

- **Rule 15.042**: ピッチの **一貫した物語** を設計

```
推奨 Narrative 構造（April Dunford / Andy Raskin スタイル）:
1. 世界の変化（Why Now）: 技術・市場の構造変化
2. 課題（Problem）: それによって生まれた問題
3. 解決（Solution）: 我々がそれをこう解く
4. 証明（Traction）: 市場が求めている証拠
5. ビジョン（Vision）: 5 年後にどんな世界を作るか
6. アンタゴニスト: 古い解決策・競合の限界（明示）
```

### 5.4. ピッチ実演プロトコル

- **Rule 15.043**: ピッチミーティング運営:
  - 持ち時間 30 分の場合: 自己紹介 5 / プレゼン 10 / Q&A 15
  - **デモ動画優先**: 静止スクリーンショットより 30 秒動画が刺さる
  - **投資家の質問に答える練習** 100 回（Founder Pitch Trainer / Mock Pitch）
  - **オフライン優先**: 重要 VC は対面 Pitch、Zoom は二次選考

### 5.5. Memo 形式（Pitch Deck の代替）

- **Rule 15.044**: 一部 VC（Sequoia / a16z）は **Pitch Memo**（5-10 ページ文章）を要求。
  - Amazon Bezos の "no PowerPoint" 哲学と同源
  - 思考の精緻さが伝わる
  - スライドより準備に時間がかかるが、内容は深い

### 5.6. クロスリファレンス
- `product/100_market_validation.md` Market Size / TAM 算出
- `product/200_go_to_market.md` GTM 戦略

---

## Part VI: 投資家選定・アウトリーチ

### 6.1. 投資家リスト構築プロトコル

- **Rule 15.050**: アウトリーチは **ファネル管理** で行う:

```
Target: 投資家候補リスト（200 社以上）
  ↓ リサーチ
Qualified: 自社ステージ・テーマ適合（50 社）
  ↓ Warm Intro 経路確認
Priority: 紹介ルートあり（20 社）
  ↓ ミーティング
Meeting: 初回ミーティング（10 社）
  ↓ 興味度確認
Active: 深掘り進行（5 社）
  ↓ Term Sheet
Closing: ターム提示（1-3 社）
```

### 6.2. Warm Intro の重要性

- **Rule 15.051**: Cold アウトリーチの返信率は **1% 以下**。**必ず Warm Intro** を経由
  - 紹介元優先順位: **ポートフォリオ創業者 > LP > 他 VC > アドバイザー > 業界知人**
  - Cold は最終手段

### 6.3. Investor Fit 評価

- **Rule 15.052**: 投資家を以下の軸で評価:

  | 評価軸 | 確認内容 |
  |:--|:--|
  | **Thesis Fit** | 投資テーマが自社ステージ・領域と一致 |
  | **Portfolio Value-add** | ポートフォリオに自社の潜在顧客・パートナー |
  | **Founder Reputation** | ポートフォリオ創業者の評判（Reference Check） |
  | **Board Value** | Board Member として何を提供できるか |
  | **Co-investment** | 次ラウンドにも参加意思・実績 |
  | **Reserve Capital** | Follow-on 投資余力 |

### 6.4. Investor Reference Check（投資家選定の Due Diligence）

- **Rule 15.053**: VC 選定前に **投資家のレファレンスチェック** を実施する
  - 過去 3 年で投資した会社の創業者 5 人に話を聞く（成功・失敗の双方）
  - 「Tough Time での挙動」「契約解釈の柔軟性」「次ラウンドの Follow-on」を確認

### 6.5. AI による投資家マッチング

- **Rule 15.054**: 2026 年現在、AI ツールで投資家マッチング効率化:
  - **Pitchbook**: ファンドの投資領域・小切手サイズ
  - **Crunchbase Pro**: ステージ・地域フィルタ
  - **OpenVC** / **VC Sheet** (community-driven): 自由記述検索

### 6.6. クロスリファレンス
- `product/200_go_to_market.md` Network 構築

---

## Part VII: タームシート完全ガイド（数学的深掘り）

### 7.1. タームシートの主要条件

- **Rule 15.060**: タームシートの主要条件は **法務専門家と必ず連携**:

  | 条件 | 創業者フレンドリー値 | 警戒値 |
  |:--|:--|:--|
  | **Valuation (Pre/Post-money)** | 現実的な高さ | 過剰高は次の Round Risk |
  | **Liquidation Preference** | 1× Non-participating | 2×+ / Participating |
  | **Anti-dilution** | Broad-based Weighted Average | Full Ratchet |
  | **Pro-rata Rights** | 標準（投資家が Follow-on 維持） | OK |
  | **Board Composition** | 創業者 majority 維持 | 投資家 majority |
  | **Information Rights** | 月次・四半期 | 過度な詳細 |
  | **Founder Vesting Re-set** | なし or Acceleration あり | 全リセット |
  | **Drag-along** | 標準（過半数） | 過小数株主の発動権 |
  | **ROFR / ROFO** | 標準 | 広すぎる |
  | **No-Shop / Exclusivity** | 30-45 日 | 60+ 日 |

### 7.2. Liquidation Preference の数学

- **Rule 15.061**: Liquidation Preference の例（Series A 投資家、$10M @ $30M Pre-money / $40M Post-money）:

```
Exit Scenario A: 会社が $30M で売却
  1× Non-participating:
    投資家オプション: (a) $10M（Preference）または (b) 25% × $30M = $7.5M
    → $10M を選択
    創業者: $30M - $10M = $20M

  1× Participating:
    投資家: $10M + 25% × ($30M - $10M) = $10M + $5M = $15M
    創業者: $15M（不利）

  2× Non-participating:
    投資家オプション: (a) $20M または (b) $7.5M
    → $20M を選択
    創業者: $10M（さらに不利）
```

- **Capped Participation**: Participating だが上限あり（例: 3× Cap）。ハイブリッド型。

### 7.3. Anti-Dilution の数学

- **Rule 15.062**: Down Round 時の Anti-dilution:

```
シナリオ: Series A $1/share、後に Series B が $0.5/share の Down Round
Series A 投資家の保護条項:

Full Ratchet（最も投資家有利）:
  Series A の換算価格を $0.5 に下げる
  → Series A の株数が 2 倍に膨らみ、創業者の希薄化激増

Broad-based Weighted Average（標準・推奨）:
  CP_new = CP_old × (A + B) / (A + C)
    A = 既発行株数
    B = 新規調達額 / CP_old
    C = 新規発行株数
  → 緩やかな調整

Narrow-based Weighted Average:
  分母から ESOP / Convertible を除外
  → Broad より投資家有利
```

### 7.4. Red Flag 条件リスト

- **Rule 15.063**: 以下が含まれる場合、法務確認を要する Red Flag:

```
警戒すべき条件:
❌ Participating Preferred Stock（清算優先 + 残余参加の二重取り）
❌ 2x+ Liquidation Preference
❌ Full Ratchet Anti-dilution
❌ Drag-along Right なしで創業者保護が弱い
❌ 投資家のコントロール過大（雇用 / 解雇の同意権、重要決定の拒否権）
❌ 過度な Ratchet 条項
❌ 広すぎる ROFR（Secondary を制限）
❌ No-Shop が 60 日超
❌ 創業者全員に対する強制 Re-vesting
```

### 7.5. Competing Offers 戦略

- **Rule 15.064**: 複数のオファーを同時に取得することが **最も有利な交渉** を生む:
  - **FOMO 戦略**: "Interest が高まっているため今月末に決定" の Deadline を設定
  - **Competitive Tension**: 特定 VC に最良条件を「他も同条件なら」で競わせる
  - **倫理ライン**: 嘘の数字を言わない、Bidding を捏造しない

### 7.6. クロスリファレンス
- `security/300_ip_due_diligence.md` 法務チェック

---

## Part VIII: デューデリジェンス対応

### 8.1. Data Room の構成

- **Rule 15.070**: DD に備え、以下を **常時 Data Room に整備**:

```
Data Room 構成（推奨）:
├── Corporate/（法人設立・株主名簿・議事録・Cap Table）
├── Financials/（月次 P&L・BS・CF・予算・3 年計画）
├── Product/（Product Roadmap・アーキテクチャ図・Tech Stack）
├── Legal/（契約書・IP 権利・訴訟リスク・Compliance）
├── HR/（組織図・雇用契約・ESOP・Board 構成）
├── Customers/（顧客リスト・MRR 明細・Churn 分析・Cohort）
├── Technology/（コード品質・セキュリティ・SOC 2）
├── Market/（市場調査・競合分析・TAM/SAM/SOM）
├── References/（顧客 / アドバイザー / 採用候補のレファレンス）
└── Press & Branding/（過去メディア掲載・ブランドアセット）
```

### 8.2. DD 対応の原則

- **Rule 15.071**: DD 情報開示の 3 原則:
  - **Proactive Disclosure**: 問題は **自発的に開示**。隠蔽が後で発覚した場合のダメージは開示より遥かに大きい
  - **Consistency**: 全投資家に同じ情報を提供。情報非対称を作らない
  - **Completeness**: 「知らなかった」は許されない。自社状態を完全把握した上で対応

### 8.3. Data Room ツール

- **Rule 15.072**: 専用ツールを使用:
  - **DocSend** — 閲覧履歴・滞在時間・スクリーンショット防止
  - **Datasite** — エンタープライズ DD
  - **Dropbox Capture** — シンプル
  - **Carta** — Cap Table 連携 Data Room
- **Anti-Pattern**: Google Drive で URL 共有 → 漏洩リスク・閲覧履歴なし

### 8.4. DD で多発する地雷

- **Rule 15.073**: 創業者がよく踏む地雷:
  - **創業者間の口頭合意**: 株式の付与・条件を書面化していない
  - **退社した元従業員の IP 帰属**: 雇用契約に IP 譲渡条項がない
  - **オープンソース・ライセンス違反**: GPL を商用に組み込み等
  - **PIPL / GDPR / 米国輸出規制**: 中国・EU・規制対象国に違反
  - **税務未払い**: 消費税・法人税・源泉徴収

### 8.5. クロスリファレンス
- `security/300_ip_due_diligence.md` IP 法務 DD
- `security/100_data_governance.md` 個人情報 DD
- `security/200_oss_compliance.md` OSS ライセンス DD

---

## Part IX: 投資家リレーションズ（IR）

### 9.1. 月次投資家レポート標準フォーマット

- **Rule 15.080**: 投資家への **月次レポート** 送付を義務とする:

```markdown
# [月次] 投資家レポート - YYYY 年 MM 月

## TL;DR（3 行サマリー）
- WIN: ◯◯ 達成 / ◯◯ Customer 獲得
- MISS: ◯◯ 未達 / 理由と対策
- ASK: 今月お願いしたいこと

## Key Metrics
| 指標 | 今月 | 先月 | MoM |
| MRR | ¥◯◯M | ¥◯◯M | +◯% |
| 顧客数 | ◯ 社 | ◯ 社 | +◯% |
| ARR | ¥◯◯M | | |
| Churn Rate | ◯% | | |
| CAC Payback | ◯ ヶ月 | | |
| Cash | ¥◯◯M | | Runway: ◯ ヶ月 |
| Burn Multiple | ◯ | | |
| NRR | ◯% | | |

## Highlights（良かったこと）

## Lowlights（課題・学び）

## Help Needed（投資家へのお願い）
- 採用: ◯◯ エンジニアを探しています
- 紹介: ◯◯ 業界の顧客を紹介ください
- アドバイス: ◯◯ の意思決定で意見が欲しい

## Hiring（採用状況）

## Looking Ahead（次月の重点）
```

### 9.2. Board Meeting 運営プロトコル

- **Rule 15.081**: Board Meeting は以下のプロトコルで運営:

```
頻度: 月次（Series A 前）/ 隔月（Series A 以降）
Board Pack 事前配布: 会議 72 時間前（48 時間最低）
構成:
  1. 業績レビュー（KPI / 財務）— 30%
  2. 主要課題のディスカッション — 40%
  3. 意思決定の必要事項 — 20%
  4. Next Actions と担当 — 10%

禁止: Board Meeting での「驚き」。重大な悪い情報は事前に連絡する。
推奨: Pre-read を投資家が読んだ前提で議論。資料を読み上げる時間は無駄。
```

### 9.3. Early Warning Protocol

- **Rule 15.082**: 以下の重大イベント発生時、**24 時間以内** に全投資家に通知:

```
Early Warning が必要な事象:
- ランウェイ 6 ヶ月切る見込み
- Key Person（創業者・CTO 等）離脱
- 重大なセキュリティインシデント
- 主要顧客（MRR の 10% 以上）の解約
- 重要な法的リスクの発生
- 競合による重大な動き（買収・大型調達）
- 規制変更による事業影響
- Founder のメンタルヘルス問題（→ Part XIII）
```

### 9.4. 投資家との関係維持

- **Rule 15.083**: ベターな投資家関係:
  - Quarterly 1-on-1（小切手大きい投資家）
  - Annual Strategy Review
  - Birthday / Holiday メッセージ（人間関係維持）
  - 失敗の共有（隠さない、学びを伝える）

### 9.5. Annual Letter（年次レター）

- **Rule 15.084**: Year-end Investor Letter（PG / Brian Chesky スタイル）:
  - 1 年の振り返り（成功・失敗・教訓）
  - 来年のビジョン・戦略
  - 投資家への感謝
  - 4-8 ページ、よく書かれた散文

---

## Part X: 規制コンプライアンス（FEFTA / CFIUS / MNPI / Tax / EDINET）

### 10.1. 外資規制（Foreign Investment Restrictions）

- **Rule 15.090**: 海外投資家を受け入れる際の規制チェック:

#### 10.1.1. 日本：FEFTA（外国為替及び外国貿易法）

- **コア技術領域**（半導体・量子・AI・バイオ・サイバーセキュリティ等）への外資投資は **事前届出義務**
- 議決権 1% 以上で届出（一部業種）、10% 以上で原則届出
- **対応**: 日本法人として上場準備中のスタートアップは特に注意

#### 10.1.2. 米国：CFIUS（外国投資委員会）

- 米国法人 / 米国事業を持つ会社への外資投資（特に中国・ロシア・北朝鮮・イラン）に CFIUS 審査
- **TID 業種**（Technology / Infrastructure / Data）は厳格審査
- **対応**: 米国 Series A 以降、Term Sheet 段階で確認

#### 10.1.3. EU：FDI Screening Regulation

- EU 加盟国による外国投資審査メカニズム
- 戦略産業（5G / AI / 量子 / バイオ）は厳格

### 10.2. Insider Trading & MNPI（Material Non-Public Information）

- **Rule 15.091**: pre-IPO / 上場直前の MNPI 規制:
  - **MNPI**: 公開されていないが投資判断に重大影響する情報（業績・大型契約・買収交渉）
  - **Insider Trading 禁止**: MNPI 保有者の株式売買は **重罪**（米国 SEC / 日本 金商法）
  - **Tipping**: 知人に MNPI を伝えて売買させることも禁止
- **対応**:
  - 上場準備期は **Trading Window**（Earnings 後の数週間のみ売買可）
  - **10b5-1 Plan**: 事前に売却スケジュールを設定（Insider でも例外的に売却可）

### 10.3. 税務考慮（Tax Considerations）

- **Rule 15.092**: 創業者・投資家の税務最適化:

#### 10.3.1. 米国：QSBS (Qualified Small Business Stock)

- IRS Section 1202: 5 年保有後の **キャピタルゲイン最大 $10M 非課税**
- 条件: 米国 C Corp、$50M 未満で発行、Active Business
- **対応**: 創業者は Day 1 に普通株を取得（税務優遇）

#### 10.3.2. 日本：エンジェル税制 / J-KISS

- 個人投資家のスタートアップ投資に税制優遇（出資額の所得控除）
- 2023 年改正で大幅拡充
- **対応**: 創業者報酬・ストックオプション設計で Tax 効率を考慮

#### 10.3.3. 国際税務：Transfer Pricing / Tax Haven

- 米国法人 + 日本子会社等の構造で Transfer Pricing 規制
- BVI / Cayman 等の Tax Haven 構造は **2026 年以降規制強化**（OECD Pillar Two）

### 10.4. 規制開示（Regulatory Disclosure）

- **Rule 15.093**: 上場後 / 上場準備中の開示義務:
  - **EDINET**（日本）: 有価証券報告書・四半期報告書・適時開示
  - **SEC EDGAR**（米国）: S-1 / 10-K / 10-Q / 8-K
  - **DPNDD**（欧州）: 同等の開示義務
- **Pre-IPO の Confidential Filing**: SEC は売上 $1.235B 未満の Emerging Growth Company に対し、IPO 直前まで Confidential Filing を許可。

### 10.5. ESG レポーティング

- **Rule 15.094**: Series B+ で投資家からの ESG 開示要求が増加（2026+）:
  - **CSRD**（EU 企業持続可能性報告指令）: 1,000 人以上は対応必須
  - **TCFD**（気候関連財務情報開示）: 上場企業の標準
  - **Sustainability KPI**: Carbon footprint / Diversity / Governance スコア

### 10.6. クロスリファレンス
- `security/100_data_governance.md` GDPR / PIPL / CCPA
- `security/300_ip_due_diligence.md` 法務一般

---

## Part XI: IPO 準備プロトコル

### 11.1. IPO の準備期間

- **Rule 15.100**: 一般的な IPO 準備期間は **18-36 ヶ月**:

```
T-36 ヶ月: ARR $50M 超えを目標、Path to Profitability 確立
T-24 ヶ月: 監査法人選定（Big 4 推奨）、Audit-Ready Financials
T-18 ヶ月: 主幹事（Lead Bank）選定、Legal Counsel 選任
T-12 ヶ月: SOX Compliance 構築、Board に独立社外取締役追加
T-9 ヶ月: S-1 ドラフト開始（Confidential Filing 含む）
T-6 ヶ月: Roadshow Pitch Deck 完成、IR チーム構築
T-3 ヶ月: Public Filing、Roadshow 開始
T-0: Pricing → Listing
```

### 11.2. 上場先選定

- **Rule 15.101**: 主要上場市場の比較:

  | 市場 | 規模目安 | 強み | 注意点 |
  |:--|:--|:--|:--|
  | **NYSE** | ARR $100M+ | 大型 IPO・Brand Prestige | 厳格な listing 基準 |
  | **NASDAQ** | ARR $50M+ | テック企業の本拠地 | 流動性高い |
  | **JPX グロース** | 売上数十億円 | 日本投資家アクセス | 海外投資家流動性低 |
  | **JPX スタンダード** | 中堅 | 日本標準 | |
  | **JPX プライム** | 大企業 | 最高ステータス | 厳格基準 |
  | **HKEX** | 多様 | アジア展開 | 政治リスク |
  | **LSE / Euronext** | 多様 | 欧州 | |

### 11.3. S-1 / Form 1-A 準備

- **Rule 15.102**: S-1（米国 IPO 目論見書）の主要セクション:
  - **Risk Factors**: 想定される全リスクの列挙（保守的に）
  - **Use of Proceeds**: 調達資金の使途
  - **MD&A**: Management's Discussion and Analysis（業績の解説）
  - **Financials**: 監査済み 3 期分の財務諸表
  - **Cap Table**: 完全開示

### 11.4. SOX Compliance（米国）

- **Rule 15.103**: Sarbanes-Oxley Act 404: **内部統制の整備・運用** 義務（公開後）
  - **Audit-Ready Financials**: 全取引の監査証跡
  - **SoD (Segregation of Duties)**: 職務分離
  - **ITGC (IT General Controls)**: アクセス管理・変更管理・運用管理
- **対応**: T-12 ヶ月から SOX チーム構築（CFO + Internal Audit Manager）

### 11.5. Direct Listing と SPAC の検討

- **Rule 15.104**: Traditional IPO 以外の選択肢:
  - **Direct Listing**: 既存株主が直接 NYSE/NASDAQ で売却（Underwriter なし、Spotify / Slack 採用）。新規調達なし
  - **SPAC merger**: 既存上場 SPAC との合併で上場（2021 年ピーク後縮小、現在 1/10）
  - **使い分け**: 知名度高 + 資金調達不要 = Direct Listing、迅速性優先 = SPAC、標準 = IPO

### 11.6. Lock-up & Greenshoe

- **Rule 15.105**:
  - **Lock-up**: IPO 後 180 日間、内部者の株式売却制限（典型）
  - **Greenshoe Option**: 主幹事が追加 15% を発行できる権利（株価安定化）
  - **Cliff Lock-up Expiration**: 180 日後一気に売り圧力 → 価格下落リスク

### 11.7. クロスリファレンス
- `security/300_ip_due_diligence.md` 法務一般

---

## Part XII: M&A Exit プロトコル

### 12.1. M&A vs IPO の判断

- **Rule 15.110**: Exit パスの選択基準:

  | 条件 | 推奨 Exit |
  |:--|:--|
  | ARR $50M+、独立成長性高 | IPO |
  | 戦略的買収候補が複数いる | M&A（戦略的シナジー） |
  | 創業者の Liquidity 優先 | M&A（即金） |
  | 市場が IPO に冷淡 | M&A or 待機 |
  | 創業者が更に経営継続したい | IPO（CEO 継続） |
  | バーンが厳しい | M&A（生存戦略） |

### 12.2. M&A 構造

- **Rule 15.111**: M&A の主要構造:

  | 構造 | 特徴 |
  |:--|:--|
  | **Stock Purchase** | 全株取得。買い手が全債務承継 |
  | **Asset Purchase** | 特定資産のみ取得。債務切離可能 |
  | **Forward Triangular Merger** | 子会社経由の合併（米国典型） |
  | **Reverse Triangular Merger** | ターゲット存続。Tax 効率良 |
  | **All-Stock Deal** | 買い手の株で対価支払（買い手株式が魅力的な場合） |
  | **All-Cash Deal** | 現金対価（即時 Liquidity） |
  | **Mixed (Cash + Stock)** | 一部現金・一部株 |

### 12.3. Indemnification（補償条項）

- **Rule 15.112**: 売却契約の補償条項:
  - **Cap**: 補償上限（取引額の 10-20% 標準）
  - **Basket / Threshold**: 補償が発動する最低損害額
  - **Survival Period**: 補償期間（12-24 ヶ月）
  - **Exclusions**: Fraud / IP / Tax は別の Cap や時効で扱われる

### 12.4. Escrow（エスクロー）

- **Rule 15.113**: 売却対価の一部を **エスクロー** で保管（補償原資）:
  - 取引額の 10-15%
  - 12-24 ヶ月後に解放
  - エスクロー期間中の補償発動で減額

### 12.5. Earnout（業績連動対価）

- **Rule 15.114**: 業績連動の追加対価:
  - 売却後 1-3 年の業績達成で追加支払
  - **Risk**: 買い手の投資判断・経営介入で目標達成が困難になる
  - **対応**: Earnout 計算式・買い手の善管注意義務を契約に明記

### 12.6. Acqui-hire（人材買収）

- **Rule 15.115**: 製品ではなく人材を取得する買収:
  - 創業者・主要エンジニアに Retention Bonus + 株式付与
  - 4 年 Vesting で離職防止
  - **Founder Reality**: Acqui-hire は失敗ではなく **次のキャリアへの橋**

### 12.7. クロスリファレンス
- `security/300_ip_due_diligence.md` 法務一般
- `operations/700_partnership_ecosystem.md` 戦略的パートナーシップ

---

## Part XIII: Founder Wellbeing & Crisis Communication

### 13.1. Founder Mental Health

- **Rule 15.120**: 創業者の **メンタルヘルス** は事業継続性のリスク:
  - **統計**: スタートアップ創業者の 72% がメンタルヘルス問題を経験（Michael Freeman 研究, UCSF）
  - **症状**: 燃え尽き / うつ / 不安障害 / 人間関係破綻
- **対応**:
  - 月 1 のセラピスト or コーチング（投資家経費として認める文化を作る）
  - **Founder Peer Group**: YC Founders' Office / 同期創業者ネットワーク
  - 配偶者・家族との時間確保（成果より相関する幸福度因子）

### 13.2. 危機伝達（Crisis Communication）

- **Rule 15.121**: 悪いニュース（Down Round / Layoff / 主要顧客解約）の伝達:
  - **Speed**: 24 時間以内に投資家・主要関係者に通知
  - **Honesty**: 言い訳・隠蔽せず事実 + 対応策を明示
  - **Action Plan**: 「これから何をするか」を併記
  - **Lead by Example**: 創業者自身の責任を認める姿勢

### 13.3. レイオフ（Layoff）の倫理

- **Rule 15.122**: 大規模レイオフ実施時のプロトコル:
  - **Severance**: 業界平均（米国: 2-12 週分の給与 + ベスト・継続健康保険）
  - **Communication**: 全社一斉ではなく Manager から個別通知
  - **Public Statement**: CEO による誠実な公表（Brian Chesky / Stripe Patrick の手紙が範例）
  - **離職した人への支援**: LinkedIn 紹介、リファレンス、求職支援

### 13.4. 創業者離脱の対応

- **Rule 15.123**: 共同創業者離脱時のプロトコル:
  - **Founder Buyback**: 未 Vest 株式の買戻し
  - **Earnout Mechanism**: 残存創業者の追加株式付与
  - **Investor Communication**: 即時 Early Warning（Part IX 参照）
  - **NDA / Non-compete**: 競業避止義務の確認

### 13.5. 危機時の Board 運営

- **Rule 15.124**: 危機時 Board Meeting の特別運営:
  - **Frequency**: 通常隔月 → 緊急週次
  - **Pre-read**: 24 時間前配布（通常 72 時間より短縮）
  - **Decision Pace**: 通常合議 → CEO 提案を Board が即時承認 / 拒否
  - **Ringfencing**: 危機対応 Board と業績 Board を分離

---

## Part XIV: Investor Tech Stack & AI 自動化

### 14.1. Cap Table & Equity Management

- **Rule 15.130**:
  - **Carta**: 業界標準。ESOP 管理 / 409A / Secondary。$10K-50K/年
  - **Pulley**: 価格優位、シンプル UI
  - **Capdesk** (UK): 欧州向け
  - **Shareworks**: 上場後・大企業向け

### 14.2. Investor Reporting

- **Rule 15.131**:
  - **Visible.vc**: 投資家向け月次レポート自動配信
  - **Carta CapTable Reports**: Carta 内製
  - **Notion + Mailchimp**: シンプル運用
  - **Quaestor**: AI 駆動の自動レポート生成

### 14.3. Investor CRM

- **Rule 15.132**:
  - **Affinity**: VC 業界標準の Relationship Intelligence
  - **HubSpot / Salesforce + custom**: 自社構築
  - **Streak**: Gmail 連携、軽量

### 14.4. Pitch Deck Tools

- **Rule 15.133**:
  - **DocSend**: 閲覧履歴・スクリーンショット防止
  - **Pitch.com**: コラボ作成
  - **Beautiful.ai**: AI デザイン補助
  - **Tome**: AI 駆動デッキ生成

### 14.5. AI-Augmented IR（2026+）

- **Rule 15.134**: AI による IR 自動化:
  - **AI 月次レポート要約**: 月次 metrics → AI で 1 ページ自動要約
  - **AI Investor Q&A**: 過去のレポートから類似質問への回答自動生成
  - **Sentiment Analysis**: 投資家のメール返信を AI で分析（関心度推定）
  - **CAUTION**: AI 出力は **必ず人間が承認** してから送信。誤情報リスク

### 14.6. Data Room Tools

- **Rule 15.135**:
  - **DocSend**: Pitch + Data Room 統合
  - **Datasite**: エンタープライズ DD（Big 4 標準）
  - **Carta Data Room**: Cap Table 連携

### 14.7. AI Governance for IR

- **Rule 15.136**: AI が生成したレポート・回答の **Human-in-the-Loop 義務**:
  - 月次レポートの最終チェックは CEO/CFO
  - 投資家への返信メールも人間レビュー
  - AI Hallucination による誤情報伝達は **Trust 破壊**

---

## Part XV: Anti-Pattern Catalog

### 15.0. Forbidden Practices Quick Reference

| カテゴリ | アンチパターン | 関連 |
|---|---|---|
| **Philosophy** | Fundraising as Validation（調達額を成功と錯覚） | §1.1 |
| **Philosophy** | 過剰調達 / Burn Multiple > 3 | §1.4 |
| **Timing** | Desperate な状態（Runway < 3 ヶ月）での交渉 | §2.2 |
| **Cap Table** | Excel での Cap Table 管理（Seed 以降） | §3.6 |
| **Cap Table** | Vesting なしの創業者株付与 | §3.2 |
| **Cap Table** | Option Pool Shuffle に気づかない | §3.3 |
| **SAFE** | Pre-money SAFE（v2.0+ あり） | §4.1 |
| **Pitch** | Vanity Metrics のみで Traction 提示 | §5.2 |
| **Pitch** | 機械翻訳のローカライズ | §5.6 |
| **Outreach** | Cold アウトリーチへの過度依存 | §6.2 |
| **Outreach** | 投資家 Reference Check を行わない | §6.4 |
| **Term Sheet** | Participating Preferred Stock を許容 | §7.4 |
| **Term Sheet** | Full Ratchet Anti-dilution | §7.4 |
| **Term Sheet** | 60+ 日 No-Shop | §7.4 |
| **DD** | 隠蔽（後で発覚した時のダメージは桁違い） | §8.2 |
| **DD** | Google Drive で Data Room 共有 | §8.3 |
| **IR** | Board Meeting での「驚き」 | §9.2 |
| **IR** | 月次レポートの遅延 / 未送付 | §9.1 |
| **IR** | Bad News 24h ルール違反 | §9.3 |
| **Compliance** | FEFTA / CFIUS の事前届出忘れ | §10.1 |
| **Compliance** | Pre-IPO Trading Window 違反 | §10.2 |
| **Compliance** | EDINET / SEC 開示遅延 | §10.4 |
| **IPO** | SOX 準備不足での Public Filing | §11.4 |
| **IPO** | Lock-up Expiration の管理放置 | §11.6 |
| **M&A** | Earnout の計算式が曖昧 | §12.5 |
| **M&A** | Indemnification Cap が高すぎる | §12.3 |
| **Wellbeing** | 創業者の燃え尽きを放置 | §13.1 |
| **Crisis** | Layoff の言い訳・責任転嫁 | §13.3 |
| **Tech** | AI 出力を人間チェックなく投資家に送信 | §14.7 |

---

## Appendix A: 逆引き索引（キーワード → セクション）

| キーワード | セクション |
|---|---|
| Default Alive / Ramen Profitability | §1 |
| Burn Multiple / Rule of 40 | §1.4, §1.5 |
| Pre-seed / Seed / Series A / Series B / C+ | §2.1 |
| Runway / Bridge Round | §2.4, §2.5 |
| Cap Table / Founder Vesting / Cliff | §3.1, §3.2 |
| ESOP / Option Pool Shuffle | §3.3 |
| 409A Valuation | §3.7 |
| Carta / Pulley | §3.6, §14.1 |
| SAFE (Y Combinator) / Post-money SAFE | §4.1 |
| Convertible Note / J-KISS / KISS | §4.3, §4.4 |
| Discount / Valuation Cap / MFN | §4.1 |
| Pitch Deck 15 Slide / Narrative | §5.1, §5.3 |
| Traction Slide / Vanity Metrics | §5.2 |
| Pitch Memo (Sequoia / a16z) | §5.5 |
| Warm Intro / Investor Funnel | §6.1, §6.2 |
| Investor Fit / Reference Check | §6.3, §6.4 |
| Liquidation Preference / Participating | §7.2 |
| Anti-dilution / Full Ratchet / Weighted Average | §7.3 |
| Pro-rata / Drag-along / ROFR | §7.1 |
| Red Flag Term Sheet | §7.4 |
| Competing Offers / FOMO | §7.5 |
| Data Room / Proactive Disclosure | §8.1, §8.2 |
| DocSend / Datasite | §8.3, §14.6 |
| 月次投資家レポート | §9.1 |
| Board Meeting / Board Pack | §9.2 |
| Early Warning Protocol | §9.3 |
| FEFTA / CFIUS / EU FDI | §10.1 |
| Insider Trading / MNPI / 10b5-1 Plan | §10.2 |
| QSBS / エンジェル税制 | §10.3 |
| EDINET / SEC EDGAR / S-1 | §10.4, §11.3 |
| ESG / CSRD / TCFD | §10.5 |
| IPO 準備期間 / 主幹事選定 | §11.1 |
| SOX Compliance | §11.4 |
| Direct Listing / SPAC | §11.5 |
| Lock-up / Greenshoe | §11.6 |
| M&A 構造 / Stock vs Asset Purchase | §12.2 |
| Indemnification / Escrow / Earnout | §12.3, §12.4, §12.5 |
| Acqui-hire | §12.6 |
| Founder Mental Health | §13.1 |
| Layoff Communication | §13.3 |
| Visible.vc / Quaestor / Affinity | §14 |
| AI-Augmented IR / Human-in-the-Loop | §14.5, §14.7 |
| Anti-Pattern Catalog | §15.0 |

---

## Appendix B: クロスリファレンス（セクション → 関連 Universal ルール）

| セクション | 関連 Universal ルール |
|---|---|
| §I 哲学 | `core/000_core_mindset.md` §1.8 Cost as First-Class Citizen |
| §II ステージ | `product/100_market_validation.md` PMF / Unit Economics |
| §III Cap Table | `operations/200_hr_organization.md` 人事・報酬 / `security/300_ip_due_diligence.md` 法務 |
| §IV SAFE | `product/300_revenue_monetization.md` 財務指標 |
| §V ピッチ | `product/100_market_validation.md` Market Size / `product/200_go_to_market.md` GTM |
| §VI 投資家選定 | `operations/700_partnership_ecosystem.md` Network |
| §VII Term Sheet | `security/300_ip_due_diligence.md` 法務 / `core/000_core_mindset.md` §1.31 Pre-Mortem |
| §VIII DD | `security/100_data_governance.md` / `security/200_oss_compliance.md` / `security/300_ip_due_diligence.md` |
| §IX IR | `core/000_core_mindset.md` §1.6 Observability-First / `ai/100_data_analytics.md` KPI |
| §X 規制 | `security/100_data_governance.md` / `security/000_security_privacy.md` |
| §XI IPO | `security/300_ip_due_diligence.md` / `operations/400_site_reliability.md` |
| §XII M&A | `security/300_ip_due_diligence.md` / `operations/700_partnership_ecosystem.md` |
| §XIII Wellbeing | `core/000_core_mindset.md` §1.16 Developer Wellbeing & Sustainable Velocity |
| §XIV Tech Stack | `ai/000_ai_engineering.md` / `core/000_core_mindset.md` §1.11 AI-Augmented Engineering |

---

**Last Updated**: 2026-05-06
**Authority**: Universal Constitution (axiarch core)
**Classification**: Product — Fundraising & Investor Relations
