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

### 2.3. Performance
*   **R8/ProGuard**: コードの縮小と難読化のための設定を適切に行う。
*   **Memory Leaks**: デバッグビルドで**LeakCanary**を使用し、特にContext処理に関連するメモリリークを検出する。

## 3. iOS (Swift) Standards

### 3.1. Modern Architecture
*   **SwiftUI & UIKit**: UIはFlutterが担うが、ネイティブUI（ウィジェットなど）が必要な場合は可能な限り**SwiftUI**を使用する。
*   **Concurrency**: 非同期タスクには**Swift Concurrency (async/await)**を使用する。「コールバック地獄」を避ける。
*   **ARC Management**: 循環参照（Retain Cycles）に注意する。クロージャ内では適切に`[weak self]`または`[unowned self]`を使用する。

### 3.2. Code Style & Quality
*   **SwiftLint**: コミュニティ標準を強制するために**SwiftLint**を必須とする。
*   **Protocol Oriented Programming**: クラス継承よりもプロトコルと値型（Structs）を優先する。

### 3.3. Performance
*   **Instruments**: Xcode Instruments（Time Profiler, Allocations）を使用してネイティブコードのパフォーマンスをプロファイリングする。
*   **Background Tasks**: 最新のバックグラウンド実行管理には`BGTaskScheduler`を使用する。

## 4. Flutter Integration (Platform Channels)

### 4.1. Type Safety (Pigeon)
*   **Mandatory Pigeon**: すべてのPlatform Channelに**[Pigeon](https://pub.dev/packages/pigeon)**を使用する。
    *   **Why**: 型の不一致によるランタイムクラッシュを防ぎ、ボイラープレートコードを削減するため。
    *   **No Raw MethodChannel**: 複雑なデータ構造に対して手動の`MethodChannel`呼び出しを避ける。

### 4.2. Threading
*   **Main Thread Safety**: ネイティブハンドラはメインスレッドで呼び出される。重い処理は即座にバックグラウンドスレッド（Coroutines/Dispatch Queues）にオフロードする。
    *   **Android**: `CoroutineScope(Dispatchers.IO).launch { ... }`
    *   **iOS**: `Task.detached { ... }`

### 4.3. Error Handling
*   **Standardized Errors**: ネイティブ例外を標準的なFlutterエラーコードにマッピングする。一般的な「Error」文字列を返さない。
