# 52. 採用・組織設計 (HR & Organization Design)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-04-06

> [!IMPORTANT]
> **Supreme Directive（最高指令）**
> 「AプレイヤーはAプレイヤーを採用する。Bプレイヤーはcプレイヤーを採用する」
> 組織は **「採用した人間の集積」** であり、採用の質が組織の長期的な実力を決定する。
> 「採用は容易化ではなく最重要化せよ。採用ミスのコストは採用プロセスのコストをはるかに超える」
> **9パート・34セクション構成。**

---

## 目次

- [Part I. 採用哲学](#part-i-採用哲学)
- [Part II. Job Design（役割設計）](#part-ii-job-design役割設計)
- [Part III. 採用プロセスの設計](#part-iii-採用プロセスの設計)
- [Part IV. インタビュープロセス](#part-iv-インタビュープロセス)
- [Part V. オファー・クロージング](#part-v-オファークロージング)
- [Part VI. Onboarding 設計](#part-vi-onboarding-設計)
- [Part VII. パフォーマンス管理](#part-vii-パフォーマンス管理)
- [Part VIII. 組織設計原則](#part-viii-組織設計原則)
- [Part IX. Appendix: 逆引き索引・クロスリファレンス](#part-ix-appendix-逆引き索引クロスリファレンス)

---

## Part I. 採用哲学

### 1.1. Talent Density（人材密度）の最大化

- **Rule 52.001**: 採用の目標は「人数を増やすこと」ではなく **「組織の人材密度（Talent Density）を高めること」** と定義する（Netflix）
- **Rule 52.002**: 採用基準を妥協して「今すぐ穴を埋めるための採用」を禁止する。欠員が出たとしても基準を下げない

### 1.2. Hire for Attitude, Train for Skills

- **Rule 52.003**: 以下の優先順位で採用判断を行う

```
優先度の高い順:
1. Values Alignment（会社の価値観との整合性）
2. Learning Agility（学習速度・成長意欲）
3. Attitude（姿勢・Ownership・誠実さ）
4. Relevant Skills（現時点での技術力・専門性）

注意: 4番目の Skills のみで採用することを禁止する
     1-3 が欠けた場合、Skills は競争優位にならない
```

### 1.3. バー設定プロトコル（Raise the Bar）

- **Rule 52.004**: 全候補者について **「我々の平均よりこの人はバーを上げるか？」** を採用決定の基準に設ける（Amazon）
- **Rule 52.005**: 採用チームに1人以上の「バーレイザー（基準維持役）」を配置することを推奨する（Series A 以降）

---

## Part II. Job Design（役割設計）

### 2.1. Job Description の品質基準

- **Rule 52.010**: 求人票を以下の構成で作成し、候補者が「自分のための仕事か」を判断できるようにする

```
Job Description 必須セクション:
1. Why This Role（なぜこのロールが存在するか）
2. What You'll Do（具体的な仕事の内容）
3. What Success Looks Like（90日・1年の成功定義）
4. What We're Looking For（Must/Nice-to-have の分離）
5. What You'll Get（報酬・ストックオプション・ベネフィット）
6. Our Culture（なぜここで働くべきか）

禁止:
❌ 「その他業務全般」という表現
❌ 要件の羅列のみ（候補者がWhy を理解できない）
❌ 過剰な要件（10年以上の経験が必要な Seed スタートアップの JD）
```

### 2.2. ロールの明確化

- **Rule 52.011**: 新しいポジションを開く前に以下を明文化する

```yaml
role_definition:
  mission: "このロールが果たすべき使命（1文）"
  key_results:
    - "3ヶ月で達成すること"
    - "1年で達成すること"
  decision_rights: "このロールが独断で決められること / 要相談のこと"
  collaboration:
    - "誰と最も密に仕事するか"
  growth_path: "このロールの次のキャリアステップ"
```

### 2.3. Compensation Philosophy（報酬哲学）

- **Rule 52.012**: 報酬哲学を透明な原則として定義する

```
推奨する報酬哲学:
- 市場の P75（上位25%）以上の固定給を提供する
- 変動報酬（ボーナス）より固定給の充実を優先する
- ストックオプション（ESOP）はロールの市場価値・希薄化を考慮して設計する
- 「給与交渉」により最終報酬がバラつくことを最小限にする（同一職種の給与バンドを設定する）
```

---

## Part III. 採用プロセスの設計

### 3.1. 採用ファネルの標準設計

- **Rule 52.020**: 採用プロセスを以下の標準構成で設計し、**4週間以内**に完了させる

```
Sourcing → Screen → Phone Screen → Interview → Reference → Offer

各ステップの期間目安:
Phone Screen: 連絡から3日以内に実施
Interview: Phone Screenから1週間以内に設定
Offer: 最終インタビューから3日以内に送付

禁止: 10ステップ以上の採用プロセス（候補者離脱の主因）
```

### 3.2. Sourcing の多様化

- **Rule 52.021**: 採用ソースを以下の優先順位で活用する

| 優先度 | ソース | 理由 |
|:------|:------|:----|
| 1 | **Internal Referral** | 最高品質・低コスト・スピード |
| 2 | **LinkedIn Recruiter** | 大規模サーチ・パッシブ候補 |
| 3 | **Targeted JD（Niche掲載）** | 専門職向け |
| 4 | **Recruiting Agency** | スピード優先時・コスト高 |
| 5 | **Job Boards（Wantedly等）** | 大量応募だが品質ばらつき |

### 3.3. Referral Program（参照採用）の設計

- **Rule 52.022**: 全社員が採用に参加するReferral Programを構築する
  - Referral ボーナス: 採用が確定し試用期間を超過した時点で支給
  - Referral の質のフィードバック: 紹介された候補者の結果を紹介社員に共有する（学習効果）
  - 「友人を紹介したくなる会社」であることがReferralの前提条件

---

## Part IV. インタビュープロセス

### 4.1. Structured Interview（構造化インタビュー）

- **Rule 52.030**: 採用インタビューは **構造化（Structured）** で行う。対話を楽しむだけの非構造化インタビューを禁止する
- **構造化の定義**: 全候補者に同一の質問を同一の順序で行い、評価基準も事前定義する

### 4.2. インタビュータイプの組み合わせ

- **Rule 52.031**: 1採用プロセスに以下の複数インタビュータイプを組み合わせる

| タイプ | 目的 | 例 |
|:------|:----|:--|
| **Behavioral** | 過去の行動から未来を予測 | STAR法（状況・課題・行動・結果） |
| **Situational** | 仮定状況への対応力を見る | Case Interview |
| **Technical / Skills** | 専門能力の直接評価 | Coding Test / Design Review |
| **Culture / Values** | 価値観・カルチャーフィット | Values Alignment Interview |
| **Reference** | 第三者評価の取得 | バックチャンネルリファレンス |

### 4.3. Debrief（採用会議）プロトコル

- **Rule 52.032**: インタビュー後のDebrief（採用会議）は以下のルールで行う

```
Debrief の実施ルール:
1. 各インタビュアーがDebrief前に独立スコアを記録する（他の人の意見の影響を受けない）
2. HIRE / NO HIRE / UNSURE の3択でまず判断を述べ、その後に議論する
3. 強い「NO HIRE」が1人でもいる場合は追加検証か見送りを検討する
4. Debrief の議題は「この人を採用するか」ではなく「この人はバーを上げるか」

禁止:
❌ ヒポクリシー（上司の意見に全員が追随する）
❌ Debrief なしでの採用決定
```

### 4.4. Unconscious Bias（無意識の偏見）の除去

- **Rule 52.033**: 採用における以下の無意識の偏見を構造的に排除する

| 偏見の種類 | 防止策 |
|:---------|:------|
| **Similar-to-me Bias** | 評価基準を事前定義する |
| **Halo Effect** | 一つの強みが全体評価を歪める → 評価軸を分離 |
| **First Impression Bias** | Resume Blind Interview の実施 |
| **Affinity Bias** | 評価者の多様性を確保する |

---

## Part V. オファー・クロージング

### 5.1. Offer のタイミングと設計

- **Rule 52.040**: 最終インタビューから3日以内にオファーを送付することを義務とする
  - **Verbal Offer First**: 書面より先に電話でオファーの意向を伝え、受諾意思を確認する
  - **Offer Letter の必須項目**: 役職・報酬・入社日・ストックオプション条件・試用期間

### 5.2. 候補者が迷っている場合の対応

- **Rule 52.041**: 候補者が意思決定を迷っている場合の対応プロトコル

```
確認すべき事項:
1. 「迷っている理由」を直接聞く（憶測しない）
2. 他社オファーの存在と比較軸を確認する
3. 「入社後のリスク懸念」に対しては具体的な回答と保証を提示する
4. 候補者が現職を辞める動機（Push factor）を事前に確認し、そこへの共感を示す

禁止:
❌ プレッシャーをかけて意思決定を急かす（後悔 → 早期離職の原因）
❌ 過剰な期待を与えるオーバープロミス
```

---

## Part VI. Onboarding 設計

### 6.1. 90日間 Onboarding プログラム

- **Rule 52.050**: 新入社員の Onboarding は90日間のプログラムとして設計する

```
Day 1-7（Day 1 Experience）:
□ 全ツールのセットアップ（入社当日完了を義務）
□ 会社・プロダクト・文化のオリエンテーション
□ チームメンバー全員との1on1（15分でもよい）
□ 最初のWin（小さな貢献）を経験させる

Week 2-4（Role Deep Dive）:
□ 担当領域の深掘り学習
□ シャドウイング（先輩の業務観察）
□ 30/60/90日の目標設定（マネジャーと合意）

Month 2-3（Onboarding to Ownership）:
□ 最初の独立プロジェクト
□ Mid-point Check-in（マネジャーとの振り返り）
□ カルチャーフィットの確認（双方向）
```

### 6.2. Buddy Program（バディ制度）

- **Rule 52.051**: 新入社員全員に「Buddy（非マネジャーの先輩社員）」をアサインする
  - Buddy の役割: 業務的な質問ではなく「文化・暗黙知」の案内役
  - Buddy の期間: 入社後90日間

---

## Part VII. パフォーマンス管理

### 7.1. OKR（Objectives & Key Results）の設計

- **Rule 52.060**: チームの目標管理には OKR を使用する

```
OKR 設計の原則:
- Objective: 定性的・感情を動かす方向性（What ではなく Why）
- Key Result: 定量的・測定可能・時間制限付き
- 数: Objective 1つに Key Result は2-5つ
- 難易度: 70%達成を「良い」と定義する（Moonshots）
- 公開: 全員の OKR を全社公開し、整合性を保つ

禁止:
❌ Key Result が「〇〇をする」（行動ではなく成果を定義する）
❌ 厳正に達成できる KR（挑戦がない）
```

### 7.2. 1on1 ミーティングの標準

- **Rule 52.061**: マネジャーと直属メンバー間の 1on1 は最低週1回30分で実施する

```
1on1 の議題構成:
1. メンバーの近況・気になること（15分）
   ← マネジャーが聞く側に回る
2. ブロッカー・サポートが必要なこと（10分）
3. 目標・キャリア開発への言及（5分）

禁止:
❌ 1on1 を Status Update ミーティングにする（それは別会議）
❌ マネジャーが一方的に話す
```

### 7.3. Performance Review のプロトコル

- **Rule 52.062**: パフォーマンスレビューは半期ごとに実施し、以下の3次元で評価する

```
評価の3軸:
1. What（成果）: OKR / 目標の達成度
2. How（行動）: Values・カルチャーに沿った行動だったか
3. Potential（ポテンシャル）: 上のロールで活躍できるか

禁止:
❌ サプライズ（レビュー前に1on1で問題を共有していなかった）
❌ 年末のみの評価（継続的なフィードバックの代替にしない）
```

---

## Part VIII. 組織設計原則

### 8.1. Conway's Law への対応

- **Rule 52.070**: 「組織はその通信構造を反映したシステムを設計する（Conway's Law）」を前提に、プロダクトとチーム構造を整合させる
  - チームの構造設計時に、それが生み出すプロダクトのアーキテクチャを意識する

### 8.2. Team Topology

- **Rule 52.071**: チーム構造は Team Topologies（Skelton & Pais）の4タイプで設計する

| タイプ | 目的 | 例 |
|:------|:----|:--|
| **Stream-Aligned** | ビジネス価値の継続的デリバリー | 機能チーム（Checkout チーム等） |
| **Enabling** | 他チームの能力向上 | プラットフォームエンジニアリング |
| **Complicated Subsystem** | 専門的な複雑な機能 | Machine Learning チーム |
| **Platform** | 内部プラットフォームの提供 | DevOps・インフラ |

### 8.3. Span of Control（管理範囲）

- **Rule 52.072**: マネジャーの直属メンバー数は原則 **5-8名** を上限とする
  - IC（Individual Contributor）への直接管理が5名以上: 新しい Engineering Manager を採用する
  - Manager of Managers（部門長）: 5 Managers まで

### 8.4. Remote / Hybrid 組織の原則

- **Rule 52.073**: リモートワーク環境での組織運営に以下の原則を適用する

```
Remote-Friendly の5原則:
1. Async First: 同期ミーティングは Default でなく例外とする
2. Documentation First: 会議での決定も必ず文書化する
3. Timezone Respect: コアタイム外のメッセージ返信を強制しない
4. Camera On Policy: 顔出しによる孤独感軽減と関係構築
5. IRL Meetups: 四半期に1回以上の対面機会を設ける
```

---

## Part IX. Appendix: 逆引き索引・クロスリファレンス

### 逆引き索引（キーワード → セクション）

| キーワード | 対応セクション |
|:---------|:------------|
| Talent Density・バーレイザー・A Player | §1 採用哲学 |
| Job Description・役割定義・報酬哲学 | §2 Job Design |
| Referral・Sourcing・採用ファネル | §3 採用プロセス |
| Structured Interview・STAR・Debrief | §4 インタビュー |
| Offer・クロージング | §5 オファー |
| 90日・Buddy・Onboarding | §6 Onboarding |
| OKR・1on1・Performance Review | §7 パフォーマンス管理 |
| Conway's Law・Team Topology・Remote | §8 組織設計 |

### クロスリファレンス（セクション → 関連ルール）

| セクション | 関連 Universal ルール |
|:---------|:------------------|
| §1 Talent Density | `000_core_mindset`（Keeper Test） |
| §3 Referral | `200_go_to_market`（Community Growth） |
| §6 Onboarding | `000_internal_tools`（Internal Tools Onboarding） |
| §7 OKR | `000_product_strategy`（North Star Metric） |
| §8 Remote原則 | `000_internal_tools`（Admin Tool Design） |
