# 36. Engineering: Native Platforms (Kotlin & Swift)

## 1. Philosophy: "Native Excellence in a Cross-Platform World"
Flutterファーストの環境であっても、高性能な統合、バックグラウンド処理、最新OS機能へのアクセスのためには、ネイティブプラットフォームへの深い理解が不可欠です。ネイティブ品質においても妥協しません。

## 2. Android (Kotlin) Standards

### 2.1. Modern Architecture
*   **Jetpack Libraries**: 堅牢で保守性の高いコードのためにAndroid Jetpackライブラリを活用する。
*   **Coroutines & Flow**: 非同期処理にはKotlin Coroutinesを使用する。`AsyncTask`や生のThreadは避ける。
    *   **Rule**: メインスレッドをブロックしないよう、ディスク/ネットワーク操作には必ず`Dispatchers.IO`を使用する。
*   **Dependency Injection**: ネイティブモジュールのDIには**Hilt**（推奨）またはKoinを使用する。

### 2.2. Code Style & Quality
*   **Kotlin Style Guide**: [Android Kotlin Style Guide](https://developer.android.com/kotlin/style-guide)に厳密に準拠する。
*   **Null Safety**: KotlinのNull安全機能を活用する。`!!`演算子は避け、`?.`や`?:`を使用する。
*   **Linter**: **ktlint**を使用してスタイルを強制する。

### 2.3. パフォーマンス (Performance)
*   **R8/ProGuard**: コードの縮小と難読化のための設定を適切に行う。
*   **Memory Leaks**: デバッグビルドで**LeakCanary**を使用し、特にContext処理に関連するメモリリークを検出する。

## 3. iOS (Swift) 標準 (iOS (Swift) Standards)

### 3.1. モダンアーキテクチャ (Modern Architecture)
*   **SwiftUI & UIKit**: UIはFlutterが担うが、ネイティブUI（ウィジェットなど）が必要な場合は可能な限り**SwiftUI**を使用する。
*   **Concurrency**: 非同期タスクには**Swift Concurrency (async/await)**を使用する。「コールバック地獄」を避ける。
*   **ARC Management**: 循環参照（Retain Cycles）に注意する。クロージャ内では適切に`[weak self]`または`[unowned self]`を使用する。

### 3.2. コードスタイルと品質 (Code Style & Quality)
*   **SwiftLint**: コミュニティ標準を強制するために**SwiftLint**を必須とする。
*   **Protocol Oriented Programming**: クラス継承よりもプロトコルと値型（Structs）を優先する。

### 3.3. パフォーマンス (Performance)
*   **Instruments**: Xcode Instruments（Time Profiler, Allocations）を使用してネイティブコードのパフォーマンスをプロファイリングする。
*   **Background Tasks**: 最新のバックグラウンド実行管理には`BGTaskScheduler`を使用する。

## 4. 高度なネイティブ機能 (Advanced Native Features)
*   **生体認証 (Biometrics)**: FaceID / TouchID / Fingerprint を積極的に活用し、パスワード入力の手間を省きます。
*   **ハプティクス (Haptics)**: 成功、失敗、重要なインタラクション時に適切な触覚フィードバック（Haptic Feedback）を提供し、操作感を向上させます。

## 5. オフラインファーストとデータ効率 (Offline First & Data Efficiency)
*   **オフラインファースト (Offline First)**:
    *   **ローカルDB**: Room (Android) / Realm / SwiftData (iOS) を「信頼できる唯一の情報源（Single Source of Truth）」とし、ネットワーク接続がない状態でもアプリが稼働するように設計します。
    *   **バックグラウンド同期**: WorkManager (Android) / BackgroundTasks (iOS) を使用し、ネットワーク復帰時にデータを自動同期します。
    *   **セキュリティ例外 (Security Exception)**:
        *   **優先順位**: 「セキュリティ > オフライン利便性」です。
        *   **機密情報**: PII（個人特定情報）や決済情報は、暗号化（Android Keystore / iOS Keychain）なしでローカル保存することを禁じます。情報漏洩リスクがある場合、その機能のオフライン対応は無効化します。
*   **通信量への配慮 (Data Efficiency)**:
    *   **キャッシュ**: 画像やAPIレスポンスは積極的にキャッシュし、無駄な通信を削減します。
    *   **Wi-Fi限定**: 大容量データ（高解像度アセット、アップデート）のダウンロードは、デフォルトでWi-Fi接続時のみに制限します。ユーザーファーストの徹底です。

## 6. Flutter Integration (Platform Channels)
### 6.1. Type Safety (Pigeon)
*   **Mandatory Pigeon**: すべてのPlatform Channelに**[Pigeon](https://pub.dev/packages/pigeon)**を使用する。
    *   **Why**: 型の不一致によるランタイムクラッシュを防ぎ、ボイラープレートコードを削減するため。
    *   **No Raw MethodChannel**: 複雑なデータ構造に対して手動の`MethodChannel`呼び出しを避ける。

### 6.2. Threading
*   **Main Thread Safety**: ネイティブハンドラはメインスレッドで呼び出される。重い処理は即座にバックグラウンドスレッド（Coroutines/Dispatch Queues）にオフロードする。
    *   **Android**: `CoroutineScope(Dispatchers.IO).launch { ... }`
    *   **iOS**: `Task.detached { ... }`

### 6.3. Error Handling
*   **Standardized Errors**: ネイティブ例外を標準的なFlutterエラーコードにマッピングする。一般的な「Error」文字列を返さない。

## 7. リリースとテスト (Release & Testing)
*   **ベータテスト (Beta Testing)**:
    *   **TestFlight (iOS)** / **Google Play Console (Internal Testing)** を活用し、本番リリース前に必ず実機でのベータテストを実施します。
*   **ガイドライン遵守 (Guideline Compliance)**:
    *   **Apple App Store Review Guidelines** および **Google Play Developer Policy** を熟読し、リジェクトリスク（例：不適切な権限要求、課金周りの規約違反）を事前に排除します。
