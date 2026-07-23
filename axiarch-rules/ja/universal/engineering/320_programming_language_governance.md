# 320. プログラミング言語ガバナンス

> [!CAUTION]
> このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。
> 改定日: 2026-07-23

> [!IMPORTANT]
> 主要方針: 言語選定は流行や個人の好みではなく、業務適合性、安全性、運用能力、採用可能性、退出可能性で決める。共通品質契約を維持しつつ、命名、formatter、型、build、testは各言語の公式・事実上標準の慣習を優先する。
> 19セクション構成、Rule 320.1–320.86。

---

## 目次

| セクション | トピック |
|:--|:--|
| §1 | 適用範囲と優先順位 |
| §2 | 言語ポートフォリオと支持区分 |
| §3 | 新言語採用契約 |
| §4 | 全言語共通の品質契約 |
| §5 | Web・UI言語プロファイル |
| §6 | バックエンド・業務自動化言語プロファイル |
| §7 | モバイル・クライアント言語プロファイル |
| §8 | データ・AI言語プロファイル |
| §9 | インフラ・運用言語プロファイル |
| §10 | システム・組み込み・アクセラレータ言語プロファイル |
| §11 | 並行処理、エラー、可観測性 |
| §12 | 言語間境界と契約 |
| §13 | チーム・企業ガバナンス |
| §14 | ポリグロットCI、供給網、再現性 |
| §15 | 例外、移行、廃止、成熟度 |
| §16 | フレームワーク・デスクトップアプリケーション統治 |
| §17 | クエリ・変換・監視・インフラDSL統治 |
| §18 | 公開ライブラリ・SDK・パッケージ配布と互換性統治 |
| §19 | Notebook・literate computational artifact統治 |
| Appendix A | 逆引き索引とクロスリファレンス |

---

## §1. 適用範囲と優先順位

- Rule 320.1: 本ファイルは、プログラミング言語、クエリ言語、IaC言語、運用スクリプト、container／build／configuration定義の選定と横断品質の正本である。
- Rule 320.2: フレームワークやプラットフォーム固有の詳細は、`300_web_frontend.md`、`400_mobile_flutter.md`、`410_native_platforms.md`、`420_react_native.md`、クラウド別正本を優先する。
- Rule 320.3: 汎用規則と公式言語慣習が衝突するときは、安全性と既存プロジェクト規約を損なわない範囲で言語ネイティブ規約を優先する。全ファイルへの一律 `kebab-case` 適用は禁止する。
- Rule 320.4: MUST／必須は相互運用性、安全性、法令・契約、回復不能な損害を避ける最低成果に限定し、SHOULD／推奨は通常の既定、MAY／任意は選択可能な強化を表す。特定の実装方法を強制しなくても成果を保証できる場合、方法ではなく検証可能な成果を規定する。プロジェクトはより厳格なBlueprintを定義してよい。
- Rule 320.5: 言語の人気だけで採用しない。既存資産、運用者、規制、性能、安全性、ライブラリエコシステム、採用市場、ベンダーロックイン、廃止費用を同時評価する。

### 1.1 Universal適用契約

本ファイルの全節は、次の4層として解釈する。この契約は、後続節の表、数値、製品名、組織名、repository例より優先する。

| 層 | 意味 | Universalでの扱い |
|:--|:--|:--|
| 不変成果 | 安全性、再現性、相互運用性、所有、検証、退出可能性 | 規範要件。実装手段は限定しない |
| ecosystem-native基線 | 公式toolchain、support policy、package／build慣習 | 該当ecosystem内の既定。公式制約と互換性に従う |
| 参考実装 | vendor、製品、file path、command、repository layout、組織名 | 非規範の例。同等能力へ置換可能 |
| Blueprint parameter | 人数、期限、頻度、閾値、support範囲、承認段階 | リスク、規模、規制、利用者影響に基づきProject Blueprintで決定 |

- vendor名、hosted service名、VCS機能名、dashboard名、team名を、唯一の適合手段として扱わない。公式platform制約、相互運用規格、または具体的な安全上の理由がある場合だけ固有手段を要求できる。
- 個人開発、小規模team、複数team、規制対象企業のすべてに同じ人数と組織図を強制しない。必要な責務を定義し、複数責務を同一人物または同一teamが兼務できるかをriskで判断する。高保証変更では、可能な限り提案と承認を分離し、分離できない場合は明示的なrisk acceptanceと独立したrelease統制を置く。
- Pull Request、Merge Request、CODEOWNERS、ruleset、merge queue、Golden Path、dashboard等は能力の代表例である。代替VCS、変更承認、ownership registry、serialized integration、scaffold、report／queryが同じ成果と証跡を満たせば適合する。

## §2. 言語ポートフォリオと支持区分

### 2.1 支持区分

| 区分 | 意味 | 必須条件 |
|:--|:--|:--|
| 標準 | 新規採用の既定候補 | 再利用可能な導入経路、accountable ownerと継続経路、risk-basedな自動品質gate、SCA、SBOM、運用runbook |
| 対応 | 既存資産または明確な適合性がある | accountable owner、検証可能な変更gate、依存解決証跡、脆弱性対応、退出計画 |
| 制限 | 高リスク、特殊用途、縮小対象 | ADR、期限付き例外、追加レビュー、代替評価 |
| 実験 | PoCまたは限定検証 | production禁止または明示承認、隔離、終了日 |
| 廃止 | 新規利用禁止 | 移行計画、利用箇所台帳、削除期限 |

### 2.2 領域別の第一級プロファイル

| 領域 | 第一級プロファイル | 条件付きプロファイル |
|:--|:--|:--|
| Web・UI | TypeScript、JavaScript、HTML、CSS | WebAssemblyターゲットのRust、Kotlin、Swift等 |
| バックエンド | TypeScript／JavaScript（Node.js）、Python、Java、Kotlin、C#/.NET、Go、Rust、PHP、Ruby | Deno／Bun runtime、Scala、Elixir／Erlang／Gleam、Clojure／その他Lisp系、Groovy、F#、OCaml／Haskell、Prolog、Lua、Perl、COBOL、PL/I、その他JVM・.NET・BEAM言語 |
| 業務自動化・enterprise platform | C#/.NET、Python、PowerShell | VBA、Visual Basic .NET、Delphi/Object Pascal、ABAP、Apex、Power Fx、PL/SQL／T-SQL等のdatabase手続き言語 |
| モバイル | Swift、Kotlin、Dart、React Native framework（TypeScript／JavaScript + Swift／Kotlin） | Objective-C、Java、Kotlin Multiplatform、その他cross-platform framework |
| デスクトップ | target OSのplatform-native UI stack、採用済みの保守可能なcross-platform framework | Electron、Tauri、.NET MAUI／Avalonia、Qt、Compose Multiplatform／Desktop、Flutter desktop、SwiftUI／AppKit、WinUI／WPF、GTK等 |
| ゲーム・リアルタイムclient | C#/.NET、C++ | GDScript、Lua、Rust、engine固有script |
| データ・AI・科学技術計算 | Python、SQL、R、Scala | Julia、MATLAB、Fortran、Mojo、SAS、Stata、JVM・.NETデータ処理 |
| クエリ・意味model・可観測性 | SQL、GraphQL、PromQL等の採用engine固有DSL | Cypher、Gremlin、SPARQL、LogQL、KQL、Flux、DAX、MDX、Power Query M、dbt／Jinja等 |
| accelerator・GPU計算 | CUDA C++、HIP C++、SYCL C++ | Triton、OpenCL C、vendor・framework固有kernel DSL |
| graphics・shader | WGSL、GLSL、HLSL、Metal Shading Language | engine固有shader DSL、sourceを生成するshader graph |
| インフラ・運用 | HCL/Terraform／OpenTofu、Dockerfile/Containerfile、Shell、PowerShell、YAML、Rego | Kubernetes manifest、Helm／Kustomize／Crossplane、Bicep、CloudFormation／ARM等のcloud-native宣言形式、Ansible／Puppet／Chef、Packer、Make／CMake、Bazel／Starlark、Nix、CUE／Jsonnet、Pulumi/CDKの汎用言語 |
| システム・組み込み | Rust、C、C++ | Zig、Ada/SPARK、Assembly、Lua、MicroPython、Embedded Swift、Kotlin/Native |
| kernel拡張・packet処理・observability | C、Rust | eBPF成果物、platform固有filter／packet DSL |
| smart contract・分散台帳 | Solidity、Rust | Vyper、Move、Cairo、chain固有言語 |
| hardware・programmable logic | SystemVerilog／Verilog、VHDL | Chisel／Scala、Bluespec、HLS向けC／C++ |

ゲームengine内のC#、C++、GDScript、Lua等も§4、§10、§12の品質と境界契約を継承する。engine、export template、platform SDK、asset build、native pluginを一つの互換性台帳でpinし、editor上の動作だけでrelease artifactを承認しない。

vendor platform言語、smart contract言語、hardware記述言語も§3、§4、§12、§14を継承する。platform固有のtransport／package、test network、simulator／synthesis、hardware検証、upgrade authority、artifact provenance、退出可能性を採用契約へ追加し、表への掲載を無条件の採用推奨と解釈しない。

- Rule 320.6: 条件付きまたは未掲載言語を禁止しない。§3の採用契約を満たしてBlueprintへ記録すれば利用できる。
- Rule 320.7: 同じ責務を複数言語で重複実装する場合、明確な性能・規制・プラットフォーム上の根拠が必要である。

## §3. 新言語採用契約

新しい言語またはランタイムをproductionへ導入する前に、次をADRと機械可読なLanguage Portfolio Recordへ記録する。

| 項目 | 必須内容 |
|:--|:--|
| 業務適合性 | 解決する責務、既存言語では不十分な理由、期待効果 |
| 所有権 | accountable owner、継続・代替経路、変更review、運用・オンコール責任。人、役割、team、外部保守契約のいずれでもよい |
| サポート | 対応版、LTS方針、更新頻度、EOL監視 |
| ツール | formatterまたは決定的なstyle enforcement、linter、型検査またはcompiler、test、SAST、SCA、SBOM。非該当項目は理由と代替統制 |
| 再現性 | runtime・compiler・platform releaseの固定または対応範囲、依存解決証跡、wrapper、hermeticまたは再現可能build方針 |
| 運用 | logging、metrics、tracing、profiling、debug、incident runbook |
| 境界 | API・event・schema・FFI契約、互換性方針 |
| リスク | メモリ安全性、並行処理、供給網、ライセンス、採用・教育コスト |
| 退出 | 廃止条件、データ・API移行、成果物保持、想定費用 |

機械可読な台帳の最低形:

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

台帳schemaは自動検証し、未知の支持区分、accountable ownerまたは継続経路の欠落、EOL超過、期限切れreview、必須gateまたは証跡参照の欠落を変更受入またはreleaseのblockerにする。`primary`と`secondary`はschema互換名であり、必ずしも別人を意味しない。高保証領域だけ独立承認を要求する。team名やtool名を自由文の表だけへ閉じ込めず、同じ台帳からreport、query、EOL通知を生成できるようにする。

- Rule 320.8: production言語にはaccountable ownerと、休暇、退職、障害、契約終了時にも保守を継続できる経路を割り当てる。別人の副担当は推奨されるが一律必須ではなく、単独保守では文書、復旧手順、credential continuity、外部支援または退出計画でkey-person riskを扱う。
- Rule 320.9: 標準区分は、新規利用者が再現可能に導入し、品質gate、release、rollback、運用へ到達できる導入経路を持つ。Golden Pathやscaffoldはその実装例であり、作成期限は採用riskとdelivery計画からBlueprintで定める。
- Rule 320.10: 採用判断は初期仮説を検証できる時点で再評価し、その後はsupport終了、重大脆弱性、採用能力低下、規制変更、重大incident等のeventと、Blueprintで定めたrisk-based cadenceで確認する。6か月後・年次reviewは参考既定であり固定義務ではない。

## §4. 全言語共通の品質契約

productionコードは、言語にかかわらず次を満たす。

1. runtime、compiler、主要toolchainを機械可読にpinする。SaaSやenterprise platformのように採用側がruntimeをpinできない場合は、対象platform／API release、互換範囲、変更通知、再検証条件を記録する。
2. 公式または広く採用されたformatterがある場合はCIで検証する。formatterを提供しないecosystemでは、決定的なpretty-printer、style lint、compiler check、正規化されたtext export、または明文化したreview gateから同等のstyle drift検出を選び、非該当理由を台帳化する。
3. linter、型検査、compiler警告、静的解析から、言語、成果物、threat modelに適用できる相補的なレイヤーを有効化する。重複toolを数だけ増やすことや、対象ecosystemで利用不能なレイヤーを要求しない。
4. 新規または変更起因の警告を失敗として扱う。既存baselineから段階導入する場合は、総数を増やさず、削減ownerと期限を持つ。抑制は最小行範囲、理由、owner、Issue、期限を必須とする。
5. unit、integration、contractをリスクに応じて持ち、外部境界と失敗系を検証する。
6. deploy可能なapplicationと実行rootは、ecosystemがlockfileを提供する場合はcommitしてfrozen／locked installを使う。lockfileが存在しない、または完全な解決snapshotではないecosystemでは、checksum、vendor tree、resolved graph、platform package version、artifact digest等の同等な依存解決証跡を保持する。公開libraryはconsumer互換性慣行に従い、CIのtest／release解決を固定する。
7. 直接依存と推移依存をSCAし、成果物単位のSBOMを生成する。
8. release成果物を同一source revisionへ結び付け、provenanceと署名を検証可能にする。
9. debug用出力、未処理例外、秘密情報、無期限TODOをreleaseへ含めない。
10. 公開APIと運用手順を文書化し、コード例を可能な範囲で実行検証する。

- Rule 320.11: 特定ツール名または品質レイヤーを対象ecosystemで利用できない場合、同等の失敗検出能力または非該当理由と補償統制をBlueprintへ記録する。存在しないtoolを形式的に要求せず、検出すべきriskを無言で省略しない。
- Rule 320.12: 動的型言語では、外部入力境界のruntime schema検証と、利用可能な型解析を併用する。
- Rule 320.13: 静的型言語でも、JSON、DB、message、CLI、environment等の外部入力を信頼せずruntime検証する。

## §5. Web・UI言語プロファイル

| 言語 | 標準 | 必須ゲート |
|:--|:--|:--|
| TypeScript | 新規アプリの既定。`strict`と境界schemaを使用 | formatter、ESLint等、`tsc --noEmit`、unit・integration・E2E、依存監査、production build |
| JavaScript | ecosystem、library、runtime、配布形式、段階移行等の制約または記録済み採用判断がある場合の正規profile。legacy、設定、短いscriptにも適用 | formatter、lint、`checkJs`／`@ts-check`とJSDoc等の利用可能な型解析、外部境界のruntime schema、test、依存監査 |
| HTML / CSS | semantic UIとstyleの第一級profile。framework生成物も対象 | formatter、HTML validation、Stylelint等、a11y、responsive・cross-browser、production artifact検証 |

- Rule 320.14: TypeScriptでは `strict` を基線とし、`noUncheckedIndexedAccess` と `exactOptionalPropertyTypes` を新規プロジェクトでSHOULDとする。
- Rule 320.15: `any`、`@ts-ignore`、lint disableは恒久解決にしない。`unknown`、narrowing、明示schemaを優先する。
- Rule 320.16: framework固有のレンダリング、accessibility、bundle、browser検証は `300_web_frontend.md` を正本とする。
- Rule 320.17: frontendとbackendが異なる言語でも、生成された契約型またはschemaを介し、手作業でDTOを複製しない。

## §6. バックエンド・業務自動化言語プロファイル

| 言語 | 主要用途 | 基準ツールチェーン例 |
|:--|:--|:--|
| TypeScript / JavaScript（Node.js） | API、BFF、real-time、serverless、automation | Active / Maintenance LTS runtime pin、package manager pinとlockfile、TypeScript `strict`または`checkJs`／JSDoc、formatter、ESLint等、unit・integration・contract、依存監査、production build |
| Python | API、AI/ML、automation、data | `pyproject.toml`、uv等のlock、Ruff、Pyrightまたはmypy、pytest、pip-audit |
| Java / Kotlin | 大規模業務、JVMサービス、Android共通層 | JDK LTS、Gradle/Maven wrapper、formatter、Error Prone・SpotBugs・detekt等、test、依存監査 |
| C# / .NET | 企業業務、Azure、ゲーム、cross-platform service | SDK pin、nullable有効、analyzers、warnings-as-errors、`dotnet format`、build、test、package監査 |
| Go | network service、platform、CLI | `gofmt`、`go vet`、Staticcheck、`go test -race`、fuzz、`govulncheck` |
| Rust | 高信頼service、systems、Wasm、性能重要処理 | `rustfmt`、Clippy、test、`cargo audit`または`cargo deny`、unsafe台帳 |
| PHP | Web、CMS、既存業務 | Composer lock、PSR-12準拠formatter、PHPStanまたはPsalm、PHPUnit/Pest、`composer audit` |
| Ruby | Rails、業務Web、automation | Bundler lock、RuboCop、RBS/SteepまたはSorbet、RSpec/Minitest、bundler-audit、RailsではBrakeman |
| Scala／Groovy／Clojure等のJVM言語 | JVM service、data processing、build／automation、既存portfolio | JDKとcompiler pin、sbt／Gradle／Leiningen／Clojure CLI等のwrapperまたは解決証跡、ecosystem-native formatter／lint／static analysis、test、JVM dependency監査 |
| Elixir／Erlang／Gleam等のBEAM言語 | concurrent service、messaging、distributed system | OTP・compiler・build tool pin、`mix.lock`／`rebar.lock`等、formatter、Dialyzerまたは言語native type check、test、release artifact、cluster／upgrade test、Hex dependency監査 |
| F#／OCaml／Haskell等の関数型言語 | domain modeling、compiler／tooling、高信頼service | runtime・compiler・package manager pin、lockまたはresolved graph、formatter、compiler warning／lint、property-basedを含むrisk-based test、FFI境界、dependency監査 |
| Lua / Perl | 組み込み拡張、automation、既存service | runtime pin、StyLua・LuacheckまたはPerl::Tidy・Perl::Critic、BustedまたはTest2 / prove、解決済み依存台帳、SCA |
| VBA | Office業務自動化、既存の重要spreadsheet | Office版pin、`Option Explicit`、text moduleのversion管理、compile・lint・test、署名済みmacro、管理されたtrusted publisher |
| COBOL／PL/I／Visual Basic .NET／Delphi等 | mainframe、Windows、長期運用されるenterprise資産 | compiler・runtime・target platform pin、copybook／interface／binary encoding契約、source管理、利用可能な静的解析、unit・integration・batch reconciliation、dependency／vendor support、移行または限定保守計画 |
| ABAP／Apex／Power Fx／database手続き言語 | SAP、Salesforce、low-code platform、databaseに結合した業務処理 | platform・runtime版またはrelease channel、text／metadata export、利用可能なformatter／静的解析、unit・integration、認可、transport／deploy検証、変更台帳、退出計画 |

Node.jsのproduction serviceはActive LTSまたはMaintenance LTSだけを使い、event loopをblockする同期I/O・長時間CPU処理をrequest pathへ置かない。外部I/Oにはtimeoutと`AbortSignal`等のcancellation、queue上限、backpressure、graceful shutdownを定義する。DenoまたはBunをserver runtimeとして採用する場合は、Node.js互換性、native addon、observability、security advisory、deployment platform、lockfile／SBOMを採用契約で実証し、Node.jsと同一runtimeとして暗黙に扱わない。

- Rule 320.18: Pythonは`pyproject.toml`を設定正本とし、未信頼データへの`pickle`、`eval`、`shell=True`を禁止する。async処理はtimeout、cancellation、structured concurrencyを設計する。
- Rule 320.19: JVMと.NETはLTSまたは組織が明示したサポート版を使用し、wrapperまたはglobal configurationでCIとlocalのSDKを一致させる。
- Rule 320.20: Goはgoroutineのowner、停止条件、`context`伝播を明記し、race detectorと`govulncheck`をCIへ含める。
- Rule 320.21: Rustの`unsafe`は最小moduleへ隔離し、各blockの安全条件、不変条件、review owner、testまたはfuzz証跡を記録する。Clippyのrestriction群を一括有効化せず、価値のあるlintを選定する。
- Rule 320.22: PHP、Ruby、Lua、Perl等の動的言語はruntime schemaまたは明示的allowlist、利用可能な静的解析、言語・framework固有security scannerを明示し、動的性を理由に型・境界検証を省略しない。VBAは新規systemの既定にせず、binary文書だけを正本にしない。exportしたtext module、Office / reference manifest、署名済み配布artifactを結び付ける。

## §7. モバイル・クライアント言語プロファイル

- Rule 320.23: SwiftとKotlinの詳細は `410_native_platforms.md`、Dartは `400_mobile_flutter.md`、React Nativeは `420_react_native.md` を正本とする。React Nativeは言語ではなく、TypeScript／JavaScript層とSwift／Kotlin native層を結ぶframeworkとして扱う。
- Rule 320.24: SwiftはStrict Concurrency、Sendable、Actor分離、SwiftLint/SwiftFormat、Swift TestingまたはXCTestを適用する。
- Rule 320.25: Kotlinはnull安全、構造化coroutine、ktlint、detekt、compiler warnings-as-errors、JUnit等を適用する。
- Rule 320.26: Dartはnull安全、`dart format`、`dart analyze --fatal-infos`、unit・widget・integration testを適用する。
- Rule 320.27: Objective-CまたはJavaの新規モバイル実装は、OS API、vendor SDK、既存資産、互換性、検証済み保守能力等の根拠を記録する。採用判断は、Swift／Kotlinへの段階移行、相互運用を伴う限定保守、または期限とsupport条件を持つ継続profileのいずれかを明示し、一律の書換えによるregressionと無期限の放置をともに避ける。

React Nativeのapp codeは§5のTypeScript／JavaScript品質を継承し、native moduleはSwift／Kotlinのowner、Codegen contract、iOS／Android build、device test、runtime-compatible OTA統制を追加する。JSだけのgateでmobile releaseを承認してはならない。

## §8. データ・AI言語プロファイル

| 言語 | 必須事項 |
|:--|:--|
| SQL | dialectとDB版のpin、formatter/lint、parameterized query、migration dry-run、schema diff、integration test、重要queryの`EXPLAIN` |
| Python | §6に加え、データ・モデル・乱数seed・environmentの再現性、型付きdataframeまたはschema検証 |
| R | `renv.lock`、styler、lintr、testthat、`R CMD check`、seedとsession情報 |
| Scala | JDK・Scala版pin、sbt/Scala CLI lock方針、scalafmt、scalafix、test、依存監査 |
| Julia | Julia版、`Project.toml`と用途に応じた`Manifest.toml`、formatter／lint、test、seed、artifact・binary dependency、precompile／sysimage互換性 |
| MATLAB | MATLAB releaseとtoolbox／license台帳、Projectまたはpath正本、Dependency Analyzer、Code Analyzer、unit test、code generation／compiled artifactのtarget互換性 |
| Fortran | compiler・language standard・target architecture pin、fpm manifestまたは同等build graph、formatter／compiler warning／static analysis、numerical regression、MPI／OpenMP／BLAS等のABI・runtime matrix |
| Mojo | compiler・package版とlock、formatter、warnings-as-errors、test、Python／C／C++ interoperability境界、target hardware。長期versioningとstabilityが確立するまでは実験または制限profileを既定とする |
| SAS／Stata等 | product release、module／license、text sourceとdataset schema、batch実行、log warning／error gate、deterministic seed、statistical regression、export／exit path |

科学技術計算では、bitwise一致を一律に要求せず、algorithm、precision、compiler optimization、hardware、parallel reductionに応じた許容誤差、invariant、reference datasetを先に定義する。proprietary runtimeはlicense server、headless CI、長期再現性、support終了、成果物の読出し可能性を採用契約へ含める。

- Rule 320.28: notebookはstatefulな実行可能documentである。exploration、research、review／report、scheduled／productionの用途profileを明示し、§19を継承する。再利用するdomain logicは可能な範囲でtest可能なpackage／moduleへ抽出し、production notebookはclean execution、immutableなenvironment／data参照、運用契約を満たす。
- Rule 320.29: data pipelineはschema、freshness、completeness、lineage、PII分類、backfill手順をコードと同じ変更で更新する。
- Rule 320.30: SQLのmigration、権限、RLS、データ保持はDB正本とsecurityルールを優先する。

custom accelerator kernelまたはframeworkが生成するdevice artifactを含むdata／AI workloadは、§10のaccelerator契約も継承する。kernel sourceを直接所有しない場合も、release挙動へ影響するcompiler、runtime、driver、target device、生成済みartifactとfallbackを互換性台帳から除外しない。

## §9. インフラ・運用言語プロファイル

| 言語・形式 | 必須ゲート |
|:--|:--|
| HCL / Terraform | `terraform fmt -check`、`validate`、TFLint、security/policy scan、`terraform test`または同等、machine-readable plan検証 |
| Bicep／cloud-native宣言形式 | 対象cloud API／toolchain pin、formatterまたはstyle lint、compiler／schema／template validation、what-if／change set等のmachine-readable変更preview、security／policy scan、module／template source固定、drift検出、rollback検証。Bicep、ARM template、CloudFormation／SAMは交換可能な例であり、異なるstate modelを同一視しない |
| Dockerfile / Containerfile | parserとbuild check、lint、信頼できる最小base imageのdigest pin、multi-stage、非root実行、build secret mount、image test／scan、SBOM、provenance |
| Shell | `shfmt`、ShellCheck、Bats/ShellSpec、`set -euo pipefail`の適用可否判断、引用、cleanup trap |
| PowerShell | PSScriptAnalyzer、Pester、StrictMode、`-ErrorAction Stop`、cross-platform matrixまたはWindows固定宣言 |
| YAML | schema検証、lint、参照先toolのdry-run/validate、秘密情報scan |
| Rego / Policy as Code | formatter、unit test、allowとdenyの両テスト、bundle/version pin |
| Make／CMake、Bazel／Starlark、Nix、CUE／Jsonnet等 | toolchain pin、formatter／lint、build graphまたはschema検証、test、host依存とnetwork accessの明示、hermetic／reproducible build検証、cache trust boundary |

- Rule 320.31: Shellは小さなutilityまたはwrapperに限定する。保守者が安全に追跡できない複雑な状態、並行処理、構造化データ変換、または増加し続ける規模へ達した場合は、Python、Go、Rust、PowerShell等への移行を評価する。100行はGoogle Shell Style Guide由来の参考ヒューリスティックであり、Universalの固定適合閾値ではない。
- Rule 320.32: Terraform planの目視だけを合格条件にしない。削除、置換、権限拡大、public exposure、費用急増を機械検出する。
- Rule 320.33: IaC、workflow、policyの変更にもownership control、test、reviewまたは同等の変更承認、roll back手順を適用する。CODEOWNERSはownership controlの一例である。

## §10. システム・組み込み・アクセラレータ言語プロファイル

| 言語 | 必須ゲート |
|:--|:--|
| Rust | §6に加え、unsafe/FFI境界、Miriまたはsanitizer適用判断、fuzz、MSRV方針 |
| C / C++ | formatter、`clang-tidy`等、compiler警告、ASan/UBSan、必要時TSan/MSan、unit/integration、fuzz、dependency/SBOM |
| Zig等 | 採用契約、toolchain pin、formatter、test、C ABI境界、供給網と長期サポート評価 |
| WebAssembly／WASI成果物 | source言語のgateに加え、compiler・runtime・Wasm／WASI／WIT version pin、module／component validation、interface・host compatibility test、capability allowlist、resource limit、対象browser／runtime matrix、source SBOMと最終binary digestを結ぶprovenance |
| CUDA C++／HIP C++／SYCL C++／Triton／OpenCL C等のaccelerator source・成果物 | host・device compiler、runtime、driver、API、device architecture、backendの互換性をpin。対応device・precision・fallback matrix、compiler／validator、CPUまたは信頼できるreference実装との差分test、許容誤差、NaN／Inf／overflow／rounding／determinism、memory境界・address space・workgroup・barrier・race検証、代表device上の性能・resource budget、sourceから中間表現・最終binary digestまでのSBOM／provenanceを持つ |
| WGSL／GLSL／HLSL／Metal Shading Language等のshader source・binary | language・graphics API・shader model・feature set・compiler／validatorをpin。stage interface、binding・layout・reflection、対象browser／OS／GPU／driver matrix、golden imageと数値・構造invariant、compile／pipeline creation／runtime error telemetry、sourceからSPIR-V／DXIL／metallib等の最終digestまでのprovenanceを持つ |
| C／Rust等から生成するeBPF ELF／BTF成果物 | source・compiler・loader、kernel・BTF、program type・attach point、helper／kfunc、architectureの互換性をpin。verifier pass、権限・capability・data exposureのthreat model、map schema・lifecycle・resource bound、CO-REと対象kernel matrixまたは明示的な限定support、attach／detach／rollback test、license・helper適格性、sourceからELF／BTF digestまでのprovenanceを持つ |
| Solidity／Vyper／Move／Cairo等 | compiler・chain・framework pin、static analysis、unit・invariant・fuzz、testnetまたはlocal fork、storage layout、upgrade／access control、bytecodeとprovenance |
| SystemVerilog／Verilog／VHDL等 | simulator・synthesis toolchain pin、lint、assertion、testbenchまたはformal verification、CDC／RDC、timing constraint、bitstream・firmware provenance |

- Rule 320.34: 新規のnetwork-facing、認証、parser、critical infrastructure機能では、メモリ安全な言語を第一候補とする。
- Rule 320.35: C/C++継続時は利用箇所、unsafe API、外部入力、sanitizer coverage、移行優先度を台帳化する。新規の外部公開、高権限、重要機能でC/C++を増やす場合は、accountable owner、段階と期限、依存関係、教育、CVE対応、互換bridge、完了指標を持つmemory-safe roadmapまたは、移行不能理由と同等の補償統制を承認済みADRへ記録する。
- Rule 320.36: FFI境界ではownership、lifetime、allocation/deallocation責任、threading、error mapping、ABI compatibilityを文書化し、境界testとfuzzを行う。

smart contractは資産、upgrade key、oracle、bridge、governance、reentrancy、integer／rounding、DoS、MEV等をthreat modelへ含め、production資産の規模と不可逆性に応じて独立auditと段階的な権限縮小を判断する。hardware記述はsimulationだけで完了とせず、synthesis後のtiming、clock／reset domain、target device、bitstream署名または同等のartifact identityまで追跡する。

acceleratorとshaderの最適化は、代表workload・device上で計測した利益が複雑性、portability、cost、energy、保守負担を上回る場合だけ採用する。vendor／backend固有pathにはportableまたはreference fallback、明示的なsupport境界、accountable owner、退出計画を置く。性能testはcorrectness testを代替せず、bitwise一致が成立しない数値処理はdomainに適した許容誤差と失敗条件を先に定義する。

precompileとruntime compileのどちらでも、build host、compiler cache、remote cache、driver JIT、署名済み配布物を信頼境界として扱う。shader validatorまたはeBPF verifierのpassだけで、visual correctness、数値正当性、privacy、権限、可用性を承認しない。高権限・network path・security enforcementへattachするeBPF変更は、通常のapplication codeより強いreview、隔離された検証、段階適用、即時detachまたはrollbackをriskに応じて要求する。

## §11. 並行処理、エラー、可観測性

- Rule 320.37: 非同期task、thread、goroutine、coroutine、actorにはowner、lifecycle、timeout、cancellation、backpressure、shutdownを定義する。
- Rule 320.38: fire-and-forgetは原則禁止する。必要な場合は監視、失敗回収、上限、停止手段を持つ管理対象taskにする。
- Rule 320.39: errorは利用者向け、domain、transient、dependency、programming faultへ分類し、retry可否とstatus mappingを一貫させる。
- Rule 320.40: 例外やerrorを握り潰さない。機密情報を除外したうえでcorrelation ID、service、operation、error categoryを構造化記録する。
- Rule 320.41: OpenTelemetry等の言語中立規約を優先し、trace contextをHTTP、RPC、queue、batch、CLI境界で伝播する。

## §12. 言語間境界と契約

- Rule 320.42: HTTPはOpenAPIまたはJSON Schema、RPCはProtocol Buffers等、eventはAsyncAPIまたはregistry schema、data productはdata contractを正本とする。
- Rule 320.43: 生成可能な型を手作業で各言語へ複製しない。generator versionとschema digestをpinし、生成差分をCIで検証する。
- Rule 320.44: contractにはowner、version、compatibility mode、deprecation期間、error model、pagination、idempotency、PII分類を含める。
- Rule 320.45: binary、timezone、decimal、64-bit integer、null、enum未知値、Unicode、orderingの言語差をcontract testで検証する。
- Rule 320.46: internal package共有よりservice/data contractを優先し、組織境界を越える実装詳細の結合を避ける。

## §13. チーム・企業ガバナンス

### 13.1 所有とレビュー

- 各言語、runtime、build toolにaccountable ownerと継続経路を置く。`primary`／`secondary`は互換schema名であり、別人化はrisk-basedに判断する。
- React Native等の言語横断frameworkはapp／JS、iOS、Android、native module、release／OTAを別の所有境界として台帳化し、単一のaccountable product ownerへ結び付ける。
- CODEOWNERS、ownership registryまたは同等機構で専門review対象を解決し、保護branch、repository rules、CI policyまたは同等の変更統制で必須検証を強制する。
- ownership recordへ複数ownerを列挙しただけでは独立承認にならない。高保証pathは必要承認数、最終変更の独立承認、古い承認の失効を利用中のVCSまたは変更管理機構で強制し、ownership policy自体にもownerを設定する。
- 高保証領域は提案者と承認者を分離し、最終revisionへの二者reviewを要求する。
- onboarding、役割変更、offboardingでは、repository／registry／signing／CI権限、service account、release ownership、maintainer連絡先、runbook、未完了例外を同じinventoryで移管・失効し、単一担当者の退職や契約終了後もbuild、patch、release、rollbackを継続できる証拠を残す。
- owner不在、EOL、重大脆弱性、build不能を自動検出し、query可能なportfolio report、dashboardまたは同等証跡へ出す。

### 13.2 Golden Path

標準言語には次へ再現可能に到達できる導入経路を提供する。template、service scaffold、生成CLI、文書化されたreference repositoryは実装例である。

- runtime/compiler pin、formatまたはstyle enforcement、lint、type/compiler、test、SCA、SBOM、container、health、telemetry
- local setup、CI、release、rollback、incident runbook
- secure defaults、sample API、contract generation、dependency update automation
- onboarding検証とTime-to-First-PR計測

### 13.3 変更と例外

- accountableな言語portfolio機能が、Blueprintのrisk-based cadenceと重要event発生時にportfolio、EOL、例外、重複言語をレビューする。Language CouncilやArchitecture Group、四半期reviewは大規模組織向けの実装例である。
- 例外にはID、scope、理由、owner、承認者、補償統制、期限、再確認日を必須とする。
- 期限切れ例外はCIで失敗させるか、少なくともmerge blockerとして扱う。

## §14. ポリグロットCI、供給網、再現性

- Rule 320.47: monorepoはbuild graphで依存関係を表し、変更範囲検証と、統合順序を直列化できる仕組み上の全体contract／integration gateを併用する。merge queueは代表的な実装例である。
- Rule 320.48: path filterだけで安全を断定しない。shared schema、base image、toolchain、workflow変更は全関係言語を再検証する。
- Rule 320.49: deploy可能なapplicationと実行rootは、ecosystemがlockfileを提供する場合はcommitし、そうでない場合は同等のimmutableな解決証跡を保持する。rootとsubprojectの解決責任を明確化し、公開libraryはecosystem固有のconsumer互換性慣行に従ってCIのtest／release解決を固定する。lockfile、checksum、resolved graph等の証跡を削除して安易に再解決することを標準復旧手順にしない。
- Rule 320.50: releaseは言語別SBOMを統合し、source revision、builder identity、toolchain、artifact digest、test/SCA結果へ追跡可能にする。本番buildはSLSA Build L2以上、高保証成果物はBuild L3を目標とし、provenanceを生成するだけでなく検証する。package registryとbuild platformが対応する場合は、長期publish tokenよりOIDC等の短命workload identityを優先し、登録workflow／pipeline自体をcredential境界として保護する。未対応ecosystemは最小scope・短寿命credentialと期限付き移行reviewを使用する。
- Rule 320.51: build cacheはtoolchain、lockfileまたは同等のdependency-resolution digest、target、feature、environmentをkeyに含め、信頼境界を越えて未検証artifactを再利用しない。
- Rule 320.52: source変更統制はowner review、必須検証、承認後変更時の再review、履歴改変防止をリスクに応じて設定する。protected branch、ruleset、server-side policyは実装例である。SLSA Source trackを採用する場合、Source L2は一般的なreference profile、高保証領域のSource L3または二者reviewを含むSource L4は強化profileとして必要propertyを選ぶ。Source VSAでは対応する数値levelと`SLSA_SOURCE_TWO_PARTY_REVIEWED`属性を検証し、存在しない`SLSA_SOURCE_LEVEL_4`を生成しない。

### 14.1 基本CI順序

1. metadata、依存解決証跡、generated contractの整合性
2. formatまたはstyle enforcement、lint、type/compiler、policy
3. unit、integration、contract、race/sanitizer
4. build、package、container、SBOM、SCA
5. E2E、performance、compatibility、reproducibility
6. provenance、signature、release policy

## §15. 例外、移行、廃止、成熟度

### 15.1 廃止プロトコル

1. 新規利用を停止し、利用箇所とownerを台帳化する。
2. 代替、互換bridge、data/API移行、rollbackを設計する。
3. traffic、consumer、build artifactがゼロになったことを機械確認する。
4. dependency、runtime、CI、秘密情報、文書を同じcloseoutで除去する。
5. ADRとTech Radarを更新し、残存例外へ新しい期限を付ける。

### 15.2 成熟度モデル

| レベル | 状態 |
|:--|:--|
| L1 属人的 | 言語選定、版、品質ゲート、ownerが暗黙的 |
| L2 可視化 | 言語台帳、pin、基本CI、依存監査がある |
| L3 標準化 | 再利用可能な導入経路、ownership control、契約生成、期限付き例外がある |
| L4 最適化 | build graph、影響範囲CI、統合SBOM、provenance、EOL自動監視がある |
| L5 適応型 | portfolio指標に基づき採用・統合・廃止を継続改善し、統制証跡を自動生成する |

### 15.3 禁止アンチパターン

- 履歴書駆動の新言語採用
- accountable owner、継続経路、退出計画のないproduction言語
- 利用可能なformatterまたは同等のstyle drift検出がないproduction repository、deploy可能なapplication／実行rootでlockfileまたは同等の依存解決証跡がない状態、または公開libraryでCIのtest／release解決と依存証跡が固定されていない状態
- TypeScript用ゲートを全言語へ名称だけ変えて適用すること
- 動的型を理由に境界schemaや静的解析を省略すること
- 静的型を理由に外部入力検証を省略すること
- 手作業で複製された多言語DTO
- path filterだけで全体互換性を保証したとみなすこと
- 無期限のlint抑制、security waiver、EOL runtime
- 置換計画のないC/C++拡大またはメモリ安全性リスクの未記録

## §16. フレームワーク・デスクトップアプリケーション統治

### 16.1 フレームワークportfolio

- Rule 320.53: 言語、runtime、framework、compiler、SDK、adapter、plugin、ORM、renderer、build／packaging toolを同一の「対応言語」に集約しない。各layerのsupport主体、version、EOL、互換範囲、更新責任を別々にinventory化し、組合せとして検証する。
- Rule 320.54: production frameworkの採用記録には、業務適合性、公式またはcommunity support、security advisory経路、runtime／compiler／SDK matrix、主要adapter／plugin、data migration、運用、upgrade、rollback、exitを含める。固定製品をUniversal標準にせず、同等成果を満たす実装へ置換可能にする。
- Rule 320.55: React／Next.js、Vue／Nuxt、Angular、Svelte／SvelteKit、Astro、Spring Boot／Quarkus／Micronaut、ASP.NET Core、Django／FastAPI／Flask、Express／NestJS／Fastify、Rails、Laravel／Symfony、Phoenix、Ktor、およびGo／Rustのweb ecosystemは代表的profileであり、列挙を無条件のsupport保証または採用指示と解釈しない。採用版の公式support policyと実効互換matrixを最終根拠とする。
- Rule 320.56: framework既定値をsecurityまたは運用契約として無検証に継承しない。認証、session、CORS、CSRF、入力検証、error、serialization、ORM／migration、job、cache、telemetryの責任境界とproduction設定を明示してtestする。
- Rule 320.57: domain contractをframework境界から分離し、transport、persistence、UI、native bridgeをadapterとして扱う。特定projectの都合だけで汎用frameworkを自作せず、複数の実利用、既存選択肢との差、保守owner、互換性とexitを示せる場合に限定する。
- Rule 320.58: major framework upgradeでは、生成template／configの差分、runtime・compiler・SDK・adapter・plugin matrix、deprecation、data／schema migration、production build、rollbackまたはforward-fixを検証する。複数majorの同時更新は、公式移行経路と切り分け可能な証跡がある場合だけ許容する。
- Rule 320.59: framework support tierは言語support tierと独立して決める。packageがinstall可能、sampleが起動可能、または言語がfirst-classであることだけを、frameworkのproduction supportと同一視しない。

### 16.2 デスクトップapplication profile

- Rule 320.60: desktop採用契約には、対象OS、architecture、runtime／webview、compiler／SDK、framework、native dependency、signing、installer／package形式、更新channel、enterprise配布経路の互換matrixを含める。riskと利用者分布に基づき、最古と現行のsupport対象を実artifactで検証する。
- Rule 320.61: renderer／webview、IPC、native bridge、filesystem、shell、network、deep link／custom protocol、updateを別のtrust boundaryとして扱う。最小権限、sandboxまたはcapability、senderと入力の検証、navigation制限を適用し、untrusted contentへ生のnative APIやcredentialを公開しない。
- Rule 320.62: desktop releaseは、code signing、notarizationまたはplatform相当検証、package identity、update manifestと署名、channel、rollback／forward-fix、SBOM、provenance、source map／symbol、crash telemetryを配布artifactへ結び付ける。該当platformに存在しない要素は、非該当理由と同等のintegrity evidenceを記録する。
- Rule 320.63: local database、cache、file、credential、PIIについて、OS secure storage、暗号化、backup、account切替、logout、uninstall、schema migration、retentionを設計する。secretをbundle、平文config、logへ含めず、shared deviceとoffline利用をthreat modelへ含める。
- Rule 320.64: frontend／web、native、IPC、packaging、signing、release、security、endpoint managementの責務と継続経路を割り当て、単一のaccountable product ownerへ結び付ける。小規模teamは兼務できるが、企業配布、MDM、proxy、certificate、least-privilege install、support desk、offboardingを必要なscopeだけ明示する。

---

## §17. クエリ・変換・監視・インフラDSL統治

- Rule 320.65: general-purpose language以外のquery、formula、template、policy、workflow、configuration DSLも、productionの挙動、権限、費用、alert、data、artifactへ影響する場合は第一級sourceとして扱う。採用記録にはlanguage／dialect、評価engineとversion、host product／workspace、source形式、生成または実効artifact、permission context、resource／cost境界、support／EOL、owner、test、rollback／exitを含める。同名DSLでもengine、extension、互換modeが異なる場合は別profileとして検証し、一覧への掲載を無条件のsupport保証にしない。
- Rule 320.66: SQL dialect、GraphQL、Cypher、Gremlin、SPARQL等のdata／API／graph queryは、schemaとtype、parameter binding、resolver／data境界の認可、tenant／row／field制約、pagination、complexity／depth／fan-out、N+1、scan／execution plan、timeout、result size、unit costを契約化する。未信頼値の文字列連結、client側検証、introspection無効化だけをinjection、認可、abuse対策とせず、positive／negative authorizationと代表的なworst-case queryを実engineでtestする。
- Rule 320.67: PromQL、LogQL、KQL、Flux、SIEM query、alert／recording rule、Rego等の可観測性・security・policy DSLは、fixtureまたはreplay、期待結果、欠損／遅延／stale data、timezone／window、sampling、cardinality、retention、scan量、PII、空結果、evaluation failureを検証する。alert、SLO、security decision、billing controlを変更するqueryはshadow、preview、canaryまたは同等の段階検証とrollbackを持ち、syntax passやdashboard表示だけで承認しない。
- Rule 320.68: dbt SQL／Jinja、DAX、MDX、Power Query M等のdata transformation、semantic model、BI formulaは、textまたはreview可能なmetadata、evaluator／connector／workspace release、sourceとsemantic schema、lineage、data quality、access／RLS、refresh、incremental／backfill、calendar／timezone／currency／precision、generated queryまたはcompiled artifact、deploymentとrollbackをversioned evidenceへ結ぶ。visual editorまたはmanaged workspaceだけを唯一の正本にせず、export不能なplatformではbefore／after、actor、test、backup、退出手順を補償統制として残す。
- Rule 320.69: Jinja、Helm template、macro、code generator、low-code export等はtemplate sourceとrendered／compiled／generated artifactの両方を検証する。入力schema、escaping、injection、secret流出、非決定性、環境差、生成差分、target schema、source revisionとgenerator versionから最終artifactまでのprovenanceを確認し、生成物の手修正またはrender前sourceだけのreviewで完了としない。
- Rule 320.70: Terraform／OpenTofu、Kubernetes manifest、Helm、Kustomize、Crossplane、Ansible／Puppet／Chef、Packer、Pulumi／CDK等のinfrastructure DSLとautomationは、formatterまたは正規化、schema／compiler validation、test、machine-readable plan／diff、security／policy／cost、state／plan／inventory／secretの保護、provider／module／collectionの解決証跡、targetとcredential、idempotency／convergence、immutable imageまたはartifact、drift、段階適用、rollback／recoveryをriskに応じて検証する。local plan、render済みYAML、dry-runが、同時変更後の最終plan、admission後のeffective state、runtime healthを保証すると仮定しない。

---

## §18. 公開ライブラリ・SDK・パッケージ配布と互換性統治

公開packageの互換性は、version文字列だけでは決まらない。言語、compiler、runtime、linker／loader、package manager、registry、生成器、利用者の組合せによって、守るべき契約と破壊の現れ方が異なる。本節は、公開範囲が組織内だけの場合も含め、consumerが独立して更新するlibrary、SDK、CLI、plugin、native module、generated clientへ適用する。

| 互換性surface | 代表的な破壊 |
|:--|:--|
| source | 既存consumerが再compile、type-check、import、code generationできない |
| binary／ABI | 再compileしていないconsumerがlink、load、起動できない |
| behavior／protocol | signatureは同じでも結果、error、retry、順序、性能、network契約が変わる |
| data／serialization | 保存済みdata、wire format、schema、enum、precision、migrationが読めない |
| toolchain／platform | 最小compiler、runtime、SDK、OS、architecture、package metadataの変更で利用不能になる |
| delivery | package内容、dependency、symbol、type、native binary、署名、provenanceがreleaseごとに一致しない |

- Rule 320.71: 公開library、SDK、package、CLI、plugin、native module、generated clientは、公開contractをsource、binary／ABI、runtime link／load、behavior、protocol、serialization／data、CLI／config、toolchain／platformの該当surfaceへ分類する。SemVerまたはecosystemのversion規約は変更意思を伝える手段であり、それ単独を互換性の証明にしない。該当しないsurfaceは理由を明示し、documented APIだけでなく、実際に公開されるsymbol、type、metadata、generated code、error、side effectを検査対象に含める。
- Rule 320.72: support claimには、最小および現行のcompiler、runtime、SDK、OS、architecture、package manager／metadata、feature、optional dependency、native dependencyのconsumer matrixを含める。riskと利用分布に応じて最古のsupport対象と現行の代表対象を実consumerとしてinstall、resolve、compile／type-check、link／load、execute、packageし、未対応、best-effort、community supportをfirst-class supportと区別する。全組合せの直積を無条件に要求せず、tier、代表値、変更影響、利用telemetryまたは同等根拠でmatrixを選ぶ。
- Rule 320.73: 変更gateは、ecosystemで利用可能なAPI／ABI diff、既存source consumerのcompile、既存binary consumerのload／run、behavior／protocol fixture、serialization互換性、代表的downstream consumerをriskに応じて組み合わせる。追加、非推奨、破壊、security例外を分類し、破壊変更には移行経路、検出可能なdeprecation、影響範囲、release note、rollbackまたはforward-fixを結び付ける。脆弱性対応で通常windowを短縮する場合も、残余risk、緩和策、consumer通知、証跡を省略しない。
- Rule 320.74: releaseは、検証したsource revisionからpackage artifactを一度だけbuildし、その実内容を公開前に検査する。package metadata、dependency constraint、license、notice、documentation、type／symbol、source map／debug symbol、generated file、native binary、platform variantを該当範囲で確認し、source revision、toolchain、lock／resolution、artifact digest、SBOM、provenanceへ結び付ける。環境ごとに再buildした別artifactを同一releaseとして昇格せず、同一の検証済みartifactまたは内容同一性を証明できる集合をchannel間でpromoteする。
- Rule 320.75: 公開済みのpackage coordinateとversionへ異なる内容を上書きまたは再利用しない。欠陥releaseは新versionで修正し、必要に応じてecosystemのyank、unlist、deprecate、withdraw、advisory等、既存consumerの再現性を壊しにくい仕組みで新規採用を抑止する。registry publicationには、review可能なrelease権限、短命またはworkload identityを優先する認証、namespace ownership、緊急失効、account recovery、auditを適用し、具体的な署名、SBOM、provenance要件は`security/200_oss_compliance.md`と統合する。
- Rule 320.76: schemaまたはIDLから複数言語のSDKを生成する場合、schema、generator、template、runtime library、手書きextension、生成設定のversionまたはdigestをrelease evidenceへ結び付ける。生成領域と手書き領域を分離し、言語間の機能parity、version対応、server／client compatibility window、error・pagination・retry・authentication等の共通behaviorをcontract testする。複数registryへの公開順序、部分失敗、再実行、撤回、server featureの有効化順を設計し、一部SDKだけ公開された状態を無検出で放置しない。
- Rule 320.77: stable、prerelease、preview、nightly等のchannelは、期待する安定性、upgrade経路、support、retention、consumer opt-inが混同されないよう分離する。最小compiler／runtime／OS／SDK／dependency／package metadata versionの引上げは、ecosystem上のmajor扱いでなくてもconsumerを破壊し得る変更として評価し、根拠、影響、最後の互換release、移行手順、通知、sunset、rollbackまたはforward-fixを提供する。support floorとdeprecation期限は固定年数ではなく、security、vendor EOL、利用分布、規制、保守能力をBlueprint parameterとして定期再評価する。
- Rule 320.78: 言語、library、SDK、packageのenterprise supportを表明できるのは、documented consumer matrixでinstall、build、test、package、upgrade、recoveryを再現でき、accountable ownerと継続経路、registry namespaceと権限、security advisory窓口、release／incident runbook、decommission／transfer手順が存在するときに限る。小規模teamは責務を兼務できるが、個人account、退職者だけが持つcredential、移管不能なnamespace、単独maintainerの暗黙知を継続経路にしない。offboarding、team再編、repository移管、provider変更時にownershipとconsumer通知経路を検証する。

---

## §19. Notebook・literate computational artifact統治

本節は、Jupyter／IPython、R Markdown／Quarto、managed notebook、Wolfram Notebook等を参考例とするが、特定製品、file形式、languageへ限定しない。code、説明、query、parameter、metadata、実行状態、rich outputを一つのdocumentまたはworkspaceで扱うPython、R、Julia、Scala、SQLその他のcomputational artifactへ適用する。製品名の掲載はsupport保証ではなく、同等能力へ置換できる。

- Rule 320.79: notebookまたはliterate computational artifactは、exploration、research、review／report、scheduled／production等の用途profileを分類し、owner、目的、source正本、kernel／runtime、input／output、data分類、実行権限、consumer、promotion、retention、exitを採用記録へ含める。用途profileは厳格さを調整するが、secret非埋込み、PII分類、owner、回収可能性を免除しない。管理画面への登録、拡張子、製品名だけをproduction supportの証明にしない。
- Rule 320.80: reviewまたはproduction判断に使うartifactは、declared parameterとinputを用い、前回sessionのmemory、out-of-order cell、hidden variable、手動UI操作、undeclared local fileへ依存せず、freshかつ隔離されたenvironmentで先頭からclean executionできることを検証する。実行順、失敗cell、timeout、interrupt、kernel restart、partial outputを検出可能にし、対話workspaceで一度成功したことを再現性の証明にしない。
- Rule 320.81: notebookはcode／markup sourceだけでなく、metadata、execution count、saved output、attachment、widget state、checkpoint、exportを含む複合artifactとしてreviewする。不要なoutputとvolatile metadataは決定的に除去または正規化し、必要な結果はdata分類、サイズ、retention、再生成costに応じてsourceと分離または明示的にversion管理する。review可能なdiffとsource正本を定め、generated exportだけのreview、巨大binary outputの無差別commit、生成物の手修正で完了としない。
- Rule 320.82: 再現性証跡には、source revision、notebook／document形式、kernel、language、packageとsystem dependency、container／image、locale／timezone、parameter、input dataのversion／schema／lineage、random seed、accelerator／hardware、実行時刻、実行結果をriskに応じて結び付ける。bitwise一致を一律に要求せず、非決定性、外部service、並列計算、浮動小数点の影響には許容誤差、invariant、reference data、再試行方針を先に定義する。
- Rule 320.83: code、markup、query、metadata、saved output、rich HTML／JavaScript、widget、attachment、checkpoint、exported HTML／PDF、workspace共有linkを独立したuntrusted surfaceとして扱う。credentialを埋め込まず、least privilegeの実行identityとnetwork／filesystem／data境界を適用し、secret／PII／malicious contentをsourceと全派生artifactでscanする。notebook署名、trust flag、ownerによる実行は保存済みoutputのintegrityまたは表示許可には使えても、codeの安全性、data access、consumer authorizationの証明にはしない。
- Rule 320.84: promotion gateは、該当するformat validation、static analysis、lint、type／schema check、抽出済みlogicのunit test、data quality、contract test、fresh environmentでのclean execution、期待output／invariant／numerical tolerance、negative authorization、secret／PII scanをriskに応じて組み合わせる。productionへ昇格するartifactは、review済みsource、immutableまたは内容識別可能なenvironment／dependency／data reference、実行identity、承認、実行結果を結び付け、UI上の表示、cell単位の手動確認、export成功だけで承認しない。
- Rule 320.85: scheduled／production notebook jobは、parameterとinput schema、idempotency、concurrency、retry、checkpoint／resume、timeout／cancellation、resource／cost budget、output destinationとatomicity、partial failure、structured log、metric、lineage、alert、rollbackまたはforward-fixを運用契約として持つ。対話kernelとproduction executorのenvironment差、queue待機、accelerator、外部API、data scan、保存済みoutputのretentionをcostとcapacityへ含め、無期限session、無制限retry、orphaned scheduleを残さない。
- Rule 320.86: teamまたはmanaged workspaceでは、accountable ownerと継続経路、source controlとworkspaceの正本境界、role／tenant／project／folder権限、data residency、共有linkとcomment、merge conflict、kernel／image ownership、schedule、secret、audit、backup／export、retention、offboarding、provider exitを定義する。小規模teamは役割を兼務できるが、個人workspace、退職者だけが所有するschedule／credential、export不能なoutput、暗黙のcell順序を引継ぎ経路にせず、別の権限主体がfresh environmentで再実行、停止、復旧、移管できることを定期検証する。

---

## Appendix A: 逆引き索引とクロスリファレンス

### 逆引き索引

| キーワード | セクション |
|:--|:--|
| 言語選定、Tech Radar、支持区分 | §2、§3、§15 |
| formatter、lint、型、test | §4〜§10 |
| TypeScript、JavaScript、HTML、CSS | §5 |
| Python、Java、Kotlin、C#、Go、Rust、PHP、Ruby、Lua、Perl、VBA、COBOL、PL/I、ABAP、Apex、Power Fx、JVM／.NET／BEAM／関数型言語 | §6 |
| Swift、Dart、React Native、モバイル、GDScript、ゲーム | §7、§10 |
| SQL、R、Scala、Julia、MATLAB、Fortran、Mojo、SAS、Stata、科学技術計算 | §8 |
| SQL、R、Scala、data、AI | §8 |
| CUDA、HIP、SYCL、Triton、OpenCL、accelerator、GPU、数値再現性 | §8、§10 |
| Terraform、Dockerfile、Containerfile、Shell、PowerShell、YAML、Rego、build DSL | §9 |
| Bicep、CloudFormation、ARM template、cloud-native IaC | §9 |
| C、C++、FFI、メモリ安全、WebAssembly、WASI、WIT、WGSL、GLSL、HLSL、Metal Shading Language、SPIR-V、DXIL、eBPF、BTF、Solidity、Move、SystemVerilog、VHDL | §10 |
| 並行処理、error、OpenTelemetry | §11 |
| OpenAPI、Protobuf、AsyncAPI、schema | §12 |
| CODEOWNERS、Golden Path、二者review、例外 | §13 |
| monorepo、SBOM、SLSA、provenance | §14 |
| migration、sunset、成熟度 | §15 |
| framework、support matrix、plugin、upgrade、desktop、Electron、Tauri、.NET MAUI、Avalonia、Qt、Compose Desktop、IPC、signing、installer | §16 |
| GraphQL、Cypher、Gremlin、SPARQL、PromQL、LogQL、KQL、Flux、DAX、MDX、Power Query M、dbt、Jinja | §17 |
| OpenTofu、Kubernetes manifest、Helm、Kustomize、Crossplane、Ansible、Puppet、Chef、Packer、generated artifact | §9、§17 |
| 公開library／SDK／package、source／binary／behavior互換性、consumer matrix、immutable version、generated SDK、package ownership | §18 |
| Jupyter、R Markdown、Quarto、managed notebook、literate programming、cell順序、hidden state、clean execution、rich output、scheduled notebook | §8、§19 |

### クロスリファレンス

| 関連ファイル | 関係 |
|:--|:--|
| `engineering/000_engineering_standards.md` | 共通エンジニアリング原則 |
| `engineering/100_api_integration.md` | 同期APIとschema-first設計 |
| `engineering/300_web_frontend.md` | Web / TypeScript固有実装 |
| `engineering/400_mobile_flutter.md` | Flutter / Dart固有実装 |
| `engineering/410_native_platforms.md` | Kotlin / Swift固有実装 |
| `engineering/420_react_native.md` | React NativeのNew Architecture、言語間境界、両OS品質、OTA、企業チーム運用 |
| `engineering/200_supabase_architecture.md` | Supabase client SDKのofficial／community support surface |
| `engineering/500_firebase_gcp.md` | Firebase client／Admin SDK、Cloud Run buildpack／containerの言語surface |
| `engineering/520_cloud_application_platforms.md` | managed runtime、framework adapter、service、platform lifecycle |
| `engineering/740_data_contracts.md` | 組織・service境界のdata contract |
| `ai/100_data_analytics.md` | data／model lineage、再現性、ML運用、analytics team統治 |
| `quality/000_qa_testing.md` | テスト戦略とCI品質ゲート |
| `security/000_security_privacy.md` | secure codingと境界防御 |
| `security/200_oss_compliance.md` | license、SCA、registry publication identity、immutable release、SBOM、provenance、供給網 |
| `operations/400_site_reliability.md` | runtime運用、SLO、可観測性 |

### 一次資料

- [GitHub Octoverse 2025](https://github.blog/news-insights/octoverse/octoverse-a-new-developer-joins-github-every-second-as-ai-leads-typescript-to-1/): 主要言語の利用動向
- [Stack Overflow Developer Survey 2025](https://survey.stackoverflow.co/2025/technology#most-popular-technologies-language-prof): professional developerの言語利用を含む補完データ
- [Node.js Releases](https://nodejs.org/en/about/previous-releases)、[Oracle Java SE Support Roadmap](https://www.oracle.com/java/technologies/java-se-support-roadmap.html)、[.NET Support Policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core)、[Python version status](https://devguide.python.org/versions/): runtimeごとのLTS、support window、EOL判断
- [Kotlin release process](https://kotlinlang.org/docs/releases.html)、[Swift 6.3 Released](https://www.swift.org/blog/swift-6.3-released/)、[Dart changelog](https://dart.dev/changelog): mobile／multiplatform言語のrelease、security support、language versioning判断
- [Angular release schedule](https://angular.dev/reference/releases)、[Spring Boot System Requirements](https://docs.spring.io/spring-boot/system-requirements.html)、[Django release process](https://docs.djangoproject.com/en/dev/internals/release-process/)、[.NET and .NET Core Support Policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core): frameworkとruntime／compiler／SDKのsupport lifecycle、互換matrix、upgrade判断
- [Electron Security](https://www.electronjs.org/docs/latest/tutorial/security)、[Tauri Capabilities](https://v2.tauri.app/security/capabilities/)、[Tauri Permissions](https://v2.tauri.app/security/permissions/): desktop webview、IPC、native capability、navigation、sandboxのtrust boundary
- [.NET MAUI Support Policy](https://dotnet.microsoft.com/en-us/platform/support/policy/maui)、[Qt Supported Platforms](https://doc.qt.io/qt-6/supported-platforms.html): desktop／cross-platform frameworkの独立したsupport cadenceとOS／architecture／compiler matrix
- [Go Release History](https://go.dev/doc/devel/release)、[Rust Release Notes](https://doc.rust-lang.org/stable/releases.html)、[PHP Supported Versions](https://www.php.net/supported-versions.php)、[Ruby branches](https://www.ruby-lang.org/en/downloads/branches/): backend／systems言語のsupport、security fix、EOL判断
- [Semantic Versioning 2.0.0](https://semver.org/)、[Go 1 and the Future of Go Programs](https://go.dev/doc/go1compat)、[Cargo SemVer Compatibility](https://doc.rust-lang.org/cargo/reference/semver.html): version表現、互換promise、ecosystem固有の破壊変更分類
- [Java Language Specification §13](https://docs.oracle.com/javase/specs/jls/se26/html/jls-13.html)、[.NET Breaking Change Rules](https://learn.microsoft.com/en-us/dotnet/standard/library-guidance/breaking-changes)、[Swift Library Evolution](https://www.swift.org/blog/library-evolution/): source／binary／behavior互換性とlibrary evolution
- [Python Core Metadata](https://packaging.python.org/en/latest/specifications/core-metadata/)、[Dart Package Versioning](https://dart.dev/tools/pub/versioning): consumer toolchain floor、package versionの不変性、互換性metadata
- [Cargo Publishing](https://doc.rust-lang.org/cargo/reference/publishing.html)、[Maven Central Publisher Registration](https://central.sonatype.org/register/central-portal/)、[GitHub Immutable Releases](https://docs.github.com/en/code-security/concepts/supply-chain-security/immutable-releases): version再利用禁止、yank／immutability、namespace ownership、release artifact integrity
- [NIST SP 800-218 SSDF](https://csrc.nist.gov/pubs/sp/800/218/final): 特定のSDLC実装へ固定しない、高水準で成果指向のsecure software development practice
- [RFC 2119](https://www.rfc-editor.org/info/rfc2119) / [RFC 8174](https://www.rfc-editor.org/info/rfc8174): MUST等の規範語を慎重かつ限定的に使用するためのBCP 14
- [SLSA v1.2 Source requirements](https://slsa.dev/spec/v1.2/source-requirements) / [Verified Properties](https://slsa.dev/spec/v1.2/verified-properties): source level、二者review、VSA属性、供給網保証
- [GitHub CODEOWNERS](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners) / [rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets) / [protected branches](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)、[GitLab approval rules](https://docs.gitlab.com/user/project/merge_requests/approvals/rules/): vendorごとに異なるowner reviewと変更統制の実装例
- [CISA Secure by Design](https://www.cisa.gov/sites/default/files/2025-01/joint-guidance-product-security-bad-practices-508c_0.pdf) / [The Case for Memory Safe Roadmaps](https://www.cisa.gov/resources-tools/resources/case-memory-safe-roadmaps): memory-safe language、経営責任、段階的移行、依存関係と透明性を含む製品セキュリティ指針
- [Go Security](https://go.dev/doc/security/)、[Rust Clippy](https://doc.rust-lang.org/clippy/index.html)、[Terraform style guide](https://developer.hashicorp.com/terraform/language/style)、[Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html): 公式またはmaintainer提供の品質・運用基準
- [TypeScript: JS Projects Utilizing TypeScript](https://www.typescriptlang.org/docs/handbook/intro-to-js-ts.html)、[Type Checking JavaScript Files](https://www.typescriptlang.org/docs/handbook/type-checking-javascript-files.html)、[JSDoc Reference](https://www.typescriptlang.org/docs/handbook/jsdoc-supported-types.html): sourceをTypeScriptへ変換せずproduction JavaScriptへ段階的な型解析を適用する公式経路
- [Wasm 3.0 Completed](https://webassembly.org/news/2025-09-17-wasm-3.0/)、[WebAssembly specifications](https://webassembly.org/specs/)、[WASI releases](https://wasi.dev/releases)、[WASI security](https://wasi.dev/security): core specificationのrelease、portable artifact、component interface、version、runtime、capability境界の判断根拠
- [Bicep overview](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview)、[CloudFormation best practices](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/best-practices.html): cloud-native宣言型IaCのvalidation、変更preview、ownership、policy、drift、rollback統制
- [Docker build best practices](https://docs.docker.com/build/building/best-practices/)、[Docker build secrets](https://docs.docker.com/build/building/secrets/)、[Bazel hermeticity](https://bazel.build/basics/hermeticity): container／build定義のpin、secret分離、再現性、host隔離
- [Microsoft .NET package audit](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-package-list)、[uv CLI](https://docs.astral.sh/uv/reference/cli/)、[Bun lockfile](https://bun.com/docs/pm/lockfile)、[renv](https://rstudio.github.io/renv/): ecosystem固有の再現性と依存監査
- [Dart package dependencies](https://dart.dev/tools/pub/dependencies#lockfiles)、[Dart Pub security advisories](https://dart.dev/tools/pub/security-advisories)、[Terraform dependency lock file](https://developer.hashicorp.com/terraform/language/files/dependency-lock): application／公開libraryとprovider／moduleで異なる依存固定・監査境界
- [Microsoft 365 Apps macro security](https://learn.microsoft.com/en-us/microsoft-365-apps/security/internet-macros-blocked): VBA macroのblock、署名、trusted publisher、集中管理
- [Lua 5.4 Reference Manual](https://www.lua.org/manual/5.4/manual.html)、[Perl security](https://perldoc.perl.org/perlsec)、[Carton](https://github.com/perl-carton/carton)、[CPAN Audit](https://github.com/briandfoy/cpan-audit): 条件付き言語の実行境界、再現性、依存監査
- [SAP ABAP Keyword Documentation](https://help.sap.com/doc/abapdocu_latest_index_htm/latest/en-US/index.htm)、[Salesforce Apex Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/): enterprise platform言語の公式制約とtest境界
- [Julia Code Loading](https://docs.julialang.org/en/v1/manual/code-loading/)、[MATLAB Analyze Project Dependencies](https://www.mathworks.com/help/matlab/matlab_prog/analyze-project-dependencies.html)、[Fortran Package Manager manifest specification](https://fpm.fortran-lang.org/spec/manifest.html)、[Mojo roadmap](https://docs.modular.com/mojo/roadmap/): scientific／HPC言語のenvironment、dependency、toolchain、stability境界
- [Solidity Security Considerations](https://docs.soliditylang.org/en/latest/security-considerations.html): smart contract固有の安全性と検証境界。Move、Cairo等は採用chainの公式仕様を最終根拠とする
- [Accellera Standards](https://www.accellera.org/downloads/standards)、[IEEE VHDL](https://standards.ieee.org/ieee/1076/12535/): hardware記述言語と検証standard
- [CUDA Programming Guide](https://docs.nvidia.com/cuda/cuda-programming-guide/)、[CUDA C++ Best Practices Guide](https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/)、[HIP programming model](https://rocm.docs.amd.com/projects/HIP/en/latest/how-to/programming_manual.html)、[SYCL Registry](https://registry.khronos.org/SYCL/)、[OpenCL Registry](https://registry.khronos.org/OpenCL/)、[Triton documentation](https://triton-lang.org/main/): heterogeneous computeのexecution model、device／backend互換性、数値検証、kernel DSL判断
- [W3C WGSL](https://www.w3.org/TR/WGSL/)、[Khronos SPIR-V Registry](https://registry.khronos.org/SPIR-V/)、[Microsoft HLSL Reference](https://learn.microsoft.com/en-us/windows/win32/direct3dhlsl/dx-graphics-hlsl-reference)、[Apple Metal Resources](https://developer.apple.com/metal/resources/): shader language、feature set、validation、中間・最終artifact判断
- [Linux eBPF verifier](https://docs.kernel.org/bpf/verifier.html)、[BPF Type Format](https://docs.kernel.org/bpf/btf.html)、[libbpf CO-RE overview](https://docs.kernel.org/bpf/libbpf/libbpf_overview.html)、[BPF licensing](https://docs.kernel.org/bpf/bpf_licensing.html): privileged programの検証、kernel portability、ELF／BTF、helper・license境界
- [GraphQL September 2025 Specification](https://spec.graphql.org/September2025/)、[SPARQL 1.1 Query Language](https://www.w3.org/TR/sparql11-query/)、[Prometheus Querying Basics](https://prometheus.io/docs/prometheus/latest/querying/basics/): query semantics、validation、graph pattern、time-series selector、engine固有execution boundary
- [dbt SQL models](https://docs.getdbt.com/docs/build/sql-models)、[DAX overview](https://learn.microsoft.com/en-us/dax/dax-overview)、[Power Query M language specification](https://learn.microsoft.com/en-us/powerquery-m/power-query-m-language-specification): sourceからeffective SQL、model DAG、semantic expression、transformation評価、host engine境界
- [OpenTofu plan](https://opentofu.org/docs/cli/commands/plan/)、[validate](https://opentofu.org/docs/cli/commands/validate/)、[test](https://opentofu.org/docs/cli/commands/test/)、[Kubernetes declarative object management](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/declarative-config/)、[Kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/)、[Helm chart templates](https://helm.sh/docs/chart_template_guide/getting_started/): planの機密性、offline validationの限界、live resourceを作るtestのrisk、宣言drift、overlay、rendered artifact review
- [Jupyter Notebook format](https://nbformat.readthedocs.io/en/latest/format_description.html)、[Jupyter notebook document security](https://jupyter-notebook.readthedocs.io/en/v6.5.2/security.html)、[nbclient execution](https://nbclient.readthedocs.io/en/latest/client.html): code、metadata、saved rich output、trust boundary、kernel／timeoutを含む実行artifactの構造と検証
- [Quarto execution management](https://quarto.org/docs/projects/code-execution.html)、[Papermill parameterization](https://papermill.readthedocs.io/en/latest/usage-parameterize.html)、[Vertex AI notebook execution](https://cloud.google.com/vertex-ai/docs/workbench/instances/schedule-notebook-run-quickstart): computational documentの再実行、parameter contract、managed scheduled executionを実装する参考例
- 採用時は各言語の公式style、security、toolchain文書を最終根拠とする
