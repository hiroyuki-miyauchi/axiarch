# 420. React Nativeエンジニアリング

> [!CAUTION]
> このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。
> 改定日: 2026-07-23 | 対象: React Nativeの現行安定版、New Architecture、Hermes、iOS、Android

> [!IMPORTANT]
> React Nativeはプログラミング言語ではなく、TypeScript／JavaScript、Swift、Kotlin、必要時C++を一つのmobile productへ結合するframeworkである。共通コード量ではなく、両OSの品質、安全な言語間境界、更新可能性、チーム所有を最適化する。
> 17セクション・Rule 420.1–420.52。

---

## 目次

| セクション | トピック |
|:--|:--|
| §1 | 適用範囲と正本境界 |
| §2 | 採用判断とdelivery profile |
| §3 | version、toolchain、再現性 |
| §4 | repositoryとarchitecture |
| §5 | TypeScript／JavaScript・React層 |
| §6 | New Architecture、Hermes、Codegen |
| §7 | native moduleと言語間境界 |
| §8 | state、data、offline、network |
| §9 | platform fidelity、navigation、accessibility |
| §10 | performanceとresource budget |
| §11 | securityとprivacy |
| §12 | testing strategy |
| §13 | CI、release、OTA update |
| §14 | dependencyとsoftware supply chain |
| §15 | observabilityとincident response |
| §16 | scalable team governance |
| §17 | 例外、成熟度、禁止事項 |

---

## §1. 適用範囲と正本境界

- Rule 420.1: 本ファイルはReact Native app、brownfield統合、React Native library、native moduleのframework固有正本である。
- Rule 420.2: TypeScript／JavaScriptの言語品質は`320_programming_language_governance.md` §5、Swift／Kotlinのnative実装は`410_native_platforms.md`を継承する。Web DOM固有規則をReact Nativeへ自動適用しない。
- Rule 420.3: securityは`security/000_security_privacy.md`、test層は`quality/000_qa_testing.md`、store審査は`product/700_appstore_compliance.md`を優先する。
- Rule 420.4: 「一つのcodebase」を「一つの挙動」と解釈しない。iOSとAndroidのUX、権限、lifecycle、background execution、release artifactを独立して保証する。

### 1.1 Universal適用契約

- 本ファイルで必須となるのは、両OSの検証、安全な言語間境界、再現可能なbuild、release追跡、運用継続、退出可能性という成果である。vendor、hosted service、repository layout、VCS機能、team名、人数、固定cadenceは、その成果を実現する参考実装またはBlueprint parameterとして扱う。
- Expo、CocoaPods、SPM、Gradle、Xcode、Metro等はframework／platformの互換性判断に必要なecosystem固有対象であり、無関係なprojectへ導入を強制するものではない。固有toolを要求する場合は、公式supportまたはartifact互換性上の理由を記録する。
- 個人または小規模teamでは複数owner役割を兼務できる。高保証境界では独立reviewを優先し、分離できない場合はrisk acceptanceと独立したrelease統制を置く。大規模組織では同じ責務を専門functionへ分離できる。

## §2. 採用判断とdelivery profile

採用ADRは次のprofileを一つ選び、変更条件と退出計画を持つ。

| Profile | 適用 | 必須判断 |
|:--|:--|:--|
| Framework-managed | 新規appの既定候補 | Expo等のframework、native customization、build／update service、退出可能性 |
| Bare | 独自native build、特殊SDK、深いOS統合 | Xcode、Gradle、CocoaPods／SPM、Metro、署名を採用主体が継続運用できること |
| Brownfield | 既存Swift／Kotlin appへの段階導入 | 画面境界、navigation、lifecycle、binary size、rollback、native owner |
| Library | 複数appへ配るmodule／component | support matrix、Codegen、example app、互換性、deprecation |

- Rule 420.5: 新規appは公式推奨に従いframework-managedを第一候補とする。bare採用はframeworkで満たせない制約をADRへ記録する。
- Rule 420.6: React Nativeを「Web人材だけでnative appを作る手段」として採用しない。iOS、Android、store、security、releaseの実務能力を計画へ含める。
- Rule 420.7: brownfieldは一画面または一flowから導入し、nativeとReact Nativeの責務、navigation、data ownership、rollback単位を明示する。
- Rule 420.8: 採用KPIは共有率だけでなく、crash-free、ANR／hang、startup、frame、app size、build time、upgrade lead time、platform差分件数、Time-to-First-PRを含む。

## §3. version、toolchain、再現性

- Rule 420.9: React Nativeは公式support window内のminorを使用し、production appとproduction libraryは`STABLE` release levelを既定にする。`CANARY`、`EXPERIMENTAL`、nightly、release candidate等の非安定channelは、必要feature、対象cohort、互換性、telemetry、rollback、退出期限を記録した隔離評価に限定し、名称だけでproduction supportを推定しない。providerがproduction利用を明示的にsupportし、product riskに適合する例外はrisk acceptanceと全release gateを必須とする。原則として現行安定版を基線とし、unsupported移行前にupgradeを完了する。
- Rule 420.10: React Native、React、Node.js、package manager、Ruby、JDK、Gradle wrapper、Android SDK／NDK、Xcode、CocoaPods／SPMを機械可読にpinし、localとCIを一致させる。
- Rule 420.11: appまたは実行rootは、JavaScript package lock、`Gemfile.lock`、`Podfile.lock`、Gradle dependency lock、`Package.resolved`等、利用するresolverの解決証跡を責任範囲ごとにcommitし、frozen／locked installまたは同等の差分検出を用いる。Gradle version catalog単独では解決済み推移graphを固定しないため、lock state、dependency verification、resolved graph digest等で補完する。公開libraryはconsumerの解決を内部lockで拘束せず、宣言constraint、固定したCI test／release解決、support matrix、lock済みexample appで互換性を検証する。
- Rule 420.12: upgradeはsupport window、変更量、利用中frameworkに応じて段階化する。Expo SDK等がincremental upgradeを要求または推奨する場合はminorを順に上げる。複数minorを移行する場合は中間releaseのrelease notes、template migration、廃止APIを省略せず確認する。いずれもUpgrade Helper、framework SDKの対応表、native dependency互換性を確認し、upgrade changeは生成template差分を含めてiOSとAndroidのrelease buildを通す。

最低限の互換性台帳。`owner`は人、役割、team、外部保守契約の識別子を取れる:

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

## §4. repositoryとarchitecture

- Rule 420.13: domain logic、data access、presentation、platform adapter、native moduleを分離し、screen componentへbusiness logicやsecret-bearing requestを直書きしない。
- Rule 420.14: shared codeと`.ios`／`.android`差分の境界を意図的に設計する。巨大な`Platform.OS`分岐、条件分岐の重複、platform behaviorの偽装統一を禁止する。
- Rule 420.15: monorepoはapp、shared package、native package、schema、toolchainのbuild graphを表し、shared changeがiOS／Android gateを迂回しないようにする。

非規範の所有境界例。directory名ではなく、記載した責務の分離と追跡可能性が要件である:

```text
apps/mobile/        React Native application and composition root
packages/domain/    platform-neutral business rules
packages/ui/        accessible design-system components
packages/contracts/ generated API and native-boundary contracts
modules/native-*/   Turbo Native Modules or Fabric components
ios/                Apple project, signing, capabilities, native integration
android/            Android project, signing, permissions, native integration
```

## §5. TypeScript／JavaScript・React層

- Rule 420.16: 新規app codeとCodegen specはTypeScript `strict`を既定とし、外部入力、navigation params、storage、native return valueをruntime schemaで検証する。
- Rule 420.17: componentは表示とinteractionへ集中し、server state、domain state、ephemeral UI stateを区別する。global stateへの無差別集約とrender中の副作用を禁止する。
- Rule 420.18: Metro設定は`@react-native/metro-config`またはframework既定を継承し、production bundleをCIで生成する。Web向けpackageのDOM、Node.js builtin、browser storage依存をnative互換と仮定しない。

## §6. New Architecture、Hermes、Codegen

- Rule 420.19: 公式support window内のReact NativeではNew Architectureを必須とする。0.82以降はLegacy Architectureを実行できないため、`newArchEnabled=false`等の無効化例外を作らない。旧版からの移行は隔離したupgrade branchと両OSの回帰testで行い、unsupported legacy runtimeのproduction継続は通常の採用profileではなく、明示的なrisk acceptance、owner、補償統制、削除期限を持つ緊急移行例外として扱う。
- Rule 420.20: Hermesを既定engineとし、React Native同梱版を使用する。JavaScriptCore等への変更はstartup、memory、bundle、debug、dependency互換性の実測ADRを必須とする。
- Rule 420.21: 新しいnative APIはTurbo Native ModuleまたはFabric Native Componentと型付きCodegen specを使用する。legacy Native Module／Componentの新規追加は禁止し、既存利用は台帳化する。
- Rule 420.22: Codegen specを境界の正本とし、generator versionと入力digestをpinする。生成物の手修正を禁止し、clean generationと差分検査をCIで行う。

## §7. native moduleと言語間境界

- Rule 420.23: native moduleにはJS、iOS、Android、公開APIのaccountabilityを割り当てる。役割は兼務できるが、変更が触れる全レイヤーの検証を一層だけのreviewで省略しない。高保証境界では独立reviewを要求する。
- Rule 420.24: 境界contractはnullability、number範囲、64-bit integer、binary、date／timezone、enum未知値、error code、cancellation、thread、lifecycleを定義する。
- Rule 420.25: JSから渡る値とnativeから返る値を未信頼として検証し、size、depth、allocation、timeout、concurrency上限を設ける。native側のexception／crashを未処理でJSへ漏らさない。
- Rule 420.26: UI main threadとJavaScript threadでblocking I/Oや重いCPU処理を行わない。非同期APIにはowner、cancellation、backpressure、duplicate call、app background／termination時の動作を定義する。

## §8. state、data、offline、network

- Rule 420.27: server state、durable local state、draft、ephemeral UI stateのSSOTを定義し、Redux等のstate tree全体を無差別に永続化しない。
- Rule 420.28: offline mutationはidempotency key、queue上限、retry／backoff、conflict policy、schema migration、logout時消去、破損回復を持つ。
- Rule 420.29: requestにはtimeout、cancellation、connectivity復帰、auth refresh single-flight、rate limit、error mappingを定義し、JSとnative networking stackのpolicy差を台帳化する。

## §9. platform fidelity、navigation、accessibility

- Rule 420.30: navigationとdeep linkはroute schemaを正本とし、cold start、warm start、background、未認証、期限切れlink、未知routeを両OSでtestする。
- Rule 420.31: iOS HIGとAndroid design／behaviorを尊重し、permission prompt、back navigation、keyboard、safe area、edge-to-edge、font scaling、dark modeをplatform別に検証する。
- Rule 420.32: accessibility label、role、state、hint、focus order、touch target、contrast、reduced motion、dynamic textをcomponent契約へ含め、VoiceOverとTalkBackの実機flowをrelease gateにする。

## §10. performanceとresource budget

- Rule 420.33: performanceはdevelopment modeではなくproduction-equivalent buildと代表的な低・中・高性能deviceで測定する。
- Rule 420.34: startup、time-to-interactive、JS／UI frame、long task、memory、CPU、network、bundle、binary size、batteryにrisk-basedなbudgetとownerを設定し、許容範囲を超える退行を変更受入またはreleaseのblockerにする。数値閾値は対象deviceと利用者分布からBlueprintで定める。
- Rule 420.35: large list、image、animation、navigation、serialization、native callをprofileしてから最適化する。memoization、native移行、cacheを推測で追加せず、before／after証跡を残す。

## §11. securityとprivacy

- Rule 420.36: JS bundle、source map、app config、native resource、build-time environmentにsecretを置かない。public clientからsecretが必要なresourceへはserver-side mediationを設ける。
- Rule 420.37: AsyncStorage等の暗号化されないstorageは非機密データだけに使う。token、credential、暗号鍵、sensitive PIIはKeychain／Keystore-backed storageへ保存し、backup、device migration、logout、account deletionを設計する。
- Rule 420.38: custom URL schemeへtokenやPIIを入れない。Universal Links／App Linksを優先し、OAuthはAuthorization Code + PKCE、state、nonce、exact redirect validationを使用する。
- Rule 420.39: native module、JSI、WebView、deep link、push payload、clipboard、screenshot、local DB、OTA channelをthreat modelへ含める。root／jailbreak検出はsignalとして扱い、server-side認可の代替にしない。

## §12. testing strategy

| Layer | 必須保証 |
|:--|:--|
| Static | format、lint、TypeScript、Codegen schema、Swift／Kotlin compiler |
| Unit | domain、state transition、serializer、error、retry、migration |
| Component | user-visible text／role／interaction。implementation detail依存を避ける |
| Native contract | JS specとSwift／Kotlin実装、thread、error、lifecycle、boundary value |
| Integration | storage、network、navigation、permission、push、deep link、offline |
| Device E2E | iOS／Androidのrelease-equivalent build、実機または高忠実度device farm |
| Non-functional | accessibility、performance、security、upgrade、OTA rollback |

- Rule 420.40: Node.js上のcomponent testはnative platform codeを保証しない。native moduleまたはOS APIを通るcritical flowは両OSのintegration／device testを必須とする。
- Rule 420.41: flaky testの無条件retryを禁止する。quarantineにはowner、Issue、期限を付け、critical release flowのquarantineを禁止する。
- Rule 420.42: device matrixは利用者分布、OS support、CPU／memory、画面、locale、accessibility serviceに基づき、少なくとも最小support OSと現行OSを含める。
- Rule 420.43: upgrade testはclean install、upgrade install、DB migration、auth session、deep link、push、background、offline queue、native module互換性を含む。

## §13. CI、release、OTA update

- Rule 420.44: 変更受入のcapability inventoryはfrozen JS install、format／lint／type／test、Codegen差分、Android release build／test、iOS release build／test、SCA、SBOMを含み、変更影響とartifactに応じて必要gateを選ぶ。JS、native、dependency、Codegen、build／runtime設定へ影響する変更は両platformのrelease buildを受入前に検証し、docs-only等の非影響変更を除外する場合は機械的なimpact根拠を残す。両OS device E2Eは、統合順序を直列化するgate、scheduled validation、release gate等からriskに合う時点をBlueprintで選び、critical flowへの影響時は受入前に行う。全releaseでは両platformの完全gateを通す。PR、merge queue、nightlyは実装例である。
- Rule 420.45: release artifactはJS bundle、source map、dSYM、R8 mapping、SBOM、provenance、signing identity、source revision、runtime compatibilityへ追跡可能にする。
- Rule 420.46: OTA updateは任意機能とし、providerにかかわらずnative runtimeとの互換性識別、update署名、channel分離、preview検証、段階配信、health監視、kill switch、previous／embedded版へのrollbackを必須とする。
- Rule 420.47: native code、permission、entitlement、SDK、signing、store metadataの変更をOTAで代替しない。Apple／Googleの現行policyと審査要件をreleaseごとに確認する。

## §14. dependencyとsoftware supply chain

- Rule 420.48: library採用時はmaintainer、release cadence、support OS、New Architecture、Hermes、Expo／bare、license、native code、security advisory、退出可能性を評価し、compatibility matrixへ記録する。
- Rule 420.49: npm、Gradle、CocoaPods、SPM、native binaryを一つのrelease inventoryへ統合し、SCA、license、SBOM、provenanceをartifact単位で検証する。abandoned packageはfork ownerまたは代替期限がなければ採用しない。

## §15. observabilityとincident response

- Rule 420.50: JS errorとnative crash、ANR／hang、startup、frame、network、OTA cohortを同じrelease／session／correlation IDへ結び付ける。source map、dSYM、mapping fileを機密管理し、symbolicationをrelease前に試験する。

最低限query可能にするsignal。dashboard、report、alert queryのいずれでもよい:

- crash-free users／sessions、ANR、iOS hang、fatal JS error
- startup、slow／frozen frame、memory、network failure
- app version、React Native version、native runtime、OTA update ID、device／OS
- rollback条件、owner、on-call route、store hotfix手順

## §16. scalable team governance

- Rule 420.51: app composition、shared JS、iOS、Android、native module、platform／CI、release／OTA、securityにaccountable ownerと継続経路を置く。primary／secondaryは互換表現であり、別人化はrisk-basedに決める。高保証境界は最終revisionへの独立reviewをVCSまたは同等の変更統制で強制する。
- Rule 420.52: Mobile Platform機能は、規模と需要に応じて個人の役割、shared responsibility、virtual group、専任Mobile Platform Teamのいずれかで担い、再利用可能な導入経路、dependency catalog、upgrade運用、device検証能力、design system、observability、release runbookを提供する。product／feature ownerはend-to-end SLOと両OSのproduct behaviorを所有する。

規模に応じた運用要件:

- CODEOWNERSだけに依存せず、ownership registryと変更統制を結び付ける。高保証領域ではrequired checks、stale approval dismissal、latest-change approval、serialized integrationまたは同等能力を設定する。
- React Native、React、Node、Xcode、Android toolchain、native moduleのEOLと互換性を、support eventとBlueprintのrisk-based cadenceでreviewする。四半期reviewは大規模portfolioの参考既定である。
- upgrade capacityを計画へ確保し、unsupported version、legacy architecture、owner不在moduleをquery可能なportfolio report、dashboardまたは同等証跡へ出す。
- brownfieldではnative teamとReact Native teamの二重roadmapを避け、screen／capabilityごとに単一のaccountable ownerを置く。
- incident、store rejection、OTA rollback、certificate失効、dependency compromiseのexerciseをrisk、変更頻度、過去incidentに基づくcadenceで行う。年1回は継続運用する大規模productの参考既定である。

## §17. 例外、成熟度、禁止事項

### 17.1 期限付き例外

New Architecture自体の例外は公式support window内のReact Nativeでは認めない。unsupported legacy runtimeからの緊急移行、Hermes、support window、device gate、security controlからの例外は、ID、scope、理由、risk、compensating control、owner、承認者、期限、退出testを持つ。期限切れは変更受入またはreleaseのblockerとする。

### 17.2 成熟度

| Level | 状態 |
|:--|:--|
| L1 属人的 | JS buildだけがあり、native owner、device test、upgrade方針がない |
| L2 管理 | toolchain pin、両OS build、基本test、crash reportingがある |
| L3 標準化 | New Architecture、typed boundary、再利用可能な導入経路、device matrix、ownership controlがある |
| L4 最適化 | performance budget、統合SBOM、upgrade train、段階OTA、release provenanceがある |
| L5 適応型 | product SLOと実利用dataに基づきarchitecture、dependency、platform差分を継続改善する |

### 17.3 禁止アンチパターン

- React Nativeを言語として扱い、Swift／Kotlin ownerを置かない
- JS unit／component testだけでmobile releaseを承認する
- unsupported React Native minor、0.82以降で無効なLegacy Architecture設定、無期限のlegacy移行例外
- 手書きで重複したJS／Swift／Kotlin interface
- `Platform.OS`分岐の拡散、platform UXの最低公倍数化
- AsyncStorageへのtoken／secret保存、bundleへのsecret埋込み
- runtime compatibility、署名、rollbackのないOTA配信
- development buildだけでperformanceを判定する
- source map、dSYM、R8 mappingの欠落でproduction crashを解析不能にする
- ownerと退出計画のないabandoned native dependency

---

## Appendix A: 逆引き索引とクロスリファレンス

| キーワード | セクション |
|:--|:--|
| Expo、bare、brownfield、library | §2 |
| version、support、Upgrade Helper、lockfile | §3 |
| TypeScript、Metro、platform-specific code | §4、§5 |
| New Architecture、Hermes、Codegen、Fabric、TurboModule | §6、§7 |
| offline、network、deep link、accessibility | §8、§9 |
| performance、JS thread、UI thread | §10 |
| Keychain、Keystore、PKCE、threat model | §11 |
| Jest、component、device E2E、native test | §12 |
| iOS／Android build、OTA、rollback、store | §13 |
| SCA、SBOM、native dependency | §14 |
| symbolication、ANR、hang、source map | §15 |
| CODEOWNERS、Platform Team、upgrade train | §16、§17 |

| 関連正本 | 責務 |
|:--|:--|
| `engineering/320_programming_language_governance.md` | 言語portfolioと共通品質契約 |
| `engineering/410_native_platforms.md` | Swift／Kotlin、iOS／Android固有実装 |
| `engineering/300_web_frontend.md` | React共有概念のうちWeb固有境界。DOM規則は継承しない |
| `security/000_security_privacy.md` | mobile security、secret、storage、deep link |
| `quality/000_qa_testing.md` | test taxonomy、device、non-functional testing |
| `security/200_oss_compliance.md` | SCA、license、SBOM、provenance |
| `operations/400_site_reliability.md` | SLO、observability、incident |
| `product/700_appstore_compliance.md` | Apple／Google store審査と配信 |

### 一次資料

- [React Native Versions](https://reactnative.dev/versions): release cadence、直近3 minorのsupport policy
- [React Native Release Levels](https://reactnative.dev/docs/releases/release-levels): `STABLE`、`CANARY`、`EXPERIMENTAL`の利用境界
- [React Native 0.86](https://reactnative.dev/blog/2026/06/11/react-native-0.86): 2026-06-11時点の安定版とsupport window更新の確認点
- [About the New Architecture](https://reactnative.dev/architecture/landing-page): New Architecture既定化と移行
- [React Native 0.82 — A New Era](https://reactnative.dev/blog/2025/10/08/react-native-0.82): 0.82以降のNew Architecture only境界
- [Native Platform](https://reactnative.dev/docs/native-platform): Turbo Native Modules、Fabric、legacy API移行
- [Codegen](https://reactnative.dev/docs/the-new-architecture/what-is-codegen): 型付きspecとplatform code生成
- [Hermes](https://reactnative.dev/docs/hermes): 同梱Hermesと既定engine
- [Testing](https://reactnative.dev/docs/testing-overview): static、unit、component、integration、E2EとJS testの限界
- [Performance](https://reactnative.dev/docs/performance): release buildでのJS／UI thread性能検証
- [Security](https://reactnative.dev/docs/security): bundle secret禁止、AsyncStorage、secure storage、deep link、PKCE
- [Upgrading](https://reactnative.dev/docs/upgrading): Android／iOS／JavaScript三層upgradeとUpgrade Helper
- [Expo runtime versions](https://docs.expo.dev/eas-update/runtime-versions/)、[code signing](https://docs.expo.dev/eas-update/code-signing/)、[rollouts](https://docs.expo.dev/eas-update/rollouts/)、[rollbacks](https://docs.expo.dev/eas-update/rollbacks/): OTA互換性、署名、段階配信、rollback
- [Apple App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)、[Google Play Device and Network Abuse Policy](https://support.google.com/googleplay/android-developer/answer/16559646?hl=en): executable codeとstore policy境界
