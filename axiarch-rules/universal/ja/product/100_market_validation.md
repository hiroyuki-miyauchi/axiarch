# 11. 市場検証・PMF戦略 (Market Validation & Product-Market Fit)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-04-22

> [!IMPORTANT]
> **Supreme Directive（最高指令）**
> 「仮説は事実ではない。データのない確信は錯覚である」
> **43%のスタートアップがProduct-Market Fit（PMF）未達で失敗する（CB Insights, 2025/2026）。**
> ビルドの前に、まず市場に問え。学習を最大化せよ。コードよりエビデンスが先である。
> PMFは「到達点」ではなく「継続的に維持・進化させる生きた状態」である。
> **18パート・125+セクション・155ルール構成。**

---

## 目次

- [Part I. 市場検証の哲学](#part-i-市場検証の哲学)
- [Part II. 問題の発見と定義](#part-ii-問題の発見と定義)
- [Part III. 市場規模の定量化と市場タイミング](#part-iii-市場規模の定量化と市場タイミング)
- [Part IV. 顧客発見プロセス（Customer Discovery）](#part-iv-顧客発見プロセスcustomer-discovery)
- [Part V. 仮説の構造化と優先順位付け](#part-v-仮説の構造化と優先順位付け)
- [Part VI. 最小検証単位（MVP / MLP）の設計](#part-vi-最小検証単位mvp--mlpの設計)
- [Part VII. PMFの測定と判定](#part-vii-pmfの測定と判定)  ← §7.15 PMF Spectrum / §7.16 Reverse Trial / §7.17 Signal-Based Validation / §7.18 Prosumer PMF 含む
- [Part VIII. PMF達成後のスケール判断](#part-viii-pmf達成後のスケール判断)
- [Part IX. 競合分析フレームワーク](#part-ix-競合分析フレームワーク)  ← §9.6 AI時代の防御可能性設計 / §9.7 AI-Resistant Value 含む
- [Part X. ピボット判断プロトコル](#part-x-ピボット判断プロトコル)
- [Part XI. リサーチ・データ収集アーキテクチャ](#part-xi-リサーチデータ収集アーキテクチャ)
- [Part XII. PMF維持・Decay・進化プロトコル](#part-xii-pmf維持decay進化プロトコル)  ← §12.7 PMF期待値複利化リスク / §12.8 PMF Fragility Score 含む
- [Part XIII. PMF拡張（Adjacent Market Expansion）](#part-xiii-pmf拡張adjacent-market-expansion)
- [Part XIV. Demand-Side Validation & Pre-Revenue証明](#part-xiv-demand-side-validation--pre-revenue証明)
- [Part XV. AI-Native市場検証プロトコル](#part-xv-ai-native市場検証プロトコル)  ← §15.7 Outcome-Based PMF / §15.8 Multi-Agent PMF / §15.9 Zero-Click Discovery 含む
- [Part XVI. 市場検証の成熟度モデル（5段階）](#part-xvi-市場検証の成熟度モデル5段階)
- [Part XVII. アンチパターンカタログ（50選）](#part-xvii-アンチパターンカタログ50選)
- [Part XVIII. Appendix: 逆引き索引・クロスリファレンス](#part-xviii-appendix-逆引き索引クロスリファレンス)

---

## Part I. 市場検証の哲学

### 1.1. Build Trap 回避の原則

- **Rule 11.001**: 「作れるから作る」ではなく「需要があるから作る」を絶対原則とする
- **Rule 11.002**: 最初の3ヶ月で費やすリソースの50%以上を「検証」に充てること。ビルドへの過早な投資を禁止する
- **Build Trap の定義**: ユーザー価値ではなく機能数や出荷速度をもって進捗と誤認する状態。本憲法においてこれを重大なリスクと定義する
- **Rule 11.003**: 「作ってから売る」ではなく「売ってから作る」の順序を、特にPMF前フェーズにおいて徹底する

### 1.2. Validated Learning（検証済み学習）

- **Rule 11.004**: 全ての意思決定は「仮説」→「実験」→「測定」→「学習」のサイクルで行う
- **Rule 11.005**: 「私たちはこれが正しいと思う」という発言は仮説として扱う。確信として扱うことを禁止する
- **Lean Startup Loop**:

```
仮説（Build）→ 最小検証（Measure）→ データ分析（Learn）→ 次の仮説
```

- **Rule 11.006**: 学習速度こそが最大の競争優位であり、1サイクルの期間を最短2週間で回すことを標準とする

### 1.3. Evidence Hierarchy（エビデンス階層）

市場検証エビデンスの信頼性は以下の順序で高い：

| ランク | エビデンスタイプ | 信頼性 | 意思決定での使用 |
|:------|:--------------|:------|:--------------|
| 1 | 実際の購買・課金行動 | ★★★★★ | 投資判断に直接使用可 |
| 2 | 事前購入（Pre-order / LOI） | ★★★★ | 参入判断に使用可 |
| 3 | プロトタイプへのアクティブ利用 | ★★★★ | 機能優先順位に使用可 |
| 4 | ユーザーインタビュー（行動ベース） | ★★★ | 仮説構築に使用可 |
| 5 | アンケート・意向調査 | ★★ | 方向性の参考のみ |
| 6 | 競合の存在・市場トレンド | ★ | 文脈把握のみ |
| 7 | 「いいね」「面白い」などの感情的反応 | ✗（無効） | 意思決定に使用禁止 |

- **Rule 11.007**: ランク5以下のエビデンスのみで主要な投資判断を下すことを禁止する
- **Rule 11.008**: エビデンスのランクを「エビデンスの量」で代替することを禁止する（アンケート1万件 < 実課金10件）

### 1.4. 検証の時間価値（Time Value of Validation）

- **Rule 11.009**: 検証結果の価値は時間と共に減衰する。6ヶ月以上前の検証データで重要な意思決定を行うことを禁止する
- **検証データの有効期限**:

| データタイプ | 有効期限 | 再検証トリガー |
|:-----------|:--------|:-------------|
| 顧客インタビュー | 6ヶ月 | 市場環境の大変化 |
| PMFサーベイ | 3ヶ月 | 競合の大型アップデート |
| 市場規模推定 | 12ヶ月 | 規制変更・技術革新 |
| 競合分析 | 3ヶ月 | 競合の資金調達・M&A |
| 価格感度調査 | 6ヶ月 | 自社の機能追加・Tier変更 |

### 1.5. Founder-Market Fit（創業者-市場適合性）

- **Rule 11.015**: PMFの前提条件として、**Founder-Market Fit（FMF）**を評価する。FMFが弱い領域でのPMF達成確率は統計的に有意に低い
- **FMF の定義**: 創業チームが対象市場の課題を**深く理解し、解決するための独自の優位性**（ドメイン経験・技術力・ネットワーク・情熱）を持っている状態

- **Rule 11.016**: FMFを以下の5軸で評価し、総合スコア15点以上を推奨する

| 評価軸 | 配点 | 評価基準 |
|:------|:-----|:--------|
| **ドメイン経験** (Domain Expertise) | 0-5 | 業界経験10年+=5, 5年+=4, 2年+=3, 個人経験のみ=2, なし=0 |
| **課題の当事者性** (Problem Proximity) | 0-5 | 自分自身が毎日経験=5, 過去に経験=3, 第三者として観察=1 |
| **ユニークインサイト** (Unique Insight) | 0-5 | 他者が知らない市場の真実を持つ=5, 一般知識のみ=1 |
| **ネットワーク** (Network Access) | 0-5 | ICP企業の意思決定者に直接連絡可能=5, なし=0 |
| **執着度** (Obsession) | 0-5 | 10年間この問題に取り組む覚悟=5, 興味レベル=1 |

- **FMF Score ≥ 20**: 強いFMF（投資家からも高評価）
- **FMF Score 15-19**: 十分なFMF（補完可能な領域を特定せよ）
- **FMF Score < 15**: 弱いFMF（ドメインエキスパートの共同創業者採用を検討せよ）

- **Rule 11.017**: FMFが弱い場合の対策は「学習」ではなく「チーム構成の変更」を優先する。ドメインエキスパートをアドバイザーではなく共同創業者として迎えることを推奨する

- **Anti-Pattern**: 「技術が素晴らしいから市場は後から学べる」は危険な思考。市場理解のない技術は方向性を失う

---

## Part II. 問題の発見と定義

### 2.1. Jobs-to-be-Done（JTBD）フレームワーク

- **Rule 11.010**: 「プロダクトの機能」ではなく「ユーザーが達成したい仕事（Job）」を起点として設計する
- **JTBD の3層構造**:

```
Functional Job（機能的な仕事）: 実際に達成したいタスク
    例: 確定申告を期限内に正確に完了したい

Emotional Job（感情的な仕事）: その際に感じたいこと
    例: 不安なくやり遂げた達成感を感じたい

Social Job（社会的な仕事）: 他者からどう見られたいか
    例: 財務管理ができる人間として認識されたい
```

- **Rule 11.011**: Job Statement は以下の形式で記述する
  ```
  When [状況], I want to [動機], so I can [期待される成果]
  ```

### 2.2. Pain Severity Scoring（課題の深刻度スコアリング）

- **Rule 11.012**: 発見した課題を以下の基準でスコアリングし、取り組む優先順位を決定する

| 評価軸 | 配点 | 評価基準 |
|:------|:-----|:--------|
| **頻度** (Frequency) | 0-3 | 毎日=3, 週次=2, 月次=1, それ以下=0 |
| **深刻度** (Severity) | 0-3 | 業務停止=3, 著しく非効率=2, 軽微な不便=1, 気にならない=0 |
| **解決意欲** (Urgency) | 0-3 | 今すぐ払う=3, 予算があれば=2, 機会があれば=1, 変えたくない=0 |
| **代替手段の不満** (Dissatisfaction) | 0-3 | 代替手段なし=3, 非常に不満=2, 不満=1, 満足=0 |

- **Pain Score ≥ 8**: 取り組む価値がある課題
- **Pain Score 5-7**: 追加検証が必要
- **Pain Score < 5**: 市場機会として疑問視する

### 2.3. Problem Statement の形式化

- **Rule 11.013**: 取り組む課題を以下のフォーマットで明文化し、チーム全員が同じ問題を解こうとしていることを保証する

```
[ペルソナ] は [状況/コンテキスト] において
[課題/フラストレーション] を抱えており、
現在は [現在の解決策] を使っているが、
[不満点] のため、十分に解決できていない。
この課題の解決により、[定量的な効果] が期待できる。
```

### 2.4. Problem-Solution Gap 分析

- **Rule 11.014**: 課題の特定だけでは不十分。**現在の解決策と理想状態の間のGap**を定量化する

```
Gap Score = (理想状態の満足度 - 現状の満足度) × 頻度 × 影響人数

Gap Score ≥ 50: 強い市場機会
Gap Score 20-49: 検証の価値あり
Gap Score < 20: 優先度低
```

---

## Part III. 市場規模の定量化と市場タイミング

### 3.1. TAM / SAM / SOM の定義と算定

- **Rule 11.020**: 事業開始前に必ず TAM・SAM・SOM を定量化し、対象セグメントの経済的実行可能性を確認する

| 指標 | 定義 | 算定アプローチ |
|:----|:----|:------------|
| **TAM** (Total Addressable Market) | 課題を持つ全市場の規模 | Top-down（業界レポート）|
| **SAM** (Serviceable Addressable Market) | 実際にリーチ可能な対象市場 | Bottom-up（セグメント × 単価）|
| **SOM** (Serviceable Obtainable Market) | 現実的に獲得可能な市場 | 競合シェア・GTM能力から算定 |

- **Rule 11.021**: TAM ≥ 1,000億円、SOM ≥ 10億円を主要事業の参入基準目安とする（例外はBlueprintで定義）

### 3.2. Bottom-Up 市場算定プロトコル

- **Rule 11.022**: Top-down の市場レポートは「現実確認」として使用する。**戦略判断の根拠には必ず Bottom-up 試算を行う**

```
SOM = ターゲットユーザー数 × コンバージョン率 × ARPU × 12ヶ月

例:
ターゲットユーザー: 50万人
コンバージョン率: 3%
ARPU: 月額2,000円
SOM = 500,000 × 0.03 × 2,000 × 12 = 36億円/年
```

- **Rule 11.023**: Top-down一行計算（「市場は$1兆、1%取ればXX億」）は投資家から即座に棄却される。必ずBottom-up根拠を添える

### 3.3. 市場の成長性評価

- **Rule 11.024**: 現在の市場規模だけでなく **CAGR（複合年成長率）** を評価する
- **基準**: CAGR ≥ 15% の成長市場を優先する
- **Rule 11.025**: **市場の収縮が見込まれる領域（CAGR < 0%）への新規参入を原則禁止する**

### 3.4. 市場タイミング分析（Why Now Protocol）

- **Rule 11.026**: Bill Grossの研究（Idealab, 2015）によれば、スタートアップ成功の**最大要因はタイミング（42%）**であり、チーム（32%）やアイデア（28%）を上回る。「なぜ今なのか」を明示的に定義・文書化する

- **Why Now Canvas**:

```yaml
why_now_canvas:
  technology_shift: "どの技術変化が今この機会を可能にしているか"
  regulatory_shift: "どの規制変更が市場を開放/制限しているか"
  behavioral_shift: "どのユーザー行動の変化が需要を生んでいるか"
  economic_shift: "どのマクロ経済の変化が支出パターンを変えているか"
  competitive_vacuum: "なぜ既存プレイヤーがまだこの機会を捉えていないか"
  urgency_evidence: "1年後でも遅くないのか？今でなければならない根拠"
```

- **Rule 11.027**: Why Now Canvasの全項目に具体的回答がない場合、参入タイミングの妥当性を再評価する
- **Anti-Pattern**: 「AIが流行っているから」「DXの波に乗る」等の曖昧なタイミング根拠は無効。具体的な技術・規制・行動の変化点を特定する

### 3.5. 市場の構造分析

- **Rule 11.028**: 市場規模だけでなく、市場の**構造的特性**を評価する

| 評価項目 | 好ましい状態 | 警戒すべき状態 |
|:--------|:-----------|:-------------|
| 断片化度 | 多数の小規模プレイヤー | 2-3社による寡占 |
| 顧客のスイッチングコスト | 低い（参入しやすい） | 極端に高い |
| 規制障壁 | 低い/新規参入に有利 | 許認可・免許が必須 |
| テクノロジーリスク | 確立技術の応用 | 基礎研究段階の技術依存 |
| 供給者の交渉力 | 複数の代替供給者 | 単一の依存先（例: 1社のAPI）|

### 3.6. 規制リスク評価プロトコル（Regulatory Risk Assessment）

- **Rule 11.029**: 規制産業（FinTech・HealthTech・EdTech・InsurTech・AI/ML）への参入前に、以下の規制リスク評価を**必ず**実施する

```yaml
regulatory_risk_assessment:
  target_jurisdictions:
    - jurisdiction: "日本"
      applicable_laws: ["資金決済法", "金商法", "個人情報保護法", "AI事業者ガイドライン"]
    - jurisdiction: "EU"
      applicable_laws: ["GDPR", "EU AI Act", "PSD2/PSD3", "DORA"]
    - jurisdiction: "US"
      applicable_laws: ["CCPA/CPRA", "SEC規制", "HIPAA", "FTC Act Section 5"]
  license_requirements:
    required: [true|false]
    estimated_timeline: "XX ヶ月"
    estimated_cost: "$XXX"
  compliance_burden:
    level: [low|medium|high|prohibitive]
    ongoing_cost_percentage: "売上の XX%"  # 継続的コンプライアンスコスト
  regulatory_trajectory:
    trend: [loosening|stable|tightening]
    upcoming_changes: "2026-2027年の予定される規制変更"
  go_no_go_decision:
    proceed: [true|false]
    conditions: "進行するための前提条件"
```

- **Rule 11.029a**: 規制リスク評価で `compliance_burden: prohibitive` と判定された場合、参入を中止するか、規制のクリアランスを**PMF検証より前に**完了する
- **Anti-Pattern**: 「まずプロダクトを作ってから規制対応を考える」は、開発リソースの全損リスク。規制産業ではRegulatory PMF（規制適合性）が市場PMFの前提条件

### 3.7. Regulatory Sandbox活用プロトコル

- **Rule 11.160**: 規制産業（FinTech・HealthTech・AI/ML・InsurTech）への参入において、**Regulatory Sandbox**（規制サンドボックス）の活用可能性を事前に評価する
- **Regulatory Sandboxの定義**: 規制当局の監督下で、規制を一時的に緩和・適用除外し、革新的なプロダクト・ビジネスモデルの実証実験を行える制度的枠組み

- **Rule 11.161**: Sandbox参加の判断基準

| 判断基準 | Sandbox推奨 | 通常の規制対応で十分 |
|:--------|:-----------|:-------------------|
| 既存規制への適合性 | 不明確・グレーゾーン | 明確に適合可能 |
| 参入タイムライン | 規制クリアに12ヶ月超 | 6ヶ月以内に対応可能 |
| 投資家シグナル | Sandbox参加が信頼性を向上 | 既に規制クリア済み |
| 業界の成熟度 | 規制フレームワークが未確立 | 確立済みの規制環境 |

- **Rule 11.162**: Sandbox参加のPMF検証への効果
  - **投資家シグナル**: Sandbox参加は規制リスクの軽減を投資家に示す有力なエビデンス
  - **規制クリアランス加速**: 規制当局との直接対話により、本格展開時の許認可取得を加速
  - **市場検証の精緻化**: 実環境に近い条件下での検証により、PMF判定の精度が向上
  - **制約**: Sandbox内での検証結果は地理的・期間的に限定されるため、スケール時の再検証が必要

- **Anti-Pattern**: 「Sandboxは大企業のもの」は誤認。多くの国（日本・UK・シンガポール・UAE等）でスタートアップ向けSandboxが整備されている

---

## Part IV. 顧客発見プロセス（Customer Discovery）

### 4.1. 顧客インタビュープロトコル

- **Rule 11.030**: 製品の開発開始前に最低 **20名との顧客インタビュー** を実施する
- **Rule 11.031**: インタビューは以下の禁止事項を徹底する

| 禁止事項 | 理由 |
|:--------|:----|
| 「〜だと思いますか？」という誘導質問 | 確証バイアスを強化する |
| プロダクトのアイデアを先に述べる | 相手が忖度して肯定的に答える |
| 「将来的には〜しますか？」という仮定質問 | 意向と行動は乖離する |
| ソリューションへのフィードバックを求める | 課題の発見ではなく検証になる |
| 1回のインタビューで全てを聞こうとする | 深掘りが浅くなり表面的な回答を得る |

- **The Mom Test 原則**: アイデアを話さずに課題だけを掘り下げる。自分の母親でも嘘をつけないような質問だけをする

### 4.2. 顧客インタビューの質問設計

**推奨する質問パターン:**

```
Phase 1: 課題の存在確認
1. 「[課題領域] において、最も大変なことは何ですか？」
2. 「その問題が最後に起きたのはいつですか？その時のことを教えてください」

Phase 2: 現在の解決策の深掘り
3. 「今はどうやってその問題を解決していますか？」
4. 「そのやり方で何が不便ですか？」
5. 「その解決策にいくら払っていますか？（時間・お金・労力）」

Phase 3: 支払い意欲の確認
6. 「この問題を解決するために実際にお金を払ったことはありますか？」
7. 「もっと良い解決策があれば、今の方法を捨てますか？」
8. 「それが明日存在したら、いくらまでなら払いますか？」
```

### 4.3. Early Adopter の特定プロトコル

- **Rule 11.032**: 最初のユーザーは「アーリーアダプター」に絞る。大衆市場を同時に狙うことを禁止する
- **アーリーアダプターの5条件**:
  1. 課題を強く認識している
  2. すでに解決しようとしている（行動している）
  3. 解決策のためにお金を払っている（または払う意思がある）
  4. 不完全なソリューションでも容認できる
  5. フィードバックを提供する時間と意欲がある

- **Rule 11.033**: アーリーアダプターの特定にはリバースエンジニアリングを活用する

```
1. 競合製品のレビュー（不満コメント）を収集する
2. 関連フォーラム・Slack・Discordで課題を議論しているユーザーを見つける
3. HackerRank・ProductHunt・Reddit等で類似ソリューションを積極的に探しているユーザーを特定する
4. 業界カンファレンスのQ&Aで課題を質問しているユーザーを見つける
```

### 4.4. 顧客インタビューの分析プロセス

- **Rule 11.034**: インタビュー後24時間以内にメモを構造化し、以下の形式で記録する

```yaml
interview_record:
  id: "INT-001"
  date: "YYYY-MM-DD"
  persona_match: [high|medium|low]
  early_adopter_score: 0-5  # 5条件の充足数
  top_pain: "最も深刻な課題の簡潔な記述"
  pain_severity_score: 0-12  # §2.2のスコアリング
  current_solution: "現在の代替手段"
  switching_cost: [high|medium|low]
  willingness_to_pay: [confirmed|likely|unlikely|no]
  stated_budget: "$XX/month"
  key_quote: "インタビューの重要な発言（原文）"
  signals:
    - type: [strong_positive|positive|neutral|negative|strong_negative]
      category: [pain|solution|pricing|timing|competition]
      note: "具体的な気づき"
  follow_up: "次のアクション"
```

### 4.5. Signal Strength Scoring（インタビューシグナル強度集計）

- **Rule 11.035**: 個別インタビューの「気づき」を組織的な意思決定に昇格させるため、シグナル強度を集計する

```
Signal Strength = (Strong Positive × 3 + Positive × 2 + Neutral × 0 
                   + Negative × -1 + Strong Negative × -3) / インタビュー数

Signal Strength ≥ 2.0: 強い市場シグナル → MVP開発に進む
Signal Strength 1.0-1.9: 中程度 → 追加10件のインタビュー
Signal Strength < 1.0: 弱い → 課題定義の再検討
```

### 4.6. AI-Augmented Interview Analysis

- **Rule 11.036**: インタビュー分析にAIを活用する場合は以下のプロトコルに従う
  - AI文字起こし（Whisper等）による全文テキスト化を推奨する
  - AIによるセンチメント分析・キーワード抽出は**補助ツール**として活用する
  - **禁止**: AI分析結果のみで仮説を確定する。必ず人間による解釈と検証を経る
  - AIが検出したパターン（例: 「20名中15名が同じフラストレーションに言及」）は定量的エビデンスとして記録する

### 4.7. Community-Led Validation（コミュニティ主導検証）プロトコル

- **Rule 11.037**: DevTool・OSS・B2D（Business-to-Developer）市場では、従来のインタビューに加えて**コミュニティシグナル**を検証エビデンスとして活用する

| コミュニティシグナル | 測定方法 | PMF相関度 |
|:-----------------|:--------|:---------|
| **GitHub Star成長率** | 週次Star増加数 | 中（Vanity Metricリスクあり） |
| **Issue/PR投稿者のユニーク数** | 月次ユニークContributor数 | 高（実際のエンゲージメント） |
| **Discord/Slack DAU** | コミュニティプラットフォームのDAU | 高 |
| **StackOverflow質問数** | 月次新規質問数の増加傾向 | 中 |
| **ユーザー作成コンテンツ** | ブログ記事・チュートリアルの自発的投稿数 | 非常に高 |
| **Word-of-Mouth NPS** | コミュニティ内での推薦率 | 非常に高 |

- **Rule 11.038**: コミュニティ主導検証の成功基準
  - **初期段階（0-6ヶ月）**: ユニークContributor ≥ 20名/月、Discord/Slack DAU ≥ 50名
  - **成長段階（6-12ヶ月）**: ユーザー作成コンテンツ ≥ 5件/月、コミュニティ起点のバグレポート ≥ 30%
  - **Anti-Pattern**: GitHub Starのみでの検証判断は「Vanity Metric Trap」。必ず利用頻度・Contributor数と組み合わせる

- **Rule 11.038a**: **AI-Driven Community Demand Mining（AI駆動コミュニティ需要マイニング）**
  - AIセマンティック検索を活用し、Reddit・Discord・Slack・HackerNews・StackOverflow等からペインポイントを自動抽出する
  - **手法**: LLMベースのキーワードクラスタリングにより、「現行ツールへの不満」「代替手段の探索」「具体的な業務上のフラストレーション」を自動分類する
  - **探索キーワードパターン**: `"current tool sucks"`, `"is there a way to"`, `"looking for alternative"`, `"frustrated with"`, `"wish there was"`
  - **出力形式**: ペインポイント×頻度×センチメント強度のヒートマップを作成し、Pain Severity Score（§2.2）の補完データとして使用する
  - **制約**: AIマイニング結果は「仮説の種」であり、必ず人間によるインタビュー（§4.1）で検証する。マイニング結果のみでの仮説確定を禁止する
  - **Anti-Pattern**: 「AIがペインポイントを見つけたから検証不要」はSynthetic Research Overreliance（§15.2）の変形。必ず実在ユーザーでの三角測量を実施する

### 4.8. 動的ICP精緻化プロトコル（Dynamic ICP Refinement）

- **Rule 11.039**: ICP（Ideal Customer Profile）は**静的な定義ではなく、検証データに基づき継続的に精緻化**する生きたドキュメントである

```
ICP精緻化サイクル（月次実施）:

1. データ収集: 過去30日間の新規顧客・解約顧客の属性を収集
2. パターン分析:
   - 高LTV顧客に共通する属性を特定
   - 早期解約顧客に共通する属性を特定
   - PMF Composite Scoreが高いコホートの特徴を抽出
3. ICP更新:
   - 「Must-Have」属性（PMF達成コホートの90%以上が持つ特徴）
   - 「Nice-to-Have」属性（PMF達成コホートの60-89%が持つ特徴）
   - 「Disqualify」属性（早期解約コホートの60%以上が持つ特徴）
4. GTMへの反映:
   - 広告ターゲティング・営業リストの更新
   - ICP Scoring Model（200_go_to_market.md参照）の再キャリブレーション
```

- **Anti-Pattern**: 「ICPは事業計画書に一度書いたら変えない」は危険。市場からのフィードバックを無視したICPは機会損失の元凶

---

## Part V. 仮説の構造化と優先順位付け

### 5.1. Assumption Map（仮説マッピング）

- **Rule 11.040**: 事業に「重要かつ未検証の仮説」を洗い出し、優先度マトリクスに配置する

```
        高リスク（重要度高）
              │
   最優先     │   監視
  （Critical）│ （Watch）
              │
  ────────────┼────────────
  未検証      │        検証済み
              │
   後回し     │   前提として扱う
  （Defer）   │ （Established）
              │
        低リスク（重要度低）
```

### 5.2. Leap of Faith 仮説の識別

- **Rule 11.041**: ビジネス全体が成立するための「信仰の跳躍（Leap of Faith）仮説」を明示する
  - **Value Hypothesis**: ユーザーは実際にこの製品を使うか？（需要の存在）
  - **Growth Hypothesis**: どうやって新しいユーザーを獲得するか？（チャネルの存在）
  - **Revenue Hypothesis**: ユーザーはこの製品に適正価格を支払うか？（WTPの存在）

### 5.3. 仮説ログの義務化

- **Rule 11.042**: 全ての主要仮説を Blueprint 内の仮説ログで追跡する

| 列 | 内容 |
|:--|:----|
| 仮説ID | H-001 形式 |
| 仮説の内容 | 具体的な記述 |
| カテゴリ | Value / Growth / Revenue / Technical / Legal |
| 重要度 | Critical / High / Medium / Low |
| ステータス | 未検証 / 検証中 / 検証済 / 否定済 |
| 検証方法 | 実験設計 |
| 成功基準 | 事前に定義した閾値 |
| 結果 | データと知見 |
| 学習日 | YYYY-MM-DD |
| 次のアクション | 次ステップの記述 |

### 5.4. Riskiest Assumption Test（RAT）

- **Rule 11.043**: 最もリスクの高い仮説（Most Critical + Most Unknown）を最初にテストする
- 全ての仮説に同時に取り組むことを禁止する。RAT順でシーケンシャルに検証する
- RAT実行プロトコル:
  1. 仮説マップから「Critical × 未検証」の仮説を特定
  2. その仮説を**最短で検証できる実験**を設計（最大2週間）
  3. 実験の成功/失敗基準を**事前に**定義
  4. 結果を仮説ログに記録
  5. 次のRATに進む

---

## Part VI. 最小検証単位（MVP / MLP）の設計

### 6.1. MVP の定義の明確化

- **Rule 11.050**: MVP は「最低限の機能セット」ではなく「最も速く学習できる実験単位」と定義する
- **Rule 11.051**: MVP の種類と用途を以下の通り定義する

| MVP タイプ | 説明 | 用途 | 検証期間目安 |
|:----------|:----|:----|:-----------|
| **Concierge MVP** | 手動でサービスを届ける | 需要・意欲の検証 | 2-4週間 |
| **Wizard of Oz MVP** | 自動化に見せかけて手動実行 | UXと実現可能性の同時検証 | 4-6週間 |
| **Landing Page MVP** | LPのみで反応率を測定 | 需要・メッセージの検証 | 1-2週間 |
| **Prototype MVP** | インタラクティブモックアップ | UXの検証 | 2-4週間 |
| **Pre-order MVP** | 開発前に販売する | 支払い意欲の最高検証 | 2-4週間 |
| **Fake Door MVP** | 存在しない機能のUI/CTAを設置 | 機能ニーズの定量測定 | 1-2週間 |
| **Email-First MVP** | メール/ニュースレターで価値提供 | コンテンツ価値の検証 | 4-8週間 |
| **API-First MVP** | プロダクトなし、APIのみ | 技術的需要の検証（B2B向け） | 4-6週間 |
| **AI-Magnet MVP** | ターゲットの1つの課題を解決する小規模AI無料ツール | ターゲット集客・利用データ収集・Pain仮説の検証 | 2-4週間 |

### 6.2. MLP（Minimum Lovable Product）プロトコル

- **Rule 11.052**: B2Cおよび体験差別化が重要な市場では、MVPを超えた**MLP（Minimum Lovable Product）**を目指す
- **MVP vs MLP の差異**:
  - **MVP**: 「動くか（Functional）」を検証する → 課題が存在するかの確認
  - **MLP**: 「喜ぶか（Delightful）」を検証する → 感情的な差別化の確認
- **MLP の設計原則**:
  - 機能数は最小に保ちつつ、**コア体験の品質を最大化**する
  - 計測指標: NPS ≥ 50 かつ 「友人に薦めたいか」の7点以上が40%以上

### 6.3. Prototype Fidelity Matrix

- **Rule 11.053**: 検証の目的に応じてプロトタイプの忠実度を適切に選択する

| 忠実度 | ツール例 | 検証対象 | 適切な場面 |
|:------|:-------|:--------|:---------|
| **Lo-Fi（低忠実度）** | 紙スケッチ・Whimsical | 情報設計・フロー | 初期仮説検証 |
| **Mid-Fi（中忠実度）** | Figma ワイヤーフレーム | UI構造・ナビゲーション | ユーザビリティテスト |
| **Hi-Fi（高忠実度）** | Figma プロトタイプ | ビジュアル・インタラクション | 投資家デモ・ユーザーテスト |
| **Functional（機能プロトタイプ）** | No-code / 実コード | 技術的実現可能性・実利用 | PMF前の実証 |

### 6.4. MVPのスコープ制限プロトコル

- **Rule 11.054**: MVP に含める機能は「1つのコアバリュー仮説を検証できる最小セット」に限定する
- **Rule 11.055**: MVP の開発期間は **最大8週間** とする。それを超える場合はスコープを削減する
- **Rule 11.056**: MVP で「学習するもの」を開発開始前に明文化する。曖昧なまま開発に入ることを禁止する

```yaml
mvp_charter:
  hypothesis_id: "H-001"
  learning_goal: "ターゲットユーザーはXXの課題に対してYY円/月を支払う意欲があるか"
  mvp_type: "concierge"
  success_criteria: "5名中3名以上が有料契約に同意する"
  failure_criteria: "5名中1名以下の場合、課題定義を再検討する"
  max_duration: "4 weeks"
  max_budget: "50万円"
```

### 6.5. Smoke Test（スモークテスト）プロトコル

- **Rule 11.057**: ビルド前に以下のスモークテストを実施し、参入判断の合理性を確認する

```
スモークテスト成功基準（標準値）:
- LP のメールアドレス収集率 ≥ 15%
- LP の有料Waitlist登録率 ≥ 5%
- インタビューでの事前購入意向（Signed LOI） ≥ 5件
- アーリーアクセス申込み ≥ 100件（30日以内）
- Fake Door CTRate ≥ 5%
```

### 6.6. Pre-PMF価格感度検証プロトコル

- **Rule 11.058**: PMFフェーズにおいても、「価格は後から決める」とせず、**価格感度の初期検証**を実施する。価格設定の詳細は `400_pricing_strategy.md` に委譲するが、PMF前の最低限の検証を本セクションで定義する

- **Rule 11.059**: Pre-PMF価格検証の3ステップ

```
Step 1: 簡易Van Westendorp（2問版）
  インタビュー中に以下の2問を追加:
  Q1: 「このプロダクトに月いくらまでなら不満なく支払えますか？」
  Q2: 「月いくら以上だと『高すぎる』と感じますか？」
  → Q1とQ2の交点が「最適価格帯」の初期仮説となる

Step 2: Fake Price Test
  LPまたはFake Doorで価格を提示し、CTR/コンバージョンを測定:
  - 価格提示ありのCTR ≥ 3%: 価格帯が許容範囲
  - 価格提示なしCTRとの差が≥ 50%: 価格抵抗が強い。再検証必要

Step 3: Anchor Price Experiment
  Design Partner・アーリーアダプターに実際の価格を提示し、反応を分類:
  - 「値段に全く言及せず契約」: 強いWTP
  - 「交渉後に契約」: 中程度のWTP
  - 「価格で辞退」: 価格が主なブロッカー
```

- **Anti-Pattern**: 「まずPMFを達成してから価格を考える」は、Unit Economics Gate（§8.4）での後戻りリスク。価格検証はPMF検証と並行して行う

---

## Part VII. PMFの測定と判定

### 7.1. PMF の定義

- **Rule 11.060**: PMFを以下のように定義する
  - **定性的定義**: 「プロダクトが特定の市場のニーズを満たし、ユーザーが自発的に利用し続け、かつ他者に推薦する状態」
  - **定量的定義**: 後述のPMF Composite Scoreが閾値を超えた状態

### 7.2. PMF Composite Score（PMF総合スコア）

- **Rule 11.061**: 以下の複数指標を加重平均し、PMF Composite Scoreを算出する。**単一指標での宣言を禁止する**

```
PMF Composite Score = (Sean Ellis Score × 0.30)
                    + (Retention Score × 0.25)
                    + (NPS Score × 0.15)
                    + (Organic Growth Score × 0.15)
                    + (Revenue Quality Score × 0.15)

各指標のスコア換算（0-100）:
- Sean Ellis: "Very Disappointed" % × 2.5（40% = 100, 0% = 0）
- Retention: D30 Retention ÷ 業界標準 × 100（業界標準達成 = 100）
- NPS: (NPS + 100) ÷ 2（NPS 100 = 100, NPS -100 = 0）
- Organic Growth: Organic % × (100/30)（30% = 100）
- Revenue Quality: Paid Conversion % × 対象係数

PMF Composite Score ≥ 70: PMF達成
PMF Composite Score 50-69: PMF接近（重点改善）
PMF Composite Score < 50: PMF未達
```

### 7.3. PMF の主要測定指標

| 指標 | PMF 閾値目安 | 計算方法 |
|:----|:-----------|:--------|
| **Sean Ellis Test** | 「なくなったら非常に困る」≥ 40% | アンケート調査（n ≥ 50） |
| **Net Promoter Score (NPS)** | ≥ +50（コンシューマ）/ ≥ +30（B2B） | 推薦意欲 0-10点調査 |
| **Retention Curve** | 傾きが水平に収束すること | コホート別継続率グラフ |
| **Organic Growth Rate** | 新規獲得の ≥ 30% がオーガニック | チャネル別集計 |
| **Engagement Depth** | DAU/MAU ≥ 20%（SNS/メッセージ系） | アクティブユーザー比 |
| **Paid Conversion** | Free→Paid ≥ 2%（PLG） | コンバージョン計測 |

### 7.4. Superhuman PMF Engine（4ステップ反復プロトコル）

- **Rule 11.062**: Rahul Vohra（Superhuman CEO）が体系化した**PMF Engine**を採用し、PMFを「感覚」ではなく「継続的に改善可能なスコア」として管理する

**4ステップ反復プロセス:**

```
Step 1: Survey（サーベイ）
  以下の4問を実際のユーザー50名以上に実施する:
  Q1: 「このプロダクトが使えなくなったら、どう感じますか？」
      □ 非常に残念 □ やや残念 □ 残念ではない □ すでに使っていない
  Q2: 「このプロダクトが最も役立つのはどんな人だと思いますか？」
  Q3: 「このプロダクトから得られる最大の価値は何ですか？」
  Q4: 「このプロダクトをどのように改善できますか？」

Step 2: Segment（セグメント）
  Q1で「非常に残念」と答えた High-Expectation Customers（HXC）を特定する。
  Q2の回答からHXCのペルソナパターンを発見する。
  HXC以外のユーザーのフィードバックをフィルタリングする。

Step 3: Analyze（分析）
  Q3から「HXCが愛する理由」を特定する → コア価値として強化する
  Q4から「やや残念層のブロッカー」を特定する → 改善対象とする
  ただし改善はHXCの体験を損なわない範囲に限る。

Step 4: Implement（実装）
  ロードマップの50%を「コア価値の強化」に、50%を「ブロッカーの解消」に配分する。
  次のスプリント後に再度Step 1を実施し、スコアの変化を追跡する。
```

- **Rule 11.063**: PMF Engineは**毎月最低1回**のサイクルを回すことを義務とする。PMFは一度達成して終わりではなく、継続的に向上させる

### 7.5. B2B vs B2C PMF判定分岐プロトコル

- **Rule 11.064**: B2BとB2Cでは PMF の測定手法と閾値が根本的に異なる。以下の分岐テーブルに従う

| 指標 | B2B SaaS | B2C Consumer | B2B2C / Marketplace |
|:----|:---------|:------------|:-------------------|
| **Sean Ellis閾値** | ≥ 40%（n ≥ 30） | ≥ 40%（n ≥ 100） | Supply: ≥ 35%, Demand: ≥ 40% |
| **NPS** | ≥ +30 | ≥ +50 | Net ≥ +40 |
| **D30 Retention** | ≥ 80% | ≥ 25% | Supply: ≥ 60%, Demand: ≥ 30% |
| **Organic Growth** | ≥ 20% | ≥ 30% | Demand先行でOK |
| **Revenue Signal** | 3社以上の有料契約 | Free→Paid ≥ 2% | Take Rate安定 |
| **特有指標** | Logo Churn ≤ 5%/月 | DAU/MAU ≥ 20% | Liquidity Score ≥ 0.3 |
| **最小検証サンプル** | 10社以上 | 500ユーザー以上 | Supply 50+, Demand 200+ |

### 7.6. Retention Curve 分析プロトコル

- **Rule 11.065**: コホート別のリテンション曲線を毎週モニタリングし、以下を確認する

```
健全な Retention Curve の特徴:
1. 初期の急落後（Day 1以降）、カーブが水平に収束する
2. D30 での Retention が業界標準を超える:
   - SNS・メッセージ系: ≥ 25%
   - SaaS (Professional): ≥ 80%
   - EC: ≥ 20%（3ヶ月内再購入率）
   - ゲーム: ≥ 15%
   - FinTech: ≥ 40%
3. コホートが改善傾向にある（最新コホート > 旧コホート）
4. Power Userセグメント（上位10%）のRetentionが異常に高い（生態系の「核」）
```

### 7.7. Cohort-Level PMF分析

- **Rule 11.066**: 全体のPMFスコアは「良いコホートが悪いコホートを隠す」リスクがある。**コホート別PMF分析**を必須とする
- コホートの分割軸:
  - 獲得チャネル別（Organic / Paid / Referral）
  - 獲得時期別（月次コホート）
  - ペルソナ別（ICP一致度スコア別）
  - 地域別
- **Rule 11.067**: 特定のコホート（例: Organic経由 × ICP高一致）でPMFを達成しても、他のコホートで未達成の場合、「Segment PMF」として記録し、全体PMF宣言を保留する

### 7.8. False PMF シグナルの警戒プロトコル

- **Rule 11.068**: 以下の状況は「偽のPMFシグナル」として扱い、PMF達成と誤認することを禁止する

| 偽シグナル | 理由 | 正しい対応 |
|:---------|:----|:---------|
| 友人・知人のみが使っている | 社会的圧力による利用 | 全くの他人50人以上で再検証 |
| 無料期間中のみ高利用 | 価格感度を検証していない | 有料転換率で再測定 |
| PR・バズ後の一時的急増 | 持続性が未検証 | 1ヶ月後のリテンションで判断 |
| 特定イベント依存の利用 | 再現性がない | イベント外での利用率を測定 |
| 投資家・アドバイザーの「素晴らしい」 | 市場の代表ではない | ICP一致ユーザーで再検証 |
| 大企業1社の大型契約 | 再現性が未検証 | 同セグメント3社以上で再現性確認 |
| AI機能への興奮 | Novelty Effectの可能性 | 2ヶ月後の継続利用率で判断 |
| 高い初期アクティベーション | オンボーディングの一時的効果 | D14/D30での本質的利用率で判断 |

### 7.9. Leading vs Lagging PMF指標

- **Rule 11.069**: PMF指標をLeading（先行）とLagging（遅行）に分類し、先行指標で素早いフィードバックループを回す

| Leading（先行指標）| Lagging（遅行指標）|
|:----------------|:----------------|
| Aha Moment到達率 | D30 Retention |
| Time-to-Value（TtV） | NPS |
| コア機能利用率（DAU内） | Sean Ellis Score |
| サポートチケットのセンチメント | Logo Churn Rate |
| 紹介意向（Q: 薦めたい？） | Organic Growth % |
| Session Depth（平均セッション深度） | NRR（Net Revenue Retention） |
| PQL Conversion Rate（PQL転換率） | Expansion MRR成長率 |

### 7.10. Marketplace & Network Effect PMFプロトコル

- **Rule 11.075**: マーケットプレイス型プロダクトでは、**Supply側とDemand側のPMFをそれぞれ独立に測定**する。片側のみのPMFはPMF未達成として扱う

| 指標 | Supply側 | Demand側 | 総合 |
|:-----|:--------|:---------|:-----|
| **Sean Ellis** | ≥ 35% | ≥ 40% | Net ≥ 38% |
| **Retention** | ≥ 60% (D30) | ≥ 30% (D30) | 加重平均 |
| **Liquidity Score** | — | — | ≥ 0.3 |
| **Time to Match** | — | — | 業界標準の50%以下 |
| **Take Rate安定性** | — | — | 3ヶ月連続で変動係数 ≤ 10% |

- **Rule 11.076**: Marketplaceの「Chicken-and-Egg」問題楚決プロトコル

```
Chicken-and-Egg 解決戦略（優先順）:

1. Supply-First: 供給側を先に確保する（該当: コンテンツ・サービスマP）
   - 数量的目標: ローンチ時にSupply ≥ 50ユニット
   - 手法: 初期無料リスティング・コンシェルジュオンボーディング

2. Single-Player Mode: ネットワークなしでも価値のある機能を提供
   - 例: OpenTable（予約管理ツールとしての価値）

3. Constrained Launch: 地理的・カテゴリ的に制限したローンチ
   - Liquidityを達成しやすい狭いセグメントから開始

4. Subsidized Demand: 初期ユーザーをインセンティブ（クーポン等）で獲得
   - 警告: インセンティブ終了後のRetentionでPMFを判定すること
```

- **Rule 11.077**: Marketplace PMFの**Liquidity Score**算出式

```
Liquidity Score = 成約数 / (リスティング数 × 検索数)

Liquidity Score ≥ 0.3: 健全なMarketplace
  → SupplyとDemandのマッチングが機能している
Liquidity Score 0.1-0.29: 改善必要
  → 検索精度・リスティング品質の向上が必要
Liquidity Score < 0.1: 危機的
  → ビジネスモデルの再設計が必要
```

### 7.11. Platform & API製品のPMFプロトコル

- **Rule 11.078**: 開発者向けプロダクト（API・SDK・Platform）のPMFは、消費者向けとは測定指標が根本的に異なる

| 指標 | PMF閾値目安 | 計算方法 |
|:-----|:-----------|:--------|
| **API Call成長率** | MoM ≥ 15% | 月次APIコール数 |
| **Developer Retention (D90)** | ≥ 70% | 90日後もアクティブな開発者 |
| **Time to First API Call** | ≤ 30分 | サインアップから初回APIコールまで |
| **Integration Depth** | ≥ 3 endpoints利用 | 平均利用エンドポイント数 |
| **3rd Party App数** | ≥ 10（プラットフォーム） | 外部開発者による統合アプリ数 |
| **NPS（Developer NPS）** | ≥ +40 | 開発者向けサーベイ |

- **Rule 11.079**: Platform PMFの特有指標 — **Developer Experience Score (DXS)**

```
Developer Experience Score (DXS) 算出:

DXS = (Docs Quality × 0.25)
    + (Time to Hello World × 0.25)
    + (Error Message Clarity × 0.15)
    + (SDK/CLI Usability × 0.20)
    + (Community Support Quality × 0.15)

各指標: 開発者サーベイ（n ≥ 30）で1-5点で評価、100点換算

DXS ≥ 80: 優秀なDX（Stripe・ Twilio水準）
DXS 60-79: 改善余地あり
DXS < 60: DXがPMFのボトルネック
```

- **Anti-Pattern**: 「開発者はドキュメントさえあれば使う」は誤り。20分以内にHello Worldに到達できないAPIは評価対象外

### 7.12. Expansion Revenue & NRR as PMF Signal

- **Rule 11.163**: PMF達成後のスケールフェーズにおいて、**NRR（Net Revenue Retention）**をPMFの持続性を測る遅行指標として追跡する

```
NRR = (期初MRR + Expansion MRR - Contraction MRR - Churn MRR) / 期初MRR × 100

NRR ≥ 130%: Best-in-class（Snowflake・Twilio水準）
NRR 110-129%: 健全なPMF持続
NRR 100-109%: PMF維持のボーダーライン
NRR < 100%: PMF Erosionの兆候 → §12.4 早期警告システムを起動
```

- **Rule 11.164**: Expansion Revenueの構成要素を分類し、PMFの「深さ」を評価する

| Expansion タイプ | 定義 | PMF示唆 |
|:---------------|:----|:--------|
| **Seat Expansion** | 同一顧客内のユーザー数増加 | プロダクトのバイラル性 |
| **Tier Upgrade** | 上位プランへの移行 | 機能価値の認知向上 |
| **Usage Growth** | 従量課金の使用量増加 | コアワークフローへの定着 |
| **Cross-sell** | 追加プロダクト・モジュールの購入 | プラットフォーム価値の拡大 |

- **Rule 11.165**: NRR < 100%が3ヶ月連続で続いた場合、PMF Composite Scoreの如何に関わらず「Revenue PMF Erosion」として扱い、§12.5の対応プロトコルを起動する

### 7.13. PLG-SLG Hybrid PMFプロトコル

- **Rule 11.166**: 2026年において、PLG（Product-Led Growth）とSLG（Sales-Led Growth）の二項対立は解消されている。**Product-Led Sales（PLS）**として統合的にPMFを測定する

- **Product-Qualified Lead (PQL) の定義と活性化メトリクス**:

```
PQL定義フレームワーク:
  PQL = (利用頻度 ≥ X回/週) AND (コア機能利用 ≥ Y種) AND (最終ログイン ≤ Z日以内)

  具体例（B2B SaaS）:
  - 週3回以上ログイン
  - 3つ以上のコア機能を利用
  - チーム内で2名以上がアクティブ
  - 直近7日以内にログイン

  PQL Conversion Rate（PQL→有料転換率）≥ 15%: 健全なPLS
  PQL Conversion Rate < 5%: PQL定義の再キャリブレーションが必要
```

- **Rule 11.167**: **Natural Rate of Growth (NRG)** を製品の自律的成長力の指標として追跡する

```
NRG = 年間売上成長率 × Organicチャネル比率 × PLG起因売上比率

NRG ≥ 50%: 強い自律的成長力（Slack・Zoom水準）
NRG 20-49%: 中程度（Sales補完が有効）
NRG < 20%: PLGモーションが機能していない
```

- **Rule 11.168**: PLG→PLS遷移の判断基準

| 遷移トリガー | 閾値 |
|:-----------|:-----|
| 無料ユーザーからのEnterprise問い合わせ | 月5件以上 |
| Average Contract Value (ACV) | $25K以上の案件が出現 |
| セキュリティ・コンプライアンス要件 | SOC2/HIPAA等の要求 |
| PQL→有料転換率の平均ACV | Self-serveの3倍以上 |

- **Rule 11.169**: **Behavioral Cohort Analysis（行動ベースコホート分析）**を時系列ベースコホートの補完として必須とする
  - 従来の月次コホート（登録月別）に加え、**特定の行動を実行したコホート**と**しなかったコホート**のRetentionを比較する
  - 「活性化行動」（Aha Momentに到達する行動）を特定し、オンボーディングフローの最適化に活用する
  - **Smile Curve（スマイルカーブ）**: Retentionが初期低下後に安定・上昇するパターンは、PMFが深化している強いシグナル

### 7.14. Vertical SaaS & Embedded Product PMFプロトコル

- **Rule 11.170**: **Vertical SaaS**（業種特化型SaaS）のPMFは、汎用SaaSとは異なる指標で測定する

| 指標 | Vertical SaaS PMF閾値 | 汎用SaaSとの違い |
|:----|:---------------------|:----------------|
| **Workflow Completion Rate** | ≥ 80% | 業務フロー全体の完遂率（部分利用は不十分） |
| **業界固有NPS** | 業界平均+20pt | 業界ごとにNPS基準が異なる（医療 vs IT） |
| **Regulatory Compliance Rate** | 100% | 業界規制への完全準拠が前提条件 |
| **System of Record化率** | ≥ 50% | 顧客がSoR（正式な記録システム）として採用 |
| **D90 Retention** | ≥ 85% | 業務システムは短期でのスイッチが困難 |

- **Rule 11.171**: **Embedded Product**（組込型プロダクト: Embedded FinTech・Embedded Insurance等）のPMF測定

| 指標 | PMF閾値 | 計算方法 |
|:----|:--------|:--------|
| **API統合深度** | ≥ 3エンドポイント利用 | パートナー企業の平均統合深度 |
| **Transaction Volume成長率** | MoM ≥ 20% | 月次トランザクション数 |
| **Partner Retention (D180)** | ≥ 90% | パートナー企業の180日後継続率 |
| **End-User Activation Rate** | ≥ 30% | パートナー経由のエンドユーザー活性化率 |
| **Revenue per Partner** | 月次成長 | パートナー当たり売上の月次推移 |

- **Anti-Pattern**: 「汎用SaaSと同じPMF指標でVertical SaaSを評価する」と、業務フロー完遂率やSystem of Record化率といった本質的な指標を見逃す

### 7.15. PMF Spectrum（段階的PMFモデル）

- **Rule 11.180**: PMFは「あり/なし」の二値判定ではなく、**4段階のスペクトラム**として管理する。各段階で重点的に追うべき指標と活動が異なる

| 段階 | 名称 | ARR目安 | 状態の定義 | 重点指標 | 重点活動 |
|:-----|:-----|:--------|:----------|:--------|:--------|
| **S1** | **Nascent（萌芽）** | $0-$500K | 3-5社のDesign Partnerが課題の深刻さを確認。初期の価値仮説が成立 | Pain Severity Score, LOI数, Design Partner満足度 | 顧客発見, RAT, Concierge MVP |
| **S2** | **Developing（発展）** | $500K-$5M | 繰り返し可能な販売チャネルが見え始める。Churnが高いが学習速度が高い | PMF Composite Score, Churn率, チャネル別CAC | GTMモーション確立, ICP精緻化, 価格検証 |
| **S3** | **Strong（確立）** | $5M-$25M | 予測可能なUnit Economics（NRR > 110%, CAC Payback < 18ヶ月）。需要が供給能力を超え始める | NRR, Burn Multiple, CAC Payback Period | スケール基盤構築, 組織拡大, マルチチャネル最適化 |
| **S4** | **Extreme（極大）** | $25M+ | 自己増殖的な成長。複数のプロダクトライン・地理的展開を視野に入れる | Revenue Growth Rate, Gross Margin, NRG | マルチプロダクト, 国際展開, プラットフォーム化 |

- **Rule 11.181**: 段階間の移行判定基準

```
S1 → S2 移行条件:
□ PMF Composite Score ≥ 50
□ 有料顧客 ≥ 5社（B2B）/ 100ユーザー（B2C）
□ 1つ以上の獲得チャネルで再現性が確認できている

S2 → S3 移行条件:
□ PMF Composite Score ≥ 70
□ NRR ≥ 110%（B2B SaaS）
□ CAC Payback Period ≤ 18ヶ月
□ 月間Churn ≤ 5%（B2C）/ ≤ 3%（B2B）

S3 → S4 移行条件:
□ PMF Composite Score ≥ 80（3四半期安定）
□ §8.1の全トランジション基準を充足
□ 組織がFounder依存から脱却している
```

- **Anti-Pattern**: S1（Nascent）からS4（Extreme）へ一気に飛ぼうとする「段階スキップ」は禁止。各段階の基盤が次段階の前提条件となる

### 7.16. Reverse Trial 検証プロトコル

- **Rule 11.182**: PLG/PLSの検証モデルとして、**Reverse Trial（逆転トライアル）**を評価対象に含める
- **Reverse Trialの定義**: ユーザーにサインアップ時から**全プレミアム機能へのアクセスを付与**し、トライアル期間終了後に無料プランへダウングレードするモデル。従来のFree TrialやFreemiumの欠点を補完する

```
Reverse Trial設計原則:

1. 全機能開放期間: 14-30日間（プロダクト複雑度に応じて調整）
2. ダウングレード後の維持機能: コア価値の50%以上を維持（完全ロックアウトは禁止）
3. 心理設計:
   - 損失回避（Loss Aversion）: ユーザーが全機能体験後に「失う」感覚を活用
   - 習慣形成: 2週間以上の利用でワークフローに組み込まれる
4. 計測指標:
   - Trial→Paid転換率: ≥ 25%（標準Freemiumの5-10%を大幅に上回ること）
   - ダウングレード後のDAU維持率: ≥ 40%（完全離脱でないことを確認）
   - Time-to-Aha: トライアル期間の前半（7日以内）でAha Momentに到達していること
```

- **Rule 11.183**: Reverse Trialが有効な条件

| 条件 | Reverse Trial推奨 | 従来モデルで十分 |
|:-----|:-----------------|:---------------|
| 価値の体感速度 | 使い込むほど価値が明確になる | 初回利用で価値が明確 |
| ワークフロー統合度 | 日常業務に深く統合される | スタンドアロンで完結 |
| スイッチングコスト | 利用開始後に高くなる | 常に低い |
| プロダクト複雑度 | 高い（全機能を見ないと価値不明） | 低い（機能が少ない） |

- **Anti-Pattern**: 「Reverse Trialは全員に有効」は誤り。Time-to-Valueが短い（即時に価値が明確な）プロダクトでは、従来のFreemiumが適切な場合もある

### 7.17. Signal-Based PMF Validation（シグナルベースPMF検証）

- **Rule 11.184**: 静的なサーベイ（Sean Ellis Test等）に加え、**リアルタイムの行動シグナル**をPMF判定の補完手法として活用する

- **Rule 11.185**: Intent Signal（意図シグナル）の分類と活用

| シグナルカテゴリ | 具体的シグナル | PMFとの相関度 | 活用方法 |
|:--------------|:------------|:------------|:--------|
| **Product Signal** | コア機能の利用頻度, セッション深度, 機能間の遷移パターン | 非常に高 | PMF Leading Indicatorとして追跡 |
| **Expansion Signal** | チーム内招待, 新ワークスペース作成, API Key発行 | 高 | PQL定義（§7.13）への統合 |
| **Market Signal** | 競合ページの訪問→自社復帰, 価格ページの頻繁な閲覧 | 中-高 | Churn予防・価格感度分析 |
| **Intent Signal** | 「○○ integration」の検索, ヘルプセンターの高度機能閲覧 | 中 | アップセル・クロスセルの機会検出 |

- **Rule 11.186**: Signal-Based ICP Refinement
  - §4.8（動的ICP精緻化）を行動シグナルで補強する
  - **高PMFコホートの行動パターン**を機械学習で抽出し、ICP定義を自動更新する
  - 「属性ベースICP」（業界・企業規模）から「行動ベースICP」（特定の行動パターンを示すユーザー）への進化を推進する

```
Signal-Based PMF Dashboard（推奨構成）:
  Tier 1（リアルタイム）: コア機能DAU, Aha Moment到達率, PQL転換率
  Tier 2（週次）: Signal Strength Score, Behavioral Cohort比較, NRG
  Tier 3（月次）: PMF Composite Score, Sean Ellis Test, NRR
```

- **Anti-Pattern**: 「シグナルだけでPMFを判定する」はデータ至上主義の罠。定量的シグナルは必ず定性的インサイト（インタビュー・VoC）と三角測量する

### 7.18. Prosumer PMF Validation Protocol

- **Rule 11.200**: **Prosumer（Professional × Consumer）**セグメントは、B2CとB2Bの境界に位置し、いずれの標準PMFフレームワークでも正確に捕捉できない固有の検証プロトコルを要する

- **Rule 11.201**: Prosumerセグメントの定義と識別基準

| 属性 | 定義 | 例 |
|:----|:----|:---|
| **ペルソナ** | 個人として製品を採用し、やがて組織全体に拡大する専門家 | フリーランスデザイナー、独立コンサルタント、DevToolの個人開発者 |
| **購買パターン** | 個人のクレジットカードで開始→経費精算→組織契約へ拡大 | Figma、Notion、GitHub Copilot |
| **価値判断** | 「仕事の効率」と「個人の満足度」の両軸で評価 | 生産性ツール、クリエイティブツール |

- **Rule 11.202**: Prosumer PMF固有の測定指標

| 指標 | 定義 | PMF閾値 |
|:----|:----|:--------|
| **Personal→Team Expansion Rate** | 個人利用開始→チーム/組織に拡大した割合 | ≥ 15% |
| **Weekend Usage Ratio** | 平日と週末の利用率の比（高いほどPersonal Fitが強い） | ≥ 30%（週末利用が平日の30%以上） |
| **Self-Serve→Sales Assisted Conversion** | セルフサーブで開始し、営業支援を経て組織契約に至った割合 | ≥ 10% |
| **Tool Evangelism Score** | ユーザーが自発的に同僚・コミュニティに推奨した頻度 | NPS ≥ 60 かつ 推奨行動実績あり |
| **Workflow Centrality Index** | ユーザーの日常ワークフローにおける製品の中心度（1-5） | ≥ 3.5 |

- **Rule 11.203**: Prosumer PMFの段階的検証プロセス

```
Prosumer PMF検証フロー:

Phase 1: Individual Fit（個人適合性）
  - 個人ユーザーがAha Momentに到達し、日常的に利用する
  - 検証: D7 Retention ≥ 60%, TtV ≤ 3日

Phase 2: Evangelism（伝道）
  - ユーザーが自発的に同僚・コミュニティに推奨する
  - 検証: Organic Referral Rate ≥ 20%, Tool Evangelism Score ≥ 60

Phase 3: Team Adoption（チーム採用）
  - 個人→チーム/部門への拡大が発生する
  - 検証: Personal→Team Expansion Rate ≥ 15%

Phase 4: Enterprise Conversion（企業契約）
  - チーム利用→組織全体の正式導入
  - 検証: Self-Serve→Sales Assisted Conversion ≥ 10%
```

- **Rule 11.204**: Prosumer価格検証の特殊性
  - **Individual Tier**: 個人で支払える範囲（$10-$30/月）でPMFを検証する
  - **Team Tier**: Individual Tierの3-5倍の価格で追加価値（コラボレーション・管理機能）を提供
  - **Enterprise Tier**: セキュリティ・コンプライアンス・SSO等の組織要件を満たす
  - Prosumer PMFの真の検証は「Individual Tierで獲得したユーザーがTeam Tierに自然移行するか」で判定する

- **Anti-Pattern**: 「B2B価格でProsumerに売る」は採用障壁を作る。逆に「Consumer価格で放置」はEnterprise転換の機会を逃す。段階的な価格エスカレーション設計が必須

---

## Part VIII. PMF達成後のスケール判断

### 8.1. PMF→ Growth へのトランジション基準

- **Rule 11.070**: 以下の **全条件を満たした場合のみ** マーケティング投資を拡大する

```
必須条件（AND）:
□ PMF Composite Score ≥ 70
□ Sean Ellis Test ≥ 40%（n≥50）
□ D30 Retention が業界標準を上回っている
□ NPS ≥ 30
□ CAC 回収期間 ≤ 12ヶ月
□ 有機的成長（Organic）が全獲得の ≥ 20%
□ Unit Economics が成立している（LTV/CAC ≥ 3.0）
```

### 8.2. Premature Scaling 禁止令

- **Rule 11.071**: PMF未達成での広告費増額、採用拡大、新機能乱発は「Premature Scaling」として明示的に禁止する
- **根拠**: CB Insights の分析では、スタートアップ失敗の74%がPMF前の過早なスケールが起因
- **Premature Scaling の具体的禁止行為**:

| 禁止行為 | PMF前に許容される範囲 |
|:--------|:-------------------|
| 有料広告への月100万円超投資 | LP実験用の最大30万円/月 |
| エンジニア5名超の採用 | 創業チーム + 1-2名 |
| 多機能同時開発 | 1コアバリュー仮説に集中 |
| 2カ国以上への同時展開 | 1市場での完全PMF達成 |
| 外部セールスチームの構築 | 創業者セールスのみ |
| サードパーティ統合の大量実装 | コアに必要な1-2統合のみ |

### 8.3. スケール前の Product Health Check

- **Rule 11.072**: スケール移行前に以下のプロダクトヘルスチェックを実施する

| チェック項目 | 基準 |
|:-----------|:----|
| Core Feature Activation Rate | ≥ 60%（登録ユーザーのコア機能到達率） |
| Onboarding Completion Rate | ≥ 50% |
| Support Ticket / DAU | ≤ 5%（サポート依存度が低いこと） |
| Page Load Performance | LCP ≤ 2.5秒 |
| Uptime | ≥ 99.5%（過去30日間） |
| Error Rate | ≤ 1%（クリティカルエラー） |
| CSAT（顧客満足度） | ≥ 4.0/5.0 |

### 8.4. Unit Economics Gate（PMF→Scale前の経済性確認）

- **Rule 11.073**: PMFを宣言しても、Unit Economicsが成立しなければスケールに進まない

| 指標 | スケール許可の最低基準 |
|:----|:--------------------|
| LTV/CAC | ≥ 3.0 |
| Payback Period | ≤ 12ヶ月 |
| Gross Margin | ≥ 60%（SaaS）/ ≥ 40%（AI-Native） |
| Monthly Churn | ≤ 5%（B2C）/ ≤ 3%（B2B） |
| Burn Multiple | ≤ 2.0 |

- **Rule 11.074**: Unit Economicsが基準未達の場合、「収益モデルPMF（Revenue PMF）」が未達成として扱い、価格戦略の再検討（`400_pricing_strategy.md`参照）を義務とする

---

## Part IX. 競合分析フレームワーク

### 9.1. 競合マッピングプロトコル

- **Rule 11.080**: 参入前に直接・間接競合を以下の4象限でマッピングする

```
            高性能・高価格
                 │
    ニッチ競合   │   リーダー競合
                 │
  ─────────────────────────────
  狭い対象       │           広い対象
                 │
    弱小競合    │    挑戦者競合
                 │
            低性能・低価格
```

### 9.2. 競合分類の拡張

- **Rule 11.081**: 競合は3層で分析する

| 層 | 定義 | 例 |
|:--|:----|:--|
| **Direct（直接競合）** | 同じ課題を同じ方法で解くプレイヤー | Notion vs Coda |
| **Indirect（間接競合）** | 同じ課題を異なる方法で解くプレイヤー | Notion vs Excel + Email |
| **Alternative（代替手段）** | 顧客が現在使っている非プロダクト解決策 | 紙のノート、口頭伝達、何もしない |

### 9.3. 差別化の原則（10x Better Rule）

- **Rule 11.082**: 競合に対して「10倍良い（10x Better）」点を1つ以上定義する。「少し良い（2x Better）」は参入根拠として不十分と定義する
- **10x Better の定義**:
  - 速さが10倍（Uber vs タクシー待ち時間）
  - コストが1/10（Airbnb vs ホテル）
  - アクセスが10倍簡単（Canva vs Photoshop）
  - 体験が劇的に優れている（iPhone vs ガラケー）
  - データ精度が10倍（AI分析 vs 手動分析）

### 9.4. Moat（競争の堀）の設計

- **Rule 11.083**: 参入段階から競争優位性（Moat）を意識的に設計する

| Moat タイプ | 説明 | 構築期間 | 例 |
|:----------|:----|:--------|:--|
| **Network Effects** | ユーザーが増えるほど価値向上 | 長期 | Slack, WhatsApp |
| **Switching Costs** | 乗り換えコストが高い | 中期 | Salesforce, SAP |
| **Data Moat** | 独自データの蓄積 | 中長期 | Google, Netflix |
| **Economies of Scale** | 規模が大きいほど有利 | 長期 | Amazon |
| **Brand** | ブランドへの信頼・愛着 | 長期 | Apple, Nike |
| **Regulatory Moat** | 規制・ライセンスによる参入障壁 | 変動 | 金融業、医療機器 |
| **AI Moat** | 独自のモデル/データによるAI優位性 | 中期 | AlphaFold |

- **Rule 11.084**: AI Moatに関する2026年の現実認識: AI機能のみによる差別化は急速に陳腐化する。AIをMoatに含める場合は、**独自データの蓄積（Data Flywheel）**とセットで設計する

### 9.5. Blue Ocean vs Red Ocean 判定

- **Rule 11.085**: 参入市場をBlue Ocean（未開拓市場）とRed Ocean（既存競争市場）に分類し、戦略を選択する

| 判定基準 | Blue Ocean | Red Ocean |
|:--------|:----------|:---------|
| 競合数 | 0-2社 | 5社以上 |
| カテゴリの確立度 | 未確立 | 確立済み |
| 差別化軸 | 新しい価値軸を定義できる | 既存軸での競争 |
| 推奨戦略 | Category Creation（§000参照） | 10x Better + Segment Focus |
| リスク | 市場自体の不存在 | 価格競争・マージン圧迫 |

### 9.6. AI時代の防御可能性設計（Defensibility in the AI Era）

- **Rule 11.187**: 2026年、AIが機能的能力をコモディティ化した結果、防御可能性は「コード」ではなく「時間が強化する非機能的資産」から生まれる

| Moatカテゴリ | 定義 | 構築難度 | 例 |
|:-----------|:-----|:--------|:---|
| **Memory as Moat（記憶堀）** | 長期的なコンテキスト蓄積により、利用するほど価値が増す。ステートレスRAGでは複製不可能 | 高 | コードベース全体を理解するAI、個人の嗜好を学習するアシスタント |
| **Learning Velocity（学習速度堀）** | ユーザーインタラクションからの構造化されたシグナル収集→モデル改善の速度が競合を凌駕 | 高 | 業界特化データで日々精度が向上するVertical AI |
| **Reliable Execution（信頼性堀）** | 決定論的ガードレール・監査ログ・エスカレーションプロトコルにより、単純なプロンプトベースのラッパーが競合不可能な信頼性を実現 | 中-高 | ミッションクリティカルなワークフロー自動化 |
| **Proprietary Workflow Data（固有ワークフローデータ堀）** | 業務が「実際にどう行われているか」に関するプロセスレベルの深いインサイト | 高 | 大企業が容易に複製できない「汗のデータ」 |

- **Rule 11.188**: **Data Flywheel → Learning Velocity → Memory Moat の循環構造**を設計すること

```
Data Flywheel循環構造:

  ユーザーインタラクション
       ↓
  構造化シグナル収集（意図・コンテキスト・成果）
       ↓
  モデル/プロダクト改善（Learning Velocity）
       ↓
  ユーザー体験の向上 → Aha Moment加速
       ↓
  長期コンテキスト蓄積（Memory as Moat）
       ↓
  スイッチングコスト増大 → Retention強化
       ↓
  (循環: 更なるユーザーインタラクション)
```

- **Rule 11.189**: 防御可能性自己評価チェック

```
AI時代の防御可能性スコアカード（四半期評価）:
□ Memory: ユーザー固有のコンテキストが蓄積されているか？ (1-5)
□ Learning: ユーザー増加に伴い精度/価値が測定可能に向上しているか？ (1-5)
□ Reliability: ミッションクリティカルな環境で信頼されているか？ (1-5)
□ Workflow Data: 競合が容易に入手できない業務データを保有しているか？ (1-5)

合計 ≥ 16: 高い防御可能性
合計 12-15: 中程度（補強が必要）
合計 < 12: 防御可能性が脆弱 → §9.4 Moat再設計を実施
```

- **Anti-Pattern**: 「AI機能自体がMoat」という幻想。2026年のAIにおいて、機能は数週間で複製される。Moatは機能の「外側」（データ・信頼・ワークフロー統合）に構築すること

### 9.7. AI-Resistant Value（AI耐性価値）の3層構造

- **Rule 11.205**: 2026年、AIは基本的なSaaS機能を数日で複製可能にした。PMFの持続には「AIが複製できない価値」（AI-Resistant Value）を**3つの層**で構築する必要がある

| 層 | 定義 | 構築方法 | 例 |
|:---|:----|:--------|:---|
| **Layer 1: AI-Proof Core** | 独自データ・深い業界関係・規制インフラに紐づく価値 | プロプライエタリデータの蓄積、業界パートナーシップの構築、規制ライセンスの取得 | Bloomberg Terminal（金融データ）、Epic（医療記録） |
| **Layer 2: Integration Moat** | レガシーシステム・複雑な社内ワークフロー・組織変革プロセスへの深い統合 | エンタープライズ統合の深化、業務プロセスへの不可逆的な組み込み | Workday（HR統合）、Palantir（政府システム統合） |
| **Layer 3: Outcome Guarantee** | 「機能」ではなく「成果」を保証する価値提供モデル | 成果報酬型・ROI保証型の価格/契約モデルの構築 | 「90日以内にコストXX%削減」保証型SaaS |

- **Rule 11.206**: **Defensibility Stress Test（防御可能性ストレステスト）**
  - 四半期ごとに以下の問いを実施し、防御可能性を定量評価する

```
40%防御可能性テスト:

質問: 「競合チームが2週間、最新のAIツールを駆使したら、
       我々の提供価値の何%を現実的に再構築できるか？」

判定:
  再構築可能率 ≤ 20%: 高い防御可能性（AI-Resistant Value が強固）
  再構築可能率 21-40%: 中程度（補強計画を策定）
  再構築可能率 41-60%: 脆弱（6ヶ月以内にLayer 1-3の強化が必須）
  再構築可能率 > 60%: 危険（PMFが持続不可能。即座にMoat再設計）
```

- **Rule 11.207**: AI-Resistant Value の構築は**§9.4 Moat設計**および**§9.6 AI時代の防御可能性**と統合して管理する。3つのフレームワークの統合ビュー:
  - **§9.4**: 伝統的Moatの7類型（Network Effects, Switching Costs, etc.）
  - **§9.6**: AI固有の防御可能性4軸（Memory, Learning Velocity, Reliability, Workflow Data）
  - **§9.7**: AI-Resistant Valueの3層構造（AI-Proof Core, Integration Moat, Outcome Guarantee）

- **Anti-Pattern**: 「Outcome Guaranteeは大企業にしかできない」は誤り。スタートアップでも限定的なスコープ（特定業務の効率化など）でのOutcome保証は可能であり、PMFの強力なシグナルとなる

---

## Part X. ピボット判断プロトコル

### 10.1. ピボット判断の客観的基準

- **Rule 11.090**: ピボットは「感情」ではなく「データ」で決定する。以下のトリガーがある場合、ピボットを検討する

| ピボットトリガー | 定義 |
|:--------------|:----|
| **PMF未達成** | 2回以上の MVP 検証でも PMF Composite Score < 50 |
| **リテンション崩壊** | D30 Retention < 10%（3コホート連続） |
| **CAC > LTV** | 3ヶ月連続で単位経済が成立しない |
| **市場の消滅** | 規制変更・技術変化により市場が消滅 |
| **競合優位性の喪失** | 大手参入により差別化が無意味化 |
| **チームのモチベーション崩壊** | 創業チームの課題への確信が消失 |

### 10.2. ピボットの種類

- **Rule 11.091**: ピボットを行う場合、その種類を明確に定義する

| ピボットタイプ | 例 |
|:------------|:--|
| **Zoom-in Pivot** | 機能の一部がプロダクト全体になる |
| **Zoom-out Pivot** | プロダクトが大きなシステムの一部になる |
| **Customer Segment Pivot** | 対象顧客を変える |
| **Platform Pivot** | アプリからプラットフォームへ |
| **Business Architecture Pivot** | B2C から B2B2C へ |
| **Value Capture Pivot** | 収益モデルを変える |
| **Technology Pivot** | 同じ問題を異なる技術で解く |
| **Channel Pivot** | GTMチャネルを変更する |

### 10.3. ピボット実行プロトコル

- **Rule 11.092**: ピボットを実行する際は以下のプロセスを必ず経る
  1. 現在の仮説ログを「否定済み」に更新
  2. ピボットの種類を明確に定義・文書化
  3. ピボット後の新しい Leap of Faith 仮説を定義
  4. 新しい MVP とサクセスメトリクスを設計
  5. 既存ユーザーへの影響を評価し、通知計画を策定
  6. チーム全員への説明と再コミットメント
  7. 新しいWhy Now Canvas（§3.4）を作成

### 10.4. Pivot vs Persevere の意思決定フレームワーク

- **Rule 11.093**: ピボット検討時は以下の3軸で評価する

```
Persevere（継続）の条件:
□ PMF Composite Scoreが前四半期比で改善している
□ 少なくとも1つのコホートでPMFシグナルが出ている
□ 改善の明確なレバーが特定できている
□ チームに確信と学習意欲が残っている

Pivot（転換）の条件:
□ 3サイクル以上の検証でスコアが横ばいまたは下降
□ 顧客の課題認識が薄いという根本的問題がある
□ 市場タイミング（§3.4）が変化した
□ より有望な隣接機会が発見された
```

### 10.5. Kill Criteria（事業撤退基準）

- **Rule 11.094**: ピボットではなく**事業の完全撤退**を判断する基準を事前に定義する
- **Kill Criteria の標準テンプレート**:

```
以下のいずれかを満たした場合、事業撤退を検討する:
□ 残存Runway ≤ 6ヶ月 かつ PMF Composite Score < 50
□ 3回のピボットを経てもPMFシグナルが出ない
□ 創業チームの主要メンバーが2名以上離脱
□ 規制変更により事業モデルが違法化
□ 大手の参入により市場の90%以上が独占された
```

---

## Part XI. リサーチ・データ収集アーキテクチャ

### 11.1. Mixed Methods（定量×定性）プロトコル

- **Rule 11.100**: 市場調査は定量（Quantitative）と定性（Qualitative）を必ず組み合わせる

| 手法 | 役割 | 実施タイミング | 最小サンプル |
|:----|:----|:------------|:-----------|
| **定性インタビュー** | 「なぜ？」を理解する | 仮説構築フェーズ | 20名 |
| **定量調査・アンケート** | 「どれくらい？」を測る | 仮説検証フェーズ | 100名 |
| **行動データ分析** | 「実際に何をしたか？」を見る | PMF 継続測定 | DAU ≥ 100 |
| **A/Bテスト** | 「どちらが良いか？」を測る | 最適化フェーズ | 統計的有意性達成 |
| **ユーザビリティテスト** | 「使えるか？」を見る | プロトタイプフェーズ | 5名 |

### 11.2. 市場調査データの品質管理

- **Rule 11.101**: 収集するデータに以下の品質基準を適用する

| バイアスタイプ | 防止策 |
|:------------|:------|
| **生存バイアス** | 成功例だけでなく失敗例も収集する |
| **確証バイアス** | 仮説を否定するデータを積極的に探す（Devil's Advocate） |
| **自己報告バイアス** | 意図ではなく行動データを優先する |
| **サンプリングバイアス** | ターゲット外のユーザーを排除する |
| **社会的望ましさバイアス** | 匿名回答を提供し、行動ベースの質問を使う |
| **Novelty Effect** | 新機能テストは最低2週間以上のランニングを義務とする |
| **Selection Bias** | ランダムサンプリングまたは階層化サンプリングを使う |

### 11.3. Continuous Discovery（継続的発見）プロセス

- **Rule 11.102**: PMF達成後も週次でユーザーリサーチを継続する（Teresa Torres 方式）
  - 週1回以上のユーザーインタビューをチームの定常業務とする
  - インサイトをOpportunity Solution Tree（OST）で可視化・管理する

```
OST の構造:
Desired Outcome（目標状態）
  └── Opportunity（機会 / ユーザーニーズ）
        ├── Solution A（解決策A）
        │     ├── Experiment 1（実験1）
        │     └── Experiment 2（実験2）
        └── Solution B（解決策B）
              └── Experiment 3（実験3）
```

  - 機能開発の全提案はユーザーリサーチに紐付けることを義務とする
  - **Rule 11.103**: 「誰のためでもない機能」の開発を停止するため、PRD（Product Requirements Document）に必ず「根拠となるリサーチID」を記載する

---

## Part XII. PMF維持・Decay・進化プロトコル

### 12.1. PMF Decay（PMF劣化）の概念

- **Rule 11.110**: **PMFは永続的な状態ではない**。市場環境・競合・技術の変化によりPMFは劣化（Decay）する
- **2026年の文脈**: AIにより競合が数週間で機能を複製可能となり、PMFの有効期限が歴史的に最も短い時代に突入している

### 12.2. PMF半減期の定義

- **Rule 11.111**: 以下の業界別PMF半減期を参考に、PMFの再検証サイクルを設定する

| 業界 | 推定PMF半減期 | 主な劣化ドライバー |
|:----|:------------|:----------------|
| AI-Native SaaS | 3-6ヶ月 | 技術の急速な陳腐化 |
| Consumer Social | 6-12ヶ月 | トレンド・ユーザー嗜好の変化 |
| B2B SaaS | 12-18ヶ月 | 競合の機能追随 |
| FinTech | 12-24ヶ月 | 規制変更 |
| Healthcare | 18-36ヶ月 | 規制・臨床エビデンスの壁 |

### 12.3. PMF再検証プロトコル

- **Rule 11.112**: 以下の頻度でPMF Composite Scoreを再計測する

| フェーズ | 再検証頻度 | 最小サンプル |
|:--------|:---------|:-----------|
| PMF達成直後（〜6ヶ月） | 毎月 | 50名 |
| Growth期（6ヶ月〜2年） | 四半期 | 100名 |
| Scale期（2年〜） | 半年 | 200名 |

### 12.4. PMF Erosion 早期警告システム

- **Rule 11.113**: 以下の早期警告シグナルを常時モニタリングし、3つ以上が同時に点灯した場合は「PMF Erosion Alert」を発令する

| 警告シグナル | 閾値 |
|:-----------|:----|
| Sean Ellis Scoreが前回比5%以上低下 | < 35% に低下 |
| D30 Retentionが前四半期比で低下 | 業界標準を下回る |
| NPSが前四半期比10pt以上低下 | NPSがネガティブに転落 |
| Organic Growthの割合が低下 | < 15% に低下 |
| サポートチケットのネガティブセンチメント急増 | 前月比30%以上増加 |
| 競合へのスイッチ理由の出現 | 解約理由の20%以上 |
| Core Feature利用率の低下 | 前四半期比15%以上減少 |

### 12.5. PMF Erosion への対応プロトコル

- **Rule 11.114**: PMF Erosion Alert発令後、以下のステップを実行する
  1. **48時間以内**: 経営チームで緊急レビューミーティングを開催
  2. **1週間以内**: 直近20名のユーザーインタビューを実施（「何が変わったか」に焦点）
  3. **2週間以内**: PMF Engine（§7.4）を緊急実施し、Root Causeを特定
  4. **1ヶ月以内**: 改善施策を実装し、次回のPMFサーベイで効果を測定

### 12.6. Technology Platform Shift Risk（プラットフォームシフトリスク）

- **Rule 11.115**: PMFは**基盤となるプラットフォームの安定性**に依存する。以下のプラットフォームシフトリスクを常時モニタリングする

| リスクタイプ | 例 | 監視方法 |
|:-----------|:--|:--------|
| **App Storeポリシー変更** | AppleのATT、GoogleのPrivacy Sandbox | 四半期毎にポリシーチェンジログを確認 |
| **AI規制変更** | EU AI Actの制定・施行 | 規制動向ダッシュボード（`security/100_data_governance.md`参照） |
| **LLMプロバイダーの価格変更** | OpenAI・Anthropic・Googleの料金改定 | Unit Economicsへのインパクトを月次分析 |
| **基盤APIの廃止** | Twitter/X API制限、Google Maps価格改定 | 代替プラットフォームの事前評価 |
| **ブラウザプライバシー変更** | 3rd Party Cookie廃止、ITP | ファーストパーティデータ戦略の進捗確認 |

- **Rule 11.116**: コア価値の50%以上が単一の外部プラットフォームに依存する場合、**Platform Dependency Risk Alert**を発令し、代替戦略を策定する

### 12.7. PMF期待値複利化リスク（Compounding Expectation Risk）

- **Rule 11.190**: AI製品において、ユーザーの期待値は**複利的に増加**する。「今日の魔法は明日のテーブルステークス」現象を体系的に管理する

```
期待値複利化の法則:
  ユーザー期待値(t+1) = ユーザー期待値(t) × (1 + 期待値増加率)

  AI-Native SaaS: 期待値増加率 ≈ 5-10%/月（年間80-120%複利）
  従来型SaaS: 期待値増加率 ≈ 1-3%/月（年間12-36%複利）
```

- **Rule 11.191**: 期待値複利化の計測指標

| 指標 | 計測方法 | 警告閾値 |
|:-----|:--------|:--------|
| **Feature Expectation Gap** | 「期待する機能」と「現在の機能」の乖離（サーベイ） | ギャップが四半期で10%以上拡大 |
| **Delight Decay Rate** | NPS推奨理由の変化速度（以前「驚き」だった機能が「当然」に変わる速度） | 主要機能が6ヶ月以内に「当然」化 |
| **Competitor Parity Speed** | 競合が自社の主要機能を複製するまでの期間 | 3ヶ月以内に複製される |

- **Rule 11.192**: 期待値複利化への対応戦略

```
対応戦略の3層構造:
  Layer 1: Innovation Cadence（定期革新）
    - 四半期ごとに「驚き」を生む新機能・体験をリリース
    - イノベーション予算をR&Dの20%以上確保

  Layer 2: Depth Over Breadth（幅より深さ）
    - 機能追加（横展開）ではなく、既存コアのワークフロー統合深度を増す
    - Workflow Completion Rate（§7.14）の継続的改善

  Layer 3: Community-Driven Value（コミュニティ駆動価値）
    - ユーザーコミュニティ・エコシステム・マーケットプレイス等
    - ネットワーク効果により、プロダクト単体の機能比較から離脱する
```

- **Anti-Pattern**: 「PMF達成後は維持するだけでよい」は最も危険な思い込み。特にAI領域では、PMFの半減期が§12.2で定義した期間よりさらに短縮される可能性がある

### 12.8. PMF Fragility Score（PMF脆弱性スコア）

- **Rule 11.208**: PMFの「達成」だけでなく「脆弱性」を定量的に測定し、予防的な対策を講じる

- **Rule 11.209**: PMF Fragility Score の算出

```
PMF Fragility Score（四半期評価）:

以下の5軸を各1-5点（5が最も脆弱）で評価し、加重平均を算出する:

F1: Feature Replicability（機能複製可能性）
  - 「競合が最新AIツールで2週間以内に再構築できる機能の割合」
  - 1（≤20%）→ 5（>80%）

F2: Single Channel Dependency（チャネル依存度）
  - 「上位1チャネルへの顧客獲得依存率」
  - 1（≤30%）→ 5（>80%）

F3: Key Person Dependency（キーパーソン依存度）
  - 「創業者/特定人物の離脱でPMFが崩壊するリスク」
  - 1（チーム分散）→ 5（完全に創業者依存）

F4: Platform Dependency（プラットフォーム依存度）
  - 「単一外部プラットフォームへのコア価値の依存率」
  - 1（≤20%）→ 5（>70%）

F5: Market Timing Sensitivity（市場タイミング感度）
  - 「規制変更・技術シフトでPMFが無効化されるリスク」
  - 1（低感度）→ 5（極めて高感度）

Fragility Score = (F1×0.30 + F2×0.15 + F3×0.15 + F4×0.20 + F5×0.20)

判定:
  Score ≤ 2.0: 堅牢なPMF（年次モニタリングで十分）
  Score 2.1-3.0: 中程度の脆弱性（四半期ごとの対策計画を策定）
  Score 3.1-4.0: 高い脆弱性（月次でMoat強化プログラムを実行）
  Score > 4.0: 危機的脆弱性（即座に§9.4-§9.7の全フレームワークを動員）
```

- **Rule 11.210**: Fragility Scoreが3.0を超えた場合、PMF Composite Scoreの値に関わらず「**Fragile PMF**」として分類し、§12.5の対応プロトコルと並行して脆弱性低減策を実行する

- **Anti-Pattern**: 「PMF Composite Scoreが高いから大丈夫」はFragility（脆弱性）の次元を見落とす。PMFは「強さ」と「脆さ」の2次元で評価すべき

---

## Part XIII. PMF拡張（Adjacent Market Expansion）

### 13.1. Adjacent Market進出の前提条件

- **Rule 11.120**: 隣接市場への拡張は、コア市場でのPMFが**安定している場合のみ**実施する

```
拡張許可の前提条件（AND）:
□ コア市場のPMF Composite Score ≥ 75（安定領域）
□ D30 Retention が3四半期連続で横ばいまたは改善
□ コア市場のUnit Economicsが安定（LTV/CAC ≥ 3.0）
□ コアチームへの影響なしに拡張にリソースを割ける
```

### 13.2. Adjacent Market PMF拡張フレームワーク

- **Rule 11.121**: 隣接市場へのPMF拡張は以下のステップで段階的に行う

```
Phase 1: 隣接性評価
  市場の隣接度 = (共通の課題 × 共通の技術基盤 × 共通のチャネル) / 固有要件の量
  隣接度 ≥ 0.7: 低リスク拡張（技術・チャネル共有可）
  隣接度 0.4-0.6: 中リスク拡張（部分的にカスタマイズ必要）
  隣接度 < 0.4: 高リスク拡張（新規事業に近い）

Phase 2: 最小検証（隣接市場向けMVP）
  コア製品を調整し、隣接市場向けの仮説を検証する
  隣接市場のインタビューを最低10名実施する

Phase 3: Segment PMF達成
  隣接市場でのPMF Composite Score ≥ 60を目指す

Phase 4: Multi-Segment PMF管理
  コア市場と隣接市場の両方のPMFスコアを並行管理する
  一方の改善が他方を劣化させていないか監視する
```

### 13.3. PMF Dilution（希薄化）リスク管理

- **Rule 11.122**: 隣接市場進出により、コア市場のPMFが希薄化するリスクを管理する
- **Dilution Alert**: コア市場のPMF Composite Scoreが拡張開始前比で5pt以上低下した場合、拡張を一時停止する
- **Anti-Pattern**: 「コア市場で勝てないから隣接市場に逃げる」パターンは禁止。逃避型拡張はPMFの二重未達を招く

### 13.4. Geographic PMF Expansion（地理的PMF拡張）プロトコル

- **Rule 11.123**: 同一プロダクトの**海外展開**において、国内PMFの成功がそのまま海外での成功を保証しない。**地域別のPMF再検証**を必須とする

- **Rule 11.124**: 地理的拡張前のLocalization PMFチェックリスト

```
Localization PMF検証項目（AND条件）:
□ 現地語でのインタビュー 10名以上完了
□ Pain Severity Score がホーム市場と同等以上（Gap ≤ 2pt）
□ 現地の規制・法令への準拠が確認済み（§3.6参照）
□ 「なぜ今X国なのか」のWhy Now Canvasが作成済み
□ 現地の競合状況がマッピング済み
□ 現地パートナーまたはカントリーマネージャーが確保済み
```

- **Rule 11.125**: 地域別PMFの成功判定は、ホーム市場と同じPMF Composite Scoreを使用するが、文化的バイアスを考慮しNPSの閾値を地域別に調整する（例: 日本市場ではNPS閾値を-10pt調整）
- **Anti-Pattern**: 「英語圈で成功したから翻訳すれば日本でもいける」は、PMFの文化的次元を無視している

### 13.5. Second Product PMF（第二プロダクトPMF）プロトコル

- **Rule 11.126**: 既存プロダクトとは異なる**新規プロダクト**のPMF検証は、隣接市場拡張（§13.1-13.3）とは異なるプロトコルで行う

```
Second Product PMFの前提条件（AND）:
□ 第一プロダクトのPMF Composite Score ≥ 80（安定期）
□ 第一プロダクトの成長が自律的（創業者の日常的介入が不要）
□ 第二プロダクト専任のチーム（最低2名）が確保されている
□ 第二プロダクト独自のFounder-Market Fit（§1.5）が評価済み
```

- **Rule 11.127**: 第二プロダクトはPMF検証を**第一プロダクトと完全に独立**して行う。第一プロダクトの顧客基盤を「確実なPMF」と混同しない
  - 第一プロダクトの既存顧客へのクロスセルは「有利なチャネル」として活用するが、PMF判定では「Organic」と区別する
  - PMF Composite Scoreは第一プロダクトのスコアと合算しない

- **Rule 11.128**: **Cross-Product Cannibalization（共食い）モニタリング**: 第二プロダクトのローンチ後、第一プロダクトのPMF Composite Scoreが5pt以上低下した場合、共食いが発生している可能性があり、ポジショニングの再設計を検討する

---

## Part XIV. Demand-Side Validation & Pre-Revenue証明

### 14.1. Pre-Revenue証明手段の階層

- **Rule 11.130**: プロダクト開発前に需要を証明するための手段を以下の信頼性順で活用する

| 手段 | 信頼性 | 準備期間 | 法的注意事項 |
|:----|:------|:--------|:-----------|
| **Signed LOI（意向表明書）** | ★★★★★ | 2-4週間 | 法的拘束力の範囲を明示 |
| **Pre-order（前払い）** | ★★★★★ | 2-4週間 | 返金ポリシーの明示必須 |
| **Paid Waitlist** | ★★★★ | 1-2週間 | 「将来のアクセス権」として販売 |
| **Design Partner契約** | ★★★★ | 4-8週間 | 共同開発の権利義務を明文化 |
| **Free Waitlist** | ★★ | 1週間 | エビデンスとしては弱い |
| **「いいね」/ フォロワー数** | ★ | — | 意思決定に使用禁止 |

### 14.2. LOI（Letter of Intent）プロトコル

- **Rule 11.131**: B2B事業において、LOIは最強のPre-Revenue Validationである。以下のプロトコルで収集する

```yaml
loi_protocol:
  target: "ICP一致企業の意思決定者（VP以上）"
  minimum_count: 5  # PMF宣言の前提条件
  content_must_include:
    - "具体的な課題の記述"
    - "想定利用シナリオ"
    - "想定予算範囲"
    - "導入条件（機能要件・タイムライン）"
    - "署名者の氏名・役職"
  validity_period: "90日間"
  non_binding: true  # 法的拘束力なしを明示
```

### 14.3. Waitlist Quality指標

- **Rule 11.132**: Waitlistの「量」ではなく「質」を評価する

| 指標 | 健全な水準 | 警告水準 |
|:----|:---------|:--------|
| ICP一致率 | ≥ 60% | < 30% |
| メールオープン率 | ≥ 50% | < 20% |
| アップデートメール返信率 | ≥ 10% | < 3% |
| 有料Waitlist転換率 | ≥ 5% | < 1% |
| ドロップオフ率（30日以内解除） | ≤ 20% | > 50% |

### 14.4. Design Partner → Paying Customer 転換プロセス

- **Rule 11.133**: Design Partner（`000_product_strategy.md` §2.5参照）から有料顧客へ転換する標準プロセスを定義する

```
Step 1: 価値実証（2-4週間）
  Design Partnerが「Aha Moment」を体験し、コア機能を継続利用している

Step 2: 有料化の打診（Week 4-6）
  「通常料金の50%割引のEarly Adopter価格」を提示する
  早期価格の有効期限（例: 12ヶ月）を設定する

Step 3: 契約と移行（Week 6-8）
  有料契約を締結し、SLA・サポート体制を明文化する
  無料→有料の移行を実施する

転換成功基準: Design Partner 5社中3社以上が有料化
```

---

## Part XV. AI-Native市場検証プロトコル

### 15.1. AI-Augmented Validation（AI支援検証）

- **Rule 11.140**: AI-Nativeな検証ツールを活用し、検証サイクルの速度を向上させる

| AI活用領域 | ツール例 | 効果 | 制約 |
|:---------|:-------|:----|:----|
| **インタビュー文字起こし** | Whisper / Otter.ai | 分析速度の向上 | PIIの取り扱いに注意 |
| **センチメント分析** | GPT / Claude API | 大量フィードバックの分析 | 文脈理解の限界 |
| **合成ペルソナ調査** | Synthetic Users API | 高速な仮説の圧力テスト | 実際のユーザーの代替不可 |
| **競合分析自動化** | Web Scraping + LLM | 競合動向のリアルタイム追跡 | スクレイピングの法的リスク |
| **市場規模推定** | LLM + データベース連携 | Bottom-up計算の補助 | 推定値の検証は人間が実施 |

### 15.2. Synthetic User Research（合成ユーザーリサーチ）

- **Rule 11.141**: AIで生成されたSynthetic Personas（合成ペルソナ）を仮説の**初期圧力テスト**に活用することを許可する。ただし以下の制約を厳守する

```
Synthetic Research の許容範囲:
✅ 仮説の方向性の「事前チェック」（本番リサーチ前の準備）
✅ メッセージングの「A/Bテスト」初期スクリーニング
✅ 既存のインタビューデータに基づく「パターン拡張」
✅ 大量の競合レビューからのインサイト抽出

❌ 禁止事項:
✗ Synthetic Researchのみでの意思決定
✗ Synthetic Researchの結果を「ユーザーインタビュー」として記録
✗ 新カテゴリの市場存在証明（実在のユーザーによる検証が必須）
✗ 価格感度調査（実際のWTP検証を代替不可）
```

- **Rule 11.142**: Synthetic Researchの結果は必ず「Synthetic」ラベルを付与し、Real Researchと混在させない

### 15.3. AI-Native PMFの特有課題

- **Rule 11.143**: AI機能をコア価値とするプロダクトのPMF検証には、以下の追加プロトコルを適用する

| AI-Native特有の課題 | 対策 |
|:------------------|:----|
| **AI Commoditization（日用品化）** | AI機能そのものではなくAIのアウトプットの**ユニーク性**でPMFを判定する |
| **Novelty Effect** | AI機能リリース後**2ヶ月間**はPMF測定を確定しない |
| **Hallucination Risk** | ユーザー信頼度（Trust Score）をPMF指標に含める |
| **Prompt Sensitivity** | 同一機能でもユーザーの入力品質で体験が変わる。TtV（Time to Value）のバラつきを測定する |
| **Model Version Dependency** | LLMのバージョンアップでPMFが変動するリスク。バージョン固定でPMFを測定する |
| **Cost Unpredictability** | AI推論コストがUnit Economicsを破壊する可能性。Gross Marginを並行して監視する |
| **Agentic AI PMF** | AI Agent製品のPMFはTask Completion Rate・Autonomy Level・Human Override Rateで測定する。従来のDAU/MAUでは不十分 |
| **Multi-Modal Experience Drift** | マルチモーダル入力（音声・画像・テキスト）間でUX品質が不均一になるリスク。モーダル別にTtVを測定する |

- **Rule 11.172**: **Agentic AI PMFの詳細指標**: AI Agent製品のPMFを精密に測定するための専用指標フレームワーク

| 指標 | 定義 | PMF閾値 |
|:----|:----|:--------|
| **Goal Attainment Rate** | エージェントが人間の介入なしにタスクを完了した割合 | ≥ 80% |
| **Cost per Successful Outcome** | 成功アウトカム当たりのAI推論コスト | 提供価値の10%未満 |
| **Autonomy Ratio** | エージェントが自律的に処理したタスクの割合 | ≥ 70% |
| **Escalation Rate** | 人間へのエスカレーション発生率 | ≤ 15% |
| **Context Chain Health** | マルチステップワークフローで文脈を失わずに完了した割合 | ≥ 85% |
| **Recovery Rate** | エラー発生時に自律的に復旧できた割合 | ≥ 60% |

- **Anti-Pattern**: 「AI Wrapper Trap」— LLM APIの薄いラッパーで独自データ/ワークフロー統合がない製品は、モデルプロバイダーが下流に進出すると即座に競争優位を失う。必ず**Data Flywheel**（§9.4）を併設すること

### 15.4. Proof of Value（PoV）vs Proof of Concept（PoC）

- **Rule 11.144**: AI-Native製品では、技術的な動作確認（PoC）ではなく、**ビジネス指標への影響**（PoV）で検証する

```
PoC（技術検証）: 「この技術は動作するか？」
  → 必要だが、市場検証には不十分

PoV（価値証明）: 「この技術は具体的なビジネス指標を改善するか？」
  → PMF判定に使用可能

PoV設計テンプレート:
  subject: "対象顧客のセグメント"
  before_metric: "導入前の指標値"
  after_metric: "導入後の目標指標値"
  measurement_period: "4-8週間"
  success_criteria: "指標がXX%改善"
```

### 15.5. AI Safety & Trust as PMF Dimension（AI安全性・信頼性をPMFの構成要素として）

- **Rule 11.145**: AI-Native製品では、**Safety（安全性）とTrust（信頼性）はPMFの独立した構成要素**であり、機能的PMFとは別次元で測定する

| 信頼性指標 | 定義 | PMF閾値 |
|:---------|:-----|:-------|
| **Trust Score** | ユーザーが「AIの出力を信頼する」と回答した割合 | ≥ 70% |
| **Safety Incident Rate** | AI出力に起因する安全性事故の発生率 | < 0.01% |
| **Human Override Rate** | ユーザーがAIの提案を手動で上書きした割合 | ≤ 20%（低いほど信頼が高い） |
| **Explainability Satisfaction** | AI判断の説明に対するユーザー満足度 | ≥ 65% |
| **Bias Detection Coverage** | バイアス検出テストのカバレッジ | ≥ 90% |

- **Rule 11.146**: Trust Scoreが50%を下回った場合、PMF Composite Scoreの如何に関わらず**PMF未達成**として扱う。ユーザーが信頼しないAIに持続的なPMFは存在し得ない
- **クロスリファレンス**: `ai/000_ai_engineering`（AI Safety Scorecard）、`security/100_data_governance`（データガバナンス）

### 15.6. Deep Tech & Hardware PMFプロトコル

- **Rule 11.176**: Deep Tech（バイオテク・素材・ロボティクス）およびハードウェア製品のPMFは、ソフトウェア製品とは根本的に異なる長期検証サイクルを要する

- **Rule 11.177**: **Technology Readiness Level (TRL) × PMFフェーズの連動**

| TRL | 定義 | PMFフェーズ | 検証活動 |
|:----|:----|:----------|:---------|
| **TRL 1-3** | 基礎研究・概念実証 | Pre-PMF（課題検証） | 顧客インタビュー・LOI収集 |
| **TRL 4-6** | ラボ実証・パイロット | PMF探索（PoV検証） | Design Partner・パイロットプログラム |
| **TRL 7-8** | システム実証・量産試作 | PMF確認（商用検証） | 限定商用・価格検証 |
| **TRL 9** | 量産・商用展開 | PMF達成 | PMF Composite Score測定 |

- **Rule 11.178**: Deep Tech PMFの特有指標

| 指標 | 定義 | 基準 |
|:----|:----|:-----|
| **Technical Risk Resolution** | 主要技術リスクの解消率 | ≥ 80% |
| **Pilot→Commercial転換率** | パイロット顧客から有料契約への転換 | ≥ 50% |
| **Time to Deployment** | 導入開始から稼働開始までの期間 | 業界標準の50%以下 |
| **Unit Economics at Scale** | 量産時のユニットエコノミクス予測 | Gross Margin ≥ 40% |
| **IP Portfolio Strength** | 特許出願・取得状況 | コア技術の特許保護 |

- **Rule 11.179**: **Climate Tech特有のインパクト指標**をPMF評価に含める

| 指標 | 定義 | PMFとの関係 |
|:----|:----|:-----------|
| **Carbon Reduction per $** | 投資1ドルあたりのCO2削減量 | ユニットエコノミクスの補完指標 |
| **SDG Alignment Score** | 持続可能な開発目標との整合度 | 投資家・規制当局からの評価 |
| **Scalability Factor** | 技術のスケール可能性（10x展開時のコスト構造） | PMF → Scale移行の判断基準 |

- **Anti-Pattern**: 「Tech-Push Trap（技術推進の罠）」— 技術の革新性に魅了され、市場の課題を後付けする。Deep Techでも「課題ファースト」（§2.1 JTBD）は不変の原則

### 15.7. Outcome-Based PMF & Pricing Validation

- **Rule 11.193**: AI時代のPMFは「**Feature Enhancement（機能強化）**」ではなく「**Workflow Replacement（ワークフロー置換）**」で測定する

- **Rule 11.194**: **Workflow Replacement Index (WRI)** を計測すること

```
Workflow Replacement Index (WRI):

WRI = (手動工数の削減時間 × 時間当たりのコスト) / プロダクト月額費用

WRI ≥ 10: 圧倒的なROI（顧客は即座に支払う）
WRI 5-9: 強いROI（投資回収が明確）
WRI 2-4: 中程度のROI（競合比較が発生する）
WRI < 2: ROI不十分（価格の再設計が必要）
```

- **Rule 11.195**: **Outcome-Based Pricing検証プロトコル**: AI推論コストの変動性に対応し、価値提供と収益を整合させる

| 価格モデル | 定義 | PMF検証方法 | 適合条件 |
|:---------|:-----|:----------|:--------|
| **Per-Outcome** | 成功結果ごとに課金（例: 解決チケット単価） | Outcome当たりのWTPと原価を計測 | 成果が明確に定量化可能 |
| **Hybrid（基本料+成果料）** | プラットフォーム基本料 + 成果連動料 | 基本料のPMF + 成果料のスケーラビリティを別々に検証 | 基本価値 + 変動価値がある |
| **Usage-Based** | 利用量に応じた従量課金 | 利用量とValue Deliveredの相関を検証 | API/トランザクション型プロダクト |

- **Rule 11.196**: Outcome-Based PMFの成功判定

```
Outcome-Based PMF判定基準（AND）:
□ WRI ≥ 5（顧客が費用の5倍以上の価値を体感）
□ 顧客のROI実証期間 ≤ 30日（1ヶ月以内に価値を実証）
□ Outcome達成率 ≥ 85%（約束した成果を85%以上で実現）
□ Unit Economics成立: 成果あたりのAI推論コスト < 成果あたりの課金額の40%
```

- **Anti-Pattern**: 「Per-Seat価格でAI製品を売る」は収益とインパクトの乖離を生む。AI Agentが人間の作業を代替する場合、シートベースのモデルは自社のバリューを制限する

### 15.8. Multi-Agent & Tool-Use PMF

- **Rule 11.197**: **AI Agent間連携（Multi-Agent Orchestration）**を持つプロダクトのPMFは、単一Agentの指標に加え、オーケストレーション品質を計測する

| 指標 | 定義 | PMF閾値 |
|:----|:----|:--------|
| **Tool-Use Success Rate** | Agent がツール（API/DB/外部サービス）を正しく呼び出し、期待結果を得た割合 | ≥ 90% |
| **Orchestration Completion Rate** | マルチステップワークフローが全工程を完了した割合 | ≥ 80% |
| **Inter-Agent Handoff Fidelity** | Agent間のコンテキスト引き継ぎの正確性 | ≥ 95% |
| **Error Recovery without Human** | エラー発生時にAgentが自律的に復旧した割合 | ≥ 70% |
| **End-to-End Latency** | ワークフロー全体の完了時間 | ユーザー許容閾値内 |

- **Rule 11.198**: **MCP/A2Aプロトコル対応PMF**
  - AIエージェントが標準プロトコル（MCP: Model Context Protocol、A2A: Agent-to-Agent）を介して外部ツール・他のAgentと連携する場合、**プロトコル準拠度**をPMF指標に含める
  - **Integration Depth Score**: サポートするプロトコル数 × 各プロトコルの機能カバー率

- **Rule 11.199**: Multi-Agent PMFの特有リスク

```
Multi-Agent PMFリスク管理:
□ 連鎖障害リスク: 1つのAgentの障害がワークフロー全体を停止させないか？
□ コスト爆発リスク: Agent間のトークン消費が指数的に増加しないか？
□ 責任境界の曖昧さ: エラー発生時にどのAgentの責任かが明確か？
□ バージョン互換性: 個別Agentの更新がオーケストレーション全体を壊さないか？
```

- **Anti-Pattern**: 「Agent数が多いほど良い」は誤り。不必要なAgent間通信はレイテンシー・コスト・エラー率を増加させる。**最小Agent数で最大の成果**を達成する設計を優先する

### 15.9. Zero-Click Discovery & Validation Economy Protocol

- **Rule 11.211**: 2026年、ユーザーの発見行動は従来の「検索→クリック→訪問」から**「AI検索→ゼロクリック回答」**に移行した。市場検証はこの新しい発見経路を考慮する必要がある

- **Rule 11.212**: **Validation Economy（検証経済）の3チャネル**

| チャネル | 定義 | 検証方法 | PMFとの関係 |
|:-------|:----|:--------|:----------|
| **AI Search Visibility** | LLM（ChatGPT, Gemini, Perplexity等）による推奨・引用でのプロダクト露出 | GEO（Generative Engine Optimization）: LLMが回答に自社を引用する頻度を計測 | オーガニック発見経路の新たな構成要素 |
| **Expert Validation** | 業界専門家・インフルエンサーによる信頼性の裏付け | ドメインエキスパートのレビュー・推奨数を追跡 | 信頼性シグナルとしてのPMF補完指標 |
| **Community-Generated Content** | Reddit・YouTube・ニュースレター等でのユーザー生成コンテンツ | 自社プロダクトに言及するUGC数・センチメントを追跡 | Organic Pull（§8.1）の新たな計測源 |

- **Rule 11.213**: **LLMs.txt対応プロトコル**
  - プロダクトサイトに`llms.txt`ファイルを配置し、LLMがプロダクト情報を正確に引用できるようにする
  - 以下の情報を構造化して提供する:
    - プロダクトの正式名称・説明・主要機能
    - 対象ユーザーセグメント・解決する課題
    - 価格情報・比較ポイント
  - **計測**: AI検索エンジンでの引用頻度を月次で追跡し、Organic Growth指標（§8.1）に統合する

- **Rule 11.214**: Zero-Click時代のPMF検証への影響

```
Zero-Click Discovery PMF補正:

従来のOrganic Growth計測:
  Organic Rate = Organic Signups / Total Signups

2026年のOrganic Growth計測（拡張版）:
  Extended Organic Rate = (Direct + Organic Search + AI Search Referral + UGC Referral) / Total Signups

AI Search Referral の計測:
  - UTMパラメータによる追跡（utm_source=chatgpt, perplexity等）
  - リファラーヘッダーの解析
  - 初回訪問時のアンケート（「どこで知りましたか？」にAI検索オプションを追加）
```

- **Anti-Pattern**: 「SEOだけやっていればオーガニックは大丈夫」はゼロクリック時代には不十分。GEO（AI検索最適化）とSEOの**両輪**で発見可能性を確保する

---

## Part XVI. 市場検証の成熟度モデル（5段階）

- **Rule 11.150**: 組織の市場検証プロセスの成熟度を以下の5段階で評価し、次の段階への改善計画を持つ

| レベル | 名称 | 特徴 | 主要実践 | Ready判定 |
|:------|:-----|:----|:--------|:---------|
| **L1** | **Intuition（直感）** | 創業者の直感と経験で判断。体系的な検証なし | なし | — |
| **L2** | **Ad-hoc（場当たり）** | 顧客インタビューや調査を場当たり的に実施 | Mom Test, 非定期インタビュー | L1 → L2: インタビュー10件以上 |
| **L3** | **Structured（構造化）** | 仮説ログ・Pain Score・Evidence Hierarchyを活用 | 仮説ログ, RAT, MVP設計, Sean Ellis | L2 → L3: 仮説ログの運用開始 |
| **L4** | **Data-Driven（データ駆動）** | Composite Score・コホート分析・継続的発見 | PMF Engine, Cohort PMF, OST | L3 → L4: PMF Composite Score運用 |
| **L5** | **Predictive（予測的）** | AI-Augmented Discovery・PMF Decay予測・Synthetic Research | AI分析, Predictive Churn, Market Sensing | L4 → L5: AI検証パイプライン稼働 |

- **Anti-Pattern**: L1→L5へのスキップを試みることは禁止。各レベルの基盤が次のレベルの前提条件となる

---

## Part XVII. アンチパターンカタログ（50選）

> 市場検証・PMF戦略における典型的な失敗パターン。各アンチパターンは「症状 → 原因 → 処方箋」の3要素で定義する。

| # | アンチパターン | 症状 | 処方箋 |
|:--|:------------|:-----|:------|
| 1 | **Build Trap** | 機能を作り続けるが誰も使わない | §1.1 Build Trap回避。検証ファーストに戻る |
| 2 | **Vanity Metrics** | ページビューやダウンロード数を成功指標にする | §7.2 Composite Scoreに切り替える |
| 3 | **Solution-First** | ソリューションを先に考え、課題を後付け | §2.1 JTBD起点に再設計する |
| 4 | **Feature Creep** | MVPにどんどん機能を追加する | §6.4 スコープ制限プロトコルを強制する |
| 5 | **Premature Scaling** | PMF前に広告費・採用を拡大 | §8.2 Premature Scaling禁止令 |
| 6 | **Founder Delusion** | 自社プロダクトの価値を過大評価 | §7.8 False PMFプロトコルで客観検証 |
| 7 | **Survey Worship** | アンケート結果を絶対視する | §1.3 Evidence Hierarchyで行動データを優先 |
| 8 | **Elephant Hunting** | 大企業との契約を追い求めPMFを後回し | §4.3 Early Adopter Protocolに戻る |
| 9 | **Zombie PMF** | 低利用・低満足で惰性で使われている | §12.4 PMF Erosion Alertで検出する |
| 10 | **Novelty Trap** | 新しいから使われているだけ | §7.8 2ヶ月後のRetentionで真のPMFを確認 |
| 11 | **AI Magic Thinking** | AIを入れれば全て解決するという幻想 | §15.3 AI-Native特有課題を評価する |
| 12 | **Confirmation Bias Interview** | 肯定的な回答だけを記録する | §4.1 Mom Testの禁止事項を遵守する |
| 13 | **Top-Down Fantasy** | 「市場は1兆ドル、1%取れば…」 | §3.2 Bottom-up必須プロトコル |
| 14 | **Pivot Paralysis** | データがピボットを示しているのに動けない | §10.1 客観的ピボットトリガーで判断 |
| 15 | **Pivot Addiction** | 洞察不十分なまま頻繁にピボットする | §10.4 3サイクル以上の検証を実施する |
| 16 | **Metric Gaming** | 指標をハックして見かけ上のPMFを作る | §7.7 Cohort-Level分析で本質を見る |
| 17 | **Segment Blindness** | 全ユーザーを同質として扱う | §7.5 B2B/B2C分岐プロトコル |
| 18 | **Over-Research** | 研究に没頭して永遠に開始しない | §5.4 RAT + 最大2週間の実験設計 |
| 19 | **Underprice to PMF** | 低価格でPMFを偽装する | §8.4 Unit Economics Gateで検出 |
| 20 | **PMF Overconfidence** | 一度のPMF達成で安心する | §12.1 PMF Decay概念を認識する |
| 21 | **Friend & Family Validation** | 知人からのフィードバックを市場検証とする | §7.8 他人50名以上で再検証 |
| 22 | **TAM Fairy Tale** | 市場規模を根拠なく楽観視する | §3.3 CAGR + 構造分析で実態を把握 |
| 23 | **Timing Ignorance** | 市場タイミングを考慮しない | §3.4 Why Now Canvasを作成する |
| 24 | **Single Channel Dependency** | 1つの獲得チャネルに完全依存 | §8.1 Organic ≥ 20%をスケール条件とする |
| 25 | **Data Hoarding** | データを集めるが分析・活用しない | §11.3 Continuous Discoveryプロセス |
| 26 | **Adjacent Market Escape** | コアPMF未達で隣接市場に逃避 | §13.1 コアPMF安定が前提条件 |
| 27 | **Synthetic Research Overreliance** | AI合成リサーチのみで判断 | §15.2 「Synthetic」は補助のみ |
| 28 | **Moat Illusion** | 存在しない競争優位を信じる | §9.4 Moat設計を定期評価する |
| 29 | **Stale Evidence** | 古い検証データで重要な判断 | §1.4 検証データの有効期限を遵守 |
| 30 | **Revenue Before PMF** | PMF前に収益最適化に注力 | §7.1 PMF Composite Score優先 |
| 31 | **Founder-Market Fit Ignorance** | チームのドメイン知識不足を無視して参入 | §1.5 FMF評価スコア15点以上を確認 |
| 32 | **Regulatory Blindspot** | 規制産業への参入前に規制リスク未評価 | §3.6 Regulatory Risk Assessmentを実施 |
| 33 | **Platform Dependency Trap** | 単一プラットフォームに全面依存 | §12.6 Platform Dependency Risk Alertを監視 |
| 34 | **Marketplace Cold Start Panic** | Chicken-and-Egg問題を無視してローンチ | §7.10 Supply-First戦略で段階的に構築 |
| 35 | **Second Product Distraction** | 第一プロダクトPMF未安定で第二プロダクトに着手 | §13.5 前提条件チェックリストを遵守 |
| 36 | **AI Wrapper Trap** | LLM APIの薄いラッパーで独自データ/ワークフロー統合なし | §9.4 Data Moat + AI Moatを併設 |
| 37 | **Unit Economics Ignorance** | AI推論コストを無視してユーザー拡大 | §8.4 Unit Economics Gate + §15.3 Gross Margin監視 |
| 38 | **Vertical Blindness** | 汎用PMF指標で業種特化プロダクトを評価 | §7.14 Vertical SaaS PMFプロトコルを適用 |
| 39 | **PLG Purism** | PLGのみでEnterprise展開を拒否 | §7.13 PLG-SLG Hybrid PMFで統合測定 |
| 40 | **Sandbox Avoidance** | 規制産業でSandboxを活用せず先にプロダクト構築 | §3.7 Regulatory Sandboxプロトコルを参照 |
| 41 | **PMF Binary Thinking** | PMFを「あり/なし」の二値で判定し段階的な進捗を見逃す | §7.15 PMF Spectrumで4段階管理を導入 |
| 42 | **Signal Blindness** | サーベイ結果のみでPMFを判定しリアルタイム行動シグナルを無視 | §7.17 Signal-Based PMF Validationを統合 |
| 43 | **Outcome Ignorance** | AI製品の価値を「機能」で説明し「ワークフロー置換」の成果を計測しない | §15.7 Workflow Replacement Index (WRI)で定量化 |
| 44 | **Expectation Debt** | AI製品のPMF達成後にイノベーション投資を停止し期待値複利化に対応できない | §12.7 3層対応戦略（Innovation Cadence/Depth/Community）を実行 |
| 45 | **Agent Sprawl** | 不必要にAgent数を増やしレイテンシー・コスト・エラー率が増大 | §15.8 最小Agent数で最大成果の設計原則を遵守 |
| 46 | **SEO-Only Discovery** | SEOのみで発見可能性を確保しAI検索（ゼロクリック）を無視 | §15.9 Zero-Click Discovery & GEOで両輪確保 |
| 47 | **Fragility Blindness** | PMF Composite Scoreが高いことに安心し脆弱性を評価しない | §12.8 PMF Fragility Scoreで脆弱性を定量化 |
| 48 | **Prosumer Misclassification** | ProsumerをB2CまたはB2Bに誤分類し検証プロトコルが不適合 | §7.18 Prosumer PMF Validation Protocolを適用 |
| 49 | **AI-Magnet Neglect** | 大規模MVPに固執し小規模AI無料ツールでの検証機会を逃す | §6.1 AI-Magnet MVPで低コスト検証を実施 |
| 50 | **Defensibility Complacency** | 防御可能性のストレステストを怠り複製リスクに気づかない | §9.7 40%防御可能性テストを四半期実施 |

---

## Part XVIII. Appendix: 逆引き索引・クロスリファレンス

### 逆引き索引（キーワード → セクション）

| キーワード | 対応セクション |
|:---------|:------------|
| Build Trap・Validated Learning・Evidence Hierarchy | §1 哲学 |
| JTBD・Pain Score・Problem Statement・Gap分析 | §2 問題定義 |
| TAM・SAM・SOM・CAGR・Why Now・市場タイミング | §3 市場規模 |
| Customer Discovery・インタビュー・Mom Test・Signal Strength | §4 顧客発見 |
| 仮説・Leap of Faith・仮説ログ・RAT | §5 仮説管理 |
| MVP・MLP・Smoke Test・Concierge・Prototype Fidelity | §6 MVP/MLP設計 |
| Sean Ellis Test・PMF Composite Score・PMF Engine・Cohort PMF | §7 PMF測定 |
| Premature Scaling・スケール基準・Unit Economics Gate | §8 スケール判断 |
| 競合・Moat・10x Better・Blue Ocean | §9 競合分析 |
| ピボット・ピボットトリガー・Kill Criteria | §10 ピボット |
| Mixed Methods・継続的発見・OST | §11 データ収集 |
| PMF Decay・PMF Erosion・半減期・再検証 | §12 PMF維持 |
| Adjacent Market・PMF拡張・Dilution | §13 PMF拡張 |
| LOI・Waitlist・Pre-order・Design Partner転換 | §14 Demand-Side |
| Synthetic Research・AI-Augmented・PoV・AI-Native PMF・AI Trust | §15 AI-Native検証 |
| 成熟度モデル・L1-L5 | §16 成熟度 |
| アンチパターン・失敗パターン | §17 アンチパターン |
| Founder-Market Fit・FMF・ドメイン経験 | §1.5 創業者適合性 |
| 規制リスク・Regulatory PMF・ライセンス | §3.6 規制リスク |
| Community Signal・OSS・DevTool・CLG | §4.7 コミュニティ検証 |
| ICP精緻化・動的ICP・顧客属性分析 | §4.8 動的ICP |
| 価格感度・Van Westendorp・WTP・Pre-PMF Pricing | §6.6 価格検証 |
| Marketplace PMF・Liquidity・Chicken-and-Egg・Take Rate | §7.10 マーケットプレイス |
| Platform PMF・API PMF・DXS・Developer NPS | §7.11 プラットフォーム |
| NRR・Expansion MRR・Seat Expansion・Revenue PMF | §7.12 Expansion Revenue |
| PLG-SLG・PQL・Natural Rate of Growth・Behavioral Cohort・Smile Curve | §7.13 Hybrid PMF |
| Vertical SaaS・Workflow Completion・System of Record・Embedded Product | §7.14 Vertical SaaS |
| Platform Shift Risk・依存リスク・API廃止 | §12.6 プラットフォームシフト |
| Geographic PMF・海外展開・Localization PMF・文化的バイアス | §13.4 地理的拡張 |
| Second Product PMF・Multi-Product・Cannibalization | §13.5 第二プロダクト |
| AI Safety・Trust Score・Explainability | §15.5 AI信頼性 |
| Regulatory Sandbox・規制サンドボックス・規制クリアランス | §3.7 Sandbox活用 |
| Deep Tech・Hardware PMF・TRL・Climate Tech・Carbon Reduction | §15.6 Deep Tech |
| Agentic AI・Goal Attainment Rate・Autonomy Ratio・Context Chain | §15.3 Agentic AI PMF |
| AI Wrapper・Data Flywheel・AI Commoditization | §15.3 + §9.4 AI Moat |
| PMF Spectrum・Nascent・Developing・Strong・Extreme・ARR段階 | §7.15 PMF Spectrum |
| Reverse Trial・Loss Aversion・ダウングレード・全機能トライアル | §7.16 Reverse Trial |
| Signal-Based・Intent Signal・Product Signal・行動シグナル | §7.17 Signal-Based Validation |
| Memory as Moat・Learning Velocity・Reliable Execution・防御可能性 | §9.6 AI時代の防御可能性 |
| 期待値複利化・Delight Decay・Feature Expectation Gap | §12.7 期待値複利化リスク |
| Workflow Replacement・WRI・Outcome-Based Pricing・ROI-Based PMF | §15.7 Outcome-Based PMF |
| Multi-Agent・Tool-Use・MCP・A2A・Orchestration | §15.8 Multi-Agent PMF |
| Agent Sprawl・PMF Binary Thinking・Signal Blindness・Expectation Debt | §17 アンチパターン #41-45 |
| Prosumer・Personal→Team Expansion・Weekend Usage・Tool Evangelism | §7.18 Prosumer PMF |
| AI-Resistant Value・AI-Proof Core・Integration Moat・Outcome Guarantee | §9.7 AI-Resistant Value |
| Defensibility Stress Test・40%テスト・Feature Replicability | §9.7 + §12.8 防御可能性 |
| PMF Fragility Score・脆弱性・Feature Replicability・Channel Dependency | §12.8 PMF Fragility Score |
| Zero-Click Discovery・GEO・LLMs.txt・Validation Economy・AI Search | §15.9 Zero-Click Discovery |
| AI-Magnet MVP・ツールマグネット・無料AIツール検証 | §6.1 AI-Magnet MVP |
| AI Demand Mining・セマンティック検索・コミュニティペインポイント抽出 | §4.7 AI Demand Mining |
| SEO-Only Discovery・Fragility Blindness・Prosumer Misclassification | §17 アンチパターン #46-50 |

### クロスリファレンス（セクション → 関連ルール）

| セクション | 関連 Universal ルール |
|:---------|:-------------------|
| §1 哲学 | `000_core_mindset`（Validated Learning原則） |
| §2 問題定義 | `000_product_strategy`（§2.2 JTBD） |
| §3 市場規模 | `300_revenue_monetization`（Unit Economics）, `000_product_strategy`（§2.6 Market Sizing） |
| §4 顧客発見 | `000_product_strategy`（§2.1 Continuous Discovery, §2.5 Design Partner） |
| §5 仮説管理 | `000_product_strategy`（§2.1 Hypothesis Log） |
| §6 MVP設計 | `000_product_strategy`（§1.2 MVP to PMF, MLP Protocol） |
| §7 PMF測定 | `500_growth_marketing`（NSM・KPI）, `ai/100_data_analytics`（計測） |
| §8 スケール | `200_go_to_market`（GTM戦略）, `300_revenue_monetization`, `400_pricing_strategy` |
| §9 競合分析 | `000_product_strategy`（§2.4 Competitive Moat, §1.6 Category Creation） |
| §10 ピボット | `000_core_mindset`（§1.1 Pivot原則）, `900_fundraising_ir`（投資家コミュニケーション） |
| §11 データ収集 | `ai/100_data_analytics`（Behavioral Analytics）, `000_design_ux`（UXリサーチ） |
| §12 PMF維持 | `000_product_strategy`（§17 競合インテリジェンス）, `300_customer_experience` |
| §13 PMF拡張 | `200_go_to_market`（GTMモーション移行）, `800_internationalization` |
| §14 Demand-Side | `000_product_strategy`（§2.5 Design Partner）, `100_sales_bizdev`（LOI） |
| §15 AI-Native | `ai/000_ai_engineering`（AI Safety Scorecard）, `000_product_strategy`（§9 AI-Native）, `security/100_data_governance`（AI信頼性） |
| §16 成熟度 | `000_engineering_standards`（成熟度モデル参照） |
| §17 アンチパターン | 各セクションへの逆参照 |
