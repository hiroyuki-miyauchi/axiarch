# 69. MCP セキュリティ (Model Context Protocol Security)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-06-09

> [!IMPORTANT]
> **Primary Directive（主要方針）**
> 「MCP は LLM に外部世界への手足を与える。ツール説明・ツール結果・リソースは**信頼できない入力**として扱い、トークンは**透過させず**、破壊的操作には**人間の承認**を挟め。」
> MCP（Model Context Protocol）を**使う側（host / client / エージェント）**と**作る側（server builder）**の双方は、本ファイルの最新安定版ベストプラクティスに準拠しなければならない。
> 認証・認可は `000_security_privacy.md` §1 の優先順位（Legal & Security > UX > Revenue > DX）に従う。

> [!NOTE]
> 本ファイルは `000_security_privacy.md` §18.3（MCPセキュリティ概要）・§18.6（Tool Poisoning）の**実装深掘り版**であり、**MCP に固有のセキュリティ実装の正本**です。
> 汎用 LLM 脅威（prompt injection・出力処理・excessive agency）は [`000_security_privacy.md`](./000_security_privacy.md) §17 が正本。
> MCP 認可の**認証/委任の技術詳細**（OAuth 2.1ベース・OBO・Resource Indicators）は [`440_workload_and_agent_identity.md`](./440_workload_and_agent_identity.md) §10/§11 が正本（本ファイルは MCP サーバー実装側のガードを深掘り）。
> AIエージェントの**権限設計・自律度・人間承認ゲート**は [`core/000_core_mindset.md`](../core/000_core_mindset.md) §9 が正本。

> [!NOTE]
> **標準の成熟度に関する注記**: RFC 8707（Resource Indicators）・RFC 9728（Protected Resource Metadata）・RFC 8414（AS Metadata）・RFC 7591（Dynamic Client Registration）・RFC 9449（DPoP）・RFC 6749（OAuth 2.0）は**安定した標準**である。
> 一方、**MCP 認可仕様は 2025 年に複数回改訂された新興領域**（2025-03-26 → 2025-06-18 → 2025-11-25）であり、**OAuth 2.1 は IETF ドラフト**（draft-ietf-oauth-v2-1）に基づく。本ファイル執筆時点の参照版は **MCP 仕様 2025-11-25**。MCP 認可は「安定版の OAuth 2.0 フロー（Authorization Code + PKCE）で実装し、OAuth 2.1（ドラフト）の方向性に追従する」立場を取り、**認可ロジックを抽象境界の背後に置いて仕様変動に追従できるようにする**。

---

## 目次

| § | セクション |
|---|---|
| 1 | [責任分界点とスコープ](#1-責任分界点とスコープ) |
| 2 | [MCP アーキテクチャと信頼境界（Host/Client/Server）](#2-mcp-アーキテクチャと信頼境界hostclientserver) |
| 3 | [トランスポートと脅威（stdio / Streamable HTTP）](#3-トランスポートと脅威stdio--streamable-http) |
| 4 | [作る側①: MCP 認可（OAuth 2.1 Resource Server）](#4-作る側-mcp-認可oauth-21-resource-server) |
| 5 | [作る側②: 入力バリデーションと間接プロンプトインジェクション](#5-作る側-入力バリデーションと間接プロンプトインジェクション) |
| 6 | [作る側③: ツール定義の健全性（annotations / output schema）](#6-作る側-ツール定義の健全性annotations--output-schema) |
| 7 | [作る側④: トランスポート安全（Origin/DNS リバインディング/セッション）](#7-作る側-トランスポート安全origindns-リバインディングセッション) |
| 8 | [作る側⑤: 実行隔離・最小権限・シークレット・監査](#8-作る側-実行隔離最小権限シークレット監査) |
| 9 | [作る側⑥: サプライチェーン（署名・rug pull・SBOM）](#9-作る側-サプライチェーン署名rug-pullsbom) |
| 10 | [使う側①: サーバー検証・許可リスト・信頼境界](#10-使う側-サーバー検証許可リスト信頼境界) |
| 11 | [使う側②: ツール定義のピン留めと rug pull / tool poisoning 検知](#11-使う側-ツール定義のピン留めと-rug-pull--tool-poisoning-検知) |
| 12 | [使う側③: 人間承認（HITL）・sampling / elicitation](#12-使う側-人間承認hitlsampling--elicitation) |
| 13 | [使う側④: 信頼しない前提とクレデンシャル規律](#13-使う側-信頼しない前提とクレデンシャル規律) |
| 14 | [可観測性・異常検知](#14-可観測性異常検知) |
| 15 | [FinOps・パフォーマンス・Zero Trust・プライバシー](#15-finopsパフォーマンスzero-trustプライバシー) |
| 16 | [実装スニペット集](#16-実装スニペット集) |
| 17 | [アンチパターン集（20件）](#17-アンチパターン集20件) |
| 18 | [成熟度モデル L1–L5](#18-成熟度モデル-l1l5) |
| A | [Appendix A: 逆引き索引](#appendix-a-逆引き索引) |
| B | [Appendix B: クロスリファレンス](#appendix-b-クロスリファレンス) |

---

## §1. 責任分界点とスコープ

> **参考規格**: MCP 仕様 2025-11-25（Authorization / Security Best Practices / Transports）, OAuth 2.1 (draft-ietf-oauth-v2-1), RFC 8707, RFC 9728

### 1.1. 本ファイルが扱う対象

-   **Rule 69.1.1**: 本ファイルは、**MCP（Model Context Protocol）に固有のセキュリティ実装**を扱う。具体的には MCP の Host/Client/Server 三者アーキテクチャ、トランスポート（stdio / Streamable HTTP）、MCP サーバー側の認可・入力検証・ツール定義健全性・トランスポート安全・実行隔離・サプライチェーン、および MCP クライアント/ホスト側のサーバー検証・ツールピン留め・人間承認である。
-   **Rule 69.1.2**: 「**作る側（server builder）**」と「**使う側（host/client/エージェント）**」の両面を網羅する。両者の責任分界（§2.3）を明確にし、片側だけの対策で安全と誤認しない。

### 1.2. 責任分界点（隣接ファイルとの境界）

-   **Rule 69.1.3**: 以下の責任分界点を遵守し、二重定義を避ける。クロスリファレンスは貼るが、各正本の本文を本ファイルで複製しない。

| ファイル | 正本とする範囲 |
|:--------|:--------------|
| `core/000_core_mindset.md` §9 | AIエージェントの**権限設計・自律度（L0–L4）・可逆性・人間承認ゲート**（設計思想） |
| `security/000_security_privacy.md` §17 | **汎用 LLM 脅威**（prompt injection / 出力処理 / excessive agency / unbounded consumption） |
| `security/000_security_privacy.md` §18.3/§18.6 | MCP/A2A・Tool Poisoning の**概要と全体方針** |
| `security/440_workload_and_agent_identity.md` §10/§11 | MCP 認可の**認証/委任の技術詳細**（OAuth 2.1ベース・OBO・XAA・トークンライフサイクル） |
| `security/410_*` | **人間向け** OAuth 2.1 / OIDC の技術詳細 |
| `security/430_*` | 認可・アクセス制御モデル（RBAC/ABAC/ReBAC）の正本 |
| **本ファイル `450`** | **MCP 固有のセキュリティ実装**（三者アーキ・トランスポート脅威・サーバー側ガード・ツールピン留め・HITL・サプライチェーン） |

-   **Rule 69.1.4**: 認可の「**誰の権限で何を委任するか**」（OBO・Resource Indicators・トークン TTL）は `440` §10 が正本。本ファイルは「**MCP サーバーが Resource Server としてどう実装し検証するか**」「**クライアント/ホストが何を信頼せず何を承認させるか**」を深掘りする。

### 1.3. 適用方針

-   **Law**: MCP 認可の独自方式実装は禁止する。検証済みの標準（OAuth 2.0 Authorization Code + PKCE、RFC 8707/9728/8414）と検証済みライブラリ/SDK を使用する。MCP 認可仕様は新興のため、抽象境界の背後に実装する（§1.0 NOTE）。
-   **Law**: 用語「MUST / MUST NOT / SHOULD / SHOULD NOT / MAY」は RFC 2119 / RFC 8174 の意味で用いる。誇張・「完全に防御できる」式の断定は用いない。MCP は防御の**層（defense in depth）**で守る。

---

## §2. MCP アーキテクチャと信頼境界（Host/Client/Server）

> **参考規格**: MCP 仕様 2025-11-25（Architecture）

### 2.1. 三者アーキテクチャ

-   **概要**: MCP は以下の三者で構成される。各々が異なる信頼境界を持つ。

| 役割 | 説明 | 主な責務 |
|:-----|:-----|:--------|
| **Host** | LLM を含むアプリケーション（例: IDE・チャットアプリ・エージェントランタイム） | ユーザー同意の取得・ポリシー適用・複数クライアントの統括・人間承認 UI |
| **Client** | Host 内で 1 つの Server と 1:1 接続するコネクタ | サーバー検証・トークン取得・ツール定義の取得とピン留め |
| **Server** | ツール・リソース・プロンプトを提供する外部プロセス/サービス | Resource Server 認可・入力検証・実行隔離・ツール定義の健全性 |

### 2.2. 信頼境界

-   **Law**: **Host ↔ Server 間は信頼境界**である。Server（およびその提供するツール説明・ツール結果・リソース）は、たとえ「承認済み」であっても**潜在的に敵対的**として扱う（§13.1）。
-   **Law**: Host は複数 Server を束ねる。**ある Server が別 Server のデータ/権限へアクセスする横移動（cross-server）を遮断**する。1 Client = 1 Server を原則とし、コンテキスト・トークン・セッションを Server 間で共有しない。

### 2.3. 作る側 / 使う側の責任分界

-   **Rule 69.2.1**: 「作る側」と「使う側」の責任を以下のとおり分界する（MUST）。**片側のみの対策で安全と誤認しない**。

| 観点 | 作る側（Server）の責務 | 使う側（Host/Client）の責務 |
|:-----|:----------------------|:---------------------------|
| 認可 | Resource Server として audience 検証・token passthrough 拒否（§4） | 最小スコープ要求・resource indicator 付与（§13） |
| 入力 | ツール入力の厳格バリデーション（§5） | ツール結果を信頼しない・再注入防御（§13.1） |
| ツール定義 | annotations 正確付与・hidden instruction 排除（§6） | 定義ハッシュピン・rug pull 検知（§11） |
| 破壊的操作 | destructiveHint 明示・確認 API 提供（§6） | 人間承認ゲート（HITL）（§12） |
| トランスポート | Origin 検証・localhost バインド・セッション規律（§7） | 接続先検証・SSRF 防御（§10） |
| 配布 | 署名・バージョン固定・SBOM（§9） | 許可リスト・署名検証・サンドボックス（§10） |

---

## §3. トランスポートと脅威（stdio / Streamable HTTP）

> **参考規格**: MCP 仕様 2025-11-25（Transports）

### 3.1. トランスポート別の脅威

-   **概要**: MCP は主に 2 つのトランスポートを持つ。各々で脅威モデルが異なる。

| トランスポート | 用途 | 主な脅威 | 既定の防御 |
|:--------------|:-----|:--------|:----------|
| **stdio** | ローカルプロセス（同一マシン） | 悪意ある起動コマンド・ローカル権限での任意コード実行・他プロセスからのアクセス | 起動コマンドの人間承認（§12）・サンドボックス・最小権限（§8） |
| **Streamable HTTP** | リモート/ネットワーク | DNS リバインディング・CSRF・セッションハイジャック・token passthrough・SSRF | Origin 検証・localhost バインド・非決定的セッションID・Bearer 認証（§7） |

-   **Law（認可とトランスポート）**: MCP 認可仕様は **HTTP ベーストランスポート向け**である。**stdio トランスポートはこの認可フローに従わず、環境（環境変数・OS の権限）からクレデンシャルを取得する**（MCP 仕様）。stdio に OAuth フローを無理に被せない。

### 3.2. ローカル MCP サーバーの危険

-   **Law**: ローカル（stdio）MCP サーバーは**ユーザーのマシン上で、MCP クライアントと同等の権限で動作**する。未検証ソースのローカルサーバーは、任意コード実行・データ持ち出し・データ損失の経路となる。
-   **Action**: ローカルサーバーは可能な限り **stdio に限定**してアクセスをクライアントのみに絞る。HTTP を使う場合は認可トークン要求または Unix ドメインソケット等の IPC で制限する。導入時の起動コマンドは§12 の人間承認に従う。

---

## §4. 作る側①: MCP 認可（OAuth 2.1 Resource Server）

> **参考規格**: MCP 仕様 2025-11-25（Authorization）, OAuth 2.1 (draft-13), RFC 8707, RFC 9728, RFC 8414, RFC 7591, RFC 9449 (DPoP)
>
> **注**: MCP 認可は新興。本節は MCP 仕様 2025-11-25 に基づく。委任（OBO）・トークン TTL の正本は `440` §10。

### 4.1. MCP サーバーは OAuth 2.1 Resource Server

-   **Law**: MCP サーバーは独自認可を避け、**OAuth 2.1 Resource Server** として実装する。認可は**安定版の OAuth 2.0 フロー（Authorization Code + PKCE / 適切な場合は Client Credentials）**で行い、OAuth 2.1（ドラフト）の方向性（PKCE 必須・Implicit/ROPC 廃止）に追従する。
-   **Rule 69.4.1**: MCP サーバーは **OAuth 2.0 Protected Resource Metadata（RFC 9728）**を実装し、`authorization_servers` を少なくとも 1 つ提供しなければならない（MUST）。未認証要求には `401` を返し、`WWW-Authenticate` ヘッダに `resource_metadata`（および可能なら `scope`）を含める（MUST/SHOULD）。
-   **Rule 69.4.2**: 認可サーバーは **RFC 8414（AS Metadata）または OIDC Discovery** のいずれかでメタデータを提供する（MUST）。クライアント登録は Client ID Metadata Documents（ドラフト）／事前登録／Dynamic Client Registration（RFC 7591、後方互換）から状況に応じて選ぶ。

### 4.2. audience 束縛（Resource Indicators / RFC 8707）

-   **Law**: トークンは**対象 MCP サーバー（audience）に束縛**しなければならない。クライアントは authorization/token 要求に **`resource` パラメータ（RFC 8707 Resource Indicators）を MUST で付与**し、対象 MCP サーバーの canonical URI を指定する。
-   **Rule 69.4.3**: MCP サーバーは、受領したアクセストークンが**自分自身を audience として明示的に発行されたものか**を検証しなければならない（MUST、RFC 9068 の `aud` クレーム等）。audience が自分でないトークン、期限切れ・無効トークンは **HTTP 401** で拒否する。
-   **Rule 69.4.4**: トークンは**毎リクエスト**で `Authorization: Bearer` ヘッダに含めて検証する（MUST）。**URL クエリ文字列にトークンを載せない**（MUST NOT）。**セッションID を認証に用いない**（§7.3）。

### 4.3. トークン透過（token passthrough）の禁止

-   **Law（MCP 仕様の明示禁止）**: MCP サーバーは、**自分宛に発行されたものでないトークンを受理してはならない**（MUST NOT）。上流 API を呼ぶ場合、MCP サーバーは**上流に対し別個の OAuth クライアント**として振る舞い、上流 AS が発行した**別トークン**を用いる。**MCP クライアントから受領したトークンをそのまま上流へ転送してはならない**（token passthrough の禁止、MUST NOT）。
-   **Rationale**: token passthrough は (a) レート制限・検証・監視等の**セキュリティ制御を迂回**し、(b) 下流ログ上で**実行主体の identity を偽装**し監査を破壊し、(c) **Confused Deputy** を誘発する。

### 4.4. Confused Deputy 防止（プロキシ型サーバー）

-   **Law**: 第三者 API へのプロキシとして動く MCP サーバー（static client ID + 動的登録 + 同意 Cookie の組合せ）は **Confused Deputy** の標的となる。**第三者認可へ転送する前に、クライアントごとの明示的同意（per-client consent）**を取得しなければならない（MUST）。
-   **Action**: ユーザー単位で承認済み `client_id` のレジストリを保持し、転送前に照合する。MCP レベルの同意画面はクライアント名・第三者スコープ・`redirect_uri` を明示し、CSRF 保護（`state`）とクリックジャッキング防御（`frame-ancestors`/`X-Frame-Options`）を施す。`redirect_uri` は**完全一致**で検証する（ワイルドカード禁止）。

### 4.5. スコープ最小化と per-tool 認可

-   **Law**: スコープは**段階的・最小権限（progressive least privilege）**で設計する。`scopes_supported` に全権限を列挙せず、初期は低リスク（discovery/read-only）に限り、特権操作の初回試行時に `WWW-Authenticate` の `scope` チャレンジで段階昇格させる（step-up）。
-   **Rule 69.4.5**: ワイルドカード/包括スコープ（`*` / `all` / `full-access`）を発行・要求してはならない（MUST NOT）。可能なら**ツール単位の認可**（per-tool scope）に分解し、破壊的ツールほど狭いスコープに束ねる。
-   **Rule 69.4.6**: トークンは sender-constrained 化（**DPoP / RFC 9449** または mTLS）を推奨する（SHOULD、高リスクは MUST）。盗難トークンの再利用を暗号的に阻止する。AS は短命トークン発行・refresh ローテーションを行う（`440` §6 と整合）。

---

## §5. 作る側②: 入力バリデーションと間接プロンプトインジェクション

> **参考規格**: `000_security_privacy.md` §17.1（Prompt Injection）, §17.10（出力処理）, OWASP LLM01/LLM05

### 5.1. ツール入力の厳格バリデーション

-   **Law**: MCP サーバーは、ツール呼び出しの入力を**スキーマ（JSON Schema 等）で厳格に検証**する。型・範囲・列挙・長さ・形式を強制し、未知フィールドを拒否（fail-closed）する。
-   **Rule 69.5.1**: ツール入力を**信頼できない外部入力**として扱い、インジェクション対策（SQL/コマンド/パス/SSRF/テンプレート）を施さなければならない（MUST）。LLM が生成したパラメータも例外なく検証対象とする（`000_security_privacy.md` §17.10 と整合）。
-   **Action**: ファイルパス・URL・コマンドはパラメータ化／許可リストで制限し、文字列連結によるシェル/SQL 実行を禁止する。出力（ツール結果）も**サニタイズ**してから返し、HTML/SQL/制御文字の意図せぬ実行を防ぐ。

### 5.2. 間接プロンプトインジェクション（コンテンツ経由）

-   **Law**: ツールが返す**外部コンテンツ（取得したファイル・Web ページ・DB レコード・リソース本文）**には、LLM への悪性命令が埋め込まれている前提で扱う（**間接プロンプトインジェクション**）。サーバーは攻撃文字列を生成・拡幅する経路にならないよう設計する。
-   **Rule 69.5.2**: ツール説明・リソース・プロンプトテンプレートに、第三者由来の文字列をそのまま埋め込む場合、**注入される前提**で出所を分離・ラベル付けし、可能なら無害化（命令的トークンの中和・引用化）する（SHOULD）。汎用の prompt injection 防御は `000_security_privacy.md` §17.1 を正本とする。
-   **Cross-Reference**: 防御の最終責任は使う側（§13.1）と分担する。サーバーは「攻撃の発射台にならない」、クライアントは「結果を信頼しない」の両輪。

---

## §6. 作る側③: ツール定義の健全性（annotations / output schema）

> **参考規格**: MCP 仕様 2025-11-25（Tools / Tool Annotations）, `000_security_privacy.md` §18.6

### 6.1. ツール annotations の正しい付与

-   **概要**: MCP のツール annotations は、ホストの UX 判断のためのヒントである。

| Annotation | 意味 | 既定値 |
|:-----------|:-----|:------|
| `readOnlyHint` | 状態を変更せず読み取りのみ | `false` |
| `destructiveHint` | データの変更/破壊を伴いうる | **`true`**（保守的） |
| `idempotentHint` | 再試行が安全（冪等） | `false` |
| `openWorldHint` | 外部世界と相互作用する | **`true`**（保守的） |

-   **Rule 69.6.1**: ツール annotations を**正確に**付与しなければならない（MUST）。読み取り専用ツールには `readOnlyHint: true`、破壊的ツールには `destructiveHint: true` を明示する。**annotation を省略すると、ホストは保守的に「破壊的・外部接続」とみなす**ため、過剰な確認摩擦を避けるには正確な付与が必要。
-   **Law（誇張しない）**: **annotations はあくまで情報的シグナルであり、セキュリティ上の強制保証ではない**（MCP 仕様）。サーバーは annotations に依存せず、§4 の認可・§5 の入力検証・§8 の実行隔離で**実際の権限を強制**する。クライアントも annotations を信頼しすぎない（§11.3）。

### 6.2. structured content / output schema

-   **Action**: ツールの戻り値は可能な限り **output schema（structured content）**を定義し、型付き構造で返す。自由形式テキストのみの返却は、間接インジェクション（§5.2）の温床になりやすい。
-   **Rule 69.6.2**: 破壊的ツールは、**説明文に破壊性を明示**し、可能なら「dry-run / 確認トークン」等の安全弁 API を提供する（SHOULD）。これによりクライアント側 HITL（§12）が機能しやすくなる。

### 6.3. hidden instruction の排除

-   **Law**: ツール名・ツール説明・パラメータ説明・リソース本文に、**LLM への隠し命令（hidden instructions）**を埋め込んではならない。自サーバーが Tool Poisoning（`000_security_privacy.md` §18.6）の発射台にならないよう、定義文をレビューする。
-   **Action**: ツール定義は機械可読でバージョン管理し、変更を監査する。動的に説明文を書き換える設計（後述の rug pull の温床）を避け、変更時は明示バージョンを上げる（§9.2）。

---

## §7. 作る側④: トランスポート安全（Origin/DNS リバインディング/セッション）

> **参考規格**: MCP 仕様 2025-11-25（Transports / Security Best Practices）, CVE-2025-9611, CVE-2025-49596

### 7.1. Origin 検証と DNS リバインディング対策

-   **Law**: Streamable HTTP トランスポートのサーバーは、**全受信接続で `Origin` ヘッダを検証**しなければならない（MUST）。`Origin` が存在し不正なら **HTTP 403 Forbidden** を返す（MUST）。これは **DNS リバインディング**（悪性 Web ページがブラウザ経由でローカル/イントラの MCP サーバーへ到達する攻撃）を遮断する中核防御。
-   **Rule 69.7.1**: ローカル開発用サーバーは **`localhost` / `127.0.0.1` / `::1` にのみバインド**し、`0.0.0.0` 等の全インターフェイス公開を避ける（MUST）。本番は明示的な `allowedOrigins` / Host 許可リストを構成する。
-   **Rationale**: Origin 未検証のローカルサーバーは、CSRF/DNS リバインディング（CVE-2025-9611 / CVE-2025-49596 等）で、ユーザーのブラウザを踏み台に侵害されうる。

### 7.2. セッションID を認証に使わない

-   **Law（MCP 仕様）**: 認可を実装する MCP サーバーは**全受信要求を検証**しなければならない（MUST）。**セッションを認証に用いてはならない**（MUST NOT）。認証は§4 のトークン検証で行う。
-   **Rule 69.7.2**: セッションID は**安全・非決定的**（暗号学的乱数の UUID 等）でなければならない（MUST）。推測可能・連番の ID を禁止する。セッションID は**ユーザー固有情報に束縛**（例: `<user_id>:<session_id>`、`user_id` はトークン由来でクライアント提供値でない）し、ローテーション/失効を設ける（SHOULD）。
-   **Rationale**: セッションハイジャック（推測した ID でのなりすまし、共有キューへの悪性イベント注入）を防ぐ。

---

## §8. 作る側⑤: 実行隔離・最小権限・シークレット・監査

> **参考規格**: MCP 仕様 2025-11-25（Local Server）, `core/000_core_mindset.md` §9, `000_security_privacy.md` §21/§25

### 8.1. ツール実行のサンドボックス化と最小権限

-   **Law**: ツール実行は**サンドボックス**（コンテナ/seccomp/chroot/アプリサンドボックス等）で隔離し、**最小権限**で動かす。ファイルシステム・ネットワーク・サブプロセスへのアクセスを既定で絞り、必要分のみ明示的に開放する。
-   **Rule 69.8.1**: MCP サーバーが外部リソース（DB・ファイル・外部 API）へアクセスする権限は、**読み取り専用を既定**とし、書き込み/破壊操作は明示的な許可リストでのみ解禁する（MUST、`core/000_core_mindset.md` §9 と整合）。

### 8.2. シークレット管理とレート制限

-   **Law**: サーバー内のシークレット（上流 API キー・DB クレデンシャル）は、ツール説明・ログ・エラー・ツール結果に**漏らさない**。シークレットマネージャ/環境分離で管理する（`000_security_privacy.md` §21 が正本）。
-   **Rule 69.8.2**: ツール呼び出しに**レート制限・タイムアウト・リソース上限**を設け、unbounded consumption（暴走・コスト爆発）を防ぐ（MUST、`000_security_privacy.md` §17.8 と整合）。

### 8.3. 不変監査ログ

-   **Rule 69.8.3**: 全ツール呼び出しを、**`tool_name` / `input`（PII マスキング後）/ `output_hash` / 認証主体（`sub`/`act`）/ `audience` / `timestamp`** を含む構造化ログで記録する（MUST）。ログは改ざん不能（追記専用）で保持する（`000_security_privacy.md` §25、`core/000_core_mindset.md` §9 の MCP Governance と整合）。

---

## §9. 作る側⑥: サプライチェーン（署名・rug pull・SBOM）

> **参考規格**: MCP 仕様 2025-11-25, `security/200_oss_compliance.md`（SBOM/依存）, CVE-2025-54136（rug pull）

### 9.1. 配布物の署名と検証可能性

-   **Law**: MCP サーバーの配布物（バイナリ/パッケージ/ツール定義）は**デジタル署名**し、利用側が**完全性を検証**できるようにする。署名なしの未検証サーバーを既定で導入させない。
-   **Rule 69.9.1**: ツール定義ファイル（JSON/YAML）に署名を付与し、起動時に改ざんを検証して、不一致なら起動を拒否する（SHOULD、`000_security_privacy.md` §18.6 と整合）。

### 9.2. rug pull（後発の悪性化）への配慮

-   **Law（rug pull）**: 「**承認時はクリーン、承認後に説明文/挙動を悪性化させる**」rug pull（CVE-2025-54136）の温床を作らない。ツール説明・コマンド・capability を**サイレント更新しない**。変更時は**明示バージョンを上げ、利用側の再承認を要求できる**よう設計する（SHOULD）。

### 9.3. 依存と SBOM

-   **Action**: MCP サーバー自身の依存関係は SBOM で管理し、既知脆弱性・ライセンスを監査する。詳細は [`security/200_oss_compliance.md`](./200_oss_compliance.md) を正本とする（本ファイルからの連携）。

---

## §10. 使う側①: サーバー検証・許可リスト・信頼境界

> **参考規格**: MCP 仕様 2025-11-25, `000_security_privacy.md` §18.3, `core/000_core_mindset.md` §9

### 10.1. サーバーの vetting と許可リスト

-   **Law**: ホスト/クライアントは、接続先 MCP サーバーを**正式なセキュリティ評価（vetting）**にかけ、**承認済みホワイトリスト（allowlist）**に限定して接続する（`000_security_privacy.md` §18.3 と整合）。任意のサーバーへ無検証で接続しない。
-   **Rule 69.10.1**: ローカル（stdio）サーバーの**ワンクリック導入**を提供するクライアントは、実行前に**起動コマンドの全文（引数含む・省略なし）を提示**し、明示的なユーザー承認を得なければならない（MUST、§12）。`sudo`/`rm -rf`/ネットワーク操作/ホームディレクトリ・SSH 鍵アクセス等の危険パターンを警告表示する。

### 10.2. クライアント側 SSRF 防御（メタデータ取得）

-   **Law**: クライアントは OAuth メタデータ探索で、悪性 MCP サーバーが指す URL（`resource_metadata` / `authorization_servers` / 各エンドポイント）を**そのまま辿らない**。SSRF 防御を施す。
-   **Rule 69.10.2**: 本番ではメタデータ取得 URL を **HTTPS 必須**とし、**プライベート/予約 IP レンジ**（`10/8`・`172.16/12`・`192.168/16`・`127/8`・`169.254/16`（クラウドメタデータ）・`fc00::/7`・`fe80::/10`）への要求をブロックする（SHOULD）。IP 検証は自作せず実績あるライブラリ/egress プロキシ（例: Smokescreen）を使い、DNS リバインディング（TOCTOU）に注意する。

### 10.3. 未検証サーバーの隔離

-   **Rule 69.10.3**: 未検証/低信頼サーバーは**サンドボックス/分離環境**で動かし、信頼済みサーバー・ホスト本体・他サーバーのコンテキストから隔離する（SHOULD、§2.2 の cross-server 遮断と整合）。

---

## §11. 使う側②: ツール定義のピン留めと rug pull / tool poisoning 検知

> **参考規格**: MCP 仕様 2025-11-25, `000_security_privacy.md` §18.6, CVE-2025-54136

### 11.1. ツール定義のハッシュピン留め

-   **Law**: クライアントは、初回承認時に取得したツール定義（ツール名・説明・パラメータ説明・annotations）を**コンテンツハッシュでピン留め**する。サーバー名だけでなく**バージョン + 内容ハッシュ**で固定する。
-   **Rule 69.11.1**: 起動時/再接続時に、取得したツール定義のハッシュをピンと照合し、**不一致を検知したら自動実行を止めて再承認を要求**しなければならない（MUST）。これが **rug pull**（承認後のサイレント悪性化）の主防御。

### 11.2. tool poisoning（隠し命令）検知

-   **Law**: ツール説明・パラメータ説明に埋め込まれた**隠し命令（tool poisoning）**を前提に、定義文を**人間がレビュー**する。AI による定義レビューは不十分（被攻撃対象と同一）であり、人間レビューを併用する（`000_security_privacy.md` §18.6 と整合）。
-   **Action**: tool shadowing（同名ツールの差し替え）にも備え、複数サーバーが提供する同名/類似ツールの衝突を検知・警告する。

### 11.3. annotations を過信しない

-   **Rule 69.11.2**: クライアントは、サーバーが申告した annotations（`readOnlyHint` 等）を**強制保証として信頼してはならない**（MUST NOT）。annotations は UX ヒントに過ぎず（§6.1）、実際の破壊性は**サーバー側の認可・ホスト側の HITL**（§12）で別途担保する。

---

## §12. 使う側③: 人間承認（HITL）・sampling / elicitation

> **参考規格**: MCP 仕様 2025-11-25（Sampling / Elicitation）, `core/000_core_mindset.md` §9.2/§9.5/§9.11

### 12.1. 破壊的・高権限ツールの人間承認

-   **Law**: 破壊的・高権限・不可逆なツール呼び出しは、**実行前に人間の明示的承認（Human-in-the-Loop）**を得る。可逆性優先（`core/000_core_mindset.md` §9.2）に従い、元に戻せない操作ほど承認ゲートを強くする。
-   **Rule 69.12.1**: ホストの承認 UI は、**実行されるツール名・引数・対象リソース・想定影響**を省略なく提示しなければならない（MUST）。承認の正本（自律度 L0–L4・承認要件）は `core/000_core_mindset.md` §9 とする。

### 12.2. UI 偽装（line-of-death）対策

-   **Law**: 承認 UI は、ツール結果やサーバー由来の文字列が**承認ダイアログを偽装/上書き（UI redress / line-of-death 越え）**できないよう、信頼境界（ホストネイティブ UI）で描画する。クリックジャッキング（iframe 埋め込み）を `frame-ancestors`/`X-Frame-Options` で防ぐ。
-   **Rule 69.12.2**: 承認対象の表示テキストは、サーバー由来の命令的文字列を**そのまま実行可能な形で表示しない**（無害化/引用化）。「承認した気にさせる」誘導を構造的に排除する。

### 12.3. sampling / elicitation の承認

-   **Law（sampling）**: MCP の **sampling**（サーバーがクライアント経由で LLM 推論を要求する機能）は、サーバーがユーザーの LLM を**間接利用**する経路である。ホストは sampling 要求に**人間承認**を挟み、プロンプト内容・モデル・コストを可視化する（SHOULD）。無制限の sampling を許可しない。
-   **Law（elicitation）**: MCP の **elicitation**（サーバーがユーザーへ追加入力を要求する機能）は、フィッシング的に機密情報を聞き出す経路となりうる。ホストは elicitation 要求の**出所（どのサーバーか）を明示**し、機密情報の入力に対し警告/承認を挟む（SHOULD）。
-   **Rule 69.12.3**: sampling / elicitation は**信頼境界をまたぐ要求**として扱い、承認・スコープ・監査の対象に含めなければならない（MUST）。

---

## §13. 使う側④: 信頼しない前提とクレデンシャル規律

> **参考規格**: `000_security_privacy.md` §17.1, `440` §10, MCP 仕様 2025-11-25

### 13.1. ツール説明・ツール結果・リソースを信頼しない

-   **Law**: クライアント/ホストは、**ツール説明・ツール結果・リソース本文を「信頼できない入力」**として扱う。これらに含まれうる間接プロンプトインジェクション（§5.2）を前提に、LLM へ渡す際は出所分離・ラベル付け・命令中和を行う（汎用防御は `000_security_privacy.md` §17.1 が正本）。
-   **Rule 69.13.1**: ツール結果を**そのまま次のツール呼び出しの引数や高権限操作のトリガにしない**（MUST）。結果由来のアクションは、可逆性・権限に応じて HITL（§12）を経由させる。

### 13.2. クレデンシャル規律（サーバーへ渡さない）

-   **Law**: クライアントは、**MCP サーバーへ、そのサーバーの AS が発行したトークン以外を送ってはならない**（MUST NOT、MCP 仕様）。最小スコープ・対象サーバーへの **`resource` indicator 付与**（§4.2）を徹底する。
-   **Rule 69.13.2**: 人間の代理として動く場合、サーバーへ渡るデータ・トークンは**目的内・最小限**に限定し、二重身元（人 + エージェント）の OBO 委任に従う（正本は `440` §8/§10）。ユーザーの長命トークン・パスワードをサーバーへ流用しない。

---

## §14. 可観測性・異常検知

### 14.1. ツール呼び出しの監査と異常検知

-   **Action**: MCP サーバー/クライアントごとに、ツール呼び出しの正常パターン（頻度・対象ツール・引数分布・時間帯）をベースライン化し、逸脱を検知する（`000_security_privacy.md` §3.3 ITDR と連携）。
-   **計測対象**:
    -   ツール定義ハッシュの変化（rug pull 検知発火）、annotations の変更。
    -   token passthrough 試行、audience 不一致による拒否、未承認サーバーへの接続試行。
    -   sampling / elicitation の発火数・コスト、破壊的ツールの承認/拒否率。
    -   Origin 検証失敗（DNS リバインディング兆候）、セッションID 異常（ハイジャック兆候）。

### 14.2. 自動対応

-   **Action**: 高リスクイベント（ツール定義改ざん検知・token passthrough・未承認サーバー接続）に対し、当該サーバーの接続遮断・トークン失効・所有者通知を行う自動ワークフロー（SOAR連携）を構築する。

---

## §15. FinOps・パフォーマンス・Zero Trust・プライバシー

### 15.1. FinOps（ツール呼び出し / sampling コスト）

-   **Action**: ツール呼び出しと **sampling**（サーバー起点の LLM 推論）はトークン/API コストを発生させる。サーバー/ツール単位でコストを計測し、暴走を予算ガード（`core/000_core_mindset.md` §9.10）で抑制する。sampling の無制限許可は FinOps 上もリスク。

### 15.2. パフォーマンス

-   **Action**: トークン検証はホットパス。JWKS キャッシュ（`410` §6.3 / `440` §14.2 と同方針）でレイテンシを抑える。ツール定義ハッシュ照合は接続時に行い、毎呼び出しの同期コストを避ける。

### 15.3. Zero Trust

-   **Law**: トークン保持＝信頼ではない。MCP サーバーへのアクセスは、毎リクエストで audience/scope/sender-constraint/コンテキストで都度検証する（NIST SP 800-207, `440` §15.1）。ツール結果・サーバー由来コンテンツも都度「信頼しない」前提で扱う（§13.1）。

### 15.4. プライバシー

-   **Action**: ツールへ渡すデータは**目的内・最小限**に限定する（`000_security_privacy.md` §7.2 データ最小化）。ツール入力/結果/監査ログ内の PII はマスキングし、外部サーバーへの不要な PII 送信を遮断する。

---

## §16. 実装スニペット集

> [!NOTE]
> スニペットは最新安定版ライブラリ前提の最小例で、特定スタックは**代表例**に過ぎない。本番では例外処理・タイムアウト・監査ログを付加すること。MCP 認可は新興のため、認可ロジックは抽象境界の背後に置く（§1.0 NOTE）。

### 16.1. MCP サーバー: audience 検証と token passthrough 拒否（Resource Server）

```typescript
// ✅ MCP サーバーは「自分宛に発行されたトークン」のみ受理。token passthrough 禁止。§4.2 / §4.3
import { createRemoteJWKSet, jwtVerify } from 'jose';

const AS_JWKS = createRemoteJWKSet(new URL('https://as.example.com/.well-known/jwks.json'));
const THIS_MCP_SERVER = 'https://mcp.example.com/mcp'; // 自身の canonical URI（RFC 8707 audience）

export async function authorizeMcpRequest(authHeader: string | undefined) {
  if (!authHeader?.startsWith('Bearer ')) {
    // §4.1: 401 + WWW-Authenticate(resource_metadata) を返す
    throw new Http401('Bearer required', { resource_metadata: `${THIS_MCP_SERVER}/.well-known/oauth-protected-resource` });
  }
  const token = authHeader.slice('Bearer '.length);
  const { payload } = await jwtVerify(token, AS_JWKS, {
    audience: THIS_MCP_SERVER,          // §4.2: 自分が audience のトークンのみ（RFC 8707/9068）
    algorithms: ['RS256', 'ES256'],     // alg ホワイトリスト
  });
  // §4.3: 上流APIを呼ぶ場合でも、このトークンを転送しない（別トークンを取得する）
  return payload; // sub/scope を以降の認可判断に使用
}
```

### 16.2. MCP サーバー: Origin 検証ミドルウェア（DNS リバインディング対策）

```typescript
// ✅ Streamable HTTP の Origin 検証 + localhost バインド。§7.1
const ALLOWED_ORIGINS = new Set(['https://app.example.com']); // 本番は明示許可リスト

export function originGuard(req, res, next) {
  const origin = req.headers['origin'];
  // Origin が存在し許可外なら 403（DNS リバインディング遮断）
  if (origin !== undefined && !ALLOWED_ORIGINS.has(origin)) {
    return res.status(403).send('Forbidden: invalid Origin'); // §7.1 MUST
  }
  next();
}
// 起動時: ローカル開発は 127.0.0.1 にバインド（0.0.0.0 で全公開しない）。§7.1
// server.listen({ host: '127.0.0.1', port: 3333 });
```

### 16.3. MCP サーバー: ツール入力スキーマ検証（fail-closed）

```typescript
// ✅ ツール入力を JSON Schema 相当で厳格検証。未知フィールド拒否・インジェクション対策。§5.1
import { z } from 'zod';

const ReadFileInput = z.object({
  path: z.string().min(1).max(1024),
}).strict(); // .strict() = 未知フィールド拒否（fail-closed）

const ALLOWED_ROOT = '/srv/data/'; // 許可ディレクトリに限定

export function handleReadFile(raw: unknown) {
  const { path } = ReadFileInput.parse(raw); // 型/長さ違反は例外
  const resolved = require('node:path').resolve(ALLOWED_ROOT, path);
  if (!resolved.startsWith(ALLOWED_ROOT)) {
    throw new Error('path traversal blocked'); // §5.1 パストラバーサル防御
  }
  // 結果も返却前にサニタイズ（§5.1）。シークレットを混入させない（§8.2）。
  return readSanitized(resolved);
}
```

### 16.4. MCP クライアント: ツール定義ハッシュピンによる rug pull 検知

```typescript
// ✅ 初回承認時のツール定義をハッシュでピン留め。不一致なら再承認要求。§11.1
import { createHash } from 'node:crypto';

function toolDefHash(tools: unknown): string {
  // ツール名・説明・パラメータ説明・annotations を正規化してハッシュ化
  return createHash('sha256').update(JSON.stringify(tools)).digest('hex');
}

// 承認時に保存した pin（content hash + version）
const pinned = { version: '1.2.0', hash: 'abc123...' };

export function verifyToolDefinitions(serverVersion: string, currentTools: unknown) {
  const current = toolDefHash(currentTools);
  if (serverVersion !== pinned.version || current !== pinned.hash) {
    // rug pull / tool poisoning の可能性 → 自動実行を停止し再承認へ（§11.1）
    throw new Error('tool definitions changed since approval — re-consent required');
  }
  // annotations は強制保証として信頼しない（§11.3）。破壊性は HITL で別途担保（§12）。
}
```

---

## §17. アンチパターン集（20件）

> [!CAUTION]
> 以下はいずれも本ファイルで**禁止または重大リスク**。発見時は `000_security_privacy.md` の Zero Tolerance Protocol に従い即時是正する。

| # | アンチパターン | リスク | 正しい対応 |
|:--|:-------------|:------|:----------|
| 1 | token passthrough（受領トークンを上流へそのまま転送） | Confused Deputy・監査破壊・制御迂回 | 別トークン取得・転送禁止（§4.3） |
| 2 | MCP サーバーが audience 未検証でトークン受理 | 他サービス用トークンの転用 | 自分が audience のトークンのみ受理（§4.2） |
| 3 | Origin 未検証の Streamable HTTP サーバー | DNS リバインディング・CSRF | Origin 検証 + 403（§7.1） |
| 4 | ローカルサーバーを `0.0.0.0` で全公開 | ローカルサーバー侵害 | localhost バインド（§7.1） |
| 5 | セッションID を認証に使用 | セッションハイジャック | セッションで認証しない・毎回トークン検証（§7.2） |
| 6 | 推測可能/連番のセッションID | ID 推測でなりすまし | 非決定的 ID + user 束縛（§7.2） |
| 7 | ツール説明・結果・リソースを信頼する | 間接プロンプトインジェクション | 信頼しない入力として扱う（§5.2, §13.1） |
| 8 | ツール入力をスキーマ検証しない | インジェクション・パストラバーサル | 厳格スキーマ + fail-closed（§5.1） |
| 9 | annotations を強制保証として信頼 | 破壊的ツールの無確認実行 | annotations は UX ヒント・HITL で担保（§6.1, §11.3） |
| 10 | annotations 未付与/不正確 | 過剰摩擦 or 危険ツールの誤分類 | 正確な annotations 付与（§6.1） |
| 11 | 破壊的ツールに人間承認なし | 不可逆操作の暴発 | HITL 承認ゲート（§12.1） |
| 12 | 承認 UI をサーバー由来文字列で偽装可能 | line-of-death 越え・誘導承認 | ホストネイティブ UI + 無害化（§12.2） |
| 13 | sampling / elicitation を無制限許可 | 間接 LLM 乱用・機密聞き出し・コスト爆発 | 承認・スコープ・監査の対象化（§12.3） |
| 14 | 未承認/未検証 MCP サーバーへ接続 | 悪性サーバー・Tool Poisoning | 許可リスト + vetting（§10.1） |
| 15 | ツール定義をハッシュピンしない | rug pull（承認後の悪性化）検知不能 | 内容ハッシュ + バージョンでピン（§11.1） |
| 16 | ワンクリックでローカルサーバー起動コマンドを無確認実行 | 任意コード実行 | 起動コマンド全文提示 + 承認（§10.1） |
| 17 | クライアントがメタデータ URL を無検証で辿る | SSRF（クラウドメタデータ等） | HTTPS 必須 + プライベート IP ブロック（§10.2） |
| 18 | ワイルドカード/包括スコープ（`*`/`all`） | 過剰権限・横移動 | 段階的最小スコープ・per-tool（§4.5） |
| 19 | ツール実行をサンドボックス化しない | 任意コード実行・データ損失 | サンドボックス + 最小権限（§8.1） |
| 20 | 未署名サーバー/ツール定義を無検証導入 | サプライチェーン汚染・rug pull | 署名検証 + バージョン固定（§9.1, §9.2） |

---

## §18. 成熟度モデル L1–L5

| レベル | 状態 | 主な特徴 |
|:------|:-----|:---------|
| **L1: Ad-hoc** | 場当たり | 任意サーバーへ無検証接続・token passthrough・Origin/入力検証なし・ツール結果を盲信・破壊的ツールに承認なし。リスク高 |
| **L2: Basic** | 基本準拠 | 承認済みサーバー許可リスト、ツール入力スキーマ検証、破壊的ツールに HITL、MCP サーバーは audience 検証する Resource Server |
| **L3: Hardened** | 堅牢化 | token passthrough 禁止徹底、Origin 検証 + localhost バインド、セッションを認証に使わない、ツール定義ハッシュピン（rug pull 検知）、annotations 正確付与、ツール実行サンドボックス |
| **L4: Advanced** | 高度 | 段階的最小スコープ + per-tool 認可、sender-constrained トークン（DPoP/mTLS）、Confused Deputy 防止（per-client consent）、sampling/elicitation の承認・監査、クライアント側 SSRF 防御、配布物署名検証 |
| **L5: Optimal** | 最適化 | Zero Trust 継続検証、cross-server 横移動の構造的遮断、不変監査ログ + ツール呼び出し異常検知の自動対応（ITDR/SOAR）、サプライチェーン全体の SBOM + バージョン固定 + rug pull 自動検知、FinOps 予算ガード |

-   **Action**: 自プロジェクトの現在地を評価し、最低 **L3** を目標とする。MCP サーバーを公開する/本番でエージェントに MCP を使わせる場合・金融/医療は **L4以上**を目標とする。

---

## Appendix A: 逆引き索引

> **使い方**: タスクに関連するキーワードで検索し、該当セクションを特定してください。

| キーワード | 該当セクション |
|:----------|:-------------|
| MCP, Model Context Protocol, アーキテクチャ, 信頼境界 | §2 |
| Host, Client, Server, 三者, 責任分界 | §2.1, §2.3 |
| トランスポート, stdio, Streamable HTTP, 脅威 | §3 |
| ローカルサーバー, 起動コマンド, 任意コード実行 | §3.2, §10.1 |
| MCP 認可, Resource Server, OAuth 2.1, Protected Resource Metadata, RFC 9728 | §4.1 |
| audience, Resource Indicators, RFC 8707, canonical URI | §4.2 |
| token passthrough, トークン透過, 転送禁止 | §4.3, §16.1 |
| Confused Deputy, per-client consent, プロキシ | §4.4 |
| スコープ最小化, per-tool, step-up, DPoP | §4.5, §4.6 |
| 入力バリデーション, スキーマ, インジェクション | §5.1, §16.3 |
| 間接プロンプトインジェクション, ツール結果 | §5.2, §13.1 |
| ツール annotations, readOnlyHint, destructiveHint, idempotentHint, openWorldHint | §6.1 |
| output schema, structured content, 破壊的ツール | §6.2 |
| hidden instruction, ツール定義健全性 | §6.3 |
| Origin 検証, DNS リバインディング, localhost バインド | §7.1, §16.2 |
| セッションID, セッションハイジャック, 認証に使わない | §7.2 |
| サンドボックス, 最小権限, 実行隔離 | §8.1 |
| シークレット, レート制限, 監査ログ | §8.2, §8.3 |
| サプライチェーン, 署名, rug pull, CVE-2025-54136, SBOM | §9 |
| サーバー検証, vetting, 許可リスト, allowlist | §10.1 |
| SSRF, メタデータ取得, プライベート IP ブロック | §10.2 |
| ツール定義ピン留め, ハッシュ, rug pull 検知 | §11.1, §16.4 |
| tool poisoning, 隠し命令, tool shadowing | §11.2 |
| annotations を過信しない | §11.3 |
| 人間承認, HITL, 破壊的操作 | §12.1 |
| UI 偽装, line-of-death, クリックジャッキング | §12.2 |
| sampling, elicitation, 承認 | §12.3 |
| 信頼しない入力, クレデンシャル規律 | §13 |
| 可観測性, 異常検知, ITDR | §14 |
| FinOps, sampling コスト, パフォーマンス | §15.1, §15.2 |
| Zero Trust, プライバシー, データ最小化 | §15.3, §15.4 |
| 実装スニペット | §16 |
| アンチパターン | §17 |
| 成熟度モデル, L1-L5 | §18 |
| 責任分界点, 440 vs 450 vs 000 §17 | §1.2 |

---

## Appendix B: クロスリファレンス

> **クロスリファレンス（関連ルールファイル）**:
> - [`security/000_security_privacy.md`](./000_security_privacy.md) — §17 AI/LLMセキュリティ（prompt injection・出力処理・excessive agency・unbounded consumption）、§18.3 MCPセキュリティ概要、§18.6 Tool Poisoning、§21 シークレット、§25 監査ログ
> - [`security/440_workload_and_agent_identity.md`](./440_workload_and_agent_identity.md) — §10 MCP 認可（OAuth 2.1ベース）、§11 XAA、§7 エージェント Tier-0、§8 OBO 委任（認証/委任の正本）
> - [`security/410_federated_identity_and_oauth.md`](./410_federated_identity_and_oauth.md) — OAuth 2.1 / OIDC・トークン管理・PKCE（正本）
> - [`security/430_authorization_and_access_control.md`](./430_authorization_and_access_control.md) — 認可・アクセス制御モデル（RBAC/ABAC/ReBAC、正本）
> - [`security/200_oss_compliance.md`](./200_oss_compliance.md) — SBOM・依存脆弱性・ライセンス（サプライチェーンの正本）
> - [`core/000_core_mindset.md`](../core/000_core_mindset.md) — §9 Agentic AI 時代プロトコル（権限設計・自律度 L0–L4・可逆性・人間承認ゲート・MCP Governance）
> - [`engineering/100_api_integration.md`](../engineering/100_api_integration.md) — 外部API連携・Webhook 署名検証

### クロスリファレンス

| セクション | 関連ルール |
|-----------|------------|
| §1–§3（責任分界点・アーキ・トランスポート） | `security/000_security_privacy` §18.3, `core/000_core_mindset` §9 |
| §4（MCP 認可・Resource Server） | `security/440` §10, `security/410`, `security/430` |
| §5（入力・間接インジェクション） | `security/000_security_privacy` §17.1/§17.10 |
| §6（ツール定義健全性） | `security/000_security_privacy` §18.6 |
| §7（トランスポート安全） | `security/000_security_privacy` §19（境界防御） |
| §8（実行隔離・監査） | `core/000_core_mindset` §9, `security/000_security_privacy` §21/§25 |
| §9（サプライチェーン） | `security/200_oss_compliance`, `security/000_security_privacy` §18.6 |
| §10–§13（使う側: 検証・ピン留め・HITL・信頼しない） | `core/000_core_mindset` §9.2/§9.5, `security/000_security_privacy` §17.1/§18.3, `security/440` §8/§10 |
| §14–§15（可観測性・FinOps・Zero Trust・プライバシー） | `core/000_core_mindset` §9.10, `security/000_security_privacy` §3.3/§7, `security/440` §13/§15 |

---
