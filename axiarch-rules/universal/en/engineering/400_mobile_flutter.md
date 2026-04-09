# 342. Mobile Engineering — Flutter

> [!CAUTION]
> **This file is a Universal Rule (immutable). Editing is prohibited without an explicit "Amend Constitution" instruction.**
> Revision date: 2026-03-30 | Target: Flutter 3.41+ / Dart 3.7+ / Riverpod 3.0+ / Impeller GA (iOS sole renderer, Android default)

> [!IMPORTANT]
> **Supreme Directive**
> "Flutter is one codebase — but never one compromise. Platform fidelity is non-negotiable."
> All Flutter implementations must deliver native-quality UX on each platform.
> Strictly adhere to the priority: **UX Fidelity > Performance > Security > Code Reuse > Dev Speed**.
> **55 Parts, 265 Sections.**

---

## Table of Contents

| Part | Topic | Sections |
|------|-------|----------|
| I | Philosophy & Supreme Directive | §1–§4 |
| II | Technology Stack Standards | §5–§8 |
| III | Architecture Principles | §9–§14 |
| IV | Dart 3.7+ Language Conventions | §15–§21 |
| V | Type System & Pattern Matching | §22–§26 |
| VI | Async Processing & Isolates | §27–§31 |
| VII | Code Generation & Tooling | §32–§35 |
| VIII | Riverpod 3.0+ Foundation | §36–§41 |
| IX | Advanced Riverpod Patterns | §42–§46 |
| X | Offline Persistence & Mutations | §47–§50 |
| XI | GoRouter & Declarative Routing | §51–§55 |
| XII | Deep Links & Universal Links | §56–§59 |
| XIII | Clean Architecture Details | §60–§64 |
| XIV | Repository & Data Layer | §65–§68 |
| XV | Dependency Injection (DI) | §69–§71 |
| XVI | Performance Foundation — "120fps or Die" | §72–§77 |
| XVII | Impeller Rendering Engine | §78–§80 |
| XVIII | Widget Tree Optimization | §81–§85 |
| XIX | Startup Optimization & App Size | §86–§89 |
| XX | Memory Management & Profiling | §90–§93 |
| XXI | Offline-First & Local DB | §94–§98 |
| XXII | Network Communication & API Integration | §99–§104 |
| XXIII | Image, Media & Asset Management | §105–§108 |
| XXIV | Real-time Communication | §109–§111 |
| XXV | Platform Fidelity | §112–§116 |
| XXVI | Responsive & Adaptive UI | §117–§121 |
| XXVII | Material 3 & Design System | §122–§126 |
| XXVIII | Animation & Motion Design | §127–§130 |
| XXIX | Forms & Input UX | §131–§134 |
| XXX | Accessibility (a11y) | §135–§141 |
| XXXI | Security Foundation — OWASP MAS | §142–§146 |
| XXXII | Runtime Protection & RASP | §147–§149 |
| XXXIII | AI & On-Device ML | §150–§154 |
| XXXIV | Testing Strategy | §155–§162 |
| XXXV | CI/CD & Deployment | §163–§170 |
| XXXVI | Observability & Monitoring | §171–§176 |
| XXXVII | Multi-Platform & Ecosystem | §177–§182 |
| XXXVIII | Governance & Compliance | §183–§188 |
| XXXIX | Maturity Model & Anti-Patterns | §189–§191 |
| XL | Future Outlook | §192–§193 |
| XLI | Push Notification Architecture | §194–§196 |
| XLII | Authentication & App Check | §197–§199 |
| XLIII | App Lifecycle & Background Processing | §200–§202 |
| XLIV | In-App Purchase & App Updates | §203–§205 |
| XLV | Dart FFI & Native Interop Deep Dive `[Flutter-Specific]` | §206–§210 |
| XLVI | Payment Integration Architecture `[Universal+Flutter]` | §211–§216 |
| XLVII | Local Notifications & Scheduling `[Universal+Flutter]` | §217–§220 |
| XLVIII | Widget Testing Deep Dive `[Flutter-Specific]` | §221–§225 |
| XLIX | Error Boundary & Recovery UX `[Universal]` | §226–§230 |
| L | Connectivity & Network Resilience `[Universal]` | §231–§235 |
| LI | In-App Navigation UX Design `[Universal+Flutter]` | §236–§240 |
| LII | Configuration Management & Feature Flags `[Universal]` | §241–§245 |
| LIII | Data Privacy & Consent Management `[Universal]` | §246–§250 |
| LIV | Mobile DevOps & DX `[Universal+Flutter]` | §251–§256 |
| LV | Language-Specific Addendum & Extended Anti-Patterns `[Flutter-Specific]` | §257–§265 |
| Appendix | Reverse Index & Cross-References | — |

---

# Part A: Philosophy & Architecture Foundation

## I. Philosophy & Supreme Directive

### §1. Supreme Directive — Flutter Excellence

- **Principle**: Flutter is the sole framework achieving "uncompromising cross-platform" quality
- **Priority**: UX Fidelity > Performance > Security > Code Reuse > Dev Speed
- **Zero Compromise**: Maintain 100% native quality on each platform (iOS/Android/Web/Desktop)
- **Latest Stable**: Always target the latest stable Flutter/Dart. New use of deprecated APIs is prohibited
- **Platform Conventions First**: Full compliance with iOS HIG / Material Design 3. Do not force unification of UX patterns across platforms

### §2. Quality Gates (Pre-deployment Requirements)

| Metric | Threshold | Blocker |
|---|---|---|
| `dart analyze --fatal-infos` | Zero warnings/infos | ✅ |
| `dart format --set-exit-if-changed .` | Zero formatting diffs | ✅ |
| Test coverage (Domain layer) | ≥ 90% | ✅ |
| App size (AAB/IPA) | ≤ 30MB | ✅ |
| Cold start | ≤ 2 seconds | ✅ |
| Frame rate | ≥ 60fps (120fps recommended) | ✅ |
| Crash-free rate | ≥ 99.5% | ✅ |

### §3. Zero Tolerance

- **Absolutely Prohibited**: `dynamic` type usage, `setState()` abuse, direct `Navigator.push()`, hardcoded API Keys
- **Principally Prohibited**: Manual Provider definitions, direct `Image.network()`, Debug-mode profiling, `.then()` chains
- **Conditionally Prohibited**: Skia fallback (only for known compatibility issues), external DI like `get_it` (Riverpod suffices)

### §4. Versioning Strategy

- **Minimum SDK**: Android `minSdk = 28` (Android 9), iOS `deploymentTarget = 16.0`
- **Target SDK**: Always track latest stable
- **Dart SDK**: `sdk: '>=3.7.0 <4.0.0'`
- **Deprecated API SLA**: Migrate within **2 release cycles** of official deprecation
- **Dependency updates**: Security patches within 72h; regular updates via Renovate/Dependabot with 14-day wait

---

## II. Technology Stack Standards

### §5. Required Package Stack

| Purpose | Package | Notes |
|---|---|---|
| State management | `riverpod` + `riverpod_generator` | Code-gen first required |
| Routing | `go_router` | Sole declarative routing choice |
| Immutable state | `freezed` + `freezed_annotation` | All state classes required |
| JSON serialization | `json_serializable` + `json_annotation` | All DTOs required |
| HTTP client | `dio` | Interceptor-based |
| Local DB | `drift` | Relational data |
| Secure storage | `flutter_secure_storage` | Tokens & PII |
| Image caching | `cached_network_image` | Required for network images |
| SVG | `flutter_svg` | Vector graphics |
| RASP | `freeRASP` | Runtime protection |
| Crash reporting | `firebase_crashlytics` | Crash reports |
| Analytics | `firebase_analytics` | Event tracking |

### §6. Prohibited / Deprecated Packages

| Package | Reason | Alternative |
|---|---|---|
| `http` | Insufficient features | `dio` |
| `provider` | Legacy | `riverpod` |
| `get_it` + `injectable` | Riverpod suffices | Riverpod Provider |
| `hive` | Cannot handle complex queries | `drift` (relational) |
| `shared_preferences` (for secrets) | Plaintext storage | `flutter_secure_storage` |

### §7. Code Generation Pipeline

```bash
# Standard code generation
dart run build_runner build --delete-conflicting-outputs

# Watch mode (during development)
dart run build_runner watch --delete-conflicting-outputs
```

- **Generated file naming**: `*.g.dart` (json_serializable), `*.freezed.dart` (freezed)
- **Git management**: `.g.dart` / `.freezed.dart` files **are committed** to Git (for CI reproducibility)
- **`build.yaml`**: Centralize generation options in project root `build.yaml`

### §8. analysis_options.yaml Standard

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  strict-casts: true
  strict-raw-types: true
  strict-inference: true
  errors:
    missing_return: error
    dead_code: warning
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"

linter:
  rules:
    - always_declare_return_types
    - avoid_dynamic_calls
    - avoid_print
    - avoid_relative_lib_imports
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_final_locals
    - unawaited_futures
    - unnecessary_lambdas
    - use_super_parameters
```

---

## III. Architecture Principles

### §9. Layered Architecture (Required)

- Strictly adhere to **3-layer structure**:
  - **Presentation layer**: Widget + ViewModel (Notifier). UI logic only. Business logic prohibited
  - **Domain layer**: Business logic + Entities + Repository interfaces. **Zero Flutter dependency** (pure Dart)
  - **Data layer**: API communication + Local DB + DTOs. Abstracted via Repository pattern
- **Dependency direction**: `Presentation → Domain ← Data`. Domain layer knows nothing about other layers

### §10. Feature-Based Directory Structure

```
lib/
├── core/                  # Common utilities, theme, constants, exceptions
│   ├── constants/
│   ├── exceptions/
│   ├── extensions/
│   ├── theme/
│   └── utils/
├── features/
│   ├── auth/
│   │   ├── data/          # Repository impl, DTOs, DataSources
│   │   ├── domain/        # Entities, Repository interfaces, UseCases
│   │   └── presentation/  # Widgets, Notifiers, Screens
│   └── cart/
├── l10n/                  # Internationalization ARB files
├── routing/               # GoRouter configuration
└── main.dart
```

### §11. SSOT (Single Source of Truth) Principle

- **Treat local DB as SSOT**: UI always renders from local DB
- **Network is a sync layer**: Not a prerequisite for UI rendering
- **Single state source**: Prohibit the same data from being scattered across multiple state managers

### §12. Unidirectional Data Flow (UDF)

- **Data flow**: Network → Repository → Notifier → Widget → User Action → Notifier → Repository
- **Widget → Notifier**: User actions propagate via Notifier method calls
- **Notifier → Widget**: State changes via reactive `ref.watch()` updates
- **Prohibited**: Direct data passing between Widgets (Callback Hell), state access via GlobalKey

### §13. Module Boundaries & Public API

- **Feature Export**: Do **not** place `barrel files` (e.g., `auth.dart`) in each feature directory. Barrel Exports breed circular dependencies
- **Alternative**: Import required classes directly. Rely on IDE auto-import
- **Inter-feature dependencies**: Only through Domain layer interfaces. Direct Data/Presentation layer references prohibited

### §14. Error Architecture

```dart
// ✅ Application-wide error hierarchy
sealed class AppException implements Exception {
  String get message;
  String? get debugInfo;
}

class NetworkException extends AppException { /* ... */ }
class CacheException extends AppException { /* ... */ }
class AuthException extends AppException { /* ... */ }
class ValidationException extends AppException { /* ... */ }
```

- **Domain layer**: Only throw/catch `AppException`. Convert package-specific exceptions in Data layer
- **Presentation layer**: Map to UI via `AsyncValue` error state
- **Fire-and-forget prohibited**: All async calls require error handling

---

# Part B: Dart Language Mastery

## IV. Dart 3.7+ Language Conventions

### §15. Wildcard Variables (Dart 3.7)

- **`_` is a true wildcard**: Using `_` in parameters/local variables does not declare a variable

```dart
// ✅ Dart 3.7 Wildcard
list.where((_, ) => true); // Ignore first argument
future.then((_) => doSomething()); // Ignore result
```

### §16. New Formatter (Dart 3.7)

- **New formatting style automatically applies** to Dart 3.7+ projects
- Automatic trailing comma handling eliminates manual adjustments
- `dart format` must be run as a CI gate

### §17. Strict Type Annotations

- **`dynamic` usage prohibited**: Apply type annotations to all variables/parameters
- Enable `strict-casts: true`, `strict-raw-types: true`, `strict-inference: true` in `analysis_options.yaml`
- **`Object` usage**: Use `Object` instead of `dynamic` when type is unknown

### §18. Naming Conventions

| Target | Convention | Example |
|---|---|---|
| Class, enum, typedef | `UpperCamelCase` | `AuthState`, `UserRole` |
| Variable, function, parameter | `lowerCamelCase` | `userName`, `fetchData()` |
| Constant | `lowerCamelCase` | `defaultTimeout` |
| File name | `snake_case` | `auth_repository.dart` |
| Private | `_` prefix | `_internalState` |
| Boolean | `is`/`has`/`can` prefix | `isLoading`, `hasError` |

### §19. Extension Types (Dart 3.3+)

- Use Extension Types for wrapping primitive types with **zero-cost type safety**

```dart
extension type UserId(String value) {
  factory UserId.fromInt(int id) => UserId(id.toString());
}
extension type Email(String value) {
  bool get isValid => value.contains('@');
}
```

### §20. Records (Dart 3.0+)

- Use `Record` for multiple return values, eliminating unnecessary class definitions

```dart
(String name, int age) parseUser(Map<String, dynamic> json) {
  return (json['name'] as String, json['age'] as int);
}
({String token, DateTime expiresAt}) authenticate() { /* ... */ }
```

### §21. Other Dart Best Practices

- **`final` first**: Prefer `final` over `var`. Use `final` for all non-reassigned variables
- **Maximize `const`**: Use `const` for all compile-time constants. Auto-fix with `dart fix --apply`
- **Cascade Notation**: Use `..` for object initialization
- **Collection Literals**: `List()` → `[]`, `Map()` → `{}`
- **String Interpolation**: Prefer `'$variable'`. String concatenation with `+` is prohibited

---

## V. Type System & Pattern Matching

### §22. Exhaustive Branching with Sealed Classes

```dart
sealed class AuthState {}
class Authenticated extends AuthState {
  final User user;
  const Authenticated(this.user);
}
class Unauthenticated extends AuthState {}
class AuthLoading extends AuthState {}

String label(AuthState s) => switch (s) {
  Authenticated(:final user) => user.name,
  Unauthenticated() => 'Guest',
  AuthLoading() => 'Loading...',
};
```

### §23. Pattern Matching

- Use `switch` expressions, `if-case`, sealed classes for **exhaustive branching**
- **Guard Clause**: Conditional matching with `when` keyword
- **Destructuring**: Extract fields directly with object patterns

### §24. Type-safe JSON Processing

- **DTO conversion**: Define DTOs (`@JsonSerializable`) for all API responses. Direct `Map<String, dynamic>` manipulation prohibited
- **Type conversion**: `as` casts prohibited. Use `is` checks + pattern matching
- **Null safety**: Set safe defaults for nullable JSON fields with `@JsonKey(defaultValue: ...)`

### §25. Enum Extensions

```dart
enum PaymentMethod {
  creditCard('Credit Card', Icons.credit_card),
  bankTransfer('Bank Transfer', Icons.account_balance),
  cash('Cash', Icons.money);

  final String label;
  final IconData icon;
  const PaymentMethod(this.label, this.icon);
  bool get isOnline => this != PaymentMethod.cash;
}
```

### §26. Null Safety Enforcement

- **`!` operator prohibited**: No forced unwrap exceptions. Use `?.`, `??`, `?.let`
- **`late` restriction**: Only `late final` permitted. `late var` prohibited (initialization risk)
- **`required` keyword**: Named Parameters that are non-nullable must use `required`

---

## VI. Async Processing & Isolates

### §27. async/await Conventions

- **`async/await` as standard**: `.then()` chains prohibited
- Execute independent async operations in parallel with `Future.wait()`
- **Fire-and-forget prohibited**: All `Future`s require `await` or explicit `unawaited()`

```dart
// ✅ Parallel execution
final (user, settings) = await (
  fetchUser(id),
  fetchSettings(),
).wait;
```

### §28. Isolate Usage

- **CPU-intensive processing** (JSON parsing, image processing, encryption) on `Isolate.run()`
- Offload any processing **exceeding 16ms** from the main Isolate to prevent UI jank

### §29. Stream Management

- **StreamSubscription lifecycle**: Always cancel in `ref.onDispose()`
- **broadcast stream**: `.asBroadcastStream()` only when multiple listeners needed
- **StreamController**: Must `.close()` after use. Primary cause of memory leaks

### §30. Cancellation

- **CancellationToken pattern**: Implement cancellation for long-running async operations
- **Dio CancelToken**: Use Dio's `CancelToken` for HTTP requests, cancel on screen exit
- **ref.onDispose()**: Release resources in Riverpod Notifier's onDispose

### §31. Async Error Handling Pattern

```dart
sealed class Result<T> {
  const Result();
}
class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}
class Failure<T> extends Result<T> {
  final AppException error;
  const Failure(this.error);
}
```

---

## VII. Code Generation & Tooling

### §32. build_runner Strategy

- **Code generation is a required CI step**: Include `dart run build_runner build` in CI pipeline
- **Conflict handling**: Always use `--delete-conflicting-outputs` flag
- **Watch mode**: Use `watch` mode for continuous generation during development

### §33. Macros Cancellation & Augmentations

- **Dart Macros development cancelled**: Hot reload/IDE analysis performance degradation was the reason
- **Current standard**: Continue using `freezed` + `json_serializable` + `build_runner`
- **Augmentations**: Class definition splitting across files under development as successor. Wait for stable

### §34. Code Generator Selection

| Purpose | Recommended Generator |
|---|---|
| Immutable data classes | `freezed` |
| JSON serialization | `json_serializable` |
| Riverpod providers | `riverpod_generator` |
| Routing | `go_router_builder` (optional) |
| Asset access | `flutter_gen` (optional) |
| Local DB | `drift` (built-in generator) |

### §35. DevTools & Profiling Tools

- **Flutter DevTools**: Use Widget Inspector, Performance Overlay, Memory Profiler, Network Profiler daily
- **Dart DevTools**: Detect memory leaks with CPU Profiler, Heap Snapshot
- **Performance Overlay**: Enable `PerformanceOverlay.allEnabled()` during development
- **Great Thread Merge (Flutter 3.29+)**: UI and Raster threads merged. DevTools frame analysis UI refreshed

---

# Part C: State Management

## VIII. Riverpod 3.0+ Foundation

### §36. Code-Generation-First Principle

- **`riverpod_generator` (`@riverpod` annotation) is required**. Manual provider definitions prohibited
- Ensures compile-time type safety and boilerplate reduction
- **Legacy API Deprecation (Riverpod 3.0)**: `StateProvider`, `StateNotifierProvider`, `ChangeNotifierProvider` moved to `package:riverpod/legacy.dart`. **New usage absolutely prohibited**
- **Unified Notifier API (Riverpod 3.0)**: `AutoDisposeNotifier` and `Notifier` merged. auto-dispose is now the unified default behavior
- **`riverpod_lint` Required**: Install the `riverpod_lint` package and enforce the following lint rules in CI:
  - `riverpod_final_provider` — Provider variables must be final
  - `unsupported_provider_value` — Detect unsupported Provider value types
  - `missing_provider_scope` — Detect missing ProviderScope
  - `avoid_manual_providers_as_generated_provider_dependency` — Detect dependencies on manually defined providers

### §37. Provider Type Selection

| Use Case | Recommended Provider |
|---|---|
| Synchronous value | `@riverpod` (auto-dispose) |
| Async data fetching | `@riverpod Future<T>` (FutureProvider) |
| Real-time stream | `@riverpod Stream<T>` (StreamProvider) |
| Mutable state + logic | `@riverpod class MyNotifier extends _$MyNotifier` |
| Async mutable state | `AsyncNotifier` / `AsyncNotifierProvider` |
| Family (parameterized) | Add parameters to `@riverpod` function |

### §38. ref.watch / ref.read Absolute Rules

- **Inside `build()` method** → `ref.watch()` only
- **Inside callbacks/event handlers** → `ref.read()` only
- Using `ref.watch()` inside callbacks is **strictly prohibited** (causes Riverpod re-evaluation loops)
- **`ref.listen()`**: Use for side effects (Snackbar display, etc.)
- **`Ref.mounted` (Riverpod 3.0)**: After async completion, use `if (!ref.mounted) return;` to prevent state updates after Provider disposal
- **`Ref` type simplification (Riverpod 3.0)**: Generic parameters removed. All subclasses (`FutureProviderRef`, etc.) unified into single `Ref` type

### §39. Granularity Control (select)

- **`ref.watch(provider.select((state) => state.specificField))`** to watch only specific fields
- Watching entire state objects is the primary cause of performance degradation
- **AsyncValue select**: `ref.watch(asyncProvider.select((v) => v.valueOrNull?.field))`
- **Equality-based updates (Riverpod 3.0)**: State comparison changed from `identical()` to `==` operator. `freezed`'s `==` override directly utilized, further reducing unnecessary rebuilds

### §40. Immutable State Enforcement

- Use **`freezed`** for all state classes to guarantee immutability
- Only `copyWith()` state transitions permitted. Direct field modification prohibited

```dart
@freezed
class CartState with _$CartState {
  const factory CartState({
    @Default([]) List<CartItem> items,
    @Default(false) bool isLoading,
    String? error,
  }) = _CartState;
}
```

### §41. Provider Lifecycle Management

- **auto-dispose (default)**: Unused Providers are automatically destroyed
- **`keepAlive()`**: Set for global state (auth state, etc.)
- **`ref.invalidate()`**: Force refresh. Used for Pull-to-Refresh implementation
- **`ref.onDispose()`**: Clean up StreamSubscription, Timer, etc.
- **Automatic Retry (Riverpod 3.0)**: Built-in Exponential Backoff retry on Provider computation failure. Provides inherent resilience against transient network issues
- **Pause/Resume (Riverpod 3.0)**: OS automatically pauses listeners on invisible Widgets. Eliminates unnecessary recomputation, improving performance

---

## IX. Advanced Riverpod Patterns

### §42. Provider Dependency Chains

- Providers can depend on other Providers via `ref.watch()`
- **Circular dependencies prohibited**: A → B → A throws `ProviderException`
- **Depth limit**: Dependency chains exceeding 5 levels require architecture review

### §43. Notifier Design Pattern

```dart
@riverpod
class OrderNotifier extends _$OrderNotifier {
  @override
  Future<List<Order>> build() async {
    final userId = ref.watch(authProvider).requireValue.id;
    return ref.watch(orderRepositoryProvider).fetchOrders(userId);
  }

  Future<void> placeOrder(OrderRequest request) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(orderRepositoryProvider).placeOrder(request);
      // ✅ Riverpod 3.0: Safety check after async completion
      if (!ref.mounted) return state.requireValue;
      return ref.read(orderRepositoryProvider).fetchOrders(
        ref.read(authProvider).requireValue.id,
      );
    });
  }
}
```

### §44. Scoped Providers

- **`ProviderScope` overrides**: Inject mocks during tests
- **Feature-scoped Providers**: Providers valid only for specific screens defined within that screen's ProviderScope

### §45. Unified AsyncValue Handling

```dart
asyncValue.when(
  data: (data) => DataWidget(data: data),
  loading: () => const ShimmerLoading(),
  error: (error, stack) => ErrorWidget(
    message: error.toString(),
    onRetry: () => ref.invalidate(provider),
  ),
);
```

### §46. Test Provider Overrides

```dart
final container = ProviderContainer(
  overrides: [
    orderRepositoryProvider.overrideWithValue(MockOrderRepository()),
    authProvider.overrideWith((ref) => const AsyncData(mockUser)),
  ],
);
```

- **`ProviderContainer.test` (Riverpod 3.0)**: Simplified test container creation. Build test containers without boilerplate
- **`tester.container()` (Riverpod 3.0)**: Utility to directly retrieve ProviderContainer from widget tree in Widget Tests

---

## X. Offline Persistence & Mutations

### §47. Riverpod Offline Persistence (Experimental)

- **`.persist()` API**: Call within `build()` method for automatic local storage caching
- **`riverpod_sqflite`**: SQLite-based Storage implementation
- **Stale-While-Revalidate**: Display local data instantly on startup; fetch fresh data in background

### §48. Mutations API

- **Declarative side-effect management**: Define form submissions, delete operations as `Mutation`
- **Automatic state tracking**: Loading → Success → Error transitions auto-managed
- **Dispose protection**: Guarantee mutation completion even during provider disposal
- **Code-generation-free (Riverpod 3.0)**: Mutations API usable without code generation
- **`Mutation.run`**: Execute async callbacks via `Mutation.run`, reflect state to UI via `ref.watch` (loading spinners, error display, etc.)

### §49. Offline Queuing

- **Sync queue**: Record offline mutations to a Drift sync table; batch send on network recovery
- **Conflict resolution**: Compare server-side `updated_at` timestamps; adopt Last-Write-Wins or Server-Priority
- **Idempotency**: Ensure server-side uniqueness for resent operations (idempotency key)

### §50. State Restoration (Android Process Death)

- **`RestorationMixin`**: Support restoration from Android process death
- **`RestorableValue`**: Make critical UI state (scroll position, form input) restorable
- **Riverpod integration**: Persisted Provider state auto-restores after process restart

---

# Part D: Navigation

## XI. GoRouter & Declarative Routing

### §51. Declarative Routing Principle

- **Adopt `go_router` as the sole official routing solution**. Direct `Navigator.push()` usage prohibited
- Use only `context.go()` / `context.push()` / `context.pop()`

### §52. Centralized Route Definitions

```dart
abstract class AppRoutes {
  static const home = '/';
  static const profile = '/profile/:id';
  static const settings = '/settings';
  static const login = '/login';
}

@riverpod
GoRouter router(Ref ref) {
  final authState = ref.watch(authProvider);
  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: authState,
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isLoginRoute = state.matchedLocation == AppRoutes.login;
      if (!isLoggedIn && !isLoginRoute) return AppRoutes.login;
      if (isLoggedIn && isLoginRoute) return AppRoutes.home;
      return null;
    },
    routes: [ /* ... */ ],
  );
}
```

### §53. Authentication Guard

- Reactively evaluate auth state via GoRouter's `redirect` property
- Connect auth state Notifier to `refreshListenable` for auto re-evaluation on state changes
- **Role-based Routing**: Route access control based on user permissions

### §54. Nested Routing

- **ShellRoute**: Page transitions within shell UI like BottomNavigationBar
- **StatefulShellRoute**: Preserve state between tabs
- **`parentNavigatorKey`**: Display modals on parent Navigator

### §55. Route Transition Animations

- **`CustomTransitionPage`**: Customize screen transition animations
- **Platform compliance**: iOS defaults to slide transition, Android to fade transition
- **Hero Animation**: Implement shared element animations between routes with GoRouter

---

## XII. Deep Links & Universal Links

### §56. Universal Links (iOS)

- **Associated Domains**: Add `applinks:example.com` in Xcode settings
- **`apple-app-site-association`**: Place on server. Define path mappings in JSON format
- **Verification**: Verify link configuration with `swcutil` command

### §57. App Links (Android)

- **`assetlinks.json`**: Place in server's `.well-known/` directory
- **`autoVerify="true"`**: Set in `intent-filter` for automatic link verification
- **Verification**: Test with `adb shell am start`

### §58. Deferred Deep Links

- Implement transition handling for uninstalled apps
- Display target screen on first launch after store installation
- **Firebase Dynamic Links deprecation**: Use custom implementation or third-party (Branch.io, etc.)

### §59. Custom URL Schemes

- **Custom scheme**: `myapp://` format. Prioritize Universal/App Links; use as fallback
- **Security**: Always validate parameters from custom schemes (injection prevention)

---

# Part E: Architecture Patterns

## XIII. Clean Architecture Details

### §60. UseCase Layer (Optional)

- **UseCase**: Encapsulate a single unit of business logic. Use for composite operations combining Repositories
- **Single responsibility**: 1 UseCase = 1 business operation
- **Pure Dart**: UseCase layer has zero Flutter dependency. Maximize testability

```dart
class PlaceOrderUseCase {
  final OrderRepository _orderRepo;
  final PaymentRepository _paymentRepo;
  const PlaceOrderUseCase(this._orderRepo, this._paymentRepo);

  Future<Result<Order>> execute(OrderRequest request) async {
    final payment = await _paymentRepo.processPayment(request.payment);
    return switch (payment) {
      Success(:final data) => await _orderRepo.createOrder(request, data),
      Failure(:final error) => Failure(error),
    };
  }
}
```

### §61. Entity Design

- **Domain Entity**: Value objects specific to business logic. Defined separately from DTOs
- **Immutability**: All Entities made immutable with `freezed`
- **Validation**: Input validation via factory methods

### §62. DTO ↔ Entity Mapping

- **Mapper**: Define `toEntity()` / `fromEntity()` methods in Data layer
- **Mapping direction**: DTO → Entity (Data layer), Entity → DTO (Data layer). Domain layer knows nothing about DTOs
- **Null-safe mapping**: Convert null values from server to default values

### §63. DataSource Abstraction

- **RemoteDataSource**: Wraps HTTP API communication. Inject Dio instance
- **LocalDataSource**: Wraps local DB (Drift) operations
- **Repository integration**: Integrate Remote and Local for offline-capable Data Flow

### §64. Testability Design

- **Interface first**: Define abstract classes for all Repositories/DataSources
- **Mock generation**: Auto-generate mocks with `mocktail` package
- **Testability metric**: Domain layer tests with zero external dependencies should comprise 50%+ of all tests

---

## XIV. Repository & Data Layer

### §65. Repository Pattern

```dart
abstract class OrderRepository {
  Future<Result<List<Order>>> getOrders();
  Future<Result<Order>> getOrderById(String id);
  Future<Result<void>> placeOrder(OrderRequest request);
}

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource _remote;
  final OrderLocalDataSource _local;
  const OrderRepositoryImpl(this._remote, this._local);

  @override
  Future<Result<List<Order>>> getOrders() async {
    try {
      final dtoList = await _remote.fetchOrders();
      final entities = dtoList.map((d) => d.toEntity()).toList();
      await _local.cacheOrders(dtoList);
      return Success(entities);
    } on DioException catch (e) {
      final cached = await _local.getCachedOrders();
      if (cached.isNotEmpty) return Success(cached.map((d) => d.toEntity()).toList());
      return Failure(NetworkException.fromDio(e));
    }
  }
}
```

### §66. Caching Strategies

| Strategy | Description | Use Case |
|---|---|---|
| Cache First | Return local first, update in background | Product catalog |
| Network First | Prioritize network, cache on failure | User data |
| Stale While Revalidate | Show stale data instantly + update behind | Feed |
| Network Only | Always fetch from network | Payment info |

### §67. Pagination

- **Cursor-based**: Use `cursor` parameter for large datasets
- **Riverpod integration**: Manage page parameters with `FamilyAsyncNotifier`
- **Scroll detection**: Detect end-of-list with `ScrollController` and load next page
- **Infinite scroll**: Implement with `ListView.builder`. Full data loading prohibited

### §68. Data Synchronization Patterns

- **Delta Sync**: Fetch only changes since last sync (`last_synced_at` parameter)
- **Full Sync**: Fallback for initial launch or Delta Sync failures
- **Conflict Resolution**: Server Wins as default strategy

---

## XV. Dependency Injection (DI)

### §69. Riverpod-based DI

- **Use Riverpod's Provider as DI container**. Additional DI libraries like `get_it` generally unnecessary
- Register all Repositories against their interfaces

```dart
@riverpod
OrderRepository orderRepository(Ref ref) {
  return OrderRepositoryImpl(
    ref.watch(orderRemoteDataSourceProvider),
    ref.watch(orderLocalDataSourceProvider),
  );
}
```

### §70. Test-time DI Replacement

- **`ProviderContainer` overrides**: Replace Providers with mocks in unit tests
- **`ProviderScope` overrides**: Replace at scope level for Widget Test / Integration Test

### §71. Environment-specific DI Configuration

- **Flavor/environment management**: Switch environments with `--dart-define=ENV=development`
- **Environment-specific Providers**: Inject different API URLs/services for dev/staging/production

```dart
@riverpod
String apiBaseUrl(Ref ref) {
  const env = String.fromEnvironment('ENV', defaultValue: 'production');
  return switch (env) {
    'development' => 'https://dev-api.example.com',
    'staging' => 'https://staging-api.example.com',
    _ => 'https://api.example.com',
  };
}
```

---

# Part F: Performance & Rendering

## XVI. Performance Foundation — "120fps or Die"

### §72. const Constructor Enforcement

- **Always apply `const` constructors** to unchanging Widgets
- Run `dart fix --apply` periodically to auto-fix `const`-eligible Widgets
- **Lint**: Enable `prefer_const_constructors`

### §73. Rebuild Suppression

- **Minimize rebuild scope** with `Consumer` widget or `ConsumerWidget`
- Use `Builder` pattern to set explicit rebuild boundaries
- **Prohibited**: `setState()` abuse causing full-screen redraws

### §74. List Optimization

- **`ListView.builder()` required**. `ListView(children: [...])` only for fixed/small item counts
- **Specify `itemExtent` or `prototypeItem`** to improve scroll performance
- **SliverList/SliverGrid**: Use Sliver API for complex scroll layouts
- **`findChildIndexCallback`**: ID-based element lookup to prevent unnecessary redraws

### §75. RepaintBoundary

- Wrap **heavily animated Widgets** with `RepaintBoundary` to isolate repaint areas
- Visually verify repaint areas with DevTools "Highlight repaints"
- **Avoid overuse**: RepaintBoundary itself has memory cost. Apply based on measurements

### §76. Computation Cost Isolation

- **`ValueListenableBuilder`**: Rebuild only on specific value changes
- **`AnimatedBuilder`**: Rebuild only on animation value changes
- **`Selector` pattern**: Watch only partial state fields, eliminating unrelated rebuilds

### §77. Performance Measurement Standards

- **Always measure in Profile/Release mode**. Debug mode measurements are invalid
- Frame rate target: **16ms/frame (60fps) absolute minimum**. 8ms/frame (120fps) target for Impeller devices
- **CI integration**: Embed performance regression tests in CI for auto-detection

```bash
flutter run --profile  # Performance measurement
flutter run --release  # Production-equivalent verification
```

---

## XVII. Impeller Rendering Engine

### §78. Impeller Adoption Policy

- **iOS**: Impeller is the **sole renderer**. Skia completely removed. No opt-out
- **Android**: Enabled by default on API 29+ (Vulkan backend). **Opt-out deprecated** (Flutter 3.38+). API 28 and below fallback to OpenGL
- **Skia fallback**: Completely abolished on iOS. Prohibited on Android in principle (only automatic fallback on legacy API 28 and below)

### §79. Impeller Benefits & Optimization

- **Benefits**: AOT pre-compilation of shaders eliminates "shader compilation jank"
- **120fps support**: Fragment Shader efficiency critical for 8.33ms frame budget
- **Impeller Inspector**: Identify and fix overdraw issues in DevTools
- **Impeller-specific DevTools (2026)**: Provides the following dedicated metrics:
  - **Command Buffer Build Time**: Draw command construction time. Target ≤ 8.33ms
  - **GPU Frame Time**: GPU-side frame processing time. Verify in Raster tab
  - **Texture Upload Latency**: Texture upload delay. Detect bottlenecks from large image decoding
  - **Draw Call Count**: Draw call count and batching efficiency. Excessive calls require layout review
  - **GPU Memory Usage**: Real-time GPU memory usage monitoring

### §80. Custom Shaders

- **Write Impeller-compatible**: SkSL-incompatible shaders prohibited
- **`FragmentProgram`**: Implement custom visual effects with Impeller-compatible Fragment Shader API
- **Math operations first**: Prefer mathematical operations over conditional logic in shaders (GPU optimization)

---

## XVIII. Widget Tree Optimization

### §81. Widget Splitting Strategy

- **Split into small Widgets**: Target 50 lines or less per Widget
- **`const` Widget extraction**: Extract static Widgets into independent const classes
- **Widget classes over functions**: `Widget buildHeader()` → `class HeaderWidget`. Functions lack rebuild optimization

### §82. Sliver API Usage

- **`CustomScrollView`**: Efficiently combine multiple scrollable content
- **`SliverAppBar`**: AppBar that responds to scroll
- **`SliverList.builder` / `SliverGrid`**: Lazy construction of large datasets

### §83. Overlay & Dialog Optimization

- **`OverlayPortal` (Flutter 3.10+)**: Tooltips, dropdowns, and other overlays
- **Dialog/BottomSheet**: Manage state only within `showDialog` / `showModalBottomSheet` builders

### §84. Key Strategy

- **`ValueKey`**: ID-based identification for list elements
- **`UniqueKey`**: When forced reconstruction is needed
- **`GlobalKey` restriction**: High performance cost. Usage outside form validation requires approval

### §85. Layout Optimization

- **`ConstrainedBox` / `SizedBox`**: SizedBox for fixed sizes, ConstrainedBox for constraints
- **`IntrinsicHeight` / `IntrinsicWidth`**: Minimize usage (costly 2-pass layout)
- **`Wrap`**: Dynamic wrapping layout. Consider Flow for large element counts

---

## XIX. Startup Optimization & App Size

### §86. Cold Start Target

- **Startup time (cold start) must be within 2 seconds** — absolute target
- Execute initialization in parallel with `Future.wait()`. Sequential `await` chains prohibited
- Defer heavy initialization (DB migration, etc.) to background

### §87. App Size Target

- **Target size: 30MB or less** (AAB/IPA)
- Split by ABI with `flutter build appbundle --split-per-abi`
- Periodically audit/remove unused packages with `dart pub deps --no-dev`
- **Icon/font optimization**: Remove unused Material icons (`--no-tree-shake-icons` prohibited)

### §88. Tree Shaking & Obfuscation

- Obfuscation is **required** for release builds:

```bash
flutter build ipa --obfuscate --split-debug-info=build/debug-info
flutter build appbundle --obfuscate --split-debug-info=build/debug-info
```

- Upload symbol files to Crashlytics/Sentry

### §89. Deferred Loading

- **`deferred as`**: Reduce bundle size with deferred imports for large libraries
- **Route-based deferred loading**: Initial load of feature modules on route transition
- **Asset bundle splitting**: Download large assets on-demand via network

---

## XX. Memory Management & Profiling

### §90. Memory Leak Prevention

- **StreamSubscription release**: Always cancel in `ref.onDispose()`
- **AnimationController release**: Always dispose in `dispose()`
- **TextEditingController release**: Always `dispose()` in StatefulWidget/HookWidget
- **Closure capture**: Watch for `this` capture. Avoid unnecessary reference retention

### §91. Dart DevTools Profiling

- **Heap Snapshot**: Periodically take Heap Snapshots to detect unintended object retention
- **Allocation Tracking**: Detect high-frequency allocations and consider object pooling
- **Leak Tracking**: CI-integrate automatic leak detection with `leak_tracker` package

### §92. Image Memory Management

- **`ImageCache` configuration**: Limit cache size with `PaintingBinding.instance.imageCache.maximumSize`
- **Appropriate image sizes**: Fetch images at device screen-appropriate resolution (oversized images prohibited)
- **`ResizeImage`**: Resize images at decode time to match display size

### §93. Profiling CI Integration

- **`flutter test --track-widget-creation`**: Track Widget creation for DevTools analysis
- **Benchmark tests**: Measure execution time of key operations with `flutter_test` `Benchmark`
- **Memory regression tests**: Record memory usage after key flow execution to detect regressions

---

# Part G: Data & Network

## XXI. Offline-First & Local DB

### §94. Offline-First Principle

- **Treat local DB as SSOT**. UI always renders from local DB
- Network is a "sync layer" — not a prerequisite for UI rendering

### §95. Local DB Selection

| Use Case | Recommended |
|---|---|
| Relational data (complex queries) | **Drift** (formerly Moor) |
| Key-Value settings | **SharedPreferences** |
| Sensitive data (tokens, PII) | **flutter_secure_storage** |
| Full-text search on large data | **Drift** + FTS5 |

### §96. Drift Configuration

```dart
@DriftDatabase(tables: [Orders, Users, SyncQueue])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);
  @override int get schemaVersion => 2;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        await m.addColumn(schema.orders, schema.orders.syncStatus);
      },
    ),
  );
}
```

### §97. Sync Architecture

- **Repository pattern** abstracts local/remote
- **Sync queue**: Record offline mutations to Drift sync table; batch send on network recovery
- **Connectivity detection**: Monitor network state with `connectivity_plus`; auto-sync on recovery

### §98. Data Encryption

- **SQLCipher**: Transparent encryption for sensitive local DBs via Drift + SQLCipher
- **Key management**: Store encryption keys in `flutter_secure_storage`. Hardcoding prohibited

---

## XXII. Network Communication & API Integration

### §99. HTTP Client

- **Adopt `dio` as standard HTTP client**. `http` package generally not used
- **Interceptors** handle cross-cutting concerns for requests/responses

### §100. API Authentication — VIP Lane Strategy

- **Law**: For authenticated user requests, **do not send API Key (`x-api-key`); send only `Authorization: Bearer <token>`**
- **Rationale**: Physically eliminates API Key embedding risk in app binary
- Token refresh handled automatically by Dio interceptor

### §101. Error Handling & Retry

- Set timeouts for all API calls (connect: 10s, receive: 30s)
- **Exponential Backoff** with max 3 retries for transient errors (5xx, timeout)
- Model error responses with sealed classes for type safety (see §31)

### §102. Dio Interceptor Architecture

```dart
final dio = Dio(BaseOptions(
  baseUrl: apiBaseUrl,
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 30),
))
  ..interceptors.addAll([
    AuthInterceptor(ref),
    RetryInterceptor(maxRetries: 3),
    LogInterceptor(requestBody: true, responseBody: true),
    ErrorMappingInterceptor(),
  ]);
```

### §103. GraphQL Support (Optional)

- **`graphql_flutter`**: Standard package for GraphQL APIs
- **Code generation**: Generate type-safe Dart code with `graphql_codegen`
- **Caching**: Leverage GraphQL normalized cache to reduce network requests

### §104. HTTP/2 & HTTP/3

- **HTTP/2**: Enable via `dio_http2_adapter`
- **HTTP/3 (QUIC)**: Evaluate migration when client support stabilizes
- **Connection pooling**: Reuse connections for multiple requests to the same host

---

## XXIII. Image, Media & Asset Management

### §105. Image Caching

- **`cached_network_image` required**. Direct `Image.network()` prohibited
- Always set placeholder and error widgets
- **Shimmer placeholder**: Use `shimmer` package for loading UI quality

### §106. Image Optimization

- Serve responsive images server-side; fetch device-optimal sizes
- **Prefer WebP/AVIF formats**. PNG/JPEG as fallback only
- Compress local assets before build

### §107. SVG & Vector Graphics

- Use **SVG (`flutter_svg`)** for icons/illustrations for resolution independence
- Convert complex SVGs to vector binary at build time (`vector_graphics_compiler`)

### §108. Video & Audio

- **`video_player`**: Standard for video playback
- **`just_audio`**: Standard for audio playback
- **Background playback**: Integrate with `audio_service` for background playback and media controls

---

## XXIV. Real-time Communication

### §109. WebSocket Integration

- **`web_socket_channel`**: Standard WebSocket package
- **Auto-reconnect**: Implement Exponential Backoff reconnection on disconnection
- **Heartbeat**: Send periodic Ping/Pong messages for connection maintenance

### §110. Server-Sent Events (SSE)

- **Use case**: One-way real-time streams from server (notifications, feed updates)
- **Dio support**: Receive SSE with `dio`'s `responseType: ResponseType.stream`

### §111. Supabase Realtime

- **Supabase Realtime**: Real-time notifications of database changes
- **Channels**: Subscribe per table. Security enforced by RLS
- **Presence**: Share user presence information (online status)

---

# Part H: Platform & UX

## XXV. Platform Fidelity

### §112. Native Feel (Required)

- **iOS**: Swipe-back gesture (`CupertinoPageRoute`), Bouncing Scroll Physics, Cupertino UI components
- **Cupertino Squircles (Flutter 3.32+)**: `CupertinoAlertDialog` and `CupertinoActionSheet` now support Apple-standard superellipse (rounded squircle) shapes. Improved iOS fidelity
- **Android**: System back button, Predictive Back Gesture support, Clamping Scroll Physics, Material Design 3
- **Absolutely prohibited**: Material dialogs on iOS, Cupertino usage on Android

### §113. .adaptive() Constructors

- **Prefer `Switch.adaptive()`, `Slider.adaptive()`, `CircularProgressIndicator.adaptive()`**
- Auto-switch between Material/Cupertino based on platform

### §114. Platform-Specific Code

- Centralize platform-specific logic in **one location**. Do not scatter across UI layer
- Use **Pigeon (type-safe Platform Channels)** for native API communication. Raw `MethodChannel` strings prohibited

### §115. Platform Channel & FFI

- **Pigeon**: Type-safe communication with iOS/Android. Share type definitions via code generation
- **Dart FFI**: Direct C/C++ library integration for performance-critical processing
- **`@Native` annotation**: Simplified FFI function binding

### §116. Haptic Feedback

- **`HapticFeedback` class**: Tactile feedback for taps, long presses
- **Usage guidelines**: Use only for significant actions (payment completion, errors). Excessive feedback prohibited
- **Platform compliance**: Appropriately use iOS Haptic Engine / Android Vibration API

---

## XXVI. Responsive & Adaptive UI

### §117. Breakpoint Definitions

| Device Type | Width |
|---|---|
| Mobile (Compact) | < 600dp |
| Tablet (Medium) | 600dp – 840dp |
| Desktop (Expanded) | > 840dp |

### §118. Layout Widgets

- **`LayoutBuilder`** for breakpoint-based layout switching
- **`MediaQuery.sizeOf(context)`**: Do not use deprecated `MediaQuery.of(context).size`
- Guarantee SafeArea, notch, punch-hole, Dynamic Island support on all screens

### §119. AdaptiveScaffold

- **`adaptive_scaffold` package**: Auto-switch NavigationBar / NavigationRail / NavigationDrawer by screen size
- Use **screen width-based** layout decisions, not device type checks (`Platform.isAndroid`, etc.)

### §120. Foldable Device Support

- **Foldable support**: Leverage `MediaQuery` hinge information
- **Multi-window**: Support Android large-screen multi-window mode

### §121. Screen Rotation & Resizing

- **Screen rotation lock prohibited**: Layout must handle any window size/orientation
- **`OrientationBuilder`**: Layout branching based on screen orientation

---

## XXVII. Material 3 & Design System

### §122. Material 3 Theme Configuration

```dart
MaterialApp(
  theme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
    typography: Typography.material2021(),
  ),
  darkTheme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.dark,
    ),
  ),
);
```

### §123. Design Token System

- **Color Token**: Treat `ColorScheme` properties (`primary`, `secondary`, `surface`) as Design Tokens
- **Typography Token**: Unify `TextTheme` styles (`headlineLarge`, `bodyMedium`)
- **Elevation Token**: Consistent elevation with `ElevationOverlay`
- **Hardcoded colors prohibited**: No direct `Color(0xFF...)`. Always via `Theme.of(context).colorScheme`

### §124. Dark/Light Mode

- **Follow system settings**: `ThemeMode.system` as default
- **Manual toggle**: Provide UI for manual theme switching
- **Testing**: Run Golden Tests in both dark/light modes

### §125. Custom Design System

- **Component library**: Centralize project-specific design system in `core/theme/`
- **Semantic colors**: Define `successColor`, `warningColor` via ThemeExtension
- **Spacing constants**: Define 4dp/8dp/16dp/24dp/32dp spacing constants

### §126. Icons & Typography

- **Material Symbols**: Use Material Icons 3 variable icons
- **Custom fonts**: Deliver via `google_fonts` package or asset bundle
- **Font scaling**: Guarantee `textScaler` support for all text

---

## XXVIII. Animation & Motion Design

### §127. Animation Classification & Selection

| Type | Use Case | Recommended API |
|---|---|---|
| Implicit | Simple property changes | `AnimatedContainer`, `AnimatedOpacity` |
| Explicit | Rich animations needing fine control | `AnimationController` + `Tween` |
| Hero | Shared element transitions between screens | `Hero` widget |
| Physics-based | Natural motion animations | `SpringSimulation` |
| Lottie/Rive | Designer-crafted complex animations | `lottie`, `rive` |

### §128. Animation Performance Standards

- **60fps guaranteed**: Zero frame drops during animation
- **Animation duration**: 200ms–400ms default. Over 500ms requires approval
- **Curve**: `Curves.easeInOutCubicEmphasized` (Material 3 recommended)

### §129. Page Transition Animations

- **iOS**: `CupertinoPageTransition` (right-to-left slide)
- **Android**: `FadeUpwardsPageTransition` or `ZoomPageTransition`
- **SharedAxisTransition**: Material 3 Shared Axis transition pattern

### §130. Lottie/Rive Integration

- **Lottie**: After Effects-based animations via `lottie` package
- **Rive**: Interactive state machine-based animations via `rive` package
- **Asset size**: Target Lottie JSON under 100KB. Consider Rive for larger animations

---

## XXIX. Forms & Input UX

### §131. Form Design Patterns

- **Reactive Forms**: Integrate `FormField` + `TextFormField` with Riverpod Notifier
- **Validation**: Two-stage — field-level (immediate) + form-level (on submit)
- **Error display**: Inline error messages below each field

### §132. Input UX

- **`TextInputType`**: Specify appropriate keyboard type per field (email, phone, number)
- **`TextInputAction`**: Optimize focus movement with `next` → `done` sequence
- **Autocomplete**: Support OS-standard autofill with `AutofillGroup`

### §133. IME & Internationalization Support

- **NFKC normalization**: Normalize full-width alphanumerics to half-width (Japanese input support)
- **maxLength**: Limit by character count, not byte count, with `LengthLimitingTextInputFormatter`
- **IME guard**: Suppress validation during `composing` state

### §134. Search UI

- **`SearchAnchor` (Material 3)**: Standard search UI
- **Debounce**: Apply 300ms debounce to search query input
- **Search history**: Persist search history in local storage

---

# Part I: Accessibility

## XXX. Accessibility (a11y)

### §135. Semantics Widget

- **Apply `Semantics` widget labels to all interactive elements**
- Always specify `semanticLabel` for icon buttons
- **Semantics Tree**: Verify logical order in DevTools Semantics Tree
- **`SemanticsRole` API (Flutter 3.32+)**: Finer control over assistive technology interpretation. Explicitly define semantic roles for buttons, links, headings, etc.
- **WCAG 2.2 AA New Criteria Compliance**:
  - **Target Size (Enhanced) 2.5.8**: Tap targets minimum 24×24dp (recommended 44×44dp). Automatic compliance with existing 48dp rule
  - **Focus Not Obscured (Minimum) 2.4.11**: Guarantee focused elements are not hidden by Sticky Header/Footer
  - **Dragging Movements 2.5.7**: Always provide alternatives to drag operations (button-based actions, etc.)
- **EU Accessibility Act (EAA) 2025**: Effective June 2025. Apps targeting the EU market must comply with WCAG 2.1 AA as a legal obligation

### §136. Tap Targets

- **Minimum tap target size: 48×48dp** (WCAG 2.1 AA compliant)
- **`MaterialTapTargetSize.padded`**: Material Widget default

### §137. Contrast Ratio

- Text-to-background contrast ratio **minimum 4.5:1** (AA compliant). Large text (18sp+): 3:1
- **Tool**: Auto-verify contrast with `Accessibility Scanner`

### §138. Screen Reader Support

- **Manually verify all screens with TalkBack (Android) & VoiceOver (iOS)**
- CI/CD-integrate automated tests using `Accessibility Guideline API`:

```dart
testWidgets('a11y check', (tester) async {
  await tester.pumpWidget(MyApp());
  await expectLater(tester, meetsGuideline(textContrastGuideline));
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
});
```

### §139. Dynamic Font Size

- Support **`MediaQuery.textScalerOf(context)`** respecting system font size settings
- Verify no text overflow at 200% scale

### §140. Input Mode Support

- **Keyboard navigation**: All operations possible via keyboard (Desktop/Web)
- **Switch Control**: Verify iOS Switch Control operability
- **Motion consideration**: Respect `MediaQuery.disableAnimationsOf(context)` motion settings

### §141. Text Direction & Language Support

- **RTL support**: Control text direction with `Directionality` widget
- **Testing**: Verify no layout breakage in RTL locales via Golden Test

---

# Part J: Security

## XXXI. Security Foundation — OWASP MAS

### §142. OWASP MAS Alignment

- Comply with **OWASP MASVS (Mobile Application Security Verification Standard)**. Manage security requirements by the following Control Groups:
  - **MASVS-STORAGE**: Data protection (§144, §98)
  - **MASVS-CRYPTO**: Encryption (AES-256-GCM, SHA-256/3)
  - **MASVS-AUTH**: Authentication (§197–§199)
  - **MASVS-NETWORK**: Communication security (§145)
  - **MASVS-PLATFORM**: Platform security (§112–§116)
  - **MASVS-CODE**: Code quality (§88, §146)
  - **MASVS-RESILIENCE**: Runtime protection & RASP (§147–§149)
- Use **OWASP MASTG (Mobile Application Security Testing Guide)** as the testing framework
- **MobSF**: Integrate into CI/CD for automated SAST (static analysis)

### §143. Secrets Management

- **Absolutely prohibit embedding API Key / Secret Key in app binary**
- Inject environment variables via build-time `--dart-define`:

```bash
flutter run --dart-define=API_URL=https://api.example.com
```

- **`--dart-define-from-file`**: Batch inject from `.env` files
- Retrieve runtime secrets from server

### §144. Secure Storage

- Store tokens, PII, passwords in **`flutter_secure_storage`** (iOS Keychain / Android Keystore)
- **Absolutely prohibit storing sensitive data in `SharedPreferences`**
- **Backup exclusion**: Android `android:allowBackup="false"`, iOS `isExcludedFromBackup`

### §145. Communication Security

- **HTTPS only**. No HTTP fallback permitted
- **Certificate Pinning**: Pin SPKI hashes to prevent MITM attacks
- **Backup pins**: Set multiple pins to prevent app blocking during cert rotation
- **TLS 1.2+ required**: Reject TLS 1.0/1.1

### §146. Code Protection

- **`--obfuscate` required** for release builds (see §88)
- Auto-verify ProGuard/R8 (Android) configuration in CI/CD
- **Log output**: Completely disable sensitive log output in release builds. Control with `kReleaseMode` flag

---

## XXXII. Runtime Protection & RASP

### §147. RASP (Runtime Application Self-Protection)

- Deploy **`freeRASP`** (or commercial RASP SDK) to detect:
  - Root/Jailbreak detection
  - Debugger/hooking framework (Frida, etc.) detection
  - App tampering (repackaging) detection
  - Emulator/virtual environment detection
  - Screen recording detection

### §148. RASP Response Actions

- RASP detection actions **controlled server-side**. Client-only blocking is bypassable
- Graduated response: Warning → Feature restriction → Session invalidation → App block
- **Telemetry**: Send RASP detection events to server for threat intelligence accumulation

### §149. Additional Security Measures

- **Screenshot prevention**: Control screen capture for financial screens with `FlutterWindowManager`
- **Clipboard control**: Control copying from sensitive fields
- **Background snapshot**: Hide content with secure screen during app switching

---

# Part K: AI & On-Device ML

## XXXIII. AI & On-Device ML

### §150. On-Device ML Integration

- **Google ML Kit**: Standard tasks — text recognition (OCR), face detection, barcode scanning
- **TFLite (TensorFlow Lite)**: Run custom models on-device via `tflite_flutter` package
- **Quantization**: Post-training quantization for model size reduction and inference speed improvement
- **Isolate execution**: Run ML inference on `Isolate.run()` to prevent UI jank

### §151. Gemini / Generative AI Integration

- **Firebase AI Logic**: Connect to Gemini API via `firebase_ai` package
- **Streaming response**: Display AI responses in real-time with `generateContentStream()`
- **Multimodal**: Support text + image input
- **FinOps**: Govern AI API call costs with `30% rule` (alert when exceeding 30% of monthly budget)

### §152. Gemini Nano (On-Device)

- **On-device LLM**: Network-free lightweight inference (summarization, proofreading, rewriting)
- **Use cases**: Real-time text suggestions, privacy-preserving processing of sensitive data
- **Device support**: Only on supported hardware (Pixel 8 Pro and later)

### §153. AI Agent Integration

- **MCP (Model Context Protocol)**: Provide app data as Context to AI Tools
- **Intent-Based UI**: Dynamic UI adaptation based on AI analysis
- **Guardrails**: Filter AI output for quality and safety

### §154. Model Management

- **Firebase ML**: OTA download custom TFLite models via Firebase
- **Model versioning**: Model updates without app updates. Background download and apply
- **Fallback**: Fall back to bundled initial model on download failure

---

# Part L: Testing Strategy

## XXXIV. Testing Strategy

### §155. Test Pyramid

| Level | Target | Framework | CI Required |
|---|---|---|---|
| Unit Test | Domain/Data layer logic | `flutter_test` | ✅ |
| Widget Test | Individual UI components | `flutter_test` | ✅ |
| Golden Test | UI snapshot regression | `golden_toolkit` | ✅ |
| Integration Test | Full user flows | `integration_test` | ✅ |
| E2E Test | Real device/emulator | **Maestro** | ✅ (nightly) |
| Security Test | OWASP MAS verification | **MobSF** | ✅ (pre-release) |

### §156. Golden Test Standards

- **Multiple device sizes** (iPhone SE / Pro Max / Pixel 7) snapshot testing
- Capture snapshots in both dark/light modes
- Capture RTL locale snapshots
- Update Golden files with `flutter test --update-goldens`; visually review diffs in PR review

### §157. Coverage Targets

- **Domain layer: 90%+** / **Data layer: 80%+** / **Presentation layer: Widget Test + Golden Test**
- Block PRs below coverage thresholds in CI/CD

### §158. Mock Strategy

- **`mocktail`**: Standard mock generation. Lighter than `mockito` with full null safety
- **Faker**: Use `faker` package for test data generation
- **`patrol` (E2E New Standard)**: Dart-native E2E testing as Maestro alternative/complement. Directly operate native UIAutomation/UiAutomator from Dart
- **`alchemist` (Golden Test Enhancement)**: Golden Test framework that absorbs font rendering differences in CI environments
- **Test fixtures**: Centralize common test data in `test/fixtures/`

### §159. Property-Based Testing

- **`glados`**: Auto-discover edge cases with Property-Based Testing
- **Use cases**: Parsers, validators, data transformation logic

### §160. Performance Testing

- **Benchmarks**: Measure key operation execution time with `flutter_test` `Benchmark`
- **Memory profiling**: Record memory usage during tests and detect regressions
- **Frame rate testing**: Detect animation frame drops in CI

### §161. Accessibility Testing (Automated)

- Run `meetsGuideline()` on all screens (see §138)
- **Font scaling test**: Verify no overflow at 200% scale

### §162. Security Testing

- **MobSF**: CI-integrate APK/IPA static analysis
- **OWASP MASTG**: Include test cases in manual test plan
- **Dependency vulnerability scanning**: Periodically run `dart pub outdated`

---

# Part M: CI/CD & Deployment

## XXXV. CI/CD & Deployment

### §163. CI Pipeline Structure

```
Push/PR → Format Check → Lint → Test → Build → Distribute
```

- **Format**: `dart format --set-exit-if-changed .`
- **Lint**: `dart analyze --fatal-infos`
- **Test**: Unit + Widget + Golden + Accessibility Tests
- **Build**: `flutter build ipa/appbundle --release --obfuscate`
- No merge unless all steps pass

### §164. CD Pipeline Structure

| Trigger | Action | Distribution |
|---|---|---|
| PR → develop | Build + Test | Firebase App Distribution |
| develop → main | Build + Test + Sign | TestFlight / Google Play Internal |
| main tag | Production build | App Store / Google Play (staged) |

### §165. Signing Management

- iOS: **App Store Connect API + Fastlane Match** for automatic cert/profile management
- Android: **Play App Signing**; manage only upload key in CI/CD
- **Absolutely prohibit including private keys in repository**

### §166. OTA Updates — Shorebird

- **Shorebird Code Push** for OTA Dart code updates
- **Constraint**: Only Dart code can be updated. Native plugins and assets require store submission
- **Dual Track Strategy**: Submit Shorebird patches and store releases simultaneously for 100% coverage guarantee
- **Lock File Persistence**: Save `pubspec.lock` and `Podfile.lock` as CI artifacts. Essential practice to reproduce the same dependency graph when creating patches
- **`fastlane-plugin-shorebird`**: Execute `shorebird_release`/`shorebird_patch` directly within Fastlane lanes
- **Patch Success Rate Monitoring**: Monitor patch adoption rate, success rate, and rollback performance in Shorebird Console

### §167. Environment Management (Flavor)

- **Flutter Flavors**: `--flavor dev`/`--flavor staging`/`--flavor prod` for environment isolation
- **`--dart-define-from-file`**: Inject env vars from `.env.dev`/`.env.prod`
- **Firebase Flavor support**: Place `google-services.json`/`GoogleService-Info.plist` per environment

### §168. Build Cache

- **GitHub Actions Cache**: Cache Flutter SDK, pub cache, build_runner output
- **Build time target: 15 minutes or less**. Review cache strategy if exceeded

### §169. Code Signing Automation

```yaml
- name: Build iOS
  run: |
    flutter build ipa \
      --release \
      --obfuscate \
      --split-debug-info=build/debug-info \
      --export-options-plist=ios/ExportOptions.plist
```

### §170. Staged Rollout

- **Google Play**: Staged rollout (1% → 5% → 25% → 100%)
- **App Store**: Phased release (1-7 days)
- **Rollback**: Immediately halt rollout if crash rate exceeds 0.5%

---

# Part N: Observability & Monitoring

## XXXVI. Observability & Monitoring

### §171. Crash Reporting

- **Firebase Crashlytics** as default. Always upload obfuscation symbols
- Adopt **Sentry** for advanced distributed tracing needs
- **Non-fatal Error**: Record business-critical errors with `recordError()`

### §172. Performance Monitoring

- **Firebase Performance Monitoring** for automatic HTTP request and screen rendering time measurement
- Custom traces for measuring business-critical operation durations

### §173. Analytics

- **Firebase Analytics** as default
- Auto-send `logScreenView` events on all screen transitions (implement via GoRouter `observer`)
- Record user actions with standardized event names

### §174. Logging Strategy

- **Debug mode**: Structured logging with `logger` package
- **Release mode**: Console logging completely disabled. Remote logging to Crashlytics/Sentry only
- **Sensitive information logging prohibited**: Prohibit token/PII logging in all modes

### §175. Custom Metrics

- **App-specific KPIs**: Define business metrics like "payment completion rate", "search result display time"
- **User flow analysis**: Measure completion rates and drop-off points for key flows

### §176. Remote Configuration

- **Firebase Remote Config**: A/B testing, feature flags, dynamic parameter delivery
- **Default values required**: Set fallback values for all parameters on fetch failure
- **Cache strategy**: Control API call frequency with `minimumFetchInterval`

---

# Part O: Multi-Platform & Ecosystem

## XXXVII. Multi-Platform & Ecosystem

### §177. Flutter Web

- **Use cases**: Admin panels, landing pages, PWA. Web version of main mobile app
- **Rendering**: CanvasKit (high quality) vs HTML (lightweight) selection
- **SEO**: No SSR possible. SPA-specific SEO measures (`flutter_meta_seo`, etc.)
- **Performance**: Optimize initial load time. Leverage Tree Shaking + Deferred Loading
- **Web Hot Reload (Flutter 3.32+ Experimental)**: Hot Reload in the browser experimentally available. Reflect UI changes instantly without full reload
- **WebAssembly (Dart→Wasm)**: Major performance improvement for Web targets. CanvasKit+Wasm for native-grade rendering speed

### §178. Flutter Desktop

- **Use cases**: Internal tools, admin panels, utility apps
- **Window management**: Control window size with `window_size` package
- **Keyboard shortcuts**: Support desktop operations with `Shortcuts`/`Actions` widgets
- **Menu bar**: Implement native menu bar with `PlatformMenuBar`

### §179. Package Management & SBOM

- **Dependency audit**: Run `dart pub outdated` monthly
- **SBOM (Software Bill of Materials)**: Generate package list in CycloneDX format
- **License verification**: Verify all dependency package licenses. Note GPL compatibility
- **Security scanning**: Respond to `dart pub deps` vulnerability warnings within 48 hours

### §180. Wearable & Embedded

- **Wear OS**: Compose for Wear OS (native recommended). Flutter Wear OS plugin limited
- **watchOS**: WatchKit/SwiftUI (native required)
- **IoT/Embedded**: Flutter Embedded is experimental. Evaluate for production use

### §181. Plugin Development

- **Federated Plugin**: Platform-specific implementations in separated plugin architecture
- **Platform Interface**: Define common interface in `_platform_interface` package
- **Testing**: Plugin Unit Tests via Platform Channel mocking

### §182. Monorepo Strategy

- **Melos**: Flutter/Dart monorepo management tool
- **Package splitting**: Manage shared libraries/feature modules in `packages/` directory
- **Dependency graph**: Visualize dependencies with `melos list --graph`

---

# Part P: Governance & Compliance

## XXXVIII. Governance & Compliance

### §183. Internationalization (i18n)

- **`flutter_localizations` + `intl`**: Flutter standard i18n. Manage messages with ARB files
- **ARB file structure**: `l10n/app_ja.arb`, `l10n/app_en.arb` separated by language
- **`l10n.yaml`**: Centralize code generation settings
- **Placeholders**: `{name}` format parameter insertion. Plural/gender support via ICU MF 2.0

### §184. Privacy & Compliance

- **Privacy Manifest (iOS)**: Declare API usage reasons in `PrivacyInfo.xcprivacy`
- **GDPR/Global Privacy Laws compliance**: Implement user data collection, storage, and deletion flows
- **Consent management**: Display data collection consent UI on first launch. Data transmission without consent prohibited
- **Data deletion**: Complete deletion of all local data on user account deletion

### §185. App Store / Google Play Compliance

- **IAP required**: Use in-app purchases (StoreKit 2 / Google Play Billing) for digital content
- **ASO (App Store Optimization)**: Optimize store listing keywords, screenshots, descriptions
- **Review guideline compliance**: Full compliance with HIG / Material Design Guidelines

### §186. Error Handling Governance

- **Classify all errors**: Fatal / Non-fatal / Expected / Unexpected — 4 categories
- **User display**: Prohibit displaying technical error messages directly to users
- **Error recovery**: Require retry/return-to-home actions on all error screens

### §187. Green Engineering

- **Battery optimization**: Minimize background processing. Select location accuracy per use case
- **Network efficiency**: Reduce data transfer with batch requests, compression, caching
- **Computation efficiency**: Eliminate unnecessary rebuilds/recalculations (per §72-§77)

### §188. Team & Organization Design

- **Code review**: Minimum 1 reviewer per PR. Include Flutter-specific performance/security perspectives
- **ADR (Architecture Decision Record)**: Record important tech decisions as ADRs
- **Knowledge sharing**: Monthly Flutter tech sharing sessions. Regular review of official blog/release notes

---

# Part Q: Maturity, Anti-Patterns & Future Outlook

## XXXIX. Maturity Model & Anti-Patterns

### §189. Maturity Model

| Level | Name | Criteria |
|---|---|---|
| L1 | Reactive | Crash response only. Insufficient tests. `setState()` dominant |
| L2 | Managed | CI/CD operational. Unit Tests. Riverpod adoption. Golden Tests started |
| L3 | Optimized | Offline-first. RASP deployed. a11y test automation. Full Material 3 migration |
| L4 | Proactive | Shorebird OTA operational. Performance budget enforced. Security scanning CI-integrated |
| L5 | Predictive | AI-assisted testing. Auto performance regression detection. FinOps optimization. Green engineering |

### §190. Prohibited Anti-Pattern Collection (Top 50)

| # | Anti-Pattern | Correct Approach |
|---|---|---|
| 1 | `setState()` abuse | Riverpod `Notifier` state management |
| 2 | Manual provider definitions | `@riverpod` code generation |
| 3 | Direct `Navigator.push()` | GoRouter `context.go()` |
| 4 | Tokens in `SharedPreferences` | `flutter_secure_storage` |
| 5 | Excessive `dynamic` type | Strict type annotations |
| 6 | Direct `Image.network()` | `cached_network_image` |
| 7 | Hardcoded API Keys | `--dart-define` or server retrieval |
| 8 | `ListView(children:[...])` for all | `ListView.builder()` |
| 9 | Watching entire state (no select) | `ref.watch(p.select(...))` |
| 10 | Debug-mode profiling | Profile/Release mode measurement |
| 11 | Raw `MethodChannel` strings | Pigeon (type-safe Platform Channel) |
| 12 | Material dialogs on iOS | `CupertinoAlertDialog` |
| 13 | Release builds without obfuscation | `--obfuscate` required |
| 14 | `.then()` chains | `async/await` |
| 15 | UI deployment without tests | Golden Test + CI/CD required |
| 16 | `Widget buildXxx()` functions | Extract to independent Widget class |
| 17 | `GlobalKey` overuse | `ValueKey` / `UniqueKey` |
| 18 | Excessive `late var` | `late final` only, or `?` nullable |
| 19 | `!` operator usage | `?.`, `??`, pattern matching |
| 20 | Barrel Exports (circular deps) | Direct imports |
| 21 | Excessive `IntrinsicHeight` | Fixed height or `ConstrainedBox` |
| 22 | Fire-and-forget | `await` or explicit `unawaited()` |
| 23 | Hardcoded `Color(0xFF...)` | `Theme.of(context).colorScheme` |
| 24 | Unreleased StreamSubscription | Release in `ref.onDispose()` |
| 25 | God Widget (500+ lines) | Split into 50-line Widgets |
| 26 | Async `BuildContext` usage | `mounted` check or `ref` |
| 27 | Real API calls in tests | Mock/stub isolation |
| 28 | `print()` in release builds | `kReleaseMode` guard |
| 29 | Skia fallback as default | Impeller enabled by default |
| 30 | `http` package usage | `dio` as standard |
| 31 | Hardcoded env variables | `--dart-define-from-file` |
| 32 | Screen rotation lock | All-orientation responsive layout |
| 33 | Ignoring `TextScaler` | 200% scale testing |
| 34 | No security testing | MobSF CI integration |
| 35 | `provider` package usage | Migrate to `riverpod` |
| 36 | Magic strings (route paths) | `AppRoutes` constants |
| 37 | `await` chains (waterfall) | `Future.wait()` parallel execution |
| 38 | Oversized image decoding | `ResizeImage` for proper sizing |
| 39 | Missing `Semantics` | Labels on all interactive elements |
| 40 | Main-thread ML inference | `Isolate.run()` isolation |
| 41 | Riverpod legacy API usage | Migrate to `Notifier`/`AsyncNotifier` |
| 42 | Missing `ref.mounted` check | `if (!ref.mounted) return` after async |
| 43 | `riverpod_lint` not installed | Add `riverpod_lint` to analysis_options |
| 44 | `showDialog()` calls scattered | Centralize dialogs in service/utility classes |
| 45 | Dropdowns without Overlay API | Use `OverlayPortal`/`CompositedTransformFollower` |
| 46 | `TextEditingController` not disposed | Reliably dispose via `ref.onDispose()` |
| 47 | No `message_id` check for notifications (duplication) | Idempotent `message_id` check |
| 48 | Direct `Scaffold.of(context)` usage | Use `ScaffoldMessenger.of(context)` |
| 49 | All permissions requested at launch | Context-dependent staged permission requests |
| 50 | `AnimationController` not disposed | Enforce `SingleTickerProviderStateMixin`+`dispose()` |

### §191. FinOps Benchmarks

| Metric | Target |
|---|---|
| CI build time | ≤ 15 min |
| App size (AAB/IPA) | ≤ 30MB |
| Cold start time | ≤ 2 sec |
| Frame rate | ≥ 60fps (120fps recommended) |
| Crash-free rate | ≥ 99.5% |
| Test coverage (Domain) | ≥ 90% |
| Security scan pass rate | 100% |

---

## XL. Future Outlook

### §192. Technology Roadmap

- **Dart Augmentations**: Class definition splitting. Evaluate `freezed` simplification after stable release
- **Flutter GPU API**: Direct GPU access for custom rendering. Revolutionary for games/3D
- **WebAssembly (Dart→Wasm)**: Major Web target performance improvement. Stability improved in Flutter 3.38+
- **Riverpod Offline GA**: Persistence feature stable release. Full adoption after Experimental graduation
- **GenUI SDK (Flutter 3.41+)**: Gemini-based AI-assisted development tools. Auto-generate UI components from natural language
- **Impeller Desktop/Web Integration**: Impeller deployment to macOS/Windows/Linux in progress. Web integration via WebGPU as future outlook

### §193. Ecosystem Evolution

- **AI-Driven Development**: Automated code generation/refactoring via Gemini Code Assist
- **Design-to-Code**: Maturation of Figma → Flutter Widget auto-conversion
- **Edge Computing**: On-device AI evolution. Gemini Nano device support expansion
- **Cross-Platform Unification**: Flutter Web/Desktop/Mobile boundaries further blurring
- **Sustainability**: Standardization of carbon-aware mobile app development
- **Flutter Modularization**: Framework module splitting in progress. Import only required components to reduce build size

---

# Part R: Mobile-Specific Infrastructure

## XLI. Push Notification Architecture

### §194. FCM / APNs Integration

- **Firebase Cloud Messaging (FCM)**: Unified push notification infrastructure for Android / iOS / Web
- **Direct APNs Integration**: Consider direct APNs integration for iOS-specific notification features (Live Activity, Critical Alert, etc.)
- **Token Management**: Centrally manage FCM tokens server-side. Guarantee immediate update on token refresh
- **Permission Request**: Request notification permission not at first launch, but **when the user understands the notification's value** (context-dependent permission)
- **Channel Design (Android)**: Separate Notification Channels by use case (`chat`, `promotion`, `system`, etc.)
- **`flutter_local_notifications` Integration**: Generate local notifications upon FCM receipt for customized foreground display
- **Idempotency (message_id)**: Prevent duplicate processing using notification `message_id`. Design that never processes the same notification multiple times is mandatory

### §195. Notification Payload Design

- **Data Message vs Notification Message**: Use **Data Message** when background processing is needed. Notification Messages have limited custom display in foreground
- **Payload Size**: FCM 4096 bytes / APNs 4096 bytes max. Reference images via external URLs
- **Rich Notification**: iOS: Notification Service Extension / Android: BigPictureStyle for image/video preview
- **Silent Notification**: Used for background data sync. Execute data updates without displaying to user

### §196. Notification Tap Handling

- **Deep link integration**: Navigate to appropriate screen via GoRouter on notification tap (see §56–§59)
- **Foreground notification**: Display as in-app banner (Snackbar/Dialog) via `firebase_messaging`'s `onMessage`
- **Notification history**: Implement notification list screen with read/unread management

---

## XLII. Authentication & App Check

### §197. Biometric Authentication

- **`local_auth` package**: Implement Face ID / Touch ID (iOS), fingerprint / face recognition (Android) through unified interface
- **Use cases**: Payment confirmation, sensitive data display, re-authentication. Do not use as substitute for initial login
- **Fallback**: Fallback to PIN / password entry on biometric authentication failure
- **Keychain / Keystore integration**: Design to retrieve tokens from Keychain / Android Keystore after successful biometric authentication

### §198. Firebase App Check

- **Device attestation**: Verify request origin legitimacy with App Attestation (iOS) / Play Integrity (Android)
- **Backend protection**: Protect Firebase / custom backend API endpoints with App Check tokens
- **Debug Token**: Use Debug Provider in development environments; inject debug tokens via environment variables in CI
- **Fallback strategy**: Implement retry logic and user notification on App Check failure

### §199. Runtime Permission Management

- **`permission_handler` package**: Unified management of camera, location, photos, microphone, etc. permissions
- **Context-dependent request**: Request permission at the point the feature is needed. Bulk requests at launch prohibited
- **Permanently Denied handling**: Must implement settings navigation UI (`openAppSettings()`)
- **Permission state monitoring**: Re-check permission state on return from settings via `AppLifecycleListener`

---

## XLIII. App Lifecycle & Background Processing

### §200. App Lifecycle Management

- **`AppLifecycleListener` (Flutter 3.29+)**: Replaces legacy `WidgetsBindingObserver`. Cleanly separates `onResume`, `onInactive`, `onPause`, `onDetach`, `onHide`, `onShow`
- **State restoration**: Verify data freshness on return from background (`onResume` API re-fetch)
- **Memory warning**: Implement cache clear / memory release on `onMemoryPressure`
- **Auth state verification**: Token expiration check after extended background period

### §201. Background Processing

- **`workmanager` package**: Flutter wrapper for Android WorkManager / iOS BGTaskScheduler
- **Use cases**: Periodic data sync, log upload, cache cleanup
- **Constraints**: iOS BGTaskScheduler minimum 15min interval. Execution timing controlled by OS
- **Headless Dart Callback**: Define background tasks in `callbackDispatcher`. No UI context required
- **Battery optimization**: Design considering Doze mode (Android) / Background App Refresh (iOS) constraints

### §202. Foreground Services

- **`flutter_foreground_task` package**: Long-running tasks like music playback, navigation, location tracking
- **Notification required (Android)**: Foreground services require persistent notification. Explicitly inform user of execution
- **Battery consumption**: Monitor foreground service battery consumption; immediately stop when unnecessary

---

## XLIV. In-App Purchase & App Updates

### §203. In-App Purchase Architecture

- **`in_app_purchase` package**: Official Flutter plugin for StoreKit 2 (iOS) / Google Play Billing Library 7+ (Android)
- **Server-side verification required**: Receipt / Purchase Token verification must be performed **server-side only**. Client-side-only verification completely prohibited
- **Subscription management**: Receive Real-Time Developer Notifications (Google) / App Store Server Notifications V2 (Apple) server-side to sync status
- **Restore functionality**: Must implement `restorePurchases()` in settings screen. App Store Review Guideline requirement
- **Sandbox testing**: Test in-development purchases with StoreKit Configuration File (iOS) / Google Play Console test tracks

### §204. Force Update & Version Check

- **Firebase Remote Config**: Manage minimum version numbers via Remote Config
- **Launch-time check**: Compare current version with Remote Config value at app launch
- **Force update**: Force all users to navigate to store for critical bug/security fixes
- **Optional update**: Recommend updates via BottomSheet for non-breaking changes (skippable)
- **Store navigation**: Navigate directly to store page via `url_launcher`. Support both iOS App Store and Google Play Store

### §205. App Review Promotion

- **`in_app_review` package**: Display native in-app review dialog (Apple / Google standard UI)
- **Timing strategy**: Request review immediately after positive user experiences (task completion, goal achievement, etc.)
- **Frequency limit**: Maximum 3 times within 365 days per user. iOS API auto-manages display limits; Android requires manual control
- **Custom prompt prohibited**: App Store Guidelines prohibit displaying custom review solicitation dialogs before the store review dialog

---

# Part S: Advanced Mobile Infrastructure Extensions

## XLV. Dart FFI & Native Interop Deep Dive `[Flutter-Specific]`

### §206. FFI Basics — `dart:ffi` Rules

- **`dart:ffi`**: Direct Dart→C/C++ function calls. Lower latency than Platform Channels
- **Use cases**: Image processing, cryptographic operations, existing C/C++ library integration
- **BindingGen**: Auto-generate Dart bindings from C/C++ headers with `ffigen` package
- **Memory safety**: Manual `Pointer<T>` management required. Always call `calloc.free()` to prevent memory leaks

### §207. JNI — `package:jni` (Android)

- **`package:jni`**: Direct access to Java/Kotlin APIs from Dart
- **`jnigen`**: Auto-generate Dart bindings from Java .class files
- **Use cases**: Low-level access to Android-specific SDKs (CameraX, MediaCodec, etc.)
- **Thread safety**: Execute JNI calls off the main thread. Recommend combining with `Isolate.run()`

### §208. Swift/Objective-C Interop (iOS)

- **`package:ffigen`**: Supports binding generation from Objective-C headers
- **Swift Interop**: Connect to Dart FFI via Swift→Objective-C bridging headers
- **Framework integration**: Distribute as XCFramework. Manage with `CocoaPods`/`Swift Package Manager`

### §209. Native Build Integration

- **CMake (Android NDK)**: Configure native builds in `android/app/src/main/jni/CMakeLists.txt`
- **Podspec (iOS)**: Specify C/C++ source files and compile flags in `ios/*.podspec`
- **Cross-Compilation**: Support multiple architectures (arm64, x86_64, etc.) with NDK/Xcode Toolchain
- **CI Integration**: Include native dependency builds in CI pipeline, guaranteeing build success for all architectures

### §210. FFI Safety Guidelines

- **Null Pointer Defense**: Mandatory null pointer checks before FFI calls
- **Exception Bridge**: Always implement wrappers to convert C/C++ exceptions to Dart exceptions
- **Test Strategy**: Combine FFI binding Unit Tests with native testing tools (gtest, etc.)
- **Documentation**: Write Dartdoc for all FFI bindings, explicitly documenting memory management responsibilities

---

## XLVI. Payment Integration Architecture `[Universal+Flutter]`

### §211. Payment Service Selection Criteria

- **PCI DSS Compliance**: Use PCI DSS-compliant SDKs (Stripe, Square, etc.) for credit card payments
- **Tokenization**: Tokenize card information client-side. Holding raw card numbers is prohibited
- **Server-Side Payment Processing**: PaymentIntent creation and confirmation must **always execute server-side**
- **Client Role**: UI display and user input collection only. Placing payment logic is prohibited

### §212. Stripe Integration Pattern

- **`flutter_stripe` package**: Official Flutter bindings for Stripe SDK
- **PaymentSheet**: Stripe-provided UI. Use PCI DSS-compliant card input forms
- **3D Secure (3DS)**: Set `automatic_payment_methods` on PaymentIntent server-side. 3DS authentication auto-handled
- **Apple Pay / Google Pay**: Integrate native payment UI via `flutter_stripe`

### §213. RevenueCat Integration Pattern

- **Use case**: Subscription management SaaS. Abstracts StoreKit 2/Google Play Billing Library
- **Entitlement-Based Design**: App logic determines access by "Entitlements" (`isPremium`, `hasFeatureX`). Direct Product ID dependency prohibited
- **Server-Side Webhooks**: Sync server-side entitlement state via RevenueCat webhooks
- **`purchases_flutter` package**: RevenueCat official Flutter SDK

### §214. Payment Flow UX Design

- **Status Mapping**: Manage payment flow with type-safe `PaymentStatus` (`idle`→`processing`→`success`/`failure`)
- **Loading Display**: Block UI during payment processing to prevent double charges
- **Error Recovery**: Always implement retry/alternative payment method guidance on payment failure
- **Receipt Confirmation UI**: Display receipt information (amount, date, Transaction ID) after payment completion

### §215. Tax & Currency Management

- **Currency Display**: Use `intl` package's `NumberFormat.currency()` for region-aware currency formatting
- **Smallest Unit Calculation**: Stripe etc. calculate in smallest currency units (cents). Format conversion only for display
- **Tax Calculation**: Execute tax calculations server-side. Manage regional tax rates via Remote Config

### §216. Payment Compliance

- **App Store Billing Rules**: IAP required for digital content/services (per §203). Physical goods/external services may use external payment
- **PSD2 SCA**: Strong Customer Authentication (3DS2) legally required in EU
- **Receipt Logging**: Record all payment transactions in server-side audit logs

---

## XLVII. Local Notifications & Scheduling `[Universal+Flutter]`

### §217. Local Notification Foundation

- **`flutter_local_notifications`**: Unified API for iOS/Android local notifications
- **Use cases**: Reminders, timers, offline completion notifications. Operates without push notifications
- **Channel Separation (Android)**: Separate `AndroidNotificationChannel` by use case. Respect user settings
- **Permission Management**: iOS 10+ requires `UNUserNotificationCenter` permission. Android 13+ requires `POST_NOTIFICATIONS` permission

### §218. Notification Scheduling

- **Date/Time Specification**: Use `zonedSchedule()` for timezone-aware scheduled notifications
- **Recurring Notifications**: Use `periodicallyShow()` for daily/weekly reminders
- **Exact Scheduling (Android 12+)**: `SCHEDULE_EXACT_ALARM` permission. Requires user permission
- **Cancellation Strategy**: Immediately clear unnecessary notifications with `cancel(id)`/`cancelAll()`

### §219. Notification Actions & Deep Link Integration

- **Actionable Notifications**: Add inline response buttons with `AndroidNotificationAction`/`DarwinNotificationAction`
- **Notification Tap → Routing**: Include `route` parameter in notification payload, navigate to target screen via GoRouter
- **Foreground Display**: Handle foreground notification taps with `onDidReceiveNotificationResponse`

### §220. Notification Testing & Verification

- **Unit Test**: Verify notification calls with mocked `FlutterLocalNotificationsPlugin`
- **Integration Test**: Confirm scheduled notification firing timing on real devices/emulators
- **Timezone Test**: Verify DST (Daylight Saving Time) transition behavior with `timezone` package

---

## XLVIII. Widget Testing Deep Dive `[Flutter-Specific]`

### §221. Widget Test Design Principles

- **User Behavior Testing**: Prefer `find.bySemanticsLabel()` over `find.text()`/`find.byType()`. Also correct from an a11y perspective
- **Arrange-Act-Assert**: Strictly follow `pumpWidget()`→`tap()`→`expect()` 3-phase structure
- **Test Size Specification**: Fix screen size with `binding.setSurfaceSize()` for responsive testing

### §222. Golden Test Strategy

- **`matchesGoldenFile()`**: Pixel-level screen snapshot testing
- **`alchemist` Framework**: Absorb font rendering differences in CI environments. Minimize Golden diffs across platforms
- **Update Flow**: Update baselines with `flutter test --update-goldens`. Always visually review Golden diffs during PR review
- **Naming Convention**: Unify as `test/goldens/{feature}_{variant}.png`

### §223. Interaction Testing

- **Scroll Testing**: Verify scroll behavior with `drag()`/`fling()`
- **Gesture Testing**: Simulate gesture operations with `longPress()`/`dragFrom()`
- **Text Input Testing**: Verify validation results with `enterText()` form input → `find.text()`
- **Animation Testing**: Wait for animation completion with `pumpAndSettle()`. Test instant completion with duration 0

### §224. Test Coverage Strategy

- **Required Widget Test Targets**: All screen Widgets, all form Widgets, all navigation flows
- **Coverage Criteria**: Presentation layer 80%+. Domain/Data layers 90%+
- **Test Matrix**: Screen size (phone/tablet) × Theme (light/dark) × Locale (ja/en)

### §225. Visual Regression CI

- **CI Golden Test Execution**: Isolate Golden Tests with `flutter test --tags=golden`
- **Image Comparison Tool**: Fail on pixel diff > 0.5%. Control minor differences with `tolerance` parameter
- **Report Output**: Output diff images as CI Artifacts on failure for immediate review

---

## XLIX. Error Boundary & Recovery UX `[Universal]`

### §226. Error Classification System

- **Fatal Error**: App cannot continue (DB corruption, authentication fraud, etc.). Display forced restart flow
- **Recoverable Error**: Recoverable via retry/alternative path (temporary network failure, API 500, etc.)
- **Expected Error**: Expected business logic errors (validation failure, insufficient permissions, etc.)
- **Silent Error**: No user impact. Log recording only (analytics submission failure, etc.)

### §227. Error Boundary Widget

- **`ErrorBoundary` Widget**: Wrap entire app to catch unhandled exceptions and display `ErrorScreen`
- **`FlutterError.onError`**: Forward Flutter framework errors to Crashlytics/Sentry
- **`PlatformDispatcher.instance.onError`**: Catch Dart runtime unhandled exceptions
- **Zone Guard**: Catch all async code exceptions with `runZonedGuarded()`

### §228. Recovery UX Patterns

- **Retry Button**: Always place a "Retry" button on all error screens
- **Offline State Display**: Constantly show `OfflineBanner` at top of screen when network disconnected
- **Stale Data Display**: Add "Last updated: XX minutes ago" label when displaying cached data
- **Graceful Degradation**: Display alternative UI when primary features unavailable (image load failure → placeholder, etc.)

### §229. Error Message Design

- **User-Friendly**: Prohibit direct display of technical error messages
- **Action-Oriented**: Include "next action" in error messages ("Check your connection and retry", etc.)
- **Multilingual Support**: Manage error messages with i18n keys. Hardcoding prohibited
- **Error Codes**: Record internal error codes (`E-AUTH-001`, etc.) in logs only. Hide from users

### §230. Post-Crash Recovery

- **State Restoration**: Restore form input and scroll position with `RestorationMixin`
- **Restart Detection**: Record crash flag in SharedPreferences. Detect on startup and execute recovery flow
- **Data Integrity**: Check DB integrity after crash. Auto-repair inconsistent data or notify user

---

## L. Connectivity & Network Resilience `[Universal]`

### §231. Network State Management

- **`connectivity_plus` package**: Detect WiFi/mobile/none connection state
- **`InternetConnectionChecker`**: Verify actual internet reachability (DNS resolution-based)
- **Riverpod Integration**: Reactively manage app-wide connection state with `connectivityProvider`
- **UI Reflection**: Display red `OfflineBanner` at top of screen via `MaterialBanner` when offline

### §232. Offline Queue

- **Operation Queue**: Queue user operations in local DB during offline
- **Reconnection Sync**: Sequentially execute queue on connection recovery. Implement conflict resolution logic
- **Idempotency Guarantee**: Prevent duplicate execution of queued operations with `idempotency_key`
- **Queue Visualization**: Display unsynced operation count as UI badge

### §233. Retry Strategy

- **Exponential Backoff**: Initial 1s → 2s → 4s → … max 60s backoff
- **Jitter**: Add random jitter to backoff to prevent server thundering herd
- **Max Retry Count**: Maximum 5 retries for API calls. Notify user on exceeded
- **Circuit Breaker**: Circuit Open after 3 consecutive failures. Half-Open retry after 30 seconds

### §234. Bandwidth Adaptation Strategy

- **Dynamic Quality Adjustment**: Auto-switch image resolution based on connection quality (WiFi: high-res, 3G: low-res)
- **Prefetch Control**: Execute prefetch only on WiFi. Data-saving mode on mobile data
- **Compression**: Mandate gzip/br compression for API responses. Set `Accept-Encoding` in Dio interceptor

### §235. VPN & Proxy Detection

- **Security Requirement**: Finance/healthcare apps detect VPN/proxy connections and require additional authentication
- **Certificate Pinning Integration**: Proper error handling for Certificate Pinning failures in VPN environments

---

## LI. In-App Navigation UX Design `[Universal+Flutter]`

### §236. Bottom Navigation Design

- **`NavigationBar` (Material 3)**: Access 3–5 primary features. Migrate to Drawer for 6+
- **State Preservation**: Preserve each tab's state. Design that doesn't rebuild on tab switch
- **`StatefulShellRoute` (GoRouter)**: Manage independent navigation stacks per tab with nested Navigators
- **Badges**: Display unread counts with Badge Widget. Reactively update from Riverpod Provider

### §237. Modal & BottomSheet Design

- **`showModalBottomSheet`**: Display supplementary actions and choices
- **`DraggableScrollableSheet`**: Sheet with height that varies based on content amount
- **Close Operations**: Always provide 3 methods: swipe down / outside tap / close button
- **Dialog vs BottomSheet**: Use Dialog for confirmation/warnings. Use BottomSheet for selection/filters

### §238. Drawer & Top-Level Navigation

- **`NavigationDrawer` (Material 3)**: Use when there are 5+ sections
- **Hamburger Menu**: Acceptable but place primary features in Bottom Navigation. Limit Drawer to settings/sub-features
- **Rail Navigation**: Auto-switch to `NavigationRail` on tablet/desktop

### §239. Page Transition Animations

- **Platform Compliance**: iOS uses leaf transition (right→left slide), Android uses upward fade
- **GoRouter Transitions**: Define custom transitions per route with `CustomTransitionPage`
- **Shared Element Transition**: Shared element animation for list→detail screen with `Hero` widget
- **Transition Duration**: 200–400ms range. 300ms recommended as default

### §240. Interstitial & Overlay

- **`OverlayPortal` (Flutter 3.32+)**: Standard API for floating UI (tooltips, dropdowns)
- **Latest Dropdown Pattern**: Render outside widget tree with `OverlayPortal`+`CompositedTransformFollower`
- **Background Scrim**: Darken background with semi-transparent scrim for modal overlays. Standardize close-on-tap behavior

---

## LII. Configuration Management & Feature Flags `[Universal]`

### §241. Feature Flag Foundation

- **Firebase Remote Config**: Standard Feature Flag solution
- **Flag Naming Convention**: `feature_{feature_name}_{stage}` — `feature_new_checkout_enabled`
- **Default Values**: Set local default values for all flags. Fallback when Remote Config unreachable
- **Cache Strategy**: Set `minimumFetchInterval` to 12 hours for production, 10 minutes for development

### §242. Staged Rollout

- **User Segments**: Staged deployment by user ID suffix/country/version via Remote Config conditions
- **Canary Release**: 1% → 5% → 25% → 100% stages. Monitor crash rate and performance at each stage
- **Kill Switch**: Implement instantly disableable kill switches for all Feature Flags
- **A/B Test Integration**: Measure Feature Flag and conversion correlation with Firebase A/B Testing

### §243. Design Patterns

- **Feature Flag Provider**: Type-safe access from Riverpod with `featureFlagProvider(flagName)`
- **Code Separation**: Limit Feature Flag branching to UseCase/Repository layer. Minimize `if` branching in Widgets
- **Test Exclusion**: Cover both ON/OFF states of Feature Flags in Unit Tests

### §244. Technical Debt Management

- **Expiration**: Set expiration (max 90 days) for all Feature Flags. Force cleanup of expired flags
- **Lint Warning**: Warn about 90+ day Feature Flags with custom Analyzer plugin
- **Cleanup PR**: Create flag deletion PR within 7 days after Feature Flag full rollout

### §245. Emergency Control

- **Global Kill Switch**: Master flag to instantly disable specific app-wide features
- **Maintenance Mode**: Flag to stop all features and display maintenance screen
- **Forced Update Integration**: Coordinate with Remote Config version check (§204)

---

## LIII. Data Privacy & Consent Management `[Universal]`

### §246. Consent Management Platform (CMP)

- **Use case**: GDPR/CCPA/Global Privacy Laws and regional privacy law compliance
- **Standard SDK**: Adopt TCF 2.0 (IAB Transparency & Consent Framework) compliant CMP SDK
- **Initial Consent**: Display consent management UI on first app launch. Data collection without consent is completely prohibited
- **Consent State Management**: Manage `ConsentStatus` (`granted`/`denied`/`notDetermined`) with Riverpod Provider

### §247. Data Classification & Permission Mapping

- **PII Classification**: Tier 1 (direct identification: name, email), Tier 2 (indirect identification: device ID, IP), Tier 3 (anonymous: aggregated data)
- **Purpose-Based Consent**: Obtain independent consent for each purpose: "Analytics", "Marketing", "Personalization"
- **Consent → Feature Mapping**: Control Analytics/Crashlytics/ad SDK initialization based on consent state

### §248. Data Subject Rights

- **Right of Access**: UI for users to request full data export (in settings screen)
- **Right to Erasure**: Execute deletion of all local data + server data on account deletion
- **Portability**: Data export functionality in JSON format
- **Response Deadline**: Auto-process GDPR requests within 30 days

### §249. Apple App Tracking Transparency (ATT)

- **iOS 14.5+**: Must call `requestTrackingAuthorization()` before obtaining IDFA
- **`app_tracking_transparency` package**: ATT dialog display and status management
- **Denied Handling**: Do not use `IDFA` when tracking denied. Fallback to contextual advertising
- **App Store Review**: Implement pre-prompt explanation for ATT to improve approval rates

### §250. Privacy Testing

- **Privacy Manifest Verification**: Verify `PrivacyInfo.xcprivacy` completeness with Xcode 15 Privacy Report
- **Network Audit**: Confirm all communication destinations with Charles Proxy etc. Verify no undeclared data destinations
- **Data Deletion Test**: Verify local DB/Keychain/SharedPreferences cleanup after account deletion
- **Consent State Test**: Verify feature restrictions work correctly for all consent ON/OFF combinations

---

## LIV. Mobile DevOps & DX `[Universal+Flutter]`

### §251. Development Environment Standardization

- **FVM (Flutter Version Management)**: Per-project Flutter version pinning
- **`.fvmrc`**: Specify Flutter version at project root. Unify all developers with `fvm use 3.41.0`
- **VSCode Settings**: Auto-configure FVM SDK path in `.vscode/settings.json`
- **DevContainer**: Docker + FVM + Android SDK DevContainer definition for environment setup within 5 minutes

### §252. Code Generation Pipeline

- **`build_runner` Optimization**: Target filtering with `build.yaml`. Exclude unnecessary generation
- **Generated File Management**: `.g.dart`/`.freezed.dart` excluded in `.gitignore` (CI generation recommended) or committed (team decision)
- **Watch Mode**: Auto-regenerate during development with `dart run build_runner watch --delete-conflicting-outputs`
- **CI Integration**: Execute `dart run build_runner build --delete-conflicting-outputs` as first CI step

### §253. Hot Reload & Development Efficiency

- **Maximize Hot Reload**: Improve Hot Reload success rate by enforcing StatelessWidget + `const` constructors
- **Avoid Hot Restart**: Properly manage state initialization logic with `ref.onDispose()` to reduce Hot Restart necessity
- **Debug Extensions**: Enrich debug output with `toString()` overrides

### §254. Development Toolchain

- **Flutter DevTools**: Comprehensive debugging with Performance, Memory, Network, Widget tabs
- **Dart DevTools**: Detailed analysis with CPU Profiler, Heap Snapshot, Logging View
- **Custom DevTools Extensions**: Add project-specific debug panels with `devtools_extensions`
- **Very Good CLI**: Rapidly generate project templates and package scaffolds with `very_good_cli`

### §255. PR Quality Gates

- **Automated Review**: Execute `dart analyze` + `dart format --set-exit-if-changed` on PR trigger
- **Test Required**: Unit + Widget Test (minimum 80% coverage) pass required
- **File Size Limit**: New Dart files must be 300 lines or less. Describe split reasoning in PR description when exceeded
- **Review Scope**: PRs exceeding +500 lines should be split in principle

### §256. Documentation & Knowledge Base

- **ADR (Architecture Decision Record)**: Record important technical decisions in `docs/adr/`
- **Widget Catalog**: Catalog all custom Widgets with Widgetbook/Storybook for Flutter
- **API Contract**: Manage backend API type definitions with `openapi.yaml`. Auto-generate Dart client with `openapi_generator`
- **Onboarding**: Document setup procedures, coding conventions, and PR flow in `CONTRIBUTING.md`

---

## LV. Language-Specific Addendum & Extended Anti-Patterns `[Flutter-Specific]`

### §257. Dart 3.7+ Latest Feature Utilization

- **Wildcard Variables (`_`)**: Explicitly mark unused variables with `_`. Clarify code intent
- **Strict Bound Checks**: Stricter upper/lower bound checks for generics
- **Extension Types**: Use as zero-cost compile-time abstractions wrapping primitive types
- **Enhanced Enums**: Add fields and methods to `enum` for type-safe value objects

### §258. Package Dependency Management

- **Monthly `dart pub outdated` Execution**: Monthly check of dependency package update status
- **Resolvable Version Specification**: Lock major version with `^` (caret syntax). Auto-update patches and minors
- **Dependency Tree Analysis**: Visualize dependency tree with `dart pub deps --style=compact`. Eliminate unnecessary transitive dependencies
- **Security Advisories**: Respond to `dart pub` vulnerability warnings within 48 hours

### §259. Memory Leak Prevention Patterns

- **StreamSubscription**: Always `cancel()` `StreamSubscription` obtained from `listen()`
- **Timer**: `cancel()` `Timer.periodic()` at `dispose()` time
- **AnimationController**: Always release at `dispose()` when using `SingleTickerProviderStateMixin`
- **Riverpod Integration**: Centralize all resource cleanup with `ref.onDispose()`
- **DevTools Memory Tab**: Periodically detect leaks with HeapSnapshot

### §260. Advanced Async Programming

- **`Stream.asyncMap`**: Async transformation of stream events
- **`StreamQueue`**: Sequential value retrieval from streams (useful for testing)
- **Completer Pattern**: Convert callback-based APIs to Futures
- **`runZonedGuarded`**: Set exception boundaries for async code
- **Rate Limiting**: Control UI event flow with `Stream.throttle()`/`Stream.debounce()`

### §261. Type Safety Pattern Collection

- **Union Types**: Define algebraic data types with `sealed class`. Guarantee exhaustive pattern matching
- **Type-Safe ID**: Prevent string ID type confusion with `extension type UserId(String value)`
- **Result Type**: Define `Success<T>`/`Failure` with `sealed class Result<T>`. Error handling without relying on exceptions
- **Branded Types**: Define domain-specific types like `Email`, `Password` with Extension Types

### §262. Code Quality Metrics

- **Cyclomatic Complexity**: Target ≤10 per function. Refactoring required when exceeded
- **Dependency Count**: ≤7 dependencies per class. Sign for responsibility splitting when exceeded
- **File Line Count**: Strictly enforce 300 lines or less. Separate mixed Widget + Logic
- **Custom Lint**: Define project-specific lint rules with `custom_lint` package

### §263. Flutter-Specific Debugging Techniques

- **`debugPaintSizeEnabled`**: Size visualization for layout debugging
- **`debugPaintBaselinesEnabled`**: Text baseline visualization
- **`debugRepaintRainbowEnabled`**: Rainbow display of repaint regions
- **`Timeline.startSync()`**: Record custom performance events
- **`debugPrint()`**: Safe print wrapper that automatically throttles long output

### §264. Advanced Responsive Design

- **Breakpoint Constants**: Define `compact` (< 600dp) / `medium` (600-839dp) / `expanded` (840dp+) in `Breakpoints` class
- **`AdaptiveScaffold`**: Material 3 adaptive layout Widget
- **Conditional Widgets**: Switch Widgets based on breakpoints with `LayoutBuilder`
- **Test Coverage**: Conduct Golden Tests for all breakpoints

### §265. CI Automation Extensions

- **Merge Queue**: Automate conflict detection pre-merge with GitHub Merge Queue
- **Auto Versioning**: Auto-increment SemVer versions with `cider`/`version` packages
- **Changelog Auto-Generation**: Auto-generate changelog from Conventional Commits
- **Dependency Update Automation**: Auto-create monthly dependency update PRs with Dependabot/Renovate

---

## Appendix A: Reverse Index

### Keyword → Section

| Keyword | Sections |
|---|---|
| Supreme Directive, Philosophy, Quality Gates | §1–§4 |
| Package Stack, analysis_options | §5–§8 |
| Clean Architecture, Layers, DI, SSOT | §9–§14 |
| Dart 3.7, Wildcard, Formatter, Type Annotations | §15–§21 |
| sealed class, Pattern Matching, Enum, Null Safety | §22–§26 |
| async/await, Isolate, Stream, Cancellation | §27–§31 |
| build_runner, Macros Cancellation, Augmentations | §32–§35 |
| Riverpod, Notifier, Provider, watch, select, Freezed | §36–§41 |
| Provider Dependencies, Scope, AsyncValue | §42–§46 |
| Offline Persistence, Mutations, State Restoration | §47–§50 |
| GoRouter, Routing, Auth Guard, Nesting | §51–§55 |
| Deep Links, Universal Links, App Links | §56–§59 |
| UseCase, Entity, DTO, DataSource | §60–§64 |
| Repository, Cache, Pagination, Sync | §65–§68 |
| DI, Environment Config, Flavor | §69–§71 |
| 60fps, 120fps, const, Rebuild, RepaintBoundary | §72–§77 |
| Impeller, Skia, Shader | §78–§80 |
| Widget Splitting, Sliver, key, Layout Optimization | §81–§85 |
| Startup Speed, App Size, Tree Shaking, Obfuscation | §86–§89 |
| Memory Leak, Heap Snapshot, Profiling | §90–§93 |
| Offline-First, Drift, SQLCipher, Sync | §94–§98 |
| Dio, API Key, Bearer Token, VIP Lane, Retry | §99–§104 |
| Image Cache, WebP, SVG, Video | §105–§108 |
| WebSocket, SSE, Supabase Realtime | §109–§111 |
| Cupertino, Material, Pigeon, FFI, Haptics | §112–§116 |
| Responsive, Breakpoints, AdaptiveScaffold | §117–§121 |
| Material 3, Design Token, Theme, Dark Mode | §122–§126 |
| Animation, Lottie, Rive, Transitions | §127–§130 |
| Forms, Validation, IME, Search | §131–§134 |
| Semantics, Tap Target, Contrast, VoiceOver | §135–§141 |
| OWASP, Keychain, Certificate Pinning, MobSF | §142–§146 |
| RASP, freeRASP, Root Detection, Tampering | §147–§149 |
| ML Kit, TFLite, Gemini, AI Agent | §150–§154 |
| Unit Test, Golden Test, Maestro, E2E, Coverage | §155–§162 |
| CI/CD, Fastlane, Shorebird, OTA, Flavor | §163–§170 |
| Crashlytics, Sentry, Analytics, Logging, Remote Config | §171–§176 |
| Flutter Web, Desktop, SBOM, Wearable, Melos | §177–§182 |
| i18n, Privacy, App Store, Green Engineering | §183–§188 |
| FinOps, Maturity, Anti-Patterns Top 50 | §189–§191 |
| Roadmap, AI Development, Future Outlook | §192–§193 |
| FCM, APNs, Push Notification, Notification Channel | §194–§196 |
| Biometric Auth, App Check, Permission Management | §197–§199 |
| AppLifecycleListener, WorkManager, Foreground Service | §200–§202 |
| IAP, Force Update, App Review | §203–§205 |
| Dart FFI, JNI, Swift Interop, Native Build | §206–§210 |
| Stripe, RevenueCat, Payment, PCI DSS, Tax | §211–§216 |
| flutter_local_notifications, Scheduling, Notification Actions | §217–§220 |
| Widget Test, Golden Test, alchemist, Visual Regression | §221–§225 |
| Error Boundary, Recovery UX, Post-Crash Recovery | §226–§230 |
| Connectivity, Offline Queue, Retry, Circuit Breaker | §231–§235 |
| Bottom Navigation, BottomSheet, Drawer, Page Transition, Overlay | §236–§240 |
| Feature Flag, Rollout, Kill Switch, Technical Debt | §241–§245 |
| CMP, GDPR, ATT, Data Subject Rights, Privacy | §246–§250 |
| FVM, build_runner, DevTools, PR Quality Gates, ADR | §251–§256 |
| Extension Type, Memory Leak, Type Safety, Debug, Responsive | §257–§265 |

---

## Appendix B: Cross-References

### Section → Related Rules

| Part | Related Universal Rules |
|---|---|
| I–III Philosophy & Architecture | `000_core_mindset`, `300_engineering_standards` |
| IV–VII Dart Language | `300_engineering_standards` |
| VIII–X State Management | `300_engineering_standards` |
| XI–XII Navigation | `200_design_ux` |
| XIII–XV Architecture Patterns | `300_engineering_standards`, `343_native_platforms` |
| XVI–XX Performance | `502_site_reliability`, `300_engineering_standards` |
| XXI–XXIV Data & Network | `301_api_integration`, `320_supabase_architecture` |
| XXV–XXVI Platform | `343_native_platforms`, `200_design_ux` |
| XXVII–XXVIII Design & Animation | `200_design_ux` |
| XXIX Forms | `200_design_ux`, `340_web_frontend` |
| XXX Accessibility | `200_design_ux`, `343_native_platforms` |
| XXXI–XXXII Security | `600_security_privacy`, `301_api_integration` |
| XXXIII AI/ML | `400_ai_engineering` |
| XXXIV Testing | `700_qa_testing` |
| XXXV CI/CD | `502_site_reliability`, `300_engineering_standards` |
| XXXVI Observability | `401_data_analytics`, `502_site_reliability` |
| XXXVII Multi-Platform | `602_oss_compliance`, `343_native_platforms` |
| XXXVIII Governance | `601_data_governance`, `103_appstore_compliance` |
| XXXIX–XL Maturity & Future | `720_cloud_finops`, `801_governance` |
| XLI–XLII Push Notification & Auth | `600_security_privacy`, `343_native_platforms` |
| XLIII Background & Lifecycle | `502_site_reliability`, `343_native_platforms` |
| XLIV IAP & App Updates | `103_appstore_compliance`, `720_cloud_finops` |
| XLV FFI & Native Interop | `343_native_platforms`, `300_engineering_standards` |
| XLVI Payment Integration | `600_security_privacy`, `103_appstore_compliance` |
| XLVII Local Notifications | `343_native_platforms`, `200_design_ux` |
| XLVIII Widget Testing | `700_qa_testing`, `300_engineering_standards` |
| XLIX Error Boundary | `200_design_ux`, `502_site_reliability` |
| L Connectivity | `502_site_reliability`, `301_api_integration` |
| LI Navigation UX | `200_design_ux`, `343_native_platforms` |
| LII Feature Flags | `502_site_reliability`, `401_data_analytics` |
| LIII Data Privacy | `600_security_privacy`, `601_data_governance` |
| LIV DevOps & DX | `502_site_reliability`, `300_engineering_standards` |
| LV Language-Specific Addendum | `300_engineering_standards`, `700_qa_testing` |

