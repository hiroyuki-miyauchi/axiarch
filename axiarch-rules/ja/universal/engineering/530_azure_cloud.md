# 530. Microsoft Azureクラウドガバナンス

> [!CAUTION]
> このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。
> 改定日: 2026-07-23

> [!IMPORTANT]
> 主要方針: Azureは企業統制を代行する製品ではなく、責任分界を実装する能力群である。Microsoft Entra、management group、subscription、resource group、Azure Policy、managed serviceを、application、team、data、failure、costの境界と混同しない。固定構成を全projectへ強制せず、同じ安全性、再現性、追跡可能性、回復性、費用説明責任、退出可能性を検証可能な成果として要求する。
> 21セクション・Rule 530.1–530.85。

---

## 目次

| セクション | トピック |
|:--|:--|
| §1 | 適用範囲とUniversal適用契約 |
| §2 | tenant、management group、landing zone |
| §3 | Microsoft Entra、RBAC、特権アクセス |
| §4 | Azure Policy、resource governance、inventory |
| §5 | IaC、control plane変更、drift |
| §6 | compute、runtime、workload配置 |
| §7 | 言語、SDK、runtime lifecycle |
| §8 | release、revision、slot、rollback |
| §9 | network、edge、DNS、egress |
| §10 | secret、key、certificate、configuration |
| §11 | data、state、migration、backup |
| §12 | messaging、event、workflow |
| §13 | observability、audit、incident |
| §14 | security、privacy、compliance |
| §15 | reliability、availability、DR |
| §16 | FinOps、quota、capacity |
| §17 | Platform Engineering、team、enterprise運用 |
| §18 | supply chain、CI、managed conformance |
| §19 | portability、exit、decommission |
| §20 | evidence、成熟度、アンチパターン |
| §21 | Azure Functionsの言語・worker・hosting support surface |
| Appendix A | 逆引き索引、クロスリファレンス、一次資料 |

---

## §1. 適用範囲とUniversal適用契約

- Rule 530.1: 本ファイルは、Azure上のapplication、data、identity、network、integration、container、serverless、AI、platform foundationを採用または運用する際のprovider profileである。Azure採用自体は必須にしない。
- Rule 530.2: Universalな必須成果は、least privilege、review可能な変更、environmentとfailure境界、data recovery、release traceability、unit cost、support lifecycle、exit planである。service、SKU、region、topology、tool、role名、固定閾値はBlueprint parameterまたは時点付き参考実装とする。
- Rule 530.3: Azure Well-Architected FrameworkのReliability、Security、Cost Optimization、Operational Excellence、Performance Efficiencyを相互trade-offとして評価し、一つのpillarだけを満たしてproduction readinessを宣言しない。
- Rule 530.4: Azureの機能、preview／GA、quota、runtime、SDK、API version、region availability、料金、support contractは採用時と重要変更時に公式資料とeffective tenant／subscription設定で再確認する。本文の製品名を将来の能力保証にしない。

## §2. tenant、management group、landing zone

- Rule 530.5: Microsoft Entra tenant、billing scope、management group、subscription、resource group、resourceの階層を明示し、それぞれのowner、policy inheritance、権限、費用、削除、移管の境界を記録する。
- Rule 530.6: application landing zoneとplatform landing zoneを分ける場合、network、identity、security、management等の共有機能とworkload teamの責任をservice contractで結ぶ。小規模構成では責務を兼務できるが、境界と証跡を省略しない。
- Rule 530.7: subscription vendingまたは同等のprovisioning pathは、workload classに応じて複数の安全なproduct lineを許容し、すべてのapplicationへ同じ巨大subscription、同じnetwork、同じapproval flowを強制しない。
- Rule 530.8: management groupとsubscriptionの配置は、組織図の写しではなく、policy、data residency、blast radius、billing、delegation、quota、lifecycleから設計する。移動時のpolicy再評価とaccess変化を事前検証する。

## §3. Microsoft Entra、RBAC、特権アクセス

- Rule 530.9: human、workload、device、external identityを分け、Azure RBAC、Microsoft Entra role、resource data-plane role、application authorizationを別の権限面としてinventoryする。`Owner`や`Contributor`の名称だけで実効権限を判断しない。
- Rule 530.10: Azure上のworkloadは、対応する場合managed identityまたはworkload identity federationと短命tokenを優先する。client secret、certificate、access keyが残る場合は、必要性、scope、rotation、revocation、利用箇所を追跡する。
- Rule 530.11: 高権限human accessは、PIMまたは同等のjust-in-time、time-bound、approval、step-up、notification、auditをriskに応じて適用する。恒久Global Administrator／Ownerを通常運用経路にしない。
- Rule 530.12: break-glass identityは通常のSSO障害を含む脅威モデル、保管、利用条件、監視、事後review、復旧確認を持つ。日常利用や自動化credentialへ転用しない。

## §4. Azure Policy、resource governance、inventory

- Rule 530.13: Azure Policyはresource stateとactionを評価するgovernance面、Azure RBACはprincipalの操作権限を制御するauthorization面として分離し、片方を他方の代替にしない。
- Rule 530.14: policy definition、initiative、assignment、exemption、effect、managed identity、remediationをversion管理し、scope inheritance、deny impact、既存resourceへの適用、除外理由を変更前に検証する。
- Rule 530.15: auditからdeny、modify、deployIfNotExists等への移行は、観測、影響分析、remediation、owner通知、rollbackまたは安全な緩和を段階化する。組織全体への未検証denyを直接適用しない。
- Rule 530.16: Azure Resource Graphまたは同等手段で、resource、public exposure、identity、role assignment、policy compliance、diagnostic setting、region、SKU、tag、owner、cost、lifecycleを検索可能なinventoryへ統合する。

## §5. IaC、control plane変更、drift

- Rule 530.17: Bicep／ARM、Terraform、Pulumiまたは同等IaCを、再構築対象のresource、role、policy、network、diagnostic setting、alert、budgetへ適用する。tool名より、review、plan、state、provenance、drift、recoveryの成果を優先する。
- Rule 530.18: deployment前にwhat-if、planまたは同等の変更予測を取得するが、unknown、provider side effect、runtime behavior、data mutation、linked deployment等を完全に証明するものとは扱わない。高risk変更はisolated testまたは段階適用で補完する。
- Rule 530.19: deployment stack等でresource lifecycle、deny、detach、deleteを管理する場合、所有境界、既存resourceの取り込み、削除挙動、known limitation、break-glassを明示し、強制削除を通常のdrift修正にしない。
- Rule 530.20: portal／CLIによる緊急変更は、actor、reason、before／after、ticket、expiry、reconciliationを記録し、IaCまたは承認済みsourceへ戻す。未記録のcontrol plane変更を恒久状態にしない。

## §6. compute、runtime、workload配置

- Rule 530.21: App Service、Functions、Container Apps、AKS、VM、Batch、Static Web Apps等は、request、event、batch、long-running、state、network、startup、scale、portability、operator burdenから選ぶ。「serverless first」または「Kubernetes first」を成熟度指標にしない。
- Rule 530.22: managed computeの責任分界を、OS／runtime patch、base image、autoscale、capacity、network、certificate、backup、observability、deployment単位で記録する。provider管理範囲をapplication recoveryの保証と誤認しない。
- Rule 530.23: Functions等のevent-driven computeは、timeout、concurrency、cold start、retry、poison input、idempotency、connection reuse、scale limit、downstream backpressureをworkload contractへ含める。
- Rule 530.24: AKSを選ぶ場合、clusterとworkloadの責任、mode、upgrade、node pool、tenant isolation、pod security、resource request／limit、disruption、image、workload identity、backup／DRを定義する。cluster作成をplatform completionと見なさない。

## §7. 言語、SDK、runtime lifecycle

- Rule 530.25: Azure上の言語supportは、application runtime、Azure SDK、management SDK／CLI、data-plane SDK、build、debug、observability、deploymentのsurface別に宣言する。「Azureが言語をsupportする」を単一の真偽値にしない。
- Rule 530.26: .NET、Java、TypeScript／JavaScript、Python、Go等のprimary SDKと、C++、Rust、mobile、community packageを、公式lifecycle、stable／beta、feature parity、API coverage、maintenance、security responseで区分する。betaをproduction既定にしない。
- Rule 530.27: Azure SDKはruntime、OS、service REST API、third-party dependencyにも依存するため、SDKだけでなく全support chainのEOL、minimum version、migration guide、breaking changeを追跡する。
- Rule 530.28: SDKがない、遅延する、またはfeature parityが不足する言語では、versioned REST／protocol、generated client、sidecar、service境界等のfallbackとauth、retry、pagination、error、telemetry contractを定義する。非公式packageを無検証で標準化しない。

## §8. release、revision、slot、rollback

- Rule 530.29: source revision、resolved dependency、builder、artifact／image digest、runtime、configuration、IaC deployment、data migration、Azure deployment ID、traffic stateをaggregate release recordへ結び付ける。
- Rule 530.30: App Service slot、Container Apps revision、Functions slot、AKS rollout等は、trafficとcomputeの切替能力であり、database、queue、identity、DNS、cache、external side effectを自動rollbackするものではない。state互換性を別gateで検証する。
- Rule 530.31: progressive deliveryは、revision、slot、region、tenant、feature flag等から適切なblast-radius単位を選び、SLI、sample、observation window、abort、rollback／forward-fixをBlueprintで定義する。
- Rule 530.32: slot swap、revision activation、image promotion、configuration変更の順序とsticky setting、private endpoint、managed identity、warm-up、health probe等の差を検証する。名前が同じ環境をparityの証拠にしない。

## §9. network、edge、DNS、egress

- Rule 530.33: public ingress、private ingress、service-to-service、hybrid接続、management access、egress、DNS、certificateをdata flowへ写像し、VNet、subnet、NSG、Private Link、Firewall、Front Door等を必要な脅威とfailure modeへ対応付ける。
- Rule 530.34: Private Link／private endpointはnetwork exposureを減らす能力であり、authentication、authorization、encryption、DNS integrity、exfiltration controlの代替ではない。public accessの残存経路も検証する。
- Rule 530.35: internet-facing applicationは、L3／L4 DDoS、L7 WAF、rate limit、bot／abuse、origin shielding、end-to-end TLS、health probe、failoverを層別化する。Front Door、Application Gateway等の採否はglobal routing、protocol、latency、cost、operator burdenで決める。
- Rule 530.36: egressはdestination、identity、DNS、proxy／firewall、SNAT／port capacity、private endpoint、data classification、costを統制し、無制限outboundをmanaged serviceの既定として放置しない。

## §10. secret、key、certificate、configuration

- Rule 530.37: Key Vaultまたは同等の承認済みsecret storeを用い、secret、key、certificate、configurationを分類する。control-plane管理権限とdata-plane読取／署名／復号権限を別に最小化する。
- Rule 530.38: soft delete、purge protection、backup／restore、key rotation、certificate renewal、expiry alert、recovery accessをdata criticalityとregulationから設計する。削除保護を復旧試験の代替にしない。
- Rule 530.39: applicationはmanaged identity等で実行時に必要な値だけを取得し、source、image、IaC output、deployment log、client bundleへsecretを埋め込まない。secret referenceの失敗挙動とcache期間を定義する。
- Rule 530.40: configurationは型、scope、owner、default、sensitivity、変更履歴、rollout、rollbackを持つ。App Configuration、feature flag、environment setting等の動的変更もrelease evidenceと監査へ接続する。

## §11. data、state、migration、backup

- Rule 530.41: Azure SQL、Cosmos DB、Azure Database for PostgreSQL、Storage等は、data model、consistency、transaction、query、scale、residency、portability、operator burden、unit costから選ぶ。provider portfolio内という理由だけで単一databaseを全用途へ強制しない。
- Rule 530.42: database、object、file、cache、search、identity、secret、queue、configuration、schema、DNSをresource-complete recovery inventoryへ含め、各system of recordと再生成可能な派生stateを区分する。
- Rule 530.43: schemaとdata migrationはexpand／migrate／contract、version compatibility、backfill、validation、pause、resume、rollbackまたはforward recoveryを持ち、application slot／revisionの切戻しだけで安全と宣言しない。
- Rule 530.44: backup、PITR、geo-replication、zone／region redundancyは異なるfailure modeを扱う。RPO／RTO、retention、immutability、key、off-region／off-account要否、restore orderを定義し、隔離環境で実restoreを検証する。

## §12. messaging、event、workflow

- Rule 530.45: Service Bus、Event Grid、Event Hubs、Storage Queue、Durable Functions、Logic Apps等は、command／event／stream、ordering、delivery、throughput、retention、replay、transaction、connector trust、costから選ぶ。
- Rule 530.46: at-least-onceまたは重複可能なdeliveryでは、producer／consumer双方のidempotency key、deduplication scope／window、transaction境界、side effect、replay safetyを定義する。providerのduplicate detectionだけに業務整合性を委ねない。
- Rule 530.47: retryはbounded exponential backoffとjitter、retryable分類、lock／visibility、TTL、dead-letter／quarantine、poison message inspection、redrive approvalを持ち、複数層の無制限retry amplificationを禁止する。
- Rule 530.48: session／partition／ordering keyは、そのscope内の順序しか保証しない。partition変更、consumer scale、failover、replay、cross-entity transactionでの順序と整合性をcontract testする。

## §13. observability、audit、incident

- Rule 530.49: Azure Monitor、Application Insights、OpenTelemetry等を用い、user journey、application、dependency、platform、control plane、data planeのSLIを相関可能にする。特定backendをtelemetry portabilityの前提にしない。
- Rule 530.50: Activity Logは主にcontrol-plane操作、resource logはserviceのdata-plane／内部操作を扱う。resource logは既定収集されない場合があるため、必要category、diagnostic setting、destination、retention、accessをIaCとinventoryで検証する。
- Rule 530.51: log、metric、trace、profile、security eventは、PII／secret scrubbing、tenant separation、cardinality、sampling、retention、query access、export、cost budgetを持つ。全部収集または全部削減を一律方針にしない。
- Rule 530.52: Azure Service Health、Resource Health、provider status、quota、billing、certificate、identity、DNSをincident dependencyへ含め、support escalation、degraded mode、customer communication、evidence preservationをrunbook化する。

## §14. security、privacy、compliance

- Rule 530.53: Microsoft Cloud Security Benchmark、Defender for Cloud、security recommendation等はcontrol selectionとgap detectionの入力であり、enablement scoreを実効securityの証明にしない。threat modelとruntime evidenceで検証する。
- Rule 530.54: data classification、processing purpose、residency、replication、support access、log export、backup、key location、subprocessor、deletionをservice graphへ結び付ける。region選択だけでdata sovereigntyを達成したと宣言しない。
- Rule 530.55: tenant、subscription、network、resource、application、row／objectのisolationをdata sensitivityとmulti-tenancy threatから組み合わせる。resource groupやsubscriptionをapplication authorizationの代替にしない。
- Rule 530.56: public exposure、role assignment、policy exemption、key access、security alert、support access、cross-tenant trustを継続監視し、security incidentではcredential revocation、identity containment、evidence保全、recoveryを連携する。

## §15. reliability、availability、DR

- Rule 530.57: Azureと利用者のshared responsibilityをservice単位で確認し、availability zone、zone-redundant、region pair、multi-regionという名称だけでapplication-level availabilityを保証しない。
- Rule 530.58: workloadのRTO／RPO、dependency、traffic、data consistency、capacity、DNS、identity、key、quotaを基に、single-region、zone redundancy、active／passive、active／active、rebuild等を選ぶ。multi-regionを無条件の成熟度要件にしない。
- Rule 530.59: timeout、retry、circuit breaker、bulkhead、load shedding、queue、cache、graceful degradationをdependency contractへ適用し、provider retryとapplication retryの重複を検証する。
- Rule 530.60: failover、restore、region evacuation、identity outage、control-plane outage、quota exhaustion、dependency degradationをrisk-based cadenceで演習し、実測RTO／RPO、data loss、manual step、capacity gapを改善へ戻す。

## §16. FinOps、quota、capacity

- Rule 530.61: billing scope、subscription、resource group、tag、meter、reservation／savings、marketplace、support、license、egress、telemetryをcost allocationへ統合し、product、team、environment、tenant、unit of valueへ説明可能にする。
- Rule 530.62: Azure Cost Managementのbudget、forecast、anomaly alertは通知・自動化triggerであり、単独のhard capではない。safe action、owner、escalation、rate limit、quota、degraded modeをservice criticalityに応じて設計する。
- Rule 530.63: subscription／region／resource provider／SKU／serviceのquotaとcapacityを、current usage、growth、deployment surge、failover、disaster recovery、support lead timeと共に監視する。autoscale上限をcapacity確保の証明にしない。
- Rule 530.64: compute、request、execution、database operation、storage、egress、build、log、seat等のcost driverをunit economicsへ接続し、idle、orphan、overprovision、retry storm、high-cardinality telemetry、preview残存を継続検出する。

## §17. Platform Engineering、team、enterprise運用

- Rule 530.65: platform teamはlanding zone、subscription vending、identity、network、policy、observability、cost、deploymentのGolden Pathをproductとして提供し、workload teamとの責任、SLO、support、exception、feedbackを明示する。
- Rule 530.66: 個人または小規模teamでは責務を兼務できるが、production owner、security、billing、data recovery、release authority、break-glassをaccountable capabilityとして残す。組織規模だけでcontrolを省略しない。
- Rule 530.67: 大規模組織ではtenant／management group／subscriptionを越えるpolicy、identity、network、cost、inventoryのfederated governanceと中央guardrailを両立し、中央teamをすべてのdeliveryの手作業bottleneckにしない。
- Rule 530.68: joiner／mover／leaver、guest、vendor、managed service identity、support engineer、automation principalのlifecycleを統合し、orphan role assignment、shared account、個人所有subscription、期限切れexceptionを検出する。

## §18. supply chain、CI、managed conformance

- Rule 530.69: Azure DevOps、GitHub Actionsまたは他のCIは交換可能な実装とし、source protection、review、ephemeral identity、pinned dependency、isolated build、secret scan、IaC policy、test、SBOM、provenance、署名、promotion evidenceを成果契約とする。
- Rule 530.70: CIからAzureへの認証はOIDC workload identity federation等の短命credentialを優先し、長寿命client secretやpublish profileをrepository／organization全体へ共有しない。subject、audience、environment、branch／tag、role scopeを制限する。
- Rule 530.71: container、package、function bundle、template、extension、agent、marketplace integrationは、source、publisher、version、digest、license、vulnerability、permission、update mode、EOLをinventoryし、deploy対象と一致するSBOM／provenanceへ接続する。
- Rule 530.72: local emulator、mock、Azurite、container、test subscriptionは高速feedbackに使えるが、managed identity、Policy、DNS、Private Link、quota、scale、retry、region、billing、provider updateを完全再現しない。fidelity matrixを持ち、managed conformance testで差を閉じる。

## §19. portability、exit、decommission

- Rule 530.73: exit planはsourceだけでなく、data、schema、object、identity、role、policy、secret、key、certificate、DNS、domain、queue、event、telemetry、IaC state、support evidence、billing recordを対象にする。
- Rule 530.74: Azure固有APIを抽象化するかは、migration probability、business value、performance、operator burden、testabilityから判断する。薄いwrapperの乱造も、無自覚なlock-inも避け、不可逆点をADRへ記録する。
- Rule 530.75: exportとrestoreはformat、completeness、ordering、metadata、ACL、encryption、checksum、throughput、downtime、egress cost、consumer compatibilityを検証する。export buttonの存在を退出可能性の証明にしない。
- Rule 530.76: decommissionはtraffic停止、producer停止、consumer確認、data retention／deletion、identity revoke、role解除、DNS／certificate、integration、backup、log、resource lock、subscription／billing closure、orphan scanまで完了して終了とする。

## §20. evidence、成熟度、アンチパターン

- Rule 530.77: production readiness evidenceには、responsibility matrix、resource／identity inventory、architecture、data flow、IaC plan、Policy結果、release record、restore test、SLO、cost model、quota、runbook、exit planをriskに応じて含める。
- Rule 530.78: CI gateは、IaC syntax／static、what-if／plan、policy、identity diff、public exposure、secret、artifact、SBOM／provenance、migration compatibility、managed smokeをchange impactに応じて組み合わせる。すべてを全PRで直列実行することは要求しない。
- Rule 530.79: 成熟度はAzure service数やmanagement group数ではなく、所有、再現性、least privilege、managed conformance、recovery実測、cost explainability、exception期限、exit rehearsalで評価する。
- Rule 530.80: 次をアンチパターンとする。個人subscriptionでのproduction、恒久Owner、service principal secret共有、portal-only変更、PolicyとRBACの混同、slot rollbackへのdata依存、Activity Logだけでdata-plane監査完了、budget alertをhard capと誤認、未検証backup、無制限autoscale、subscriptionをapplication認可に利用、削除前のorphan scan省略。

## §21. Azure Functionsの言語・worker・hosting support surface

- Rule 530.81: 「Azure Functionsが言語Xをsupportする」を単一の真偽値にしない。language version、Functions host version、worker model、OS、hosting plan、region、deployment unit、local toolchain、trigger／binding、debug／observability、runtime update、EOLを一つのsupport recordへ結び付ける。Azure SDKの存在、Custom Handlerでの実行可能性、portalでの編集可能性をfirst-class managed language supportと同一視しない。
- Rule 530.82: 2026-07-23時点の公式support表では、C#、JavaScript／TypeScript、Python、Java、PowerShellはmanaged language surfaceを持ち、GoはPreviewかつFlex Consumption plan限定、Rustその他はCustom Handlers経路として示される。これは採用時点のsnapshotであり、PreviewをGAまたはproduction既定へ昇格させず、version、plan、OS、region、feature parity、SLA／support、migration guideを実装時に再確認する。
- Rule 530.83: Custom HandlerはFunctions hostとのHTTPまたはdocumented protocol境界を提供するescape hatchであり、providerが対象言語runtime、package、security patch、startup、signal、serialization、binding bridgeを管理する保証ではない。採用側はruntime artifact、bootstrap、dependency、SBOM、provenance、health、telemetry、patch、rollback、handler protocol compatibilityを所有し、同じ言語のmanaged workerと別support tierで扱う。
- Rule 530.84: worker modelとhosting planを言語名から分離する。.NETのin-process／isolated worker、Node.js上へtranspileされるTypeScript、managed minor／patch update、Linux／Windows差、planごとの追加version停止や退役は、source互換性だけでなくbuild、trigger／binding、startup、memory、network、deployment、managed smokeを変え得る。自動更新を無効化または古いhost／workerへ滞留する場合は、owner、期限、security gap、migration test、rollback／forward-fixを記録する。
- Rule 530.85: productionで使用するFunctionsの各language／worker／OS／plan組合せに、accountable owner、support level、EOL、advisory route、native CI gate、managed conformance、on-call、fallback、decommissionを割り当てる。platform teamは承認済み組合せをGolden Pathとして提供できるが、全teamへ一つの言語またはplanを強制せず、Preview／Custom Handlerのrisk acceptanceとupgrade evidenceをworkload ownerへ可視化する。

---

## Appendix A: 逆引き索引

| 課題 | 参照 |
|:--|:--|
| enterprise landing zone、subscription vending | §2、§17 |
| Microsoft Entra、managed identity、PIM、OIDC | §3、§10、§18 |
| Azure Policy、inventory、portal drift | §4、§5 |
| App Service、Functions、Container Apps、AKS | §6、§8 |
| .NET、Java、TypeScript、Python、Go、SDK | §7 |
| Azure Functions、Go Preview、Custom Handler、worker model、hosting plan | §21 |
| Private Link、Front Door、WAF、DDoS、egress | §9 |
| Key Vault、secret、certificate | §10 |
| Azure SQL、Cosmos DB、PostgreSQL、Storage、backup | §11 |
| Service Bus、Event Grid、Event Hubs、Logic Apps | §12 |
| Azure Monitor、Activity Log、diagnostic setting | §13 |
| data sovereignty、security posture | §14 |
| availability zone、multi-region、DR | §15 |
| Cost Management、budget、quota、unit cost | §16 |
| SBOM、provenance、managed conformance | §18 |
| exit、decommission | §19 |

### クロスリファレンス

- 横断platform選定・共有責任・aggregate release: `engineering/520_cloud_application_platforms.md`
- プログラミング言語・SDK・toolchain: `engineering/320_programming_language_governance.md`
- API／service boundary: `engineering/100_api_integration.md`
- Git／CI／release workflow: `engineering/600_git_workflow.md`
- Security／Privacy: `security/000_security_privacy.md`
- OSS／SBOM／SLSA: `security/200_oss_compliance.md`
- QA／IaC／migration testing: `quality/000_qa_testing.md`
- SRE／DR／Production Readiness: `operations/400_site_reliability.md`
- Cloud FinOps: `operations/600_cloud_finops.md`

### 一次資料

- [Microsoft Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/what-is-well-architected-framework)
- [Azure landing zones](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/)、[subscription vending product lines](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending-product-lines)
- [Microsoft Entra managed identities](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview)、[workload identity federation](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-create-trust)、[Privileged Identity Management](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure)
- [Azure Policy overview](https://learn.microsoft.com/en-us/azure/governance/policy/overview)
- [Bicep deployment what-if](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-what-if)、[deployment stacks](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-stacks)
- [App Service deployment slots](https://learn.microsoft.com/en-us/azure/app-service/deploy-staging-slots)、[Container Apps revisions](https://learn.microsoft.com/en-us/azure/container-apps/revisions)、[traffic splitting](https://learn.microsoft.com/en-us/azure/container-apps/traffic-splitting)、[Functions runtime versions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-versions)
- [Azure Functions supported languages](https://learn.microsoft.com/en-us/azure/azure-functions/supported-languages)、[Azure Functions language stack support policy](https://learn.microsoft.com/en-us/azure/azure-functions/language-support-policy)、[Azure Functions custom handlers](https://learn.microsoft.com/en-us/azure/azure-functions/functions-custom-handlers): managed language、worker model、OS／hosting plan、Preview／GA、Custom Handler、support lifecycleの境界
- [Azure Private Link](https://learn.microsoft.com/en-us/azure/private-link/private-link-overview)、[Azure Front Door best practices](https://learn.microsoft.com/en-us/azure/frontdoor/best-practices)、[Azure DDoS Protection security](https://learn.microsoft.com/en-us/azure/ddos-protection/secure-ddos-protection)
- [Azure Key Vault RBAC](https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-guide)、[secure Key Vault access](https://learn.microsoft.com/en-us/azure/key-vault/general/secure-key-vault)
- [Service Bus message loss and duplicates](https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-message-loss-and-duplicates)、[duplicate detection](https://learn.microsoft.com/en-us/azure/service-bus-messaging/duplicate-detection)、[Event Grid delivery and retry](https://learn.microsoft.com/en-us/azure/event-grid/delivery-and-retry)
- [Azure Monitor Activity Log](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log)、[diagnostic settings](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings)
- [Microsoft Cost Management](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/overview-cost-management)、[Azure quotas](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits)、[Reliability in Azure](https://learn.microsoft.com/en-us/azure/reliability/)、[Azure Backup](https://learn.microsoft.com/en-us/azure/backup/backup-overview)
- [Azure SDK support policy](https://azure.github.io/azure-sdk/policies_support.html)、[Azure SDK release policy](https://azure.github.io/azure-sdk/policies_releases.html)、[Azure SDK design guidelines](https://azure.github.io/azure-sdk/general_introduction.html)
