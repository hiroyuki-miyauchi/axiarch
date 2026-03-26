# 36. ネイティブプラットフォーム (Native Platforms — Kotlin & Swift)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-03-24 | 対象: Kotlin 2.2+ / Swift 6.2+ / Android 16+ / iOS 26+

> [!IMPORTANT]
> **Supreme Directive（最高指令）**
> 「ネイティブは妥協ではなく、最高のユーザー体験への最短経路である。」
> クロスプラットフォームファーストの環境であっても、OS固有の深い統合・最先端AI・ハードウェアアクセスにおいてネイティブ品質を絶対に妥協しない。
> ネイティブプラットフォームの実装において、**セキュリティ > UX > パフォーマンス > 保守性 > 開発速度** の優先順位を厳守せよ。
> この文書はネイティブプラットフォーム戦略に関するすべての設計判断の最上位基準である。
> **40パート・186セクション構成。**

---

## 目次

| Part | トピック | セクション |
|------|---------|-----------| 
| I | 哲学と基本原則 | §1–§4 |
| II | Kotlin 2.2+ 言語標準 | §5–§10 |
| III | Swift 6.2+ 言語標準 | §11–§17 |
| IV | Android アーキテクチャ | §18–§25 |
| V | iOS アーキテクチャ | §26–§33 |
| VI | KMP / Kotlin Multiplatform | §34–§40 |
| VII | Compose Multiplatform | §41–§44 |
| VIII | Jetpack Compose パフォーマンス | §45–§50 |
| IX | SwiftUI ベストプラクティス | §51–§56 |
| X | 並行処理・非同期 | §57–§63 |
| XI | パフォーマンス最適化 | §64–§70 |
| XII | オンデバイスAI・エッジML | §71–§78 |
| XIII | オフラインファースト・データ永続化 | §79–§85 |
| XIV | セキュリティ・アプリ堅牢化 | §86–§94 |
| XV | プラットフォーム統合・OS機能 | §95–§101 |
| XVI | Flutter/クロスプラットフォーム連携 | §102–§106 |
| XVII | テスト戦略 | §107–§114 |
| XVIII | ビルド・CI/CD・リリース | §115–§122 |
| XIX | アクセシビリティ | §123–§127 |
| XX | 可観測性・モニタリング | §128–§132 |
| XXI | FinOps・コスト最適化 | §133–§136 |
| XXII | visionOS・Spatial Computing | §137–§139 |
| XXIII | Wear OS・watchOS | §140–§142 |
| XXIV | Android XR・Immersive | §143–§144 |
| XXV | グリーンエンジニアリング | §145–§147 |
| XXVI | プライバシー・コンプライアンス | §148–§152 |
| XXVII | チーム・組織設計 | §153–§155 |
| XXVIII | マイグレーション戦略 | §156–§158 |
| XXIX | デザインシステム連携 | §159–§161 |
| XXX | Embedded Systems・IoT | §162–§164 |
| XXXI | ネットワーキング・通信 | §165–§167 |
| XXXII | 国際化・ローカライゼーション | §168–§170 |
| XXXIII | データ変換・シリアライゼーション | §171–§172 |
| XXXIV | Dependency Management・SBOM | §173–§174 |
| XXXV | エラーハンドリング戦略 | §175–§176 |
| XXXVI | コード生成・メタプログラミング | §177–§178 |
| XXXVII | AI支援開発・Copilot統合 | §179–§180 |
| XXXVIII | ストア審査最適化 | §181–§182 |
| XXXIX | 成熟度モデル・アンチパターン | §183–§184 |
| XL | 将来展望 | §185–§186 |
| Appendix | 逆引き索引・クロスリファレンス | — |

---

## Part I: 哲学と基本原則

### §1. Supreme Directive — ネイティブ・エクセレンス

- **原則**: ネイティブ開発はクロスプラットフォームの補助ではなく、ユーザー体験の最高水準を達成する手段
- **優先順位**: セキュリティ > UX > パフォーマンス > 保守性 > 開発速度
- **ゼロ妥協**: OS固有の最新API・ハードウェア統合においてネイティブ品質を100%維持する
- **最新安定版**: 常にKotlin/Swiftの最新安定版を前提とする。非推奨APIの新規使用は禁止
- **Platform Conventions First**: 各プラットフォームのHIG/Material Design Guidelinesに完全準拠。プラットフォーム間でUXパターンを無理に統一しない
- **Privacy by Design**: ユーザーデータの収集は最小限に留め、オンデバイス処理を最優先する

### §2. プラットフォーム選択マトリクス

| ユースケース | 推奨アプローチ | 理由 |
|---|---|---|
| ビジネスロジック共有 | KMP (`commonMain`) | コード再利用率85%+ |
| UI集約型アプリ | Compose Multiplatform | iOS安定版到達、開発効率最大化 |
| OS深層統合（HealthKit, NFC等） | プラットフォーム固有ネイティブ | API制約・HW依存 |
| 高性能リアルタイム処理 | ネイティブ（Kotlin/Swift） | レイテンシ最小化 |
| ウィジェット / App Clips / Dynamic Island | プラットフォーム固有ネイティブ | OS要件 |
| オンデバイスAI | Core ML / ML Kit + ネイティブ | ハードウェアアクセラレータ最適化 |
| visionOS / Spatial Computing | SwiftUI + RealityKit | Apple専用エコシステム |
| Android XR / Immersive | Jetpack XR + ARCore | Google XRエコシステム |
| 組込みシステム / IoT | Kotlin/Native / Embedded Swift | 低レベルHW制御 |

### §3. アーキテクチャ原則

- **Clean Architecture**: Domain / Data / Presentation の3層分離を徹底
- **Dependency Inversion**: 上位レイヤーが下位レイヤーの具象に依存してはならない
- **Single Source of Truth (SSOT)**: 状態はローカルDB（Room / SwiftData）を唯一の真実とする
- **Unidirectional Data Flow (UDF)**: MVI / TCA 等の単方向データフロー必須
- **Feature Module化**: 機能単位でモジュール分割し、ビルド時間とテスト範囲を最小化
- **Composition over Inheritance**: 継承より合成を優先。プロトコル/インターフェース指向設計
- **Defensive Programming**: 全外部入力を疑い、境界でのバリデーションを徹底

### §4. バージョニング戦略

- **Minimum SDK**: Android `minSdk = 28` (Android 9)、iOS `deploymentTarget = 16.0` を下限推奨
- **Target SDK**: Android `targetSdk` は常に最新安定版を追従（Android 16 = API 36）。iOS は最新SDKでビルド
- **言語バージョン**: Kotlin 2.2+、Swift 6.2+ を必須。K2コンパイラをデフォルト有効化
- **非推奨API SLA**: 公式に非推奨化されたAPIは **2リリースサイクル以内** に移行完了
- **OS対応方針**: 最新OS + 直近2世代をサポート範囲とする
- **依存関係更新**: セキュリティパッチは72時間以内、通常更新はRenovate/Dependabotで21日待機後マージ

---

## Part II: Kotlin 2.2+ 言語標準

### §5. Kotlin 2.2 言語機能

- **Guard Conditions（安定版）**: `when`式内のガード条件で条件分岐の可読性を向上
- **Non-local break/continue（安定版）**: インライン関数ラムダ内での`break`/`continue`を活用
- **Multi-dollar interpolation（安定版）**: `$`リテラルを多用する文字列のエスケープ簡素化
- **Context Parameters（Preview）**: コンテキスト依存の依存性管理を簡素化。Context Receiversの後継
- **Context-sensitive resolution（Preview）**: Enum型推論の改善。コンテキストから型名を省略可能
- **`@JvmExposeBoxed`**: インライン値クラスのJava相互運用を改善
- **Base64 / HexFormat API（安定版）**: 標準ライブラリのエンコーディングAPI安定化
- **`-Xwarning-level`**: コンパイラ警告レベルの統一管理オプション

```kotlin
// ✅ Good: Guard Conditions (Stable in Kotlin 2.2)
sealed interface UiState {
    data object Loading : UiState
    data class Success(val data: List<Item>) : UiState
    data class Error(val message: String, val retryable: Boolean) : UiState
}

fun render(state: UiState) = when (state) {
    is UiState.Loading -> showLoading()
    is UiState.Success if state.data.isEmpty() -> showEmpty()
    is UiState.Success -> showList(state.data)
    is UiState.Error if state.retryable -> showRetryDialog(state.message)
    is UiState.Error -> showFatalError(state.message)
}

// ✅ Good: Context Parameters (Preview — Kotlin 2.2)
context(logger: Logger, db: Database)
fun processOrder(order: Order): Result<Receipt> {
    logger.info("Processing order: ${order.id}")
    return runCatching { db.save(order.toEntity()) }
        .map { Receipt(order.id, it.timestamp) }
}
```

### §6. Kotlin 2.2.20 追加機能

- **Kotlin/Wasm Beta到達**: Web対象がBeta。ブラウザデバッグ組み込みサポート
- **Swift Export（デフォルト有効・Experimental）**: Obj-Cエクスポートに代わる直接Swiftマッピング
- **`js`/`wasmJs`共有ソースセット**: マルチターゲットWebのコード共有
- **Kotlin/Native Xcode 26対応**: スタックカナリア、リリースバイナリサイズ削減
- **Long→BigInt（JS）**: JavaScriptターゲットでLong値がBigIntにコンパイル
- **安定版クロスプラットフォームコンパイル**: ライブラリの安定版クロスコンパイル

### §7. K2コンパイラ

- **必須有効化**: K2コンパイラをデフォルトで使用。K1は非推奨（IntelliJ IDEA 2025.1で非推奨化済み）
- **ビルド速度**: 平均2倍のコンパイル速度向上。JetBrains IntelliJモノレポで40%+削減
- **型推論改善**: 統合データ構造による精度の高い型推論・呼び出し解決
- **マルチプラットフォーム一貫性**: JVM/JS/Nativeで同一のコンパイル挙動を保証
- **KAPT→KSP移行**: K2移行に伴い、KAPTからKSP (Kotlin Symbol Processing) への移行を必須とする

```kotlin
// build.gradle.kts — K2 + KSP設定
plugins {
    id("com.google.devtools.ksp") version "2.2.0-1.0.x"
}

kotlin {
    compilerOptions {
        allWarningsAsErrors.set(true)
        freeCompilerArgs.addAll("-Xcontext-parameters")
    }
}
```

### §8. Null安全と型安全

- **`!!`演算子禁止**: 強制アンラップは例外なく禁止。`?.`、`?:`、`let`を使う
- **`requireNotNull`/`checkNotNull`**: プログラムエラーのアサートに限定使用
- **Result型**: 失敗する可能性のある操作には`kotlin.Result`またはカスタムSealed classを使用
- **データクラス**: DTO・値オブジェクトには`data class`。ボイラープレートを排除
- **不変性優先**: `val` > `var`、`List` > `MutableList`、`Map` > `MutableMap`
- **Sealed階層**: 状態管理・エラー型にはSealed class/interfaceを必須とし、`when`の網羅性チェックを保証
- **Value class**: 型の意味的区別に`@JvmInline value class`を活用（UserId, Email等）

### §9. コードスタイルとリンター

- **スタイルガイド**: [Android Kotlin Style Guide](https://developer.android.com/kotlin/style-guide) 厳守
- **ktlint**: CIパイプラインで必須実行。PRマージゲートとする
- **detekt**: 静的解析でComplexity, Naming, Performanceを自動検証。カスタムルールセット推奨
- **命名規約**: `lowerCamelCase`基本、定数`UPPER_SNAKE_CASE`、パッケージ`lowercase`
- **関数長制限**: 1関数30行以下推奨。超過時はリファクタリング検討
- **拡張関数**: ユーティリティコードは拡張関数で整理。レシーバの型スコープを限定
- **スコープ関数使い分け**:
  - `let`: null安全チェーン / 変数スコープ限定
  - `apply`: オブジェクト初期化設定
  - `also`: サイドエフェクト（ロギング等）
  - `run`: レシーバのコンテキスト内で処理実行
  - `with`: 非nullオブジェクトに対する複数操作

### §10. Kotlinネイティブ・Wasm

- **Kotlin/Native**: LLVM 19ベース。メモリ消費のトラッキング・調整機能を活用
- **スタックカナリア**: リリースバイナリにスタックカナリアを有効化（バッファオーバーフロー検知）
- **バイナリサイズ**: リリースビルドの最適化によるバイナリサイズ削減
- **Kotlin/Wasm（Beta）**: Web対象はBeta到達。Binaryen設定のプロジェクト単位カスタマイズ対応
- **共有ソースセット**: `js`と`wasmJs`ターゲット間の共有ソースセットを活用
- **Type-safe builders**: Kotlin DSLパターンでドメイン固有構成を型安全に構築

---

## Part III: Swift 6.2+ 言語標準

### §11. Swift 6.2 Approachable Concurrency

- **デフォルトMainActor実行**: スクリプト・UIコードではデフォルトでメインスレッド実行。明示的`@MainActor`不要
- **`@concurrent`属性**: 明示的な非同期実行を指定する新属性
- **偽データ競合警告の削減**: 並行処理を多用しないコードでの誤検知を大幅削減
- **予測可能な`async`挙動**: async呼び出しが呼び出し元のActorをデフォルトで尊重
- **タスク命名**: `Task`にデバッグ・プロファイリング用の名前を付与可能
- **Progressive Disclosure**: 並行処理の高度な機能は必要な時にのみ導入

```swift
// ✅ Good: Swift 6.2 @concurrent
@concurrent
func fetchData() async throws -> Data {
    // 明示的にバックグラウンドで実行
    let (data, _) = try await URLSession.shared.data(from: endpoint)
    return data
}
```

### §12. Swift 6 Strict Concurrency基盤

- **Strict Concurrency有効化必須**: データ競合をコンパイル時に検出
- **`Sendable`プロトコル**: スレッド間共有型は`Sendable`準拠必須
- **Actor分離**: 共有可変状態にはActorを使用。従来のロック機構を置き換え
- **`@MainActor`**: UI更新ロジックに付与しメインスレッド実行を保証
- **Structured Concurrency**: `async/await`と`TaskGroup`で非同期処理を構造化

```swift
// ✅ Good: Actor + Sendable
actor ImageCache: Sendable {
    private var cache: [URL: Data] = [:]

    func image(for url: URL) async throws -> Data {
        if let cached = cache[url] { return cached }
        let (data, _) = try await URLSession.shared.data(from: url)
        cache[url] = data
        return data
    }
}
```

### §13. 型安全とプロトコル指向

- **Protocol Oriented Programming (POP)**: クラス継承よりプロトコル+構造体を優先
- **値型優先**: `struct` > `class`。参照セマンティクスが必要な場合のみ`class`
- **Opaque Types**: `some Protocol`でAPI境界の柔軟性と型安全を両立
- **`@Observable`マクロ**: SwiftUI連携の監視可能オブジェクトに使用
- **Typed Throws (Swift 6)**: 型安全なエラーハンドリング

```swift
// ✅ Good: Typed throws
enum NetworkError: Error, Sendable {
    case timeout, unauthorized, serverError(Int)
}

func fetchUser() throws(NetworkError) -> User {
    // コンパイラがNetworkError以外のthrowを禁止
}
```

### §14. InlineArray・メモリ安全

- **`InlineArray`（Swift 6.2）**: コンパイル時に固定サイズの配列。ヒープ割り当て・ARC不要でスタック上に直接格納
- **構文**: `InlineArray<N, Element>` または `[N of Element]` のショートハンド
- **用途**: パフォーマンスクリティカルなコード（ゲーム、組込み、タイトループ）に最適
- **`Span`型（Swift 6.2）**: 連続メモリへの安全な直接アクセス。use-after-freeをコンパイル時防止
- **循環参照防止**: クロージャ内で`[weak self]`を適切に使用
- **Non-Copyable Types**: `~Copyable`をリソース管理（ファイルハンドル等）に活用
- **Strict Memory Safety**: オプトインのstrict memory safetyフラグでunsafe構文を検出・排除

```swift
// ✅ Good: InlineArray (Swift 6.2) — スタック上固定サイズ配列
let colors: InlineArray<4, Color> = [.red, .green, .blue, .white]
// または: let colors: [4 of Color] = [.red, .green, .blue, .white]

// ✅ Good: Span型 — メモリ安全な直接アクセス
func process(_ span: Span<UInt8>) {
    for byte in span {
        // use-after-freeをコンパイル時に防止
    }
}
```

### §15. Swift Package Manager

- **Package Traits（Swift 6.1）**: 環境に応じた機能適応（Embedded Swift、WebAssembly等）
- **`@implementation`属性**: Objective-C宣言のSwift実装を提供。段階的移行に活用
- **バージョン解決**: 依存関係のバージョン解決は`Package.resolved`をコミットし再現性を保証
- **依存関係最小化**: パッケージ依存は必要最小限。OpenSSF Scorecardによる評価推奨

### §16. コードスタイルとリンター

- **SwiftLint**: 必須。CIパイプラインに統合しPRマージゲート
- **SwiftFormat**: コードフォーマットの自動統一
- **命名規約**: Apple Swift API Design Guidelinesに厳密準拠
- **trailing comma**: Swift 6.1で各種リストにtrailing commaをサポート。有効化推奨
- **ドキュメントコメント**: `///`で公開APIに必ず付与

### §17. Swift WebAssembly・Embedded Swift

- **WebAssembly公式サポート（Swift 6.2）**: ブラウザ・サーバーレスランタイム対象のコンパイル
- **Embedded Swift**: 組込みシステム向けSwift。IoT/自動車領域
- **C++相互運用強化（Swift 6.2）**: C++プロジェクトとのシームレスな連携
- **Subprocessパッケージ**: Swiftから直接サブプロセスを起動・管理
- **VS Code拡張**: バックグラウンドインデキシング、LLDB統合、DocCライブプレビュー

---

## Part IV: Android アーキテクチャ

### §18. Jetpackライブラリスタック

- **BOM管理**: `androidx.compose:compose-bom`でCompose依存を統一バージョン管理
- **必須ライブラリ**: Compose UI, Material 3, Navigation, Lifecycle, Hilt, Room, DataStore, WorkManager
- **Gradle Version Catalog**: `libs.versions.toml`で全依存関係を一元管理。`build.gradle.kts`内のバージョン直書き禁止
- **型安全Navigation**: Compose Navigation 2.8+の型安全APIを使用。文字列ルート禁止

```kotlin
// libs.versions.toml
[versions]
compose-bom = "2025.12.00"
kotlin = "2.2.20"
hilt = "2.54"
room = "2.7.1"

[libraries]
compose-bom = { group = "androidx.compose", name = "compose-bom", version.ref = "compose-bom" }
```

### §19. MVIパターン（推奨アーキテクチャ）

- **Model-View-Intent**: 単方向データフローを厳守。ViewModel → State → UI → Intent → ViewModel
- **UiState**: Sealed interfaceで状態を型安全に定義
- **UiEvent**: ユーザーアクションをSealed classで表現
- **SideEffect**: ナビゲーション・Snackbar等のワンショットイベントはChannelで配信

```kotlin
// ✅ MVI Architecture
@HiltViewModel
class OrderViewModel @Inject constructor(
    private val orderRepository: OrderRepository,
) : ViewModel() {
    private val _state = MutableStateFlow<OrderUiState>(OrderUiState.Loading)
    val state: StateFlow<OrderUiState> = _state.asStateFlow()

    private val _sideEffect = Channel<OrderSideEffect>(Channel.BUFFERED)
    val sideEffect: Flow<OrderSideEffect> = _sideEffect.receiveAsFlow()

    fun onEvent(event: OrderEvent) {
        when (event) {
            is OrderEvent.Load -> loadOrders()
            is OrderEvent.Delete -> deleteOrder(event.id)
        }
    }

    private fun loadOrders() {
        viewModelScope.launch {
            _state.value = OrderUiState.Loading
            orderRepository.getOrders()
                .onSuccess { _state.value = OrderUiState.Success(it) }
                .onFailure { _state.value = OrderUiState.Error(it.message ?: "Unknown") }
        }
    }
}
```

### §20. マルチモジュール設計

- **Feature Module**: 機能単位で`:feature:xxx`モジュールを分割
- **Core Module**: 共通ユーティリティ・デザインシステムは`:core:xxx`
- **Data Module**: リポジトリ・API・DB実装は`:data:xxx`
- **Domain Module**: ビジネスロジック・UseCaseは`:domain`
- **Convention Plugin**: ビルド設定をConvention Pluginで共通化。各モジュールの`build.gradle.kts`を最小化
- **依存方向**: `feature → domain → data`。逆方向依存禁止

### §21. Dependency Injection — Hilt

- **Hilt必須**: AndroidのDIはHiltを標準採用。手動DIはプロトタイプのみ許可
- **`@HiltViewModel`**: ViewModelのDIはHilt経由で統一
- **`@Module`分割**: 機能モジュール毎に`@Module`を分割配置
- **テスト用Module**: `@TestInstallIn`でテスト時の差し替えを容易にする

### §22. Android 16 固有API統合

- **Foreground Service制約**: Android 14+のForeground Service Type宣言を厳守
- **Embedded Photo Picker**: システムフォトピッカーをアプリUI内に直接埋め込み。プライバシー保護とUX向上を両立
- **予測型バックジェスチャー**: Predictive Back Gestureに完全対応
- **Health Records API**: Health Connect経由でFHIR標準の医療データにアクセス
- **Adaptive Refresh Rate (ARR)**: `hasArrSupport`/`getSuggestedFrameRate`でディスプレイ可変リフレッシュレート最適化
- **Desktop Windowing**: 大画面デバイスでの複数ウィンドウ対応
- **Haptics API強化**: 振幅・周波数カーブ制御で豊かな触覚フィードバック
- **`getCpuHeadroom`/`getGpuHeadroom`**: ハードウェアリソース監視

### §23. Android Gradle設定基準

```kotlin
// build.gradle.kts — 共通設定
android {
    compileSdk = 36
    defaultConfig {
        minSdk = 28
        targetSdk = 36
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }
    buildFeatures {
        compose = true
        buildConfig = true
    }
    packaging {
        resources.excludes += "/META-INF/{AL2.0,LGPL2.1}"
    }
    lint {
        warningsAsErrors = true
        abortOnError = true
    }
}
```

### §24. ProGuard/R8最適化

- **R8 Full Mode**: `android.enableR8.fullMode=true`を有効化
- **難読化ルール**: ライブラリ固有のProGuardルールを適切に管理
- **リフレクション保護**: `@Keep`アノテーションでリフレクション対象を明示保護
- **マッピングファイル保持**: リリースビルドの`mapping.txt`を必ず保存（クラッシュ解析用）

### §25. Per-App Language・Grammatical Inflection

- **Per-App Language**: アプリ内言語設定のシステムAPI対応。`AppCompatDelegate.setApplicationLocales()`
- **Grammatical Inflection API**: 多言語対応のための文法活用API
- **ロケール管理**: `LocaleListCompat`によるロケール優先順位管理

---

## Part V: iOS アーキテクチャ

### §26. SwiftUI + MVVM/TCA

- **SwiftUI優先**: 新規画面はSwiftUIで実装。UIKitは既存画面の維持のみ
- **MVVM**: `@Observable`マクロを使用したViewModel + SwiftUIの標準パターン
- **TCA (The Composable Architecture)**: 大規模アプリではTCAを検討。単方向データフロー + テスタビリティ
- **Preview-Driven Development**: SwiftUI Previewsを積極活用。プレビュー可能な設計 = テスト可能な設計

### §27. iOS 26 固有フレームワーク統合

- **Liquid Glass**: iOS 26の新デザイン言語。ガラス質の透明・丸みを帯びたUI要素が自動適用
- **Foundation Models Framework**: オンデバイスLLM（約3Bパラメータ）へのアクセスAPI
- **HealthKit**: ヘルスデータ連携。権限要求は最小限に
- **StoreKit 2**: アプリ内課金。`Product`/`Transaction` APIを使用
- **PhotosUI**: `PhotosPicker`でシステムフォトピッカーを使用
- **WebView（SwiftUI）**: SwiftUIネイティブの`WebView`コンポーネント（iOS 26新規）

### §28. Privacy Manifest（必須）

- **`PrivacyInfo.xcprivacy`**: 全アプリに必須。使用APIの理由を宣言
- **Required Reason API**: UserDefaults, FileTimestamp, SystemBootTime, DiskSpace等の使用理由を明記
- **Tracking Domains**: サードパーティSDKのトラッキングドメインを宣言
- **サードパーティSDK**: 使用する全SDKのPrivacy Manifestを確認。未対応SDKは採用禁止

```xml
<!-- PrivacyInfo.xcprivacy -->
<dict>
    <key>NSPrivacyTracking</key>
    <false/>
    <key>NSPrivacyTrackingDomains</key>
    <array/>
    <key>NSPrivacyCollectedDataTypes</key>
    <array>
        <dict>
            <key>NSPrivacyCollectedDataType</key>
            <string>NSPrivacyCollectedDataTypeUserID</string>
            <key>NSPrivacyCollectedDataTypePurposes</key>
            <array>
                <string>NSPrivacyCollectedDataTypePurposeAppFunctionality</string>
            </array>
        </dict>
    </array>
</dict>
```

### §29. App Intents & Apple Intelligence

- **App Intents Framework**: Siri/Shortcuts/Apple Intelligence連携の標準API
- **App Shortcuts**: 主要機能をショートカットとして公開
- **Spotlight連携**: `CSSearchableItem`でアプリ内コンテンツをSpotlight検索可能に
- **Apple Intelligence統合**: Writing Tools、Image Playground等との連携設計

### §30. SwiftData統合

- **`@Model`マクロ**: Swiftデータモデルをネイティブ定義
- **`@Query`**: SwiftUIビューでのリアクティブデータ取得
- **ModelContainer / ModelContext**: 永続化バックエンド管理
- **スキーマバージョニング**: 構造変更前に必ずスキーマバージョンを更新
- **Class Inheritance（iOS 26+）**: 明確な「is-a」階層にのみ使用。浅い継承ツリーを維持
- **`@Index`マクロ（iOS 26+）**: ソート・フェッチの最適化インデックス定義
- **`@Unique`マクロ（iOS 26+）**: 複数属性にまたがる一意制約

### §31. Deployment Target基準

| Target | 最小バージョン | 根拠 |
|--------|-------------|------|
| iOS | 16.0 | SwiftUI成熟、95%+デバイスカバー |
| macOS | 13.0 | SwiftUI/SwiftData基盤 |
| watchOS | 9.0 | WidgetKit + SwiftUI |
| tvOS | 16.0 | SwiftUI標準化 |
| visionOS | 1.0 | 初版から対応 |

### §32. Xcode設定基準

- **Strict Concurrency Checking**: `Complete`に設定
- **Swift 6 Language Mode**: 有効化
- **Build Settings**: `SWIFT_STRICT_CONCURRENCY = complete`
- **Warnings as Errors**: `-warnings-as-errors`を有効化
- **Code Signing**: 自動署名 + Xcode Cloud / Fastlane連携

### §33. Observations・Reactive Patterns

- **`Observations` async sequences（Swift 6.2）**: Observable型のトランザクショナルな状態変更をストリーミング
- **UIKit統合（iOS 26+）**: UIKitがSwift Observationを自動統合。`layoutSubviews`等で自動追跡
- **Combineからの移行**: 新規コードは`@Observable`+`Observations`へ。Combineは既存コードの維持のみ

---

## Part VI: KMP / Kotlin Multiplatform

### §34. KMPアーキテクチャ設計

- **`commonMain`最大化**: ビジネスロジック・データ層・ドメインモデルを共有。共有率85%+を目標
- **`expect`/`actual`**: プラットフォーム固有実装のみ。既存マルチプラットフォームライブラリを優先検索
- **ソースセット構成**: `commonMain` → `androidMain` / `iosMain` / `jvmMain` / `wasmJsMain`
- **UIは柔軟に**: Compose Multiplatform（UIも共有）またはプラットフォーム固有UI（最大UX）を選択

```kotlin
// KMP expect/actual パターン
// commonMain
expect fun platformName(): String

// androidMain
actual fun platformName(): String = "Android ${Build.VERSION.RELEASE}"

// iosMain
actual fun platformName(): String = UIDevice.current.systemName()
```

### §35. KMPライブラリ選定

| 用途 | 推奨ライブラリ | 備考 |
|------|-------------|------|
| HTTP | Ktor Client | マルチプラットフォーム対応 |
| シリアライゼーション | kotlinx.serialization | 安定版。KMPネイティブサポート |
| 並行処理 | kotlinx.coroutines | Flow含む全ターゲット対応 |
| 日時 | kotlinx-datetime | Beta。Temporal APIとの互換性 |
| DI | Koin Multiplatform | KMP対応DI |
| 設定 | DataStore multiplatform | Preferences/Proto対応 |
| コレクション | kotlinx.collections.immutable | 不変コレクション |
| 画像 | Coil 3 Multiplatform | KMP対応画像読み込み |

### §36. Swift Export（GA）

- **Swift Export**: Kotlin 2.2.20でデフォルト有効化（Experimental）。Objective-Cエクスポートに代わる標準相互運用
- **Swift型マッピング**: Kotlinの型がSwiftネイティブ型に直接マッピング
- **Nullability保持**: KotlinのNull安全性がSwiftの`Optional`に正確に変換
- **利点**: Swiftらしいインターフェースを自然に生成。Obj-Cブリッジの制約を解消

### §37. KMP段階的導入戦略

1. **Phase 1**: データモデル・DTOを共有化（リスク最小）
2. **Phase 2**: ネットワーク層・リポジトリを共有化
3. **Phase 3**: ドメインロジック・UseCaseを共有化
4. **Phase 4**: UIをCompose Multiplatformで共有化（任意）
- **チーム教育**: KMPワークショップを導入前に必ず実施
- **段階的移行**: 新機能からKMP化。既存コードの一括移行は禁止

### §38. KMPテスト戦略

- **`commonTest`**: 共有ロジックのテストは`commonTest`に配置
- **`androidTest` / `iosTest`**: プラットフォーム固有テストは各ソースセットに配置
- **テストランナー**: JUnit5（Android）、XCTest経由（iOS）
- **モック**: `commonMain`ではインターフェースベースでテスタブルに設計

### §39. KMPビルド最適化

- **Gradle設定**: `kotlin.mpp.stability.nowarn=true`で安定性警告を抑制
- **インクリメンタルコンパイル**: K2マルチプラットフォームインクリメンタルコンパイルを活用
- **キャッシュ**: Gradle Build Cacheを有効化。CI環境でもリモートキャッシュを設定
- **バイナリ互換性**: `@OptIn(ExperimentalKotlinApi::class)`の使用箇所を最小限に

### §40. KMP共通依存管理

- **安定版クロスコンパイル（Kotlin 2.2.20）**: ライブラリの安定版クロスプラットフォームコンパイル
- **共通依存アプローチ**: 新しい共通依存管理方式でソースセット間の依存解決を簡素化
- **BOM統合**: KMPプロジェクトでのBOM管理パターン

---

## Part VII: Compose Multiplatform

### §41. Compose Multiplatform iOS（安定版）

- **iOS安定版**: 2025年に安定版到達。VoiceOverサポート、ネイティブライクスクロール、SwiftUI相互運用
- **SwiftUI Interop**: Compose画面内にSwiftUIビューを埋め込み可能。逆も対応
- **ネイティブ体感**: iOSのヒューリスティクス（バウンスエフェクト、スクロール物理等）をデフォルトエミュレーション
- **フォント統合**: iOS System Fontを自動使用。カスタムフォントのバンドルも対応

### §42. Compose Multiplatform設計原則

- **共有可能な範囲**: UI + ビジネスロジック + ナビゲーション + テーマ
- **プラットフォーム固有UI**: OS固有のUXパターン（Bottom Sheet作法等）は`expect`/`actual`で分岐
- **テーマ戦略**: Material 3ベースの共通テーマ + プラットフォーム微調整
- **ナビゲーション**: Compose Navigation Multiplatformを使用

### §43. Compose Multiplatform Web/Desktop

- **Compose for Web**: Wasm対象でBeta。プロダクション利用は慎重に評価
- **Compose for Desktop**: JVM対象で安定。社内ツール・管理画面に推奨
- **ターゲット別最適化**: Web/Desktop固有のインタラクションパターン（マウスホバー、キーボードナビゲーション）を考慮

### §44. Compose Multiplatform移行ガイド

- **新規プロジェクト**: Compose Multiplatformをデフォルト採用検討
- **既存Android Compose**: `commonMain`への段階的移行が容易
- **iOS既存アプリ**: SwiftUI Interopを通じた段階的導入。全画面書き換え不要

---

## Part VIII: Jetpack Compose パフォーマンス

### §45. Pausable Composition（GA）

- **Compose 1.10+**: Pausable Compositionがデフォルト有効
- **機能**: 重いUI構築をフレームをまたいで分割実行。ジャンクを防止
- **Lazy Prefetch連携**: LazyColumn/LazyRow のプリフェッチでPausable Compositionが自動適用
- **パフォーマンスパリティ**: GoogleのベンチマークでComposeがViews同等のスクロールパフォーマンスを達成

### §46. Strong Skipping Mode（デフォルト）

- **安定版**: Compose Compiler 1.7+ / Compose 1.10+でデフォルト有効
- **効果**: unstableなパラメータを持つComposableもスキップ可能に
- **ラムダメモ化**: Composable内のラムダが自動的にメモ化。手動`remember { }`不要
- **APKサイズ**: 微増（許容範囲）と引き換えに、不要な再Compositionを大幅削減

### §47. 再Composition最適化

- **`remember`**: 高コスト計算のキャッシュ
- **`derivedStateOf`**: 高頻度変更Stateの再Composition制限
- **安定した`key`**: LazyLayout（`LazyColumn`等）で`key`パラメータ必須
- **State読み取り遅延**: レンダリングに必要になるまでState読み取りを遅延（ラムダ活用）
- **Backwards Write禁止**: 同一Composable内で既読Stateへの書き込み禁止

```kotlin
// ✅ Good: 状態読み取りの遅延
@Composable
fun AnimatedHeader(scrollProvider: () -> Int) {
    val alpha = (scrollProvider() / 300f).coerceIn(0f, 1f)
    Header(modifier = Modifier.alpha(alpha))
}

// ❌ Bad: 直接的なState読み取り
@Composable
fun AnimatedHeader(scroll: Int) {
    val alpha = (scroll / 300f).coerceIn(0f, 1f)
    Header(modifier = Modifier.alpha(alpha))
}
```

### §48. Compose 1.10 新API

- **`retain` API**: Configuration Change（画面回転等）をまたいで値を永続化。シリアライズ不要でラムダ、Flow、Bitmapを保持
- **`SecureTextField`/`OutlinedSecureTextField`**: パスワード入力用セキュアテキストフィールド
- **`autoSize` Text**: テキストのコンテナ自動サイズ調整
- **Advanced Shadows**: 高度な影エフェクトAPI
- **2D Scrolling API**: 2次元スクロール対応

### §49. Baseline Profiles

- **必須**: アプリ固有のBaseline Profilesを生成。デフォルトのCompose Profileだけでは不十分
- **生成方法**: Macrobenchmarkテストで重要ユーザーフローをカバー
- **効果**: AOTコンパイルで起動時のコード実行速度を約30%改善
- **CI統合**: Baseline Profiles生成をCIパイプラインに統合

```kotlin
// Baseline Profile生成 — Macrobenchmark
@RunWith(AndroidJUnit4::class)
class BaselineProfileGenerator {
    @get:Rule
    val rule = BaselineProfileRule()

    @Test
    fun generateProfile() {
        rule.collect("com.example.app") {
            startActivityAndWait()
            device.findObject(By.text("Search")).click()
            device.waitForIdle()
        }
    }
}
```

### §50. Compose開発ツール

- **Layout Inspector**: 再Compositionの可視化・デバッグ
- **Compose Metrics**: コンパイラメトリクス出力でスキップ率を確認
- **Live Edit 2.0**: ステートフルComposableのリアルタイム更新
- **リリースモードテスト**: パフォーマンステストは必ずR8有効のリリースビルドで実行
- **Profiler**: CPU, Memory, Frame Rate をAndroid Studioプロファイラーで定期監視

---

## Part IX: SwiftUI ベストプラクティス

### §51. Observation Framework

- **`@Observable`マクロ（推奨）**: iOS 17+で`ObservableObject`+`@Published`を置き換え
- **細粒度トラッキング**: 変更されたプロパティに依存するビュー部分のみ再描画
- **`@State` / `@Environment` / `@Bindable`**: `@Observable`との組み合わせで簡潔なコード
- **`Observations` async sequences（Swift 6.2）**: Observable型のトランザクショナルな状態変更をストリーミング
- **UIKit統合（iOS 26+）**: UIKitがSwift Observationを自動統合

```swift
// ✅ Good: @Observable (iOS 17+)
@Observable
final class CartViewModel {
    var items: [CartItem] = []
    var total: Decimal { items.reduce(0) { $0 + $1.price } }

    func addItem(_ item: CartItem) {
        items.append(item)
    }
}

struct CartView: View {
    @State private var viewModel = CartViewModel()

    var body: some View {
        VStack {
            List(viewModel.items) { item in ItemRow(item: item) }
            Text("合計: ¥\(viewModel.total)")
        }
    }
}
```

### §52. SwiftUIパフォーマンス

- **ビュー分割**: 複雑なビューを小さな再利用可能コンポーネントに分割
- **Lazy Container**: `LazyVStack`/`LazyHStack`/`LazyVGrid`で大量データを効率表示
- **安定ID**: `List`/`ForEach`で安定した一意の識別子を提供
- **State最小化**: `@State`変数は焦点を絞り小さく保つ
- **重処理回避**: `body`プロパティ内でネットワーク/フィルタリング/画像処理を実行禁止
- **SwiftUI Performance Instrument（WWDC 2025）**: ビューbodyレンダリングと状態管理効率の最適化ツール
- **リストパフォーマンス向上（iOS 26）**: 大規模リストの読み込み最大6倍・更新最大16倍高速化

### §53. ナビゲーション設計

- **`NavigationStack`**: 型安全なプログラマティクナビゲーション
- **`navigationDestination`**: 型ベースのルーティング
- **Sheet/Modal**: サイズ・dismiss挙動・トランジションのカスタマイズAPI
- **Deep Link対応**: URL→NavigationPath変換のハンドラ実装

### §54. SwiftUI + UIKit共存

- **`UIViewRepresentable`**: UIKitビューのSwiftUIラッパー
- **`UIViewControllerRepresentable`**: UIKitViewControllerの統合
- **`UIHostingController`**: SwiftUIビューをUIKit内に配置
- **段階的移行**: 新規画面SwiftUI、既存画面UIKit維持。共存は長期的に許容

### §55. アニメーション・インタラクション

- **宣言的アニメーション**: `withAnimation`/`.animation`修飾子でフルーイドなトランジション
- **PhaseAnimator**: 多段階アニメーションの簡素化
- **Keyframe Animation**: キーフレーム駆動のカスタムアニメーション
- **Matched Geometry Effect**: 画面遷移時の要素連続アニメーション
- **Spring Animation**: 物理ベースのスプリングアニメーションをデフォルト推奨
- **ハプティックフィードバック**: `UIImpactFeedbackGenerator` / `SensoryFeedback`の適切な使用

### §56. Liquid Glass対応（iOS 26+）

- **自動適用**: Xcode 26で再コンパイルすることで既存SwiftUIアプリに自動適用
- **カスタマイズAPI**: ナビゲーションスタック、タブ、ツールバーのLiquid Glassスタイル制御
- **Material Variants**: `.ultraThin`、`.mega`等の新しいブラースタイル
- **後方互換**: iOS 16-25対象では従来のデザインが維持される

---

## Part X: 並行処理・非同期

### §57. Kotlin Coroutines ベストプラクティス

- **構造化並行処理**: `viewModelScope`/`lifecycleScope`でCoroutineのライフサイクルを管理
- **Dispatchers**: `Main`（UI）、`IO`（I/O）、`Default`（CPU）を適切に使い分け
- **Flow**: リアクティブストリームにはFlowを使用。`StateFlow`（状態保持）、`SharedFlow`（イベント）
- **例外ハンドリング**: `CoroutineExceptionHandler`でグローバル例外を捕捉
- **キャンセル対応**: `isActive`チェックまたは`ensureActive()`で協調的キャンセル

```kotlin
// ✅ Good: 構造化 Coroutines
class SearchViewModel @Inject constructor(
    private val searchRepository: SearchRepository,
) : ViewModel() {
    private val _query = MutableStateFlow("")

    val results: StateFlow<List<Item>> = _query
        .debounce(300)
        .distinctUntilChanged()
        .flatMapLatest { query ->
            if (query.isBlank()) flowOf(emptyList())
            else searchRepository.search(query)
        }
        .stateIn(viewModelScope, SharingStarted.Lazily, emptyList())
}
```

### §58. Swift Concurrency ベストプラクティス

- **`async/await`**: コールバックを完全排除。Structured Concurrencyを徹底
- **`TaskGroup`**: 複数タスクの並列実行と結果集約
- **Actor**: 共有可変状態のスレッドセーフアクセス。過度なisolationを避ける
- **タスクキャンセル**: `Task.checkCancellation()`で協調的キャンセル
- **優先度**: `Task.Priority`でクリティカルな処理（UI更新等）を優先

```swift
// ✅ Good: async let for parallel fetch
func loadDashboard() async throws -> Dashboard {
    async let profile = fetchProfile()
    async let orders = fetchOrders()
    async let recommendations = fetchRecommendations()

    return try await Dashboard(
        profile: profile,
        orders: orders,
        recommendations: recommendations
    )
}
```

### §59. バックグラウンド処理 — Android

- **WorkManager**: 信頼性の高いバックグラウンドタスク（同期、アップロード等）
- **制約設定**: ネットワーク状態、充電状態、ストレージ容量をWorkRequestに指定
- **Foreground Service Type**: Android 14+のタイプ宣言必須（`dataSync`, `mediaPlayback`等）
- **Doze Mode対応**: `setExact`の制限を理解し、AlarmManagerの使用を最小化

### §60. バックグラウンド処理 — iOS

- **BGTaskScheduler**: `BGAppRefreshTask`/`BGProcessingTask`でバックグラウンド更新
- **URLSession Background**: 大容量ダウンロード/アップロードはバックグラウンドセッション
- **Push Notification Trigger**: Silent Pushでバックグラウンド処理をトリガー
- **バッテリー配慮**: バックグラウンド実行時間を最小化。システムの判断を尊重

### §61. リアルタイム通信

- **WebSocket**: 双方向リアルタイム通信。`URLSessionWebSocketTask`（iOS）/ OkHttp WebSocket（Android）
- **Server-Sent Events (SSE)**: サーバー→クライアントのストリーミング
- **Reconnection戦略**: Exponential Backoff + Jitterで再接続
- **接続状態管理**: ネットワーク状態に応じたグレースフルデグラデーション

### §62. 並行処理アンチパターン

- **❌ メインスレッドI/O**: I/O操作は必ずバックグラウンドスレッド
- **❌ GlobalScope**: `GlobalScope.launch`禁止。構造化されたスコープを使用
- **❌ Thread.sleep**: Coroutineでは`delay()`を使用
- **❌ Callback地獄**: async/awaitで解消
- **❌ race condition無視**: Actor/Mutexで共有状態を保護
- **❌ 未処理のTask**: `Task { }`の戻り値を適切に管理。キャンセル漏れ防止

### §63. DispatchQueue移行ガイド（iOS）

- **GCD→Swift Concurrency**: `DispatchQueue.main.async`を`@MainActor`に移行
- **`DispatchQueue.global()`→`Task.detached`**: バックグラウンド処理の移行
- **DispatchGroup→TaskGroup**: 複数非同期タスクの待ち合わせ
- **段階的移行**: 新規コードはSwift Concurrency必須。既存GCDは計画的に移行

---

## Part XI: パフォーマンス最適化

### §64. 起動時間最適化

- **Cold Start目標**: 500ms以内（メインコンテンツ表示まで）
- **Android対策**: Content Providerの遅延初期化、App Startupライブラリ活用、Baseline Profiles
- **iOS対策**: `pre-main`時間の最小化、dylib最小化、Static Linkingの活用
- **測定**: Firebase App Start Trace / MetricKit `MXAppLaunchMetric`で継続的監視
- **Splash Screen**: Android 12+ `SplashScreen` API / iOS Launch Storyboardで統一

### §65. メモリ管理

- **Android**: LeakCanary（デバッグ）+ StrictMode。Bitmap再利用（`BitmapPool`）
- **iOS**: Instruments Allocations/Leaks。Autoreleasepool適切な使用
- **画像管理**: Coil（Android）/ Kingfisher（iOS）でメモリキャッシュ管理
- **Large Heap回避**: `android:largeHeap="true"` は最終手段。根本的なメモリ最適化を優先
- **閾値**: バックグラウンド時メモリ使用量 < 50MBを目標

### §66. レンダリングパフォーマンス

- **目標フレームレート**: 60fps / 120fps（ProMotion/高リフレッシュレート対応）
- **Adaptive Refresh Rate（Android 16）**: `getSuggestedFrameRate`で可変リフレッシュレートを最適利用
- **ジャンク検出**: JankStats API（Android）/ MetricKit `MXAnimationMetric`（iOS）
- **過剰描画削減**: GPU Overdrawデバッグ。不要なbackground/clip操作の排除
- **オフスクリーンレンダリング回避**: `cornerRadius`+`shadow`の組み合わせに注意（iOS）

### §67. ネットワーク最適化

- **HTTP/3 (QUIC)**: OkHttp 5+ / `URLSession`でHTTP/3を優先使用
- **画像最適化**: WebP/AVIF形式。画面解像度に合わせたリサイズ配信
- **gRPC**: 高頻度API呼び出しにはgRPCを検討。Protocol Buffersでペイロード削減
- **キャッシュ戦略**: `Cache-Control`ヘッダー遵守。ETag/Last-Modifiedで条件付きリクエスト
- **接続プーリング**: Keep-Aliveで接続再利用。DNS-over-HTTPSでDNS解決を高速化

### §68. バッテリー最適化

- **Doze Mode（Android）**: ネットワーク/Alarmの制約を理解し設計
- **Adaptive Power（iOS 26）**: 高使用期間のバッテリー最適化（iPhone 15 Pro+）
- **Low Power Mode（iOS）**: `ProcessInfo.processInfo.isLowPowerModeEnabled`で動作を調整
- **位置情報**: 必要な精度のみ要求。`significantLocationChange`を優先
- **バックグラウンド制限**: JobScheduler/BGTaskSchedulerの制約内で設計
- **Energy Impact低減**: Instruments Energy Log / Battery Historianで定期監視

### §69. アプリサイズ最適化

- **Android App Bundle (AAB)**: デバイス固有APK配信。ダウンロードサイズ最小化
- **App Thinning (iOS)**: Slicing / On-Demand Resources
- **目標**: 初回ダウンロード < 30MB。大容量アセットはオンデマンド取得
- **R8/ProGuard**: 不要コード・リソースの自動削除
- **Asset圧縮**: 画像はWebP、動画はHEVC、フォントはwoff2サブセット
- **監視**: PR毎にアプリサイズ差分レポートをCIで出力

### §70. ハードウェアリソース監視

- **`getCpuHeadroom`/`getGpuHeadroom`（Android 16）**: ハードウェア可用性のリアルタイム監視
- **Activity/場面に応じた品質調整**: リソース逼迫時の描画品質・AI推論精度のダイナミック制御
- **Thermal State API**: デバイスの熱状態に応じた処理負荷軽減
- **用途**: ゲーム、カメラ、AR/VR、オンデバイスAI推論での活用

---

## Part XII: オンデバイスAI・エッジML

### §71. オンデバイスAI戦略

- **プライバシーファースト**: ユーザーデータをデバイス外に送信せずにAI処理
- **オフライン動作**: ネットワーク不要でAI機能が完全動作
- **レイテンシ**: エッジ推論で10ms以下の応答を目標
- **モデルサイズ**: 初回同梱 < 20MB。大型モデルはOTA配信
- **ハードウェア活用**: Neural Engine（Apple）/ NPU（Android）を最大活用

### §72. Android — ML Kit & TensorFlow Lite

- **ML Kit**: テキスト認識、顔検出、バーコード、翻訳等のプリビルトAPI
- **TensorFlow Lite**: カスタムモデルの高性能推論。GPU/NNAPIデリゲート活用
- **MediaPipe**: マルチモーダルAIパイプライン。リアルタイム姿勢推定・手検出
- **Gemini Nano**: オンデバイスLLM。Android AICore API経由でアクセス
- **モデルフォーマット**: `.tflite`（量子化済み）を標準使用

```kotlin
// ML Kit テキスト認識
val recognizer = TextRecognition.getClient(TextRecognizerOptions.DEFAULT_OPTIONS)
recognizer.process(inputImage)
    .addOnSuccessListener { text ->
        text.textBlocks.forEach { block ->
            // テキストブロックの処理
        }
    }
```

### §73. iOS — Core ML & Apple Foundation Models

- **Core ML**: Neural Engine最適化。`.mlmodel`→`.mlmodelc`のコンパイル済みモデル使用
- **Create ML**: カスタムモデルのトレーニング。Transfer Learningでデータ効率を向上
- **Vision Framework**: 画像分類、物体検出、テキスト認識のハイレベルAPI
- **Natural Language**: テキスト分類、感情分析、言語検出

### §74. Apple Foundation Models Framework（iOS 26+）

- **オンデバイスLLM**: 約3Bパラメータのモデルにアクセス。完全オフライン動作
- **対応タスク**: テキスト生成、要約、エンティティ抽出、テキスト理解、リファインメント、対話
- **プライバシー保証**: データはデバイス外に送信されない
- **Apple Silicon最適化**: Neural Engine活用で高効率推論
- **ガードレール**: 出力の安全性フィルタリング・コンテンツ制御を内蔵
- **フォールバック**: デバイス非対応時はクラウドAPI（Private Cloud Compute経由）にフォールバック

```swift
// Apple Foundation Models — テキスト生成
import FoundationModels

let session = LanguageModelSession()
let response = try await session.respond(
    to: "ユーザーの質問を要約してください: \(userQuery)"
)
print(response.content)
```

### §75. Gemini Nano 詳細

- **AICore API**: Android AICore経由でオンデバイスGemini Nanoにアクセス
- **対応タスク**: Summarization, Smart Reply, 文章補完
- **デバイス要件**: Pixel 8 Pro以降、一部Samsung Galaxy対応
- **ガードレール**: オンデバイスLLMにも出力フィルタリング・安全性チェックを適用
- **フォールバック**: 非対応デバイスではクラウドGemini APIにフォールバック

### §76. モデル管理とガバナンス

- **バージョニング**: モデルにセマンティックバージョンを付与。A/Bテスト対応
- **OTA配信**: Firebase ML Model Download / CloudKit でモデルを動的更新
- **フォールバック**: OTA失敗時にバンドル済みモデルにフォールバック
- **パフォーマンス監視**: 推論時間・精度・メモリ使用量をテレメトリで追跡
- **モデル署名**: 改竄防止のためモデルファイルにデジタル署名

### §77. エッジAIパフォーマンス基準

| 指標 | 目標値 | 測定方法 |
|------|-------|---------| 
| 推論レイテンシ | < 50ms（CPU）/ < 10ms（NPU） | Systrace / Instruments |
| モデルサイズ | < 20MB（初回同梱） | ビルド時サイズチェック |
| メモリ使用量 | < 100MB追加 | Memory Profiler |
| バッテリー影響 | < 5%/時間 | Battery Historian / Energy Log |
| 精度低下 | サーバーモデル比 < 5%劣化 | 評価パイプライン |

### §78. マルチモーダルAI

- **カメラ連携**: リアルタイム画像認識 + テキスト生成の組み合わせ
- **音声**: オンデバイス音声認識 + LLMによる意図理解
- **センサー融合**: 加速度・ジャイロ + AIによるコンテキスト推定
- **ユースケース**: Visual Intelligence（iOS）、Circle to Search（Android）

---

## Part XIII: オフラインファースト・データ永続化

### §79. オフラインファースト設計原則

- **SSOT**: ローカルDB（Room / SwiftData）が唯一の真実。サーバーはレプリカ
- **楽観的更新**: UI即反映→バックグラウンド同期。コンフリクト解決戦略を事前定義
- **Network State Awareness**: `ConnectivityManager`（Android）/ `NWPathMonitor`（iOS）でネットワーク状態を監視
- **データ一貫性**: CRDT / Last-Write-Winsによるコンフリクト解決
- **キューイング**: オフライン操作をキューに蓄積、ネットワーク復帰時に順次実行

### §80. Android データ永続化 — Room

- **Room**: SQLiteの型安全ORM。KSP対応必須
- **`@Entity`/`@Dao`/`@Database`**: 標準的なRoom構成
- **Migration**: `AutoMigration`を優先。破壊的変更時は手動Migration
- **Flow統合**: `@Query`の戻り値を`Flow<List<T>>`にしリアクティブUI更新
- **Paging 3**: 大量データのページング。`PagingSource` + `RemoteMediator`

```kotlin
// Room + Flow + Paging
@Dao
interface OrderDao {
    @Query("SELECT * FROM orders ORDER BY created_at DESC")
    fun getOrdersFlow(): Flow<List<OrderEntity>>

    @Query("SELECT * FROM orders ORDER BY created_at DESC")
    fun getOrdersPagingSource(): PagingSource<Int, OrderEntity>

    @Upsert
    suspend fun upsertOrders(orders: List<OrderEntity>)
}
```

### §81. Android DataStore

- **Preferences DataStore**: SharedPreferencesの後継。Coroutinesベースの非同期API
- **Proto DataStore**: Protocol Buffersでスキーマベースの型安全ストレージ
- **EncryptedSharedPreferences禁止**: 機密データにはAndroid Keystoreを直接使用
- **移行**: SharedPreferences→DataStoreへの段階的移行をサポート

### §82. iOS データ永続化 — SwiftData

- **SwiftData**: Core Dataの後継。`@Model`マクロで宣言的データ定義
- **`@Query`**: SwiftUIビューでのリアクティブフェッチ。Observation Frameworkと統合
- **ModelContainer**: 永続化バックエンドの構成管理
- **スキーマ移行**: LightweightMigration推奨。カスタム移行はバージョン管理を厳密に
- **CloudKit統合**: `NSPersistentCloudKitContainer`でiCloudバックアップ/同期
- **Class Inheritance（iOS 26+）**: 明確な「is-a」階層にのみ使用
- **`@Index`/`@Unique`（iOS 26+）**: パフォーマンス最適化とデータ整合性保証

### §83. iOS Keychain & UserDefaults

- **Keychain**: 認証トークン、暗号鍵、機密データの保存に必須使用
- **`kSecAttrAccessibleWhenUnlockedThisDeviceOnly`**: デバイスロック連動のアクセス制御
- **UserDefaults**: 非機密の設定値のみ。Privacy Manifestでの使用理由宣言が必要
- **App Group**: HostアプリとExtension間のデータ共有

### §84. バックグラウンド同期

- **Delta Sync**: 差分同期で帯域幅を最小化。`updated_at`タイムスタンプベース
- **WorkManager（Android）**: 信頼性の高いバックグラウンド同期。ネットワーク制約対応
- **BGTaskScheduler（iOS）**: `BGProcessingTask`で大量データ同期
- **コンフリクト戦略**: Last-Write-Wins / Server-Wins / マニュアル解決の3パターンを準備
- **ページネーション同期**: 大量データはカーソルベース同期で段階的に取得

### §85. クロスプラットフォームデータ同期

- **KMP DataStore**: マルチプラットフォーム対応の設定データ永続化
- **Ktor + Room/SwiftData**: KMPネットワーク層 + プラットフォーム固有DB
- **同期プロトコル**: REST / GraphQL / gRPC の同期パターン設計
- **エラーリカバリ**: 同期失敗時のリトライ・部分同期・ロールバック戦略

---

## Part XIV: セキュリティ・アプリ堅牢化

### §86. シークレット管理 — No Secrets in Binary

- **絶対禁止**: API Key、OAuthシークレット、暗号鍵のソースコードへのハードコード
- **Android Keystore**: ハードウェアバックドのセキュアストレージ
- **iOS Keychain**: Secure Enclaveとの統合
- **CI Secrets**: ビルド時にCI/CD環境変数からSecretを注入
- **検出**: gitleaks / truffleHog をプリコミットフックで実行

### §87. 暗号化とデータ保護

- **保存時暗号化**: Android `EncryptedFile` / iOS `FileProtection.complete`
- **通信暗号化**: TLS 1.3必須。TLS 1.2は後方互換のみ許可
- **ハッシュ**: SHA-256以上。MD5/SHA-1は禁止
- **鍵管理**: ハードウェアバックド鍵生成（Keystore / Secure Enclave）
- **暗号アジリティ**: 量子耐性暗号（ML-KEM, ML-DSA）への移行計画を策定

### §88. 認証と生体認証

- **Passkeys (FIDO2/WebAuthn)**: パスワードレス認証の第一推奨。フィッシング耐性あり
- **BiometricPrompt（Android）**: `BIOMETRIC_STRONG`でClass 3生体認証
- **LAContext（iOS）**: Face ID / Touch ID。`evaluatePolicy`で認証
- **フォールバック**: 生体認証非対応デバイスではPIN/パスコードにフォールバック
- **セッション管理**: JWTの有効期限管理。リフレッシュトークンのセキュアな保存

```kotlin
// Android BiometricPrompt
val biometricPrompt = BiometricPrompt(
    fragmentActivity,
    ContextCompat.getMainExecutor(context),
    object : BiometricPrompt.AuthenticationCallback() {
        override fun onAuthenticationSucceeded(result: AuthenticationResult) {
            // 認証成功 → Keystoreに保存した秘密鍵でデータを復号
        }
    }
)
val promptInfo = BiometricPrompt.PromptInfo.Builder()
    .setTitle("本人確認")
    .setAllowedAuthenticators(BiometricManager.Authenticators.BIOMETRIC_STRONG)
    .setNegativeBtnText("キャンセル")
    .build()
```

### §89. アプリ堅牢化 (App Hardening / RASP)

- **Play Integrity API（Android）**: アプリ真正性・デバイス整合性・アカウント整合性を検証
- **App Attest（iOS）**: Secure Enclaveベースの暗号プルーフでリクエスト真正性を保証
- **Root/Jailbreak検出**: 改ざんデバイスでの動作を制限またはブロック
- **RASP**: ランタイム自己保護。改竄検知、リバースエンジニアリング防御、フッキング検出
- **コード難読化**: ProGuard/R8（Android）。iOS SwiftはABI安定性により限定的
- **デバッガ検出**: `ptrace`検知（iOS）、`Debug.isDebuggerConnected()`（Android）

### §90. ネットワークセキュリティ

- **Certificate Transparency（推奨）**: Certificate Pinningに代わる新標準。証明書ローテーション時のアプリ更新不要
- **Certificate Pinning（従来方式）**: 公開鍵ピニング。バックアップピンを必ず設定
- **Network Security Config（Android）**: `res/xml/network_security_config.xml`でクリアテキスト禁止
- **ATS (App Transport Security / iOS)**: デフォルト有効。例外は最小限に
- **Man-in-the-Middle防御**: TLS 1.3 + Certificate Transparency/Pinningの多層防御

```xml
<!-- Android Network Security Config -->
<network-security-config>
    <base-config cleartextTrafficPermitted="false">
        <trust-anchors>
            <certificates src="system" />
        </trust-anchors>
    </base-config>
    <domain-config>
        <domain includeSubdomains="true">api.example.com</domain>
        <pin-set expiration="2026-12-31">
            <pin digest="SHA-256">XXXXXXXXXXX=</pin>
            <pin digest="SHA-256">YYYYYYYYYYY=</pin>
        </pin-set>
    </domain-config>
</network-security-config>
```

### §91. セキュアコーディング

- **入力検証**: 全ユーザー入力をサニタイズ・バリデーション
- **SQLインジェクション防止**: Room/SwiftData のパラメータバインディング必須
- **WebView Security**: JavaScript無制限有効化禁止。`addJavascriptInterface`は最小権限
- **Intent Spoofing防止**: exported Activity/BroadcastReceiverの権限設定を厳格化
- **URL Scheme Hijacking**: Universal Links / App Links でURL Schemeの乗っ取りを防止
- **クリップボード保護**: `ClipDescription.EXTRA_IS_SENSITIVE`フラグでパスワード等のコピーを保護

### §92. Privacy Sandbox統合（Android 16）

- **SDK Runtime**: SDKが分離環境で動作。データ保護強化
- **Topics API**: プライバシー保護型広告ターゲティング
- **Attribution Reporting**: プライバシー保護型コンバージョン計測
- **Protected Audiences**: オンデバイスオークションによるリマーケティング

### §93. セキュリティテスト基準

- **SAST**: ktlint security rules / SwiftLint security rules をCI統合
- **DAST**: OWASP ZAP / Burp SuiteでAPI・通信のセキュリティテスト
- **SBOM**: CycloneDX形式でサードパーティ依存のインベントリを生成
- **脆弱性SLA**: Critical — 24時間以内修正、High — 7日以内、Medium — 30日以内
- **OWASP MASVS**: モバイルアプリセキュリティ検証基準への準拠確認

### §94. セキュリティ監視・インシデント対応

- **Crashlyticsセキュリティイベント**: セキュリティ関連クラッシュの自動分類
- **Anomaly Detection**: 異常な認証パターン・API呼び出しパターンをサーバー側で検知
- **Remote Kill Switch**: 重大脆弱性発見時のリモート機能無効化メカニズム
- **インシデント対応**: セキュリティインシデント発生時の緊急リリースフロー定義

---

## Part XV: プラットフォーム統合・OS機能

### §95. プッシュ通知

- **FCM（Android）**: Firebase Cloud Messaging。トピック購読/条件配信
- **APNs（iOS）**: Apple Push Notification service。VoIP Push / Live Activities Push
- **通知チャネル（Android）**: `NotificationChannel`でカテゴリ分類必須
- **Notification Cooldown（Android 16）**: バースト通知の音量段階的低減
- **権限要求**: Pre-Permission Pattern。価値説明 → 許可要求の2段階アプローチ
- **Rich Notification**: 画像/アクションボタン/カスタムUI付き通知

### §96. ディープリンク・ユニバーサルリンク

- **App Links（Android）**: `assetlinks.json`でドメイン所有権を検証。Intent Filter設定
- **Universal Links（iOS）**: `apple-app-site-association`でドメイン検証
- **Deferred Deep Links**: 未インストールユーザーへの遅延ディープリンク
- **ナビゲーション統合**: ディープリンク→NavigationStack/NavGraph変換のルーティング

### §97. ウィジェット・ライブアクティビティ

- **Glance（Android）**: Jetpack Glanceで宣言的ウィジェット。Compose構文
- **WidgetKit（iOS）**: SwiftUIベースウィジェット。TimelineProvider
- **Live Activities（iOS）**: リアルタイム情報表示。Dynamic Island対応
- **更新頻度**: システムバジェット内で更新。過剰更新はOS制限の対象

### §98. App Clips / Instant Apps

- **App Clips（iOS）**: < 15MB。NFC/QRコード/Safari Smart Banner発動
- **Instant Apps（Android）**: Google Playインスタント形式
- **設計原則**: 単一タスク完結型。フル版アプリへの導線を設計

### §99. Web-Native Bridge

- **WebView**: `WKWebView`（iOS）/ AndroidX WebView使用。JavaScriptインターフェースは最小権限
- **SwiftUI WebView（iOS 26）**: SwiftUIネイティブWebViewコンポーネント
- **JavaScript Bridge**: メッセージパッシングによるセキュアな通信
- **Cookie同期**: ネイティブセッションとWebViewセッションの整合性

### §100. カメラ・センサー・ハードウェア

- **CameraX（Android）**: Camera2 APIのハイレベルラッパー。ライフサイクル対応
- **AVFoundation（iOS）**: カメラ/マイク/ビデオ処理
- **Android 16 Camera API強化**: 色温度/ティント調整、ハイブリッドAE、ナイトモード検出
- **センサーAPI**: 加速度、ジャイロ、気圧。`SensorManager`/`CMMotionManager`
- **Bluetooth LE**: `CompanionDeviceManager`（Android）/ `CBCentralManager`（iOS）
- **NFC**: `NfcAdapter`（Android）/ `NFCTagReaderSession`（iOS）
- **権限管理**: カメラ/マイク/位置情報の権限要求は使用直前に実施

### §101. Health Connect / HealthKit

- **Health Connect（Android）**: 統一的な健康データプラットフォーム
- **Health Records API（Android 16）**: FHIR標準の医療データアクセス
- **HealthKit（iOS）**: 包括的な健康データフレームワーク
- **最小権限**: 必要なデータ種別のみ要求。プライバシー説明を明確に
- **データ暗号化**: 健康データは常に暗号化して保存

---

## Part XVI: Flutter/クロスプラットフォーム連携

### §102. Platform Channel — Pigeon必須

- **Pigeon**: 型安全なPlatform Channel生成。手動MethodChannel禁止
- **コード生成**: `.dart` + `.kt` / `.swift` の型安全バインディング自動生成
- **エラー型統一**: Pigeon生成コードでエラー型を両プラットフォームで統一

```dart
// Pigeon定義 — messages.dart
@HostApi()
abstract class NativeAuthApi {
  @async
  String getBiometricToken();

  @async
  bool isBiometricAvailable();
}
```

### §103. スレッディングルール

- **プラットフォームI/O**: MethodChannel (Android) はメインスレッドで受信。重い処理は`withContext(Dispatchers.IO)`
- **iOS**: MainActorで受信。重い処理はTask.detachedで実行
- **Isolate統合**: Dart Isolate ↔ Platform Channelの安全な通信パターン

### §104. エラーハンドリング標準

- **エラーコード統一**: プラットフォーム固有エラーをアプリ共通エラーコードにマッピング
- **PlatformException**: Flutter側で適切にcatch・変換
- **フォールバック**: ネイティブAPI不可時のDart純粋実装フォールバック

### §105. KMP + Flutter ハイブリッド

- **KMPビジネスロジック + Flutter UI**: ビジネスロジックをKMPで共有、UIをFlutterで実装
- **Pigeon経由**: KMP生成物をPigeon経由でFlutterに公開
- **責任分界**: KMP = ドメイン/データ層、Flutter = プレゼンテーション層

### §106. React Native連携

- **Turbo Modules**: ネイティブモジュールの新標準API。Bridge廃止への移行
- **Fabric**: 新レンダリングエンジンとの統合
- **制約**: RN使用時もネイティブ固有API部分はKotlin/Swiftで実装

---

## Part XVII: テスト戦略

### §107. ユニットテスト

- **Kotlin**: JUnit 5 + MockK。Coroutinesテストは`kotlinx-coroutines-test`のTurbine
- **Swift**: Swift Testing framework（`@Test`マクロ）。XCTestからの移行推奨
- **カバレッジ**: ビジネスロジック80%+、ユーティリティ100%。UIは分離テスト

```kotlin
// Kotlin ViewModel Test
@Test
fun `loadOrders should emit Success state`() = runTest {
    val mockRepo = mockk<OrderRepository> {
        coEvery { getOrders() } returns Result.success(testOrders)
    }
    val viewModel = OrderViewModel(mockRepo)
    viewModel.onEvent(OrderEvent.Load)

    viewModel.state.test {
        assertThat(awaitItem()).isInstanceOf(OrderUiState.Loading::class)
        assertThat(awaitItem()).isEqualTo(OrderUiState.Success(testOrders))
    }
}
```

```swift
// Swift Testing
@Test func fetchUserReturnsProfile() async throws {
    let mockRepo = MockUserRepository(result: .success(testUser))
    let viewModel = ProfileViewModel(repository: mockRepo)
    await viewModel.loadProfile()
    #expect(viewModel.profile == testUser)
}
```

### §108. Swift Testing 深化

- **`@Suite`**: テストスイートのグルーピング
- **`@Test(arguments:)`**: パラメタライズドテストで複数入力を効率検証
- **Tags**: テストへのタグ付けでCI実行時のフィルタリング
- **Parallel Execution**: テストの自動並列実行
- **XCTestからの移行**: `#expect`/`#require`マクロへの段階的移行

### §109. UIテスト

- **Compose**: `ComposeTestRule`でComposableの自動テスト。SemanticNodeの検索・アサーション
- **SwiftUI**: `ViewInspector`またはXCTest UIテスト
- **スナップショットテスト**: Paparazzi（Android）/ Swift Snapshot Testing（iOS）で視覚的回帰検出

### §110. 統合テスト・E2Eテスト

- **Maestro**: クロスプラットフォームE2Eテストフレームワーク。YAML定義でテストフロー記述
- **Espresso**: Android UIテスト（レガシー。新規はCompose Test推奨）
- **XCUITest**: iOS UIテスト
- **テスト環境**: モックサーバー（WireMock / MockServer）でAPI依存を排除

### §111. パフォーマンステスト

- **Macrobenchmark（Android）**: 起動時間、スクロール、アニメーションのベンチマーク
- **XCTest Performance**: `measure { }`でiOSパフォーマンス計測
- **Baseline Profiles生成**: Macrobenchmarkテストから自動生成
- **CI統合**: パフォーマンスリグレッションの自動検出。閾値超過でPRブロック

### §112. セキュリティテスト

- **静的解析**: detekt security rules / SwiftLint security rules
- **依存関係スキャン**: Dependabot / Renovate + OSVスキャナー
- **ペネトレーションテスト**: 年1回以上の外部ペネトレーションテスト
- **OWASP MASVS**: モバイルアプリセキュリティ検証基準への準拠確認

### §113. テストインフラストラクチャ

- **Firebase Test Lab**: 実機テスト。Roboテスト + カスタムテスト
- **Xcode Cloud**: iOS CI/CDとテスト統合
- **テストシャーディング**: 大規模テストスイートの並列実行
- **Flaky テスト撲滅**: Flakyテストを自動検出し隔離。2週間以内に修正義務

### §114. Screenshot Testing

- **Android Screenshot Testing API**: Compose UIの視覚的リグレッション検出
- **Paparazzi**: ヘッドレスでComposeスクリーンショット取得。実機不要
- **Swift Snapshot Testing**: SwiftUI/UIKitビューのスナップショットテスト
- **CI統合**: PRごとにゴールデンイメージとの差分自動レポート

---

## Part XVIII: ビルド・CI/CD・リリース

### §115. ビルド最適化

- **Gradle**: Configuration Cache有効化。Build Cache（ローカル + リモート）必須
- **Gradle 9.x**: Isolated Projects対応
- **Xcode**: DerivedData Cache活用。並列ビルド設定最適化
- **目標**: フルビルド15分以内。インクリメンタルビルド3分以内
- **Convention Plugin**: ビルド設定の共通化でbuild.gradle.kts簡素化

### §116. CI/CDパイプライン

- **5段階ゲート**: Lint → Unit Test → Integration Test → Build → Release
- **Affected Module Detection（Android）**: 変更モジュールのみテスト・ビルド
- **Code Signing自動化**: Fastlane Match / App Store Connect API
- **アーティファクト管理**: APK/IPA/dSYM/mapping.txtの自動保存・バージョン紐付け

### §117. リリース管理

- **Staged Rollout（Android）**: 1% → 5% → 20% → 50% → 100%の段階配信
- **TestFlight（iOS）**: 内部/外部テスターへの配信。自動フィードバック収集
- **リリース判定**: クラッシュ率 < 0.1%、ANR率 < 0.5%がGo条件
- **ホットフィックス**: 重大バグ発見時の緊急リリースフロー定義

### §118. ストアガイドライン遵守

- **App Store Review Guidelines**: 開発開始時に最新版を確認
- **Google Play Developer Policy**: 審査ポリシー変更の定期モニタリング
- **プリサブミッションチェック**: ストア固有の自動チェックリスト実行
- **メタデータ管理**: ASO（App Store Optimization）のキーワード/スクリーンショット最適化

### §119. Feature Flag運用

- **Firebase Remote Config / LaunchDarkly**: 機能のON/OFF切替
- **段階的ロールアウト**: 新機能を段階的にユーザーに公開
- **A/Bテスト**: 機能バリアントの比較実験
- **キルスイッチ**: 問題発生時の即時機能無効化

### §120. バージョニング規約

- **セマンティックバージョニング**: `MAJOR.MINOR.PATCH`
- **ビルド番号**: CI/CDで自動インクリメント。手動変更禁止
- **versionCode（Android）**: 単調増加。`MAJOR * 10000 + MINOR * 100 + PATCH`
- **CFBundleVersion（iOS）**: ビルド番号と連動

### §121. Gradle最新動向

- **Gradle Version Catalog**: `libs.versions.toml`での依存一元管理
- **Convention Plugins**: ビルドロジックの共通化
- **Configuration Cache**: ビルド設定のキャッシュで再構成を回避
- **Amper（実験的）**: JetBrains新構築ツール。KMPプロジェクト向け簡素化

### §122. Xcode Cloud・Fastlane

- **Xcode Cloud**: Apple公式CI/CD。TestFlight配信自動化
- **Fastlane**: コード署名（Match）、スクリーンショット自動化、メタデータ管理
- **Tuist**: Xcodeプロジェクト生成・管理の自動化ツール
- **Mise**: 開発環境のバージョン管理（Ruby, Node等のFastlane依存）

---

## Part XIX: アクセシビリティ

### §123. スクリーンリーダー対応

- **TalkBack（Android）**: `contentDescription`を全インタラクティブ要素に設定
- **VoiceOver（iOS）**: `accessibilityLabel`/`accessibilityHint`を適切に設定
- **読み上げ順序**: 論理的な読み上げ順序を`accessibilityTraversalOrder`で制御
- **ライブリージョン**: 動的コンテンツ更新を`accessibilityLiveRegion`（Android）/ `UIAccessibility.post(notification:)`（iOS）で通知

### §124. Dynamic Type / フォントスケーリング

- **Android**: `sp`単位でフォントサイズを定義。`textScaleFactor`対応
- **iOS**: Dynamic Type対応。`preferredFont(forTextStyle:)`使用
- **最大倍率**: テキストが200%拡大してもレイアウトが崩れないことを検証
- **テスト**: アクセシビリティインスペクタでフォントスケーリングを検証

### §125. タッチターゲットとモーション

- **最小タッチターゲット**: 48dp × 48dp（Android）/ 44pt × 44pt（iOS）
- **モーション軽減**: `prefers-reduced-motion`への対応。アニメーション無効化オプション
- **色覚多様性**: 色だけに依存しない情報伝達。コントラスト比 4.5:1以上
- **キーボードナビゲーション**: iPad外部キーボード / Chromebookでの完全操作対応

### §126. アクセシビリティテスト

- **Accessibility Scanner（Android）**: 自動スキャンでa11y問題を検出
- **Accessibility Inspector（iOS）**: Xcode統合ツール
- **CI統合**: Espresso a11y checks / XCTest a11y assertions をCIに統合
- **WCAG 2.2 AA準拠**: 全新規画面はWCAG 2.2 AA基準を満たすことを必須
- **当事者テスト**: 視覚障害/運動障害のユーザーによるテストを定期的に実施

### §127. LE Audio・補聴器対応（Android 16）

- **LE Audio**: 低遅延Bluetoothオーディオ。補聴器との統合強化
- **通話中マイク切替**: LE Audio補聴器使用時のマイク入力切替
- **アンビエント音量調整**: 周囲音のボリュームコントロール

---

## Part XX: 可観測性・モニタリング

### §128. クラッシュレポーティング

- **Firebase Crashlytics**: Android/iOS共通のクラッシュ分析
- **Non-fatal errors**: 致命的でないエラーもCrashlyticsに記録
- **ProGuard/R8マッピング**: 難読化スタックトレースの自動解読
- **dSYM**: Xcode自動アップロード設定。Bitcode廃止後もdSYMは必須
- **アラート基準**: クラッシュフリー率 < 99.9%でアラート発火

### §129. パフォーマンスモニタリング

- **Firebase Performance Monitoring**: ネットワーク遅延、画面レンダリング、カスタムトレース
- **MetricKit（iOS）**: MXAppLaunchMetric, MXAnimationMetric等のシステムレベルメトリクス
- **カスタムトレース**: 重要ユーザーフロー（ログイン、検索、決済）の計測
- **ANR/Hang検出**: Android ANR / iOS Hang の自動検出とレポーティング

### §130. OpenTelemetry Mobile

- **OTel Mobile SDK**: 標準化テレメトリ収集。ベンダーロックイン回避
- **分散トレーシング**: モバイル → API → バックエンドの完全なトレース連携
- **セマンティック規約**: OTel Mobile Semantic Conventionsに準拠
- **エクスポート**: OTLP形式でバックエンド（Datadog/New Relic/Grafana等）に送信

### §131. アプリ分析・ヘルスモニタリング

- **ユーザーフロー分析**: 画面遷移、機能利用率、離脱ポイントの可視化
- **Core Web Vitals的指標**: 起動時間、インタラクション応答性、視覚的安定性
- **アラート閾値定義**:
  - クラッシュ率 > 0.1% → P1アラート
  - ANR率 > 0.5% → P1アラート
  - 起動時間 > 2s → P2アラート
  - ネットワークエラー率 > 5% → P2アラート

### §132. ログ戦略

- **構造化ログ**: JSON形式。タイムスタンプ、セッションID、ユーザーID（ハッシュ化）を含む
- **ログレベル**: ERROR/WARN/INFO/DEBUG。リリースビルドはINFO以上のみ
- **PII除外**: 個人情報はログに絶対に出力しない
- **ローテーション**: ログファイルサイズ上限設定。古いログの自動削除

---

## Part XXI: FinOps・コスト最適化

### §133. ビルドコスト最適化

- **CI/CD実行時間**: ビルド時間15分以内（Android/iOS共通目標）
- **キャッシュ戦略**: Gradle Build Cache / Xcode DerivedData Cache / SPMキャッシュでリビルド削減
- **テスト選択実行**: Affected Module Detection（Android）で変更関連テストのみ実行
- **セルフホストランナー**: Apple Silicon Mac mini / Linux ARM64でCI/CDコスト削減
- **並列ビルド**: iOS並列ビルドとテストシャーディングでwait時間最小化

### §134. ストアコスト最適化

- **App Size**: < 30MB初回ダウンロード。ストアコンバージョン率との相関を定期分析
- **On-Demand Resources（iOS）**: 大容量アセットのオンデマンドダウンロード
- **Dynamic Feature Modules（Android）**: 機能のオンデマンドインストール
- **ASO ROI**: キーワード最適化・スクリーンショットA/Bテストの効果測定

### §135. クラウドサービスコスト

- **Firebase Blaze Plan**: 無料枠超過の監視アラート設定
- **テレメトリコスト**: ログ/メトリクスの送信量を最適化。サンプリング率の適正化
- **CDN最適化**: 画像/アセットのCDN配信でオリジンサーバーコスト削減
- **APIコール最適化**: バッチリクエスト、キャッシュ活用でAPI呼び出し回数削減

### §136. デバイスファーム最適化

- **Firebase Test Lab**: 最小限の実機構成で最大カバレッジ
- **テスト並列化**: テストシャーディングによる実行時間短縮
- **エミュレータ活用**: 実機テストが不要なケースではエミュレータでコスト削減
- **テスト選択**: リスクベースドテストで実行対象を最適化

---

## Part XXII: visionOS・Spatial Computing

### §137. visionOS アプリ設計

- **3Dスペーシャルインタラクション**: 目・手・声による自然なインタラクション設計
- **App構造**: Windows（浮遊2Dウィンドウ）/ Volumes（3Dコンテンツ）/ Immersive Spaces（没入体験）
- **SwiftUI + RealityKit**: SwiftUIで2D UI、RealityKitで3Dコンテンツを統合
- **クロスプラットフォーム**: SwiftUIの共通コードでiOS/macOS/visionOS対応
- **イベントハンドリング**: タップ/ロングプレス/ドラッグ/回転/ズームジェスチャー

### §138. visionOS パフォーマンス・UX

- **レンダリング**: 90fps必須（VR酔い防止）。RealityKit最適化
- **空間オーディオ**: 3Dポジショナルオーディオでリアリティを向上
- **アクセシビリティ**: VoiceOver空間対応、ポインターコントロール代替入力
- **プライバシー**: カメラ/場所データの最小取得。ARSession権限管理

### §139. visionOS設計原則

- **空間デザイン**: 奥行き感のある情報階層。z軸を活用したUIレイヤリング
- **物理ベースインタラクション**: 手の自然な動きに対応するジェスチャー設計
- **シェアードスペース**: 他アプリとの共存を考慮した設計
- **Human Interface Guidelines for visionOS**: Apple HIG visionOS版に厳密準拠

---

## Part XXIII: Wear OS・watchOS

### §140. Wear OS 開発

- **Compose for Wear OS**: Wear特化のComposeコンポーネント使用
- **Tiles API**: グランスアブル情報表示。Tileレンダラーで効率的描画
- **Health Services API**: センサーデータ（心拍数、歩数等）の効率取得
- **バッテリー配慮**: バックグラウンド計測はHealth Services APIに委譲
- **Complications**: ウォッチフェイスコンプリケーションのデータプロバイダー実装

### §141. watchOS 開発

- **SwiftUI First**: watchOS UIはSwiftUIのみ。WatchKit（Storyboard）は非推奨
- **WidgetKit**: watchOSウィジェット/コンプリケーション
- **HealthKit**: 心拍数、ワークアウト、睡眠データの取得・記録
- **WCSession**: iPhone↔Apple Watch間通信。ファイル転送/メッセージング
- **Always On Display**: 常時表示対応。`TimelineView`で低頻度更新

### §142. ウェアラブルUX原則

- **グランスアブル**: 情報は一目で理解可能に。長文テキスト禁止
- **2秒ルール**: ユーザーインタラクションは2秒以内に完結
- **コンテキストアウェア**: 時間/場所/活動に応じたプロアクティブ情報提示
- **ハプティック**: 重要通知は触覚フィードバックで伝達

---

## Part XXIV: Android XR・Immersive

### §143. Android XR プラットフォーム

- **Jetpack XR**: AndroidのAR/VRアプリ向けフレームワーク
- **ARCore**: 環境認識・平面検出・オクルージョン
- **Compose for XR**: Compose構文で空間UIを構築
- **クロスデバイス**: スマートフォン/タブレット/ヘッドセットの統合体験設計
- **パフォーマンス**: 90fps目標。低遅延レンダリングパイプライン

### §144. Immersive Experience設計

- **6DoF**: 6自由度トラッキングの活用。位置+回転の完全追跡
- **空間アンカー**: 物理空間へのデジタルコンテンツの固定
- **ハンドトラッキング**: 手の動きによる直感的インタラクション
- **コンテンツ配置**: 人間工学に基づいた視線高さ・距離のガイドライン

---

## Part XXV: グリーンエンジニアリング

### §145. バッテリー効率設計

- **バックグラウンド制限遵守**: OS提供のスケジューラーAPI（WorkManager/BGTaskScheduler）を使用
- **位置情報省電力**: Significant Location Change / Geofencingの活用
- **ネットワーク効率**: バッチリクエスト、gzip圧縮、HTTP/3 0-RTT
- **レンダリング効率**: 不要なアニメーション/再描画の排除
- **ダークモード推奨**: OLED画面での消費電力削減

### §146. CO2排出量意識

- **計測**: ビルドCI/CDのCO2排出量をSCI（Software Carbon Intensity）で計測
- **最適化**: ARM64ビルドランナー使用でエネルギー効率向上
- **コード効率**: 不要な依存関係の排除、バンドルサイズ最適化
- **Green SRE連携**: サーバーサイドのグリーン最適化との統合的な環境負荷低減

### §147. エネルギー効率KPI

| 指標 | 目標値 | 測定方法 |
|------|-------|---------|
| バックグラウンドバッテリー消費 | < 1%/時間 | Battery Historian / Energy Log |
| ネットワークバッテリー消費 | < 0.5%/API呼び出し | Energy Profiler |
| CI/CDビルドエネルギー | < 0.5 kWh/ビルド | SCI計測 |
| アイドル時CPU使用率 | < 1% | Instruments / Profiler |

---

## Part XXVI: プライバシー・コンプライアンス

### §148. Privacy Manifest深化（iOS）

- **Required Reason API**: UserDefaults, FileTimestamp, SystemBootTime, DiskSpaceの使用理由を全て宣言
- **サードパーティSDK Privacy Manifest**: 使用SDKの全Privacy Manifestの確認・集約
- **Tracking Transparency**: ATT（App Tracking Transparency）フレームワークの適切な実装
- **Privacy Nutrition Labels**: App Store Connectでの正確なプライバシーラベル申告
- **FingerPrinting禁止**: デバイスフィンガープリンティングに該当するAPI使用の禁止

### §149. Android プライバシー

- **QUERY_ALL_PACKAGES制限**: Android 11+のパッケージ可視性制限への対応
- **Scoped Storage**: アプリ固有ストレージの適切な使用
- **Photo Picker**: ストレージ権限不要の画像選択APIを優先
- **Embedded Photo Picker（Android 16）**: アプリUI内に直接埋め込み可能
- **バックグラウンド位置情報**: `ACCESS_BACKGROUND_LOCATION`の使用は正当化必須
- **Data Safety Section**: Google Play Console での正確な情報申告

### §150. 規制コンプライアンス

- **GDPR**: EUユーザーへのデータ処理同意取得。データポータビリティ・削除権対応
- **APPI**: 日本の個人情報保護法2025年改正への対応
- **CCPA/CPRA**: カリフォルニア消費者プライバシー法対応
- **EU CRA（Cyber Resilience Act）**: 2027年施行。SBOM・脆弱性報告義務
- **児童保護**: COPPA準拠。13歳未満ユーザーへの特別保護
- **レビュー**: プライバシーポリシーのアプリ内表示と定期更新

### §151. 権限管理ベストプラクティス

- **Just-in-Time**: 権限要求は使用直前の文脈で実施
- **Pre-Permission Pattern**: システムダイアログ前に価値説明画面を表示
- **Graceful Degradation**: 権限拒否時も代替UIで機能を提供
- **権限棚卸し**: 半年に1回、使用権限の必要性を再検証

### §152. EAA（European Accessibility Act 2025）

- **法的要件**: 2025年6月施行。デジタル製品のアクセシビリティ義務化
- **対象**: EU市場向けモバイルアプリ。自己適合宣言を準備
- **WCAG 2.2 AA**: 技術的基準としてWCAG 2.2 AA準拠を義務付け
- **当事者テスト**: 障がいのある方によるテストを含む検証プロセス

---

## Part XXVII: チーム・組織設計

### §153. Mobile Platform Team

- **Platform Team**: 共通インフラ（CI/CD、デザインシステム、ネットワーク層）の責任を持つ専門チーム
- **Feature Teams**: 機能単位のクロスファンクショナルチーム。Android/iOS開発者を含む
- **コードオーナーシップ**: `CODEOWNERS`でモジュール毎のレビュー責任を明確化
- **アーキテクチャレビュー**: 新機能設計時のアーキテクチャレビュー必須

### §154. 知識共有・育成

- **Tech Radar**: チーム内技術レーダーでAdopt/Trial/Assess/Holdを管理
- **モブプログラミング**: 複雑な実装はモブプロで知識共有
- **RFCプロセス**: 大規模変更時はRFC（Request for Comments）を作成
- **KMP育成**: Swiftエンジニア向けKotlin研修、Kotlinエンジニア向けSwift研修の相互実施

### §155. コードレビュー基準

- **レビューチェックリスト**: セキュリティ、パフォーマンス、アクセシビリティ、テストカバレッジの4観点
- **PR Size**: 1 PR ≤ 400行変更目標。大規模変更はスタック型PR
- **レビューSLA**: PR提出後24時間以内に初回レビュー
- **自動チェック**: Lint/Format/Testの自動チェック通過をマージ前提条件

---

## Part XXVIII: マイグレーション戦略

### §156. UIKit → SwiftUI 移行

- **段階的移行**: 新規画面をSwiftUIで実装。既存画面は`UIHostingController`で部分的に置換
- **共存期間**: UIKit/SwiftUI共存は2-3年の長期計画で推進
- **データフロー統合**: `@Observable`マクロで状態管理を統一
- **テスト戦略**: 移行後の画面はSwiftUI PreviewsベースのVRTでリグレッション検出

### §157. View → Compose / Java → Kotlin 移行

- **Compose移行**: 新規画面をCompose化。既存XMLレイアウトは`AndroidView`/`ComposeView`で段階的置換
- **Java→Kotlin**: 新規コードはKotlin必須。既存JavaはAndroid Studioの自動変換ツールで段階的移行
- **Interop**: `ComposeView`（XML内にCompose）/ `AndroidView`（Compose内にView）の双方向統合
- **移行メトリクス**: Kotlin化率・Compose化率をダッシュボードで追跡

### §158. 移行のROI計測

- **メトリクス**: コード行数削減率、バグ密度変化、ビルド時間変化、開発速度変化
- **段階的検証**: 各移行フェーズ完了後にROI計測。効果が低い場合は計画見直し
- **移行テスト**: A/Bテストで旧画面と新画面のUXメトリクス比較

---

## Part XXIX: デザインシステム連携

### §159. Material Design 3 / Material 3 Expressive

- **Material 3**: Android標準デザインシステム。Dynamic Color、Typography Scale準拠
- **Material 3 Expressive（2025）**: 感情的デザイン表現の拡張。Motion, Shape, Color の豊かな表現
- **Design Tokens**: Figma→コード変換。`MaterialTheme`でテーマを一元管理
- **カスタムコンポーネント**: Material 3ベースにプロジェクト固有コンポーネントを構築

### §160. Human Interface Guidelines (HIG)

- **HIG準拠**: iOS/macOS/visionOS/watchOSのHIGに厳密準拠
- **SF Symbols**: 標準アイコンセット。カスタムシンボルもHIG形式で作成
- **Typography**: SF Pro / SF Mono / New York。Dynamic Type連携
- **Spacing/Layout**: 8ptグリッドシステム。Safe Area対応

### §161. Liquid Glass デザインシステム（iOS 26+）

- **Liquid Glass原則**: ガラス質の透明・丸みを帯びたUI。奥行き感の表現
- **自動適用**: Xcode 26で再コンパイルすることで既存アプリに自動適用
- **カスタマイズ**: `.glass`修飾子系統のカスタムスタイリングAPI
- **互換性**: iOS 26未満では従来デザインにフォールバック
- **アクセシビリティ**: `Reduce Bright Effects`設定への対応

---

## Part XXX: Embedded Systems・IoT

### §162. Embedded Swift

- **Embedded Swift**: Swift 6.2で強化。組込みシステム向けSwift実行環境
- **対象**: IoTデバイス、車載システム、家電制御
- **Package Traits**: 環境適応型ビルド設定で組込みターゲットに最適化
- **メモリ制約**: 最小限のランタイムオーバーヘッド

### §163. Kotlin/Native 組込み

- **Kotlin/Native**: LLVM 19ベースで組込みターゲットに対応
- **C相互運用**: `cinterop`でCライブラリを直接呼び出し
- **メモリ管理**: 参照カウントベース。リアルタイム制約下では予測可能な実行
- **バイナリサイズ**: 最適化フラグでサイズ削減

### §164. IoTプロトコル統合

- **MQTT**: 軽量メッセージングプロトコル。低帯域・低電力環境
- **Matter**: スマートホーム標準プロトコル。Apple/Google/Amazon共通
- **Bluetooth LE**: ペリフェラル/セントラル両モードの実装パターン
- **Thread**: IPv6ベースのメッシュネットワーキング

---

## Part XXXI: ネットワーキング・通信

### §165. HTTP/3 (QUIC) 最適化

- **OkHttp 5+**: Android HTTP/3デフォルトサポート
- **URLSession**: iOSでHTTP/3を優先使用（iOS 15+デフォルト有効）
- **0-RTT**: 初回接続のレイテンシ削減
- **Connection Migration**: ネットワーク切替（Wi-Fi↔モバイル）時の接続維持

### §166. gRPC モバイル

- **gRPC-Kotlin**: Kotlin向けgRPCクライアント。Coroutines統合
- **gRPC-Swift**: Swift向けgRPCクライアント。async/await統合
- **Protocol Buffers**: ペイロードサイズ削減。JSON比70-80%削減
- **Streaming**: Server/Client/Bidirectional ストリーミング対応
- **エラーハンドリング**: gRPCステータスコードの適切なマッピング

### §167. WebTransport・WebSocket

- **WebSocket**: 双方向リアルタイム通信の標準
- **WebTransport**: HTTP/3ベースの次世代リアルタイムプロトコル
- **接続管理**: 自動再接続 + Exponential Backoff + Jitter
- **帯域制御**: ネットワーク品質に応じたメッセージ優先度制御

---

## Part XXXII: 国際化・ローカライゼーション

### §168. 文字列管理

- **Android**: `strings.xml`でローカライズ。`Plurals`/`StringArray`対応
- **iOS**: `String Catalog`（Xcode 15+）でローカライズ管理。`.xcstrings`形式
- **型安全文字列**: 文字列キーのハードコード禁止。コード生成されたリソースIDを使用
- **翻訳管理**: Crowdin / Lokalise / Phrase等のTMSとCI統合

### §169. RTL・多言語レイアウト

- **RTLサポート**: アラビア語/ヘブライ語のRTLレイアウト完全対応
- **Auto Layout**: `leading`/`trailing`を`left`/`right`の代わりに使用
- **テスト**: 全画面をRTLモードで検証（Android Developer Options / iOS設定）
- **フォント**: 言語別フォントのフォールバック設定

### §170. 日時・通貨・数値フォーマット

- **ICU**: ロケール依存のフォーマットにICU準拠API使用
- **`DateFormatter`/`NumberFormatter`**: ロケール依存の日時/数値フォーマッティング
- **通貨**: `Locale`ベースの通貨フォーマット。ハードコード禁止
- **相対日時**: 「3分前」等の相対表現にRelativeDateTimeFormatterを使用

---

## Part XXXIII: データ変換・シリアライゼーション

### §171. Kotlin Serialization

- **kotlinx.serialization**: マルチプラットフォーム対応のシリアライゼーション
- **JSON**: `Json { ignoreUnknownKeys = true }`をデフォルト設定
- **バージョニング**: APIレスポンスの後方互換性を`@SerialName`/`@EncodeDefault`で保証
- **パフォーマンス**: Gsonからの移行。リフレクション不使用で高速化

### §172. Swift Codable

- **Codable**: Swift標準のエンコード/デコードプロトコル
- **CodingKeys**: JSON↔Swiftプロパティ名のマッピング
- **カスタムDecoder**: 複雑なAPI応答のデコード戦略
- **エラーハンドリング**: `DecodingError`の適切なcatch・ユーザー向けメッセージ変換

---

## Part XXXIV: Dependency Management・SBOM

### §173. 依存関係管理

- **Gradle Version Catalog**: `libs.versions.toml`で一元管理（Android/KMP）
- **Swift Package Manager**: `Package.swift`+`Package.resolved`でバージョン固定
- **CocoaPods**: レガシー。SPMへの段階的移行推奨
- **Renovate / Dependabot**: 自動更新PR。セキュリティパッチは72時間以内にマージ
- **OSV Scanner**: 既知脆弱性の自動検出

### §174. SBOM (Software Bill of Materials)

- **CycloneDX**: SBOM生成標準フォーマット
- **EU CRA準拠**: 2027年施行のEU Cyber Resilience Actに備えたSBOM義務化
- **ライセンス監査**: 全依存関係のライセンス互換性チェック
- **脆弱性トラッキング**: SBOMベースの継続的脆弱性モニタリング

---

## Part XXXV: エラーハンドリング戦略

### §175. Kotlin エラーハンドリング

- **Result型**: `kotlin.Result`またはカスタムSealed classでエラーを型安全に表現
- **runCatching**: try-catchの代わりに`runCatching`+`onSuccess`/`onFailure`/`fold`
- **例外階層**: ビジネス例外 vs 技術例外を明確に分離
- **Coroutine例外**: `CoroutineExceptionHandler` + `supervisorScope`で伝播を制御

### §176. Swift エラーハンドリング

- **Typed Throws（Swift 6）**: エラー型を関数シグネチャで明示
- **Result型**: `Result<Success, Failure>`でエラーを値として扱う
- **guard early return**: 早期リターンパターンで可読性向上
- **do-catch**: リカバリ可能なエラーの処理。catch節は具体的に
- **Never型**: 失敗しないフォールバックの型安全な表現

---

## Part XXXVI: コード生成・メタプログラミング

### §177. Kotlin コード生成

- **KSP (Kotlin Symbol Processing)**: KAPT後継。ビルド速度2倍以上改善
- **KSP対応ライブラリ**: Room, Hilt, Moshi, kotlinx.serialization
- **カスタムKSPプロセッサ**: プロジェクト固有のボイラープレート削減
- **K2コンパイラプラグインAPI**: 安定版コンパイラプラグインAPIの設計進行中

### §178. Swift マクロ

- **Swift Macros**: `@Freestanding`/`@Attached`マクロでコンパイル時コード生成
- **`@Observable`**: Observation Frameworkのマクロ
- **`@Model`**: SwiftDataのマクロ
- **`@Test`**: Swift Testingのマクロ
- **カスタムマクロ**: プロジェクト固有の反復コード削減に活用
- **マクロビルドパフォーマンス（Swift 6.2）**: マクロ使用プロジェクトのクリーンビルド時間大幅改善

---

## Part XXXVII: AI支援開発・Copilot統合

### §179. AIコーディングアシスタント

- **GitHub Copilot / Gemini Code Assist**: AIコード補完をIDEに統合
- **レビュー支援**: AIによるPRレビュー補助。セキュリティ・パフォーマンス観点の自動チェック
- **テスト生成**: AIアシスタントによるテストコード生成。手動レビュー必須
- **制約**: AI生成コードは必ず人間がレビュー。ライセンス互換性の確認

### §180. AIネイティブ開発パターン

- **プロンプトエンジニアリング**: オンデバイスLLM向けのプロンプト設計パターン
- **StructuredOutput**: LLM出力の型安全なパース（JSONスキーマ/Codable連携）
- **RAG連携**: オンデバイスベクターDB + LLMの組み合わせパターン
- **エッジ-クラウドハイブリッド**: 小型モデルはオンデバイス、大型モデルはクラウドの使い分け

---

## Part XXXVIII: ストア審査最適化

### §181. App Store審査対策

- **App Store Review Guidelines**: 最新版（2025年版）の定期チェック
- **審査リジェクト回避**: Guideline 4.3（スパム）、5.1.1（データ収集）、3.1.1（IAP）の要注意ポイント
- **Privacy Manifest完備**: 不備による審査リジェクトを防止
- **App Review情報**: 審査員向けのテストアカウント・説明資料準備

### §182. Google Play審査対策

- **Developer Policy更新追従**: ポリシー変更の定期モニタリング
- **Data Safety Section**: 正確な情報申告。不備はストア掲載停止リスク
- **Foreground Service Type**: 不適切なタイプ宣言による審査リジェクト防止
- **Target API Level要件**: Google Playの最新targetSdk要件を常に満たす

---

## Part XXXIX: 成熟度モデル・アンチパターン

### §183. 成熟度モデル（5段階）

| レベル | 名称 | 特徴 |
|--------|------|------|
| L1 | Ad Hoc | ネイティブ標準なし。プラットフォーム知識が属人的。テスト不在 |
| L2 | Defined | コーディング規約・アーキテクチャガイド策定。Lint/Format統一。ユニットテスト導入 |
| L3 | Managed | CI/CD統合、自動テスト70%+、Baseline Profiles、アクセシビリティ AA対応、KMP導入 |
| L4 | Optimized | KMP共有85%+、オンデバイスAI統合、パフォーマンスバジェット運用、Compose/SwiftUI完全移行 |
| L5 | Autonomous | 自動回帰検知、A/Bモデル配信、0-day脆弱性自動パッチ、SLO駆動開発、Green SRE統合 |

### §184. アンチパターン30選

| # | アンチパターン | 正しい対応 |
|---|-------------|-----------| 
| 1 | `!!`演算子の多用 | `?.`, `?:`, `let`で安全にハンドリング |
| 2 | API Keyのハードコード | Keystore/Keychain + CI Secrets |
| 3 | メインスレッドでのI/O | `Dispatchers.IO` / `Task.detached` |
| 4 | 生のMethodChannel | Pigeon使用 |
| 5 | SharedPreferencesに機密データ | EncryptedSharedPreferences/Keychain |
| 6 | ARC循環参照の放置 | `[weak self]`の適切な使用 |
| 7 | 全画面再Composition | 粒度の細かい状態管理・State読み取り遅延 |
| 8 | テストなしリリース | ユニット/UI/E2Eテスト必須 |
| 9 | a11y対応の後回し | Day 1からアクセシビリティ設計 |
| 10 | 非推奨API使用 | Coroutines/async-await/最新API |
| 11 | Baseline Profile未設定 | 重要フローのAOTプロファイル生成 |
| 12 | Privacy Manifest未対応 | `PrivacyInfo.xcprivacy`必須 |
| 13 | WebView JS無制限 | 最小権限 + サニタイズ |
| 14 | Root/JB検出なし | Play Integrity / App Attest |
| 15 | 通知権限の即時要求 | Pre-Permission Patternで価値説明後 |
| 16 | オフライン非対応 | ローカルDB SSOT + バックグラウンド同期 |
| 17 | 単一巨大モジュール | Feature Module分割 |
| 18 | Certificate対策なし | Certificate Transparency / Pinning |
| 19 | バッテリー消費無配慮 | Doze/BGTaskScheduler対応 |
| 20 | ストアガイドライン未確認 | リリース前に最新ポリシー確認 |
| 21 | GlobalScope.launch | 構造化されたCoroutineScope使用 |
| 22 | KAPT使用継続 | KSPへ移行 |
| 23 | ObservableObject使用継続 | `@Observable`マクロ移行（iOS 17+） |
| 24 | K1コンパイラ使用 | K2コンパイラ移行 |
| 25 | Pinning Only（CT未対応） | Certificate Transparency優先 |
| 26 | Context Receivers使用 | Context Parameters移行（Kotlin 2.2+） |
| 27 | Combine新規使用 | `@Observable` + `Observations`移行 |
| 28 | SBOM未生成 | CycloneDX SBOM生成でEU CRA備え |
| 29 | InlineArray未検討 | パフォーマンスクリティカル箇所で活用 |
| 30 | EAA未対応 | WCAG 2.2 AA準拠で法的リスク回避 |

---

## Part XL: 将来展望

### §185. 技術トレンド（2026-2028）

- **Kotlin/Wasm GA**: Web対象の正式安定版到達
- **Swift Embedded GA**: 組込みシステム向けSwift安定版
- **Compose Multiplatform全プラットフォーム安定**: iOS/Web/Desktopの全ターゲット安定版
- **AI-Native Development**: AI Copilotによるコード生成・レビュー・テスト自動化の標準化
- **Quantum-Safe Cryptography**: ML-KEM/ML-DSA対応のモバイル暗号ライブラリ
- **Spatial Computing普及**: visionOS/Android XR エコシステムの成熟
- **Context Parameters GA（Kotlin 2.3+）**: コンテキスト依存DI/DSLの標準化
- **Swift Value Generics**: コンパイル時定数ジェネリクスのさらなる拡張

### §186. 推奨学習パス

- **Android**: Kotlin 2.2 → Compose 1.10 → Hilt → KMP → ML Kit → Compose Multiplatform → Android XR
- **iOS**: Swift 6.2 → SwiftUI → SwiftData → Observation → Foundation Models → visionOS
- **共通**: Clean Architecture → CI/CD → セキュリティ → アクセシビリティ → パフォーマンス最適化 → SBOM/CRA

---

## Appendix A: 逆引き索引

| キーワード | 参照セクション |
|-----------|-------------|
| Kotlin 2.2 / K2 / Context Parameters | §5–§7 |
| Kotlin 2.2.20 / Swift Export / Wasm Beta | §6, §36 |
| Swift 6.2 / Approachable Concurrency / @concurrent | §11–§12 |
| InlineArray / Span / Memory Safety | §14 |
| Sendable / Actor / Structured Concurrency | §12, §58 |
| KMP / Kotlin Multiplatform / Swift Export | §34–§40 |
| Compose Multiplatform / iOS安定版 | §41–§44 |
| Jetpack Compose / Pausable Composition / retain | §45–§50 |
| SwiftUI / @Observable / Observations | §51–§56 |
| Liquid Glass / iOS 26 | §27, §56, §161 |
| Baseline Profiles / Macrobenchmark | §49, §111 |
| Coroutines / Flow / StateFlow | §57 |
| async/await / TaskGroup | §58 |
| Android 16 / Embedded Photo Picker / ARR | §22, §66, §100 |
| Room / SwiftData / オフラインファースト | §79–§85 |
| Core ML / ML Kit / オンデバイスAI | §71–§78 |
| Apple Foundation Models / Gemini Nano | §74, §75 |
| セキュリティ / Keystore / Keychain | §86–§94 |
| Passkeys / FIDO2 / 生体認証 | §88 |
| RASP / Play Integrity / App Attest | §89 |
| Certificate Transparency / Pinning | §90 |
| Privacy Sandbox / Android 16 | §92 |
| Privacy Manifest / ATT | §28, §148 |
| Push通知 / FCM / APNs | §95 |
| Deep Links / Universal Links | §96 |
| WidgetKit / Glance / Live Activities | §97 |
| Health Connect / HealthKit / FHIR | §101 |
| Pigeon / Platform Channel | §102 |
| Swift Testing / @Suite / Tags | §107, §108 |
| Screenshot Testing / Paparazzi | §114 |
| テスト / JUnit5 / Maestro | §107–§113 |
| CI/CD / Staged Rollout / Feature Flag | §115–§122 |
| Gradle 9.x / Convention Plugin / Amper | §121 |
| Xcode Cloud / Fastlane / Tuist | §122 |
| アクセシビリティ / VoiceOver / TalkBack | §123–§127 |
| WCAG 2.2 / EAA 2025 | §126, §152 |
| LE Audio / 補聴器 | §127 |
| Crashlytics / OpenTelemetry Mobile | §128–§132 |
| FinOps / アプリサイズ / ビルドコスト | §133–§136 |
| visionOS / Spatial Computing | §137–§139 |
| Wear OS / watchOS | §140–§142 |
| Android XR / ARCore | §143–§144 |
| グリーンエンジニアリング / バッテリー | §145–§147 |
| EU CRA / SBOM / GDPR / APPI | §150, §174 |
| デザインシステム / Material 3 Expressive / HIG | §159–§161 |
| Embedded Swift / IoT / Matter | §162–§164 |
| HTTP/3 / gRPC / WebTransport | §165–§167 |
| 国際化 / RTL / String Catalog | §168–§170 |
| kotlinx.serialization / Codable | §171–§172 |
| Dependency Management / SBOM | §173–§174 |
| エラーハンドリング / Result型 / Typed Throws | §175–§176 |
| KSP / Swift Macros / コード生成 | §177–§178 |
| AI支援開発 / Copilot | §179–§180 |
| ストア審査 / ASO | §181–§182 |
| 成熟度モデル / アンチパターン | §183–§184 |

---

## Appendix B: クロスリファレンス

| 関連ルール | ファイル | 関連トピック |
|-----------|---------|------------|
| モバイル開発 (Flutter) | [342_mobile_flutter.md](../ja/342_mobile_flutter.md) | Flutter固有ベストプラクティス |
| ストア申請準拠 | [103_appstore_compliance.md](../ja/103_appstore_compliance.md) | IAP/ASO/審査ガイドライン |
| セキュリティ | [600_security_privacy.md](../ja/600_security_privacy.md) | Zero Trust/OWASP/暗号化 |
| デザイン・UX | [200_design_ux.md](../ja/200_design_ux.md) | アクセシビリティ/タッチターゲット |
| AI実装 | [400_ai_engineering.md](../ja/400_ai_engineering.md) | オンデバイスAI/エッジML |
| QA・テスト | [700_qa_testing.md](../ja/700_qa_testing.md) | テストピラミッド/E2E |
| エンジニアリング全般 | [300_engineering_standards.md](../ja/300_engineering_standards.md) | CI/CD/コーディング規約 |
| 法務・プライバシー | [601_data_governance.md](../ja/601_data_governance.md) | GDPR/Privacy Manifest/EU CRA |
| ライセンス管理 | [602_oss_compliance.md](../ja/602_oss_compliance.md) | SBOM/依存関係管理 |
| SRE・信頼性 | [502_site_reliability.md](../ja/502_site_reliability.md) | 可観測性/SLO/Green SRE |
| 分析インテリジェンス | [401_data_analytics.md](../ja/401_data_analytics.md) | OTel Mobile/モバイル分析 |
| 言語プロトコル | [802_language_protocol.md](../ja/802_language_protocol.md) | モバイル固有言語プロトコル |
| グローバル展開 | [800_internationalization.md](../ja/800_internationalization.md) | モバイルi18n/RTL対応 |
