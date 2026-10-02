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
-   **Rule 67.2.9（境界は集合で定義し、ラチェットで両方向に固定）**: セキュリティ境界（書ける列・読める列・マスクするキー・許可オリジン・許可セレクタ等）は、**要素の名指し列挙ではなく集合（許可集合＋既定の極性）で定義する**（MUST）。名指しは「後から増えた要素」を必ず取りこぼす。集合はテスト（ラチェット）で固定し、増えたとき・減ったときの**両方で赤くなる**形にする（MUST）。分類の正本はコメントや文書ではなく、関数・定数・テストなど機械可読な形で持つ（MUST。コメントは検査できない）。境界を張る変更では兄弟経路（UPDATE を塞いだら INSERT、1 テーブルを直したら同型の全テーブル）を同時に棚卸しする（MUST）。失敗パターン: 操作・キー名・列・ワイルドカード・DNS の 5 件が、いずれも「列挙が集合の変化に追従しなかった」という同じ形で漏れた。

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
-   **Guard-Exempt Zone Discipline（権限獲得画面の配置）**: 集中 guard（layout 等）の配下に、その権限を**獲得する**ための画面（招待受諾・初回オンボーディング・権限申請・契約同意）を置かない（MUST NOT）。権限ゼロの状態で通す必要がある画面を要求側 guard の配下に置くと、循環依存で機能が構造的に死ぬ。分離は URL を変えない機構（route group 等）で行い、page ごとの opt-in guard より優先する。guard 外区画を作ったら全ページを列挙して「guard 配下 or 完全一致 allowlist の guard 外」を強制する構造ゲートを置き、走査 0 件での偽合格を防ぐ下限 assert を併設する（MUST）。guard 外区画の唯一の認証境界は契約テストで固定し、ソース走査はコメント除外で行う（生読みはコメント内の guard 名で偽合格する）。
-   **Config Reader Consistency（同じ設定値を読む判定器の整合）**: 「運営が確認済み」「信頼済み IP」のような設定値を新設・変更したら、その値を読む部品（受付制御・不正スコア・警報・台帳）を列挙し、読んでいない判定器が同じ入力で逆の結論を出さないかを確認する（MUST）。それぞれのテストが緑でも「2 つの判定が一致しているか」を見る検査が無ければ矛盾は素通りする（失敗パターン: 信頼 IP は「保留しない」のに警報だけが毎晩立ち、人が手で閉じていた）。警報が毎日立って人が手で閉じている状態は運用ではなく設計矛盾の兆候として扱い、閾値調整ではなく判定器間の整合で直す（SHOULD）。例外リストを広げると個別イベントの警報は減るので、例外リストの変更自体を監査ログ（before/after）と警報の対象にし、乗っ取りで例外が足された場合はその時点で検知する（SHOULD）。
-   **Self-Lockout Pre-Check（自己締め出しの保存前検証）**: アクセス制限・ロール・権限を自分自身にも適用する設定は、保存前に「適用後も保存者が通れるか」を**判定側と同一の関数**で検証する（MUST）。別実装で書くと二重 SSOT になり、片方だけ直して「防いだつもり」になる。fail-open 条件も判定側と一致させ、復帰可能なモード（ステップアップで通れる）は拒否せず、不可逆な締め出しだけ止める。テストでは判定系をモックせず入力取得だけ差し替える。失敗パターン: 「誰が保存できるか」だけ守られ「何を保存できるか」が無検査だった。
-   **Allowlist Resolution-Chain Parity（許可リストと解決連鎖の同一集合）**: 許可リスト検証を追加するときは、呼び出し元がその値をどう解決しているか（DB → 環境変数 fallback 等）を先に読み、許可集合を同一連鎖の全経路で構成する（MUST）。データ状態依存の検証は実 DB の現在値を実測する（型検査・lint・単体テストは素通りする）。回帰テストは「fallback 生存＋不正値拒否＋fail-safe」の 3 点。既定 false のセキュリティフラグを migration で ON 化する場合、seed が同テーブルを DELETE+INSERT で再構築して黙って false へ巻き戻していないか確認する。失敗パターン: DB 側の値が全行 NULL のまま許可リストを DB 由来に固定し、正規購入が全件拒否された。

### 6.3. Decision Log（監査可能性）

-   **Rule 67.6.4（判定ログ）**: すべての認可判定を**構造化された decision log** として記録可能にする（MUST）。少なくとも「主体・アクション・リソース・判定結果・適用ポリシー・コンテキスト・時刻」を残す。PII はマスキングする（000 §7.4 と整合）。
-   decision log は (a) インシデント時の影響範囲特定、(b) 過剰権限の発見、(c) コンプライアンス監査に用いる。拒否（deny）の記録は攻撃検知シグナルとして ITDR（000 §3.3）へ連携する。

### 6.4. Consistency / 新鮮性要件

-   **Rule 67.6.5（権限変更の伝播）**: 権限剥奪・ロール変更は**速やかに PDP/キャッシュへ伝播**させる。キャッシュ TTL とのトレードオフを明示し、機微操作では新鮮性を強める（§4.4・§9）。
-   **Rule 67.6.6（fail-closed）**: PDP/ポリシーストアへの問い合わせが失敗・タイムアウトした場合、**拒否側に倒す**（fail-closed）（MUST）。可用性のために許可へフォールバックしてはならない（高可用が必須の限定経路では、キャッシュ済み直近判定の短時間利用を明示ポリシーで許容する場合に限る）。
-   **Rule 67.6.7（fail-open を選ぶ場合の実証義務と沈黙禁止）**: 可用性優先で fail-open にした防御ゲート（不審 IP 遮断・漏えいパスワード照合・新デバイス通知等）は、「エラー時に素通し」＝防御が**静かに無効化**されても誰も気づかない。選ぶなら (a) モックでなく実エンドポイント／実クエリで動作を実証する（構文エラーで常に ALLOW に落ちる状態は unit mock では検出できない）、(b) 外部依存呼び出しは UA 等を明示して将来の provider 側拒否によるサイレント停止を予防する、(c) 「直前の履歴」に依存する判定は現在の記録を書く前に同期取得し、その順序をテストで固定する、(d) ゲート自身が書く記録を集計対象から除外して自己増幅（攻撃停止後も window が滑り続ける）を断つ（MUST）。
    -   エラーを握って空を返す実装は、権限欠落・関数不在・引数不一致をすべて「結果 0 件」へ潰す。握りつぶすなら、握った事実そのものをメトリクス／ログで可観測にする（MUST）。
    -   防御機能（ロックアウト・レート制限・検証）の旧シグネチャを「常に許可」を返す廃止スタブとして残してはならない（MUST NOT）。呼び出し側が fail-open なら結果は同じで記録だけが増えるので、廃止スタブは明示的に失敗させて警告経路に乗せる。引数名で overload 解決する API（PostgREST RPC 等）では、引数を落とした呼び出しがエラーにならず旧版へ解決するため、廃止時は旧シグネチャを DROP するか失敗させる（MUST）。契約（シグネチャ・戻り値）を変えるときは、既存テストが守っていた保証の行き先を先に決める（MUST）。共有 IP の誤遮断は保守的閾値・break-glass 設定・多層（per-account ロック／レート制限）で受容する。
    -   同じ判定（停止・ロック・失効・レート制限）が複数の guard に散っている場合、権限の高い順に有無を確認する（MUST）。防御は困っている所から書かれるため弱い側から実装され、最も権限の高い guard が最後まで抜ける。IdP の ban が発行済み access token を失効させない場合、guard 側で ban 状態を都度判定する（認証応答に含まれる値なら追加コストは無い）。

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
-   **Rule 67.7.7（サーバが決める値はロールで守る）**: tier・status・role・所有者 ID・評価集計など**サーバが決めるべき値は、決め方が正しいことではなく「その列を書ける主体（ロール）を絞る」ことで守る**（MUST）。クライアントが DB へ直接書ける構成（PostgREST／GraphQL 等）では、アプリと同じロールで書いている限り DB は正当な書込と API 直叩きを区別できない。「状態遷移だけを見るガード」は、状態を据え置いたまま中身（URL・親 ID・集計値）を差し替える更新を通す。守る列は名前の正規表現で拾わず、書込可能列をテーブル単位の集合として固定する（MUST）。権限判定はテーブル単位（`has_table_privilege` 相当）ではなく列単位（`has_any_column_privilege` 相当）で確認する（SHOULD。列 GRANT だけが残った状態を「権限なし」と誤判定するため）。失敗パターン: 課金なしで最上位 tier を自己発行できた。
-   **Rule 67.7.8（任意認証経路の拒否分岐）**: 匿名でも実行できる操作（投稿・コメント・アップロード）の認証解決は「真正のセッション無し」「停止アカウント」「不正な資格情報」「認証基盤障害」を区別する型で返し、後者 3 つを匿名に丸めてはならない（MUST）。拒否を処理してから初めて user を参照し、認証確認が失敗したまま Storage・高権限 DB・外部検証へ進めない（fail-closed）。本人向け API は 401（未認証）・403（停止／拒否）・404（対象不存在）・503（認証／DB 障害）を区別して返し、503 を再ログインへ誘導しない（MUST）。外部（IdP）エラー本文を応答や通知へ返さない。IdP の HTTP ステータスだけでは「無効トークン」と「停止」を区別できないことがあるので、SDK の固定エラーコードを優先して分類し、分類は実 IdP を通す結合テストで固定する（SHOULD）。失敗パターン: 認証ヘルパーの null が「匿名」と「拒否」を兼ね、停止ユーザーが匿名として投稿でき、基盤障害が再ログイン画面へ誘導された。
-   **Rule 67.7.9（所属判定は構造で比較する）**: 「所属・所有・同一」を判定するコードで `startsWith` や生の文字列完全一致を見たら疑う（MUST）。URL は origin（scheme+host+port）の三つ組で、IP はバイト列（IPv4-mapped IPv6 の復元、ポート除去、先頭ゼロ正規化）で、キー／パスは構造として比較する。LIKE／glob の接頭辞に外部由来または命名規約上のメタ文字（`%` `_`）が入り得る場合、エスケープして通すのではなく拒否する（SHOULD）。判定の失敗側に何があるかを確認する（「内部＝ガード無し」のように誤判定がそのまま防御無効化になる場合は特に）。正規化失敗の扱いは非対称にし、許可判定側は解釈不能→誤遮断回避、設定エントリ側は fail-closed（設定ミスで全許可しない）とする。変異テストに「接尾辞を足した別ドメイン」「メタ文字入り接頭辞」「IPv4-mapped IPv6」「ポート付き」を含める（MUST）。失敗パターン: `自社ホスト.example.com` が「内部」と判定されてガードを通らず、IPv4-mapped 表記の管理者 IP が許可リストに一致せず締め出された。
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
-   **Rule 67.8.6（派生テーブルの可視性継承）**: 公開可否（下書き・非表示・公開予定日・削除済み）が親エンティティにある場合、子・翻訳・中間（junction）・集計・派生テーブルの読取ポリシーは**親の可視性判定を自分で持つ**（MUST）。親テーブルが匿名に 0 件を返すことを派生テーブルの安全の根拠にしてはならない。露出はアプリ画面には現れない（画面は親を先に引く）ため、検査は匿名ロールで到達できる全テーブルを横断して直接叩く（MUST）。実装詳細は `engineering/200_supabase_architecture.md` Rule 2.15。
-   **Rule 67.8.7（SSOT の実効性と名前空間分離）**: 許可集合を「定義表＋表を検査するテスト」で固定したら、その表が実装に効いていること（実装から下流へ渡る実引数が表と一致する）を検証する別テストを置く（MUST）。表→表のテストは実装が表を無視していても緑のままである。同じ概念の台帳が 2 箇所にある場合（DB の列遮断と DTO の除外リスト、ロガーの機微キーとエラートラッカーの scrub パターン等）は、片方の期待集合を読み込んでもう片方の挙動を assert する突合テストを置き、是正前に赤くなる陰性対照を確認する（MUST）。是正は下流（RPC 側）で絞り込み、呼び出し側だけで絞らない。逆に、比べている対象が違う値（DB 層のロール列とアプリ層の管理ロール表等）は綴りが同じでも別の定数にし（MUST）、意図的に共有する綴りは参照で共有する。1 つの定数で 2 つの名前空間を照合すると、片方の値がもう片方の許可集合へ流れ込み「設定したのに何も起きない」状態を生む。
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

-   **判定結果の消費義務（Consume the Decision）**: ガードは「呼ばれた」だけでは効かない。上記のように判定関数自身が throw する形か、判別可能ユニオン（`{ proceed: true } | { proceed: false, reason }`）を返して呼び出し側が `proceed` を確認しないと型が通らない形にする（MUST）。「エラー時だけ return」で成功時に本処理へ落ちる形（例: OTP 発行に成功すると INSERT/UPDATE へ流れる）は禁止。存在チェック（`if (!otp)`）は検証ではなく、検証関数を呼んでその結果で分岐する。未実装のスタブ mutation は `{ success: true }` の no-op ではなく明示的エラーを返す（MUST。偽の成功と偽の監査行を作る）。監査では判定関数の呼び出し箇所を機械列挙し、戻り値を分岐に使っていない箇所を検出する。「全 mutation にガード適用済み」の主張は UI 導線からの人手列挙ではなく、export された mutation 関数の機械列挙（命名 prefix 等）を母数にし、同名関数が複数ファイルにある場合は import 元を全数確認して実 caller を特定する（MUST。失敗パターン: caller 0 件の孤児側にガードを足し、実経路が無防備のまま 2 回の改修を通過した）。

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
| 21 | 境界を要素の名指し列挙で定義し、増えた要素を取りこぼす | 集合＋既定極性で定義し両方向ラチェットで固定（§2.3 67.2.9） |
| 22 | 任意認証経路で停止・不正資格情報・基盤障害を「匿名」へ丸める | 拒否の種別を型で区別し fail-closed、503 を再ログインへ誘導しない（§7.4 67.7.8） |
| 23 | 同じ設定値（信頼済み IP 等）を読む判定器が逆の結論を出す | 設定値の読者を列挙し判定一致をテストで固定。例外リストの変更を監査・警報対象にする（§6.2） |
| 24 | 「全 mutation にガード適用済み」を UI 導線からの人手列挙で主張 | export 関数の機械列挙＋同名関数の caller 検証を母数にする（§10.4） |
| 25 | IP・URL・ドメインの所属判定を `startsWith`／文字列完全一致で行う | origin 三つ組・正規化バイト列など構造で比較し、接尾辞付き別ドメイン等を変異テストに含める（§7.4 67.7.9） |
| 26 | 許可集合の定義表だけをテストし、実装が表を参照しているか検証しない | 実装→下流の実引数を検査し、台帳間を挙動で突合（§8.2 67.8.7） |
| 27 | 自分を締め出せる設定（IP 制限・ロール）を保存前に検証しない | 保存者自身が通るかを判定側と同一関数で検証し、不可逆な締め出しだけ止める（§6.2） |
| 28 | 停止・失効の判定が弱い guard にだけあり、最も権限の高い guard に無い | 権限の高い順に有無を確認し、IdP の ban が発行済みトークンを失効させないなら guard 側で都度判定（§6.4 67.6.7） |
| 29 | 許可リスト検証を呼び出し元の SSOT 解決連鎖（DB ∪ env fallback）と別集合で構成 | 同一連鎖の全経路で許可集合を構成し、データ状態依存の検証は実 DB の現在値で実測（§6.2） |

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
