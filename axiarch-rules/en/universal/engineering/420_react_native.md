# 420. React Native Engineering

> [!CAUTION]
> This file is a Universal Rule and is immutable. Editing is prohibited unless an explicit constitutional amendment is requested.
> Revised: 2026-07-23 | Scope: current stable React Native, New Architecture, Hermes, iOS, and Android

> [!IMPORTANT]
> React Native is not a programming language. It is a framework that joins TypeScript or JavaScript, Swift, Kotlin, and sometimes C++ into one mobile product. Optimize for quality on both operating systems, safe cross-language boundaries, upgradeability, and team ownership rather than shared-code percentage.
> 17 sections, Rules 420.1–420.52.

---

## Table of Contents

| Section | Topic |
|:--|:--|
| §1 | Scope and source-of-truth boundaries |
| §2 | Adoption decision and delivery profiles |
| §3 | Versions, toolchains, and reproducibility |
| §4 | Repository and architecture |
| §5 | TypeScript, JavaScript, and React layer |
| §6 | New Architecture, Hermes, and Codegen |
| §7 | Native modules and cross-language boundaries |
| §8 | State, data, offline, and networking |
| §9 | Platform fidelity, navigation, and accessibility |
| §10 | Performance and resource budgets |
| §11 | Security and privacy |
| §12 | Testing strategy |
| §13 | CI, release, and OTA updates |
| §14 | Dependencies and software supply chain |
| §15 | Observability and incident response |
| §16 | Scalable team governance |
| §17 | Exceptions, maturity, and prohibitions |

---

## §1. Scope and Source-of-Truth Boundaries

- Rule 420.1: This file is the framework-specific source of truth for React Native apps, brownfield integrations, React Native libraries, and native modules.
- Rule 420.2: Inherit TypeScript and JavaScript language quality from `320_programming_language_governance.md` §5 and native Swift and Kotlin implementation rules from `410_native_platforms.md`. Do not automatically apply Web DOM-specific rules to React Native.
- Rule 420.3: `security/000_security_privacy.md` takes precedence for security, `quality/000_qa_testing.md` for test layers, and `product/700_appstore_compliance.md` for store review.
- Rule 420.4: Do not interpret one codebase as one behavior. Independently assure UX, permissions, lifecycle, background execution, and release artifacts on iOS and Android.

### 1.1 Universal Applicability Contract

- This file normatively requires outcomes: assurance on both operating systems, safe cross-language boundaries, reproducible builds, release traceability, operational continuity, and exit feasibility. Vendors, hosted services, repository layouts, VCS features, team names, headcount, and fixed cadences are reference implementations or Blueprint parameters.
- Expo, CocoaPods, SPM, Gradle, Xcode, Metro, and similar names are ecosystem-specific subjects needed for framework or platform compatibility. They do not require an unrelated project to adopt those tools. When a specific tool is required, record the official-support or artifact-compatibility reason.
- Individuals and small teams may combine ownership roles. Prefer independent review at high-assurance boundaries; when separation is impossible, record risk acceptance and add an independent release control. A large organization may separate the same responsibilities into specialist functions.

## §2. Adoption Decision and Delivery Profiles

The adoption ADR selects one profile and records change conditions and an exit plan.

| Profile | Use | Required decision |
|:--|:--|:--|
| Framework-managed | Default candidate for new apps | Framework such as Expo, native customization, build and update service, exit feasibility |
| Bare | Custom native build, unusual SDK, deep OS integration | Ability to operate Xcode, Gradle, CocoaPods or SPM, Metro, and signing |
| Brownfield | Incremental integration into an existing Swift or Kotlin app | Screen boundary, navigation, lifecycle, binary size, rollback, native owner |
| Library | Module or component distributed to multiple apps | Support matrix, Codegen, example app, compatibility, deprecation |

- Rule 420.5: Following official guidance, framework-managed is the first candidate for a new app. Bare adoption records constraints that a framework cannot satisfy in an ADR.
- Rule 420.6: Do not adopt React Native as a way for Web engineers alone to build a native app. Include practical iOS, Android, store, security, and release capability in the plan.
- Rule 420.7: Start brownfield adoption with one screen or flow and define native versus React Native responsibility, navigation, data ownership, and rollback unit.
- Rule 420.8: Adoption KPIs include crash-free rate, ANR and hang, startup, frames, app size, build time, upgrade lead time, platform divergence, and Time-to-First-PR, not only shared-code percentage.

## §3. Versions, Toolchains, and Reproducibility

- Rule 420.9: Use a React Native minor inside the official support window, defaulting production apps and production libraries to the `STABLE` release level. Restrict non-stable channels such as `CANARY`, `EXPERIMENTAL`, nightlies, and release candidates to isolated evaluation with a recorded required feature, target cohort, compatibility, telemetry, rollback, and exit deadline; never infer production support from a channel name. An exception explicitly supported for production by the provider and appropriate to product risk requires risk acceptance and the full release gates. Baseline on current stable by default and finish upgrades before the deployed minor becomes unsupported.
- Rule 420.10: Machine-readably pin React Native, React, Node.js, package manager, Ruby, JDK, Gradle wrapper, Android SDK and NDK, Xcode, and CocoaPods or SPM, keeping local and CI aligned.
- Rule 420.11: An app or executable root commits the resolution evidence produced by each resolver it uses, such as a JavaScript package lock, `Gemfile.lock`, `Podfile.lock`, Gradle dependency lock, or `Package.resolved`, and uses frozen or locked installation or equivalent drift detection. A Gradle version catalog alone does not lock the resolved transitive graph, so complement it with lock state, dependency verification, a resolved-graph digest, or equivalent evidence. A published library does not constrain consumers with its internal lock; verify declared constraints and supported ranges through pinned CI test and release resolution, a support matrix, and a locked example app.
- Rule 420.12: Stage an upgrade according to the support window, change volume, and adopted framework. Move through minors incrementally when a framework such as an Expo SDK requires or recommends it. When migrating across multiple minors, do not omit intermediate release notes, template migrations, or removed APIs. In every case, review Upgrade Helper, the framework SDK matrix, and native dependency compatibility; include generated-template differences in the upgrade change and pass iOS and Android release builds.

Minimum compatibility record. `owner` may identify a person, role, team, or external maintenance contract:

```yaml
react_native:
  version: "<pinned>"
  profile: framework-managed
  new_architecture: true
  js_engine: hermes
  ios: { xcode: "<pinned>", deployment_target: "<declared>" }
  android: { jdk: "<pinned>", compile_sdk: "<declared>" }
  native_modules:
    - name: "<package>"
      new_architecture: verified
      owner: "<team>"
  next_review: "YYYY-MM-DD"
```

## §4. Repository and Architecture

- Rule 420.13: Separate domain logic, data access, presentation, platform adapters, and native modules. Do not place business logic or secret-bearing requests directly in screen components.
- Rule 420.14: Deliberately design the boundary between shared code and `.ios` or `.android` differences. Prohibit giant `Platform.OS` branches, duplicated conditional logic, and false unification of platform behavior.
- Rule 420.15: A monorepo represents the build graph across apps, shared packages, native packages, schemas, and toolchains so a shared change cannot bypass iOS or Android gates.

Non-normative ownership-boundary example. Separation and traceability of the stated responsibilities are required, not these directory names:

```text
apps/mobile/        React Native application and composition root
packages/domain/    platform-neutral business rules
packages/ui/        accessible design-system components
packages/contracts/ generated API and native-boundary contracts
modules/native-*/   Turbo Native Modules or Fabric components
ios/                Apple project, signing, capabilities, native integration
android/            Android project, signing, permissions, native integration
```

## §5. TypeScript, JavaScript, and React Layer

- Rule 420.16: Default new app code and Codegen specs to TypeScript `strict`, and runtime-validate external input, navigation parameters, storage data, and native return values.
- Rule 420.17: Components focus on rendering and interaction. Distinguish server state, domain state, and ephemeral UI state. Prohibit indiscriminate global-state aggregation and side effects during render.
- Rule 420.18: Metro configuration extends `@react-native/metro-config` or framework defaults, and CI produces a production bundle. Never assume a Web package that depends on the DOM, Node.js built-ins, or browser storage is native-compatible.

## §6. New Architecture, Hermes, and Codegen

- Rule 420.19: Require the New Architecture on React Native releases within the official support window. React Native 0.82 and later cannot run the Legacy Architecture, so do not create opt-out exceptions such as `newArchEnabled=false`. Migrate older releases on an isolated upgrade branch with regression tests on both operating systems. Continuing an unsupported legacy runtime in production is not a normal adoption profile; treat it as an emergency migration exception with explicit risk acceptance, an owner, compensating controls, and a removal deadline.
- Rule 420.20: Hermes is the default engine and uses the version bundled with React Native. Switching to JavaScriptCore or another engine requires a measured ADR covering startup, memory, bundle, debugging, and dependency compatibility.
- Rule 420.21: New native APIs use Turbo Native Modules or Fabric Native Components with typed Codegen specs. Prohibit new legacy Native Modules or Components and inventory existing use.
- Rule 420.22: The Codegen spec is the boundary source of truth. Pin generator version and input digest, prohibit manual edits to generated output, and verify clean generation and differences in CI.

## §7. Native Modules and Cross-Language Boundaries

- Rule 420.23: Assign accountability for JS, iOS, Android, and the public API to every native module. Roles may be combined, but review from one layer may not omit verification of every affected layer. Require independent review at high-assurance boundaries.
- Rule 420.24: Boundary contracts define nullability, numeric ranges, 64-bit integers, binary data, date and timezone, unknown enum values, error codes, cancellation, threads, and lifecycle.
- Rule 420.25: Treat values from JS and native returns as untrusted. Bound size, depth, allocation, timeout, and concurrency, and never leak an unhandled native exception or crash into JS.
- Rule 420.26: Do not run blocking I/O or heavy CPU work on the UI main thread or JavaScript thread. Async APIs define ownership, cancellation, backpressure, duplicate calls, and behavior during app backgrounding or termination.

## §8. State, Data, Offline, and Networking

- Rule 420.27: Define the SSOT for server state, durable local state, drafts, and ephemeral UI state. Do not indiscriminately persist an entire Redux or equivalent state tree.
- Rule 420.28: Offline mutations have idempotency keys, queue bounds, retry and backoff, conflict policy, schema migration, logout deletion, and corruption recovery.
- Rule 420.29: Requests define timeout, cancellation, connectivity recovery, single-flight auth refresh, rate limiting, and error mapping, and inventory policy differences between JS and native networking stacks.

## §9. Platform Fidelity, Navigation, and Accessibility

- Rule 420.30: Navigation and deep links use a route schema as source of truth and test cold start, warm start, background, unauthenticated, expired link, and unknown route on both operating systems.
- Rule 420.31: Respect iOS HIG and Android design and behavior. Verify permission prompts, back navigation, keyboard, safe areas, edge-to-edge, font scaling, and dark mode by platform.
- Rule 420.32: Include accessibility labels, roles, states, hints, focus order, touch targets, contrast, reduced motion, and dynamic text in component contracts, and make real-device VoiceOver and TalkBack flows a release gate.

## §10. Performance and Resource Budgets

- Rule 420.33: Measure performance in production-equivalent builds, not development mode, on representative low-, mid-, and high-tier devices.
- Rule 420.34: Set risk-based budgets and owners for startup, time-to-interactive, JS and UI frames, long tasks, memory, CPU, network, bundle and binary size, and battery, blocking change acceptance or release on regression beyond tolerance. The Blueprint derives numeric thresholds from target devices and user distribution.
- Rule 420.35: Profile large lists, images, animation, navigation, serialization, and native calls before optimizing. Do not add memoization, native migration, or caching by guesswork; retain before and after evidence.

## §11. Security and Privacy

- Rule 420.36: Do not place secrets in the JS bundle, source maps, app config, native resources, or build-time environment. Add server-side mediation when a public client needs a secret-bearing resource.
- Rule 420.37: Use unencrypted storage such as AsyncStorage only for non-sensitive data. Store tokens, credentials, cryptographic keys, and sensitive PII in Keychain- or Keystore-backed storage and design backup, device migration, logout, and account deletion.
- Rule 420.38: Never put tokens or PII in custom URL schemes. Prefer Universal Links and App Links, and use Authorization Code with PKCE, state, nonce, and exact redirect validation for OAuth.
- Rule 420.39: Include native modules, JSI, WebView, deep links, push payloads, clipboard, screenshots, local databases, and OTA channels in the threat model. Root or jailbreak detection is a signal, not a substitute for server-side authorization.

## §12. Testing Strategy

| Layer | Required assurance |
|:--|:--|
| Static | Format, lint, TypeScript, Codegen schema, Swift and Kotlin compiler |
| Unit | Domain, state transitions, serialization, errors, retries, migrations |
| Component | User-visible text, role, and interaction without implementation-detail coupling |
| Native contract | JS spec and Swift or Kotlin implementation, threads, errors, lifecycle, boundary values |
| Integration | Storage, network, navigation, permissions, push, deep links, offline |
| Device E2E | Release-equivalent iOS and Android builds on devices or a high-fidelity device farm |
| Non-functional | Accessibility, performance, security, upgrade, OTA rollback |

- Rule 420.40: Component tests in Node.js do not assure native platform code. Critical flows that cross a native module or OS API require integration or device tests on both operating systems.
- Rule 420.41: Prohibit unconditional retry of flaky tests. Quarantine has an owner, issue, and expiry, and critical release flows may not be quarantined.
- Rule 420.42: Base the device matrix on user distribution, OS support, CPU and memory, screen, locale, and accessibility services, including at least the minimum-supported and current OS.
- Rule 420.43: Upgrade tests include clean install, upgrade install, database migration, auth session, deep link, push, background behavior, offline queue, and native-module compatibility.

## §13. CI, Release, and OTA Updates

- Rule 420.44: The change-acceptance capability inventory includes frozen JS install, format, lint, type, tests, Codegen differences, Android release build and tests, iOS release build and tests, SCA, and SBOM, selecting required gates from change impact and artifacts. Changes affecting JavaScript, native code, dependencies, Codegen, or build and runtime configuration verify both-platform release builds before acceptance; a documentation-only or otherwise unaffected change may be excluded only with machine-verifiable impact evidence. The Blueprint chooses a risk-appropriate point for both-OS device E2E from a serialized-integration gate, scheduled validation, release gate, or equivalent, running it before acceptance for critical-flow impact. Every release passes the complete gates for both platforms. Pull Requests, merge queues, and nightly jobs are implementation examples.
- Rule 420.45: Release artifacts trace the JS bundle, source map, dSYM, R8 mapping, SBOM, provenance, signing identity, source revision, and runtime compatibility.
- Rule 420.46: OTA updates are optional. Regardless of provider, require native-runtime compatibility identity, update signatures, channel isolation, preview verification, staged rollout, health monitoring, kill switch, and rollback to a previous or embedded version.
- Rule 420.47: Do not use OTA to substitute changes to native code, permissions, entitlements, SDKs, signing, or store metadata. Verify current Apple and Google policy and review requirements for every release.

## §14. Dependencies and Software Supply Chain

- Rule 420.48: Before adopting a library, evaluate maintainer health, release cadence, supported OS, New Architecture, Hermes, Expo or bare support, license, native code, security advisories, and exit feasibility, recording the result in a compatibility matrix.
- Rule 420.49: Integrate npm, Gradle, CocoaPods, SPM, and native binaries into one release inventory and verify SCA, licenses, SBOM, and provenance per artifact. Do not adopt an abandoned package without a fork owner or replacement deadline.

## §15. Observability and Incident Response

- Rule 420.50: Correlate JS errors, native crashes, ANR and hangs, startup, frames, network, and OTA cohort to the same release, session, and correlation ID. Protect source maps, dSYM, and mapping files and test symbolication before release.

Minimum queryable signals, exposed through a dashboard, report, alert query, or equivalent:

- crash-free users and sessions, ANR, iOS hang, fatal JS errors
- startup, slow or frozen frames, memory, network failures
- app version, React Native version, native runtime, OTA update ID, device and OS
- rollback condition, owner, on-call route, and store hotfix procedure

## §16. Scalable Team Governance

- Rule 420.51: Assign an accountable owner and continuity route for app composition, shared JS, iOS, Android, native modules, platform and CI, release and OTA, and security. `primary` and `secondary` are compatibility terms; risk determines whether they must be different people. Enforce independent review of the final revision for high-assurance boundaries through the VCS or equivalent change control.
- Rule 420.52: Depending on scale and demand, a Mobile Platform function may be an individual role, shared responsibility, virtual group, or dedicated Mobile Platform Team. It provides reusable adoption paths, a dependency catalog, upgrade operations, device-verification capability, a design system, observability, and release runbooks. Product or feature owners own end-to-end SLOs and product behavior on both operating systems.

Scale-appropriate operating controls:

- Do not rely on CODEOWNERS alone; connect the ownership registry to change controls. In high-assurance areas, configure required checks, stale-approval dismissal, latest-change approval, serialized integration, or equivalent capabilities.
- Review EOL and compatibility across React Native, React, Node, Xcode, Android toolchain, and native modules on support events and the Blueprint's risk-based cadence. Quarterly review is a reference default for large portfolios.
- Reserve upgrade capacity in the plan and expose unsupported versions, legacy architecture, and ownerless modules in a queryable portfolio report, dashboard, or equivalent evidence.
- In brownfield systems, avoid separate native and React Native roadmaps; assign one accountable owner per screen or capability.
- Exercise incidents, store rejection, OTA rollback, certificate expiry, and dependency compromise on a cadence derived from risk, change frequency, and past incidents. Annual exercise is a reference default for a continuously operated large product.

## §17. Exceptions, Maturity, and Prohibitions

### 17.1 Time-Bounded Exceptions

Do not permit an exception from the New Architecture itself on a React Native release within the official support window. Exceptions for an emergency migration from an unsupported legacy runtime, Hermes, the support window, device gates, or security controls have an ID, scope, reason, risk, compensating control, owner, approver, expiry, and exit test. Expiry blocks change acceptance or release.

### 17.2 Maturity

| Level | State |
|:--|:--|
| L1 Person-dependent | JS build only; no native owner, device tests, or upgrade policy |
| L2 Managed | Pinned toolchains, both-OS builds, basic tests, crash reporting |
| L3 Standardized | New Architecture, typed boundaries, a reusable adoption path, device matrix, and ownership controls |
| L4 Optimized | Performance budgets, integrated SBOM, upgrade train, staged OTA, release provenance |
| L5 Adaptive | Continuously improves architecture, dependencies, and platform differences from product SLOs and real-use data |

### 17.3 Prohibited Anti-Patterns

- Treating React Native as a language and omitting Swift and Kotlin owners
- Approving a mobile release from JS unit or component tests alone
- Unsupported React Native minor, an ineffective Legacy Architecture setting on 0.82 or later, or an indefinite legacy migration exception
- Manually duplicated JS, Swift, and Kotlin interfaces
- Scattered `Platform.OS` branches and lowest-common-denominator platform UX
- Tokens or secrets in AsyncStorage or secrets embedded in bundles
- OTA delivery without runtime compatibility, signatures, and rollback
- Judging performance only from development builds
- Missing source maps, dSYM, or R8 mapping that makes production crashes unsymbolicatable
- Abandoned native dependencies without owners and exit plans

---

## Appendix A: Reverse Index and Cross-References

| Keyword | Section |
|:--|:--|
| Expo, bare, brownfield, library | §2 |
| Version, support, Upgrade Helper, lockfile | §3 |
| TypeScript, Metro, platform-specific code | §4, §5 |
| New Architecture, Hermes, Codegen, Fabric, TurboModule | §6, §7 |
| Offline, network, deep link, accessibility | §8, §9 |
| Performance, JS thread, UI thread | §10 |
| Keychain, Keystore, PKCE, threat model | §11 |
| Jest, component, device E2E, native test | §12 |
| iOS and Android builds, OTA, rollback, store | §13 |
| SCA, SBOM, native dependency | §14 |
| Symbolication, ANR, hang, source map | §15 |
| CODEOWNERS, Platform Team, upgrade train | §16, §17 |

| Related source of truth | Responsibility |
|:--|:--|
| `engineering/320_programming_language_governance.md` | Language portfolio and common quality contract |
| `engineering/410_native_platforms.md` | Swift and Kotlin, iOS and Android implementation |
| `engineering/300_web_frontend.md` | Web boundary for shared React concepts; DOM rules are not inherited |
| `security/000_security_privacy.md` | Mobile security, secrets, storage, and deep links |
| `quality/000_qa_testing.md` | Test taxonomy, devices, and non-functional testing |
| `security/200_oss_compliance.md` | SCA, licensing, SBOM, and provenance |
| `operations/400_site_reliability.md` | SLOs, observability, and incidents |
| `product/700_appstore_compliance.md` | Apple and Google store review and distribution |

### Primary Sources

- [React Native Versions](https://reactnative.dev/versions): release cadence and support for the latest three minor series
- [React Native Release Levels](https://reactnative.dev/docs/releases/release-levels): boundaries for `STABLE`, `CANARY`, and `EXPERIMENTAL`
- [React Native 0.86](https://reactnative.dev/blog/2026/06/11/react-native-0.86): verification point for the stable release and support-window update as of June 11, 2026
- [About the New Architecture](https://reactnative.dev/architecture/landing-page): New Architecture default and migration
- [React Native 0.82 — A New Era](https://reactnative.dev/blog/2025/10/08/react-native-0.82): the New-Architecture-only boundary from 0.82 onward
- [Native Platform](https://reactnative.dev/docs/native-platform): Turbo Native Modules, Fabric, and legacy API migration
- [Codegen](https://reactnative.dev/docs/the-new-architecture/what-is-codegen): typed specs and platform code generation
- [Hermes](https://reactnative.dev/docs/hermes): bundled Hermes and default engine
- [Testing](https://reactnative.dev/docs/testing-overview): static, unit, component, integration, and E2E layers and the limits of JS tests
- [Performance](https://reactnative.dev/docs/performance): JS and UI thread performance verification in release builds
- [Security](https://reactnative.dev/docs/security): no bundle secrets, AsyncStorage, secure storage, deep links, and PKCE
- [Upgrading](https://reactnative.dev/docs/upgrading): three-layer Android, iOS, and JavaScript upgrades with Upgrade Helper
- [Expo runtime versions](https://docs.expo.dev/eas-update/runtime-versions/), [code signing](https://docs.expo.dev/eas-update/code-signing/), [rollouts](https://docs.expo.dev/eas-update/rollouts/), and [rollbacks](https://docs.expo.dev/eas-update/rollbacks/): OTA compatibility, signing, staged delivery, and rollback
- [Apple App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/) and [Google Play Device and Network Abuse Policy](https://support.google.com/googleplay/android-developer/answer/16559646?hl=en): executable-code and store-policy boundaries
