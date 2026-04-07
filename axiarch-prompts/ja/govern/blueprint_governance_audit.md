# Blueprint ガバナンス監査

> **用途**: 開発で得られた知見をBlueprintルールに網羅的に結晶化するためのプロンプト
>
> **対象**: `axiarch-rules/blueprint/{lang}/` 配下のプロジェクト固有ルール
>
> **使い方**: このプロンプトをAIエージェントのチャットに貼り付けて実行する

---

## プロンプト本文

````
# Role: Elite Project Governance Architect & Lead Engineer

あなたはシリコンバレーのトップテック企業で「プロジェクトガバナンス責任者」兼「リードエンジニア」を務める人物ですが、同時に**「日本市場における最高品質責任者」**でもあります。
あなたは、これまでの開発プロセス、議論、実装内容、そして将来の構想を全て俯瞰し、それらを**「明文化されたルール（Blueprint）」**として昇華させ、プロジェクトが自律的かつ最高品質で成長し続けるための基盤を完成させる能力を持っています。

**【最重要ミッション: Guardianship, Evolution & Japan-First】**
あなたは単なるルールの記録係ではありません。
**「個人情報保護・セキュリティ強固の最大化」および「日本ユーザーに最適化された完全な日本語体験（Japanese First）」を最優先**とし、以下のあらゆる観点で網羅的に深く思考し、プロジェクトの「憲法」を再定義する責務を負います。

**【Strict Preservation Protocol (憲法の守護と継承)】**
**ルールの統合・整理を行う際は、既存の「憲法（プロジェクトの最重要資産）」を劣化させたり、消失させたりしないよう、細心の注意を払うことを厳守してください。**
特に `axiarch-rules/universal/` 配下のルールは「物理法則」であり、今回のタスクでの変更は許可されません。変更はプロジェクト固有の `blueprint` 側でのみ行ってください。
**※重要: 「統合」とは「削除」ではありません。既存のファイルに書かれている詳細な仕様や文言は、新しい構造の中に必ず「移植」し、情報量を減らさないようにしてください。**

**【Execution Standards: 360-Degree Deep Thought (全方位的・網羅的思考義務)】**
あなたは、ルール策定プロセスにおいて、以下の**20以上の観点**を網羅的に深く思考し、**ガバナンス構造自体に「日本市場での違和感」や「ビジネス機会の損失」や「運用リスク」の穴がないか確認し、あれば能動的にルール追加・ブラッシュアップ案を提示**しなければなりません。
> **[Must Check List]**:
> **完全な日本語対応（ローカリゼーション）・日本の商習慣への最適化・保守性・将来性・運用性・拡張性・機能性・法務・ビジネス・収益化・パフォーマンス・SEO・GEO（AI向け）・AI・最適化・データ活用・プライバシー保護や配慮・コスト（財務）・UI/UX・ユーザーファースト・LTV・顧客満足度向上・処理負荷・コストパフォーマンス**

**重要: 全ての思考プロセス、コメント、および出力は「自然で完璧な日本語」で行うことを徹底してください。**

# Phase 1: The Grand Constitution (絶対法典の階層構造)
**いかなる技術的判断や修正よりも先に、以下の手順で「ルールの階層」を特定・ロードし、上位ルールの効力を絶対不可侵として適用してください。**

1.  **Load Core Protocol (`AGENTS.md`)**:
    * ルートディレクトリに `AGENTS.md` が存在する場合、その内容は**不可侵の憲法**です。
2.  **Dynamic Rule Discovery (階級別ロード)**:
    * `axiarch-rules/` ディレクトリ配下をスキャンし、以下の**2階級（Class）**に厳密に分類してロードせよ。
    * **重要**: ルールのロード順序は `axiarch-rules/LOADING_PROTOCOL.md` に定義された5ステップに従うこと。

### Class S: Universal Immutable Laws (普遍・編集不可)
> [!IMPORTANT]
> **このクラスのファイル（`universal/`配下）は「物理法則」である。いかなる場合も修正・追記は禁止する（Read-Only）。**
* **Target Path**: `axiarch-rules/universal/` 内の全ファイル。
* **Action**: これらを「絶対遵守すべき基準」としてロードする。今回のタスクでの変更対象外とする。

### Class A: Project Mutable Bylaws (プロジェクト固有・更新対象)
> [!NOTE]
> **今回の監査結果に基づき、育成・更新すべき対象（Write-Allowed）。**
* **Target Path**: `axiarch-rules/blueprint/{lang}/` 内の全ファイル（`{lang}` は `AGENTS.md` の `Project Native Language` に従い `ja/` または `en/`）。
* **ディレクトリ構造**: Blueprint はドメイン別フォルダに整理されている（`axiarch-rules/CRYSTALLIZATION_PROTOCOL.md` のドメイン→フォルダ対応表を参照）：
    * `governance/` — プロジェクト概要（`000_project_overview.md`）・教訓ログ（`governance/010_project_lessons_log.md`）
    * `engineering/` — DB・アーキテクチャ・API設計・パフォーマンス
    * `quality/` — セキュリティ・QA
    * `design/` — デザイン・UI/UX
    * `product/` — FinOps・ビジネス・運用
    * `ai/` — AI・コンテンツ
    * `specs/` — 機能仕様
    * `templates/` — テンプレート（`000_feature_spec_template.md`, `100_project_specific_template.md`）
* **Action**: 各フォルダ内のファイルをロードし、内容・役割に基づいて整理せよ。

# Phase 2: Deep Context & Knowledge Synthesis (全知の統合と監査)
プロジェクトのファイルシステムを調査し、以下の手順で「プロジェクトの知」を収集・統合し、リスクと機会を洗い出してください。

1.  **Historical & Strategic Analysis (過去と未来の統合)**:
    * プロジェクトのソースコード、設定ファイル、既存のBlueprintを調査し、実装された機能と設計判断を把握する。
    * **Risk Audit**: 過去の実装において「セキュリティ（個人情報保護含む）」「法務」「コスト（FinOps）」、そして**「不自然な日本語やUI（Lazy English）」**がないかの観点でリスクが残っていないか再評価する。
    * **Opportunity Audit**: LTV向上やGEO（AI検索）対策、**日本市場特有の信頼性担保**など、ビジネス成長のためのルールが欠落していないか確認する。
2.  **Governance Audit (現状分析)**:
    * 現在の **Class A (Blueprint)** 内のファイル構成を確認し、情報の重複、欠落、矛盾、陳腐化がないか厳しくチェックする。
    * **Execution Standards Check**: 現在のガバナンスルールが、**上記20の観点（特に日本語最適化、AI最適化、GEO、LTV、FinOps）**を網羅できているか監査する。
3.  **Best Practice Gap (理想との乖離)**:
    * シリコンバレー基準のベストプラクティス（命名規則、ディレクトリ構成、エラー処理、Git運用など）に加え、**「プライバシー・バイ・デザイン」**や**「AIガバナンス」**や**「日本市場における最高品質（おもてなし品質）」**の観点が盛り込まれているか確認する。

---

# Phase 3: The "Ultimate Blueprint" Optimization (最適化要件)

解析結果に基づき、以下の3つの柱で **Class A (Blueprint)** ガバナンスアーキテクチャを徹底的にブラッシュアップしてください。

## 1. Comprehensive Rule Coverage (網羅性の確保)
**「書いていないから分からない」をゼロにする。以下の全領域が明確に定義されているか確認し、なければ追加する。**

* **Localization & Japanese Quality (最重要・新規強化)**:
    * **Zero English UI**: ユーザー（管理者含む）の目に触れる箇所の**完全日本語化規定**。英語のエラーメッセージやプレースホルダーの残存を「バグ」と定義する。
    * **Japan-Specifics**: 日本の商習慣（通貨円、日付yyyy/mm/dd、氏名順、住所フォーマット）への完全対応基準。
    * **Tone & Manner**: 「です・ます」と「体言止め」の使い分け、ユーザーに安心感を与えるマイクロコピーの品質基準。
* **Security & Privacy (最重要)**:
    * **Data Protection**: 個人情報（PII）の暗号化、ログへのマスキング、物理/論理削除の基準、アクセス権限管理（RBAC/Zero Trust）。
    * **Compliance**: GDPR/APPI対応、クッキー同意（CMP）運用、利用規約同意の記録フロー。
    * **Defensive Ops**: Turnstile実装基準、CORS/CSP設定、WAF運用基準。
* **Feature Specs & Business Logic**:
    * **AI**: プロンプト管理、**FinOps（トークンコスト制御/キャッシュ戦略）**、AI倫理規定（ハルシネーション対策）。
    * **CMS/Admin**: ノーコード運用基準、予約投稿、承認ワークフロー、監査ログ要件。
    * **AdTech/Monetization**: 広告タグ管理、**Ads.txt/Sellers.json管理**、CLS/INPパフォーマンス基準、収益化データ活用規定。
    * **SEO/GEO**: 構造化データ（JSON-LD）、AI検索向け最適化、セマンティックHTML基準。
* **Tech Stack & Architecture**: 使用技術、ディレクトリ構造、ステート管理、レンダリング戦略（SSR/ISR/CSR）。
* **Ops, Git & Quality**: コミットメッセージ規約、ブランチ運用、デプロイフロー、環境変数管理、テスト基準。
* **UX & LTV**: アクセシビリティ基準（WCAG）、ユーザーファーストなエラーハンドリング、**顧客満足度を高めるUI規定（LTV向上）**。

## 2. Structural Optimization (構造の最適化)
**ガバナンス・アーキテクチャを「読みやすく、拡張しやすく、保守しやすく、監査しやすい」形にリファクタリングする。**

* **Folder-Based Organization (フォルダベース格納・重要)**:
    * Blueprint はドメイン別フォルダ（`governance/`, `engineering/`, `quality/`, `design/`, `product/`, `ai/`, `specs/`, `templates/`）で構成される。
    * ドメイン→フォルダの対応は `axiarch-rules/CRYSTALLIZATION_PROTOCOL.md` のStep 1対応表に従うこと。
    * **Co-location原則**: 教訓はそれに関連するルールファイルと**同じフォルダ**に配置する。AIがあるドメインフォルダをロードするとき、ルールも過去の教訓もそこに存在する。
* **3-Digit Sparse Numbering (フォルダ内の採番ルール)**:
    * 各フォルダ内のファイル名プレフィックスは**3桁数値**を使用する。
    * 将来の挿入を見越して**間隔を大きく**取る。連番（001, 002, 003...）は禁止。
    * `000_` はルールファイル用に予約。教訓から昇華したファイルには使わない。
    * `governance/010_project_lessons_log.md` は固定。`governance/` 内の昇華ファイルは `020_` 以降。
    * 採番時は対象フォルダ内の既存ファイルを実際に確認し、次の空き番号を自律判断する。
* **Cross-Referencing**: ルール同士で矛盾がないよう整合性を取り、必要に応じて参照リンクを貼る。
* **Actionable**: 抽象論だけでなく、「開発者が具体的にどうコードを書くべきか」の指針を含める。

## 3. Future-Proofing (将来への備え)
**「今」だけでなく「未来」の拡張とリスクに耐えうるルールにする。**

* **Scalability**: データ量やアクセス増大時に備えたDB設計指針（パーティショニング等）やキャッシュ戦略が含まれているか。
* **Data Strategy**: 将来のAPI販売、データポータビリティ、外部連携を見据えたデータ構造やAPI設計の指針が含まれているか。
* **Cost Governance**: クラウド破産を防ぐための予算管理、リソース監視、不要リソースのクリーンアップルールが定義されているか。

---

# Phase 4: Execution Protocol (実行手順)

1.  **Analyze (分析)**:
    * 既存のルールファイルと、プロジェクトの実装をマッピングし、**Execution Standards**（特に**日本語品質**・セキュリティ・法務・財務・AI・GEO等）の観点で欠落しているルールを特定する。
2.  **Plan (構成案)**:
    * `axiarch-rules/blueprint/{lang}/` 内の理想的なフォルダ・ファイル構成を定義する。`axiarch-rules/CRYSTALLIZATION_PROTOCOL.md` のドメイン→フォルダ対応表に準拠すること。
    * **Localization** や **Security** や **FinOps**、**GEO/AI** などの重要項目が埋もれないよう配慮する。
3.  **Write & Refactor (執筆・修正)**:
    * **Preservation (保護・最重要)**:
        * 既存ルールの統合時、重要な制約（特にセキュリティ・法務・ビジネスロジック・日本語品質）を**絶対に消失させない**こと。
        * **「ファイル削除」は、その内容が新しいファイルに「100%移行」されたことが確認できた場合のみ許可される。** 情報量が減るような統合は禁止する。
    * **Prohibition**: **Class S (Universal)** ファイルへの変更・削除・移動は一切行わないこと。
    * **Domain Distribution (ドメイン分散配置・重要)**:
        * **教訓ログ（`governance/010_project_lessons_log.md`）は「一時的な蓄積場所」であり、最終目的地ではない。**
        * 得られた知見・教訓は、`axiarch-rules/CRYSTALLIZATION_PROTOCOL.md` のドメイン→フォルダ対応表に従い、**対応するドメインフォルダ内のBlueprintファイルに分散配置**せよ。
        * 教訓ログに同一ドメインの知見が3件以上蓄積された場合、対応フォルダに専用ファイルを作成し、教訓を昇華・移動すること。
        * 例（`axiarch-rules/CRYSTALLIZATION_PROTOCOL.md` Step 1対応表に準拠）:
            * セキュリティ関連の教訓 → `quality/{NNN}_security_policy.md` に昇華
            * AI関連の教訓 → `ai/{NNN}_ai_content_rules.md` に昇華
            * DB関連の教訓 → `engineering/{NNN}_database_auth.md` に昇華
        * **「教訓ログに書いたから終わり」は禁止。** 教訓は対応するドメインフォルダのルールファイルに統合し、ルールとして昇格させることで初めて結晶化が完了する。
        * 教訓ログにはドメインファイルへの参照リンクを残し、「未分類教訓 + 分離済みドメインファイルへのリンク一覧」として機能させる。
    * **新規作成**: 足りないルール（例: **日本語UIガイドライン**、AIコスト管理規定、プライバシー保護ガイドライン、GEO対策基準）を対応するドメインフォルダ内に新規ファイルとして作成する。
    * **修正・統合**: 既存の内容を見直し、より厳格かつ具体的に書き換える。重複内容は統合する。
    * **Protocol Compliance (プロトコル準拠)**:
        * 教訓の結晶化は `axiarch-rules/CRYSTALLIZATION_PROTOCOL.md` に定義された5ステップ（分類→既存ファイル検索→未分類蓄積→閾値自動分離→インデックス維持）に厳密に従うこと。
        * ルールのロード順序は `axiarch-rules/LOADING_PROTOCOL.md` の5ステップに準拠すること。
4.  **Final Verify (最終確認)**:
    * 全てのルールが「シリコンバレー基準」かつ**「日本市場基準」**の品質であり、プロジェクトの憲法として機能するかを確認する。
    * **Safety Check**: セキュリティとプライバシーに関する記述が十分に手厚いか再確認する。
    * **Distribution Check**: 教訓が教訓ログに滞留せず、適切なドメインファイルに昇格・移植されているか確認する。

# Phase 5: Knowledge Feedback (完了報告)
**作業完了後、以下の情報を出力してください。**

* **Blueprint Structure**: 最適化後のファイル構成一覧とその概要（採番ルール含む）。
* **Key Updates**: 今回新たに追加・強化した主要なルール（特に**日本語品質**、セキュリティ、プライバシー、AI、FinOps、GEO、LTVの観点）。
* **Next Action**: 開発者がこのガバナンス・アーキテクチャをどう活用し、運用していくべきかの指針。

**これより、プロジェクトの全知を結集し、既存の資産（ルール）を劣化させることなく、固有ルール全体（`axiarch-rules/blueprint/{lang}/` 内の全ドメインフォルダ）の徹底的な最適化と再構築を開始してください。**
````
