# 36. ネイティブプラットフォーム (Native Platforms — Kotlin & Swift)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-07-23 | 対象: サポート中の安定版Kotlin / Swift（確認基線: Kotlin 2.4.10 / Swift 6.3、platform調査基線: Android 16 / iOS 26）

> [!IMPORTANT]
> **Primary Directive（主要方針）**
> 「ネイティブは妥協ではなく、高品質なユーザー体験へ近づくための有力な経路である。」
> クロスプラットフォームファーストの環境であっても、OS固有の深い統合・最先端AI・ハードウェアアクセスにおいてネイティブ品質を厳正に妥協しない。
> ネイティブプラットフォームの実装において、**セキュリティ > UX > パフォーマンス > 保守性 > 開発速度** の優先順位を厳守せよ。
> この文書はネイティブプラットフォーム戦略に関するすべての設計判断の最上位基準である。
> **40パート・186セクション構成。**

---

## 目次

| Part | トピック | セクション |
|------|---------|-----------| 
| I | 哲学と基本原則 | §1–§4 |
| II | Kotlin言語標準 | §5–§10 |
| III | Swift言語標準 | §11–§17 |
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

### Universal適用契約

本ファイルはKotlin、Swift、Android、Apple platformに固有の互換性と安全性を扱うが、特定projectのarchitecture、library、repository構造、組織図を全利用者へ強制しない。全節は次の優先順位で解釈する。

1. 公式platform制約、store要件、言語安全性、artifact互換性は規範要件とする。
2. architecture pattern、library、CI provider、device farm、code generation toolは参考実装であり、同等の成果と証跡を持つ代替を認める。
3. OS support幅、共有率、coverage、build時間、脆弱性SLA、review SLA、rollout率、組織人数、cadenceはBlueprint parameterとし、利用者分布、threat model、規制、service level、team規模から決める。
4. 本文の「必須」「禁止」「常に」、固定数値、固有製品名がこの契約と衝突する場合、公式constraintまたは明示した安全根拠がない限り、検証可能な成果を規範、記載手段を非規範のreference defaultとして扱う。
5. 個人・小規模teamは複数のaccountabilityを兼務できる。高保証変更では独立reviewを優先し、分離できない場合はrisk acceptanceと独立したrelease統制を置く。大規模組織は同じ責務を専門functionへ分離できる。

### §1. Primary Directive — ネイティブ・エクセレンス

- **原則**: ネイティブ開発はクロスプラットフォームの補助ではなく、ユーザー体験の最高水準を達成する手段
- **優先順位**: セキュリティ > UX > パフォーマンス > 保守性 > 開発速度
- **品質成果**: OS固有API・ハードウェア統合では、UX、安全性、性能、回復性を測定可能なacceptance criteriaで保証する。「100%」のように測定不能な表現を合格条件にしない
- **サポート版**: productionは公式support window内の安定版をexact pinする。最新安定版は新規採用の第一候補だが、OS、SDK、library、enterprise supportとの互換性を先に検証する。非推奨APIの新規使用は、代替不能理由と移行条件がある場合だけ期限付きで認める
- **Platform Conventions First**: 各プラットフォームのHIG/Material Design Guidelinesに完全準拠。プラットフォーム間でUXパターンを無理に統一しない
- **Privacy by Design**: ユーザーデータの収集は最小限に留め、オンデバイス処理を最優先する

### §2. プラットフォーム選択マトリクス

| ユースケース | 推奨アプローチ | 理由 |
|---|---|---|
| ビジネスロジック共有 | KMP (`commonMain`)を評価 | 重複削減とplatform fidelityを実測。共有率は目的ではない |
| UI集約型アプリ | Compose Multiplatform | iOS安定版到達、開発効率最大化 |
| OS深層統合（HealthKit, NFC等） | プラットフォーム固有ネイティブ | API制約・HW依存 |
| 高性能リアルタイム処理 | ネイティブ（Kotlin/Swift） | レイテンシ最小化 |
| ウィジェット / App Clips / Dynamic Island | プラットフォーム固有ネイティブ | OS要件 |
| オンデバイスAI | Core ML / ML Kit + ネイティブ | ハードウェアアクセラレータ最適化 |
| visionOS / Spatial Computing | SwiftUI + RealityKit | Apple専用エコシステム |
| Android XR / Immersive | Jetpack XR + ARCore | Google XRエコシステム |
| 組込みシステム / IoT | Kotlin/Native / Embedded Swift | 低レベルHW制御 |

### §3. アーキテクチャ原則

- **責務分離**: Domain / Data / Presentation等の境界を、変更理由、testability、dependency directionから設計する。Clean Architectureの3層は参考patternであり固定構造ではない
- **Dependency Inversion**: 上位レイヤーが下位レイヤーの具象に依存してはならない
- **Single Source of Truth (SSOT)**: 各状態domainのauthoritative sourceを明示する。offline-firstではlocal DBが候補だが、Room／SwiftDataやlocal-firstを全systemへ強制しない
- **State Flow**: 状態更新のowner、direction、side effect、concurrencyを予測可能にする。UDF、MVI、TCAは参考patternである
- **Module Boundary**: codebase規模、変更頻度、ownership、build graphに基づきmodule境界を設計する。feature moduleは選択肢であり、過剰分割を避ける
- **Composition over Inheritance**: 継承より合成を優先。プロトコル/インターフェース指向設計
- **Defensive Programming**: 全外部入力を疑い、境界でのバリデーションを徹底

### §4. バージョニング戦略

- **Minimum OS**: Android `minSdk`とApple deployment targetは、利用者分布、security update、必要API、法令、support費用からBlueprintで決める。`minSdk = 28`、iOS 16は2026-07-23時点の参考基線である
- **Target SDK**: store policyと公式期限を満たし、採用toolchainで検証済みのtarget SDKを使う。Android 16／API 36と最新Apple SDKは2026-07-23時点の確認例であり固定値ではない
- **言語バージョン**: productionはサポート中の安定版をexact pinする。2026-07-23の確認基線はKotlin 2.4.10とSwift 6.3。platformやvendor制約で旧版を使う場合はsupport window、owner、移行期限、互換性testをADRへ記録する
- **Android toolchain互換性**: Kotlin、AGP、D8、R8、JDK、Compose compilerの互換性行列を公式資料で確認し、言語版だけを単独更新しない
- **非推奨API SLA**: removal予定、security impact、利用箇所、代替成熟度から移行期限を決める。2 release cycleは参考既定である
- **OS対応方針**: 利用者分布、vendor security support、必要機能、test capacityからsupport matrixを定め、最低support OSと現行OSを検証する
- **依存関係更新**: exploitability、KEV／EPSS、data感度、exposure、補償統制からrisk-based SLAを定める。72時間と21日待機は参考値、Renovate／Dependabotは実装例である

---

## Part II: Kotlin言語標準

### §5. Kotlin 2.2以降の主要言語機能

- **Guard Conditions（安定版）**: `when`式内のガード条件で条件分岐の可読性を向上
- **Non-local break/continue（安定版）**: インライン関数ラムダ内での`break`/`continue`を活用
- **Multi-dollar interpolation（安定版）**: `$`リテラルを多用する文字列のエスケープ簡素化
- **Context Parameters（Kotlin 2.4で安定版）**: コンテキスト依存の依存性管理を簡素化。Context Receiversの後継。明示context argumentとcallable referenceは別の実験機能として扱う
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

// ✅ Good: Context Parameters (Stable in Kotlin 2.4)
context(logger: Logger, db: Database)
fun processOrder(order: Order): Result<Receipt> {
    logger.info("Processing order: ${order.id}")
    return runCatching { db.save(order.toEntity()) }
        .map { Receipt(order.id, it.timestamp) }
}
```

### §6. Kotlin 2.2.20から2.4系への進化

- **2.2.20の移行基盤**: Kotlin/Wasm Beta、`js`／`wasmJs`共有source set、LongからBigIntへのJS変換、Xcode 26対応を導入したreleaseとして扱う
- **2.4の安定化**: context parameters、explicit backing fields、共通標準libraryのUUID API、Kotlin/Wasm incremental compilationがstableになったため、旧preview opt-inを惰性で残さない
- **JVM / Java境界**: Java 26 bytecode、Maven Toolchains、Java／JVM target alignmentを利用できる。採用JDKとconsumer support matrixを先に定義する
- **Kotlin/Native**: Swift Exportは2.4でAlphaとなり、Swift package importとconcurrency mappingが改善したが、production採用は互換性matrix、fallback、生成API差分testを必要とする
- **Kotlin/Wasm**: WebAssembly Component Modelはexperimentalである。browser／WASI／FaaSを同一runtimeとして扱わず、host capabilityとsecurity境界を分離する
- **互換性**: Kotlin 2.4でK1は非対応となる。compiler plugin、KSP／kapt processor、Gradle、AGP、D8／R8、Composeを一つのupgrade PRで検証する

### §7. K2コンパイラ

- **必須有効化**: K2コンパイラを使用する。Kotlin 2.4ではK1が非対応のため、旧資産の互換modeにはowner、期限、compiler plugin互換testを必須とする
- **ビルド速度**: K2の改善値を自projectのclean／incremental build、cache hit、CI runnerで実測する。公開benchmarkは採用根拠の一部であり、個別buildの改善率を保証しない
- **型推論改善**: 統合データ構造による精度の高い型推論・呼び出し解決
- **マルチプラットフォーム一貫性**: JVM/JS/Nativeで同一のコンパイル挙動を保証
- **KAPT→KSP移行**: 新規processorは対応可能ならKSPを既定とする。既存kaptはprocessor互換性を確認し、blocker、owner、期限、generated API差分testを持つ段階移行にする

```kotlin
// build.gradle.kts — K2 + KSP設定
plugins {
    id("com.google.devtools.ksp") version "<pinned-compatible-version>"
}

kotlin {
    compilerOptions {
        allWarningsAsErrors.set(true)
    }
}
```

Kotlin 2.4ではcontext parametersに旧preview flagを付けない。明示context argument等の実験機能を使う場合だけ、該当する個別opt-inを台帳化する。

### §8. Null安全と型安全

- **`!!`演算子禁止**: 強制アンラップは例外なく禁止。`?.`、`?:`、`let`を使う
- **`requireNotNull`/`checkNotNull`**: プログラムエラーのアサートに限定使用
- **Result型**: 失敗する可能性のある操作には`kotlin.Result`またはカスタムSealed classを使用
- **データクラス**: DTO・値オブジェクトには`data class`。ボイラープレートを排除
- **不変性優先**: `val` > `var`、`List` > `MutableList`、`Map` > `MutableMap`
- **Sealed階層**: 閉じた状態集合やerror taxonomyにはSealed class／interfaceを優先し、開放拡張が必要なcontractではinterface等を選んで未知値と互換性をtestする
- **Value class**: 型の意味的区別に`@JvmInline value class`を活用（UserId, Email等）

### §9. コードスタイルとリンター

- **スタイルガイド**: [Android Kotlin Style Guide](https://developer.android.com/kotlin/style-guide) 厳守
- **formatter／lint**: ktlint、detektまたは同等手段をpinして変更gateで実行し、抑制には理由、scope、owner、期限を持たせる。Pull Requestはgate実装の一例である
- **detekt**: 静的解析でComplexity, Naming, Performanceを自動検証。カスタムルールセット推奨
- **命名規約**: `lowerCamelCase`基本、定数`UPPER_SNAKE_CASE`、パッケージ`lowercase`
- **関数複雑性**: 行数、分岐、責務、nesting、testabilityで判断する。30行はreviewを促す参考ヒューリスティックであり固定適合閾値ではない
- **拡張関数**: ユーティリティコードは拡張関数で整理。レシーバの型スコープを限定
- **スコープ関数使い分け**:
  - `let`: null安全チェーン / 変数スコープ限定
  - `apply`: オブジェクト初期化設定
  - `also`: サイドエフェクト（ロギング等）
  - `run`: レシーバのコンテキスト内で処理実行
  - `with`: 非nullオブジェクトに対する複数操作

### §10. Kotlinネイティブ・Wasm

- **Kotlin/Native**: Kotlin 2.4ではLLVM 21ベース。CMS GCが既定であることを前提にpause、throughput、peak memoryを実機計測する
- **スタックカナリア**: リリースバイナリにスタックカナリアを有効化（バッファオーバーフロー検知）
- **バイナリサイズ**: リリースビルドの最適化によるバイナリサイズ削減
- **Kotlin/Wasm（Beta）**: Web対象はBeta到達。Binaryen設定のプロジェクト単位カスタマイズ対応
- **共有ソースセット**: `js`と`wasmJs`ターゲット間の共有ソースセットを活用
- **Type-safe builders**: Kotlin DSLパターンでドメイン固有構成を型安全に構築

---

## Part III: Swift言語標準

### §11. Swift 6.2 Approachable Concurrency

- **デフォルトactor isolation**: Swift 6.2ではmodule／targetを`MainActor`既定にできる。build settingを記録し、publicまたはmodule間の契約が曖昧になる境界には明示的annotationを付ける。全script、package、UI周辺functionが同じisolationだと仮定しない
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

- **Strict Concurrency**: Swift 6の本番moduleでcomplete checkingを有効化し、移行警告はownerと期限を持つ限定例外で処理する。データ競合検証を黙って無効化しない
- **`Sendable`プロトコル**: スレッド間共有型は`Sendable`準拠必須
- **Actor分離**: isolationとreentrancy modelが適合する共有可変状態ではactorを優先する。lock、atomic等は、invariant、ownership、testを記録した測定済みlow-level境界で引き続き使用できる
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
- **値／参照semantics**: 独立valueには`struct`、identity、共有lifetime、参照semanticsには`class`またはactorを選ぶ。一律の型順位ではなくmutabilityとisolationを記録する
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
- **バージョン解決**: app／実行rootは`Package.resolved`をcommitし、導入版と同じ解決をCIで検証する。公開packageの`Package.resolved`はconsumer解決をpinしないため、宣言constraint、固定したCI test／release解決、最低・最高support範囲、必要ならlock済みexample appで互換性を保証する
- **依存関係最小化**: パッケージ依存は必要最小限。OpenSSF Scorecardによる評価推奨

### §16. コードスタイルとリンター

- **formatter／lint**: SwiftLint、SwiftFormatまたは同等手段をpinして変更gateへ統合し、抑制には理由、scope、owner、期限を持たせる。Pull Requestはgate実装の一例である
- **命名規約**: Apple Swift API Design Guidelinesに厳密準拠
- **trailing comma**: Swift 6.1で各種リストにtrailing commaをサポート。有効化推奨
- **ドキュメントコメント**: `///`で公開APIに必ず付与

### §17. Swift 6.3・クロスプラットフォーム・Embedded Swift

- **WebAssembly公式サポート（Swift 6.2）**: ブラウザ・サーバーレスランタイム対象のコンパイル
- **Embedded Swift**: 組込みシステム向けSwift。IoT/自動車領域
- **C++相互運用強化（Swift 6.2）**: C++プロジェクトとのシームレスな連携
- **Swift 6.3 C相互運用**: `@c`と`@implementation`でC ABI境界を明示し、header生成、ownership、error、allocation、ABI互換性をtestする
- **Swift SDK for Android**: Swift 6.3で公式releaseとなったが、Kotlin／JavaとのJNI境界、Android toolchain、binary size、debug、on-call能力を採用ADRで実証する。既定mobile stackを自動的に置換しない
- **Swift Build統合**: Swift Package Manager統合はpreviewとして隔離し、production build system変更はreproducibility、cache、plugin、CI parityを実測してから採用する
- **Subprocessパッケージ**: Swiftから直接サブプロセスを起動・管理
- **VS Code拡張**: バックグラウンドインデキシング、LLDB統合、DocCライブプレビュー

---

## Part IV: Android アーキテクチャ

### §18. Jetpackライブラリスタック

- **BOM管理**: `androidx.compose:compose-bom`でCompose依存を統一バージョン管理
- **能力別library選定**: UI、design system、navigation、lifecycle、DI、persistence、settings、background workに必要な能力を明示し、Compose、Material、Hilt、Room、DataStore、WorkManager等から適合するものだけを採用する
- **依存version正本**: version catalog、platform／BOM、lock、集中管理plugin等から、選択したbuild構成に合う一つの解決正本を持つ。`libs.versions.toml`は実装例である
- **型安全Navigation**: route contractを型またはschemaで検証し、文字列の暗黙契約を避ける。Compose Navigationの型安全APIは実装例である

```kotlin
// libs.versions.toml
[versions]
compose-bom = "2025.12.00"
kotlin = "<pinned-supported-version>"
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

### §21. Dependency Injection

- **選定基準**: object lifecycle、scope、startup、code generation、KMP互換性、test substitution、debuggabilityからDI手段を選ぶ。Hilt、Koin、compile-time DI、明示的manual compositionはいずれも適合し得る
- **境界**: ViewModel、service、repository等の生成責任とscopeをcomposition rootへ集約し、service locatorの暗黙依存を避ける
- **Module分割**: dependency graphの変更理由とownershipに沿ってmoduleを分ける。feature単位を一律に強制しない
- **Test substitution**: production bindingをtest doubleへ安全に差し替え、scope leakと別graphの未検証を防ぐ。`@TestInstallIn`はHilt採用時の実装例である

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

### §26. Apple UIアーキテクチャ

- **UI framework選定**: deployment target、必要なplatform API、performance、accessibility、team能力が適合する場合は新規UIでSwiftUIを第一候補にする。制約がある場合はUIKit、AppKit、混合compositionも適合する
- **状態と責務の境界**: rendering、状態遷移、副作用、domain logicを分離する。`@Observable`を使うMVVM、TCA、その他の単方向patternは代替可能な実装例であり、Universalなarchitecture強制ではない
- **移行**: framework変更はscreenまたはcapability境界から導入し、相互運用、rollback、regression testを持つ。全面rewriteを強制しない
- **Preview**: feedbackを改善する範囲でSwiftUI Previewsを使うが、preview可能性は正しさの証明ではないため、unit、integration、accessibility、device testを保持する

### §27. iOS 26 固有フレームワーク統合

- **Liquid Glass**: iOS 26の新デザイン言語。ガラス質の透明・丸みを帯びたUI要素が自動適用
- **Foundation Models Framework**: オンデバイスLLM（約3Bパラメータ）へのアクセスAPI
- **HealthKit**: ヘルスデータ連携。権限要求は最小限に
- **StoreKit 2**: アプリ内課金。`Product`/`Transaction` APIを使用
- **PhotosUI**: `PhotosPicker`でシステムフォトピッカーを使用
- **WebView（SwiftUI）**: SwiftUIネイティブの`WebView`コンポーネント（iOS 26新規）

### §28. Privacy ManifestとRequired Reason API

- **適用判定**: 現行Apple policyがapp、組み込みSDK、収集data、tracking、Required Reason API利用に対して要求する場合に`PrivacyInfo.xcprivacy`を生成・検証する。SDKとstore policyの変更ごとに再判定する
- **Required Reason API**: UserDefaults、file timestamp、system boot time、disk space等を棚卸しし、実際の挙動と一致する承認済み理由だけを宣言する
- **Tracking DomainとData**: tracking domainと収集data宣言をruntime挙動、consent、App Store privacy details、third-party SDKと一致させる
- **サードパーティSDK**: 組み込みSDKに必要なmanifestと署名を検証する。不適合SDKは更新、置換、または期限付き例外とし、全SDKへ同じmanifest義務があると仮定しない

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

### §31. Deployment Target決定契約

deployment targetはBlueprint parameterであり、固定OS版をUniversalな適合条件にしない。各targetは利用者分布、vendor security support、必要API、store期限、hardware制約、test capacity、法令・契約、support費用から決め、根拠の取得日と見直し条件を記録する。

| Target | 主な決定根拠 | 必須検証 |
|--------|-------------|----------|
| iOS / iPadOS | active device分布、security update、必要SDK／API、enterprise fleet | 最小support OS、現行OS、upgrade install、保存data移行、accessibility |
| macOS | hardware／OS fleet、distribution方式、sandbox／entitlement、必要framework | 最小・現行OS、Intel／Apple silicon適用範囲、署名・notarization、upgrade |
| watchOS | paired iPhone条件、sensor／background API、利用device | 対応pair、最小・現行OS、通信断、battery、accessibility |
| tvOS | remote入力、media／DRM、利用device世代 | 最小・現行OS、focus、network、media playback |
| visionOS | 対象利用者、device availability、spatial API、代替experience | 実機または妥当な検証環境、safety、comfort、fallback、performance |

2026-07-23時点の検討例としてiOS 16、macOS 13、watchOS 9、tvOS 16、visionOS 1があり得るが、これらを既定support範囲またはcoverage保証として再利用しない。release計画ごとに公式dataと自組織のtelemetryで再判定する。

### §32. Xcode設定基準

- **Strict Concurrency Checking**: `Complete`に設定
- **Swift 6 Language Mode**: 有効化
- **Build Settings**: `SWIFT_STRICT_CONCURRENCY = complete`
- **Warnings as Errors**: `-warnings-as-errors`を有効化
- **Code Signing**: credentialを最小権限で保護し、再現可能な自動署名または統制された署名手順と監査証跡を持つ。Xcode Cloud／Fastlaneは実装例である

### §33. Observations・Reactive Patterns

- **`Observations` async sequences（Swift 6.2）**: Observable型のトランザクショナルな状態変更をストリーミング
- **UIKit統合（iOS 26+）**: UIKitがSwift Observationを自動統合。`layoutSubviews`等で自動追跡
- **Observation選定**: stateとeventのsemantics、deployment target、backpressure、cancellation、相互運用からObservation、`Observations`、Combine、`AsyncSequence`を選ぶ。移行には測定可能な利点と互換計画を要求する

---

## Part VI: KMP / Kotlin Multiplatform

### §34. KMPアーキテクチャ設計

- **`commonMain`適正化**: business logic、data、domain modelは、platform差分を隠蔽せず保守性とtestabilityが改善する範囲で共有する。共有率をKPIにしない
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

### §36. Swift Export（Alpha／段階導入）

- **Swift Export**: Kotlin 2.4でAlpha。structured concurrencyと`Flow`から`AsyncSequence`へのmappingが改善したが、productionの既定またはObjective-C exportの無条件な置換とみなさない
- **Swift型マッピング**: Kotlinの型がSwiftネイティブ型に直接マッピング
- **Nullability保持**: KotlinのNull安全性がSwiftの`Optional`に正確に変換
- **採用条件**: 公開API差分、concurrency、exception、binary compatibility、Xcode／Swift matrix、Objective-C export fallbackを両言語のcontract testで検証する

### §37. KMP段階的導入戦略

1. **Phase 1**: データモデル・DTOを共有化（リスク最小）
2. **Phase 2**: ネットワーク層・リポジトリを共有化
3. **Phase 3**: ドメインロジック・UseCaseを共有化
4. **Phase 4**: UIをCompose Multiplatformで共有化（任意）
- **Team Capability**: 導入前にKMP、Swift／Kotlin境界、build、debug、incident対応の実務能力を検証する。workshopは育成手段の一例である
- **段階的移行**: 新機能からKMP化。既存コードの一括移行は禁止

### §38. KMPテスト戦略

- **`commonTest`**: 共有ロジックのテストは`commonTest`に配置
- **`androidTest` / `iosTest`**: プラットフォーム固有テストは各ソースセットに配置
- **テストランナー**: JUnit5（Android）、XCTest経由（iOS）
- **モック**: `commonMain`ではインターフェースベースでテスタブルに設計

### §39. KMPビルド最適化

- **Gradle設定**: `kotlin.mpp.stability.nowarn=true`で安定性警告を抑制
- **インクリメンタルコンパイル**: K2マルチプラットフォームインクリメンタルコンパイルを活用
- **キャッシュ**: build cacheは再現性、cache key、秘密情報、tenant分離、汚染回復を検証できる場合に使う。remote cacheは規模と費用対効果がある場合の任意強化である
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

- **適用判定**: 起動または重要flowのlatencyが重要なAndroid applicationでは、library提供profileを超えてapp固有Baseline Profileが代表deviceで実質的改善を出すか測定する
- **生成方法**: 採用時は、測定済み重要user flowをMacrobenchmark等でカバーし、profileをrelease artifactとversion対応させる
- **証跡**: 固定改善率を仮定せず、起動、frame、binary size、build costのbefore／after証跡を保持する
- **CI統合**: 対象code、toolchain、target deviceが変わったときに再生成・検証し、CIまたはreleaseの適用gateはBlueprintで決める

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

- **`async/await`**: コールバック依存の強い処理を実務上可能な範囲で `async/await` に置換。Structured Concurrencyを徹底
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
- **段階的移行**: 新規の非同期codeではSwift Concurrencyを第一候補とし、GCD／callbackを継続する境界はplatform API、latency、interop等の根拠とtestを持つ。既存移行はinventory、risk、互換性、capacityから計画する

---

## Part XI: パフォーマンス最適化

### §64. 起動時間最適化

- **Cold Start budget**: 利用device分布、OS、起動経路、UX SLOからpercentileと測定点をBlueprintで定め、release artifactで継続測定する。500msは特定productの参考budgetである
- **Android対策**: Content Providerの遅延初期化、App Startupライブラリ活用、Baseline Profiles
- **iOS対策**: `pre-main`時間の最小化、dylib最小化、Static Linkingの活用
- **測定**: platform metric、device lab、field telemetry等の相補的手段で継続監視する。Firebase App Start TraceとMetricKit `MXAppLaunchMetric`は実装例である
- **Splash Screen**: Android 12+ `SplashScreen` API / iOS Launch Storyboardで統一

### §65. メモリ管理

- **Android**: LeakCanary（デバッグ）+ StrictMode。Bitmap再利用（`BitmapPool`）
- **iOS**: Instruments Allocations/Leaks。Autoreleasepool適切な使用
- **画像管理**: Coil（Android）/ Kingfisher（iOS）でメモリキャッシュ管理
- **Large Heap回避**: `android:largeHeap="true"` は最終手段。根本的なメモリ最適化を優先
- **memory budget**: device class、OS kill policy、feature、foreground／background状態からBlueprintで定め、peak、steady state、leak、memory pressure時の回復を測定する。50MBは参考値である

### §66. レンダリングパフォーマンス

- **rendering budget**: 対象displayのrefresh rateとUX SLOからframe time、jank、long frame budgetを定める。60／120fpsを全画面へ固定せず、animation、battery、thermal、accessibilityを含めて測定する
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
- **目標**: §134のBlueprint budgetに従い、初回download、install、update sizeをartifactから測定する。大容量assetの分割・オンデマンド取得はUX、offline要件、保持費用を含めて判断する
- **R8/ProGuard**: 不要コード・リソースの自動削除
- **Asset圧縮**: 対象OSとdeviceで対応するformatから、画質、decode性能、license、accessibility、fallbackを測定して選び、不要variantを除外する
- **監視**: sizeへ影響する変更とreleaseで差分reportを生成し、budget超過を承認またはblockできる証跡にする。Pull Requestは実装例である

### §70. ハードウェアリソース監視

- **`getCpuHeadroom`/`getGpuHeadroom`（Android 16）**: ハードウェア可用性のリアルタイム監視
- **Activity/場面に応じた品質調整**: リソース逼迫時の描画品質・AI推論精度のダイナミック制御
- **Thermal State API**: デバイスの熱状態に応じた処理負荷軽減
- **用途**: ゲーム、カメラ、AR/VR、オンデバイスAI推論での活用

---

## Part XII: オンデバイスAI・エッジML

### §71. オンデバイスAI戦略

- **配置判断**: data感度、latency、offline要件、model能力、device coverage、energy、費用、法令からon-device、cloud、hybridを選ぶ。on-deviceであることだけをprivacy保証にしない
- **オフライン契約**: offlineで必要なflow、quality、fallback、同期、model availabilityを明示し、network不要を全AI機能へ一律強制しない
- **performance budget**: inference latency、model／download size、memory、battery、thermal、qualityを代表deviceと利用flowからBlueprintで定める
- **配布**: bundled、on-demand、OTA等をruntime互換性、署名、rollback、store policy、network／storage制約から選ぶ
- **hardware活用**: Neural Engine、NPU、GPU、CPU等の利用をprofileし、対応deviceでの効果とfallbackを検証する

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

次の数値は小規模interactive modelの測定開始用reference budgetであり、Universal適合閾値ではない。model、task、device、UX SLO、quality、安全性、energyからBlueprintで校正し、percentileと代表deviceを併記する。

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

- **適用判定**: capabilityごとにuser需要、data sensitivity、consistency、運用costからoffline、cache-only、read-through、online-requiredを選ぶ
- **SSOT**: data domainごとにauthoritative sourceを宣言する。local databaseはread modelまたはoffline authorityになり得るが、writeとconflict resolutionをserver、device、別systemのどれが所有するかを明示する
- **楽観的更新**: 採用時はidempotency、rollback、conflict policy、userへ見せる失敗挙動を事前定義する
- **Network State Awareness**: `ConnectivityManager`／`NWPathMonitor`等で接続状態を観測するが、reachabilityをdependency成功の証明として扱わない
- **Data ConsistencyとQueue**: domain semanticsに応じてversion check、server arbitration、CRDT、last-write-wins、merge UI等を選ぶ。offline queueは上限、必要な暗号化、migration、retry、purgeを定義する

### §80. Android データ永続化 — Room

- **選定**: Roomはstructured SQLite persistenceの実装例である。schema、query、暗号化、migration、offline要件からRoom、別database、file、preferences、または永続local storeなしを選ぶ
- **Room toolchain**: Room採用時は互換性のあるRoom、Kotlin、Gradle、KSPまたは対応processorを固定し、generated schema差分を検証する
- **Migration**: 対応可能なら自動検証できるmigrationを優先し、変換やreviewが必要な場合は明示migrationを使う。破壊的fallbackにはdata lossの明示承認が必要
- **Reactive query**: consumerがstream updateとcancellationを必要とするときだけ`Flow`、paging等のlifecycle-aware APIを公開する
- **Paging**: data量とaccess patternが正当化する場合だけ`PagingSource`、`RemoteMediator`等を採用する

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

- **secure storage**: 認証token、暗号鍵、機密dataはKeychain、Secure Enclave連携、hardware-backed keystore等からthreat modelとaccessibility要件に適合する保護領域へ保存し、backup、移行、logout、device lock時の挙動を定義する
- **`kSecAttrAccessibleWhenUnlockedThisDeviceOnly`**: デバイスロック連動のアクセス制御
- **UserDefaults**: 小さな非機密preferenceだけに使う。現行Apple policyが利用APIをRequired Reason APIに分類する場合、実際の挙動と一致する承認済み理由を宣言する
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
- **通信暗号化**: platform標準のcertificate／hostname検証を必須とし、保護対象trafficのcleartextを禁止する。TLS 1.3を優先し、platformまたはdependency互換性が必要な場合だけ、弱いalgorithmを無効化した現行support内のTLS 1.2を許可する
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
- **Root/Jailbreak検出**: threat modelに応じてintegrity／tamper signalを使う。step-up、capability制限、調査のtriggerにはできるが、server-side認証・認可の代替にしない
- **RASP**: ランタイム自己保護。改竄検知、リバースエンジニアリング防御、フッキング検出
- **コード難読化**: ProGuard/R8（Android）。iOS SwiftはABI安定性により限定的
- **デバッガ検出**: `ptrace`検知（iOS）、`Debug.isDebuggerConnected()`（Android）

### §90. ネットワークセキュリティ

- **Certificate Transparency**: 利用可能なplatform trustとCTをpublic PKIの既定証跡にするが、全threat modelでapplication identityを代替するとは限らない
- **Certificate Pinning**: 統制可能な高risk endpointでrotationとrecoveryを設計できる場合だけ採用する。SPKIを優先し、独立backup pinを用意し、TLS検証のfail-openを禁止する
- **Network Security Config（Android）**: `res/xml/network_security_config.xml`でクリアテキスト禁止
- **ATS (App Transport Security / iOS)**: デフォルト有効。例外は最小限に
- **Man-in-the-Middle防御**: 現行platform TLS検証へrisk-basedなCT、pinning、application-layer request保護を組み合わせ、各layerがどのthreatへ対応するか記録する

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
- **SQLインジェクション防止**: 文字列連結を避け、利用するDB APIのparameter binding、typed queryまたは同等の安全な構築方式を必須とする。Room／SwiftDataは実装例である
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
- **SBOM**: 消費者とtoolchainに適合するCycloneDX、SPDXまたは相互運用可能なformatで第三者依存のinventoryを生成・validateする
- **脆弱性SLA**: severityだけでなくexploitability、KEV／EPSS、exposure、data感度、補償統制から期限を定める。Critical 24時間、High 7日、Medium 30日はinternet-facingな高リスクproductの参考既定である
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

- **App Clips（iOS）**: current platformのsize、capability、invocation、privacy、distribution制約をreleaseごとに確認し、対象taskを制約内で完結させる
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

### §102. 型付きPlatform Boundary

- **型付きcontract**: DartとKotlin／Swift間のAPIはschema、生成binding、または薄い手書きadapterで型、nullability、error、thread、lifecycleを明示する
- **Pigeon**: Flutter標準ecosystemで有力なreference implementation。Pigeonを使わない場合も、contract drift test、boundary validation、互換性方針を同等に保証する
- **手書きchannel**: 生の文字列method名とunchecked castを散在させない。既存MethodChannelは一つのadapterへ隔離し、typed facadeとcontract testで保護する

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
- **型付きbridge経由**: KMP生成物をPigeonまたは同等のtyped bridgeでFlutterに公開
- **責任分界**: KMP = ドメイン/データ層、Flutter = プレゼンテーション層

### §106. React Native連携

- **専用正本**: React Native全体のarchitecture、test、CI、OTA、team governanceは`420_react_native.md`に従う
- **New Architecture**: Turbo Native Modules、Fabric Native Components、型付きCodegen specを既定とする
- **Native責務**: OS固有APIはKotlin／Swiftで実装し、JS、iOS、Androidのownerと互換性matrixを持つ
- **境界検証**: nullability、error、thread、lifecycle、cancellation、size limitをCodegen contractと両OStestで保証する

---

## Part XVII: テスト戦略

### §107. ユニットテスト

- **Kotlin**: JUnit 5 + MockK。Coroutineの時間・dispatcher制御は`kotlinx-coroutines-test`、Flowの値検証は採用時にTurbine等を役割分離して使用
- **Swift**: Swift Testing framework（`@Test`マクロ）。XCTestからの移行推奨
- **Coverage**: risk、critical path、mutation／fault detection、過去defectからtest adequacyを判断する。80%／100%は参考値であり、coverage単独をrelease gateにしない

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
- **ペネトレーションテスト**: threat model、data感度、規制、internet exposure、重要変更、過去incidentに基づきscopeとcadenceを決める。外部第三者と年次実施は高リスクproductの参考既定である
- **OWASP MASVS**: モバイルアプリセキュリティ検証基準への準拠確認

### §113. テストインフラストラクチャ

- **Device Testing**: 管理実機、device farm、Firebase Test Lab等からdevice matrixと再現性に合う手段を選ぶ
- **iOS CI**: self-hosted runner、managed CI、Xcode Cloud等から署名、simulator／device、artifact保持要件に合う手段を選ぶ
- **テストシャーディング**: 大規模テストスイートの並列実行
- **Flaky Test管理**: flaky testを自動検出し、owner、影響、隔離期限を記録する。critical release flowは隔離しない。修正SLAは頻度とimpactからBlueprintで決め、2週間は参考既定とする

### §114. Screenshot Testing

- **Android Screenshot Testing API**: Compose UIの視覚的リグレッション検出
- **Paparazzi**: ヘッドレスでComposeスクリーンショット取得。実機不要
- **Swift Snapshot Testing**: SwiftUI/UIKitビューのスナップショットテスト
- **CI統合**: PRごとにゴールデンイメージとの差分自動レポート

---

## Part XVIII: ビルド・CI/CD・リリース

### §115. ビルド最適化

- **Gradle**: Configuration CacheとBuild Cacheは互換性と再現性を検証して採用する。local／remoteの選択は規模、trust boundary、費用対効果で決める
- **Gradle 9.x**: Isolated Projects対応
- **Xcode**: DerivedData Cache活用。並列ビルド設定最適化
- **目標**: developer feedbackとrelease SLOからbuild budgetを設定し、継続測定する。full 15分、incremental 3分は参考既定である
- **Convention Plugin**: ビルド設定の共通化でbuild.gradle.kts簡素化

### §116. CI/CDパイプライン

- **5段階ゲート**: Lint → Unit Test → Integration Test → Build → Release
- **Impact-aware verification**: build／contract graphからaffected module、dependent、schema、toolchain、release artifactをtest／buildする。path／module filterだけを安全証明にせず、serialized integrationまたは定期full gateを保持する
- **Code Signing**: credential isolation、rotation、least privilege、audit trailを満たす自動化または統制手順を使う。Fastlane Match／App Store Connect APIは実装例である
- **アーティファクト管理**: APK/IPA/dSYM/mapping.txtの自動保存・バージョン紐付け

### §117. リリース管理

- **Staged Rollout**: cohort、観測時間、停止条件、rollback能力をriskと利用規模から定める。1%→5%→20%→50%→100%は参考例である
- **TestFlight（iOS）**: 内部/外部テスターへの配信。自動フィードバック収集
- **リリース判定**: crash／ANR、hang、startup、business SLIをbaselineとerror budgetに照らして判定する。0.1%／0.5%は固定Universal値ではなくBlueprintの初期参考値である
- **ホットフィックス**: 重大バグ発見時の緊急リリースフロー定義

### §118. ストアガイドライン遵守

- **App Store Review Guidelines**: 開発開始時に最新版を確認
- **Google Play Developer Policy**: 審査ポリシー変更の定期モニタリング
- **プリサブミッションチェック**: ストア固有の自動チェックリスト実行
- **メタデータ管理**: ASO（App Store Optimization）のキーワード/スクリーンショット最適化

### §119. Feature Flag運用

- **Feature Control**: local／server-side flag、Firebase Remote Config、LaunchDarkly等から、authorization、audit、offline、kill switch要件に合う手段を選ぶ
- **段階的ロールアウト**: 新機能を段階的にユーザーに公開
- **A/Bテスト**: 機能バリアントの比較実験
- **キルスイッチ**: 問題発生時の即時機能無効化

### §120. バージョニング規約

- **セマンティックバージョニング**: `MAJOR.MINOR.PATCH`
- **ビルド番号**: CI/CDで自動インクリメント。手動変更禁止
- **versionCode（Android）**: store要件どおり単調増加させる。計算式はrelease trainと上限を考慮してBlueprintで決め、`MAJOR * 10000 + MINOR * 100 + PATCH`は一例とする
- **CFBundleVersion（iOS）**: ビルド番号と連動

### §121. Gradle最新動向

- **Gradle Version Catalog**: `libs.versions.toml`での依存一元管理
- **Convention Plugins**: ビルドロジックの共通化
- **Configuration Cache**: ビルド設定のキャッシュで再構成を回避
- **Amper（実験的）**: JetBrains新構築ツール。KMPプロジェクト向け簡素化

### §122. Apple Build・Release Automation

- **CI/CD**: self-hosted runner、managed CI、Xcode Cloud等から、署名境界、device test、artifact、audit要件に合うものを選ぶ
- **Release Automation**: Fastlane等は署名、screenshot、metadata管理の実装例。credential、plugin、Ruby／Node等の推移toolchainもpinする
- **Project Generation**: Tuist等を採用する場合、生成正本、差分、version、rollbackを検証する
- **Environment Pinning**: Mise等のversion managerまたは同等手段でrelease toolchainを再現可能にする

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

- **crash analysis**: platform report、Crashlytics等のserviceまたは同等手段を選び、Android／Appleのsymbol、release、user impactへ関連付ける
- **Non-fatal errors**: action可能な非致命errorをsampling、privacy、cost policyに従って記録する
- **ProGuard/R8マッピング**: 難読化スタックトレースの自動解読
- **symbol artifact**: dSYM、R8 mapping等をrelease digestへ結び付け、採用backendが復号できるよう安全に保持・転送・検証する。Xcode自動uploadは実装例である
- **アラート基準**: crash-free、fatal、ANR／hangをbaseline、error budget、利用者影響へ結び付けてBlueprintで校正する。99.9%は初期参考値である

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
- **アラート閾値定義**: baseline、error budget、利用者影響からBlueprintで決める。次は初期参考値である:
  - クラッシュ率 > 0.1% → P1アラート
  - ANR率 > 0.5% → P1アラート
  - 起動時間 > 2s → P2アラート
  - ネットワークエラー率 > 5% → P2アラート

### §132. ログ戦略

- **構造化ログ**: JSON形式。タイムスタンプ、セッションID、ユーザーID（ハッシュ化）を含む
- **ログレベル**: 言語／platformに合うseverity、sampling、retention、remote collectionを定義する。本番buildは、統制された期限付きsupport modeで有効化する場合を除き、verboseまたは機密diagnosticを除外する
- **PII除外**: 個人情報はログに厳正に出力しない
- **ローテーション**: ログファイルサイズ上限設定。古いログの自動削除

---

## Part XXI: FinOps・コスト最適化

### §133. ビルドコスト最適化

- **CI/CD実行時間**: developer feedback SLOと費用からbuild budgetを定める。15分は共通の初期参考値である
- **キャッシュ戦略**: Gradle Build Cache / Xcode DerivedData Cache / SPMキャッシュでリビルド削減
- **テスト選択実行**: build graphのimpact analysisでfast feedbackを得つつ、riskに応じたcadenceでfull contract、compatibility、release gateを保持する
- **runner選定**: hosted／self-hosted、CPU architecture、隔離、保守、待ち時間、費用を実測し、release toolchainを再現できるrunnerを選ぶ。特定hardwareは参考実装である
- **並列ビルド**: iOS並列ビルドとテストシャーディングでwait時間最小化

### §134. ストアコスト最適化

- **App Size**: store制約、利用者のnetwork／storage分布、startup、機能価値、conversionへの影響からdownload／install／update size budgetをBlueprintで定め、release artifactで継続計測する
- **On-Demand Resources（iOS）**: 大容量アセットのオンデマンドダウンロード
- **Dynamic Feature Modules（Android）**: 機能のオンデマンドインストール
- **ASO ROI**: キーワード最適化・スクリーンショットA/Bテストの効果測定

### §135. クラウドサービスコスト

- **Managed service budget**: 採用したbackend、build、update、telemetry、device test serviceへusage／cost alertを設定する。Firebase Blazeは実装例の一つ
- **テレメトリコスト**: ログ/メトリクスの送信量を最適化。サンプリング率の適正化
- **CDN最適化**: 画像/アセットのCDN配信でオリジンサーバーコスト削減
- **APIコール最適化**: バッチリクエスト、キャッシュ活用でAPI呼び出し回数削減

### §136. デバイスファーム最適化

- **Device verification構成**: risk-based device matrixから、自社保有device、managed lab、Firebase Test Lab、別device farm、simulator、emulatorを選ぶ。単一providerを最大coverageの証明にしない
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

- **レンダリング**: interaction modeごとにtarget deviceがsupportするrefresh／frame-time budgetを満たし、production相当buildでdropped frame、latency、thermal state、motion comfortを測る。RealityKitはplatform実装例の一つ
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

- **watchOS UI**: support対象の新規UIではSwiftUIを優先し、legacy WatchKitはdeployment target、API availability、regression risk、product roadmapに従い維持または移行する
- **WidgetKit**: watchOSウィジェット/コンプリケーション
- **HealthKit**: 心拍数、ワークアウト、睡眠データの取得・記録
- **WCSession**: iPhone↔Apple Watch間通信。ファイル転送/メッセージング
- **Always On Display**: 常時表示対応。`TimelineView`で低頻度更新

### §142. ウェアラブルUX原則

- **グランスアブル**: 簡潔な情報とprogressive disclosureを優先するが、安全、法務、accessibility上必要な内容は保持する
- **Interaction budget**: urgency、motor constraint、connectivity、device contextからscenario別の完了時間とstep数を決める。2秒は単純なglanceable actionの参考heuristicであり、Universal上限ではない
- **コンテキストアウェア**: 時間/場所/活動に応じたプロアクティブ情報提示
- **ハプティック**: 重要通知は触覚フィードバックで伝達

---

## Part XXIV: Android XR・Immersive

### §143. Android XR プラットフォーム

- **Jetpack XR**: AndroidのAR/VRアプリ向けフレームワーク
- **ARCore**: 環境認識・平面検出・オクルージョン
- **Compose for XR**: Compose構文で空間UIを構築
- **クロスデバイス**: スマートフォン/タブレット/ヘッドセットの統合体験設計
- **パフォーマンス**: deviceとinteraction modeごとのsupported refresh／latency budgetを目標にし、代表deviceのprofileとthermal証跡を持つ

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

次の数値は測定開始用のreference budgetであり、device、workload、利用時間、business SLOに合わせてBlueprintで校正する。

| 指標 | 目標値 | 測定方法 |
|------|-------|---------|
| バックグラウンドバッテリー消費 | < 1%/時間 | Battery Historian / Energy Log |
| ネットワークバッテリー消費 | < 0.5%/API呼び出し | Energy Profiler |
| CI/CDビルドエネルギー | < 0.5 kWh/ビルド | SCI計測 |
| アイドル時CPU使用率 | < 1% | Instruments / Profiler |

---

## Part XXVI: プライバシー・コンプライアンス

### §148. Privacy Manifest深化（iOS）

- **Required Reason API**: 現行Apple listを棚卸しし、実際に使用するAPIだけ承認済み理由を宣言する。generated codeとthird-party codeも同じinventoryで検証する
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
- **Global Privacy Laws**: 提供地域、事業者区分、data主体、処理目的、越境移転、契約から適用法を判定し、現行公式文と法務判断へ追跡可能にする
- **地域法令**: GDPR、CCPA／CPRA、日本の個人情報保護法等は名称だけで適用を推定せず、適用範囲、権利、通知、保持、processor／controller責務を確認する
- **Cyber Resilience Act等**: 対象製品と事業者に該当する場合、現行の適用時期、SBOM、脆弱性処理・報告、support期間等の義務を公式文で確認する
- **児童・年少者保護**: COPPAその他の適用法、年齢確認方式、保護者同意、store categoryから対象年齢と追加統制を決める。13歳を世界共通閾値にしない
- **レビュー**: privacy noticeとstore disclosureを実際の処理へ一致させ、data flow、SDK、地域、法令、store policyの変更時とrisk-based cadenceで再確認する

### §151. 権限管理ベストプラクティス

- **Just-in-Time**: 権限要求は使用直前の文脈で実施
- **Pre-Permission Pattern**: システムダイアログ前に価値説明画面を表示
- **Graceful Degradation**: 権限拒否時も代替UIで機能を提供
- **権限棚卸し**: OS、SDK、機能、threat model、store policyの変更時とBlueprintのrisk-based cadenceで、使用権限の必要性を再検証する。半年ごとは参考例である

### §152. EAAその他のアクセシビリティ法令

- **適用判定**: 提供市場、製品・service区分、事業者区分、例外、移行措置を現行公式文と法務判断で確認し、単にEU向けという理由だけで適用範囲を断定しない
- **適合証跡**: 適用される宣言、技術文書、support、監視、是正、記録保持をrelease artifactと結び付ける
- **技術基準**: WCAG 2.2 AAを有力なengineering baselineとしつつ、適用法、harmonised standard、platform要件が指定する正確な基準と版を確認する
- **当事者テスト**: 法的義務の有無だけでなく、主要flowと重大riskに応じて障害当事者を含む検証を計画し、自動検査だけで適合を断定しない

---

## Part XXVII: チーム・組織設計

### §153. Mobile Platform機能

- **Platform Function**: CI/CD、design system、network、toolchain、release等の共通責務を、個人の役割、shared responsibility、virtual group、専任teamから規模に合う形で担う
- **Product Ownership**: 機能またはproductのownerがAndroid／Apple platform双方の利用者成果とSLOへaccountableになる。組織図は固定しない
- **Code Ownership**: CODEOWNERS、ownership registryまたは同等機構でreview責任と継続経路を明確化する
- **Architecture Review**: 影響範囲、不可逆性、安全性、cross-platform境界に応じた設計reviewを行う。全変更へ同じ会議を強制しない

### §154. 知識共有・育成

- **Tech Radar**: チーム内技術レーダーでAdopt/Trial/Assess/Holdを管理
- **モブプログラミング**: 複雑な実装はモブプロで知識共有
- **RFCプロセス**: 大規模変更時はRFC（Request for Comments）を作成
- **KMP育成**: Swiftエンジニア向けKotlin研修、Kotlinエンジニア向けSwift研修の相互実施

### §155. コードレビュー基準

- **レビューチェックリスト**: セキュリティ、パフォーマンス、アクセシビリティ、テストカバレッジの4観点
- **Change Size**: review可能性、rollback、生成物、機械変更を考慮して変更を分割する。400行は参考heuristicであり合否基準にしない
- **Review SLA**: delivery risk、team timezone、incident優先度からBlueprintで設定する。24時間は共同開発teamの参考既定である
- **自動チェック**: 適用対象のLint／Format／Test等を変更受入条件とする。PR／mergeはVCS上の実装例である

---

## Part XXVIII: マイグレーション戦略

### §156. UIKit → SwiftUI 移行

- **段階的移行**: 新規画面でSwiftUIを第一候補として評価し、OS support、既存architecture、必要API、team能力、test可能性が適合する範囲から`UIHostingController`等で段階導入する
- **共存期間**: UIKit／SwiftUI共存期間はinventory、risk、delivery capacity、OS supportから計画する。2〜3年は大規模legacy移行の参考例である
- **データフロー統合**: 既存契約との境界、状態owner、lifecycle、concurrencyを定義し、`@Observable`は適合する場合の実装例とする
- **テスト戦略**: 移行後の画面はunit、integration、accessibility、snapshot／visual regression等からriskに合う組合せで退行を検出する。Previewだけを合格条件にしない

### §157. View → Compose / Java → Kotlin 移行

- **Compose移行**: 新規画面でComposeを第一候補として評価し、OS、既存View、library、performance、accessibility、team能力が適合する範囲から`AndroidView`／`ComposeView`等で段階導入する
- **Java→Kotlin**: 新規Android codeはKotlinを第一候補とする。Java継続は既存API、生成code、toolchain、vendor support等の根拠を記録し、移行対象は自動変換だけに依存せずnullability、concurrency、behaviorをtestする
- **Interop**: `ComposeView`（XML内にCompose）/ `AndroidView`（Compose内にView）の双方向統合
- **移行メトリクス**: 言語・UI移行率だけでなく、defect、build時間、performance、accessibility、保守性をquery可能なreport、dashboardまたは同等証跡で追跡する

### §158. 移行のROI計測

- **メトリクス**: コード行数削減率、バグ密度変化、ビルド時間変化、開発速度変化
- **段階的検証**: 各移行フェーズ完了後にROI計測。効果が低い場合は計画見直し
- **移行テスト**: A/Bテストで旧画面と新画面のUXメトリクス比較

---

## Part XXIX: デザインシステム連携

### §159. Material Design 3 / Material 3 Expressive

- **Material 3**: current Android guidanceと採用targetに照らしてDynamic Color、typography、motion、component behaviorを評価する
- **Material 3 Expressive**: 採用する場合は対応library／OS、brand、accessibility、performance、既存UIとの互換性を検証する。年号だけを採用根拠にしない
- **Design Tokens**: design toolを固定せず、version管理したtoken正本から`MaterialTheme`等のplatform表現へ再現可能に変換する
- **カスタムコンポーネント**: brandとproduct要件を満たしつつ、platform convention、accessibility、状態、test契約を保持する

### §160. Human Interface Guidelines (HIG)

- **HIG整合**: 対象Apple platformのcurrent HIGとOS behaviorへ整合し、意図的な差異はUX、安全性、accessibilityの根拠を記録する
- **Symbols**: SF Symbols等のplatform assetを優先評価し、custom symbolはlicense、意味、localization、accessibility、描画互換性を検証する
- **Typography**: platform typographyとDynamic Typeを尊重し、custom fontは可読性、fallback、license、download sizeを検証する
- **Spacing/Layout**: 固定gridをUniversal要件にせず、Safe Area、window size、input、Dynamic Type、platform conventionに対応するtokenとlayout contractを定義する

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

- **Kotlin/Native**: Kotlin 2.4ではLLVM 21ベース。対象hardwareとtoolchainの正式supportを個別確認する
- **C相互運用**: `cinterop`でCライブラリを直接呼び出し
- **メモリ管理**: CMS GCが既定。hard real-timeの予測可能性を仮定せず、pause、allocation、memory上限を対象hardwareで測定する
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
- **Protocol Buffers**: schema、生成code、binary互換性が適合する場合の選択肢。payload size、CPU、memory、debuggabilityを実workloadでJSON等の代替と比較し、固定削減率を仮定しない
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

- **Android／KMP依存**: version catalog、platform／BOM、dependency lock、中央管理plugin等からbuildに合う解決正本を一つ定義する
- **Apple依存**: SPM、CocoaPods、binary framework等の採用形態ごとに、version、source、checksum／signature、transitive dependency、support責任を固定・検証する。package manager名だけで移行を強制しない
- **自動更新**: Renovate、Dependabotまたは同等手段で更新候補を作り、risk-based SLAと互換性testで受け入れる。72時間は高緊急度patchの参考値である
- **脆弱性検査**: OSV、ecosystem advisory、SCA service等の相補的sourceを使い、検出結果をreachability、KEV／EPSS、exposure、補償統制でtriageする

### §174. SBOM (Software Bill of Materials)

- **format**: 消費者、regulator、toolchainに応じてCycloneDX、SPDXまたは相互運用可能なformatを選び、schema versionと生成toolをpinしてvalidateする
- **法令・契約**: CRAその他の適用法または顧客契約が要求する場合、対象、時期、format、提供、保持、脆弱性処理の正確な義務を現行公式文で確認する
- **ライセンス監査**: 全依存関係のライセンス互換性チェック
- **脆弱性トラッキング**: SBOMベースの継続的脆弱性モニタリング

---

## Part XXXV: エラーハンドリング戦略

### §175. Kotlin エラーハンドリング

- **Result型**: `kotlin.Result`またはカスタムSealed classでエラーを型安全に表現
- **runCatching**: 同期境界で失敗を値として返す場合だけ使用する。`Throwable`を捕捉するため、suspend処理では`CancellationException`を必ず再throwし、無条件にtry-catchの代替にしない
- **例外階層**: ビジネス例外 vs 技術例外を明確に分離
- **Coroutine例外**: structured concurrencyを既定とし、`CoroutineExceptionHandler`はroot coroutineの未処理例外の最終観測に限定する。独立失敗が必要な境界だけ`supervisorScope`を使い、cancellationを握り潰さない

### §176. Swift エラーハンドリング

- **Typed Throws（Swift 6）**: エラー型を関数シグネチャで明示
- **Result型**: `Result<Success, Failure>`でエラーを値として扱う
- **guard early return**: 早期リターンパターンで可読性向上
- **do-catch**: リカバリ可能なエラーの処理。catch節は具体的に
- **Never型**: 失敗しないフォールバックの型安全な表現

---

## Part XXXVI: コード生成・メタプログラミング

### §177. Kotlin コード生成

- **KSP (Kotlin Symbol Processing)**: 対応済みK2 workloadで優先するprocessor API。固定倍率を仮定せず、採用projectのclean／incremental build効果を測定する
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

- **選択可能な支援**: GitHub Copilot、Gemini Code Assist、その他のassistantは任意の実装例であり、導入しないprojectも適合する。採用時はdata boundary、retention、license、access control、model changeを評価する
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

- **App Store Review Guidelines**: release計画時とpolicy変更時にcurrent版、発効日、対象地域を確認し、確認日と影響を記録する
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
| L3 | Managed | 両OSのCI/CD、リスクベースの多層test、アクセシビリティ、owner、dependency更新運用がある |
| L4 | Optimized | 実測performance budget、device matrix、統合SBOM、段階配信、互換性とupgrade lead timeを継続管理する |
| L5 | Adaptive | SLOと実利用dataに基づきnative／shared境界、toolchain、依存、release統制を継続改善し、統制証跡を自動生成する |

### §184. アンチパターン30選

| # | アンチパターン | 正しい対応 |
|---|-------------|-----------| 
| 1 | `!!`演算子の多用 | `?.`, `?:`, `let`で安全にハンドリング |
| 2 | API Keyのハードコード | Keystore/Keychain + CI Secrets |
| 3 | メインスレッドでのI/O | `Dispatchers.IO` / `Task.detached` |
| 4 | 生のMethodChannelを各所へ散在 | Pigeonまたは同等のtyped adapterへ隔離しcontract test |
| 5 | SharedPreferencesに機密データ | EncryptedSharedPreferences/Keychain |
| 6 | ARC循環参照の放置 | `[weak self]`の適切な使用 |
| 7 | 全画面再Composition | 粒度の細かい状態管理・State読み取り遅延 |
| 8 | risk-basedなtest layerなしでrelease | 適用対象のstatic、unit、integration、UI、device、non-functional証跡を要求 |
| 9 | a11y対応の後回し | Day 1からアクセシビリティ設計 |
| 10 | 非推奨API使用 | Coroutines/async-await/最新API |
| 11 | 起動性能／profile適用を未測定 | 重要flowを測り、証跡からBaseline Profileの採否を決める |
| 12 | 必要なprivacy宣言の欠落 | 現行policyと実挙動に従いmanifest、reason宣言、store disclosureを生成 |
| 13 | WebView JS無制限 | 最小権限 + サニタイズ |
| 14 | Root/JB検出を認可の代替にする | Play Integrity / App Attest等はrisk signalとしてserver-side認可と併用 |
| 15 | 通知権限の即時要求 | Pre-Permission Patternで価値説明後 |
| 16 | offline利用が想定されるcapabilityの失敗挙動が未定義 | cache、queue、conflict、recovery、user communicationを定義 |
| 17 | 変更理由とownerに合わないmodule境界 | build graph、cohesion、ownership、test影響から分割または統合 |
| 18 | TLS検証を無効化、または更新計画なしでPinning | platform標準TLSを必須化し、Pinningはthreat model・backup pin・安全なrotationがある高リスクAPIだけで採用 |
| 19 | バッテリー消費無配慮 | Doze/BGTaskScheduler対応 |
| 20 | ストアガイドライン未確認 | リリース前に最新ポリシー確認 |
| 21 | GlobalScope.launch | 構造化されたCoroutineScope使用 |
| 22 | KAPTを理由なく新規採用 | processor互換性を確認し、対応済み範囲はKSPへ段階移行 |
| 23 | deployment targetを無視したObservation移行 | iOS 17+範囲は`@Observable`を評価し、旧OS互換は既存方式を維持 |
| 24 | K1互換modeの無期限継続 | K2移行blocker、owner、期限、compiler plugin互換testを記録 |
| 25 | Pinning Only（CT未対応） | Certificate Transparency優先 |
| 26 | Context Receivers使用 | Context Parameters移行（Kotlin 2.2+） |
| 27 | state、event stream、非同期sequenceを一つのframeworkへ混同 | Observation、Combine、AsyncSequenceを責務とOS supportに応じて選定 |
| 28 | SBOM未生成 | CycloneDX SBOM生成でEU CRA備え |
| 29 | 実測なしの低水準最適化 | profilerとbefore／after基準を満たす箇所だけspecialized data structureを採用 |
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
- **WebAssembly Component Model成熟**: Kotlin／Swiftを含む言語間component contract、capability、sandbox、observabilityの標準化
- **Swift Value Generics**: コンパイル時定数ジェネリクスのさらなる拡張

### §186. 推奨学習パス

- **Android**: サポート中の安定版Kotlin → UI／state → dependency composition → 必要に応じKMP／AI／XR。Compose、Hilt、ML Kit等は採用stackに応じた学習例
- **iOS**: サポート中の安定版Swift → UI／state → persistence／dependency composition → 必要に応じAI／spatial computing。SwiftUI、SwiftData、Observation、Foundation Models、visionOSは採用stackに応じた学習例
- **共通**: 責務分離と境界設計 → CI/CD → セキュリティ → アクセシビリティ → 実測performance → SBOM／供給網。特定architecture patternの習得自体を目的にしない

---

## Appendix A: 逆引き索引

| キーワード | 参照セクション |
|-----------|-------------|
| Kotlin 2.4 / K2 / Context Parameters | §5–§7 |
| Kotlin 2.2.20–2.4 / Swift Export / Wasm | §6, §36 |
| Swift 6.2–6.3 / Approachable Concurrency / @concurrent / @c | §11–§17 |
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
| EU CRA / SBOM / GDPR / Global Privacy Laws | §150, §174 |
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
| モバイル開発 (Flutter) | [342_mobile_flutter.md](../engineering/400_mobile_flutter.md) | Flutter固有ベストプラクティス |
| ストア申請準拠 | [product/700_appstore_compliance.md](../product/700_appstore_compliance.md) | IAP/ASO/審査ガイドライン |
| セキュリティ | [security/000_security_privacy.md](../security/000_security_privacy.md) | Zero Trust/OWASP/暗号化 |
| デザイン・UX | [design/000_design_ux.md](../design/000_design_ux.md) | アクセシビリティ/タッチターゲット |
| AI実装 | [ai/000_ai_engineering.md](../ai/000_ai_engineering.md) | オンデバイスAI/エッジML |
| QA・テスト | [quality/000_qa_testing.md](../quality/000_qa_testing.md) | テストピラミッド/E2E |
| エンジニアリング全般 | [engineering/000_engineering_standards.md](../engineering/000_engineering_standards.md) | CI/CD/コーディング規約 |
| 法務・プライバシー | [security/100_data_governance.md](../security/100_data_governance.md) | GDPR/Privacy Manifest/EU CRA |
| ライセンス管理 | [security/200_oss_compliance.md](../security/200_oss_compliance.md) | SBOM/依存関係管理 |
| SRE・信頼性 | [operations/400_site_reliability.md](../operations/400_site_reliability.md) | 可観測性/SLO/Green SRE |
| 分析インテリジェンス | [ai/100_data_analytics.md](../ai/100_data_analytics.md) | OTel Mobile/モバイル分析 |
| 言語プロトコル | [core/200_language_protocol.md](../core/200_language_protocol.md) | モバイル固有言語プロトコル |
| グローバル展開 | [800_internationalization.md](../product/800_internationalization.md) | モバイルi18n/RTL対応 |

---

## Appendix C: 一次資料

- [NIST SP 800-218 SSDF](https://csrc.nist.gov/pubs/sp/800/218/final): 特定のSDLCやtoolへ固定しない、成果指向のsecure development practice
- [RFC 2119](https://www.rfc-editor.org/info/rfc2119) / [RFC 8174](https://www.rfc-editor.org/info/rfc8174): MUST等の規範語を相互運用性と損害防止に必要な範囲へ限定するBCP 14
- [Kotlin release process](https://kotlinlang.org/docs/releases.html) / [Kotlin 2.4](https://kotlinlang.org/docs/whatsnew24.html): current stable、support window、K1終了、KMP／Wasm更新
- [Android Kotlin compatibility](https://developer.android.com/build/kotlin-support): KotlinとAGP／D8／R8の互換性行列
- [Google Play target API要件](https://developer.android.com/google/play/requirements/target-sdk): 2026-08-31以降のAndroid 16／API 36基線とdevice category別例外
- [Swift 6.3 Released](https://www.swift.org/blog/swift-6.3-released/): `@c`、Swift SDK for Android、Swift Build integration preview
- [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/): Swift固有の公開API設計
