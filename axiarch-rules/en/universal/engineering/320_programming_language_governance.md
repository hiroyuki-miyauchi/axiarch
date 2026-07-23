# 320. Programming Language Governance

> [!CAUTION]
> This file is a Universal Rule (Immutable). Editing is prohibited without explicit "Amend Constitution" instruction.
> Revision date: 2026-07-23

> [!IMPORTANT]
> Primary directive: Select languages by fitness for purpose, safety, operability, talent sustainability, and exit options rather than fashion or personal preference. Preserve one common quality contract while preferring each language's official or de facto conventions for naming, formatting, typing, builds, and tests.
> 19-section structure, Rules 320.1–320.86.

---

## Table of Contents

| Section | Topic |
|:--|:--|
| §1 | Scope and precedence |
| §2 | Language portfolio and support tiers |
| §3 | New-language adoption contract |
| §4 | Cross-language quality contract |
| §5 | Web and UI language profiles |
| §6 | Backend and business-automation language profiles |
| §7 | Mobile and client language profiles |
| §8 | Data and AI language profiles |
| §9 | Infrastructure and operations language profiles |
| §10 | Systems, embedded, and accelerator language profiles |
| §11 | Concurrency, errors, and observability |
| §12 | Cross-language boundaries and contracts |
| §13 | Team and enterprise governance |
| §14 | Polyglot CI, supply chain, and reproducibility |
| §15 | Exceptions, migration, retirement, and maturity |
| §16 | Framework and desktop application governance |
| §17 | Query, transformation, observability, and infrastructure DSL governance |
| §18 | Public library, SDK, package distribution, and compatibility governance |
| §19 | Notebook and literate computational artifact governance |
| Appendix A | Reverse index and cross-references |

---

## §1. Scope and Precedence

- Rule 320.1: This file is the source of truth for selecting and governing programming languages, query languages, IaC languages, operational scripting languages, and container, build, or configuration definitions.
- Rule 320.2: Framework- and platform-specific rules in `300_web_frontend.md`, `400_mobile_flutter.md`, `410_native_platforms.md`, `420_react_native.md`, and cloud-specific sources of truth take precedence for their domains.
- Rule 320.3: When a generic convention conflicts with an official language convention, prefer the language-native convention unless it weakens security or an established project contract. A blanket `kebab-case` rule for all files is prohibited.
- Rule 320.4: MUST defines only a minimum outcome needed for interoperability, safety, law or contract, or prevention of irrecoverable harm; SHOULD defines the normal default; MAY defines an optional enhancement. When an outcome can be assured without mandating one implementation, specify the verifiable outcome rather than the method. A Blueprint may impose stricter requirements.
- Rule 320.5: Do not adopt a language on popularity alone. Evaluate existing assets, operators, regulation, performance, safety, ecosystem, hiring, vendor lock-in, and retirement cost together.

### 1.1 Universal Applicability Contract

Interpret every section of this file through the following four layers. This contract takes precedence over later tables, numbers, product names, organization names, and repository examples.

| Layer | Meaning | Treatment in Universal rules |
|:--|:--|:--|
| Invariant outcome | Safety, reproducibility, interoperability, ownership, verification, and exit feasibility | Normative requirement without prescribing one implementation |
| Ecosystem-native baseline | Official toolchain, support policy, package and build conventions | Default inside that ecosystem, subject to official constraints and compatibility |
| Reference implementation | Vendor, product, path, command, repository layout, or organization name | Non-normative example replaceable by an equivalent capability |
| Blueprint parameter | Headcount, deadline, cadence, threshold, support range, or approval stage | Decided in the Project Blueprint from risk, scale, regulation, and user impact |

- Never treat a vendor, hosted service, VCS feature, dashboard, or team name as the only conforming mechanism. A specific mechanism may be required only by an official platform constraint, an interoperability standard, or a documented safety reason.
- Do not force the same headcount or organization chart on individuals, small teams, multi-team organizations, and regulated enterprises. Define the responsibilities and decide by risk whether one person or team may combine them. For high-assurance changes, separate proposal from approval where practicable; where separation is impossible, record explicit risk acceptance and add an independent release control.
- Pull Requests, Merge Requests, CODEOWNERS, rulesets, merge queues, Golden Paths, and dashboards are representative implementations. An alternative VCS, change approval, ownership registry, serialized integration mechanism, scaffold, or report or query conforms when it provides equivalent outcomes and evidence.

## §2. Language Portfolio and Support Tiers

### 2.1 Support tiers

| Tier | Meaning | Required conditions |
|:--|:--|:--|
| Standard | Default candidate for new work | Reusable adoption path, accountable owner and continuity route, risk-based automated quality gates, SCA, SBOM, operational runbook |
| Supported | Existing assets or a clear domain fit | Accountable owner, verifiable change gate, dependency-resolution evidence, vulnerability response, exit plan |
| Restricted | High risk, specialized, or being reduced | ADR, expiring exception, additional review, alternative assessment |
| Experimental | PoC or bounded evaluation | No production use or explicit approval, isolation, end date |
| Retired | Prohibited for new use | Migration plan, usage inventory, removal deadline |

### 2.2 First-class profiles by domain

| Domain | First-class profiles | Conditional profiles |
|:--|:--|:--|
| Web and UI | TypeScript, JavaScript, HTML, CSS | Rust, Kotlin, Swift, and other WebAssembly targets |
| Backend | TypeScript or JavaScript on Node.js, Python, Java, Kotlin, C#/.NET, Go, Rust, PHP, Ruby | Deno or Bun runtimes, Scala, Elixir, Erlang, or Gleam, Clojure or other Lisp-family languages, Groovy, F#, OCaml or Haskell, Prolog, Lua, Perl, COBOL, PL/I, and other JVM, .NET, or BEAM languages |
| Business automation and enterprise platforms | C#/.NET, Python, PowerShell | VBA, Visual Basic .NET, Delphi/Object Pascal, ABAP, Apex, Power Fx, and database procedural languages such as PL/SQL and T-SQL |
| Mobile | Swift, Kotlin, Dart, React Native framework (TypeScript or JavaScript plus Swift and Kotlin) | Objective-C, Java, Kotlin Multiplatform, and other cross-platform frameworks |
| Desktop | Platform-native UI stacks for the target OS and adopted maintainable cross-platform frameworks | Electron, Tauri, .NET MAUI or Avalonia, Qt, Compose Multiplatform or Desktop, Flutter desktop, SwiftUI or AppKit, WinUI or WPF, GTK, and equivalents |
| Games and real-time clients | C#/.NET, C++ | GDScript, Lua, Rust, engine-specific scripting |
| Data, AI, and scientific computing | Python, SQL, R, Scala | Julia, MATLAB, Fortran, Mojo, SAS, Stata, JVM and .NET data processing |
| Query, semantic, and observability DSLs | SQL and adopted SQL dialects, GraphQL, PromQL | Cypher, Gremlin, SPARQL, LogQL, KQL, Flux, DAX, MDX, Power Query M, dbt SQL and Jinja, vendor-specific query or formula languages |
| Accelerator and GPU compute | CUDA C++, HIP C++, SYCL C++ | Triton, OpenCL C, vendor- or framework-specific kernel DSLs |
| Graphics and shaders | WGSL, GLSL, HLSL, Metal Shading Language | Engine-specific shader DSLs and shader graphs that generate source |
| Infrastructure and operations | HCL/Terraform or OpenTofu, Dockerfile/Containerfile, Shell, PowerShell, YAML, Rego | Bicep, cloud-native declarative formats such as CloudFormation or ARM, Kubernetes manifests, Helm, Kustomize, Crossplane, Ansible, Puppet, Chef, Packer, Make or CMake, Bazel or Starlark, Nix, CUE or Jsonnet, general-purpose Pulumi/CDK languages |
| Systems and embedded | Rust, C, C++ | Zig, Ada/SPARK, Assembly, Lua, MicroPython, Embedded Swift, Kotlin/Native |
| Kernel extensions, packet processing, and observability | C, Rust | eBPF artifacts and platform-specific filter or packet DSLs |
| Smart contracts and distributed ledgers | Solidity, Rust | Vyper, Move, Cairo, chain-specific languages |
| Hardware and programmable logic | SystemVerilog or Verilog, VHDL | Chisel or Scala, Bluespec, C or C++ for HLS |

C#, C++, GDScript, Lua, and other code inside a game engine inherits the quality and boundary contracts in §4, §10, and §12. Pin the engine, export templates, platform SDKs, asset build, and native plugins in one compatibility record, and never approve a release artifact solely because it works in the editor.

Vendor-platform languages, smart-contract languages, and hardware-description languages also inherit §3, §4, §12, and §14. Extend the adoption contract with platform transports and packages, test networks, simulation or synthesis, hardware verification, upgrade authority, artifact provenance, and exit feasibility as applicable. Inclusion in this table is not an unconditional adoption recommendation.

- Rule 320.6: Conditional or unlisted languages are not categorically forbidden. They may be used after satisfying §3 and recording the decision in the Blueprint.
- Rule 320.7: Duplicating the same responsibility in multiple languages requires a specific performance, regulatory, or platform rationale.

## §3. New-Language Adoption Contract

Before introducing a language or runtime into production, record the following in an ADR and a machine-readable Language Portfolio Record.

| Field | Required content |
|:--|:--|
| Business fit | Responsibility solved, why current languages are insufficient, expected benefit |
| Ownership | Accountable owner, continuity or alternate route, change review, and operational or on-call responsibility; each may be a person, role, team, or external maintenance contract |
| Support | Supported versions, LTS policy, update cadence, EOL monitoring |
| Tooling | Formatter or deterministic style enforcement, linter, type checker or compiler, tests, SAST, SCA, and SBOM; rationale and compensating control for a non-applicable item |
| Reproducibility | Runtime, compiler, or platform-release pin or compatibility range; dependency-resolution evidence; wrapper; hermetic or reproducible-build policy |
| Operations | Logging, metrics, tracing, profiling, debugging, incident runbook |
| Boundaries | API, event, schema, or FFI contracts and compatibility policy |
| Risk | Memory safety, concurrency, supply chain, licensing, hiring and training cost |
| Exit | Retirement criteria, data and API migration, artifact retention, estimated cost |

Minimum machine-readable record:

```yaml
language_portfolio:
  schema_version: 1
  reviewed_at: "YYYY-MM-DD"
  entries:
    - id: "java"
      tier: "standard"
      domains: ["backend"]
      toolchain:
        runtime: "<distribution>"
        version: "<pinned-version>"
        command_or_wrapper: "./gradlew"
      dependency_resolution:
        evidence: "<lockfile-resolved-graph-checksum-or-platform-version>"
      support:
        policy: "LTS"
        eol: "YYYY-MM-DD"
        next_review: "YYYY-MM-DD"
      owners:
        primary: "<person-role-or-team>"
        secondary: "<continuity-route-or-same-owner-with-risk-record>"
        on_call: "<route>"
      required_gates: ["format", "lint", "compile", "test", "sca", "sbom", "provenance"]
      evidence_refs: ["<ADR>", "<ownership-or-change-control-record>", "<runbook>"]
      exception_ids: []
```

Validate the record schema automatically and make an unknown tier, missing accountable owner or continuity route, exceeded EOL, expired review, or missing required gate or evidence reference a change-acceptance or release blocker. `primary` and `secondary` are compatibility field names and do not always mean different people; require independent approval only for high-assurance areas. Do not trap team and tool names in a free-form table; allow reports, queries, and EOL alerts to consume the same record.

- Rule 320.8: Assign every production language an accountable owner and a route that preserves maintenance through leave, departure, incident, or contract termination. A separate backup maintainer is recommended but not universally mandatory. Solo maintenance addresses key-person risk through documentation, recovery procedures, credential continuity, external support, or an exit plan.
- Rule 320.9: Standard status requires a reproducible adoption path through quality gates, release, rollback, and operations. A Golden Path or scaffold is one implementation; its delivery deadline is a Blueprint parameter derived from adoption risk and delivery plans.
- Rule 320.10: Reassess adoption when the initial hypothesis can be validated, then on support retirement, a major vulnerability, loss of staffing capability, regulatory change, major incident, and a risk-based cadence defined by the Blueprint. Six-month and annual reviews are reference defaults, not fixed obligations.

## §4. Cross-Language Quality Contract

Production code must satisfy all of the following regardless of language.

1. Pin the runtime, compiler, and primary toolchain in a machine-readable form. When an adopter cannot pin a SaaS or enterprise-platform runtime, record the target platform or API release, compatibility range, change-notification path, and revalidation triggers.
2. Verify an official or broadly adopted formatter in CI when the ecosystem provides one. Otherwise select an equivalent style-drift control from a deterministic pretty-printer, style lint, compiler check, normalized text export, or documented review gate, and inventory why formatting is not applicable.
3. Enable complementary layers from linting, type checking, compiler warnings, and static analysis that apply to the language, artifact, and threat model. Do not multiply redundant tools merely to increase their count or require a layer unavailable in that ecosystem.
4. Treat new warnings and warnings caused by a change as failures. A phased adoption from an existing baseline must not increase the total and must assign a reduction owner and expiry. A suppression must have the narrowest scope, a reason, owner, Issue, and expiry.
5. Maintain unit, integration, and contract tests according to risk, including external boundaries and failure paths.
6. For deployable applications and executable roots, commit a lockfile and use frozen or locked installation when the ecosystem provides one. When no lockfile exists or it is not a complete resolution snapshot, retain equivalent evidence such as checksums, a vendor tree, a resolved graph, platform package versions, or artifact digests. Publishable libraries follow consumer-compatibility conventions while pinning CI test and release resolution.
7. Run SCA over direct and transitive dependencies and generate an artifact-level SBOM.
8. Bind release artifacts to one source revision and make provenance and signatures verifiable.
9. Exclude debug output, unhandled errors, secrets, and indefinite TODOs from releases.
10. Document public APIs and operations, and execute-verify code examples wherever practical.

- Rule 320.11: When a named tool or quality layer is unavailable in the target ecosystem, record an equivalent failure-detection capability or the non-applicability rationale and compensating control in the Blueprint. Do not demand a nonexistent tool for appearances or silently omit the risk it was meant to detect.
- Rule 320.12: Dynamically typed languages must combine runtime schema validation at external boundaries with available static type analysis.
- Rule 320.13: Statically typed languages must still runtime-validate external JSON, database, message, CLI, and environment input.

## §5. Web and UI Language Profiles

| Language | Standard | Required gates |
|:--|:--|:--|
| TypeScript | Default for new applications; use `strict` and boundary schemas | Formatter, ESLint or equivalent, `tsc --noEmit`, unit, integration, E2E, dependency audit, production build |
| JavaScript | A normal profile when ecosystem, library, runtime, distribution, incremental-migration constraints, or a recorded adoption decision justify it; also applies to legacy code, configuration, and short scripts | Formatter, lint, available type analysis such as `checkJs` or `@ts-check` with JSDoc, runtime schemas at external boundaries, tests, dependency audit |
| HTML / CSS | First-class profile for semantic UI and styling, including framework output | Formatter, HTML validation, Stylelint or equivalent, accessibility, responsive and cross-browser checks, production-artifact verification |

- Rule 320.14: TypeScript uses `strict` as the baseline. New projects SHOULD enable `noUncheckedIndexedAccess` and `exactOptionalPropertyTypes`.
- Rule 320.15: Do not use `any`, `@ts-ignore`, or lint disables as permanent solutions. Prefer `unknown`, narrowing, and explicit schemas.
- Rule 320.16: `300_web_frontend.md` is the source of truth for framework rendering, accessibility, bundle, and browser verification.
- Rule 320.17: When frontend and backend use different languages, use generated contract types or schemas rather than manually duplicated DTOs.

## §6. Backend and Business-Automation Language Profiles

| Language | Primary uses | Baseline toolchain examples |
|:--|:--|:--|
| TypeScript / JavaScript on Node.js | APIs, BFFs, real-time systems, serverless, automation | Active or Maintenance LTS runtime pin, package-manager pin and lockfile, TypeScript `strict` or `checkJs` and JSDoc, formatter, ESLint or equivalent, unit, integration, contract, dependency audit, production build |
| Python | APIs, AI/ML, automation, data | `pyproject.toml`, uv or equivalent lock, Ruff, Pyright or mypy, pytest, pip-audit |
| Java / Kotlin | Large business systems, JVM services, shared Android layers | JDK LTS, Gradle or Maven wrapper, formatter, Error Prone, SpotBugs, detekt or equivalent, tests, dependency audit |
| C# / .NET | Enterprise systems, Azure, games, cross-platform services | SDK pin, nullable enabled, analyzers, warnings as errors, `dotnet format`, build, tests, package audit |
| Go | Network services, platform tooling, CLI | `gofmt`, `go vet`, Staticcheck, `go test -race`, fuzzing, `govulncheck` |
| Rust | High-assurance services, systems, Wasm, performance-critical work | `rustfmt`, Clippy, tests, `cargo audit` or `cargo deny`, unsafe inventory |
| PHP | Web, CMS, existing business applications | Composer lock, PSR-12 formatter, PHPStan or Psalm, PHPUnit or Pest, `composer audit` |
| Ruby | Rails, business web applications, automation | Bundler lock, RuboCop, RBS/Steep or Sorbet, RSpec or Minitest, bundler-audit, and Brakeman for Rails |
| Scala, Groovy, Clojure, and other JVM languages | JVM services, data processing, build and automation, existing portfolios | JDK and compiler pins, a wrapper or resolution evidence for sbt, Gradle, Leiningen, Clojure CLI, or an equivalent tool, ecosystem-native formatting, linting, or static analysis, tests, JVM dependency audit |
| Elixir, Erlang, Gleam, and other BEAM languages | Concurrent services, messaging, distributed systems | OTP, compiler, and build-tool pins, `mix.lock`, `rebar.lock`, or equivalent, formatting, Dialyzer or language-native type checking, tests, release artifacts, cluster and upgrade tests, Hex dependency audit |
| F#, OCaml, Haskell, and other functional languages | Domain modeling, compilers and tooling, high-assurance services | Runtime, compiler, and package-manager pins, a lock or resolved graph, formatting, compiler warnings or linting, risk-based tests including property-based tests, FFI boundaries, dependency audit |
| Lua / Perl | Embedded extensions, automation, existing services | Runtime pin, StyLua and Luacheck or Perl::Tidy and Perl::Critic, Busted or Test2 and prove, resolved dependency inventory, SCA |
| VBA | Office business automation and existing critical spreadsheets | Office version pin, `Option Explicit`, versioned text modules, compile, lint, tests, signed macros, managed trusted publishers |
| COBOL, PL/I, Visual Basic .NET, Delphi, and similar languages | Mainframes, Windows, long-lived enterprise assets | Compiler, runtime, and target-platform pins, copybook, interface, and binary-encoding contracts, source control, available static analysis, unit, integration, and batch reconciliation, dependency and vendor support, migration or bounded-maintenance plan |
| ABAP, Apex, Power Fx, and database procedural languages | SAP, Salesforce, low-code platforms, and database-coupled business processing | Platform and runtime version or release channel, text or metadata export, available formatting or static analysis, unit and integration tests, authorization, transport or deployment verification, change inventory, exit plan |

A production Node.js service uses only an Active LTS or Maintenance LTS release and does not place blocking synchronous I/O or long-running CPU work on a request path. Define timeouts and cancellation such as `AbortSignal`, queue bounds, backpressure, and graceful shutdown for external I/O. When adopting Deno or Bun as a server runtime, demonstrate Node.js compatibility, native-addon behavior, observability, security advisories, deployment-platform support, lockfile behavior, and SBOM coverage in the adoption contract; do not silently treat it as the same runtime as Node.js.

- Rule 320.18: Python uses `pyproject.toml` as its configuration source of truth and prohibits `pickle`, `eval`, or `shell=True` for untrusted input. Async designs define timeouts, cancellation, and structured concurrency.
- Rule 320.19: JVM and .NET use LTS or an explicitly supported organizational version and align local and CI SDKs through wrappers or global configuration.
- Rule 320.20: Go documents every goroutine's owner and termination condition, propagates `context`, and includes the race detector and `govulncheck` in CI.
- Rule 320.21: Rust isolates `unsafe` to the smallest module and records the safety conditions, invariants, review owner, and test or fuzz evidence for every block. Do not enable all Clippy restriction lints blindly; select valuable lints deliberately.
- Rule 320.22: Dynamic languages such as PHP, Ruby, Lua, and Perl declare a runtime-schema or explicit-allowlist strategy, available static analysis, and language or framework security scanners. Dynamic behavior is not grounds for skipping types or boundary validation. VBA is not a default for new systems, and a binary document alone is not its source of truth. Bind exported text modules, an Office and reference manifest, and the signed distribution artifact.

## §7. Mobile and Client Language Profiles

- Rule 320.23: `410_native_platforms.md` is the source of truth for Swift and Kotlin, `400_mobile_flutter.md` for Dart, and `420_react_native.md` for React Native. Treat React Native as a framework joining a TypeScript or JavaScript layer to Swift and Kotlin native layers, not as a language.
- Rule 320.24: Swift applies Strict Concurrency, Sendable, actor isolation, SwiftLint or SwiftFormat, and Swift Testing or XCTest.
- Rule 320.25: Kotlin applies null safety, structured coroutines, ktlint, detekt, compiler warnings as errors, and JUnit or equivalent.
- Rule 320.26: Dart applies null safety, `dart format`, `dart analyze --fatal-infos`, and unit, widget, and integration tests.
- Rule 320.27: New Objective-C or Java mobile code records a rationale based on OS APIs, vendor SDKs, existing assets, compatibility, verified maintenance capability, or equivalent evidence. The adoption decision selects a staged migration to Swift or Kotlin, bounded maintenance with interoperability, or a continuing profile with explicit support conditions and review triggers, avoiding both regression-prone rewrites and indefinite neglect.

React Native app code inherits the TypeScript or JavaScript quality contract in §5. Native modules add Swift and Kotlin ownership, Codegen contracts, iOS and Android builds, device tests, and runtime-compatible OTA controls. A JS-only gate cannot approve a mobile release.

## §8. Data and AI Language Profiles

| Language | Mandatory requirements |
|:--|:--|
| SQL | Dialect and database version pin, formatter or lint, parameterized queries, migration dry-run, schema diff, integration tests, and `EXPLAIN` for critical queries |
| Python | §6 plus reproducible data, model, random seed, and environment, with typed dataframes or schema validation |
| R | `renv.lock`, styler, lintr, testthat, `R CMD check`, seed and session information |
| Scala | JDK and Scala pin, sbt or Scala CLI resolution policy, scalafmt, scalafix, tests, dependency audit |
| Julia | Julia version, `Project.toml` and a use-case-appropriate `Manifest.toml`, formatting or linting, tests, seeds, artifact and binary dependencies, precompile or sysimage compatibility |
| MATLAB | MATLAB release and toolbox or license inventory, a Project or canonical path configuration, Dependency Analyzer, Code Analyzer, unit tests, target compatibility for generated code or compiled artifacts |
| Fortran | Compiler, language standard, and target-architecture pins, an fpm manifest or equivalent build graph, formatting, compiler warnings or static analysis, numerical regression, ABI and runtime matrices for MPI, OpenMP, BLAS, or equivalents |
| Mojo | Compiler and package pins with a lock, formatting, warnings as errors, tests, Python, C, and C++ interoperability boundaries, target hardware; default to an Experimental or Restricted profile until long-term versioning and stability are established |
| SAS, Stata, and similar platforms | Product release, module and license inventory, text source and dataset schemas, batch execution, log warning and error gates, deterministic seeds, statistical regression, export and exit paths |

Scientific computing does not universally require bitwise identity. Define tolerances, invariants, and reference datasets before implementation according to the algorithm, precision, compiler optimization, hardware, and parallel reduction. Include license servers, headless CI, long-term reproducibility, support retirement, and artifact readability in the adoption contract for proprietary runtimes.

- Rule 320.28: A notebook is a stateful executable document. Declare whether its profile is exploration, research, review or report, or scheduled or production, and inherit §19. Extract reusable domain logic into testable packages or modules where practical. A production notebook must satisfy clean-execution, immutable environment and data reference, and operating-contract requirements.
- Rule 320.29: A data-pipeline change updates schema, freshness, completeness, lineage, PII classification, and backfill procedures with the code.
- Rule 320.30: Database sources of truth and security rules take precedence for SQL migrations, privileges, RLS, and retention.

A data or AI workload containing a custom accelerator kernel or framework-generated device artifact also inherits the accelerator contract in §10. Even when the project does not directly own the kernel source, keep every compiler, runtime, driver, target device, generated artifact, and fallback that affects release behavior in the compatibility inventory.

## §9. Infrastructure and Operations Language Profiles

| Language or format | Required gates |
|:--|:--|
| HCL / Terraform | `terraform fmt -check`, `validate`, TFLint, security or policy scan, `terraform test` or equivalent, machine-readable plan verification |
| Bicep and cloud-native declarative formats | Target cloud API and toolchain pins; formatter or style lint; compiler, schema, or template validation; machine-readable change preview such as what-if or change sets; security and policy scan; module or template-source pin; drift detection; rollback verification. Bicep, ARM templates, CloudFormation, and SAM are replaceable examples; do not treat their state models as identical |
| Dockerfile / Containerfile | Parser and build checks, lint, trusted minimal base image pinned by digest, multi-stage build, non-root execution, build-secret mounts, image tests and scans, SBOM, provenance |
| Shell | `shfmt`, ShellCheck, Bats or ShellSpec, an explicit `set -euo pipefail` applicability decision, quoting, cleanup traps |
| PowerShell | PSScriptAnalyzer, Pester, StrictMode, `-ErrorAction Stop`, cross-platform matrix or an explicit Windows-only declaration |
| YAML | Schema validation, lint, target-tool dry-run or validation, secret scan |
| Rego / Policy as Code | Formatter, unit tests for allow and deny, bundle and version pins |
| Make or CMake, Bazel or Starlark, Nix, CUE or Jsonnet, and similar build DSLs | Toolchain pin, formatter or lint, build-graph or schema validation, tests, declared host and network dependencies, hermetic or reproducible-build verification, cache trust boundary |

- Rule 320.31: Limit Shell to small utilities or wrappers. Evaluate migration to Python, Go, Rust, PowerShell, or another structured language when state, concurrency, structured-data processing, or growing size can no longer be safely followed by maintainers. One hundred lines is a reference heuristic from the Google Shell Style Guide, not a fixed Universal conformance threshold.
- Rule 320.32: Visual inspection alone cannot approve a Terraform plan. Machine-detect deletion, replacement, privilege expansion, public exposure, and material cost growth.
- Rule 320.33: Apply ownership controls, tests, review or equivalent change approval, and rollback procedures to IaC, workflow, and policy changes. CODEOWNERS is one ownership-control implementation.

## §10. Systems, Embedded, and Accelerator Language Profiles

| Language | Required gates |
|:--|:--|
| Rust | §6 plus unsafe and FFI boundaries, Miri or sanitizer applicability decision, fuzzing, MSRV policy |
| C / C++ | Formatter, `clang-tidy` or equivalent, compiler warnings, ASan and UBSan, TSan or MSan when relevant, unit and integration tests, fuzzing, dependency inventory and SBOM |
| Zig and others | Adoption contract, toolchain pin, formatter, tests, C ABI boundary, supply-chain and long-term-support evaluation |
| WebAssembly and WASI artifacts | Source-language gates plus compiler, runtime, Wasm, WASI, and WIT version pins; module or component validation; interface and host compatibility tests; capability allowlist; resource limits; target browser or runtime matrix; provenance binding the source SBOM to the final binary digest |
| Accelerator sources and artifacts such as CUDA C++, HIP C++, SYCL C++, Triton, and OpenCL C | Pin host and device compilers, runtime, driver, API, device architecture, and backend compatibility. Maintain supported-device, precision, and fallback matrices; compiler or validator checks; differential tests against a CPU or trusted reference implementation; defined tolerances for NaN, Inf, overflow, rounding, and determinism; memory-boundary, address-space, workgroup, barrier, and race checks; performance and resource budgets on representative devices; and SBOM or provenance from source through intermediate representation to final binary digest |
| Shader sources and binaries such as WGSL, GLSL, HLSL, and Metal Shading Language | Pin the language, graphics API, shader model, feature set, compiler, and validator. Validate stage interfaces, bindings, layouts, and reflection; test the target browser, OS, GPU, and driver matrix; use golden images plus numerical or structural invariants; capture compilation, pipeline-creation, and runtime error telemetry; and bind source provenance to final SPIR-V, DXIL, metallib, or equivalent digests |
| eBPF ELF and BTF artifacts generated from C, Rust, or another source language | Pin the source, compiler, loader, kernel, BTF, program type, attach point, helpers or kfuncs, and architecture compatibility. Require verifier acceptance; a privilege, capability, and data-exposure threat model; map-schema, lifecycle, and resource bounds; CO-RE and a target-kernel matrix or an explicit limited-support declaration; attach, detach, and rollback tests; license and helper eligibility; and provenance from source to ELF and BTF digests |
| Solidity, Vyper, Move, Cairo, and similar | Compiler, chain, and framework pins; static analysis; unit, invariant, and fuzz tests; testnet or local fork; storage layout; upgrade and access control; bytecode and provenance |
| SystemVerilog, Verilog, VHDL, and similar | Simulator and synthesis toolchain pins, lint, assertions, testbench or formal verification, CDC and RDC, timing constraints, bitstream and firmware provenance |

- Rule 320.34: Prefer a memory-safe language for new network-facing, authentication, parser, and critical-infrastructure functions.
- Rule 320.35: Where C or C++ remains, inventory usage, unsafe APIs, external inputs, sanitizer coverage, and migration priority. New externally exposed, privileged, or critical C or C++ work requires an approved ADR containing either a memory-safe roadmap with an accountable owner, phases and deadlines, dependencies, training, CVE response, compatibility bridges, and completion metrics, or a documented infeasibility case with equivalent compensating controls.
- Rule 320.36: At FFI boundaries, document ownership, lifetime, allocation and deallocation responsibility, threading, error mapping, and ABI compatibility, then run boundary tests and fuzzing.

A smart-contract threat model includes assets, upgrade keys, oracles, bridges, governance, reentrancy, integer and rounding behavior, denial of service, and MEV, with an independent audit and staged privilege reduction selected according to production asset value and irreversibility. Hardware-description work does not end at simulation; trace post-synthesis timing, clock and reset domains, target devices, and bitstream signatures or equivalent artifact identity.

Adopt accelerator or shader optimization only when measured benefit on representative workloads and devices exceeds the complexity, portability, cost, energy, and maintenance burden. A vendor- or backend-specific path needs a portable or reference fallback, an explicit support boundary, an accountable owner, and an exit plan. Performance tests never replace correctness tests. Where bitwise equality is not achievable for numerical work, define domain-appropriate tolerances and failure conditions first.

Treat build hosts, compiler caches, remote caches, driver JITs, and signed distributions as trust boundaries whether artifacts are precompiled or compiled at runtime. Passing a shader validator or eBPF verifier alone does not approve visual correctness, numerical correctness, privacy, privilege, or availability. Based on risk, require stronger review, isolated verification, staged attachment, and immediate detach or rollback for eBPF changes attached to privileged, network, or security-enforcement paths.

## §11. Concurrency, Errors, and Observability

- Rule 320.37: Every asynchronous task, thread, goroutine, coroutine, or actor defines its owner, lifecycle, timeout, cancellation, backpressure, and shutdown behavior.
- Rule 320.38: Fire-and-forget is prohibited by default. A justified case must be a managed task with monitoring, failure recovery, limits, and termination controls.
- Rule 320.39: Classify errors as user-facing, domain, transient, dependency, or programming faults and keep retry and status mappings consistent.
- Rule 320.40: Never swallow exceptions or errors. Excluding sensitive data, emit structured correlation ID, service, operation, and error category.
- Rule 320.41: Prefer language-neutral standards such as OpenTelemetry and propagate trace context across HTTP, RPC, queue, batch, and CLI boundaries.

## §12. Cross-Language Boundaries and Contracts

- Rule 320.42: Use OpenAPI or JSON Schema for HTTP, Protocol Buffers or equivalent for RPC, AsyncAPI or registry schemas for events, and data contracts for data products.
- Rule 320.43: Do not hand-copy types that can be generated across languages. Pin generator versions and schema digests and verify generated diffs in CI.
- Rule 320.44: A contract includes owner, version, compatibility mode, deprecation period, error model, pagination, idempotency, and PII classification.
- Rule 320.45: Contract tests cover language differences in binary values, time zones, decimals, 64-bit integers, nulls, unknown enum values, Unicode, and ordering.
- Rule 320.46: Prefer service and data contracts over shared internal packages across organizational boundaries to avoid implementation coupling.

## §13. Team and Enterprise Governance

### 13.1 Ownership and review

- Assign every language, runtime, and build tool an accountable owner and continuity route. `primary` and `secondary` are compatibility schema names; risk determines whether they must be different people.
- For a cross-language framework such as React Native, inventory app and JS, iOS, Android, native-module, and release or OTA ownership boundaries and connect them to one accountable product owner.
- Resolve specialist review through CODEOWNERS, an ownership registry, or an equivalent mechanism, and enforce mandatory verification through protected branches, repository rules, CI policy, or equivalent change controls.
- Multiple entries in an ownership record do not by themselves enforce independent approval. For high-assurance paths, configure required approval counts, independent approval of the latest change, and dismissal of stale approvals in the active VCS or change-management mechanism, and assign an owner to the ownership policy itself.
- Separate proposer and approver in high-assurance areas and require two-person review of the final revision.
- During onboarding, role changes, and offboarding, transfer or revoke repository, registry, signing, and CI access; service accounts; release ownership; maintainer contacts; runbooks; and unresolved exceptions through the same inventory. Retain evidence that builds, patches, releases, and rollback remain operable after a sole maintainer leaves or a contract ends.
- Detect missing owners, EOL versions, critical vulnerabilities, and broken builds automatically and expose them in a queryable portfolio report, dashboard, or equivalent evidence.

### 13.2 Golden Paths

Provide a reproducible adoption path to the following for each Standard language. Templates, service scaffolds, generated CLIs, and documented reference repositories are example implementations:

- Runtime and compiler pins, formatting or style enforcement, lint, type or compiler checks, tests, SCA, SBOM, container, health, and telemetry
- Local setup, CI, release, rollback, and incident runbooks
- Secure defaults, sample API, contract generation, dependency-update automation
- Onboarding verification and Time-to-First-PR measurement

### 13.3 Change and exceptions

- An accountable language-portfolio function reviews the portfolio, EOL state, exceptions, and language duplication on the Blueprint's risk-based cadence and on material events. A Language Council or Architecture Group and quarterly review are large-organization examples.
- Every exception requires an ID, scope, reason, owner, approver, compensating controls, expiry, and recheck date.
- An expired exception fails CI or is at minimum treated as a merge blocker.

## §14. Polyglot CI, Supply Chain, and Reproducibility

- Rule 320.47: A monorepo represents dependencies in a build graph and combines change-scoped verification with full contract and integration gates on a mechanism that serializes integration order. A merge queue is a representative implementation.
- Rule 320.48: Do not treat path filters as proof of safety. Changes to shared schemas, base images, toolchains, or workflows revalidate every affected language.
- Rule 320.49: Deployable applications and executable roots commit a lockfile when the ecosystem provides one and otherwise retain equivalent immutable resolution evidence. Define root-versus-subproject resolution ownership, and make publishable libraries follow ecosystem consumer-compatibility conventions while pinning CI test and release resolution. Do not make deletion of lockfiles, checksums, resolved graphs, or other evidence followed by casual re-resolution a standard recovery step.
- Rule 320.50: A release merges language-specific SBOMs and is traceable to source revision, builder identity, toolchain, artifact digest, and test and SCA results. Target SLSA Build L2 or higher for production builds and Build L3 for high-assurance artifacts, and verify provenance rather than merely generating it. When the package registry and build platform support it, prefer a short-lived workload identity such as OIDC over a long-lived publish token and protect the registered workflow or pipeline as a credential boundary. An unsupported ecosystem uses a minimally scoped, short-lived credential and a time-bound migration review.
- Rule 320.51: Build-cache keys include toolchain, the lockfile or equivalent dependency-resolution digest, target, features, and environment. Never reuse unverified artifacts across trust boundaries.
- Rule 320.52: According to risk, source-change controls require owner review, mandatory checks, renewed review after approval-changing commits, and protection from history rewriting. Protected branches, rulesets, and server-side policy are example implementations. When adopting the SLSA Source track, treat Source L2 as a common reference profile and Source L3 or Source L4 with two-party review as strengthened profiles for high-assurance areas, selecting the required properties from risk. In a Source VSA, verify the corresponding numeric level plus `SLSA_SOURCE_TWO_PARTY_REVIEWED` and do not emit a nonexistent `SLSA_SOURCE_LEVEL_4`.

### 14.1 Baseline CI order

1. Metadata, dependency-resolution evidence, and generated-contract integrity
2. Formatting or style enforcement, lint, type or compiler, and policy
3. Unit, integration, contract, race, and sanitizer checks
4. Build, package, container, SBOM, and SCA
5. E2E, performance, compatibility, and reproducibility
6. Provenance, signature, and release policy

## §15. Exceptions, Migration, Retirement, and Maturity

### 15.1 Retirement protocol

1. Stop new usage and inventory all usage and owners.
2. Design the replacement, compatibility bridge, data and API migration, and rollback.
3. Machine-verify zero traffic, consumers, and build artifacts.
4. Remove dependencies, runtime, CI, secrets, and documentation in the same closeout.
5. Update the ADR and Tech Radar and assign new deadlines to remaining exceptions.

### 15.2 Maturity model

| Level | State |
|:--|:--|
| L1 Individual | Language choice, versions, quality gates, and owners are implicit |
| L2 Visible | Language inventory, pins, baseline CI, and dependency auditing exist |
| L3 Standardized | Reusable adoption paths, ownership controls, contract generation, and expiring exceptions exist |
| L4 Optimized | Build graph, impact-aware CI, merged SBOM, provenance, and automated EOL monitoring exist |
| L5 Adaptive | Portfolio metrics continuously improve adoption, consolidation, and retirement while generating control evidence automatically |

### 15.3 Prohibited anti-patterns

- Resume-driven language adoption
- A production language without an accountable owner, continuity route, and exit plan
- A production repository without an available formatter or equivalent style-drift control, a deployable application or executable root without a lockfile or equivalent dependency-resolution evidence, or a publishable library without pinned CI test and release resolution and retained dependency evidence
- Renaming TypeScript gates and applying them unchanged to every language
- Skipping boundary schemas or static analysis because a language is dynamic
- Skipping external-input validation because a language is static
- Manually duplicated cross-language DTOs
- Treating path filters alone as proof of end-to-end compatibility
- Indefinite lint suppressions, security waivers, or EOL runtimes
- Expanding C or C++ without a replacement strategy or recorded memory-safety risk

## §16. Framework and Desktop Application Governance

### 16.1 Framework portfolio

- Rule 320.53: Do not collapse languages, runtimes, frameworks, compilers, SDKs, adapters, plugins, ORMs, renderers, and build or packaging tools into one “supported language” claim. Inventory the support authority, version, EOL, compatibility range, and update responsibility for each layer and validate the combination.
- Rule 320.54: A production-framework adoption record includes business fit, official or community support, the security-advisory path, runtime, compiler, and SDK matrices, critical adapters and plugins, data migration, operations, upgrade, rollback, and exit. Universal rules do not make one product mandatory; an implementation may be replaced by one that delivers equivalent outcomes.
- Rule 320.55: React and Next.js, Vue and Nuxt, Angular, Svelte and SvelteKit, Astro, Spring Boot, Quarkus, Micronaut, ASP.NET Core, Django, FastAPI, Flask, Express, NestJS, Fastify, Rails, Laravel, Symfony, Phoenix, Ktor, and Go or Rust web ecosystems are representative profiles. Their inclusion is not an unconditional support guarantee or adoption directive. The adopted version's official support policy and effective compatibility matrix are authoritative.
- Rule 320.56: Do not inherit framework defaults as unverified security or operational contracts. Define and test responsibility boundaries and production settings for authentication, sessions, CORS, CSRF, input validation, errors, serialization, ORM and migrations, jobs, caching, and telemetry.
- Rule 320.57: Keep domain contracts independent from framework boundaries and treat transport, persistence, UI, and native bridges as adapters. Do not build a general-purpose internal framework only for one project's preferences; require multiple concrete consumers, a demonstrated gap against existing options, a maintenance owner, compatibility, and an exit path.
- Rule 320.58: A major framework upgrade validates generated template and configuration differences, runtime, compiler, SDK, adapter, and plugin matrices, deprecations, data or schema migrations, the production build, and rollback or forward-fix. Upgrade multiple majors together only when the official migration path and separable evidence make failures diagnosable.
- Rule 320.59: Decide the framework support tier independently from the language support tier. An installable package, a runnable sample, or a first-class language does not by itself establish production framework support.

### 16.2 Desktop application profile

- Rule 320.60: A desktop adoption contract includes a compatibility matrix for target OS, architecture, runtime or webview, compiler or SDK, framework, native dependencies, signing, installer or package format, update channels, and enterprise distribution paths. Validate the oldest and current supported targets with real artifacts according to risk and user distribution.
- Rule 320.61: Treat the renderer or webview, IPC, native bridge, filesystem, shell, network, deep links or custom protocols, and update path as separate trust boundaries. Apply least privilege, sandboxing or capabilities, sender and input validation, and navigation restrictions; never expose raw native APIs or credentials to untrusted content.
- Rule 320.62: Bind code signing, notarization or platform-equivalent verification, package identity, update manifests and signatures, channels, rollback or forward-fix, SBOM, provenance, source maps or symbols, and crash telemetry to the distributed desktop artifact. Where a platform has no applicable mechanism, record why and retain equivalent integrity evidence.
- Rule 320.63: Design OS secure storage, encryption, backup, account switching, logout, uninstall, schema migration, and retention for local databases, caches, files, credentials, and PII. Do not put secrets in bundles, plaintext configuration, or logs, and include shared-device and offline use in the threat model.
- Rule 320.64: Assign responsibilities and continuity routes for frontend or web, native code, IPC, packaging, signing, release, security, and endpoint management, and bind them to one accountable product owner. Small teams may combine duties, but document enterprise distribution, MDM, proxies, certificates, least-privilege installation, support desks, and offboarding only where the scope requires them.

---

## §17. Query, Transformation, Observability, and Infrastructure DSL Governance

- Rule 320.65: Treat query, formula, template, policy, workflow, and configuration DSLs as production languages when they influence production behavior, permissions, cost, alerts, data, or artifacts. Before first-class production adoption, record the dialect and evaluator, version and host product, source location and effective artifact, permissions, cost model, support authority, accountable owner and continuity route, positive and negative tests, and exit path. A file extension or product label alone does not establish semantics.
- Rule 320.66: For SQL dialects, GraphQL, Cypher, Gremlin, SPARQL, and equivalent query languages, define parameterization or injection defenses, authorization and tenant boundaries, query complexity or resource limits, pagination and result bounds, timeout and cancellation, index or execution-plan review, retry and consistency semantics, observability, and cost tests. GraphQL schema validation, database grants, graph traversal syntax, or endpoint authentication alone does not prove object-level authorization or bounded execution.
- Rule 320.67: For PromQL, LogQL, KQL, Flux, SIEM query languages, Rego, and equivalent observability or policy DSLs, version dashboards, recording rules, alerts, and policies; test representative true, false, missing-data, stale-data, and high-cardinality cases; and control label or field cardinality, PII exposure, scan volume, evaluation interval, retention, and query cost. Roll out alert and deny behavior in a staged, observable form with an owner and rollback or safe-disable path.
- Rule 320.68: For dbt SQL and Jinja, DAX, MDX, Power Query M, and equivalent transformation, semantic, or BI languages, record source and lineage, dialect or engine, model and measure ownership, data classification, row or object security, refresh and incremental semantics, timezone and locale, null and numeric behavior, compiled or effective output, historical fixtures, reconciliation, and rollback. A successful visual or dashboard refresh is not proof of correct business semantics.
- Rule 320.69: For Helm templates, Jinja, CUE, Jsonnet, Starlark, code generators, shader graphs, and other source-to-artifact systems, review both source and rendered or compiled artifacts. Pin the evaluator and dependencies, make input and merge precedence explicit, validate every production-relevant variant, scan the effective artifact for secrets and policy violations, and retain source-to-artifact provenance. Generated output that cannot be reproduced and reviewed is not release evidence.
- Rule 320.70: For Terraform or OpenTofu, Kubernetes manifests, Kustomize, Helm, Crossplane, Ansible, Puppet, Chef, Packer, Pulumi, CDK, and equivalent infrastructure or configuration languages, require parse or type validation, a reviewable plan or effective diff, security and policy checks, cost-impact analysis where applicable, state and lock safety, secret separation, dependency pinning, idempotency or convergence evidence, drift detection, staged rollout, and recovery or destroy boundaries. Treat plans, state, inventories, logs, and test-created resources as sensitive; a local render or validate command is not proof that provider credentials, live state, admission controls, or runtime behavior are safe.

---

## §18. Public Library, SDK, Package Distribution, and Compatibility Governance

Compatibility for a published package is not determined by a version string alone. The contract and failure mode depend on the language, compiler, runtime, linker or loader, package manager, registry, generator, and consumer combination. This section applies to libraries, SDKs, CLIs, plugins, native modules, and generated clients whose consumers update independently, including packages published only inside an organization.

| Compatibility surface | Representative breakage |
|:--|:--|
| Source | An existing consumer can no longer compile, type-check, import, or generate code |
| Binary or ABI | A consumer that was not rebuilt can no longer link, load, or start |
| Behavior or protocol | Signatures remain stable while results, errors, retries, ordering, performance, or network contracts change |
| Data or serialization | Stored data, wire formats, schemas, enums, precision, or migrations can no longer be read |
| Toolchain or platform | A change in the minimum compiler, runtime, SDK, OS, architecture, or package metadata makes a consumer unusable |
| Delivery | Package contents, dependencies, symbols, types, native binaries, signatures, or provenance differ across a release |

- Rule 320.71: Classify the public contract for every published library, SDK, package, CLI, plugin, native module, or generated client across the applicable source, binary or ABI, runtime link or load, behavioral, protocol, serialization or data, CLI or configuration, and toolchain or platform surfaces. Semantic Versioning or an ecosystem versioning convention communicates change intent but is not, by itself, proof of compatibility. State why a surface is not applicable, and inspect the symbols, types, metadata, generated code, errors, and side effects actually exposed in addition to the documented API.
- Rule 320.72: A support claim includes a consumer matrix for the minimum and current compiler, runtime, SDK, OS, architecture, package manager or metadata version, features, optional dependencies, and native dependencies. Based on risk and usage distribution, install, resolve, compile or type-check, link or load, execute, and package real consumers on the oldest supported and representative current combinations. Distinguish unsupported, best-effort, and community support from first-class support. Do not require the unconditional Cartesian product of all combinations; select the matrix using tiers, representative values, change impact, usage telemetry, or equivalent evidence.
- Rule 320.73: Combine ecosystem-appropriate API or ABI diffs, compilation of existing source consumers, load or execution of existing binary consumers, behavioral or protocol fixtures, serialization compatibility, and representative downstream consumers according to risk. Classify additive, deprecated, breaking, and security-exception changes. Bind breaking changes to a migration path, detectable deprecation, impact scope, release notes, and rollback or forward-fix. When a vulnerability requires a shortened compatibility window, retain residual-risk, mitigation, consumer-notification, and decision evidence.
- Rule 320.74: Build a release package once from the verified source revision and inspect its actual contents before publication. As applicable, verify package metadata, dependency constraints, licenses, notices, documentation, types or symbols, source maps or debug symbols, generated files, native binaries, and platform variants. Bind them to the source revision, toolchain, lock or resolution state, artifact digest, SBOM, and provenance. Do not promote environment-specific rebuilds as the same release; promote the same verified artifact, or a set with demonstrated content identity, across channels.
- Rule 320.75: Never overwrite or reuse a published package coordinate and version with different contents. Correct a defective release with a new version and, when necessary, discourage new adoption through ecosystem-native yank, unlist, deprecate, withdraw, or advisory mechanisms that preserve existing-consumer reproducibility where possible. Apply reviewable release authority, authentication that prefers short-lived or workload identities, namespace ownership, emergency revocation, account recovery, and audit to registry publication. Integrate concrete signing, SBOM, and provenance controls with `security/200_oss_compliance.md`.
- Rule 320.76: When generating multi-language SDKs from a schema or IDL, bind the version or digest of the schema, generator, templates, runtime library, handwritten extensions, and generation settings to release evidence. Separate generated and handwritten regions, and contract-test cross-language feature parity, version mapping, server or client compatibility windows, and shared behavior such as errors, pagination, retries, and authentication. Design publication order, partial-failure handling, retries, withdrawal, and server-feature enablement across registries; do not leave a partially published SDK set undetected.
- Rule 320.77: Separate stable, prerelease, preview, nightly, and equivalent channels so that expected stability, upgrade paths, support, retention, and consumer opt-in cannot be confused. Treat increases to the minimum compiler, runtime, OS, SDK, dependency, or package metadata version as potentially consumer-breaking even when the ecosystem does not label them major changes. Provide rationale, impact, the last compatible release, migration steps, notice, sunset, and rollback or forward-fix. Define support floors and deprecation windows as Blueprint parameters periodically re-evaluated against security, vendor EOL, usage distribution, regulation, and maintenance capacity rather than fixed universal durations.
- Rule 320.78: Claim enterprise support for a language, library, SDK, or package only when install, build, test, package, upgrade, and recovery are reproducible under a documented consumer matrix, and accountable ownership and continuity, registry namespace and access control, a security advisory path, release and incident runbooks, and decommission or transfer procedures exist. A small team may combine responsibilities, but personal accounts, credentials held only by departed staff, non-transferable namespaces, and undocumented knowledge held by one maintainer are not continuity paths. Verify ownership and consumer-notification routes during offboarding, team reorganization, repository transfer, and provider change.

---

## §19. Notebook and Literate Computational Artifact Governance

This section uses Jupyter or IPython, R Markdown or Quarto, managed notebooks, and Wolfram Notebook as reference examples, but it does not bind requirements to one product, file format, or language. It applies to Python, R, Julia, Scala, SQL, and other computational artifacts that combine code, narrative, queries, parameters, metadata, execution state, and rich outputs in one document or workspace. Listing a product does not guarantee support, and an equivalent capability may replace it.

- Rule 320.79: Classify a notebook or literate computational artifact as exploration, research, review or report, scheduled or production, or another explicit use profile. Record its owner, purpose, source of truth, kernel or runtime, inputs and outputs, data classification, execution authority, consumers, promotion, retention, and exit. A profile may scale rigor, but it never waives secret non-embedding, PII classification, ownership, or recoverability. Registration in a management console, a file extension, or a product name alone does not demonstrate production support.
- Rule 320.80: An artifact used for review or production decisions must cleanly execute from the beginning in a fresh isolated environment with declared parameters and inputs, without relying on memory from a prior session, out-of-order cells, hidden variables, manual UI actions, or undeclared local files. Make execution order, failed cells, timeouts, interrupts, kernel restarts, and partial outputs detectable. One successful run in an interactive workspace is not reproducibility evidence.
- Rule 320.81: Review a notebook as a compound artifact that includes not only code and markup source but also metadata, execution counts, saved outputs, attachments, widget state, checkpoints, and exports. Deterministically remove or normalize unnecessary outputs and volatile metadata. Separate required results from source or version them explicitly according to data classification, size, retention, and regeneration cost. Define a reviewable diff and source of truth; do not finish with review of generated exports alone, indiscriminate commits of large binary outputs, or manual edits to generated artifacts.
- Rule 320.82: Bind the source revision, notebook or document format, kernel, language, packages and system dependencies, container or image, locale and timezone, parameters, input-data version, schema, and lineage, random seeds, accelerator or hardware, execution time, and result according to risk. Do not universally require bitwise identity. For nondeterminism, external services, parallel computation, and floating-point effects, define tolerances, invariants, reference data, and retry policy before execution.
- Rule 320.83: Treat code, markup, queries, metadata, saved output, rich HTML or JavaScript, widgets, attachments, checkpoints, exported HTML or PDF, and workspace share links as independent untrusted surfaces. Do not embed credentials. Apply least-privilege execution identities and network, filesystem, and data boundaries, and scan source plus all derived artifacts for secrets, PII, and malicious content. A notebook signature, trust flag, or owner execution may establish saved-output integrity or display permission, but it does not establish code safety, data access, or consumer authorization.
- Rule 320.84: Combine applicable format validation, static analysis, linting, type or schema checks, unit tests for extracted logic, data-quality and contract tests, clean execution in a fresh environment, expected outputs, invariants or numerical tolerances, negative authorization, and secret or PII scanning according to risk. Bind a production promotion to reviewed source, immutable or content-addressable environment, dependency, and data references, an execution identity, approval, and execution result. UI rendering, manual cell-by-cell inspection, or export success alone cannot approve promotion.
- Rule 320.85: A scheduled or production notebook job must define an operating contract for parameter and input schemas, idempotency, concurrency, retries, checkpoint or resume, timeout and cancellation, resource and cost budgets, output destination and atomicity, partial failures, structured logs, metrics, lineage, alerts, and rollback or forward-fix. Include environment differences between the interactive kernel and production executor, queue wait, accelerators, external APIs, data scans, and saved-output retention in cost and capacity decisions. Do not leave indefinite sessions, unbounded retries, or orphaned schedules.
- Rule 320.86: In a team or managed workspace, define accountable ownership and continuity, the source-of-truth boundary between source control and the workspace, role, tenant, project, and folder access, data residency, share links and comments, merge conflicts, kernel or image ownership, schedules, secrets, audit, backup and export, retention, offboarding, and provider exit. A small team may combine roles, but personal workspaces, schedules or credentials owned only by departed staff, non-exportable outputs, and implicit cell order are not handoff paths. Periodically verify that another authorized principal can re-execute, stop, recover, and transfer the work in a fresh environment.

---

## Appendix A: Reverse Index and Cross-References

### Reverse index

| Keyword | Section |
|:--|:--|
| Language selection, Tech Radar, support tiers | §2, §3, §15 |
| Formatter, lint, types, tests | §4–§10 |
| TypeScript, JavaScript, HTML, CSS | §5 |
| Python, Java, Kotlin, C#, Go, Rust, PHP, Ruby, Lua, Perl, VBA, COBOL, PL/I, ABAP, Apex, Power Fx, JVM, .NET, BEAM, and functional languages | §6 |
| Swift, Dart, React Native, mobile, GDScript, games | §7 and §10 |
| SQL, R, Scala, Julia, MATLAB, Fortran, Mojo, SAS, Stata, scientific computing | §8 |
| SQL, R, Scala, data, AI | §8 |
| CUDA, HIP, SYCL, Triton, OpenCL, accelerator, GPU, numerical reproducibility | §8, §10 |
| Terraform, Dockerfile, Containerfile, Shell, PowerShell, YAML, Rego, build DSLs | §9 |
| Bicep, CloudFormation, ARM templates, cloud-native IaC | §9 |
| C, C++, FFI, memory safety, WebAssembly, WASI, WIT, WGSL, GLSL, HLSL, Metal Shading Language, SPIR-V, DXIL, eBPF, BTF, Solidity, Move, SystemVerilog, VHDL | §10 |
| Concurrency, errors, OpenTelemetry | §11 |
| OpenAPI, Protobuf, AsyncAPI, schemas | §12 |
| CODEOWNERS, Golden Paths, two-person review, exceptions | §13 |
| Monorepo, SBOM, SLSA, provenance | §14 |
| Migration, sunset, maturity | §15 |
| Framework, support matrix, plugins, upgrades, desktop, Electron, Tauri, .NET MAUI, Avalonia, Qt, Compose Desktop, IPC, signing, installers | §16 |
| GraphQL, Cypher, Gremlin, SPARQL, PromQL, LogQL, KQL, Flux, DAX, MDX, Power Query M, dbt, Jinja, query and semantic DSLs | §17 |
| OpenTofu, Kubernetes manifests, Helm, Kustomize, Crossplane, Ansible, Puppet, Chef, Packer, generated or effective artifacts | §9, §17 |
| Public libraries, SDKs, packages, source, binary, or behavioral compatibility, consumer matrices, immutable versions, generated SDKs, package ownership | §18 |
| Jupyter, R Markdown, Quarto, managed notebooks, literate programming, cell order, hidden state, clean execution, rich output, scheduled notebooks | §8, §19 |

### Cross-references

| Related file | Relationship |
|:--|:--|
| `engineering/000_engineering_standards.md` | Common engineering principles |
| `engineering/100_api_integration.md` | Synchronous APIs and schema-first design |
| `engineering/300_web_frontend.md` | Web and TypeScript-specific implementation |
| `engineering/400_mobile_flutter.md` | Flutter and Dart-specific implementation |
| `engineering/410_native_platforms.md` | Kotlin and Swift-specific implementation |
| `engineering/420_react_native.md` | React Native New Architecture, cross-language boundaries, both-OS quality, OTA, and enterprise team operation |
| `engineering/200_supabase_architecture.md` | Official and community support surfaces for Supabase client SDKs |
| `engineering/500_firebase_gcp.md` | Language surfaces for Firebase client and Admin SDKs plus Cloud Run buildpacks and containers |
| `engineering/520_cloud_application_platforms.md` | Managed-runtime, framework-adapter, service, and platform lifecycle |
| `engineering/740_data_contracts.md` | Data contracts across organizational and service boundaries |
| `ai/100_data_analytics.md` | Data and model lineage, reproducibility, ML operations, and analytics team governance |
| `quality/000_qa_testing.md` | Test strategy and CI quality gates |
| `security/000_security_privacy.md` | Secure coding and boundary protection |
| `security/200_oss_compliance.md` | Licensing, SCA, registry publication identity, immutable releases, SBOMs, provenance, and supply chain |
| `operations/400_site_reliability.md` | Runtime operations, SLOs, and observability |

### Primary references

- [GitHub Octoverse 2025](https://github.blog/news-insights/octoverse/octoverse-a-new-developer-joins-github-every-second-as-ai-leads-typescript-to-1/): adoption trends for major languages
- [Stack Overflow Developer Survey 2025](https://survey.stackoverflow.co/2025/technology#most-popular-technologies-language-prof): complementary data including professional-developer language use
- [Node.js Releases](https://nodejs.org/en/about/previous-releases), [Oracle Java SE Support Roadmap](https://www.oracle.com/java/technologies/java-se-support-roadmap.html), [.NET Support Policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), and [Python version status](https://devguide.python.org/versions/): runtime-specific LTS, support-window, and EOL decisions
- [Kotlin release process](https://kotlinlang.org/docs/releases.html), [Swift 6.3 Released](https://www.swift.org/blog/swift-6.3-released/), and [Dart changelog](https://dart.dev/changelog): release, security-support, and language-versioning decisions for mobile and multiplatform languages
- [Angular release schedule](https://angular.dev/reference/releases), [Spring Boot System Requirements](https://docs.spring.io/spring-boot/system-requirements.html), [Django release process](https://docs.djangoproject.com/en/dev/internals/release-process/), and [.NET and .NET Core Support Policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core): framework and runtime, compiler, and SDK support lifecycles, compatibility matrices, and upgrade decisions
- [Electron Security](https://www.electronjs.org/docs/latest/tutorial/security), [Tauri Capabilities](https://v2.tauri.app/security/capabilities/), and [Tauri Permissions](https://v2.tauri.app/security/permissions/): desktop webview, IPC, native-capability, navigation, and sandbox trust boundaries
- [.NET MAUI Support Policy](https://dotnet.microsoft.com/en-us/platform/support/policy/maui) and [Qt Supported Platforms](https://doc.qt.io/qt-6/supported-platforms.html): independent support cadences and OS, architecture, and compiler matrices for desktop and cross-platform frameworks
- [Go Release History](https://go.dev/doc/devel/release), [Rust Release Notes](https://doc.rust-lang.org/stable/releases.html), [PHP Supported Versions](https://www.php.net/supported-versions.php), and [Ruby branches](https://www.ruby-lang.org/en/downloads/branches/): support, security-fix, and EOL decisions for backend and systems languages
- [Semantic Versioning 2.0.0](https://semver.org/), [Go 1 and the Future of Go Programs](https://go.dev/doc/go1compat), and [Cargo SemVer Compatibility](https://doc.rust-lang.org/cargo/reference/semver.html): version expression, compatibility promises, and ecosystem-specific breaking-change classification
- [Java Language Specification §13](https://docs.oracle.com/javase/specs/jls/se26/html/jls-13.html), [.NET Breaking Change Rules](https://learn.microsoft.com/en-us/dotnet/standard/library-guidance/breaking-changes), and [Swift Library Evolution](https://www.swift.org/blog/library-evolution/): source, binary, and behavioral compatibility and library evolution
- [Python Core Metadata](https://packaging.python.org/en/latest/specifications/core-metadata/) and [Dart Package Versioning](https://dart.dev/tools/pub/versioning): consumer toolchain floors, immutable package versions, and compatibility metadata
- [Cargo Publishing](https://doc.rust-lang.org/cargo/reference/publishing.html), [Maven Central Publisher Registration](https://central.sonatype.org/register/central-portal/), and [GitHub Immutable Releases](https://docs.github.com/en/code-security/concepts/supply-chain-security/immutable-releases): version non-reuse, yanking and immutability, namespace ownership, and release-artifact integrity
- [NIST SP 800-218 SSDF](https://csrc.nist.gov/pubs/sp/800/218/final): high-level, outcome-oriented secure-development practices that do not mandate one SDLC implementation
- [RFC 2119](https://www.rfc-editor.org/info/rfc2119) and [RFC 8174](https://www.rfc-editor.org/info/rfc8174): BCP 14 guidance for careful and limited use of normative terms such as MUST
- [SLSA v1.2 Source requirements](https://slsa.dev/spec/v1.2/source-requirements) and [Verified Properties](https://slsa.dev/spec/v1.2/verified-properties): source levels, two-party review, VSA properties, and supply-chain assurance
- [GitHub CODEOWNERS](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners), [rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets), and [protected branches](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches), plus [GitLab approval rules](https://docs.gitlab.com/user/project/merge_requests/approvals/rules/): vendor-specific examples of ownership review and change control
- [CISA Secure by Design](https://www.cisa.gov/sites/default/files/2025-01/joint-guidance-product-security-bad-practices-508c_0.pdf) and [The Case for Memory Safe Roadmaps](https://www.cisa.gov/resources-tools/resources/case-memory-safe-roadmaps): product-security guidance covering memory-safe languages, executive accountability, phased migration, dependencies, and transparency
- [Go Security](https://go.dev/doc/security/), [Rust Clippy](https://doc.rust-lang.org/clippy/index.html), [Terraform style guide](https://developer.hashicorp.com/terraform/language/style), and [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html): official or maintainer-provided quality and operational baselines
- [TypeScript: JS Projects Utilizing TypeScript](https://www.typescriptlang.org/docs/handbook/intro-to-js-ts.html), [Type Checking JavaScript Files](https://www.typescriptlang.org/docs/handbook/type-checking-javascript-files.html), and [JSDoc Reference](https://www.typescriptlang.org/docs/handbook/jsdoc-supported-types.html): official incremental type-analysis paths for production JavaScript without converting the source to TypeScript
- [Wasm 3.0 Completed](https://webassembly.org/news/2025-09-17-wasm-3.0/), [WebAssembly specifications](https://webassembly.org/specs/), [WASI releases](https://wasi.dev/releases), and [WASI security](https://wasi.dev/security): core-specification release, portable-artifact, component-interface, version, runtime, and capability-boundary decisions
- [Bicep overview](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview) and [CloudFormation best practices](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/best-practices.html): cloud-native declarative IaC validation, change preview, ownership, policy, drift, and rollback controls
- [Docker build best practices](https://docs.docker.com/build/building/best-practices/), [Docker build secrets](https://docs.docker.com/build/building/secrets/), and [Bazel hermeticity](https://bazel.build/basics/hermeticity): pinning, secret separation, reproducibility, and host isolation for container and build definitions
- [Microsoft .NET package audit](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-package-list), [uv CLI](https://docs.astral.sh/uv/reference/cli/), [Bun lockfile](https://bun.com/docs/pm/lockfile), and [renv](https://rstudio.github.io/renv/): ecosystem-specific reproducibility and dependency auditing
- [Dart package dependencies](https://dart.dev/tools/pub/dependencies#lockfiles), [Dart Pub security advisories](https://dart.dev/tools/pub/security-advisories), and [Terraform dependency lock file](https://developer.hashicorp.com/terraform/language/files/dependency-lock): dependency pinning and audit boundaries that differ between applications and publishable libraries, and between providers and modules
- [Microsoft 365 Apps macro security](https://learn.microsoft.com/en-us/microsoft-365-apps/security/internet-macros-blocked): blocking, signing, trusted-publisher, and centralized-control guidance for VBA macros
- [Lua 5.4 Reference Manual](https://www.lua.org/manual/5.4/manual.html), [Perl security](https://perldoc.perl.org/perlsec), [Carton](https://github.com/perl-carton/carton), and [CPAN Audit](https://github.com/briandfoy/cpan-audit): execution boundaries, reproducibility, and dependency auditing for conditional languages
- [SAP ABAP Keyword Documentation](https://help.sap.com/doc/abapdocu_latest_index_htm/latest/en-US/index.htm) and [Salesforce Apex Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/): official constraints and test boundaries for enterprise-platform languages
- [Julia Code Loading](https://docs.julialang.org/en/v1/manual/code-loading/), [MATLAB Analyze Project Dependencies](https://www.mathworks.com/help/matlab/matlab_prog/analyze-project-dependencies.html), [Fortran Package Manager manifest specification](https://fpm.fortran-lang.org/spec/manifest.html), and [Mojo roadmap](https://docs.modular.com/mojo/roadmap/): environment, dependency, toolchain, and stability boundaries for scientific and HPC languages
- [Solidity Security Considerations](https://docs.soliditylang.org/en/latest/security-considerations.html): smart-contract-specific safety and verification boundaries; use the adopted chain's official specification as final authority for Move, Cairo, and similar languages
- [Accellera Standards](https://www.accellera.org/downloads/standards) and [IEEE VHDL](https://standards.ieee.org/ieee/1076/12535/): hardware-description-language and verification standards
- [CUDA Programming Guide](https://docs.nvidia.com/cuda/cuda-programming-guide/), [CUDA C++ Best Practices Guide](https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/), [HIP programming model](https://rocm.docs.amd.com/projects/HIP/en/latest/how-to/programming_manual.html), [SYCL Registry](https://registry.khronos.org/SYCL/), [OpenCL Registry](https://registry.khronos.org/OpenCL/), and [Triton documentation](https://triton-lang.org/main/): execution models, device and backend compatibility, numerical verification, and kernel-DSL decisions for heterogeneous compute
- [W3C WGSL](https://www.w3.org/TR/WGSL/), [Khronos SPIR-V Registry](https://registry.khronos.org/SPIR-V/), [Microsoft HLSL Reference](https://learn.microsoft.com/en-us/windows/win32/direct3dhlsl/dx-graphics-hlsl-reference), and [Apple Metal Resources](https://developer.apple.com/metal/resources/): shader-language, feature-set, validation, and intermediate- or final-artifact decisions
- [Linux eBPF verifier](https://docs.kernel.org/bpf/verifier.html), [BPF Type Format](https://docs.kernel.org/bpf/btf.html), [libbpf CO-RE overview](https://docs.kernel.org/bpf/libbpf/libbpf_overview.html), and [BPF licensing](https://docs.kernel.org/bpf/bpf_licensing.html): privileged-program verification, kernel portability, ELF and BTF, helper, and license boundaries
- [GraphQL September 2025 Specification](https://spec.graphql.org/September2025/), [SPARQL 1.1 Query Language](https://www.w3.org/TR/sparql11-query/), and [Prometheus Querying Basics](https://prometheus.io/docs/prometheus/latest/querying/basics/): query semantics, validation, graph patterns, time-series selectors, and engine-specific execution boundaries
- [dbt SQL models](https://docs.getdbt.com/docs/build/sql-models), [DAX overview](https://learn.microsoft.com/en-us/dax/dax-overview), and [Power Query M language specification](https://learn.microsoft.com/en-us/powerquery-m/power-query-m-language-specification): source-to-effective SQL, model DAGs, semantic expressions, transformation evaluation, and host-engine boundaries
- [OpenTofu plan](https://opentofu.org/docs/cli/commands/plan/), [validate](https://opentofu.org/docs/cli/commands/validate/), and [test](https://opentofu.org/docs/cli/commands/test/), [Kubernetes declarative object management](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/declarative-config/), [Kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/), and [Helm chart templates](https://helm.sh/docs/chart_template_guide/getting_started/): plan sensitivity, offline validation limits, live-resource test risk, declarative drift, overlays, and rendered-artifact review
- [Jupyter Notebook format](https://nbformat.readthedocs.io/en/latest/format_description.html), [Jupyter notebook document security](https://jupyter-notebook.readthedocs.io/en/v6.5.2/security.html), and [nbclient execution](https://nbclient.readthedocs.io/en/latest/client.html): the structure and verification of executable artifacts containing code, metadata, saved rich outputs, trust boundaries, kernels, and timeouts
- [Quarto execution management](https://quarto.org/docs/projects/code-execution.html), [Papermill parameterization](https://papermill.readthedocs.io/en/latest/usage-parameterize.html), and [Vertex AI notebook execution](https://cloud.google.com/vertex-ai/docs/workbench/instances/schedule-notebook-run-quickstart): reference implementations for computational-document re-execution, parameter contracts, and managed scheduled execution
- Use each language's official style, security, and toolchain documentation as the final authority during adoption
