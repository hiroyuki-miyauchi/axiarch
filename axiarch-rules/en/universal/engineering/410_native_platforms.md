# 36. Native Platforms (Kotlin & Swift)

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-07-23 | Scope: supported stable Kotlin / Swift releases (verified baseline: Kotlin 2.4.10 / Swift 6.3; platform research baseline: Android 16 / iOS 26)

> [!IMPORTANT]
> **Primary Directive**
> "Native is not a compromise — it is the shortest path to the best user experience."
> Even in cross-platform-first environments, never compromise on native quality for deep OS integration, cutting-edge AI, and hardware access.
> Strictly follow the priority order for native platform implementations: **Security > UX > Performance > Maintainability > Development Speed**.
> This document is the primary standard for all design decisions regarding native platform strategy.
> **40 Parts, 186 Sections.**

---

## Table of Contents

| Part | Topic | Sections |
|------|-------|---------| 
| I | Philosophy & Fundamentals | §1–§4 |
| II | Kotlin Language Standards | §5–§10 |
| III | Swift Language Standards | §11–§17 |
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

### Universal Applicability Contract

This file governs Kotlin-, Swift-, Android-, and Apple-platform-specific compatibility and safety without forcing one project's architecture, libraries, repository layout, or organization chart on every adopter. Interpret all sections in this order:

1. Official platform constraints, store requirements, language safety, and artifact compatibility are normative.
2. Architecture patterns, libraries, CI providers, device farms, and code-generation tools are reference implementations; an alternative with equivalent outcomes and evidence conforms.
3. OS support breadth, sharing percentage, coverage, build time, vulnerability SLA, review SLA, rollout percentage, organization headcount, and cadence are Blueprint parameters derived from user distribution, threat model, regulation, service level, and team scale.
4. When later wording such as required, prohibited, always, a fixed number, or a product name conflicts with this contract, treat the verifiable outcome as normative and the stated mechanism as a non-normative reference default unless an official constraint or explicit safety rationale is present.
5. Individuals and small teams may combine accountabilities. Prefer independent review for high-assurance changes; when separation is impossible, record risk acceptance and add an independent release control. A large organization may separate the same responsibilities into specialist functions.

### §1. Primary Directive — Native Excellence

- **Principle**: Native development is the means to achieve the highest standard of user experience, not a supplement to cross-platform
- **Priority**: Security > UX > Performance > Maintainability > Development Speed
- **Quality Outcomes**: For OS-specific APIs and hardware integration, assure UX, safety, performance, and recoverability through measurable acceptance criteria. Do not use an unmeasurable phrase such as "100%" as an acceptance gate
- **Supported Releases**: Production exactly pins a stable release inside the official support window. Current stable is the first candidate for new adoption, but verify OS, SDK, library, and enterprise-support compatibility first. Permit new use of a deprecated API only under a time-bounded exception with a no-alternative rationale and exit condition
- **Platform Conventions First**: Fully comply with each platform's HIG/Material Design Guidelines. Do not forcefully unify UX patterns across platforms
- **Privacy by Design**: Minimize user data collection and prioritize on-device processing

### §2. Platform Selection Matrix

| Use Case | Recommended Approach | Rationale |
|---|---|---|
| Business logic sharing | Evaluate KMP (`commonMain`) | Measure duplication reduction and platform fidelity; sharing percentage is not the goal |
| UI-intensive apps | Compose Multiplatform | iOS stable reached, maximized dev efficiency |
| Deep OS integration (HealthKit, NFC, etc.) | Platform-specific native | API constraints / HW dependency |
| High-performance real-time processing | Native (Kotlin/Swift) | Minimized latency |
| Widgets / App Clips / Dynamic Island | Platform-specific native | OS requirements |
| On-device AI | Core ML / ML Kit + Native | Hardware accelerator optimization |
| visionOS / Spatial Computing | SwiftUI + RealityKit | Apple-exclusive ecosystem |
| Android XR / Immersive | Jetpack XR + ARCore | Google XR ecosystem |
| Embedded Systems / IoT | Kotlin/Native / Embedded Swift | Low-level HW control |

### §3. Architecture Principles

- **Separation of Responsibilities**: Design Domain, Data, Presentation, or equivalent boundaries from reasons to change, testability, and dependency direction. Three-layer Clean Architecture is a reference pattern, not a fixed structure
- **Dependency Inversion**: Upper layers must not depend on concrete implementations of lower layers
- **Single Source of Truth (SSOT)**: Identify the authoritative source for each state domain. A local database may serve offline-first systems, but Room, SwiftData, and local-first design are not mandatory for every system
- **State Flow**: Make state-update ownership, direction, side effects, and concurrency predictable. UDF, MVI, and TCA are reference patterns
- **Module Boundaries**: Design module boundaries from codebase scale, change frequency, ownership, and the build graph. Feature modules are one option; avoid needless fragmentation
- **Composition over Inheritance**: Prefer composition over inheritance. Protocol/interface-oriented design
- **Defensive Programming**: Distrust all external inputs and enforce validation at boundaries

### §4. Versioning Strategy

- **Minimum OS**: Derive Android `minSdk` and Apple deployment targets from user distribution, security updates, required APIs, law, and support cost. `minSdk = 28` and iOS 16 are reference baselines as of 2026-07-23
- **Target SDK**: Use a target SDK that satisfies store policy and official deadlines and is verified with the adopted toolchain. Android 16 or API 36 and the latest Apple SDK are verification examples as of 2026-07-23, not fixed values
- **Language Version**: Production must exactly pin a supported stable release. The baseline verified on 2026-07-23 is Kotlin 2.4.10 and Swift 6.3. When platform or vendor constraints require an older supported release, record its support window, owner, migration deadline, and compatibility tests in an ADR
- **Android Toolchain Compatibility**: Verify the official Kotlin, AGP, D8, R8, JDK, and Compose compiler compatibility matrix. Never update the language version in isolation
- **Deprecated API SLA**: Derive migration deadlines from scheduled removal, security impact, usage, and alternative maturity. Two release cycles is a reference default
- **OS Support Policy**: Define the support matrix from user distribution, vendor security support, required capabilities, and test capacity, and verify at least the minimum-supported and current OS
- **Dependency Updates**: Set a risk-based SLA from exploitability, KEV or EPSS, data sensitivity, exposure, and compensating controls. Seventy-two hours and a 21-day wait are reference values; Renovate and Dependabot are implementation examples

---

## Part II: Kotlin Language Standards

### §5. Major Language Features Since Kotlin 2.2

- **Guard Conditions (Stable)**: Guard conditions in `when` expressions for improved readability
- **Non-local break/continue (Stable)**: Leverage `break`/`continue` inside inline function lambdas
- **Multi-dollar interpolation (Stable)**: Simplified escaping for strings with frequent `$` literals
- **Context Parameters (Stable in Kotlin 2.4)**: Simplified context-dependent dependency management and the successor to Context Receivers. Treat explicit context arguments and callable references as separate experimental features
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

// ✅ Good: Context Parameters (Stable in Kotlin 2.4)
context(logger: Logger, db: Database)
fun processOrder(order: Order): Result<Receipt> {
    logger.info("Processing order: ${order.id}")
    return runCatching { db.save(order.toEntity()) }
        .map { Receipt(order.id, it.timestamp) }
}
```

### §6. Evolution from Kotlin 2.2.20 to the 2.4 Line

- **2.2.20 Migration Foundation**: Treat Kotlin/Wasm Beta, the shared `js` / `wasmJs` source set, JS Long-to-BigInt mapping, and Xcode 26 support as capabilities introduced by that release
- **2.4 Stabilization**: Context parameters, explicit backing fields, the common standard-library UUID API, and Kotlin/Wasm incremental compilation are stable. Do not retain obsolete preview opt-ins by inertia
- **JVM / Java Boundary**: Java 26 bytecode, Maven Toolchains, and Java / JVM target alignment are available. Define the adopted JDK and consumer support matrix first
- **Kotlin/Native**: Swift Export became Alpha in 2.4, with Swift package import and improved concurrency mapping. Production adoption still requires a compatibility matrix, fallback, and generated-API diff tests
- **Kotlin/Wasm**: The WebAssembly Component Model remains experimental. Do not treat browser, WASI, and FaaS as one runtime; separate host capabilities and security boundaries
- **Compatibility**: Kotlin 2.4 no longer supports K1. Verify compiler plugins, KSP / kapt processors, Gradle, AGP, D8 / R8, and Compose in one upgrade PR

### §7. K2 Compiler

- **Mandatory Enablement**: Use the K2 compiler. Kotlin 2.4 no longer supports K1, so any compatibility mode for older estates requires an owner, deadline, and compiler-plugin compatibility tests
- **Build Speed**: Measure K2 improvement on the project's clean and incremental builds, cache hits, and CI runners. Published benchmarks are supporting evidence, not a guaranteed improvement for an individual build
- **Type Inference Improvement**: Unified data structure for more accurate type inference and call resolution
- **Multiplatform Consistency**: Guarantees identical compilation behavior across JVM/JS/Native
- **KAPT→KSP Migration**: Default new processors to KSP where supported. Migrate existing kapt usage incrementally with processor compatibility checks, blocker, owner, deadline, and generated-API diff tests

```kotlin
// build.gradle.kts — K2 + KSP configuration
plugins {
    id("com.google.devtools.ksp") version "<pinned-compatible-version>"
}

kotlin {
    compilerOptions {
        allWarningsAsErrors.set(true)
    }
}
```

Do not retain the old preview flag for context parameters on Kotlin 2.4. Inventory only the specific opt-in for experimental features such as explicit context arguments when they are used.

### §8. Null Safety & Type Safety

- **`!!` operator prohibited**: Force unwrap is prohibited without exception. Use `?.`, `?:`, `let`
- **`requireNotNull`/`checkNotNull`**: Limited to assertions for programming errors
- **Result type**: Use `kotlin.Result` or custom Sealed class for fallible operations
- **Data classes**: Use `data class` for DTOs and value objects. Eliminate boilerplate
- **Immutability first**: `val` > `var`, `List` > `MutableList`, `Map` > `MutableMap`
- **Sealed Hierarchies**: Prefer a sealed class or interface for closed state sets and error taxonomies; where the contract requires open extension, choose an interface or equivalent and test unknown values and compatibility
- **Value class**: Leverage `@JvmInline value class` for semantic type distinction (UserId, Email, etc.)

### §9. Code Style & Linters

- **Style Guide**: Strictly follow [Android Kotlin Style Guide](https://developer.android.com/kotlin/style-guide)
- **Formatter and Lint**: Pin ktlint, detekt, or equivalent controls and run them in the change gate. A suppression has a reason, scope, owner, and expiry. A Pull Request is one gate implementation
- **detekt**: Static analysis for Complexity, Naming, Performance. Custom rule sets recommended
- **Naming Convention**: `lowerCamelCase` base, constants `UPPER_SNAKE_CASE`, packages `lowercase`
- **Function Complexity**: Judge lines, branches, responsibility, nesting, and testability. Thirty lines is a reference review heuristic, not a fixed conformance threshold
- **Extension Functions**: Organize utility code as extension functions. Limit receiver type scope
- **Scope Function Guidelines**:
  - `let`: Null safety chaining / variable scope limitation
  - `apply`: Object initialization configuration
  - `also`: Side effects (logging, etc.)
  - `run`: Execute processing within receiver context
  - `with`: Multiple operations on non-null objects

### §10. Kotlin Native & Wasm

- **Kotlin/Native**: Kotlin 2.4 is based on LLVM 21. With CMS GC as the default, measure pauses, throughput, and peak memory on representative devices
- **Stack Canaries**: Enable stack canaries in release binaries (buffer overflow detection)
- **Binary Size**: Release build optimizations for binary size reduction
- **Kotlin/Wasm (Beta)**: Web target reached Beta. Per-project Binaryen configuration customization
- **Shared Source Sets**: Leverage shared source sets between `js` and `wasmJs` targets
- **Type-safe builders**: Build domain-specific configurations type-safely with Kotlin DSL patterns

---

## Part III: Swift Language Standards

### §11. Swift 6.2 Approachable Concurrency

- **Default actor isolation**: Swift 6.2 can default a module or target to `MainActor` isolation. Record the build setting and annotate public or cross-module boundaries when the contract would otherwise be ambiguous; do not assume every script, package, or UI-adjacent function has the same isolation
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

- **Strict Concurrency**: Enable complete checking for Swift 6 production modules and migrate warnings through bounded, owned exceptions so data-race safety is verified rather than silently disabled
- **`Sendable` protocol**: Types shared across threads must conform to `Sendable`
- **Actor isolation**: Prefer actors for shared mutable state when their isolation and reentrancy model fits. Locks, atomics, and other primitives remain valid at measured low-level boundaries with documented invariants, ownership, and tests
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
- **Value and reference semantics**: Prefer `struct` for independent values and `class` or actors for identity, shared lifetime, or reference semantics. Record mutability and isolation instead of applying a universal type ranking
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
- **Version Resolution**: An app or executable root commits `Package.resolved` and verifies the same resolution in CI. Because a published package's `Package.resolved` does not pin consumer resolution, assure compatibility through declared constraints, pinned CI test and release resolution, minimum and maximum supported ranges, and a locked example app when needed
- **Dependency Minimization**: Keep package dependencies minimal. Evaluation via OpenSSF Scorecard recommended

### §16. Code Style & Linters

- **Formatter and Lint**: Pin SwiftLint, SwiftFormat, or equivalent controls and integrate them into the change gate. A suppression has a reason, scope, owner, and expiry. A Pull Request is one gate implementation
- **Naming Convention**: Strictly follow Apple Swift API Design Guidelines
- **Trailing comma**: Swift 6.1 supports trailing commas in various lists. Enable recommended
- **Documentation Comments**: Mandatory `///` for all public APIs

### §17. Swift 6.3, Cross-Platform, and Embedded Swift

- **WebAssembly Official Support (Swift 6.2)**: Compilation targeting browser and serverless runtimes
- **Embedded Swift**: Swift for embedded systems. IoT/automotive domains
- **Enhanced C++ Interoperability (Swift 6.2)**: Seamless integration with C++ projects
- **Swift 6.3 C Interoperability**: Use `@c` and `@implementation` to make C ABI boundaries explicit, and test generated headers, ownership, errors, allocation, and ABI compatibility
- **Swift SDK for Android**: Swift 6.3 provides the first official release, but adoption must prove JNI boundaries with Kotlin / Java, Android toolchain compatibility, binary size, debugging, and on-call capability in an ADR. It does not automatically replace the default mobile stack
- **Swift Build Integration**: Treat Swift Package Manager integration as a preview. Adopt a production build-system change only after measuring reproducibility, cache behavior, plugins, and CI parity
- **Subprocess Package**: Launch and manage subprocesses directly from Swift code
- **VS Code Extension**: Background indexing, LLDB integration, DocC live preview

---

## Part IV: Android Architecture

### §18. Jetpack Library Stack

- **BOM Management**: Unify Compose dependency versions with `androidx.compose:compose-bom`
- **Capability-Based Library Selection**: State the needed UI, design-system, navigation, lifecycle, DI, persistence, settings, and background-work capabilities, then adopt only fitting tools such as Compose, Material, Hilt, Room, DataStore, or WorkManager
- **Dependency-Version Source of Truth**: Use one resolution source suited to the build, such as a version catalog, platform or BOM, lock, or central-management plugin. `libs.versions.toml` is an implementation example
- **Type-Safe Navigation**: Verify route contracts with types or schemas and avoid implicit string contracts. Compose Navigation's type-safe API is an implementation example

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

### §21. Dependency Injection

- **Selection Criteria**: Select DI from object lifecycle, scope, startup, code generation, KMP compatibility, test substitution, and debuggability. Hilt, Koin, compile-time DI, and explicit manual composition may all conform
- **Boundary**: Centralize creation responsibility and scope for ViewModels, services, and repositories at composition roots, avoiding implicit service-locator dependencies
- **Module Splitting**: Divide modules according to reasons the dependency graph changes and ownership, not a universal feature-per-module rule
- **Test Substitution**: Safely replace production bindings with test doubles and prevent scope leaks or an unverified alternate graph. `@TestInstallIn` is an implementation example when using Hilt

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

### §26. Apple UI Architecture

- **UI framework selection**: Evaluate SwiftUI first for new UI when the deployment target, required platform APIs, performance, accessibility, and team capability fit. UIKit, AppKit, or mixed composition remains valid when those constraints require it
- **State and responsibility boundaries**: Separate rendering, state transitions, side effects, and domain logic. MVVM with `@Observable`, TCA, and other unidirectional patterns are replaceable implementations, not universal architecture mandates
- **Migration**: Introduce framework changes at a screen or capability boundary with interoperability, rollback, and regression tests; do not require a full rewrite
- **Previews**: Use SwiftUI Previews where they improve feedback, but retain executable unit, integration, accessibility, and device tests because previewability is not proof of correctness

### §27. iOS 26 Framework Integration

- **Liquid Glass**: iOS 26's new design language. Glassy transparent, rounded UI elements auto-applied
- **Foundation Models Framework**: On-device LLM (~3B parameters) access API
- **HealthKit**: Health data integration. Keep permission requests minimal
- **StoreKit 2**: In-app purchases. Use `Product`/`Transaction` APIs
- **PhotosUI**: Use `PhotosPicker` for system photo picker
- **WebView (SwiftUI)**: Native SwiftUI `WebView` component (new in iOS 26)

### §28. Privacy Manifest and Required-Reason APIs

- **Applicability**: Generate and validate `PrivacyInfo.xcprivacy` when current Apple policy requires it for the app, embedded SDK, collected data, tracking, or Required Reason API usage. Re-evaluate at every SDK and store-policy change
- **Required Reason API**: Inventory APIs such as UserDefaults, file timestamps, system boot time, and disk space, then declare only approved reasons that match actual behavior
- **Tracking Domains and Data**: Keep tracking domains and collected-data declarations consistent with runtime behavior, consent, App Store privacy details, and third-party SDKs
- **Third-party SDKs**: Verify required manifests and signatures for embedded SDKs. Replace, update, or place a time-bounded exception on a non-compliant SDK rather than assuming every SDK has the same manifest obligation

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

### §31. Deployment Target Decision Contract

A deployment target is a Blueprint parameter; a fixed OS version is not a Universal conformance condition. Determine every target from user distribution, vendor security support, required APIs, store deadlines, hardware constraints, test capacity, legal or contractual duties, and support cost. Record the evidence date and re-evaluation triggers.

| Target | Primary Decision Evidence | Required Verification |
|--------|---------------------------|-----------------------|
| iOS / iPadOS | active-device distribution, security updates, required SDKs and APIs, enterprise fleet | minimum supported OS, current OS, upgrade install, stored-data migration, accessibility |
| macOS | hardware and OS fleet, distribution method, sandbox and entitlements, required frameworks | minimum and current OS, Intel and Apple silicon scope, signing and notarization, upgrade |
| watchOS | paired-iPhone constraints, sensor and background APIs, deployed devices | supported pairs, minimum and current OS, disconnection, battery, accessibility |
| tvOS | remote input, media and DRM, deployed device generations | minimum and current OS, focus, network, media playback |
| visionOS | target users, device availability, spatial APIs, alternative experience | device or justified test environment, safety, comfort, fallback, performance |

iOS 16, macOS 13, watchOS 9, tvOS 16, and visionOS 1 may be evaluation examples as of 2026-07-23, but they are not a reusable default support range or a coverage guarantee. Re-evaluate with official data and product telemetry for every release plan.

### §32. Xcode Configuration Standards

- **Strict Concurrency Checking**: Set to `Complete`
- **Swift 6 Language Mode**: Enable
- **Build Settings**: `SWIFT_STRICT_CONCURRENCY = complete`
- **Warnings as Errors**: Enable `-warnings-as-errors`
- **Code Signing**: Protect credentials with least privilege and retain a reproducible automated-signing or controlled-signing procedure plus audit evidence. Xcode Cloud and Fastlane are implementation examples

### §33. Observations & Reactive Patterns

- **`Observations` async sequences (Swift 6.2)**: Stream transactional state changes of observable types
- **UIKit Integration (iOS 26+)**: UIKit automatically integrates Swift Observation. Auto-tracking in `layoutSubviews`, etc.
- **Observation selection**: Select Observation, `Observations`, Combine, or `AsyncSequence` by state versus event semantics, deployment target, backpressure, cancellation, and interoperability. A migration needs measured benefit and a compatibility plan

---

## Part VI: KMP / Kotlin Multiplatform

### §34. KMP Architecture Design

- **Right-Size `commonMain`**: Share business logic, data, and domain models where doing so improves maintainability and testability without hiding platform differences. Do not use sharing percentage as a KPI
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

### §36. Swift Export (Alpha and Gradual Adoption)

- **Swift Export**: Alpha in Kotlin 2.4, with improved structured concurrency and `Flow`-to-`AsyncSequence` mapping. Do not treat it as the production default or an unconditional replacement for Objective-C export
- **Swift Type Mapping**: Kotlin types map directly to Swift native types
- **Nullability Preservation**: Kotlin null safety accurately converts to Swift `Optional`
- **Adoption Conditions**: Contract-test public API differences, concurrency, exceptions, binary compatibility, the Xcode and Swift matrix, and the Objective-C export fallback in both languages

### §37. KMP Gradual Adoption Strategy

1. **Phase 1**: Share data models and DTOs (minimal risk)
2. **Phase 2**: Share network layer and repositories
3. **Phase 3**: Share domain logic and UseCases
4. **Phase 4**: Share UI with Compose Multiplatform (optional)
- **Team Capability**: Before adoption, verify practical capability in KMP, Swift and Kotlin boundaries, builds, debugging, and incident response. Workshops are one training mechanism
- **Gradual Migration**: KMP-ify new features first. Bulk migration of existing code prohibited

### §38. KMP Testing Strategy

- **`commonTest`**: Place tests for shared logic in `commonTest`
- **`androidTest` / `iosTest`**: Place platform-specific tests in respective source sets
- **Test Runners**: JUnit5 (Android), via XCTest (iOS)
- **Mocking**: Design testable code in `commonMain` with interface-based approach

### §39. KMP Build Optimization

- **Gradle Configuration**: Suppress stability warnings with `kotlin.mpp.stability.nowarn=true`
- **Incremental Compilation**: Leverage K2 multiplatform incremental compilation
- **Caching**: Use build caches only when reproducibility, cache keys, secrets, tenant separation, and recovery from poisoning are verified. A remote cache is an optional enhancement when scale and economics justify it
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

- **Applicability decision**: For Android applications where startup or critical-flow latency matters, measure whether an app-specific Baseline Profile materially improves representative devices beyond library-provided profiles
- **Generation Method**: When adopted, cover measured critical user flows with Macrobenchmark or an equivalent and version the profile with the release artifact
- **Evidence**: Retain before-and-after startup, frame, binary-size, and build-cost evidence instead of assuming a fixed percentage improvement
- **CI Integration**: Regenerate and validate the profile when covered code, toolchains, or target devices change; the Blueprint selects the CI or release gate

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
            Text("Total: $\\(viewModel.total)")
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

- **`async/await`**: Replace callback-heavy flows with structured `async/await` where practical. Enforce Structured Concurrency
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
- **Gradual Migration**: Treat Swift Concurrency as the first candidate for new asynchronous code. A boundary that retains GCD or callbacks has platform-API, latency, interop, or comparable rationale and tests. Plan existing migration from inventory, risk, compatibility, and capacity

---

## Part XI: Performance Optimization

### §64. Startup Time Optimization

- **Cold Start Budget**: Define the percentile and measurement point in the Blueprint from user device distribution, operating systems, launch paths, and the UX SLO, and continuously measure release artifacts. Five hundred milliseconds is a product-specific reference budget
- **Android Measures**: Lazy initialization of Content Providers, App Startup library, Baseline Profiles
- **iOS Measures**: Minimize `pre-main` time, minimize dylibs, leverage Static Linking
- **Measurement**: Continuously monitor with complementary platform metrics, device labs, and field telemetry. Firebase App Start Trace and MetricKit `MXAppLaunchMetric` are implementation examples
- **Splash Screen**: Unified with Android 12+ `SplashScreen` API / iOS Launch Storyboard

### §65. Memory Management

- **Android**: LeakCanary (debug) + StrictMode. Bitmap reuse (`BitmapPool`)
- **iOS**: Instruments Allocations/Leaks. Proper Autoreleasepool usage
- **Image Management**: Memory cache management with Coil (Android) / Kingfisher (iOS)
- **Large Heap Avoidance**: `android:largeHeap="true"` is a last resort. Prioritize fundamental memory optimization
- **Memory Budget**: Define it in the Blueprint from device class, OS kill policy, feature, and foreground or background state; measure peak, steady state, leaks, and recovery under memory pressure. Fifty megabytes is a reference value

### §66. Rendering Performance

- **Rendering Budget**: Define frame-time, jank, and long-frame budgets from target-display refresh rates and the UX SLO. Do not fix 60 or 120 fps for every screen; measure animation, battery, thermal, and accessibility effects
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
- **Target**: Follow the §134 Blueprint budget and measure initial download, install, and update size from artifacts. Decide asset splitting and on-demand delivery with UX, offline needs, and retention cost included
- **R8/ProGuard**: Automatic removal of unused code and resources
- **Asset Compression**: Select from formats supported by target operating systems and devices after measuring quality, decode performance, licensing, accessibility, and fallbacks, and remove unused variants
- **Monitoring**: Generate a size-difference report for size-affecting changes and releases, preserving evidence that budget overruns are approved or blocked. A Pull Request is an implementation example

### §70. Hardware Resource Monitoring

- **`getCpuHeadroom`/`getGpuHeadroom` (Android 16)**: Real-time hardware availability monitoring
- **Dynamic Quality Adjustment**: Dynamic control of rendering quality and AI inference accuracy under resource pressure
- **Thermal State API**: Processing load reduction based on device thermal state
- **Use Cases**: Games, camera, AR/VR, on-device AI inference

---

## Part XII: On-Device AI & Edge ML

### §71. On-Device AI Strategy

- **Placement Decision**: Select on-device, cloud, or hybrid processing from data sensitivity, latency, offline needs, model capability, device coverage, energy, cost, and law. On-device placement alone is not a privacy guarantee
- **Offline Contract**: Define which flows, quality, fallback, synchronization, and model availability are required offline; do not force network independence on every AI feature
- **Performance Budget**: Derive inference latency, model and download size, memory, battery, thermal, and quality budgets from representative devices and user flows in the Blueprint
- **Distribution**: Choose bundled, on-demand, OTA, or another method from runtime compatibility, signatures, rollback, store policy, and network and storage constraints
- **Hardware Utilization**: Profile Neural Engine, NPU, GPU, CPU, or other paths and verify benefit and fallback on supported devices

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

The following numbers are starting reference budgets for measuring a small interactive model, not Universal conformance thresholds. Calibrate them in the Blueprint from the model, task, devices, UX SLO, quality, safety, and energy, and state percentiles and representative devices.

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

- **Applicability**: Decide offline, cache-only, read-through, or online-required behavior per capability from user needs, data sensitivity, consistency, and operational cost
- **SSOT**: Declare the authoritative source for each data domain. A local database may be the read model or offline authority, but the server, device, or another system may own writes and conflict resolution
- **Optimistic Updates**: When used, predefine idempotency, rollback, conflict policy, and user-visible failure behavior
- **Network State Awareness**: Observe connectivity through platform APIs such as `ConnectivityManager` or `NWPathMonitor`, while treating reachability as a hint rather than proof that a dependency works
- **Data Consistency and Queues**: Select version checks, server arbitration, CRDT, last-write-wins, merge UI, or another policy from domain semantics. Bound, encrypt where needed, migrate, retry, and purge offline queues

### §80. Android Data Persistence — Room

- **Selection**: Room is a reference implementation for structured SQLite persistence. Select it, another database, files, preferences, or no durable local store from schema, query, encryption, migration, and offline requirements
- **Room toolchain**: When Room is adopted, pin a compatible Room, Kotlin, Gradle, and KSP or supported processor matrix and verify generated-schema differences
- **Migration**: Prefer automatically verifiable migrations where supported, and use explicit migrations when transformation or review is required. Destructive fallback needs explicit data-loss approval
- **Reactive queries**: Expose `Flow`, paging, or another lifecycle-aware API only where consumers need streaming updates and cancellation
- **Paging**: Use `PagingSource`, `RemoteMediator`, or an equivalent only for datasets whose size and access pattern justify pagination

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

- **Secure Storage**: Store authentication tokens, encryption keys, and sensitive data in a protected facility suited to the threat model and accessibility needs, such as Keychain, Secure Enclave integration, or a hardware-backed keystore; define backup, migration, logout, and device-lock behavior
- **`kSecAttrAccessibleWhenUnlockedThisDeviceOnly`**: Device lock-linked access control
- **UserDefaults**: Use only for small non-sensitive preferences. When current Apple policy classifies the accessed API as a Required Reason API, declare an approved reason consistent with actual behavior
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
- **Transport Encryption**: Require platform-standard certificate and hostname validation and prohibit cleartext for protected traffic. Prefer TLS 1.3; allow a currently supported TLS 1.2 configuration only when platform or dependency compatibility requires it and weak algorithms are disabled
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
- **Root/Jailbreak Detection**: Use integrity and tamper signals according to the threat model. They may trigger step-up, restricted capability, or investigation, but never replace server-side authentication and authorization
- **RASP**: Runtime self-protection. Tampering detection, reverse engineering defense, hooking detection
- **Code Obfuscation**: ProGuard/R8 (Android). iOS Swift limited due to ABI stability
- **Debugger Detection**: `ptrace` detection (iOS), `Debug.isDebuggerConnected()` (Android)

### §90. Network Security

- **Certificate Transparency**: Use platform trust and Certificate Transparency where available as the default public-PKI evidence; it is not an application-identity substitute in every threat model
- **Certificate Pinning**: Adopt only for controllable, high-risk endpoints with a rotation and recovery design. Prefer SPKI pins, include an independent backup pin, and prohibit fail-open TLS validation
- **Network Security Config (Android)**: Prohibit cleartext in `res/xml/network_security_config.xml`
- **ATS (App Transport Security / iOS)**: Enabled by default. Minimize exceptions
- **Man-in-the-Middle Defense**: Combine current platform TLS validation with risk-based CT, pinning, or application-layer request protection; document which layer addresses which threat

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
- **SQL Injection Prevention**: Avoid string concatenation and require parameter binding, typed queries, or an equivalent safe construction mechanism in the adopted database API. Room and SwiftData are implementation examples
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
- **SBOM**: Generate and validate the third-party dependency inventory in CycloneDX, SPDX, or an interoperable format suited to consumers and toolchains
- **Vulnerability SLA**: Derive deadlines from exploitability, KEV or EPSS, exposure, data sensitivity, and compensating controls, not severity alone. Critical in 24 hours, High in seven days, and Medium in 30 days are reference defaults for a high-risk internet-facing product
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

- **App Clips (iOS)**: Confirm current platform size, capability, invocation, privacy, and distribution constraints for each release and complete the target task within those constraints
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

### §102. Typed Platform Boundary

- **Typed Contract**: APIs between Dart and Kotlin or Swift explicitly define types, nullability, errors, threads, and lifecycle through a schema, generated binding, or thin hand-written adapter
- **Pigeon**: A strong reference implementation in the Flutter ecosystem. When not using Pigeon, provide equivalent contract-drift tests, boundary validation, and compatibility policy
- **Hand-Written Channels**: Do not scatter raw string method names and unchecked casts. Isolate an existing MethodChannel behind one adapter and protect it with a typed facade and contract tests

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
- **Via Typed Bridge**: Expose KMP artifacts to Flutter through Pigeon or an equivalent typed bridge
- **Responsibility Boundary**: KMP = Domain/Data layer, Flutter = Presentation layer

### §106. React Native Integration

- **Dedicated Source of Truth**: Follow `420_react_native.md` for the overall React Native architecture, tests, CI, OTA, and team governance
- **New Architecture**: Default to Turbo Native Modules, Fabric Native Components, and typed Codegen specs
- **Native Responsibility**: Implement OS-specific APIs in Kotlin or Swift and maintain JS, iOS, and Android owners plus a compatibility matrix
- **Boundary Verification**: Assure nullability, errors, threads, lifecycle, cancellation, and size limits through Codegen contracts and tests on both operating systems

---

## Part XVII: Testing Strategy

### §107. Unit Testing

- **Kotlin**: JUnit 5 + MockK. Use `kotlinx-coroutines-test` for coroutine time and dispatcher control, and a separately adopted tool such as Turbine for Flow value assertions
- **Swift**: Swift Testing framework (`@Test` macro). Migration from XCTest recommended
- **Coverage**: Assess test adequacy from risk, critical paths, mutation or fault detection, and past defects. Eighty and 100 percent are reference values; coverage alone is not a release gate

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
- **Penetration Testing**: Derive scope and cadence from the threat model, data sensitivity, regulation, internet exposure, material changes, and past incidents. Annual external testing is a reference default for high-risk products
- **OWASP MASVS**: Compliance verification against Mobile App Security Verification Standard

### §113. Test Infrastructure

- **Device Testing**: Select managed devices, a device farm, Firebase Test Lab, or an equivalent according to the device matrix and reproducibility needs
- **iOS CI**: Select self-hosted runners, managed CI, Xcode Cloud, or an equivalent according to signing, simulator or device, and artifact-retention needs
- **Test Sharding**: Parallel execution of large test suites
- **Flaky Test Management**: Automatically detect flaky tests and record owner, impact, and quarantine expiry. Do not quarantine a critical release flow. The Blueprint derives the repair SLA from frequency and impact; two weeks is a reference default

### §114. Screenshot Testing

- **Android Screenshot Testing API**: Visual regression detection for Compose UI
- **Paparazzi**: Headless Compose screenshot capture. No real device required
- **Swift Snapshot Testing**: Snapshot tests for SwiftUI/UIKit views
- **CI Integration**: Automatic diff reports against golden images per PR

---

## Part XVIII: Build, CI/CD & Release

### §115. Build Optimization

- **Gradle**: Adopt Configuration Cache and Build Cache after verifying compatibility and reproducibility. Choose local or remote from scale, trust boundaries, and economics
- **Gradle 9.x**: Isolated Projects support
- **Xcode**: Leverage DerivedData Cache. Optimize parallel build settings
- **Target**: Set and continuously measure a build budget from developer-feedback and release SLOs. Fifteen minutes full and three minutes incremental are reference defaults
- **Convention Plugin**: Simplify build.gradle.kts through shared build configurations

### §116. CI/CD Pipeline

- **5-Stage Gate**: Lint → Unit Test → Integration Test → Build → Release
- **Impact-aware verification**: Use the build and contract graph to test and build affected modules, dependents, schemas, toolchains, and release artifacts. Retain a serialized-integration or scheduled full gate because path or module filters alone do not prove safety
- **Code Signing**: Use automation or a controlled procedure that provides credential isolation, rotation, least privilege, and an audit trail. Fastlane Match and the App Store Connect API are implementation examples
- **Artifact Management**: Auto-save and version-link APK/IPA/dSYM/mapping.txt

### §117. Release Management

- **Staged Rollout**: Derive cohorts, observation time, stop conditions, and rollback capability from risk and user scale. One, five, 20, 50, and 100 percent is a reference example
- **TestFlight (iOS)**: Internal/external tester distribution. Automatic feedback collection
- **Release Criteria**: Evaluate crash and ANR rates, hangs, startup, and business SLIs against baselines and error budgets. Values of 0.1 and 0.5 percent are initial Blueprint references, not fixed Universal thresholds
- **Hotfix**: Define emergency release flow for critical bug discovery

### §118. Store Guideline Compliance

- **App Store Review Guidelines**: Check latest version at development start
- **Google Play Developer Policy**: Regular monitoring of review policy changes
- **Pre-Submission Check**: Execute store-specific automated checklists
- **Metadata Management**: ASO keyword/screenshot optimization

### §119. Feature Flag Operations

- **Feature Control**: Select local or server-side flags, Firebase Remote Config, LaunchDarkly, or an equivalent according to authorization, audit, offline, and kill-switch needs
- **Phased Rollout**: Gradually expose new features to users
- **A/B Testing**: Comparative experiments of feature variants
- **Kill Switch**: Immediate feature disable on issue discovery

### §120. Versioning Convention

- **Semantic Versioning**: `MAJOR.MINOR.PATCH`
- **Build Number**: Auto-increment via CI/CD. Manual changes prohibited
- **versionCode (Android)**: Increase monotonically as required by the store. The Blueprint chooses a formula that accounts for the release train and numeric limit; `MAJOR * 10000 + MINOR * 100 + PATCH` is one example
- **CFBundleVersion (iOS)**: Linked to build number

### §121. Gradle Latest Developments

- **Gradle Version Catalog**: Centralized dependency management in `libs.versions.toml`
- **Convention Plugins**: Shared build logic
- **Configuration Cache**: Avoid reconfiguration through build config caching
- **Amper (Experimental)**: JetBrains new build tool. Simplified for KMP projects

### §122. Apple Build and Release Automation

- **CI/CD**: Select self-hosted runners, managed CI, Xcode Cloud, or an equivalent according to signing boundaries, device tests, artifacts, and audit requirements
- **Release Automation**: Fastlane is an implementation example for signing, screenshots, and metadata. Pin its transitive toolchain, including plugins and Ruby or Node dependencies
- **Project Generation**: When adopting Tuist or an equivalent, verify the generation source of truth, differences, version, and rollback
- **Environment Pinning**: Make the release toolchain reproducible through Mise, another version manager, or an equivalent mechanism

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

- **Crash Analysis**: Select platform reports, a service such as Crashlytics, or an equivalent control and associate Android and Apple symbols, releases, and user impact
- **Non-fatal Errors**: Record actionable non-fatal errors under sampling, privacy, and cost policy
- **ProGuard/R8 Mapping**: Automatic deobfuscation of stack traces
- **Symbol Artifacts**: Bind dSYM, R8 mappings, and equivalent artifacts to the release digest and securely retain, transfer, and verify them so the adopted backend can deobfuscate reports. Xcode auto-upload is an implementation example
- **Alert Criteria**: Calibrate crash-free, fatal, ANR, and hang alerts in the Blueprint against baselines, error budgets, and user impact. A 99.9 percent crash-free rate is an initial reference value

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
- **Alert Threshold Definition**: Derive thresholds in the Blueprint from baselines, error budgets, and user impact. The following are initial reference values:
  - Crash rate > 0.1% → P1 alert
  - ANR rate > 0.5% → P1 alert
  - Startup time > 2s → P2 alert
  - Network error rate > 5% → P2 alert

### §132. Logging Strategy

- **Structured Logs**: JSON format. Include timestamp, session ID, user ID (hashed)
- **Log Levels**: Define language- and platform-appropriate severity, sampling, retention, and remote collection. A production build excludes verbose or sensitive diagnostics unless a controlled, time-bounded support mode enables them
- **PII Exclusion**: Never output personal information in logs
- **Rotation**: Set log file size limits. Auto-delete old logs

---

## Part XXI: FinOps & Cost Optimization

### §133. Build Cost Optimization

- **CI/CD Execution Time**: Derive a build budget from the developer-feedback SLO and cost. Fifteen minutes is a common initial reference
- **Cache Strategy**: Reduce rebuilds with Gradle Build Cache / Xcode DerivedData Cache / SPM Cache
- **Selective Test Execution**: Use build-graph impact analysis for fast feedback, while preserving full contract, compatibility, and release gates on a risk-appropriate cadence
- **Runner Selection**: Measure hosted versus self-hosted, CPU architecture, isolation, maintenance, queue time, and cost, then select runners that reproduce the release toolchain. Specific hardware is a reference implementation
- **Parallel Builds**: Minimize wait time with iOS parallel builds and test sharding

### §134. Store Cost Optimization

- **App Size**: Define download, install, and update size budgets in the Blueprint from store constraints, user network and storage distribution, startup, feature value, and conversion impact, and continuously measure release artifacts
- **On-Demand Resources (iOS)**: On-demand download of large assets
- **Dynamic Feature Modules (Android)**: On-demand feature installation
- **ASO ROI**: Measure effectiveness of keyword optimization and screenshot A/B testing

### §135. Cloud Service Costs

- **Managed-service budget**: Set usage and cost alerts for the adopted backend, build, update, telemetry, and device-testing services. Firebase Blaze is one implementation example
- **Telemetry Costs**: Optimize log/metrics volume. Appropriate sampling rate
- **CDN Optimization**: Reduce origin server costs with CDN delivery for images/assets
- **API Call Optimization**: Reduce API call count with batch requests and caching

### §136. Device Farm Optimization

- **Device-verification mix**: Select owned devices, managed labs, Firebase Test Lab, another device farm, simulators, and emulators from the risk-based device matrix; no single provider proves maximum coverage
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

- **Rendering**: Meet the target device's supported refresh and frame-time budget for the interaction mode, measuring dropped frames, latency, thermal state, and motion comfort in production-equivalent builds. RealityKit is one platform implementation
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

- **watchOS UI**: Prefer SwiftUI for supported new UI and retain or migrate legacy WatchKit according to the deployment target, API availability, regression risk, and product roadmap
- **WidgetKit**: watchOS widgets/complications
- **HealthKit**: Heart rate, workout, sleep data retrieval and recording
- **WCSession**: iPhone↔Apple Watch communication. File transfer/messaging
- **Always On Display**: Always-on display support. Low-frequency updates with `TimelineView`

### §142. Wearable UX Principles

- **Glanceable**: Prioritize concise information and progressive disclosure while preserving required safety, legal, and accessibility content
- **Interaction budget**: Define completion-time and step budgets per scenario from urgency, motor constraints, connectivity, and device context. Two seconds is a reference heuristic for a simple glanceable action, not a universal limit
- **Context Aware**: Proactive information presentation based on time/location/activity
- **Haptics**: Convey important notifications via tactile feedback

---

## Part XXIV: Android XR & Immersive

### §143. Android XR Platform

- **Jetpack XR**: Android framework for AR/VR apps
- **ARCore**: Environment recognition, plane detection, occlusion
- **Compose for XR**: Build spatial UIs with Compose syntax
- **Cross-Device**: Unified experience design across smartphone/tablet/headset
- **Performance**: Target the supported refresh and latency budget of each device and interaction mode, with representative-device profiling and thermal evidence

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

The values below are reference budgets for starting measurement. Calibrate them in the Blueprint to devices, workload, usage duration, and business SLOs.

| Metric | Target | Measurement Method |
|--------|--------|--------------------|
| Background Battery Consumption | < 1%/hour | Battery Historian / Energy Log |
| Network Battery Consumption | < 0.5%/API call | Energy Profiler |
| CI/CD Build Energy | < 0.5 kWh/build | SCI measurement |
| Idle CPU Usage | < 1% | Instruments / Profiler |

---

## Part XXVI: Privacy & Compliance

### §148. Privacy Manifest Deep Dive (iOS)

- **Required Reason API**: Inventory the current Apple list, declare approved reasons only for APIs actually used, and verify generated and third-party code against the same inventory
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
- **Global Privacy Laws**: Determine applicable law from service regions, operator classification, data subjects, processing purposes, cross-border transfers, and contracts, retaining traceability to current official text and legal judgment
- **Regional Law**: Do not infer applicability from the names GDPR, CCPA or CPRA, Japan's APPI, or another law alone. Confirm scope, rights, notice, retention, and processor or controller responsibilities
- **Cyber Resilience Act and equivalents**: When the product and operator are in scope, confirm current applicability dates and duties for SBOMs, vulnerability handling and reporting, support periods, and related controls from official text
- **Children and minors**: Derive age scope and extra controls from COPPA and other applicable law, age-assurance method, parental consent, and store category. Do not use age 13 as a universal global threshold
- **Review**: Keep the privacy notice and store disclosures aligned with actual processing, and re-evaluate on data-flow, SDK, region, law, or store-policy changes and on a risk-based cadence

### §151. Permission Management Best Practices

- **Just-in-Time**: Request permissions in context just before use
- **Pre-Permission Pattern**: Display value explanation screen before system dialog
- **Graceful Degradation**: Provide alternative UI even when permissions denied
- **Permission Audit**: Re-verify the necessity of permissions on OS, SDK, feature, threat-model, or store-policy changes and on the Blueprint's risk-based cadence. Six months is a reference example

### §152. EAA and Other Accessibility Law

- **Applicability**: Confirm market, product or service category, operator class, exceptions, and transition measures from current official text and legal judgment. Do not infer scope solely because an app targets the EU
- **Conformance Evidence**: Bind applicable declarations, technical documentation, support, monitoring, remediation, and record retention to release artifacts
- **Technical Baseline**: Treat WCAG 2.2 AA as a strong engineering baseline while confirming the exact standard and version required by applicable law, harmonised standards, and platform policy
- **User Testing**: Plan verification involving people with disabilities according to critical flows and material risk, whether or not legally mandated, and never assert conformance from automation alone

---

## Part XXVII: Team & Organization Design

### §153. Mobile Platform Function

- **Platform Function**: Carry common CI/CD, design-system, network, toolchain, and release responsibilities through an individual role, shared responsibility, virtual group, or dedicated team suited to scale
- **Product Ownership**: A feature or product owner is accountable for user outcomes and SLOs on both Android and Apple platforms. Do not prescribe one organization chart
- **Code Ownership**: Clarify review responsibility and continuity through CODEOWNERS, an ownership registry, or an equivalent mechanism
- **Architecture Review**: Perform design review according to impact radius, irreversibility, safety, and cross-platform boundaries. Do not force the same meeting on every change

### §154. Knowledge Sharing & Development

- **Tech Radar**: Manage Adopt/Trial/Assess/Hold with team technology radar
- **Mob Programming**: Share knowledge through mob programming for complex implementations
- **RFC Process**: Create RFC (Request for Comments) for large-scale changes
- **KMP Training**: Cross-training: Kotlin training for Swift engineers, Swift training for Kotlin engineers

### §155. Code Review Standards

- **Review Checklist**: 4 perspectives: security, performance, accessibility, test coverage
- **Change Size**: Split changes for reviewability and rollback while accounting for generated and mechanical changes. Four hundred lines is a reference heuristic, not a conformance gate
- **Review SLA**: The Blueprint derives it from delivery risk, team time zones, and incident priority. Twenty-four hours is a reference default for collaborative teams
- **Automated Checks**: Make applicable lint, format, test, and equivalent checks change-acceptance conditions. Pull Requests and merges are VCS implementation examples

---

## Part XXVIII: Migration Strategy

### §156. UIKit → SwiftUI Migration

- **Gradual Migration**: Evaluate SwiftUI as the first candidate for new screens and introduce it incrementally with mechanisms such as `UIHostingController` where OS support, existing architecture, required APIs, team capability, and testability fit
- **Coexistence Period**: Plan UIKit and SwiftUI coexistence from inventory, risk, delivery capacity, and OS support. Two to three years is a reference example for a large legacy migration
- **Data Flow Integration**: Define existing-contract boundaries, state owners, lifecycle, and concurrency; `@Observable` is an implementation example when it fits
- **Test Strategy**: Detect regressions in migrated screens with a risk-appropriate combination of unit, integration, accessibility, snapshot, and visual-regression tests. Previews alone are not an acceptance gate

### §157. View → Compose / Java → Kotlin Migration

- **Compose Migration**: Evaluate Compose as the first candidate for new screens and introduce it incrementally with mechanisms such as `AndroidView` and `ComposeView` where OS support, existing Views, libraries, performance, accessibility, and team capability fit
- **Java→Kotlin**: Treat Kotlin as the first candidate for new Android code. Record the rationale for continuing Java due to existing APIs, generated code, toolchains, or vendor support; test nullability, concurrency, and behavior rather than relying on automatic conversion alone
- **Interop**: Bidirectional integration with `ComposeView` (Compose in XML) / `AndroidView` (View in Compose)
- **Migration Metrics**: Track defect rate, build time, performance, accessibility, and maintainability as well as language and UI migration rates in a queryable report, dashboard, or equivalent evidence

### §158. Migration ROI Measurement

- **Metrics**: Code line reduction rate, bug density change, build time change, development speed change
- **Phased Verification**: Measure ROI after each migration phase. Revise plan if effectiveness is low
- **Migration Testing**: A/B test UX metrics comparing old and new screens

---

## Part XXIX: Design System Integration

### §159. Material Design 3 / Material 3 Expressive

- **Material 3**: Evaluate Dynamic Color, typography, motion, and component behavior against current Android guidance and adopted targets
- **Material 3 Expressive**: If adopted, verify compatible libraries and operating systems, brand fit, accessibility, performance, and existing-UI compatibility. A calendar year alone is not an adoption rationale
- **Design Tokens**: Do not fix one design tool. Reproducibly transform a versioned token source of truth into platform representations such as `MaterialTheme`
- **Custom Components**: Meet brand and product needs while retaining platform conventions, accessibility, state, and test contracts

### §160. Human Interface Guidelines (HIG)

- **HIG Alignment**: Align with current HIG and OS behavior for each target Apple platform, documenting UX, safety, and accessibility rationale for intentional differences
- **Symbols**: Prefer evaluating platform assets such as SF Symbols, and verify license, meaning, localization, accessibility, and rendering compatibility for custom symbols
- **Typography**: Respect platform typography and Dynamic Type; verify readability, fallbacks, licensing, and download size for custom fonts
- **Spacing/Layout**: Do not make one grid a Universal requirement. Define tokens and layout contracts that support Safe Areas, window sizes, inputs, Dynamic Type, and platform conventions

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

- **Kotlin/Native**: Kotlin 2.4 is based on LLVM 21. Verify formal support for each target hardware and toolchain
- **C Interop**: Direct C library calls via `cinterop`
- **Memory Management**: CMS GC is the default. Do not assume hard-real-time predictability; measure pauses, allocation, and memory bounds on target hardware
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
- **Protocol Buffers**: An option where schemas, generated code, and binary compatibility fit. Compare payload size, CPU, memory, and debuggability against JSON or other alternatives on the real workload; do not assume a fixed reduction
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

- **Android and KMP Dependencies**: Define one resolution source of truth suited to the build, such as a version catalog, platform or BOM, dependency lock, or central-management plugin
- **Apple Dependencies**: Pin and verify version, source, checksum or signature, transitive dependencies, and support ownership for each adopted form such as SPM, CocoaPods, or a binary framework. Do not force migration based only on the package-manager name
- **Automated Updates**: Use Renovate, Dependabot, or an equivalent to propose updates, then accept them through a risk-based SLA and compatibility tests. Seventy-two hours is a reference for a high-urgency patch
- **Vulnerability Detection**: Combine complementary sources such as OSV, ecosystem advisories, and SCA services, triaging results by reachability, KEV or EPSS, exposure, and compensating controls

### §174. SBOM (Software Bill of Materials)

- **Format**: Select CycloneDX, SPDX, or an interoperable format according to consumers, regulators, and toolchains; pin and validate the schema version and generator
- **Law and Contracts**: When the CRA, another applicable law, or a customer contract requires it, confirm exact scope, timing, format, delivery, retention, and vulnerability-handling duties from current official text
- **License Audit**: Check license compatibility of all dependencies
- **Vulnerability Tracking**: Continuous vulnerability monitoring based on SBOM

---

## Part XXXV: Error Handling Strategy

### §175. Kotlin Error Handling

- **Result Type**: Express errors type-safely with `kotlin.Result` or custom Sealed class
- **runCatching**: Use it only at synchronous boundaries that return failures as values. Because it catches `Throwable`, always rethrow `CancellationException` in suspending work and do not make it an unconditional replacement for try-catch
- **Exception Hierarchy**: Clearly separate business exceptions from technical exceptions
- **Coroutine Exceptions**: Default to structured concurrency and limit `CoroutineExceptionHandler` to final observation of uncaught exceptions on root coroutines. Use `supervisorScope` only where child failures must be isolated, and never swallow cancellation

### §176. Swift Error Handling

- **Typed Throws (Swift 6)**: Explicitly declare error types in function signatures
- **Result Type**: Handle errors as values with `Result<Success, Failure>`
- **Guard Early Return**: Improve readability with early return pattern
- **do-catch**: Process recoverable errors. Catch clauses should be specific
- **Never Type**: Type-safe expression of infallible fallbacks

---

## Part XXXVI: Code Generation & Metaprogramming

### §177. Kotlin Code Generation

- **KSP (Kotlin Symbol Processing)**: Preferred processor API for supported K2 workloads. Measure clean and incremental build effects in the adopted project rather than assuming a fixed speedup
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

- **Optional Assistance**: GitHub Copilot, Gemini Code Assist, and other assistants are optional implementations; a project without one still conforms. When adopted, evaluate data boundaries, retention, licensing, access control, and model changes
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

- **App Store Review Guidelines**: Check the current version, effective date, and target regions during release planning and on policy changes, recording the review date and impact
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
| L3 | Managed | Both-OS CI/CD, risk-based layered tests, accessibility, owners, and dependency-update operations exist |
| L4 | Optimized | Measured performance budgets, a device matrix, integrated SBOM, staged delivery, compatibility, and upgrade lead time are continuously managed |
| L5 | Adaptive | Native and shared boundaries, toolchains, dependencies, and release controls continuously improve from SLOs and real-use data while control evidence is generated automatically |

### §184. 30 Anti-Patterns

| # | Anti-Pattern | Correct Approach |
|---|-------------|-----------------|
| 1 | Excessive `!!` operator use | Safe handling with `?.`, `?:`, `let` |
| 2 | Hardcoded API Keys | Keystore/Keychain + CI Secrets |
| 3 | Main thread I/O | `Dispatchers.IO` / `Task.detached` |
| 4 | Raw MethodChannel scattered across the codebase | Isolate it behind Pigeon or an equivalent typed adapter with contract tests |
| 5 | Sensitive data in SharedPreferences | EncryptedSharedPreferences/Keychain |
| 6 | Unresolved ARC circular references | Proper `[weak self]` usage |
| 7 | Full-screen recomposition | Fine-grained state management and deferred State reading |
| 8 | Release without risk-based test layers | Require applicable static, unit, integration, UI, device, and non-functional evidence |
| 9 | Postponing a11y | Design for accessibility from Day 1 |
| 10 | Using deprecated APIs | Coroutines/async-await/latest APIs |
| 11 | Unmeasured startup or profile decision | Measure critical flows and adopt or reject Baseline Profiles with evidence |
| 12 | Missing required privacy declarations | Generate manifests, reason declarations, and store disclosures according to current policy and actual behavior |
| 13 | Unrestricted WebView JS | Minimum privilege + sanitization |
| 14 | Treating Root/JB detection as authorization | Use Play Integrity, App Attest, or equivalent as risk signals alongside server-side authorization |
| 15 | Immediate permission request | Pre-Permission Pattern with value explanation first |
| 16 | Undefined failure behavior for expected offline use | Define cache, queue, conflict, recovery, and user communication for the capability |
| 17 | Module boundaries unrelated to change and ownership | Split or combine modules from build graph, cohesion, ownership, and test impact |
| 18 | Disabled TLS verification or pinning without an update plan | Require platform TLS and use pinning only for threat-modeled high-risk APIs with backup pins and safe rotation |
| 19 | Battery consumption neglect | Doze/BGTaskScheduler compliance |
| 20 | Unchecked store guidelines | Check latest policies before release |
| 21 | GlobalScope.launch | Use structured CoroutineScope |
| 22 | New KAPT adoption without rationale | Verify processor compatibility and migrate supported scope incrementally to KSP |
| 23 | Observation migration that ignores the deployment target | Evaluate `@Observable` for iOS 17+ scope and retain an existing compatible approach for older OS support |
| 24 | Indefinite K1 compatibility mode | Record the K2 migration blocker, owner, deadline, and compiler-plugin compatibility tests |
| 25 | Pinning Only (no CT) | Prioritize Certificate Transparency |
| 26 | Using Context Receivers | Migrate to Context Parameters (Kotlin 2.2+) |
| 27 | Conflating state, event streams, and asynchronous sequences in one framework | Select Observation, Combine, or AsyncSequence by responsibility and OS support |
| 28 | No SBOM generation | Generate CycloneDX SBOM for EU CRA readiness |
| 29 | Low-level optimization without measurement | Adopt specialized data structures only where profiling and before-and-after evidence justify them |
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
- **WebAssembly Component Model Maturity**: Standardize cross-language component contracts, capabilities, sandboxing, and observability, including Kotlin and Swift
- **Swift Value Generics**: Further expansion of compile-time constant generics

### §186. Recommended Learning Path

- **Android**: Supported stable Kotlin → UI and state → dependency composition → KMP, AI, or XR when needed. Compose, Hilt, and ML Kit are learning examples for an adopted stack
- **iOS**: Supported stable Swift → UI and state → persistence and dependency composition → AI or spatial computing when needed. SwiftUI, SwiftData, Observation, Foundation Models, and visionOS are learning examples for an adopted stack
- **Common**: Responsibility separation and boundary design → CI/CD → security → accessibility → measured performance → SBOM and supply chain. Learning one architecture pattern is not itself the goal

---

## Appendix A: Quick Reference Index

| Keyword | Referenced Sections |
|---------|-------------------|
| Kotlin 2.4 / K2 / Context Parameters | §5–§7 |
| Kotlin 2.2.20–2.4 / Swift Export / Wasm | §6, §36 |
| Swift 6.2–6.3 / Approachable Concurrency / @concurrent / @c | §11–§17 |
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
| EU CRA / SBOM / GDPR / Global Privacy Laws | §150, §174 |
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
| Mobile Development (Flutter) | [342_mobile_flutter.md](../engineering/400_mobile_flutter.md) | Flutter-specific best practices |
| Store Submission Compliance | [product/700_appstore_compliance.md](../product/700_appstore_compliance.md) | IAP/ASO/Review Guidelines |
| Security | [security/000_security_privacy.md](../security/000_security_privacy.md) | Zero Trust/OWASP/Encryption |
| Design & UX | [design/000_design_ux.md](../design/000_design_ux.md) | Accessibility/Touch Targets |
| AI Implementation | [ai/000_ai_engineering.md](../ai/000_ai_engineering.md) | On-Device AI/Edge ML |
| QA & Testing | [quality/000_qa_testing.md](../quality/000_qa_testing.md) | Test Pyramid/E2E |
| Engineering General | [engineering/000_engineering_standards.md](../engineering/000_engineering_standards.md) | CI/CD/Coding Conventions |
| Legal & Privacy | [security/100_data_governance.md](../security/100_data_governance.md) | GDPR/Privacy Manifest/EU CRA |
| License Management | [security/200_oss_compliance.md](../security/200_oss_compliance.md) | SBOM/Dependency Management |
| SRE & Reliability | [operations/400_site_reliability.md](../operations/400_site_reliability.md) | Observability/SLO/Green SRE |
| Analytics Intelligence | [ai/100_data_analytics.md](../ai/100_data_analytics.md) | OTel Mobile/Mobile Analytics |
| Language Protocol | [core/200_language_protocol.md](../core/200_language_protocol.md) | Mobile-specific Language Protocol |
| Global Expansion | [800_internationalization.md](../product/800_internationalization.md) | Mobile i18n/RTL Support |

---

## Appendix C: Primary Sources

- [NIST SP 800-218 SSDF](https://csrc.nist.gov/pubs/sp/800/218/final): outcome-oriented secure-development practices that do not mandate one SDLC or tool
- [RFC 2119](https://www.rfc-editor.org/info/rfc2119) and [RFC 8174](https://www.rfc-editor.org/info/rfc8174): BCP 14 guidance limiting normative terms such as MUST to cases needed for interoperability or harm prevention
- [Kotlin release process](https://kotlinlang.org/docs/releases.html) / [Kotlin 2.4](https://kotlinlang.org/docs/whatsnew24.html): current stable release, support window, K1 removal, and KMP / Wasm updates
- [Android Kotlin compatibility](https://developer.android.com/build/kotlin-support): Kotlin and AGP / D8 / R8 compatibility matrix
- [Google Play target API requirements](https://developer.android.com/google/play/requirements/target-sdk): the Android 16 / API 36 baseline from August 31, 2026 and device-category exceptions
- [Swift 6.3 Released](https://www.swift.org/blog/swift-6.3-released/): `@c`, the Swift SDK for Android, and the Swift Build integration preview
- [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/): Swift-native public API design
