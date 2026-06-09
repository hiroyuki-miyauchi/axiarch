# 64. 認証・パスキー深掘り (Authentication & Passkeys Deep Dive)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-06-09

> [!IMPORTANT]
> **Level 1 Priority: Absolute Compliance（最上位の優先事項）**
> 認証クレデンシャル層は「一度間違えると全ユーザーが同時に危険にさらされる」最も影響範囲の広い基盤である。
> 本ファイルの MUST 要件はリスク低減と最低品質の底上げを目的とし、ユーザー利便性・開発速度・コストよりも優先する。

> [!CAUTION]
> **Primary Directive（主要方針）**
> 本ファイルは `security/000_security_privacy.md` §4（認証・認可）・§5（Passkey）・§6（セッション管理）の **深掘り・詳細化版**である。
> 000 は要約レベルのポリシー、本ファイル（64）は実装可能な粒度のクレデンシャル層詳細を担う。重複ではなく拡充の位置づけ。
> セッション管理・Step-Up認証・フェデレーションは隣接ファイル（410/420 および 000 §6）へ委譲し、本ファイルは **クレデンシャルそのもの**（パスキー・MFA・パスワード・リカバリー・ライフサイクル）に集中する。

---

## 目次

- §1. 主要方針・責務範囲
- §2. 認証クレデンシャルの優先順位（フィッシング耐性ファースト）
- §3. パスキー / WebAuthn / FIDO2 アーキテクチャ
  - §3.1. 用語と構成要素
  - §3.2. Synced Passkey vs Device-Bound Passkey
  - §3.3. RP ID とオリジン検証
  - §3.4. Attestation の選択基準（none / direct / enterprise）
  - §3.5. User Verification (UV) ポリシー
  - §3.6. Discoverable Credential (Resident Key)
  - §3.7. Conditional UI / Conditional Mediation（オートフィル）
  - §3.8. Cross-Device Authentication (CDA / hybrid transport)
  - §3.9. Related Origin Requests（関連オリジン）
  - §3.10. Signal API
  - §3.11. WebAuthn Level 3 の最新動向
- §4. WebAuthn 実装：サーバー検証
  - §4.1. 登録（Registration / Attestation）検証
  - §4.2. 認証（Authentication / Assertion）検証
  - §4.3. クライアント実装（navigator.credentials）
- §5. MFA / 2FA 戦略
  - §5.1. MFA 方式の強度序列
  - §5.2. TOTP (RFC 6238)
  - §5.3. プッシュ通知 + Number Matching
  - §5.4. ハードウェアセキュリティキー
  - §5.5. SMS / 音声 OTP の非推奨と限定的許容条件
  - §5.6. バックアップコード
- §6. パスワードポリシー (NIST SP 800-63B / 800-63-4)
- §7. パスワードレス戦略と移行ロードマップ
- §8. クレデンシャルライフサイクル
- §9. アカウントリカバリー設計（最弱リンク防御）
- §10. 多角観点（可観測性 / FinOps / 性能 / Zero Trust / a11y / プライバシー）
- §11. 責任分界点（IDaaS 前提・RP/IdP の責務境界）
- §12. アンチパターン集
- §13. 成熟度モデル L1–L5
- Appendix A: 逆引き索引

---

## §1. 主要方針・責務範囲 (Primary Directive & Scope)

### 1.1. 責務範囲

-   **本ファイル（64）の責務**: 認証「クレデンシャル」層の実装詳細。パスキー/WebAuthn、MFA要素、パスワード、クレデンシャルのライフサイクルとリカバリー。
-   **本ファイルが扱わないもの（委譲先）**:

| トピック | 委譲先 |
|:--------|:-------|
| セッション/トークン管理、Step-Up認証の全体設計 | `security/000_security_privacy.md` §6, `security/420_step_up_auth_and_sensitive_operations.md` |
| OAuth/OIDC/SAML フェデレーション、ソーシャルログイン | `security/000_security_privacy.md` §4.4/§4.10, `security/410_federated_identity_and_oauth.md` |
| 認可（RBAC/ABAC）、PAM、ITDR | `security/000_security_privacy.md` §3, §4.5 |
| ボット対策・レート制限の総論 | `security/000_security_privacy.md` §10.6, §23 |

### 1.2. 基本原則

-   **Rule 64.1.1（フィッシング耐性ファースト）**: 新規に認証要素を選定する場合、フィッシング耐性のある方式（パスキー/FIDO2/プラットフォーム認証器）を**第一候補**とする。フィッシング耐性のない要素（OTP共有秘密、SMS）は補助・フォールバックの位置づけに留める。
-   **Rule 64.1.2（自前認証基盤の構築禁止）**: 認証の中核（パスワードハッシュ、セッション、WebAuthnサーバー検証、OTP検証）の**自前ゼロ実装は禁止**。検証済みのIDaaSまたは保守されたライブラリ（例: `@simplewebauthn`, `otplib`）を用いる（§11参照）。
-   **Rule 64.1.3（Defense in Depth）**: いずれか単一の要素が破られても他要素が機能する設計とする。パスキー導入後もパスワードやリカバリー経路が弱点として残らないよう全経路を同一強度で設計する（§9参照）。
-   **Rule 64.1.4（誇張禁止）**: 「完璧」「絶対安全」を標榜しない。本ファイルの目的は**攻撃コストの引き上げとリスクの体系的低減**であり、各要件は最低品質の底上げとして読む。ただし MUST と明記した要件は必須である。

---

## §2. 認証クレデンシャルの優先順位（フィッシング耐性ファースト）

### 2.1. 要素強度の序列

-   **Law**: 認証要素は以下の序列で優先採用する。上位ほどフィッシング耐性・耐リプレイ性が高い。

| ランク | 要素 | フィッシング耐性 | 推奨用途 |
|:------|:-----|:---------------|:---------|
| **S** | Device-Bound Passkey / ハードウェアキー (FIDO2) | あり（オリジン束縛） | 管理者・高リスク操作・特権アカウント |
| **A** | Synced Passkey (WebAuthn) | あり（オリジン束縛） | 一般ユーザーの主要素 |
| **B** | プッシュ通知 + Number Matching | 部分的 | パスキー非対応環境の第2要素 |
| **C** | TOTP (RFC 6238) | なし（共有秘密） | パスキー非対応環境の第2要素 |
| **D** | SMS / 音声 OTP | なし（SIMスワップ/SS7） | 最終フォールバックのみ（§5.5の条件下） |

-   **Rule 64.2.1**: 高リスク操作（決済、ロール変更、アカウント削除）の**唯一の第2要素**として SMS OTP を用いてはならない（MUST NOT）。フィッシング耐性要素または最低でも TOTP を併用する。
-   **Rule 64.2.2**: 「パスワード + SMS」を「強い認証」と表示・記録してはならない。両要素ともフィッシング耐性がなく、リアルタイムフィッシングで同時に窃取され得る。

### 2.2. フィッシング耐性の定義

-   **フィッシング耐性 (Phishing-Resistant)** とは、**クレデンシャルが要求元オリジンに暗号的に束縛**されており、偽サイトに提示しても成立しない性質を指す。WebAuthn/FIDO2 はこの性質を満たす。OTP・パスワードは満たさない。
-   **Cross-Reference**: `security/000_security_privacy.md` §4.2 (MFA), §3.3 (ITDR)

---

## §3. パスキー / WebAuthn / FIDO2 アーキテクチャ

> **参考規格**: W3C WebAuthn Level 2 (REC), WebAuthn Level 3 (Draft), FIDO2, CTAP2.1, FIDO Alliance Passkey Guidelines

### 3.1. 用語と構成要素

| 用語 | 説明 |
|:-----|:-----|
| **RP (Relying Party)** | 認証を要求するサービス（あなたのアプリ）。RP ID はその識別子（通常は登録可能ドメイン） |
| **Authenticator（認証器）** | クレデンシャルを保持・署名する主体。プラットフォーム認証器（Touch ID/Windows Hello）とローミング認証器（YubiKey 等） |
| **Passkey** | FIDO2/WebAuthn の discoverable credential のユーザー向け呼称。秘密鍵は認証器内に留まる |
| **CTAP2** | クライアント（ブラウザ/OS）とローミング認証器間のプロトコル |
| **Attestation** | 認証器の出所・モデルを RP に証明する仕組み |
| **Assertion** | 認証時に認証器が生成する署名付きレスポンス |

-   **Rule 64.3.1**: 秘密鍵・生体テンプレートは**認証器内に留まり、サーバーへ送信されない**。RP が保存するのは公開鍵・credential ID・署名カウンタ等のメタデータのみ（MUST）。生体情報のサーバー送信・保存は禁止（§10.6参照）。

### 3.2. Synced Passkey vs Device-Bound Passkey

| 種別 | 特徴 | 使い分け |
|:-----|:-----|:---------|
| **Synced Passkey** | プロバイダ（iCloud Keychain / Google Password Manager / 1Password 等）でクラウド同期。デバイス紛失耐性が高い | 一般ユーザーの主要素。利便性とリカバリー性を優先する用途 |
| **Device-Bound Passkey** | 単一デバイス/ハードウェアキーに固定。同期されない（`backupEligible=false`） | 管理者・特権・高保証用途。コンプライアンスで単一デバイス保証が必要な場合 |

-   **Rule 64.3.2**: 認証応答の **`backupEligible (BE)` / `backupState (BS)` フラグ**を記録し、同期パスキーかデバイス固定かを判別する。管理者・特権アカウントは Device-Bound（ハードウェアキー）を**必須**とする（MUST、§3 管理者要件・000 §5.5 と整合）。
-   **Rule 64.3.3**: Synced Passkey は同期プロバイダのアカウント乗っ取りが攻撃面となる。高保証用途では同期プロバイダの強度に依存しないデバイス固定を選ぶ。
-   一般ユーザーには Synced を既定とし、利便性とリカバリー性（デバイス紛失時の復元）を優先する。

### 3.3. RP ID とオリジン検証

-   **Rule 64.3.4（RP ID 設定）**: RP ID は**登録可能サフィックスドメイン**に設定する（例: `example.com`）。サブドメインをまたいでパスキーを共有する場合は親ドメインを RP ID とし、各オリジンが RP ID の下位であることを検証する（MUST）。
-   **アンチパターン**: RP ID にフルオリジン（`https://www.example.com`）やポート付き文字列を設定する／開発の都合で本番と異なる RP ID を流用する。RP ID の不整合は登録済みパスキーを使用不能にする。
-   **Rule 64.3.5（オリジン検証）**: サーバー検証時、`clientDataJSON.origin` が**許可オリジンの完全一致リスト**に含まれることを検証する（MUST）。`type` が `webauthn.create`/`webauthn.get` であること、`challenge` がサーバー発行値と一致することも検証する。

### 3.4. Attestation の選択基準（none / direct / enterprise）

| Attestation | 内容 | 推奨採用基準 |
|:-----------|:-----|:------------|
| **none** | 認証器のモデルを開示しない | **既定**。一般的なコンシューマ向けサービス。プライバシー配慮。検証コストが低い |
| **direct** | 認証器のモデル証明書を取得 | 認証器の種別・認証レベル（FIDO 認定）を確認したい場合。AAGUID で機種を識別 |
| **enterprise** | 個体識別可能な証明（シリアル等） | 企業管理デバイス限定。デバイスインベントリと突合する高保証用途のみ。プライバシー影響大 |

-   **Rule 64.3.6**: コンシューマ向けは `attestation: 'none'` を**既定**とする。不要な `direct`/`enterprise` 要求はユーザーのプライバシーを損なうため、機種制限・認定要件など明確な根拠がある場合に限り採用する。
-   `direct`/`enterprise` を採用する場合は、FIDO Metadata Service (MDS) と照合して認証器の真正性・脆弱性ステータスを検証する。

### 3.5. User Verification (UV) ポリシー

-   **UV** は認証器でのローカル本人確認（生体/PIN）が行われたかを示す。`userVerification` に `required` / `preferred` / `discouraged` を指定。
-   **Rule 64.3.7**: 主要素（パスワードレス・第1要素）としてのパスキーは `userVerification: 'required'` とする（MUST）。第2要素としての利用（所持の証明のみで足りる場合）は `preferred` を許容する。
-   サーバー検証時、ポリシーに応じて authenticatorData の **UV フラグ**を必ず検証する。

### 3.6. Discoverable Credential (Resident Key)

-   **Discoverable Credential（旧 Resident Key）**: ユーザー識別子を認証器側に保持し、ユーザー名入力なしでログイン可能にする。`residentKey: 'required'`（または `'preferred'`）+ `requireResidentKey` で要求。
-   **Rule 64.3.8**: ユーザー名レス（Usernameless）ログインおよび Conditional UI を提供する場合、登録時に discoverable credential を要求する（MUST）。これがないとオートフィル UX が成立しない。
-   ローミング認証器の保存容量には上限があるため、Device-Bound ハードウェアキー運用ではクレデンシャル数の管理に留意する。

### 3.7. Conditional UI / Conditional Mediation（オートフィル）

-   **Conditional Mediation** は、フォーカス時に既存パスキーをブラウザのオートフィル候補として提示する仕組み。ユーザー名フィールドに `autocomplete="username webauthn"` を付与し、`navigator.credentials.get({ mediation: 'conditional', ... })` を呼ぶ。
-   **Rule 64.3.9**: パスキーログイン画面は Conditional UI を推奨する。`PublicKeyCredential.isConditionalMediationAvailable()` で対応可否を判定し、非対応時は明示的なパスキーボタンへフォールバックする。

```html
<!-- ✅ Conditional UI: オートフィル候補にパスキーを提示 -->
<input type="text" name="username" autocomplete="username webauthn" />
```

### 3.8. Cross-Device Authentication (CDA / hybrid transport)

-   **CDA (hybrid transport)**: スマートフォンの認証器を別デバイス（PC）の認証に使う仕組み。QRコード提示 + BLE による近接証明（proximity check）で構成。フィッシング中継を防ぐため BLE による物理的近接が要求される。
-   **Rule 64.3.10**: CDA を無効化しない。リモートのリレー攻撃に対し BLE 近接チェックが防御層となるため、QR スキャンのみで近接検証を省く独自実装を作ってはならない（MUST NOT）。標準のブラウザ/OS フローに委ねる。
-   CDA はデバイスをまたいだ初回ログインのフォールバックとして有用。同期パスキー未対応のクロスエコシステム（iOS↔Windows 等）で特に価値がある。

### 3.9. Related Origin Requests（関連オリジン）

-   **Related Origin Requests**: 同一サービスが複数の eTLD+1（例: `example.com` と `example.co.jp`）で運用される場合に、`/.well-known/webauthn` を公開して関連オリジンからのパスキー利用を許可する仕組み（WebAuthn L3）。
-   **Rule 64.3.11**: マルチドメイン運用でパスキーを共有する場合は Related Origin Requests を用いる。RP ID を安易に広いドメインに設定して回避してはならない。`/.well-known/webauthn` の `origins` リストは厳密に管理する。

### 3.10. Signal API

-   **Signal API**（WebAuthn L3）: RP が認証器/パスワードマネージャに対し、クレデンシャルの状態変化を通知する API。`signalUnknownCredential`（サーバーに存在しないクレデンシャルの削除提案）、`signalAllAcceptedCredentials`（有効なクレデンシャル一覧の同期）、`signalCurrentUserDetails`（ユーザー名/表示名の更新）。
-   **Rule 64.3.12**: クレデンシャル失効・ユーザー名変更時に Signal API を呼び、パスワードマネージャ側の**ゴーストパスキー**（サーバー側で既に削除されたのに UI に残る項目）を抑制する。対応ブラウザでのみ best-effort で実施。

### 3.11. WebAuthn Level 3 の最新動向

-   **採用方針**: WebAuthn **Level 2 を REC（安定）基盤**として実装し、Level 3 のドラフト機能（Related Origin Requests, Signal API, `getClientCapabilities()` 等）は**プログレッシブエンハンスメント**として、機能検出（feature detection）の上で追加する。
-   ドラフト仕様は変更余地があるため、L3 機能の非対応をエラーにせず、L2 のコア機能で必ず認証が完結する設計にする（MUST）。

---

## §4. WebAuthn 実装：サーバー検証

> 実装ライブラリは `@simplewebauthn/server`（Node）等の保守されたものを用いる。以下はサーバー検証で**必ず確認すべき項目**を示すための代表例。

### 4.1. 登録（Registration / Attestation）検証

-   **検証必須項目（MUST）**: ① challenge 一致（サーバー発行・一回限り） ② origin 完全一致 ③ RP ID ハッシュ一致 ④ UV フラグ（ポリシー準拠） ⑤ credential ID の一意性 ⑥ 公開鍵・署名カウンタ・AAGUID・BE/BS フラグの保存。

```typescript
// ✅ 登録検証（@simplewebauthn/server）
import { verifyRegistrationResponse } from '@simplewebauthn/server';

const verification = await verifyRegistrationResponse({
  response,                                  // クライアントからの attestation レスポンス
  expectedChallenge: storedChallenge,        // サーバーが発行した使い捨て challenge
  expectedOrigin: ['https://example.com'],   // 完全一致の許可オリジン
  expectedRPID: 'example.com',               // 登録可能ドメイン
  requireUserVerification: true,             // 主要素なら必須
});

if (!verification.verified) throw new Error('Registration verification failed');

const { credential, credentialDeviceType, credentialBackedUp, aaguid } =
  verification.registrationInfo;
// credential.id / credential.publicKey / credential.counter を保存
// credentialBackedUp (BS) と credentialDeviceType で synced/device-bound を判別し保存
```

### 4.2. 認証（Authentication / Assertion）検証

-   **検証必須項目（MUST）**: ① challenge 一致 ② origin 完全一致 ③ RP ID ハッシュ一致 ④ UV フラグ ⑤ 署名検証（保存済み公開鍵で） ⑥ **署名カウンタの単調増加**（複製クローン検知。0 を返す認証器は例外扱い）。

```typescript
// ✅ 認証検証
import { verifyAuthenticationResponse } from '@simplewebauthn/server';

const verification = await verifyAuthenticationResponse({
  response,
  expectedChallenge: storedChallenge,
  expectedOrigin: ['https://example.com'],
  expectedRPID: 'example.com',
  credential: {                              // DBから取得した登録済みクレデンシャル
    id: stored.id,
    publicKey: stored.publicKey,
    counter: stored.counter,
  },
  requireUserVerification: true,
});

if (!verification.verified) throw new Error('Authentication failed');
// verification.authenticationInfo.newCounter で counter を更新
// newCounter <= stored.counter の場合はクローン疑いとして要調査
```

### 4.3. クライアント実装（navigator.credentials）

```typescript
// ✅ 登録（クライアント）
const cred = await navigator.credentials.create({
  publicKey: {
    challenge,                               // サーバー発行のランダム値
    rp: { id: 'example.com', name: 'Example' },
    user: { id: userIdBytes, name: email, displayName },
    pubKeyCredParams: [{ alg: -7, type: 'public-key' },  // ES256
                       { alg: -257, type: 'public-key' }], // RS256
    authenticatorSelection: {
      residentKey: 'required',               // discoverable credential
      userVerification: 'required',
    },
    attestation: 'none',
  },
});

// ✅ 認証（Conditional UI / オートフィル）
const assertion = await navigator.credentials.get({
  mediation: 'conditional',                  // オートフィル候補として提示
  publicKey: { challenge, rpId: 'example.com', userVerification: 'required' },
});
```

---

## §5. MFA / 2FA 戦略

### 5.1. MFA 方式の強度序列

-   §2.1 の序列に従う。**フィッシング耐性MFA（パスキー/ハードウェアキー）を最優先**とし、TOTP・プッシュは過渡期の第2要素、SMS は最終手段とする。
-   **Rule 64.5.1**: 管理者・特権アカウントには MFA を**例外なく強制**（MUST、000 §4.2 と整合）。可能な限り Device-Bound パスキー/ハードウェアキーを要求する。

### 5.2. TOTP (RFC 6238)

-   **Rule 64.5.2（TOTP実装）**: TOTP は RFC 6238 準拠。**30秒のタイムステップ**、**6桁以上**、HMAC-SHA1（互換性）または SHA-256。検証時は時計ずれを許容するため**前後±1ステップ**のウィンドウを許可する（広すぎる窓は禁止）。
-   **Rule 64.5.3（リプレイ防止）**: 一度使用した OTP コードは同一タイムステップ内で再利用不可とする（最後に成功したステップを記録し、それ以下を拒否）。
-   共有秘密（seed）は保存時に暗号化し、QRプロビジョニングは `otpauth://` URI を用いる。秘密はログ・URL クエリに残さない。

```typescript
// ✅ TOTP 検証（otplib）— リプレイ防止つき
import { authenticator } from 'otplib';
authenticator.options = { window: 1, step: 30, digits: 6 };

function verifyTotp(token: string, secret: string, lastUsedStep: number) {
  const isValid = authenticator.verify({ token, secret });
  if (!isValid) return { ok: false };
  const currentStep = Math.floor(Date.now() / 1000 / 30);
  if (currentStep <= lastUsedStep) return { ok: false }; // リプレイ拒否
  return { ok: true, usedStep: currentStep };
}
```

### 5.3. プッシュ通知 + Number Matching

-   **Rule 64.5.4**: プッシュ承認型 MFA は **Number Matching（番号照合）**を必須とする（MUST）。単純な「承認/拒否」のみのプッシュは MFA Fatigue（プッシュ爆撃）に弱い。
-   プッシュには**コンテキスト情報**（リクエスト元アプリ・地理的位置・IP）を表示する。短時間に大量のプッシュ要求を検知したら自動で一時停止し、ユーザーに通知する（000 §3.3 ITDR と連携）。

### 5.4. ハードウェアセキュリティキー

-   **Rule 64.5.5**: 高保証用途（管理者・金融・機微データ）には FIDO2 ハードウェアキー（YubiKey 等）を採用する。可能なら**2本以上を登録**し、1本紛失時の自己リカバリーを確保する（バックアップキー）。
-   ハードウェアキーは Device-Bound であり、フィッシング耐性 S ランク（§2.1）。CTAP2.1 の PIN/生体での UV を有効にする。

### 5.5. SMS / 音声 OTP の非推奨と限定的許容条件

-   **Law**: SMS/音声 OTP は **SIMスワップ攻撃・SS7プロトコル脆弱性・端末横取り**により傍受され得るため、**フィッシング耐性のない最弱要素**として扱う（NIST SP 800-63B でも restricted authenticator）。
-   **Rule 64.5.6（限定的許容条件）**: SMS OTP は以下を**全て**満たす場合のみ許容する。それ以外は使用してはならない（MUST NOT を既定とする）:
    1.  他のフィッシング耐性要素が利用できないユーザー向けの**最終フォールバック**であること。
    2.  高リスク操作（決済・権限変更・削除）の**唯一の第2要素ではない**こと。
    3.  SIMスワップ検知（キャリア連携 / 直近のSIM変更フラグ）と異常検知を併用すること。
    4.  ユーザーに、より強い方式（パスキー/TOTP）への移行を継続的に促すこと。
-   **Anti-Pattern**: SMS OTP を既定の第2要素として新規実装する／SMS を「2要素だから安全」と説明する。

### 5.6. バックアップコード

-   **Rule 64.5.7**: バックアップコードは**一回限り使用**。ハッシュ化して保存（パスワードと同じく Argon2id/bcrypt、平文保存禁止）。生成時に一括表示し、各コードは使用後に失効する。
-   推奨: 8〜10個、各10文字以上。残数が少なくなったらユーザーに再生成を促す。バックアップコードはフィッシング耐性がないため、リカバリーの一手段に留め、唯一の手段にしない。

---

## §6. パスワードポリシー (NIST SP 800-63B / 800-63-4)

> **参考規格**: NIST SP 800-63B / SP 800-63-4（最新版）

-   **Law**: パスワードを用いる場合は NIST SP 800-63B / 800-63-4 に準拠する。要件は「長さ重視・複雑性要件廃止・流出照合・定期変更廃止」。

| 項目 | 要件 |
|:-----|:-----|
| **最低長** | 8文字以上（管理者: 12文字以上）。**最大長は64文字以上**を許可 |
| **文字種別の強制** | **しない**（大文字/記号必須等の複雑性ルールは廃止） |
| **使用可能文字** | 全 Unicode・スペース・絵文字を許可。貼り付け（ペースト）を禁止しない |
| **流出パスワード照合** | 新規設定・変更時に既知漏洩パスワード（Have I Been Pwned k-Anonymity API 等）と照合し、ヒット時は拒否（MUST） |
| **定期変更の強制** | **しない**。漏洩の証拠がある場合のみ変更を要求 |
| **ヒント・秘密の質問** | **禁止**（パスワードヒント、知識ベースのセキュリティ質問は使用しない） |
| **強度フィードバック** | zxcvbn 等でリアルタイム強度メーターを提供 |
| **ハッシュ** | **Argon2id（推奨）** または bcrypt(cost≥12)/scrypt。SHA-256/MD5 単体での保存は**絶対禁止** |

-   **Rule 64.6.1**: パスワード比較は**定数時間比較**で行い、ユーザー名の存在有無を応答時間・メッセージから推測させない（000 §6.6 と整合）。
-   **Cross-Reference**: `security/000_security_privacy.md` §4.9 (Password Policy), §16 (暗号化)

---

## §7. パスワードレス戦略と移行ロードマップ

-   **Law**: パスキーをパスワードレスの戦略的方向性とし、段階的に移行する（000 §5.1/§5.3 の詳細化）。

| フェーズ | アクション | 出口基準 |
|:--------|:---------|:---------|
| **Phase 1: 共存** | パスキー登録をオプト提供。パスワード + 任意パスキー | 登録動線の整備・計測開始 |
| **Phase 2: 推奨** | ログイン後にパスキー登録を能動的に促す。Conditional UI 提供 | パスキー採用率 30%+ |
| **Phase 3: 優先** | パスキーを既定の認証手段に。パスワードはフォールバック | 採用率 70%+・パスワードログイン比率の継続低下 |
| **Phase 4: パスワードレス** | 新規はパスキーのみ。既存はパスワード廃止を選択可能に | パスワード依存ユーザーの十分な移行 |

-   **Rule 64.7.1**: パスワードレス化の各フェーズでも**リカバリー経路の強度を主経路と揃える**こと。パスキーを強くしてもリセット経路が弱いと全体強度はリセット経路に律速される（§9参照）。

---

## §8. クレデンシャルライフサイクル

-   **Rule 64.8.1（登録 / Enrollment）**: クレデンシャル登録自体を保護対象とする。新規パスキー/MFA要素の追加は、既存の有効なセッション + 可能なら Step-Up 認証の上で行い、登録完了をユーザーに**通知**する（000 §6.2 / 420 と連携）。
-   **Rule 64.8.2（複数クレデンシャル管理）**: ユーザーが複数のパスキー/要素を登録・命名・一覧・削除できる管理 UI を提供する。各クレデンシャルに「最終使用日時・デバイス種別・synced/device-bound」を表示する。
-   **Rule 64.8.3（失効 / Revocation）**: クレデンシャル削除時はサーバー側で即時無効化し、Signal API（§3.10）で認証器側へ通知する。失効イベントを監査ログに記録し、ユーザーへ通知する。
-   **Rule 64.8.4（ローテーション）**: 共有秘密（TOTP seed、バックアップコード）と署名鍵は侵害疑い時に再生成できる導線を用意する。最後の1要素を削除して**ロックアウトする操作は防止**（必ず代替要素の存在を確認してから削除を許可）。
-   **Rule 64.8.5（最小1要素の保証）**: アカウントは常に少なくとも1つの有効な認証手段を保持することを保証し、孤立（ロックアウト）を構造的に防ぐ。

---

## §9. アカウントリカバリー設計（最弱リンク防御）

> **Law**: リカバリーは認証システムの**最弱リンク**である。主認証をどれだけ強化しても、リカバリーが弱ければ攻撃者はそこを突く。リカバリー経路は主経路と**同等の強度**で設計する（MUST）。

-   **Rule 64.9.1（セキュリティ質問の禁止）**: 知識ベースのセキュリティ質問（母親の旧姓・出身地等）を**リカバリーに使用してはならない**（MUST NOT）。公開情報・推測・ソーシャルエンジニアリングで突破される。
-   **Rule 64.9.2（多経路・段階的）**: リカバリーは複数の独立要素を組み合わせる（例: 登録済みメール + 既存デバイス確認 + 本人確認）。単一経路（メールだけ）で完全復旧できる設計を避ける。
-   **Rule 64.9.3（遅延と通知）**: 高リスクなリカバリー（全要素喪失からの復旧）には**待機期間（クールダウン）**を設け、その間に登録済み全チャネルへ**通知**する。正規ユーザーが不正なリカバリーをキャンセルできる猶予を作る。
-   **Rule 64.9.4（MFAバイパス禁止）**: リカバリーフローが MFA/パスキーを**実質的に無効化する裏口**になってはならない（MUST NOT）。パスワードリセットだけで MFA を解除できる設計は禁止。リカバリー後も必要な要素の再登録を要求する。
-   **Rule 64.9.5（フィッシング耐性の維持）**: 推奨リカバリー手段は、リカバリーコード（オフライン保存）+ バックアップパスキー/ハードウェアキー（複数登録）とする。SMS/メールリンクは補助に留め、可能なら近接・所持証明を併用する。
-   **Rule 64.9.6（レート制限・列挙防止）**: リカバリー開始エンドポイントにレート制限を課し、アカウント存在の有無を応答から漏らさない統一メッセージを返す。
-   **Cross-Reference**: `security/000_security_privacy.md` §5.4 (Account Recovery), §6.6 (Brute Force)

---

## §10. 多角観点

### 10.1. 可観測性 (Observability)

-   **Rule 64.10.1**: 認証イベント（成功/失敗/MFA要求/要素登録/失効/リカバリー）を**構造化ログ**として記録する。PII はマスキングし、`userId`・要素種別・結果・リスクスコア・IP/UA を残す（000 §7.4 と整合）。
-   **メトリクス**: ログイン成功率、MFA 完了率、パスキー採用率、リカバリー発生率、認証失敗の分布を継続計測。異常（同一IPからの大量失敗、Impossible Travel）を ITDR（000 §3.3）に連携。

### 10.2. FinOps

-   **Rule 64.10.2**: IDaaS は MAU・MFA・SMS 送信単位で課金されることが多い。**SMS OTP は送信1件ごとに課金**され、攻撃者による OTP 送信乱用（SMS Pumping / Toll Fraud）でコストが急増し得る。SMS をパスキー/TOTP に置換することはセキュリティとコストの双方を改善する。
-   SMS 送信にレート制限・国別フィルタ・異常検知を課し、Toll Fraud を防ぐ。

### 10.3. パフォーマンス・スケーラビリティ

-   **Rule 64.10.3**: 認証レイテンシは UX に直結する。WebAuthn 署名検証・Argon2id 検証はサーバー負荷を持つため、Argon2id パラメータ（メモリ/反復）はセキュリティとレイテンシ目標の両立点に調整し、負荷試験で検証する。
-   challenge・セッション状態はステートレス検証可能な設計（署名付き短命トークン等）にし、水平スケールを阻害しない。

### 10.4. Zero Trust 連携

-   **Rule 64.10.4**: 認証結果（要素種別・フィッシング耐性の有無・UV・デバイス種別）を**認可・継続検証のシグナル**として下流に伝える。フィッシング耐性要素での認証時のみ高リスク操作を許可する等、Zero Trust のリスクスコアに反映する（000 §2, §6.2 と連携）。

### 10.5. アクセシビリティ (a11y)

-   **Rule 64.10.5**: パスキー UX はキーボード操作・スクリーンリーダーで完結可能にする。技術用語（WebAuthn/FIDO2）を避け「指紋・顔・端末でログイン」等の平易な表現を用いる（000 §5.6 と整合）。生体が使えないユーザー向けに PIN/ハードウェアキー/代替要素を必ず用意し、特定モダリティに依存しない。

### 10.6. プライバシー

-   **Rule 64.10.6**: 生体情報（指紋/顔テンプレート）は**デバイス内に留まりサーバーへ送信・保存されない**（MUST）。RP が扱うのは公開鍵とメタデータのみ。
-   **Rule 64.10.7**: Attestation は機種・個体を識別し得るため、必要最小限（既定 `none`）に留める（§3.4）。`enterprise` attestation はプライバシー影響が大きく、管理デバイス限定とする。

---

## §11. 責任分界点（IDaaS 前提・RP/IdP の責務境界）

-   **Law**: 認証基盤は IDaaS（Firebase Authentication, Auth0, Amazon Cognito, Clerk, WorkOS, Supabase Auth 等）を用いることを前提とし、**自前の認証基盤構築を禁止**する（64.1.2 / 000 §4.3）。

| 責務 | RP（あなたのアプリ）側 | IdP / IDaaS 側 |
|:-----|:----------------------|:---------------|
| クレデンシャル保管・ハッシュ | — | 担当（パスワードハッシュ・パスキー公開鍵保管） |
| WebAuthn サーバー検証 | IDaaS未対応時のみ自前（保守ライブラリ使用） | 多くは IDaaS が提供 |
| MFA要素の登録・検証 | ポリシー定義・要求 | 検証ロジック |
| セッション/トークン発行 | 検証・失効連携 | 発行・署名 |
| リスク検知・ITDR | シグナル消費・追加防御 | 検知・スコアリング |
| 認可（RBAC/ABAC） | **担当**（業務ロジック） | — |
| リカバリーポリシー | **設計・ポリシー定義** | 実行手段の提供 |

-   **Rule 64.11.1**: IDaaS を使う場合でも、**オリジン/RP ID 検証・UV ポリシー・リカバリー設計・SMS の限定・監査ログ**は RP 側の責務として明示的に設定・検証する。IDaaS の既定値を鵜呑みにせず、本ファイルの MUST 要件に適合させる。
-   **Rule 64.11.2**: IDaaS ベンダーロックインに備え、ユーザー識別子・クレデンシャルメタデータの移行可能性（エクスポート手段）を事前に評価する。

---

## §12. アンチパターン集

| # | アンチパターン | 正しい対応 |
|:--|:-------------|:----------|
| 1 | SMS OTP を高リスク操作の唯一の第2要素にする | フィッシング耐性要素か最低でも TOTP を併用（§5.5） |
| 2 | 「パスワード + SMS」を「強い認証」と表示する | 両者ともフィッシング耐性なし。表現と実態を一致させる（§2.1） |
| 3 | RP ID にフルオリジンやポート付き文字列を設定する | 登録可能ドメインを RP ID にする（§3.3） |
| 4 | サーバー検証で origin を完全一致で確認しない | 許可オリジンの完全一致リストで検証（§4） |
| 5 | challenge を使い回す / 失効させない | 使い捨て challenge をサーバー発行・一回限り（§4） |
| 6 | 署名カウンタを検証しない | 単調増加を検証しクローンを検知（§4.2） |
| 7 | 不要に `direct`/`enterprise` attestation を要求 | 既定 `none`、明確な根拠がある場合のみ昇格（§3.4） |
| 8 | 主要素パスキーで UV を `discouraged` にする | 主要素は `required`（§3.5） |
| 9 | リカバリーでセキュリティ質問を使う | 知識ベース質問は禁止（§9.1） |
| 10 | パスワードリセットだけで MFA を解除できる | リカバリーが MFA バイパスにならない設計（§9.4） |
| 11 | 生体テンプレートをサーバーへ送信・保存する | 生体はデバイス内に留める（§10.6） |
| 12 | パスワードに複雑性要件・定期変更を強制する | NIST 準拠：長さ重視・複雑性/定期変更廃止（§6） |
| 13 | 流出パスワード照合をしない | HIBP 等で既知漏洩を拒否（§6） |
| 14 | パスワードを SHA-256/MD5 で保存する | Argon2id/bcrypt(cost≥12)（§6） |
| 15 | プッシュ承認で Number Matching を使わない | Number Matching を必須化（§5.3） |
| 16 | TOTP の検証窓を広く取りすぎる / リプレイ許容 | ±1ステップ・使用済みステップ拒否（§5.2） |
| 17 | バックアップコードを平文保存・無期限・無制限使用 | ハッシュ保存・一回限り・残数管理（§5.6） |
| 18 | 最後の1要素を削除させてユーザーをロックアウト | 最小1要素を保証し削除を防止（§8.5） |
| 19 | パスキーは強いがリセット経路が弱く全体が律速 | リカバリー強度を主経路と揃える（§7.1, §9） |
| 20 | WebAuthn サーバー検証を自前ゼロ実装する | 保守ライブラリ/IDaaS を使う（§1.2, §11） |
| 21 | CDA で BLE 近接を省く独自 QR フローを作る | 標準フローに委ねる（§3.8） |
| 22 | Synced パスキーのみで管理者認証を許可する | 管理者は Device-Bound 必須（§3.2） |

---

## §13. 成熟度モデル L1–L5

| レベル | 状態 | 特徴 |
|:------|:-----|:-----|
| **L1: Initial** | パスワード単独。MFA なしか SMS のみ | 複雑性要件・定期変更を強制。リカバリーにセキュリティ質問。最も脆弱 |
| **L2: Managed** | IDaaS 導入。TOTP/アプリMFA を任意提供 | NIST 準拠パスワード（流出照合）。管理者に MFA 強制 |
| **L3: Defined** | パスキー登録を提供。Number Matching プッシュ | 全ユーザーに MFA。SMS を最終フォールバックに格下げ。監査ログ整備 |
| **L4: Phishing-Resistant** | パスキーが主要素。管理者は Device-Bound 必須 | リカバリーがフィッシング耐性・多経路・遅延通知。ITDR 連携 |
| **L5: Passwordless** | パスワードレス（パスキーのみ）に到達 | Signal API でクレデンシャル同期。Zero Trust の認証シグナル統合。SMS 全廃 |

-   **Rule 64.13.1**: 現在地を評価し、**最低 L3 を到達目標**とする。高リスク/特権を扱うサービスは L4 以上を目標とする。

---

## Appendix A: 逆引き索引

> AIが本ファイルを部分ロードする際に使用する逆引き索引。

| キーワード | セクション |
|:----------|:----------|
| パスキー / Passkey / WebAuthn / FIDO2 / CTAP2 | §3 |
| Synced vs Device-Bound / backupEligible / BE/BS フラグ | §3.2 |
| RP ID / オリジン検証 / origin 完全一致 | §3.3, §4 |
| Attestation / none / direct / enterprise / AAGUID / MDS | §3.4 |
| User Verification / UV / userVerification | §3.5 |
| Discoverable Credential / Resident Key / Usernameless | §3.6 |
| Conditional UI / Conditional Mediation / autocomplete webauthn / オートフィル | §3.7 |
| Cross-Device Authentication / CDA / hybrid / QR / BLE 近接 | §3.8 |
| Related Origin Requests / .well-known/webauthn / マルチドメイン | §3.9 |
| Signal API / ゴーストパスキー / クレデンシャル同期 | §3.10 |
| WebAuthn Level 2 / Level 3 / getClientCapabilities | §3.11 |
| WebAuthn サーバー検証 / @simplewebauthn / 署名カウンタ | §4 |
| navigator.credentials.create / get | §4.3 |
| MFA / 2FA / 強度序列 / フィッシング耐性MFA | §2, §5 |
| TOTP / RFC 6238 / otplib / リプレイ防止 | §5.2 |
| プッシュ通知 / Number Matching / MFA Fatigue | §5.3 |
| ハードウェアキー / YubiKey / FIDO2 / バックアップキー | §5.4 |
| SMS OTP / 音声OTP / SIMスワップ / SS7 / 限定許容 | §5.5 |
| バックアップコード / リカバリーコード | §5.6, §9.5 |
| パスワードポリシー / NIST SP 800-63B / 800-63-4 / HIBP / Argon2id | §6 |
| パスワードレス / 移行ロードマップ / Phase | §7 |
| クレデンシャルライフサイクル / 登録 / 失効 / ローテーション | §8 |
| アカウントリカバリー / 最弱リンク / セキュリティ質問禁止 / MFAバイパス禁止 | §9 |
| 認証イベントログ / メトリクス / 異常検知 | §10.1 |
| FinOps / IDaaS課金 / SMS Pumping / Toll Fraud | §10.2 |
| 認証レイテンシ / Argon2id パラメータ / スケーラビリティ | §10.3 |
| Zero Trust 認証シグナル / 継続検証 | §10.4 |
| アクセシビリティ / パスキー a11y | §10.5 |
| 生体情報 / デバイス内 / サーバー送信禁止 | §10.6 |
| IDaaS / 責任分界点 / RP / IdP / 自前認証禁止 | §11 |
| アンチパターン | §12 |
| 成熟度モデル / L1-L5 | §13 |

---

**Cross-Reference（関連ルール）:**
-   `security/000_security_privacy.md` — §4 認証・認可、§5 Passkey、§6 セッション管理（本ファイルの上位ポリシー・要約）
-   `security/410_federated_identity_and_oauth.md` — OAuth 2.1 / OIDC / SAML フェデレーション、ソーシャルログイン
-   `security/420_step_up_auth_and_sensitive_operations.md` — Step-Up認証、機微操作の再認証、ティア別保護
-   `security/100_data_governance.md` — 同意管理、生体データの法規制、子供データ保護
-   `engineering/500_firebase_gcp.md` — Firebase Authentication 実装、Identity Platform
-   `engineering/300_web_frontend.md` — フロントエンドの認証UX、クライアントサイドセキュリティ
-   `operations/000_internal_tools.md` — 社内ツールのSSO・管理者認証・特権アクセス

### クロスリファレンス

| セクション | 関連ルール |
|-----------|------------|
| §2–§5（クレデンシャル強度・MFA） | `security/000_security_privacy`（§4, §5） |
| §3–§4（パスキー/WebAuthn実装） | `engineering/500_firebase_gcp`, `engineering/300_web_frontend` |
| §6（パスワードポリシー） | `security/000_security_privacy`（§4.9, §16） |
| §9（リカバリー） | `security/000_security_privacy`（§5.4, §6.6） |
| §10–§11（多角観点・責任分界） | `operations/000_internal_tools`, `security/100_data_governance` |
