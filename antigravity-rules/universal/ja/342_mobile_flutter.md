# 31. モバイルエンジニアリング (Mobile Engineering - Flutter)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-03-24

> [!IMPORTANT]
> **Supreme Directive（最高指令）**
> 「Flutterはワンコードベース — だがワン妥協ではない。プラットフォーム忠実度は交渉不可。」
> すべてのFlutter実装は各プラットフォームでネイティブ品質のUXを提供しなければならない。
> **UX忠実度 > パフォーマンス > コード再利用 > 開発速度** の優先順位を厳守せよ。
> **7セクション構成。**

---

## 目次

1. [§1. アーキテクチャと状態管理](#1-アーキテクチャと状態管理-architecture--state-management)
2. [§2. パフォーマンス最適化](#2-パフォーマンス最適化-performance-optimization---60fps-or-die)
3. [§3. プラットフォームへの忠実度と統合](#3-プラットフォームへの忠実度と統合-platform-fidelity--integration)
4. [§4. ユーザーガイドとオンボーディング](#4-ユーザーガイドとオンボーディング-user-guidance--onboarding)
5. [§5. 品質保証](#5-品質保証-quality-assurance)
6. [§6. デプロイと配信](#6-デプロイと配信-deployment--distribution)
7. [§7. Security & API Integration](#7-security--api-integration)
8. [Appendix A: 逆引き索引](#appendix-a-逆引き索引)

---

## 1. アーキテクチャと状態管理 (Architecture & State Management)
*   **Riverpod & Hooks**:
    *   **標準化**: 状態管理には **Riverpod (Code Generation)** を、UIロジックには **Flutter Hooks** を標準として採用します。
    *   **不変性 (Immutability)**: 状態（State）は全て `Freezed` を使用して不変（Immutable）にし、予期せぬ副作用を防ぎます。
*   **レイヤー構造 (Layered Architecture)**:
    *   **Presentation**: UIとViewModel（Notifier）。ロジックを持たせず、描画に徹します。
    *   **Domain**: ビジネスロジックとエンティティ。Flutterへの依存を排除します。
    *   **Data**: API通信、DB操作、DTO。Repositoryパターンで抽象化します。

## 2. パフォーマンス最適化 (Performance Optimization - "60fps or Die")
*   **レンダリング (Rendering)**:
    *   **再描画の抑制**: `Consumer` や `select` を適切に使用し、必要な部分だけを再描画（Rebuild）させます。
    *   **定数化**: `const` コンストラクタを徹底的に使用し、ウィジェットの再生成を防ぎます。
*   **起動速度 (Startup Time)**:
    *   アプリの起動時間は **2秒以内** を目指します。初期化処理は非同期で並列実行し、スプラッシュ画面で待機させません。
*   **画像処理 (Image Handling)**:
    *   `cached_network_image` を使用して画像をキャッシュし、通信量を削減します。
    *   巨大な画像はサーバー側でリサイズしてから取得します。

## 3. プラットフォームへの忠実度と統合 (Platform Fidelity & Integration)
*   **ネイティブの感触 (Native Feel)**:
    *   iOSでは「スワイプバック」、Androidでは「戻るボタン」の挙動を完全にサポートします。
    *   スクロールの物理挙動（Bouncing vs Clamping）は、各OSの標準に従います。
*   **アダプティブUI (Adaptive UI)**:
    *   OSごとに異なるダイアログ、ボトムシート、スイッチ等のUIコンポーネントを使い分け、違和感を排除します。
*   **Deep Linking**:
    *   **Universal Links / App Links**: Webとアプリをシームレスに繋ぐため、iOS/Android両方でディープリンクの実装を義務付けます。
    *   **体験**: ユーザーがWebのURLをタップした際、アプリがインストールされていれば即座にアプリ内の該当ページを開きます。

## 4. ユーザーガイドとオンボーディング (User Guidance & Onboarding)
*   **コーチマーク実装 (Coach Marks Implementation)**:
    *   **ライブラリ**: `tutorial_coach_mark` パッケージ（または同等の高品質ライブラリ）を使用し、実装工数を最小化します。自前での複雑なオーバーレイ実装は避けます。
    *   **OverlayPortal**: カスタムオーバーレイが必要な場合は、Flutter 3.10+の `OverlayPortal` を使用し、パフォーマンスを維持しつつウィジェットツリーの制約を回避します。
    *   **状態管理**: 「一度だけ表示する」状態は、必ずローカルストレージ（SharedPreferences/Isar）とリモートDBの両方で管理し、再インストール時にもユーザーを煩わせないようにします。

## 5. 品質保証 (Quality Assurance)
*   **Golden Tests**:
    *   UIの回帰テストとして、**Golden Toolkit** を使用したスナップショットテストを必須とします。
    *   異なるデバイスサイズ（iPhone SE, Pro Max, Pixel）での表示崩れを自動検知します。
*   **Maestro**:
    *   E2Eテストには **Maestro** を使用し、ユーザーの実際の操作フローを自動化します。

## 6. デプロイと配信 (Deployment & Distribution)
*   **CI/CD**:
    *   GitHub ActionsとCodemagic/Bitriseを連携させ、mainブランチへのマージをトリガーに、TestFlight/Google Play Internal Testingへ自動配信します。
    *   リリースビルドは、難読化（Obfuscation）と最適化（Tree Shaking）を必ず有効にします。`flutter build ipa --obfuscate --split-debug-info=/<path>` を使用します。

## 7. Security & API Integration
*   **The Native Bypass Protocol (VIP Lane Strategy)**:
    *   **Law**: バックエンドのTier 2 (VIP Lane) 戦略に対応するため、ログインユーザーのリクエストにおいては、**API Key (`x-api-key`) を送信せず、必ず `Authorization: Bearer <token>` のみを送信**することを義務付けます。
    *   **Reason**: アプリバイナリ内へのAPI Key（秘密鍵）埋め込みリスクを物理的にゼロにするためです。アプリ内にはPublic Keyすら持たせないのが理想です。

---

## Appendix A: 逆引き索引

### 逆引き索引（キーワード → セクション）

| キーワード | 対応セクション |
|---|---|
| Riverpod・Hooks・Freeezed・レイヤー | §1 アーキテクチャ |
| 60fps・再描画・起動速度・キャッシュ | §2 パフォーマンス |
| スワイプバック・ディープリンク・アダプティブUI | §3 プラットフォーム統合 |
| コーチマーク・オンボーディング | §4 ユーザーガイド |
| Golden Test・Maestro・E2E | §5 品質保証 |
| CI/CD・Codemagic・TestFlight | §6 デプロイ |
| API Key・Bearer Token・VIP Lane | §7 セキュリティ |

### クロスリファレンス（セクション → 関連ルール）

| セクション | 関連 Universal ルール |
|---|---|
| §1 アーキテクチャ | `300_engineering_standards`, `343_native_platforms` |
| §2 パフォーマンス | `200_design_ux`, `300_engineering_standards` |
| §3 プラットフォーム | `343_native_platforms`, `200_design_ux` |
| §4 オンボーディング | `200_design_ux` |
| §5 品質保証 | `700_qa_testing` |
| §6 デプロイ | `502_site_reliability`, `300_engineering_standards` |
| §7 セキュリティ | `600_security_privacy`, `301_api_integration` |
