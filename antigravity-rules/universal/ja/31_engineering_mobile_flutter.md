# 31. モバイルエンジニアリング (Mobile Engineering - Flutter)

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

## 3. プラットフォームへの忠実度 (Platform Fidelity)
*   **ネイティブの感触 (Native Feel)**:
    *   iOSでは「スワイプバック」、Androidでは「戻るボタン」の挙動を完全にサポートします。
    *   スクロールの物理挙動（Bouncing vs Clamping）は、各OSの標準に従います。
*   **アダプティブUI (Adaptive UI)**:
    *   OSごとに異なるダイアログ、ボトムシート、スイッチ等のUIコンポーネントを使い分け、違和感を排除します。

## 4. 品質保証 (Quality Assurance)
*   **Golden Tests**:
    *   UIの回帰テストとして、**Golden Toolkit** を使用したスナップショットテストを必須とします。
    *   異なるデバイスサイズ（iPhone SE, Pro Max, Pixel）での表示崩れを自動検知します。
*   **Maestro**:
    *   E2Eテストには **Maestro** を使用し、ユーザーの実際の操作フローを自動化します。

## 5. デプロイと配信 (Deployment & Distribution)
*   **CI/CD**:
    *   GitHub ActionsとCodemagic/Bitriseを連携させ、mainブランチへのマージをトリガーに、TestFlight/Google Play Internal Testingへ自動配信します。
    *   リリースビルドは、難読化（Obfuscation）と最適化（Tree Shaking）を必ず有効にします。bfuscate --split-debug-info=/<path>` を使用する。
    *   *Why*: シンボル名を短縮し、デバッグメタデータを削除するため。
*   **Golden Tests**: UIの退行（リグレッション）を防ぐためにゴールデンテスト（ピクセルパーフェクトチェック）を使用する。

## 3. Platform Fidelity & UI
*   **Native Feel**:
    *   iOSとAndroidそれぞれの「らしさ」を尊重しつつ、ブランドの世界観を統一する。
    *   Material 3 と Cupertino ウィジェットを適切に使い分けるか、高度にカスタマイズされた共通コンポーネントを構築する。

## 4. Robust Connectivity
*   **Offline-First**:
    *   ネットワーク切断時でもアプリがクラッシュせず、閲覧可能なデータは表示する。
    *   Repository Patternを用いて、ローカルキャッシュとリモートデータの同期を適切に管理する。
