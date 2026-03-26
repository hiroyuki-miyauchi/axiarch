# 36. Native Platforms (Kotlin & Swift)

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-03-24 | Target: Kotlin 2.2+ / Swift 6.2+ / Android 16+ / iOS 26+

> [!IMPORTANT]
> **Supreme Directive**
> "Native is not a compromise — it is the shortest path to the best user experience."
> Even in cross-platform-first environments, never compromise on native quality for deep OS integration, cutting-edge AI, and hardware access.
> Strictly follow the priority order for native platform implementations: **Security > UX > Performance > Maintainability > Development Speed**.
> This document is the supreme standard for all design decisions regarding native platform strategy.
> **40 Parts, 186 Sections.**

---

## Table of Contents

| Part | Topic | Sections |
|------|-------|---------| 
| I | Philosophy & Fundamentals | §1–§4 |
| II | Kotlin 2.2+ Language Standards | §5–§10 |
| III | Swift 6.2+ Language Standards | §11–§17 |
| IV | Android Architecture | §18–§25 |
| V | iOS Architecture | §26–§33 |
| VI | KMP / Kotlin Multiplatform | §34–§40 |
| VII | Compose Multiplatform | §41–§44 |
| VIII | Jetpack Compose Performance | §45–§50 |
| IX | SwiftUI Best Practices | §51–§56 |
| X | Concurrency & Async | §57–§63 |
| XI | Performance Optimization | §64–§70 |
| XII | On-Device AI & Edge ML | §71–§78 |
| XIII | Offline-First & Data Persistence | §79–§85 |
| XIV | Security & App Hardening | §86–§94 |
| XV | Platform Integration & OS Features | §95–§101 |
| XVI | Flutter / Cross-Platform Integration | §102–§106 |
| XVII | Testing Strategy | §107–§114 |
| XVIII | Build, CI/CD & Release | §115–§122 |
| XIX | Accessibility | §123–§127 |
| XX | Observability & Monitoring | §128–§132 |
| XXI | FinOps & Cost Optimization | §133–§136 |
| XXII | visionOS & Spatial Computing | §137–§139 |
| XXIII | Wear OS & watchOS | §140–§142 |
| XXIV | Android XR & Immersive | §143–§144 |
| XXV | Green Engineering | §145–§147 |
| XXVI | Privacy & Compliance | §148–§152 |
| XXVII | Team & Organization Design | §153–§155 |
| XXVIII | Migration Strategy | §156–§158 |
| XXIX | Design System Integration | §159–§161 |
| XXX | Embedded Systems & IoT | §162–§164 |
| XXXI | Networking & Communication | §165–§167 |
| XXXII | Internationalization & Localization | §168–§170 |
| XXXIII | Data Transformation & Serialization | §171–§172 |
| XXXIV | Dependency Management & SBOM | §173–§174 |
| XXXV | Error Handling Strategy | §175–§176 |
| XXXVI | Code Generation & Metaprogramming | §177–§178 |
| XXXVII | AI-Assisted Development & Copilot | §179–§180 |
| XXXVIII | Store Review Optimization | §181–§182 |
| XXXIX | Maturity Model & Anti-Patterns | §183–§184 |
| XL | Future Outlook | §185–§186 |
| Appendix | Reverse Index & Cross-References | — |

---

## Part I: Philosophy & Fundamentals

### §1. Supreme Directive — Native Excellence

- **Principle**: Native development is the means to achieve the highest standard of user experience, not a supplement to cross-platform
- **Priority**: Security > UX > Performance > Maintainability > Development Speed
- **Zero Compromise**: Maintain 100% native quality in cutting-edge OS APIs and hardware integration
- **Latest Stable**: Always target the latest stable versions of Kotlin/Swift. New use of deprecated APIs is prohibited
- **Platform Conventions First**: Fully comply with each platform's HIG/Material Design Guidelines. Do not forcefully unify UX patterns across platforms
- **Privacy by Design**: Minimize user data collection and prioritize on-device processing

### §2. Platform Selection Matrix

| Use Case | Recommended Approach | Rationale |
|---|---|---|
| Business logic sharing | KMP (`commonMain`) | 85%+ code reuse rate |
| UI-intensive apps | Compose Multiplatform | iOS stable reached, maximized dev efficiency |
| Deep OS integration (HealthKit, NFC, etc.) | Platform-specific native | API constraints / HW dependency |
| High-performance real-time processing | Native (Kotlin/Swift) | Minimized latency |
| Widgets / App Clips / Dynamic Island | Platform-specific native | OS requirements |
| On-device AI | Core ML / ML Kit + Native | Hardware accelerator optimization |
| visionOS / Spatial Computing | SwiftUI + RealityKit | Apple-exclusive ecosystem |
| Android XR / Immersive | Jetpack XR + ARCore | Google XR ecosystem |
| Embedded Systems / IoT | Kotlin/Native / Embedded Swift | Low-level HW control |

### §3. Architecture Principles

- **Clean Architecture**: Strict 3-layer separation of Domain / Data / Presentation
- **Dependency Inversion**: Upper layers must not depend on concrete implementations of lower layers
- **Single Source of Truth (SSOT)**: Local DB (Room / SwiftData) is the single source of truth
- **Unidirectional Data Flow (UDF)**: MVI / TCA or similar unidirectional data flow is mandatory
- **Feature Module Architecture**: Split by feature unit for minimal build times and test scope
- **Composition over Inheritance**: Prefer composition over inheritance. Protocol/interface-oriented design
- **Defensive Programming**: Distrust all external inputs and enforce validation at boundaries

### §4. Versioning Strategy

- **Minimum SDK**: Recommend `minSdk = 28` (Android 9), iOS `deploymentTarget = 16.0` as minimum
- **Target SDK**: Always track the latest stable Android `targetSdk` (Android 16 = API 36). Build iOS with the latest SDK
- **Language Version**: Kotlin 2.2+ and Swift 6.2+ are mandatory. Enable K2 compiler by default
- **Deprecated API SLA**: APIs officially deprecated must be migrated **within 2 release cycles**
- **OS Support Policy**: Support latest OS + previous 2 generations
- **Dependency Updates**: Security patches within 72 hours; regular updates via Renovate/Dependabot with 21-day waiting period before merge

---

## Part II: Kotlin 2.2+ Language Standards

### §5. Kotlin 2.2 Language Features

- **Guard Conditions (Stable)**: Guard conditions in `when` expressions for improved readability
- **Non-local break/continue (Stable)**: Leverage `break`/`continue` inside inline function lambdas
- **Multi-dollar interpolation (Stable)**: Simplified escaping for strings with frequent `$` literals
- **Context Parameters (Preview)**: Simplified context-dependent dependency management. Successor to Context Receivers
- **Context-sensitive resolution (Preview)**: Improved enum type inference. Type name omission from context
- **`@JvmExposeBoxed`**: Improved Java interop for inline value classes
- **Base64 / HexFormat API (Stable)**: Stabilized standard library encoding APIs
- **`-Xwarning-level`**: Unified compiler warning level management option

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

### §6. Kotlin 2.2.20 Additional Features

- **Kotlin/Wasm Beta**: Web target reached Beta. Built-in browser debugging support
- **Swift Export (Default-Enabled, Experimental)**: Direct Swift mapping replacing Obj-C export
- **`js`/`wasmJs` shared source set**: Code sharing for multi-target Web
- **Kotlin/Native Xcode 26 support**: Stack canaries, release binary size reduction
- **Long→BigInt (JS)**: Long values compile to BigInt on JavaScript target
- **Stable cross-platform compilation**: Stable cross-compilation for Kotlin libraries

### §7. K2 Compiler

- **Mandatory Enablement**: Use K2 compiler by default. K1 is deprecated (deprecated in IntelliJ IDEA 2025.1)
- **Build Speed**: Average 2x compilation speed improvement. 40%+ reduction in JetBrains IntelliJ monorepo
- **Type Inference Improvement**: Unified data structure for more accurate type inference and call resolution
- **Multiplatform Consistency**: Guarantees identical compilation behavior across JVM/JS/Native
- **KAPT→KSP Migration**: Mandatory migration from KAPT to KSP (Kotlin Symbol Processing) with K2

```kotlin
// build.gradle.kts — K2 + KSP configuration
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

### §8. Null Safety & Type Safety

- **`!!` operator prohibited**: Force unwrap is prohibited without exception. Use `?.`, `?:`, `let`
- **`requireNotNull`/`checkNotNull`**: Limited to assertions for programming errors
- **Result type**: Use `kotlin.Result` or custom Sealed class for fallible operations
- **Data classes**: Use `data class` for DTOs and value objects. Eliminate boilerplate
- **Immutability first**: `val` > `var`, `List` > `MutableList`, `Map` > `MutableMap`
- **Sealed hierarchies**: Mandatory for state management and error types to guarantee `when` exhaustiveness
- **Value class**: Leverage `@JvmInline value class` for semantic type distinction (UserId, Email, etc.)

### §9. Code Style & Linters

- **Style Guide**: Strictly follow [Android Kotlin Style Guide](https://developer.android.com/kotlin/style-guide)
- **ktlint**: Mandatory in CI pipeline. PR merge gate
- **detekt**: Static analysis for Complexity, Naming, Performance. Custom rule sets recommended
- **Naming Convention**: `lowerCamelCase` base, constants `UPPER_SNAKE_CASE`, packages `lowercase`
- **Function Length Limit**: Recommended ≤ 30 lines per function. Consider refactoring when exceeded
- **Extension Functions**: Organize utility code as extension functions. Limit receiver type scope
- **Scope Function Guidelines**:
  - `let`: Null safety chaining / variable scope limitation
  - `apply`: Object initialization configuration
  - `also`: Side effects (logging, etc.)
  - `run`: Execute processing within receiver context
  - `with`: Multiple operations on non-null objects

### §10. Kotlin Native & Wasm

- **Kotlin/Native**: LLVM 19-based. Leverage memory consumption tracking and adjustment features
- **Stack Canaries**: Enable stack canaries in release binaries (buffer overflow detection)
- **Binary Size**: Release build optimizations for binary size reduction
- **Kotlin/Wasm (Beta)**: Web target reached Beta. Per-project Binaryen configuration customization
- **Shared Source Sets**: Leverage shared source sets between `js` and `wasmJs` targets
- **Type-safe builders**: Build domain-specific configurations type-safely with Kotlin DSL patterns

---

## Part III: Swift 6.2+ Language Standards

### §11. Swift 6.2 Approachable Concurrency

- **Default MainActor execution**: Scripts and UI code run on main thread by default. Explicit `@MainActor` not required
- **`@concurrent` attribute**: New attribute for explicitly specifying asynchronous execution
- **Reduced false data-race warnings**: Dramatically reduced false positives for code not heavily using concurrency
- **Predictable `async` behavior**: Async calls default to respecting the caller's Actor
- **Task Naming**: Tasks can be named for debugging and profiling purposes
- **Progressive Disclosure**: Advanced concurrency features introduced only when needed

```swift
// ✅ Good: Swift 6.2 @concurrent
@concurrent
func fetchData() async throws -> Data {
    // Explicitly runs on background
    let (data, _) = try await URLSession.shared.data(from: endpoint)
    return data
}
```

### §12. Swift 6 Strict Concurrency Foundation

- **Strict Concurrency mandatory**: Detect data races at compile time
- **`Sendable` protocol**: Types shared across threads must conform to `Sendable`
- **Actor isolation**: Use Actors for shared mutable state. Replace traditional lock mechanisms
- **`@MainActor`**: Apply to UI update logic to guarantee main thread execution
- **Structured Concurrency**: Structure async processing with `async/await` and `TaskGroup`

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

### §13. Type Safety & Protocol-Oriented Programming

- **Protocol Oriented Programming (POP)**: Prefer protocols + structs over class inheritance
- **Value types first**: `struct` > `class`. Use `class` only when reference semantics are needed
- **Opaque Types**: Use `some Protocol` to balance API boundary flexibility and type safety
- **`@Observable` macro**: Use for observable objects integrated with SwiftUI
- **Typed Throws (Swift 6)**: Type-safe error handling

```swift
// ✅ Good: Typed throws
enum NetworkError: Error, Sendable {
    case timeout, unauthorized, serverError(Int)
}

func fetchUser() throws(NetworkError) -> User {
    // Compiler prohibits throwing anything other than NetworkError
}
```

### §14. InlineArray & Memory Safety

- **`InlineArray` (Swift 6.2)**: Compile-time fixed-size arrays. Stored directly on stack without heap allocation or ARC
- **Syntax**: `InlineArray<N, Element>` or `[N of Element]` shorthand
- **Use Cases**: Optimal for performance-critical code (games, embedded, tight loops)
- **`Span` type (Swift 6.2)**: Safe direct access to contiguous memory. Compile-time prevention of use-after-free
- **Circular Reference Prevention**: Properly use `[weak self]` in closures
- **Non-Copyable Types**: Leverage `~Copyable` for resource management (file handles, etc.)
- **Strict Memory Safety**: Opt-in strict memory safety flag to detect and eliminate unsafe constructs

```swift
// ✅ Good: InlineArray (Swift 6.2) — Stack-allocated fixed-size array
let colors: InlineArray<4, Color> = [.red, .green, .blue, .white]
// Or: let colors: [4 of Color] = [.red, .green, .blue, .white]

// ✅ Good: Span type — Memory-safe direct access
func process(_ span: Span<UInt8>) {
    for byte in span {
        // Compile-time prevention of use-after-free
    }
}
```

### §15. Swift Package Manager

- **Package Traits (Swift 6.1)**: Feature adaptation based on environment (Embedded Swift, WebAssembly, etc.)
- **`@implementation` attribute**: Provide Swift implementations for Objective-C declarations. Use for gradual migration
- **Version Resolution**: Commit `Package.resolved` to guarantee reproducibility
- **Dependency Minimization**: Keep package dependencies minimal. Evaluation via OpenSSF Scorecard recommended

### §16. Code Style & Linters

- **SwiftLint**: Mandatory. Integrate into CI pipeline as PR merge gate
- **SwiftFormat**: Automatic code format unification
- **Naming Convention**: Strictly follow Apple Swift API Design Guidelines
- **Trailing comma**: Swift 6.1 supports trailing commas in various lists. Enable recommended
- **Documentation Comments**: Mandatory `///` for all public APIs

### §17. Swift WebAssembly & Embedded Swift

- **WebAssembly Official Support (Swift 6.2)**: Compilation targeting browser and serverless runtimes
- **Embedded Swift**: Swift for embedded systems. IoT/automotive domains
- **Enhanced C++ Interoperability (Swift 6.2)**: Seamless integration with C++ projects
- **Subprocess Package**: Launch and manage subprocesses directly from Swift code
- **VS Code Extension**: Background indexing, LLDB integration, DocC live preview

---

## Part IV: Android Architecture

### §18. Jetpack Library Stack

- **BOM Management**: Unify Compose dependency versions with `androidx.compose:compose-bom`
- **Required Libraries**: Compose UI, Material 3, Navigation, Lifecycle, Hilt, Room, DataStore, WorkManager
- **Gradle Version Catalog**: Centralize all dependencies in `libs.versions.toml`. Direct version declarations in `build.gradle.kts` prohibited
- **Type-safe Navigation**: Use Compose Navigation 2.8+ type-safe APIs. String routes prohibited

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

### §19. MVI Pattern (Recommended Architecture)

- **Model-View-Intent**: Strictly follow unidirectional data flow. ViewModel → State → UI → Intent → ViewModel
- **UiState**: Define states type-safely with Sealed interface
- **UiEvent**: Express user actions as Sealed class
- **SideEffect**: Deliver one-shot events (navigation, Snackbar) via Channel

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

### §20. Multi-Module Design

- **Feature Module**: Split into `:feature:xxx` modules by feature
- **Core Module**: Common utilities and design system in `:core:xxx`
- **Data Module**: Repository, API, DB implementations in `:data:xxx`
- **Domain Module**: Business logic and UseCases in `:domain`
- **Convention Plugin**: Centralize build configurations with Convention Plugins. Minimize each module's `build.gradle.kts`
- **Dependency Direction**: `feature → domain → data`. Reverse dependencies prohibited

### §21. Dependency Injection — Hilt

- **Hilt mandatory**: Hilt is the standard DI for Android. Manual DI only for prototypes
- **`@HiltViewModel`**: Unify ViewModel DI through Hilt
- **`@Module` splitting**: Distribute `@Module` per feature module
- **Test Module**: Enable easy test substitution with `@TestInstallIn`

### §22. Android 16 Platform API Integration

- **Foreground Service constraints**: Strictly follow Android 14+ Foreground Service Type declarations
- **Embedded Photo Picker**: Embed system photo picker directly in app UI. Privacy protection with improved UX
- **Predictive Back Gesture**: Full support for predictive back gestures
- **Health Records API**: Access FHIR-standard medical data via Health Connect
- **Adaptive Refresh Rate (ARR)**: Optimize variable display refresh rates with `hasArrSupport`/`getSuggestedFrameRate`
- **Desktop Windowing**: Multi-window support for large-screen devices
- **Enhanced Haptics API**: Rich tactile feedback via amplitude and frequency curve control
- **`getCpuHeadroom`/`getGpuHeadroom`**: Hardware resource monitoring

### §23. Android Gradle Configuration Standards

```kotlin
// build.gradle.kts — Common configuration
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

### §24. ProGuard/R8 Optimization

- **R8 Full Mode**: Enable `android.enableR8.fullMode=true`
- **Obfuscation Rules**: Properly manage library-specific ProGuard rules
- **Reflection Protection**: Explicitly protect reflection targets with `@Keep` annotation
- **Mapping File Retention**: Always save `mapping.txt` from release builds (for crash analysis)

### §25. Per-App Language & Grammatical Inflection

- **Per-App Language**: System API support for in-app language settings. `AppCompatDelegate.setApplicationLocales()`
- **Grammatical Inflection API**: Grammar inflection API for multilingual support
- **Locale Management**: Locale priority management via `LocaleListCompat`

---

## Part V: iOS Architecture

### §26. SwiftUI + MVVM/TCA

- **SwiftUI first**: New screens implemented in SwiftUI. UIKit only for maintaining existing screens
- **MVVM**: Standard pattern of ViewModel + SwiftUI using `@Observable` macro
- **TCA (The Composable Architecture)**: Consider TCA for large-scale apps. Unidirectional data flow + testability
- **Preview-Driven Development**: Actively leverage SwiftUI Previews. Previewable design = testable design

### §27. iOS 26 Framework Integration

- **Liquid Glass**: iOS 26's new design language. Glassy transparent, rounded UI elements auto-applied
- **Foundation Models Framework**: On-device LLM (~3B parameters) access API
- **HealthKit**: Health data integration. Keep permission requests minimal
- **StoreKit 2**: In-app purchases. Use `Product`/`Transaction` APIs
- **PhotosUI**: Use `PhotosPicker` for system photo picker
- **WebView (SwiftUI)**: Native SwiftUI `WebView` component (new in iOS 26)

### §28. Privacy Manifest (Mandatory)

- **`PrivacyInfo.xcprivacy`**: Mandatory for all apps. Declare reasons for API usage
- **Required Reason API**: Declare usage reasons for UserDefaults, FileTimestamp, SystemBootTime, DiskSpace, etc.
- **Tracking Domains**: Declare tracking domains of third-party SDKs
- **Third-party SDKs**: Verify Privacy Manifests of all used SDKs. SDKs without manifests are prohibited

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

- **App Intents Framework**: Standard API for Siri/Shortcuts/Apple Intelligence integration
- **App Shortcuts**: Expose key features as shortcuts
- **Spotlight Integration**: Make in-app content searchable via `CSSearchableItem`
- **Apple Intelligence Integration**: Design integration with Writing Tools, Image Playground, etc.

### §30. SwiftData Integration

- **`@Model` macro**: Natively define Swift data models
- **`@Query`**: Reactive data fetching in SwiftUI views
- **ModelContainer / ModelContext**: Persistence backend management
- **Schema Versioning**: Always update schema version before structural changes
- **Class Inheritance (iOS 26+)**: Use only for clear "is-a" hierarchies. Maintain shallow inheritance trees
- **`@Index` macro (iOS 26+)**: Define optimization indexes for sorting and fetching
- **`@Unique` macro (iOS 26+)**: Unique constraints across multiple attributes

### §31. Deployment Target Standards

| Target | Minimum Version | Rationale |
|--------|----------------|-----------|
| iOS | 16.0 | SwiftUI maturity, 95%+ device coverage |
| macOS | 13.0 | SwiftUI/SwiftData foundation |
| watchOS | 9.0 | WidgetKit + SwiftUI |
| tvOS | 16.0 | SwiftUI standardization |
| visionOS | 1.0 | Support from first version |

### §32. Xcode Configuration Standards

- **Strict Concurrency Checking**: Set to `Complete`
- **Swift 6 Language Mode**: Enable
- **Build Settings**: `SWIFT_STRICT_CONCURRENCY = complete`
- **Warnings as Errors**: Enable `-warnings-as-errors`
- **Code Signing**: Automatic signing + Xcode Cloud / Fastlane integration

### §33. Observations & Reactive Patterns

- **`Observations` async sequences (Swift 6.2)**: Stream transactional state changes of observable types
- **UIKit Integration (iOS 26+)**: UIKit automatically integrates Swift Observation. Auto-tracking in `layoutSubviews`, etc.
- **Migration from Combine**: New code uses `@Observable`+`Observations`. Combine only for maintaining existing code

---

## Part VI: KMP / Kotlin Multiplatform

### §34. KMP Architecture Design

- **Maximize `commonMain`**: Share business logic, data layer, and domain models. Target 85%+ sharing rate
- **`expect`/`actual`**: Only for platform-specific implementations. Prioritize searching existing multiplatform libraries
- **Source Set Structure**: `commonMain` → `androidMain` / `iosMain` / `jvmMain` / `wasmJsMain`
- **Flexible UI**: Choose between Compose Multiplatform (shared UI) or platform-specific UI (maximum UX)

```kotlin
// KMP expect/actual pattern
// commonMain
expect fun platformName(): String

// androidMain
actual fun platformName(): String = "Android ${Build.VERSION.RELEASE}"

// iosMain
actual fun platformName(): String = UIDevice.current.systemName()
```

### §35. KMP Library Selection

| Purpose | Recommended Library | Notes |
|---------|-------------------|-------|
| HTTP | Ktor Client | Multiplatform support |
| Serialization | kotlinx.serialization | Stable. Native KMP support |
| Concurrency | kotlinx.coroutines | Flow included, all targets |
| Date/Time | kotlinx-datetime | Beta. Temporal API compatibility |
| DI | Koin Multiplatform | KMP-compatible DI |
| Settings | DataStore multiplatform | Preferences/Proto support |
| Collections | kotlinx.collections.immutable | Immutable collections |
| Images | Coil 3 Multiplatform | KMP-compatible image loading |

### §36. Swift Export (GA)

- **Swift Export**: Default-enabled in Kotlin 2.2.20 (Experimental). Standard interop replacing Objective-C export
- **Swift Type Mapping**: Kotlin types map directly to Swift native types
- **Nullability Preservation**: Kotlin null safety accurately converts to Swift `Optional`
- **Benefits**: Naturally generates Swift-idiomatic interfaces. Eliminates Obj-C bridge limitations

### §37. KMP Gradual Adoption Strategy

1. **Phase 1**: Share data models and DTOs (minimal risk)
2. **Phase 2**: Share network layer and repositories
3. **Phase 3**: Share domain logic and UseCases
4. **Phase 4**: Share UI with Compose Multiplatform (optional)
- **Team Training**: Conduct KMP workshops before adoption
- **Gradual Migration**: KMP-ify new features first. Bulk migration of existing code prohibited

### §38. KMP Testing Strategy

- **`commonTest`**: Place tests for shared logic in `commonTest`
- **`androidTest` / `iosTest`**: Place platform-specific tests in respective source sets
- **Test Runners**: JUnit5 (Android), via XCTest (iOS)
- **Mocking**: Design testable code in `commonMain` with interface-based approach

### §39. KMP Build Optimization

- **Gradle Configuration**: Suppress stability warnings with `kotlin.mpp.stability.nowarn=true`
- **Incremental Compilation**: Leverage K2 multiplatform incremental compilation
- **Caching**: Enable Gradle Build Cache. Configure remote cache for CI environments
- **Binary Compatibility**: Minimize `@OptIn(ExperimentalKotlinApi::class)` usage

### §40. KMP Common Dependency Management

- **Stable Cross-Compilation (Kotlin 2.2.20)**: Stable cross-platform compilation for libraries
- **Common Dependency Approach**: Simplified dependency resolution across source sets with new approach
- **BOM Integration**: BOM management patterns for KMP projects

---

## Part VII: Compose Multiplatform

### §41. Compose Multiplatform iOS (Stable)

- **iOS Stable**: Reached stable in 2025. VoiceOver support, native-like scrolling, SwiftUI interop
- **SwiftUI Interop**: Embed SwiftUI views within Compose screens. Reverse also supported
- **Native Feel**: Default emulation of iOS heuristics (bounce effects, scroll physics, etc.)
- **Font Integration**: Automatically uses iOS System Font. Custom font bundling supported

### §42. Compose Multiplatform Design Principles

- **Shareable Scope**: UI + Business logic + Navigation + Theme
- **Platform-specific UI**: Branch OS-specific UX patterns (Bottom Sheet conventions, etc.) via `expect`/`actual`
- **Theme Strategy**: Common Material 3-based theme + platform fine-tuning
- **Navigation**: Use Compose Navigation Multiplatform

### §43. Compose Multiplatform Web/Desktop

- **Compose for Web**: Beta on Wasm target. Evaluate carefully for production use
- **Compose for Desktop**: Stable on JVM target. Recommended for internal tools and admin panels
- **Target-specific Optimization**: Consider Web/Desktop-specific interaction patterns (mouse hover, keyboard navigation)

### §44. Compose Multiplatform Migration Guide

- **New Projects**: Consider Compose Multiplatform as default
- **Existing Android Compose**: Gradual migration to `commonMain` is straightforward
- **Existing iOS Apps**: Gradual adoption through SwiftUI Interop. Full screen rewrite not required

---

## Part VIII: Jetpack Compose Performance

### §45. Pausable Composition (GA)

- **Compose 1.10+**: Pausable Composition enabled by default
- **Feature**: Splits heavy UI construction across frames. Prevents jank
- **Lazy Prefetch Integration**: Pausable Composition auto-applied in LazyColumn/LazyRow prefetch
- **Performance Parity**: Google benchmarks show Compose achieving Views-equivalent scroll performance

### §46. Strong Skipping Mode (Default)

- **Stable**: Default-enabled in Compose Compiler 1.7+ / Compose 1.10+
- **Effect**: Composables with unstable parameters can also be skipped
- **Lambda Memoization**: Lambdas in Composables automatically memoized. Manual `remember { }` unnecessary
- **APK Size**: Minor increase (acceptable) in exchange for dramatically reduced unnecessary recompositions

### §47. Recomposition Optimization

- **`remember`**: Cache expensive computations
- **`derivedStateOf`**: Limit recomposition from frequently changing State
- **Stable `key`**: Mandatory `key` parameter in LazyLayouts (`LazyColumn`, etc.)
- **Deferred State Reading**: Defer State reading until needed for rendering (use lambdas)
- **Backwards Write Prohibited**: Writing to already-read State within the same Composable is prohibited

```kotlin
// ✅ Good: Deferred state reading
@Composable
fun AnimatedHeader(scrollProvider: () -> Int) {
    val alpha = (scrollProvider() / 300f).coerceIn(0f, 1f)
    Header(modifier = Modifier.alpha(alpha))
}

// ❌ Bad: Direct State reading
@Composable
fun AnimatedHeader(scroll: Int) {
    val alpha = (scroll / 300f).coerceIn(0f, 1f)
    Header(modifier = Modifier.alpha(alpha))
}
```

### §48. Compose 1.10 New APIs

- **`retain` API**: Persist values across Configuration Changes (rotation, etc.). No serialization needed for lambdas, Flows, Bitmaps
- **`SecureTextField`/`OutlinedSecureTextField`**: Secure text fields for password input
- **`autoSize` Text**: Automatic text container size adjustment
- **Advanced Shadows**: Advanced shadow effect APIs
- **2D Scrolling API**: Two-dimensional scrolling support

### §49. Baseline Profiles

- **Mandatory**: Generate app-specific Baseline Profiles. Default Compose Profiles alone are insufficient
- **Generation Method**: Cover critical user flows with Macrobenchmark tests
- **Effect**: ~30% improvement in startup code execution speed via AOT compilation
- **CI Integration**: Integrate Baseline Profile generation into CI pipeline

```kotlin
// Baseline Profile Generation — Macrobenchmark
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

### §50. Compose Development Tools

- **Layout Inspector**: Recomposition visualization and debugging
- **Compose Metrics**: Compiler metrics output to verify skip rates
- **Live Edit 2.0**: Real-time updates for stateful Composables
- **Release Mode Testing**: Always run performance tests in R8-enabled release builds
- **Profiler**: Regularly monitor CPU, Memory, Frame Rate with Android Studio profiler

---

## Part IX: SwiftUI Best Practices

### §51. Observation Framework

- **`@Observable` macro (recommended)**: Replaces `ObservableObject`+`@Published` from iOS 17+
- **Fine-grained tracking**: Only redraws the portion of the view dependent on changed properties
- **`@State` / `@Environment` / `@Bindable`**: Concise code when combined with `@Observable`
- **`Observations` async sequences (Swift 6.2)**: Stream transactional state changes of observable types
- **UIKit Integration (iOS 26+)**: UIKit automatically integrates Swift Observation

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
            Text("Total: ¥\(viewModel.total)")
        }
    }
}
```

### §52. SwiftUI Performance

- **View Decomposition**: Split complex views into small reusable components
- **Lazy Containers**: Efficiently display large datasets with `LazyVStack`/`LazyHStack`/`LazyVGrid`
- **Stable IDs**: Provide stable unique identifiers in `List`/`ForEach`
- **Minimize State**: Keep `@State` variables focused and small
- **Avoid Heavy Processing**: No network/filtering/image processing inside `body` property
- **SwiftUI Performance Instrument (WWDC 2025)**: Optimization tool for view body rendering and state management efficiency
- **List Performance Improvement (iOS 26)**: Up to 6x faster loading and 16x faster updates for large lists

### §53. Navigation Design

- **`NavigationStack`**: Type-safe programmatic navigation
- **`navigationDestination`**: Type-based routing
- **Sheet/Modal**: Customization APIs for size, dismiss behavior, and transitions
- **Deep Link Support**: Implement URL→NavigationPath conversion handlers

### §54. SwiftUI + UIKit Coexistence

- **`UIViewRepresentable`**: SwiftUI wrapper for UIKit views
- **`UIViewControllerRepresentable`**: UIKit ViewController integration
- **`UIHostingController`**: Place SwiftUI views within UIKit
- **Gradual Migration**: New screens in SwiftUI, existing screens maintained in UIKit. Long-term coexistence is acceptable

### §55. Animation & Interaction

- **Declarative Animation**: Fluid transitions with `withAnimation`/`.animation` modifiers
- **PhaseAnimator**: Simplified multi-phase animations
- **Keyframe Animation**: Custom keyframe-driven animations
- **Matched Geometry Effect**: Continuous element animation during screen transitions
- **Spring Animation**: Physics-based spring animations recommended as default
- **Haptic Feedback**: Appropriate use of `UIImpactFeedbackGenerator` / `SensoryFeedback`

### §56. Liquid Glass Support (iOS 26+)

- **Auto-Application**: Automatically applied to existing SwiftUI apps when recompiled with Xcode 26
- **Customization APIs**: Liquid Glass style control for navigation stacks, tabs, toolbars
- **Material Variants**: New blur styles like `.ultraThin`, `.mega`
- **Backward Compatibility**: Traditional design maintained for iOS 16-25 targets

---

## Part X: Concurrency & Async

### §57. Kotlin Coroutines Best Practices

- **Structured Concurrency**: Manage Coroutine lifecycles with `viewModelScope`/`lifecycleScope`
- **Dispatchers**: Properly use `Main` (UI), `IO` (I/O), `Default` (CPU)
- **Flow**: Use Flow for reactive streams. `StateFlow` (state retention), `SharedFlow` (events)
- **Exception Handling**: Catch global exceptions with `CoroutineExceptionHandler`
- **Cancellation Support**: Cooperative cancellation via `isActive` check or `ensureActive()`

```kotlin
// ✅ Good: Structured Coroutines
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

### §58. Swift Concurrency Best Practices

- **`async/await`**: Completely eliminate callbacks. Enforce Structured Concurrency
- **`TaskGroup`**: Parallel execution and result aggregation of multiple tasks
- **Actor**: Thread-safe access to shared mutable state. Avoid excessive isolation
- **Task Cancellation**: Cooperative cancellation via `Task.checkCancellation()`
- **Priority**: Prioritize critical processing (UI updates, etc.) with `Task.Priority`

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

### §59. Background Processing — Android

- **WorkManager**: Reliable background tasks (sync, upload, etc.)
- **Constraint Configuration**: Specify network state, charging state, storage capacity in WorkRequest
- **Foreground Service Type**: Mandatory type declaration for Android 14+ (`dataSync`, `mediaPlayback`, etc.)
- **Doze Mode Compliance**: Understand `setExact` limitations and minimize AlarmManager usage

### §60. Background Processing — iOS

- **BGTaskScheduler**: Background updates via `BGAppRefreshTask`/`BGProcessingTask`
- **URLSession Background**: Background sessions for large downloads/uploads
- **Push Notification Trigger**: Trigger background processing via Silent Push
- **Battery Consideration**: Minimize background execution time. Respect system decisions

### §61. Real-Time Communication

- **WebSocket**: Standard bidirectional real-time communication. `URLSessionWebSocketTask` (iOS) / OkHttp WebSocket (Android)
- **Server-Sent Events (SSE)**: Server→client streaming
- **Reconnection Strategy**: Exponential Backoff + Jitter for reconnection
- **Connection State Management**: Graceful degradation based on network conditions

### §62. Concurrency Anti-Patterns

- **❌ Main Thread I/O**: I/O operations must always run on background threads
- **❌ GlobalScope**: `GlobalScope.launch` prohibited. Use structured scopes
- **❌ Thread.sleep**: Use `delay()` in Coroutines
- **❌ Callback Hell**: Resolve with async/await
- **❌ Ignoring Race Conditions**: Protect shared state with Actor/Mutex
- **❌ Unmanaged Tasks**: Properly manage `Task { }` return values. Prevent cancellation leaks

### §63. DispatchQueue Migration Guide (iOS)

- **GCD→Swift Concurrency**: Migrate `DispatchQueue.main.async` to `@MainActor`
- **`DispatchQueue.global()`→`Task.detached`**: Background processing migration
- **DispatchGroup→TaskGroup**: Multi-async task waiting migration
- **Gradual Migration**: New code requires Swift Concurrency. Systematically migrate existing GCD

---

## Part XI: Performance Optimization

### §64. Startup Time Optimization

- **Cold Start Target**: Under 500ms (until main content display)
- **Android Measures**: Lazy initialization of Content Providers, App Startup library, Baseline Profiles
- **iOS Measures**: Minimize `pre-main` time, minimize dylibs, leverage Static Linking
- **Measurement**: Continuous monitoring with Firebase App Start Trace / MetricKit `MXAppLaunchMetric`
- **Splash Screen**: Unified with Android 12+ `SplashScreen` API / iOS Launch Storyboard

### §65. Memory Management

- **Android**: LeakCanary (debug) + StrictMode. Bitmap reuse (`BitmapPool`)
- **iOS**: Instruments Allocations/Leaks. Proper Autoreleasepool usage
- **Image Management**: Memory cache management with Coil (Android) / Kingfisher (iOS)
- **Large Heap Avoidance**: `android:largeHeap="true"` is a last resort. Prioritize fundamental memory optimization
- **Threshold**: Target < 50MB memory usage when backgrounded

### §66. Rendering Performance

- **Target Frame Rate**: 60fps / 120fps (ProMotion/high refresh rate support)
- **Adaptive Refresh Rate (Android 16)**: Optimal variable refresh rate utilization via `getSuggestedFrameRate`
- **Jank Detection**: JankStats API (Android) / MetricKit `MXAnimationMetric` (iOS)
- **Overdraw Reduction**: GPU Overdraw debugging. Eliminate unnecessary background/clip operations
- **Offscreen Rendering Avoidance**: Beware of `cornerRadius`+`shadow` combinations (iOS)

### §67. Network Optimization

- **HTTP/3 (QUIC)**: Prefer HTTP/3 with OkHttp 5+ / `URLSession`
- **Image Optimization**: WebP/AVIF formats. Resolution-based resize delivery
- **gRPC**: Consider gRPC for high-frequency API calls. Payload reduction with Protocol Buffers
- **Cache Strategy**: Follow `Cache-Control` headers. Conditional requests with ETag/Last-Modified
- **Connection Pooling**: Connection reuse with Keep-Alive. Faster DNS resolution with DNS-over-HTTPS

### §68. Battery Optimization

- **Doze Mode (Android)**: Understand and design for network/Alarm constraints
- **Adaptive Power (iOS 26)**: Battery optimization during high usage periods (iPhone 15 Pro+)
- **Low Power Mode (iOS)**: Adjust behavior based on `ProcessInfo.processInfo.isLowPowerModeEnabled`
- **Location**: Request only necessary accuracy. Prefer `significantLocationChange`
- **Background Limits**: Design within JobScheduler/BGTaskScheduler constraints
- **Energy Impact Reduction**: Regular monitoring with Instruments Energy Log / Battery Historian

### §69. App Size Optimization

- **Android App Bundle (AAB)**: Device-specific APK delivery. Minimize download size
- **App Thinning (iOS)**: Slicing / On-Demand Resources
- **Target**: Initial download < 30MB. Fetch large assets on demand
- **R8/ProGuard**: Automatic removal of unused code and resources
- **Asset Compression**: Images in WebP, video in HEVC, fonts in woff2 subsets
- **Monitoring**: Output app size diff reports per PR in CI

### §70. Hardware Resource Monitoring

- **`getCpuHeadroom`/`getGpuHeadroom` (Android 16)**: Real-time hardware availability monitoring
- **Dynamic Quality Adjustment**: Dynamic control of rendering quality and AI inference accuracy under resource pressure
- **Thermal State API**: Processing load reduction based on device thermal state
- **Use Cases**: Games, camera, AR/VR, on-device AI inference

---

## Part XII: On-Device AI & Edge ML

### §71. On-Device AI Strategy

- **Privacy First**: Process AI without sending user data off-device
- **Offline Operation**: AI features fully functional without network
- **Latency**: Target < 10ms response for edge inference
- **Model Size**: Initial bundled < 20MB. Deliver large models via OTA
- **Hardware Utilization**: Maximize Neural Engine (Apple) / NPU (Android)

### §72. Android — ML Kit & TensorFlow Lite

- **ML Kit**: Pre-built APIs for text recognition, face detection, barcode, translation
- **TensorFlow Lite**: High-performance custom model inference. GPU/NNAPI delegate utilization
- **MediaPipe**: Multimodal AI pipeline. Real-time pose estimation and hand detection
- **Gemini Nano**: On-device LLM. Access via Android AICore API
- **Model Format**: Standard use of `.tflite` (quantized)

```kotlin
// ML Kit Text Recognition
val recognizer = TextRecognition.getClient(TextRecognizerOptions.DEFAULT_OPTIONS)
recognizer.process(inputImage)
    .addOnSuccessListener { text ->
        text.textBlocks.forEach { block ->
            // Process text blocks
        }
    }
```

### §73. iOS — Core ML & Apple Foundation Models

- **Core ML**: Neural Engine optimized. Use compiled `.mlmodel`→`.mlmodelc` models
- **Create ML**: Custom model training. Improved data efficiency with Transfer Learning
- **Vision Framework**: High-level APIs for image classification, object detection, text recognition
- **Natural Language**: Text classification, sentiment analysis, language detection

### §74. Apple Foundation Models Framework (iOS 26+)

- **On-Device LLM**: Access to ~3B parameter models. Fully offline operation
- **Supported Tasks**: Text generation, summarization, entity extraction, text understanding, refinement, dialogue
- **Privacy Guarantee**: Data never leaves the device
- **Apple Silicon Optimized**: Efficient inference leveraging Neural Engine
- **Guardrails**: Built-in output safety filtering and content control
- **Fallback**: Fallback to cloud API (via Private Cloud Compute) for unsupported devices

```swift
// Apple Foundation Models — Text Generation
import FoundationModels

let session = LanguageModelSession()
let response = try await session.respond(
    to: "Summarize the user's question: \(userQuery)"
)
print(response.content)
```

### §75. Gemini Nano Details

- **AICore API**: Access on-device Gemini Nano via Android AICore
- **Supported Tasks**: Summarization, Smart Reply, text completion
- **Device Requirements**: Pixel 8 Pro and later, select Samsung Galaxy models
- **Guardrails**: Apply output filtering and safety checks to on-device LLMs
- **Fallback**: Fallback to cloud Gemini API for unsupported devices

### §76. Model Management & Governance

- **Versioning**: Assign semantic versions to models. A/B testing support
- **OTA Delivery**: Dynamic model updates via Firebase ML Model Download / CloudKit
- **Fallback**: Fallback to bundled model on OTA failure
- **Performance Monitoring**: Track inference time, accuracy, and memory usage via telemetry
- **Model Signing**: Digital signatures on model files for tampering prevention

### §77. Edge AI Performance Standards

| Metric | Target | Measurement Method |
|--------|--------|--------------------|
| Inference Latency | < 50ms (CPU) / < 10ms (NPU) | Systrace / Instruments |
| Model Size | < 20MB (initial bundle) | Build-time size check |
| Memory Usage | < 100MB additional | Memory Profiler |
| Battery Impact | < 5%/hour | Battery Historian / Energy Log |
| Accuracy Degradation | < 5% vs server model | Evaluation pipeline |

### §78. Multimodal AI

- **Camera Integration**: Real-time image recognition + text generation combination
- **Voice**: On-device speech recognition + LLM intent understanding
- **Sensor Fusion**: Accelerometer/gyroscope + AI context estimation
- **Use Cases**: Visual Intelligence (iOS), Circle to Search (Android)

---

## Part XIII: Offline-First & Data Persistence

### §79. Offline-First Design Principles

- **SSOT**: Local DB (Room / SwiftData) is the single source of truth. Server is a replica
- **Optimistic Updates**: Immediate UI reflection → background sync. Predefine conflict resolution strategy
- **Network State Awareness**: Monitor network state with `ConnectivityManager` (Android) / `NWPathMonitor` (iOS)
- **Data Consistency**: Conflict resolution via CRDT / Last-Write-Wins
- **Queuing**: Accumulate offline operations in queue, execute sequentially upon network recovery

### §80. Android Data Persistence — Room

- **Room**: Type-safe SQLite ORM. KSP support mandatory
- **`@Entity`/`@Dao`/`@Database`**: Standard Room configuration
- **Migration**: Prefer `AutoMigration`. Manual Migration for destructive changes
- **Flow Integration**: Return `Flow<List<T>>` from `@Query` for reactive UI updates
- **Paging 3**: Large data pagination. `PagingSource` + `RemoteMediator`

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

- **Preferences DataStore**: Successor to SharedPreferences. Coroutines-based async API
- **Proto DataStore**: Schema-based type-safe storage with Protocol Buffers
- **EncryptedSharedPreferences Prohibited**: Use Android Keystore directly for sensitive data
- **Migration**: Support gradual migration from SharedPreferences to DataStore

### §82. iOS Data Persistence — SwiftData

- **SwiftData**: Successor to Core Data. Declarative data definition with `@Model` macro
- **`@Query`**: Reactive fetch in SwiftUI views. Integrated with Observation Framework
- **ModelContainer**: Persistence backend configuration management
- **Schema Migration**: Prefer LightweightMigration. Strict version control for custom migrations
- **CloudKit Integration**: iCloud backup/sync with `NSPersistentCloudKitContainer`
- **Class Inheritance (iOS 26+)**: Use only for clear "is-a" hierarchies
- **`@Index`/`@Unique` (iOS 26+)**: Performance optimization and data integrity guarantee

### §83. iOS Keychain & UserDefaults

- **Keychain**: Mandatory for auth tokens, encryption keys, sensitive data
- **`kSecAttrAccessibleWhenUnlockedThisDeviceOnly`**: Device lock-linked access control
- **UserDefaults**: Non-sensitive settings only. Usage reason declaration required in Privacy Manifest
- **App Group**: Data sharing between host app and extensions

### §84. Background Sync

- **Delta Sync**: Minimize bandwidth with differential sync. `updated_at` timestamp-based
- **WorkManager (Android)**: Reliable background sync with network constraint support
- **BGTaskScheduler (iOS)**: Large data sync with `BGProcessingTask`
- **Conflict Strategy**: Prepare 3 patterns: Last-Write-Wins / Server-Wins / Manual Resolution
- **Pagination Sync**: Cursor-based incremental sync for large datasets

### §85. Cross-Platform Data Sync

- **KMP DataStore**: Multiplatform settings data persistence
- **Ktor + Room/SwiftData**: KMP network layer + platform-specific DB
- **Sync Protocol**: Sync pattern design for REST / GraphQL / gRPC
- **Error Recovery**: Retry, partial sync, and rollback strategies for sync failures

---

## Part XIV: Security & App Hardening

### §86. Secret Management — No Secrets in Binary

- **Absolutely Prohibited**: Hardcoding API Keys, OAuth secrets, encryption keys in source code
- **Android Keystore**: Hardware-backed secure storage
- **iOS Keychain**: Integration with Secure Enclave
- **CI Secrets**: Inject secrets from CI/CD environment variables at build time
- **Detection**: Run gitleaks / truffleHog in pre-commit hooks

### §87. Encryption & Data Protection

- **At-rest Encryption**: Android `EncryptedFile` / iOS `FileProtection.complete`
- **Transport Encryption**: TLS 1.3 mandatory. TLS 1.2 only for backward compatibility
- **Hashing**: SHA-256 or higher. MD5/SHA-1 prohibited
- **Key Management**: Hardware-backed key generation (Keystore / Secure Enclave)
- **Cryptographic Agility**: Develop migration plan for quantum-resistant cryptography (ML-KEM, ML-DSA)

### §88. Authentication & Biometrics

- **Passkeys (FIDO2/WebAuthn)**: First recommendation for passwordless auth. Phishing-resistant
- **BiometricPrompt (Android)**: Class 3 biometric auth with `BIOMETRIC_STRONG`
- **LAContext (iOS)**: Face ID / Touch ID. Authenticate with `evaluatePolicy`
- **Fallback**: Fallback to PIN/passcode for devices without biometric support
- **Session Management**: JWT expiration management. Secure storage of refresh tokens

```kotlin
// Android BiometricPrompt
val biometricPrompt = BiometricPrompt(
    fragmentActivity,
    ContextCompat.getMainExecutor(context),
    object : BiometricPrompt.AuthenticationCallback() {
        override fun onAuthenticationSucceeded(result: AuthenticationResult) {
            // Auth success → Decrypt data with private key stored in Keystore
        }
    }
)
val promptInfo = BiometricPrompt.PromptInfo.Builder()
    .setTitle("Identity Verification")
    .setAllowedAuthenticators(BiometricManager.Authenticators.BIOMETRIC_STRONG)
    .setNegativeBtnText("Cancel")
    .build()
```

### §89. App Hardening (RASP)

- **Play Integrity API (Android)**: Verify app authenticity, device integrity, and account integrity
- **App Attest (iOS)**: Guarantee request authenticity with Secure Enclave-based cryptographic proof
- **Root/Jailbreak Detection**: Restrict or block operation on tampered devices
- **RASP**: Runtime self-protection. Tampering detection, reverse engineering defense, hooking detection
- **Code Obfuscation**: ProGuard/R8 (Android). iOS Swift limited due to ABI stability
- **Debugger Detection**: `ptrace` detection (iOS), `Debug.isDebuggerConnected()` (Android)

### §90. Network Security

- **Certificate Transparency (Recommended)**: New standard replacing Certificate Pinning. No app update needed for cert rotation
- **Certificate Pinning (Legacy)**: Public key pinning. Always configure backup pins
- **Network Security Config (Android)**: Prohibit cleartext in `res/xml/network_security_config.xml`
- **ATS (App Transport Security / iOS)**: Enabled by default. Minimize exceptions
- **Man-in-the-Middle Defense**: Multi-layer defense with TLS 1.3 + Certificate Transparency/Pinning

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

### §91. Secure Coding

- **Input Validation**: Sanitize and validate all user inputs
- **SQL Injection Prevention**: Mandatory parameter binding with Room/SwiftData
- **WebView Security**: Prohibit unrestricted JavaScript. Minimum privilege for `addJavascriptInterface`
- **Intent Spoofing Prevention**: Strict permission settings for exported Activity/BroadcastReceiver
- **URL Scheme Hijacking**: Prevent URL Scheme hijacking with Universal Links / App Links
- **Clipboard Protection**: Protect password copy with `ClipDescription.EXTRA_IS_SENSITIVE` flag

### §92. Privacy Sandbox Integration (Android 16)

- **SDK Runtime**: SDKs operate in isolated environment. Enhanced data protection
- **Topics API**: Privacy-preserving ad targeting
- **Attribution Reporting**: Privacy-preserving conversion measurement
- **Protected Audiences**: On-device auction-based remarketing

### §93. Security Testing Standards

- **SAST**: CI integration of ktlint security rules / SwiftLint security rules
- **DAST**: API and communication security testing with OWASP ZAP / Burp Suite
- **SBOM**: Generate third-party dependency inventory in CycloneDX format
- **Vulnerability SLA**: Critical — fix within 24 hours, High — 7 days, Medium — 30 days
- **OWASP MASVS**: Compliance verification against Mobile App Security Verification Standard

### §94. Security Monitoring & Incident Response

- **Crashlytics Security Events**: Auto-classification of security-related crashes
- **Anomaly Detection**: Server-side detection of abnormal auth and API call patterns
- **Remote Kill Switch**: Remote feature disabling mechanism for critical vulnerability discovery
- **Incident Response**: Define emergency release flow for security incidents

---

## Part XV: Platform Integration & OS Features

### §95. Push Notifications

- **FCM (Android)**: Firebase Cloud Messaging. Topic subscription/conditional delivery
- **APNs (iOS)**: Apple Push Notification service. VoIP Push / Live Activities Push
- **Notification Channels (Android)**: Mandatory `NotificationChannel` categorization
- **Notification Cooldown (Android 16)**: Gradual volume reduction for burst notifications
- **Permission Request**: Pre-Permission Pattern. Value explanation → permission request two-stage approach
- **Rich Notification**: Notifications with images/action buttons/custom UI

### §96. Deep Links & Universal Links

- **App Links (Android)**: Verify domain ownership with `assetlinks.json`. Intent Filter configuration
- **Universal Links (iOS)**: Domain verification with `apple-app-site-association`
- **Deferred Deep Links**: Deferred deep links for users without the app installed
- **Navigation Integration**: Routing for deep link→NavigationStack/NavGraph conversion

### §97. Widgets & Live Activities

- **Glance (Android)**: Declarative widgets with Jetpack Glance. Compose syntax
- **WidgetKit (iOS)**: SwiftUI-based widgets. TimelineProvider
- **Live Activities (iOS)**: Real-time information display. Dynamic Island support
- **Update Frequency**: Update within system budget. Excessive updates subject to OS throttling

### §98. App Clips / Instant Apps

- **App Clips (iOS)**: < 15MB. Triggered by NFC/QR code/Safari Smart Banner
- **Instant Apps (Android)**: Google Play Instant format
- **Design Principle**: Single-task completion type. Design pathway to full app

### §99. Web-Native Bridge

- **WebView**: Use `WKWebView` (iOS) / AndroidX WebView. Minimum privilege for JavaScript interfaces
- **SwiftUI WebView (iOS 26)**: Native SwiftUI WebView component
- **JavaScript Bridge**: Secure communication via message passing
- **Cookie Sync**: Consistency between native and WebView sessions

### §100. Camera, Sensors & Hardware

- **CameraX (Android)**: High-level Camera2 API wrapper. Lifecycle-aware
- **AVFoundation (iOS)**: Camera/mic/video processing
- **Android 16 Camera API Enhancement**: Color temperature/tint adjustment, hybrid AE, night mode detection
- **Sensor API**: Accelerometer, gyroscope, barometer. `SensorManager`/`CMMotionManager`
- **Bluetooth LE**: `CompanionDeviceManager` (Android) / `CBCentralManager` (iOS)
- **NFC**: `NfcAdapter` (Android) / `NFCTagReaderSession` (iOS)
- **Permission Management**: Request camera/mic/location permissions just before use

### §101. Health Connect / HealthKit

- **Health Connect (Android)**: Unified health data platform
- **Health Records API (Android 16)**: FHIR-standard medical data access
- **HealthKit (iOS)**: Comprehensive health data framework
- **Minimum Privilege**: Request only necessary data types. Clear privacy descriptions
- **Data Encryption**: Always encrypt health data at rest

---

## Part XVI: Flutter / Cross-Platform Integration

### §102. Platform Channel — Pigeon Mandatory

- **Pigeon**: Type-safe Platform Channel generation. Manual MethodChannel prohibited
- **Code Generation**: Auto-generated type-safe bindings for `.dart` + `.kt` / `.swift`
- **Error Type Unification**: Unified error types across platforms via Pigeon-generated code

```dart
// Pigeon Definition — messages.dart
@HostApi()
abstract class NativeAuthApi {
  @async
  String getBiometricToken();

  @async
  bool isBiometricAvailable();
}
```

### §103. Threading Rules

- **Platform I/O**: MethodChannel (Android) receives on main thread. Heavy processing with `withContext(Dispatchers.IO)`
- **iOS**: Receives on MainActor. Heavy processing with Task.detached
- **Isolate Integration**: Safe communication patterns between Dart Isolate ↔ Platform Channel

### §104. Error Handling Standard

- **Error Code Unification**: Map platform-specific errors to app-common error codes
- **PlatformException**: Properly catch and convert on Flutter side
- **Fallback**: Pure Dart implementation fallback when native API unavailable

### §105. KMP + Flutter Hybrid

- **KMP Business Logic + Flutter UI**: Share business logic via KMP, implement UI in Flutter
- **Via Pigeon**: Expose KMP artifacts to Flutter via Pigeon
- **Responsibility Boundary**: KMP = Domain/Data layer, Flutter = Presentation layer

### §106. React Native Integration

- **Turbo Modules**: New standard API for native modules. Migration from Bridge
- **Fabric**: Integration with new rendering engine
- **Constraints**: Even with RN, implement native-specific API parts in Kotlin/Swift

---

## Part XVII: Testing Strategy

### §107. Unit Testing

- **Kotlin**: JUnit 5 + MockK. Coroutines testing with `kotlinx-coroutines-test` Turbine
- **Swift**: Swift Testing framework (`@Test` macro). Migration from XCTest recommended
- **Coverage**: Business logic 80%+, utilities 100%. UI tested separately

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

### §108. Swift Testing Deep Dive

- **`@Suite`**: Test suite grouping
- **`@Test(arguments:)`**: Parameterized tests for efficient multi-input verification
- **Tags**: Tag tests for CI execution filtering
- **Parallel Execution**: Automatic parallel test execution
- **Migration from XCTest**: Gradual migration to `#expect`/`#require` macros

### §109. UI Testing

- **Compose**: Auto-test Composables with `ComposeTestRule`. SemanticNode search and assertions
- **SwiftUI**: `ViewInspector` or XCTest UI tests
- **Snapshot Testing**: Visual regression detection with Paparazzi (Android) / Swift Snapshot Testing (iOS)

### §110. Integration & E2E Testing

- **Maestro**: Cross-platform E2E test framework. YAML-defined test flows
- **Espresso**: Android UI testing (legacy; Compose Test recommended for new)
- **XCUITest**: iOS UI testing
- **Test Environment**: Eliminate API dependencies with mock servers (WireMock / MockServer)

### §111. Performance Testing

- **Macrobenchmark (Android)**: Benchmarks for startup, scroll, animation
- **XCTest Performance**: iOS performance measurement with `measure { }`
- **Baseline Profile Generation**: Auto-generate from Macrobenchmark tests
- **CI Integration**: Auto-detect performance regressions. Block PRs on threshold exceedance

### §112. Security Testing

- **Static Analysis**: detekt security rules / SwiftLint security rules
- **Dependency Scanning**: Dependabot / Renovate + OSV Scanner
- **Penetration Testing**: External penetration testing at least annually
- **OWASP MASVS**: Compliance verification against Mobile App Security Verification Standard

### §113. Test Infrastructure

- **Firebase Test Lab**: Real device testing. Robo test + custom tests
- **Xcode Cloud**: iOS CI/CD and test integration
- **Test Sharding**: Parallel execution of large test suites
- **Flaky Test Elimination**: Auto-detect and quarantine flaky tests. Fix within 2 weeks mandatory

### §114. Screenshot Testing

- **Android Screenshot Testing API**: Visual regression detection for Compose UI
- **Paparazzi**: Headless Compose screenshot capture. No real device required
- **Swift Snapshot Testing**: Snapshot tests for SwiftUI/UIKit views
- **CI Integration**: Automatic diff reports against golden images per PR

---

## Part XVIII: Build, CI/CD & Release

### §115. Build Optimization

- **Gradle**: Enable Configuration Cache. Build Cache (local + remote) mandatory
- **Gradle 9.x**: Isolated Projects support
- **Xcode**: Leverage DerivedData Cache. Optimize parallel build settings
- **Target**: Full build under 15 minutes. Incremental build under 3 minutes
- **Convention Plugin**: Simplify build.gradle.kts through shared build configurations

### §116. CI/CD Pipeline

- **5-Stage Gate**: Lint → Unit Test → Integration Test → Build → Release
- **Affected Module Detection (Android)**: Test and build only changed modules
- **Code Signing Automation**: Fastlane Match / App Store Connect API
- **Artifact Management**: Auto-save and version-link APK/IPA/dSYM/mapping.txt

### §117. Release Management

- **Staged Rollout (Android)**: 1% → 5% → 20% → 50% → 100% phased delivery
- **TestFlight (iOS)**: Internal/external tester distribution. Automatic feedback collection
- **Release Criteria**: Crash rate < 0.1%, ANR rate < 0.5% as Go conditions
- **Hotfix**: Define emergency release flow for critical bug discovery

### §118. Store Guideline Compliance

- **App Store Review Guidelines**: Check latest version at development start
- **Google Play Developer Policy**: Regular monitoring of review policy changes
- **Pre-Submission Check**: Execute store-specific automated checklists
- **Metadata Management**: ASO keyword/screenshot optimization

### §119. Feature Flag Operations

- **Firebase Remote Config / LaunchDarkly**: Feature ON/OFF toggle
- **Phased Rollout**: Gradually expose new features to users
- **A/B Testing**: Comparative experiments of feature variants
- **Kill Switch**: Immediate feature disable on issue discovery

### §120. Versioning Convention

- **Semantic Versioning**: `MAJOR.MINOR.PATCH`
- **Build Number**: Auto-increment via CI/CD. Manual changes prohibited
- **versionCode (Android)**: Monotonically increasing. `MAJOR * 10000 + MINOR * 100 + PATCH`
- **CFBundleVersion (iOS)**: Linked to build number

### §121. Gradle Latest Developments

- **Gradle Version Catalog**: Centralized dependency management in `libs.versions.toml`
- **Convention Plugins**: Shared build logic
- **Configuration Cache**: Avoid reconfiguration through build config caching
- **Amper (Experimental)**: JetBrains new build tool. Simplified for KMP projects

### §122. Xcode Cloud & Fastlane

- **Xcode Cloud**: Apple official CI/CD. TestFlight distribution automation
- **Fastlane**: Code signing (Match), screenshot automation, metadata management
- **Tuist**: Xcode project generation and management automation tool
- **Mise**: Development environment version management (Ruby, Node, etc. for Fastlane dependencies)

---

## Part XIX: Accessibility

### §123. Screen Reader Support

- **TalkBack (Android)**: Set `contentDescription` on all interactive elements
- **VoiceOver (iOS)**: Properly set `accessibilityLabel`/`accessibilityHint`
- **Reading Order**: Control logical reading order with `accessibilityTraversalOrder`
- **Live Regions**: Notify dynamic content updates with `accessibilityLiveRegion` (Android) / `UIAccessibility.post(notification:)` (iOS)

### §124. Dynamic Type / Font Scaling

- **Android**: Define font sizes in `sp` units. `textScaleFactor` support
- **iOS**: Dynamic Type support. Use `preferredFont(forTextStyle:)`
- **Maximum Scale**: Verify layout integrity at 200% text enlargement
- **Testing**: Verify font scaling with Accessibility Inspector

### §125. Touch Targets & Motion

- **Minimum Touch Target**: 48dp × 48dp (Android) / 44pt × 44pt (iOS)
- **Motion Reduction**: Support `prefers-reduced-motion`. Animation disable option
- **Color Vision Diversity**: Information conveyance not solely dependent on color. Contrast ratio 4.5:1+
- **Keyboard Navigation**: Full operation support with iPad external keyboard / Chromebook

### §126. Accessibility Testing

- **Accessibility Scanner (Android)**: Auto-scan for a11y issues
- **Accessibility Inspector (iOS)**: Xcode integrated tool
- **CI Integration**: Integrate Espresso a11y checks / XCTest a11y assertions into CI
- **WCAG 2.2 AA Compliance**: All new screens must meet WCAG 2.2 AA standards
- **User Testing**: Regular testing by users with visual/motor disabilities

### §127. LE Audio & Hearing Aid Support (Android 16)

- **LE Audio**: Low-latency Bluetooth audio. Enhanced hearing aid integration
- **In-Call Mic Switching**: Mic input switching for LE Audio hearing aid users
- **Ambient Sound Volume**: Volume control for ambient sounds

---

## Part XX: Observability & Monitoring

### §128. Crash Reporting

- **Firebase Crashlytics**: Common crash analysis for Android/iOS
- **Non-fatal errors**: Record non-fatal errors in Crashlytics
- **ProGuard/R8 Mapping**: Automatic deobfuscation of stack traces
- **dSYM**: Xcode auto-upload setup. dSYM still required after Bitcode deprecation
- **Alert Criteria**: Alert when crash-free rate < 99.9%

### §129. Performance Monitoring

- **Firebase Performance Monitoring**: Network latency, screen rendering, custom traces
- **MetricKit (iOS)**: System-level metrics: MXAppLaunchMetric, MXAnimationMetric, etc.
- **Custom Traces**: Measure critical user flows (login, search, checkout)
- **ANR/Hang Detection**: Automatic detection and reporting of Android ANR / iOS Hang

### §130. OpenTelemetry Mobile

- **OTel Mobile SDK**: Standardized telemetry collection. Vendor lock-in avoidance
- **Distributed Tracing**: Complete trace linking from mobile → API → backend
- **Semantic Conventions**: Comply with OTel Mobile Semantic Conventions
- **Export**: Send in OTLP format to backends (Datadog/New Relic/Grafana, etc.)

### §131. App Analytics & Health Monitoring

- **User Flow Analysis**: Visualize screen transitions, feature usage rates, drop-off points
- **Core Web Vitals-like Metrics**: Startup time, interaction responsiveness, visual stability
- **Alert Threshold Definition**:
  - Crash rate > 0.1% → P1 alert
  - ANR rate > 0.5% → P1 alert
  - Startup time > 2s → P2 alert
  - Network error rate > 5% → P2 alert

### §132. Logging Strategy

- **Structured Logs**: JSON format. Include timestamp, session ID, user ID (hashed)
- **Log Levels**: ERROR/WARN/INFO/DEBUG. Release builds only INFO and above
- **PII Exclusion**: Never output personal information in logs
- **Rotation**: Set log file size limits. Auto-delete old logs

---

## Part XXI: FinOps & Cost Optimization

### §133. Build Cost Optimization

- **CI/CD Execution Time**: Build time under 15 minutes (common target for Android/iOS)
- **Cache Strategy**: Reduce rebuilds with Gradle Build Cache / Xcode DerivedData Cache / SPM Cache
- **Selective Test Execution**: Run only change-related tests with Affected Module Detection (Android)
- **Self-Hosted Runners**: Reduce CI/CD costs with Apple Silicon Mac mini / Linux ARM64
- **Parallel Builds**: Minimize wait time with iOS parallel builds and test sharding

### §134. Store Cost Optimization

- **App Size**: < 30MB initial download. Regularly analyze correlation with store conversion rate
- **On-Demand Resources (iOS)**: On-demand download of large assets
- **Dynamic Feature Modules (Android)**: On-demand feature installation
- **ASO ROI**: Measure effectiveness of keyword optimization and screenshot A/B testing

### §135. Cloud Service Costs

- **Firebase Blaze Plan**: Set monitoring alerts for free tier exceedance
- **Telemetry Costs**: Optimize log/metrics volume. Appropriate sampling rate
- **CDN Optimization**: Reduce origin server costs with CDN delivery for images/assets
- **API Call Optimization**: Reduce API call count with batch requests and caching

### §136. Device Farm Optimization

- **Firebase Test Lab**: Maximum coverage with minimal real device configuration
- **Test Parallelization**: Reduce execution time through test sharding
- **Emulator Usage**: Use emulators to cut costs when real device testing isn't needed
- **Test Selection**: Optimize execution targets with risk-based testing

---

## Part XXII: visionOS & Spatial Computing

### §137. visionOS App Design

- **3D Spatial Interaction**: Natural interaction design via eyes, hands, and voice
- **App Structure**: Windows (floating 2D) / Volumes (3D content) / Immersive Spaces (immersive experience)
- **SwiftUI + RealityKit**: SwiftUI for 2D UI, RealityKit for 3D content integration
- **Cross-Platform**: Shared SwiftUI code for iOS/macOS/visionOS
- **Event Handling**: Tap/long press/drag/rotate/zoom gestures

### §138. visionOS Performance & UX

- **Rendering**: 90fps mandatory (VR sickness prevention). RealityKit optimization
- **Spatial Audio**: Enhance realism with 3D positional audio
- **Accessibility**: VoiceOver spatial support, pointer control alternative input
- **Privacy**: Minimum camera/location data collection. ARSession permission management

### §139. visionOS Design Principles

- **Spatial Design**: Information hierarchy with depth. UI layering using z-axis
- **Physics-Based Interaction**: Gesture design responding to natural hand movements
- **Shared Space**: Design considering coexistence with other apps
- **Human Interface Guidelines for visionOS**: Strict compliance with Apple HIG visionOS edition

---

## Part XXIII: Wear OS & watchOS

### §140. Wear OS Development

- **Compose for Wear OS**: Use Wear-specific Compose components
- **Tiles API**: Glanceable information display. Efficient rendering with Tile renderer
- **Health Services API**: Efficient sensor data retrieval (heart rate, step count, etc.)
- **Battery Consideration**: Delegate background measurements to Health Services API
- **Complications**: Implement watch face complication data providers

### §141. watchOS Development

- **SwiftUI First**: watchOS UI is SwiftUI only. WatchKit (Storyboard) is deprecated
- **WidgetKit**: watchOS widgets/complications
- **HealthKit**: Heart rate, workout, sleep data retrieval and recording
- **WCSession**: iPhone↔Apple Watch communication. File transfer/messaging
- **Always On Display**: Always-on display support. Low-frequency updates with `TimelineView`

### §142. Wearable UX Principles

- **Glanceable**: Information must be understandable at a glance. Long text prohibited
- **2-Second Rule**: User interactions complete within 2 seconds
- **Context Aware**: Proactive information presentation based on time/location/activity
- **Haptics**: Convey important notifications via tactile feedback

---

## Part XXIV: Android XR & Immersive

### §143. Android XR Platform

- **Jetpack XR**: Android framework for AR/VR apps
- **ARCore**: Environment recognition, plane detection, occlusion
- **Compose for XR**: Build spatial UIs with Compose syntax
- **Cross-Device**: Unified experience design across smartphone/tablet/headset
- **Performance**: 90fps target. Low-latency rendering pipeline

### §144. Immersive Experience Design

- **6DoF**: 6 degrees of freedom tracking utilization. Full position + rotation tracking
- **Spatial Anchors**: Fix digital content to physical space
- **Hand Tracking**: Intuitive interaction via hand movements
- **Content Placement**: Ergonomic guidelines for gaze height and distance

---

## Part XXV: Green Engineering

### §145. Battery Efficiency Design

- **Background Limit Compliance**: Use OS-provided scheduler APIs (WorkManager/BGTaskScheduler)
- **Location Power Saving**: Leverage Significant Location Change / Geofencing
- **Network Efficiency**: Batch requests, gzip compression, HTTP/3 0-RTT
- **Rendering Efficiency**: Eliminate unnecessary animations/redraws
- **Dark Mode Recommended**: Reduce power consumption on OLED screens

### §146. CO2 Emission Awareness

- **Measurement**: Measure build CI/CD CO2 emissions with SCI (Software Carbon Intensity)
- **Optimization**: Improve energy efficiency with ARM64 build runners
- **Code Efficiency**: Eliminate unnecessary dependencies, optimize bundle size
- **Green SRE Integration**: Integrated environmental impact reduction with server-side green optimization

### §147. Energy Efficiency KPIs

| Metric | Target | Measurement Method |
|--------|--------|--------------------|
| Background Battery Consumption | < 1%/hour | Battery Historian / Energy Log |
| Network Battery Consumption | < 0.5%/API call | Energy Profiler |
| CI/CD Build Energy | < 0.5 kWh/build | SCI measurement |
| Idle CPU Usage | < 1% | Instruments / Profiler |

---

## Part XXVI: Privacy & Compliance

### §148. Privacy Manifest Deep Dive (iOS)

- **Required Reason API**: Declare all usage reasons for UserDefaults, FileTimestamp, SystemBootTime, DiskSpace
- **Third-Party SDK Privacy Manifests**: Verify and aggregate Privacy Manifests of all used SDKs
- **Tracking Transparency**: Proper implementation of ATT (App Tracking Transparency) framework
- **Privacy Nutrition Labels**: Accurate privacy label declaration in App Store Connect
- **Fingerprinting Prohibited**: Prohibit API usage that constitutes device fingerprinting

### §149. Android Privacy

- **QUERY_ALL_PACKAGES Restriction**: Comply with Android 11+ package visibility restrictions
- **Scoped Storage**: Proper use of app-specific storage
- **Photo Picker**: Prefer image selection APIs requiring no storage permissions
- **Embedded Photo Picker (Android 16)**: Embeddable directly in app UI
- **Background Location**: Justify `ACCESS_BACKGROUND_LOCATION` usage
- **Data Safety Section**: Accurate information declaration in Google Play Console

### §150. Regulatory Compliance

- **GDPR**: Data processing consent for EU users. Data portability and deletion rights
- **APPI**: Compliance with Japan's 2025 Personal Information Protection Act amendments
- **CCPA/CPRA**: California Consumer Privacy Act compliance
- **EU CRA (Cyber Resilience Act)**: Effective 2027. SBOM and vulnerability reporting obligations
- **Child Protection**: COPPA compliance. Special protections for users under 13
- **Review**: In-app privacy policy display and regular updates

### §151. Permission Management Best Practices

- **Just-in-Time**: Request permissions in context just before use
- **Pre-Permission Pattern**: Display value explanation screen before system dialog
- **Graceful Degradation**: Provide alternative UI even when permissions denied
- **Permission Audit**: Re-verify necessity of used permissions every 6 months

### §152. EAA (European Accessibility Act 2025)

- **Legal Requirements**: Effective June 2025. Mandatory accessibility for digital products
- **Scope**: Mobile apps targeting EU market. Prepare self-declaration of conformity
- **WCAG 2.2 AA**: WCAG 2.2 AA compliance mandated as technical standard
- **User Testing**: Verification process including testing by people with disabilities

---

## Part XXVII: Team & Organization Design

### §153. Mobile Platform Team

- **Platform Team**: Specialized team responsible for common infrastructure (CI/CD, design system, network layer)
- **Feature Teams**: Cross-functional teams by feature. Include Android/iOS developers
- **Code Ownership**: Clarify review responsibilities per module with `CODEOWNERS`
- **Architecture Review**: Mandatory architecture review for new feature design

### §154. Knowledge Sharing & Development

- **Tech Radar**: Manage Adopt/Trial/Assess/Hold with team technology radar
- **Mob Programming**: Share knowledge through mob programming for complex implementations
- **RFC Process**: Create RFC (Request for Comments) for large-scale changes
- **KMP Training**: Cross-training: Kotlin training for Swift engineers, Swift training for Kotlin engineers

### §155. Code Review Standards

- **Review Checklist**: 4 perspectives: security, performance, accessibility, test coverage
- **PR Size**: Target ≤ 400 lines changed per PR. Use stacked PRs for large changes
- **Review SLA**: Initial review within 24 hours of PR submission
- **Automated Checks**: Lint/Format/Test auto-check pass as merge prerequisites

---

## Part XXVIII: Migration Strategy

### §156. UIKit → SwiftUI Migration

- **Gradual Migration**: Implement new screens in SwiftUI. Partially replace existing screens with `UIHostingController`
- **Coexistence Period**: UIKit/SwiftUI coexistence over 2-3 year long-term plan
- **Data Flow Unification**: Unify state management with `@Observable` macro
- **Test Strategy**: VRT-based regression detection using SwiftUI Previews for migrated screens

### §157. View → Compose / Java → Kotlin Migration

- **Compose Migration**: Compose-ify new screens. Gradually replace existing XML layouts with `AndroidView`/`ComposeView`
- **Java→Kotlin**: New code must be Kotlin. Gradually migrate existing Java with Android Studio auto-conversion
- **Interop**: Bidirectional integration with `ComposeView` (Compose in XML) / `AndroidView` (View in Compose)
- **Migration Metrics**: Track Kotlin adoption rate and Compose adoption rate on dashboards

### §158. Migration ROI Measurement

- **Metrics**: Code line reduction rate, bug density change, build time change, development speed change
- **Phased Verification**: Measure ROI after each migration phase. Revise plan if effectiveness is low
- **Migration Testing**: A/B test UX metrics comparing old and new screens

---

## Part XXIX: Design System Integration

### §159. Material Design 3 / Material 3 Expressive

- **Material 3**: Android standard design system. Dynamic Color, Typography Scale compliance
- **Material 3 Expressive (2025)**: Expanded emotional design expression. Rich Motion, Shape, Color expression
- **Design Tokens**: Figma→code conversion. Centralized theme management with `MaterialTheme`
- **Custom Components**: Build project-specific components based on Material 3

### §160. Human Interface Guidelines (HIG)

- **HIG Compliance**: Strict compliance with HIG for iOS/macOS/visionOS/watchOS
- **SF Symbols**: Standard icon set. Create custom symbols in HIG format
- **Typography**: SF Pro / SF Mono / New York. Dynamic Type integration
- **Spacing/Layout**: 8pt grid system. Safe Area compliance

### §161. Liquid Glass Design System (iOS 26+)

- **Liquid Glass Principles**: Glassy transparent, rounded UI with depth expression
- **Auto-Application**: Automatically applied to existing apps when recompiled with Xcode 26
- **Customization**: Custom styling APIs via `.glass` modifier family
- **Compatibility**: Falls back to traditional design on iOS < 26
- **Accessibility**: Support for `Reduce Bright Effects` setting

---

## Part XXX: Embedded Systems & IoT

### §162. Embedded Swift

- **Embedded Swift**: Enhanced in Swift 6.2. Swift runtime for embedded systems
- **Targets**: IoT devices, automotive systems, appliance control
- **Package Traits**: Environment-adaptive build configurations optimized for embedded targets
- **Memory Constraints**: Minimal runtime overhead

### §163. Kotlin/Native Embedded

- **Kotlin/Native**: LLVM 19-based, supporting embedded targets
- **C Interop**: Direct C library calls via `cinterop`
- **Memory Management**: Reference counting-based. Predictable execution under real-time constraints
- **Binary Size**: Size reduction through optimization flags

### §164. IoT Protocol Integration

- **MQTT**: Lightweight messaging protocol. Low bandwidth, low power environments
- **Matter**: Smart home standard protocol. Apple/Google/Amazon common
- **Bluetooth LE**: Implementation patterns for both peripheral and central modes
- **Thread**: IPv6-based mesh networking

---

## Part XXXI: Networking & Communication

### §165. HTTP/3 (QUIC) Optimization

- **OkHttp 5+**: Default Android HTTP/3 support
- **URLSession**: Prefer HTTP/3 on iOS (enabled by default on iOS 15+)
- **0-RTT**: Reduced latency for initial connections
- **Connection Migration**: Connection persistence during network switching (Wi-Fi↔mobile)

### §166. gRPC Mobile

- **gRPC-Kotlin**: gRPC client for Kotlin. Coroutines integration
- **gRPC-Swift**: gRPC client for Swift. async/await integration
- **Protocol Buffers**: Payload size reduction. 70-80% reduction vs JSON
- **Streaming**: Server/Client/Bidirectional streaming support
- **Error Handling**: Proper mapping of gRPC status codes

### §167. WebTransport & WebSocket

- **WebSocket**: Standard for bidirectional real-time communication
- **WebTransport**: Next-generation real-time protocol based on HTTP/3
- **Connection Management**: Auto-reconnect + Exponential Backoff + Jitter
- **Bandwidth Control**: Message priority control based on network quality

---

## Part XXXII: Internationalization & Localization

### §168. String Management

- **Android**: Localize with `strings.xml`. `Plurals`/`StringArray` support
- **iOS**: Localization management with `String Catalog` (Xcode 15+). `.xcstrings` format
- **Type-safe Strings**: Hardcoded string keys prohibited. Use code-generated resource IDs
- **Translation Management**: TMS integration with CI via Crowdin / Lokalise / Phrase

### §169. RTL & Multilingual Layout

- **RTL Support**: Full RTL layout support for Arabic/Hebrew
- **Auto Layout**: Use `leading`/`trailing` instead of `left`/`right`
- **Testing**: Verify all screens in RTL mode (Android Developer Options / iOS Settings)
- **Fonts**: Language-specific font fallback configuration

### §170. Date, Currency & Number Formatting

- **ICU**: Use ICU-compliant APIs for locale-dependent formatting
- **`DateFormatter`/`NumberFormatter`**: Locale-dependent date/number formatting
- **Currency**: Locale-based currency formatting. Hardcoding prohibited
- **Relative Time**: Use RelativeDateTimeFormatter for expressions like "3 minutes ago"

---

## Part XXXIII: Data Transformation & Serialization

### §171. Kotlin Serialization

- **kotlinx.serialization**: Multiplatform serialization
- **JSON**: Set `Json { ignoreUnknownKeys = true }` as default
- **Versioning**: Guarantee API response backward compatibility with `@SerialName`/`@EncodeDefault`
- **Performance**: Migration from Gson. Faster due to no reflection

### §172. Swift Codable

- **Codable**: Swift standard encoding/decoding protocol
- **CodingKeys**: JSON↔Swift property name mapping
- **Custom Decoder**: Decoding strategies for complex API responses
- **Error Handling**: Proper catch of `DecodingError` and user-facing message conversion

---

## Part XXXIV: Dependency Management & SBOM

### §173. Dependency Management

- **Gradle Version Catalog**: Centralized management in `libs.versions.toml` (Android/KMP)
- **Swift Package Manager**: Version pinning with `Package.swift`+`Package.resolved`
- **CocoaPods**: Legacy. Gradual migration to SPM recommended
- **Renovate / Dependabot**: Automatic update PRs. Merge security patches within 72 hours
- **OSV Scanner**: Automatic detection of known vulnerabilities

### §174. SBOM (Software Bill of Materials)

- **CycloneDX**: Standard format for SBOM generation
- **EU CRA Compliance**: Prepare for EU Cyber Resilience Act SBOM mandate effective 2027
- **License Audit**: Check license compatibility of all dependencies
- **Vulnerability Tracking**: Continuous vulnerability monitoring based on SBOM

---

## Part XXXV: Error Handling Strategy

### §175. Kotlin Error Handling

- **Result Type**: Express errors type-safely with `kotlin.Result` or custom Sealed class
- **runCatching**: Use `runCatching`+`onSuccess`/`onFailure`/`fold` instead of try-catch
- **Exception Hierarchy**: Clearly separate business exceptions from technical exceptions
- **Coroutine Exceptions**: Control propagation with `CoroutineExceptionHandler` + `supervisorScope`

### §176. Swift Error Handling

- **Typed Throws (Swift 6)**: Explicitly declare error types in function signatures
- **Result Type**: Handle errors as values with `Result<Success, Failure>`
- **Guard Early Return**: Improve readability with early return pattern
- **do-catch**: Process recoverable errors. Catch clauses should be specific
- **Never Type**: Type-safe expression of infallible fallbacks

---

## Part XXXVI: Code Generation & Metaprogramming

### §177. Kotlin Code Generation

- **KSP (Kotlin Symbol Processing)**: KAPT successor. 2x+ build speed improvement
- **KSP-Compatible Libraries**: Room, Hilt, Moshi, kotlinx.serialization
- **Custom KSP Processors**: Project-specific boilerplate reduction
- **K2 Compiler Plugin API**: Stable compiler plugin API design in progress

### §178. Swift Macros

- **Swift Macros**: Compile-time code generation with `@Freestanding`/`@Attached` macros
- **`@Observable`**: Observation Framework macro
- **`@Model`**: SwiftData macro
- **`@Test`**: Swift Testing macro
- **Custom Macros**: Reduce project-specific repetitive code
- **Macro Build Performance (Swift 6.2)**: Significant improvement in clean build times for macro-using projects

---

## Part XXXVII: AI-Assisted Development & Copilot

### §179. AI Coding Assistants

- **GitHub Copilot / Gemini Code Assist**: Integrate AI code completion into IDE
- **Review Assistance**: AI-powered PR review support. Automatic security and performance checks
- **Test Generation**: AI assistant test code generation. Manual review mandatory
- **Constraints**: AI-generated code must always be human-reviewed. Verify license compatibility

### §180. AI-Native Development Patterns

- **Prompt Engineering**: Prompt design patterns for on-device LLMs
- **Structured Output**: Type-safe parsing of LLM output (JSON Schema/Codable integration)
- **RAG Integration**: On-device vector DB + LLM combination patterns
- **Edge-Cloud Hybrid**: Small models on-device, large models in cloud differentiation

---

## Part XXXVIII: Store Review Optimization

### §181. App Store Review Preparation

- **App Store Review Guidelines**: Regular check of latest version (2025 edition)
- **Rejection Avoidance**: Key guidelines: 4.3 (spam), 5.1.1 (data collection), 3.1.1 (IAP)
- **Complete Privacy Manifest**: Prevent review rejections due to manifest deficiencies
- **App Review Information**: Prepare test accounts and explanation materials for reviewers

### §182. Google Play Review Preparation

- **Developer Policy Update Tracking**: Regular monitoring of policy changes
- **Data Safety Section**: Accurate information declaration. Deficiencies risk store listing suspension
- **Foreground Service Type**: Prevent review rejection from inappropriate type declarations
- **Target API Level Requirements**: Always meet Google Play's latest targetSdk requirements

---

## Part XXXIX: Maturity Model & Anti-Patterns

### §183. Maturity Model (5 Levels)

| Level | Name | Characteristics |
|-------|------|----------------|
| L1 | Ad Hoc | No native standards. Platform knowledge is individual. No testing |
| L2 | Defined | Coding conventions and architecture guides established. Lint/Format unified. Unit testing introduced |
| L3 | Managed | CI/CD integration, automated tests 70%+, Baseline Profiles, a11y AA compliance, KMP adoption |
| L4 | Optimized | KMP sharing 85%+, on-device AI integration, performance budget operations, full Compose/SwiftUI migration |
| L5 | Autonomous | Auto regression detection, A/B model delivery, 0-day vulnerability auto-patch, SLO-driven development, Green SRE integration |

### §184. 30 Anti-Patterns

| # | Anti-Pattern | Correct Approach |
|---|-------------|-----------------|
| 1 | Excessive `!!` operator use | Safe handling with `?.`, `?:`, `let` |
| 2 | Hardcoded API Keys | Keystore/Keychain + CI Secrets |
| 3 | Main thread I/O | `Dispatchers.IO` / `Task.detached` |
| 4 | Raw MethodChannel | Use Pigeon |
| 5 | Sensitive data in SharedPreferences | EncryptedSharedPreferences/Keychain |
| 6 | Unresolved ARC circular references | Proper `[weak self]` usage |
| 7 | Full-screen recomposition | Fine-grained state management and deferred State reading |
| 8 | Release without tests | Unit/UI/E2E tests mandatory |
| 9 | Postponing a11y | Design for accessibility from Day 1 |
| 10 | Using deprecated APIs | Coroutines/async-await/latest APIs |
| 11 | No Baseline Profiles | Generate AOT profiles for critical flows |
| 12 | No Privacy Manifest | `PrivacyInfo.xcprivacy` mandatory |
| 13 | Unrestricted WebView JS | Minimum privilege + sanitization |
| 14 | No Root/JB detection | Play Integrity / App Attest |
| 15 | Immediate permission request | Pre-Permission Pattern with value explanation first |
| 16 | No offline support | Local DB SSOT + background sync |
| 17 | Single monolithic module | Feature Module splitting |
| 18 | No Certificate measures | Certificate Transparency / Pinning |
| 19 | Battery consumption neglect | Doze/BGTaskScheduler compliance |
| 20 | Unchecked store guidelines | Check latest policies before release |
| 21 | GlobalScope.launch | Use structured CoroutineScope |
| 22 | Continuing KAPT use | Migrate to KSP |
| 23 | Continuing ObservableObject use | Migrate to `@Observable` macro (iOS 17+) |
| 24 | Using K1 compiler | Migrate to K2 compiler |
| 25 | Pinning Only (no CT) | Prioritize Certificate Transparency |
| 26 | Using Context Receivers | Migrate to Context Parameters (Kotlin 2.2+) |
| 27 | New Combine usage | Migrate to `@Observable` + `Observations` |
| 28 | No SBOM generation | Generate CycloneDX SBOM for EU CRA readiness |
| 29 | Not considering InlineArray | Leverage for performance-critical sections |
| 30 | No EAA compliance | WCAG 2.2 AA compliance to mitigate legal risk |

---

## Part XL: Future Outlook

### §185. Technology Trends (2026-2028)

- **Kotlin/Wasm GA**: Web target reaching full stable
- **Swift Embedded GA**: Stable Swift for embedded systems
- **Compose Multiplatform Full-Platform Stable**: All targets (iOS/Web/Desktop) reaching stable
- **AI-Native Development**: AI Copilot code generation, review, and test automation becoming standard
- **Quantum-Safe Cryptography**: ML-KEM/ML-DSA mobile crypto libraries
- **Spatial Computing Proliferation**: visionOS/Android XR ecosystem maturation
- **Context Parameters GA (Kotlin 2.3+)**: Context-dependent DI/DSL standardization
- **Swift Value Generics**: Further expansion of compile-time constant generics

### §186. Recommended Learning Path

- **Android**: Kotlin 2.2 → Compose 1.10 → Hilt → KMP → ML Kit → Compose Multiplatform → Android XR
- **iOS**: Swift 6.2 → SwiftUI → SwiftData → Observation → Foundation Models → visionOS
- **Common**: Clean Architecture → CI/CD → Security → Accessibility → Performance Optimization → SBOM/CRA

---

## Appendix A: Quick Reference Index

| Keyword | Referenced Sections |
|---------|-------------------|
| Kotlin 2.2 / K2 / Context Parameters | §5–§7 |
| Kotlin 2.2.20 / Swift Export / Wasm Beta | §6, §36 |
| Swift 6.2 / Approachable Concurrency / @concurrent | §11–§12 |
| InlineArray / Span / Memory Safety | §14 |
| Sendable / Actor / Structured Concurrency | §12, §58 |
| KMP / Kotlin Multiplatform / Swift Export | §34–§40 |
| Compose Multiplatform / iOS Stable | §41–§44 |
| Jetpack Compose / Pausable Composition / retain | §45–§50 |
| SwiftUI / @Observable / Observations | §51–§56 |
| Liquid Glass / iOS 26 | §27, §56, §161 |
| Baseline Profiles / Macrobenchmark | §49, §111 |
| Coroutines / Flow / StateFlow | §57 |
| async/await / TaskGroup | §58 |
| Android 16 / Embedded Photo Picker / ARR | §22, §66, §100 |
| Room / SwiftData / Offline-First | §79–§85 |
| Core ML / ML Kit / On-Device AI | §71–§78 |
| Apple Foundation Models / Gemini Nano | §74, §75 |
| Security / Keystore / Keychain | §86–§94 |
| Passkeys / FIDO2 / Biometrics | §88 |
| RASP / Play Integrity / App Attest | §89 |
| Certificate Transparency / Pinning | §90 |
| Privacy Sandbox / Android 16 | §92 |
| Privacy Manifest / ATT | §28, §148 |
| Push Notifications / FCM / APNs | §95 |
| Deep Links / Universal Links | §96 |
| WidgetKit / Glance / Live Activities | §97 |
| Health Connect / HealthKit / FHIR | §101 |
| Pigeon / Platform Channel | §102 |
| Swift Testing / @Suite / Tags | §107, §108 |
| Screenshot Testing / Paparazzi | §114 |
| Testing / JUnit5 / Maestro | §107–§113 |
| CI/CD / Staged Rollout / Feature Flag | §115–§122 |
| Gradle 9.x / Convention Plugin / Amper | §121 |
| Xcode Cloud / Fastlane / Tuist | §122 |
| Accessibility / VoiceOver / TalkBack | §123–§127 |
| WCAG 2.2 / EAA 2025 | §126, §152 |
| LE Audio / Hearing Aids | §127 |
| Crashlytics / OpenTelemetry Mobile | §128–§132 |
| FinOps / App Size / Build Cost | §133–§136 |
| visionOS / Spatial Computing | §137–§139 |
| Wear OS / watchOS | §140–§142 |
| Android XR / ARCore | §143–§144 |
| Green Engineering / Battery | §145–§147 |
| EU CRA / SBOM / GDPR / APPI | §150, §174 |
| Design System / Material 3 Expressive / HIG | §159–§161 |
| Embedded Swift / IoT / Matter | §162–§164 |
| HTTP/3 / gRPC / WebTransport | §165–§167 |
| Internationalization / RTL / String Catalog | §168–§170 |
| kotlinx.serialization / Codable | §171–§172 |
| Dependency Management / SBOM | §173–§174 |
| Error Handling / Result Type / Typed Throws | §175–§176 |
| KSP / Swift Macros / Code Generation | §177–§178 |
| AI-Assisted Development / Copilot | §179–§180 |
| Store Review / ASO | §181–§182 |
| Maturity Model / Anti-Patterns | §183–§184 |

---

## Appendix B: Cross-References

| Related Rule | File | Related Topic |
|-------------|------|--------------|
| Mobile Development (Flutter) | [342_mobile_flutter.md](../en/342_mobile_flutter.md) | Flutter-specific best practices |
| Store Submission Compliance | [103_appstore_compliance.md](../en/103_appstore_compliance.md) | IAP/ASO/Review Guidelines |
| Security | [600_security_privacy.md](../en/600_security_privacy.md) | Zero Trust/OWASP/Encryption |
| Design & UX | [200_design_ux.md](../en/200_design_ux.md) | Accessibility/Touch Targets |
| AI Implementation | [400_ai_engineering.md](../en/400_ai_engineering.md) | On-Device AI/Edge ML |
| QA & Testing | [700_qa_testing.md](../en/700_qa_testing.md) | Test Pyramid/E2E |
| Engineering General | [300_engineering_standards.md](../en/300_engineering_standards.md) | CI/CD/Coding Conventions |
| Legal & Privacy | [601_data_governance.md](../en/601_data_governance.md) | GDPR/Privacy Manifest/EU CRA |
| License Management | [602_oss_compliance.md](../en/602_oss_compliance.md) | SBOM/Dependency Management |
| SRE & Reliability | [502_site_reliability.md](../en/502_site_reliability.md) | Observability/SLO/Green SRE |
| Analytics Intelligence | [401_data_analytics.md](../en/401_data_analytics.md) | OTel Mobile/Mobile Analytics |
| Language Protocol | [802_language_protocol.md](../en/802_language_protocol.md) | Mobile-specific Language Protocol |
| Global Expansion | [800_internationalization.md](../en/800_internationalization.md) | Mobile i18n/RTL Support |
