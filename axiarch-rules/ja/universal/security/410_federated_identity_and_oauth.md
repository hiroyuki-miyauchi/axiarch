# 65. フェデレーテッドID & OAuth/OIDC (Federated Identity & OAuth/OIDC)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-06-09

> [!IMPORTANT]
> **Primary Directive（主要方針）**
> 「外部IDの委任は信頼の委譲である — トークンは奪われる前提で設計せよ。」
> フェデレーテッドID・OAuth・OIDC・ソーシャルログイン・エンタープライズSSOの実装は、
> 本ファイルの最新安定版ベストプラクティスに準拠しなければならない。
> **Deprecated（Implicit Flow / ROPC / サードパーティCookie依存）の新規採用は禁止。**
> 認証・認可は `000_security_privacy.md` §1 の優先順位（Legal & Security > UX > Revenue > DX）に従う。

> [!NOTE]
> 本ファイルは `000_security_privacy.md` の §3.5（IDフェデレーション&SSO）・§4.4（Social Login）・§4.10（OAuth 2.1 & DPoP）の**深掘り版**です。
> 概要は 000 を、実装詳細は本ファイルを参照してください。Step-Up（再認証）は `420_step_up_auth_and_sensitive_operations.md` に分離しています。

---

## 目次

| § | セクション |
|---|---|
| 1 | [責任分界点とアーキテクチャ基礎](#1-責任分界点とアーキテクチャ基礎) |
| 2 | [OAuth 2.1 中核プロトコル](#2-oauth-21-中核プロトコル) |
| 3 | [PKCE / state / nonce](#3-pkce--state--nonce) |
| 4 | [OIDC（OpenID Connect）](#4-oidcopenid-connect) |
| 5 | [ID Token 検証](#5-id-token-検証) |
| 6 | [JWKS・署名鍵・ローテーション](#6-jwks署名鍵ローテーション) |
| 7 | [ソーシャルログイン（Google / Apple / Microsoft / GitHub）](#7-ソーシャルログインgoogle--apple--microsoft--github) |
| 8 | [アカウントリンク・乗っ取り防止](#8-アカウントリンク乗っ取り防止) |
| 9 | [エンタープライズSSO（SAML 2.0 / OIDC）](#9-エンタープライズssosaml-20--oidc) |
| 10 | [JIT プロビジョニング & SCIM](#10-jit-プロビジョニング--scim) |
| 11 | [トークン管理・有効期限・失効](#11-トークン管理有効期限失効) |
| 12 | [リフレッシュトークンローテーション & 再利用検知](#12-リフレッシュトークンローテーション--再利用検知) |
| 13 | [Sender-Constrained Tokens（DPoP / mTLS）](#13-sender-constrained-tokensdpop--mtls) |
| 14 | [トークン保管・BFFパターン（SPA/モバイル）](#14-トークン保管bffパターンspaモバイル) |
| 15 | [高度プロトコル（PAR / RAR / JAR / JARM / Token Exchange）](#15-高度プロトコルpar--rar--jar--jarm--token-exchange) |
| 16 | [FedCM（サードパーティCookie廃止対応）](#16-fedcmサードパーティcookie廃止対応) |
| 17 | [ログアウト・セッション同期](#17-ログアウトセッション同期) |
| 18 | [Verifiable Credentials / SD-JWT / OID4VCI（将来動向）](#18-verifiable-credentials--sd-jwt--oid4vci将来動向) |
| 19 | [可観測性・FinOps・パフォーマンス・Zero Trust・プライバシー](#19-可観測性finopsパフォーマンスzero-trustプライバシー) |
| 20 | [実装スニペット集](#20-実装スニペット集) |
| 21 | [アンチパターン集](#21-アンチパターン集) |
| 22 | [成熟度モデル L1–L5](#22-成熟度モデル-l1l5) |
| A | [Appendix A: 逆引き索引](#appendix-a-逆引き索引) |
| B | [Appendix B: クロスリファレンス](#appendix-b-クロスリファレンス) |

---

## §1. 責任分界点とアーキテクチャ基礎

> **参考規格**: OAuth 2.1 (draft-ietf-oauth-v2-1), OpenID Connect Core 1.0, RFC 6749, RFC 9700 (OAuth Security BCP)

### 1.1. ロール定義と責任分界点

-   **Rule 65.1.1**: フェデレーテッドID構成における各ロールの責任範囲を設計時に明文化する。境界が曖昧なまま実装してはならない。

| ロール | 責任 | 主体例 |
|:------|:-----|:------|
| **Resource Owner** | リソースへのアクセスを認可する主体 | エンドユーザー |
| **Client (RP: Relying Party)** | トークンを要求し利用するアプリ | あなたのWeb/モバイルアプリ |
| **Authorization Server (AS)** | 認証・同意・トークン発行 | Google / Auth0 / Cognito / Keycloak |
| **Resource Server (RS)** | アクセストークンを検証しAPIを提供 | あなたのAPIバックエンド |
| **Identity Provider (IdP)** | ユーザー認証とアイデンティティ提供 | Google / Apple / Entra ID / Okta |

-   **Rule 65.1.2**: AS と RS が論理的に分離している場合、RS は**必ず audience（`aud`）検証**でトークンが自分宛てかを確認する（§5.2）。
-   **Rule 65.1.3**: IdP・AS・RS のどれが侵害されても影響範囲が局所化するよう、Defense in Depth を適用する（`000_security_privacy.md` §1.3）。

### 1.2. クライアント種別

-   **Confidential Client**: `client_secret` を安全に保持できるサーバーサイドアプリ。
-   **Public Client**: SPA・モバイル・デスクトップなど secret を秘匿できないクライアント。**PKCE 必須**（§3）。
-   **Rule 65.2.1**: Public Client に `client_secret` をバンドルしてはならない（バイナリ/JSバンドルから抽出可能なため無意味）。
-   **Rule 65.2.2**: SPA は Public Client として扱うが、可能なら **BFF パターン**（§14）で Confidential Client 化することを推奨する。

### 1.3. 適用方針

-   **Law**: 自前の OAuth/OIDC プロバイダー実装は禁止する。検証済みの IDaaS / AS（`000_security_privacy.md` §4.3）を使用する。RP（クライアント）側の正しい実装が本ファイルの主眼。
-   **Law**: 新規実装は **OAuth 2.1 + OIDC + PKCE** を既定とする。OAuth 2.0 の許容していた弱いフロー（§2.2）は採用しない。

---

## §2. OAuth 2.1 中核プロトコル

> **参考規格**: OAuth 2.1 (draft-ietf-oauth-v2-1), RFC 9700 (Security BCP), RFC 6749

### 2.1. Authorization Code Flow + PKCE（唯一の標準フロー）

-   **Law**: ブラウザ/モバイル経由のユーザー認可は **Authorization Code Flow + PKCE** のみを使用する。
-   **フロー概要**:
    1.  クライアントが `code_verifier` を生成し、`code_challenge = BASE64URL(SHA256(code_verifier))` を算出。
    2.  `/authorize` に `response_type=code`, `code_challenge`, `code_challenge_method=S256`, `state`, `scope`, `redirect_uri` を付与してリダイレクト。
    3.  ユーザー認証・同意後、AS が `code` を `redirect_uri` に返却。
    4.  クライアントがバックチャネルで `/token` に `code` + `code_verifier`（+ Confidential なら `client_secret`）を送信。
    5.  AS が `code_verifier` を検証しトークンを発行。

### 2.2. 禁止・非推奨フロー

| フロー | OAuth 2.0 | 本ファイル方針 | 理由 |
|:------|:---------|:-------------|:-----|
| **Implicit Flow** (`response_type=token`) | 許可 | 🔴 **禁止** | アクセストークンがURLフラグメントに露出。ログ/履歴/リファラ漏洩 |
| **Resource Owner Password Credentials (ROPC)** | 許可 | 🔴 **禁止** | クライアントがユーザー資格情報を直接扱う。フィッシング助長・MFA不可 |
| **Hybrid Flow** (`code token`, `code id_token token`) | 許可 | ⚠️ **非推奨** | アクセストークンのフロントチャネル露出を伴う場合は不可。`code id_token` は OIDC `response_mode=fragment` で限定的に許容（§4.6） |
| **Authorization Code（PKCEなし）** | 推奨 | 🔴 **禁止** | 認可コード横取り攻撃に脆弱 |
| **Device Authorization Grant** (RFC 8628) | 許可 | ✅ 許可 | TV/CLI等の入力制約デバイスでのみ使用 |
| **Client Credentials Grant** | 許可 | ✅ 許可 | M2M（ユーザー不在）通信専用。ユーザー認証には使わない |

### 2.3. Redirect URI の完全一致

-   **Law**: `redirect_uri` は AS に事前登録した値との**完全一致（Exact Match）**のみ許可する。ワイルドカード・部分一致・パスのみ一致を禁止する。
-   **Action**:
    1.  AS の登録時に絶対URL（スキーム+ホスト+ポート+パス）を完全指定。
    2.  `https://app.example.com/callback?next=...` のように **Open Redirect** 経由でトークンを外部へ転送させる設計を排除。`next` 等の戻り先パラメータは許可リスト検証する。
    3.  モバイルのカスタムスキーム（`com.example.app:/callback`）よりも **Universal Links / App Links** を優先（横取り防止）。

### 2.4. スコープ最小化

-   **Law**: 要求する `scope` は機能遂行に必要な最小限に限定する（`000_security_privacy.md` §7.2 データ最小化）。
-   **Action**: `openid`, `email`, `profile` 等から開始し、追加権限は **Incremental Authorization**（必要になった時点で追加要求）で取得する。

### 2.5. OAuth Consent Phishing（不正同意付与攻撃）

-   **背景**: 攻撃者が正規の AS 上に悪意あるOAuthアプリを登録し、ユーザーを正規の同意画面に誘導して「メール読み取り」「ファイルアクセス」等のスコープへ同意させ、**正規のトークンを正規のフローで詐取**する攻撃。フィッシングサイトを使わないため、**パスキー／フィッシング耐性要素では防げない**（同意行為そのものが正規であるため）。
-   **Law**: テナント／組織のOAuthアプリ登録・同意を統制する。
    1.  **アプリ／スコープ審査**: 自テナントに対し第三者アプリが要求できるスコープを制限し、機微スコープ（メール・ファイル・ディレクトリ）への**ユーザー任意同意を無効化**して **admin consent（管理者承認）必須**とする。
    2.  **publisher 検証**: 検証済み発行元（verified publisher）でないアプリの同意を既定で拒否する。
    3.  **同意の可観測性**: 付与済み同意（consent grant）を定期棚卸しし、未使用・過剰スコープのアプリを失効する。異常な新規同意付与を ITDR（`000_security_privacy.md` §3.3）へ送出。
-   **自テナントが AS を提供する側（マルチテナントSaaS）**の場合は、登録アプリの publisher 検証・スコープ最小化・同意ログ提供を実装する。

### 2.6. Device Authorization Grant のフィッシング面（RFC 8628）

-   **背景**: Device Authorization Grant（§2.2 で TV/CLI 用に許容）は、攻撃者が自分のデバイスコードをユーザーに提示し「このコードを入力して」と誘導することで、被害者の認証を攻撃者のセッションに紐付ける **Device Code Phishing** の温床になりうる。
-   **Law**: Device Code Flow は以下を満たす場合のみ使用する。
    1.  **必要時のみ有効化**: 入力制約デバイス（TV/CLI/IoT）に限定し、通常のブラウザ／モバイルでは有効化しない。
    2.  **短命・試行制限**: `user_code` は短命（数分）かつ低エントロピーを避け、検証エンドポイントに試行回数制限・レート制限を課す。
    3.  **コード一致確認の明示**: ユーザーが入力するデバイス側に表示されたコードと承認画面のコードの一致をユーザーに明示確認させ、「他者から提示されたコードを入力しない」旨を警告表示する。
    4.  高リスクスコープ／管理者操作を Device Code Flow で付与しない。

---

## §3. PKCE / state / nonce

### 3.1. PKCE（Proof Key for Code Exchange — RFC 7636）

-   **Law**: 全クライアント種別（Confidential 含む）で PKCE を必須とする。`code_challenge_method` は **`S256` のみ**許可し、`plain` を禁止する。
-   **Action**:
    1.  `code_verifier` は 43〜128文字の高エントロピー乱数（`[A-Za-z0-9-._~]`）。
    2.  `code_verifier` はクライアント側に安全に一時保管（SPAなら `sessionStorage` ではなく BFF セッション、§14）。
    3.  AS は `/token` で `code_verifier` のハッシュ一致を検証。

### 3.2. state（CSRF防止）

-   **Law**: `/authorize` リクエストに暗号学的乱数の `state` を付与し、コールバックで一致を検証する。CSRF（認可コードインジェクション）を防止する。
-   **Action**: `state` をセッションに束縛して保存。コールバックの `state` と不一致なら拒否。`state` に戻り先URL等のアプリ状態を入れる場合は署名/暗号化または不透明値+サーバー側マッピングを使う。

### 3.3. nonce（IDトークンリプレイ防止 — OIDC）

-   **Law**: OIDC 認証リクエストに `nonce` を付与し、ID Token の `nonce` クレームと一致を検証する（§5.1）。
-   **Action**: `nonce` は `state` とは独立の乱数とし、セッションに束縛。ID Token 検証時に必ず照合する。

> [!CAUTION]
> `state`（CSRF）と `nonce`（IDトークンリプレイ）は**役割が異なる**。どちらか一方の省略は不可。両方を独立に検証する。

---

## §4. OIDC（OpenID Connect）

> **参考規格**: OpenID Connect Core 1.0, OIDC Discovery 1.0, OpenID Connect for Identity Assurance

### 4.1. Discovery（`.well-known/openid-configuration`）

-   **Action**: AS の構成（`authorization_endpoint`, `token_endpoint`, `jwks_uri`, `issuer`, 対応スコープ/署名アルゴリズム）を Discovery エンドポイントから取得し、ハードコードを避ける。レスポンスはキャッシュし（§6.3）、`issuer` がリクエストドメインと一致することを検証する。

### 4.2. scopes と claims

-   **標準スコープ**: `openid`（必須）, `profile`, `email`, `address`, `phone`, `offline_access`（リフレッシュトークン要求）。
-   **Action**:
    1.  クレームは UserInfo エンドポイントまたは ID Token のいずれから取得するか方針を決め、二重取得を避ける。
    2.  最小権限: 表示名だけ必要なら `address`/`phone` を要求しない。
    3.  `claims` パラメータ（OIDC）で個別クレームを精密要求可能。

### 4.3. UserInfo エンドポイント

-   **Action**: UserInfo はアクセストークンで保護される。レスポンスの `sub` が ID Token の `sub` と一致することを必ず検証する（トークン置換攻撃防止）。

### 4.4. prompt / max_age（再認証・同意制御）

-   `prompt=none`: サイレント認証（既存セッション確認）。失敗時 `login_required` 等を返す。
-   `prompt=login`: 強制再認証。
-   `prompt=consent`: 同意画面の再表示。
-   `max_age`: 最後の認証からの最大経過秒数。超過時は再認証を要求。Step-Up 用途は §420 を参照。

### 4.5. ユーザー識別子の扱い

-   **Law**: ユーザーの一意識別子は **`iss` + `sub` の組**で扱う。`email` を主キーにしてはならない（メールは変更・再利用・なりすまし可能）。
-   **Action**: DB には `(provider_iss, provider_sub)` をユニーク制約として保存。`email` は補助属性かつ `email_verified=true` の場合のみ信頼する（§8.2）。

### 4.6. Hybrid Flow の扱い

-   **Law**: Hybrid Flow の新規採用は原則非推奨。アクセストークンをフロントチャネルに露出する `response_type` は禁止する。
-   **限定許容**: `response_type=code id_token`（フロントチャネルで ID Token のみ受領、トークンはバックチャネル交換）は、`c_hash` 検証を必須としたうえで限定的に許容する。新規はプレーンな Authorization Code + PKCE を優先する。

---

## §5. ID Token 検証

> **参考規格**: OIDC Core 1.0 §3.1.3.7, RFC 9700

### 5.1. 必須検証項目

-   **Law**: ID Token（JWT）は以下を**すべて**検証してから信頼する。1項目でも欠落・不一致なら拒否する。

| クレーム | 検証内容 |
|:--------|:---------|
| **署名** | `jwks_uri` から取得した公開鍵で署名検証（§6）。`alg=none` を拒否 |
| **`iss`** | 期待する Issuer と完全一致 |
| **`aud`** | 自クライアントの `client_id` を含むこと。複数 audience 時は `azp` も検証 |
| **`exp`** | 有効期限内（サーバー時刻、許容クロックスキュー ≤ 60秒） |
| **`iat`** | 発行時刻が妥当（未来時刻でない） |
| **`nonce`** | 認証リクエストで送信した値と一致（§3.3） |
| **`at_hash`** | アクセストークンと併送時、`at_hash` の整合を検証（トークン置換防止） |
| **`azp`** | `aud` が複数または `azp` 存在時、自 `client_id` と一致 |

### 5.2. アクセストークンの audience 制限

-   **Law**: Resource Server はアクセストークン（JWT の場合）の `aud`（または導入された `resource` インジケータ, RFC 8707）が自分宛てであることを検証する。他サービス向けトークンの転用（Confused Deputy）を防止する。

### 5.3. アルゴリズム固定

-   **Law**: 検証側は許可する署名アルゴリズムをホワイトリストで固定する（例: `RS256`, `ES256`）。トークンヘッダーの `alg` を信頼して動的選択してはならない。`alg=none` と対称鍵（`HS256`）への降格攻撃を防止する。

### 5.4. 署名検証の委譲

-   **Action**: 自前のJWTデコードよりも、保守された検証ライブラリ（`jose`, AS公式SDK）を使用する。`jwt.decode()` の検証なし利用を禁止する（§21）。

---

## §6. JWKS・署名鍵・ローテーション

### 6.1. JWKS による鍵取得

-   **Action**: 署名検証鍵は AS の `jwks_uri`（JWK Set）から `kid`（Key ID）で選択する。ID Token/JWT ヘッダーの `kid` に一致する鍵を使用する。

### 6.2. 鍵ローテーション対応

-   **Law**: AS の署名鍵は予告なくローテーションされる前提で実装する。未知の `kid` を受信した場合は **JWKS を再取得**してから検証する（即エラーにしない）。
-   **Action**: JWKS キャッシュを保持しつつ、`kid` ミス時にキャッシュを無効化して再フェッチ。ただし JWKS エンドポイントへの DoS を避けるため**レート制限/最小再取得間隔**を設ける。

### 6.3. JWKS キャッシュ（パフォーマンス）

-   **Action**: JWKS は HTTP `Cache-Control` を尊重しつつ、5〜60分程度キャッシュする。毎リクエストでの JWKS フェッチは禁止（レイテンシ・コスト・可用性リスク）。`jose` の `createRemoteJWKSet` 等はこのキャッシュ＋`kid`再取得を内蔵する。

---

## §7. ソーシャルログイン（Google / Apple / Microsoft / GitHub）

> **参考規格**: 各IdP公式ドキュメント, OIDC Core, FedCM (W3C)

### 7.1. 共通要件

-   **Law**: ソーシャルログインは `000_security_privacy.md` §4.4 の Social Login Security Protocol を満たす（Authorization Code + PKCE、`state`、サーバーサイド token 交換、スコープ最小化、明示的アカウントリンク、`iss`/`aud`/`exp` 検証）。
-   **Action**: IdP から受領した ID Token / プロフィールは**サーバーサイドで再検証**してからセッションを発行する。クライアントの主張をそのまま信頼しない。

### 7.2. Google（Google Identity Services）

-   **Action**:
    1.  **Sign in with Google**（GIS ライブラリ）を使用。レガシーの Google Sign-In JavaScript（gapi.auth2）は廃止済みのため使用しない。
    2.  ID Token はサーバー側で検証: `iss` が `https://accounts.google.com` または `accounts.google.com`、`aud` が自 OAuth クライアントID、`exp` 有効。Google 公式ライブラリ（`google-auth-library`）での検証を推奨（§20.5）。
    3.  ユーザー識別は `sub` を使用。`email_verified` を確認のうえで `email` を補助利用。
    4.  **FedCM 対応**: サードパーティCookie廃止に伴い、GIS は FedCM ベースに移行している。FedCM 対応モードを有効化する（§16）。

### 7.3. Apple（Sign in with Apple）

-   **Action**:
    1.  ID Token（`iss=https://appleid.apple.com`）を JWKS で検証。`client_secret` は **ES256 署名の JWT**（有効期限付き）として動的生成する。
    2.  **Private Email Relay**: ユーザーがメール非公開を選択した場合 `@privaterelay.appleid.com` のリレーアドレスが返る。送信ドメインを Apple に登録しないとメール不達になる点に注意。
    3.  **名前は初回認可時のみ返却**: `name` は最初の認可レスポンスにしか含まれない。初回に取得・永続化する。後続フローでは取得不可。
    4.  App Store 配布アプリで他のソーシャルログインを提供する場合、Apple のガイドライン上 Sign in with Apple の併設が要求されることがある（要確認）。

### 7.4. Microsoft（Entra ID / Microsoft アカウント）

-   **Action**:
    1.  Microsoft Identity Platform（v2.0 エンドポイント）+ OIDC を使用。MSAL ライブラリを推奨。
    2.  **`tid`（テナントID）検証**: マルチテナント構成では受け入れるテナントを許可リストで制御する。`common`/`organizations` エンドポイント利用時は `tid` を必ず検証し、任意テナントのなりすましを防止する。
    3.  ユーザー識別は `oid`（+ `tid`）の組を使用。`email`/`preferred_username` は変更されうる。

### 7.5. GitHub（OAuth / GitHub Apps）

-   **Action**:
    1.  GitHub は純粋な OAuth 2.0（OIDC ではない）。ID Token はないため、`/user` API でユーザー情報を取得する。
    2.  メールは公開設定により取得できない場合があるため、`user:email` スコープ + `/user/emails` で `verified=true` かつ `primary=true` のアドレスを使用する。
    3.  きめ細かな権限が必要なら OAuth App ではなく **GitHub App** を使用し、最小権限の installation token を利用する。
    4.  Webhook 受信時は署名（`X-Hub-Signature-256`）を検証する（`engineering/100_api_integration.md`）。

---

## §8. アカウントリンク・乗っ取り防止

> **参考規格**: OAuth Security BCP (RFC 9700), 各IdPアカウントリンクガイドライン

### 8.1. 自動リンクの禁止

-   **Law**: 同一メールアドレスという理由だけで、既存アカウントと外部IDを**自動リンクしてはならない**（`000_security_privacy.md` §4.4 Explicit Account Link）。
-   **Rationale**: IdP が `email_verified=false` を返す、または攻撃者が未検証メールで外部アカウントを作成した場合、自動リンクは**アカウント乗っ取り（Account Takeover）**に直結する。

### 8.2. 安全なリンクフロー

-   **Action**:
    1.  **既存セッションでのリンク**: 既にログイン中のユーザーが「Googleを連携」操作をした場合のみ、認証済みセッション内でリンクを許可する。
    2.  **事前検証メール**: 既存メールに一致する外部ログイン時は、自動リンクせず、**既存アカウントの所有確認**（確認メールのワンタイムリンク、または既存資格情報での再認証）を要求してからリンクする。
    3.  **`email_verified` 厳格化**: IdP の `email_verified=true` でない限り `email` を本人確認の根拠に使わない。
    4.  **リンク解除**: ユーザーが連携を解除できるUIを提供し、最後のログイン手段の解除はパスワード設定等のフォールバック確保後に許可する。

### 8.3. プロバイダー横断の名寄せ

-   **Action**: 1人のユーザーが複数IdP（Google+Apple+メール）を持つ場合、内部ユーザーIDに複数の `(iss, sub)` を関連付ける identities テーブル設計とする。`email` を結合キーにしない。

---

## §9. エンタープライズSSO（SAML 2.0 / OIDC）

> **参考規格**: SAML 2.0 (OASIS), OIDC Core, NIST SP 800-63

### 9.1. SAML 2.0 と OIDC の使い分け

| 観点 | SAML 2.0 | OIDC |
|:-----|:---------|:-----|
| **適性** | レガシー/エンタープライズIdP（多くの社内IdPが対応） | モダン/モバイル/SPA/API |
| **トークン** | XML Assertion | JWT (ID Token) |
| **モバイル親和性** | 低 | 高 |
| **推奨** | 顧客IdPが SAML のみ対応の場合 | 新規・自由選択時の既定 |

-   **Law**: 新規実装で選択肢があるなら **OIDC を既定**とする。SAML は顧客/取引先IdPの制約で必要な場合に対応する。

### 9.2. SAML 実装の必須検証

-   **Law**: SAML Assertion を受領する SP（Service Provider）は以下を検証する。
    1.  **XML署名検証**: IdP の証明書で Assertion/Response の署名を検証。**XML Signature Wrapping (XSW)** 攻撃対策のため、署名された要素と処理する要素が同一であることを保証する保守されたライブラリを使用する。
    2.  **`Audience` / `Recipient` / `Destination`** が自SPと一致。
    3.  **`NotBefore` / `NotOnOrAfter`**（時刻窓）。
    4.  **`InResponseTo`** が自分の送ったリクエストIDと一致（リプレイ防止）。
    5.  **Assertion の再利用防止**: 処理済み Assertion ID を一定期間記録。

### 9.3. IdP-initiated SSO のリスク

-   **Law**: **IdP-initiated SSO**（SPのリクエストなしにIdPから Assertion が送られる）は CSRF/ログインインジェクションのリスクが高いため、可能な限り **SP-initiated** を使用する。
-   **Action**: IdP-initiated を要求される場合は、`InResponseTo` 検証ができない代替としてリプレイ防止・短時間有効・ランディング後のユーザー確認を組み合わせる。

### 9.4. SAML/OIDC 共通

-   **Action**: テナント（顧客企業）ごとに IdP メタデータ・証明書を分離管理し、テナント間のトークン混用を構造的に防ぐ（`000_security_privacy.md` マルチテナント分離）。証明書ローテーションを監視する。

---

## §10. JIT プロビジョニング & SCIM

### 10.1. JIT（Just-In-Time）プロビジョニング

-   **Action**: SSO 初回ログイン時にユーザーレコードを自動作成する場合、IdP が主張する属性（ロール・グループ）を**そのまま特権付与に使わない**。最小権限で作成し、特権昇格は別途承認フローを通す。

### 10.2. SCIM（System for Cross-domain Identity Management 2.0）

-   **Law**: エンタープライズ顧客のユーザーライフサイクル（作成・更新・**無効化**）は SCIM 2.0 で自動同期する。手動デプロビジョニングは退職者アカウント残存（Orphaned ID）の温床。
-   **Action**:
    1.  SCIM エンドポイントは Bearer Token で保護し、テナントごとにスコープ分離。
    2.  **Deprovisioning 即時反映**: IdP 側の無効化を受けて、対象ユーザーの全セッションを即時失効（§17, §11.4）。
    3.  SCIM 操作を監査ログに記録（`000_security_privacy.md` §4.6）。
-   **Cross-Reference**: `000_security_privacy.md` §3.5（SCIM）

---

## §11. トークン管理・有効期限・失効

### 11.1. トークン有効期限（`000_security_privacy.md` §6.1 と整合）

| トークン種別 | 推奨有効期限 | 管理画面/高リスク |
|:-----------|:-----------|:----------------|
| **Access Token** | ≤ 1時間 | ≤ 15分 |
| **Refresh Token** | 7〜30日（ローテーション必須） | ≤ 7日 |
| **ID Token** | 短命（認証直後の検証用、長期保持しない） | — |
| **Authorization Code** | ≤ 60秒・**1回限り** | ≤ 60秒 |

### 11.2. アクセストークンは短命に

-   **Law**: アクセストークンは短命とし、失効はリフレッシュトークンのローテーション（§12）と失効リストで担保する。長命アクセストークンは漏洩時の被害が甚大。

### 11.3. Introspection（RFC 7662）

-   **Action**: 不透明（Opaque）アクセストークンを使う場合、RS は Introspection エンドポイントでトークンの有効性・スコープ・`aud` を確認する。JWT の場合はローカル検証（§5）+ 失効確認を併用。

### 11.4. Revocation（RFC 7009）と失効反映

-   **Law**: ログアウト・アカウント停止・パスワード変更・SCIM 無効化時に、トークンを失効させる。
-   **Action**:
    1.  Refresh Token は AS の Revocation エンドポイントで失効。
    2.  短命アクセストークン + 失効リスト（`jti` ベース）または短いキャッシュTTLで失効反映の遅延を最小化。
    3.  `000_security_privacy.md` §6.5（Server-Side Invalidation）と整合。

---

## §12. リフレッシュトークンローテーション & 再利用検知

> **参考規格**: OAuth Security BCP (RFC 9700)

### 12.1. ローテーション必須

-   **Law**: Public Client（SPA/モバイル/BFF）では Refresh Token Rotation を必須とする。リフレッシュのたびに新しい Refresh Token を発行し、旧トークンを無効化する。

### 12.2. 再利用検知（Reuse Detection）

-   **Law**: 既に使用済み（ローテーション済み）の Refresh Token が再提示された場合、**そのトークンファミリー全体を即時失効**し、ユーザーに再認証を要求する。これはトークン窃取のシグナルである。
-   **Action**: Refresh Token に family ID を付与し、ローテーションチェーンを追跡。再利用検知時は family を一括失効し、ITDR（`000_security_privacy.md` §3.3）へイベント送出。

### 12.3. Sender-Constraint 併用

-   **Action**: 高リスク用途では Refresh Token を DPoP/mTLS で sender-constrained 化し（§13）、盗難トークンの再利用を暗号的にも阻止する。

---

## §13. Sender-Constrained Tokens（DPoP / mTLS）

> **参考規格**: RFC 9449 (DPoP), RFC 8705 (mTLS / Certificate-Bound Access Tokens)

### 13.1. DPoP（Demonstrating Proof of Possession）

-   **概要**: アクセストークン/リフレッシュトークンをクライアントの公開鍵に暗号的に束縛し、Bearer トークン盗難時の再利用を防止する（`000_security_privacy.md` §4.10 と整合）。
-   **Action**:
    1.  クライアントはリクエストごとに鍵対（`ES256`/`EdDSA` 推奨）で署名した DPoP JWT を `DPoP` ヘッダーに付与。
    2.  サーバーは `htm`（HTTPメソッド）, `htu`（HTTP URI）, `iat`, `jti`（リプレイ防止）を検証し、トークンの `cnf.jkt`（鍵Thumbprint）と DPoP 鍵の一致を確認。
    3.  `DPoP-Nonce` をサーバー発行し、リプレイをブロック。
-   実装スニペットは §20.4 を参照。

### 13.2. mTLS Certificate-Bound Access Tokens

-   **概要**: アクセストークンをクライアント証明書の Thumbprint に束縛（`cnf.x5t#S256`）。証明書ベースで DPoP より強固。
-   **用途**: 金融API（FAPI 2.0）、M2M 通信。クライアント証明書が使える環境で推奨。

### 13.3. 選定指針

| 環境 | 推奨方式 |
|:-----|:---------|
| ブラウザSPA/モバイル | DPoP（または BFF + Cookie、§14） |
| サーバー間/金融API | mTLS（FAPI 2.0） |
| レガシー互換が必要 | Bearer（ただし短命 + 失効厳格化） |

### 13.4. AiTM（Adversary-in-the-Middle）とトークン窃取への対抗

-   **背景**: AiTM フィッシング（Evilginx 等のリバースプロキシキット）は、ログインとMFAをリアルタイムに中継して**発行済みセッショントークン／リフレッシュトークンを窃取**する。パスキー（フィッシング耐性要素）はログイン自体の中継を阻止できるが、**発行後の Bearer トークンが盗まれれば再利用される**ため、トークン層の防御が別途必要となる。
-   **Law**: AiTM とトークン窃取への対抗として、高リスク用途では **sender-constrained token（DPoP=RFC 9449 / mTLS=RFC 8705）を必須**とし、Bearer トークン単独運用に依存しない。盗難トークンは束縛鍵を持たない攻撃者からは再利用できない。
-   **Action**:
    1.  アクセストークン・リフレッシュトークンの双方を sender-constrained 化（§12.3, §13.1）。
    2.  トークン窃取の兆候（同一トークンの IP/デバイス急変、Impossible Travel）を検知し、CAEP（→`420_step_up_auth_and_sensitive_operations.md` §10）で即時失効・再認証を発火。
    3.  リフレッシュ再利用検知（§12.2）でトークンファミリーを一括失効。
-   **Cross-Reference**: `420_step_up_auth_and_sensitive_operations.md` §28（ATO 検知）

---

## §14. トークン保管・BFFパターン（SPA/モバイル）

> **参考規格**: OAuth 2.0 for Browser-Based Apps (BCP)

### 14.1. localStorage 回避

-   **Law**: ブラウザの `localStorage` / `sessionStorage` にアクセストークン・リフレッシュトークンを保存してはならない。XSS により JS から窃取可能なため。

### 14.2. BFF（Backend-for-Frontend）パターン推奨

-   **Law**: SPA は **BFF パターン**を推奨既定とする。トークンはサーバーサイド（BFF）が保持し、ブラウザには `HttpOnly` + `Secure` + `SameSite` の**セッションCookie**のみを渡す。
-   **アーキテクチャ**:
    1.  BFF が Confidential Client として OAuth フロー（Authorization Code + PKCE）を実行。
    2.  トークンは BFF のサーバーサイドセッションストア（暗号化）に保管。
    3.  ブラウザ↔BFF は same-site Cookie セッション、BFF↔API は Bearer/DPoP。
    4.  CSRF 対策（`SameSite=Lax`/`Strict` + CSRF トークン、`000_security_privacy.md` §10.8）。

### 14.3. BFF が使えない純SPAの場合

-   **Action**: やむを得ず純SPAでトークンを扱う場合、(a) アクセストークンはメモリ（JS変数）のみに保持し永続化しない、(b) リフレッシュは `HttpOnly` Cookie + ローテーション + 再利用検知、(c) 強固な CSP + Trusted Types で XSS 面を最小化する（`engineering/300_web_frontend.md`）。

### 14.4. モバイル

-   **Action**: トークンは OS のセキュアストレージ（iOS Keychain / Android Keystore/EncryptedSharedPreferences）に保管。`AppAuth` 等の OIDC 認定ライブラリを使用し、システムブラウザ（ASWebAuthenticationSession / Custom Tabs）で認可する。WebView での認可は禁止（資格情報窃取・PKCE回避リスク）。

---

## §15. 高度プロトコル（PAR / RAR / JAR / JARM / Token Exchange）

> **参考規格**: RFC 9126 (PAR), RFC 9396 (RAR), RFC 9101 (JAR), JARM (FAPI), RFC 8693 (Token Exchange), RFC 8707 (Resource Indicators)

### 15.1. PAR（Pushed Authorization Requests — RFC 9126）

-   認可リクエストパラメータをフロントチャネルではなくバックチャネルで事前送信し、`request_uri` を受領。パラメータ改ざん・漏洩を防止。高リスク（金融・医療）で推奨。

### 15.2. RAR（Rich Authorization Requests — RFC 9396）

-   `authorization_details` で細粒度の認可（例: 「口座Xから1万円以内の振込のみ」）を表現。Open Banking / FAPI 2.0 準拠に必要。

### 15.3. JAR / JARM

-   **JAR (RFC 9101)**: 認可リクエストを署名/暗号化 JWT（`request` オブジェクト）として送信し、改ざんを防止。
-   **JARM**: 認可レスポンスを署名 JWT で返し、レスポンス改ざん・インジェクションを防止。FAPI で採用。

### 15.4. Token Exchange（RFC 8693）

-   あるトークンを別のトークン（異なる audience/権限）に交換。マイクロサービス間の権限委譲・ダウンスコープに使用。過剰権限の伝播を避けるため audience/scope を絞る。

### 15.5. 認証強度の表現（acr / amr）と Step-Up は §420 へ

-   **Law**: 認証の保証レベルと使用要素は **`acr`（Authentication Context Class Reference）/ `amr`（Authentication Methods References, RFC 8176）** クレームで表現し、RP（リソース側）が**操作の重大性に応じて検証**する。トークンを保持していること自体を認証強度の根拠にしない（§19.5 Zero Trust）。
-   **AAL/IAL/FAL マッピング**: NIST SP 800-63 の **AAL（認証器保証）/ IAL（身元確認保証）/ FAL（フェデレーション保証）** を `acr` 値にマッピングし、操作ティアごとに必要レベルを定義する。詳細なマッピングと Step-Up（再認証）の実装は **`420_step_up_auth_and_sensitive_operations.md` §2・§3** に集約する（本ファイルでは深掘りしない）。
-   高リスク操作時の再認証（Step-Up Authentication）、トランザクション認証は **`420_step_up_auth_and_sensitive_operations.md`** を参照。

---

## §16. FedCM（サードパーティCookie廃止対応）

> **参考規格**: W3C Federated Credential Management (FedCM)

### 16.1. 背景

-   **Note（前提の正確化）**: 当初予定されていた Chrome のサードパーティCookie**一律廃止は撤回**され、当面はサードパーティCookieが**残存**する見込みである（ブラウザ間でも扱いが分かれる）。FedCM はそれと独立に前進しているため、設計の前提は「サードパーティCookieは当面残存するが、FedCM への移行は前進させる」とする。「サードパーティCookie廃止が確定済み」という断定はしない。
-   **Law**: それでもなお、サードパーティCookie依存・分割（Storage Partitioning）の影響を受けやすいフェデレーション（暗黙のIdPセッション共有、隠しiframe、サイレント認証）は**脆く壊れやすい**前提で設計する。廃止の有無に関わらず、FedCM またはリダイレクトベースへの移行を進める。

### 16.2. FedCM 対応

-   **Action**:
    1.  Google Identity Services 等、IdP/ライブラリの **FedCM 対応モード**を有効化する。
    2.  サードパーティCookieに依存する `prompt=none` サイレント認証・iframe ベースのトークン更新を、FedCM またはリダイレクトベース（BFF + Refresh Token）に置き換える。
    3.  IdP 側が FedCM の `accounts`/`client_metadata`/`id_assertion` エンドポイントを提供する場合は仕様に準拠。
    4.  ブラウザ互換性に応じたフォールバック（リダイレクトフロー）を用意する。

### 16.3. 禁止

-   **Law**: サードパーティCookieに恒久的に依存する新規フェデレーション設計を禁止する。

---

## §17. ログアウト・セッション同期

> **参考規格**: OIDC RP-Initiated Logout 1.0, OIDC Back-Channel Logout 1.0, OIDC Front-Channel Logout 1.0

### 17.1. RP-Initiated Logout

-   **Action**: アプリ（RP）からのログアウト時、ローカルセッション破棄に加え、AS の `end_session_endpoint` へ `id_token_hint` + `post_logout_redirect_uri`（事前登録・完全一致）でリダイレクトし、IdP セッションも終了させる。

### 17.2. Back-Channel Logout（推奨）

-   **Law**: SSO 環境では **Back-Channel Logout** を実装する。IdP がログアウトを各RPにサーバー間通知（Logout Token JWT）し、RP は対象セッションを失効させる。
-   **Action**: Logout Token の `iss`/`aud`/`exp`/`events` を検証し、`sid`（セッションID）または `sub` に対応する全セッションをサーバーサイド失効（§11.4）。Front-Channel Logout はサードパーティCookie制約で不安定なため Back-Channel を優先。

### 17.3. セッション同期とグローバルログアウト

-   **Action**: 「すべてのデバイスからログアウト」機能を提供（`000_security_privacy.md` §6.3）。SCIM 無効化・パスワード変更時は全セッション+Refresh Token を失効させる。

---

## §18. Verifiable Credentials / SD-JWT / OID4VCI（将来動向）

> **参考規格**: W3C Verifiable Credentials 2.0, SD-JWT (IETF), OpenID for Verifiable Credential Issuance/Presentation (OID4VCI/OID4VP)

### 18.1. 方向性

-   **Note**: 分散型ID（DID）・Verifiable Credentials・デジタルウォレット（EU Digital Identity Wallet 等）は、IdP集中型フェデレーションを補完する将来動向。現時点では標準が固まりつつある段階のため、**新規必須要件ではない**が設計上の拡張点として認識する。

### 18.2. SD-JWT（Selective Disclosure JWT）

-   **概要**: クレームを選択的に開示できる JWT。検証者に必要な属性のみ提示し、過剰開示を避ける（プライバシー最小化）。年齢確認で「生年月日」ではなく「18歳以上」のみ提示する用途等。
-   **規格ステータス**: 基盤の **SD-JWT は RFC 9901**（確定）。一方、その上で VC（Verifiable Credential）を表現する **SD-JWT VC はまだ IETF I-D（Internet-Draft, RFC 未確定）**である。両者を混同せず、SD-JWT VC を採用する場合はドラフト変更リスクを前提にバージョンを固定する。

### 18.3. OID4VCI / OID4VP

-   **概要**: OAuth/OIDC を拡張し、Verifiable Credential の発行（VCI）・提示（VP）を行うプロトコル。将来的に政府発行ID・資格証明のウォレット連携で利用が広がる見込み。
-   **Action**: 採用検討時は、ウォレットのセキュリティ・鍵管理・失効（Status List）・プライバシー（相関防止）を評価する。

---

## §19. 可観測性・FinOps・パフォーマンス・Zero Trust・プライバシー

### 19.1. 可観測性（Observability）

-   **Action**: 以下を計測・ログ化する（PIIマスキング順守、`000_security_privacy.md` §7.4）。
    -   **OAuth エラー率**: `invalid_grant`, `invalid_client`, `access_denied`, redirect mismatch 等の発生率。
    -   **トークン発行/更新メトリクス**: 発行数、リフレッシュ成功/失敗、再利用検知発火数。
    -   **検証失敗**: 署名検証失敗、`iss`/`aud`/`nonce` 不一致、期限切れ。
    -   **異常**: 同一IPからの大量 token 要求、Impossible Travel（ITDR連携）。
-   ログには `sub`/`email` 等のPIIを生で残さず、ユーザーIDのハッシュ/相関IDを用いる。

### 19.2. FinOps

-   **Action**:
    1.  **MAU課金**: 多くの IDaaS は MAU（Monthly Active Users）課金。匿名/ボットトラフィックによる MAU 膨張を監視・抑制する。
    2.  **トークン検証コスト**: 不透明トークンの Introspection は AS への往復コスト。JWT ローカル検証 + JWKS キャッシュ（§6.3）でコスト/レイテンシを削減。
    3.  M2M トークン（Client Credentials）の過剰発行を監視（一部 IDaaS は M2M トークン数課金）。

### 19.3. パフォーマンス

-   **Action**: JWKS キャッシュ（§6.3）、ID Token のローカル検証、Discovery のキャッシュにより認可フローのレイテンシを抑える。トークン検証はホットパスのため、鍵フェッチを同期ブロッキングにしない。

### 19.4. スケーラビリティ

-   **Action**: セッション/失効リストは分散ストア（Redis 等）で水平スケール。JWT のステートレス検証を活かしつつ、失効は短TTL + 失効リストのハイブリッドで一貫性とスケールを両立。

### 19.5. Zero Trust

-   **Action**: フェデレーションは Identity-First Zero Trust（`000_security_privacy.md` §2.4）の中核。トークン保持＝信頼ではなく、`aud`/`scope`/sender-constraint/コンテキスト（デバイス・リスクスコア）で都度認可する。

### 19.6. プライバシー・同意

-   **Action**: スコープ最小化（§2.4）、`prompt=consent` による明示同意、SD-JWT 等での過剰開示回避。同意取得UIはダークパターンを禁止（`000_security_privacy.md` §9.5）。IdP から取得した属性は目的内利用に限定し保存期間を定義する。

---

## §20. 実装スニペット集

> [!NOTE]
> スニペットは最新安定版のライブラリ前提の最小例。本番では例外処理・タイムアウト・監査ログを付加すること。

### 20.1. PKCE 生成（code_verifier / code_challenge）

```typescript
// ✅ PKCE: code_verifier と S256 code_challenge を生成
function base64url(buffer: ArrayBuffer): string {
  return btoa(String.fromCharCode(...new Uint8Array(buffer)))
    .replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
}

export async function createPkcePair() {
  const verifierBytes = crypto.getRandomValues(new Uint8Array(32));
  const codeVerifier = base64url(verifierBytes.buffer); // 43文字
  const digest = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(codeVerifier));
  const codeChallenge = base64url(digest);
  return { codeVerifier, codeChallenge, method: 'S256' as const };
}
```

### 20.2. ID Token 検証（jose）

```typescript
// ✅ OIDC ID Token をJWKS・iss・aud・nonceまで検証
import { createRemoteJWKSet, jwtVerify } from 'jose';

const JWKS = createRemoteJWKSet(new URL('https://issuer.example.com/.well-known/jwks.json')); // §6.3 内部キャッシュ+kid再取得

export async function verifyIdToken(idToken: string, expectedNonce: string) {
  const { payload } = await jwtVerify(idToken, JWKS, {
    issuer: 'https://issuer.example.com',  // iss 完全一致
    audience: process.env.OIDC_CLIENT_ID!, // aud に client_id
    algorithms: ['RS256', 'ES256'],        // §5.3 alg ホワイトリスト
    clockTolerance: 60,                    // ≤60秒
  });
  if (payload.nonce !== expectedNonce) throw new Error('nonce mismatch'); // §3.3
  // azp: aud が複数または azp 存在時に client_id 一致を検証
  if (payload.azp && payload.azp !== process.env.OIDC_CLIENT_ID) throw new Error('azp mismatch');
  return payload; // sub を (iss, sub) で識別子に
}
```

### 20.3. BFF パターン（サーバー側コールバック処理の骨子）

```typescript
// ✅ BFF: トークンはサーバーが保持、ブラウザにはHttpOnlyセッションCookieのみ
import { cookies } from 'next/headers';

export async function handleCallback(code: string, state: string) {
  const session = await getServerSession();           // 事前にstate/PKCEを束縛
  if (state !== session.oauthState) throw new Error('state mismatch'); // §3.2

  const token = await exchangeCodeForToken({
    code,
    codeVerifier: session.codeVerifier,               // §3.1
    redirectUri: process.env.REDIRECT_URI!,           // §2.3 完全一致
    clientId: process.env.OIDC_CLIENT_ID!,
    clientSecret: process.env.OIDC_CLIENT_SECRET!,    // Confidential（サーバーのみ）
  });

  await storeTokensServerSide(session.id, token);     // §14.2 トークンはサーバー保管
  cookies().set('sid', session.id, { httpOnly: true, secure: true, sameSite: 'lax' });
}
```

### 20.4. DPoP Proof 生成（クライアント側）

```typescript
// ✅ DPoP Proof（RFC 9449）。§13.1
import { generateKeyPair, exportJWK, SignJWT } from 'jose';

const { privateKey, publicKey } = await generateKeyPair('ES256'); // 鍵対は再利用

export async function createDPoPProof(method: string, url: string, nonce?: string): Promise<string> {
  const jwk = await exportJWK(publicKey);
  return new SignJWT({
    htm: method,                 // HTTPメソッド
    htu: url,                    // クエリ/フラグメント除去後のURI
    jti: crypto.randomUUID(),    // リプレイ防止
    ...(nonce ? { nonce } : {}), // DPoP-Nonce
  })
    .setProtectedHeader({ alg: 'ES256', typ: 'dpop+jwt', jwk })
    .setIssuedAt()
    .sign(privateKey);
}
```

### 20.5. Google ID Token 検証（google-auth-library）

```typescript
// ✅ Sign in with Google のID Tokenをサーバー検証。§7.2
import { OAuth2Client } from 'google-auth-library';

const client = new OAuth2Client();

export async function verifyGoogleIdToken(idToken: string) {
  const ticket = await client.verifyIdToken({
    idToken,
    audience: process.env.GOOGLE_CLIENT_ID!, // aud 検証
  });
  const payload = ticket.getPayload()!;       // iss/exp/署名はライブラリが検証
  if (!payload.email_verified) throw new Error('email not verified'); // §8.2
  return { sub: payload.sub, email: payload.email }; // 識別は sub
}
```

---

## §21. アンチパターン集

> [!CAUTION]
> 以下はいずれも本ファイルで**禁止または重大リスク**。発見時は §000 の Zero Tolerance Protocol に従い即時是正する。

| # | アンチパターン | リスク | 正しい対応 |
|:--|:-------------|:------|:----------|
| 1 | Implicit Flow（`response_type=token`）の使用 | トークンのURL露出・漏洩 | Authorization Code + PKCE（§2.1） |
| 2 | ROPC（パスワードグラント）でログイン | 資格情報直接扱い・MFA不可 | リダイレクトベース認可（§2.2） |
| 3 | トークンを `localStorage`/`sessionStorage` に保存 | XSS で窃取 | BFF + HttpOnly Cookie（§14） |
| 4 | redirect URI のワイルドカード/部分一致 | トークン横取り・Open Redirect | 完全一致登録（§2.3） |
| 5 | `nonce` 未検証 | ID Token リプレイ | nonce 生成・検証（§3.3, §5.1） |
| 6 | `state` 未検証 | CSRF / コードインジェクション | state 束縛・検証（§3.2） |
| 7 | ID Token の署名検証を省略（`decode` のみ） | トークン偽造受容 | JWKS 署名検証（§5, §6） |
| 8 | `aud`/`iss` 未検証 | トークン置換・Confused Deputy | 全クレーム検証（§5.1, §5.2） |
| 9 | `alg` をトークンヘッダーから動的選択 | `alg=none`/HS降格攻撃 | alg ホワイトリスト固定（§5.3） |
| 10 | 同一メールで外部IDを自動リンク | アカウント乗っ取り | 明示的リンク+事前検証（§8） |
| 11 | `email_verified` を確認せず email を本人確認に使用 | なりすまし | verified 厳格化（§8.2） |
| 12 | `email` をユーザー主キーにする | メール変更/再利用で破綻・乗っ取り | `(iss, sub)` で識別（§4.5） |
| 13 | Refresh Token を無期限・ローテーションなし | 窃取時に永続アクセス | ローテーション+再利用検知（§12） |
| 14 | リフレッシュ再利用検知なし | 窃取検知不能 | family 一括失効（§12.2） |
| 15 | JWKS を毎リクエストでフェッチ | レイテンシ・DoS・可用性低下 | キャッシュ+kid再取得（§6.3） |
| 16 | 未知 `kid` で即エラー | 鍵ローテーションで全面障害 | JWKS 再取得（§6.2） |
| 17 | Public Client に `client_secret` をバンドル | secret 抽出・無意味 | PKCE で代替（§1.2） |
| 18 | モバイルで WebView 認可 | 資格情報窃取・PKCE回避 | システムブラウザ+AppAuth（§14.4） |
| 19 | SAML XML 署名未検証 / XSW 脆弱な処理 | Assertion 偽造 | 署名検証+保守ライブラリ（§9.2） |
| 20 | IdP-initiated SSO を無条件受容 | ログインインジェクション/CSRF | SP-initiated 優先（§9.3） |
| 21 | サードパーティCookie依存のサイレント認証 | Cookie廃止で破綻 | FedCM/リダイレクト（§16） |
| 22 | ログアウトをクライアント側トークン削除のみ | サーバー側セッション残存 | サーバー失効+Back-Channel（§17） |
| 23 | 過剰スコープを一括要求 | 過剰権限・同意疲れ・プライバシー侵害 | 最小化+Incremental（§2.4） |
| 24 | UserInfo の `sub` を ID Token と照合しない | トークン置換 | sub 一致検証（§4.3） |
| 25 | 第三者OAuthアプリの機微スコープ同意をユーザー任意に放任 | Consent Phishing で正規トークン詐取 | admin consent 必須化＋publisher 検証（§2.5） |
| 26 | Device Code Flow を常時有効・コード一致確認なし | Device Code Phishing | 必要時のみ有効化＋短命＋試行制限＋一致確認（§2.6） |
| 27 | 高リスク用途で Bearer トークン単独運用 | AiTM でセッショントークン窃取・再利用 | sender-constrained（DPoP/mTLS）必須（§13.4） |

---

## §22. 成熟度モデル L1–L5

| レベル | 状態 | 主な特徴 |
|:------|:-----|:---------|
| **L1: Ad-hoc** | 場当たり実装 | Implicit/ROPC 残存、localStorage 保管、検証の一部欠落。リスク高 |
| **L2: Basic** | 基本準拠 | Authorization Code + PKCE、`state`/`nonce` 検証、ID Token 署名・`iss`/`aud`/`exp` 検証 |
| **L3: Hardened** | 堅牢化 | Refresh Rotation + 再利用検知、JWKS キャッシュ+ローテーション対応、スコープ最小化、安全なアカウントリンク、SPA は BFF |
| **L4: Advanced** | 高度 | Sender-Constrained（DPoP/mTLS）、PAR/RAR/JARM（高リスク）、Back-Channel Logout、SCIM デプロビジョニング、FedCM 対応、可観測性メトリクス |
| **L5: Optimal** | 最適化 | Zero Trust 継続認可・リスクベース、トランザクション認証連携（§420）、FAPI 2.0 準拠、VC/SD-JWT 等次世代への拡張余地、自動失効・ITDR 連動 |

-   **Action**: 自プロジェクトの現在地を評価し、最低 **L3** を目標とする。金融・医療・エンタープライズSSOは **L4以上**を目標とする。

---

## Appendix A: 逆引き索引

> **使い方**: タスクに関連するキーワードで検索し、該当セクションを特定してください。

| キーワード | 該当セクション |
|:----------|:-------------|
| OAuth 2.1, Authorization Code, Grant | §2 |
| Implicit Flow, ROPC, 禁止フロー | §2.2, §21 |
| Consent Phishing, 不正同意, admin consent, publisher 検証 | §2.5 |
| Device Code Phishing, Device Authorization Grant, RFC 8628 | §2.6 |
| AiTM, Adversary-in-the-Middle, トークン窃取, sender-constrained | §13.4 |
| acr, amr, RFC 8176, AAL/IAL/FAL マッピング | §15.5（→420） |
| SD-JWT, RFC 9901, SD-JWT VC, I-D | §18.2 |
| PKCE, code_verifier, code_challenge, S256 | §3.1, §20.1 |
| state, CSRF | §3.2, §21 |
| nonce, リプレイ防止 | §3.3, §5.1 |
| redirect URI, 完全一致, Open Redirect | §2.3 |
| scope, 最小化, Incremental Authorization | §2.4, §19.6 |
| OIDC, OpenID Connect, Discovery | §4 |
| ID Token 検証, iss, aud, exp, at_hash, azp | §5, §20.2 |
| JWKS, kid, 署名鍵, ローテーション, キャッシュ | §6 |
| alg, none, 降格攻撃, HS256 | §5.3 |
| Google, Sign in with Google, GIS | §7.2, §20.5 |
| Apple, Sign in with Apple, private relay | §7.3 |
| Microsoft, Entra ID, tid, MSAL | §7.4 |
| GitHub, OAuth App, GitHub App | §7.5 |
| アカウントリンク, 乗っ取り, ATO, email_verified | §8 |
| ユーザー識別子, sub, iss, email 主キー | §4.5, §8.3 |
| SAML 2.0, Assertion, XSW, IdP-initiated | §9 |
| SSO, SP, IdP, エンタープライズ | §1, §9 |
| JIT プロビジョニング, SCIM, デプロビジョニング | §10 |
| トークン有効期限, Access Token, 短命 | §11.1 |
| Introspection, Revocation, 失効 | §11.3, §11.4 |
| Refresh Token, ローテーション, 再利用検知, family | §12 |
| DPoP, Sender-Constrained, cnf, jkt | §13.1, §20.4 |
| mTLS, Certificate-Bound, x5t#S256, FAPI | §13.2 |
| BFF, localStorage 回避, トークン保管 | §14 |
| モバイル, AppAuth, WebView 禁止, Keychain | §14.4 |
| PAR, RAR, authorization_details | §15.1, §15.2 |
| JAR, JARM, request オブジェクト | §15.3 |
| Token Exchange, ダウンスコープ | §15.4 |
| FedCM, サードパーティCookie | §16 |
| ログアウト, RP-Initiated, Back-Channel Logout | §17 |
| セッション同期, グローバルログアウト | §17.3 |
| Verifiable Credentials, SD-JWT, OID4VCI, ウォレット | §18 |
| 可観測性, OAuth エラー, トークンメトリクス | §19.1 |
| FinOps, MAU 課金, トークン検証コスト | §19.2 |
| パフォーマンス, JWKS キャッシュ | §19.3, §6.3 |
| Zero Trust, Identity-First | §19.5 |
| プライバシー, 同意, 過剰開示 | §19.6 |
| 責任分界点, RP, AS, RS, IdP, クライアント種別 | §1 |
| Hybrid Flow, c_hash, response_type | §4.6 |
| Step-Up, 再認証, acr, amr | §15.5（→420） |
| アンチパターン | §21 |
| 成熟度モデル, L1-L5, FAPI 2.0 | §22 |

---

## Appendix B: クロスリファレンス

> **クロスリファレンス（関連ルールファイル）**:
> - [`security/000_security_privacy.md`](./000_security_privacy.md) — §3.5 IDフェデレーション&SSO、§4.4 Social Login、§4.10 OAuth 2.1 & DPoP、§6 セッション管理、§9.5 ダークパターン
> - [`security/400_authentication_and_passkeys.md`](./400_authentication_and_passkeys.md) — Passkey/FIDO2/WebAuthn、MFA、パスワードポリシー、IDaaS
> - [`security/420_step_up_auth_and_sensitive_operations.md`](./420_step_up_auth_and_sensitive_operations.md) — Step-Up 再認証、acr/amr、トランザクション認証、高リスク操作
> - [`security/200_oss_compliance.md`](./200_oss_compliance.md) — 依存ライブラリ（jose 等）のサプライチェーン管理
> - [`engineering/100_api_integration.md`](../engineering/100_api_integration.md) — 外部API連携、Webhook 署名検証、トークン利用
> - [`engineering/300_web_frontend.md`](../engineering/300_web_frontend.md) — CSP/Trusted Types、Cookie、フロントエンドセキュリティ
> - [`engineering/500_firebase_gcp.md`](../engineering/500_firebase_gcp.md) — Firebase Auth、Google Identity、GCP IAM

### クロスリファレンス

| セクション | 関連ルール |
|-----------|------------|
| §1–§6（OAuth/OIDC 中核・検証） | `security/000_security_privacy`, `engineering/100_api_integration` |
| §7–§8（ソーシャルログイン・リンク） | `security/000_security_privacy`, `engineering/500_firebase_gcp` |
| §9–§10（SSO・SCIM） | `security/000_security_privacy` |
| §11–§14（トークン管理・BFF） | `security/000_security_privacy`, `engineering/300_web_frontend` |
| §15–§18（高度・FedCM・将来） | `security/420_step_up_auth_and_sensitive_operations` |
| §19–§22（多角観点・実装・成熟度） | `security/400_authentication_and_passkeys`, `engineering/300_web_frontend` |

---
