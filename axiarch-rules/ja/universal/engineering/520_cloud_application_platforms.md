# 520. クラウド・アプリケーションプラットフォームガバナンス

> [!CAUTION]
> このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。
> 改定日: 2026-07-23

> [!IMPORTANT]
> 主要方針: platformは開発速度を買う手段であり、責任、データ、可用性、費用、退出可能性を譲渡する契約ではない。Vercel、Supabase、Firebase、Cloudflare、hyperscaler、container PaaS、self-hosted基盤を同じ成果契約で比較し、特定vendorのdashboard操作をUniversalな唯一解にしない。
> 22セクション・Rule 520.1–520.89。

---

## 目次

| セクション | トピック |
|:--|:--|
| §1 | 適用範囲とUniversal適用契約 |
| §2 | platform portfolioと採用判断 |
| §3 | 共有責任と制御面 |
| §4 | organization、account、team統治 |
| §5 | 環境分離と変更昇格 |
| §6 | artifact、deployment、rollback |
| §7 | identity、secret、configuration |
| §8 | data、state、migration、backup |
| §9 | runtime、network、edge、cache |
| §10 | security、privacy、供給網 |
| §11 | observability、SLO、incident |
| §12 | FinOps、quota、capacity |
| §13 | portability、exit、DR |
| §14 | 主要platform profile |
| §15 | team利用とPlatform Engineering |
| §16 | CI gate、例外、成熟度 |
| §17 | SDK・client interface lifecycle |
| §18 | managed async・event delivery contract |
| §19 | local／emulatorからmanaged環境へのconformance |
| §20 | provider-managed integration／extension lifecycle |
| §21 | multi-service application composition／aggregate release |
| §22 | BaaS capability・identity portability統治 |
| Appendix A | 逆引き索引、クロスリファレンス、一次資料 |

---

## §1. 適用範囲とUniversal適用契約

- Rule 520.1: 本ファイルは、managed hosting、frontend platform、BaaS、serverless、edge runtime、container PaaS、hyperscaler、Kubernetes、self-hosted application platformの選定と横断統治の正本である。
- Rule 520.2: database、認証、mobile、web、SRE、FinOps、securityの詳細は各domain正本を優先し、本ファイルはplatform間の責任分界、変更昇格、証跡、退出可能性を接続する。
- Rule 520.3: vendor名、plan名、role名、dashboard、CLI、固定limit、料金、region、preview機能は参考実装または時点情報である。採用時と重要変更時に公式document、契約、利用accountのeffective settingを再確認する。
- Rule 520.4: Universalな必須事項は、安全性、再現性、追跡可能性、所有、回復性、費用境界、data portabilityである。人数、provider、環境数、承認段階、SLO、予算閾値はriskに基づくBlueprint parameterとする。

### 1.1 解釈レイヤー

| レイヤー | 規範性 | 例 |
|:--|:--|:--|
| 不変成果 | 必須 | least privilege、review可能な変更、backup restore、rollback、cost attribution |
| capability contract | 該当時必須 | preview、WAF、branch、queue、stateful primitive等を採用する際の成果 |
| provider profile | 条件付き | Vercel、Supabase、Firebase、Cloudflare等の現在機能への写像 |
| Blueprint parameter | project固有 | plan、region、quota、budget、owner、SLO、retention |

## §2. platform portfolioと採用判断

- Rule 520.5: platformは「web hosting」「application compute」「data/auth」「edge/network」「async/event」「observability」のcapability単位で棚卸しし、一社採用と複数社採用の両方を許容する。
- Rule 520.6: 採用ADRには、workload、data classification、latency、regional availability、runtime compatibility、operational burden、team capability、support、compliance、unit economics、exit costを記録する。
- Rule 520.7: 無料枠、初期開発速度、人気、frameworkの自動検出だけでproduction platformを決めない。定常時とabuse／spike時の費用、quota挙動、停止時の影響を比較する。
- Rule 520.8: 同じcapabilityを複数providerで重複させる場合、availability、regulation、migration、acquisition等の目的と、二重運用のcomplexity budget、owner、退出条件を持つ。

### 2.1 capability評価表

| 軸 | 必須質問 | 証跡例 |
|:--|:--|:--|
| workload fit | request、batch、stream、state、GPU、background処理に適合するか | benchmark、limit表、ADR |
| control | IAM、network、encryption、audit、policyを必要粒度で統制できるか | responsibility matrix、policy export |
| delivery | preview、promotion、canary、rollback、migrationを分離できるか | pipeline、deployment record |
| operation | SLI、logs、traces、status、support、incident exportがあるか | dashboard-as-codeまたはquery、runbook |
| economics | unit cost、quota、egress、build、logging、seat、add-onを説明できるか | cost model、budget action |
| exit | code、data、identity、domain、secret、telemetryを移行できるか | exit rehearsal、export test |

## §3. 共有責任と制御面

- Rule 520.9: providerが管理する物理基盤、runtime、control planeと、利用者が管理するcode、data、identity、configuration、business continuityを責任matrixで分離する。「managed」を「責任不要」と解釈しない。
- Rule 520.10: control plane、data plane、build plane、observability planeを別のtrust boundaryとして扱い、各面のidentity、network path、logging、break-glassを定義する。
- Rule 520.11: dashboardで変更可能な設定もconfiguration source、owner、review、drift detectionを持つ。公式APIまたはIaCで表現できない例外は、before／after、actor、理由、期限を記録する。
- Rule 520.12: provider status、quota、support、billing、certificate、DNS、identity providerの障害を外部依存台帳へ登録し、failure modeとdegraded modeを決める。

## §4. organization、account、team統治

- Rule 520.13: production resourceは個人accountではなく、継続可能なorganization、team、folder、subscription、accountまたは同等の所有境界に置く。
- Rule 520.14: roleはjob functionと環境で分け、owner／billing／security／developer／viewer等のprovider roleをそのまま信用せず、effective permissionを検証する。read-only roleがsecret metadataまたは値を閲覧できる場合もriskへ含める。
- Rule 520.15: production deploy、secret閲覧、billing変更、domain移管、log export、project削除、backup restoreはsensitive operationとして、riskに応じたstep-up、独立承認、通知、不変監査を適用する。
- Rule 520.16: joiner／mover／leaver、SSO、SCIMまたは同等provisioning、service identity、外部contributor、support accessを一つのaccess lifecycleで管理し、orphan accountとshared credentialを検出する。

## §5. 環境分離と変更昇格

- Rule 520.17: local、preview、test、staging、productionは必要なrisk境界に応じて分離する。環境名や個数ではなく、credential、data、domain、quota、billing、access、blast radiusの分離成果を検証する。
- Rule 520.18: preview環境をpublicな無認証環境にしない。production data、secret、OAuth callback、webhook、email送信、検索index、analyticsをpreviewへ無差別複製しない。
- Rule 520.19: configuration、schema、runtime、build、routing、firewall、feature flagを同じrevisionとpromotion recordへ結び付ける。環境ごとの差は型付きconfigurationとpolicyで宣言する。
- Rule 520.20: production昇格は、検証済みartifactまたはversionを再buildせずpromoteできる場合は同一物を使う。再buildが必要なplatformではsource、dependency、builder、configuration差分をprovenanceで検証する。

## §6. artifact、deployment、rollback

- Rule 520.21: source revision、resolved dependency、builder、runtime、configuration、artifact digest、deployment ID、actor、environment、時刻をrelease evidenceへ結ぶ。managed runtimeでは宣言上のruntime識別子だけでなく、観測可能なprovider runtime build、base image、buildpack／adapter、更新modeを実行revisionへ関連付ける。
- Rule 520.22: upload／buildとtraffic切替を分離できるplatformでは、smoke、security、contract、migration compatibilityを通したversionだけを段階昇格する。分離できない場合は同等のpreviewと即時切戻しを用意する。
- Rule 520.23: code rollbackはdatabase、queue、object storage、KV、cache、Durable Object、external side effectを戻さない。rollback runbookにはstate compatibility、forward fix、cache purge、replay、compensationを含める。
- Rule 520.24: gradual deploymentはversion skewを発生させる。API、event、session、cache key、state schemaをN/N-1互換にし、affinityまたはversion overrideは必要な整合性を満たす手段として使う。

## §7. identity、secret、configuration

- Rule 520.25: human、CI、runtime、provider integration、supportを別identityとし、可能な経路ではOIDC／workload identityと短命credentialを優先する。
- Rule 520.26: public client key、publishable key、secret key、service role、admin credentialの性質を台帳化し、browserへ送信可能な識別子と権限credentialを名称だけで判断しない。
- Rule 520.27: secretはenvironmentとserviceに最小scopeで注入し、source、preview comment、build log、artifact、client bundle、telemetryへ残さない。閲覧、更新、失効を監査する。
- Rule 520.28: configuration schemaは未知値、欠落、環境違いをbuildまたはstartupでfail closedし、secret rotation、provider key migration、certificate更新をdual-read／dual-key等で無停止検証する。

## §8. data、state、migration、backup

- Rule 520.29: authoritative data store、cache、derived view、file object、identity record、analytics、configurationのsystem of recordを明示し、providerごとの暗黙的な二重正本を作らない。
- Rule 520.30: schemaとdata変更はversion管理されたmigrationまたは承認済みrunbookで行い、codeとのexpand-contract、seedの機密除去、preview dataの合成、drift detectionを実装する。
- Rule 520.31: provider branch、preview database、emulatorはproduction data copyを既定にしない。data-less環境、synthetic seed、masked subsetのどれを使うかをprivacyとtest realismで選ぶ。
- Rule 520.32: provider backupの存在だけでDR完了としない。対象resource、保持、暗号、削除時挙動、account喪失、region障害、off-platform copy、restore時間、整合性を実際に復元検証する。

## §9. runtime、network、edge、cache

- Rule 520.33: 宣言したlanguage／runtime識別子、provider管理のpatch／build、base OS／image、framework adapter／buildpack、compatibility date／flag、region、CPU、memory、duration、concurrency、connection、subrequest、bundle、payload等のeffective contractをmachine-readable inventoryへ記録し、公式変更と実効driftを監視する。
- Rule 520.34: edge、serverless、container、VM、Kubernetesをlatencyだけで選ばず、state、library compatibility、connection model、background execution、cold start、debug、cost、data gravityを評価する。
- Rule 520.35: provider内部binding、private network、service discoveryを使える場合はpublic Internet経由より優先するが、認証・認可を省略しない。outbound destination、SSRF、egress、DNS、TLSを統制する。
- Rule 520.36: cache key、tenant、auth、locale、version、privacy、purge、stale policyを契約化する。deployやrollbackがstateful cacheを自動無効化すると仮定せず、cross-version behaviorをtestする。

## §10. security、privacy、供給網

- Rule 520.37: WAF、DDoS対策、bot管理、App Check、deployment protection等はdefense in depthであり、application認可、rate limit、input validation、abuse detectionの代替にしない。
- Rule 520.38: build integration、marketplace app、Git provider、deploy hook、MCP、CLI、support toolを第三者principalとして扱い、scope、install actor、更新、data retention、revocationをreviewする。完全なlifecycle契約は§20で定義する。
- Rule 520.39: buildとdeployはpinned toolchain、locked dependency、SCA、SBOM、secret scan、artifact provenanceを持つ。providerが生成するartifactにもsource revisionと最終digestの追跡可能性を要求する。
- Rule 520.40: data residency、subprocessor、support access、telemetry retention、backup location、AI機能へのdata利用を契約とeffective settingで確認し、marketing上の地域名だけで法的適合を断定しない。

## §11. observability、SLO、incident

- Rule 520.41: request、build、deployment、control-plane change、billing、security eventを相関できるIDと時刻で結び、logs、metrics、traces、auditを外部保管またはquery可能にする。
- Rule 520.42: platform metricだけでなくuser journeyとbusiness outcomeのSLIを持つ。provider uptimeをapplication SLOの代替にしない。
- Rule 520.43: sampling、retention、cardinality、PII scrub、log volume costを設計し、incident時に必要なevidenceを保持する。console出力の量をobservability成熟度と見なさない。
- Rule 520.44: provider incident時のstatus確認、support escalation、traffic shift、feature degradation、credential revocation、evidence preservation、customer communicationをrunbook化し、定期exerciseする。

## §12. FinOps、quota、capacity

- Rule 520.45: request、compute、duration、memory、storage、operation、egress、build、log、trace、seat、domain、support、add-onをcost driverとしてservice／environment／ownerへ配賦する。
- Rule 520.46: budget alert、spend cap、automatic pause、quotaは同一ではない。対象外usage、反映遅延、fail-open／fail-closed、503等の顧客影響を確認し、単一のcost controlへ依存しない。
- Rule 520.47: loop、retry storm、cache miss、log explosion、abuse、preview leak、branch放置、unbounded fan-outをcost incidentとして検出し、rate、concurrency、instance、queue、retentionへ安全上限を置く。
- Rule 520.48: capacityはproviderの「自動scale」を根拠に無制限と見なさず、quota、connection、hot key、regional capacity、support lead time、cost ceilingを負荷試験とforecastで検証する。

## §13. portability、exit、DR

- Rule 520.49: portabilityは「一切のvendor機能を使わない」ことではない。strategic differentiationを生むmanaged capabilityは利用し、data、domain、identity、protocol、artifact、telemetryの退出境界を意図的に設計する。
- Rule 520.50: exit planにはexport形式、量、所要時間、egress費、encryption key、DNS、certificate、OAuth、webhook、queue、scheduled job、data validation、parallel run、rollbackを含める。
- Rule 520.51: critical workloadはprovider、account、region、control planeのfailureを分類し、backup provider、degraded static path、queue buffering、manual operation等からbusinessに必要なrecoveryを選ぶ。
- Rule 520.52: provider移行を年次儀式として一律強制しないが、API deprecation、pricing change、support failure、M&A、regulation、capacity不足等のtriggerと、export／restoreのrisk-based rehearsal cadenceを定める。

## §14. 主要platform profile

- Rule 520.53: Vercelはfull-stack web、preview、managed build／deployment、functions、edge／CDNのprofileとして扱う。roleとenvironmentを分離し、previewを保護し、検証済みdeploymentのpromotionとrollbackをcode外state変更から分ける。runtimeのOIDCとCLI／CIのdeploy認証を同一視せず、各経路でproviderが対応する最小権限credentialを使う。Spend Managementの通知・webhook・pauseは、全費用の即時hard capとは見なさない。
- Rule 520.54: SupabaseはPostgreSQL、Auth、Storage、Realtime、Edge Functionsのprofileとして扱う。exposed schemaのgrantとRLSを別統制として検証し、branchの固有credentialとdata-less既定、migration／config、backup／PITR、Spend Cap対象外usageを確認する。
- Rule 520.55: Firebase／GCPはmobile／web SDK、Auth、Security Rules、App Check、Firestore／Data Connect、Hosting／App Hosting、Cloud Run、event基盤のprofileとして扱う。App Checkはuser認証・認可の代替にせず、client SDKのSecurity Rulesとserver SDKのIAM境界をtestする。Blaze等の課金planは利用capabilityが要求する場合だけ選び、budget alertをhard capと誤認しない。
- Rule 520.56: CloudflareはDNS、CDN、WAF、Zero Trust、Workers、KV／R2／D1／Durable Objects／Queues等のedge platform profileとして扱う。Worker versionは関連stateをversion化しないため、gradual deployment、version skew、binding／migration互換、rollback、cache invalidationを別々に検証する。

### 14.1 補完profile

| profile | 代表例 | 主な追加責任 |
|:--|:--|:--|
| hyperscaler | AWS、Azure、Google Cloud | organization hierarchy、landing zone、IAM、network、region、service quota、IaC、shared responsibility |
| enterprise／regional／sovereign cloud | Oracle Cloud Infrastructure、IBM Cloud、Alibaba Cloud、Tencent Cloud、OVHcloud等 | jurisdiction、data residency／sovereignty、organization／account hierarchy、IAM federation、managed runtime／container契約、interconnect／egress、support、marketplace、exit |
| frontend／web platform | Vercel、Netlify、Cloudflare | build provenance、preview protection、cache、edge runtime、domain、deployment promotion |
| BaaS／data platform | Supabase、Firebase、AWS Amplify、Appwrite、Convex、managed database等 | capability別schema、RLS／Rules／IAM、backup、identity／data portability、connection、egress |
| container PaaS | Cloud Run、Azure Container Apps、AWS App Runner、DigitalOcean App Platform、Render、Railway、Fly.io、Heroku等 | image、health、scale-to-zero、volume、network、job、region、rollback |
| orchestrated／self-hosted | Kubernetes、Nomad、VM、自社基盤 | control plane、patch、capacity、backup、on-call、supply chain、upgrade burden |

### 14.2 言語・runtime surfaceの解釈

「platformが言語Xに対応する」という表現は、client SDK、build input、first-class execution runtime、community runtime、container、Wasm compile targetを区別しない限り使用しません。採用判断では、各surfaceのprovider support、maturity、EOL、deployment unit、effective limit、debug／observability、artifact provenance、SBOM、rollbackを別々にinventory化します。

| platform profile | 区別すべきsurface |
|:--|:--|
| Vercel | current公式Function runtime、community runtime、Edge runtime、Wasm、polyglot service capabilityを分離する。beta／experimental機能は利用可能という理由だけでStandardへ昇格させない |
| Supabase | PostgreSQL／SQL、Deno互換Edge Functionsのruntime、client SDK言語、community clientを分離する |
| Firebase／GCP | mobile／web client SDK、Functions runtime、Cloud Runのcontainer言語、event sourceを分離する |
| Cloudflare | first-class Workers言語、JavaScript APIへ接続するbinding、Wasm compile pathを分離する。compatibility date／flag／bindingから生成したruntime typeと実artifactの一致をCIで検証する |
| hyperscaler FaaS | AWS Lambda、Azure Functions等ではmanaged language runtime、worker model、OS-only／custom handler、container imageを分離し、各support level、EOL、patch責任、runtime update modeを確認する |
| frontend／edge platform | Netlify等ではbuild対象、standard function、edge runtime、framework adapterを分離し、同じTypeScript／JavaScriptでもAPI、package、duration、region、rollback契約が同じと仮定しない |
| container PaaS | Cloud Run、Render、Railway等ではnative／auto-detected build、buildpack、source-to-image、持込containerを分離する。「任意言語をcontainerで実行可能」をfirst-class language supportと同一視しない |

2026-07-23時点の[Vercel Functions Runtimes公式資料](https://vercel.com/docs/functions/runtimes)はNode.js、Bun、Python、Rust、Go、Ruby、Wasm、Edgeをofficial runtimeとして、Bash、Deno、PHPをrecommended community runtimeとして区分する。これをVercel全体の言語support表とは解釈せず、各runtimeのrelease channel、API、filesystem、streaming、duration、region、failover、isolation、observability、build artifact、support authorityを別々に検証する。community runtimeやRuntime API／Build Output API経路には、publisher continuity、security advisory、artifact provenance、rollback、provider support外のfailure ownerを追加する。

2026-07-23時点の[Vercel Services公式ガイド](https://vercel.com/kb/guide/vercel-services)では、top-levelの`services`で複数serviceを宣言し、serviceは既定でinternal、外部公開はtop-level routing／rewriteで明示し、service間通信はbindingを使う。これはRule 520.80–520.83をVercelへ写像した時点付きimplementation profileであり、Universalなconfig形式ではない。旧`experimentalServices`の設定例を現行projectへ機械的に持ち込まず、導入・移行時に公式config schema、release channel、public route、binding、custom runtime supportを再確認し、effective configurationとmanaged smoke evidenceを保存する。

2026-07-23時点の[Cloudflare Workers Languages公式資料](https://developers.cloudflare.com/workers/languages/)はJavaScript、TypeScript、Python、Rustをfirst-classなlanguage surfaceとして列挙する一方、[Python Workers固有資料](https://developers.cloudflare.com/workers/languages/python/)はPythonをopen betaとし、compatibility flagを要求している。したがってfirst-classな統合面とrelease maturityを同じ軸にせず、言語ごとの固有資料を優先する。その他のC／C++、Kotlin、Go等はWebAssembly経路として区別し、採用時は実効support status、binding bridge、standard library、package、cold start、debug、observability、security update、rollbackをworkloadごとに検証する。

Wasmへcompile可能であることは、そのsource言語の全standard library、thread、filesystem、socket、debug、performance、security modelをplatformがfirst-class supportすることを意味しません。対応表にはcapability、support主体、maturity、deployment unit、制約、検証証跡を併記し、marketing上の「対応言語数」を成熟度指標にしません。

managed runtimeはsource revisionやapplication artifactを変更せず更新され得ます。採用時は、automatic、deploy連動、manual pin、container rebuild等の更新mode、security patch責任、段階rollout、region／architecture差、実効runtime identityの取得手段、回帰時の切戻しを台帳化します。providerが推奨するsupportedな自動更新を通常の安全既定とし、manual pinや更新停止は一時的な互換性緩和としてowner、期限、patch gap、再検証条件を持たせます。containerまたは持込base imageでは、providerのmanaged runtime patchを期待せず、再build、scan、deployを採用側が所有します。runtime、buildpack、adapter、base imageの変更eventでは、source無変更でもriskに応じたsmoke、contract、performance、security、observability検証を起動します。

## §15. team利用とPlatform Engineering

- Rule 520.57: team規模にかかわらず、platformごとにaccountable owner、security、billing、operations、data、developer enablementの責務を割り当てる。個人または小規模teamは兼務できるが継続経路を持つ。
- Rule 520.58: Golden Pathはproject creation、identity、environment、secret、domain、observability、budget、deploy、rollback、decommissionを再現可能にし、escape hatchと例外期限を持つ。
- Rule 520.59: central platform teamを全組織へ強制しない。複数teamや高保証環境ではself-service、policy-as-code、usage analytics、support SLOを持つPlatform Engineering機能を段階的に設ける。
- Rule 520.60: provider console knowledgeを少数者へ閉じ込めず、runbook、ownership registry、architecture decision、cost model、incident record、access recoveryをteamが検索・引継ぎ可能にする。

## §16. CI gate、例外、成熟度

- Rule 520.61: platform変更のCIは、config schema、IaC validate、policy、secret、dependency、SBOM、build、contract、migration、provider runtime／buildpack／base image drift、preview smoke、security、cost diff、rollback readinessを影響範囲に応じて実行する。
- Rule 520.62: deployment前のEvidence Packetにはsource、artifact、environment diff、data impact、observability、cost impact、owner、approval、rollback、known limitationを含める。
- Rule 520.63: provider制約で満たせない要件は、risk、scope、compensating control、owner、期限、exit triggerを持つ例外として管理する。plan upgradeだけを唯一の解決策にしない。
- Rule 520.64: 成熟度は、L1手動・個人依存、L2再現可能build、L3policyと環境昇格、L4統合SLO／FinOps／security、L5検証済みself-service／DR／exitの成果で測り、採用製品数で測らない。

## §17. SDK・client interface lifecycle

- Rule 520.65: platformへの言語対応を、packageが存在することだけで認定しない。言語・platform・serviceごとに、公式、community、生成client、protocol直接利用、runtime同梱SDKを区別し、support主体、maturity、対応API、version互換範囲、release／security update、EOL、license、認証方式をmachine-readable inventoryへ記録する。
- Rule 520.66: SDK間のfeature parityを仮定しない。Auth、data query／transaction、Realtime／streaming、Storage、Functions／events、local emulator、schema／type generation、retry／pagination、telemetryについて、必要capabilityとpositive／negative contract testを言語ごとに定義する。client SDKの公開credential・Rules／RLS境界と、server／admin SDKのworkload identity・IAM境界を同一視しない。
- Rule 520.67: schemaまたはAPIからclientを生成する場合は、schema digest、generator、template、runtime、生成artifactをpinし、手修正を禁止する。platform API、SDK、生成client、consumerのversion skewをcompatibility testで検証し、deprecated APIまたはSDK major versionの移行をowner、期限、rollbackとともに管理する。
- Rule 520.68: community SDKまたは未提供言語をproductionで使う場合は、maintainer continuity、security advisory経路、release遅延、機能欠落、platform support範囲をrisk acceptanceへ記録し、直接REST／gRPC等の公開protocol、内部adapter、別の公式SDK利用service等から実現可能なfallbackを持つ。共通wrapperは認証、retry、error、pagination等の差を隠して第二の非公式platform APIを作らず、必要最小限の安定境界とcontract testに限定する。

## §18. managed async・event delivery contract

- Rule 520.69: queue、topic、stream、event trigger、scheduled／durable workflowごとに、producerから各consumerと最終side effectまでのat-most-once／at-least-once／exactly-once等のdelivery mode、ack／lease／visibility timeout、ordering scopeとpartition key、retry／backoff／retention、batchとpartial failure、payload／serialization、concurrency／backpressure、rate／quota、region／residencyをmachine-readable contractへ記録する。providerの「guaranteed」「exactly once」「ordered」という名称だけでend-to-end保証を推定せず、適用範囲、成立条件、失効条件を公式仕様とtestで確認する。
- Rule 520.70: end-to-endで実証できない経路はduplicate delivery、redelivery、out-of-order、concurrent processingを前提にする。consumerはstableなbusiness identityからidempotency keyを導出し、claimとstate transitionまたはside effectをtransaction、inbox／outbox、conditional write、dedup store等の適切な原子境界で保護する。producer側dedup、broker内exactly-once、message IDの一意性は、payment、email、外部API、複数data store等の下流副作用が一度だけになる証明ではない。
- Rule 520.71: retryは分類済みのtransient failureへ限定し、attemptまたはevent age、exponential backoffとjitter、timeout、cancellation、concurrency、cost ceilingをboundedにする。permanent failure、schema不正、期限切れ、poison messageはDLQまたは同等のquarantineへ移し、providerにbuilt-in DLQがなければ必要payloadとfailure metadataを保持するapplication-level quarantineを実装する。inspect、discard、redrive、replayは認可、PII保護、監査、dry-runまたは対象preview、idempotency、rate／cost上限、停止手段、実行証跡を伴うsensitive operationとして扱う。
- Rule 520.72: event payloadのschema、owner、compatibility、deprecation、data classificationは`engineering/740_data_contracts.md`を正本とする。platform delivery envelopeにはstable event ID、event type、schema version、producer、occurred／published time、correlation／causation、trace context、該当時のtenant／subjectと最小payloadを定義し、historical、duplicate、out-of-order、delayed、unknown field／type、malformed、partial-batchをcontract testとreplay testで検証する。運用ではbacklog depth／age、delivery attempt、ack／lease failure、retry／DLQ／quarantine、end-to-end latency、loss／dedup anomaly、fan-out、cost per eventをownerとSLO／alertへ結び、drain、replay、rollback、provider exitのrunbookを持つ。

## §19. local／emulatorからmanaged環境へのconformance

- Rule 520.73: productionで使用するmaterialなplatform capabilityごとに、test double、local process／container、provider emulator、local runtimeとremote binding、managed preview／sandbox／staging、production canary等の検証surfaceを必要な粒度で分類し、どの実行runtime、API、identity、network、region、quota、concurrency、timer、cache、event、control plane、billingを再現するか、再現しないかをmachine-readableなfidelity matrixへ記録する。localまたはemulatorの成功をmanaged IAM、service configuration、quota、regional behavior、provider integration、performance、securityの同等性証明にしない。managed semanticsへ依存しないcapabilityは、根拠を記録してmanaged testを非該当にできる。
- Rule 520.74: 各fidelity profileは、source revision、CLI／emulator／local runtime、SDK／adapter、service API、configuration／compatibility setting、schema／generated binding、target environmentを検証結果へ結ぶ。provider、runtime、toolchain、SDK、binding support、quota、default、security policyの変更eventでは、影響するprofileを再評価し、local fixture／mockが現行managed contractからdriftしていないことをcontract testまたは同等のevidenceで確認する。
- Rule 520.75: production前に、localで忠実に再現できないmaterial behaviorを、最も低costで安全なprovider-managed隔離環境または同等の高fidelity surfaceでrisk-basedに検証する。対象には該当時、positive／negative authorization、effective configuration、runtime limit、network／region、callback／event、storage／data isolation、concurrency／retry／clock／cache、observability、quota／costを含める。remote resourceやephemeral managed環境はproduction dataとcredentialを既定で使わず、isolated identity、syntheticまたは適切に保護されたdata、least privilege、owner、source revision、TTLまたは明示したretention／cleanup trigger、cost attribution、cleanupまたはdestroy evidenceを持つ。必要なmanaged検証を利用できない場合は、未検証差分、残存risk、補償統制、staged rollout、kill switch、再評価triggerをrelease evidenceへ記録する。

## §20. provider-managed integration／extension lifecycle

- Rule 520.76: materialなprovider-managed integrationであるmarketplace app、extension、plugin、connector、binding、managed add-onまたは同等機能ごとに、publisher／support主体、maturity、承認済みsource、effective version／release channel、license／terms、data flow／subprocessor、作成または共有resource、API、scope／effective permission、installer／runtime identity、secret／対象環境、webhook／network path、region／retention、billing unit／payer、accountable owner、dependent、exit routeを台帳化する。実在するcode package、control-plane principal、managed resource、configuration binding、commercial subscriptionを分けて分類し、package SBOMだけでこのlifecycleを網羅したとみなさない。
- Rule 520.77: install、update、reconfiguration、plan変更、permission拡張、publisher移管、環境接続をprivileged supply-chain／control-plane changeとして扱う。providerが対応する場合は承認済みでreview可能なmanifest、IaC、APIまたは同等sourceを使い、対応しない場合はbefore／afterを保存する。least privilege、identity分離、環境／tenant分離、install actor、effective permission diff、configuration／secret target diff、price／terms impact、positive／negative authorization、risk-basedな独立承認とstaged validationを必須とする。新しいscope、resource、data destination、terms、price、version channelを自動承認せず、consoleまたはprovider側のdriftを承認済み状態との差分として検出する。
- Rule 520.78: integrationのhealth、audit、dependency、quota、unit cost、budget、retry／queue、provider status、deprecation、support signalをownerとdegraded-mode runbookへ結ぶ。disabled integration、退職またはdeprovision済みinstaller、orphan identity、credential／webhook expiry、permission／version drift、upstream lifecycle eventを検出し、credentialをrotateし、riskに応じてkill switchまたは安全なbypassを演習する。integration、secret、environment variable、binding、drain、managed resourceが利用不能または削除された場合のdeploy／runtime挙動を検証する。
- Rule 520.79: decommissionではprovider-owned resourceと、customer data、generated artifact、shared database／bucket、identity、secret、environment variable、webhook、drain、callback、DNS、branch、retained copy、billingを区別するimpact graphを作る。export、retention、deletion、privacy obligationを定義し、新規writeを止め、必要時はrollbackまたはparallel runを保持し、access revoke、uninstall、残存resource cleanup、orphan scan、billing停止、dependent healthを確認してcleanup evidenceを保持する。uninstallまたはdisconnectedという表示だけを、data、access、cost、dependentが除去された証明にしない。

## §21. multi-service application composition／aggregate release

- Rule 520.80: 複数のdeploy可能unitで一つのproductまたはuser journeyを構成する場合は、repository形態やprovider project数にかかわらずservice graphをmachine-readableに管理する。各unitのstable ID、accountable owner、言語／runtimeとsupport状態、source／build root、artifact／deployment unit、public route／internal endpoint、upstream／downstream contract、identity、secretの値を含まないsecret reference／configuration metadata、authoritative data／state、region、SLO、cost attribution、decommission dependencyを記録する。monorepoを単一deployment、同一domainを単一failure boundary、複数directoryをmicroserviceと自動解釈しない。
- Rule 520.81: applicationのrelease topologyをindependent、coordinated、aggregateまたはその明示した組合せとして宣言し、対象source revision、各unitのartifact digest／deployment ID、runtime、effective configuration、route、service discovery／binding、schema／migration、feature stateをaggregate release recordまたは同等のquery可能な証跡へ結ぶ。providerの「一括deploy」という名称だけでbuild、activation、traffic切替、state変更の原子性を推定せず、partial build／deploy、欠落dependency、stale binding、route overlap／reserved path／base-path conflict、preview URLまたはgenerated endpointのdriftをpreflightとmanaged-environment smokeで検出する。
- Rule 520.82: cross-unit変更はconsumer-driven contract、N/N-1または明示した互換window、expand-contract、additive producer → compatible consumer → cleanup等の安全な順序で進める。順序依存は隠さずpipeline gateへ表現し、各unitとapplication全体についてpause、rollback、roll-forward、traffic shift、feature disable、data compensationの成立範囲を定義する。一つのunit、routing rule、platform deploymentのrollbackが、他unit、database、queue、cache、外部side effectまで戻すと仮定しない。
- Rule 520.83: CIは変更影響graphから該当unitのnative gate、cross-language contract、route／binding／identity policy、integration、end-to-end journeyを選び、shared contract、base image、toolchain、platform config等の横断変更では全dependentを再検証する。path filterのみを安全証明にしない。運用はunit別とapplication全体のhealth、trace、SLO、security signal、quota、unit cost、deployment statusを相関し、owner変更、access lifecycle、partial-outage runbook、rollback／restore exercise、service追加／統合／廃止を同じteam governanceへ含める。

## §22. BaaS capability・identity portability統治

- Rule 520.84: BaaSまたはfull-stack platformというproduct labelを採用・support・release・退出の最小単位にしない。Auth、database／data API、file／object storage、functions／compute、Realtime／streaming、queue／scheduler、search／vector、AI、analytics、hostingをcapabilityへ分解し、managed cloud、self-hosted、hybrid等のdeployment modeごとに責任、support、data、identity、cost、SLO、exitを判定する。AWS Amplify、Appwrite、Convex等の製品名は代表例であり、Universalな必須製品ではない。
- Rule 520.85: productionで利用する各capabilityを、少なくともprovider／service、deployment mode、maturity／support authority、client／server／protocol等のsurface、environment、data classification、system of record、authorization boundary、region／residency、language／runtime／SDK、configuration source、migration、backup／restore、cost driver、SLO、accountable owner／continuity route、evidence reference、exit evidence、exception IDへ結ぶmachine-readable capability manifestで管理する。利用しないfieldは黙って削除せず、非該当理由を記録する。

```yaml
platform_capabilities:
  schema_version: 1
  reviewed_at: "YYYY-MM-DD"
  entries:
    - id: "auth-primary"
      provider: "<provider>"
      service: "<service>"
      deployment_mode: "managed"
      maturity: "ga"
      surfaces: ["client-sdk", "server-sdk", "control-plane"]
      environments: ["production"]
      data_classification: ["identity"]
      system_of_record: true
      authorization_boundary: "<policy-source>"
      regions: ["<approved-region>"]
      language_runtime_sdk: ["<supported-surface>"]
      configuration_source: "<reviewable-source>"
      migration: "<versioned-contract>"
      backup_restore: "<verified-evidence>"
      cost_drivers: ["<billing-unit>"]
      slo: "<service-objective>"
      owners:
        accountable: "<owner>"
        continuity: "<alternate>"
      evidence_refs: ["<evidence>"]
      exit_evidence: "<export-or-recovery-proof>"
      exception_ids: []
```

- Rule 520.86: browser／mobile client SDK、server／admin SDK、direct protocol／data API、runtime binding、CLI、dashboard／control plane、webhook／event、emulatorを別trust surfaceとしてinventory化する。各surfaceでpositive／negative authorization、tenant分離、rate／quota、retry、telemetryを検証し、公開可能なproject identifier／publishable credentialと、service／admin secretをpermission実測で区別する。client側のRules、RLS、App Check等をserver-side IAMまたはbusiness authorizationの代替にしない。
- Rule 520.87: 同一provider内でも各capabilityはrelease、maturity、region、quota、pricing、backup、failure mode、support、EOLが独立する。BaaS全体のstatus、plan、backup、SLA、rollback表示を、個別capabilityまたはend-to-end user journeyの原子的なrelease、recovery、DR証跡と見なさない。capability graphで依存、shared identity、shared billing、state、side effectを関連付ける。
- Rule 520.88: identity portabilityはuser ID、external provider link、password hashのexport可否、MFA／passkey、session／token、consent、group／role／tenant membership、audit history、email／phone verification、削除状態を対象にし、data exportだけで完了としない。非portable要素にはpassword reset、federation、dual run、ID mapping、user communication、reconciliation、rollback／forward-fix、privacy retentionを含む移行経路と演習証跡を持つ。
- Rule 520.89: capabilityのGA／preview／deprecation／EOL、pricing／terms、SDK／runtime、region、limit、security model、incident、M&A、managed／self-hosted責任境界の変化をrevalidation triggerとし、期限切れreview、owner不在、missing evidence、unsupported critical surfaceをrelease gateで検出する。小規模teamは役割を兼務できるが、accountable owner、continuity route、access recovery、billing、incident、exitの責務は省略しない。

## Appendix A: 逆引き索引とクロスリファレンス

### 逆引き索引

| キーワード | セクション |
|:--|:--|
| Vercel、Supabase、Firebase、Cloudflare | §14 |
| platform選定、portfolio、PaaS、BaaS | §1〜§3 |
| RBAC、team、SSO、SCIM、sensitive operation | §4、§15 |
| preview、staging、production、promotion | §5〜§6 |
| secret、OIDC、environment variable | §7 |
| migration、seed、backup、PITR、state rollback | §8、§13 |
| edge、serverless、runtime limit、cache | §9 |
| 言語、runtime、SDK、Wasm、polyglot、buildpack、managed runtime update | §9、§14、§17 |
| WAF、App Check、supply chain、privacy | §10 |
| logs、traces、SLO、incident | §11 |
| budget、Spend Cap、quota、cost incident | §12 |
| portability、vendor lock-in、exit、DR | §13 |
| Golden Path、Platform Engineering、enterprise team | §15、§17 |
| CI、Evidence Packet、例外、成熟度 | §16 |
| 公式／community SDK、feature parity、生成client、protocol fallback | §17 |
| queue、event、delivery、idempotency、ordering、retry、DLQ、replay | §18 |
| local、emulator、mock、fidelity matrix、remote binding、managed conformance | §19 |
| marketplace app、extension、integration、binding、add-on、install、update、uninstall、orphan scan | §20 |
| multi-service、service graph、release topology、aggregate release、route conflict、partial deployment | §21 |
| BaaS capability manifest、AWS Amplify、Appwrite、Convex、trust surface、identity portability、service EOL | §14、§22 |

### クロスリファレンス

| 関連正本 | 責務 |
|:--|:--|
| `engineering/100_api_integration.md` | service境界、通信contract、consistency、release topology |
| `engineering/200_supabase_architecture.md` | Supabase／PostgreSQL固有profile |
| `engineering/300_web_frontend.md` | Web framework、rendering、browser品質 |
| `engineering/320_programming_language_governance.md` | runtime、言語、polyglot CI、供給網 |
| `engineering/500_firebase_gcp.md` | Firebase／GCP固有profile |
| `engineering/510_aws_cloud.md` | AWS固有profile |
| `engineering/530_azure_cloud.md` | Microsoft Azure固有profile |
| `engineering/700_batch_backfill_operations.md` | machine-invoked job、失敗計数、DLQ／quarantine |
| `engineering/740_data_contracts.md` | event／data schema、owner、compatibility、classification |
| `operations/400_site_reliability.md` | SLO、release、DR、incident |
| `operations/600_cloud_finops.md` | cloud cost、unit economics、budget |
| `security/000_security_privacy.md` | identity、secret、privacy、secure SDLC |
| `quality/000_qa_testing.md` | platform、migration、release test |

### 一次資料

- [Vercel Deployments](https://vercel.com/docs/deployments/overview)、[Access Roles](https://vercel.com/docs/rbac/access-roles)、[Spend Management](https://vercel.com/docs/spend-management)、[OIDC Federation](https://vercel.com/docs/oidc)、[Function Runtimes](https://vercel.com/docs/functions/runtimes)、[Services](https://vercel.com/docs/services)、[Vercel CLI](https://vercel.com/docs/cli)、[Vercel Firewall](https://vercel.com/docs/vercel-firewall)、[Logs](https://vercel.com/docs/logs)、[DigitalOcean App Platform](https://docs.digitalocean.com/products/app-platform/)
- [Vercel Services現行ガイド](https://vercel.com/kb/guide/vercel-services)、[Vercel Service Bindings](https://vercel.com/changelog/secure-internal-communication-between-services)、[Vercel application structure](https://vercel.com/kb/guide/structure-your-application)、[Cloudflare Service Bindings](https://developers.cloudflare.com/workers/runtime-apis/bindings/service-bindings/)、[Kubernetes Services](https://kubernetes.io/docs/concepts/services-networking/service/)、[Kubernetes Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)、[Cloud Run service revisions](https://cloud.google.com/run/docs/deploying)、[Firebase App Hosting monorepos](https://firebase.google.com/docs/app-hosting/monorepos)、[Firebase multisite hosting](https://firebase.google.com/docs/hosting/multisites): 複数unitは同一deploymentへ束ねる方式、別々にdeployする方式、明示的順序を要する方式があり、repository、domain、provider projectとrelease原子性は一致しない。service graph、互換順序、partial failure、aggregate evidenceをprovider中立に管理する。
- [Vercel integration permissions and access](https://vercel.com/docs/integrations/install-an-integration/manage-integrations-reference)、[Vercel Marketplace API](https://vercel.com/docs/integrations/create-integration/marketplace-api/reference)、[Firebase extension manifests](https://firebase.google.com/docs/extensions/manifest)、[Manage installed Firebase extensions](https://firebase.google.com/docs/extensions/manage-installed-extensions)、[Firebase extension access](https://firebase.google.com/docs/extensions/publishers/access)、[Supabase Postgres extensions](https://supabase.com/docs/guides/database/extensions)、[Supabase platform upgrades](https://supabase.com/docs/guides/platform/upgrading)、[Supabase through the Vercel Marketplace](https://supabase.com/docs/guides/integrations/vercel-marketplace)、[Cloudflare Workers integrations](https://developers.cloudflare.com/workers/configuration/integrations/)、[Cloudflare bindings](https://developers.cloudflare.com/workers/runtime-apis/bindings/)、[Cloudflare Workers versions and deployments](https://developers.cloudflare.com/workers/versions-and-deployments/): managed integrationはidentity、secret、resource、binding、billing、残存artifactを生成し得るため、package dependency管理とは別にinstall、change、degradation、removalの明示的lifecycleを必要とする。
- [Vercel Environments](https://vercel.com/docs/deployments/environments)、[Supabase Local Development](https://supabase.com/docs/guides/local-development/overview)、[Firebase Local Emulator Suite](https://firebase.google.com/docs/emulator-suite)、[Cloudflare Workers Local Development](https://developers.cloudflare.com/workers/local-development/)、[Cloudflare binding support by development mode](https://developers.cloudflare.com/workers/local-development/bindings-per-env/)、[AWS serverless testing guide](https://docs.aws.amazon.com/lambda/latest/dg/testing-guide.html): local、emulator、remote binding、managed preview／cloud testは再現するsurfaceと制約が異なるため、fidelityを明示しmanaged-only behaviorをrisk-basedに検証する。
- [Vercel Queues](https://vercel.com/docs/queues)、[Supabase Queues](https://supabase.com/docs/guides/queues)、[Firebase asynchronous function retries](https://firebase.google.com/docs/functions/retries)、[Cloudflare Queues delivery guarantees](https://developers.cloudflare.com/queues/reference/delivery-guarantees/)、[Cloudflare Queues batching and retries](https://developers.cloudflare.com/queues/configuration/batching-retries/): delivery scope、visibility／ack、retry、ordering、DLQ／quarantineはproviderごとに異なるため、end-to-end contractで検証する。
- [Supabase Branching](https://supabase.com/docs/guides/deployment/branching)、[Access Control](https://supabase.com/docs/guides/platform/access-control)、[Cost Control](https://supabase.com/docs/guides/platform/cost-control)、[Backups](https://supabase.com/docs/guides/platform/backups)、[Securing the Data API](https://supabase.com/docs/guides/api/securing-your-api)、[Edge Functions](https://supabase.com/docs/guides/functions)、[Client Libraries](https://supabase.com/docs/guides/api/rest/client-libs)
- [Firebase App Check](https://firebase.google.com/docs/app-check)、[Firebase IAM](https://firebase.google.com/docs/projects/iam/permissions)、[Security Rules Emulator](https://firebase.google.com/docs/firestore/security/test-rules-emulator)、[App Hosting Costs](https://firebase.google.com/docs/app-hosting/costs)、[Cloud Functions](https://firebase.google.com/docs/functions/get-started)、[Client Libraries](https://firebase.google.com/docs/libraries)
- [Cloudflare Workers Languages](https://developers.cloudflare.com/workers/languages/)、[Python Workers](https://developers.cloudflare.com/workers/languages/python/)、[TypeScript Runtime Types](https://developers.cloudflare.com/workers/languages/typescript/)、[Workers Versions and Deployments](https://developers.cloudflare.com/workers/versions-and-deployments/)、[Gradual Deployments](https://developers.cloudflare.com/workers/versions-and-deployments/gradual-deployments/)、[Rollbacks](https://developers.cloudflare.com/workers/versions-and-deployments/rollbacks/)、[Limits](https://developers.cloudflare.com/workers/platform/limits/)、[Observability](https://developers.cloudflare.com/workers/observability/)
- [AWS Lambda Runtimes](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html)、[Runtime Updates](https://docs.aws.amazon.com/lambda/latest/dg/runtimes-update.html)、[Azure Functions Supported Languages](https://learn.microsoft.com/en-us/azure/azure-functions/supported-languages)、[Language Version Updates](https://learn.microsoft.com/en-us/azure/azure-functions/update-language-versions): managed／custom／container runtimeとsupport lifecycle
- [AWS Lambda with SQS](https://docs.aws.amazon.com/lambda/latest/dg/with-sqs.html)、[Google Cloud Pub/Sub exactly-once delivery](https://cloud.google.com/pubsub/docs/exactly-once-delivery)、[Azure Service Bus message loss and duplicates](https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-message-loss-and-duplicates): exactly-once、ordering、deduplicationはservice、receive mode、region、ack、window等のscope付きcapabilityであり、consumerと下流side effectのidempotencyを不要にしない。
- [Google Cloud Client Libraries](https://cloud.google.com/apis/docs/client-libraries-explained)、[AWS SDK Maintenance Policy](https://docs.aws.amazon.com/sdkref/latest/guide/maint-policy.html)、[AWS SDK Version Lifecycle](https://docs.aws.amazon.com/sdkref/latest/guide/version-support-matrix.html): 公式client、生成client、直接protocol、SDK major versionと依存runtimeのsupport lifecycle
- [Netlify Functions](https://docs.netlify.com/build/functions/get-started/)、[Netlify Edge Functions](https://docs.netlify.com/edge-functions/overview/)、[Cloud Run Container Contract](https://cloud.google.com/run/docs/container-contract): standard function、edge、containerの実行契約
- [Render Supported Languages](https://render.com/docs/language-support)、[Railway Languages and Frameworks](https://docs.railway.com/languages-frameworks): native／auto-detected buildとcontainer fallbackの区別
- [AWS Amplify documentation](https://docs.amplify.aws/javascript/start/)、[Amplify Data](https://docs.amplify.aws/react/build-a-backend/data/set-up-data/)、[Amplify function secrets](https://docs.amplify.aws/react/build-a-backend/functions/environment-variables-and-secrets/): TypeScript-firstなfull-stack定義、capability別resource／client surface、sandbox環境、artifactへ残るenvironment variableとsecret保管の区別
- [Appwrite documentation](https://appwrite.io/docs)、[Appwrite self-hosting](https://appwrite.io/docs/advanced/self-hosting): Auth、database、storage、functions、messaging、Realtimeのcapabilityと、managed／self-hosted deployment modeで異なる運用責任
- [Convex function types](https://docs.convex.dev/functions/overview): query、mutation、action、HTTP actionごとに異なるtransaction、reactivity、external side effect、retry境界
- [MongoDB Atlas App Services release notes](https://www.mongodb.com/docs/atlas/app-services/release-notes/backend/)、[Atlas App Services Admin API](https://www.mongodb.com/docs/api/doc/atlas-app-services-admin-api-v3/): service単位のlifecycle／EOLはprovider／database brandと別に変化し得るため、採用capabilityとexitを独立管理する根拠
- [CNCF Annual Cloud Native Survey](https://www.cncf.io/reports/the-cncf-annual-cloud-native-survey/): container／KubernetesとPlatform Engineeringの採用状況を示す市場signal。採用義務や個別設計の根拠には単独使用しない。
