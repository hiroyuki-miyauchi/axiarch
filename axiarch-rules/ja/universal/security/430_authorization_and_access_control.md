# 67. 認可・アクセス制御深掘り (Authorization & Access Control Deep Dive)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-06-09

> [!IMPORTANT]
> **Level 1 Priority: Absolute Compliance（最上位の優先事項）**
> 認可層は「誰が何にアクセスできるか」を決定する最終防衛線である。認証（authN）を突破された後でも、認可（authZ）が正しく機能すればデータ漏洩・権限昇格を阻止できる。
> 本ファイルの MUST 要件はリスク低減と最低品質の底上げを目的とし、ユーザー利便性・開発速度・コストよりも優先する。

> [!CAUTION]
> **Primary Directive（主要方針）**
> 本ファイルは `security/000_security_privacy.md` §4.5（RBAC/ABAC 設計）・§4.6（RBAC Defense Protocol）の **深掘り・詳細化版**である。
> 000 は要約レベルのポリシー、本ファイル（67）は実装可能な粒度の認可層詳細（RBAC/ABAC/ReBAC モデル選定、Policy as Code、認可の外部化、API 認可）を担う。重複ではなく拡充の位置づけ。
> 認証（クレデンシャル）は隣接ファイル（400）、フェデレーション/OAuth は（410）、Step-Up 認証は（420）、委任認可（OAuth スコープ委任・トークン交換の詳細）は（440）へ委譲する。本ファイルは **認可の判定と強制（authZ）**に集中する。

---

## 目次

- §1. 主要方針・責務範囲
- §2. authN と authZ の責任分界
  - §2.1. 誰か（authN）vs 何ができるか（authZ）
  - §2.2. PDP / PEP / PIP / PAP アーキテクチャ
  - §2.3. Deny-by-Default 原則
  - §2.4. 最小権限と職務分離（SoD）
- §3. 認可モデルの選定と段階的昇格
  - §3.1. RBAC（Role-Based）
  - §3.2. ABAC（Attribute-Based）
  - §3.3. ReBAC（Relationship-Based）
  - §3.4. PBAC（Policy-Based）
  - §3.5. 選定基準と段階的昇格パス
- §4. ReBAC / Google Zanzibar パターン
  - §4.1. Relation Tuples
  - §4.2. 推移的・階層的アクセス
  - §4.3. OpenFGA（CNCF Incubating）
  - §4.4. SpiceDB（Tunable Consistency / 新鮮性）
- §5. Policy as Code
  - §5.1. AWS Cedar + Amazon Verified Permissions
  - §5.2. OPA / Rego（K8s / インフラ）
  - §5.3. Cedar vs OPA 使い分け
- §6. 認可の外部化
  - §6.1. アプリ内 if 散在の禁止
  - §6.2. 集中ポリシーストアと集中ガード
  - §6.3. Decision Log（監査可能性）
  - §6.4. Consistency / 新鮮性要件
- §7. OAuth 連携と API 認可
  - §7.1. スコープ設計
  - §7.2. RAR（RFC 9396 authorization_details）
  - §7.3. PAR（RFC 9126）
  - §7.4. API 認可：BOLA / BFLA 防止
- §8. マルチテナント認可
  - §8.1. テナント分離と権限境界
  - §8.2. 行レベルセキュリティ（RLS）連携
- §9. 多角観点（可観測性 / FinOps / 性能 / スケーラビリティ / Zero Trust / プライバシー）
- §10. 実装スニペット
- §11. アンチパターン集
- §12. 成熟度モデル L1–L5
- Appendix A: 逆引き索引

---

## §1. 主要方針・責務範囲 (Primary Directive & Scope)

### 1.1. 責務範囲

-   **本ファイル（67）の責務**: 認可（authZ）層の実装詳細。認可モデル（RBAC/ABAC/ReBAC/PBAC）の選定、Policy as Code、認可判定の外部化、API 認可、マルチテナント認可。
-   **本ファイルが扱わないもの（委譲先）**:

| トピック | 委譲先 |
|:--------|:-------|
| 認可の要約ポリシー（SSOT・Guardian Protocol の原型） | `security/000_security_privacy.md` §4.5, §4.6 |
| 認証（クレデンシャル・パスキー・MFA・パスワード） | `security/400_authentication_and_passkeys.md` |
| フェデレーション、OAuth/OIDC のトークン取得フロー | `security/410_federated_identity_and_oauth.md` |
| Step-Up 認証、機微操作の再認証 | `security/420_step_up_auth_and_sensitive_operations.md` |
| 委任認可（トークン交換・on-behalf-of・委任スコープの詳細） | `security/440_workload_and_agent_identity.md` |
| RLS 実装の具体（PostgreSQL ポリシー文法） | `engineering/200_supabase_architecture.md` |

### 1.2. 基本原則

-   **Rule 67.1.1（authN/authZ 分離）**: 認証（誰か）と認可（何ができるか）は**別レイヤーとして設計・実装**する（MUST）。認証成功を認可の代替にしてはならない。ログイン済みであることは「リソース X を操作できる」ことを意味しない。
-   **Rule 67.1.2（Deny-by-Default）**: 認可判定は**明示的に許可された場合のみ許可**し、それ以外は拒否する（MUST）。未定義・不明・エラー時は拒否側に倒す（fail-closed）。
-   **Rule 67.1.3（認可の外部化）**: 認可判定ロジックをアプリケーションコード全体に散在させてはならない（MUST NOT）。集中したポリシー定義（Policy as Code）または集中ガード（PDP）に集約する（§6 参照）。
-   **Rule 67.1.4（最小権限）**: 主体（ユーザー・サービス）には職務遂行に必要な最小限の権限のみを付与する（MUST）。広い権限を既定で配り後から絞る運用を避ける。
-   **Rule 67.1.5（誇張禁止）**: 「完璧」「絶対安全」を標榜しない。本ファイルの目的は**攻撃コストの引き上げとリスクの体系的低減**であり、各要件は最低品質の底上げとして読む。ただし MUST と明記した要件は必須である。

---

## §2. authN と authZ の責任分界

### 2.1. 誰か（authN）vs 何ができるか（authZ）

| 観点 | 認証 (Authentication / authN) | 認可 (Authorization / authZ) |
|:-----|:------------------------------|:------------------------------|
| **問い** | あなたは誰か？ | あなたは何をしてよいか？ |
| **出力** | 検証済みアイデンティティ（subject / principal） | 許可 / 拒否の判定（decision） |
| **入力** | クレデンシャル（パスキー・パスワード・MFA） | subject・action・resource・context |
| **担当ファイル** | `400`（クレデンシャル）/ `410`（フェデレーション） | **本ファイル（67）** |

-   **Rule 67.2.1**: 認可判定は**認証済みアイデンティティを前提入力**とするが、認証の成否だけで認可を決定してはならない。認証層から渡されるシグナル（認証要素の強度・フィッシング耐性・デバイス種別）を認可の context として活用する（400 §10.4 と連携）。

### 2.2. PDP / PEP / PIP / PAP アーキテクチャ

> XACML 由来の標準的な認可コンポーネント分離。実装スタックに依存せず適用する。

| コンポーネント | 役割 |
|:--------------|:-----|
| **PDP (Policy Decision Point)** | ポリシーに基づき許可/拒否を**判定**する。認可エンジンの中核 |
| **PEP (Policy Enforcement Point)** | リクエスト経路上で PDP に問い合わせ、判定を**強制**する（API ゲートウェイ・ミドルウェア・ガード関数） |
| **PIP (Policy Information Point)** | 判定に必要な属性（ユーザー属性・リソース属性・環境）を**供給**する |
| **PAP (Policy Administration Point)** | ポリシーを**管理・編集**する |

-   **Rule 67.2.2（PEP の網羅性）**: 保護対象リソースへの**全アクセス経路に PEP を配置**する（MUST）。一部の経路（管理 API・バッチ・内部サービス間呼び出し）に PEP が無いと、そこが回避経路になる。
-   **Rule 67.2.3（PDP の単一責任）**: 判定（PDP）と強制（PEP）を分離し、判定ロジックを PEP に埋め込まない。PDP を差し替え可能（埋め込み / サイドカー / リモートサービス）に保つ。

### 2.3. Deny-by-Default 原則

-   **Rule 67.2.4**: ポリシー評価の既定値は**拒否**とする（MUST）。許可ルールに一致しない全リクエストは拒否される。Cedar・OPA・OpenFGA はいずれも deny-by-default を基本動作とする。
-   **Rule 67.2.5（明示的 forbid の優先）**: 許可（permit）と禁止（forbid）が競合する場合、**禁止を優先**する（deny-overrides）。Cedar はこのセマンティクスを言語仕様で保証する。
-   **Anti-Pattern**: 「リストにあるものを拒否、それ以外を許可」（allow-by-default / ブラックリスト方式）。漏れが即座に過剰権限になる。

### 2.4. 最小権限と職務分離（SoD）

-   **Rule 67.2.6（最小権限）**: ロール・ポリシーは必要最小限のアクションに限定する。ワイルドカード（`*`）権限は高リスク用途に限り、付与時に正当化と期限を記録する。
-   **Rule 67.2.7（職務分離 / Separation of Duties）**: 単一の主体が**相互チェックを要する操作を単独で完結できない**よう設計する（例: 申請者と承認者を分離、支払い作成者と承認者を分離）。SoD 制約はポリシーで宣言的に表現する。
-   **Rule 67.2.8（特権の昇格は一時的に）**: 恒常的な高権限付与を避け、必要時のみ昇格（Just-In-Time）し期限後に自動失効させる。特権操作は Step-Up 認証（420）と組み合わせる。

---

## §3. 認可モデルの選定と段階的昇格

### 3.1. RBAC（Role-Based Access Control）

-   **概要**: 主体に**ロール**を割り当て、ロールに**権限**を紐づける。`user → role → permission` の間接化により権限管理を簡素化する。
-   **適性**: ロール数が少なく、権限がリソース個別ではなく**種別単位**で表現できる組織。最も理解・監査しやすい。
-   **限界**: 「自分が作成したドキュメントのみ編集可」「同一テナント内のみ閲覧可」のような**インスタンス単位・関係性ベース**の制御で role 爆発（role explosion）を起こす。

### 3.2. ABAC（Attribute-Based Access Control）

-   **概要**: subject・resource・action・environment の**属性**を評価して判定する（例: `subject.department == resource.owner_department && env.time in business_hours`）。
-   **適性**: 細粒度・文脈依存（時刻・場所・デバイス・データ機密度）の制御。RBAC では表現しきれない条件を属性式で表す。
-   **限界**: 「誰がこのリソースにアクセスできるか」を逆引き（reverse index / enumeration）するのが困難。ポリシーが複雑化しやすく、監査・テストの負荷が高い。

### 3.3. ReBAC（Relationship-Based Access Control）

-   **概要**: 主体とリソースの**関係（relation）**をグラフとして表現し、関係の有無・推移で判定する（例: `user is editor of doc`、`doc is in folder that user is viewer of`）。Google Zanzibar が代表設計（§4）。
-   **適性**: ドキュメント共有・組織階層・ネスト化されたリソース・グループメンバーシップ。「フォルダの編集者は配下ファイルも編集可」のような**推移的・階層的アクセス**を自然に表現する。
-   **限界**: 関係データ（tuple）の整合性・新鮮性管理が必要。専用の認可データストア（OpenFGA / SpiceDB）を要する。

### 3.4. PBAC（Policy-Based Access Control）

-   **概要**: 認可ルールを**宣言的ポリシー言語**（Cedar / Rego 等）で外部化し、Policy as Code として管理する包括的アプローチ。RBAC・ABAC・ReBAC の要素をポリシー内で組み合わせられる。
-   **適性**: 複数モデルの混在、形式検証・テスト・バージョン管理を要する組織。§5 の Policy as Code と直結する。

### 3.5. 選定基準と段階的昇格パス

-   **Rule 67.3.1（最小十分なモデルから開始）**: 要件を満たす**最も単純なモデル**から開始する（MUST）。過剰に複雑なモデルを先行採用しない。RBAC で足りるなら RBAC、文脈条件が必要なら ABAC、関係グラフが本質なら ReBAC。

| 判断基準 | 推奨モデル |
|:--------|:----------|
| 権限が「種別 × ロール」で表現でき、インスタンス単位の例外が少ない | **RBAC** |
| 時刻・場所・データ機密度・所属など文脈/属性で判定が必要 | **ABAC**（RBAC に属性を追加） |
| 「共有」「階層」「メンバーシップ」「推移的アクセス」が中核 | **ReBAC**（Zanzibar 系） |
| 複数モデル混在・形式検証・監査可能性を重視 | **PBAC**（Cedar / Rego で統合） |

-   **Rule 67.3.2（段階的昇格）**: モデルの昇格（RBAC → ABAC → ReBAC）は**集中ポリシー層を介して段階的**に行う（§6）。アプリ内に判定が散在していると昇格時に全コードパスを書き換える必要が生じ、移行リスクが跳ね上がる。
-   **Rule 67.3.3（混合の許容）**: 単一モデルへの原理主義を避ける。粗粒度の RBAC（ロール）と細粒度の ReBAC（リソース共有）を**併用**してよい。重要なのは判定が集中層に集約されていること。

---

## §4. ReBAC / Google Zanzibar パターン

> **参考**: Google Zanzibar 論文（2019）, OpenFGA（CNCF Incubating）, SpiceDB（authzed）

### 4.1. Relation Tuples

-   **Relation Tuple**: ReBAC の最小単位。`⟨object⟩#⟨relation⟩@⟨subject⟩` の形で「object は subject にとって relation の関係にある」を表す（例: `document:roadmap#editor@user:anne`）。
-   **Rule 67.4.1**: 認可モデル（型定義・関係定義）とデータ（tuple）を分離して管理する。型定義はバージョン管理し、tuple は書き込み API 経由でのみ更新する。アプリが直接認可 DB のテーブルを書き換える運用を避ける。

### 4.2. 推移的・階層的アクセス

-   **概要**: ReBAC は関係の**合成・継承**を表現する。「`folder:x#viewer` を持つ user は、`document:y#parent@folder:x` の document:y も viewer として閲覧可」のように、関係を推移的に評価する。
-   **Rule 67.4.2（推移評価の境界）**: 推移的・階層的評価は深さ・幅が増えるほどレイテンシとコストが増す。評価深さの上限とタイムアウトを設定し、無制限のグラフ探索を避ける（§9 性能と連携）。

### 4.3. OpenFGA（CNCF Incubating）

-   **概要**: Zanzibar に基づくオープンソース認可システム。**CNCF Incubating** プロジェクト。DSL（authorization model）で型と関係を定義し、`check` / `list-objects` / `list-users` API で判定する。
-   **Rule 67.4.3**: OpenFGA を採用する場合、認可モデル（`.fga` / JSON）を**コードとしてバージョン管理**し、CI でモデルのテスト（期待される check 結果）を実行する。モデル変更は段階的にロールアウトする。

### 4.4. SpiceDB（Tunable Consistency / 新鮮性）

-   **概要**: Zanzibar に基づく認可システム（authzed）。Zanzibar の **Zookie**（一貫性トークン）相当の **ZedToken** により、判定の**新鮮性（consistency）を呼び出し単位で調整**できる。
-   **一貫性レベル**: `minimize_latency`（最速・やや古いデータ許容）/ `at_least_as_fresh`（指定 ZedToken 以降の鮮度を保証）/ `fully_consistent`（最新保証・最も高コスト）。
-   **Rule 67.4.4（New Enemy Problem 防止）**: 権限剥奪の直後に古いキャッシュで許可が通る「New Enemy Problem」を避けるため、**機微操作では新鮮性を強める**（`at_least_as_fresh` 以上）。一般の閲覧では `minimize_latency` を許容しレイテンシを優先する（§6.4・§9 と連携）。

---

## §5. Policy as Code

> **Law**: 認可ポリシーは**コードとして外部化・バージョン管理・テスト**する（PBAC）。アプリのデプロイから独立してポリシーを変更・監査できる状態を目標とする。

### 5.1. AWS Cedar + Amazon Verified Permissions

-   **Cedar**: AWS が開発したオープンソースの認可ポリシー言語。**deny-by-default**・**deny-overrides**（forbid 優先）をセマンティクスで保証し、**形式検証（formal verification）**に対応する設計。RBAC・ABAC を同一言語で表現できる。
-   **Amazon Verified Permissions (AVP)**: Cedar を実行するマネージド PDP サービス。ポリシーストア・評価 API（`isAuthorized`）を提供する。
-   **Rule 67.5.1**: Cedar を採用する場合、`permit` / `forbid` を明示的に書き、principal・action・resource の三項と条件（`when` / `unless`）で表現する。**forbid を許可の例外的上書き**として活用する（deny-overrides）。
-   形式検証ツール（Cedar の policy analysis）でポリシー間の矛盾・到達不能ルール・過剰許可を静的に検査できる。

### 5.2. OPA / Rego（K8s / インフラ）

-   **OPA (Open Policy Agent)**: **CNCF Graduated** の汎用ポリシーエンジン。**Rego** 言語でポリシーを記述し、JSON 入力に対し判定を返す。Kubernetes（Admission Control / Gatekeeper）・Terraform・API ゲートウェイ・マイクロサービス間認可など**インフラ/プラットフォーム層**で広く使われる。
-   **Rule 67.5.2**: OPA を採用する場合、Rego ポリシーを**ユニットテスト**（`opa test`）し、入力（input）の契約（スキーマ）を固定する。ポリシーバンドルの配布・署名・バージョンを管理する。

### 5.3. Cedar vs OPA 使い分け

| 軸 | Cedar (+ AVP) | OPA / Rego |
|:---|:--------------|:-----------|
| **主用途** | アプリケーション認可（ユーザー → リソース） | インフラ/プラットフォーム認可（K8s・IaC・ゲートウェイ） |
| **モデル親和性** | RBAC / ABAC を簡潔に表現 | 汎用（あらゆる JSON 判定）。表現自由度が高い |
| **形式検証** | あり（言語設計レベル） | 限定的（テスト中心） |
| **deny セマンティクス** | deny-overrides を保証 | 記述者が定義（既定なし、明示が必要） |
| **マネージド** | Amazon Verified Permissions | 自己ホスト中心（各種マネージド派生あり） |

-   **Rule 67.5.3（使い分け）**: **アプリ内のユーザー↔リソース認可は Cedar/AVP または ReBAC（OpenFGA/SpiceDB）**、**K8s/IaC/ゲートウェイ等のインフラ認可は OPA/Rego** を第一候補とする。両者は排他ではなく、層ごとに適材適所で併用してよい。

---

## §6. 認可の外部化

### 6.1. アプリ内 if 散在の禁止

-   **Rule 67.6.1（散在禁止）**: 認可判定をビジネスロジック内の `if (user.role === 'admin')` のような**インライン分岐として散在**させてはならない（MUST NOT、000 §4.5 Guardian Protocol の詳細化）。判定は集中ガードまたは外部 PDP に委ねる。
-   散在は (a) 漏れ（ある経路だけチェック忘れ）、(b) 不整合（同一判定が経路ごとに異なる）、(c) モデル昇格の困難（全コードパス改修）を招く。

### 6.2. 集中ポリシーストアと集中ガード

-   **Rule 67.6.2（集中化）**: 認可判定は**集中ポリシーストア（PDP）**に集約し、各経路は薄い PEP（ガード関数 / ミドルウェア）から PDP を呼ぶ（MUST）。
-   **Rule 67.6.3（ロール SSOT）**: ロール・権限の正本（Single Source of Truth）を一箇所に定める。フロントエンドのフラグや遺物テーブルを認可の根拠にしてはならない（000 §4.5 と整合）。フロントの権限表示は UX 上の利便であり、サーバー側 PEP の判定が常に最終権威である。

### 6.3. Decision Log（監査可能性）

-   **Rule 67.6.4（判定ログ）**: すべての認可判定を**構造化された decision log** として記録可能にする（MUST）。少なくとも「主体・アクション・リソース・判定結果・適用ポリシー・コンテキスト・時刻」を残す。PII はマスキングする（000 §7.4 と整合）。
-   decision log は (a) インシデント時の影響範囲特定、(b) 過剰権限の発見、(c) コンプライアンス監査に用いる。拒否（deny）の記録は攻撃検知シグナルとして ITDR（000 §3.3）へ連携する。

### 6.4. Consistency / 新鮮性要件

-   **Rule 67.6.5（権限変更の伝播）**: 権限剥奪・ロール変更は**速やかに PDP/キャッシュへ伝播**させる。キャッシュ TTL とのトレードオフを明示し、機微操作では新鮮性を強める（§4.4・§9）。
-   **Rule 67.6.6（fail-closed）**: PDP/ポリシーストアへの問い合わせが失敗・タイムアウトした場合、**拒否側に倒す**（fail-closed）（MUST）。可用性のために許可へフォールバックしてはならない（高可用が必須の限定経路では、キャッシュ済み直近判定の短時間利用を明示ポリシーで許容する場合に限る）。

---

## §7. OAuth 連携と API 認可

> **参考規格**: RFC 9396 (RAR), RFC 9126 (PAR), OWASP API Security Top 10。OAuth トークン取得フローの詳細は 410、委任の詳細は 440 へ委譲。

### 7.1. スコープ設計

-   **Rule 67.7.1（粗粒度スコープ + 細粒度認可）**: OAuth スコープは**粗粒度のアクセス区分**（例: `documents.read` / `documents.write`）に留め、**インスタンス単位の細粒度判定はリソースサーバー側の authZ（本ファイルのモデル）**で行う（MUST）。スコープだけで「この特定リソースにアクセス可」を表現しようとしない。
-   スコープは最小権限で要求し、過剰スコープの同意要求を避ける。スコープと内部権限のマッピングを集中管理する。

### 7.2. RAR（RFC 9396 authorization_details）

-   **概要**: **Rich Authorization Requests (RAR)** は、粗粒度スコープでは表現できない**細粒度の認可要求**を `authorization_details`（JSON 構造）で表現する仕組み。例: 「口座 A から 100 ドルを送金する権限」のように type・対象・上限を構造化する。
-   **Rule 67.7.2**: 金融取引・特定リソース限定の権限など、スコープでは粒度が不足する認可は RAR（`authorization_details`）で表現する。リソースサーバーは `authorization_details` を検証し、要求された具体的操作のみを許可する。

### 7.3. PAR（RFC 9126）

-   **概要**: **Pushed Authorization Requests (PAR)** は、認可リクエストのパラメータを**事前にバックチャネルで認可サーバーへ送信**し、フロントチャネルでは `request_uri` 参照のみを渡す仕組み。リクエスト改ざん・パラメータ漏洩・URL 長制限を緩和する。RAR と組み合わせると `authorization_details` を安全に送れる。
-   **Rule 67.7.3**: 高保証 API・金融グレード（FAPI 系）の認可では PAR を採用し、認可リクエストの完全性を担保する。詳細なフロー実装は 410 / 440 を参照する。

### 7.4. API 認可：BOLA / BFLA 防止

> OWASP API Security Top 10 の API1（BOLA）・API5（BFLA）は認可欠陥に起因する最頻出脆弱性である。

-   **BOLA (Broken Object Level Authorization)**: あるオブジェクト ID（例: `/orders/123`）に対し、**そのオブジェクトへのアクセス権**を検証せずに ID だけで返してしまう欠陥。IDOR の上位概念。
-   **Rule 67.7.4（オブジェクトレベル認可の強制）**: すべてのオブジェクト参照エンドポイントで、**リクエスト主体が当該オブジェクトにアクセスできるか**をオブジェクト単位で検証する（MUST）。ID が推測可能/連番であることに依存しない。ReBAC の `check(user, view, object)` 相当を全取得経路に適用する。
-   **BFLA (Broken Function Level Authorization)**: 関数/エンドポイント単位の権限検証漏れ（例: 一般ユーザーが管理者用 `DELETE /admin/users/123` を叩ける）。
-   **Rule 67.7.5（関数レベル認可の強制）**: 管理機能・特権機能のエンドポイントは、UI で隠すだけでなく**サーバー側 PEP で関数レベル認可を強制**する（MUST）。「URL を知らなければ安全」（security by obscurity）に依存しない。
-   **Rule 67.7.6（マスアサインメント防止）**: 認可に関わる属性（`role` / `is_admin` / `tenant_id`）を**クライアント入力で上書きさせない**（MUST NOT）。入力許可フィールドを明示的に allowlist する。
-   **Cross-Reference**: `engineering/100_api_integration.md`（API 設計・契約）

---

## §8. マルチテナント認可

### 8.1. テナント分離と権限境界

-   **Rule 67.8.1（テナント境界の必須化）**: マルチテナントでは**全認可判定に `tenant_id` を不可分の前提**として含める（MUST）。「リソースにアクセス可」かつ「同一テナントに属する」の双方を検証する。テナント横断アクセスは既定で拒否する。
-   **Rule 67.8.2（テナント ID の信頼源）**: `tenant_id` は**サーバー側で認証済みコンテキストから導出**する（MUST）。クライアントが送る `tenant_id` をそのまま信頼してはならない（クロステナント攻撃の典型）。
-   **Rule 67.8.3（権限境界の階層）**: 「システム管理者 → テナント管理者 → テナント内ロール」の階層を明確にし、テナント管理者がシステム全体やほかテナントへ昇格できない境界を保証する。

### 8.2. 行レベルセキュリティ（RLS）連携

-   **Rule 67.8.4（多層防御としての RLS）**: アプリ層の PEP に加え、**データベースの行レベルセキュリティ（RLS）を最終防衛線**として併用する（SHOULD）。アプリ層の認可漏れがあっても DB がテナント/所有者境界を強制する。
-   **Rule 67.8.5（RLS と PDP の整合）**: RLS ポリシーとアプリ層 PDP の判定が**矛盾しない**よう、テナント/所有者の判定基準を共通の SSOT から導出する。RLS は粗粒度の境界（テナント・所有者）、PDP は細粒度（共有・関係）と役割分担してよい。
-   **Cross-Reference**: `engineering/200_supabase_architecture.md`（PostgreSQL RLS ポリシーの実装詳細）

---

## §9. 多角観点

### 9.1. 可観測性 (Observability)

-   **Rule 67.9.1**: 認可判定をメトリクス化する（許可率/拒否率、判定レイテンシ p50/p99、ポリシー別ヒット数、deny の理由分布）。拒否の急増・特定主体からの大量 deny を異常検知し ITDR（000 §3.3）へ連携する。decision log（§6.3）と合わせ、過剰権限・未使用権限を継続的に棚卸しする。

### 9.2. FinOps

-   **Rule 67.9.2**: マネージド認可エンジン（AVP・authzed Cloud 等）は**判定リクエスト単位/保存 tuple 単位で課金**されることが多い。N+1 的な逐次 check（リスト表示で 1 件ごとに check）はコストとレイテンシを増幅する。`list-objects` / バッチ check の活用と適切なキャッシュでコストを抑える（新鮮性とのトレードオフは §4.4）。

### 9.3. パフォーマンス・スケーラビリティ

-   **Rule 67.9.3（認可レイテンシ）**: 認可判定はホットパス上にあり、全リクエストに加算される。判定レイテンシ目標（例: p99 で数 ms〜十数 ms）を定め、(a) 判定結果のキャッシュ、(b) リスト系の一括判定（`list-objects`）、(c) PDP の埋め込み/サイドカー配置でレイテンシを抑える。
-   **Rule 67.9.4（キャッシュと新鮮性のトレードオフ）**: キャッシュは性能を上げるが新鮮性を下げる。**機微/破壊的操作は新鮮性優先（キャッシュ短命 or バイパス）、一般閲覧はレイテンシ優先**と操作リスクで切り替える（§4.4・§6.4）。
-   **Rule 67.9.5（スケーラビリティ）**: 認可データ（tuple/属性）と判定はサービスの成長に比例して増える。専用認可ストア（OpenFGA/SpiceDB）は水平スケールを前提に設計されている。アプリ DB に認可判定を相乗りさせ続けるとボトルネック化する。

### 9.4. Zero Trust 連携

-   **Rule 67.9.6**: Zero Trust では「ネットワーク内＝信頼」を排し、**全アクセスをリクエスト単位で認可**する。認証シグナル（要素強度・デバイス姿勢・リスクスコア）を認可 context に取り込み、リスクに応じて許可を絞る/Step-Up（420）を要求する（000 §2 と連携）。

### 9.5. プライバシー（目的制限）

-   **Rule 67.9.7（目的制限）**: 認可は「権限の有無」だけでなく**アクセスの目的（purpose）**も判定要素に含め得る。同一データへのアクセスでも目的（サポート対応 vs 分析）で可否・範囲を変える purpose-based access を、規制データ（100_data_governance）で検討する。decision log には目的を記録し、目的外利用を監査可能にする。

---

## §10. 実装スニペット

> 以下は各方式の**最小代表例**。実スタックでは保守されたエンジン/ライブラリを用い、本ファイルの MUST 要件（deny-by-default・集中化・decision log）に適合させる。

### 10.1. OpenFGA 認可モデル例

```dsl
# ✅ OpenFGA authorization model（document / folder の ReBAC）
model
  schema 1.1

type user

type folder
  relations
    define viewer: [user]

type document
  relations
    define parent: [folder]
    define editor: [user]
    # folder の viewer は document も閲覧可（推移的アクセス）
    define viewer: [user] or editor or viewer from parent
```

```
# Relation tuple 例: anne は roadmap の editor
document:roadmap#editor@user:anne
# check(user:anne, viewer, document:roadmap) => allowed（editor から派生）
```

### 10.2. AWS Cedar ポリシー例

```cedar
// ✅ Cedar: deny-by-default。permit に一致しなければ拒否
permit (
  principal,
  action == Action::"viewDocument",
  resource
)
when {
  // 同一テナントかつ owner であること（最小権限）
  principal.tenant == resource.tenant &&
  resource.owner == principal
};

// forbid は permit を上書きする（deny-overrides）— 失効ユーザーは常に拒否
forbid (principal, action, resource)
when { principal.status == "suspended" };
```

### 10.3. OPA / Rego 例

```rego
# ✅ OPA/Rego: default で deny、明示 allow のみ許可
package authz

default allow := false

allow if {
    input.subject.role == "editor"
    input.resource.tenant == input.subject.tenant   # テナント境界
    input.action == "write"
}
```

### 10.4. 集中ガード関数（PEP → PDP）

```typescript
// ✅ 認可判定を集中 PDP に委ね、判定を decision log に記録する PEP
import { pdp } from '@/lib/authz/pdp';        // 集中ポリシー判定（Cedar/OpenFGA 等の薄いラッパ）
import { auditAuthz } from '@/lib/authz/audit';

export async function authorize(
  subject: Subject, action: string, resource: Resource, ctx: Context,
): Promise<void> {
  // tenant_id は認証済みコンテキストから導出（クライアント入力を信頼しない）
  const decision = await pdp.check({ subject, action, resource, tenant: ctx.tenant });
  auditAuthz({ subject: subject.id, action, resource: resource.id, decision, ctx }); // decision log
  if (!decision.allowed) throw new ForbiddenError(); // deny-by-default / fail-closed
}
```

---

## §11. アンチパターン集

| # | アンチパターン | 正しい対応 |
|:--|:-------------|:----------|
| 1 | 認証成功を認可の代替にする（ログイン済み＝操作可） | authN と authZ を分離し全アクセスを認可（§1.1, §2.1） |
| 2 | `if (user.role === 'admin')` を全コードに散在させる | 集中ガード/外部 PDP に集約（§6.1） |
| 3 | allow-by-default（ブラックリスト方式） | deny-by-default を徹底（§2.3） |
| 4 | フロントのフラグ/遺物テーブルを認可の根拠にする | サーバー側 SSOT を唯一の正にする（§6.2） |
| 5 | オブジェクト ID だけで返す（BOLA / IDOR） | オブジェクト単位で所有/共有を検証（§7.4） |
| 6 | 管理エンドポイントを UI で隠すだけ | サーバー側で関数レベル認可を強制（§7.4） |
| 7 | クライアント送信の `tenant_id` を信頼する | 認証済みコンテキストから導出（§8.1） |
| 8 | スコープだけで細粒度リソース認可を表現する | 粗粒度スコープ + リソース側 authZ（§7.1） |
| 9 | 権限剥奪後も古いキャッシュで許可（New Enemy Problem） | 機微操作で新鮮性を強める（§4.4, §6.4） |
| 10 | PDP 障害時に許可へフォールバック | fail-closed（拒否側に倒す）（§6.6） |
| 11 | 認可判定をログに残さない | decision log を構造化記録（§6.3） |
| 12 | RBAC でインスタンス単位制御を無理に表現（role 爆発） | ReBAC/ABAC へ段階的昇格（§3） |
| 13 | 最初から過剰に複雑なモデルを採用 | 最小十分なモデルから開始（§3.5） |
| 14 | ワイルドカード（`*`）権限を恒常付与 | 最小権限 + 一時昇格（JIT）（§2.6, §2.8） |
| 15 | 申請者が自分の申請を承認できる | 職務分離（SoD）を宣言的に強制（§2.7） |
| 16 | 認可属性（role/tenant）をマスアサインメントで上書き可 | 入力フィールドを allowlist（§7.6） |
| 17 | アプリ層だけで多層防御なし | RLS を最終防衛線として併用（§8.4） |
| 18 | RLS とアプリ PDP の判定が矛盾 | 共通 SSOT から判定基準を導出（§8.5） |
| 19 | リスト表示で 1 件ごとに逐次 check（N+1） | `list-objects`/バッチ check + キャッシュ（§9.2, §9.3） |
| 20 | 認可モデルをコード管理せず本番直編集 | Policy as Code + CI テスト（§5, §4.3） |

---

## §12. 成熟度モデル L1–L5

| レベル | 状態 | 特徴 |
|:------|:-----|:-----|
| **L1: Initial** | 認可がコードに散在。allow-by-default 傾向 | role チェックが経路ごとに不整合。BOLA/BFLA リスク高。判定ログなし |
| **L2: Managed** | RBAC を導入。ロール SSOT を一箇所に集約 | 管理 API に role チェック。deny-by-default を意識。基本的な監査ログ |
| **L3: Defined** | 集中ガード/PDP に判定を集約。オブジェクトレベル認可 | BOLA/BFLA を全経路で防止。テナント境界を強制。decision log 整備 |
| **L4: Policy-Driven** | Policy as Code（Cedar/OPA）または ReBAC（OpenFGA/SpiceDB）を採用 | ポリシーを CI テスト/形式検証。新鮮性を操作リスクで制御。最小権限・SoD を宣言的に強制 |
| **L5: Adaptive Zero Trust** | 認可が認証シグナル/リスクスコアと統合 | 全アクセスをリクエスト単位で評価。目的制限・継続検証。認可メトリクスで過剰権限を継続棚卸し |

-   **Rule 67.12.1**: 現在地を評価し、**最低 L3 を到達目標**とする。マルチテナント/特権/規制データを扱うサービスは L4 以上を目標とする。

---

## Appendix A: 逆引き索引

> AIが本ファイルを部分ロードする際に使用する逆引き索引。

| キーワード | セクション |
|:----------|:----------|
| authN vs authZ / 認証認可の分離 / 責任分界 | §2.1 |
| PDP / PEP / PIP / PAP / XACML | §2.2 |
| deny-by-default / deny-overrides / fail-closed | §2.3, §6.6 |
| 最小権限 / 職務分離 / SoD / JIT 昇格 | §2.4 |
| RBAC / role 爆発 | §3.1 |
| ABAC / 属性ベース / 文脈依存 | §3.2 |
| ReBAC / 関係ベース / グラフ | §3.3, §4 |
| PBAC / ポリシーベース | §3.4 |
| モデル選定 / 段階的昇格 / 混合 | §3.5 |
| Relation Tuple / Zanzibar | §4.1 |
| 推移的 / 階層的アクセス | §4.2 |
| OpenFGA / CNCF Incubating / .fga | §4.3 |
| SpiceDB / ZedToken / tunable consistency / 新鮮性 / New Enemy Problem | §4.4 |
| Policy as Code | §5 |
| Cedar / Amazon Verified Permissions / 形式検証 | §5.1 |
| OPA / Rego / Kubernetes / Gatekeeper | §5.2 |
| Cedar vs OPA 使い分け | §5.3 |
| 認可の外部化 / if 散在禁止 / Guardian Protocol | §6.1, §6.2 |
| ロール SSOT | §6.2 |
| decision log / 判定ログ / 監査可能性 | §6.3 |
| consistency / 新鮮性 / 権限伝播 | §6.4, §4.4 |
| OAuth スコープ設計 / 粗粒度 | §7.1 |
| RAR / RFC 9396 / authorization_details | §7.2 |
| PAR / RFC 9126 | §7.3 |
| BOLA / IDOR / オブジェクトレベル認可 | §7.4 |
| BFLA / 関数レベル認可 | §7.4 |
| マスアサインメント / role 上書き防止 | §7.4 |
| マルチテナント / テナント分離 / tenant_id | §8.1, §8.2 |
| 行レベルセキュリティ / RLS / 多層防御 | §8.2 |
| 可観測性 / 認可メトリクス | §9.1 |
| FinOps / 認可エンジン課金 / キャッシュ | §9.2 |
| 認可レイテンシ / 性能 / list-objects | §9.3 |
| キャッシュ vs 新鮮性 トレードオフ | §9.4 |
| スケーラビリティ | §9.5 |
| Zero Trust 認可 | §9.4 |
| プライバシー / 目的制限 / purpose-based | §9.5 |
| 実装スニペット / OpenFGA / Cedar / Rego / 集中ガード | §10 |
| アンチパターン | §11 |
| 成熟度モデル / L1-L5 | §12 |

---

**Cross-Reference（関連ルール）:**
-   `security/000_security_privacy.md` — §4.5 RBAC/ABAC 設計、§4.6 RBAC Defense Protocol（本ファイルの上位ポリシー・要約）
-   `security/400_authentication_and_passkeys.md` — 認証（クレデンシャル・パスキー・MFA）。認可の前提となるアイデンティティ確立
-   `security/410_federated_identity_and_oauth.md` — OAuth 2.1 / OIDC / SAML フェデレーション、トークン取得フロー
-   `security/420_step_up_auth_and_sensitive_operations.md` — Step-Up 認証、特権操作の再認証（認可の高リスク経路と連携）
-   `security/440_workload_and_agent_identity.md` — 委任認可、トークン交換、on-behalf-of、委任スコープの詳細
-   `engineering/100_api_integration.md` — API 設計・契約（BOLA/BFLA 防止の実装文脈）
-   `engineering/200_supabase_architecture.md` — PostgreSQL 行レベルセキュリティ（RLS）の実装詳細

### クロスリファレンス

| セクション | 関連ルール |
|-----------|------------|
| §2–§3（責任分界・モデル選定） | `security/000_security_privacy`（§4.5, §4.6） |
| §4–§5（ReBAC・Policy as Code） | `security/000_security_privacy`（§4.5）, `engineering/100_api_integration` |
| §7（OAuth 連携・API 認可） | `security/410_federated_identity_and_oauth`, `security/440_workload_and_agent_identity` |
| §8（マルチテナント・RLS） | `engineering/200_supabase_architecture` |
| §9（多角観点） | `security/420_step_up_auth_and_sensitive_operations`, `security/100_data_governance` |
