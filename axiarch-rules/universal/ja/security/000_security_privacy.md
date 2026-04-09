# 60. セキュリティとプライバシー (Security & Privacy)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-03-28

> [!IMPORTANT]
> **Level 1 Priority: Absolute Compliance**
> セキュリティと法的コンプライアンスは**最上位の優先事項**です。
> ユーザーの利便性、開発速度、収益性、これら全てよりも優先されます。
> **30パート・90+セクション構成。**

> [!CAUTION]
> **Supreme Directive (最高指令)**
> 個人情報保護とセキュリティは、機能要件・納期・コストよりも常に優先されます。
> 本ドキュメントの内容に違反するコードは、いかなる理由があっても本番環境へデプロイしてはなりません。
>
> **The Zero Tolerance Protocol**:
> リスクに気づいた時点で、その大小や発生確率に関わらず、**例外なく・即座に・徹底的に** 対応してください。

---

## 目次

- §1. 最高指令・優先順位
- §2. ゼロトラストアーキテクチャ
- §3. Identity-First Security & ITDR
- §4. 認証・認可アーキテクチャ
- §5. Passkey・パスワードレス戦略
- §6. セッション管理・アカウント保護
- §7. プライバシー・バイ・デザイン
- §8. データ分類・DSPM
- §9. 同意管理・データ主体の権利
- §10. APIセキュリティ
- §11. サプライチェーンセキュリティ
- §12. インフラセキュリティ
- §13. SASE・ネットワークセキュリティ
- §14. コンテナ・クラウドネイティブセキュリティ
- §15. ファイルアップロードセキュリティ
- §16. 暗号化ポリシー・PQC
- §17. AI/LLMセキュリティ
- §18. Agentic AI・MCP/A2Aセキュリティ
- §19. セキュアSDLC（Shift-Left Security）
- §20. GraphQLセキュリティ
- §21. シークレットマネジメント
- §22. クライアントサイドセキュリティ
- §23. ボット管理・DDoS防御
- §24. セキュリティ品質基準
- §25. 高度セキュリティ運用・SecOps
- §26. セキュリティ可観測性
- §27. 委託先セキュリティ管理
- §28. 規制コンプライアンス深化
- §29. セキュリティガバナンス
- §30. 成熟度モデル・アンチパターン
- 言語固有セクション
- Appendix A: 逆引き索引

---

## §1. 最高指令・優先順位 (Supreme Directive & Golden Rule)

### 1.1. 優先順位階層

-   **Legal & Security > User Experience > Revenue > DX**:
    -   **鉄則**: 「ユーザーが望んでも、法的にリスクがあるなら提供しない」。
    -   **例**: ユーザーが「ログインなしで履歴を見たい」と望んでも、プライバシーリスクがあるなら却下。「オフラインで決済したい」と望んでも、セキュリティリスクがあるなら却下。

### 1.2. Assume Breach（侵害前提設計）

-   侵害は「もし起きたら」ではなく「いつ起きるか」の問題として設計する。
-   侵害発生時の被害範囲（Blast Radius）を最小化する設計を常に優先する。
-   **Harvest Now, Decrypt Later**: 現在の暗号化データが将来の量子コンピュータで復号されるリスクを考慮した設計を義務付ける（§16.4 PQC参照）。

### 1.3. Defense in Depth（多層防御原則）

-   単一の防御策に依存しない。認証・認可・暗号化・監視・ネットワーク分離を重畳的に適用する。
-   いずれか1層が突破されても残りの層が機能する設計を義務付ける。
-   **セキュリティレイヤー最小構成**:

| レイヤー | 必須対策 |
|:--------|:---------|
| **ネットワーク** | WAF + CDN + DDoS緩和 + VPC分離 |
| **アイデンティティ** | IDaaS + MFA/Passkey + RBAC/ABAC |
| **アプリケーション** | 入力検証 + CSP + CORS + CSRF防御 |
| **データ** | 暗号化(at-rest/in-transit) + RLS + マスキング |
| **エンドポイント** | デバイスポスチャ + SRI + Trusted Types |
| **監視** | SIEM + 監査ログ + 異常検知 |

### 1.4. セキュリティ・チャンピオン文化

-   セキュリティは専門チームだけの責務ではなく、**全エンジニアの基本責務**。
-   「セキュリティは後回し」「リリース後に対応」は**設計上の欠陥**とみなす。

---

## §2. ゼロトラストアーキテクチャ (Zero Trust Architecture)

> **参考規格**: NIST SP 800-207, CISA Zero Trust Maturity Model v2.0, NIST CSF 2.0

### 2.1. 基本原則

-   **Rule 2.1.1: The Untrusted Default**: 内部ネットワーク、管理者アカウント、AIエージェントを含む**全てのアクセス主体を「信頼しない」**前提で、**認証(Authentication)**、**認可(Authorization)**、**暗号化(Encryption)** を強制する。
-   **Rule 2.1.2: Least Privilege**: 全てのアクセスは、目的遂行に必要な**最小限の権限**のみ付与する。JIT（Just-In-Time）アクセスを推奨。
-   **Rule 2.1.3: Microsegmentation**: ネットワークを細分化し、侵害時の横移動（Lateral Movement）を物理的に阻止する。
-   **Rule 2.1.4: Continuous Verification**: セッション中であっても、リスクスコアの変化（異常IP、地理的異動、デバイス変更）を検知した場合は**再認証を強制**。
-   **Rule 2.1.5: Deny by Default**: 明示的に許可されていないアクセスは全て拒否。

### 2.2. CISA Zero Trust Maturity Model v2.0 準拠

-   **Law**: CISAゼロトラスト成熟度モデル v2.0の5柱 + 3横断能力を参照フレームワークとする。

| 柱 | 対策義務 |
|:---|:---------| 
| **1. Identity** | IDaaS必須。MFA/Passkey強制。フィッシング耐性MFA推奨。NHI管理（§3参照） |
| **2. Device** | 管理デバイスからのアクセスを優先。デバイスポスチャ検証。EDR/XDR統合推奨 |
| **3. Network** | VPC、プライベートサブネット必須。パブリックDB禁止。SASE統合推奨（§13参照） |
| **4. Application** | 全エンドポイントで入力検証・認可チェック。WAF必須。API Gateway（§10参照） |
| **5. Data** | 保存時・転送時暗号化必須。データ分類（§8参照）に基づく保護。DSPM導入推奨 |

| 横断能力 | 要件 |
|:---------|:-----|
| **Visibility & Analytics** | 全レイヤーの統合ログ収集・リアルタイム監視。SIEM連携必須 |
| **Automation & Orchestration** | SOAR統合。セキュリティインシデントの自動対応ワークフロー |
| **Governance** | NIST CSF 2.0 Govern関数準拠。リスクアペタイト定義。RACI明確化 |

-   **成熟度段階**: Traditional → Initial → Advanced → Optimal の4段階で組織の現在地を評価し、段階的に成熟度を向上させる。

### 2.3. NIST CSF 2.0 Govern関数との連携

-   **Law**: NIST CSF 2.0で新設された「Govern」関数に準拠し、セキュリティリスク管理をエンタープライズリスク管理（ERM）に統合する。
-   **Action**:
    1.  **リスクアペタイト定義**: 組織として許容可能なリスクレベルを明文化し、§29のガバナンスフレームワークに反映。
    2.  **役割と責任**: セキュリティに関する意思決定者・責任者・実行者を明確に定義。
    3.  **サプライチェーンリスク**: ゼロトラストの原則を委託先・サブプロセッサーにも適用（§27参照）。
    4.  **Shadow AI管理**: 未承認のAIツール利用を検出・統制するポリシーを策定。
-   **Cross-Reference**: §29 (セキュリティガバナンス)

### 2.4. Identity-First Zero Trust

-   **Law**: ゼロトラストの起点は**アイデンティティ**。ネットワーク境界ではなくIDを新しい境界（New Perimeter）として設計する。
-   **Action**:
    1.  全アクセスリクエストをID検証から開始。ネットワーク位置による信頼をゼロにする。
    2.  人間ID・非人間ID（NHI）・AIエージェントIDを統一的に管理（§3参照）。
    3.  リスクベースの動的認可（コンテキストアウェア・アクセス）を推奨。
-   **Cross-Reference**: §3 (Identity-First Security & ITDR)

---

## §3. Identity-First Security & ITDR

> **参考規格**: CISA ZTMM Identity Pillar, NIST SP 800-63-4, ISO/IEC 24760

### 3.1. 統合ID管理フレームワーク

-   **Law**: 人間ID、非人間ID（NHI）、AIエージェントIDを**統一されたIDファブリック**で管理する。
-   **Action**:
    1.  **IDインベントリ**: 全ID（ユーザーアカウント、サービスアカウント、APIキー、CI/CDパイプライン、AIエージェント）の棚卸しと所有者の明確化。
    2.  **IDライフサイクル管理**: プロビジョニング → 利用 → 変更 → 無効化 → 削除を自動化。
    3.  **IAMプラットフォーム統合**: IDaaS（Firebase Auth, Auth0, Cognito等）を唯一のIDプロバイダーとし、自前の認証基盤構築を禁止。
    4.  **Orphaned ID検出**: 退職者・不使用のIDを定期的に検出し、自動無効化。

### 3.2. 非人間ID管理 (Non-Human Identity Management)

-   **Law**: NHIは人間IDの**45倍以上**存在し（業界調査）、セキュリティ侵害の主要ベクトルとなっている。NHIを人間IDと同等の厳格さで管理する。
-   **NHI分類**:

| NHI種別 | 例 | リスクレベル |
|:--------|:---|:-----------|
| **サービスアカウント** | GCP Service Account, AWS IAM Role | High |
| **APIキー** | 外部SaaS連携キー | High |
| **CI/CDクレデンシャル** | GitHub Actions secrets, deploy keys | Critical |
| **AIエージェント** | MCP Client, A2A Agent | Critical |
| **Bot/自動化** | Cron jobs, Webhook handlers | Medium |
| **証明書/トークン** | mTLS証明書, OAuth client credentials | High |

-   **Action**:
    1.  **所有者割り当て**: 全NHIに人間の所有者を必ず割り当て。所有者不明のNHIは即時無効化候補。
    2.  **最小権限**: NHIに付与するスコープを目的遂行に必要な最小限に限定。広範な権限（`admin`, `*`）を持つNHIを定期的に監査。
    3.  **短命クレデンシャル**: 静的キーよりも**動的・短命シークレット**を優先（§21.3参照）。
    4.  **ローテーション強制**: NHIのシークレットは人間のものより**短いローテーション周期**を適用（§21.5参照）。
    5.  **利用パターン監視**: NHIの通常利用パターンをベースライン化し、異常を即時検出。
-   **Anti-Pattern**: サービスアカウントを共有し、複数のサービスで同一クレデンシャルを使い回すこと。
-   **Cross-Reference**: §21 (シークレットマネジメント), §18 (Agentic AI)

### 3.3. Identity Threat Detection & Response (ITDR)

-   **Law**: ID関連の攻撃（Credential Stuffing、アカウントテイクオーバー、権限昇格、Lateral Movement）をリアルタイムで検出し、自動対応する。
-   **検出対象パターン**:

| 脅威パターン | 検出手法 | 自動対応 |
|:-----------|:---------|:---------|
| **Credential Stuffing** | 同一IPからの複数アカウント認証失敗 | IP一時ブロック + CAPTCHA強制 |
| **アカウントテイクオーバー (ATO)** | 異常な地理的ログイン、デバイス変更 | セッション無効化 + 再認証要求 |
| **権限昇格** | 通常と異なるロール変更パターン | 変更ブロック + 管理者アラート |
| **Lateral Movement** | 複数サービスへの連続アクセスパターン | セッション隔離 + 調査開始 |
| **Golden Ticket / Silver Ticket** | Kerberos異常 | 全セッション無効化 |
| **MFA Fatigue攻撃** | 短時間に大量のMFAプッシュ要求 | MFAプッシュ一時停止 + 通知 |

-   **Action**:
    1.  **行動ベースライン**: ユーザー/NHIごとに正常行動プロファイルを構築。逸脱をリスクスコアに反映。
    2.  **リアルタイムリスクスコアリング**: ログイン試行ごとにリスクスコアを計算。閾値超過時は段階的に防御（CAPTCHA→MFA→ブロック）。
    3.  **SIEM/XDR統合**: ITDR検出イベントをSIEM/XDRに送信し、相関分析を実行。
    4.  **自動修復**: 高リスクイベントに対する自動対応ワークフロー（SOAR連携）を構築。
-   **Cross-Reference**: §6 (セッション管理), §26 (セキュリティ可観測性)

### 3.4. Privileged Access Management (PAM)

-   **Law**: 特権アカウント（管理者、DBA、インフラ管理者）は**最も攻撃価値の高い標的**。特権アクセスを厳格に管理する。
-   **Action**:
    1.  **JIT (Just-In-Time) Access**: 特権は常時付与せず、必要時に一時的に付与し、タスク完了後に自動回収。
    2.  **JEA (Just Enough Administration)**: 特権の範囲を必要最小限に限定。フルAdmin権限の常時付与を禁止。
    3.  **特権セッション記録**: 特権セッションの操作を全て録画・記録。事後監査に使用。
    4.  **ブレイクグラス手順**: 緊急時の特権アクセス手順を事前定義。使用後は即座に監査・報告。
    5.  **Standing Privilege Zero Goal**: 恒常的な特権アカウント数をゼロに近づける長期目標を設定。

### 3.5. IDフェデレーション & SSO

-   **Law**: 複数サービス間でのID管理を統一し、パスワード増殖を防止する。
-   **Action**:
    1.  **SSO必須**: 社内ツール・管理画面はSSO（SAML 2.0 / OIDC）で統一認証。個別認証を非推奨。
    2.  **SCIM (System for Cross-domain Identity Management)**: ユーザーのプロビジョニング/デプロビジョニングを自動化。
    3.  **条件付きアクセス**: デバイスポスチャ、ネットワーク位置、リスクスコアに基づく動的アクセス制御。

---

## §4. 認証・認可アーキテクチャ (Authentication & Authorization)

### 4.1. Credential Hygiene

-   APIキー・シークレット・DB接続文字列のソースコード記述を**物理的に禁止**。必ず `process.env` を使用。
-   機密情報の共有には1Password等の暗号化チャネルを使用。**Slack貼り付け禁止**。
-   **CI Gate**: `git-secrets` / `gitleaks` をpre-commitフックに組み込み、シークレットのコミットを物理的に阻止する。

```typescript
// ❌ PROHIBITED: ハードコードされたシークレット
const supabase = createClient(
  'https://xxx.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
);

// ✅ CORRECT: 環境変数経由
const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
);
```

### 4.2. MFA (多要素認証)

-   管理者権限アカウントには**MFA強制**。例外なし。
-   **Passkey/FIDO2/WebAuthn推奨**: フィッシング耐性のある認証方式を**最優先**で採用する（§5で詳述）。
-   **SMS OTP非推奨**: SIMスワップ攻撃・SS7プロトコル脆弱性により、SMS OTPは**高リスク操作の唯一の第2要素としては不十分**。TOTP/Passkey/ハードウェアキーを優先。
-   **MFA Fatigue対策**: 短時間の大量プッシュ通知を検知し、自動ブロック + ユーザー通知。Number Matching（番号照合）方式を推奨。

### 4.3. IDaaS必須

-   自前の認証基盤構築は禁止。Firebase Auth, Auth0, Cognito 等の検証済みソリューションを使用。
-   **Rationale**: 認証は「一度間違えると全ユーザーが危険にさらされる」極めてリスクの高い基盤。独自実装はパスワードハッシュの不備、タイミング攻撃、セッション管理の欠陥等を招く。

### 4.4. Social Login Security Protocol

-   **Authorization Code Flow + PKCE 必須**: Implicit Flow 禁止。
-   **CSRF Prevention**: `state` パラメータ必須。
-   **Server-Side Token Exchange**: `client_secret` はサーバーサイドでのみ使用。
-   **Scope Minimization**: `openid`, `email`, `profile` 等最小限に限定。
-   **Explicit Account Link**: 同一メールの既存アカウントとの自動リンク禁止。確認UIを表示。
-   **Session Verification**: `iss`, `aud`, `exp` の全フィールド検証。

### 4.5. RBAC / ABAC 設計

-   **Admin Privilege Verification (SSOT)**: `public.profiles` テーブルの `role` カラムを唯一の正とする。フロントエンドフラグ・遺物テーブルへの依存は**セキュリティホール**。
-   **The Guardian Protocol (Centralized Auth)**: 権限チェックロジックの散在を禁止。集約されたガード関数（例: `admin-guard.ts`）を使用。

```typescript
// ❌ ANTI-PATTERN: 各ファイルで個別にロールチェック
const { data } = await supabase.from('profiles').select('role').eq('id', userId);
if (data?.role !== 'admin') throw new Error('Unauthorized');

// ✅ CORRECT: 集約されたガード関数
import { requireAdmin } from '@/lib/auth/admin-guard';
const user = await requireAdmin(); // 内部で認証+認可+監査ログを一元実行
```

-   **Role Enumeration Symmetry**: 同一ドメインを検証する複数のガード関数は**共通の定数配列**からロール一覧を取得する。
-   **Unconditional Baseline Auth**: 特権クライアントを使用するアクション層のハンドラは、データのステータスに関わらず**全コードパスで認証・認可チェックを実行**。
-   **ABAC推奨**: 単純なRBACでは不十分な場合（マルチテナント、細粒度アクセス制御）、属性ベースアクセス制御（ABAC）を導入。

### 4.6. RBAC Defense Protocol

-   全Admin API/Actionは冒頭でRBACチェックを強制。
-   金銭・権限・削除操作はRBACに加え Turnstile/OTP 追加認証必須。
-   全Admin操作を監査ログに記録。破壊的操作は変更前後の差分を含める。

### 4.7. Omnichannel Auth

-   Webクッキーだけでなく **Bearer Token (JWT)** にも完全対応。Server Actions側の検証省略は禁止。

### 4.8. API Key Security

-   **Hashing Mandate**: API Key は**厳正に平文保存しない**。SHA-256等でハッシュ化して保存。
-   **Dual Auth Protocol**: `X-API-KEY` と `Authorization: Bearer` の OR条件で実装。
-   **Prefix Design**: API Keyにプレフィックス（例: `sk_live_`, `pk_test_`）を付与し、種別・環境を識別可能にする。

### 4.9. Password Policy

-   **Law**: パスワードポリシーはNIST SP 800-63B / 800-63-4に準拠する。
-   **要件**:
    -   **最低長**: 8文字以上（管理者: 12文字以上）。
    -   **文字種別強制なし**: NIST SP 800-63Bに従い、大文字/記号必須といった複雑性ルールは**推奨しない**。
    -   **流出パスワード検査**: 新規設定・変更時に **Have I Been Pwned API** 等で流出済みパスワードとの照合。
    -   **定期変更強制なし**: NIST推奨に従い、定期的なパスワード変更強制は**行わない**（漏洩が確認された場合を除く）。
    -   **パスワード強度メーター**: ユーザーにリアルタイムの強度フィードバックを提供（zxcvbnライブラリ等）。
    -   **パスワードハッシュ**: 保存には**Argon2id**（推奨）または **bcrypt** (cost=12以上) を使用。SHA-256/MD5での保存は絶対禁止。
-   **Cross-Reference**: §16.2 (推奨アルゴリズム), §4.2 (MFA)

---

## §5. Passkey・パスワードレス戦略 (Passkey & Passwordless Strategy)

> **参考規格**: FIDO Alliance, W3C WebAuthn Level 3, NIST SP 800-63B Supplement

### 5.1. 戦略的方向性

-   **Law**: Passkey（FIDO2/WebAuthn）をパスワードレス認証の戦略的方向性として位置付け、段階的移行計画を策定する。
-   **背景**: 2025年時点で15億以上のオンラインアカウントがPasskeyに対応。87%のエンタープライズがPasskey導入を推進中（FIDO Alliance調査）。

### 5.2. Passkey分類

| 種類 | 特徴 | 用途 |
|:-----|:-----|:-----|
| **Synced Passkey** | クラウド同期（iCloud Keychain/Google等）。デバイス間利用可能 | 一般ユーザー向け。利便性重視 |
| **Device-Bound Passkey** | 特定デバイス/ハードウェアキーに固定。同期なし | 管理者・高リスク操作向け。セキュリティ重視 |

### 5.3. 段階的導入ロードマップ

| フェーズ | アクション | 目標 |
|:--------|:---------|:-----|
| **Phase 1** | Passkey登録をオプションとして提供 | 認知度向上 |
| **Phase 2** | パスワード + Passkey併用。Passkey推奨UI | 採用率30%+ |
| **Phase 3** | Passkey優先。パスワードをフォールバックに | 採用率70%+ |
| **Phase 4** | パスワードレス完全移行（Passkey-only） | 長期目標 |

### 5.4. Account Recovery

-   **法**: Passkey紛失時のリカバリー手段を複数用意する。
-   **Action**:
    1.  **バックアップPasskey**: ユーザーに複数のPasskey登録を推奨（デバイス + クラウド同期）。
    2.  **リカバリーコード**: ワンタイムリカバリーコード（オフライン保存推奨）を提供。
    3.  **段階的リカバリー**: メール/SMS + 本人確認書類 + 待機期間の多段階プロセス。
    4.  **フィッシング耐性維持**: パスワードリセットへのフォールバックはフィッシング耐性を損なわない方式で設計。

### 5.5. 管理者アカウントのPasskey要件

-   **Device-Bound Passkey必須**: 管理者アカウントにはYubiKey等のハードウェアキーを**必須**とする。
-   Synced Passkeyのみでの管理者認証は**不可**。

### 5.6. UX設計原則

-   **平易な言語**: 「Face ID/指紋でログイン」等のユーザーフレンドリーな表現を使用。技術用語（WebAuthn, FIDO2）はUI上で避ける。
-   **Cross-Platform**: 全主要プラットフォーム（iOS/Android/Windows/macOS/Linux + 主要ブラウザ）でのPasskey互換性を保証。
-   **Conditional UI**: WebAuthn Conditional Mediation (`mediation: 'conditional'`) によるPasskeyオートフィルを推奨。
-   **Cross-Reference**: §4.2 (MFA), §29 (セキュリティガバナンス)

---

## §6. セッション管理・アカウント保護 (Session Management & Account Protection)

### 6.1. Token Expiration（トークン有効期限設計）

| トークン種別 | 推奨有効期限 | 管理画面向け |
|:-----------|:-----------|:-----------|
| **Access Token** | ≤ 1時間 | ≤ 15分 |
| **Refresh Token** | 7〜30日 | ≤ 7日 |
| **Session Cookie** | ブラウザセッション | ブラウザセッション |
| **Signed URL** | ≤ 5分 | ≤ 5分 |

### 6.2. Step-Up Authentication

-   パスワード変更、決済操作、メールアドレス変更等の高リスク操作時は、現在のセッションが有効であっても**再認証（Step-Up Auth）**を要求する。
-   **Tiered Security Protocol**:

| ティア | 操作例 | 必要認証 |
|:------|:------|:--------|
| **Tier 1: 閲覧** | データ参照 | 通常認証 |
| **Tier 2: 変更** | プロフィール更新 | 通常認証 + RBAC |
| **Tier 3: 金銭・権限** | 決済、ロール変更 | RBAC + Turnstile + OTP |
| **Tier 4: 破壊的** | アカウント削除、全データパージ | RBAC + OTP + 管理者承認 |

### 6.3. Concurrent Session Policy

-   同時ログインデバイス数に上限を設定。超過時は最古セッション無効化。
-   管理者アカウントにはより厳格な制限（同時1〜2セッション）を適用。
-   「すべてのデバイスからログアウト」機能の提供を推奨。

### 6.4. Suspicious Session Detection

-   同一アカウントへの異なるIP/地理的に離れた地域からの同時アクセスを検出し、ユーザーに通知。
-   **Impossible Travel Detection**: 物理的に不可能な移動速度でのアクセス切り替え（東京→ロンドンを5分以内等）を自動検知。
-   **Cross-Reference**: §3.3 (ITDR)

### 6.5. Server-Side Invalidation

-   ログアウト時はサーバーサイドで即時無効化。クライアント側のトークン削除のみでは不十分。
-   アカウント停止・削除時は全セッションを即時無効化する。
-   **Token Revocation List**: 無効化されたトークンのリストを管理し、検証時に照合。

### 6.6. Account Lockout & Brute Force Prevention

-   **Law**: 繰り返しの認証失敗に対し、段階的なロックアウトを適用し、ブルートフォース攻撃を構造的に防止する。

| 失敗回数 | アクション |
|:---------|:-----------|
| 3回 | CAPTCHA（Turnstile）を要求 |
| 5回 | **15分間ロック** + メール通知 |
| 10回 | **1時間ロック** + 管理者アラート |
| 20回 | **アカウント凍結** + 管理者手動解除必要 |

-   **IPベース制限**: 同一IPからの異なるアカウントへの繰り返し失敗（Credential Stuffing）も検知・ブロック。
-   **Constant-Time Comparison**: 認証失敗時のレスポンス時間を一定に保ち、**タイミング攻撃**を防止。
-   **エラーメッセージ**: 「メールアドレスまたはパスワードが正しくありません」のように、どちらが不正かを明かさない統一メッセージを返却。

### 6.7. The Secret Rotation Lifecycle

-   IAMクレデンシャルやJWT署名鍵は **90日ごと** にローテーション。
-   **Panic Button（Kill Switch）**: 漏洩時の全セッション一括無効化手順を常に最新状態で維持。

### 6.8. The Physical Master Key (Bus Factor Defense)

-   極めて重要なリカバリー情報は**物理媒体（紙）**に記録し、耐火金庫に保管。
-   **Scope**: `service_role` キー、Cloudflare Recovery Code、ドメインロックコード、1Passwordマスターキー。

### 6.9. Digital Legacy Protocol

-   **Law**: ユーザーの長期間不活性時のデータ取り扱い方針を利用規約に明記する。
-   「1年間ログインなし」→ 通知 → 「3年間ログインなし」→ アカウント無効化＋PII匿名化（§9.3準拠）。

---

## §7. プライバシー・バイ・デザイン (Privacy by Design)

> **参考規格**: ISO 31700, GDPR Art.25, Global Privacy Laws, CCPA/CPRA

### 7.1. 7原則の適用

-   **Law**: Ann Cavoukianのプライバシー・バイ・デザイン7原則を設計段階から組み込む。

| # | 原則 | 実装義務 |
|:--|:-----|:---------|
| 1 | 事後対応ではなく予防 | 設計レビューでプライバシーリスクを事前特定 |
| 2 | デフォルトでプライバシー保護 | オプトイン型のデータ収集。収集範囲のデフォルト最小化 |
| 3 | 設計に組み込む | PIA（プライバシー影響評価）を設計フェーズで実施 |
| 4 | ゼロサムではない | プライバシーと機能性の両立を設計目標とする |
| 5 | ライフサイクル全体の保護 | 収集→保存→利用→廃棄の全段階で保護 |
| 6 | 透明性 | 利用目的・保存期間・第三者提供をプライバシーポリシーで明示 |
| 7 | ユーザー中心 | ユーザーが自身のデータを管理・削除できるUIを提供 |

### 7.2. データ最小化原則

-   **Law**: 目的外データ、過剰データの収集を構造的に禁止する。
-   **Action**:
    1.  各データ項目に「収集目的」「法的根拠」「保存期間」を定義（Data Catalog義務）。
    2.  `SELECT *` 禁止。必要カラムのみ明示的に取得。
    3.  DTOパターンで内部構造を外部に露出させない。
    4.  不要になったデータは保存期間経過後に自動削除（TTL設計）。

### 7.3. PII感度分類

| 感度 | データ例 | 保護要件 |
|:-----|:---------|:---------|
| **Critical** | パスワードハッシュ、クレジットカード番号 | 強暗号化 + アクセスログ + 2名以上の承認 |
| **High** | 氏名、メールアドレス、電話番号、生年月日 | 暗号化 + RLS + 閲覧ログ |
| **Medium** | 住所、ニックネーム | RLS + 最小権限アクセス |
| **Low** | 設定値、UI設定 | 通常のアクセス制御 |

### 7.4. PII マスキング

-   **Law**: ログ出力・エラーレポート・サポート画面にPIIを**厳正に含めない**。
-   **Action**:
    1.  ログフレームワークにPIIフィルターを組み込み、`email`, `phone`, `name` 等を自動マスキング。
    2.  `console.log(user)` のような生オブジェクトのログ出力を禁止。
    3.  Sentry等のエラートラッキングでもPIIフィルターを設定。

```typescript
// ❌ PROHIBITED: PIIを含むログ出力
console.log('User login:', { email: user.email, name: user.name });

// ✅ CORRECT: PIIをマスキング
console.log('User login:', { userId: user.id, role: user.role });
```

### 7.5. 暗号化要件

| 状態 | 最低要件 |
|:-----|:---------|
| **保存時 (At Rest)** | AES-256 (DB/Storage/Backup全て) |
| **転送時 (In Transit)** | TLS 1.2以上（TLS 1.3推奨） |
| **利用時 (In Use)** | メモリ暗号化推奨（Confidential Computing） |

-   **Cross-Reference**: §16 (暗号化ポリシー・PQC)

### 7.6. Data Residency

-   **Law**: ユーザーデータの保管場所（Country/Region）を意識し、法域要件に準拠する。
-   **Action**:
    1.  サービス提供地域のデータ保護法（GDPR, Global Privacy Laws, CCPA等）を特定。
    2.  DBリージョンをサービス提供地域と同一または法的に許容される地域に配置。
    3.  越境データ転送（Cross-Border Data Transfer）にはSCC/IDTA等の法的枠組みを適用。

---

## §8. データ分類・DSPM (Data Classification & Data Security Posture Management)

### 8.1. データ分類フレームワーク

-   **Law**: 全データ資産を体系的に分類し、分類に基づく保護レベルを自動適用する。

| 分類レベル | 説明 | 保護要件 | 例 |
|:----------|:-----|:---------|:---|
| **Restricted** | 漏洩時に法的制裁・重大損害 | 暗号化+RLS+監査ログ+DLP | PII, PHI, 決済データ |
| **Confidential** | 業務上の機密情報 | 暗号化+RLS+アクセスログ | 内部文書, 顧客リスト |
| **Internal** | 社内向け情報 | RBAC+アクセス制御 | 社内Wiki, 設計書 |
| **Public** | 公開情報 | 改ざん防止のみ | 公開ページ, プレスリリース |

### 8.2. DSPM (Data Security Posture Management)

-   **Law**: クラウド環境全体のデータセキュリティ態勢を継続的に発見・評価・改善する。
-   **Action**:
    1.  **Shadow Data Discovery**: マネージドサービス、ログ、バックアップ内の未管理データを自動発見。
    2.  **データフロー追跡**: 機密データが組織内でどこに流れ、誰がアクセスしているかを可視化。
    3.  **過剰アクセス検出**: 実際のアクセスパターンと付与権限の乖離を検出し、権限を縮小勧告。
    4.  **コンプライアンス態勢評価**: GDPR/Global Privacy Laws/CCPA等の要件に対する現在の遵守状況をスコアリング。
-   **Cross-Reference**: §7.3 (PII感度分類), §29 (セキュリティガバナンス)

### 8.3. データリネージ & カタログ

-   **Law**: 機密データの「どこから来て、どこに流れ、誰が触れるか」を追跡可能にする。
-   **Action**:
    1.  データカタログツールでテーブル/カラム単位のメタデータ（分類レベル、オーナー、保存期間）を管理。
    2.  ETL/ELTパイプラインでのデータ移動時に分類ラベルを自動伝搬。
    3.  **Data Loss Prevention (DLP)**: Restricted分類データの不正なコピー・ダウンロード・外部送信を検出・ブロック。

---

## §9. 同意管理・データ主体の権利 (Consent Management & Data Subject Rights)

### 9.1. 法的コンプライアンスマトリクス

| 法律 | 地域 | 同意要件 | 削除権 | 通知期間 |
|:-----|:-----|:---------|:-------|:---------|
| **GDPR** | EU/EEA | 明示的オプトイン | あり（忘れられる権利） | 72時間以内 |
| **Global Privacy Laws** | 日本 | 利用目的の公表・通知 | あり（開示・訂正・利用停止） | 速やかに |
| **CCPA/CPRA** | カリフォルニア | オプトアウト権 | あり（削除権） | 45日以内 |
| **LGPD** | ブラジル | 明示的同意 | あり | 合理的期間 |
| **PIPA** | 韓国 | 明示的同意 | あり | 遅滞なく |

### 9.2. 同意管理プラットフォーム (CMP)

-   **Law**: Cookie/トラッキング技術はユーザー同意を取得してから開始。「デフォルト同意」は禁止。
-   **Action**:
    1.  CMP（例: OneTrust, Cookiebot, Osano）を導入し、同意の取得・記録・変更を自動化。
    2.  同意カテゴリ（必須/機能/分析/マーケティング）を明確に分類。
    3.  同意拒否時もサービスの基本機能は利用可能にする（同意強制の禁止）。
    4.  同意記録は法的証拠として**最低5年間**保持。

### 9.3. 忘れられる権利（Right to be Forgotten）

-   **Law**: ユーザーからの削除要求に対し、構造的に完全対応する仕組みを構築する。
-   **Action**:
    1.  **物理削除**: PIIを含むレコードは論理削除ではなく**物理削除**。
    2.  **カスケード考慮**: 関連テーブル、ストレージ、バックアップ、CDNキャッシュからもPIIを除去。
    3.  **バックアップ内PII**: バックアップからの個別レコード削除が技術的に困難な場合、暗号化キーの破棄（Cryptographic Erasure）で対応。
    4.  **対応期限**: GDPR=30日以内、CCPA=45日以内。タイマーベースの自動リマインダーを実装。
    5.  **削除証明**: 削除完了の記録（対象データ範囲、削除日時、実行者）を監査ログに記録。
-   **Cross-Reference**: `601_data_governance.md`

### 9.4. データポータビリティ

-   **Law**: ユーザーが自身のデータを構造化された機械可読形式（JSON/CSV）でエクスポートできる機能を提供する。
-   **Action**: エクスポート機能にはレート制限と認証（Step-Up Auth）を適用。バルクエクスポートは非同期処理。

---

## §10. APIセキュリティ (API Security)

> **参考規格**: OWASP API Security Top 10 2023, OWASP Top 10 2025

### 10.1. BOLA / BFLA防御（OWASP API #1 / #5）

-   **BOLA (Broken Object Level Authorization) — API #1**:
    -   **Law**: 全APIエンドポイントでオブジェクトレベルの認可チェックを義務付ける。
    -   **Action**: `GET /api/users/{id}` のように外部IDを受け取る全エンドポイントで、要求者が当該リソースへのアクセス権を持つか検証。
    -   **Supabase**: RLS (Row Level Security) ポリシーで `auth.uid() = user_id` の制約を強制（§24.3参照）。

-   **BFLA (Broken Function Level Authorization) — API #5**:
    -   **Law**: 管理者APIエンドポイントと一般ユーザーAPIエンドポイントを明確に分離し、ロールベースのアクセス制御を適用。
    -   **Anti-Pattern**: URLパスのみで管理者/一般を区別（`/admin/users` vs `/users`）し、バックエンドで認可チェックを省略すること。

### 10.2. Mass Assignment防御（API #3）

-   **Law**: クライアントからの入力をモデルに直接バインドすることを禁止。
-   **Action**: DTOパターンで受け入れるフィールドをホワイトリストで明示的に定義。
-   **Anti-Pattern**: `Object.assign(model, req.body)` 等のバルク代入。

### 10.3. 入力検証 (Input Validation)

-   **Validation at the Edge**: 全ての入力は「信頼できないデータ」として扱い、サーバーサイドで検証する。クライアントサイド検証のみでは不十分。
-   **Zod / Valibot / ArkType必須**: スキーマベースの検証を義務付ける。`any`型での入力受け入れは禁止。

```typescript
// ✅ CORRECT: Zodによる厳格な入力検証
import { z } from 'zod';

const UpdateProfileSchema = z.object({
  nickname: z.string().min(1).max(50).trim(),
  bio: z.string().max(500).optional(),
  // role: z.enum(['admin', 'user']),  ← ❌ ユーザー入力でロール変更不可
});

export async function updateProfile(input: unknown) {
  const validated = UpdateProfileSchema.parse(input);
  // validated のみを使用してDB更新
}
```

### 10.4. SQLインジェクション防御

-   **Parameterized Query Only**: 文字列連結によるSQL構築は**絶対禁止**。ORMまたはパラメータ化クエリのみ使用。
-   **ORMの安全な使用**: Prisma, Drizzle等のORMを使用する場合でも、`$queryRaw` 等の生SQL機能使用時はパラメータ化を強制。

### 10.5. SSRF防御

-   **Law**: サーバーサイドで外部リソースをフェッチする場合、内部ネットワーク（`127.0.0.1`, `10.x`, `172.16.x`, `169.254.169.254`）へのアクセスを構造的に禁止する。
-   **Action**: URLホワイトリスト + DNSリバインディング対策 + メタデータサービスへのアクセスをファイアウォールで遮断。

### 10.6. Rate Limiting / Throttling

-   **Law**: 全APIエンドポイントにレート制限を適用する。
-   **推奨制限値**:

| エンドポイント種別 | 制限値（例） |
|:-----------------|:-----------|
| 認証（ログイン/登録） | 5回/分/IP |
| 一般API | 60回/分/ユーザー |
| 検索/重い処理 | 10回/分/ユーザー |
| 管理者API | 30回/分/ユーザー |
| Webhook受信 | 100回/分/ソース |

-   **Rate Limit Headers**: レスポンスに `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`, `Retry-After` を含める。
-   **Cross-Reference**: §23 (ボット管理)

### 10.7. CORS設計

-   `Access-Control-Allow-Origin: *` は**本番環境で絶対禁止**。
-   **許可ドメインの明示的指定**: ホワイトリスト方式で信頼するオリジンのみ許可。
-   `Access-Control-Allow-Credentials: true` 使用時は `*` が使えないことを利用し、厳格に制限。

### 10.8. CSRF防御

-   **SameSite Cookie**: `SameSite=Lax`（推奨）または `SameSite=Strict` を全Cookieに設定。
-   **Double Submit Cookie**: フレームワークのCSRFトークン機構を有効化。
-   **Custom Header Check**: AJAX経由のリクエストに `X-Requested-With` 等のカスタムヘッダーを付与。

### 10.9. エラーハンドリング

-   本番環境でスタックトレース、内部パス、DB構造を含むエラーレスポンスを返すことを**絶対禁止**。
-   ユーザーには汎用メッセージ（`500: Internal Server Error`）を返し、詳細はサーバーサイドログにのみ記録。

### 10.10. API Shadow/Zombie検出

-   **Law**: 未文書化のAPI（Shadow API）、非推奨だがまだ稼働しているAPI（Zombie API）を定期的に検出・廃止する。
-   **Action**: APIゲートウェイのトラフィック分析で未登録エンドポイントを検出。APIインベントリと照合。

### 10.11. API Gateway

-   **Law**: 全APIトラフィックをAPI Gatewayを経由させ、認証・認可・Rate Limiting・ロギングを一元管理する。
-   **Cross-Reference**: §13 (SASE), §26 (セキュリティ可観測性)

---

## §11. サプライチェーンセキュリティ (Supply Chain Security)

> **参考規格**: NIST SSDF (SP 800-218), SLSA v1.0, OWASP Top 10 2025 A03

### 11.1. SBOM (Software Bill of Materials)

-   **Law**: 全プロジェクトでSBOM（CycloneDX/SPDX）を自動生成・管理する。
-   **Action**: CI/CDパイプラインにSBOM生成ステップを組み込み、ビルドごとに署名付きSBOMを生成。
-   **Compliance**: EU CRAの2027年義務化に先行対応。

### 11.2. Dependency Scanning

-   **Law**: 全ての依存関係（直接・間接）の脆弱性を継続的にスキャンする。
-   **Action**:
    1.  `npm audit` / `yarn audit` をCI/CDで強制実行。Critical/Highは**マージブロック**。
    2.  Dependabot / Renovate / Snykによる自動アップデートPR。
    3.  **lockfile整合性検証**: `package-lock.json` / `yarn.lock` の改ざん検出。
    4.  **Phantom Dependency検出**: 直接宣言していない依存パッケージへの暗黙的依存を検出。

### 11.3. SLSA (Supply-chain Levels for Software Artifacts)

-   **Target**: 最低SLSA Level 2を目標。Level 3を推奨。

| SLSAレベル | 要件 | 実装 |
|:----------|:-----|:-----|
| **Level 1** | ビルドプロセスの文書化 | ビルドスクリプトのバージョン管理 |
| **Level 2** | ビルドの再現性 + 来歴(Provenance)生成 | CI/CDでの自動ビルド + 署名付きProvenance |
| **Level 3** | 強化されたビルド環境 | エフェメラルランナー + ビルド隔離 |

### 11.4. ライセンスコンプライアンス

-   **禁止ライセンス**: AGPL, SSPL, 独自の制約ライセンス。
-   **要注意ライセンス**: GPL（伝染性に注意）、CC-BY-NC（商用利用不可）。
-   **許可ライセンス**: MIT, Apache 2.0, BSD, ISC, MPL 2.0。
-   **Action**: CIにライセンスチェッカーを導入し、禁止ライセンスの依存追加をブロック。
-   **Cross-Reference**: `602_oss_compliance.md`

### 11.5. Typosquatting & Dependency Confusion

-   **Law**: 依存パッケージのタイポスクワッティング（偽パッケージ）攻撃を防御する。
-   **Action**:
    1.  パッケージ名の正確性を手動レビューで確認。
    2.  プライベートレジストリのスコープ設定でDependency Confusionを防止。
    3.  `npm config set registry` で信頼するレジストリのみ使用。

---

## §12. インフラセキュリティ (Infrastructure Security)

### 12.1. Security Headers

-   **Law**: 全HTTPレスポンスにセキュリティヘッダーを付与する。

| ヘッダー | 必須値 | 目的 |
|:---------|:-------|:-----|
| `Content-Security-Policy` | Nonce方式（§12.2参照） | XSS防御 |
| `Strict-Transport-Security` | `max-age=63072000; includeSubDomains; preload` | HTTPS強制 |
| `X-Content-Type-Options` | `nosniff` | MIMEスニッフィング防止 |
| `X-Frame-Options` | `DENY` or `SAMEORIGIN` | クリックジャッキング防止 |
| `Referrer-Policy` | `strict-origin-when-cross-origin` | リファラー情報漏洩防止 |
| `Permissions-Policy` | 利用しないAPI機能を明示的に無効化 | 不要なブラウザAPI制限 |
| `Cross-Origin-Embedder-Policy` | `require-corp` | クロスオリジン分離 |
| `Cross-Origin-Opener-Policy` | `same-origin` | ウィンドウ参照の分離 |
| `Cross-Origin-Resource-Policy` | `same-origin` | リソースの分離 |

### 12.2. CSP Nonce Protocol

-   **Law**: CSPは**Nonce方式**を使用し、インラインスクリプトの安全な実行を保証する。`'unsafe-inline'`, `'unsafe-eval'` の使用を**完全禁止**。

```typescript
// ✅ CORRECT: Next.js CSP Nonce実装例
import { headers } from 'next/headers';
import { randomBytes } from 'crypto';

export async function generateCspNonce(): Promise<string> {
  const nonce = randomBytes(16).toString('base64');
  return nonce;
}

// middleware.ts
export function middleware(request: NextRequest) {
  const nonce = randomBytes(16).toString('base64');
  const csp = `
    default-src 'self';
    script-src 'self' 'nonce-${nonce}';
    style-src 'self' 'nonce-${nonce}';
    img-src 'self' blob: data:;
    connect-src 'self' https://*.supabase.co;
    frame-ancestors 'none';
    base-uri 'self';
    form-action 'self';
  `.replace(/\n/g, '');

  const response = NextResponse.next();
  response.headers.set('Content-Security-Policy', csp);
  response.headers.set('x-nonce', nonce);
  return response;
}
```

### 12.3. RLS (Row Level Security) Mandate

-   **Anti-Permissive RLS Mandate**: Supabaseテーブルに対するRLSポリシーは**デフォルト拒否（Deny by Default）**。
-   **検証義務**: 新規テーブル作成時は、PR内でRLSポリシーの設計意図をコメントに記載。
-   **`auth.uid()` ラッピング**: `(select auth.uid())` のように `select` でラッピングし、行単位の再評価を防止（パフォーマンス最適化）。

```sql
-- ✅ CORRECT: RLS + auth.uid() ラッピング
CREATE POLICY "Users can view own data"
  ON public.profiles
  FOR SELECT
  USING (id = (select auth.uid()));

-- ✅ CORRECT: Admin用ポリシー
CREATE POLICY "Admins can view all"
  ON public.profiles
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = (select auth.uid()) AND role = 'admin'
    )
  );
```

-   **Cross-Reference**: `320_supabase_architecture.md`

### 12.4. Cookie Security

| 属性 | 必須値 | 理由 |
|:-----|:-------|:-----|
| `HttpOnly` | `true` | JS経由でのCookieアクセスを阻止 |
| `Secure` | `true` | HTTPS通信のみで送信 |
| `SameSite` | `Lax` or `Strict` | CSRF防御 |
| `__Host-` prefix | 推奨 | Cookie固定化攻撃の防御 |

### 12.5. SRI (Subresource Integrity)

-   CDN等の外部スクリプト/スタイルシートには `integrity` 属性を**必須**で付与。
-   **Action**: SRIハッシュをCI/CDで自動生成・検証。

```html
<!-- ✅ CORRECT: SRI付き外部スクリプト -->
<script
  src="https://cdn.example.com/library.js"
  integrity="sha384-xxxxx..."
  crossorigin="anonymous"
></script>
```

### 12.6. DNS Security

-   **DNSSEC**: DNSスプーフィング防止のためDNSSECを有効化。
-   **CAA Record**: 認証局を限定するCAA DNSレコードを設定。
-   **SPF + DKIM + DMARC**: メール送信ドメインの認証を完備し、フィッシング/スプーフィングを防止。

### 12.7. Email Security

-   **SPF**: 許可する送信元サーバーを限定。`-all` で厳格フェイル。
-   **DKIM**: メール署名で改ざん検出。2048bit鍵以上。
-   **DMARC**: `p=reject` を最終目標。段階的に `p=none` → `p=quarantine` → `p=reject` に移行。
-   **BIMI**: ブランドロゴ表示によるフィッシング対策強化（DMARC reach後）。

### 12.8. Webhook Security

-   受信Webhookは署名検証必須（HMAC-SHA256等）。
-   タイムスタンプ検証でリプレイ攻撃を防止。
-   Webhookエンドポイントにもレート制限を適用。

---

## §13. SASE・ネットワークセキュリティ (SASE & Network Security)

> **参考規格**: Gartner SASE Framework, NIST SP 800-207 (Zero Trust)

### 13.1. SASE (Secure Access Service Edge)

-   **Law**: リモートワーク・クラウドネイティブ環境において、ネットワークセキュリティとWANを統合する**SASE**アーキテクチャの採用を推奨する。
-   **構成要素**:

| コンポーネント | 機能 | 推奨ツール |
|:-------------|:-----|:---------|
| **ZTNA** | ゼロトラストネットワークアクセス（VPN置換） | Cloudflare Access, Zscaler |
| **SWG** | セキュアウェブゲートウェイ | Cloudflare Gateway |
| **CASB** | クラウドアクセスセキュリティブローカー | Netskope, Microsoft MCAS |
| **FWaaS** | Firewall-as-a-Service | Cloudflare Magic Firewall |
| **SD-WAN** | ソフトウェア定義WAN | Cloudflare Magic WAN |

### 13.2. ZTNA（VPN代替）

-   **Law**: レガシーVPNからZTNAへの移行を推奨する。VPNは全ネットワークへのアクセスを許可するため、侵害時のBlast Radiusが大きい。
-   **Action**:
    1.  アプリケーション単位のアクセス制御（マイクロセグメンテーション）。
    2.  デバイスポスチャチェック（OS更新状況、EDR稼働確認等）。
    3.  コンテキストアウェアアクセス（時間帯、地理的位置、リスクスコア）。

### 13.3. WAF (Web Application Firewall)

-   **Law**: 全公開Webアプリケーション/APIの前段にWAFを配置する。
-   **Action**:
    1.  OWASP Core Rule Set (CRS) ベースのルールセットを適用。
    2.  カスタムルールで業務固有の攻撃パターンを検出。
    3.  新規ルールは**監視モード（Log Only）**で検証後、ブロックモードに移行。
    4.  WAFバイパスアラートを設定し、WAFを迂回する直接接続を検知。

### 13.4. DDoS防御

-   **Law**: 全ドメインをCDN/DDoS防御サービス経由でルーティングし、オリジンサーバーIPを秘匿する。
-   **Action**: CDN経由でのDDoS緩和 + オリジン保護 + 帯域スケーリング + アプリケーション層レート制限。
-   **Cross-Reference**: §23 (ボット管理・DDoS防御)

### 13.5. ネットワーク分離

-   **VPC設計**: パブリックサブネット（ALB/CDN）とプライベートサブネット（DB/内部サービス）を分離。
-   **DBの直接公開禁止**: データベースにパブリックIPを付与することを**絶対禁止**。
-   **Bastion Host / Session Manager**: 内部リソースへのアクセスはBastion Host経由またはSSM Session Managerを使用。

---

## §14. コンテナ・クラウドネイティブセキュリティ (Container & Cloud-Native Security)

### 14.1. Image Security

-   **最小ベースイメージ**: Distroless / Alpine等の最小イメージを使用。
-   **CIスキャン**: Trivy / Clair等でイメージスキャンをCI/CDに統合。Critical/Highはデプロイブロック。
-   **イメージ署名**: Cosign (Sigstore) でビルド成果物に署名。未署名イメージはAdmission Webhookで拒否。
-   **Latestタグ禁止**: 本番環境での `latest` タグ使用を禁止。具体的バージョン/SHAを指定。

### 14.2. Pod Security Standards

-   **Non-Root**: `runAsNonRoot: true`。
-   **Read-Only Filesystem**: `readOnlyRootFilesystem: true`。
-   **Capability Drop**: `drop: ["ALL"]`、必要最小限のみ追加。
-   **No Privileged**: `privileged: false`。

### 14.3. Network Policy

-   **Default Deny**: デフォルトで全トラフィックを拒否し、必要な通信のみホワイトリストで許可。
-   Pod間通信は必要最小限に制限（Microsegmentation）。

### 14.4. Runtime Security

-   **Law**: ビルド時スキャンだけでは不十分。実行時の異常行動を検出・ブロックする。
-   **Action**:
    1.  **ランタイム監視**: Falco等でリアルタイムに異常syscallを検出。
    2.  **イメージ不変性**: 稼働中のコンテナへのパッチ適用を禁止。新イメージをデプロイ（Immutable Infrastructure）。
    3.  **Egress Policy**: Network Policyでコンテナの外向き通信を制御。データ持ち出しを構造的に防止。

### 14.5. Admission Controller

-   ValidatingAdmissionWebhook / Kyverno / OPA Gatekeeperでセキュリティポリシー違反のデプロイを**自動拒否**。
-   新ポリシーは `dry-run` モードで検証後、本番適用。

### 14.6. サプライチェーン（Container固有）

-   マルチステージDockerfileの各段階でハッシュを記録し、ビルドの再現性を確保。
-   ベースイメージのCVE監視を自動化。Critical CVE検出時は**72時間以内**に再ビルド。

---

## §15. ファイルアップロードセキュリティ (File Upload Security)

### 15.1. Server-Side Validation

-   **Law**: クライアントサイド検証のみに依存しない。必ずサーバーサイドで再検証する。
-   **Action**:
    1.  **MIME Type検証**: **マジックバイト（ファイルヘッダ）** + `Content-Type` ヘッダーの両方を検査。
    2.  **拡張子検証**: ホワイトリスト（例: `.jpg`, `.png`, `.pdf`）で制限。
    3.  **サイズ制限**: タイプごとの最大サイズ設定（例: 画像10MB、文書50MB）。
    4.  **ファイル名サニタイズ**: ユーザーファイル名を直接使用しない。UUIDでリネーム。`../` を除去。

### 15.2. メタデータ除去

-   **Law**: アップロード画像からEXIFメタデータ（GPS、カメラ情報等）を保存前に除去する。

### 15.3. 実行可能ファイルのブロック

-   実行可能ファイル（`.exe`, `.sh`, `.bat`, `.ps1`, `.js`等）のアップロードは**デフォルト禁止**。
-   `.jpg.exe`, `.pdf.js` 等の二重拡張子を検出・拒否。

### 15.4. Signed URL Pattern

-   大容量ファイルには**Signed URL**パターンでの直接ストレージアップロードを推奨。
-   **Action**: 最長5分の有効期限、`Content-Type` 条件、`Content-Length` 条件、アップロード後のサーバーサイド再検証。

### 15.5. Storage Bucket Security

-   **バケット分離**: 公開アセットと非公開アセットを**別バケット**に分離。
-   **RLS必須**: Supabase Storageの全バケットにRLSポリシーを要求。
-   **CORS制限**: アプリドメインのみ許可。`*` 禁止。

### 15.6. Content-Disposition Security

-   ユーザーアップロードファイルのダウンロード時は `Content-Disposition: attachment` を設定。
-   `inline` は画像（`image/*`）のみ許可。HTML/SVG/PDFは `attachment` を強制。

### 15.7. 画像処理セキュリティ

-   ImageMagickよりも安全なSharp（libvipsベース）を使用。
-   **Pixel Bomb Prevention**: Decompression Bombsに対してピクセル数上限（例: 100MP）を設定。

---

## §16. 暗号化ポリシー・PQC (Cryptographic Policy & Post-Quantum Cryptography)

> **参考規格**: NIST FIPS 203/204/205, NIST SP 800-131A Rev.2

### 16.1. 禁止アルゴリズム

| 禁止アルゴリズム | 理由 | 代替 |
|:---------------|:-----|:-----|
| **MD5** | 衝突耐性なし | SHA-256+ |
| **SHA-1** | 衝突攻撃実証済み | SHA-256+ |
| **DES / 3DES** | 鍵長不足 | AES-256 |
| **RC4** | 統計的偏り | AES-256-GCM |
| **RSA-1024** | 鍵長不足 | RSA-2048+, Ed25519推奨 |
| **Blowfish (bcrypt以外)** | 64bitブロックサイズ脆弱性 | AES-256 |

### 16.2. 推奨アルゴリズム

| 用途 | 推奨アルゴリズム |
|:-----|:---------------|
| **共通鍵暗号** | AES-256-GCM |
| **ハッシュ** | SHA-256, SHA-384, SHA-512 |
| **パスワードハッシュ** | Argon2id, bcrypt (cost ≥ 12), scrypt |
| **デジタル署名** | Ed25519, ECDSA P-256 |
| **鍵交換** | X25519, ECDH P-256 |
| **TLS** | TLS 1.3推奨, TLS 1.2最低 |

### 16.3. 鍵管理ライフサイクル

| フェーズ | 要件 |
|:--------|:-----|
| **生成** | CSPRNGで生成。`Math.random()` 禁止 |
| **保管** | HSM / KMS / Vaultに保管。平文保管禁止 |
| **配布** | 暗号化チャネル（TLS 1.2+）で配布。Slack貼り付け禁止 |
| **使用** | 目的外利用禁止 |
| **ローテーション** | 90日ごと。漏洩時は即時ローテーション |
| **破棄** | セキュア破棄（ゼロフィル or 暗号化消去） |

### 16.4. ポスト量子暗号 (PQC) 対応

-   **Law**: NIST PQC標準化完了（FIPS 203: ML-KEM, FIPS 204: ML-DSA, FIPS 205: SLH-DSA）を受け、ハイブリッド暗号モードへの移行を計画する。
-   **FIPS規格対応表**:

| FIPS | アルゴリズム | 用途 | ステータス |
|:-----|:-----------|:-----|:---------|
| **FIPS 203** | ML-KEM (旧CRYSTALS-Kyber) | 鍵カプセル化 | 2024年8月公表済み |
| **FIPS 204** | ML-DSA (旧CRYSTALS-Dilithium) | デジタル署名 | 2024年8月公表済み |
| **FIPS 205** | SLH-DSA (旧SPHINCS+) | デジタル署名（ハッシュベース） | 2024年8月公表済み |
| **FIPS 206** | FN-DSA (旧FALCON) | デジタル署名 | 2025年公表予定 |
| **HQC** | 符号ベースKEM | 鍵カプセル化（多様化） | 2027年標準化予定 |

-   **移行タイムライン**:

| マイルストーン | 期限 | アクション |
|:-------------|:-----|:---------|
| **暗号インベントリ** | 即時 | 使用中の全暗号アルゴリズムを棚卸し |
| **Crypto-Agility設計** | 2026年末 | アルゴリズム容易交換可能なアーキテクチャ導入 |
| **ハイブリッドモード** | 2027年 | 古典+PQCのハイブリッドTLS鍵交換（X25519Kyber768等）評価・導入 |
| **RSA/ECC非推奨** | 2030年 | NIST推奨に従い既存暗号の段階的廃止 |
| **PQC完全移行** | 2035年 | 量子脆弱アルゴリズムの完全排除 |

-   **Harvest Now, Decrypt Later (HNDL) 対策**: 現在捕獲された暗号化データが将来の量子コンピュータで復号されるリスク。長期秘匿データは**今すぐ**PQCハイブリッド暗号化を検討。

---

## §17. AI/LLMセキュリティ (AI/LLM Security)

> **参考規格**: OWASP Top 10 for LLM Applications 2025, NIST AI RMF, EU AI Act

### 17.1. Prompt Injection防御 (LLM01:2025)

-   **Law**: ユーザー入力をLLMプロンプトに直接挿入する場合、**プロンプトインジェクション攻撃を構造的に防御**する。
-   **Action**:
    1.  **System/User Prompt分離**: システムプロンプトとユーザー入力を明確に分離。
    2.  **入力サニタイズ**: 制御文字、プロンプト操作パターンをフィルタリング。
    3.  **出力検証**: LLM出力を構造化フォーマット（JSON Schema等）で検証。期待外出力を拒否。
    4.  **Guardrail実装**: 入力・出力の両方にガードレール（トピック制限、有害コンテンツ検出）を設置。

### 17.2. 機密情報漏洩防御 (LLM02:2025)

-   **Law**: LLMが学習データや設定から機密情報を漏洩しないよう防御する。
-   **Action**: 出力フィルターでPII/秘密情報パターンを検出・マスキング。RAGでのデータアクセスにRBACを適用。

### 17.3. サプライチェーン脆弱性 (LLM03:2025)

-   **Law**: LLMモデル・プラグイン・学習データのサプライチェーンリスクを管理する。
-   **Action**: モデルの出所・ライセンス・整合性を検証。サードパーティプラグインのセキュリティ評価。

### 17.4. Data/Model Poisoning (LLM04:2025)

-   **Law**: 学習データ・ファインチューニングデータの汚染を防止する。
-   **Action**: 学習データの入力検証・出所検証。ファインチューニングパイプラインのアクセス制御。

### 17.5. Excessive Agency制御 (LLM06:2025)

-   **Law**: LLMに付与する権限・ツールを最小限に制限。重要操作にはHuman-in-the-Loopを強制。
-   **Action**: ツールコールのスコープ制限、破壊的操作の承認フロー、操作ログ監査。

### 17.6. System Prompt Leakage防御 (LLM07:2025)

-   **Law**: システムプロンプトに機密情報（APIキー、内部URL、ビジネスロジック）を含めない。
-   **Action**: 機密情報を環境変数に外出し。プロンプト抽出攻撃への耐性テスト。

### 17.7. Vector/Embeddingセキュリティ (LLM08:2025)

-   **Law**: RAGアーキテクチャにおけるベクトルDB/エンベディングの整合性を保護する。
-   **Action**: エンベディングソースのアクセス制御、ベクトルDBの書き込み権限制限、インジェクション検出。

### 17.8. Unbounded Consumption防御 (LLM10:2025)

-   **Law**: 過剰なLLMリクエストによるコスト爆発・DoSを防止する。
-   **Action**: トークン使用量のレート制限、ユーザーごとの日次上限、コストアラート設定。
-   **Cross-Reference**: `400_ai_engineering.md` (トークンコスト管理)

### 17.9. モデルアクセス制御

-   **Law**: LLMモデルアクセスを認証・認可で保護し、不正利用を防止する。
-   **Action**:
    1.  **API認証**: LLMエンドポイントへのアクセスをAPIキー + リクエスト署名で保護。
    2.  **利用監視**: ユーザー/APIキーごとのトークン使用量をリアルタイム監視。異常利用パターンを自動検出。

---

## §18. Agentic AI・MCP/A2Aセキュリティ (Agentic AI & MCP/A2A Security)

> **参考規格**: OWASP LLM Top 10 (LLM06), MAESTRO Framework, EU AI Act

### 18.1. Agentic AI セキュリティ原則

-   **Law**: AIエージェント（LLMがツールを利用し自律的に行動するシステム）には、追加のセキュリティガードレールを適用する。
-   **根拠**: Agentic AIはLLMに「手足」を与え、Prompt Injectionが実損害（データ削除、不正送金等）に直結するリスクを劇的に増大させる。

### 18.2. エージェント権限管理

| 原則 | 実装 |
|:-----|:-----|
| **権限最小化** | エージェントにはタスク遂行に必要な最小限のツール/APIのみ付与。危険な権限（ファイルシステム書き込み、直接DB操作）はデフォルト不許可 |
| **承認フロー** | 破壊的操作（削除、金銭操作、外部APIコール）はユーザー承認（Human-in-the-Loop）を要求 |
| **チェーン深度制限** | マルチエージェントアーキテクチャでエージェント間の呼び出しチェーン深度に上限設定 |
| **サンドボックス実行** | エージェントのコード実行を隔離されたサンドボックス環境で実行 |
| **出力監査** | エージェントの全アクション（ツールコール、APIコール、生成コンテンツ）を監査ログに記録 |

### 18.3. MCP (Model Context Protocol) セキュリティ

-   **Law**: MCPを通じたAIエージェントと外部ツール/データの連携に対し、以下のセキュリティ制御を適用する。
-   **Action**:
    1.  **MCPサーバー承認制**: 新規MCPサーバーの導入には正式なセキュリティ評価・承認プロセスを義務付け。
    2.  **承認済みサーバーインベントリ**: 承認済みMCPサーバーのホワイトリストを維持・公開。
    3.  **Prompt Injection via MCP**: MCPサーバーが保持するプロンプトリポジトリが攻撃ベクトルとなるリスクを認識し、入力検証を徹底。
    4.  **ユーザーコンテキスト伝搬**: MCPはホストからサーバーへのユーザーコンテキスト伝搬が任意であるため、権限昇格を防止する明示的な認証実装を義務付け。
    5.  **包括的ログ**: 全プロンプト・ツールコール・データアクセスのログを記録。

### 18.4. A2A (Agent-to-Agent) セキュリティ

-   **Law**: AIエージェント間の通信・連携に対し、以下のセキュリティ制御を適用する。
-   **脅威モデル**:

| 脅威 | 説明 | 対策 |
|:-----|:-----|:-----|
| **Agent Card Spoofing** | 偽のエージェント識別情報 | エージェントID検証 + 署名 |
| **Task Replay Attack** | 過去のタスクの再実行 | タイムスタンプ + Nonce検証 |
| **Cross-Agent Prompt Injection** | エージェント間データ経由のインジェクション | 各エージェントでの入力検証 |
| **権限昇格** | エージェント間の権限拡大 | 各段階での認可チェック |
| **Infinite Delegation Loop** | 無限委譲ループ | チェーン深度制限 + タイムアウト |

-   **Action**:
    1.  入力・トークン・認可の厳格な検証。
    2.  エージェント通信の暗号化（mTLS推奨）。
    3.  エージェント間のデータ共有にはRBACを適用。

### 18.5. MAESTRO脅威モデリング

-   **Law**: Agentic AIシステムの脅威モデリングにはMAESTROフレームワーク（7層セキュリティアーキテクチャ）の適用を推奨する。
-   **Cross-Reference**: `400_ai_engineering.md`

---

## §19. セキュアSDLC（Shift-Left Security）

> **参考規格**: NIST SSDF (SP 800-218), OWASP SAMM, Microsoft SDL

### 19.1. Security Gate Mandate

| フェーズ | セキュリティゲート | ブロッキング |
|:--------|:----------------|:-----------|
| **設計** | 脅威モデリング / PIA | Yes |
| **コーディング** | SAST + Secret Scan | Yes |
| **PR/レビュー** | セキュリティチェックリスト検証 | Yes |
| **ビルド** | SBOM生成 + 依存関係スキャン | Yes |
| **テスト** | DAST + ペネトレーションテスト | Yes (Critical/Highのみ) |
| **デプロイ** | Config Drift検出 + Image Signing | Yes |
| **運用** | SIEM + 監査ログ監視 | — |

### 19.2. 脅威モデリング

-   **Law**: 重要な新機能の設計フェーズで**STRIDE**または**DREAD**ベースの脅威モデリングを実施する。
-   **Action**: DFD作成、Trust Boundary分析、脅威の優先順位付け（High+は設計で解決）、Blueprintに文書化。

### 19.3. CI/CDパイプラインセキュリティ

-   **Law**: CI/CDパイプラインは攻撃標的。パイプラインセキュリティを**サプライチェーンセキュリティの一部**として管理する。
-   **Action**:
    1.  **Least Privilege**: シークレットはリポジトリ単位ではなくジョブ単位で付与。
    2.  **Pinned Actions**: GitHub Actionsは**SHA**で固定（タグ禁止）。
    3.  **Ephemeral Runners**: セルフホストランナーはエフェメラル（使い捨て）で運用。
    4.  **OIDC Token**: 長寿命シークレットの代わりにOIDCトークンを使用。
    5.  **Branch Protection**: CI/CDトリガーは保護されたブランチルール経由のみ。

```yaml
# ✅ セキュアなGitHub Actions設定
jobs:
  deploy:
    permissions:
      contents: read       # 最小権限
      id-token: write      # OIDC
    steps:
      - uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11 # SHA固定
      - uses: aws-actions/configure-aws-credentials@e3dd6a429d7300a6a4c196c26e071d42e0343502
        with:
          role-to-assume: ${{ secrets.AWS_ROLE_ARN }}  # OIDC認証
          aws-region: ap-northeast-1
```

### 19.4. Security Champion Program

-   **Law**: 開発チームごとに**Security Champion**を任命する。
-   **責任**: PRレビューでのセキュリティチェック、新ライブラリのリスク評価、四半期チームセキュリティセッション、インシデント初動対応。

---

## §20. GraphQLセキュリティ (GraphQL Security)

### 20.1. Introspection制御

-   **Law**: 本番環境ではGraphQL Introspectionを**無効化**。スキーマ発見による偵察を防止。
-   **Action**: Introspectionを有効にする場合は**強力な認証・認可**を要求し、全Introspectionクエリをログ。開発環境のみ環境変数で有効化。

```typescript
// ✅ 本番でIntrospectionを無効化 (Apollo Server例)
const server = new ApolloServer({
  typeDefs,
  resolvers,
  introspection: process.env.NODE_ENV !== 'production',
});
```

### 20.2. クエリ深度制限

-   **Law**: 深くネストされたクエリによるサーバーリソース枯渇を防止する。
-   **Action**: 最大クエリ深度を**5–7レベル**に制限。超過時は拒否。

### 20.3. クエリ複雑度分析

-   **Law**: フィールドごとに「コスト」を割り当て、クエリ複雑度スコアの上限を設定する。
-   **Action**:
    1.  スカラーフィールド: cost 1, リスト/リレーション: cost 10×アイテム数。
    2.  最大複雑度スコア（例: 1000）を設定。超過時は `429 Too Complex` を返却。
    3.  認証ユーザーにはより高い上限を許可（ティア制）。

### 20.4. フィールドレベル認可

-   **Law**: GraphQLリゾルバレベルで**フィールドレベルの認可チェック**を実装する。

```typescript
// ✅ フィールドレベル認可
const resolvers = {
  User: {
    email: (parent, args, context) => {
      if (context.user.id !== parent.id && context.user.role !== 'admin') {
        throw new ForbiddenError('Access denied');
      }
      return parent.email;
    },
  },
};
```

### 20.5. バッチリクエスト制御

-   **Law**: 単一HTTPリクエストで複数GraphQL操作をバッチ処理する攻撃を防止する。
-   **Action**: バッチ操作を**5–10**に制限。認証エンドポイントでのバッチを**完全禁止**。

### 20.6. GraphQL対応レート制限

-   **Law**: HTTPリクエスト数ではなく、**GraphQL操作単位**でレート制限を適用する。
-   **根拠**: GraphQLは1リクエストで複数の重い操作をバンドルできるため、HTTP層のレート制限は容易にバイパス可能。

### 20.7. 本番エラーメッセージ制御

-   **Law**: 本番環境ではGraphQLの詳細エラーメッセージ（スタックトレース、スキーマ情報）を抑制する。
-   **Action**: エラーフォーマッターで汎用メッセージに変換。詳細はサーバーサイドログにのみ記録。

---

## §21. シークレットマネジメント (Secrets Management)

### 21.1. 基本原則

-   **Law**: 全シークレット（APIキー、DBパスワード、証明書、暗号鍵）を一元管理し、ライフサイクルを自動化する。
-   **Action**:
    1.  **ハードコーディング絶対禁止**: コード、設定ファイル、`.env`ファイル（Git管理下）、バージョン管理にシークレットを物理的に埋め込むことを禁止。
    2.  **ランタイム取得**: シークレットは実行時にセキュアな外部ソースから取得。
    3.  **最小権限**: シークレットへのアクセスはユーザー/サービスごとに必要最小限のみ付与。

### 21.2. 一元管理ツール

| ツール | 推奨環境 | 主要機能 |
|:------|:---------|:---------|
| **HashiCorp Vault** | マルチクラウド/ハイブリッド | 動的シークレット、Encryption-as-a-Service |
| **AWS Secrets Manager** | AWS中心 | AWS統合、自動ローテーション |
| **Google Secret Manager** | GCP中心 | GCP統合、IAMベースアクセス |
| **Supabase Vault** | Supabase環境 | DB内暗号化シークレットストレージ |
| **Vercel Environment Variables** | Vercelデプロイ | 環境ごとのシークレット管理 |

### 21.3. 動的シークレット

-   **Law**: 可能な限り、静的キー/パスワードではなく**短命な動的シークレット**を使用する。
-   **Action**: Vault等でDB接続用の短命クレデンシャルを生成。セッション終了時に自動期限切れ。

### 21.4. Secret Zero問題の解決

-   **Law**: シークレットマネージャーにアクセスするための「最初のシークレット」（Secret Zero）自体が脆弱性とならない設計を義務付ける。
-   **ソリューション**:
    1.  **OIDC/Workload Identity**: 暗号的に署名されたID証明を提示（クラウド環境、CI/CD）。
    2.  **Platform Auth**: プラットフォーム固有メカニズム（AWS IAM Role, GCP Service Account等）を活用。
    3.  **AppRole**: Vault AppRole認証（RoleID + 短命SecretID）の組み合わせ。

### 21.5. 自動ローテーション

| シークレット種別 | ローテーション頻度 |
|:---------------|:-----------------|
| **APIキー** | 90日ごと |
| **DBパスワード** | 60日ごと |
| **サービスアカウント** | 30日ごと |
| **暗号鍵** | 90日ごと（§16.3） |
| **高リスクシークレット** | 必要に応じてより頻繁に |

-   **Dual-Phase Rotation**: 新シークレット生成 → 配布 → 旧シークレットを有効なまま検証 → 検証後に旧シークレット無効化。

### 21.6. NHI (Non-Human Identity) シークレット管理

-   **Law**: シークレットを所有/利用する「非人間ID」の管理を強化する。
-   **Action**:
    1.  全NHI IDの棚卸しと明確な所有者割り当て。
    2.  NHI IDにも最小権限を厳格適用。
    3.  NHIシークレットにはより**短いローテーション周期**を適用。
    4.  未使用NHI IDの定期的な検出・無効化。
-   **Cross-Reference**: §3.2 (NHI管理)

### 21.7. CI/CDパイプラインシークレット管理

-   **Law**: CI/CDパイプライン内のシークレット管理は特に重要。パイプライン侵害 = インフラ全体の侵害。
-   **Action**:
    1.  パイプライン設定/スクリプト内へのハードコーディング禁止。
    2.  ジョブスコープでのシークレット注入。
    3.  **OIDC認証**（§19.3）でクラウドプロバイダ認証し、長寿命シークレットを排除。
    4.  **シークレットマスキング**: CIログ内のシークレットを自動マスク。

---

## §22. クライアントサイドセキュリティ (Client-Side Security)

### 22.1. DOM XSS防御

-   **Law**: ブラウザ内で完結するDOM-based XSSを防止する。
-   **Action**:
    1.  **Trusted Types**: `Content-Security-Policy: require-trusted-types-for 'script'` で危険なDOMシンク（`innerHTML`, `document.write`等）を型レベルで制限。
    2.  **サニタイズ**: ユーザー入力をDOMに挿入時は必ず`DOMPurify`等のサニタイザを適用。
    3.  **フレームワーク標準のエスケープ活用**: React/Vueのデフォルトエスケープを活用。`dangerouslySetInnerHTML` / `v-html` の使用は**PRレビューでの特別承認**を要求。

```typescript
// ❌ PROHIBITED: Trusted Types未使用のinnerHTML
element.innerHTML = userInput;

// ✅ CORRECT: DOMPurifyでサニタイズ
import DOMPurify from 'dompurify';
element.innerHTML = DOMPurify.sanitize(userInput);

// ✅ BEST: Trusted Types Policy
if (window.trustedTypes) {
  const policy = trustedTypes.createPolicy('default', {
    createHTML: (input: string) => DOMPurify.sanitize(input),
  });
}
```

### 22.2. サードパーティスクリプト管理

-   **Law**: サードパーティスクリプトは**主要なサプライチェーン攻撃ベクトル**。導入・管理を厳格に制御する。
-   **Action**:
    1.  **インベントリ管理**: 全サードパーティスクリプトの目的、リスク、オーナー、CSP設定を文書化。
    2.  **承認プロセス**: 新規サードパーティスクリプトはセキュリティレビューと承認を要求。
    3.  **SRI (Subresource Integrity)**: 全外部スクリプト/CSSに `integrity` 属性を付与（§12.5）。
    4.  **バージョン固定**: CDNスクリプトのバージョンを固定。`latest` URLの使用禁止。
    5.  **定期監査**: サードパーティスクリプトの動作を定期的に監査し、不審な外部通信を検出。
-   **PCI DSS 4.0**: 要件6.4.3は決済ページでのスクリプトインベントリとSRIを義務付け。

### 22.3. Local Storageセキュリティ

-   **Law**: `localStorage` / `sessionStorage` にシークレット・トークン・PIIを**厳正に保存しない**。
-   **根拠**: XSS成功時にJavaScriptで `localStorage` の全データを即座に窃取可能。
-   **代替**: 認証トークンは `HttpOnly` + `Secure` + `SameSite` Cookie またはサーバーサイドセッションで管理。

### 22.4. PostMessageセキュリティ

-   **Law**: `window.postMessage` / `MessageEvent` 使用時は必ず `origin` を検証する。
-   **Action**: `event.origin` をホワイトリストと照合。`*` へのメッセージ送信を禁止。

### 22.5. フロントエンド依存関係セキュリティ

-   **Law**: フロントエンド依存関係もサプライチェーンリスクの対象。バンドルサイズだけでなくセキュリティを評価する。
-   **Action**:
    1.  `npm audit` をCI/CDに統合（§11.2）。
    2.  未使用依存関係を定期的に検出・削除（攻撃面縮小）。
    3.  バンドルアナライザーで予期しない依存関係の混入を検出。

---

## §23. ボット管理・DDoS防御 (Bot Management & DDoS Defense)

### 23.1. ボット検出・分類

| カテゴリ | 例 | 対応 |
|:--------|:---|:-----|
| **Good Bots** | Googlebot, Bingbot | robots.txtで許可、緩やかなレート制限 |
| **Bad Bots** | スクレイパー、Credential Stuffing | ブロック |
| **Sophisticated Bots** | ヘッドレスブラウザ、AI駆動ボット | 行動分析で検出 |

### 23.2. 多層ボット防御

-   **Action**:
    1.  **Managed Challenge (Turnstile)**: CAPTCHA代替。フォーム送信、ログイン、APIエンドポイントに適用。
    2.  **行動分析**: マウス移動、入力パターン、スクロール行動を分析。人間パターンから逸脱するリクエストをフラグ。
    3.  **デバイスフィンガープリンティング**: ブラウザ/デバイス特性から一意識別子を生成。同一フィンガープリントからの異常行動を検出。
    4.  **レート制限（多層）**: IP単位、ユーザー/APIキー単位、エンドポイント単位の制限。
    5.  **ハニーポット**: ボットのみが入力する隠しフォームフィールド。

### 23.3. DDoS防御戦略

-   **Law**: DDoS攻撃に対する多層防御をプロアクティブに構築する。
-   **Action**:
    1.  **CDNエッジ保護**: 全ドメインをCDN経由でルーティング。オリジンサーバーを秘匿。DDoS緩和を有効化。
    2.  **オリジン保護**: オリジンサーバーIPを非公開。CDNバイパスの直接アクセスを防止。
    3.  **帯域スケーリング**: ロードバランサーと冗長化で単一障害点を排除。
    4.  **アプリケーション層防御**: リソース集約型処理（検索、DB書き込み）に個別レート制限。
    5.  **異常検知**: 通常トラフィックパターンをベースラインとし、急激な逸脱をリアルタイム検出。
-   **DDoS対応計画**: 検知基準定義 → 自動緩和ルール設定 → エスカレーション手順 → 通知テンプレート準備。

### 23.4. APIアビューズパターン検出

-   **Law**: 個別リクエストではなく**リクエストパターン**を分析してアビューズを検出する。
-   **検出パターン**: 異なるIPからの同一アカウントへの高速アクセス、辞書攻撃パターン、順序外のAPIコール、短時間の大量アカウント作成。

---

## §24. セキュリティ品質基準 (Security Quality Standards)

### 24.1. セキュリティテスト戦略

| テスト種別 | 頻度 | スコープ |
|:---------|:-----|:--------|
| **SAST** | 毎CI | 全コードベース |
| **DAST** | 週次/スプリント | 公開エンドポイント |
| **SCA (依存関係)** | 毎CI | 全依存関係 |
| **ペネトレーションテスト** | 年2回 | 外部侵入テスト |
| **レッドチーム演習** | 年1回 | フルスコープ |
| **バグバウンティ** | 常時 | 外部研究者による発見 |

### 24.2. セキュリティ教育

-   **Law**: 全エンジニアに最低限のセキュリティ教育を義務付ける。
-   **Action**:
    1.  **入社時**: OWASP Top 10概要、セキュアコーディング基礎。
    2.  **四半期**: 最新脅威動向、インシデント事例レビュー。
    3.  **年次**: ハンズオンCTF（Capture The Flag）演習。
    4.  **ロール別**: フロントエンド(XSS/CSRF), バックエンド(Injection/BOLA), インフラ(IAM/Network)の専門教育。

### 24.3. インシデント対応計画

-   **Law**: セキュリティインシデントに対する定義済みの対応計画を維持・更新する。
-   **インシデント重大度分類**:

| 重大度 | 定義 | 初動SLA |
|:------|:-----|:--------|
| **P1 (Critical)** | データ漏洩、サービス全停止 | 15分以内 |
| **P2 (High)** | 部分的機能停止、脆弱性悪用の兆候 | 1時間以内 |
| **P3 (Medium)** | 潜在的脆弱性の発見 | 24時間以内 |
| **P4 (Low)** | 情報提供レベルのセキュリティ事象 | 次営業日 |

-   **Cross-Reference**: `503_incident_response.md`

### 24.4. セキュリティ指標・KPI

| 指標 | 目標値 | 測定頻度 |
|:-----|:------|:---------|
| **MTTR（脆弱性修復時間）** | Critical ≤ 24h, High ≤ 72h | 月次 |
| **脆弱性密度** | < 1件/KLOC (Critical+High) | スプリント |
| **パッチ適用率** | ≥ 95%(14日以内) | 月次 |
| **MFA採用率** | 100%(管理者) / ≥ 80%(全体) | 月次 |
| **インシデント検出時間** | ≤ 1時間 | 月次 |
| **セキュリティ教育完了率** | 100% | 四半期 |

---

## §25. 高度セキュリティ運用・SecOps (Advanced Security Operations)

### 25.1. 監査ログ設計

-   **Law**: セキュリティ関連のイベントを網羅的に記録し、改ざん不能な形で保存する。
-   **必須ログフィールド**:

| フィールド | 説明 |
|:---------|:-----|
| `timestamp` | ISO 8601形式（タイムゾーン付き） |
| `actor_id` | 操作実行者のID |
| `actor_type` | human / service / ai_agent |
| `action` | 実行されたアクション |
| `resource` | 対象リソース |
| `result` | success / failure / denied |
| `ip_address` | 要求元IPアドレス |
| `user_agent` | ユーザーエージェント |
| `change_diff` | 変更前後の差分（破壊的操作時） |

-   **改ざん防止**: 監査ログは書き込み専用（Append-Only）ストレージに保存。削除・変更を物理的に不可能にする。
-   **保存期間**: 最低1年間保持（規制要件に応じて延長）。

### 25.2. ビジネスロジックセキュリティ

-   **Law**: 技術的な脆弱性だけでなく、ビジネスロジックの悪用を検出・防御する。
-   **検出対象**:
    1.  クーポン/ポイントの不正利用（多重適用、負値操作）。
    2.  レース条件による二重処理（ダブルブッキング、二重決済）。
    3.  価格操作（クライアントサイドでの価格書き換え）。
    4.  紹介プログラムの自己紹介等の不正利用。
-   **対策**: サーバーサイドでの状態・金額検証、冪等性キー（Idempotency Key）の実装、操作の原子性保証。

### 25.3. ペネトレーションテスト

-   **Law**: 定期的（年2回以上）の外部ペネトレーションテストを実施する。
-   **Scope**: OWASP Testing Guide v5準拠。OWASP Top 10 + API Security Top 10 のカバレッジ。
-   **報告**: 発見事項をリスクレベルで分類。Critical/Highは修復後に再テスト。

---

## §26. セキュリティ可観測性 (Security Observability)

### 26.1. SIEM統合

-   **Law**: セキュリティ関連のログ・イベントを統合SIEMプラットフォームに集約し、相関分析を実施する。
-   **Action**:
    1.  アプリケーションログ、インフラログ、認証ログ、WAFログをSIEMに統合。
    2.  相関ルールで個別には正常に見えるイベントの組み合わせから脅威を検出。
    3.  ダッシュボードでリアルタイムのセキュリティ態勢を可視化。

### 26.2. XDR (Extended Detection and Response)

-   **Law**: エンドポイント、ネットワーク、クラウド、アイデンティティを横断する統合的な脅威検出・対応を推奨する。
-   **Action**: EDR + NDR + Cloud Security の統合。AIベースの異常検出。

### 26.3. SOAR (Security Orchestration, Automation, and Response)

-   **Law**: 繰り返し発生するセキュリティインシデントに対する自動対応ワークフロー（Playbook）を構築する。
-   **Playbook例**:
    1.  **フィッシング対応**: メール受信 → URLスキャン → 悪意判定 → 送信者ブロック → 影響ユーザー通知。
    2.  **アカウント侵害対応**: 異常検知 → セッション無効化 → パスワードリセット強制 → ログ保全。
    3.  **マルウェア検出**: EPP検知 → 隔離 → IOC抽出 → 全端末スキャン → レポート生成。

### 26.4. セキュリティダッシュボード

-   **Law**: 経営層・開発チームに対し、セキュリティ態勢のリアルタイムダッシュボードを提供する。
-   **表示項目**: 脆弱性サマリー（Critical/High/Medium/Low）、インシデント統計、パッチ適用状況、MFA採用率、コンプライアンススコア。
-   **Cross-Reference**: §24.4 (セキュリティ指標), §29 (セキュリティガバナンス)

---

## §27. 委託先セキュリティ管理 (Vendor Security Management)

### 27.1. 委託先セキュリティ評価基準

| 評価カテゴリ | チェック項目 | 最低要件 |
|:-----------|:-----------|:---------|
| **認証** | ISO 27001 / SOC 2 Type II | いずれか1つ以上 |
| **データ暗号化** | 保存時・転送時 | AES-256 + TLS 1.2+ |
| **アクセス制御** | RBAC, MFA | 管理者MFA必須 |
| **インシデント対応** | 計画と通知時間 | 初報24時間以内 |
| **データ所在地** | データセンター所在地 | サービス提供地域と同一リージョン |
| **バックアップ & DR** | 頻度とリカバリ | 日次バックアップ + RTO 24時間以内 |

### 27.2. 委託先SLAテンプレート

| SLA項目 | 推奨基準 | 違反時対応 |
|:--------|:--------|:---------|
| **可用性** | 99.9%+（月次） | クレジット返金またはペナルティ |
| **インシデント通知** | 発見から24時間以内 | 契約違反記録 |
| **データ復旧** | RPO 24時間 / RTO 4時間 | エスカレーション |
| **パッチ適用** | Critical: 72時間 / High: 2週間 | 改善計画要求 |
| **監査協力** | 年次受入義務 | 拒否時は契約見直し |

### 27.3. 再委託先管理

-   **事前通知**: 新規再委託先利用の**30日前**に通知。
-   **同等条件**: 同等のセキュリティ・プライバシー条件を課す。
-   **チェーン制限**: 再々委託は**原則禁止**。個別承認が必要。
-   **リスト管理**: 全再委託先リストを維持・開示。
-   **Cross-Reference**: GDPR Art.28(2), Global Privacy Laws 委託先監督義務

---

## §28. 規制コンプライアンス深化 (Regulatory Compliance Deep Dive)

> **参考規格**: EU AI Act, NIS2, DORA, GDPR, Global Privacy Laws

### 28.1. EU AI Act 対応

-   **Law**: EUサービス提供時、EU AI Actのリスク分類と義務を遵守する。

| カテゴリ | リスクレベル | 義務 | 施行時期 |
|:--------|:-----------|:-----|:--------|
| **禁止AI** | Unacceptable | 使用禁止 | 2025年2月 |
| **汎用AI (GPAI)** | — | 透明性・著作権法遵守 | 2025年8月 |
| **高リスクAI** | High | リスク管理・データガバナンス・技術文書・ログ記録・人的監視・精度/堅牢性/サイバーセキュリティ | 2026年8月 |
| **限定リスクAI** | Limited | 透明性義務（AI利用の開示） | 2026年8月 |

-   **高リスクAIのサイバーセキュリティ要件（Art.15）**:
    1.  データポイズニング、モデルポイズニング、敵対的サンプル、モデル回避への耐性。
    2.  エラー、障害、不整合に対する堅牢性（技術的冗長性、フェイルセーフ）。
    3.  適合性評価、CE marking、EU DB登録。

### 28.2. NIS2 対応

-   **Law**: NIS2指令（2024年10月施行）の対象となるサービスでは、リスクベースのサイバーセキュリティ管理を義務付ける。
-   **要件**: インシデント対応計画、サプライチェーンセキュリティ、暗号化、アクセス制御、脆弱性管理。
-   **インシデント報告**: 重大インシデントは24時間以内に初報、72時間以内に詳細報告。

### 28.3. DORA (Digital Operational Resilience Act)

-   **Law**: 金融セクターでAI/ITシステムを提供する場合、DORAのICTリスク管理要件に準拠する。
-   **要件**: ICTリスク管理フレームワーク、インシデント報告、デジタル運用レジリエンステスト、ICTサードパーティリスク管理。

### 28.4. 規制横断コンプライアンスマトリクス

| 要件 | GDPR | Global Privacy Laws | NIS2 | DORA | EU AI Act |
|:-----|:----:|:----:|:----:|:----:|:---------:|
| データ保護影響評価 | ✅ | — | — | — | ✅ (高リスク) |
| インシデント報告 | 72h | 速やかに | 24h初報 | 4h初報 | 72h (重大) |
| サプライチェーン管理 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 暗号化義務 | 推奨 | 推奨 | ✅ | ✅ | ✅ |
| 監査・証拠保全 | ✅ | ✅ | ✅ | ✅ | ✅ |

---

## §29. セキュリティガバナンス (Security Governance)

> **参考規格**: NIST CSF 2.0 (Govern Function), ISO 27001, COBIT

### 29.1. ガバナンスフレームワーク

-   **Law**: セキュリティリスク管理をエンタープライズリスク管理（ERM）に統合する。NIST CSF 2.0 Govern関数を参照フレームワークとする。
-   **Action**:
    1.  **組織コンテキスト**: ビジネス目標、規制要件、リスク環境を文書化し、セキュリティ戦略に反映。
    2.  **セキュリティ戦略**: リスクアペタイト（許容リスクレベル）を定義し、セキュリティ投資の優先順位付けに反映。
    3.  **役割と責任**: セキュリティの意思決定者・実行者・被相談者・被通知者のRACIマトリクスを定義。

### 29.2. リスクアペタイト定義

| リスクレベル | 定義 | 対応方針 |
|:-----------|:-----|:---------|
| **Critical** | 事業継続に致命的影響 | 即時対応。リスク受容不可 |
| **High** | 重大な財務・法的・評判ダメージ | 72時間以内に緩和策実施 |
| **Medium** | 限定的な影響 | 計画的対応 |
| **Low** | 軽微な影響 | 監視継続。受容可能 |

### 29.3. セキュリティ予算・リソース

-   **ガイドライン**: IT予算の**10-15%**をセキュリティに配分推奨（NIST/業界標準）。
-   **投資優先領域**: IAM、脅威検出・インシデント対応、セキュリティ自動化、セキュリティ教育・訓練。

### 29.4. エグゼクティブ報告

-   **Law**: 経営層/取締役会へのセキュリティ状況の定期報告体制を確立する。
-   **報告内容**: セキュリティ指標ダッシュボード（§24.4 KPI要約）、主要リスクと状況、インシデントサマリー、コンプライアンス状況、セキュリティ投資ROI。
-   **頻度**: 四半期 + 重大インシデント時のアドホック報告。

### 29.5. ポリシー管理

-   **Law**: セキュリティポリシーの陳腐化を防ぐため、定期的にレビュー・更新する。
-   **Action**:
    1.  **年次レビュー**: 全セキュリティポリシーの年次レビューを義務化。
    2.  **トリガーベース更新**: 重大インシデント、規制変更、技術スタック変更時に即時ポリシー更新。
    3.  **バージョン管理**: ポリシー文書のバージョン履歴を維持。
    4.  **周知義務**: ポリシー変更時は全ステークホルダーへの周知と承認を確保。

### 29.6. コンプライアンス監査

-   **Law**: 定期的な内部/外部セキュリティ監査を実施し、コンプライアンスを保証する。
-   **Action**:
    1.  **内部監査**: 半年ごとのセキュリティ構成・運用の自己評価。
    2.  **外部監査**: 年1回の第三者セキュリティ監査を推奨（SOC 2 Type II等）。
    3.  **是正**: 監査発見事項は30日以内に是正計画を策定、90日以内に完了。

---

## §30. 成熟度モデル・アンチパターン (Maturity Model & Anti-Patterns)

### 30.1. セキュリティ成熟度モデル（5段階）

| レベル | 名称 | 特徴 |
|:------|:-----|:-----|
| **Level 1: Initial** | 場当たり対応 | セキュリティは個人の知識に依存。ポリシーなし |
| **Level 2: Developing** | 基本ポリシー策定 | 基本ポリシー存在。部分的な実施。自動化なし |
| **Level 3: Defined** | 標準化・組織展開 | 全チームで統一ポリシー実施。CI/CDにセキュリティゲート統合 |
| **Level 4: Managed** | 測定・最適化 | KPI測定。リスクベースの意思決定。SIEM/SOAR運用 |
| **Level 5: Optimized** | 継続的改善・予測 | AIベースの脅威予測。レッドチーム常設。業界ベンチマーク超過 |

### 30.2. セキュリティ 30大アンチパターン

| # | アンチパターン | 参照セクション |
|:--|:-------------|:-------------|
| 1 | シークレットのハードコーディング | §4.1, §21.1 |
| 2 | `SELECT *` の使用 | §7.2 |
| 3 | RLSポリシーなしのテーブル公開 | §12.3 |
| 4 | `Access-Control-Allow-Origin: *` | §10.7 |
| 5 | CSPヘッダーなし / `unsafe-inline` | §12.1, §12.2 |
| 6 | PIIのログ出力 | §7.4 |
| 7 | SQLの文字列連結 | §10.4 |
| 8 | クライアントサイドのみの入力検証 | §10.3 |
| 9 | `localStorage`へのトークン保存 | §22.3 |
| 10 | MFA未実装の管理画面 | §4.2 |
| 11 | 本番エラーでスタックトレース表示 | §10.9 |
| 12 | `latest` タグでのイメージデプロイ | §14.1 |
| 13 | GitHub ActionsのSHAピン留めなし | §19.3 |
| 14 | EXIF未除去の画像保存 | §15.2 |
| 15 | パスワードのMD5/SHA-1ハッシュ | §16.1 |
| 16 | SMS OTPのみの2要素認証 | §4.2 |
| 17 | DBのパブリックIP公開 | §13.5 |
| 18 | 静的APIキーの長期使用 | §21.5 |
| 19 | エージェントへの過剰権限付与 | §18.2 |
| 20 | SBOM未生成のデプロイ | §11.1 |
| 21 | Webhook署名未検証 | §12.8 |
| 22 | DMARC未設定 | §12.7 |
| 23 | 監査ログの欠如 | §25.1 |
| 24 | 依存関係の脆弱性放置 | §11.2 |
| 25 | 自前の認証基盤構築 | §4.3 |
| 26 | `Math.random()` での暗号鍵生成 | §16.3 |
| 27 | MCPサーバーの未承認導入 | §18.3 |
| 28 | NHIの共有クレデンシャル | §3.2 |
| 29 | 同意なしのCookie設定 | §9.2 |
| 30 | 脅威モデリングなしの設計 | §19.2 |

---

## 言語固有セクション (Language-Specific Security)

### TypeScript / JavaScript

-   `eval()`, `Function()`, `new Function()` の使用は**完全禁止**。
-   `dangerouslySetInnerHTML` / `v-html` は**PRレビューでの特別承認**が必要。
-   `any` 型の使用を最小限に。入力バリデーションでは `unknown` + Zodを使用。
-   `process.env` 経由のシークレット取得を強制。直値禁止。
-   `===` 厳密等価演算子の使用を強制（`==` 禁止）。

### Python

-   `pickle.loads()` に未信頼データを渡すことは**絶対禁止**（任意コード実行リスク）。
-   `subprocess.call(shell=True)` 禁止。`subprocess.run()` + リスト引数を使用。
-   `os.system()` 禁止。
-   `yaml.safe_load()` を使用。`yaml.load()` は**禁止**。
-   `format()` / f-string でのユーザー入力直接展開に注意。テンプレートインジェクション対策。

### Go

-   `html/template` を使用（`text/template` はXSS未対策）。
-   `crypto/rand` を使用（`math/rand` は暗号用途不可）。
-   SQLクエリは `database/sql` のプレースホルダーを使用（文字列結合禁止）。
-   goroutineのリソースリーク防止（`context.WithTimeout` / `context.WithCancel` の活用）。

### SQL

-   `SELECT *` 禁止。必要カラムのみ明示的指定。
-   動的SQLは禁止。パラメータ化クエリのみ使用。
-   `GRANT ALL` 禁止。必要な権限のみ個別に付与。
-   `SECURITY DEFINER` 関数には `SET search_path = public` を必ず付与。

---

## Appendix A: 逆引き索引 (Quick Reference Index)

| キーワード | セクション |
|:---------|:---------|
| A2A | §18.4 |
| Access Control | §4.5, §10.1 |
| Account Lockout | §6.6 |
| Agentic AI | §18 |
| API Discovery / Shadow API | §10.10 |
| API Gateway | §10.11 |
| API Key | §4.8, §21 |
| Audit Log | §25.1 |
| Authentication | §4 |
| Authorization | §4.5, §10.1 |
| BOLA / BFLA | §10.1 |
| Bot Management | §23 |
| CAPTCHA / Turnstile | §6.6, §23.2 |
| Container | §14 |
| Cookie | §12.4 |
| CORS | §10.7 |
| CSP (Content Security Policy) | §12.2 |
| Cryptography | §16 |
| CSRF | §10.8 |
| Data Classification | §8.1 |
| Data Minimization | §7.2 |
| Data Residency | §7.6 |
| DDoS | §23.3 |
| DKIM / DMARC / SPF | §12.7 |
| DOM XSS | §22.1 |
| DORA | §28.3 |
| DSPM | §8.2 |
| DTO | §10.2 |
| Dynamic Secrets | §21.3 |
| Email | §12.7 |
| Encryption | §7.5, §16 |
| Error Handling | §10.9 |
| EU AI Act | §28.1 |
| EXIF | §15.2 |
| File Upload | §15 |
| GDPR / Global Privacy Laws / CCPA | §9.1 |
| Governance | §29 |
| GraphQL | §20 |
| HSTS | §12.1 |
| Incident Response | §24.3 |
| Identity-First | §2.4, §3 |
| Injection | §10.4 |
| ITDR | §3.3 |
| JWT | §6.1, §6.7 |
| Kubernetes / K8s | §14 |
| License | §11.4 |
| LLM / AI Security | §17 |
| Local Storage | §22.3 |
| Logging | §25.1, §7.4 |
| MAESTRO | §18.5 |
| MCP | §18.3 |
| MFA | §4.2 |
| NHI (Non-Human Identity) | §3.2, §21.6 |
| NIS2 | §28.2 |
| NIST CSF 2.0 | §2.3, §29 |
| Nonce | §12.2 |
| OAuth / Social Login | §4.4 |
| OWASP Top 10 | §10, §17 |
| PAM | §3.4 |
| Passkey / WebAuthn / FIDO2 | §5 |
| Password | §4.9, §16.2 |
| Penetration Test | §25.3 |
| Permissions-Policy | §12.1 |
| PII | §7.3, §7.4 |
| PostMessage | §22.4 |
| Post-Quantum / PQC | §16.4 |
| Privacy | §7 |
| Prompt Injection | §17.1 |
| Rate Limiting | §10.6, §23.2 |
| RBAC | §4.5 |
| Right to be Forgotten | §9.3 |
| Risk Appetite | §29.2 |
| RLS (Row Level Security) | §12.3 |
| SASE | §13.1 |
| SBOM | §11.1 |
| Secret Management | §21 |
| Secret Rotation | §6.7, §16.3, §21.5 |
| Secret Zero | §21.4 |
| Session | §6 |
| SIEM | §26.1 |
| SLSA | §11.3 |
| SOAR | §26.3 |
| SRI (Subresource Integrity) | §12.5, §22.2 |
| SSRF | §10.5 |
| Supply Chain | §11 |
| Third-Party Scripts | §22.2 |
| TLS | §7.5, §16.2 |
| Trusted Types | §22.1 |
| Vendor | §27 |
| WAF | §13.3 |
| Webhook | §12.8 |
| XDR | §26.2 |
| Zero Trust | §2 |
| ZTNA | §13.2 |
| Zod / Validation | §10.3 |

---

> **Cross-References（関連ルールファイル）**:
> - `000_core_mindset.md` — 優先順位階層、ゼロトレランス
> - `300_engineering_standards.md` — CI/CD、コーディング基準
> - `301_api_integration.md` — API設計、CORSガバナンス
> - `320_supabase_architecture.md` — RLS、Auth、Vault、Connection Pooling
> - `361_aws_cloud.md` — AWS WAF、IAM、KMS
> - `400_ai_engineering.md` — AIガードレール、トークン管理
> - `502_site_reliability.md` — 可用性、監視、アラート
> - `503_incident_response.md` — インシデント対応フロー
> - `601_data_governance.md` — 法的コンプライアンス、データガバナンス、Cookie管理
> - `602_oss_compliance.md` — ライセンス管理詳細
> - `700_qa_testing.md` — セキュリティテストポリシー

### Cross-References

| セクション | 関連ルール |
|---------|----------|
| §1–§2 (ゼロトラスト) | `300_engineering_standards`, `801_governance` |
| §3 (Identity-First) | `320_supabase_architecture`, `360_firebase_gcp` |
| §7–§9 (プライバシー) | `601_data_governance` |
| §10 (APIセキュリティ) | `301_api_integration` |
| §11 (サプライチェーン) | `602_oss_compliance` |
| §12–§13 (インフラ・SASE) | `502_site_reliability`, `361_aws_cloud` |
| §17–§18 (AI/LLM) | `400_ai_engineering` |
| §28 (規制コンプライアンス) | `601_data_governance`, `800_internationalization` |

