# 36. ネイティブプラットフォーム (Native Platforms - Kotlin & Swift)

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
*   **生体認証 (Biometrics)**:
    *   **FaceID / TouchID**: ログインや重要な操作（決済等）には、必ず生体認証オプションを提供し、UXとセキュリティを両立させます。
    *   **フォールバック**: 生体認証が利用できない場合のPINコード等のフォールバックを必ず実装します。
*   **画像解析とAI (Image Analysis & AI)**:
    *   **ML Kit / Core ML**: デバイスオンデバイスでの画像解析（OCR、物体認識）を優先し、サーバー負荷とプライバシーリスクを低減します。
*   **音声認識 (Voice Recognition)**:
    *   **Speech-to-Text**: 検索や入力フォームにおいて、音声入力オプションを積極的に提供します。
*   **UIアニメーション (UI Animation)**:
    *   **Haptics**: 成功、失敗、スライダー操作時に適切な触覚フィードバック（Haptic Feedback）を提供します。
    *   **120Hz**: スクロールやスライダーのアニメーションは、ProMotionディスプレイ（120Hz）に対応し、ヌルヌル動くように最適化します。

## 5. オフラインファーストとデータ効率 (Offline First & Data Efficiency)
*   **オフラインファースト (Offline First)**:
    *   **ローカルDB**: Room (Android) / Realm / SwiftData (iOS) を「信頼できる唯一の情報源（Single Source of Truth）」とし、ネットワーク接続がない状態でもアプリが稼働するように設計します。
    *   **バックグラウンド同期**: WorkManager (Android) / BackgroundTasks (iOS) を使用し、ネットワーク復帰時にデータを自動同期します。
*   **セキュリティ例外 (Security Exception - Level 1 Priority)**:
    *   **優先順位**: 「セキュリティ > オフライン利便性」です。
    *   **機密情報**: PII（個人特定情報）や決済情報は、暗号化（Android Keystore / iOS Keychain）なしでローカル保存することを禁じます。
    *   **リスク判断**: デバイス紛失時に情報漏洩のリスクがある場合、その機能のオフライン対応は**無効化**します。利便性よりも安全性を取ります。
*   **通信量への配慮 (Data Efficiency)**:
    *   **キャッシュ**: 画像やAPIレスポンスは積極的にキャッシュし、無駄な通信を削減します。
    *   **Wi-Fi限定**: 大容量データ（高解像度アセット、アップデート）のダウンロードは、デフォルトでWi-Fi接続時のみに制限します。

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
    *   **最新情報**: 開発開始時に必ず最新のガイドライン変更点（例：プライバシーマニフェストの義務化）を確認します。

## 8. ネイティブ・アクセシビリティ (Native Accessibility)
*   **スクリーンリーダー対応**:
    *   **義務**: 新機能リリース前には、iOS VoiceOver / Android TalkBack での実機確認を必須とします。
    *   **フォーカス順序**: ナビゲーション順序が論理的（左上から右下）であることを確認します。
*   **インクルーシブデザイン**:
    *   **Dynamic Type**: フォントサイズはユーザー設定（最大200%）に追従し、レイアウトが崩れないようにします。
    *   **タッチ領域**: 全てのインタラクティブ要素は最低 **44x44dp (iOS) / 48x48dp (Android)** を確保します。
