# 30. エンジニアリングの卓越性 (Engineering Excellence - General)

### 1.0. 至高の指令 (The Supreme Directive)
*   **The Consolidated Naming Convention**:
    *   **Files & Directories**: 全てのファイル名とディレクトリ名は `kebab-case` (例: `user-profile-card.tsx`) で統一します。PascalCaseやsnake_caseはOS間のGit互換性問題（Case Sensitivity）を引き起こすため厳禁です。
    *   **Components**: ファイル名は `kebab-case` ですが、コンポーネント名は `PascalCase`、関数名は `camelCase` とします。
    *   **The Barrel File Ban**: `index.ts` による再エクスポート（Barrel File）は、循環参照とTree Shaking阻害の主因となるため、原則禁止とします。
- **UI/Logic Consistency (完全統一)**:
  - **原則**: 「似ているが違う」はプロ意識の欠如であり、バグです。すべての機能（削除、編集、一覧）において、UIとロジックは統合されていなければなりません。
  - **Tiered Security**: セキュリティはリスクに応じて段階化します。
    - **Tier 1**: 一般的な単体操作は「確認のみ」とします。
    - **Tier 2**: 一括操作、および**ユーザー削除などの最重要単体操作**は「高セキュリティ認証（OTP/Passkey/2FA等）必須」とします。これを独自の判断で崩すことは許されません。
*   **The Hierarchical Data Principle (1:N Core)**:
    *   **Law**: 複雑なドメイン（ライフタイムデータ、契約、高秘匿記録等）を設計する際は、必ずルートとなる親テーブル（例: `users`, `accounts`, `master_records`）を定義し、関連データは $1:N$ の階層構造でぶら下げる「疎結合な親子関係」を貫いてください。単一の巨大なテーブルへの押し込み（God Table）は、マイグレーションとRLS設計の破綻を招く敗北行為です。
*   **The Tiered Service Mandate (Subscription Gating)**:
    *   **Law**: サービスレベル（Free/Paid）による制限（登録数、AI利用回数等）は、必ず **サーバーサイド (Server Guards)** で強制してください。フロントエンドの表示制御のみに頼ることは、APIリクエストによる回避を許すため禁止します。
    *   **Upsell Trigger**: 制限超過時には、単なる「エラー」ではなく、上位プランへの動線を伴う明確なメッセージを返却してください。
*   **The Interoperable Ecosystem Mandate**:
    *   **Law**: アプリ内に保持される重要なドメインデータ（実績、資格、記録等）を、システムの外でも通用する「標準化された資産」として扱ってください。独自仕様に閉じ込めることは、将来のサービス連携とユーザーへの価値提供を阻害する敗北行為です。
    *   **Portable Design**: 可能な限り業界標準のスキーマ、定数、国際規格に準拠し、データそれ自体が「信頼性の高い証明書」として他システムへのポータビリティ（携行性）を持つように設計してください。
*   **Structure First Protocol**:
    *   **Law**: 重要なビジネスデータ（資格、契約、健康状態、資産等）は、テキスト（非構造化データ）ではなく、可能な限りマスターデータ（M:N）やタグ形式で構造化して管理してください。
    *   **Future-Proof Data Strategy (LTV & FinOps)**: 
        *   **Context**: 特定のデータ（例: 医療費、故障率、ライフタイムイベント）は、現時点で不要であっても、将来の保険提案や高度なパーソナライズ、ビジネスモデルの転換において「黄金のデータ」となります。
        *   **Law**: データモデリング時は、将来的な FinOps や LTV 最大化に寄与する可能性のあるメタデータ（コスト、発生日時、種別、事象）を、構造化された形で保持できるように設計してください。「後で追加する」コストを最小化し、データの連続性を担保します。
    *   **Autonomous Structure Strategy (Edge AI)**: 
        *   **Law**: ユーザーに入力（Typing）という苦役を強いることは可能な限り避け、紙の証明書、領収書、書類等の「非構造化物理アセット」は、OCR/Vision AI を活用して即座に「高精度な構造化データ」へ自動変換するフローを標準実装として検討してください。
        *   **Standard**: 「写真を撮るだけで、重要な全項目が DB に入る」UX を、データ品質維持とユーザー継続率向上のための至上命題とします。
        *   **Human-in-the-Loop Mandate**: AI（OCR/Vision等）によるデータ抽出・変換結果は、常に **「下書き（Draft）」** として扱い、**ユーザーが目視で確認・修正した上で「保存」ボタンを押す**フローを強制してください。AIによるDBへの直接書き込み（Auto-Save）は、誤データの混入リスクがあるため禁止します。
        *   **PII Scrubbing**: AI処理対象の文書や画像に個人情報（氏名、住所、電話番号等）が含まれる場合、OCR/AI結果としてそのまま保存せず、自動的に破棄またはマスキング（`***`等で置換）してください。特に第三者の個人情報は、本人の同意なく構造化データとして保持してはなりません。
*   **Blueprint Compliance (憲法遵守)**:
    *   **Entry Point**: すべての開発作業は、まず対応するルールファイルを確認することから始めます。
    *   **Update First**: 実装中に設計変更が必要になった場合、**コードを書く前に（または同時に）Blueprintを更新**します。ドキュメントとコードの乖離は最大の技術的負債です。
    *   **Code as Documentation**: Blueprintファイルはコードの一部です。実装を変更したら、必ず対応するルールファイルも更新し、乖離（Drift）を防いでください。
*   **警告ゼロ (Zero Warnings)**:
    *   **ルール**: 警告（Warning）はエラー（Error）として扱います。CIは警告が1つでもあれば失敗させます。「壊れた窓割れ理論」を防ぎます。
    *   **厳格なエラーハンドリング**: 空の `catch` ブロックは禁止です。全てのエラーはログに記録され、適切に処理されなければなりません。
    *   **Zero Tolerance for Band-Aid Solutions**:
        *   **Prohibition**: `// @ts-ignore`, `any` キャスト、`legacy-peer-deps` は「思考停止」であり、エンジニアとしての敗北です。
        *   **Mandate**: 一時的な回避が必要な場合は、必ず `// TODO(#IssueID): reason` とチケット番号を添えて理由を記述してください。無言の `ignore` は即時Reject対象です。
    *   **The Incident Response Protocol (SRE)**: 
        1. **Plan & Drill**: セキュリティインシデント（情報漏洩、不正アクセス）発生時の連絡網と初動対応（サービス停止基準、ログ保全）を定義し、半年に1回訓練を行ってください。
        2. **Post-Mortem & Blueprint Sync**: 障害・インシデント対応後は必ず根本原因を特定して言語化し、その教訓を即座に **Blueprint (設計書)** へ反映させるまでを一つの不可分なプロセスとします。
    *   **The Anti-Blindness Protocol (AI Hygiene)**:
        *   **Law**: AIが生成したコードに含まれる `// ...` や `// implementation details` といった省略記法を、そのままファイルに保存することを物理的に禁止します。
        *   **Action**: 必ず**完全なコード**を展開させてください。省略されたコードは「バグ」ではなく「虚無」であり、システムをクラッシュさせます。
    *   **The System Transparency Protocol (Stack Card)**:
        *   **Law**: 使用している技術スタック（Framework, DB, UI Lib）のバージョン情報を、`PROMPT.md` または `tech_stack.md` に常に最新状態で維持してください。
        *   **Reason**: AIエージェントは「現在」の環境を知る由もありません。正確なバージョン情報こそが、正確なコード生成の命綱です。
*   **リファクタリング (Refactoring - The Boy Scout Rule)**:
    *   **義務 (Mandate)**: 「来た時よりも美しくして立ち去る（ボーイスカウトの精神）」。ファイルを触る際は、必ず小さな改善（命名変更、関数抽出）を行います。
    *   **「後で」はない (No "Later")**: 「後でリファクタリングする」は嘘です。今やるか、永遠にやらないかです。
    *   **複雑度の排除 (Cyclomatic Complexity)**: 複雑度（ネストの深さ）が高いコードは、バグの温床です。早期リターン（Early Return）を活用し、ネストを浅く保ちます。
*   **クリーンアップ (Cleanup)**:
    *   **デッドコードの即時削除**: コメントアウトされたコード、使われていないインポート、デバッグ用の `console.log` は、コミット前に完全に削除します。
    *   **TODOコメントの管理**: `// TODO:` を残す場合は、必ずチケット番号または期限を併記します。放置されたTODOは技術的負債です。

### 1.1. Supreme Directive: Omnichannel & Headless First Protocol
*   **Web is just ONE Client**:
    *   **Definition**: システム全体を設計する際、「Webサイト（Next.js）」は多数あるクライアントの**ほんの一つ**に過ぎないと定義します。
    *   **Vision**: 将来的なネイティブアプリ（iOS/Android）、外部メディア連携、IoT配信、AIエージェントとの対話を前提とします。
*   **API Mandate**:
    *   **Law**: **全ての機能とデータ** は、再利用可能な API (Headless Architecture) を介して提供されなければなりません。
*   **Prohibition (The Web-Only Ban)**:
    *   **Felony**: Reactコンポーネント内へのビジネスロジックの閉塞や、HTML構造に依存したデータ設計（Web Only設計）は、**「再最重要項目の違反」として厳禁** とします。これを行った場合、即時のReject対象となります。
