# 68. ワークロード & エージェントアイデンティティ (Workload & Agent Identity)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-06-09

> [!IMPORTANT]
> **Primary Directive（主要方針）**
> 「非人間IDは人間の数十倍存在し、人間より速く強く侵害される — standing credential を持たせるな、短命・スコープ付き・失効可能を既定とせよ。」
> サービスアカウント・APIキー・CI/CDクレデンシャル・ワークロード・AIエージェントの認証と委任は、
> 本ファイルの最新安定版ベストプラクティスに準拠しなければならない。
> 認証・認可は `000_security_privacy.md` §1 の優先順位（Legal & Security > UX > Revenue > DX）に従う。

> [!NOTE]
> 本ファイルは `000_security_privacy.md` §3.2（非人間ID管理）・§18（Agentic AI / MCP）の**深掘り版**であり、非人間ID（NHI）とAIエージェントの**認証・委任の正本**です。
> 人間向けの OAuth/OIDC・トークン交換の正本は [`410_federated_identity_and_oauth.md`](./410_federated_identity_and_oauth.md) に集約しています（M2M・委任は本ファイルへ）。
> AIエージェントの**権限設計・自律度・委任成熟度**は [`core/000_core_mindset.md`](../core/000_core_mindset.md) §9 が正本です（本ファイルは認証/委任の技術深掘り）。

> [!NOTE]
> **標準の成熟度に関する注記**: SPIFFE/SPIRE・OAuth 2.0 Client Credentials（RFC 6749）・Token Exchange（RFC 8693）・Resource Indicators（RFC 8707）は**安定した標準**である。
> 一方、**OAuth 2.1 は IETF ドラフト**（draft-ietf-oauth-v2-1、RFC ではない）であり、**MCP（Model Context Protocol）認可・Cross-App Access（XAA）・AIエージェント On-Behalf-Of 委任の運用パターンは 2025–2026 の新興/ドラフト標準**である。新興部分は仕様変動を前提に、抽象境界を設けて実装する。

---

## 目次

| § | セクション |
|---|---|
| 1 | [責任分界点とスコープ](#1-責任分界点とスコープ) |
| 2 | [非人間ID（NHI）ガバナンス](#2-非人間idnhiガバナンス) |
| 3 | [ワークロードアイデンティティ（SPIFFE/SPIRE・mTLS）](#3-ワークロードアイデンティティspiffespiremtls) |
| 4 | [Workload Identity Federation（WIF・OIDC連携）](#4-workload-identity-federationwifoidc連携) |
| 5 | [M2M 認証（Client Credentials・APIキー）](#5-m2m-認証client-credentialsapiキー) |
| 6 | [短命クレデンシャル・STS・Zero Standing Privilege](#6-短命クレデンシャルstszero-standing-privilege) |
| 7 | [AIエージェントのアイデンティティ原則（Tier-0）](#7-aiエージェントのアイデンティティ原則tier-0) |
| 8 | [On-Behalf-Of 委任（Token Exchange・二重身元）](#8-on-behalf-of-委任token-exchange二重身元) |
| 9 | [委任チェーンの制限とループ防止](#9-委任チェーンの制限とループ防止) |
| 10 | [MCP 認可（OAuth 2.1ベース・新興）](#10-mcp-認可oauth-21ベース新興) |
| 11 | [Cross-App Access（XAA・IdP仲介・新興）](#11-cross-app-accessxaaidp仲介新興) |
| 12 | [監査と委任チェーンの追跡可能性](#12-監査と委任チェーンの追跡可能性) |
| 13 | [可観測性・異常検知](#13-可観測性異常検知) |
| 14 | [FinOps・パフォーマンス・スケーラビリティ](#14-finopsパフォーマンススケーラビリティ) |
| 15 | [Zero Trust・プライバシー](#15-zero-trustプライバシー) |
| 16 | [実装スニペット集](#16-実装スニペット集) |
| 17 | [アンチパターン集（20件）](#17-アンチパターン集20件) |
| 18 | [成熟度モデル L1–L5](#18-成熟度モデル-l1l5) |
| A | [Appendix A: 逆引き索引](#appendix-a-逆引き索引) |
| B | [Appendix B: クロスリファレンス](#appendix-b-クロスリファレンス) |

---

## §1. 責任分界点とスコープ

> **参考規格**: NIST SP 800-207 (Zero Trust), SPIFFE/SPIRE, RFC 6749, RFC 8693, RFC 8707

### 1.1. 本ファイルが扱う対象

-   **Rule 68.1.1**: 本ファイルは、**人間以外のアクセス主体**（非人間ID = NHI）の認証と委任を扱う。具体的にはサービスアカウント・APIキー・CI/CDクレデンシャル・ワークロード（コンテナ/関数/VM）・AIエージェントである。
-   **Rule 68.1.2**: 人間ユーザーのブラウザ/モバイル認証（Authorization Code Flow・ソーシャルログイン・SSO・パスキー）は本ファイルの対象外であり、`410`・`400` を正本とする。

### 1.2. 責任分界点（隣接ファイルとの境界）

-   **Rule 68.1.3**: 以下の責任分界点を遵守し、二重定義を避ける。クロスリファレンスは貼るが、各正本の本文を本ファイルで複製しない。

| ファイル | 正本とする範囲 |
|:--------|:--------------|
| `core/000_core_mindset.md` §9 | AIエージェントの**権限設計・自律度（L0–L4）・委任成熟度・可逆性・人間承認ゲート**（設計思想） |
| `security/000_security_privacy.md` §3.2 / §18 | NHI管理・Agentic AI/MCP の**概要と全体方針** |
| `security/410_*` | **人間向け** OAuth 2.1 / OIDC・トークン交換の技術詳細 |
| **本ファイル `440`** | **NHI・ワークロード・AIエージェントの認証/委任の技術詳細**（SPIFFE・WIF・Client Credentials・OBO・MCP認可） |

-   **Rule 68.1.4**: WIF・SPIRE 等の**特定クラウド/ランタイムの実装手順**は `engineering/500_firebase_gcp.md` 等のエンジニアリングルールを正本とする。本ファイルは方針と検証要件を定める。

### 1.3. 適用方針

-   **Law**: 自前の認証/委任プロトコル実装は禁止する。検証済みの標準（SPIFFE/SPIRE・OAuth 2.0 Client Credentials・RFC 8693 Token Exchange）と検証済みライブラリ/SDKを使用する。
-   **Law**: 用語「MUST / MUST NOT / SHOULD / SHOULD NOT / MAY」は RFC 2119 / RFC 8174 の意味で用いる。

---

## §2. 非人間ID（NHI）ガバナンス

> **参考規格**: `000_security_privacy.md` §3.2, NIST SP 800-207

### 2.1. NHI は人間の数十倍規模である前提

-   **Law**: NHI は人間IDを**桁違いに上回る規模**（業界調査で数十倍）で存在する前提で、ガバナンスを**自動化前提**で設計する。手動棚卸しは規模で破綻する。
-   **Rule 68.2.1**: NHI のライフサイクル（発行 → 利用 → ローテーション → 失効 → 削除）を自動化し、人手の介在を最小化しなければならない（MUST）。

### 2.2. NHI 分類と所有者割当

-   **Rule 68.2.2**: 全 NHI を分類し、**各 NHI に人間の所有者（owner）を必ず割り当てる**。所有者不明の NHI は orphaned とみなし、失効候補とする。

| NHI 種別 | 例 | 既定の認証方式 | リスク |
|:--------|:---|:-------------|:------|
| **サービスアカウント** | GCP SA / AWS IAM Role | WIF / STS 短命トークン | High |
| **APIキー** | 外部SaaS連携キー | プレフィックス+ハッシュ保存 | High |
| **CI/CDクレデンシャル** | GitHub Actions / deploy key | **OIDC（静的シークレット廃止）** | Critical |
| **ワークロード** | コンテナ/関数/VM | SPIFFE SVID / mTLS | High |
| **AIエージェント** | LLMエージェント / MCP Client | OBO委任 + 短命トークン | Critical |
| **Bot/自動化** | Cron / Webhook handler | スコープ付き短命トークン | Medium |

### 2.3. 棚卸し・ローテーション・一括失効・orphaned 検出

-   **Rule 68.2.3**: NHI インベントリを**機械可読**（API/IaC由来）で維持し、所有者・スコープ・最終利用時刻・有効期限を属性として保持する（MUST）。
-   **Rule 68.2.4**: 一定期間未使用の NHI、所有者が退職/異動した NHI を **orphaned** として自動検出し、無効化フローに乗せる（MUST）。
-   **Rule 68.2.5**: 漏洩・インシデント時に、所有者・発行元・スコープを軸に **NHI を一括失効（bulk revocation）**できる経路を事前に用意する（MUST）。`000_security_privacy.md` §6.7 Panic Button と整合させる。
-   **Rule 68.2.6**: 広範な権限（`*` / `admin` / unscoped）を持つ NHI を定期監査し、最小権限へ縮小する。

---

## §3. ワークロードアイデンティティ（SPIFFE/SPIRE・mTLS）

> **参考規格**: SPIFFE/SPIRE（CNCF 卒業プロジェクト）, RFC 8705 (mTLS)

### 3.1. SPIFFE ID と SVID

-   **概要**: SPIFFE はワークロードに**プラットフォーム非依存の一意ID**（SPIFFE ID、例: `spiffe://example.org/ns/prod/sa/payments`）を与える標準。SPIRE はその参照実装で、ワークロードを**アテステーション**（実行環境の検証）したうえで**短命の SVID**（X.509 証明書または JWT）を発行する。
-   **Law**: ワークロード間の認証は、長命の共有シークレットではなく **SPIFFE SVID（短命）+ mTLS** を既定とする。
-   **Action**:
    1.  ワークロードに静的な証明書/キーを焼き込まない。SPIRE Agent によるアテステーションで動的に SVID を取得する。
    2.  SVID は**短命**（分〜時間オーダー）とし、自動更新する。
    3.  X.509-SVID で mTLS、JWT-SVID で HTTP/gRPC の Bearer 的検証を使い分ける。

### 3.2. mTLS とサービスメッシュ

-   **Action**: サービスメッシュ（Istio/Linkerd 等）を用いる場合、メッシュが発行するワークロード証明書（多くは SPIFFE 互換）で**サービス間 mTLS を既定**とし、平文の内部通信を排除する。
-   **Rule 68.3.1**: SVID/証明書を受領する側は、**信頼ドメイン（trust domain）**と**SPIFFE ID（または SAN）**を許可リストで検証する（MUST）。任意のワークロードからの接続を受理してはならない。

### 3.3. Secretless / Zero Standing Privilege

-   **Law**: ワークロードは可能な限り **secretless**（静的シークレットを保持しない）で設計する。認証は実行環境のアテステーション（SPIFFE / クラウドメタデータ / OIDC）から導出する。
-   **Cross-Reference**: §6（短命クレデンシャル）, `000_security_privacy.md` §21.3（動的シークレット）

---

## §4. Workload Identity Federation（WIF・OIDC連携）

> **参考規格**: GCP Workload Identity Federation, AWS IAM Roles Anywhere / OIDC, Azure Workload Identity, GitHub Actions OIDC

### 4.1. 静的キーの廃止

-   **Law**: クラウドへのワークロード認証に**長命の静的キー**（サービスアカウントキーJSON・長命IAMユーザーアクセスキー）を新規発行してはならない。**Workload Identity Federation（WIF）/ OIDC 連携**で短命クレデンシャルへ交換する。

### 4.2. プロバイダ別の連携方式

| 環境 | 連携方式 |
|:-----|:---------|
| **GCP** | Workload Identity Federation（外部OIDC/SAML → 短命 SA トークン） |
| **AWS** | IAM Roles Anywhere（X.509）/ OIDC フェデレーション（`AssumeRoleWithWebIdentity`） |
| **Azure** | Workload Identity Federation（Federated Credentials） |
| **CI/CD** | **GitHub Actions OIDC**（`id-token: write`）→ 各クラウドの短命ロール引受 |

### 4.3. OIDC 連携の検証要件

-   **Rule 68.4.1**: クラウド側の信頼ポリシーは、IdP の `iss` に加えて **`sub` / `aud` / リポジトリ・ブランチ・環境などのクレームを最小スコープで束縛**しなければならない（MUST）。`aud` 無検証・`sub` ワイルドカードは禁止。
-   **Rule 68.4.2**: GitHub Actions OIDC では、信頼条件に **リポジトリと（必要に応じ）ブランチ/環境/タグ**を含め、フォークや任意リポジトリからのロール引受を構造的に防止する。
-   **Cross-Reference**: `000_security_privacy.md` §19.3（CI/CD OIDC）, `engineering/500_firebase_gcp.md`（WIF 実装詳細）

---

## §5. M2M 認証（Client Credentials・APIキー）

> **参考規格**: RFC 6749 (OAuth 2.0 Client Credentials), RFC 8707 (Resource Indicators), RFC 9449 (DPoP), RFC 8705 (mTLS)

### 5.1. OAuth 2.0 Client Credentials Grant

-   **Law**: ユーザー不在の M2M（machine-to-machine）通信は **OAuth 2.0 Client Credentials Grant（RFC 6749）**を既定とする。ユーザー認証フロー（Authorization Code）を M2M に流用しない。
-   **Rule 68.5.1**: Client Credentials で取得するトークンは、**`audience`（対象リソース、RFC 8707 resource indicators）と `scope` を最小限に限定**しなければならない（MUST）。1つの汎用トークンを全API共用にしてはならない。
-   **Rule 68.5.2**: M2M トークンは可能な限り **mTLS（RFC 8705）または DPoP（RFC 9449）で sender-constrained 化**し、盗難トークンの再利用を暗号的に阻止する（SHOULD、金融/高リスクは MUST）。

### 5.2. APIキーの規律

-   **Law**: APIキーを採用する場合、以下を満たす（`000_security_privacy.md` §4.8 と整合）。
-   **Action**:
    1.  **プレフィックス**: 種別・環境を識別できるプレフィックス（例: `sk_live_` / `pk_test_`）を付与する。
    2.  **ハッシュ保存**: キー本体は平文保存せず、SHA-256 等でハッシュ化して保存する。照合は定数時間比較で行う。
    3.  **ローテーション**: 有効期限とローテーション周期を定め、無期限キーを禁止する。重複期間（旧新両有効）を設けて無停止ローテーションする。
    4.  **失効ログ**: 発行・利用・失効を監査ログに記録し、漏洩時に即時失効できる経路を持つ。
-   **Rule 68.5.3**: APIキーは M2M の**簡易手段**であり、可能なら Client Credentials + 短命トークンへ移行する（SHOULD）。長命APIキーは漏洩時の被害が甚大。

---

## §6. 短命クレデンシャル・STS・Zero Standing Privilege

> **参考規格**: NIST SP 800-207, `000_security_privacy.md` §21.3

### 6.1. TTL 管理と自動更新

-   **Law**: NHI/ワークロード/エージェントのクレデンシャルは**短命**を既定とし、TTL（有効期限）を明示管理する。期限切れ前に自動更新する仕組みを実装する。

| クレデンシャル種別 | 推奨 TTL |
|:----------------|:--------|
| ワークロード SVID（SPIFFE） | 分〜1時間 |
| STS / WIF 短命トークン | ≤ 1時間 |
| M2M アクセストークン | ≤ 1時間 |
| AIエージェント委任トークン | ≤ 15分（高リスクはより短く） |

### 6.2. 静的シークレット廃止と Zero Standing Privilege

-   **Law**: 静的・長命シークレットの新規導入を原則禁止し、**動的・短命シークレット**（STS / Vault dynamic secrets / WIF）へ移行する。
-   **Rule 68.6.1**: 恒常的に有効な権限（**standing privilege**）を最小化し、**必要時に発行・タスク完了後に自動失効**する Just-in-Time モデルを採用する（SHOULD、特権 NHI は MUST）。
-   **Cross-Reference**: `000_security_privacy.md` §21（シークレットマネジメント）, §3.4（PAM / JIT）

---

## §7. AIエージェントのアイデンティティ原則（Tier-0）

> **参考規格**: `core/000_core_mindset.md` §9, `000_security_privacy.md` §18, OAuth 2.1 (draft), RFC 8693
>
> **★将来性の核**: 本節以降（§7–§11）は AIエージェント認証・委任の中核であり、2025–2026 の新興/ドラフト領域を含む。

### 7.1. エージェントは人間とは別のアイデンティティ

-   **Law**: AIエージェントには、**それを操作する人間とは別個のアイデンティティ**を割り当てる。エージェントが人間のログインセッション・人間のパスワード・人間の長命トークンをそのまま流用してはならない。
-   **Rationale**: エージェントと人間の身元を分離することで、エージェントの行動を独立に監査・スコープ制限・失効できる。

### 7.2. Tier-0 原則（エージェントに対する絶対禁止）

-   **Law**: AIエージェントのアイデンティティには、以下の **Tier-0 原則** を例外なく適用する。

| Tier-0 原則 | 内容 |
|:-----------|:-----|
| **standing credential 禁止** | エージェントに恒常的に有効な長命クレデンシャルを持たせない。委任は短命・revocable に限る |
| **unscoped 禁止** | スコープ無制限（全API・全リソース）の権限をエージェントに付与しない。必ず `audience` / `scope` を絞る |
| **共有シークレット禁止** | 複数エージェント/サービスで同一クレデンシャルを使い回さない。1エージェント=1アイデンティティ |

-   **Rule 68.7.1**: エージェントへ渡す権限は**短命・スコープ付き・失効可能（revocable）**でなければならない（MUST）。これは Tier-0 原則の運用的言い換えである。
-   **Cross-Reference**: 権限設計の自律度（L0–L4）・人間承認ゲートは `core/000_core_mindset.md` §9.1 を正本とする。

---

## §8. On-Behalf-Of 委任（Token Exchange・二重身元）

> **参考規格**: RFC 8693 (OAuth 2.0 Token Exchange — 安定), OAuth 2.1 (draft), RFC 8707 (Resource Indicators)
>
> **注**: RFC 8693 Token Exchange 自体は安定標準。これを**AIエージェント On-Behalf-Of（OBO）委任に適用する運用パターン**は 2025–2026 の新興であり、仕様変動を前提とする。

### 8.1. OBO 委任の原則

-   **Law**: エージェントが「人間ユーザーの代理」として動作する場合、**On-Behalf-Of（OBO）委任**で「人 + エージェント」の二重身元を保持する。エージェントが人間に成り代わって（impersonation）痕跡を消してはならない。
-   **Action**: RFC 8693 Token Exchange を用い、
    1.  人間のトークン（subject token）を `subject_token` として提示。
    2.  エージェントのアイデンティティを `actor_token`（または `requested_actor` 相当の表現）として提示。
    3.  AS は**人（`sub`）+ 代理実行者（`act` チェーン）**を含むトークンを発行する。`act` クレームに委任者の連鎖を記録する。
-   **Rule 68.8.1**: 発行されるトークンは、**誰の権限で（`sub`）・誰が実行したか（`act`）**の双方を監査可能な形で保持しなければならない（MUST）。impersonation（actor 情報を消す代理）は監査性を損なうため、原則 delegation（`act` 保持）を用いる。

### 8.2. ダウンスコープ強制と resource indicators

-   **Law**: OBO 委任時、エージェントへ渡すトークンは元の人間トークンより**権限を広げてはならない**。必要に応じて**ダウンスコープ（縮小）**する。
-   **Rule 68.8.2**: Token Exchange の要求には **`scope` の縮小**と **`resource`（RFC 8707 resource indicators）による audience の限定**を付与しなければならない（MUST）。過剰権限の伝播（privilege escalation via delegation）を構造的に防止する。

---

## §9. 委任チェーンの制限とループ防止

> **参考規格**: `000_security_privacy.md` §18.4 (A2A), `core/000_core_mindset.md` §9.6 (Multi-Agent Orchestration)

### 9.1. 多段委任の深さ制限

-   **Law**: 人 → エージェント → サブエージェント → リソース のような**多段委任チェーンの深さに上限**を設ける。無制限の委任は権限の追跡不能・横移動を招く。
-   **Rule 68.9.1**: 委任トークンに**委任深度カウンタ**または `act` チェーン長の上限を設け、上限超過の交換要求を拒否しなければならない（MUST）。
-   **Rule 68.9.2**: 各委任段階で**ダウンスコープを強制**し（§8.2）、下流ほど権限が縮小する単調性を保つ。下流が上流より広い権限を得てはならない。

### 9.2. ループ防止

-   **Rule 68.9.3**: 委任チェーンに**同一アイデンティティの再出現（循環）を検知**し、ループ（A→B→A）を拒否する。`core/000_core_mindset.md` §9.6 の Agentic Loop Detection と整合させる。
-   **Action**: タイムアウトと最大委任回数の二重ガードを実装し、無限委任（Infinite Delegation Loop、`000_security_privacy.md` §18.4）を防止する。

---

## §10. MCP 認可（OAuth 2.1ベース・新興）

> **参考規格**: Model Context Protocol Authorization（OAuth 2.1 ベース・**新興/ドラフト**）, OAuth 2.1 (draft-ietf-oauth-v2-1), RFC 8707
>
> **注**: MCP 認可仕様は 2025–2026 に標準化が進行中の**新興領域**である。仕様の更新に追従できるよう、認可ロジックを抽象境界の背後に置く。

### 10.1. MCP 認可の基本

-   **Law**: MCP（Model Context Protocol）サーバーへのアクセス認可は、独自方式ではなく **OAuth 2.1 ベースのフロー**（Authorization Code + PKCE / 適切な場合は Client Credentials）に準拠する。
-   **Action**:
    1.  MCP クライアント（エージェント）は MCP サーバーを **Resource Server** として扱い、AS から取得したスコープ付き短命トークンで認可する。
    2.  **resource indicators（RFC 8707）**で対象 MCP サーバーを `audience` として明示し、トークンの転用（Confused Deputy）を防止する。
    3.  ユーザーコンテキストの伝搬は§8 の OBO 委任に従い、「人 + エージェント」の二重身元を保つ（`000_security_privacy.md` §18.3 の権限昇格防止と整合）。

### 10.2. MCP 固有のガード

-   **Rule 68.10.1**: MCP サーバーは承認済みホワイトリストに限定し（`000_security_privacy.md` §18.3）、ツール定義の改ざん（Tool Poisoning、§18.6）に対し署名検証・人間レビューを併用する。
-   **Rule 68.10.2**: MCP トークンも Tier-0 原則（§7.2）に従い、**短命・スコープ付き・失効可能**でなければならない（MUST）。

---

## §11. Cross-App Access（XAA・IdP仲介・新興）

> **参考規格**: Cross-App Access（XAA、**新興**）, RFC 8693 (Token Exchange), Enterprise IdP Federation
>
> **注**: XAA はエンタープライズ IdP がアプリ間/エージェント間アクセスを仲介する **2025–2026 の新興パターン**である。標準が固まりつつある段階のため、新規必須要件ではなく拡張点として認識する。

### 11.1. IdP 仲介の原則

-   **概要**: Cross-App Access（XAA）は、エージェントやアプリが他アプリ/リソースへアクセスする際に、**エンタープライズ IdP を仲介役**として置き、IdP がポリシー適用・トークン交換・**全アクションの監査**を担う構成。エージェントが各アプリと個別に長命連携を結ぶ「コネクタ乱立」を避ける。
-   **Action**:
    1.  エージェント↔リソース間の直接の長命クレデンシャル発行を避け、IdP 経由のスコープ付き短命トークンに集約する。
    2.  IdP 側で**全アクセス・全委任を一元監査**し、失効を一箇所で行えるようにする。
    3.  トークン交換は RFC 8693（§8）に準拠し、OBO の二重身元・ダウンスコープを維持する。
-   **Rule 68.11.1**: XAA を採用する場合でも、Tier-0 原則（§7.2）・委任チェーン制限（§9）・監査追跡（§12）の要件を緩めてはならない。

---

## §12. 監査と委任チェーンの追跡可能性

> **参考規格**: `000_security_privacy.md` §25（不変ログ）, RFC 8693（`act` クレーム）

### 12.1. 委任チェーンの完全な追跡可能性

-   **Law**: 「人 → エージェント → （サブエージェント →）リソース」の委任チェーン全体を、後から人間が追跡・検証できる形で記録する。
-   **Rule 68.12.1**: 各アクセス/操作のログには、**実権限者（`sub`）・実行アクター（`act` チェーン）・対象リソース（`audience`）・スコープ・トークン発行/失効イベント**を含めなければならない（MUST）。
-   **Rule 68.12.2**: NHI/エージェントの監査ログは**改ざん不能（不変・追記専用）**で保持し（`000_security_privacy.md` §25）、PII は §7.4 に従いマスキングする。

### 12.2. 相関と再構成

-   **Action**: 委任トークンに相関ID（correlation id）を付与し、分散したサービス横断で1つの委任チェーンを再構成可能にする。インシデント時に「どの人間の権限で、どのエージェントが、何をしたか」を即座に再現できることを要件とする。

---

## §13. 可観測性・異常検知

### 13.1. NHI/エージェントの行動ベースライン

-   **Action**: NHI/エージェントごとに正常な利用パターン（呼び出し頻度・対象API・時間帯・送信先）をベースライン化し、逸脱を検知する（`000_security_privacy.md` §3.3 ITDR と連携）。
-   **計測対象**:
    -   トークン発行/更新/失効レート、Token Exchange（OBO）発火数。
    -   委任深度の分布、深度上限ヒット数、ループ検知発火数。
    -   `audience`/`scope` 不一致による拒否、未知 SPIFFE ID/信頼ドメインからの接続。
    -   エージェントの異常なツール呼び出し（頻度急増・通常外リソース）。

### 13.2. 自動対応

-   **Action**: 高リスクイベント（再利用検知・委任ループ・unscoped 要求）に対し、当該 NHI/エージェントのトークンファミリーを即時失効し、所有者へ通知する自動ワークフロー（SOAR連携）を構築する。

---

## §14. FinOps・パフォーマンス・スケーラビリティ

### 14.1. FinOps（短命クレデンシャル発行コスト）

-   **Action**: 短命クレデンシャルは安全だが、**発行・更新のたびに STS / AS への往復コスト**が発生する。発行頻度とTTLのバランスを取り、過剰な再発行を監視する。一部 IDaaS は M2M トークン数で課金されるため、エージェントのトークン乱発を抑制する。

### 14.2. パフォーマンス

-   **Action**: トークン検証はホットパス。JWT-SVID/JWT のローカル検証 + JWKS キャッシュ（`410` §6.3 と同方針）でレイテンシを抑える。鍵フェッチを同期ブロッキングにしない。

### 14.3. スケーラビリティ

-   **Action**: NHI が数十倍規模である前提で、失効リスト・委任状態は分散ストア（Redis 等）で水平スケールさせる。ステートレス検証（短命トークン）を主軸にしつつ、失効は短TTL + 失効リストのハイブリッドで一貫性とスケールを両立する。

---

## §15. Zero Trust・プライバシー

### 15.1. 継続的検証（Zero Trust）

-   **Law**: トークン保持＝信頼ではない。NHI/エージェントのアクセスは、毎回 `audience`/`scope`/sender-constraint/コンテキスト（ワークロードアテステーション・リスクスコア）で都度検証する（NIST SP 800-207, `000_security_privacy.md` §2.4 Identity-First Zero Trust）。

### 15.2. プライバシー

-   **Action**: エージェントが人間の代理でアクセスする場合、OBO 委任で渡るデータを**目的内・最小限**に限定する（`000_security_privacy.md` §7.2 データ最小化）。委任トークン・監査ログ内の PII はマスキングし、相関IDで人間を直接特定できないよう配慮する。

---

## §16. 実装スニペット集

> [!NOTE]
> スニペットは最新安定版のライブラリ前提の最小例。本番では例外処理・タイムアウト・監査ログを付加すること。新興領域（MCP/XAA）は仕様変動を前提に抽象境界の背後に置く。

### 16.1. SPIFFE JWT-SVID の検証（受信側）

```typescript
// ✅ SPIFFE JWT-SVID を信頼ドメイン + SPIFFE ID 許可リストで検証。§3.2
import { createRemoteJWKSet, jwtVerify } from 'jose';

const BUNDLE = createRemoteJWKSet(new URL('https://spire-server.example.org/keys')); // trust bundle

const ALLOWED_SPIFFE_IDS = new Set(['spiffe://example.org/ns/prod/sa/payments']);

export async function verifySvid(jwtSvid: string, expectedAudience: string) {
  const { payload } = await jwtVerify(jwtSvid, BUNDLE, {
    audience: expectedAudience,           // §3.1 audience 検証
    algorithms: ['ES256', 'RS256'],       // alg ホワイトリスト
  });
  // sub = SPIFFE ID。信頼ドメイン + 許可リストを検証
  if (!ALLOWED_SPIFFE_IDS.has(String(payload.sub))) {
    throw new Error('untrusted SPIFFE ID');
  }
  return payload;
}
```

### 16.2. Client Credentials + mTLS（M2M トークン取得）

```typescript
// ✅ OAuth 2.0 Client Credentials + audience/scope 限定。§5.1
// mTLS は HTTPS クライアント証明書（agent options / fetch dispatcher）で束縛する想定。
export async function getM2MToken(): Promise<string> {
  const res = await fetch('https://as.example.com/oauth2/token', {
    method: 'POST',
    headers: { 'content-type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'client_credentials',
      client_id: process.env.M2M_CLIENT_ID!,
      // mTLS 束縛なら client_secret 不要（証明書で認証）。DPoP 併用も可。
      scope: 'payments:read',                       // §5.1 最小スコープ
      resource: 'https://api.example.com/payments', // §5.1 RFC 8707 audience 限定
    }),
    // dispatcher/agent: mTLS クライアント証明書を付与（環境依存）
  });
  if (!res.ok) throw new Error('token request failed');
  return (await res.json()).access_token;
}
```

### 16.3. Token Exchange（On-Behalf-Of 委任・二重身元）

```typescript
// ✅ RFC 8693 Token Exchange で「人 + エージェント」のOBO委任。§8
// subject_token = 人間のトークン、actor_token = エージェントのアイデンティティ。
export async function exchangeOnBehalfOf(humanToken: string, agentToken: string) {
  const res = await fetch('https://as.example.com/oauth2/token', {
    method: 'POST',
    headers: { 'content-type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:token-exchange',
      subject_token: humanToken,
      subject_token_type: 'urn:ietf:params:oauth:token-type:access_token',
      actor_token: agentToken,                                          // §8.1 act チェーン
      actor_token_type: 'urn:ietf:params:oauth:token-type:access_token',
      scope: 'documents:read',                                          // §8.2 ダウンスコープ（縮小のみ）
      resource: 'https://api.example.com/documents',                    // §8.2 RFC 8707 audience 限定
    }),
  });
  if (!res.ok) throw new Error('token exchange failed');
  // 発行トークンは sub（人）+ act（エージェント連鎖）を含む。§8.1 / §12.1
  return (await res.json()).access_token;
}
```

### 16.4. MCP 認可フロー（新興・抽象境界の背後に）

```typescript
// ✅ MCP サーバーを Resource Server として OAuth 2.1 ベースで認可。§10（新興/ドラフト）
// 仕様変動に備え、MCP 認可の取得は専用モジュールに隔離する。
export async function getMcpToken(mcpServerUrl: string, delegated: { human: string; agent: string }) {
  // OBO 委任（§8）で短命・スコープ付きトークンを取得し、対象 MCP を audience に限定
  const token = await exchangeOnBehalfOf(delegated.human, delegated.agent);
  // resource indicator により当該 MCP サーバー以外への転用を防止（§10.1）
  return { authorization: `Bearer ${token}`, audience: mcpServerUrl };
}
```

### 16.5. GitHub Actions OIDC → クラウド短命ロール

```yaml
# ✅ GitHub Actions OIDC で静的キーなしにクラウドの短命ロールを引き受ける。§4.2 / §4.3
permissions:
  id-token: write   # OIDC トークン発行に必須
  contents: read
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: aws-actions/configure-aws-credentials@<commit-sha>  # §000 §19.3 SHA 固定
        with:
          role-to-assume: arn:aws:iam::123456789012:role/deploy-role
          aws-region: ap-northeast-1
          # クラウド側の信頼ポリシーで sub/aud をリポジトリ・ブランチに束縛（§4.1）:
          #   "token.actions.githubusercontent.com:sub": "repo:org/repo:ref:refs/heads/main"
          #   "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
```

---

## §17. アンチパターン集（20件）

> [!CAUTION]
> 以下はいずれも本ファイルで**禁止または重大リスク**。発見時は `000_security_privacy.md` の Zero Tolerance Protocol に従い即時是正する。

| # | アンチパターン | リスク | 正しい対応 |
|:--|:-------------|:------|:----------|
| 1 | サービスアカウントの長命静的キー（JSON/アクセスキー）を発行 | 漏洩で永続アクセス | WIF/OIDC で短命トークン（§4） |
| 2 | 複数サービス/エージェントで同一クレデンシャルを共有 | 影響範囲拡大・所有者不明 | 1主体=1アイデンティティ（§2.2, §7.2） |
| 3 | NHI に所有者を割り当てない | orphaned 検出不能・放置 | 全 NHI に人間の所有者（§2.2） |
| 4 | NHI/エージェントに `*`/`admin`/unscoped 権限 | 過剰権限・横移動 | audience/scope 最小化（§5.1, §7.2） |
| 5 | M2M に Authorization Code フローを流用 | フロー誤用・複雑化 | Client Credentials（§5.1） |
| 6 | APIキーを平文保存 | DB 漏洩で全キー流出 | プレフィックス+ハッシュ保存（§5.2） |
| 7 | 無期限・ローテーションなしの APIキー | 漏洩時に永続 | TTL+ローテーション+失効ログ（§5.2） |
| 8 | M2M トークンを bearer のまま（sender-constraint なし） | 盗難トークン再利用 | mTLS/DPoP 束縛（§5.1） |
| 9 | エージェントに standing（長命）クレデンシャル付与 | Tier-0 違反・常時攻撃面 | 短命・revocable 委任（§7.2） |
| 10 | エージェントが人間のセッション/トークンを流用 | 監査で人とエージェントを分離不能 | 別アイデンティティ+OBO（§7.1, §8） |
| 11 | impersonation で actor 情報を消す代理 | 「誰が実行したか」喪失 | delegation（`act` 保持）（§8.1） |
| 12 | OBO 委任で権限を拡大（アップスコープ） | privilege escalation | ダウンスコープ強制（§8.2） |
| 13 | Token Exchange に resource/audience を付けない | Confused Deputy・転用 | RFC 8707 で audience 限定（§8.2, §10） |
| 14 | 多段委任に深さ制限なし | 追跡不能・無限委任 | 委任深度上限（§9.1） |
| 15 | 委任ループ（A→B→A）を検知しない | 無限ループ・資源枯渇 | ループ検知+タイムアウト（§9.2） |
| 16 | MCP 認可を独自方式で自作 | 標準逸脱・脆弱性 | OAuth 2.1 ベース（§10.1） |
| 17 | 未承認/未検証の MCP サーバーに接続 | Tool Poisoning・権限昇格 | ホワイトリスト+署名検証（§10.2） |
| 18 | 委任チェーンを監査ログに残さない | インシデント追跡不能 | sub+act+audience を記録（§12.1） |
| 19 | SVID/証明書の信頼ドメイン・SPIFFE ID 未検証 | なりすましワークロード受理 | 許可リスト検証（§3.2） |
| 20 | WIF 信頼ポリシーで `sub` ワイルドカード/`aud` 無検証 | 任意リポジトリからのロール引受 | sub/aud をクレームで束縛（§4.1） |

---

## §18. 成熟度モデル L1–L5

| レベル | 状態 | 主な特徴 |
|:------|:-----|:---------|
| **L1: Ad-hoc** | 場当たり | 長命静的キー・共有クレデンシャル・所有者不明 NHI・APIキー平文保存。リスク高 |
| **L2: Basic** | 基本準拠 | NHI インベントリと所有者割当、APIキーのハッシュ保存+プレフィックス、M2M は Client Credentials + audience/scope 限定 |
| **L3: Hardened** | 堅牢化 | WIF/OIDC で静的キー廃止、短命クレデンシャル+自動更新、SPIFFE/mTLS、orphaned 自動検出、一括失効経路、エージェントは別アイデンティティ |
| **L4: Advanced** | 高度 | sender-constrained M2M（mTLS/DPoP）、OBO 委任（人+エージェント二重身元）、ダウンスコープ強制、委任深度制限+ループ防止、委任チェーン監査、MCP 認可（OAuth 2.1ベース） |
| **L5: Optimal** | 最適化 | Zero Standing Privilege（JIT 発行・自動失効）、Zero Trust 継続検証、XAA による IdP 一元仲介・全アクション監査、NHI/エージェント異常検知の自動対応（ITDR/SOAR 連動） |

-   **Action**: 自プロジェクトの現在地を評価し、最低 **L3** を目標とする。AIエージェントを本番運用する場合・金融/医療は **L4以上**を目標とする。

---

## Appendix A: 逆引き索引

> **使い方**: タスクに関連するキーワードで検索し、該当セクションを特定してください。

| キーワード | 該当セクション |
|:----------|:-------------|
| 非人間ID, NHI, ガバナンス, 棚卸し, 所有者 | §2 |
| orphaned, 一括失効, bulk revocation | §2.3 |
| ローテーション, APIキー, プレフィックス, ハッシュ保存 | §5.2 |
| SPIFFE, SPIRE, SVID, アテステーション | §3.1 |
| mTLS, サービスメッシュ, 信頼ドメイン | §3.2 |
| secretless, Zero Standing Privilege | §3.3, §6.2 |
| Workload Identity Federation, WIF | §4 |
| GCP WIF, AWS IAM Roles Anywhere, Azure | §4.2 |
| GitHub Actions OIDC, id-token, sub/aud 束縛 | §4.2, §4.3, §16.5 |
| M2M, Client Credentials, RFC 6749 | §5.1 |
| audience, scope, resource indicators, RFC 8707 | §5.1, §8.2, §10.1 |
| DPoP, mTLS, sender-constrained | §5.1 |
| 短命クレデンシャル, STS, TTL, 自動更新 | §6 |
| AIエージェント, 別アイデンティティ, Tier-0 | §7 |
| standing credential 禁止, unscoped 禁止, 共有禁止 | §7.2 |
| On-Behalf-Of, OBO, 二重身元, actor_token | §8 |
| Token Exchange, RFC 8693, act クレーム | §8, §16.3 |
| ダウンスコープ, アップスコープ禁止 | §8.2, §9.1 |
| 委任チェーン, 深さ制限, ループ防止 | §9 |
| MCP, Model Context Protocol, 認可 | §10 |
| Cross-App Access, XAA, IdP 仲介 | §11 |
| 監査, 追跡可能性, sub, act, 相関ID | §12 |
| 可観測性, 異常検知, ITDR | §13 |
| FinOps, トークン発行コスト, M2M 課金 | §14.1 |
| パフォーマンス, JWKS キャッシュ, スケーラビリティ | §14.2, §14.3 |
| Zero Trust, 継続的検証 | §15.1 |
| プライバシー, データ最小化, PII マスキング | §15.2, §12.2 |
| 実装スニペット | §16 |
| アンチパターン | §17 |
| 成熟度モデル, L1-L5 | §18 |
| 責任分界点, 410 vs 440 vs core §9 | §1.2 |

---

## Appendix B: クロスリファレンス

> **クロスリファレンス（関連ルールファイル）**:
> - [`security/000_security_privacy.md`](./000_security_privacy.md) — §3.2 非人間ID管理、§18 Agentic AI・MCP/A2A、§21 シークレットマネジメント、§25 監査ログ
> - [`core/000_core_mindset.md`](../core/000_core_mindset.md) — §9 Agentic AI 時代プロトコル（権限設計・自律度 L0–L4・委任成熟度・人間承認ゲート）
> - [`security/400_authentication_and_passkeys.md`](./400_authentication_and_passkeys.md) — 人間向け認証クレデンシャル・パスキー・MFA・IDaaS
> - [`security/410_federated_identity_and_oauth.md`](./410_federated_identity_and_oauth.md) — 人間向け OAuth 2.1 / OIDC・トークン管理・Token Exchange（§15.4）
> - [`security/420_step_up_auth_and_sensitive_operations.md`](./420_step_up_auth_and_sensitive_operations.md) — Step-Up 再認証・重要操作保護
> - [`security/430_*`](./) — （関連: 認証系隣接ルール）
> - [`engineering/500_firebase_gcp.md`](../engineering/500_firebase_gcp.md) — Workload Identity Federation・GCP IAM・SA の実装詳細（正本）
> - [`engineering/100_api_integration.md`](../engineering/100_api_integration.md) — 外部API連携・Webhook 署名検証・M2M トークン利用

### クロスリファレンス

| セクション | 関連ルール |
|-----------|------------|
| §1–§2（責任分界点・NHI ガバナンス） | `security/000_security_privacy` §3.2/§21, `core/000_core_mindset` §9 |
| §3–§4（ワークロード・WIF） | `engineering/500_firebase_gcp`, `security/000_security_privacy` §19.3 |
| §5–§6（M2M・短命クレデンシャル） | `security/410_federated_identity_and_oauth` §15.4, `engineering/100_api_integration` |
| §7–§9（エージェント・OBO・委任チェーン） | `core/000_core_mindset` §9.1/§9.6, `security/000_security_privacy` §18 |
| §10–§11（MCP・XAA） | `security/000_security_privacy` §18.3/§18.6 |
| §12–§15（監査・可観測性・Zero Trust・プライバシー） | `security/000_security_privacy` §25/§26/§2.4/§7 |

---
