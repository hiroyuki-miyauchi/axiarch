# 12. GTM戦略・市場参入とローンチ (Go-to-Market Strategy & Launch)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-04-06

> [!IMPORTANT]
> **Supreme Directive（最高指令）**
> 「優れたプロダクトも、正しく届かなければ存在しないのと同じである」
> **GTMはプロダクト開発と同等の設計行為である。** 「作れば売れる」という幻想を完全に排除する。
> ローンチは「1日のイベント」ではなく「継続的なプロセス」である。
> **10パート・38セクション構成。**

---

## 目次

- [Part I. GTM の哲学と前提](#part-i-gtm-の哲学と前提)
- [Part II. ポジショニング戦略](#part-ii-ポジショニング戦略)
- [Part III. ICP（理想顧客プロファイル）の定義](#part-iii-icp理想顧客プロファイルの定義)
- [Part IV. GTM モーションの選択](#part-iv-gtm-モーションの選択)
- [Part V. チャネル戦略](#part-v-チャネル戦略)
- [Part VI. ローンチ計画の設計](#part-vi-ローンチ計画の設計)
- [Part VII. 初期顧客獲得プロトコル](#part-vii-初期顧客獲得プロトコル)
- [Part VIII. GTM メトリクスと計測](#part-viii-gtm-メトリクスと計測)
- [Part IX. GTM 組織・責任設計](#part-ix-gtm-組織責任設計)
- [Part X. Appendix: 逆引き索引・クロスリファレンス](#part-x-appendix-逆引き索引クロスリファレンス)

---

## Part I. GTM の哲学と前提

### 1.1. GTM の定義と範囲

- **Rule 12.001**: GTM（Go-To-Market）戦略を「誰に・何を・どのように・いくらで届けるかの包括的な設計」と定義する
- **Rule 12.002**: GTM はプロダクトチームの責務である。「それはマーケティングの仕事」という分断を禁止する
- GTM の4要素:

```
Who:    誰に届けるか（ICP・Persona）
What:   何を届けるか（Value Proposition・Positioning）
How:    どうやって届けるか（Channel・GTM Motion）
When:   いつ・どのタイミングで（Launch Sequence）
```

### 1.2. GTM 開始の前提条件

- **Rule 12.003**: 以下が全て満たされていない限り、本格的な GTM 投資を開始しない

```
必須前提:
□ Problem-Solution Fit の確認（§100_market_validation における顧客発見完了）
□ ICP が3名以上の実在顧客で具体化されている
□ コアバリュープロポジションが1文で言明できる
□ 競合に対する明確な差別化が定義されている
□ 基本的な製品提供能力（MVP以上）が存在する
```

### 1.3. GTM ≠ マーケティングキャンペーン

- **Rule 12.004**: GTM 戦略は「広告を打つこと」と混同しない。以下の要素を含む包括的な設計である
  - 製品の価格設計
  - 販売チャネルの構築
  - 営業プロセスの設計
  - カスタマーサクセスの準備
  - オンボーディングの設計

---

## Part II. ポジショニング戦略

### 2.1. ポジショニングの原則

- **Rule 12.010**: ポジショニングは「自分たちが何であるか」ではなく **「顧客の頭の中に占める位置」** として定義する（Al Ries & Jack Trout）
- **Rule 12.011**: ポジショニングは競合比較ではなく、**顧客の既存の思考の枠組み（フレーム）** に新しいカテゴリを作ることを目指す

### 2.2. April Dunford の Positioning Canvas

- **Rule 12.012**: ポジショニングは以下の5要素で定義する（[Obviously Awesome, April Dunford]）

| 要素 | 問い | 例 |
|:----|:----|:--|
| **Competitive Alternatives** | 競合がなければ顧客は何を使うか | Excel, メール, 何もしない |
| **Unique Attributes** | 競合にない独自の特徴は何か | リアルタイム同期, AI提案機能 |
| **Value for Customer** | そのAttributeが顧客にもたらす価値は | 承認時間が60%削減 |
| **Target Customer** | 価値を最も感じられる顧客は誰か | 月次承認が10件以上の財務担当者 |
| **Market Category** | どのカテゴリとして認識されたいか | 「AI財務承認プラットフォーム」 |

### 2.3. Category Creation（カテゴリ創造）戦略

- **Rule 12.013**: 既存カテゴリへの参入は価格競争に陥るリスクがある。新カテゴリを創造できる場合はその戦略を優先的に検討する
- **カテゴリ創造の条件**:
  - 既存カテゴリが顧客のニーズを適切に表現していない
  - 新しい問題定義により、競合を「比較対象外」にできる
  - カテゴリの定義を業界に先行して wide に語れる

### 2.4. Messaging Hierarchy（メッセージ階層）

- **Rule 12.014**: 外部向けメッセージは以下の3層で整理し、それぞれの目的を明確にする

```
Layer 1: Tagline / Headline（3秒の注意を取る）
         例: "5分でできる経費精算"

Layer 2: Sub-headline / Value Proposition（30秒で価値を伝える）
         例: "領収書を撮るだけで自動仕訳。月末の経費精算地獄から解放されます。"

Layer 3: Feature Proof Points（3分で根拠を示す）
         例: AI OCRで99.5%の精度 / Supabase連携でリアルタイム同期 / ...
```

---

## Part III. ICP（理想顧客プロファイル）の定義

### 3.1. ICP と Persona の違い

- **Rule 12.020**: ICP（Ideal Customer Profile）と Persona を明確に区別する

| 概念 | レベル | 用途 |
|:----|:------|:----|
| **ICP** | 組織レベル（B2B）/ セグメントレベル（B2C） | 誰を集中して狙うかの戦略判断 |
| **Persona** | 個人レベル | UIデザイン・コピーライティング |

### 3.2. B2B ICP の定義要素

- **Rule 12.021**: B2B の ICP は以下の属性で定義する

```yaml
b2b_icp:
  firmographics:
    industry: ["SaaS", "フィンテック"]
    employees: "50-500名"
    revenue: "5億円〜50億円"
    geography: ["日本", "シンガポール"]
    tech_stack: ["Salesforce", "Slack", "AWS"]
  
  situational:
    trigger_events:         # ICPが製品を探し始めるタイミング
      - "資金調達後のスケーリングフェーズ"
      - "B2B Sales チームが10名を超えた"
      - "既存ツールの契約更新時期3ヶ月前"
    pain_indicators:        # ICP が持つ課題のシグナル
      - "Indeed に営業採用を3件以上掲載中"
      - "LinkedIn で CRO の採用投稿あり"
    disqualifiers:          # 除外条件（SDR が時間を無駄にしない）
      - "従業員10名未満"
      - "既存競合と長期契約中"
```

### 3.3. B2C ICP の定義要素

- **Rule 12.022**: B2C の ICP は行動・状況ベースで定義する（人口統計は補助情報に留める）

```yaml
b2c_icp:
  behavioral:
    trigger: "現在の解決策に月2,000円以上を支払っている"
    frequency: "週3回以上この課題に直面する"
    digital_savvy: "スマホアプリを10個以上インストールしている"
  
  attitudinal:
    pain_awareness: "問題を明確に認識している（Pain-Aware）"
    solution_awareness: "解決策の存在を知っている"
    urgency: "次の90日以内に解決したい"
```

### 3.4. ICP スコアリングモデル

- **Rule 12.023**: 営業・マーケティング効率化のため、ICP一致度をスコアリングする仕組みを構築する

```
ICP Score = Σ(属性一致 × 重み)

スコア 80以上: 最優先（Tier 1）→ AE が直接接触
スコア 60-79: 優先（Tier 2）→ SDR + シーケンス
スコア 40-59: 低優先（Tier 3）→ マーケティングナーチャリング
スコア 40未満: 対象外 → 自動除外
```

---

## Part IV. GTM モーションの選択

### 4.1. GTM モーションの種類

- **Rule 12.030**: GTM モーションを以下の4種類から（重複可）選択し、主力モーションを明確にする

| モーション | 説明 | 向いている製品タイプ |
|:---------|:----|:----------------|
| **PLG** (Product-Led Growth) | 製品自体が主要な獲得・拡大エンジン | Viral性があるSaaS、個人向けプロダクト |
| **SLG** (Sales-Led Growth) | セールスチームが主要な獲得エンジン | エンタープライズ、高単価B2B |
| **MLG** (Marketing-Led Growth) | コンテンツ・ブランドが主要な獲得エンジン | 教育系、複雑な意思決定が必要なSaaS |
| **CLG** (Community-Led Growth) | コミュニティが主要な獲得・拡大エンジン | DevTools、OSS、ニッチ専門職向け |

### 4.2. PLG の実装プロトコル

- **Rule 12.031**: PLG を選択した場合、以下を設計する

```
PLG の3エンジン:
1. Acquisition Engine（獲得）
   - フリートライアル / フリーミアムの WTPライン設計
   - Viral Loop の組み込み（共有・招待・埋め込み）
   - Product Hunt / App Store のストア最適化

2. Activation Engine（活性化）
   - Time-to-Value（最初の価値体験）を ≤ 5分に設計
   - Onboarding の「Aha Moment」到達までのステップを最小化

3. Expansion Engine（拡大）
   - ユーザー内でのスプレッド設計（シート追加、部署展開）
   - Usage-based Billing との連動（使えば使うほど価値が増す）
```

### 4.3. SLG の実装プロトコル

- **Rule 12.032**: SLG を選択した場合、以下を設計する

```
SLG の基本構造:
Lead → MQL → SQL → SAL → Opportunity → Closed Won

各ステージの定義をBlueprint側で明文化すること:
- MQL（Marketing Qualified Lead）の定義基準
- SQL（Sales Qualified Lead）の定義基準  
- BANT / MEDDIC によるOpportunity資格確認基準
```

### 4.4. GTM モーションの移行プロトコル

- **Rule 12.033**: PLG から SLG への移行（Product-Led Sales）は以下の兆候が出た時点で検討する
  - エンタープライズからのインバウンドが月5件以上
  - フリープランからの自然な拡大が止まり始める
  - ACV（年間契約額）が100万円を超える顧客が出現

---

## Part V. チャネル戦略

### 5.1. チャネル発見プロトコル

- **Rule 12.040**: 初期は3〜5チャネルの実験を並行実施し、**1チャネルへのリソース集中** を4〜8週間で決定する
- **Rule 12.041**: 各チャネルを以下の基準で評価する

| 評価軸 | 配点 | 説明 |
|:------|:----|:----|
| リーチ（Reach） | 1-5 | 到達可能なICPの数 |
| フォーカス（Targeting） | 1-5 | ICP だけに届けられるか |
| コスト（Cost） | 1-5 | CAC の見込み |
| スピード（Speed） | 1-5 | 効果が出るまでの時間 |
| コントロール（Control） | 1-5 | 自社でコントロールできるか |

### 5.2. チャネル別特性と活用法

| チャネル | 強み | 弱み | 向いているフェーズ |
|:--------|:----|:----|:--------------|
| **SEO / Content** | スケーラブル, 低CAC | 効果まで時間 | PMF後のスケール |
| **SEM / Paid** | 即効性, 測定容易 | コスト高, 停止=消滅 | 検証・スケール |
| **Cold Email / SDR** | 高ターゲティング | スケール困難 | アーリーアダプター獲得 |
| **Partnerships** | 一括リーチ | 依存リスク | チャネル多様化後 |
| **PR / Media** | Brand認知 | 営業転換率低 | ローンチ・資金調達前後 |
| **Product Viral** | 低コスト | PMF前提 | PMF達成後 |
| **Community** | 高エンゲージ | 構築に時間 | ニッチ市場 |
| **Events / WEB** | 高品質リード | 再現性低 | アーリーアダプター |

### 5.3. チャネル集中の法則

- **Rule 12.042**: 獲得チャネルは **多角化より集中** を優先する。1チャネルで CAC 回収が成立するまで次のチャネルに着手しない
- **Rule 12.043**: 「チャネル多様化」は戦略ではなく、依存リスクの管理フェーズで行う（ARR 1億円以降が目安）

---

## Part VI. ローンチ計画の設計

### 6.1. ローンチの3段階構造

- **Rule 12.050**: プロダクトローンチは以下の3フェーズで設計する

```
Phase 1: Soft Launch（限定公開）
目的: アーリーアダプターからのリアルフィードバック収集
対象: ウェイトリスト上位 / 信頼できる既存ネットワーク
KPI: NPS ≥ 30, Day-7 Retention ≥ 30%

Phase 2: Closed Beta（招待制クローズドベータ）
目的: PMFシグナルの強化 / バグ撲滅 / Testimonial収集
対象: ICP に一致する 50-200名
KPI: Sean Ellis Test ≥ 40%, Churn < 10%/月

Phase 3: Public Launch（公開ローンチ）
目的: 認知の最大化 / 獲得チャネルの検証
対象: 全体公開
KPI: Web Traffic, Signups, Conversion, MRR
```

### 6.2. Product Hunt ローンチプロトコル

- **Rule 12.051**: Product Hunt を活用する場合、以下を実施する

```
ローンチ前（4週間）:
□ Hunter / Maker のプロフィールを充実させる
□ コミュニティに事前貢献（コメント・Upvote 習慣化）
□ ウェイトリスト / Teaser ページで期待値構築
□ Supporter リスト（Upvoteしてくれる見込み）を 200名以上構築

ローンチ当日:
□ 00:01 AM PST に公開（1日フルに使う）
□ 全チームでSNS掃討（Twitter/X, LinkedIn, Slack コミュニティ）
□ 最初の2時間での Upvote 速度が Top 5 入りの鍵

ローンチ後:
□ 全コメントに24時間以内に返信
□ 獲得したユーザーを Soft Launch リストに追加
□ 翌月の指標をフォローアップとして公開
```

### 6.3. ローンチのタイミング原則

- **Rule 12.052**: ローンチのタイミングを以下の観点で最適化する

| 要素 | ベストプラクティス |
|:----|:--------------|
| 曜日 | 火曜〜木曜（B2B）/ 週末前後（B2C・コンシューマ）|
| 季節 | Q1・Q3（予算執行期。Q4年末・連休前後は避ける）|
| 業界イベント | 主要カンファレンスの前週に合わせる |
| 競合動向 | 競合の大型ローンチと重ならないタイミングを選ぶ |

---

## Part VII. 初期顧客獲得プロトコル

### 7.1. Do Things That Don't Scale（スケールしないことをせよ）

- **Rule 12.060**: 初期の顧客獲得はスケーラブルな方法にこだわらない。手間がかかっても高品質な顧客と直接関係を築くことを優先する（Paul Graham, Y Combinator）

```
スケールしない顧客獲得の例:
- 創業者が全サポートチケットに手動返信する
- 見込み顧客のカンファレンスに全員出席する
- ターゲット100社に個別カスタマイズされたアウトリーチ
- 競合ユーザーのTwitterフォロワーに手動DM
- 地域コミュニティに直接入り込む
```

### 7.2. 最初の 10 顧客獲得プロトコル

- **Rule 12.061**: 最初の10顧客は以下の順序で獲得する

```
Step 1: 自分の直接ネットワーク（同僚・友人・元同僚）
Step 2: 2次ネットワークへの紹介依頼
Step 3: ターゲットコミュニティへの直接参加（価値提供先行）
Step 4: ICP がいる場所への手動アウトリーチ
Step 5: Cold Email（高度なパーソナライズを必須とする）
```

- **Rule 12.062**: 最初の10顧客は **ICP に完全一致する顧客のみを選ぶ**。「誰でもいいから」という姿勢を禁止する

### 7.3. Customer Success as a GTM Engine

- **Rule 12.063**: 初期は Customer Success（CS）を獲得エンジンとして位置づける
  - 既存顧客の成功事例（Case Study）を積極的に作成し、GTM 資産とする
  - NPS 9-10 の顧客に必ず紹介依頼を行う（Referral Program）
  - 成功している顧客の行動パターンを Playbook 化し、再現性を高める

---

## Part VIII. GTM メトリクスと計測

### 8.1. GTM の KPI ダッシュボード

- **Rule 12.070**: GTM の効果を以下の指標体系でモニタリングする

```
Acquisition Layer（獲得）:
- Website Visitors（セッション数）
- MQL（マーケティング資格獲得リード数）
- CAC（顧客獲得コスト）per チャネル

Activation Layer（活性化）:
- Signup → Trial Conversion Rate
- Time-to-First-Value（最初の価値体験到達時間）
- Onboarding Completion Rate

Revenue Layer（収益）:
- MRR / ARR
- ACV（年間契約額）分布
- Deal Velocity（最初の接触から成約までの日数）

Expansion Layer（拡大）:
- Net Revenue Retention (NRR) ≥ 100% を目標
- Expansion MRR（既存顧客からのアップグレード収益）
- Referral Rate（紹介経由の新規割合）
```

### 8.2. Funnel Conversion の標準ベンチマーク

- **Rule 12.071**: 以下のベンチマークと自社指標を比較し、改善優先度を決定する

| ステージ | B2B SaaS 標準 | B2C 標準 |
|:--------|:------------|:--------|
| Visit → Signup | 2-5% | 5-15% |
| Signup → Activated | 20-40% | 30-60% |
| Trial → Paid | 15-30% | 2-8% |
| MQL → SQL | 15-25% | - |
| SQL → Closed Won | 20-30% | - |

### 8.3. GTM Attribution（マーケティング帰属分析）

- **Rule 12.072**: マルチタッチアトリビューションを実装し、チャネルの真の貢献度を測定する
  - First Touch, Last Touch, Linear, Time Decay, Data-driven の各モデルを理解した上で自社に適したモデルを選択する
  - UTM パラメータを全チャネルで統一的に実装し、欠損を許容しない

---

## Part IX. GTM 組織・責任設計

### 9.1. Revenue Team の構造

- **Rule 12.080**: GTM 機能を以下のロールで設計する（会社フェーズに応じてスタック可）

| ロール | フォーカス | 必要になるフェーズ |
|:------|:---------|:------------|
| **AE** (Account Executive) | クロージング | 月次MRR 500万円以上 |
| **SDR** (Sales Dev Rep) | パイプライン生成 | AEが忙しくなった時点 |
| **CSM** (Customer Success Mgr) | 維持・拡大 | チャーン率が問題になった時点 |
| **PMM** (Product Marketing Mgr) | Positioning・Enablement | Series A 前後 |
| **Growth Eng** | PLG・Funnel最適化 | PLG が主力モーションの場合 |

### 9.2. GTM の責任分界点

- **Rule 12.081**: Product と GTM の責任境界を明確にする

```
Product の責任:
- Onboarding フロー（UIとコピー）
- Product Viral ループの設計
- Activation Metric の定義と達成

GTM の責任:
- チャネルの選択と実行
- Messaging・Positioning
- Pricing の設定と変更
- Deal のクロージング
```

### 9.3. Smarketing（Sales + Marketing 統合）プロトコル

- **Rule 12.082**: Sales と Marketing のサイロを排除するための連携プロトコルを定義する
  - MQL/SQL の定義を両者が合意して文書化する
  - 週次で MQL品質・フィードバックを相互共有する
  - 共通の収益目標（Revenue Target）に対して両チームが評価される制度を設計する

---

## Part X. Appendix: 逆引き索引・クロスリファレンス

### 逆引き索引（キーワード → セクション）

| キーワード | 対応セクション |
|:---------|:------------|
| ポジショニング・カテゴリ創造・メッセージ階層 | §2 ポジショニング |
| ICP・ペルソナ・B2B・B2C・スコアリング | §3 ICP |
| PLG・SLG・MLG・CLG | §4 GTMモーション |
| SEO・Paid・Cold Email・チャネル評価 | §5 チャネル戦略 |
| Product Hunt・Soft Launch・Beta | §6 ローンチ計画 |
| 10顧客・Do Things That Don't Scale | §7 初期獲得 |
| KPI・Funnel・Attribution・NRR | §8 GTMメトリクス |
| AE・SDR・CSM・PMM・Smarketing | §9 GTM組織 |

### クロスリファレンス（セクション → 関連ルール）

| セクション | 関連 Universal ルール |
|:---------|:------------------|
| §2 ポジショニング | `600_brand_strategy`, `000_product_strategy` |
| §3 ICP | `100_market_validation`（Customer Discovery） |
| §4 PLG | `000_product_strategy`（§4 収益化戦略）|
| §5 チャネル | `500_growth_marketing` |
| §6 ローンチ | `500_growth_marketing`（PLG・SEO/GEO） |
| §7 初期獲得 | `100_sales_bizdev`（営業プロセス） |
| §8 メトリクス | `100_data_analytics`（Analytics） |
| §9 GTM組織 | `200_hr_organization`（採用・組織） |
