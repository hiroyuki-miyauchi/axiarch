# 38. バックエンド・クラウドインフラ戦略: AWS (Amazon Web Services)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-03-24

> [!IMPORTANT]
> **Supreme Directive（最高指令）**
> 「AWSは"手段"であり、アーキテクチャの"目的"ではない。」
> クラウドインフラの全設計判断は **Well-Architected Framework の6ピラー** と **IaC Only 原則** に基づいて行わなければならない。
> コンソール手動操作（ClickOps）は本憲法において **重大な違反** である。
> **「セキュリティは後付けではない。Day 0から組み込め。」**
> **156セクション構成。**

> [!NOTE]
> **ファイル概要**: 155セクション・240+ルール・15コードスニペット構成。AWS Well-Architected基盤から全主要AWSサービスまで網羅。
> サービス別逆引き索引（Appendix A）付き。

---

## 目次

- [§0. AWSクラウド至高の命令](#0-awsクラウド至高の命令-aws-cloud-supreme-directives)
- [§1. IAMセキュリティ戦略](#1-iamセキュリティ戦略-iam-security-strategy)
- [§2. ネットワーク設計基準](#2-ネットワーク設計基準-network-design-standards)
- [§3. コンピューティング戦略](#3-コンピューティング戦略-compute-strategy)
- [§4. データベース戦略](#4-データベース戦略-database-strategy)
- [§5. ストレージ戦略](#5-ストレージ戦略-storage-strategy)
- [§6. セキュリティ運用](#6-セキュリティ運用-security-operations)
- [§7. オブザーバビリティ戦略](#7-オブザーバビリティ戦略-observability-strategy)
- [§8. IaC・デプロイ戦略](#8-iacデプロイ戦略-iac--deployment-strategy)
- [§9. コスト最適化戦略 / FinOps](#9-コスト最適化戦略-cost-optimization--finops)
- [§10. 信頼性・災害復旧](#10-信頼性災害復旧-reliability--disaster-recovery)
- [§11. パフォーマンス最適化](#11-パフォーマンス最適化-performance-optimization)
- [§12. データ保護・暗号化](#12-データ保護暗号化-data-protection--encryption)
- [§13. コンテナ・サーバーレス詳細](#13-コンテナサーバーレス詳細-container--serverless-deep-dive)
- [§14. ガバナンス・コンプライアンス](#14-ガバナンスコンプライアンス-governance--compliance)
- [§15. サステナビリティ](#15-サステナビリティ-sustainability)
- [§16. 運用保守・チェックリスト](#16-運用保守チェックリスト-operations--maintenance-checklists)
- [§17. メッセージング・イベント駆動](#17-メッセージングイベント駆動アーキテクチャ-messaging--event-driven-architecture)
- [§18. API Gateway戦略](#18-api-gateway戦略-api-gateway-strategy)
- [§19. ワークフローオーケストレーション](#19-ワークフローオーケストレーション-workflow-orchestration)
- [§20. DNS・ドメイン管理](#20-dnsドメイン管理-dns--domain-management)
- [§21. インシデントレスポンス](#21-インシデントレスポンス-incident-response)
- [§22. アプリケーション認証・ID管理](#22-アプリケーション認証id管理-application-authentication--identity)
- [§23. ロードバランサー戦略](#23-ロードバランサー戦略-load-balancer-strategy)
- [§24. デプロイ戦略](#24-デプロイ戦略-deployment-strategy)
- [§25. データ分析・パイプライン](#25-データ分析パイプライン-data-analytics--pipeline)
- [§26. Control Tower・Landing Zone](#26-control-towerlanding-zone-control-tower--landing-zone)
- [§27. Service Quotas・リミット管理](#27-service-quotasリミット管理-service-quotas--limits-management)
- [§28. サプライチェーンセキュリティ](#28-サプライチェーンセキュリティ-supply-chain-security)
- [§29. 生成AI・Bedrockセキュリティ](#29-生成aibedrockセキュリティ-generative-ai--bedrock-security)
- [§30–§39. ネットワーク・ハイブリッド・FinOps深化](#30-ネットワークセキュリティ深化-advanced-network-security)
- [§40–§49. バックアップ・テスト・コンプライアンス](#40-aws-backup集中管理-centralized-backup-management)
- [§50–§59. Organizations・PKI・Observability・SageMaker](#50-アカウント自動プロビジョニング-account-factory--automated-provisioning)
- [§60–§69. ZeroTrust・バッチ・マイグレーション](#60-ゼロトラストネットワークアクセス-zero-trust--verified-access)
- [§70–§79. EKS・WAF・EventBridge・CloudWatch高度化](#70-eks高度運用-advanced-eks-operations)
- [§80–§89. RDS Proxy・Config・IoT・Resilience Hub](#80-rds-proxyaurora-serverless-v2-advanced-database-proxying--serverless-rds)
- [§90–§99. IaC高度化・Bedrock・Outposts・DocumentDB](#90-iac高度化--samcdk-advanced-iac--sam--cdk)
- [§100–§109. S3 Tables・AgentCore・DSQL・MRSC・Lambda MI](#100-s3-tables--s3-metadataデータレイクハウス戦略)
- [§110–§119. CloudFront VPC・Security IR・Database SP・Cognito・Macie](#110-cloudfront-vpc-originsプライベートオリジン配信)
- [§120–§129. DataSync・EMR・ECR・CI/CD・SES・Q・Amplify](#120-aws-datasyncデータ移行転送-data-migration--transfer)
- [§130–§141. TGW・DirectConnect・Detective・Snow・Lex・EventBridge Pipes・S3 Express](#130-aws-transit-gatewayネットワークハブ-network-hub)
- [§142. Lambda Durable Functions](#142-lambda-durable-functions耐久ワークフロー-durable-workflow-orchestration)
- [§143. AWS Interconnectマルチクラウド接続](#143-aws-interconnectマルチクラウド接続-multi-cloud-private-connectivity)
- [§144. EKS Capabilities](#144-eks-capabilities-マネージドk8sツール群-managed-kubernetes-tooling)
- [§145. Amazon Novaモデルファミリー](#145-amazon-novaモデルファミリー-nova-ai-foundation-models)
- [§146. VPC Encryption Controls](#146-vpc-encryption-controls-ネットワーク暗号化制御-network-traffic-encryption)
- [§147. Data Perimeterデータ境界戦略](#147-data-perimeterデータ境界戦略-organization-wide-data-boundary)
- [§148. Passkey/FIDO2 MFA必須化](#148-passkeyfido2-mfa必須化プロトコル-phishing-resistant-mfa-mandate)
- [§149. Outposts Gen2 & Local Zones 2.0](#149-aws-outposts第2世代--local-zones-20-hybrid--edge-gen2)
- [§150. Amazon Transform](#150-amazon-transformエージェント型モダナイゼーション-agentic-application-modernization)
- [§151. Data Transfer Terminal](#151-aws-data-transfer-terminal物理データ転送端末-physical-data-upload-terminal)
- [§152. Green Insights](#152-aws-green-insightsサステナビリティ管理-carbon-footprint--sustainability-management)
- [§153. Shield AI駆動脅威検知](#153-aws-shield-ai駆動脅威検知-ai-enhanced-ddos-protection)
- [§154. Billing Custom Views & Split Cost](#154-billing-custom-views--split-cost-allocation-高度コストガバナンス)
- [§155. 成熟度モデル & アンチパターン集](#155-awsクラウド成熟度モデル--アンチパターン集-maturity-model--anti-patterns)
- [Appendix A. サービス別逆引き索引](#appendix-a-サービス別逆引き索引)

---

## 0. AWSクラウド至高の命令 (AWS Cloud Supreme Directives)

### Supreme Directive 0.1: The Well-Architected Compliance Mandate
-   **Law**: AWSインフラの設計・構築・運用において、**AWS Well-Architected Framework の6ピラー**への準拠を義務付けます。
    1.  **運用効率 (Operational Excellence)**: 自動化、IaC、ランブック整備。
    2.  **セキュリティ (Security)**: 最小権限、多層防御、暗号化。
    3.  **信頼性 (Reliability)**: Multi-AZ/リージョン、自動回復、カオスエンジニアリング。
    4.  **パフォーマンス効率 (Performance Efficiency)**: 適切なサービス選択、ライトサイジング。
    5.  **コスト最適化 (Cost Optimization)**: FinOps、無駄の排除、コミットメント戦略。
    6.  **サステナビリティ (Sustainability)**: リソース効率、Graviton採用、リージョン選択。以下の具体的アクションを実施：
        -   **Customer Carbon Footprint Tool**: AWSコンソールで自社のクラウド利用に伴う推定カーボンフットプリントを確認（2024年GA）。四半期ごとに排出量トレンドをレビューし削減目標を設定。
        -   **Graviton優先**: Gravitonインスタンスは同等x86比で最大60%のエネルギー効率向上。新規ワークロードではGraviton（§3.1参照）を第一候補として評価。
        -   **リソース効率化**: Compute Optimizer推奨に基づくライトサイジング、未使用リソースの削除（§9.3参照）、S3 Intelligent-Tiering（§78参照）によるストレージ階層最適化。
        -   **リージョン選択**: 再生可能エネルギー比率の高いリージョンを優先検討。AWSの[Sustainability Pillar公式ドキュメント](https://docs.aws.amazon.com/wellarchitected/latest/sustainability-pillar/)参照。
-   **Lenses（専門レンズ）**: ワークロードに応じて以下の公式レンズを適用してください（2025年更新）。
    -   **Responsible AI Lens**: AI/MLワークロードのガバナンス、バイアス評価、公平性、透明性の指針。
    -   **Generative AI Lens**: Bedrock / SageMaker JumpStart を用いた生成AIアプリケーションの設計・運用ガイド。
    -   **Machine Learning Lens**: ML パイプライン（データ収集→学習→推論→監視）のアーキテクチャ設計指針。
-   **Action**: 四半期ごとに AWS Well-Architected Tool でレビューを実施し、全ピラーで「高リスク項目ゼロ」を維持してください。AI/MLワークロードには必ず該当レンズのレビューも実施。

### Supreme Directive 0.2: The IaC-Only Mandate (Infrastructure as Code 絶対原則)
-   **Law**: AWS上の全リソースは、**Infrastructure as Code (IaC)** で定義・管理されなければなりません。AWSマネジメントコンソールやCLIでの手動作成・変更は「履歴の破壊行為」とみなします。
-   **Mandate**:
    1.  **Code First**: 全インフラ変更はコード（CloudFormation / CDK / Terraform）で定義し、Gitでバージョン管理してください。
    2.  **No ClickOps**: コンソールは「現在値の確認」「デバッグ」という参照専用（Read-only）として利用を制限してください。
    3.  **Drift Zero Tolerance**: `terraform plan` や CloudFormation Drift Detection で定期的にドリフトを検出し、検出された場合は即座にコードに反映または手動変更を元に戻してください。
-   **Exception**: 緊急インシデント対応時のみ手動変更を許可しますが、事後24時間以内にIaCコードへの反映を義務付けます。
-   **Reference — Terraformプロジェクト構成スケルトン**:
    ```
    infrastructure/
    ├── environments/
    │   ├── dev/
    │   │   ├── main.tf          # 環境固有のリソース定義
    │   │   ├── variables.tf     # 環境固有変数
    │   │   ├── terraform.tfvars # 環境固有値（Git管理、機密値はSSM/SecretsManager参照）
    │   │   └── backend.tf       # S3 + DynamoDB state管理
    │   ├── staging/
    │   └── production/
    ├── modules/                  # 再利用可能モジュール
    │   ├── networking/           # VPC, Subnets, NAT, TGW
    │   ├── compute/             # ECS, Lambda, EC2
    │   ├── database/            # RDS, DynamoDB, ElastiCache
    │   └── security/            # IAM, SG, WAF, GuardDuty
    └── _global/                 # Organizations, SCPs, IAM Identity Center
    ```
    **State管理必須設定（backend.tf）**:
    ```hcl
    terraform {
      backend "s3" {
        bucket         = "myproject-terraform-state-ACCOUNT_ID"
        key            = "env/dev/terraform.tfstate"
        region         = "ap-northeast-1"
        encrypt        = true
        dynamodb_table = "terraform-state-lock"  # 排他ロック必須
        kms_key_id     = "alias/terraform-state"  # KMS暗号化必須
      }
    }
    ```

### Supreme Directive 0.3: The Trinity DTO Mandate (データ構造三位一体)
-   **Purpose**: Supabase憲法（37番）と同一の原則。AWSサービス間のデータ受け渡しにおいても、生データの直接露出を禁止し、目的別DTOへの変換を義務付けます。
-   **Mandate**:
    -   **Security**: API Gateway → Lambda → クライアント間で、不必要なフィールド（内部ID、PII）の露出を物理的に防止。
    -   **Stability**: DBスキーマ変更がフロントエンドに直接影響しないマッパー層の実装。
    -   **AI Economy**: LLM/AIサービスへのペイロード最小化によるトークンコスト削減。

### Supreme Directive 0.4: The Multi-Account Strategy Mandate
-   **Law**: 本番ワークロードは**単一AWSアカウント**で運用してはなりません。AWS Organizationsを用いたマルチアカウント戦略を採用し、環境・責務ごとにアカウントを分離してください。
-   **Action**:
    1.  **Management Account**: 請求統合、Organizations管理専用。ワークロードを配置しない。
    2.  **Security Account**: GuardDuty、Security Hub、CloudTrailの委任管理者。
    3.  **Log Archive Account**: 全アカウントのCloudTrail・VPC Flow Logs・Config Logsの集約先。改竄防止設定必須。
    4.  **Network Account**: Transit Gateway、VPN、Direct Connect等のネットワークハブ。
    5.  **Workload Accounts**: 環境ごと（Dev / Staging / Production）に分離。
-   **SCP (Service Control Policies)**: 全アカウントに対し、未使用リージョンの無効化、ルートユーザーのAPI利用禁止等のガードレールをSCPで強制してください。
-   **Reference — 未使用リージョン無効化SCP例**:
    ```json
    {
      "Version": "2012-10-17",
      "Statement": [{
        "Sid": "DenyUnusedRegions",
        "Effect": "Deny",
        "NotAction": [
          "iam:*", "sts:*", "organizations:*",
          "support:*", "billing:*", "health:*",
          "cloudfront:*", "route53:*", "wafv2:*"
        ],
        "Resource": "*",
        "Condition": {
          "StringNotEquals": {
            "aws:RequestedRegion": [
              "ap-northeast-1",
              "us-east-1"
            ]
          }
        }
      }]
    }
    ```

---

## 1. IAMセキュリティ戦略 (IAM Security Strategy)

### Rule 1.1: The Least Privilege Iron Rule (最小権限の鉄則)
-   **Law**: 全てのIAMエンティティ（ユーザー、ロール、ポリシー）は、**タスクの遂行に必要最小限の権限のみ**を付与しなければなりません。
-   **Action**:
    1.  **No Wildcard Actions**: `"Action": "s3:*"` や `"Resource": "*"` のようなワイルドカード権限を本番環境で使用することを禁止します。全アクションとリソースARNを明示的に指定してください。
    2.  **IAM Access Analyzer**: 定期的に IAM Access Analyzer を実行し、外部アクセスが意図しないリソースに許可されていないか検出してください。
    3.  **Permission Boundaries**: 管理者が作成するロールの最大権限をPermission Boundariesで制限し、権限エスカレーションを物理的に防止してください。
    4.  **Customer Managed Policies**: AWS管理ポリシーは初期テンプレートとしてのみ使用し、本番環境では必要最小限の権限に絞ったカスタマー管理ポリシーを作成してください。
-   **Reference — 最小権限IAMポリシー例（Lambda用S3読取専用）**:
    ```json
    {
      "Version": "2012-10-17",
      "Statement": [{
        "Sid": "AllowS3ReadSpecificBucket",
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        "Resource": [
          "arn:aws:s3:::my-app-data-bucket",
          "arn:aws:s3:::my-app-data-bucket/*"
        ],
        "Condition": {
          "StringEquals": {
            "aws:PrincipalOrgID": "o-xxxxxxxxxxxx"
          }
        }
      }]
    }
    ```
    > **⚠️ アンチパターン**: `"Action": "s3:*", "Resource": "*"` — 全バケットの全操作が可能になり、情報漏洩・削除リスクが最大化。

### Rule 1.2: The Credential Hygiene Protocol (認証情報衛生)
-   **Law**: 長期認証情報（アクセスキー）の使用を原則禁止し、一時的な認証情報（IAMロール + STS）を全面的に採用してください。
-   **Action**:
    1.  **No Long-Term Keys**: IAMユーザーのアクセスキーを新規作成することを禁止します。EC2にはインスタンスプロファイル、LambdaにはIAMロール、CI/CDにはOIDCフェデレーションを使用してください。
    2.  **Federated Identity**: 人間のアクセスはIAM Identity Center（旧SSO）を使用し、外部IdP（Okta、Azure AD等）と連携してください。
    3.  **Key Rotation**: やむを得ず長期キーを使用する場合は、90日以内のローテーションを自動化してください。未使用キーは即削除。
    4.  **Root Account Lock**: ルートユーザーのアクセスキーを作成してはなりません。MFAを有効化し、日常業務での使用を完全禁止してください。ルートアカウントのアクティビティに対するCloudWatchアラームを設定してください。

### Rule 1.3: The MFA Enforcement Protocol
-   **Law**: 全てのIAMユーザーおよびルートアカウントに**MFA（多要素認証）**を強制してください。
-   **Action**:
    1.  **Hardware MFA for Root**: ルートアカウントにはハードウェアMFAデバイス（YubiKey等）を使用してください。
    2.  **SCP Enforcement**: MFAなしのAPI呼び出しを拒否するSCPをOrganizations全体に適用してください。
    3.  **Condition Keys**: 重要なアクション（IAMポリシー変更、S3バケット削除等）にはIAMポリシーの `Condition` で `aws:MultiFactorAuthPresent` を要求してください。

### Rule 1.4: The Cross-Account Access Protocol
-   **Law**: クロスアカウントアクセスは、アクセスキーの共有ではなく、**IAMロールの委任（AssumeRole）**で実現してください。
-   **Action**:
    1.  **Trust Policy**: 信頼ポリシーで許可するアカウントIDとExternalIdを明示的に指定してください。
    2.  **Session Duration**: セッション時間は業務に必要な最小限（推奨: 1時間以内）に設定してください。
    3.  **Audit**: クロスアカウントのAssumeRoleイベントをCloudTrailで監視し、異常なアクセスパターンを検出してください。

---

## 2. ネットワーク設計基準 (Network Design Standards)

### Rule 2.1: The VPC Architecture Protocol
-   **Law**: ワークロードは適切に設計されたVPC内に配置し、パブリックインターネットへの直接露出を最小化してください。
-   **Action**:
    1.  **CIDR Planning**: VPCのCIDRブロックはオンプレミスネットワークやピアリング先との重複を避けて計画し、将来の拡張余地を確保してください。IPv6デュアルスタックの採用を推奨。
    2.  **Multi-AZ**: 全ての本番ワークロードは最低2つのAZ（推奨3つ）に分散配置してください。
    3.  **Subnet Separation**: Public / Private / Isolated（DB専用）の3層サブネット構成を標準とします。
        -   **Public Subnet**: ALB、NAT Gateway、Bastionホスト のみ配置。
        -   **Private Subnet**: アプリケーションサーバー（EC2、ECS、Lambda VPC接続）。
        -   **Isolated Subnet**: RDS、ElastiCache等のデータストア。インターネットへの経路なし。
    4.  **VPC Block Public Access**: **Amazon VPC Block Public Access**をアカウントレベルで有効化し、VPCのインターネットアクセスを宣言的に制御してください（2024年GA）。
        -   **Bidirectional Block**: 全VPCのインバウンド・アウトバウンドインターネット通信をブロック（最も厳格）。
        -   **Ingress-Only Block**: インバウンドのみブロックし、アウトバウンド（NAT Gateway経由等）は許可。
        -   **Exclusions**: 特定のVPCやサブネットを除外設定可能（パブリックALBを持つVPC等）。IPv4/IPv6両対応。
        -   **SCP連携**: SCPと組み合わせ、Block Public Accessの無効化を組織全体で禁止するガードレールを設定。
-   **Reference — CIDR設計基準テーブル**:
    | VPC用途 | CIDR例 | サブネットサイズ | 備考 |
    |:----------|:--------|:------------|:-----|
    | Production | `10.1.0.0/16` | 各サブネット `/24`（251 IPs） | EKSは `/19` 推奨（Pod IP消費大） |
    | Staging | `10.2.0.0/16` | 各サブネット `/24` | Productionと重複禁止 |
    | Dev | `10.3.0.0/16` | 各サブネット `/24` | VPC Peering接続可 |
    | Shared Services | `10.0.0.0/16` | 各サブネット `/24` | DNS, AD, Monitoring |
    > **⚠️ アンチパターン**: 全環境で同一CIDRを使用 — VPC Peering/Transit Gateway接続が不可能になる。計画段階で全VPCのCIDRマップを作成すること。

### Rule 2.2: The Security Group Discipline (ステートフルファイアウォール規律)
-   **Law**: セキュリティグループは**最小権限のホワイトリスト方式**で設定し、不必要なポートの開放を禁止します。
-   **Action**:
    1.  **No 0.0.0.0/0 Inbound**: SSH（22番）やRDP（3389番）のインバウンドルールに `0.0.0.0/0` を指定することを厳禁とします。踏み台経由またはSSM Session Managerを使用してください。
    2.  **SG Reference**: 異なるティア間の通信は、IPアドレス範囲ではなくセキュリティグループIDを参照する形で許可してください。
    3.  **Tier Isolation**: Web層、App層、DB層それぞれに専用のセキュリティグループを作成し、Allow規則は必要最小限のポート・プロトコルに限定してください。

### Rule 2.3: The NACL Defense Layer
-   **Law**: NACLはセキュリティグループの追加防御層として、サブネットレベルでの明示的な拒否ルールを実装してください。
-   **Action**:
    1.  **Explicit Deny**: 既知の悪意あるIPレンジや不要なプロトコルを明示的に拒否するルールを追加してください。
    2.  **Stateless Awareness**: NACLはステートレスです。インバウンドを許可する場合、対応するエフェメラルポート範囲のアウトバウンドも許可してください。
    3.  **Rule Ordering**: ルールは番号順に評価されます。拒否ルールを許可ルールより前（小さい番号）に配置してください。

### Rule 2.4: The VPC Endpoint Mandate (プライベート接続義務)
-   **Law**: VPC内からAWSサービス（S3、DynamoDB、SQS、KMS等）へのアクセスは、インターネットゲートウェイやNAT Gatewayを経由せず、**VPCエンドポイント**を使用してプライベート接続してください。
-   **Action**:
    1.  **Gateway Endpoint**: S3とDynamoDBにはGatewayエンドポイント（無料）を必ず作成してください。
    2.  **Interface Endpoint (PrivateLink)**: その他のAWSサービス（KMS、STS、ECR、CloudWatch Logs等）にはInterfaceエンドポイントを作成し、トラフィックをAWSネットワーク内に閉じ込めてください。
    3.  **Endpoint Policy**: VPCエンドポイントにポリシーを設定し、特定のリソース（特定のS3バケット等）へのアクセスのみを許可するデータ境界を構築してください。

### Rule 2.5: The NAT Gateway Resilience
-   **Law**: プライベートサブネットからのアウトバウンドインターネットアクセスにはNAT Gatewayを使用し、高可用性を保証してください。
-   **Action**:
    1.  **AZ NAT Gateway（従来型）**: 各AZに1つずつNAT Gatewayを配置し、AZ障害時のアウトバウンド通信停止を防止。AZ単位での障害分離が必要な場合に選択。
    2.  **Regional NAT Gateway（推奨・2025年11月GA）**: **リージョンレベルで1つのNAT Gateway**を配置し、ワークロードの存在するAZ間で自動的にスケール・拡縮。パブリックサブネットへの配置が不要。ポート枯渇保護が組み込まれ、大規模ワークロードでも安定動作。運用オーバーヘッドを大幅に削減。
    3.  **Selection Criteria**: 新規環境はRegional NAT Gatewayを第一候補とする。既存環境でAZ単位のNAT GWが稼働中の場合、コスト比較（アタッチメント数×料金）と運用簡素化を考慮して移行を検討。
    4.  **Monitoring**: CloudWatch メトリクス（`BytesOutToDestination`, `PacketsDropCount`, `ErrorPortAllocation`）を監視。Regional NAT GWではポート枯渇が自動回避されるが、異常なトラフィック増加を検知するためアラートは必須。
-   **Anti-pattern**: 全AZに個別NAT Gatewayを配置し管理コストを増大させること。Regional NAT Gatewayで運用を簡素化。
-   **Cross-Ref**: Transit Gatewayは§130参照。VPCネットワーキングは§2参照。

### Rule 2.6: The Transit Gateway Hub (大規模ネットワーク)
-   **Law**: 3つ以上のVPCを接続する場合、VPCピアリングのメッシュ構成ではなく、**Transit Gateway**をハブとして使用してください。
-   **Action**:
    1.  **Route Table Segregation**: VPCごとに専用のルートテーブルを割り当て、不必要なVPC間通信を遮断してください。
    2.  **Network Firewall Integration**: Transit Gatewayと AWS Network Firewall を統合し、VPC間トラフィックの検査・フィルタリングを実施してください。
    3.  **Encryption**: Transit Gateway経由の通信は暗号化を有効化してください。

### Rule 2.7: The VPC Lattice Service Networking
-   **Law**: マイクロサービス間の通信には**Amazon VPC Lattice**を活用し、サービス間のネットワーキングを簡素化してください（2024年GA）。
-   **Action**:
    1.  **Service Network**: VPC Latticeのサービスネットワークを作成し、複数VPC・アカウントにまたがるサービス間通信を、VPCピアリングやTransit Gatewayなしで実現。
    2.  **Auth Policy**: サービス間認証にIAM認証ポリシーを適用し、ゼロトラストのサービス間通信を実装。
    3.  **Weighted Routing**: VPC Lattice のトラフィック管理機能でカナリアデプロイ（重み付きルーティング）を実装。
    4.  **Observability**: アクセスログをCloudWatch Logs / S3 / Kinesis Data Firehoseに送信し、サービス間通信の可視化を実現。
-   **Use Case**: ECS/EKS/Lambda/EC2の混在環境でのサービスメッシュ代替として推奨。Envoy等のサイドカープロキシ不要で運用簡素化。

### Rule 2.8: The VPC Block Public Access (アカウントレベルパブリック遮断)
-   **Law**: 全アカウントで**VPC Block Public Access**を有効化し、意図しないパブリックインターネット接続を物理的に遮断してください（2024 GA）。
-   **Action**:
    1.  **Account-Level Enforcement**: VPC Block Public Access をアカウントレベルで有効化。インターネットゲートウェイ（IGW）経由のインバウンド/アウトバウンド通信をデフォルトで遮断。
    2.  **Exclusion Management**: パブリックアクセスが必要なVPC/サブネット（ALB用パブリックサブネット等）のみを明示的に除外リストに登録。除外は最小限に維持。
    3.  **Organizations展開**: SCPまたはAWS Organizationsのポリシーで全アカウントへの一括適用を推奨。Shadow IT や開発者の誤設定によるパブリック露出を根本的に排除。
    4.  **監査**: AWS Config Rule でBPAの無効化・除外設定の変更を検知し、不正な変更を即時アラート。
-   **Anti-pattern**: BPAを有効化せずにSecurity Groupのみでパブリックアクセス制御を行うこと。人的ミスによるSG設定漏れは防止できない。

---

## 3. コンピューティング戦略 (Compute Strategy)

### Rule 3.1: The Right-Sizing Mandate (ライトサイジング義務)
-   **Law**: コンピューティングリソースは定期的に使用状況を分析し、**適切なサイズに調整（Right-Sizing）**しなければなりません。過剰プロビジョニングはコスト浪費、過小プロビジョニングはパフォーマンス劣化です。
-   **Action**:
    1.  **AWS Compute Optimizer**: 全EC2インスタンス、Lambda関数、ECSタスクに対してCompute Optimizerの推奨事項を月次でレビューしてください。
    2.  **CloudWatch Metrics**: CPU使用率、メモリ使用率、ネットワークI/Oを継続的に監視し、平均使用率が30%未満のインスタンスはダウンサイジング候補としてください。
    3.  **Graviton First**: 新規ワークロードはARMベースの**Graviton インスタンス**を第一候補としてください。x86対比で最大40%の価格性能比改善が見込めます。

        | 世代 | インスタンス例 | 特長 |
        |:-----|:--------------|:-----|
        | Graviton3 | C7g, M7g, R7g | Graviton2比25%高性能、2倍の浮動小数点演算 |
        | Graviton4 | C8g, M8g, R8g | Graviton3比30%高性能、75%高メモリ帯域 |
        | **Graviton5** | **M9g, C9g, R9g** | **192コア/チップ、3nmプロセス、Graviton4比25%コンピュート性能向上、30%DB高速化、35%Web/MLワークロード高速化、5倍L3キャッシュ（コアあたり2.6倍）、15%高ネットワーク帯域、20%高EBS帯域、Nitro Isolation Engine搭載（re:Invent 2025〜）** |

        > ※ 新規ワークロードは最新世代（Graviton5 / M9g）から検討し、互換性を検証。C9g（コンピュート集約型）、R9g（メモリ集約型）は2026年提供開始予定。

### Rule 3.2: The Lambda Best Practices (サーバーレス最適化)
-   **Law**: Lambda関数の設計・実装において、コールドスタートの最小化、メモリ最適化、コスト効率を追求してください。
-   **Cross-Ref**: 安定した高トラフィックワークロードには**Lambda Managed Instances**（§108）も検討。EC2上でLambdaを実行し、Savings Plans/RIによるコスト最適化が可能。
-   **Action**:
    1.  **Memory-CPU Tuning**: Lambdaのメモリ割り当てはCPU割り当てに比例します（1,769MBで1 vCPU）。**AWS Lambda Power Tuning** ツールで最適なメモリ設定を特定してください。
    2.  **Cold Start Mitigation**:
        -   デプロイパッケージを最小化（未使用依存関係の削除、Lambda Layersの活用）。
        -   **SnapStart**を有効化しコールドスタートを最大90%削減:
            -   **Java**: 初期化スナップショットによるコールドスタート劇的削減（GA済み）。
            -   **Python** (2024 GA): `snapstart: ApplyOn: PublishedVersions` で有効化。boto3/pandas等の重い初期化を高速化。
            -   **.NET** (2024 GA): .NET 8+対応。DI/EFCore初期化の高速化に最適。
        -   ランタイムはNode.js/Pythonを推奨（コールドスタートが最小）。Go/Rustも高性能。
        -   SDK初期化、DB接続はハンドラー外（INIT フェーズ）で実行し、Warm Invocationで再利用。
        -   **ARM64 (Graviton2)**: `arm64` アーキテクチャを指定しGravitonで実行（x86比20%安価・最大34%高性能）。新規関数はARM64をデフォルトに。
    3.  **Provisioned Concurrency**: 支払い処理、認証等のレイテンシクリティカルな関数には Provisioned Concurrency を設定し、コールドスタートをゼロにしてください。
    4.  **Response Streaming**: レスポンスが大きいワークロード（レポート生成・LLMストリーミング等）には**Lambda Response Streaming**を使用。従来の6MBペイロード制限を超え最大20MBまでストリーミング送信可能。Time to First Byte (TTFB) を大幅改善。Function URLまたはCloudFront経由で利用。
    5.  **Function Design**:
        -   1関数1責務（Single Responsibility）。モノリシックLambdaを禁止。
        -   タイムアウトは必要最小限に設定（デフォルト3秒→タスクに応じて調整）。
        -   べき等性（Idempotency）を保証。SQS + Lambda構成では重複実行を前提とした設計。
    6.  **VPC Attachment**: VPC接続は本当に必要な場合のみ。RDS Proxy、DynamoDB、外部APIはVPC外から接続可能です。
    7.  **Advanced Logging Controls**: Lambda関数のログを**JSON構造化形式**で出力（2024 GA）。アプリケーションレベルのログレベル（INFO/WARN/ERROR）をLambda設定から制御可能。CloudWatch Logs Insightsでの分析効率を大幅向上。
-   **Reference — Lambdaコールドスタート最小化パターン（Node.js）**:
    ```typescript
    // ✅ INITフェーズで初期化（Warm Invocationで再利用）
    import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
    const client = new DynamoDBClient({});  // ハンドラー外でインスタンス化

    export const handler = async (event: APIGatewayProxyEvent) => {
      // ✅ べき等性キーで重複実行防止
      const idempotencyKey = event.headers['x-idempotency-key'];
      if (!idempotencyKey) {
        return { statusCode: 400, body: 'Missing idempotency key' };
      }
      // ... business logic
    };
    ```
-   **Reference — Lambdaメモリ別コスト指標**:
    | メモリ (MB) | vCPU組 | 価格 (USD/ms) | 推奨用途 |
    |:-----------|:----------|:-------------|:--------|
    | 128 | 0.07 vCPU | $0.0000000021 | 軽量トリガー/イベントフィルタ |
    | 512 | 0.29 vCPU | $0.0000000083 | APIハンドラ |
    | 1769 | 1 vCPU | $0.0000000292 | 標準ビジネスロジック |
    | 3008 | 1.7 vCPU | $0.0000000496 | データ処理/画像変換 |
    | 10240 | 6 vCPU | $0.0000001668 | ML推論/重計算 |

### Rule 3.3: The Container Strategy (ECS / EKS)
-   **Law**: コンテナワークロードの実行基盤として、マネージドサービス（ECS / EKS）を使用し、自前のコンテナオーケストレーションを構築してはなりません。
-   **Action**:
    1.  **Fargate First**: サーバー管理を排除するため、**AWS Fargate** を第一候補としてください。EC2起動タイプはGPUワークロードやカスタムカーネル要件がある場合に限定。
    2.  **EKS Auto Mode**: EKSを使用する場合、**EKS Auto Mode**の採用を強く推奨（re:Invent 2025 GA）。コンピュート・ストレージ・ネットワークの完全自動管理を実現し、手動でのKarpenter設定やアドオン管理が不要に。
        -   EKS Auto Modeが最適なEC2インスタンスタイプを自動選択し、動的にリソースをスケーリング。
        -   コアアドオン（CoreDNS、kube-proxy、VPC CNI等）のアップグレードも自動管理。
        -   Kubernetes-conformantなデータプレーンを提供し、チームはアプリケーション開発に集中可能。
        -   **注意**: 高度なノードカスタマイズ（カスタムAMI、特定カーネルパラメータ等）が必要な場合はManaged Node Groups/Self-Managedを選択。
    3.  **Image Security**: ECRのイメージスキャン機能を有効化し、Critical/High脆弱性を持つイメージのデプロイを禁止してください。
    4.  **Task Sizing**: ECSタスク/Podのリソース要求（CPU、メモリ）はContainer Insightsのメトリクスに基づいてライトサイジングしてください。
    5.  **Secrets Injection**: コンテナ内に認証情報をハードコードせず、**AWS Secrets Manager**または**SSM Parameter Store**から実行時に注入してください。

### Rule 3.4: The Auto Scaling Protocol
-   **Law**: 本番ワークロードには**Auto Scaling**を必ず設定し、需要変動に自動対応してください。手動スケーリングに依存する運用を禁止します。
-   **Action**:
    1.  **Target Tracking**: CPU使用率70%を目標としたTarget Tracking Scalingを基本とし、カスタムメトリクス（キュー深度、リクエスト数等）も活用してください。
    2.  **Predictive Scaling**: トラフィックパターンが予測可能な場合、Predictive Scalingを有効化して事前にキャパシティを確保してください。
    3.  **Scale-In Protection**: ステートフルなタスク（長時間バッチ処理等）にはScale-In保護を設定し、処理中のインスタンスが終了されることを防いでください。
    4.  **Cooldown**: スケールアウト/インのクールダウン期間を適切に設定し、フラッピング（急激なスケール変動の繰り返し）を防止してください。

### Rule 3.5: The App Runner Strategy
-   **Law**: シンプルなWebアプリケーション・APIのコンテナデプロイには**AWS App Runner**を検討してください。VPC/ALB/Auto Scaling等のインフラ管理を完全に抽象化し、開発者はコードに集中できます。
-   **Action**:
    1.  **Use Case**: カスタムネットワーク構成やサイドカーが不要なステートレスWebアプリ/REST APIに最適。マイクロサービスの個別デプロイにも推奨。
    2.  **Source**: ECRイメージまたはGitHubリポジトリからの自動デプロイ。プッシュごとの自動デプロイを有効化。
    3.  **VPC Connector**: プライベートリソース（RDS/ElastiCache等）へのアクセスが必要な場合はVPCコネクタを設定。
    4.  **Auto Scaling**: 同時リクエスト数ベースの自動スケーリング。最小インスタンス数1、最大25（デフォルト）。コスト最適化のためPause/Resume機能を活用。
    5.  **Observability**: CloudWatch Logs/X-Rayトレーシングを自動統合。カスタムメトリクスの送信も可能。
-   **vs Fargate**: App Runner = インフラ抽象化（PaaS的）。Fargate = 細かなネットワーク/タスク制御が必要な場合。複雑なマイクロサービス群にはECS/Fargateを優先。

---

## 4. データベース戦略 (Database Strategy)

### Rule 4.1: The RDS / Aurora Best Practices
-   **Law**: リレーショナルデータベースにはマネージドサービス（RDS / Aurora）を使用し、EC2上での自前DB運用を原則禁止します。
-   **Action**:
    1.  **Aurora First**: 新規プロジェクトでは**Amazon Aurora**（MySQL互換/PostgreSQL互換）を第一候補としてください。標準RDS対比で最大5倍（MySQL）、3倍（PostgreSQL）のスループット。
    2.  **Multi-AZ Mandatory**: 本番DBは必ずMulti-AZ配置とし、自動フェイルオーバー（35秒以内）を保証してください。
    3.  **Read Replica Strategy**:
        -   読み取り負荷の分散にはAurora Replicas（最大15台）を使用し、Readerエンドポイントでロードバランシングしてください。
        -   レプリカラグ（`AuroraReplicaLag`）を継続監視し、ラグが増大した場合はReaderインスタンスのサイジングを見直してください。
    4.  **RDS Proxy Mandatory**: サーバーレス環境（Lambda）からのDB接続には**RDS Proxy**を必ず使用してください。Lambda関数の同時実行数増加時のDB接続数爆発を防止します。
    5.  **Performance Insights**: 全RDS/Auroraインスタンスで Performance Insights を有効化し、DBロード、トップSQL、ウェイトイベントを継続監視してください。
    6.  **Parameter Group**: デフォルトパラメータグループを使用せず、カスタムパラメータグループを作成してワークロードに最適化してください。
    7.  **Aurora Limitless Database**: ペタバイト級のデータ・数百万TPS要件には**Aurora Limitless Database**（2024年GA・PostgreSQL互換）を検討:
        -   **Router + Shard Group**: Routerがクエリを適切なShardに自動ルーティング。アプリケーション側のシャーディングロジックは不要。
        -   **分散トランザクション**: Shard間の分散トランザクションをAuroraが透過的に管理。ACID保証を維持しながら水平スケール。
        -   **テーブル分類**: Reference Tables（全Shardにレプリカ）とSharded Tables（キーで分散）を適切に設計。小さなマスタテーブルはReference、大規模トランザクションテーブルはSharded。
        -   **制限事項**: 外部キー制約の制限あり。参照整合性はアプリケーション層での管理が必要な場合あり。
    8.  **Aurora I/O-Optimized**: I/Oコストが月額DBコストの**25%を超過**するワークロードには**I/O-Optimized**クラスタ構成を選択。I/O料金が発生せず、I/O集約型ワークロードで最大40%のコスト削減。Provisioned/Serverless v2の両方で利用可能。

### Rule 4.2: The DynamoDB Design Protocol
-   **Law**: DynamoDBの設計は**アクセスパターンファースト**で行い、RDBの正規化思考を直接適用してはなりません。
-   **Action**:
    1.  **Access Pattern First**: テーブル設計前に、全てのRead/Writeアクセスパターンを洗い出してください。「後からJOINできる」前提の設計は禁止です。
    2.  **Partition Key Design**: 高カーディナリティのパーティションキーを選択し、データの均等分散を保証してください。タイムスタンプやシーケンシャルIDの単独使用を禁止。
    3.  **Hot Partition Prevention**:
        -   書き込みが集中するキーには**Write Sharding**（ランダムサフィックス付与）を適用してください。
        -   読み取りホットスポットには**DAX (DynamoDB Accelerator)**キャッシュを導入してください。
    4.  **GSI Hygiene**: GSIの数は必要最小限（上限20）に抑え、射影属性は`KEYS_ONLY`または必要なカラムのみ（`INCLUDE`）としてください。`ALL`射影はストレージコストを倍増させます。
    5.  **Capacity Mode Selection**:
        -   予測可能なトラフィック → Provisioned（RI/SP適用可能でコスト効率◎）
        -   予測不能なスパイク → On-Demand
    6.  **Item Size Limit**: 1アイテムの上限は400KB。大きなデータはS3に格納し、DynamoDBにはS3参照キーのみ保存してください。
    7.  **Query over Scan**: `Scan`操作は全件走査であり、大規模テーブルでは禁止です。必ず`Query`でパーティションキーを指定してアクセスしてください。

### Rule 4.3: The ElastiCache Strategy
-   **Law**: 高頻度の読み取りやセッション管理には**ElastiCache**（Redis / Memcached）を使用し、DBへの直接負荷を軽減してください。
-   **Action**:
    1.  **Cache-Aside Pattern**: アプリケーション層でキャッシュの読み取り→ミスの場合のみDB問い合わせ→結果をキャッシュに書き込む、のパターンを標準としてください。
    2.  **TTL Mandatory**: 全キャッシュエントリにTTL（有効期限）を設定し、ステイルデータの無期限残存を防止してください。
    3.  **Multi-AZ**: 本番環境では Multi-AZ + 自動フェイルオーバーを有効化してください。

---

## 5. ストレージ戦略 (Storage Strategy)

### Rule 5.1: The S3 Security Fortress
-   **Law**: S3バケットのセキュリティは**多層防御（Defense in Depth）**で構築し、意図しないデータ公開を物理的に不可能にしてください。
-   **Action**:
    1.  **Block Public Access**: アカウントレベルおよびバケットレベルで**S3 Block Public Access**を有効化してください。例外は絶対に許可しないでください（静的サイトホスティングにはCloudFront + OAC を使用）。
    2.  **Encryption Mandatory**: 全バケットでサーバーサイド暗号化を有効化。機密データには**SSE-KMS**（CMK）を使用し、キーの使用を監査してください。通常データは**SSE-S3**で十分です。
    3.  **Bucket Policy**: 最小権限の原則に基づき、必要なIAMロール/アカウントからのアクセスのみを許可してください。`"Principal": "*"` の使用を禁止。
    4.  **Versioning**: 重要なデータバケットではバージョニングを有効化し、誤削除・上書きからの復旧を可能にしてください。
    5.  **MFA Delete**: 重要バケットではMFA Deleteを有効化し、悪意のある削除を防止。
    6.  **ACL Disabled**: S3 Object Ownershipを「バケット所有者強制 (Bucket Owner Enforced)」に設定し、ACLを無効化してください。アクセス制御はバケットポリシーとIAMに集約。
    7.  **Access Logging**: サーバーアクセスログを別のログバケットに出力し、不正アクセスの痕跡を追跡可能にしてください。
    8.  **S3 Access Grants** (2024 GA): IAMポリシーの代わりに**Active Directory / IdP のユーザー/グループ**に基づいたS3データアクセス制御を実現。IAM Identity Center と連携し、ユーザーのIDに基づいてS3プレフィックスレベルの権限を動的付与。数千人規模のアクセス管理を個別バケットポリシーからAccess Grantsに統合。
-   **Cross-Ref**: 超低レイテンシストレージは**§141（S3 Express One Zone）**参照。ベクトルストレージは**§107（S3 Vectors）**参照。

### Rule 5.2: The S3 Lifecycle Optimization
-   **Law**: S3のストレージコストを最適化するため、**ライフサイクルポリシー**を全バケットに設定してください。
-   **Action**:
    1.  **Tiered Storage**: アクセス頻度に応じてストレージクラスを自動遷移させてください。

        | 期間 | ストレージクラス | 用途 |
        |:-----|:----------------|:-----|
        | (超低レイテンシ) | S3 Express One Zone | ML学習データ・分析中間データ（§141参照）|
        | 0-30日 | S3 Standard | アクティブデータ |
        | 30-90日 | S3 Standard-IA | 低頻度アクセス |
        | 90-365日 | S3 Glacier Instant Retrieval | アーカイブ（即時取得） |
        | 1年以上 | S3 Glacier Deep Archive | 長期保管（12時間取得） |

    2.  **Incomplete Upload Cleanup**: マルチパートアップロードの不完全なアップロードを7日後に自動削除するルールを設定してください。
    3.  **Noncurrent Version Expiration**: バージョニング有効バケットでは、非現行バージョンの保持期間と保持数を明示的に設定し、ストレージ肥大化を防止してください。
    4.  **S3 Intelligent-Tiering**: アクセスパターンが予測困難なデータには S3 Intelligent-Tiering を適用し、自動的に最適なクラスに移行させてください。

### Rule 5.3: The Cross-Region Replication Protocol
-   **Law**: 災害復旧（DR）要件を持つデータには**Cross-Region Replication (CRR)**を設定し、別リージョンへの自動複製を保証してください。
-   **Action**:
    1.  バージョニングをソース・宛先バケットの両方で有効化（CRRの前提条件）。
    2.  レプリケーションにはCMK（KMS）を使用し、両リージョンのキーポリシーでレプリケーションロールを許可。
    3.  レプリケーションメトリクス（`ReplicationLatency`）を監視し、遅延が閾値を超えた場合にアラートを発報。

### Rule 5.4: The EBS / EFS Standards
-   **Law**: ブロックストレージ（EBS）およびファイルストレージ（EFS）のコストとパフォーマンスを最適化してください。
-   **Action**:
    1.  **EBS Type Selection**: gp3 を標準とし、gp2は使用しない。io2 Block Express は高IOPS要件時のみ使用。
    2.  **Unattached Volume Cleanup**: 未アタッチのEBSボリュームを週次で検出・削除してください（AWS Config Rule `ec2-volume-inuse-check`）。
    3.  **Snapshot Management**: EBSスナップショットのライフサイクルポリシー（AWS Backup / DLM）を設定し、古いスナップショットの自動削除を実施してください。
    4.  **EFS Lifecycle**: EFS Intelligent-Tiering を有効化し、アクセスされないファイルをIA（低頻度アクセス）クラスに自動移行させてください。
    5.  **Encryption**: 全EBSボリュームおよびEFSファイルシステムで暗号化を有効化してください。アカウントレベルのデフォルト暗号化設定を推奨。

---

## 6. セキュリティ運用 (Security Operations)

### Rule 6.1: The GuardDuty Mandate (脅威検知義務)
-   **Law**: **Amazon GuardDuty**を全AWSアカウント・全リージョンで有効化し、脅威検知を常時監視してください。
-   **Action**:
    1.  **All Regions**: 使用していないリージョンでもGuardDutyを有効化してください（未使用リージョンでの不正活動を検知するため）。
    2.  **Delegated Administrator**: Organizations内でセキュリティアカウントを委任管理者に設定し、全アカウントの検知結果を一元管理してください。
    3.  **Protection Plans**: 以下の全保護プランを有効化:
        -   **S3 Malware Protection** (2024 GA): S3バケットへのオブジェクトアップロード時に自動マルウェアスキャン。検知時にオブジェクトタグ付け（`GuardDutyMalwareScanStatus: THREATS_FOUND`）。EventBridge連携で感染ファイルの自動隔離/削除ワークフローを構築。ユーザーアップロードを受け付けるバケットには必須。
        -   **EKS/ECS Runtime Monitoring**: コンテナワークロード内の不審なプロセス実行、ファイルアクセス、ネットワーク通信をリアルタイム検知。EKS Add-on/ECS Sidecar で自動デプロイ。
        -   **Lambda Network Activity Monitoring**: Lambda関数の不審なネットワーク接続（C2サーバー通信等）を検知。
        -   **RDS Login Activity Monitoring**: Aurora/RDS へのブルートフォース攻撃・不審なログイン試行を検知。
    4.  **Extended Threat Detection（拡張脅威検知）**: EC2/ECS向けの**Extended Threat Detection**を有効化してください（re:Invent 2025〜）。複数のイベントソースとシグナルを相関分析し、高度な攻撃シーケンス（クレデンシャル窃取→横移動→データ流出等）を単一のFindingとして検出。従来の個別アラートでは見逃していた攻撃キャンペーンを可視化。
    5.  **Finding Workflow**: Critical/High の検知結果は24時間以内に調査・対応を完了してください。

### Rule 6.2: The Security Hub Unified View
-   **Law**: **AWS Security Hub**を有効化し、AWS Foundational Security Best Practices (FSBP) スタンダードの全コントロールに準拠してください。
-   **Action**:
    1.  **AWS Config Prerequisite**: Security Hubの大半のチェックはAWS Configに依存します。全アカウント・全リージョンでAWS Configを有効化してください。
    2.  **FSBP Compliance**: FSBPスタンダードのスコアを**95%以上**に維持してください。
    3.  **Finding Aggregation**: Security Hub の Cross-Region Aggregation を設定し、全リージョンの検知結果を単一リージョンに集約してください。
    4.  **Automated Remediation**: Critical/Highの検知結果に対してEventBridge→Lambda による自動修復ワークフローを構築してください。
-   **Reference — Security Hub自動修復EventBridgeルール例**:
    ```json
    {
      "source": ["aws.securityhub"],
      "detail-type": ["Security Hub Findings - Imported"],
      "detail": {
        "findings": {
          "Severity": { "Label": ["CRITICAL", "HIGH"] },
          "Workflow": { "Status": ["NEW"] },
          "ProductFields": {
            "StandardsControlArn": [{
              "prefix": "arn:aws:securityhub"
            }]
          }
        }
      }
    }
    ```
    > **運用基準**: CRITICAL=4時間以内対応、HIGH=24時間以内対応、MEDIUM=7日以内対応

### Rule 6.3: The AWS Config Governance
-   **Law**: **AWS Config**を全アカウントで有効化し、コンフィグルールによる継続的なコンプライアンス監視を実施してください。
-   **Action**:
    1.  **Mandatory Rules**: 以下のルールを必須として適用：
        -   `s3-bucket-public-read-prohibited` / `s3-bucket-public-write-prohibited`
        -   `rds-instance-public-access-check`
        -   `ec2-volume-inuse-check`
        -   `iam-root-access-key-check`
        -   `encrypted-volumes`
        -   `cloud-trail-enabled`
    2.  **Conformance Packs**: 業界標準（CIS、PCI-DSS等）のConformance Packsを適用してください。
    3.  **Remediation**: 自動修復アクションを設定し、非準拠リソースの即時対応を可能にしてください。

### Rule 6.4: The WAF / Shield Protocol (Web保護)
-   **Law**: パブリック向けのWebアプリケーション（ALB、API Gateway、CloudFront）には**AWS WAF**を必ず適用してください。
-   **Action**:
    1.  **Managed Rule Groups**: AWS Managed Rulesの Core Rule Set (CRS) と Known Bad Inputs を基本セットとして適用。
    2.  **Rate Limiting**: APIエンドポイントにはRate-based Rulesを設定し、DDoS/ブルートフォースを防止。
    3.  **Bot Control**: Bot Controlマネージドルールを適用し、悪意あるボットトラフィックをブロック。
    4.  **Shield Advanced**: 高可用性要件のワークロードにはAWS Shield Advancedを適用し、DDoS保護を強化してください。

---

## 7. オブザーバビリティ戦略 (Observability Strategy)

### Rule 7.1: The CloudWatch Foundation
-   **Law**: 全AWSリソースのメトリクス、ログ、トレースを**Amazon CloudWatch**に集約し、運用可視性を確保してください。
-   **Action**:
    1.  **Custom Metrics**: AWSデフォルトメトリクスに加え、ビジネスKPI（注文数、エラー率、レイテンシ P99等）をカスタムメトリクスとして送信してください。
    2.  **Log Groups**: 全アプリケーションログをCloudWatch Logsに送信。構造化ログ（JSON形式）を標準とし、Logs Insightsでのクエリ効率を最大化してください。
    3.  **Retention Policy**: ログの保持期間をLog Groupごとに明示的に設定してください。無期限保持（デフォルト）はコスト浪費です。

        | ログ種別 | 推奨保持期間 |
        |:---------|:-------------|
        | アプリケーションログ | 90日 |
        | セキュリティログ（CloudTrail） | 1年（S3に永続保存） |
        | デバッグログ | 14日 |
        | アクセスログ | 30日 |

    4.  **Alarms**: 重要メトリクスにCloudWatch Alarmsを設定し、SNS経由でSlack/PagerDuty等に通知してください。

### Rule 7.2: The CloudTrail Audit Trail
-   **Law**: **AWS CloudTrail**を全アカウント・全リージョンで有効化し、API呼び出しの完全な監査証跡を保持してください。
-   **Action**:
    1.  **Organization Trail**: Organizations単位のTrailを作成し、全アカウントのイベントを自動収集。
    2.  **S3 + Integrity**: ログはLog Archiveアカウントの専用S3バケットに保存し、ログファイルの整合性検証（Log File Validation）を有効化。
    3.  **S3 Object Lock**: CloudTrailログバケットにObject Lock（WORM）を適用し、ログの改竄・削除を物理的に防止してください。
    4.  **Data Events**: 重要なS3バケットやLambda関数のデータイベントも記録対象に追加してください。

### Rule 7.3: The Distributed Tracing Mandate
-   **Law**: マイクロサービス / サーバーレスアーキテクチャでは、**AWS X-Ray**または OpenTelemetry を使用した分散トレーシングを実装してください。
-   **Action**:
    1.  全Lambda関数、ECSタスク、API Gatewayでトレーシングを有効化。
    2.  サービスマップを活用してボトルネックとエラー発生箇所を特定。
    3.  サンプリングレートを本番環境では5-10%に設定し、コストとカバレッジのバランスを取ってください。

### Rule 7.4: The Internet Monitor Protocol
-   **Law**: グローバルに展開するアプリケーションでは、**Amazon CloudWatch Internet Monitor**を活用し、インターネット経由のユーザー体験を可視化してください（2023年GA）。
-   **Action**:
    1.  **Traffic Insights**: CloudFront/VPC/WorkSpaces等のリソースに対するインターネットパフォーマンス（可用性・レイテンシ）をリアルタイム監視。
    2.  **Health Events**: ISP障害やインターネット経路の劣化を自動検出し、EventBridge経由でアラート通知。
    3.  **Optimization Suggestions**: トラフィックの最適化提案（リージョン切替、CloudFront活用等）を活用し、エンドユーザー体験を改善。

---

## 8. IaC・デプロイ戦略 (IaC & Deployment Strategy)

### Rule 8.1: The IaC Tool Selection
-   **Law**: プロジェクトのIaCツールを統一し、混在使用を最小化してください。
-   **Recommendation**:
    -   **AWS CDK**: AWSネイティブのプロジェクトに推奨。プログラミング言語（TypeScript推奨）で型安全にインフラを定義可能。
    -   **Terraform**: マルチクラウドまたはAWS以外のプロバイダーとの統合が必要な場合に推奨。
    -   **CloudFormation**: CDKの出力先としてまたはレガシー資産の維持に限定。直接YAMLを記述する新規プロジェクトは非推奨。
-   **Prohibition**: 同一プロジェクト内でCDKとTerraformを混在させることは、状態管理の分裂を招くため禁止します。

### Rule 8.2: The State Management Protocol (Terraform)
-   **Law**: Terraformのステートファイルをローカルに保管することを**厳禁**とします。
-   **Action**:
    1.  **S3 Backend**: ステートファイルは暗号化されたS3バケットに保存してください。
    2.  **DynamoDB Locking**: 同時実行によるステート破損を防ぐため、DynamoDBテーブルでロックを取得してください。
    3.  **State Isolation**: 環境ごと（Dev / Staging / Production）にステートファイルを分離してください。

### Rule 8.3: The CI/CD Pipeline Mandate
-   **Law**: インフラのデプロイは手動の `terraform apply` や `cdk deploy` ではなく、**CI/CDパイプライン**経由で実行してください。
-   **Action**:
    1.  **Plan Review**: `terraform plan` / `cdk diff` の出力をプルリクエストにコメントとして投稿し、レビュー後にマージ→自動デプロイの流れを構築。
    2.  **OIDC Federation**: CI/CD（GitHub Actions等）からAWSへのアクセスにはOIDCフェデレーションを使用し、長期アクセスキーの保管を排除。
    3.  **Rollback Strategy**: デプロイ失敗時の自動ロールバック戦略を定義してください。

### Rule 8.4: The Tagging Strategy (タギング義務)
-   **Law**: 全AWSリソースに**標準化されたタグ**を付与し、コスト配分、運用管理、セキュリティ制御の基盤としてください。
-   **Action**:
    1.  **Mandatory Tags**: 以下のタグを全リソースに必須としてください。

        | タグキー | 目的 | 例 |
        |:---------|:-----|:---|
        | `Environment` | 環境識別 | `production`, `staging`, `dev` |
        | `Project` | プロジェクト識別 | `example-app`, `admin-portal` |
        | `Owner` | 責任者 | `team-backend`, `user@example.com` |
        | `CostCenter` | コスト配分 | `engineering`, `marketing` |
        | `ManagedBy` | 管理方法 | `terraform`, `cdk`, `manual` |

    2.  **Enforcement**: AWS Config Rule `required-tags` またはSCPでタグ付けを強制し、タグなしリソースの作成を拒否してください。
    3.  **No PII in Tags**: タグにPII（個人情報）を含めることを禁止します。タグは暗号化されず、多くのAWSサービスからアクセス可能です。
    4.  **Automation**: IaCテンプレート内でデフォルトタグを定義し、手動タグ付けへの依存を排除してください。

### Rule 8.5: The IaC Generator & Reverse Engineering Protocol
-   **Law**: 既存AWSリソース（手動作成・レガシー環境）のIaC化には**IaC Generator**と**CDK Migrate**を活用し、コンソール上のリソースをコード管理下に取り込んでください。
-   **Action**:
    1.  **IaC Generator（CloudFormation）**: AWSコンソールから既存リソースをスキャンし、CloudFormationテンプレートを自動生成。手動作成リソースのIaC化第一ステップとして活用。生成されたテンプレートは必ずレビュー・調整後にGit管理。
    2.  **CDK Migrate**: CloudFormation/Terraform既存テンプレートまたは手動作成リソースをCDKコードに変換。L1 Constructsとして生成されるため、段階的にL2/L3へリファクタリング。
    3.  **Terraform Import**: `terraform import` + `terraform plan` で既存リソースをTerraformステートに取り込み後、HCLコードを作成。Import Block構文（Terraform 1.5+）でインポートをコード化。
    4.  **段階的アプローチ**: 全リソースの一括変換は危険。クリティカルでない環境（Dev）から順番に適用し、`plan` の差分がゼロであることを確認してから本番環境に展開。
    5.  **Drift Prevention**: IaC化完了後、コンソール操作による変更を検知するためConfig Rules/Drift Detectionを即座に有効化。
-   **Anti-pattern**: IaC Generatorの出力をそのまま本番テンプレートとして使用すること。自動生成コードは必ずモジュール化・変数化のリファクタリングを実施。

---

## 9. コスト最適化戦略 (Cost Optimization / FinOps)

### Rule 9.1: The FinOps Culture Mandate
-   **Law**: クラウドコストは「インフラチームの問題」ではなく、**全エンジニアリングチームの責任**です。コスト意識を開発文化に組み込んでください。
-   **Action**:
    1.  **Cost Visibility**: AWS Cost Explorerで部門・プロジェクト・環境ごとのコストを可視化し、月次レビューを実施してください。
    2.  **Budget Alerts**: AWS Budgetsで月額予算を設定し、80% / 100% / 120% 到達時にSlack/メール通知を送信してください。
    3.  **Anomaly Detection**: AWS Cost Anomaly Detection を有効化し、異常なコスト増加を自動検知してください。
    4.  **Unit Economics**: 総コストだけでなく「1ユーザーあたりのコスト」「1トランザクションあたりのコスト」等のユニットコストを算出・追跡してください。

### Rule 9.2: The Commitment Strategy (RI / Savings Plans / Spot)
-   **Law**: 安定したベースラインワークロードに対して**コミットメントベースの割引**を適用し、On-Demand価格での不必要な支出を削減してください。
-   **Action**:
    1.  **Savings Plans First**: 柔軟性を重視し、**Compute Savings Plans**を第一候補としてください。インスタンスタイプ、リージョン、OS、テナンシーを問わず適用可能（最大72%割引）。
    2.  **EC2 Instance SP**: 特定インスタンスファミリーの使用が安定している場合、より深い割引が得られるEC2 Instance Savings Plansの追加を検討。
    3.  **Database Savings Plans**: RDS/Aurora/Redshift/ElastiCache/MemoryDB/Neptune等のデータベースサービスには**Database Savings Plans**を適用（最大20%割引、2025年〜）。データベースワークロードの予算管理をCompute SPから分離し、より正確なコスト最適化を実現。
    4.  **Reserved Instances**: Savings Plans非対応サービスにはRIを適用（最大75%割引）。1年コミットメントを推奨（技術変化への追従性を確保）。
    5.  **Spot Instances**: フォールトトレラントなワークロード（バッチ処理、CI/CD、データ分析）にはSpotインスタンスを活用（最大90%割引）。中断に備えた設計を義務化。
    6.  **Waterline Approach**: コミットメントは平均使用量ではなく**最低使用量（Waterline）**に基づいて購入し、過剰コミットを防止してください。
    7.  **Split Cost Allocation Data**: 共有リソース（EKSクラスター、ElastiCacheクラスター等）のコストを実際の使用量に基づいてテナント/チーム別に分割配分し、正確なチャージバックを実現。

### Rule 9.3: The Waste Elimination Protocol (無駄排除)
-   **Law**: 未使用・アイドル状態のAWSリソースを定期的に検出・削除してください。放置された「ゾンビリソース」はサイレントなコストリークです。
-   **Action**:
    1.  **Weekly Sweep**: 以下のゾンビリソースを週次で検出・削除：
        -   未アタッチのEBSボリューム
        -   古いEBSスナップショット（30日以上前のもの。バックアップポリシー外）
        -   未使用のElastic IP
        -   アイドル状態のロードバランサー
        -   古いLambdaバージョン（直近3バージョン以外を削除）
    2.  **Non-Production Scheduling**: Dev/Staging環境は営業時間外に自動停止してください。AWS Instance Scheduler または Lambda + EventBridge で自動化。
    3.  **Trusted Advisor**: AWS Trusted Advisor のコスト最適化チェックを月次でレビューしてください。

### Rule 9.4: The Data Transfer Cost Awareness
-   **Law**: AWSのデータ転送コスト（特にアウトバウンド、クロスAZ、クロスリージョン）を認識し、アーキテクチャ設計段階で最小化してください。
-   **Action**:
    1.  **Same-AZ Preference**: 可能な限りコンピューティングとストレージを同一AZに配置し、クロスAZ転送コストを削減してください。ただし可用性とのトレードオフを考慮。
    2.  **VPC Endpoints**: NAT Gateway経由のデータ転送はGB単位で課金されます。VPCエンドポイントに置き換えてコスト削減。
    3.  **CloudFront**: S3やALBのオリジンに対するアウトバウンド転送はCloudFront経由の方が安価な場合があります。配信パターンを分析してください。

---

## 10. 信頼性・災害復旧 (Reliability & Disaster Recovery)

### Rule 10.1: The Multi-AZ / Multi-Region Strategy
-   **Law**: 本番ワークロードの可用性要件を明確に定義し、それに応じたデプロイ戦略を採用してください。
-   **Action**:
    | 可用性目標 | 戦略 | 年間許容ダウンタイム |
    |:-----------|:-----|:---------------------|
    | 99.9% | Multi-AZ | 8時間45分 |
    | 99.99% | Multi-AZ + 自動フェイルオーバー | 52分 |
    | 99.999% | Multi-Region Active-Active | 5分 |

### Rule 10.2: The Backup Strategy (AWS Backup)
-   **Law**: 全データストア（RDS、DynamoDB、EBS、EFS、S3）に対して**自動バックアップ**を設定し、定期的な復旧テストを実施してください。
-   **Action**:
    1.  **AWS Backup**: AWS Backupで一元管理し、バックアップポリシー（頻度、保持期間）を明示的に定義してください。
    2.  **Cross-Region Copy**: DR要件に応じてバックアップを別リージョンにコピーしてください。
    3.  **Recovery Testing**: 四半期ごとにバックアップからの復旧テストを実施し、RTO（目標復旧時間）とRPO（目標復旧時点）が要件を満たすことを検証してください。
    4.  **Vault Lock**: バックアップデータの改竄防止のため、AWS Backup Vault Lockを適用してください。

### Rule 10.3: The Chaos Engineering Protocol
-   **Law**: 本番環境の信頼性を**受動的に信じる**のではなく、**能動的に検証**してください。
-   **Action**:
    1.  **AWS Fault Injection Service (FIS)**: AZ障害、インスタンス停止、ネットワーク遅延等の障害注入テストを定期的に実施してください。
    2.  **Game Day**: 四半期ごとにGame Day（障害シミュレーション訓練）を実施し、インシデント対応手順の有効性を検証してください。
    3.  **Runbook**: 主要障害シナリオ（DBフェイルオーバー、リージョン障害、DDoS攻撃等）に対するランブックを整備してください。

---

## 11. パフォーマンス最適化 (Performance Optimization)

### Rule 11.1: The Caching Strategy
-   **Law**: 高頻度の読み取りリクエストには適切なキャッシュ層を導入し、オリジンへの負荷を軽減してください。
-   **Action**:
    1.  **CloudFront**: 静的コンテンツ・API応答のエッジキャッシュ。Originとして S3（OAC経由）、ALB、API Gateway に対応。
    2.  **ElastiCache**: アプリケーション層のセッション管理、DBクエリ結果キャッシュ。
    3.  **DAX**: DynamoDBへの読み取り高速化（マイクロ秒レイテンシ）。
    4.  **API Gateway Caching**: REST API の応答キャッシュ（ステージレベルで設定）。
-   **Cache Invalidation**: キャッシュの無効化戦略を必ず設計してください。「キャッシュの無効化」はコンピュータサイエンスで最も難しい問題の一つです。TTLとイベント駆動の無効化を組み合わせてください。

### Rule 11.2: The CDN Optimization (CloudFront)
-   **Law**: グローバルにサービスを提供する場合、**CloudFront**をフロントに配置し、エッジからのコンテンツ配信を最大化してください。
-   **Action**:
    1.  **Origin Access Control (OAC)**: S3オリジンへのアクセスはOACを使用し、バケットへの直接アクセスを遮断してください（旧OAIは非推奨）。
    2.  **Cache Policy**: キャッシュキーを最小化し（不要なヘッダー・クエリパラメータを除外）、キャッシュヒット率を最大化してください。
    3.  **Compression**: Gzip / Brotli 圧縮を有効化してください。
    4.  **Lambda@Edge / CloudFront Functions**: ヘッダー操作、リダイレクト、A/Bテスト等の軽量ロジックをエッジで実行してください。

---

## 12. データ保護・暗号化 (Data Protection & Encryption)

### Rule 12.1: The Encryption Standard
-   **Law**: 全データを**保存時（At Rest）**および**転送時（In Transit）**に暗号化してください。
-   **Action**:
    1.  **At Rest (保存時)**:
        -   EBS: デフォルト暗号化をアカウントレベルで有効化。
        -   S3: SSE-S3（標準）またはSSE-KMS（監査要件あり）。
        -   RDS/Aurora: 暗号化有効（作成時にのみ設定可能。既存DBの暗号化にはスナップショット→暗号化復元が必要）。
        -   DynamoDB: デフォルトで暗号化済み（AWS Owned Key）。CMKへの切り替え推奨。
    2.  **In Transit (転送時)**:
        -   全エンドポイントでTLS 1.2以上を強制。TLS 1.0/1.1を明示的に拒否してください。
        -   VPC内のサービス間通信にもTLSを適用してください。

### Rule 12.2: The KMS Key Management
-   **Law**: **AWS KMS**の鍵管理を適切に行い、暗号鍵の安全性を保証してください。
-   **Action**:
    1.  **CMK over AWS Managed**: 重要データにはCustomer Managed Key（CMK）を使用し、キーポリシーで使用者を制限してください。
    2.  **Key Rotation**: CMKの自動ローテーション（年次）を有効化してください。
    3.  **Key Policy**: 最小権限の原則に基づき、キーの使用を必要最小限のIAMロールに制限してください。
    4.  **Cross-Account**: クロスアカウントでキーを共有する場合、キーポリシーとIAMポリシーの両方で明示的に許可してください。

### Rule 12.3: The Secrets Management Protocol
-   **Law**: アプリケーションの秘密情報（APIキー、DBパスワード、トークン等）を**ソースコードや環境変数にハードコード**することを厳禁とします。
-   **Action**:
    1.  **Secrets Manager**: DB認証情報、APIキー等は**AWS Secrets Manager**で管理し、自動ローテーションを有効化してください。
    2.  **SSM Parameter Store**: 暗号化不要な設定値にはSSM Parameter Store（SecureString型）を使用してください。
    3.  **Runtime Injection**: Lambda環境変数にはSecretsManagerの参照ARNを設定し、実行時に解決してください。ビルド時にシークレットをバンドルしないでください。
    4.  **Git Guardian**: `.env`ファイルやシークレットのGitリポジトリへのコミットを防止するため、`git-secrets` やpre-commitフックを導入してください。

---

## 13. コンテナ・サーバーレス詳細 (Container & Serverless Deep Dive)

### Rule 13.1: The ECS Task Design
-   **Law**: ECSタスク定義はセキュリティとリソース効率を最大化する設計を徹底してください。
-   **Action**:
    1.  **Read-Only Root Filesystem**: コンテナのルートファイルシステムを読み取り専用に設定し、マルウェアの書き込みを防止。書き込みが必要な場合は`tmpfs`マウントを使用。
    2.  **Non-Root User**: コンテナはrootユーザーで実行しない。Dockerfileで`USER`ディレクティブを指定。
    3.  **Resource Limits**: タスク定義でCPU/メモリの`reservation`と`limit`を明示的に設定し、リソースの暴走を防止。
    4.  **Health Check**: コンテナヘルスチェックを定義し、不健全なコンテナの自動置換を有効化。
    5.  **Log Driver**: `awslogs`ドライバーでCloudWatch Logsに出力。`json-file`（デフォルト）は本番環境で使用しない。
-   **Cross-Ref**: ECSサービス間通信は**ECS Service Connect（§105）**を推奨。

### Rule 13.2: The EKS Security Hardening
-   **Law**: EKSクラスターのセキュリティを多層的に強化してください。
-   **Action**:
    1.  **Private Endpoint**: EKS APIサーバーのパブリックエンドポイントを無効化し、プライベートアクセスのみに制限。
    2.  **Pod Security**: Pod Security Standards (PSS) を適用し、特権コンテナの実行を禁止。
    3.  **EKS Pod Identity（推奨）/ IRSA（レガシー）**: Pod単位でIAMロールを割り当て、ノードレベルの広範な権限を排除。新規クラスターではEKS Pod Identityを標準採用（詳細は**§70.1**参照）。
    4.  **Network Policy**: VPC CNI v1.14+でネイティブNetwork Policyを使用してPod間の通信を制御。
    5.  **EKS Auto Mode / Karpenter（§3.3参照）**: EKS Auto Mode（推奨）またはKarpenterでノードの自動スケーリングを実装し、リソース効率を最大化。
    6.  **EKS Hybrid Nodes** (2024 GA): オンプレミスまたはEdge環境のサーバーをEKSクラスターのノードとして登録。AWSリージョンのコントロールプレーンで統一管理しつつ、低レイテンシ要件やデータローカリティ要件のワークロードをオンプレミスで実行。SSM Hybrid Activationsで参加。
-   **Cross-Ref**: EKS高度運用の詳細は**§70.1**参照。

### Rule 13.3: The Lambda Advanced Patterns
-   **Law**: Lambda関数の信頼性と運用効率を高める高度な設計パターンを適用してください。
-   **Action**:
    1.  **Dead Letter Queue (DLQ)**: 非同期呼び出しには必ずDLQ（SQSまたはSNS）を設定し、失敗した呼び出しのペイロードを保存してください。
    2.  **Idempotency**: SQS/EventBridgeトリガーの関数は、同一イベントの複数配信（At-Least-Once）を前提に、べき等な処理を実装してください。Powertools for AWS Lambda のIdempotencyモジュール推奨。
    3.  **Structured Logging**: Powertools for AWS Lambda のLoggerモジュールを使用し、構造化ログ（JSON）を標準化。correlation_id によるトレース連携を実装。
    4.  **Reserved Concurrency**: 重要な関数にReserved Concurrencyを設定し、他の関数のスケールアウトによるスロットリングを防止。
    5.  **Layers for Shared Code**: 共通ライブラリやユーティリティはLambda Layersで共有し、デプロイパッケージサイズを削減。

---

## 14. ガバナンス・コンプライアンス (Governance & Compliance)

### Rule 14.1: The Compliance Framework
-   **Law**: ワークロードが準拠すべきコンプライアンスフレームワーク（SOC 2、PCI-DSS、HIPAA、GDPR、APPI等）を明確にし、技術的統制を実装してください。
-   **Action**:
    1.  **AWS Artifact**: 必要なAWSコンプライアンスレポート（SOC、ISO等）をAWS Artifactから取得してください。
    2.  **Security Hub Standards**: 対応するコンプライアンススタンダード（CIS、PCI-DSS等）をSecurity Hubで有効化。
    3.  **Config Conformance Packs**: 業界標準のConfig Conformance Packで自動的にコンプライアンスチェックを実施。
    4.  **Evidence Collection**: 監査対応のため、CloudTrailログ、Configスナップショット、Security Hub検出結果を自動的に収集・保存する仕組みを構築してください。

### Rule 14.2: The Service Control Policy (SCP) & Resource Control Policies (RCPs) Governance
-   **Law**: AWS Organizations の**SCP**（プリンシパルベース）と**RCP**（リソースベース）を併用して、組織全体の多層的セキュリティガードレールを強制してください。
-   **Action**:
    1.  **Region Restriction**: SCPで使用を許可するリージョンを明示的に限定し、未承認リージョンでのリソース作成を拒否。
    2.  **Root User Restriction**: SCPでルートユーザーによるAPI操作（キー作成、パスワード変更等）を拒否。
    3.  **Critical Service Protection**: SCPでCloudTrail、GuardDuty、Config等のセキュリティサービスの無効化を拒否。
    4.  **VPC Flow Log Enforcement**: VPCの作成時にFlow Logsの有効化を強制。
    5.  **Resource Control Policies (RCPs)**: リソースレベルの予防的ガードレールとして**RCP**を適用し、データ境界（Data Perimeter）を構築（re:Invent 2025〜）。
        -   **SCP vs RCP**: SCPは「誰が何をできるか」（プリンシパル制御）、RCPは「リソースへの誰のアクセスを許可するか」（リソース制御）。両方を組み合わせて完全な境界を形成。
        -   **S3 Data Perimeter**: RCPでS3バケットへの外部アクセスをOrganization内に限定。リソースポリシーの設定ミスによる意図しない外部公開を組織レベルで防止。
        -   **適用範囲**: OU単位・アカウント単位で適用可能。段階的にロールアウトし、`DryRun`モードで影響を事前評価。

### Rule 14.3: The Resource Lifecycle Protocol
-   **Law**: AWSリソースのライフサイクル（作成→運用→廃止）を管理し、「孤立リソース」の放置を防止してください。
-   **Action**:
    1.  **Creation Approval**: 本番環境のリソース作成はIaCのプルリクエスト経由でレビュー・承認を義務化。
    2.  **Expiration Tag**: 一時的なリソース（テスト用インスタンス等）には`ExpiresAt`タグを付与し、自動削除を設定。
    3.  **Decommission Checklist**: リソース廃止時は関連リソース（セキュリティグループ、IAMロール、DNS、ターゲットグループ等）の同時クリーンナップを実施。

---

## 15. サステナビリティ (Sustainability)

### Rule 15.1: The Carbon-Aware Architecture
-   **Law**: AWS Well-Architected Framework のサステナビリティピラーに基づき、環境負荷を最小化するアーキテクチャ設計を推奨します。サステナビリティは「測定可能かつ管理可能な非機能要件」として扱ってください。
-   **Action**:
    1.  **Graviton Adoption**: Gravitonプロセッサ（ARMベース）は同等のx86インスタンスと比較して最大60%のエネルギー効率改善を提供します。互換性がある場合は積極的に採用。最新世代（Graviton5、3nmプロセス）はさらなるエネルギー効率改善を実現。
    2.  **AWS Green Insights**: AWSコンソールの**AWS Green Insights**ツールを活用し、以下のサステナビリティ管理を実施：
        -   クラウドインフラのカーボンフットプリントをリソース別・サービス別に追跡・可視化。
        -   エネルギー効率最適化の具体的提案（Graviton移行、非ピーク時スケールダウン等）を受け取り実行。
        -   月次でCO2排出削減量をダッシュボードに記録し、定量的な改善を推進。
    3.  **Region Selection**: リージョン選択時に、AWSが公開する各リージョンの再生可能エネルギー比率を考慮してください。AWSは100%再生可能エネルギーを2025年に達成済み。低炭素リージョンへのワークロード配置を優先。
    4.  **Right-Sizing**: 過剰なリソースプロビジョニングは電力浪費です。Compute Optimizerの推奨に基づく継続的なライトサイジングを実施。
    5.  **Serverless**: サーバーレスアーキテクチャ（Lambda、Fargate、Aurora Serverless）は、使用していない時間のリソース消費がゼロに近づくため、サステナビリティの観点からも推奨。
    6.  **Data Lifecycle**: 不要なデータの保持はストレージサーバーの稼働を要します。ライフサイクルポリシーによる適切なデータ削除を実施。
    7.  **Sustainability Metrics**: Customer Carbon Footprint Tool でScope 1/2/3排出量を定期レビュー。サステナビリティKPIをダッシュボードに統合し、四半期ごとの改善レポートを作成。
    8.  **Sustainability KPI Dashboard**: サステナビリティメトリクスをCloudWatchカスタムダッシュボードに統合し、エンジニアリングチームが日常的に環境影響を確認可能にしてください。

---

## 16. 運用保守・チェックリスト (Operations & Maintenance Checklists)

### Rule 16.1: The New AWS Account Checklist
-   **Law**: 新しいAWSアカウントを作成した際は、以下の初期設定を完了させてください。
-   **Checklist**:
    - [ ] ルートユーザーにハードウェアMFAを設定
    - [ ] ルートユーザーのアクセスキーが存在しないことを確認
    - [ ] IAM Identity Center (SSO) によるフェデレーションアクセスを設定
    - [ ] CloudTrailを全リージョンで有効化
    - [ ] AWS Configを全リージョンで有効化
    - [ ] GuardDutyを全リージョンで有効化
    - [ ] Security Hubを有効化（FSBP + CIS標準）
    - [ ] S3 Block Public Accessをアカウントレベルで有効化
    - [ ] EBSデフォルト暗号化を有効化
    - [ ] AWS Budgetsでコストアラートを設定
    - [ ] 必須タグポリシーを適用
    - [ ] VPC Flow Logsを有効化
    - [ ] SCPの適用を確認（Organizations管理下の場合）

### Rule 16.2: The Monthly Operations Review
-   **Law**: 月次でAWS環境の健全性レビューを実施してください。
-   **Checklist**:
    - [ ] **コスト**: Cost Explorerで先月のコスト推移とUnit Economicsを確認
    - [ ] **セキュリティ**: Security Hubのスコアが95%以上であることを確認
    - [ ] **GuardDuty**: 未対応のCritical/High検知結果がゼロであることを確認
    - [ ] **パフォーマンス**: RDS Performance Insights、Lambda Duration P99を確認
    - [ ] **ゾンビリソース**: 未使用EBSボリューム、Elastic IP、古いスナップショットの削除
    - [ ] **バックアップ**: AWS Backupのジョブ成功率が100%であることを確認
    - [ ] **パッチ**: EC2/ECSのOSおよびランタイムのセキュリティパッチが最新であることを確認
    - [ ] **IAM**: 90日以上未使用のIAMユーザー・アクセスキーの棚卸しと削除
    - [ ] **Savings Plans/RI**: 使用率と有効期限を確認し、更新計画を策定
    - [ ] **Compute Optimizer**: ライトサイジングの推奨事項をレビュー

### Rule 16.3: The New Service Deployment Checklist
-   **Law**: 新しいサービス/マイクロサービスを本番環境にデプロイする前に、以下の品質ゲートを通過してください。
-   **Checklist**:
    - [ ] IaCでインフラが定義されている（手動作成なし）
    - [ ] Auto Scalingが設定されている
    - [ ] ヘルスチェック/ヘルスエンドポイントが実装されている
    - [ ] CloudWatch Alarmsが設定されている（エラー率、レイテンシ）
    - [ ] ログがCloudWatch Logsに出力されている（構造化JSON）
    - [ ] 分散トレーシング（X-Ray/OpenTelemetry）が有効化されている
    - [ ] セキュリティグループが最小権限で設定されている
    - [ ] 認証情報がSecrets Manager/SSM経由で注入されている
    - [ ] バックアップポリシーが設定されている（データストアの場合）
    - [ ] タグが必須タグポリシーに準拠している
    - [ ] 負荷テストが実施されている
    - [ ] DR手順（ランブック）が整備されている

---

## 17. メッセージング・イベント駆動アーキテクチャ (Messaging & Event-Driven Architecture)

### Rule 17.1: The SQS Best Practices
-   **Law**: サービス間の非同期通信には**Amazon SQS**を使用し、疎結合アーキテクチャを実現してください。
-   **Action**:
    1.  **Standard vs FIFO**: メッセージの厳密な順序保証が不要な場合はStandardキュー、順序保証・Exactly-Once処理が必要な場合はFIFOキューを選択してください。
    2.  **Dead Letter Queue (DLQ) Mandatory**: 全SQSキューにDLQを設定してください。`maxReceiveCount`（通常3〜5回）を設定し、処理に繰り返し失敗したメッセージをDLQに退避。
    3.  **DLQ Monitoring**: DLQの`ApproximateNumberOfMessagesVisible`メトリクスにCloudWatchアラームを設定し、メッセージが蓄積された場合即座に検知してください。
    4.  **DLQ Redrive**: DLQに退避されたメッセージの再処理（Redrive）手順を整備し、根本原因解決後に元のキューへ再送信してください。
    5.  **Visibility Timeout**: メッセージ処理に必要な時間の約6倍をVisibility Timeoutに設定し、タイムアウトによる重複処理を防止してください。
    6.  **Long Polling**: `WaitTimeSeconds`を最大20秒に設定し、空のレスポンスによるAPI呼び出しコストを削減してください（Short Pollingは禁止）。
    7.  **FIFO MessageGroupId**: FIFOキューでは`MessageGroupId`を適切に設定し、同一グループ内の順序を保証しつつ、異なるグループ間の並列処理を実現してください。
    8.  **Content-Based Deduplication**: FIFO使用時はコンテンツベース重複排除を有効化するか、明示的な`MessageDeduplicationId`を送信してください。
    9.  **Encryption**: SQS SSE（KMS CMK）を有効化し、メッセージの保存時暗号化を保証してください。
-   **Reference — SQS + DLQ Terraform設定例**:
    ```hcl
    # DLQ（デッドレターキュー）
    resource "aws_sqs_queue" "orders_dlq" {
      name                      = "orders-dlq"
      message_retention_seconds = 1209600  # 14日間保持
      kms_master_key_id         = aws_kms_key.sqs.arn
    }

    # メインキュー
    resource "aws_sqs_queue" "orders" {
      name                       = "orders-queue"
      visibility_timeout_seconds = 180   # 処理時間の約6倍
      receive_wait_time_seconds  = 20    # Long Polling必須
      kms_master_key_id          = aws_kms_key.sqs.arn

      redrive_policy = jsonencode({
        deadLetterTargetArn = aws_sqs_queue.orders_dlq.arn
        maxReceiveCount     = 3  # 3回失敗でDLQ退避
      })
    }

    # DLQ監視アラーム
    resource "aws_cloudwatch_metric_alarm" "dlq_alarm" {
      alarm_name          = "orders-dlq-messages"
      namespace           = "AWS/SQS"
      metric_name         = "ApproximateNumberOfMessagesVisible"
      dimensions          = { QueueName = aws_sqs_queue.orders_dlq.name }
      statistic           = "Sum"
      period              = 300
      evaluation_periods  = 1
      threshold           = 1     # 1件でも即座検知
      comparison_operator = "GreaterThanOrEqualToThreshold"
      alarm_actions       = [aws_sns_topic.alerts.arn]
    }
    ```

### Rule 17.2: The SNS Fan-Out Protocol
-   **Law**: 1つのイベントを複数の消費者に配信する**Fan-Out**パターンには**Amazon SNS**を使用してください。
-   **Action**:
    1.  **SNS + SQS Fan-Out**: SNSトピックに複数のSQSキューをサブスクリプションとして登録し、各消費者が独立してメッセージを処理するパターンを標準としてください。
    2.  **Message Filtering**: サブスクリプションフィルターポリシーを活用し、各消費者が必要なメッセージのみを受信するようにしてください（不要なメッセージの処理排除）。
    3.  **FIFO Topic**: SQS FIFOキューへの配信が必要な場合は、SNS FIFOトピックを使用してください（StandardトピックからFIFOキューへの直接配信は不可）。
    4.  **DLQ for Subscriptions**: SNSサブスクリプションにもDLQを設定し、配信失敗メッセージの追跡を可能にしてください。
    5.  **Encryption**: SNS SSE（KMS CMK）を有効化してください。

### Rule 17.3: The EventBridge Strategy
-   **Law**: AWSサービス間のイベント連携、SaaS統合、カスタムイベントバスには**Amazon EventBridge**を第一候補としてください。
-   **Action**:
    1.  **Event Schema Definition**: イベントのスキーマを明確に定義し、Schema Registryに登録してください。自己記述的なイベント設計を推奨。
    2.  **Event Pattern Matching**: ルールのイベントパターンを可能な限り詳細に定義し、不必要なターゲット呼び出しを最小化してください。
    3.  **Archive & Replay**: 重要なイベントはアーカイブを有効化し、障害時のイベントリプレイによる復旧を可能にしてください。
    4.  **DLQ per Target**: 各ターゲットにDLQ（SQS Standardキュー）を設定し、配信失敗イベントを捕捉してください。
    5.  **Cross-Account Event Bus**: マイクロサービス間のイベント連携にはクロスアカウントイベントバスを活用し、サービス間の直接結合を排除してください。
    6.  **Scheduler**: 定期実行タスクにはEventBridge Schedulerを使用し、cron式またはrate式でスケジューリングしてください。Lambda cronジョブの代替として推奨。

### Rule 17.4: The Idempotency Mandate (べき等性義務)
-   **Law**: 全てのメッセージ消費者（Lambda、ECS等）は**べき等（Idempotent）**に設計してください。At-Least-Once配信が保証される分散システムでは、同一メッセージの複数回処理を前提とした設計が必須です。
-   **Action**:
    1.  **Idempotency Key**: 処理済みメッセージのIDをDynamoDBやRedisに記録し、重複処理を防止してください。
    2.  **Powertools**: AWS Lambda Powertools の Idempotency モジュールの採用を推奨。
    3.  **Conditional Writes**: DB更新には条件付き書き込み（DynamoDB ConditionExpression、RDB Optimistic Locking）を使用してください。

    ```python
    # Lambda Powertools Idempotency 実装例
    from aws_lambda_powertools.utilities.idempotency import (
        DynamoDBPersistenceLayer, idempotent
    )

    persistence = DynamoDBPersistenceLayer(table_name="IdempotencyTable")

    @idempotent(persistence_store=persistence)
    def handler(event, context):
        # この関数は同一イベントに対して1度だけ実行される
        payment_id = event["detail"]["payment_id"]
        return process_payment(payment_id)
    ```

---

## 18. API Gateway戦略 (API Gateway Strategy)

### Rule 18.1: The API Type Selection
-   **Law**: API Gatewayの適切なタイプを選択し、要件に合わないオーバースペック/アンダースペックを避けてください。
-   **Action**:

    | 要件 | 推奨タイプ | 備考 |
    |:-----|:-----------|:-----|
    | フルREST機能（APIキー、Usage Plans、WAF統合、リクエスト検証） | REST API | 高機能、やや高コスト |
    | 低コスト・低レイテンシ、OAuth/OIDC組み込み | HTTP API | REST APIの約70%安価 |
    | 双方向リアルタイム通信（チャット、通知） | WebSocket API | 接続管理にDynamoDB活用 |

### Rule 18.2: The API Security Protocol
-   **Law**: API Gatewayのエンドポイントには多層的なセキュリティ対策を適用してください。
-   **Action**:
    1.  **Authorization**: 以下から要件に合った認証方式を選択：
        -   **IAM Authorization**: AWSサービス間の通信に最適。
        -   **Cognito User Pools**: ユーザー向けモバイル/Webアプリに最適。
        -   **Lambda Authorizer**: カスタム認証ロジック（独自トークン検証、RBAC等）が必要な場合。
        -   **JWT Authorizer** (HTTP APIのみ): OAuth 2.0 / OIDC トークンの検証。
    2.  **Resource Policy**: APIへのアクセスを特定のIPレンジ、VPC、AWSアカウントに制限してください。
    3.  **Private API**: 内部システム向けAPIはPrivate APIとして構成し、VPCエンドポイント経由でのみアクセス可能にしてください。
    4.  **mTLS**: 高セキュリティ要件のAPIには相互TLS認証を実装してください。
    5.  **Request Validation**: API Gatewayのリクエスト検証（モデルスキーマ）を活用し、不正なリクエストをバックエンドに到達させない「Fail Fast」を実現してください。
    6.  **TLS Policy**: 最新のTLSセキュリティポリシー（TLS 1.3推奨）を適用し、古い暗号スイートを排除してください。

### Rule 18.3: The API Throttling & Rate Limiting
-   **Law**: APIエンドポイントに適切なスロットリングを設定し、バックエンドサービスの過負荷を防止してください。
-   **Action**:
    1.  **Account-Level**: アカウント全体のデフォルトスロットル制限を理解し、必要に応じて引き上げリクエストを行ってください。
    2.  **Stage/Method-Level**: ステージレベルおよびメソッドレベルでスロットリングを設定し、重要なAPIパスの保護を強化してください。
    3.  **Usage Plans**: API利用者（テナント/顧客）ごとにUsage Plansを作成し、APIキーでレート制限とクォータを管理してください。
    4.  **429 Handling**: クライアント側でHTTP 429（Too Many Requests）レスポンスのリトライロジック（指数バックオフ + ジッター）を実装してください。

### Rule 18.4: The API Versioning Protocol
-   **Law**: APIのバージョニング戦略を定義し、破壊的変更からクライアントを保護してください。
-   **Action**:
    1.  **URI Versioning**: URIパスにバージョンを含める方式（`/v1/users`）を標準としてください。
    2.  **Deprecation Policy**: 旧バージョンの廃止は最低6ヶ月の移行期間を設け、クライアントに事前通知してください。
    3.  **Stage Variables**: 環境変数やLambdaエイリアスと組み合わせて、バージョン切り替えを柔軟に管理してください。

---

## 19. ワークフローオーケストレーション (Workflow Orchestration)

### Rule 19.1: The Step Functions Strategy
-   **Law**: マイクロサービス間のオーケストレーション、複雑なビジネスプロセスの実装には**AWS Step Functions**を使用し、Lambda関数内のオーケストレーションロジック（連鎖呼び出し）を排除してください。
-   **Action**:
    1.  **Standard vs Express**:

        | 特性 | Standard | Express |
        |:-----|:---------|:--------|
        | 最大実行時間 | 1年 | 5分 |
        | 実行モデル | Exactly-Once | At-Least-Once |
        | 課金 | 状態遷移数 | リクエスト数＋時間＋メモリ |
        | 用途 | 長期実行プロセス、監査必須 | 高ボリューム/低レイテンシ |
        | 実行履歴 | コンソールで参照可能 | CloudWatch Logsに出力 |

    2.  **Error Handling**: Retry（指数バックオフ＋ジッター）とCatchブロックを積極的に活用し、一時的障害からの自動回復を実装してください。
    3.  **Saga Pattern**: 分散トランザクションにはSagaパターンを採用し、各ステップに補償トランザクション（ロールバック処理）を実装してください。全ステップをべき等に設計。
    4.  **Payload Limit**: ステート間のペイロード上限は256KB。大きなデータはS3に保存し、S3 URIを受け渡してください（Claim Checkパターン）。
    5.  **Direct Integration**: Lambda関数を介さずにAWSサービス（DynamoDB、SQS、SNS等）を直接呼び出すSD統合を活用し、コストとレイテンシを削減してください。
    6.  **Nested Workflows**: Express WorkflowをStandard Workflow内にネストし、長期実行と高頻度処理の両方を効率的に実現してください。

---

## 20. DNS・ドメイン管理 (DNS & Domain Management)

### Rule 20.1: The Route 53 Best Practices
-   **Law**: DNS管理には**Amazon Route 53**を使用し、高可用性・低レイテンシのDNS解決を実現してください。
-   **Action**:
    1.  **Alias Records**: AWSリソース（ALB、CloudFront、S3、API Gateway等）へのルーティングには**Aliasレコード**を使用してください。CNAMEと異なりZone Apex（`example.com`）で使用でき、クエリ料金が無料。
    2.  **Health Checks**: 全本番エンドポイントにRoute 53ヘルスチェックを設定し、DNS応答から不健全なエンドポイントを自動除外してください。
    3.  **Failover Routing**: Active-Passive DR構成にはフェイルオーバールーティングポリシーを使用してください。プライマリとセカンダリの両方にヘルスチェックを設定。
    4.  **Latency-Based Routing**: マルチリージョンデプロイでは、レイテンシベースルーティングを使用してユーザーに最も近いリージョンへ自動ルーティングしてください。
    5.  **Weighted Routing**: カナリアデプロイやA/Bテストにはウェイテッドルーティングを活用してください。
    6.  **DNSSEC**: DNSスプーフィング防止のため、ホストゾーンにDNSSEC署名を有効化してください。KMSキーは`us-east-1`に作成。
    7.  **Private Hosted Zone**: VPC内のプライベートDNSにはPrivate Hosted Zoneを使用し、内部サービスディスカバリを実現してください。

---

## 21. インシデントレスポンス (Incident Response)

### Rule 21.1: The Incident Response Framework
-   **Law**: セキュリティインシデント及び運用障害に対する**体系的な対応フレームワーク**を整備してください。
-   **Action**:
    1.  **Preparation (準備)**:
        -   インシデント対応チーム（IRT）の役割と連絡先を明確化。
        -   主要障害シナリオ（データ漏洩、DB障害、リージョン障害、DDoS）に対するランブックを整備。
        -   AWS Systems Manager Incident Manager を設定し、インシデントの自動エスカレーションと対応を構築。
    2.  **Detection (検知)**:
        -   GuardDuty、Security Hub、CloudWatch Alarms、EventBridgeによる自動検知体制を構築。
        -   重大度別の通知ルートを定義（Critical→PagerDuty即時通知、High→Slack通知、Medium→翌営業日対応）。
    3.  **Containment (封じ込め)**:
        -   侵害されたEC2インスタンスの即座のセキュリティグループ隔離手順を自動化。
        -   侵害されたIAMクレデンシャルの即座の無効化手順を整備。
        -   Lambda関数でのリアルタイム自動対応（セキュリティグループ変更、キー無効化等）を構築。
    4.  **Recovery (復旧)**:
        -   バックアップからの復旧手順のテスト済みランブック。
        -   フェイルオーバー手順の定期的な訓練（Game Day）。
    5.  **Post-Incident (事後対応)**:
        -   全インシデントへのポストモーテム（振り返り）実施を義務化。根本原因分析（RCA）と再発防止策を文書化。
        -   教訓をランブック・セキュリティルールに反映し、継続的改善を実施。

### Rule 21.2: The Forensic Readiness
-   **Law**: セキュリティインシデント発生時のフォレンジック調査に備え、証拠保全体制を整備してください。
-   **Action**:
    1.  **CloudTrail Integrity**: ログファイルの整合性検証を有効化し、改竄の検出を可能にしてください。
    2.  **VPC Flow Logs**: 全VPCで Flow Logs を有効化し、ネットワーク通信の履歴を保持してください。
    3.  **EBS Snapshot**: 侵害されたインスタンスのEBSボリュームスナップショットを即座に取得し、フォレンジック分析用に保全してください。
    4.  **Isolated Forensic Account**: フォレンジック分析は専用のAWSアカウント（隔離環境）で実施し、本番環境への影響を防止してください。
    5.  **Detective**: Amazon Detective を有効化し、セキュリティ検知結果の自動分析と根本原因の可視化を支援してください。

---

## 22. アプリケーション認証・ID管理 (Application Authentication & Identity)

### Rule 22.1: The Cognito Best Practices
-   **Law**: エンドユーザー向けの認証・認可には**Amazon Cognito**を使用し、自前の認証基盤構築を原則禁止します。
-   **Action**:
    1.  **User Pool Security**:
        -   AWS WAF Web ACLを適用し、ボットやブルートフォース攻撃から保護。
        -   パスワードポリシーを厳格に設定（最低12文字、複雑性要件）。
        -   パスワードレス認証（WebAuthn/パスキー）の採用を推奨。
    2.  **MFA Enforcement**: 全ユーザーにMFA（TOTP、SMS）を強制。アダプティブ認証（リスクベース）を有効化し、異常なサインインを自動検知・ブロック。
    3.  **Token Management**:
        -   ID/アクセストークンをローカルストレージに保存禁止。
        -   リフレッシュトークンはサインアウト時に必ず失効させる。
        -   トークンスコープは必要最小限に設定（`aws.cognito.signin.user.admin` デフォルトスコープの使用を回避）。
    4.  **Identity Pool**: IAMロールは最小権限。ゲスト（未認証）アクセスは原則無効化。有効化する場合はスコープダウンポリシーを適用。
    5.  **Federation**: SAML 2.0/OIDC経由の外部IdP連携時、PKCE（Proof Key for Code Exchange）によるトークンインターセプション防止を義務化。

---

## 23. ロードバランサー戦略 (Load Balancer Strategy)

### Rule 23.1: The ELB Type Selection
-   **Law**: ワークロードに適切なロードバランサータイプを選択してください。
-   **Action**:

    | 要件 | 推奨タイプ | 備考 |
    |:-----|:-----------|:-----|
    | HTTP/HTTPSトラフィック、パスベースルーティング | ALB | L7、WAF統合可 |
    | 超低レイテンシ、TCP/UDP、固定IP | NLB | L4、TLSパススルー可 |
    | レガシーEC2-Classic | CLB | 非推奨、移行推奨 |

### Rule 23.2: The Load Balancer Best Practices
-   **Law**: ロードバランサーの設定を最適化し、高可用性とゼロダウンタイムデプロイを実現してください。
-   **Action**:
    1.  **Health Check Design**: `/health` 等の専用エンドポイントを実装し、依存サービスの健全性も含む「Deep Health Check」を設計。タイムアウト2-5秒、間隔5-10秒を推奨。
    2.  **Deregistration Delay**: アプリケーションの最長レスポンス時間に基づいてDeregistration Delay（Connection Draining）を適切に設定。デフォルト300秒を見直し、処理中のリクエスト完了を保証。
    3.  **Cross-Zone Load Balancing**: ALBはデフォルト有効。NLBはクロスAZデータ転送コストを考慮しつつ、AZ間の均等分散のため有効化を推奨。
    4.  **TLS Termination**: TLS終端はロードバランサーで実施し、ACM（AWS Certificate Manager）で証明書を一元管理。HTTP→HTTPSリダイレクトを必須化。
    5.  **Sticky Sessions回避**: セッションアフィニティは負荷の偏りを招くため原則禁止。ElastiCache/DynamoDB等の外部セッションストアでステートレス設計を推奨。
    6.  **Access Log**: ALBアクセスログをS3に出力し、トラフィック分析と障害調査を可能に。

---

## 24. デプロイ戦略 (Deployment Strategy)

### Rule 24.1: The Deployment Pattern Selection
-   **Law**: リスクを最小化するため、適切なデプロイパターンを選択してください。手動の全量デプロイを本番環境で禁止します。
-   **Action**:

    | パターン | リスク | ロールバック | 適用場面 |
    |:---------|:-------|:-------------|:---------|
    | **Blue/Green** | 低 | 即時（トラフィック切替） | DB変更なし or 後方互換あり |
    | **Canary** | 低 | 即時（重み付け解除） | 漸進的な検証が必要 |
    | **Rolling** | 中 | やや時間がかかる | 大規模サーバー群の更新 |
    | **All-at-once** | 高 | 不可（再デプロイ要） | 開発環境のみ |

### Rule 24.2: The Safe Deployment Practices
-   **Law**: 本番デプロイは自動化され、ロールバック可能な設計を必須とします。
-   **Action**:
    1.  **Lambda Alias + Weighted Routing**: Lambda関数のデプロイにはエイリアス（`prod`）を使用し、重み付きルーティングでCanaryリリースを実施。`$LATEST`を本番で直接参照することを禁止。
    2.  **CodeDeploy Integration**: ECS/EC2/Lambdaのデプロイには**AWS CodeDeploy**を使用し、Linear/Canary/AllAtOnceの交通シフト戦略を定義。
    3.  **Automatic Rollback**: デプロイ中のCloudWatchアラーム（エラー率、レイテンシP99）違反で自動ロールバックを発動する設定を必須化。
    4.  **Immutable Infrastructure**: EC2ベースのデプロイでは、既存インスタンスの更新ではなく新しいAMIからのインスタンス起動（Immutable Infrastructure）を推奨。
    5.  **Feature Flags**: デプロイとリリースを分離するため、フィーチャーフラグの活用を推奨。

---

## 25. データ分析・パイプライン (Data Analytics & Pipeline)

### Rule 25.1: The Data Lake Foundation
-   **Law**: データレイクの基盤には**Amazon S3**を使用し、多層ストレージアーキテクチャ（Raw/Stage/Curated）を構築してください。
-   **Action**:
    1.  **Open Table Format**: Apache Iceberg を採用し、ACID保証、タイムトラベル、スキーマ進化を実現。
    2.  **AWS Glue Data Catalog**: メタデータリポジトリとして一元管理。Glue Crawlerでスキーマ自動検出。
    3.  **Lake Formation Governance**: データメッシュの実現に向け、AWS Lake Formationで列/行レベルのきめ細かなアクセス制御を実装。

### Rule 25.2: The Streaming & Batch Pipeline
-   **Law**: リアルタイム処理にはKinesis、バッチETLにはAWS Glueを使用し、データパイプラインを構築してください。
-   **Action**:
    1.  **Kinesis Data Streams**: リアルタイムデータ取り込みに使用。On-Demandモードで自動スケーリング。レコードのバッチ処理で効率化。
    2.  **Kinesis Data Firehose**: S3/Redshift/OpenSearchへの自動配信。変換Lambda統合で取り込み時のETLを実現。
    3.  **AWS Glue Jobs**: バッチETLに使用。Parquet/ORC形式、動的ワーカー割り当て、データ品質チェック統合を推奨。
    4.  **Amazon Athena**: S3上のサーバーレスSQLクエリ。ワークグループでクエリコストを制御。パーティション射影でスキャンを最小化。
    5.  **Redshift Serverless**: データウェアハウスの要件がある場合に使用。アイドル時ゼロスケーリングでコスト最適化。

---

## 26. Control Tower・Landing Zone (Control Tower & Landing Zone)

### Rule 26.1: The Control Tower Mandate
-   **Law**: マルチアカウント環境のガバナンスには**AWS Control Tower**を使用し、標準化されたLanding Zoneを構築してください。
-   **Action**:
    1.  **Guardrails Strategy**: 3種類のガードレールを組み合わせた多層防御を実装。
        -   **Preventive（予防）**: SCP/RCPベース。非準拠リソースの作成を事前阻止。
        -   **Detective（検知）**: AWS Configルールベース。非準拠リソースの事後検出。
        -   **Proactive（予防的）**: CloudFormation Hooksベース。IaCデプロイ時の事前検証。
    2.  **Account Factory**: Account Factory（AFC/AFT）を使用してアカウントプロビジョニングを自動化。カスタムブループリントで標準設定を強制。
    3.  **OU Structure**: セキュリティ、ネットワーク、共有サービス、ワークロード（Dev/Staging/Prod各OU）の階層構造を設計。
    4.  **Ongoing**: Landing Zoneは「一度設定して終わり」ではありません。新しいガードレールの追加、既存ルールの更新を継続的に実施。

---

## 27. Service Quotas・リミット管理 (Service Quotas & Limits Management)

### Rule 27.1: The Quota Management Protocol
-   **Law**: AWSサービスクォータを**事前監視**し、制限到達によるサービス中断を防止してください。
-   **Action**:
    1.  **CloudWatch Alarms**: 重要なサービスクォータ（Lambda同時実行数、EC2インスタンス数、VPC数等）に対し、使用率70%/90%でCloudWatchアラームを設定。
    2.  **Automatic Quota Management**: AWS Service Quotasの自動クォータ管理機能を有効化し、使用量に応じた自動通知・自動調整を活用。
    3.  **Proactive Increase**: 大規模イベントやキャンペーン前に、予想される需要に基づいて事前にクォータ引き上げリクエストを提出。
    4.  **Cross-Account Monitoring**: マルチアカウント環境ではアカウント横断でクォータ使用率を一元監視する仕組みを構築。
    5.  **Non-Adjustable Quotas**: 調整不可のクォータに対しては、アーキテクチャレベルでの回避策（シャーディング、リージョン分散等）を設計。

---

## 28. サプライチェーンセキュリティ (Supply Chain Security)

### Rule 28.1: The Container Supply Chain Protocol
-   **Law**: コンテナイメージおよびソフトウェア依存関係のサプライチェーンセキュリティを確保してください。
-   **Action**:
    1.  **ECR Image Scanning**: ECR拡張スキャン（Inspector統合）を有効化し、OS/言語パッケージの脆弱性を検出。Critical/Highの脆弱性を持つイメージのデプロイを自動阻止。
    2.  **Image Signing**: ECR/Sigstore等でコンテナイメージの署名を導入し、改竄されていないことを検証可能に。
    3.  **SBOM (Software Bill of Materials)**: Amazon Inspector でSBOMを自動生成し、全デプロイされたソフトウェアの依存関係を可視化。
    4.  **Base Image Governance**: ベースイメージは組織承認済みのものに限定（AWS公式、組織内ゴールデンイメージ）。信頼されていないパブリックイメージの直接使用を禁止。
    5.  **Dependency Scanning**: `npm audit` / `pip-audit` / `Snyk`等をCI/CDパイプラインに統合し、言語パッケージの既知脆弱性を自動検出。
    6.  **Immutable Tags**: ECRでイメージタグの不変性（Tag Immutability）を有効化し、同一タグへの上書きプッシュを防止。

---

## 29. 生成AI・Bedrockセキュリティ (Generative AI & Bedrock Security)

### Rule 29.1: The Bedrock Security Protocol
-   **Law**: Amazon Bedrockを使用する生成AIアプリケーションには、**多層的なセキュリティ対策**を実装してください。
-   **Action**:
    1.  **Guardrails Mandatory**: 全Bedrockアプリケーションに**Amazon Bedrock Guardrails**を適用し、入力・出力の双方向でコンテンツフィルタリング、PII検出・マスキング、プロンプト攻撃検知を実施。
    2.  **Prompt Injection Defense**: ユーザー入力のサニタイズ、システムプロンプトでの「埋め込みコマンド無視」指示、高リスク操作の人間承認ステップを義務化。
    3.  **Model Access Control**: IAMポリシー/SCPで`Invoke*`アクションを特定のFoundation Modelに制限。組織レベルで許可モデルを一元管理。
    4.  **Network Isolation**: Bedrock推論はVPCエンドポイント（PrivateLink）経由でアクセスし、パブリックインターネット経由の呼び出しを排除。
    5.  **Cross-Region Inference**: クロスリージョン推論使用時、データは宛先リージョンに保存されないことを確認。SCP でリージョン制限を適用。
    6.  **Agentic AI Security**: **Bedrock AgentCore**でエージェント型AIをデプロイする際、品質評価・ポリシー制御・ツール実行の権限管理を実装。エージェントのアクション範囲をIAMポリシーで制限し、人間承認ゲートを高リスク操作に設置。

### Rule 29.2: The AI Cost Optimization
-   **Law**: 生成AIのコストを最適化し、予期しないコスト超過を防止してください。
-   **Action**:
    1.  **Model Selection**: タスクの複雑さに応じてモデルを使い分け。Amazon Novaモデル群の活用を推奨:

        | モデル | 用途 | 特長 |
        |:-------|:-----|:-----|
        | Nova 2 Lite | 簡易タスク、分類、要約 | 高速・低コストの推論 |
        | Nova 2 Omni | マルチモーダル推論・画像生成 | テキスト・画像・動画の統合処理 |
        | Nova 2 Sonic | 音声対話、会話型AI | 低レイテンシ Speech-to-Speech |
        | Nova Forge | カスタムフロンティアモデル構築 | 自社データでのファインチューニング |
        | Nova Act | ブラウザ自動化 | 信頼性の高いWeb操作自動化 |

    2.  **Prompt Caching**: プロンプトテンプレートの再利用とキャッシュで入力トークンを最小化。Bedrock Prompt Caching で同一プレフィックスの繰返し推論コストを90%削減可能。
    3.  **Batch Processing**: 大量処理にはバッチ推論（On-Demand比最大50%割引）を活用。
    4.  **Provisioned Throughput**: 予測可能なワークロードにはプロビジョンドスループットで専用容量を確保。
    5.  **Usage Monitoring**: CloudWatch/Cost Explorerでモデル別・エンドポイント別のコストを追跡。Budget Alertsを設定。
    6.  **Intelligent Model Routing**: リクエストの複雑さに応じて軽量/高性能モデルを自動選択するルーター設計（Prompt Router）でコスト最適化。簡易クエリに高性能モデルを使用させない。

### Rule 29.3: The Bedrock Reinforcement Fine Tuning (RFT) Protocol
-   **Law**: ドメイン固有の精度向上が必要なBedrockモデルには**Reinforcement Fine Tuning（RFT）**を使用し、人間のフィードバックなしで最大66%の精度向上を実現してください（re:Invent 2025 GA）。
-   **Action**:
    1.  **RFTワークフロー**: ドメイン固有のプロンプト・レスポンスペアを準備→報酬関数を定義→RFTジョブを実行。従来のSFT（Supervised Fine Tuning）と異なり、大量のラベル付きデータが不要。
    2.  **Reward Function Design**: タスク固有の評価指標（正確性/一貫性/スタイル適合等）を報酬関数として定義。モデルが自律的に最適な応答パターンを学習。
    3.  **Model Selection**: RFTはAmazon Novaモデルおよび対応Bedrockモデルで利用可能。まず小規模データセットでRFTの効果を検証し、本番適用前にA/Bテストを実施。
    4.  **Cost Optimization**: RFTはSFTより少ないデータで高精度を達成するため、データ準備コストを削減。学習ジョブのGPU/Trainium使用量をCloudWatchで監視。
    5.  **vs SFT/RAG**: RFT = モデルの推論能力自体を強化。SFT = 特定パターンの模倣学習。RAG = 外部知識の注入。タスクに応じて適切な手法を選択。複雑な推論改善にはRFTが最適。
-   **Anti-pattern**: 十分なプロンプトエンジニアリングやRAGを試さずにRFTに着手すること。まずプロンプト最適化→RAG→SFT→RFTの順で検討。
-   **Cross-Ref**: Bedrock Guardrailsは§93参照。SageMaker MLOpsは§59参照。

### Rule 29.4: The Bedrock Knowledge Bases & RAG Protocol
-   **Law**: 生成AIアプリケーションの知識検索（RAG）基盤には**Amazon Bedrock Knowledge Bases**を使用し、チャンキング戦略・埋め込みモデル選択・ハイブリッド検索を体系的に設計してください。
-   **Action**:
    1.  **データソース設計**: S3（ドキュメント）、Web Crawler（Webコンテンツ）、Confluence/SharePoint等のコネクタから知識ベースを構築。データソースの同期スケジュールを定義し鮮度を管理。
    2.  **チャンキング戦略**: データの特性に応じた最適なチャンキングを選択：
        -   **Fixed Size**: 一般的なドキュメント向け。300-500トークン + 20%オーバーラップ推奨。
        -   **Hierarchical**: 構造化文書（マニュアル/仕様書）向け。章→節→段落の階層を保持。
        -   **Semantic**: 意味的区切りで自動分割。文脈の一貫性を最大化。
        -   **No Chunking**: FAQ/Q&Aペアなど既に適切な粒度のデータ。
    3.  **埋め込みモデル選択**: Amazon Titan Embeddings V2（デフォルト推奨・1024次元）またはCohere Embed。多言語対応はTitan V2を優先。次元数とコストのトレードオフを評価。
    4.  **ハイブリッド検索**: セマンティック検索（ベクトル類似度）+ キーワード検索の組み合わせで検索精度を向上。Rerankモデル（Cohere Rerank / Amazon Rerank）で上位結果を再ランキング。
    5.  **ベクトルストア選択**: S3 Vectors（§107・低コスト大規模）/ OpenSearch Serverless（リアルタイム高頻度）/ Aurora pgvector（既存RDS活用）/ Pinecone（サードパーティ）。コスト・レイテンシ・スケールの要件で選択。
    6.  **メタデータフィルタリング**: ドキュメントにメタデータ（部門/カテゴリ/日付等）を付与し、検索時にフィルタリングで精度向上。マルチテナント環境ではテナントIDでフィルタ。
-   **Anti-pattern**: チャンキングサイズを検証せずにデフォルト設定で本番運用。必ずA/Bテストで最適チャンクサイズを決定。
-   **Cross-Ref**: S3 Vectorsは§107参照。Bedrock Guardrailsは§93参照。AgentCoreは§101参照。

### Rule 29.5: The Bedrock Flows Protocol
-   **Law**: 生成AIワークフロー（プロンプトチェーン・条件分岐・ツール連携）の設計には**Amazon Bedrock Flows**を使用し、ビジュアル設計でプロンプトエンジニアリングの複雑さを管理してください。
-   **Action**:
    1.  **ビジュアルフロー設計**: ドラッグ＆ドロップでプロンプトノード・条件分岐・Knowledge Base検索・Lambda関数呼び出しを接続。コードなしでマルチステップAIワークフローを構築。
    2.  **ノードタイプ活用**: Prompt（LLM呼び出し）、Knowledge Base（RAG検索）、Agent（タスク実行）、Condition（条件分岐）、Lambda（カスタムロジック）、Iterator（ループ処理）を組み合わせ。
    3.  **テスト＆バージョン管理**: フロー定義のバージョニングとエイリアス管理。テスト実行で各ノードの入出力を検証してから本番デプロイ。
    4.  **Guardrails統合**: フロー内の各Promptノードに§93のBedrock Guardrailsを適用し、入出力の安全性を担保。
-   **Cross-Ref**: Step Functionsは§19参照。AgentCoreは§101参照。

### Rule 29.6: The Model Distillation Protocol
-   **Law**: 大規模モデルの知識を小規模モデルに移転しコスト削減する場合は**Amazon Bedrock Model Distillation**を使用してください（2024 GA）。
-   **Action**:
    1.  **Teacher-Student**: 大規模Teacherモデル（Claude 3.5 Sonnet/Nova Pro等）の出力を自動ラベルとして小規模Studentモデル（Nova Lite/Micro等）を学習。ラベル付けコストを排除。
    2.  **精度検証**: Distillation後のStudentモデルをTeacher比で品質評価。タスク固有ベンチマークで許容精度閾値を定義。
    3.  **コスト効果**: 推論コストの大幅削減（大→小モデル移行）とレイテンシ改善を両立。大量リクエストの定型タスクに最適。
    4.  **反復改善**: Distillationデータセットを継続的に拡充し、Studentモデルの精度を段階的に向上。
-   **vs RFT（§29.3）**: Distillation = 大→小モデルへの知識移転（コスト最適化）。RFT = 同一モデルの推論能力強化（精度最適化）。

---

## 30. ネットワークセキュリティ深化 (Advanced Network Security)

### Rule 30.1: The Network Firewall Protocol
-   **Law**: インターネットとの境界およびVPC間のトラフィック検査には**AWS Network Firewall**を使用してください。
-   **Action**:
    1.  **Stateful Rules First**: ディープパケットインスペクション（DPI）とIDS/IPS機能にはステートフルルールを使用。ステートレスルールはサブネットレベルの広域フィルタリングのみ。
    2.  **Suricata Rules**: 複雑な検査要件にはSuricata互換ルールを使用し、きめ細かなトラフィック制御を実現。
    3.  **Firewall Manager**: AWS Firewall Managerで組織全体のポリシーを一元管理・自動デプロイ。
    4.  **Logging**: ドロップパケット、ステートフルルールマッチ、トラフィックパターンをCloudWatchに出力し、リアルタイム監視。

### Rule 30.2: The DNS Firewall Protocol
-   **Law**: **Route 53 Resolver DNS Firewall**を使用して悪意あるドメインへのDNSクエリをブロックしてください。
-   **Action**:
    1.  **Managed Domain Lists**: AWS脅威インテリジェンスベースの管理ドメインリストで既知の悪意あるドメインを自動ブロック。
    2.  **Advanced Protections**: DNSトンネリング検知を有効化し、従来のブロックリストでは検知できない高度な脅威に対応。
    3.  **Centralized via Firewall Manager**: 組織全体のVPCに一貫したDNSセキュリティポリシーを適用。

### Rule 30.3: The Traffic Mirroring Protocol
-   **Law**: 高度なセキュリティ分析やフォレンジック調査には**VPC Traffic Mirroring**を使用してください。
-   **Action**:
    1.  **Smart Filtering**: IP、ポート、プロトコルでフィルタを適用し、必要なトラフィックのみをキャプチャ。パケットトランケーションでコスト削減。
    2.  **Security Tool Integration**: ミラーリングされたトラフィックをNLB経由でサードパーティIDS/IPS、SIEMプラットフォームに転送。

---

## 31. Systems Manager運用管理 (Systems Manager Operations)

### Rule 31.1: The SSM Foundation
-   **Law**: EC2およびハイブリッド環境の運用管理には**AWS Systems Manager**を使用し、SSH/RDPの直接アクセスを排除してください。
-   **Action**:
    1.  **Session Manager**: SSH鍵管理やBastionホストを廃止し、Session Manager経由の暗号化セッションでインスタンスにアクセス。全セッションをCloudTrailで監査、S3/CloudWatch Logsにログを集約。
    2.  **Patch Manager**: パッチベースラインとパッチグループを定義し、Maintenance Windowsでスケジュール適用を自動化。ハイブリッド環境もHybrid Activationsで一元管理。
    3.  **Parameter Store**: 設定データの階層的管理。機密データはKMS暗号化（SecureString）で保護。IAMで細粒度アクセス制御。バージョニングによるロールバック対応。
    4.  **Run Command**: 複数ノードへのリモートコマンド一括実行。ログイン不要のセキュアな管理操作。
    5.  **Inventory & Fleet Manager**: 全マネージドノードのソフトウェアインベントリを自動収集し、Fleet Managerで可視化・一元管理。

---

## 32. ハイブリッド接続・データ主権 (Hybrid Connectivity & Data Sovereignty)

### Rule 32.1: The Hybrid Connectivity Strategy
-   **Law**: オンプレミスとAWS間の接続には、要件に応じた適切な接続方式を選択してください。
-   **Action**:

    | 要件 | 推奨サービス | 備考 |
    |:-----|:-------------|:-----|
    | 専用帯域・低レイテンシ・大量転送 | Direct Connect | MACsec暗号化、DX Gateway |
    | インターネット経由の暗号化接続 | Site-to-Site VPN | DXバックアップ推奨 |
    | AWS/SaaSサービスへのプライベートアクセス | PrivateLink | パブリックIP不要 |

    1.  **Direct Connect Resilience**: 最大耐障害性のため、異なるDXロケーションでの冗長接続をデプロイ。Active/Activeの動的ルーティングを実装。
    2.  **VPN as Backup**: Direct Connectのバックアップとして必ずSite-to-Site VPNを設定。
    3.  **Transit Gateway Hub**: 3+VPC接続にはTransit Gatewayをハブとして使用し、DX/VPN接続を集約。

### Rule 32.2: The Data Sovereignty Protocol
-   **Law**: データ主権・データレジデンシー要件を遵守し、データが意図しないリージョンに移動しないことを保証してください。
-   **Action**:
    1.  **Region Selection**: ビジネス要件と適用法令（GDPR、APPI等）に基づいてAWSリージョンを選択。データは明示的に設定しない限り他リージョンに移動しない。
    2.  **SCP Region Restriction**: SCPで未承認リージョンでのリソース作成を禁止。
    3.  **Control Tower Sovereignty Controls**: Control Towerのデジタル主権コントロールでデータ保存場所の自動監視と暗号化を実施。
    4.  **BYOK**: 最高レベルの暗号鍵管理が必要な場合、KMS External Key Store（XKS）またはCloudHSMを検討。

---

## 33. データベース移行 (Database Migration)

### Rule 33.1: The DMS Migration Protocol
-   **Law**: データベース移行には**AWS Database Migration Service (DMS)**を使用し、ダウンタイムを最小化してください。
-   **Action**:
    1.  **CDC (Change Data Capture)**: 継続的レプリケーションでリアルタイムデータ同期を実現し、ゼロダウンタイム移行を達成。
    2.  **Schema Conversion Tool**: 異種DB移行（Oracle→PostgreSQL等）にはAWS SCTでスキーマ・コード変換を事前実施。生成AI支援の変換推奨機能を活用。
    3.  **Validation Mandatory**: DMSデータ検証機能を有効化し、ソース・ターゲット間のデータ整合性をテーブルレベルで検証。
    4.  **PoC First**: 本番移行前に必ずPoC（概念実証）を実施し、移行時間の見積もり、環境問題の特定、ワークロードシミュレーションを実行。
    5.  **Monitoring**: CloudWatchでレプリケーションラグ、CPU/メモリ使用率、ネットワークスループットを継続監視。

---

## 34. データ分類・プライバシー保護 (Data Classification & Privacy Protection)

### Rule 34.1: The Macie Data Classification Protocol
-   **Law**: S3に保存されたデータに対し**Amazon Macie**を使用して機密データの自動分類・PII検出を実施してください。
-   **Action**:
    1.  **Automated Discovery**: Macieの自動機密データ検出を有効化し、S3バケット全体の機密データ分布を継続的に可視化。
    2.  **Custom Data Identifiers**: 組織固有の機密データパターン（顧客ID、内部コード等）をカスタムデータ識別子として定義し、検出精度を向上。
    3.  **Automated Remediation**: EventBridge→Lambda連携で、PII検出時の自動対応（暗号化バケットへの移動、アクセス制限、通知）を構築。
    4.  **Security Hub Integration**: Macie検知結果をSecurity Hubに集約し、一元的なセキュリティ管理と既存ワークフローとの統合を実現。
    5.  **Multi-Account**: 委任管理者アカウントを設定し、組織全体のS3データ分類を一元管理。
    6.  **Compliance Alignment**: GDPR/HIPAA/PCI-DSS要件に合わせたスキャンポリシーを定義し、監査証跡としてMacie検出結果レポートを保持。

---

## 35. タグ戦略・ガバナンス (Tagging Strategy & Governance)

### Rule 35.1: The Tagging Mandate
-   **Law**: 全AWSリソースに対し、**組織統一のタグ戦略**を策定・強制し、コスト配分・セキュリティ・自動化の基盤を構築してください。
-   **Action**:
    1.  **Mandatory Tags**: 以下の必須タグを全リソースに適用。

        | タグキー | 用途 | 例 |
        |:---------|:-----|:---|
        | `Environment` | 環境識別 | prod, staging, dev |
        | `CostCenter` | コスト配分 | engineering, marketing |
        | `Project` | プロジェクト紐付け | myapp-v2 |
        | `Owner` | 責任者 | team-platform |
        | `ManagedBy` | IaCツール識別 | terraform, cdk |

    2.  **Tag Policies**: AWS Organizations Tag Policyでタグキー/値の標準化を強制。48時間ごとの自動コンプライアンス評価を活用。
    3.  **SCP Enforcement**: 必須タグ欠落リソースの作成をSCPで物理的に阻止。
    4.  **Cost Allocation**: Cost Explorerでコスト配分タグを有効化し、チーム別・プロジェクト別のコスト可視化を実現。
    5.  **Automation Tags**: Systems Managerで`PatchGroup`/`Schedule`タグによる自動パッチ適用・インスタンス起動停止スケジューリングを実装。

---

## 36. 集中ログ管理アーキテクチャ (Centralized Logging Architecture)

### Rule 36.1: The Centralized Logging Protocol
-   **Law**: **専用ログ管理アカウント**にログを集約し、セキュリティ監査・コンプライアンス要件を満たす統合ログ基盤を構築してください。
-   **Action**:
    1.  **Dedicated Account**: ログ専用AWSアカウントを設立し、厳格なアクセス制御を適用。
    2.  **CloudWatch Logs Centralization**: **CloudWatch Logs中央集約**機能を使用して、複数AWSアカウント・複数リージョンからのログデータをログ専用アカウントに自動集約（2025年〜）。Organizations統合で新規アカウント追加時の自動オンボーディングを実現。
    3.  **Tiered Retention**: CloudWatch Logs（30-60日の短期・運用分析）→ S3（長期保管・コンプライアンス）→ S3 Glacier（アーカイブ）の3層リテンション戦略を実装。
    4.  **Cross-Account Aggregation**: CloudTrail、VPC Flow Logs、ALBアクセスログ、Config、GuardDutyの検出結果を全アカウントからS3中央バケットに集約。**CloudTrail Data Event Aggregation**でデータイベントのセキュリティ監視を簡素化。
    5.  **SIEM Integration**: S3集約ログをSIEMプラットフォーム（Splunk/Datadog等）にKinesis Data Firehose経由で連携し、リアルタイム脅威検知を実現。
    6.  **Log Integrity**: CloudTrailログファイルの整合性検証を有効化し、改竄を検出可能に。S3 Object Lockで規制要件の非改変記録保持を実現。
    7.  **Cost Control**: 本番環境ではDEBUGログレベルを無効化。ログ圧縮とフィルタリングでストレージコストを最適化。CloudWatch Logs Insights のクエリ最適化（`fields`/`filter`/`limit`の活用）でスキャンコスト削減。

---

## 37. FinOps高度化 (Advanced FinOps)

### Rule 37.1: The Proactive Cost Intelligence
-   **Law**: AWSのコスト最適化ツールを組み合わせ、**予防的・自動的なコスト管理**を実現してください。
-   **Action**:
    1.  **Cost Anomaly Detection**: 全アカウントにAWS Cost Anomaly Detectionを有効化。ML基盤の異常検知で予期しないコスト急増を自動検出。SNS/Slack通知を設定。
    2.  **Trusted Advisor Integration**: Trusted Advisorのコスト最適化チェック（アイドルリソース、未使用EIP、低利用率EC2）を定期レビューに組み込み。
    3.  **Compute Optimizer**: 全アカウントでCompute Optimizerを有効化し、EC2/EBS/Lambda/ECSのライトサイジング推奨を継続的に適用。Graviton移行推奨も活用。
    4.  **AWS Budgets**: サービス別・タグ別・アカウント別の予算を設定し、実績・予測コストがしきい値を超過する前にアラートを発行。
    5.  **Cost Optimization Hub**: 組織全体のコスト最適化推奨を一元集約し、重複排除された実効的な推奨リストを管理。

---

## 38. マルチリージョン Active-Active (Multi-Region Active-Active)

### Rule 38.1: The Multi-Region Architecture Protocol
-   **Law**: グローバル規模の高可用性が必要なワークロードには、**マルチリージョン Active-Active アーキテクチャ**を設計してください。
-   **Action**:
    1.  **DynamoDB Global Tables**: マルチリージョン書き込みが必要なデータストアにはGlobal Tablesを使用。「last-writer-wins」のコンフリクト解決戦略をアプリケーション設計に反映。強整合性が必要な場合はMRSC Global Tablesを検討。
    2.  **Aurora Global Database**: 低レイテンシ・リードレプリカとDR用途にはAurora Global Databaseを使用。非同期レプリケーション（1秒未満遅延）。プライマリリージョン障害時の自動フェイルオーバー。
    3.  **Route 53 Health Checks**: 各リージョンのエンドポイントにヘルスチェックを設定。Latency-basedルーティングで最寄りの正常リージョンに誘導。低TTL（60秒以下）を設定。
    4.  **CloudFront Origin Failover**: Origin Groupでプライマリ/セカンダリオリジンを定義し、5xx系エラー時に自動切替。
    5.  **Stateless Design**: アプリケーションをリージョン非依存のステートレス設計に。セッションは外部ストア（DynamoDB/ElastiCache Global Datastore）で管理。
    6.  **IaC Multi-Region**: 全リージョンのインフラをIaCで同一コードベースから一貫してデプロイ。

---

## 39. CloudFront深化・エッジコンピューティング (CloudFront Advanced & Edge Computing)

### Rule 39.1: The Edge Function Selection
-   **Law**: エッジロジックの要件に基づいて適切な関数タイプを選択してください。
-   **Action**:

    | 要件 | 推奨 | 備考 |
    |:-----|:-----|:-----|
    | 軽量処理（ヘッダ操作・URL書換・リダイレクト） | CloudFront Functions | <1ms、1000万RPS+、低コスト |
    | API呼出・外部接続・画像変換・複雑認証 | Lambda@Edge | ネットワークアクセス可、10GB RAM |

### Rule 39.2: The CloudFront Security & Performance
-   **Law**: CloudFrontのセキュリティ・パフォーマンス機能をフル活用してください。
-   **Action**:
    1.  **Origin Shield**: オリジンに最も近いリージョンでOrigin Shieldを有効化し、キャッシュヒット率向上とオリジン負荷軽減を実現。
    2.  **Signed URLs/Cookies**: 有料コンテンツ・期限付きダウンロードにはSigned URLを使用。ECDSA署名（2025年〜）でモバイル/IoT向けに最適化。
    3.  **Field-Level Encryption**: POSTリクエストの特定フィールドをエッジで暗号化し、オリジンサーバ侵害時も機密データを保護。RSA 2048bit鍵ペアをSecrets Managerで管理。
    4.  **Real-Time Logs**: Kinesis Data Streamsへリクエストデータをリアルタイム配信。サンプリングレートとフィールド選択でコスト最適化。
    5.  **Cache Key Normalization**: CloudFront FunctionsでクエリパラメータのソートやUser-Agentの正規化を実施し、キャッシュヒット率を最大化。
    6.  **KeyValueStore**: **CloudFront KeyValueStore**を活用し、エッジでの動的構成データ管理を実現（2023年GA）。
        -   **ユースケース**: URL書換・リダイレクト、フィーチャーフラグ、A/Bテスト、アクセス認可リストをコードと分離してエッジで管理。
        -   **低レイテンシ**: インメモリKVストアにより、毎秒数百万リクエスト規模でサブミリ秒の読み取りを実現。
        -   **コード分離**: CloudFront Functions（JavaScript Runtime 2.0必須）と組み合わせ、関数コードと構成データを独立デプロイ。コード変更不要のデータ更新が可能。
        -   **制限**: KVストアあたり最大5MB、キー512バイト、値1KB。大規模データにはDynamoDB + Lambda@Edgeを検討。
        -   **セキュリティ**: 保存時・転送中の暗号化を自動適用。エッジでのメモリ内復号。
    7.  **VPC Origins（2024年GA）**: プライベートサブネット内のALB/NLB/EC2インスタンスをCloudFrontオリジンとして直接使用。パブリックインターネットへのバックエンド露出を完全排除しゼロトラスト配信を実現。
        -   **Security Group**: オリジンリソースのSGで、CloudFrontマネージドプレフィックスリスト（`CloudFront-VPCOrigins-Service-SG`）からのインバウンドのみ許可。
        -   **HTTPS**: CloudFrontとVPCオリジン間は常にHTTPS通信を設定。
        -   **Cross-Account VPC Origins（2025年〜）**: AWS Resource Access Manager（RAM）経由で、別アカウントのVPCオリジンにCloudFrontから接続。マルチアカウント環境のセキュリティ強化。
        -   **WAF統合**: CloudFront + AWS WAFで悪意あるトラフィックをエッジでフィルタ後、プライベートオリジンに転送。

### Rule 39.3: The Secrets Rotation Protocol
-   **Law**: **AWS Secrets Manager**でシークレットの自動ローテーションを実装し、認証情報のライフサイクルを完全自動化してください。
-   **Action**:
    1.  **Automated Rotation**: RDS/Aurora/Redshift向けの事前構築済みLambdaローテーション関数を使用。最低90日間隔でのローテーションを設定。
    2.  **Dual-Secret Strategy**: ローテーション中はAWSCURRENT/AWSPENDING両バージョンを維持し、ゼロダウンタイムを保証。
    3.  **Cross-Account Sharing**: カスタムKMS CMKとリソースベースポリシーでクロスアカウントシークレット共有を実装。
    4.  **Client-Side Caching**: Secrets Manager Agentでクライアントサイドキャッシュを使用し、API呼出を最小化しつつ最新値を取得。
    5.  **Monitoring**: CloudTrailで全シークレットアクセス・ローテーションイベントを監査。ローテーション失敗時のCloudWatchアラームを設定。

---

## 40. AWS Backup集中管理 (Centralized Backup Management)

### Rule 40.1: The Backup Governance Protocol
-   **Law**: **AWS Backup**を使用してバックアップ管理を一元化し、データ保護のコンプライアンスを自動化してください。
-   **Action**:
    1.  **Organization Policies**: AWS Organizations Backup Policyで組織全体の統一バックアップルールをデプロイ。タグベースで自動リソース組み込み。
    2.  **Cross-Account Backup**: 専用バックアップアカウントにリカバリポイントを自動コピー。アカウント侵害時の最終防衛線として機能。
    3.  **Vault Lock (WORM)**: Compliance Modeでバックアップボルトを不変化。最小保持期間内のリカバリポイント削除を物理的に阻止。Governance Modeで事前テスト後にComplianceへ移行。
    4.  **Backup Audit Manager**: コンプライアンスコントロールとテンプレートでバックアップ計画が保持・暗号化要件を満たしているか継続監視。
    5.  **PITR**: RDS/Aurora/DynamoDB等で継続的バックアップとPITR（ポイントインタイムリカバリ）を有効化し、データ破損からの粒度の細かい復旧を実現。
    6.  **Lifecycle**: S3 Glacier等への自動遷移でストレージコストを最適化。SCP で保持期間の最小・最大値を組織レベルで強制。

---

## 41. 脆弱性管理・Inspector (Vulnerability Management & Inspector)

### Rule 41.1: The Inspector Protocol
-   **Law**: **Amazon Inspector**を全アカウント・全スキャンタイプ（EC2/Lambda/ECR）で有効化し、継続的な脆弱性管理を実現してください。
-   **Action**:
    1.  **Organization-Wide**: 委任管理者アカウントから全メンバーアカウントに自動有効化。新規アカウント追加時も自動適用。
    2.  **EC2 Deep Inspection**: SSM Agent統合でOSパッケージに加えアプリケーションパッケージ（Python/Java/Node.js）の脆弱性も検出。
    3.  **Lambda Code Scanning**: 依存関係スキャン（standard）に加え、コード脆弱性スキャン（code scanning）でデータリーク・インジェクション・弱暗号を検出。
    4.  **ECR Continuous Re-scan**: プッシュ時のみでなく、新CVE公開時にも自動再スキャン。最小ベースイメージ（Alpine/distroless）使用を推奨。
    5.  **SBOM Export**: CycloneDX/SPDX形式でSBOMをS3にエクスポート。サプライチェーン透明性とコンプライアンス監査に活用。
    6.  **CIS Benchmarks**: EC2インスタンスに対しCIS Benchmark（Level 1/2）評価をスケジュール実行。
    7.  **Automated Remediation**: EventBridge→SSM Automationで重大脆弱性の自動パッチ適用。Security Hub Custom Actionsで修復ワークフローを構築。

---

## 42. CI/CDパイプラインセキュリティ (CI/CD Pipeline Security)

### Rule 42.1: The Secure Pipeline Protocol
-   **Law**: CI/CDパイプラインをセキュリティ境界として設計し、サプライチェーン攻撃を防止してください。
-   **Action**:
    1.  **OIDC Federation**: GitHub Actions等の外部CI/CDにはOIDC連携を使用し、長期アクセスキーの保存を完全排除。Trust Policyでリポジトリ/環境を厳格に制限。
    2.  **Artifact Signing**: ビルド成果物（コンテナイメージ、バイナリ）に暗号署名を実施。AWS Signerでテスト完了後・デプロイ前に署名。改竄検知を自動化。
    3.  **Cross-Account Deployment**: 環境別アカウント分離（dev/staging/prod）。共有サービスアカウントのCI/CDからクロスアカウントロールでデプロイ。最小権限のIAMポリシーを適用。
    4.  **Secrets in Pipeline**: パイプライン設定やIaCテンプレートにシークレットのハードコーディング禁止。Secrets Manager参照を義務化。
    5.  **Artifact Encryption**: S3のCodePipeline成果物バケットにKMS暗号化を適用。

---

## 43. カオスエンジニアリング (Chaos Engineering & Resilience Testing)

### Rule 43.1: The FIS Protocol
-   **Law**: **AWS Fault Injection Simulator (FIS)**を使用して制御されたカオス実験を実施し、システムレジリエンスを継続的に検証してください。
-   **Action**:
    1.  **Steady-State Hypothesis**: 実験前にシステムの「定常状態」を定量的に定義（レイテンシ、エラー率、スループット等）。仮説を立て、実験で検証/否定。
    2.  **Blast Radius Control**: 実験テンプレートでターゲットリソースをタグ/IDで限定。Stop ConditionsにCloudWatchアラームを設定し、異常時に自動停止。
    3.  **Progressive Complexity**: 非本番環境→部分本番→フルスケールの段階的拡大。小規模実験でチームの信頼性を構築後にスケールアップ。
    4.  **CI/CD Integration**: 主要デプロイ後にFIS実験を自動実行し、デプロイごとのレジリエンス検証を継続的に実施。
    5.  **IAM Least Privilege**: FIS実験ロールに最小権限を適用し、意図しないリソースへの影響を物理的に防止。

---

## 44. IAM高度化 (Advanced IAM)

### Rule 44.1: The IAM Excellence Protocol
-   **Law**: IAMの高度機能を活用し、エンタープライズレベルのアクセス管理を実現してください。
-   **Action**:
    1.  **IAM Identity Center (SSO)**: 人間のユーザーアクセスは全てIdentity Center経由のフェデレーション認証に統一。個別IAMユーザー作成禁止。Permission Setsでアカウント横断のアクセスを定義。
    2.  **Permission Boundaries**: IAMロール/ユーザーの最大権限を制限し、権限昇格を構造的に防止。管理者権限の委譲時に必須適用。
    3.  **Confused Deputy Prevention**: クロスサービスアクセスのTrust Policyに`aws:SourceArn`/`aws:SourceAccount`条件キーを必ず付与。
    4.  **IAM Access Analyzer**: 外部アクセス・クロスアカウントアクセスの検出を継続実行。未使用アクセスの分析と最小権限ポリシー自動生成を活用。
    5.  **MFA Enforcement**: クロスアカウントロール引受時、特権操作時のMFA必須化をIAMポリシー条件で強制。

---

## 45. Well-Architected運用プロセス (Well-Architected Operational Process)

### Rule 45.1: The Well-Architected Review Cadence
-   **Law**: **AWS Well-Architected Tool**を使用して定期的なアーキテクチャレビューを実施し、継続的な改善サイクルを確立してください。
-   **Action**:
    1.  **Review Cadence**: 本番クリティカルワークロードは四半期ごと、その他は半期ごとにWell-Architectedレビューを実施。
    2.  **Milestone Tracking**: レビュー完了時とアーキテクチャ改善実施時にマイルストーンを保存し、改善の進捗を定量的に追跡。
    3.  **Custom Lens**: 組織固有の技術標準・コンプライアンス要件をカスタムレンズとして定義し、標準6ピラーレビューに加えて適用。
    4.  **Organizational Sharing**: レビューテンプレート・カスタムレンズをAWS Organizations全体で共有し、レビュー品質の均一化とスケーリングを実現。
    5.  **Improvement Plan**: 特定されたリスクに対し改善計画を策定し、優先度付けて実行。高リスク項目（HRI）はSprint計画に組み込み。

---

## 46. コンプライアンスフレームワーク対応 (Compliance Framework Alignment)

### Rule 46.1: The Compliance Automation Protocol
-   **Law**: **AWS Audit Manager**を使用してコンプライアンスエビデンス収集を自動化し、主要規制フレームワークへの準拠を継続的に証明してください。
-   **Action**:
    1.  **Audit Manager Frameworks**: SOC 2、ISO 27001、HIPAA、PCI-DSS、NIST 800-53用の事前構築済みフレームワークを有効化。CloudTrail/Config/Security Hubからエビデンスを自動収集。
    2.  **Security Hub Standards**: AWS Foundational Security Best Practices、CIS AWS Foundations Benchmark、PCI-DSS標準を有効化し、セキュリティスコアで継続的コンプライアンスを可視化。
    3.  **Config Conformance Packs**: 各フレームワーク用のConformance Pack（PCI-DSS/FedRAMP等）をデプロイし、Config Rulesによるリソース準拠をバッチ評価。
    4.  **HIPAA BAA**: PHI（保護対象医療情報）を扱う場合、AWSとBAA（事業者関連契約）を締結。HIPAA適格サービスのみでPHIを処理。
    5.  **AWS Artifact**: AWSのSOC/ISO/PCI認証レポートをArtifactからダウンロードし、監査証跡として保持。

---

## 47. レジリエンスハブ (Resilience Hub)

### Rule 47.1: The Resilience Assessment Protocol
-   **Law**: **AWS Resilience Hub**を使用してアプリケーションのレジリエンス体制を定量評価し、RTO/RPO目標への準拠を継続的に検証してください。
-   **Action**:
    1.  **Resiliency Policy**: 各アプリケーションに適切なRTO/RPO目標を定義したレジリエンシーポリシーを適用（ソフトウェア/ハードウェア/AZ/リージョン障害別）。
    2.  **Assessment Scheduling**: 日次自動評価をスケジュール設定し、アーキテクチャ変更がレジリエンス目標に影響しないか継続的に検証。
    3.  **Drift Detection**: リソース追加/削除やRTO/RPO逸脱をドリフト検出で自動検知。SNS通知で即時アラート。
    4.  **Operational Recommendations**: 評価後の推奨アラーム・SOP・FIS実験テンプレートをCloudFormationテンプレートとして自動生成。
    5.  **Resiliency Score**: 0-100のレジリエンシースコアでアプリケーション全体の耐障害性を定量追跡。100点達成を目標に推奨事項を段階的に実装。

---

## 48. 共有ファイルストレージ (Shared File Storage — EFS/FSx)

### Rule 48.1: The Shared Storage Protocol
-   **Law**: コンテナ/サーバーレスワークロードの共有ストレージには**Amazon EFS**または**Amazon FSx**を適切に選択し、パフォーマンス・コスト・セキュリティを最適化してください。
-   **Action**:
    1.  **EFS Throughput Mode**: ワークロードが予測困難な場合はElastic Throughput（自動スケール・使用量課金）。安定高スループットが必要な場合はProvisioned Throughput。
    2.  **EFS Lifecycle Management**: Infrequent Access (IA)→Archiveへの自動遷移ポリシーを設定（IA: 最大92%コスト削減）。アクセス頻度に基づき7/14/30/60/90日の遷移期間を選択。
    3.  **Multi-AZ Mount Targets**: 高可用性のため複数AZにマウントターゲットを作成。DNS名でのマウントで自動AZ解決。
    4.  **Encryption**: 作成時にKMS暗号化（静止時）を有効化。EFS Mount Helperでtunnel TLS（転送中暗号化）を実装。
    5.  **FSx Selection**: Windows互換→FSx for Windows File Server、HPC/ML→FSx for Lustre、汎用高性能→FSx for OpenZFS。Intelligent-Tieringでコスト自動最適化。
    6.  **Access Points**: EFS Access Pointsでコンテナごとの権限分離とPOSIX権限を強制。

---

## 49. OpenSearch検索・分析 (OpenSearch Search & Analytics)

### Rule 49.1: The OpenSearch Protocol
-   **Law**: **Amazon OpenSearch Service**の本番運用では、セキュリティ・可用性・コスト最適化のベストプラクティスを適用してください。
-   **Action**:
    1.  **Fine-Grained Access Control**: インデックス/ドキュメント/フィールドレベルのアクセス制御を有効化。Cognito/SAMLとの統合でIdP認証を実装。
    2.  **Dedicated Master Nodes**: 本番環境では3ノードのマルチAZ専用マスターノードを設定（m5.large以上）。スプリットブレイン防止。
    3.  **UltraWarm / Cold Storage**: 読み取り専用の履歴データをUltraWarm/Coldに自動移行。S3バックエンドでGBあたりコストを大幅削減。
    4.  **Vector Database & GPU Acceleration**: ベクトル検索（k-NN）をGPUアクセラレーションで高速化（2025年〜）。RAGパイプライン、セマンティック検索、リコメンデーションエンジンのパフォーマンスとコストを自動最適化。Auto-Optimizationでインデックス設定を自動チューニング。
    5.  **Index Lifecycle Management (ISM)**: ロールオーバー・保持期間・削除をISMポリシーで自動化。時系列データのストレージ階層自動遷移。
    6.  **VPC Deployment**: ドメインをVPC内にデプロイしインターネット非公開。PrivateLinkエンドポイントでアクセス制御。Multi-AZ配置で高可用性。
    7.  **Serverless Option**: 運用負荷を最小化したい場合はOpenSearch Serverlessを検討。自動スケーリング・高可用性・使用量課金。

---

## 50. アカウント自動プロビジョニング (Account Factory & Automated Provisioning)

### Rule 50.1: The Account Vending Protocol
-   **Law**: **Account Factory for Terraform (AFT)**またはControl Tower Account Factoryを使用してAWSアカウントのプロビジョニングを完全自動化してください。
-   **Action**:
    1.  **AFT Pipeline**: Terraform IaCベースのAFTパイプラインで、アカウント作成・セキュリティベースライン・ネットワーク設定・SSO統合を自動化。Gitリポジトリでアカウント仕様を宣言的管理。
    2.  **Global Customizations**: 全アカウント共通のセキュリティベースライン（CloudTrail有効化、ガードレール適用、タグ付与）をグローバルカスタマイゼーションで一括適用。
    3.  **Account-Specific**: 環境別（dev/staging/prod）の固有設定をアカウント固有カスタマイゼーションで差分適用。
    4.  **OU Strategy**: コンプライアンス境界に基づくOU構造を設計。SCP/Tag Policyをou単位で適用。ワークロード別・環境別・セキュリティ境界別の3軸でOU設計。
    5.  **Self-Service Portal**: 開発チームがセルフサービスでアカウントを要求できるポータルを構築し、ガバナンスを保ちつつ開発速度を向上。

---

## 51. ネットワークパフォーマンス最適化 (Network Performance Optimization)

### Rule 51.1: The Network Performance Protocol
-   **Law**: AWSのネットワーク高速化機能を適切に選択・設定し、ワークロードの通信性能を最大化してください。
-   **Action**:
    1.  **Placement Groups**: HPC/低レイテンシ要件にはCluster Placement Group（同一AZ・最大100Gbps）。HA要件にはSpread。分散システムにはPartition。
    2.  **Enhanced Networking (ENA)**: 全EC2インスタンスでENA（Elastic Network Adapter）を有効化。SR-IOVによるPPS向上・レイテンシ低減。
    3.  **EFA**: HPC/MLのノード間通信にはElastic Fabric Adapter。OS-bypassで単一桁マイクロ秒レイテンシ。Cluster Placement Group必須。
    4.  **Jumbo Frames**: VPC内/Peering間のデータ転送にMTU 9001を設定。プロトコルオーバーヘッド削減でスループット向上。
    5.  **Transit Gateway Optimization**: ECMP（等コストマルチパス）ルーティングで帯域幅を水平拡張。VPNスループットも複数トンネルで線形スケール。
    6.  **Data Transfer Cost**: 同一AZ内通信を最大化しデータ転送コストを最小化。CloudFront/Global Acceleratorでグローバルユーザーへの配信を最適化。

---

## 52. MSKストリーミング基盤 (Managed Streaming for Apache Kafka)

### Rule 52.1: The MSK Protocol
-   **Law**: 大規模イベントストリーミングには**Amazon MSK**を使用し、クラスター設計・セキュリティ・運用のベストプラクティスを適用してください。
-   **Action**:
    1.  **Provisioned vs Serverless**: 予測可能な高スループットにはProvisioned、変動的ワークロードにはMSK Serverless。Provisioned選択時はブローカー数・パーティション数を事前計画。
    2.  **Tiered Storage**: 長期保持データにはTiered Storageを有効化し、ブローカーローカルストレージから自動オフロード。ストレージコストを大幅削減。
    3.  **IAM Authentication**: IAM認証によるクライアント認証を優先。mTLS/SASLも対応。ACLでトピックレベルの細粒度アクセス制御。
    4.  **Schema Registry**: AWS Glue Schema Registryでスキーマ進化を管理。Avro/JSON Schema/Protobuf対応。互換性モード（BACKWARD/FORWARD/FULL）を強制。
    5.  **Multi-AZ**: 3AZ配置とmin.insync.replicas=2でデータ耐久性を保証。unclean.leader.election.enable=falseでデータロスを防止。
    6.  **Kafka Connect**: MSK Connectでソース/シンクコネクタをサーバーレス運用。S3/DynamoDB/OpenSearchへの自動データパイプライン構築。

---

## 53. データレイクガバナンス (Data Lake Governance — Lake Formation)

### Rule 53.1: The Lake Formation Protocol
-   **Law**: **AWS Lake Formation**を使用してデータレイクのアクセス制御を一元化し、列・行・セルレベルのきめ細かなデータガバナンスを実現してください。
-   **Action**:
    1.  **Fine-Grained Access Control**: 列レベル（機密カラム制限）、行レベル（レコード単位制限）、セルレベル（列×行の組み合わせ制限）のアクセス制御を実装。
    2.  **LF-Tags**: タグベースのアクセス制御で権限管理をスケール。LF-Tag分類体系を設計し、データベース→テーブル→カラムの階層継承で権限付与を簡素化。
    3.  **Cross-Account Sharing**: RAM（Resource Access Manager）によるクロスアカウントデータ共有。データ複製なしで安全なアカウント間分析。
    4.  **Data Catalog**: Glue Data Catalogを中心としたメタデータ管理。スキーマ履歴の自動追跡でデータ発見性を向上。
    5.  **Governed Tables**: ACIDトランザクション・タイムトラベル・行レベルセキュリティを備えたS3テーブル。Apache Iceberg/Hudi/Delta Lake互換。
    6.  **Audit**: CloudTrailでデータアクセスの完全な監査証跡を維持。Macieと連携して機密データの自動分類。

---

## 54. セキュリティ調査・脅威ハンティング (Security Investigation & Threat Hunting)

### Rule 54.1: The Security Investigation Protocol
-   **Law**: **Amazon Detective**と**Amazon Security Lake**を統合し、セキュリティ調査と脅威ハンティングの効率を最大化してください。
-   **Action**:
    1.  **Security Lake**: 全リージョン・全アカウントで有効化。VPC Flow Logs/CloudTrail/Route 53/GuardDutyを自動集約。OCSF（Open Cybersecurity Schema Framework）で正規化。
    2.  **OCSF Schema Governance**: OCSFの統一スキーマにより、AWサービス・SaaS・オンプレミスの異種ログを単一の正規化フォーマットに変換。カスタムパーサー不要で分析基盤を簡素化。Apache Parquet形式でS3に効率的に格納。
    3.  **Detective Integration**: GuardDuty findingを起点にDetectiveで根本原因分析。Behavior Graphで関連エンティティの挙動を可視化。
    4.  **Threat Hunting**: Security Lakeの正規化データに対しAthena/OpenSearchでクロスソースパターン検索。Sigmaルールベースの脅威検出。
    5.  **Generative AI Integration**: Security LakeのOCSFデータを生成AI（Bedrock/Amazon Q）と統合し、インシデント調査を加速。自然言語でのセキュリティクエリ、自動サマリ生成、攻撃チェーンの自然言語説明により、調査時間を大幅短縮（実績: 丸1日→数分）。
    6.  **SIEM Integration**: Security LakeのOCSFデータを外部SIEM（Splunk/Datadog等）に連携。統一スキーマでログ解析を効率化。ベンダーロックイン回避。
    7.  **Automated Response**: Detective→Step Functions→Lambda→Systems Managerの自動インシデントレスポンスパイプライン構築。
    8.  **Cost Optimization**: Security Lakeのデータ保持ポリシーを設定し、ホットデータは90日、アーカイブは規制要件に応じて設定。S3 Intelligent-Tieringと組み合わせてストレージコストを最適化。

---

## 55. エンタープライズPKI・ハードウェアセキュリティ (Enterprise PKI & Hardware Security)

### Rule 55.1: The PKI & HSM Protocol
-   **Law**: **AWS Private CA**と**CloudHSM**を使用してエンタープライズPKIインフラを構築し、証明書管理とハードウェアセキュリティを実現してください。
-   **Action**:
    1.  **Private CA Hierarchy**: CloudHSM上にルートCA秘密鍵を生成・保管（FIPS 140-2 Level 3）。Private CAで下位CAを管理する階層型PKIを構築。
    2.  **Short-Lived Certificates**: コンテナ/サーバーレスのエフェメラルリソースにはShort-Lived CA Mode（最大7日有効期間）を使用。CRL/OCSP依存を最小化。
    3.  **mTLS**: Private CA発行の証明書でmutual TLSを実装。ALB/API Gateway/VPC Latticeでクライアント証明書検証。
    4.  **CloudHSM FIPS**: FIPS 140-2 Level 3が要求される場合（金融・政府・医療）、CloudHSMで暗号鍵を管理。KMS（Level 2）では不十分な規制要件に対応。
    5.  **IAM Roles Anywhere**: Private CA証明書でオンプレミスワークロードにIAM一時認証情報を付与。長期アクセスキー不要のハイブリッド認証。

---

## 56. リソース最適化・アドバイザリ (Resource Optimization & Advisory)

### Rule 56.1: The Optimization Advisory Protocol
-   **Law**: **AWS Compute Optimizer**と**Trusted Advisor**を有効活用し、リソースのライトサイジングとコスト最適化を継続的に実行してください。
-   **Action**:
    1.  **Compute Optimizer**: EC2/EBS/Lambda/ECS on Fargateの利用パターンを分析し、最適インスタンスタイプ・ボリュームタイプ・メモリ割当を推奨。Graviton移行機会の自動検出。
    2.  **Lambda Power Tuning**: Lambda Power Tuningツールで関数ごとの最適メモリ設定を決定。コスト対パフォーマンスの最適解を自動探索。
    3.  **Trusted Advisor**: 5ピラー（コスト、パフォーマンス、セキュリティ、耐障害性、サービス制限）のチェックを定期確認。アイドルリソース・未使用EBSボリューム・未関連EIPを自動検出。
    4.  **Cost Optimization Hub**: Compute Optimizer/Trusted Advisorの推奨を統合し、組織全体のコスト最適化機会を一元可視化。
    5.  **EBS Optimization**: gp2→gp3マイグレーション推奨の自動検出。DLM（Data Lifecycle Manager）でスナップショットライフサイクルを自動管理。

---

## 57. マネージドオブザーバビリティ (Managed Observability — Grafana/Prometheus)

### Rule 57.1: The Managed Observability Protocol
-   **Law**: **Amazon Managed Grafana (AMG)**と**Amazon Managed Service for Prometheus (AMP)**を使用してクラウドネイティブなオブザーバビリティスタックを構築してください。
-   **Action**:
    1.  **Centralized Architecture**: 専用オブザーバビリティアカウントにAMG/AMPワークスペースを集約。クロスアカウントIAMロールで全ワークロードアカウントのメトリクスを収集。
    2.  **AMP Workspace**: ラベルセットと制限を設定しアクティブ系列量を管理。Recording Rulesで頻用PromQLクエリを事前計算しパフォーマンスを最適化。
    3.  **CloudWatch Integration**: AMGでCloudWatch/AMP/X-Rayを統合データソースとして設定。メトリクス・ログ・トレースの統一ダッシュボードを構築。
    4.  **Alerting**: Prometheus AlertManagerで症状ベースアラートを設定。SNS/PagerDuty連携で通知。CloudWatch Anomaly Detectionで誤検知を低減。
    5.  **OpenTelemetry**: AWS Distro for OpenTelemetry（ADOT）でテレメトリ収集を標準化。ベンダーロックイン回避とマルチシグナル（metrics/traces/logs）統合。

---

## 58. AppSync GraphQL API

### Rule 58.1: The AppSync Protocol
-   **Law**: GraphQL APIには**AWS AppSync**を使用し、リアルタイム・キャッシング・セキュリティのベストプラクティスを適用してください。
-   **Action**:
    1.  **JavaScript Pipeline Resolvers**: VTLではなくJavaScript（APPSYNC_JS）リゾルバを使用。Pipeline Resolverで関数再利用性を確保。DynamoDB直接統合でLambda Hop削減。
    2.  **Authorization Multi-Mode**: Cognito User Pools/IAM/API Key/OIDC/Lambda Authorizerの複数認証モードを同時設定。ユースケースに応じ最適な認証方式を選択。
    3.  **Real-Time Subscriptions**: WebSocket経由のGraphQL Subscriptionsでリアルタイムデータ同期。Cognito認証で購読アクセスを制御。
    4.  **Resolver Caching**: サーバーサイドキャッシュをリゾルバ単位で設定（TTL指定・カスタムキャッシュキー）。DAXとの組み合わせでDynamoDB読取負荷を軽減。
    5.  **Merged APIs**: 複数チームのAppSync APIを単一エンドポイントに統合。@canonical/@hiddenディレクティブで型名衝突を解決。
    6.  **Introspection制限**: 本番環境ではスキーマイントロスペクションを制限し、APIメタデータの漏洩を防止。

---

## 59. SageMaker MLOps

### Rule 59.1: The SageMaker MLOps Protocol
-   **Law**: **Amazon SageMaker**を使用するMLワークロードでは、MLOpsのベストプラクティスを適用してモデルライフサイクルを自動化・ガバナンスしてください。
-   **Action**:
    1.  **SageMaker Pipelines**: 学習・評価・モデル登録のワークフローを自動化。パラメータ化・条件分岐・CI/CD統合で再現性を確保。
    2.  **Model Registry**: モデルバージョン管理・承認ワークフロー（Staging→Production）を一元化。メタデータ（学習データ/メトリクス/Git SHA）を自動添付。
    3.  **Feature Store**: オンライン（低レイテンシ推論）/オフライン（バッチ学習）Feature Storeで学習・推論間の特徴量一貫性を保証。タイムトラベルで再現性。
    4.  **Endpoint Autoscaling**: TargetTrackingスケーリングで推論エンドポイントを動的調整。Multi-Model Endpoint (MME)で複数モデルのコスト最適化。Inference Recommenderで最適インスタンス選定。
    5.  **Model Monitor**: データ品質・モデル品質・データドリフト・概念ドリフトを継続監視。CloudWatchアラームで閾値超過を即時検知し、自動再学習トリガーを設定。
    6.  **VPC-Only Mode**: SageMaker Studioドメインを VPC-Only Modeで設定。VPCエンドポイント経由でS3/ECR/KMSにプライベート接続。直接インターネットアクセス無効化。
    7.  **Serverless Customization（re:Invent 2025 GA）**: **SageMaker AI Serverless Customization**でファインチューニングワークフローを数ヶ月から数日に短縮。インフラプロビジョニング不要でモデルカスタマイズを実行。サーバーレスコンピュート上でデータ準備→学習→評価を一貫実行。小〜中規模のファインチューニングタスクに最適。大規模学習にはTrainium/GPU付きSageMaker学習ジョブを使用。

---

## 60. ゼロトラストネットワークアクセス (Zero Trust — Verified Access)

### Rule 60.1: The Zero Trust Protocol
-   **Law**: 社内アプリケーションへのアクセスには**AWS Verified Access**を使用し、VPN依存を排除してゼロトラストアーキテクチャを実現してください。
-   **Action**:
    1.  **Identity + Device Trust**: IDプロバイダ（IAM Identity Center/Okta/Azure AD）とデバイス管理（CrowdStrike/Jamf）を統合。ユーザーIDとデバイスセキュリティ状態の両方で認証。
    2.  **Cedar Policies**: Cedarポリシー言語で人間が読める条件付きアクセスポリシーを定義。グループレベル（広範囲）+エンドポイントレベル（アプリ固有）の階層化。
    3.  **Endpoint Groups**: セキュリティ要件が共通のアプリケーションをグループ化。単一ポリシーで複数アプリに一貫したセキュリティを適用。
    4.  **Non-HTTP(S) Protocol Support**: **TCP/SSH/RDPプロトコル**にも対応（2025年〜プレビュー）。Gitリポジトリ・データベース・EC2インスタンスへのVPN不要アクセスを実現。既存のVerified Accessポリシーを非Webリソースにも拡張し、全社アクセスを統一的にゼロトラスト化。
    5.  **WAF Integration**: Verified AccessにAWS WAFを統合し、SQLインジェクション等のアプリケーション層攻撃を防止。ゼロトラスト認証とWAFの多層防御を実現。
    6.  **Signed Identity Context**: 署名付きIDコンテキスト（email、username等）をアプリケーションエンドポイントにパススルー。アプリ側でのパーソナライゼーションとセキュリティ強化に活用。
    7.  **Access Logging**: 全アクセスログをCloudWatch/S3に送信。リアルタイム監視・インシデント調査・長期コンプライアンス監査に活用。
    8.  **Incremental Adoption**: VPNからの移行は段階的に実施。低リスクなWebアプリから開始し、Non-HTTP(S)リソース（SSH/RDP/DB）へ順次拡大。

---

## 61. バッチ・HPCコンピューティング (Batch & HPC Computing)

### Rule 61.1: The Batch Computing Protocol
-   **Law**: バッチ処理・HPC・大規模並列処理には**AWS Batch**を使用し、スケジューリング・コスト・耐障害性を最適化してください。
-   **Action**:
    1.  **Compute Environment**: Fargate（サーバーレス・運用簡素）またはEC2（柔軟性・GPU対応）を選択。Gravitonインスタンスでコストパフォーマンス向上。
    2.  **Spot Integration**: Spotインスタンスを活用し学習・バッチ処理コストを大幅削減。中断時の自動リトライとジョブチェックポイントで耐障害性確保。
    3.  **Job Queue Priority**: 優先度レベル付きジョブキューで重要ジョブを最優先処理。Fair-shareスケジューリングでユーザー/チーム間のリソース公平分配。
    4.  **Array Jobs**: 同一パラメータ差異の大量ジョブをArray Jobsで効率的に並列化。インデックスベースの入力分割で管理を簡素化。
    5.  **Multi-Node Parallel**: HPCワークロードにはマルチノード並列ジョブを使用。タイトカップリング通信が必要なシミュレーション・計算に対応。

---

## 62. サービスディスカバリ・サービス間通信戦略 (Service Discovery & Inter-Service Communication)

### Rule 62.1: The Service Communication Strategy
-   **Law**: マイクロサービスアーキテクチャでは**AWS Cloud Map**でサービスディスカバリを実現し、サービス間通信には**VPC Lattice**（§2.7）または**ECS Service Connect**（§105）を使用してください。
-   **Action**:
    1.  **Cloud Map Namespaces**: Private DNS Namespace（VPC内部サービス）/HTTP Namespace（API Gatewayルーティング）を環境別に設計。論理的分離でdev/staging/prodを区別。
    2.  **Discovery Mode**: DNS方式（シンプルなIP解決・MULTIVALUEルーティング）とAPI方式（カスタム属性フィルタ・Blue/Greenデプロイ対応）を要件に応じ選択。
    3.  **ECS/EKS Integration**: ECSタスクのCloud Map自動登録・解除を利用。EKSではVPC CNIとKubernetes Service Discoveryの併用を検討。
    4.  **Service Mesh Selection**: サービスメッシュ機能が必要な場合、以下の選択基準に従う：
        -   **VPC Lattice（§2.7）**: ECS/EKS/Lambda/EC2混在のクロスVPC・クロスアカウント環境。サイドカー不要。
        -   **ECS Service Connect（§105）**: ECS単一環境の同一VPC内。Envoy自動デプロイ。
    5.  **Health Check Integration**: Route 53ヘルスチェック/カスタムヘルスチェックでトラフィックを正常インスタンスにのみルーティング。CloudWatchアラームで障害検知を自動化。
-   **⚠️ Deprecation Notice**: **AWS App Meshは2026年9月30日にEOL。** 新規採用禁止。既存ワークロードはVPC Lattice（EKS）またはECS Service Connect（ECS）へ移行を計画すること。

---

## 63. AWS Health イベント駆動運用 (Health Event-Driven Operations)

### Rule 63.1: The Health Automation Protocol
-   **Law**: **AWS Health Dashboard**と**EventBridge**を統合し、AWSサービスのヘルスイベントに対するプロアクティブな通知と自動修復を実現してください。
-   **Action**:
    1.  **EventBridge Integration**: AWS HealthイベントをEventBridgeルールでキャプチャ。サービス/リージョン/イベントタイプ/重要度でフィルタリング。
    2.  **Proactive Notifications**: SNS/Chatbot（Slack/Teams連携）でリアルタイム通知。Lambda経由でPagerDuty/ServiceNowとの自動連携。
    3.  **Organizational View**: AWS Organizations全体のヘルスイベントを一元集約。委任管理者アカウントで組織横断の健全性を可視化。
    4.  **Automated Remediation**: EventBridge→Lambda→Systems Manager Automationで自動修復パイプライン構築。EC2リタイアメント時の自動停止・起動、侵害されたアクセスキーの自動停止。
    5.  **Scheduled Change Planning**: 予定メンテナンス・更新イベントの事前検知と自動対応ワークフロー。変更影響範囲の自動評価とリソース調整。

---

## 64. データ主権・レジデンシー (Data Sovereignty & Residency)

### Rule 64.1: The Data Sovereignty Protocol
-   **Law**: データ主権・レジデンシー要件を満たすため、リージョン制御・データ境界ポリシー・不変ストレージを組み合わせてデータガバナンスを実現してください。
-   **Action**:
    1.  **Region Control**: Control Tower Guardrails/SCPで許可リージョンを限定。`aws:RequestedRegion`条件キーで未承認リージョンでのリソース作成を物理的に防止。
    2.  **Data Boundary Policy**: データ境界を3要素（信頼されたID/信頼されたリソース/期待されるネットワーク）で定義。SCP+RCP+VPCエンドポイントポリシーの組み合わせで実現。
    3.  **S3 Object Lock**: WORM（Write-Once-Read-Many）でデータ不変性を保証。Compliance Mode（rootでも変更不可）で規制要件に対応。Legal Hold で訴訟対応。
    4.  **GDPR / Data Act対応**: EUリージョン選択、データ分類、削除権（Right to Erasure）対応アーキテクチャ、暗号化（KMS CMK）、CloudTrail監査証跡。
    5.  **Sovereign Cloud**: AWS European Sovereign Cloud等の主権クラウドオプション。Local Zones/Outpostsでオンプレミス内データ主権を維持。

---

## 65. マイグレーション戦略 (Migration Strategy — 6Rs)

### Rule 65.1: The Migration Protocol
-   **Law**: **AWS Migration Hub**と**Application Migration Service (MGN)**を使用して体系的な6Rsマイグレーション戦略を実行してください。
-   **Action**:
    1.  **6Rs選定**: Rehost（そのまま移行）/Replatform（小修正移行）/Refactor（クラウドネイティブ再設計）/Repurchase（SaaS移行）/Retire（廃止）/Retain（保留）をアプリごとに選定。
    2.  **Discovery & Assessment**: Application Discovery ServiceでIT資産・依存関係を自動マッピング。Migration Evaluatorでコスト予測・ビジネスケース作成。
    3.  **Migration Factory**: Wave計画（5-10アプリ/Wave）で段階実行。低リスクアプリから開始。MGNでRehost自動化。IaC（CDK/Terraform）で Landing Zone構築。
    4.  **Minimal Viable Migration**: マイグレーションとモダナイゼーションを分離。まず移行完了→後からリアーキテクト。チェックポイント方式でリスク最小化。
    5.  **Post-Migration Optimization**: 移行後Compute Optimizer/Trusted Advisorでリソース最適化。CloudWatch/X-Rayでパフォーマンスベースライン作成。

---

## 66. ビジネスインテリジェンス (Business Intelligence — QuickSight)

### Rule 66.1: The BI Protocol
-   **Law**: **Amazon QuickSight**を使用してセキュアなBI/分析基盤を構築し、SPICE・RLS・埋め込み分析のベストプラクティスを適用してください。
-   **Action**:
    1.  **SPICE Optimization**: 頻繁アクセスデータにSPICE（インメモリエンジン）使用。ETL完了後にAPI経由のインクリメンタルリフレッシュ。Parquet/ORC変換と事前集約でデータ最適化。
    2.  **Row/Column-Level Security**: RLS（行レベルセキュリティ）でユーザー/グループ別データアクセス制御。CLS（列レベルセキュリティ）で機密カラムを制限。グループベース権限で管理スケール。
    3.  **Embedded Analytics**: QuickSight Embedding SDKでアプリケーションにダッシュボード埋め込み。SSO/匿名認証対応。マルチテナンシーにはNamespace分離。
    4.  **Q (Natural Language)**: SPICEデータセットベースの自然言語クエリ。Topicキュレーション（フィールド同義語・セマンティック型・既定集計）でQ精度を最適化。
    5.  **Cost Management**: Standard/Enterprise Editionの適切な選択。未使用ダッシュボードのアーカイブ。SPICEキャパシティ監視とコスト最適化。

---

## 67. マネージドファイル転送・ハイブリッドストレージ (Managed File Transfer & Hybrid Storage)

### Rule 67.1: The File Transfer & Hybrid Storage Protocol
-   **Law**: **AWS Transfer Family**と**Storage Gateway**を使用してセキュアなファイル転送とハイブリッドストレージを実現してください。
-   **Action**:
    1.  **Transfer Family**: SFTP/FTPS/FTPプロトコルでS3/EFSへの直接ファイル転送。VPCエンドポイント+セキュリティグループでアクセス制限。LDAP/AD/カスタムIDプロバイダ認証。
    2.  **File Gateway**: NFS/SMBプロトコルでオンプレミスからS3に透過アクセス。ローカルキャッシュ（150GB以上推奨）で頻繁アクセスデータの低レイテンシ。S3ライフサイクル連携。
    3.  **Tape Gateway**: 仮想テープライブラリ（VTL）でバックアップをGlacier/Deep Archiveにアーカイブ。既存バックアップソフトウェアとiSCSI互換。
    4.  **Volume Gateway**: Cached Volumes（S3上データ+ローカルキャッシュ）/Stored Volumes（ローカル全量データ+S3スナップショット）の使い分け。DR用EBSスナップショット復元。
    5.  **Performance**: Direct Connect/VPN経由の専用帯域確保。キャッシュディスクの並列化でスループット最適化。CloudWatchでキャッシュヒット率監視。

---

## 68. 高度なOrganizationsポリシー制御 (Advanced Organizations Policy Controls)

### Rule 68.1: The SCP & RCP Protocol
-   **Law**: **Service Control Policies (SCP)**と**Resource Control Policies (RCP)**を組み合わせて、組織全体の予防的セキュリティ制御を実現してください。
-   **Action**:
    1.  **Deny-List Strategy**: FullAWSAccess SCPを維持し、明示的Deny SCPを段階追加。リージョン制限（`aws:RequestedRegion`）・セキュリティツール保護（CloudTrail/Config/GuardDuty無効化禁止）を最優先実装。
    2.  **Resource Control Policies (RCP)**: SCPの補完としてリソースベース制御を実施。信頼されたIDのみリソースアクセス可能。HTTPS強制・信頼されたIDプロバイダ制限。データ境界確立。
    3.  **OU階層設計**: 機能・コンプライアンス要件ベースのOU構造。上位OUに広範ポリシー→下位OUに厳格ポリシー。本番/高リスクOUに追加制約。
    4.  **Permission Boundaries**: IAMユーザー/ロール単位の最大権限制限。開発者に権限付きロール作成を委任しつつ、Permission Boundaryで昇格を防止。
    5.  **Testing & Versioning**: 新SCPは隔離OUで必ず事前テスト。SCP JSONをGitでバージョン管理。CloudTrailでDenyアクションを監視しポリシー調整。

---

## 69. キャパシティプランニング・フリート管理 (Capacity Planning & Fleet Management)

### Rule 69.1: The Capacity Planning Protocol
-   **Law**: **Predictive Scaling**・**Capacity Reservations**・**Warm Pools**を活用し、先読みキャパシティプランニングとコスト最適化を両立してください。
-   **Action**:
    1.  **Predictive Scaling**: ML分析で履歴トラフィックから将来需要を予測。トラフィックスパイク前にキャパシティを事前確保。「Forecast Only」モードで予測精度を事前検証（14日間の履歴推奨）。
    2.  **On-Demand Capacity Reservations**: クリティカルワークロード用に特定AZ・インスタンスタイプの容量を確保。InsufficientInstanceCapacityエラーを物理的に防止。Split/Move/Modify機能で柔軟運用。
    3.  **Warm Pools**: 初期化に時間がかかるアプリケーション用にプリウォーミングインスタンスプールを維持。Stopped/Running状態の使い分け（コスト対起動速度のトレードオフ）。
    4.  **Lifecycle Hooks**: スケールアウト/イン時のカスタムアクション（ソフトウェアインストール/ログ退避/グレースフルシャットダウン）。タイムアウト設定とエラーハンドリング。
    5.  **Mixed Instance Policy**: ASGで複数インスタンスタイプ/購入オプション（On-Demand/Spot/Savings Plans）を混合。Graviton移行機会の継続評価。

---

## 70. EKS高度運用 (Advanced EKS Operations)

### Rule 70.1: The Advanced EKS Protocol
-   **Law**: **Amazon EKS**のプロダクション運用では、EKS Auto Mode / Karpenter・Pod Security Standards・Network Policy・EKS Pod Identityを組み合わせたクラウドネイティブセキュリティとコスト最適化を実現してください。
-   **Action**:
    1.  **Karpenter / EKS Auto Mode（§3.3参照）**: EKS Auto Mode（推奨）またはKarpenterでジャストインタイムノードプロビジョニング。Pod要件に基づく最適インスタンス自動選択。Spot+Graviton多様化でコスト30-40%削減。Consolidation機能で未使用リソース自動回収。
    2.  **Pod Security Standards (PSS)**: Privileged/Baseline/Restrictedの3レベルをNamespace単位で適用。PSA（Pod Security Admission）で強制。Restrictedレベルでrootユーザー実行を禁止。
    3.  **Network Policies**: VPC CNI v1.14+でネイティブNetwork Policy実施。Default-Denyからの明示的Allow。Security Groups for Podsとの多層防御。
    4.  **EKS Pod Identity（推奨）**: **EKS Pod Identity**をIRSAの後継として新規クラスターでは標準採用。以下のメリットにより、大規模環境での運用を大幅に簡素化。
        -   **OIDC不要**: クラスターごとのOIDCプロバイダ設定が不要。EKSがTrust関係を自動管理。
        -   **ABAC対応**: IAMロールセッションタグをサポートし、属性ベースのアクセス制御（ABAC）が実現可能（IRSAでは不可）。
        -   **クロスアカウント簡素化**: IAMロールチェーンにより、クラスターアカウントのPod Identityロールから他アカウントのロールを直接Assume可能。
        -   **移行**: IRSA → Pod Identityは非破壊的に共存可能。Pod Identity Agentアドオンをインストールし、既存Trust PolicyにPod Identityプリンシパルを追加後、段階的に移行。
    5.  **IRSA（レガシー環境）**: EKS Anywhere・Self-Managed K8sなどPod Identity非対応環境ではIRSAを継続使用。Trust PolicyでNamespace/SA限定。CloudTrailでIRSA使用監査。
    6.  **Managed Node Groups + Add-ons**: ローリングアップデート対応のマネージドノードグループ。VPC CNI/CoreDNS/kube-proxyのマネージドアドオン。GuardDutyランタイム保護。

---

## 71. ElastiCache高度運用 (Advanced ElastiCache Operations)

### Rule 71.1: The Advanced ElastiCache Protocol
-   **Law**: **Amazon ElastiCache** (Redis/Valkey) のプロダクション運用では、Cluster Mode・Serverless・Global Datastore・暗号化のベストプラクティスを適用してください。
-   **Action**:
    1.  **Cluster Mode Enabled**: 水平スケーリングでストレージ/スループット拡張。クラスタ対応クライアント使用。Configuration Endpoint経由の自動ルーティング。
    2.  **Valkey Serverless**: キャパシティプランニング不要の自動スケーリング。コスト最大33%削減・メモリ40%削減。TLS常時有効。サブミリ秒レイテンシ。
    3.  **Eviction & TTL**: `allkeys-lru`をデフォルト推奨。TTLにランダムジッターを付与しThundering Herd防止。メモリ使用率60-80%を維持。高頻度Eviction時はスケールアウト。
    4.  **Encryption & Auth**: At-Rest暗号化（KMS）+In-Transit暗号化（TLS）を同時有効化。AUTH Token でアクセス制御。作成時に暗号化設定。
    5.  **Global Datastore**: クロスリージョン非同期レプリケーション。低レイテンシローカル読取+DR。セカンダリリージョンはRead-Only。定期的なフェイルオーバーテスト。

---

## 72. WAF・DDoS高度防御 (Advanced WAF & DDoS Protection)

### Rule 72.1: The Advanced WAF Protocol
-   **Law**: **AWS WAF**と**Shield Advanced**を組み合わせ、Bot対策・アカウント乗っ取り防止・カスタムルール・レート制限の多層防御を実現してください。
-   **Action**:
    1.  **Managed Rule Groups**: AWS Managed Rules（OWASP Top 10対応）をCount Modeで検証後Block Modeに移行。自動更新で最新脅威対応。
    2.  **Bot Control & ATP**: Bot Control でボットトラフィック可視化・制御。Account Takeover Prevention (ATP) で認証情報スタッフィング防止。JavaScript SDK でサイレントチャレンジ。
    3.  **Rate-Based Rules**: 全体のブランケットレート制限＋ログイン/APIエンドポイントの厳格制限。5分ウィンドウでIPベース追跡。Athenaログ分析で適切な閾値決定。
    4.  **Logging & Analysis**: S3/CloudWatch Logs/Kinesis Firehoseへのログ出力。フィールドリダクションで機密情報フィルタ。CloudWatchアラームで異常パターン検知。
    5.  **Shield Advanced**: **AI駆動予測型DDoS防御**（2025年〜）で攻撃パターンをMLで分析し、攻撃発生前にプロアクティブな緩和措置を実行。L7 DDoS自動緩和。DRT（DDoS Response Team）24/7アクセス。Anti-DDoS Managed Rule GroupをWeb ACL上位に配置。WAF料金Shield包含。

---

## 73. EventBridge高度統合 (Advanced EventBridge — Pipes & Scheduler)

### Rule 73.1: The EventBridge Pipes & Scheduler Protocol
-   **Law**: **EventBridge Pipes**でポイントツーポイント統合を簡素化し、**EventBridge Scheduler**でタスクスケジューリングを管理してください。
-   **Action**:
    1.  **Pipes**: SQS/Kinesis/DynamoDB StreamsからLambda/Step Functions/SNS/SQS等へのポイントツーポイント統合。グルーコード（Lambda）の削減。
    2.  **Filtering**: Pipe内でイベントフィルタリングを実施し、不要イベントの下流転送を防止。コスト削減とリソース効率化。Enrichment前にフィルタ適用。
    3.  **Enrichment**: Lambda/Step Functions/API GatewayでイベントデータをEnrich。サードパーティAPI連携・レガシーシステム統合。DLQ+リトライポリシーでエラーハンドリング。
    4.  **Scheduler**: Cron/Rate式+ワンタイムスケジュール。200+AWSサービス・6000+ API をネイティブ呼出し。リトライポリシー+DLQ。UTC基準の明示的タイムゾーン設定。
    5.  **Cost Optimization**: Pay-per-invocation。高頻度スケジュールをSQS/SNS経由バッチ処理に統合。Pipes+Step Functionsで複雑なワークフローオーケストレーション。

---

## 74. コスト異常検知 (Cost Anomaly Detection)

### Rule 74.1: The Cost Anomaly Detection Protocol
-   **Law**: **AWS Cost Anomaly Detection**を使用してMLベースのコスト異常検知と自動通知を実現してください。
-   **Action**:
    1.  **Monitor Types**: 全AWSサービス監視（デフォルト）/リンクアカウント別/コストカテゴリ別/コスト配分タグ別のモニター設定。新サービス自動追跡。
    2.  **Alert Configuration**: 保守的な閾値から開始し段階調整。金額ベース（$50超等）/パーセンテージベースの閾値。個別/日次/週次のアラート頻度設定。
    3.  **Root Cause Analysis**: サービス・使用タイプ・アカウント別の原因特定。最大コスト要因の優先調査。計画/非計画支出の切り分け。
    4.  **SNS/Chatbot Integration**: SNS通知+AWS Chatbot（Slack/Chime連携）でリアルタイムアラート。チームチャネルへの即座配信。
    5.  **Budget連携**: AWS Budgetsと補完的運用。Anomaly Detectionで予期しない逸脱を検知→Budgetsで上限管理。過去パターンから正確な予算予測。

---

## 75. Well-Architected レビュー自動化 (Well-Architected Review Automation)

### Rule 75.1: The WA Review Automation Protocol
-   **Law**: **AWS Well-Architected Tool**のレビュープロセスを自動化し、Custom Lens・Milestone・Trusted Advisor統合で継続的なアーキテクチャ改善を実施してください。
-   **Action**:
    1.  **Custom Lenses**: 組織固有のベストプラクティス・コンプライアンス要件をカスタムレンズとして定義。JSON テンプレートで作成。AWS アカウント間共有で標準化。
    2.  **Milestones**: 初回レビュー完了時+改善実施後にマイルストーン保存。経時的な進捗追跡と改善効果測定。
    3.  **Improvement Plan**: HRI/MRI（High/Medium Risk Issues）の識別・優先度付け。セキュリティ/信頼性を最優先、次にクイックウィン。オーナー・タイムライン・成功基準の定義。
    4.  **Trusted Advisor Integration**: Trusted Advisorチェック結果をWAレビューに自動マッピング。コスト/パフォーマンス/セキュリティ/耐障害性の統合ビュー。四半期レビュー推奨。
    5.  **CI/CD Integration**: ガバナンスをコード化。CI/CDパイプラインでWAチェックを自動実行。AI支援のセキュリティレビューと自己進化アーキテクチャ。

---

## 76. Secrets Manager高度運用 (Advanced Secrets Manager Operations)

### Rule 76.1: The Secrets Manager Protocol
-   **Law**: **AWS Secrets Manager**の自動ローテーション・マルチリージョン秘密情報・クロスアカウント共有・キャッシュSDKを活用して、安全な秘密情報管理を実現してください。
-   **Action**:
    1.  **Automatic Rotation**: Lambda関数による4ステップローテーション（createSecret→setSecret→testSecret→finishSecret）。AWSCURRENT/AWSPENDING/AWPREVIOUSのステージングラベル管理。デュアルシークレット（A/Bパターン）でゼロダウンタイム。
    2.  **Multi-Region Secrets**: 自動同期されるマルチリージョンレプリカ。リージョン別KMSキー。レプリカは独自ARNを持ち、プライマリリージョン障害時も独立稼働。
    3.  **Cross-Account Sharing**: リソースベースポリシーでクロスアカウント読取許可。カスタマー管理KMSキー必須（デフォルト`aws/secretsmanager`キーは不可）。コンシューマ側キャッシュでAPI呼出削減。
    4.  **Caching SDK**: AWS SDK Cachingコンポーネント（Java/Python/.NET/Go/Rust）でクライアント側キャッシュ。Lambda Extension でSecrets/Parametersキャッシュ。TTL 5分でローテーション時の迅速な切替。
    5.  **Monitoring & Lifecycle**: ローテーション失敗アラートの設定。秘密情報バージョニングとロールバック機能。削除時のリカバリウィンドウ設定。

---

## 77. CloudWatch高度オブザーバビリティ (Advanced CloudWatch — Synthetics & RUM)

### Rule 77.1: The Synthetics & RUM Protocol
-   **Law**: **CloudWatch Synthetics**（合成監視）と**CloudWatch RUM**（リアルユーザ監視）を組み合わせ、プロアクティブ＋リアクティブの完全オブザーバビリティを実現してください。
-   **Action**:
    1.  **Synthetics Canaries**: APIエンドポイントとUIワークフローの合成監視。CI/CDからカナリーテスト自動デプロイ。マルチリージョンデプロイで地域差検出。クリティカルは5分間隔、低優先は15分間隔。
    2.  **RUM (Real User Monitoring)**: Core Web Vitals（LCP/FID/CLS/INP）のリアルユーザ監視。サンプリングレートでデータ収集コスト制御。JavaScript エラー・HTTPエラーの追跡。
    3.  **Application Signals**: サービス間依存関係の自動発見。SLO定義とビジネスインパクト監視。OpenTelemetry基盤のメトリクス/ログ/トレース統合ビュー。
    4.  **Security**: カナリー構成の暗号化（HTTPS）。機密情報はSecrets Manager管理。ログのマスキング。IAM最小権限ロール。
    5.  **X-Ray Integration**: カナリー＋RUMのトレースをX-Rayに統合。エンドツーエンドのリクエスト追跡とボトルネック特定。Performance Insightsとの連携。

---

## 78. S3高度ストレージ最適化 (Advanced S3 Storage Optimization)

### Rule 78.1: The Advanced S3 Protocol
-   **Law**: **Intelligent-Tiering**・**Access Points**・**Express One Zone**・**Storage Lens**を活用し、コスト・パフォーマンス・セキュリティの3軸でS3を最適化してください。
-   **Action**:
    1.  **Intelligent-Tiering**: アクセスパターン未知/変動データのデフォルトストレージクラス。30日→IA、90日→Archive Instant Accessの自動階層移行。128KB未満は監視費用免除。
    2.  **Access Points**: バケット単位のカスタムネットワークエンドポイント。VPC Endpoint連携でプライベートアクセス。データ感度に基づく粒度の細かいアクセスポリシー。命名規則による管理性向上。
    3.  **Multi-Region Access Points (MRAP)**: 単一グローバルエンドポイントで最近接バケットへルーティング。Cross-Region Replication+バージョニング必須。PrivateLink経由のプライベート接続。
    4.  **Express One Zone**: AI/ML・HPC・分析向け単一ディジットmsレイテンシ。コンピュートと同一AZに配置。APIコスト50%削減。明示的バックアップ戦略（単一AZリスク）。
    5.  **Storage Lens & Lifecycle**: 60+メトリクスでストレージ使用状況可視化。コールドバケット特定・バージョン管理・低コスト階層移行機会の発掘。ライフサイクルルールの定期見直し。
    6.  **50TBオブジェクト対応（2025年12月GA）**: S3の最大オブジェクトサイズが**5TB→50TB**に10倍拡大。高解像度動画・地震データ・AI学習データセット等の大規模ファイルを分割なしで格納可能。AWS Common Runtime（CRT）およびS3 Transfer Managerでアップロード/ダウンロードパフォーマンスを最適化。全ストレージクラス・全S3機能と互換。
    7.  **Batch Operations 10x高速化（2025年12月GA）**: S3 Batch Operationsが**最大10倍高速化**。200億オブジェクト規模のジョブを追加設定・追加コストなしで高速処理。大規模タグ操作・オブジェクトコピー・チェックサム計算・ライフサイクルタグ管理に適用。完了レポートの生成も高速化。

---

## 79. Lambda高度最適化 (Advanced Lambda Optimization)

### Rule 79.1: The Advanced Lambda Protocol
-   **Law**: **SnapStart**・**Powertools**・**Graviton (ARM64)**・**ESMイベントフィルタリング**を活用し、Lambda のパフォーマンス最適化とコスト削減を実現してください。
-   **Action**:
    1.  **SnapStart**: Java/Python/.NETのコールドスタートをスナップショットで大幅削減。初期化フェーズに重い処理を集約。Restoreフックで安全な状態再初期化。Provisioned Concurrencyとは併用不可。
    2.  **Powertools & Layers**: 構造化ログ/メトリクス/トレース/冪等性ユーティリティ。共通ライブラリのLayer化。レイヤーバージョニングとセキュリティスキャン。関数あたり最大5レイヤー。
    3.  **Graviton (ARM64)**: 20%コスト削減+20%パフォーマンス向上。エイリアス加重ルーティングで段階移行。ネイティブ依存がある場合はARM64再ビルド。最新世代Graviton（Graviton4/5ベース）の対応状況を継続監視。
    4.  **ESM Event Filtering**: SQS/Kinesis/DynamoDB StreamsのPipe内フィルタリングでコスト92%削減可能。バッチサイズ/ウィンドウの最適化。DLQ必須設定。
    5.  **Cold Start Prevention**: デプロイパッケージ5MB未満目標。Tree shakingと未使用依存削除。メモリ512MB-1GBでCPU比例割当。VPC使用時はRDS Proxy活用。

---

## 80. RDS Proxy・Aurora Serverless v2 (Advanced Database Proxying & Serverless RDS)

### Rule 80.1: The RDS Proxy & Aurora Serverless v2 Protocol
-   **Law**: **RDS Proxy**で接続効率化とフェイルオーバー高速化を実現し、**Aurora Serverless v2**でACUベースの自動スケーリングを活用してください。
-   **Action**:
    1.  **Connection Pooling**: RDS Proxyによるコネクション多重化・借用・ピニング管理。`MaxConnectionsPercent`/`MaxIdleConnectionsPercent`の適切な設定。同一VPC内配置必須。
    2.  **IAM Authentication**: IAM認証+Secrets Manager連携でEndtoEndセキュアアクセス。`rds-db:connect`権限の最小権限IAMロール。
    3.  **Aurora Serverless v2 ACU**: 0.5-256 ACU自動スケーリング。Auto-Pause（0 ACU）で開発環境コスト最小化。本番は最小2 ACU以上推奨。CloudWatchの`ServerlessDatabaseCapacity`/`ACUUtilization`監視。
    4.  **Read Replicas**: 最大15リードレプリカ。Promotion Tier 0-1は高最小容量でフェイルオーバー高速化。Tier 2-15は独立スケーリング。`ReplicaLag`監視。
    5.  **Failover Optimization**: RDS Proxyでフェイルオーバー時間66%削減。DNS伝播遅延・ローカルDNSキャッシュ問題の排除。アプリケーション側リトライロジック+短接続タイムアウト。

---

## 81. Config高度ガバナンス (Advanced Config Governance — Conformance Packs)

### Rule 81.1: The Config Conformance Packs Protocol
-   **Law**: **AWS Config Conformance Packs**と**Config Aggregators**を使用して、組織横断のコンプライアンス監視と自動修復を実現してください。
-   **Action**:
    1.  **Conformance Packs**: AWS Managed Rules+カスタムルールをバンドル。RDK（Rule Development Kit）でカスタムルール開発。Organizations全体への一括デプロイ。新規アカウント自動適用。
    2.  **Remediation Actions**: SSM Automation/Lambda による自動修復。手動修復から段階的に自動化。修復アクションの事前テスト必須。
    3.  **Config Aggregators**: マルチアカウント・マルチリージョンのコンプライアンスデータ集約。委任管理者アカウントでの運用推奨。Advanced Queriesで柔軟な分析。
    4.  **Compliance Reporting**: コンプライアンスダッシュボードでHRI/MRI可視化。CloudTrailとの組合せで「何が」「誰が」変更したかの完全監査証跡。
    5.  **IaC Integration**: CloudFormationでConformance Packs定義。コンプライアンスフレームワークのコード化。CI/CDパイプラインでの自動エビデンス収集。

---

## 82. Nitro Enclaves・Confidential Computing

### Rule 82.1: The Confidential Computing Protocol
-   **Law**: **AWS Nitro Enclaves**を使用して、機密データ処理（PII/金融/医療）をハードウェア分離環境で実行し、Attestation+KMS連携で暗号学的な信頼性を保証してください。
-   **Action**:
    1.  **Enclave Isolation**: Nitro Systemによるハードウェア分離。永続ストレージなし・外部ネットワークなし・SSH/SSMアクセス不可。vsockのみの通信チャネル。
    2.  **Attestation + KMS**: PCRベースのKMSポリシーで認証済みEnclaveコードのみにキー公開。Attestation Documentでコード整合性検証。リプレイ攻撃防止のnonce。
    3.  **PII Tokenization**: Enclave内で暗号化データを復号→トークン化→トークンのみ親インスタンスに返却。平文データがEnclaveを離脱しない設計。
    4.  **EIF Management**: Enclave Image Fileを最小限に保つ。再現可能ビルドでサプライチェーンセキュリティ。依存関係をEIF内に事前パッケージ。
    5.  **Operational Security**: 親EC2インスタンスの最小権限IAM・VPC・暗号化。Enclaveヘルスの継続監視。CloudTrailでKMS API呼出監査。

---

## 83. Amazon Connectコンタクトセンター (Contact Center)

### Rule 83.1: The Contact Center Protocol
-   **Law**: **Amazon Connect**でオムニチャネルコンタクトセンターを構築し、AI/生成AI活用・フロー設計・品質管理のベストプラクティスを適用してください。
-   **Action**:
    1.  **Omnichannel**: 音声/チャット/Email/SMS/WhatsApp統合プラットフォーム。チャネル間のコンテキスト維持。Amazon Q in Connectで生成AIアシスト。
    2.  **IVR Flow Design**: Amazon Lex統合でNLU会話。Lambda連携で動的バックエンド統合（注文状況/決済）。モジュラーフロー設計。
    3.  **Routing Profiles**: スキルベースルーティング。キュー優先度/遅延設定による負荷分散。Lambda動的ルーティングで外部ビジネスロジック連携。
    4.  **Contact Lens**: リアルタイム＋履歴の統合分析ダッシュボード。感情分析・会話分析。粒度の細いアクセス制御で録音/トランスクリプト保護。
    5.  **Quality Management**: 自動品質管理（AQM）でML評価。ワークフォース管理（予測/キャパシティ/スケジューリング）。Agent Workspaceのペルソナベースカスタマイズ。

---

## 84. IoT Core・Greengrass (IoT & Edge Computing)

### Rule 84.1: The IoT Protocol
-   **Law**: **AWS IoT Core**でデバイス接続・管理を行い、**IoT Greengrass**でエッジコンピューティングを実現し、セキュリティ・フリート管理・OTA更新のベストプラクティスを適用してください。
-   **Action**:
    1.  **Device Provisioning**: デバイスごと固有X.509証明書。Fleet Provisioning（claim/trusted user）で大規模自動登録。JITR/JITPで初回接続時自動登録。
    2.  **Fleet Management**: Thing Groups（静的/動的）でデバイス論理グループ化。IoT Device Defenderで異常行動検知と自動緩和。フリートインデキシングで動的グループ自動更新。
    3.  **Edge Computing (Greengrass)**: Lambda/Docker実行でローカル処理・低レイテンシ・帯域削減。エッジMLモデルでリアルタイム推論。コンポーネントベースアーキテクチャ。
    4.  **MQTT Topics**: data/cmd プレフィックスでデータ/コマンド分離。小文字・ハイフン・Thing Name含有の命名規則。Rules Engine連携でメッセージ処理パイプライン。
    5.  **Security & OTA**: mTLS必須。最小権限ポリシー。コードサイニングで改竄防止。段階的ロールアウト+ロールバック機能。証明書ライフサイクル管理。

---

## 85. Timestreamタイムシリーズデータベース (Time Series Database)

### Rule 85.1: The Timestream Protocol
-   **Law**: **Amazon Timestream**を使用して、IoTテレメトリ・運用メトリクスの時系列データを効率的に格納・クエリし、コスト最適化を実現してください。
-   **Action**:
    1.  **Memory/Magnetic Store**: Memory Store（高速）→ Magnetic Store（低コスト）の2層自動階層化。Memory保持期間は最小限に設定。Magnetic超過データはS3 Parquetエクスポート。
    2.  **Scheduled Queries**: 頻繁にアクセスする集計結果を事前マテリアライズ。クエリコスト・レイテンシの大幅削減。ダッシュボード/レポート向け最適化。
    3.  **Schema Design**: Multi-Measure Recordsで関連メジャーをグループ化（書込削減・コスト最適化）。Dimensionでフィルタリング/グルーピング用メタデータ管理。
    4.  **Cost Optimization**: `SELECT *`を避け必要カラムのみクエリ（スキャンバイト課金）。適切なRetention設定。Scheduled Queriesでリアルタイム集計コスト削減。
    5.  **Integration**: IoT Core直接連携。Grafana/QuickSightダッシュボード。Lambda/Kinesis経由のデータ投入パイプライン。

---

## 86. Resilience Hub・FIS深化 (Advanced Resilience Testing)

### Rule 86.1: The Advanced Resilience Protocol
-   **Law**: **AWS Resilience Hub**のレジリエンスポリシー評価と**Fault Injection Service (FIS)**のカオス実験を組み合わせ、RTO/RPOの検証と継続的レジリエンス改善を実施してください。
-   **Action**:
    1.  **Resilience Policy**: アプリケーション単位でRTO/RPO目標をインフラ/AZ/リージョン別に定義。定期評価で推奨構成・アラーム・テスト・SOP自動生成。
    2.  **FIS Experiments**: SSM連携でカスタム障害注入。CloudWatchアラームのStop Conditions。小規模実験から段階拡大。CI/CDへのFIS統合。
    3.  **Serverless/GenAI Testing**: Lambda開始遅延/呼出エラー注入。GenAIワークロードの接続障害・AZ電源喪失シミュレーション。
    4.  **Gameday Testing**: 本番レプリカ環境での組織横断演習。EC2停止/AZ障害/ネットワーク障害シナリオ。インシデントレスポンスプレイブック検証。
    5.  **Graceful Degradation**: キュー（SQS）+DLQ非同期処理。キャッシュコンテンツ提供。フォールバックメッセージ。部分稼働設計。

---

## 87. Verified Permissions・Cedar認可 (Fine-Grained Authorization)

### Rule 87.1: The Verified Permissions Protocol
-   **Law**: **Amazon Verified Permissions**と**Cedar ポリシー言語**を使用して、アプリケーションレベルのきめ細かい認可（RBAC+ABAC）をコード外部化し、一元管理してください。
-   **Action**:
    1.  **Cedar Policy Design**: Default-Denyベース。`forbid`が`permit`より優先。最小権限原則。ビジネスドメインアクション定義（`CreateSupportCase`等）。
    2.  **Schema Definition**: Entity Types・Attributes・Action階層をスキーマで定義。ポリシーのスキーマバリデーション。デプロイ前のCedar Playgroundテスト。
    3.  **RBAC + ABAC Hybrid**: Principal Groupsでロール管理+ポリシー条件でAttribute制御。`resource.team == principal.department`等の動的条件。
    4.  **Entity Security**: UUID等の不変IDで全Principal/Resource識別。エンティティ階層（ユーザー→グループ、リソース→コレクション）の`in`演算子活用。
    5.  **API Integration**: OpenAPIスキーマからCedarスキーマ自動生成。マイクロサービス横断の一貫した認可。CloudTrail監査ログ。CI/CDでポリシーバリデーション。

---

## 88. Clean Roomsプライバシー保護データ連携 (Privacy-Preserving Data Collaboration)

### Rule 88.1: The Clean Rooms Protocol
-   **Law**: **AWS Clean Rooms**を使用して、生データを共有せずに複数組織間でのセキュアなデータ分析を実現してください。差分プライバシーと暗号化コンピューティングを適用してください。
-   **Action**:
    1.  **Analysis Rules**: Configured Tableごとに集計/リスト/カスタムの分析ルール定義。必要カラム・関数のみ許可。集約制約（最小25-100ユニークID）で再識別防止。
    2.  **C3R (Cryptographic Computing)**: Fingerprint列（JOIN用）+Sealed列（SELECT用）で暗号化データのまま分析。共有暗号鍵による両者のJoin列暗号化。
    3.  **Differential Privacy**: 差分プライバシーでクエリ結果にキャリブレートされたノイズ注入。プライバシーバジェット管理。安全でないJOINのブロック。
    4.  **ML Privacy-Enhanced Training**: **Clean Rooms ML**（2025年〜）でプライバシーを保護しながらMLモデルの共同学習を実施。生データを共有せずに、共同データセットからのモデルトレーニングとlookalike segmentの生成が可能。
    5.  **Collaboration Management**: コラボレーション作成→招待→承認フロー。デューデリジェンス実施。合成データでの事前テスト。クエリログ定期レビュー。
    6.  **Security**: KMSによる結果暗号化。TLS通信。ハッシュ化ID使用(生メール/電話番号を直接使用しない)。PySpark/ML拡張分析。

---

## 89. MemoryDB耐久性インメモリデータベース (Durable In-Memory Database)

### Rule 89.1: The MemoryDB Protocol
-   **Law**: **Amazon MemoryDB**をマイクロ秒読取レイテンシ＋耐久性が必要なワークロード（セッション/リアルタイム分析/リーダーボード/決済）のプライマリDBとして活用してください。
-   **Action**:
    1.  **Durability**: 分散トランザクショナルログでマルチAZ耐久書込。全書込はAZ横断で永続化後にACK。ノード/クラスタ/AZ障害からの復旧保証。
    2.  **Multi-AZ & HA**: 最低2AZにVPCサブネット配置。高速フェイルオーバー。スナップショットによるリカバリ。
    3.  **Performance**: マイクロ秒読取/ミリ秒単位書込レイテンシ。Enhanced I/O Multiplexing (v7.0+)で読取スループット3x向上。Data Tiering でSSD活用コスト最適化。
    4.  **Scaling**: 水平スケーリング（シャード/レプリカ追加）+垂直スケーリング（ノードタイプ変更）。オンライン垂直スケーリングで最小ダウンタイム。
    5.  **Security**: TLS暗号化通信+KMS暗号化保存。ACL+IAM認証。セキュリティグループでポート6379のアクセス制限。

---

## 90. IaC高度化 — SAM・CDK (Advanced IaC — SAM & CDK)

### Rule 90.1: The Advanced IaC Protocol
-   **Law**: **SAM**でサーバーレスアプリケーションを効率的に開発し、**CDK**でL1/L2/L3 Constructsを活用した再利用可能なインフラコード化を実現してください。**Application Composer**でビジュアル設計を活用してください。
-   **Action**:
    1.  **Application Composer**: ドラッグ&ドロップでサーバーレスアーキテクチャ視覚設計。SAM/CloudFormationテンプレート自動生成。VS Code拡張統合。AI支援構成提案。
    2.  **SAM Best Practices**: SAM CLIでローカルテスト+SAM Accelerateで高速反復。マイクロサービス・イベント駆動設計。API Gateway統合。コールドスタート最適化。
    3.  **CDK Constructs**: L1（Raw CloudFormation）→L2（合理的デフォルト）→L3（パターン全体）の適切な使い分け。再利用可能なConstruct設計。cdk-nagでセキュリティガードレール。
    4.  **Anti-Patterns**: ハードコード名の回避（マルチ環境デプロイ不可）。Statefulリソースの論理ID変更禁止（データ損失）。同一ライフサイクルリソースの単一スタック配置。
    5.  **Policy as Code**: CI/CDパイプラインでのポリシーチェック自動化。セキュリティ・コンプライアンスをコード化。スナップショット/ユニットテスト。

---

## 91. DataZoneデータメッシュガバナンス (Data Mesh Governance)

### Rule 91.1: The DataZone Protocol
-   **Law**: **Amazon DataZone**を使用して、データメッシュアーキテクチャによる分散データ所有権・データプロダクト管理・セルフサービスデータ発見を実現してください。
-   **Action**:
    1.  **Domain-Oriented Ownership**: ビジネスドメイン（財務/マーケティング/HR等）旧位のデータ所有権。フェデレーテッドコンピューテーショナルガバナンス。ドメイン自律性とグローバル可視性のバランス。
    2.  **Data Products**: セマンティックレイヤーを持つコヒーシブなデータプロダクト定義。自動メタデータ生成。プロダクトレベルのアクセス制御/メタデータ管理。
    3.  **Catalog & Discovery**: 統合データカタログでビジネスグロッサリー+メタデータフォーム。技術メタデータ+ビジネスコンテキスト。セルフサービス検索。
    4.  **Publish/Subscribe**: データプロダクトの公開→発見→サブスクリプションの管理ワークフロー。メタデータルールによる公開標準強制。カスタム承認ワークフロー。
    5.  **IAM Integration**: IAM/外部IdP認証。データポータルでのセルフサービスアクセス。粒度の細いアクセスポリシー。

---

## 92. PrivateLink深化 (Advanced PrivateLink & VPC Endpoints)

### Rule 92.1: The Advanced PrivateLink Protocol
-   **Law**: **AWS PrivateLink**のInterface/Gateway Endpointsを適切に使い分け、クロスアカウント・クロスリージョンのプライベート接続を実現し、ゼロトラストネットワークの基盤としてください。
-   **Action**:
    1.  **Endpoint Types**: Interface Endpoints（PrivateLink対応サービス）vs Gateway Endpoints（S3/DynamoDB無料）の使い分け。コスト・機能・要件に基づく選択。
    2.  **HA & Security**: 最低2AZにEndpoint配置。セキュリティグループで最小権限（HTTPS 443のみ等）。Endpoint Policyで利用可能Principalを制限。
    3.  **Cross-Account**: NLBベースのEndpoint Service公開。接続承認要求（acceptance-required）。SCP でPrivateLinkサービス接続制御。最小権限アクセス。
    4.  **Cross-Region**: ネイティブクロスリージョン接続（VPCピアリング不要）。AWSグローバルバックボーン経由。`vpce:AllowMultiRegion`ポリシー。
    5.  **DNS & Monitoring**: リージョナルDNS名使用（ラウンドロビン）。Private DNS有効化。VPC Flow Logsで不審なトラフィック検出。

---

## 93. Bedrock Guardrails — 責任あるAI (Responsible AI Guardrails)

### Rule 93.1: The Bedrock Guardrails Protocol
-   **Law**: **Amazon Bedrock Guardrails**を使用して、生成AIアプリケーションのコンテンツフィルタリング・PII保護・トピック制限・幻覚防止・プロンプト攻撃防御を実現してください。
-   **Action**:
    1.  **Content Filtering**: ヘイトスピーチ/侮辱/性的/暴力/不正行為カテゴリの検出・ブロック。フィルタ強度（LOW/MEDIUM/HIGH）設定。マルチモーダル毒性検出（画像対応）。60+言語対応。
    2.  **PII Redaction**: 30+種類のPII自動検出・マスキング（`{NAME}`等の置換）。カスタム正規表現でプロジェクト固有パターン対応。入力/出力両方でフィルタリング。
    3.  **Topic Denial**: アプリケーション範囲外トピックの定義・ブロック。ドメイン外回答防止（例：銀行チャットボットの医療アドバイス拒否）。
    4.  **Grounding Checks**: RAG応答の事実正確性検証。Grounding（ソース準拠）+ Relevance（クエリ関連性）スコア。信頼度閾値設定。幻覚75%+フィルタリング。
    5.  **Prompt Attack Prevention**: プロンプトインジェクション/ジェイルブレイク/プロンプトリーケージ検出・ブロック。Detect Mode での事前テスト。バージョン管理。反復的な改善。

---

## 94. Network Firewall IPS/IDS (Advanced Network Protection)

### Rule 94.1: The Network Firewall Protocol
-   **Law**: **AWS Network Firewall**を使用してVPCのステートフルインスペクション・IPS/IDS・TLSインスペクション・ドメインフィルタリングを実現し、集中型のネットワークセキュリティを構築してください。
-   **Action**:
    1.  **Stateful Inspection**: Suricataベースのステートフルルール。Strict Orderingで定義順処理。IP/FQDN/プロトコルベースのフィルタリング。Active Threat Defenseで10分間隔の脅威更新。
    2.  **IPS/IDS**: マネージドルールグループ（AWS+パートナー：Checkpoint/Fortinet/Trend Micro等）。CVE/OWASP Top10/マルウェア/C&C保護。カスタムSuricataルールは最小限に。
    3.  **TLS Inspection**: Egress TLSインスペクションで暗号化トラフィック内の脅威検出。SNIスプーフィング対策（TLSサーバ証明書 vs SNI検証）。データ漏洩防止。
    4.  **Centralized Deployment**: Transit Gateway inspectionVPCでEast-West/North-South統合検査。Firewall Managerで組織全体のポリシー一元管理。各AZにファイアウォールEndpoint配置。
    5.  **Routing**: 対称ルーティング必須（Transit Gateway Appliance Mode有効化）。非対称ルーティング非サポート。GeoIPフィルタリング。

---

## 95. Neptune グラフデータベース (Graph Database)

### Rule 95.1: The Neptune Protocol
-   **Law**: **Amazon Neptune**を使用して、不正検出・ナレッジグラフ・推薦エンジン・アイデンティティグラフなどの高度連結データワークロードを効率的に処理してください。
-   **Action**:
    1.  **Data Model**: Property Graph（Gremlin/openCypher）vs RDF（SPARQL）の用途に応じた選択。アクセスパターンに合わせたノード/エッジ/プロパティ設計。
    2.  **Query Optimization**: EXPLAIN/PROFILEでクエリ分析。フィルタの早期プッシュ。Cartesian Product回避。必要変数のみSELECT。LIMIT活用。
    3.  **Serverless & Scaling**: Neptune Serverlessで非定常/スパイクトラフィック対応。最小NCU（1-2）で開発/ステージング最適化。リードレプリカで読取スケーリング。
    4.  **Analytics**: Neptune Analyticsでグラフアルゴリズム（PageRank/Louvain/Connected Components）。GraphRAG for GenAI。Entity Resolution連携。
    5.  **Security**: VPCネットワーク分離。IAM+DB認証。暗号化（保存/転送）。CloudWatch監視。バルクロードで初期データ投入最適化。

---

## 96. Amazon Q Developer・CodeGuru (AI Developer Tools)

### Rule 96.1: The AI Developer Tools Protocol
-   **Law**: **Amazon Q Developer**（旧CodeWhisperer）でAIコード生成・セキュリティスキャン、**CodeGuru**でプロファイリング・SAST分析を活用し、開発生産性とコード品質を向上してください。
-   **Action**:
    1.  **AI Code Generation**: コンテキスト認識のリアルタイムコード提案。効果的なプロンプトエンジニアリング。AWS固有最適化。セキュリティスキャン内蔵。
    2.  **Security Scanning**: SAST/SCA/IaCスキャン統合。OWASP Top10/ハードコード資格情報/暗号化不備の検出。コードdiffでの修正提案。Shift-Left戦略。
    3.  **CodeGuru Profiler**: 本番/プリプロダクション環境での継続プロファイリング。CPU利用率最適化。パフォーマンスボトルネック特定。アクション可能な推奨事項。
    4.  **AI-Generated Code Safety**: AI生成コードは検証まで潜在的リスクとして扱う。セキュアプロンプトガイドライン。CI/CDポリシーガードレール。依存関係許可リスト。
    5.  **CI/CD Integration**: CodeGuru Security+Q DeveloperのCI/CDパイプライン統合。自動コードレビュー。脆弱性の段階的自動修正。ログとトレーサビリティ。

---

## 97. Outposts・Local Zones・Wavelength (Hybrid & Edge Computing)

### Rule 97.1: The Hybrid & Edge Protocol
-   **Law**: **AWS Outposts**（オンプレミス）、**Local Zones**（都市圏低レイテンシ）、**Wavelength**（5Gエッジ）を用途別に適切に選択し、ハイブリッドクラウド・エッジコンピューティング戦略を構築してください。
-   **Action**:
    1.  **Outposts**: オンプレミスでAWS API/ツール/セキュリティ一貫性。1ms未満レイテンシ。データレジデンシー要件対応。S3レプリケーション。Local Gateway経由ローカル接続。
    2.  **Local Zones**: 都市圏での1桁msレイテンシ。ゲーミング/ストリーミング/AR/VR。VPC拡張でリージョンサービスへのシームレスアクセス。Control Tower/SCPガバナンス。
    3.  **Wavelength**: 5Gネットワーク内のAWSコンピュート。超低レイテンシモバイルアプリ。キャリアネットワーク内トラフィック最小化。複数ゾーンのマルチロケーション展開。
    4.  **Data Gravity**: データ生成場所での処理（帯域削減/レイテンシ低減）。エッジAI/MLリアルタイム推論。IoTデバイス処理。
    5.  **Security & Operations**: IaCで一貫したデプロイ自動化。ゼロトラストセキュリティモデル。分散トレーシング/オブザーバビリティ。Direct Connect+VPNフェイルオーバー。

---

## 98. DocumentDB ドキュメントデータベース (Document Database)

### Rule 98.1: The DocumentDB Protocol
-   **Law**: **Amazon DocumentDB**をMongoDB互換のマネージドドキュメントDBとして活用し、Elastic Clusters・Global Clusters・インデックス最適化のベストプラクティスを適用してください。
-   **Action**:
    1.  **Indexing**: 高カーディナリティフィールドのみインデックス（重複率1%未満）。Compound Indexes優先。未使用インデックス定期削除。マイグレーション前にインデックス事前作成。
    2.  **Elastic Clusters**: 水平スケーリングでシャーディング自動管理。最適シャードキー選択（高カーディナリティ/均等書込分散）。2PBまでスケール。コンピュート/ストレージ分離。
    3.  **Global Clusters**: 最大10リージョンレプリケーション。60秒以内のリージョン障害復旧。低レイテンシグローバル読取。ストレージベース物理レプリケーション。
    4.  **Cost Optimization**: BufferCacheHitRatio監視（ワーキングセットがメモリに収まること確認）。I/O-Optimized（I/Oコスト25%超過時）。Zstandard圧縮。未使用クラスタ停止。
    5.  **Migration & Operations**: DMS（オンラインマイグレーション）/mongodump（オフライン）。Change Streamsでリアルタイムイベント。secondaryPreferredでレプリカ読取。最低2AZ×3インスタンス。

---

## 99. Bedrock Knowledge Bases & RAGアーキテクチャ (Knowledge Bases & RAG Architecture)

### Rule 99.1: The RAG Architecture Protocol
-   **Law**: 本番RAG（Retrieval-Augmented Generation）システムの構築には**Amazon Bedrock Knowledge Bases**を中核とし、検索精度・コスト・レイテンシのバランスを体系的に設計してください。
-   **Action**:
    1.  **アーキテクチャパターン**: ユースケースに応じたRAGアーキテクチャを選択：

        | パターン | 説明 | 適用場面 |
        |:---------|:-----|:---------|
        | **Naive RAG** | 単純な検索→生成 | PoC、シンプルなQ&A |
        | **Advanced RAG** | Pre/Post検索の最適化（クエリ拡張・リランキング） | 本番アプリケーション |
        | **Multi-Source RAG** | 複数Knowledge Baseの統合検索 | 部門横断知識検索 |
        | **Agentic RAG** | エージェントが検索戦略を自律判断 | 複雑な分析・調査タスク |

    2.  **クエリ拡張**: ユーザークエリを自動的にパラフレーズ・分解し、検索精度を向上。Bedrock Knowledge Basesのクエリ分解機能を活用。
    3.  **ガードレール統合**: Knowledge Bases検索結果に対してもBedrock Guardrails（§93）を適用。PII・機密情報の漏洩を検索段階で防止。
    4.  **評価メトリクス**: Faithfulness（生成がソースに忠実か）、Relevance（検索結果が適切か）、Answer Correctness（回答が正確か）を定量的に測定。Bedrock Evaluation/RAGASフレームワークを活用。
    5.  **同期スケジュール**: データソースの更新頻度に応じた同期戦略。リアルタイム性が必要な場合はIncremental Sync + EventBridgeトリガー。

### Rule 99.2: The RAG Cost Optimization Protocol
-   **Law**: RAG運用コストを段階的に最適化し、ベクトルストア・埋め込み・推論の各レイヤーでコスト意識を持ってください。
-   **Action**:
    1.  **ベクトルストア階層化**: ホットデータ（高頻度クエリ）はOpenSearch Serverless、コールドデータ（低頻度）はS3 Vectors（§107）へ段階的移行。最大90%のストレージコスト削減。
    2.  **埋め込みキャッシュ**: 同一ドキュメントの再埋め込みを防止。変更検知（ハッシュ比較）で差分のみ再埋め込み。
    3.  **検索結果キャッシュ**: 頻出クエリの検索結果をElastiCache/DynamoDBにキャッシュ。TTLベースで鮮度管理。
    4.  **トークン制御**: 検索結果のコンテキストウィンドウへの投入量を制御。Top-K結果数とチャンクサイズの最適化でプロンプトトークンを最小化。
-   **Cross-Ref**: Bedrock Knowledge Bases設計原則は§29.4参照。S3 Vectorsは§107参照。AgentCoreは§101参照。

---

## 100. S3 Tables & S3 Metadata（データレイクハウス戦略）

### Rule 100.1: The S3 Tables Protocol
-   **Law**: 構造化表データの分析ワークロードには**Amazon S3 Tables**を使用し、Apache Icebergネイティブのデータレイクハウスアーキテクチャを構築してください（re:Invent 2025 GA）。
-   **Action**:
    1.  **Apache Iceberg Integration**: S3 Tables はApache Iceberg形式をネイティブサポート。ACID トランザクション、スキーマ進化、タイムトラベル（過去バージョンへのクエリ）を活用し、信頼性の高い分析基盤を構築。
    2.  **Intelligent-Tiering**: S3 Tables Intelligent-Tiering を有効化し、アクセスパターンに基づいて Frequent Access / Infrequent Access / Archive Instant Access 間で自動移行。最大80%のストレージコスト削減を実現。
    3.  **Cross-Region Replication**: 重要な分析データにはS3 Tables のクロスリージョンレプリケーションを設定し、リージョン障害時のDR・グローバルデータセットの一貫性を保証。
    4.  **Iceberg REST Catalog**: Iceberg REST Catalog エンドポイントを使用し、オープンソースのIceberg APIで直接テーブルを管理。ベンダーロックインを回避しつつマネージドサービスのメリットを享受。
    5.  **Glue Data Catalog連携**: AWS Glue Data Catalog との統合により、Athena・EMR・Redshift Spectrum からシームレスにクエリ可能な統合メタデータカタログを構築。
    6.  **Compaction Optimization**: ソート結合コンパクションを活用しクエリ効率を最大化。コンパクション料金は90%削減済み（2025年〜）。テーブルバケットあたり最大10,000テーブルまでスケール。
-   **Anti-pattern**: 分析ワークロードに通常のS3バケット + 手動パーティション管理を使用すること。S3 Tables のマネージドコンパクション・メタデータ管理により運用負荷を大幅削減可能。

### Rule 100.2: The S3 Metadata Protocol
-   **Law**: S3に保存されたオブジェクトのメタデータ管理には**Amazon S3 Metadata**を使用し、SQLベースのメタデータクエリ基盤を構築してください（2025年GA）。
-   **Action**:
    1.  **Automated Discovery**: 新規・更新オブジェクトだけでなく、**既存の全S3オブジェクト**に対してもメタデータを自動生成・管理。
    2.  **SQL Queryable**: メタデータはApache Iceberg形式の自動更新テーブル（ジャーナルテーブル・ライブインベントリテーブル）として提供。Amazon AthenaやEMRから標準SQLでクエリ可能。
    3.  **Live Inventory**: ライブインベントリテーブルはオブジェクトの変更後通常1時間以内に自動更新。リアルタイムに近いメタデータの可視性を確保。
    4.  **AI Integration**: Amazon Bedrockと連携し、AI生成コンテンツ（動画等）に関連メタデータを自動アノテーション。データカタログの自動拡充に活用。
    5.  **Cost Optimization**: ジャーナルテーブルの料金は33%削減済み。メタデータの保持期間とクエリ頻度に基づいてコストを最適化。

---

## 101. Bedrock AgentCore（AIエージェントプラットフォーム）

### Rule 101.1: The AgentCore Protocol
-   **Law**: 生成AIエージェントの本番デプロイには**Amazon Bedrock AgentCore**を使用し、Runtime・Memory・Identity・Gateway・Observabilityの7コアサービスを統合活用してください（2025年10月GA）。
-   **Action**:
    1.  **AgentCore Runtime**: エージェントのホスティング・スケーリング・フェイルオーバーを自動管理。Agent-to-Agent（A2A）プロトコル対応で、マルチエージェント協調を実現。双方向ストリーミングでリアルタイム会話を実装。
    2.  **AgentCore Memory**: エピソディックメモリ（過去の対話からの学習）とセマンティックメモリ（知識の蓄積・検索）を組み合わせ、エージェントのコンテキスト維持と学習能力を実現。セルフマネージド戦略でメモリ抽出・統合を制御可能。
    3.  **AgentCore Identity**: IAM認証統合 + カスタムクレーム対応でマルチテナント環境のセキュアな認証を実現。エージェントのアクション実行権限をIAMポリシーで厳格に制限。
    4.  **AgentCore Gateway**: Model Context Protocol（MCP）サーバーへの接続をサポート。IAM認可で安全なツール・データソースアクセスを実現。
    5.  **AgentCore Observability**: CloudWatchダッシュボードとの完全統合によるエージェント実行の可視化。OpenTelemetry（OTEL）互換。エージェントの推論過程・ツール呼び出し・エラーを完全トレース。
    6.  **Code Interpreter & Browser Tool**: コード生成・実行のサンドボックス環境と、Webブラウジング自動化ツールの統合。

### Rule 101.2: The AgentCore Governance
-   **Law**: AIエージェントのガバナンスとして、**Policy in AgentCore**による実行時ポリシー制御と**AgentCore Evaluations**による品質評価を実装してください。
-   **Action**:
    1.  **Policy in AgentCore**: 自然言語でポリシーを定義し、Cedar言語に自動変換。AgentCore Gatewayと統合してリアルタイムでエージェントの行動境界を制御。高リスク操作（決済、データ削除等）には人間承認ゲートを設置。
    2.  **AgentCore Evaluations**: 13個の組み込み評価器 + カスタムスコアリングシステムでエージェント品質を継続テスト。評価メトリクスはCloudWatch経由でモニタリング。
    3.  **VPC & PrivateLink**: エンタープライズセキュリティ要件として、VPC・PrivateLink対応を有効化。エージェントのネットワーク通信をプライベートに維持。
    4.  **IaC Integration**: CloudFormation・リソースタグ対応でエージェントインフラのコード化・自動管理を実現。

---

## 102. IAM高度化 — Policy Autopilot & ABAC（属性ベースアクセス制御）

### Rule 102.1: The IAM Policy Autopilot Protocol
-   **Law**: IAMポリシーの最小権限化には**IAM Access Analyzer**のポリシー生成機能と**IAM Policy Autopilot**（オープンソース）を活用し、CloudTrailログに基づく自動最小権限ポリシーを生成してください（re:Invent 2025〜）。
-   **Action**:
    1.  **Policy Generation**: IAM Access Analyzer のポリシー生成で、指定期間のCloudTrailログを分析し、実際に使用されたアクションのみを含むポリシーテンプレートを自動生成。過剰権限の特定・削減を自動化。
    2.  **Unused Access Detection**: IAM Access Analyzer の未使用アクセス検出で、90日以上使用されていないIAMロール・権限を特定。不要な権限の棚卸しを自動化。
    3.  **External Access Analysis**: 外部からのアクセスが意図しないリソースに許可されていないか、IAM Access Analyzer で継続的にスキャン。S3バケット、IAMロール、KMSキー、Lambda関数、SQSキュー等が対象。
    4.  **CI/CD Integration**: ポリシー検証APIをCI/CDパイプラインに統合し、過剰権限のポリシーがデプロイされることを事前に防止。

### Rule 102.2: The ABAC Strategy (属性ベースアクセス制御)
-   **Law**: 大規模環境のスケーラブルなアクセス管理には**ABAC（Attribute-Based Access Control）**を採用し、タグベースの動的認可を実装してください。
-   **Action**:
    1.  **Tag-Based Authorization**: IAMポリシーの`Condition`ブロックで`aws:PrincipalTag`と`aws:ResourceTag`を使用し、ユーザー/ロールのタグとリソースのタグが一致する場合のみアクセスを許可する動的ポリシーを設計。
    2.  **RBAC + ABAC Hybrid**: 従来のロールベース（RBAC）を基盤として維持しつつ、ABACで横断的なアクセス制御（部門・プロジェクト・環境のタグベース制御）を追加。静的ポリシーの増殖を抑制。
    3.  **Strategic Tagging**: ABACの効果を最大化するため、リソースとプリンシパルに統一されたタグ戦略を適用。必須タグ（§8.4参照）との整合性を保証。
    4.  **Permission Boundaries Enhancement**: Permission Boundariesを開発チームが作成するIAMロールに適用し、セルフサービスでの権限管理を実現しつつ組織のセキュリティポリシーの範囲内に制限。開発者自身ではなく、開発者が作成するサービスロールにBoundariesを設定。
-   **Reference — ABACポリシー例（部門タグベースのS3アクセス制御）**:
    ```json
    {
      "Version": "2012-10-17",
      "Statement": [{
        "Sid": "AllowS3AccessMatchingDepartment",
        "Effect": "Allow",
        "Action": ["s3:GetObject", "s3:PutObject"],
        "Resource": "arn:aws:s3:::company-data-*/*",
        "Condition": {
          "StringEquals": {
            "aws:ResourceTag/Department": "${aws:PrincipalTag/Department}"
          }
        }
      }]
    }
    ```
    > **メリット**: 新しい部門が追加されても、タグを付与するだけでアクセス制御が自動適用。個別ポリシーの追加が不要。

---

## 103. Aurora DSQL（分散SQLデータベース）

### Rule 103.1: The Aurora DSQL Protocol
-   **Law**: グローバル規模の分散トランザクションが必要なワークロードには**Amazon Aurora DSQL**を使用してください。PostgreSQL互換の分散SQL、サーバーレス、マルチリージョン対応（2025年GA）。
-   **Action**:
    1.  **Use Case Selection**: 以下の要件を満たす場合にAurora DSQLを選択：
        -   マルチリージョンでの強整合性（Strong Consistency）が必要
        -   水平方向のスケーラビリティ（自動シャーディング）が必要
        -   サーバーレス（インフラ管理ゼロ）が望ましい
        -   PostgreSQLワイヤプロトコル互換が条件
    2.  **Serverless Architecture**: 完全サーバーレスのため、インスタンスサイズ・シャード数の管理が不要。ワークロードに応じた透過的なスケーリングを自動実行。
    3.  **Multi-Region Active-Active**: マルチリージョンクラスター構成で、各リージョンでの読み書きが可能。グローバルトランザクションのACID保証を維持。
    4.  **Security**: VPC PrivateLink経由のアクセス、IAM認証統合、保存時暗号化（KMS）、転送中暗号化（TLS 1.3）を標準適用。Dynamic Data Maskingで機密データの動的マスキングを実装。
    5.  **Monitoring**: CloudWatch メトリクスでトランザクション遅延・スループット・エラー率を監視。Performance Insights未対応の場合はカスタムメトリクスで補完。
-   **vs Aurora**: 従来のAurora（§4.1）は単一リージョン・プライマリライター構成に最適。DSQLはマルチリージョン書き込みが必要な場合に選択。Aurora Global DatabaseはRead Replicaベースのマルチリージョン読み取りに使用。
-   **Anti-pattern**: 単一リージョン・低レイテンシ要件のOLTPワークロードにDSQLを使用すること。分散コーディネーションのオーバーヘッドにより、従来のAuroraの方が低レイテンシを達成可能。

---

## 104. Application Signals & SLOドリブン監視

### Rule 104.1: The Application Signals Protocol
-   **Law**: アプリケーションのパフォーマンス監視には**CloudWatch Application Signals**を使用し、自動計装・SLO定義・サービスマップを統合したAPM基盤を構築してください（2024年GA）。
-   **Action**:
    1.  **Automatic Instrumentation**: Application Signalsの自動計装を有効化し、手動コーディングなしでサービスの標準メトリクス（呼び出し量、可用性、レイテンシ、フォールト、エラー）を収集。Java、Python、Node.js、.NET対応。
    2.  **Service Map**: サービストポロジーの自動発見・可視化。依存関係と通信フローをリアルタイムで把握し、障害のインパクト範囲を即時特定。
    3.  **SLO Definition**: クリティカルなユーザー向けサービスからSLOを定義。以下のプラクティスに従う：
        -   可用性SLO: 99.9%以上をターゲット（月間43分以内のダウンタイム許容）
        -   レイテンシSLO: P99を基準に設定（例: API応答 500ms以内）
        -   **Burn Rate Alerts**: エラーバジェットの消費速度に基づくアラートを設定。静的閾値よりも実効的。
    4.  **Container Insights Integration**: ECSタスク/EKS PodのインフラメトリクスとApplication Signalsのアプリメトリクスを統合表示。アプリ性能低下の根本原因（CPU高負荷、メモリ不足等）を1画面で特定。
    5.  **OpenTelemetry**: Application SignalsはOpenTelemetry標準に基づくため、AWS Distro for OpenTelemetry（ADOT）をECSサイドカーとしてデプロイし、詳細トレースを収集。ベンダーロックイン回避。
    6.  **Synthetics + RUM 連携（§77参照）**: Application Signalsをcloudwatch Synthetics（合成監視）およびRUM（リアルユーザー監視）と統合し、バックエンド〜フロントエンドのエンドツーエンド可視性を確保。

---

## 105. ECS Service Connect（サービスメッシュ統合）

### Rule 105.1: The ECS Service Connect Protocol
-   **Law**: ECS上のマイクロサービス間通信には**Amazon ECS Service Connect**を使用し、サービスディスカバリ・負荷分散・オブザーバビリティをECSネイティブで実現してください（2022年GA、継続強化中）。
-   **Action**:
    1.  **Service Discovery**: ECS Service Connectでサービス名ベースのDNS解決を提供。Cloud Map統合により、サービスの登録・解決を自動化。VPC Lattice（§2.7）が不要な単一VPC環境で推奨。
    2.  **Envoy Integration**: Service ConnectはEnvoyプロキシをサイドカーとして自動デプロイ。サービス間通信のロードバランシング・リトライ・タイムアウトを透過的に管理。
    3.  **Traffic Metrics**: サービス間のリクエスト量・レイテンシ・エラー率をCloudWatchメトリクスとして自動収集。個別のメトリクスエージェント設定不要。
    4.  **Envoy Access Logs**: Service ConnectのEnvoyアクセスログを有効化し、リクエストレベルのトラフィックパターンを詳細に記録。エンドツーエンドのトレーシング・デバッグ・コンプライアンス監視を実現。
    5.  **Health Check**: Envoyによるアクティブヘルスチェックで異常なタスクへのトラフィックを自動停止。ECSタスクレベルのヘルスチェックと組み合わせ。
    6.  **TLS Encryption**: Service Connect間のmTLS暗号化を有効化し、サービス間通信のゼロトラストを実現。
-   **vs VPC Lattice**: Service Connect = ECS内のサービスメッシュ（同一VPC/単一オーケストレーター環境向け）。VPC Lattice（§2.7）= ECS/EKS/Lambda/EC2混在の異種クロスVPC環境向け。

---

## 106. AWSカスタムシリコン戦略 (AWS Custom Silicon — Trainium / Inferentia)

### Rule 106.1: The Custom Silicon Strategy
-   **Law**: ML推論には**Inferentia2**（Inf2インスタンス）、ML学習には**Trainium2/3**（Trn2/Trn3インスタンス）を第一候補として検討し、NVIDIA GPUインスタンスとのコスト対パフォーマンスを比較して最適なコンピューティングを選択してください。
-   **Action**:
    1.  **Inferentia2 (Inf2)**: LLM・Vision Transformer等の推論ワークロードに最適。GPU比で最大4倍のスループット、最大10倍のレイテンシ削減。各チップに2つのNeuronCore-v2と32GB HBMを搭載。
    2.  **Trainium2 (Trn2)**: 大規模生成AIモデルの学習に最適。16基のTrainium2チップで20.8 FP8 PFLOPSの計算能力。GPU比で30-40%のコストパフォーマンス向上。Trn2 UltraServerは64チップ/83.2 PFLOPSに拡張可能。
    3.  **Trainium3 (Trn3) — re:Invent 2025 GA**: 次世代学習チップ。Trainium2比で**4.4倍のコンピュート性能**、**3.9倍のメモリ帯域**。Trn3 UltraServerは最大144チップに拡張可能。大規模基盤モデル（数兆パラメータ）の学習コストを大幅に削減。AWS AI Factories（オンプレミスAIインフラ）の基盤チップ。
    4.  **AWS Neuron SDK**: Trainium/Inferentia専用のSDK。PyTorch/JAX/TensorFlowを変換なしで使用可能。`torch-neuronx`コンパイラで既存モデルをNeuronCoreに最適化。Neuron Monitorで使用率を監視。
    5.  **Selection Criteria**:
        -   **Inferentia2推奨**: 推論ワークロード、コスト最優先、Neuron SDK対応モデル
        -   **GPU推奨**: カスタムCUDAカーネル必須、最新の未対応モデル、マルチモーダル研究
        -   **併用戦略**: 学習はGPU(P5/P4d)、推論をInferentia2に移行してTCO最適化
    6.  **Bedrock Integration**: Amazon Bedrockの基盤モデルは内部的にTrainium/Inferentiaを活用。直接のチップ管理不要でカスタムシリコンの恩恵を享受可能。自前モデルの推論コスト最適化が必要な場合にInf2を選択。
-   **Anti-pattern**: Neuron SDKの互換性を確認せずにGPU学習コードをTrainiumに直接移植すること。必ず`neuron-compile`でコンパイル検証を実施。

---

## 107. S3 Vectorsベクトルストレージ (Vector Storage for AI)

### Rule 107.1: The S3 Vectors Protocol
-   **Law**: AIアプリケーション向けのベクトルデータ格納・検索には**Amazon S3 Vectors**を使用し、専用ベクトルデータベース対比で最大90%のコスト削減を実現してください（2025年12月GA）。
-   **Action**:
    1.  **Vector Buckets & Indexes**: 専用ベクトルバケットを作成し、ベクトルインデックスで論理的に整理。バケットあたり最大10,000インデックス、インデックスあたり最大20億ベクトル、バケットあたり最大20兆ベクトル。
    2.  **Index Configuration**: インデックス作成時にベクトル次元数（1-4,096）と距離メトリクス（コサイン類似度/ユークリッド距離）を指定。これらは不変パラメータのため、設計段階で慎重に決定。
    3.  **Metadata Filtering**: 各ベクトルにメタデータ（キー・バリューペア）を付与し、検索時にきめ細かいフィルタリングを実施。全メタデータはデフォルトでフィルタリング可能。
    4.  **Bedrock KB Integration**: Amazon Bedrock Knowledge Basesのベクトルストレージとしてネイティブ統合。RAGアプリケーションのコスト効率を大幅に改善。
    5.  **Tiered Architecture**: ホットデータ（高頻度クエリ）にはOpenSearch Serviceを使用し、コールドデータ（低頻度）にはS3 Vectorsをオフロード。ハイブリッド構成でコスト最適化。
    6.  **Security**: SSE-S3またはSSE-KMS（カスタマー管理キー/インデックス）で暗号化。IAMポリシーによる粒度の細いアクセス制御。タグベースABACでコスト配分。
-   **Anti-pattern**: 高頻度のサブミリ秒レイテンシが必要なホットベクトルデータにS3 Vectorsを使用すること。10-100ms程度のクエリレイテンシを許容できるワークロード向け。

---

## 108. Lambda Managed Instances（EC2上のLambda）

### Rule 108.1: The Lambda Managed Instances Protocol
-   **Law**: 安定した高トラフィックのLambdaワークロードには**Lambda Managed Instances**を使用し、EC2インスタンス上でLambdaを実行することで、Savings Plans/RIによるコスト最適化とハードウェア選択の柔軟性を実現してください（re:Invent 2025 GA）。
-   **Action**:
    1.  **Use Case Selection**: 以下の場合にLambda Managed Instancesを選択：
        -   安定した予測可能なトラフィックパターン
        -   Savings Plans/RIによるコスト最適化が必要
        -   特定のCPUアーキテクチャ（Graviton4等）が必要
        -   マルチ同時実行による効率化が期待できる
    2.  **Instance Selection**: ワークロード要件に基づきEC2インスタンスタイプを選択。最新Graviton4/5プロセッサを活用したコスト最適化。高帯域ネットワーキングオプション対応。
    3.  **Multi-Concurrency**: 各実行環境で複数リクエストを同時処理し、リソース利用率と価格性能比を向上。従来Lambdaの1リクエスト/実行環境の制約を解消。
    4.  **Operations**: AWSがインスタンスライフサイクル・OSパッチ・セキュリティ更新・ロードバランシング・Auto Scalingを自動管理。EC2の柔軟性とLambdaのサーバーレス運用性を両立。
    5.  **Cost Model**: Lambda リクエスト料金 + EC2インスタンス料金 + 15%コンピュート管理手数料。Savings Plans/RIの適用でOn-Demand比大幅コスト削減可能。
    6.  **Migration**: 既存Lambda関数のコード変更なしで移行可能。Java/Node.js/Python/.NETランタイム対応。CloudWatch/X-Ray/AWS Configとシームレス統合。
-   **vs Traditional Lambda**: 従来Lambda = 予測不能・短時間・低頻度のイベント駆動。Managed Instances = 高トラフィック・安定パターン・コスト最適化重視。
-   **Cross-Ref**: Lambda基本設計は§3.2参照。Lambda高度最適化は§79参照。

---

## 109. DynamoDB Multi-Region Strong Consistency (MRSC)

### Rule 109.1: The DynamoDB MRSC Protocol
-   **Law**: マルチリージョンでの強整合性（Strong Consistency）が必要なDynamoDBワークロードには**Multi-Region Strong Consistency (MRSC)**を使用し、Zero RPO（Recovery Point Objective）を実現してください（2025年6月GA）。
-   **Action**:
    1.  **3-Region Minimum**: MRSCには最低3リージョン構成が必要。3フルレプリカ、または2レプリカ + 1ウィットネス（変更データのみ保持）構成を選択。ウィットネスはフルテーブルコピーは不要だがデータ可用性を保証。
    2.  **Synchronous Replication**: 書き込みは少なくとも1つの別リージョンに同期レプリケーション完了後にACK。マルチリージョンジャーナルによる即時読み取り可能性を保証。
    3.  **Consistent Reads**: 最強の耐障害性が必要な読み取りには`ConsistentRead=True`パラメータを使用。クロスリージョン通信が発生するため、結果整合性読み取りよりもレイテンシが増加。
    4.  **Use Case Selection**: ユーザープロファイル管理・在庫管理・金融トランザクション処理等の厳密な整合性が必要なワークロードに適用。
    5.  **Cost Awareness**: 同期レプリケーションによる書き込みコスト・クロスリージョンデータ転送コストを考慮。全データでMRSCを有効化するのではなく、整合性が真に必要なテーブルに限定。
-   **vs Standard Global Tables**: 標準グローバルテーブル = 結果整合性（最終的な整合性）。MRSC = 強整合性（Zero RPO）。レイテンシとコストのトレードオフを考慮して選択。
-   **Cross-Ref**: DynamoDB基本設計は§4.2参照。

---

## 110. CloudFront VPC Origins（プライベートオリジン配信）

### Rule 110.1: The CloudFront VPC Origins Protocol
-   **Law**: パブリックインターネットへのバックエンド露出を排除するため、**CloudFront VPC Origins**を使用し、プライベートサブネット内のALB/NLB/EC2をオリジンとするゼロトラスト配信アーキテクチャを構築してください（2024年GA）。
-   **Action**:
    1.  **Private Subnet Deployment**: オリジンリソース（ALB/NLB/EC2）を必ずプライベートサブネットに配置。CloudFrontが唯一のエントリポイントとなり、攻撃対象を大幅に縮小。
    2.  **Security Group Lock**: オリジンのセキュリティグループで、CloudFrontマネージドセキュリティグループ（`CloudFront-VPCOrigins-Service-SG`）からのインバウンドトラフィックのみを許可。パブリックDNS/エンドポイントが存在しないゼロトラストペリメータ。
    3.  **VPC Requirements**: VPCにInternet Gatewayを設定（CloudFrontの接続シグナル用、オリジンへの直接ルーティングには使用されない）。プライベートサブネットに最低1つのIPv4アドレスを確保。
    4.  **HTTPS Enforcement**: CloudFrontとVPCオリジン間は常にHTTPSを設定。転送中データの暗号化を保証。
    5.  **Cross-Account（2025年〜）**: AWS Resource Access Manager（RAM）で別アカウントのVPCオリジンへのクロスアカウント接続をサポート。マルチアカウント環境でのセキュリティと運用効率を向上。
    6.  **Monitoring**: CloudWatchでオリジンレイテンシ・応答時間・エラー率（4xx/5xx）・キャッシュヒット率を監視。パフォーマンス問題を即時検知。
-   **Cross-Ref**: CloudFront詳細設定は§39参照。WAF統合は§72参照。

---

## 111. AWS Security Incident Response（セキュリティインシデント対応サービス）

### Rule 111.1: The Security Incident Response Service Protocol
-   **Law**: セキュリティインシデントの自動トリアージ・調査・対応には**AWS Security Incident Response**サービスを使用し、GuardDuty/Security Hubとの統合によるインシデント管理を実現してください（2024年12月GA）。
-   **Action**:
    1.  **Automated Triage**: GuardDuty・Security Hub・サードパーティ検出ツールからのセキュリティファインディングを自動監視・トリアージ。重要アラートの優先順位付けにより、セキュリティチームの負荷を軽減。
    2.  **AI-Powered Investigation**: AIエージェントによるインシデントへのコンテキスト・証拠の自動付与。調査時間の短縮とインパクト範囲の迅速な特定。
    3.  **CIRT Access**: AWS Customer Incident Response Team（CIRT）への24/7アクセス。専門エンジニアが数分以内にリクエストに対応。重大インシデント時のエスカレーション経路として活用。
    4.  **Centralized Console**: インシデント管理の統合コンソール。セキュアなコラボレーション機能（メッセージング・データ転送・ビデオ会議スケジューリング）で協調対応を促進。
    5.  **Integration**: CloudTrail・VPC Flow Logs・DNS Logs等との連携で包括的なインシデントビューを提供。EventBridge + Lambda で自動修復ワークフローを構築。
-   **Cross-Ref**: インシデントレスポンスフレームワークは§21参照。フォレンジック対応は§21.2参照。

---

## 112. Database Savings Plans（データベースコスト最適化）

### Rule 112.1: The Database Savings Plans Protocol
-   **Law**: 安定したデータベースワークロードのコスト最適化には**Database Savings Plans**を使用し、RDS・Aurora・ElastiCache・Redshift等のコミットメントベース割引（最大35%）を適用してください（re:Invent 2025 GA）。
-   **Action**:
    1.  **Coverage Analysis**: AWS Cost Explorer でデータベース関連の使用パターンを分析し、On-Demand使用量のベースラインを特定。安定的な最低使用量（Waterline）に基づいてコミットメント金額を決定。
    2.  **Flexible Application**: Database Savings Plansは、インスタンスファミリー・リージョン・エンジン・データベースサイズを問わず自動適用。Compute Savings Plansのデータベース版として、柔軟性を最大化。
    3.  **Complementary Strategy**: 既存のCompute Savings Plans・Reserved Instancesとの組み合わせ。データベース専用のコミットメントにより、全体のコスト最適化カバレッジを拡大。
    4.  **Term Selection**: 1年/3年のコミットメント期間。All Upfront（全額前払い）で最大割引。No Upfront（前払いなし）で柔軟性を確保。リスク許容度に応じて選択。
    5.  **Monitoring**: Cost Explorerの Savings Plans利用率レポートで適用状況を継続監視。過剰/過少コミットメントを検知し四半期ごとに見直し。
-   **Cross-Ref**: FinOps詳細は§9・§37・§74参照。Compute Savings Plansは§9.2参照。

---

## 113. CloudWatch Unified Data Store（統合ログストア）

### Rule 113.1: The CloudWatch Unified Data Store Protocol
-   **Law**: 運用ログ・セキュリティログ・コンプライアンスログの統合管理には**CloudWatch Unified Data Store**を使用し、自動正規化・統合分析基盤を構築してください（re:Invent 2025〜）。
-   **Action**:
    1.  **Unified Ingestion**: 運用・セキュリティ・コンプライアンスの各種ログを単一のCloudWatch統合データストアに集約。ログソース別の個別管理を排除し、横断的な分析を実現。
    2.  **Automatic Normalization**: 異なるフォーマット・スキーマのログを自動正規化。手動のETL処理やフォーマット変換作業を不要にし、即座に分析可能な状態でログを蓄積。
    3.  **Built-in Analytics**: 組み込みの分析機能で、複数ログソースを横断したクエリ・相関分析・トレンド検出を実施。CloudWatch Logs Insights との統合で既存クエリパターンも活用。
    4.  **Security Integration**: GuardDuty・Security Hub・CloudTrailのセキュリティ関連ログとの統合により、脅威ハンティングとコンプライアンス監査の効率を向上。
    5.  **Cost Optimization**: ストレージ階層化と保持ポリシーによるコスト管理。高頻度アクセスログと長期保管ログの自動分離。IA（Infrequent Access）クラスの活用推奨。
-   **Cross-Ref**: CloudWatch基本設定は§7参照。Centralized Loggingは§36参照。

---

## 114. AWS Glue & Zero-ETLデータ統合 (Data Integration)

### Rule 114.1: The Glue Data Integration Protocol
-   **Law**: データ統合・ETL/ELTパイプラインには**AWS Glue**を使用し、可能な限り**Zero-ETL**統合でETLコード自体を排除してください。Glue 5.0以降を標準とし、Apache Iceberg/Hudi/Delta Lakeオープンテーブルフォーマットを活用。
-   **Action**:
    1.  **Glue 5.0標準**: Apache Spark 3.5.2、Python 3.11、Java 17ベース。オープンテーブルフォーマット（Iceberg/Hudi/Delta Lake）のネイティブサポート。Lake Formationによる細粒度アクセス制御。
    2.  **Zero-ETL統合（最優先）**: ETLコードを書く前に以下のZero-ETL統合を検討：
        -   **Aurora → Redshift**: Aurora MySQL/PostgreSQLからRedshiftへの自動レプリケーション。ニアリアルタイム分析。
        -   **DynamoDB → Redshift**: DynamoDBテーブルの自動エクスポート・統合。
        -   **SaaS → Redshift**: Salesforce/SAP等のビジネスアプリからの直接統合（8アプリ対応）。
        -   **S3 → Redshift**: Auto-Copy機能による自動取り込み。
    3.  **Data Catalog**: Glue Data Catalogをメタデータの中央リポジトリとして運用。Iceberg REST Catalog連携でオープンスタンダード準拠。クロスエンジンビュー（Athena/Redshift/EMR共有）を定義。
    4.  **Catalog Federation（2025年GA）**: リモートIcebergカタログへの直接アクセス。S3上のIcebergテーブルをGlue経由で各分析エンジンに提供。
    5.  **Data Quality**: ML搭載データ品質自動チェック。異常検知アルゴリズムでデータ品質問題をプロアクティブに検出・修復。品質ルールをCatalogに定義し全パイプラインで再利用。
    6.  **コスト最適化**: Auto Scalingで必要最小限のDPU使用。Flex実行（非対話型ジョブ向け、最大60%コスト削減）。ジョブブックマークで増分処理。
-   **Anti-pattern**: Zero-ETL統合で対応可能なユースケースにカスタムGlueジョブを作成すること。まずZero-ETLを評価。
-   **Cross-Ref**: データレイクガバナンスは§53参照。S3 Tablesは§100参照。

---

## 115. Amazon Athenaサーバーレス分析 (Serverless SQL Analytics)

### Rule 115.1: The Athena Analytics Protocol
-   **Law**: S3上のデータに対するアドホッククエリ・分析には**Amazon Athena**を使用し、サーバーレスでインフラ管理不要のSQL分析基盤を構築してください。
-   **Action**:
    1.  **料金モデル選択**:
        -   **Per-Query（デフォルト）**: スキャンしたデータ量に応じた課金（$5/TB）。散発的なクエリに最適。
        -   **Capacity Reservations**: 固定DPU容量を予約。高頻度クエリワークロード向け。DPU単位の粒度制御（2025年〜）。
    2.  **パフォーマンス最適化**:
        -   **パーティション射影**: パーティション数が多い場合（10万+）、Glue Catalogクロールの代わりにパーティション射影（Partition Projection）で動的パーティション解決。
        -   **列指向フォーマット**: Parquet/ORCを使用し、`SELECT *`を禁止。必要カラムのみ指定でスキャン量90%+削減。
        -   **CTAS/INSERT INTO**: 頻繁にクエリするデータをCTAS（Create Table As Select）で最適化済みテーブルに変換。
        -   **バケッティング**: 結合キーでバケッティングし、JOIN性能を向上。
    3.  **Apache Iceberg統合**: Athena上でIcebergテーブルのACIDトランザクション、Time Travel（過去バージョンクエリ）、スキーマ進化を活用。OPTIMIZE文で自動コンパクション。VACUUM文で不要スナップショット削除。
    4.  **Federated Query**: Lambda経由で外部データソース（RDS/Redshift/DynamoDB/DocumentDB/CloudWatch Logs等）に直接クエリ。25以上のコネクタ利用可能。
    5.  **Spark on Athena**: Apache SparkノートブックをAthena上で実行。インフラ管理不要のインタラクティブ分析。Python/Scala対応。
    6.  **セキュリティ**: Lake Formation統合で行/列レベルセキュリティ。Workgroups でユーザーグループ別のクエリ制限・コスト制御。CloudTrailでクエリ監査。
-   **Cross-Ref**: Glue Data Catalogは§114参照。S3ストレージ最適化は§78参照。

---

## 116. Amazon RedshiftモダンDWH (Modern Data Warehouse)

### Rule 116.1: The Redshift Data Warehouse Protocol
-   **Law**: 大規模データ分析・DWHワークロードには**Amazon Redshift**を使用し、Serverlessファーストでゼロ運用管理を実現してください。
-   **Action**:
    1.  **Serverless First**: 新規ワークロードはRedshift Serverlessから開始。RPU（Redshift Processing Unit）ベースの自動スケーリング。AI駆動スケーリング最適化（re:Invent 2024 GA）で負荷パターンを学習し自動調整。
    2.  **Zero-ETL統合（最優先）**: ETLパイプライン構築前に§114のZero-ETL統合を評価。Aurora/DynamoDB/SaaSからの直接統合でデータ鮮度とコストを最適化。
    3.  **Data Sharing**: クロスアカウント・クロスリージョンのデータ共有。RA3ノード/Serverless間のマルチDWH書き込み（2024 GA）。データコピー不要で最新データに即時アクセス。
    4.  **ストリーミング取り込み**: Amazon Kinesis Data Streams/Amazon MSKからの直接ストリーミングインジェスト。マテリアライズドビューでリアルタイムダッシュボード。
    5.  **AI/ML統合**:
        -   **Bedrock SQL統合**: SQL文からBedrock LLMを直接呼び出し。自然言語→SQL変換。
        -   **ML推論**: `CREATE MODEL`文でSageMaker統合ML推論。SQL内でモデル推論を実行。
    6.  **Iceberg統合**: Icebergテーブルの作成・直接データ挿入（SQL経由、ACID保証・スナップショット分離）。Apache Iceberg V3対応。
    7.  **コスト最適化**: Serverless RPU最小値設定。Provisioned: RA3ノード + Reserved Instances。日次/時間帯別のスケジュールスケーリング。Concurrency Scaling（バースト時自動追加クラスタ、1日1時間無料）。
-   **Anti-pattern**: 小規模分析（<100GB）にRedshiftを使用すること。Athena（§115）で十分。
-   **Cross-Ref**: Glue統合は§114参照。Kinesisストリーミングは§117参照。

---

## 117. Amazon Kinesisストリーミング基盤 (Real-Time Streaming)

### Rule 117.1: The Kinesis Streaming Protocol
-   **Law**: リアルタイムデータストリーミング・処理には**Amazon Kinesis**を使用し、レイテンシ最小化とコスト効率を両立してください。
-   **Action**:
    1.  **Data Streams — On-demand Advantage（2025年GA）**: 即時スループットスケーリング（最大10GB/秒）。従来On-demand比60%低コスト。シャード管理不要。新規ワークロードの第一候補。
    2.  **Data Streams — Provisioned**: 予測可能なトラフィックパターン向け。シャード単位の明示的容量管理。1シャードあたり1MB/秒書き込み、2MB/秒読み取り。
    3.  **Enhanced Fan-Out**: コンシューマごとに専用2MB/秒帯域を割当。複数アプリケーション間の読み取り競合を排除。HTTP/2プッシュで70ms以下のレイテンシ。
    4.  **レコードサイズ拡張（2025年〜）**: 最大10MiBレコードサイズ対応。大規模IoTデータ・メディアメタデータの直接ストリーミング。
    5.  **Data Firehose**: S3/Redshift/OpenSearch/Splunk等への直接配信。Lambda変換（オプション）。バッファサイズ/間隔でコスト最適化。Parquet/ORC自動変換。Dynamic Partitioning でS3パーティション自動生成。
    6.  **セキュリティ**: KMSサーバーサイド暗号化。VPCエンドポイント（PrivateLink）でプライベート通信。IAMポリシーでストリーム/コンシューマ単位のアクセス制御。
-   **vs MSK（§52）**: Kinesis = マネージド・サーバーレス・AWS統合重視。MSK = Kafka互換・既存エコシステム・高度カスタマイズ。
-   **Cross-Ref**: イベント駆動アーキテクチャは§17参照。Redshiftストリーミング取り込みは§116参照。

---

## 118. Amazon Cognitoユーザー認証 (Application Authentication)

### Rule 118.1: The Cognito Authentication Protocol
-   **Law**: アプリケーションのユーザー認証・認可には**Amazon Cognito**を使用し、User Pools + Identity Poolsの組み合わせでセキュアなID管理を実現してください。
-   **Action**:
    1.  **User Pools — 認証基盤**:
        -   **パスワードレス認証（推奨）**: FIDO2/WebAuthn（Passkeys）、マジックリンク、ワンタイムパスコード（OTP）。パスワード漏洩リスクを根本排除。
        -   **MFA必須**: TOTP（Authenticatorアプリ）またはSMS。高セキュリティ環境ではTOTP推奨。
        -   **OAuth 2.0 / OIDC**: Authorization Code Flow + PKCE（SPAモバイル必須）。Implicit Flowは非推奨。
        -   **ソーシャルログイン**: Google/Apple/Facebook/SAML/OIDC IdP連携。
    2.  **Managed Login（2024年GA）**: ドラッグ＆ドロップUIビルダーでブランド統一ログイン画面。CSS/JavaScript不要のカスタマイズ。
    3.  **Identity Pools — AWS認証情報発行**: 認証済み/未認証ユーザーにAWS一時認証情報（STS）を発行。S3/DynamoDB等のAWSリソースへの直接アクセスを制御。最小権限IAMロールをマッピング。
    4.  **Advanced Security Features（ASF）**:
        -   **適応型認証**: リスクベース認証でログイン試行を評価。Low/Medium/Highリスクに応じてMFA要求を動的調整。
        -   **侵害パスワード検知**: 流出データベースとの照合。侵害パスワードでの登録/ログインをブロック。
        -   **IPアドレスベースのブロック**: 不正アクセス元IPの自動ブロック。
    5.  **Lambda Triggers**: Pre Sign-up（カスタムバリデーション）、Pre Authentication（カスタム認証ロジック）、Post Confirmation（ウェルカムメール・初期データ作成）、Token Generation（カスタムクレーム追加）。
    6.  **JWTトークン管理**: アクセストークン有効期限は5分〜1日（デフォルト1時間推奨）。リフレッシュトークンは1日〜3650日。トークンスコープでAPI権限を制御。
-   **Cross-Ref**: IAM全般は§1参照。アプリケーション認証基本は§22参照。Verified Permissionsは§87参照。

---

## 119. Amazon Macie PII自動検知 (Automated PII Discovery)

### Rule 119.1: The Macie PII Discovery Protocol
-   **Law**: S3に保存されたデータのPII（個人識別情報）自動検知・分類には**Amazon Macie**を使用し、データプライバシーコンプライアンスを自動化してください。
-   **Action**:
    1.  **自動検出（Automated Discovery）**: S3バケット全体をサンプリングベースで継続的にスキャン。100以上のマネージドPIIタイプ（氏名/住所/クレジットカード/SSN/マイナンバー等）を自動検知。
    2.  **カスタムデータ識別子**: 正規表現 + キーワードベースで、組織固有の機密データパターン（社員ID/顧客コード等）を定義。マネージド識別子で検出されないドメイン固有データに対応。
    3.  **感度設定**: バケット/プレフィックス単位で包含/除外リストを設定。スキャン範囲を最適化しコストを制御。サンプリング深度の調整。
    4.  **Security Hub統合**: MacieファインディングをSecurity Hubに自動集約。優先度ベースのアラートと修復ワークフロー。EventBridge + Lambda で自動修復（例：PII検出→S3暗号化強制/アクセス制限）。
    5.  **Organizations統合**: マルチアカウント一元管理。委任管理者アカウントから全アカウントのMacieを集中管理。新規アカウントの自動有効化。
    6.  **コスト最適化**: サンプリングベーススキャン（バケット全体の1-2%）でコスト削減。高リスクバケットに対してのみフルスキャン。月次コスト見積もり機能で事前予測。
-   **Cross-Ref**: データ分類は§34参照。セキュリティ運用は§6参照。プライバシー保護は§34参照。

---

## 120. AWS DataSyncデータ移行・転送 (Data Migration & Transfer)

### Rule 120.1: The DataSync Transfer Protocol
-   **Law**: オンプレミスとAWS間、およびAWSサービス間のデータ転送には**AWS DataSync**を使用し、自動化された高速・セキュアなデータ移行を実現してください。
-   **Action**:
    1.  **転送パターン**:
        -   **オンプレミス → AWS**: NFS/SMB/HDFS/オブジェクトストレージからS3/EFS/FSxへの移行。DataSyncエージェントをオンプレミスにデプロイ。
        -   **AWS → AWS**: S3→S3、EFS→EFS、FSx→FSxのクロスリージョン/クロスアカウント転送。エージェント不要。
        -   **クラウド間**: Google Cloud Storage/Azure Blob Storage → S3の直接転送。
    2.  **高速転送**: 専用ネットワークプロトコルで最大10Gbpsスループット。自動並列化・マルチスレッド転送。圧縮・帯域制御オプション。
    3.  **タスクフィルタリング**: 包含/除外パターンで転送対象を精密制御。特定ファイル拡張子、パス、タイムスタンプベースのフィルタ。
    4.  **スケジューリング**: cron式スケジュールで定期実行。増分転送（変更ファイルのみ転送）でコストと時間を最適化。
    5.  **整合性検証**: 転送中・転送後の自動チェックサム検証。データ整合性を保証。転送結果の詳細ログ出力（CloudWatch Logs）。
    6.  **DataSync Discovery**: オンプレミスストレージの使用状況を自動分析。最適なAWSストレージサービス（S3/EFS/FSx）の推奨と移行計画を生成。
    7.  **セキュリティ**: TLS 1.2暗号化（転送中）。VPCエンドポイント対応でプライベートネットワーク転送。IAMポリシーで転送タスクのアクセス制御。
-   **vs Transfer Family（§67）**: DataSync = 大規模データ移行・同期。Transfer Family = SFTP/FTPS/FTPプロトコル互換のファイル転送。
-   **Cross-Ref**: ハイブリッドストレージは§67参照。S3最適化は§78参照。

---

## 121. Amazon EMRビッグデータ処理 (Big Data Processing)

### Rule 121.1: The EMR Big Data Protocol
-   **Law**: 大規模データ処理・分析にはAmazon EMRを使用し、**EMR Serverless**ファーストでインフラ管理ゼロの分析基盤を構築してください。
-   **Action**:
    1.  **EMR Serverless（推奨）**: Apache Spark/Hive/Prestoをインフラ管理なしで実行。自動スケーリング。ジョブ実行時間+リソース使用量ベースの課金。バッチ＆インタラクティブアプリケーション対応。
    2.  **EMR on EKS**: 既存EKSクラスタ上でSpark/Hiveを実行。Kubernetes統合。マルチテナント分離。カスタムコンテナイメージ対応。EKS Auto Mode統合で運用簡素化。
    3.  **EMR on EC2（既存ワークロード）**: 細かいインスタンス制御が必要な場合。Gravitonインスタンスでコスト30%削減。Spot Instancesでさらに最大90%コスト削減。
    4.  **Advanced Scaling（v7.0+）**: MLベース予測スケーリング。タスク完了予測とリソース需要予測で最適なクラスタサイズを自動決定。パフォーマンスとコストのバランスを動的に調整。
    5.  **Apache Iceberg V3**: 削除ベクタ（Deletion Vectors）と行リネージ（Row Lineage）サポート。大規模テーブルの更新パフォーマンス向上。
    6.  **Spark Troubleshooting Agent**: AI搭載トラブルシューティング。Sparkアプリケーションのエラー原因を自然言語で分析・提案。EMR/Glue/SageMaker Notebooks対応。
    7.  **セキュリティ**: Lake Formation統合で細粒度アクセス制御。KMS暗号化（保存時・転送中）。Apache Ranger統合。VPCプライベートサブネットデプロイ。
-   **vs Athena（§115）**: EMR = 複雑なデータ処理パイプライン・大規模ETL。Athena = アドホッククエリ・軽量分析。
-   **vs Glue（§114）**: EMR = Spark/Hive/Prestoの完全制御。Glue = マネージドETL・Data Catalog。
-   **Cross-Ref**: Glue統合は§114参照。データレイクガバナンスは§53参照。

---

## 122. Amazon ECRコンテナレジストリ (Container Registry)

### Rule 122.1: The ECR Container Management Protocol
-   **Law**: コンテナイメージの管理には**Amazon ECR**を使用し、ライフサイクル管理・脆弱性スキャン・イメージ署名で安全なコンテナサプライチェーンを構築してください。
-   **Action**:
    1.  **Tag Immutability（必須）**: イメージタグの不変性を有効化。同一タグへの上書きプッシュを防止し、デプロイの再現性を保証。`latest`タグの本番使用は厳禁、セマンティックバージョニング + コミットハッシュを使用。
    2.  **拡張スキャン（Inspector統合）**: ECR拡張スキャン（Amazon Inspector統合）を有効化。OS/言語パッケージの脆弱性を継続的に検出。プッシュ時＋新CVE公開時の自動再スキャン。Critical/High脆弱性のあるイメージのデプロイをCI/CDで自動阻止。
    3.  **ライフサイクルポリシー**: タグなしイメージの自動削除（例：プッシュ後24時間）。タグ付きイメージの世代管理（例：最新30イメージのみ保持）。ストレージコスト最適化。
    4.  **クロスリージョンレプリケーション**: マルチリージョン展開時はECRレプリケーションでイメージを自動同期。DR時のイメージ可用性を保証。クロスアカウントレプリケーションも対応。
    5.  **Pull-Through Cache**: Docker Hub/GitHub Container Registry等のパブリックレジストリをキャッシュ。外部レジストリへの依存を削減し、レート制限回避・ネットワークレイテンシ低減。
    6.  **OCI Artifact対応**: コンテナイメージだけでなく、Helmチャート・SBOM・署名等のOCIアーティファクトを保存・管理。
    7.  **イメージ署名**: AWS Signer/Sigstore(Cosign)でイメージに署名。Kubernetes Admission Controllerで署名検証を強制し、未署名イメージのデプロイを阻止。
-   **Anti-pattern**: パブリックECRリポジトリに内部イメージを公開。プライベートリポジトリを使用しIAMポリシーでアクセス制御。
-   **Cross-Ref**: コンテナセキュリティは§13/§28参照。CI/CDパイプラインは§123参照。Inspector統合は§41参照。

---

## 123. AWS CI/CDモダナイゼーション (CI/CD Modernization)

### Rule 123.1: The AWS CI/CD Pipeline Protocol
-   **Law**: AWS環境のCI/CDには**CodePipeline V2 + CodeBuild + CodeDeploy**の組み合わせ、または**Amazon CodeCatalyst**を使用し、安全で高速なデプロイパイプラインを構築してください。
-   **Action**:
    1.  **CodePipeline V2（推奨）**: パイプラインタイプV2を使用。トリガーフィルタ（ブランチ/タグ/ファイルパス）でパイプライン実行を精密制御。パイプライン変数でステージ間のデータ受け渡し。
    2.  **CodeBuild — ビルド基盤**:
        -   **Compute**: ARM（Graviton）ビルドインスタンスでコスト最適化。Lambda Computeモードで軽量ビルドのさらなるコスト削減。
        -   **キャッシュ**: S3/ローカルキャッシュでビルド時間短縮。Docker Layer Cacheでイメージビルド高速化。
        -   **セキュリティ**: VPC内ビルドでプライベートリソースアクセス。Secrets Manager統合で機密情報管理。ビルドログをCloudWatch Logsに出力。
    3.  **CodeDeploy — デプロイ戦略**:
        -   **ECS Blue/Green**: ALBターゲットグループ切替で瞬時ロールバック。テストリスナーによるカナリアテスト。
        -   **Lambda Canary/Linear**: `Canary10Percent5Minutes`等の段階的トラフィックシフト。CloudWatchアラーム連動の自動ロールバック。
        -   **EC2 Rolling**: 最小インスタンス数を維持しながらの段階的更新。
    4.  **CodeCatalyst（統合プラットフォーム）**: IDE統合（VS Code/JetBrains）。ワークフロー定義でビルド・テスト・デプロイを一元管理。マルチアカウント対応。チーム協業機能。
    5.  **パイプラインセキュリティ**: 成果物バケットのKMS暗号化。IAMポリシーでステージ別権限制御。手動承認ステージで本番デプロイの人的ゲート。
    6.  **IaCパイプラインパターン**: CDK/Terraform変更をCodePipelineで自動化。`cdk diff`/`terraform plan`の結果を承認ステージで確認後に適用。
-   **Cross-Ref**: CI/CDセキュリティは§42参照。IaCは§8/§90参照。ECRは§122参照。

---

## 124. Amazon SESメール配信 (Email Delivery Service)

### Rule 124.1: The SES Email Protocol
-   **Law**: トランザクションメール・通知メールの送信には**Amazon SES**を使用し、高到達率とコンプライアンス準拠を実現してください。
-   **Action**:
    1.  **ドメイン認証（必須）**:
        -   **DKIM**: DKIM署名を必ず有効化（Easy DKIM推奨、2048bit）。メール改竄防止と到達率向上。
        -   **SPF**: カスタムMAIL FROMドメインを設定しSPF認証をパス。
        -   **DMARC**: `p=reject`ポリシーを設定し、なりすましメールを完全拒否。DMARCレポート受信で認証状況を監視。
    2.  **Configuration Sets**: 送信イベント（配信/バウンス/苦情/開封/クリック）をKinesis Data Firehose/SNS/CloudWatchに出力。メール到達率KPIを計測。
    3.  **Virtual Deliverability Manager（VDM）**: SES VDMを有効化し、到達率最適化の推奨事項を自動取得。送信レピュテーション監視。Engagement Trackingでエンゲージメントデータを分析。
    4.  **バウンス・苦情処理（必須）**: SNSトピックでバウンス/苦情通知を受信。ハードバウンスアドレスを即時送信停止リストに追加。苦情率0.1%未満を維持（超過でアカウント停止リスク）。
    5.  **送信制限**: SESサンドボックスから本番アクセスへのリクエスト。日次送信クォータと秒間レート制限の監視。段階的なウォームアップ（新規IP/ドメイン）。
    6.  **専用IP**: 大量送信（10万通/日以上）には専用IPプールを使用。IPレピュテーションを独立管理。Managed Dedicated IPsでウォームアップ自動化。
    7.  **テンプレートエンジン**: SESテンプレートでHTMLメールを管理。Handlebarsベースの動的コンテンツ。バルク送信API（`SendBulkTemplatedEmail`）で大量送信を効率化。
-   **Anti-pattern**: FROM/REPLY-TOアドレスの不一致。バウンス処理を実装せずに大量送信。サンドボックスモードでの本番運用。
-   **Cross-Ref**: ユーザーサポートメールは`501_customer_experience.md`参照。

---

## 125. Amazon Q AI開発支援 (AI-Powered Development)

### Rule 125.1: The Amazon Q Protocol
-   **Law**: AWS環境での開発生産性向上には**Amazon Q Developer**を、企業ナレッジ検索には**Amazon Q Business**を活用し、AI支援による開発・運用の効率化を実現してください。
-   **Action**:
    1.  **Q Developer — IDE統合**:
        -   **コード補完**: VS Code/JetBrains IDEでリアルタイムコード補完。コンテキストアウェアな提案。
        -   **コードレビュー**: セキュリティ脆弱性、バグ、コード品質を自動スキャン。OWASP Top 10/CWE準拠の検出。
        -   **コード変換（Transform）**: Java 8→17等のメジャーバージョンアップグレードを自動化。.NET Frameworkから.NETへの移行支援。
        -   **チャット**: 自然言語でAWSサービスの使い方、コードの説明、デバッグ支援を取得。
    2.  **Q Developer — AWSコンソール統合**: CloudWatch/EC2/Lambda等のAWSコンソール内でエラー分析・トラブルシューティング支援。自然言語でAWSリソースの操作方法を問い合わせ。
    3.  **Q Developer — CLI統合**: AWS CLIでの自然言語→コマンド変換。`aws q chat`でターミナル内AI支援。
    4.  **Q Business — 企業ナレッジ検索**: 社内ドキュメント（Confluence/SharePoint/S3等）を統合検索。RAG（Retrieval-Augmented Generation）ベースの正確な回答生成。ソース引用付き。
    5.  **ガードレール**: Q Developerの提案コードは必ず人的レビューを通すこと。機密情報（APIキー/認証情報）の提案は自動フィルタリング。組織ポリシーに基づくカスタマイズ。
    6.  **コスト管理**: Q Developer Proプラン（$19/月/ユーザー）とFreeプランの使い分け。チーム全体のAPI呼び出し量を監視。
-   **Cross-Ref**: AI開発ツール全般は§96参照。Bedrock統合は§29/§93参照。

---

## 126. CloudTrail Lake監査分析 (Audit Analytics)

### Rule 126.1: The CloudTrail Lake Protocol
-   **Law**: AWS環境のセキュリティ監査・コンプライアンス分析には**CloudTrail Lake**を使用し、SQLベースのイベント分析基盤を構築してください。
-   **Action**:
    1.  **イベントデータストア**: 管理イベント/データイベント/インサイトイベントをCloudTrail Lakeに集約。最大2,555日（7年）の保持期間設定。コンプライアンス要件に合わせた保持戦略。
    2.  **SQLクエリ分析**: 標準SQLでイベントデータを直接クエリ。S3エクスポート+Athena連携より低レイテンシ。ダッシュボード機能でクエリ結果を可視化。
    3.  **Organizations統合**: 組織レベルのイベントデータストアで全アカウントの監査ログを一元集約。委任管理者アカウントから集中管理。
    4.  **Config統合**: AWS Config構成項目をCloudTrail Lakeに取り込み。リソース変更履歴とAPI呼び出しを相関分析。
    5.  **外部イベント統合**: オンプレミス/SaaSのイベントをCloudTrail Lake Integrationsで取り込み。ハイブリッド環境の統合監査。
    6.  **コスト最適化**: Ingestion課金（$2.50/GB、1年保持）。高頻度アクセスが不要な場合はS3+Athena（§115）を検討。CloudTrail Insightsで異常API呼び出しパターンを自動検出。
-   **Cross-Ref**: インシデントレスポンスは§21参照。脅威ハンティングは§54参照。集中ログ管理は§36参照。

---

## 127. AWS Amplify Gen 2フルスタック開発 (Full-Stack Development)

### Rule 127.1: The Amplify Gen 2 Protocol
-   **Law**: フルスタックWebアプリケーションの迅速な開発には**AWS Amplify Gen 2**を使用し、TypeScriptファーストのコード駆動インフラ定義とホスティングを統合してください。
-   **Action**:
    1.  **TypeScript-First**: フロントエンド（React/Next.js/Vue/Angular）とバックエンドリソース（Data/Auth/Storage/Functions）をTypeScriptで統一定義。型安全なクラウドリソース構成。
    2.  **Sandbox環境**: 開発者ごとの独立したSandbox環境を自動プロビジョニング。ホットリロードでバックエンド変更を即時反映。本番環境への影響ゼロで開発。
    3.  **Data（AppSync/DynamoDB）**: TypeScriptスキーマ定義からGraphQL API + DynamoDBテーブルを自動生成。リレーション定義、認可ルール、リアルタイムサブスクリプション。
    4.  **Auth（Cognito）**: 認証フローをTypeScriptで定義。ソーシャルログイン、MFA、パスワードレス認証を宣言的に構成。
    5.  **Storage（S3）**: ファイルアップロード/ダウンロードのアクセスルールをパスベースで定義。認証状態に基づく自動アクセス制御。
    6.  **Hosting**: GitベースCI/CD。ブランチごとのプレビュー環境自動生成。カスタムドメイン + SSL証明書自動プロビジョニング。Deploy Skew Protection（2025年GA）で旧バージョンアセットの配信を保証。
    7.  **AI Kit**: Amazon Bedrock統合。会話UIコンポーネントとAIバックエンドルートをTypeScriptで定義。生成AIアプリケーションの迅速な構築。
-   **vs CDK/Terraform**: Amplify = フルスタック開発の迅速化（数時間）。CDK/Terraform = 大規模インフラの精密制御（数日〜）。
-   **Cross-Ref**: Cognito認証は§118参照。AppSyncは§58参照。

---

## 128. Amazon Location Service位置情報 (Geospatial Services)

### Rule 128.1: The Location Service Protocol
-   **Law**: アプリケーションの位置情報機能には**Amazon Location Service**を使用し、プライバシーファースト設計でコスト効率の高い地理空間サービスを構築してください。
-   **Action**:
    1.  **Maps**: インタラクティブマップの表示。MapLibre GL JS/React Native統合。Esri/HERE/Open Dataプロバイダから選択。カスタムマップスタイル対応。
    2.  **Places（検索）**: 住所検索（ジオコーディング）と逆ジオコーディング。オートコンプリート検索。POI（Point of Interest）検索。
    3.  **Routes**: 最適ルート計算。マルチモーダル（車/徒歩/トラック）対応。交通情報考慮。行列ルーティング（Matrix Routing）で複数起点→終点の効率計算。
    4.  **Trackers**: デバイスの位置追跡。バッテリー最適化フィルタリング。位置履歴の保存・クエリ。IoT Core統合でIoTデバイスの位置管理。
    5.  **Geofences**: 仮想境界の定義。デバイスの入出イベントを自動検出。EventBridge統合でジオフェンストリガーワークフロー構築。最大50,000ジオフェンス/コレクション。
    6.  **プライバシー**: 位置データはAWSインフラ内で処理。データプロバイダ（Esri/HERE）への個人情報（デバイスID等）の送信なし。GDPR/CCPA準拠設計。
    7.  **コスト**: Google Maps Platform比で最大80%コスト削減。AWS Free Tierで月3ヶ月の無料利用枠。リクエスト課金モデル。
-   **Cross-Ref**: IoTデバイス統合は§84参照。EventBridge統合は§73参照。

---

## 129. AWS Service Catalogプラットフォーム工学 (Platform Engineering)

### Rule 129.1: The Service Catalog Protocol
-   **Law**: 承認済みインフラリソースのセルフサービスプロビジョニングには**AWS Service Catalog**を使用し、ガバナンスを維持しながらチームの自律性を実現してください。
-   **Action**:
    1.  **ポートフォリオ管理**: 承認済みプロダクト（CloudFormation/Terraform）をポートフォリオに整理。IAMプリンシパル/OUへのアクセス権付与。環境別（dev/staging/prod）ポートフォリオ分離。
    2.  **プロダクト定義**: CloudFormation/Terraformテンプレートをプロダクトとして登録。バージョン管理でテンプレート更新をトラッキング。制約（Constraints）でデプロイ条件を制御。
    3.  **Launch Constraints**: プロダクト起動時のIAMロールを指定。エンドユーザーに最小権限で標準化リソースの起動を許可。管理者権限の委譲なしにセルフサービスを実現。
    4.  **TagOptions**: プロビジョニング時に強制タグを適用。コスト配分タグ、環境タグ、所有者タグの自動付与。タグ付け漏れを物理的に防止。
    5.  **Organizations共有**: ポートフォリオを組織全体/特定OU/特定アカウントと共有。中央チームが管理するゴールデンパスパターンを全チームに配布。
    6.  **Terraform統合**: Terraform Cloud/Enterprise統合でHCLベースのプロダクトをService Catalogに登録。既存Terraformワークフローとの統合。
    7.  **プロビジョニングアクション**: EventBridge統合でプロビジョニングイベントを監視。自動タグ付け、承認ワークフロー、通知の自動化。
-   **Cross-Ref**: Organizations管理は§68参照。IaCは§8/§90参照。タグ戦略は§35参照。

---

## 130. AWS Transit Gatewayネットワークハブ (Network Hub)

### Rule 130.1: The Transit Gateway Protocol
-   **Law**: マルチVPC・マルチアカウント・ハイブリッドネットワークの中央ハブには**AWS Transit Gateway（TGW）**を使用し、スケーラブルで管理容易なネットワークトポロジを構築してください。
-   **Action**:
    1.  **ハブ&スポーク設計**: TGWを中央ハブとし、全VPC/VPN/Direct Connectをアタッチメントで接続。フルメッシュVPC Peering（N×(N-1)/2接続）の複雑性を排除。最大5,000 VPCアタッチメント。
    2.  **ルートテーブル分離**: ルートテーブルを用途別に分離（例：共有サービス/本番/開発/セキュリティ）。アソシエーション＋プロパゲーションでルーティングを精密制御。ブラックホールルートで特定通信を明示的に遮断。
    3.  **マルチキャスト**: TGWマルチキャストドメインでマルチキャスト配信。IGMPv2プロトコル対応。金融市場データ配信等のユースケース。
    4.  **Inter-Region Peering**: リージョン間TGW Peeringでグローバルネットワーク構築。AWSグローバルバックボーン経由の暗号化通信。リージョン間のルーティング制御。
    5.  **Network Manager**: AWS Network Managerでグローバルネットワークを一元可視化・監視。トポロジマップ、ルートアナライザー、イベント通知。CloudWatchメトリクス統合。
    6.  **Flow Logs**: TGWフローログでアタッチメント間のトラフィックを可視化。異常通信パターン検出。S3/CloudWatch Logs出力。
    7.  **コスト最適化**: アタッチメント時間課金（$0.05/h/アタッチメント）+ データ処理料金。不要なアタッチメントの定期棚卸し。同リージョン内通信はVPC Peeringの方が低コストな場合あり。
-   **vs VPC Peering**: TGW = 3+VPC環境・ハイブリッド接続・集中管理。VPC Peering = 2VPC間のシンプル接続・低コスト。
-   **Cross-Ref**: VPCネットワーキングは§2参照。Direct Connectは§131参照。PrivateLinkは§92参照。

---

## 131. AWS Direct Connect専用線接続 (Dedicated Network Connectivity)

### Rule 131.1: The Direct Connect Protocol
-   **Law**: オンプレミスとAWS間の安定的・高帯域・低レイテンシ接続には**AWS Direct Connect**を使用し、インターネット経由の不安定性を排除してください。
-   **Action**:
    1.  **接続タイプ選択**:
        -   **Dedicated Connection**: 1Gbps/10Gbps/100Gbps専用ポート。大量データ転送・低レイテンシ要件。AWS Direct Connectロケーションでの物理クロスコネクト。
        -   **Hosted Connection**: パートナー経由の50Mbps〜10Gbps。専用ポートが不要な場合。迅速なプロビジョニング。
    2.  **VIF（仮想インターフェース）**: Private VIF（VPC接続）、Public VIF（AWSパブリックサービス接続）、Transit VIF（Transit Gateway接続）を用途に応じて使い分け。
    3.  **冗長化（必須）**: 単一Direct Connect接続は単一障害点。最低2接続（異なるDXロケーション）でアクティブ/アクティブ冗長化。最大レジリエンシーモデル（4接続、2ロケーション）を推奨。SiteLink対応でDXロケーション間ダイレクト通信。
    4.  **VPN Failover**: Direct Connect障害時にSite-to-Site VPN（インターネット経由）へ自動フェイルオーバー。BGPルーティングでシームレス切替。VPN接続は常時スタンバイ。
    5.  **MACsec暗号化**: 10Gbps/100Gbps接続でMACsec（IEEE 802.1AE）レイヤ2暗号化。ネイティブの回線レベル暗号化でデータ保護。
    6.  **Link Aggregation Group（LAG）**: 複数接続を論理的にバンドルし帯域を集約。LACP（Link Aggregation Control Protocol）対応。
    7.  **コスト最適化**: ポート時間課金 + データ転送アウト課金。Data Transfer Outの多いワークロードで特にコスト効果大（EC2 Internet Out比60-80%削減）。
-   **Cross-Ref**: Transit Gatewayは§130参照。ハイブリッドアーキテクチャは§32参照。VPN接続は§32参照。

---

## 132. Amazon Detectiveセキュリティ調査 (Security Investigation)

### Rule 132.1: The Detective Investigation Protocol
-   **Law**: セキュリティインシデントの根本原因分析・調査には**Amazon Detective**を使用し、ML駆動の行動グラフ分析で迅速なフォレンジック調査を実現してください。
-   **Action**:
    1.  **自動データ収集**: CloudTrailログ、VPCフローログ、GuardDutyファインディング、EKS監査ログ、S3データイベントを自動取り込み。手動ログ収集・統合は不要。
    2.  **行動グラフ（Behavior Graph）**: ML分析で正常な行動パターンのベースラインを構築。異常な行動（通常と異なるAPI呼び出しパターン、不自然なネットワーク通信等）を自動検出。
    3.  **GuardDuty統合（推奨フロー）**: GuardDutyファインディング → Detective調査 → Security Hub集約。GuardDutyで検知→Detectiveで深堀り調査→根本原因特定のワークフロー。「Investigate in Detective」ワンクリック連携。
    4.  **Finding Groups**: 関連するファインディングを自動グループ化。単一のセキュリティイベントに関連する全活動を俯瞰。攻撃チェーン全体を可視化。
    5.  **IAM Investigation**: 特定のIAMプリンシパルの活動履歴を時系列で分析。異常なAPI呼び出し、通常と異なるリソースアクセスを検出。
    6.  **Organizations統合**: 委任管理者アカウントから全メンバーアカウントのDetectiveを集中管理。組織全体のセキュリティ調査を一元化。
-   **Anti-pattern**: GuardDutyファインディングを個別に手動調査すること。Detectiveでコンテキスト付き調査を行い調査時間を80%短縮。
-   **Cross-Ref**: GuardDutyは§6参照。Security Hubは§41参照。インシデント対応は§111参照。CloudTrail Lakeは§126参照。

---

## 133. AWS AI/ML応用サービス (Applied AI/ML Services)

### Rule 133.1: The Applied AI/ML Protocol
-   **Law**: 画像・動画解析、文書処理、自然言語処理、音声処理には**AWSのマネージドAI/MLサービス**を使用し、ML専門知識不要で高精度なAI機能を実装してください。
-   **Action**:
    1.  **Amazon Rekognition（画像・動画解析）**: 物体検出/顔分析/テキスト検出/コンテンツモデレーション/PPE検出。Custom Labels でドメイン固有の画像分類モデルを少量データ（30枚〜）で学習。ストリーミングビデオ分析（Kinesis Video Streams統合）。
    2.  **Amazon Textract（文書処理）**: OCR + 構造化データ抽出。テーブル/フォーム/署名/手書き文字を自動認識。Queries機能で特定フィールドを自然言語で指定抽出。Lending機能で住宅ローン書類を自動分類・抽出。ConfidenceScore閾値（推奨≥90%）による人的レビューフロー。
    3.  **Amazon Comprehend（自然言語処理）**: 感情分析/エンティティ抽出/キーフレーズ抽出/言語検出/トピックモデリング。PII検出・匿名化（Comprehend PII）。Custom Classification/Entity Recognition でドメイン固有NLPモデル。
    4.  **Amazon Transcribe（音声→テキスト）**: リアルタイム/バッチ音声文字起こし。カスタム語彙でドメイン用語の認識精度向上。話者分離（Speaker Diarization）。医療向け（Transcribe Medical）。コールセンター分析（Call Analytics）で感情/中断/無音を自動分析。
    5.  **Amazon Polly（テキスト→音声）**: Neural TTS で自然な音声合成。SSML対応で発音/速度/音量を制御。Brand Voice でカスタム音声作成。26言語60以上の音声。
    6.  **統合パターン**: Step Functions でAIサービスチェーンをオーケストレーション（例：S3アップロード → Textract抽出 → Comprehend分析 → DynamoDB保存）。非同期処理はSNS/SQS連携。
    7.  **コスト最適化**: 各サービスはAPI呼び出し/ページ/秒ベース課金。バッチ処理（Textract Bulk/Comprehend Async）でコスト削減。処理結果をS3/DynamoDBにキャッシュし再処理を回避。
-   **vs Bedrock（§29/§93）**: 応用AIサービス = 特定タスク（OCR/NLP/音声）の高精度実行。Bedrock = 汎用生成AI（テキスト生成/要約/対話）。
-   **Cross-Ref**: Bedrock統合は§29/§93参照。SageMakerは§59参照。Step Functions連携は§19参照。

---

## 134. AWS Snow Familyデータ移行 (Physical Data Transfer)

### Rule 134.1: The Snow Family Protocol
-   **Law**: 大規模データ移行（10TB以上）やエッジコンピューティングには**AWS Snow Family**を使用し、ネットワーク転送の制約を物理デバイスで克服してください。
-   **Action**:
    1.  **デバイス選択**:
        -   **Snowcone**: 最小デバイス（8TB HDD / 14TB SSD）。ドローン/IoTエッジ/遠隔地向け。Wi-Fi対応。DataSync Agent組込み。
        -   **Snowball Edge Storage Optimized**: 80TB利用可能ストレージ。大規模データ移行の標準選択。EC2互換コンピュート機能。S3互換エンドポイント。
        -   **Snowball Edge Compute Optimized**: 104 vCPU、416GB RAM。エッジでの重計算ワークロード。GPU（V100）オプション。ML推論/メディアトランスコード。
        -   **Snowmobile**: 100PBコンテナトラック。データセンター丸ごと移行級の超大規模転送。
    2.  **ジョブ管理**: AWSコンソール/CLIでジョブ作成。デバイスの発送・受取を追跡。OpsHub GUIツールでローカル管理。
    3.  **セキュリティ**: 256bit暗号化（KMS管理キー）。耐タンパリング設計（Trusted Platform Module）。デバイス返却後、NIST 800-88準拠のセキュアイレースを自動実行。E Ink配送ラベルで追跡。
    4.  **エッジコンピューティング**: Snowball Edge上でEC2インスタンス/Lambdaファンクション/IoT Greengrassを実行。ネットワーク非接続環境でのローカル処理。
    5.  **データ移行判断基準**: ネットワーク転送で1週間以上かかる場合（概算：100Mbps回線で10TB≈10日）はSnow Familyを検討。コスト比較：$300/デバイス vs データ転送料金。
-   **vs DataSync（§120）**: Snow Family = ネットワーク制約下の大規模一括移行/エッジ処理。DataSync = ネットワーク経由の継続的・増分転送。
-   **Cross-Ref**: データ移行戦略は§65参照。DataSyncは§120参照。S3は§5参照。

---

## 135. Amazon Lex会話AI (Conversational AI)

### Rule 135.1: The Lex Conversational AI Protocol
-   **Law**: チャットボット・音声ボットの構築には**Amazon Lex V2**を使用し、自然言語理解（NLU）によるインテリジェントな会話インターフェースを実現してください。
-   **Action**:
    1.  **Lex V2（必須）**: V1は非推奨。V2のマルチ言語/マルチインテント/ストリーミング会話対応を使用。100以上のインテントスロット。コンテキスト管理で複数ターンの会話フロー。
    2.  **Bedrock統合（2024年GA）**: QnABotインテントでBedrock基盤モデルを活用したFAQ応答。Lex会話フロー内から生成AIの知識ベースにフォールバック。構造化会話＋生成AI応答のハイブリッド設計。
    3.  **Connect統合**: Amazon Connect コンタクトセンターとネイティブ統合。IVR（自動音声応答）でのインテント認識。通話中のリアルタイム感情分析+エージェントアシスト。
    4.  **チャネル統合**: Slack/Facebook Messenger/Twilio SMS/Web（React/JavaScript SDK）への展開。マルチチャネル同一ボット定義。
    5.  **テスト**: 自動テスト機能で会話フローをバッチ検証。テストセット（期待インテント+スロット値）を定義しNLU精度を計測。
    6.  **セキュリティ**: 会話ログのCloudWatchへの出力（機密データマスキング対応）。IAMポリシーでボット/エイリアス単位のアクセス制御。VPCプライベートAPI対応。
-   **vs Bedrock Agents（§101）**: Lex = 構造化会話フロー（注文受付/予約等）。Bedrock Agents = 非構造化タスク実行（調査/分析等）。
-   **Cross-Ref**: AI実装全般は`400_ai_engineering.md`参照。Connectは§84参照。

---

## 136. Amazon WorkSpaces仮想デスクトップ (Virtual Desktop Infrastructure)

### Rule 136.1: The WorkSpaces VDI Protocol
-   **Law**: セキュアなリモートデスクトップ環境には**Amazon WorkSpaces**を使用し、エンドポイントからのデータ漏洩リスクをゼロ化してください。
-   **Action**:
    1.  **WorkSpaces Thin Client**: 専用デバイスでローカルデータ保存ゼロ。BYOD環境でのセキュリティ強化。Fire TV Cube上での動作。
    2.  **バンドル選択**: Value/Standard/Performance/Power/PowerPro/Graphicsの各バンドルから業務要件に応じて選択。GPU対応バンドルでCAD/3Dレンダリング。
    3.  **料金モデル**: AlwaysOn（月額固定、フルタイム利用者向け）vs AutoStop（時間課金、パートタイム利用者向け）。利用パターン分析で最適モデル選択。
    4.  **WorkSpaces Pools（2024年GA）**: 非永続デスクトップのプール。多人数で共有。セッションベースの課金。コスト効率の高いタスクワーカー向け。
    5.  **セキュリティ**: IPアクセス制御グループでアクセス元IP制限。ローカルデバイスへのコピー/印刷/クリップボード転送を無効化可能。MFA統合（RADIUS/SAML IdP）。PCoIP/WSP（WorkSpaces Streaming Protocol）による暗号化通信。
    6.  **Directory統合**: AWS Managed Microsoft AD / AD Connector / Simple AD連携。既存Active Directory環境との統合認証。
    7.  **イメージ管理**: WorkSpaces Image Builder でカスタムイメージを作成。アプリケーション更新を一括展開。BYOL（持込みライセンス）対応。
-   **Cross-Ref**: IAM認証全般は§1参照。ゼロトラストは§60参照。

---

## 137. AWS Elemental MediaConvertメディア処理 (Media Processing)

### Rule 137.1: The MediaConvert Protocol
-   **Law**: 動画トランスコード・メディアパッケージングには**AWS Elemental MediaConvert**を使用し、サーバーレスで大規模動画処理パイプラインを構築してください。
-   **Action**:
    1.  **サーバーレストランスコード**: インフラ管理不要。S3入力→トランスコード→S3出力。ABR（Adaptive Bitrate）ラダーでHLS/DASH/CMAF出力。H.264/H.265/VP9/AV1コーデック対応。
    2.  **品質定義出力（QVBR）**: 知覚品質を一定に保ちながらビットレート最適化。従来CBR比最大50%のファイルサイズ削減。Quality Level 7推奨。
    3.  **HDR対応**: HDR10/HDR10+/Dolby Vision変換。SDR→HDRアップコンバート。DolbyアトモスオーディオPassthrough。
    4.  **DRM（デジタル著作権管理）**: SPEKE v2統合でFairPlay/Widevine/PlayReady暗号化。マルチDRMパッケージング。コンテンツ保護の一元管理。
    5.  **自動化パイプライン**: S3イベント → EventBridge → Lambda → MediaConvertジョブ。Step Functionsで複雑なワークフロー（トランスコード→サムネイル生成→メタデータ抽出→CloudFront配信）をオーケストレーション。
    6.  **予約キュー**: 予約価格キュー（Reserved Pricing）で最大75%コスト削減。高頻度ジョブ向け。オンデマンドキューとの使い分け。
    7.  **アクセラレーテッドトランスコード**: Professional Tierで高速並列処理。大規模ファイル（1時間以上のコンテンツ）の処理時間短縮。
-   **Cross-Ref**: CloudFront配信は§20/§39参照。S3ストレージは§5/§78参照。EventBridge統合は§73参照。

---

## 138. AWS DevOps Agent — AIインシデント対応 (AI-Powered Incident Response)

### Rule 138.1: The DevOps Agent Protocol
-   **Law**: インシデントの自動調査・根本原因分析・緩和計画の策定には**AWS DevOps Agent**を活用し、インシデント対応時間を数時間から数分に短縮してください（Public Preview・2025年末）。
-   **Action**:
    1.  **自動インシデント調査**: アラートトリガー時点で自動的に調査を開始。CloudWatch・Datadog・New Relic・Splunk等のオブザーバビリティツール、コードリポジトリ（GitHub/GitLab）を横断的に相関分析。
    2.  **根本原因分析・緩和計画**: AIが推定される根本原因を特定し、具体的な緩和アクションと実装ガイダンスを含む緩和計画を生成。エラーハンドリングの監視改善提案も含む。
    3.  **予防的信頼性向上**: 過去のインシデントパターンを分析し、再発防止のための構造的改善提案を自動生成。オブザーバビリティ強化・インフラ最適化・デプロイパイプライン改善・アプリケーションレジリエンス強化。
    4.  **統合・連携**: ServiceNow/PagerDutyとのインシデント管理プラットフォーム連携。Slack経由での調査結果・緩和ステップの共有。AWS Supportケースの自動作成（調査コンテキスト付き）。
    5.  **継続的学習**: フィードバックに基づき推奈事項を継続的に改善。組織固有のパターンを学習し、反応的な消防活動から予防的な運用改善へ移行。
    6.  **利用上の注意**: Preview段階のため、本番ワークロードの最終的なインシデント対応判断は必ず人間が確認。DevOps Agentの提案をそのまま本番環境に適用せず、必ずレビュープロセスを経由。us-east-1リージョンで利用可能。
-   **Anti-pattern**: DevOps Agentの緩和提案を人的レビューなしで本番環境に適用すること。あくまで「調査支援・提案生成」ツールとして活用。
-   **Cross-Ref**: インシデントレスポンスは§21参照。Security Incident Responseは§111参照。CloudWatchオブザーバビリティは§7参照。

---

## 139. AWS Resource Explorerリソース検索基盤 (Multi-Account Resource Discovery)

### Rule 139.1: The Resource Explorer Protocol
-   **Law**: マルチアカウント環境のリソース検索・発見には**AWS Resource Explorer**を使用し、全アカウント・全リージョンのリソースを統一的に検索可能にしてください。
-   **Action**:
    1.  **Aggregator Index**: 1つのアカウント・リージョンにAggregator Indexを作成し、Organizations全体のリソースメタデータを集約。検索の単一エントリーポイントを確立。
    2.  **Local Index**: 各アカウント・リージョンにLocal Indexを有効化し、Aggregatorへのメタデータ自動同期を設定。
    3.  **統一タグ検索**: Resource Explorerのタグベースフィルタリングで、§8.4のタギング戦略と連携。`Environment=production` や `Owner=team-backend` でのクロスアカウント検索を実現。
    4.  **View定義**: 目的別のリソースビュー（例：全EC2インスタンス、未タグリソース、特定プロジェクトのリソース）を定義。チームごとの可視性を管理。
    5.  **コスト可視化連携**: Resource Explorerで発見した未タグ・未管理リソースをCost Explorer/Budgets（§9参照）と突合し、ゾンビリソースの特定を加速。
    6.  **セキュリティ監査**: Resource Explorerで「パブリックアクセス可能なリソース」「暗号化未設定リソース」を定期検索し、セキュリティ不備を早期発見。
-   **Cross-Ref**: タグ戦略は§8.4参照。Organizations管理は§0.4/§26/§68参照。Config Rulesは§81参照。

---

## 140. EventBridge Pipesポイントツーポイント統合 (Point-to-Point Integration)

### Rule 140.1: The EventBridge Pipes Protocol
-   **Law**: ソースからターゲットへの1対1のイベント駆動統合には**Amazon EventBridge Pipes**を使用し、Lambda関数の「グルーコード」を排除してください。
-   **Action**:
    1.  **ソース対応**: SQS、Kinesis、DynamoDB Streams、Amazon MQ、Apache Kafka (MSK)、Self-Managed Kafkaをソースとしてサポート。ポーリングロジックの自前実装が不要。
    2.  **フィルタリング**: ソースからのイベントをPipeレベルでフィルタリングし、不要なイベントの処理を排除。ターゲットに到達するイベント量を削減しコスト最適化。
    3.  **エンリッチメント（Enrichment）**: Lambda関数、Step Functions、API Gateway、EventBridge API Destinationsを使用して、ターゲットに送信する前にイベントデータを拡張・変換。
    4.  **入力変換（Input Transformation）**: JSONPathベースの変換でターゲットが期待するフォーマットにデータを整形。Lambda不要。
    5.  **ターゲット**: Step Functions、Lambda、SQS、SNS、Kinesis、EventBridge Event Bus、API Gateway、CloudWatch Logs等の14以上のAWSサービスに直接配信。
    6.  **コスト最適化**: フィルタリングで不要イベントを早期排除し、ターゲット側の処理コストを削減。Lambdaグルーコードの排除によりLambda実行コストもゼロに。
-   **vs EventBridge Event Bus**: Pipes = 1対1のポイントツーポイント統合（フィルタ・変換・エンリッチ内蔵）。Event Bus = 1対多のファンアウトイベントルーティング。
-   **Anti-pattern**: SQS→Lambda→Step Functionsのようなグルーコードパターン。Pipesで直接SQS→Step Functionsを実現可能。
-   **Cross-Ref**: EventBridge Event Busは§17/§73参照。Step Functionsは§19参照。

---

## 141. S3 Express One Zone超低レイテンシストレージ (Ultra-Low Latency Storage)

### Rule 141.1: The S3 Express One Zone Protocol
-   **Law**: ML学習データ、分析中間結果、高頻度アクセスの一時データには**Amazon S3 Express One Zone**を使用し、S3 Standard比最大10倍の高速アクセスを実現してください（2023年GA・継続拡張中）。
-   **Action**:
    1.  **ディレクトリバケット**: S3 Express One Zoneは「ディレクトリバケット」として作成。従来のS3汎用バケットとは異なるバケットタイプ。`CreateSession` APIによるセッションベース認証でリクエスト認証オーバーヘッドを削減。
    2.  **AZ配置**: 単一AZ内にデータを配置し物理的な近接性で低レイテンシを実現。**同一AZ内のEC2/EKS/EMR/SageMaker**からアクセスする際に最大効果。AZ IDを一致させることが重要。
    3.  **最適ユースケース**:
        -   **ML学習データ**: SageMaker/EKSからのチェックポイント読み書き。学習ジョブの入出力を高速化。
        -   **分析中間データ**: Spark/Athena/EMRのシャッフルデータ・中間結果の一時保存。
        -   **高頻度読み書き**: 秒間数十万リクエストの低レイテンシワークロード。
    4.  **コスト特性**: ストレージ単価はS3 Standard比で約50%高いが、リクエスト料金は約50%安い。高リクエスト頻度のワークロードでトータルコスト削減。
    5.  **制限事項**: 単一AZ（耐障害性はS3 Standardの11 9's対比で低い）。ライフサイクルポリシー非対応。S3 Standardへのコピーでデータ永続性を担保する設計を推奨。
-   **Anti-pattern**: 長期保管・低頻度アクセスデータにExpress One Zoneを使用すること。Standard/Glacier等の適切なクラスを選択。
-   **Cross-Ref**: S3ストレージ階層は§5.2参照。S3セキュリティは§5.1参照。ML基盤は§59/§106参照。

---

## 142. Lambda Durable Functions耐久ワークフロー (Durable Workflow Orchestration)

### Rule 142.1: The Lambda Durable Functions Protocol
-   **Law**: マルチステップワークフロー・長時間実行タスク・AIエージェントオーケストレーションには**Lambda Durable Functions**を使用し、インフラ管理なしで信頼性の高いワークフローを構築してください（2025年12月GA）。
-   **Action**:
    1.  **自動チェックポイント**: Durable Functionsは実行中の状態を自動的にチェックポイントし、障害発生時に中断箇所から再開。手動でのステート管理やDLQ設計が不要。
    2.  **最大1年のサスペンド**: 外部イベント（承認フロー、人間のレビュー等）の待機中に実行を最大1年間サスペンド可能。Provisioned Concurrencyのコストなしでロングランニングプロセスを実現。
    3.  **AIエージェントワークフロー**: LLMのツール選択 → 外部API呼び出し → 結果統合のマルチステップAIエージェントフローをDurable Functionsで構築。Bedrock AgentCoreとの組み合わせでエンタープライズ級エージェントを実現。
    4.  **サガパターン**: マイクロサービス間の分散トランザクションをDurable Functionsのサガパターンで実装。各ステップの補償アクション（ロールバック）を宣言的に定義。
    5.  **コスト特性**: 実行中のステップのみ課金（サスペンド中は無課金）。Step Functionsと比較して、細粒度のステップ実行が多いワークフローでコスト優位。
    6.  **選択基準**:
        | 特性 | Lambda Durable Functions | Step Functions |
        |:-----|:------------------------|:---------------|
        | 実行モデル | コード内でオーケストレーション | JSONベースASL定義 |
        | 最大実行時間 | 最大1年（サスペンド含む） | 最大1年（Standard） |
        | チェックポイント | 自動 | ステートマシン管理 |
        | 最適ユースケース | コード中心のワークフロー/AIエージェント | ビジュアル定義/AWS統合重視 |
        | 言語サポート | Python/Node.js（初期） | 全Lambda言語 |
-   **Anti-pattern**: 単純なイベント駆動処理にDurable Functionsを使用すること。単一ステップの関数には通常のLambdaが適切。
-   **Cross-Ref**: Lambda基本は§3.2/§79参照。Step Functionsは§19参照。Bedrock AgentCoreは§101参照。

---

## 143. AWS Interconnectマルチクラウド接続 (Multi-Cloud Private Connectivity)

### Rule 143.1: The AWS Interconnect Protocol
-   **Law**: マルチクラウド環境（AWS + Google Cloud / Azure）間の高速プライベート接続には**AWS Interconnect**を使用し、パブリックインターネットを経由しないセキュアな専用帯域接続を確立してください（2025年11月Preview、Google Cloud初期パートナー）。
-   **Action**:
    1.  **専用帯域接続**: AWS VPCとGoogle Cloud VPCをAWS Interconnect経由で直接接続。パブリックインターネットを経由せず、専用帯域で低レイテンシ・高スループットのマルチクラウド通信を実現。
    2.  **接続設定**: AWSコンソールから接続を作成し、VPC・帯域幅を指定。Google Cloud側でVPN Gatewayまたは Partner Interconnectを設定し相互接続。
    3.  **データレジデンシー**: マルチクラウド間のデータ転送が特定の地理的経路（国内等）を経由することを保証。データ主権要件への対応。
    4.  **ユースケース**:
        -   **マルチクラウドデータメッシュ**: AWS上のデータレイクとGoogle Cloud BigQuery間の高速データ連携。
        -   **DR/BCPマルチクラウド**: プライマリ（AWS）→ セカンダリ（Google Cloud）のDR構成。
        -   **ベストオブブリード**: 各クラウドの最適サービスを組み合わせ（例：AWS上のアプリ + Google Cloud上のBigQuery/Vertex AI）。
    5.  **Azure対応**: 2026年中にMicrosoft Azureとの接続をサポート予定。マルチクラウド戦略の全体設計にあらかじめ含めておく。
    6.  **コスト考慮**: 接続の帯域幅とデータ転送量で課金。Direct Connectと同様のコストモデル。大規模データ転送では事前にコスト見積もりを実施。
-   **vs Direct Connect（§131）**: Interconnect = マルチクラウド間接続。Direct Connect = オンプレミス ↔ AWS間の専用線接続。
-   **Cross-Ref**: Direct Connectは§131参照。Transit Gatewayは§130/§2.6参照。データ主権は§64参照。

---

## 144. EKS Capabilities マネージドK8sツール群 (Managed Kubernetes Tooling)

### Rule 144.1: The EKS Capabilities Protocol
-   **Law**: EKSクラスターのCI/CD・AWSリソース管理・動的リソースオーケストレーションには**Amazon EKS Capabilities**を使用し、Kubernetes運用の自動化と標準化を実現してください（re:Invent 2025 GA）。
-   **Action**:
    1.  **Continuous Deployment (Argo CD)**: EKS Capabilitiesに統合されたArgo CDでGitOpsベースの継続的デプロイを実現。AWS管理サービスアカウントで動作し、Argo CDの運用管理（インストール/アップグレード/スケーリング）が不要。
    2.  **AWS Controllers for Kubernetes (ACK)**: Kubernetes Custom Resource (CR) として S3バケット、RDSインスタンス、SQSキュー等のAWSリソースをKubernetesマニフェストから宣言的に管理。`kubectl apply` でAWSリソースのプロビジョニング。
    3.  **Kube Resource Orchestrator (KRO)**: 複数のKubernetesリソースとAWSリソースを論理グループとしてバンドルし、単一のAPIで管理。開発者は「アプリケーション」単位でデプロイ可能。プラットフォームチームが自社用APIを定義可能。
    4.  **運用モデル**: 全てAWS管理サービスアカウント上で実行され、顧客のノード/Pod上にはデプロイされない。コンピューティングコストの追加負担なし。
    5.  **有効化**: EKSコンソールまたはCLIでCapabilitiesを有効化。既存クラスターへの後付けも可能。
-   **vs 自前ツール管理**: EKS Capabilities = AWSマネージド（パッチ/スケーリング自動）。自前Argo CD = 運用負荷大（アップグレード/HA構成の自前管理）。新規クラスターではEKS Capabilities標準採用を推奨。
-   **Cross-Ref**: EKS高度運用は§70参照。EKS Auto Modeは§3.3参照。CI/CDは§42/§123参照。

---

## 145. Amazon Novaモデルファミリー (Nova AI Foundation Models)

### Rule 145.1: The Nova AI Model Strategy
-   **Law**: AWSネイティブの基盤モデルとして**Amazon Nova**ファミリーを活用し、コスト効率とパフォーマンスのバランスを最適化してください（Nova 2: re:Invent 2025〜）。
-   **Action**:
    1.  **Nova 2 Lite**: 高速・低コストの推論モデル。日常的なテキスト生成・分類・要約タスクに最適。レイテンシ最小化が求められるリアルタイムアプリケーションの第一候補。
    2.  **Nova 2 Pro**: 複雑な多段階推論・分析タスク向け。コード生成、長文分析、エージェント型ワークフローの中核モデル。（Preview → 2026年GA予定）
    3.  **Nova 2 Sonic**: 音声-音声（Speech-to-Speech）の会話型AIモデル。低レイテンシのリアルタイム音声対話を実現。コンタクトセンター・音声アシスタント向け。
    4.  **Nova 2 Omni**: マルチモーダル推論（テキスト・画像・音声・動画入力 → テキスト・画像出力）。全入力モーダリティの統一処理。（Preview → 2026年GA予定）
    5.  **Nova Forge**: 自社データでカスタムNovaモデルを構築。「Open Training」アプローチで学習データ・ハイパーパラメータを完全制御。ドメイン特化モデルの構築に最適。
    6.  **Nova Act**: AIエージェントによるブラウザ操作自動化。Webフォーム入力・データ収集・業務プロセス自動化で最大90%の信頼性。エンタープライズRPA代替。
    7.  **モデル選択ガイドライン**:
        | モデル | 推奨ユースケース | コスト効率 |
        |:-------|:----------------|:-----------|
        | Nova 2 Lite | FAQ応答、分類、要約 | ★★★★★ |
        | Nova 2 Pro | コード生成、複雑分析、エージェント | ★★★☆☆ |
        | Nova 2 Sonic | 音声対話、コンタクトセンター | ★★★★☆ |
        | Nova 2 Omni | マルチモーダル分析 | ★★★☆☆ |
        | Nova Forge | ドメイン特化カスタムモデル | ★★☆☆☆（初期投資大） |
-   **Cross-Ref**: Bedrock統合は§29/§93/§99参照。AI実装全般は`400_ai_engineering.md`参照。

---

## 146. VPC Encryption Controls ネットワーク暗号化制御 (Network Traffic Encryption)

### Rule 146.1: The VPC Encryption Controls Protocol
-   **Law**: VPC内のネットワークトラフィックの暗号化を組織レベルで宣言的に制御するため、**VPC Encryption Controls**を有効化してください（2025年11月GA）。
-   **Action**:
    1.  **宣言的暗号化**: VPCレベルで「全インスタンス間トラフィックの暗号化」を宣言的に有効化。アプリケーションコードの変更なしで、VPC内の全EC2インスタンス間通信を自動暗号化。
    2.  **Nitro System統合**: 暗号化はAWS Nitroハードウェア上でオフロード処理されるため、アプリケーションのパフォーマンスへの影響は極小（通常<5%のスループット低下）。
    3.  **コンプライアンス対応**: PCI-DSS要件3.5/4.1、HIPAA、GDPR等の「転送時暗号化」要件を、ネットワーク層で一括充足。TLSの個別実装漏れリスクを物理的に排除。
    4.  **Organizations展開**: AWS Organizations SCPと連携し、全アカウント・全VPCでの暗号化有効化を強制。開発者個人の設定漏れを防止。
    5.  **既存VPC対応**: 既存VPCに対しても後付けで有効化可能。段階的ロールアウト（Dev → Staging → Production の順）を推奨。有効化前後のネットワークパフォーマンスベンチマーク比較を実施。
    6.  **監視**: VPC Flow Logsの暗号化ステータスフィールドで、暗号化されていないトラフィックを検知。Config Ruleでの自動コンプライアンスチェック。
-   **vs アプリケーション層TLS**: VPC Encryption Controls = ネットワーク層での一括暗号化（運用簡素化）。アプリケーション層TLS = エンドツーエンド暗号化（より厳密だが運用コスト大）。併用を推奨。
-   **Cross-Ref**: VPCネットワーキングは§2参照。暗号化基準は§12参照。コンプライアンスは§14/§46参照。

---

## 147. Data Perimeterデータ境界戦略 (Organization-Wide Data Boundary)

### Rule 147.1: The Data Perimeter Strategy
-   **Law**: AWS環境全体のデータ境界（Data Perimeter）を**SCP + RCP + VPCエンドポイントポリシー**の3層構造で構築し、「信頼されたアイデンティティのみが、信頼されたリソースに、期待されるネットワークからのみアクセス可能」な状態を保証してください。
-   **Action**:
    1.  **3層境界モデル**:
        -   **Identity Perimeter（SCP）**: 「誰がアクセスできるか」。Organization内のプリンシパルのみがリソースにアクセス可能にする。`aws:PrincipalOrgID` 条件キーで外部アカウントからのアクセスを拒否。
        -   **Resource Perimeter（RCP）**: 「どのリソースにアクセスできるか」。Organization内のリソースへのアクセスのみ許可。意図しない外部リソースへのデータ流出を防止。
        -   **Network Perimeter（VPCエンドポイントポリシー）**: 「どのネットワークからアクセスするか」。VPCエンドポイント経由のアクセスのみ許可し、インターネット経由のデータアクセスを遮断。
    2.  **Data Perimeter Helper**: AWSが提供する**Data Perimeter Helper**ツールを活用し、CloudTrailログを分析してデータ境界ポリシーのドライランを実施。既存ワークロードへの影響を事前に評価。
    3.  **段階的適用**: まずS3バケット（データ流出リスク最大）から境界を適用し、順次SQS・SNS・KMS等に拡大。
    4.  **例外管理**: AWSサービスプリンシパル（`*.amazonaws.com`）やサードパーティ統合に必要な例外を `aws:PrincipalIsAWSService` 等の条件キーで明示的に許可。例外は四半期ごとにレビュー。
    5.  **監視**: CloudTrail + Security HubでData Perimeterポリシー違反を検知。自動アラートでポリシー外のアクセス試行を即時通知。
-   **Reference — S3 Data Perimeter RCPポリシー例**:
    ```json
    {
      "Version": "2012-10-17",
      "Statement": [{
        "Sid": "EnforceOrgIdentity",
        "Effect": "Deny",
        "Principal": "*",
        "Action": "s3:*",
        "Resource": "*",
        "Condition": {
          "StringNotEqualsIfExists": {
            "aws:PrincipalOrgID": "o-xxxxxxxxxxxx"
          },
          "BoolIfExists": {
            "aws:PrincipalIsAWSService": "false"
          }
        }
      }]
    }
    ```
-   **Cross-Ref**: SCP/RCPは§14.2/§68参照。VPCエンドポイントは§2.4/§92参照。セキュリティは§6/§60参照。

---

## 148. Passkey/FIDO2 MFA必須化プロトコル (Phishing-Resistant MFA Mandate)

### Rule 148.1: The Passkey/FIDO2 MFA Mandate
-   **Law**: 全AWSアカウントのルートユーザーおよび管理者ユーザーに**フィッシング耐性のあるMFA（FIDO2 Passkey / ハードウェアセキュリティキー）**を義務付け、従来のTOTP/SMS MFAからの完全移行を計画してください。
-   **Action**:
    1.  **ルートユーザーMFA必須（2024年5月〜）**: スタンドアロンAWSアカウントのルートユーザーへのMFA強制が段階的にロールアウト。コンソールサインイン時にMFA登録を要求（猶予期間35日）。
    2.  **メンバーアカウント拡大（2025年春〜）**: AWS Organizations内のメンバーアカウントのルートユーザーにもMFA要件を拡大適用。
    3.  **FIDO2 Passkey推奨**: YubiKey等のハードウェアセキュリティキー、またはデバイス内蔵のPasskey（Touch ID / Windows Hello）を最優先で設定。フィッシング攻撃に対する完全耐性。
    4.  **移行ロードマップ**:
        | フェーズ | 期間 | アクション |
        |:---------|:-----|:-----------|
        | P1 | 即時 | ルートユーザーにFIDO2/Passkey MFAを設定 |
        | P2 | 〜3ヶ月 | 全管理者IAMユーザー/Identity CenterユーザーにFIDO2を設定 |
        | P3 | 〜6ヶ月 | SCPで非FIDO2 MFAデバイスの新規登録を拒否 |
        | P4 | 〜12ヶ月 | 全ユーザーのTOTP MFAを廃止、FIDO2に完全移行 |
    5.  **Identity Center統合**: IAM Identity CenterでPasskeyをデフォルトMFA方式として設定。外部IdP（Okta/Azure AD）のPasskeyポリシーとの整合性を確保。
    6.  **監査**: IAM Credential Reportで非FIDO2 MFAデバイスを使用しているユーザーを月次で検出・是正。
-   **Anti-pattern**: SMS MFAを「十分なMFA」として放置すること。SIMスワッピング攻撃のリスクあり。FIDO2への移行を計画的に実施。
-   **Cross-Ref**: IAMセキュリティは§1参照。MFA基本は§1.3参照。Identity Centerは§22参照。

---

## 149. AWS Outposts第2世代 & Local Zones 2.0 (Hybrid & Edge Gen2)

### Rule 149.1: The Outposts Gen2 & Local Zones 2.0 Protocol
-   **Law**: オンプレミス/エッジ環境でのAWSサービス利用には最新世代の**Outposts Rack Gen2**および**Local Zones 2.0**を採用し、ハイブリッドアーキテクチャの性能と運用効率を最大化してください。
-   **Action**:
    1.  **Outposts Rack Gen2（2025年）**: 最新x86 EC2インスタンスをサポート。ネットワーク性能の大幅向上。Gravitonインスタンスのオンプレミス提供拡大。EKS Hybrid Nodesとの統合強化。
    2.  **Local Zones 2.0（2025年）**: 低レイテンシの強化（1桁ms以内のサービス提供）。5G Mobile Edge Computing (MEC) との統合拡張。AI/ML推論のエッジデプロイをサポート。
    3.  **ハイブリッドパターン選定**:
        | 要件 | 推奨サービス |
        |:-----|:-------------|
        | フルAWS体験をオンプレミスで | Outposts Rack Gen2 |
        | 低レイテンシ（都市レベル） | Local Zones 2.0 |
        | エッジ（通信事業者網内） | Wavelength |
        | 小規模エッジ/IoT | EKS Hybrid Nodes + Greengrass |
    4.  **データローカリティ**: データ主権要件がある場合、Outposts上のS3/RDS/EBS等でデータをオンプレミスに保持しつつ、AWS APIで操作。
    5.  **運用**: Outposts/Local Zonesのリソースは通常のAWSコンソール・CLI・IaCから一元管理。Monitoringは CloudWatch（オンプレミスAgent経由）で統合。
-   **Cross-Ref**: 既存のOutposts/Local Zones/Wavelengthは§97参照。EKS Hybrid Nodesは§13.2参照。エッジコンピューティングは§39参照。

---

## 150. Amazon Transformエージェント型モダナイゼーション (Agentic Application Modernization)

### Rule 150.1: The Amazon Transform Protocol
-   **Law**: レガシーアプリケーション・インフラのモダナイゼーションには**Amazon Transform**を活用し、AIエージェントによる自動分析・変換・検証でモダナイゼーションコストと時間を削減してください（2025年GA）。
-   **Action**:
    1.  **自動分析**: レガシーコードベース（COBOL、Java EE、.NET Framework等）をAIエージェントが自動解析し、依存関係マップ・移行リスク・推奨アーキテクチャを生成。
    2.  **コード変換**: レガシーコードをモダンスタック（Java 17+、.NET 8+、Python、TypeScript等）に自動変換。テストケースの自動生成を含む。
    3.  **インフラ移行**: オンプレミスVMware/物理サーバーからAWSネイティブサービス（ECS/EKS/Lambda等）への移行計画を自動策定。
    4.  **検証自動化**: 変換後のコード/インフラの機能的等価性を自動テストで検証。回帰テストスイートの自動生成。
    5.  **段階的アプローチ**: ストラングラーフィグパターンを適用し、レガシーシステムを段階的にモダンサービスに置換。全面刷新ではなく段階的移行を推奨。
-   **vs 手動移行**: Transform = AI駆動で移行速度3-5倍。手動移行 = 人的リソース大、品質ばらつきあり。ただしTransformの出力は必ず人間がレビュー。
-   **Cross-Ref**: マイグレーション戦略は§65参照。CI/CDは§42/§123参照。

---

## 151. AWS Data Transfer Terminal物理データ転送端末 (Physical Data Upload Terminal)

### Rule 151.1: The Data Transfer Terminal Protocol
-   **Law**: 大規模データセットの初期アップロードには**AWS Data Transfer Terminal**を活用し、物理ストレージデバイスをAWSデータセンター近隣の転送端末に直接持ち込んで高速転送を実現してください（2025年〜）。
-   **Action**:
    1.  **物理持ち込み**: NVMe SSD/HDD等のストレージデバイスをAWSが指定するData Transfer Terminal拠点に持ち込み、超高速ネットワーク経由でS3に直接アップロード。
    2.  **転送速度**: ネットワーク制約なし（ローカル接続）。テラバイト級データを数時間でS3に転送。Snow Family（数日の輸送時間）と比較して即時性が優位。
    3.  **ユースケース**: メディア/映像制作（4K/8K素材）、科学計算データ、データセンター移行の初期一括転送。
    4.  **セキュリティ**: 暗号化済みデバイスのみ受付推奨。転送完了後のデバイスセキュアイレース証明書を発行。
    5.  **vs Snow Family（§134）**: Terminal = 自分でデバイスを持ち込む（即時性重視）。Snow Family = AWSがデバイスを発送（リモートロケーション対応）。
-   **Cross-Ref**: Snow Familyは§134参照。DataSyncは§120参照。データ移行戦略は§65参照。

---

## 152. AWS Green Insightsサステナビリティ管理 (Carbon Footprint & Sustainability Management)

### Rule 152.1: The Green Insights Protocol
-   **Law**: クラウドインフラのカーボンフットプリントの可視化と削減には**AWS Green Insights**を活用し、サステナビリティを測定可能な運用メトリクスとして管理してください（2025年GA）。
-   **Action**:
    1.  **リソース別CO2可視化**: AWSリソースごと（EC2、S3、RDS等）のCO2排出量を推定・可視化。どのサービス/リージョンが環境負荷最大かをデータ駆動で特定。
    2.  **最適化提案**: Green Insightsが具体的なサステナビリティ改善アクションを提案。例：Graviton移行によるCO2削減量の推定、非ピーク時スケールダウン効果の定量化、リージョン変更による再生可能エネルギー比率改善。
    3.  **サステナビリティKPIダッシュボード**: CloudWatchカスタムダッシュボードにGreen Insightsメトリクスを統合。月次でCO2排出削減量を追跡。サステナビリティ目標の進捗を定量管理。
    4.  **レポーティング**: ESG報告書・サステナビリティレポート向けのデータをGreen Insightsからエクスポート。Scope 1/2/3排出量の定期レビュー。
    5.  **AWSの2025年実績**: AWSは2025年に事業運営における100%再生可能エネルギーを達成済み。リージョン選択時にこの実績を考慮。
-   **vs Customer Carbon Footprint Tool**: Green Insights = リソース別詳細分析 + 改善提案。CCFT = アカウント全体のマクロ指標。両方を活用。
-   **Cross-Ref**: サステナビリティ基本は§15参照。FinOpsは§9/§37/§74参照。Green SREは`502_site_reliability.md`参照。

---

## 153. AWS Shield AI駆動脅威検知 (AI-Enhanced DDoS Protection)

### Rule 153.1: The Shield AI-Driven Protection Protocol
-   **Law**: DDoS保護の高度化として**AWS Shield**のAI駆動脅威検知機能を活用し、従来のルールベース検知では対応困難な高度DDoS攻撃を自動検知・緩和してください（2025年拡張）。
-   **Action**:
    1.  **AI検知モデル**: Shield Advancedが機械学習モデルでトラフィックパターンのベースラインを学習し、通常のトラフィック増加（キャンペーン等）とDDoS攻撃を自動識別。誤検知率の大幅削減。
    2.  **自動緩和**: 検知した攻撃に対してAIが最適な緩和ルールを自動生成・適用。レスポンス時間を秒単位に短縮。
    3.  **L7 Application DDoS**: HTTP/HTTPSレベルのアプリケーション層攻撃（Slowloris、HTTP Flood等）の高精度検知。WAFルールの自動調整。
    4.  **Shield Response Team (SRT) 連携**: Shield AdvancedのSRTサポートとAI検知を組み合わせ、大規模攻撃時のエキスパート支援を即座に起動。
    5.  **コスト保護**: Shield Advancedの DDoS Cost Protection機能でDDoS攻撃に起因するスケーリングコストを自動カバー。
-   **Cross-Ref**: WAF/Shield基本は§6.4/§72参照。ネットワークセキュリティは§30/§94参照。インシデント対応は§21/§111参照。

---

## 154. Billing Custom Views & Split Cost Allocation (高度コストガバナンス)

### Rule 154.1: The Advanced Cost Governance Protocol
-   **Law**: コストの可視性と正確な配分のため、**AWS Billing Custom Views**でチーム別・プロジェクト別のコストビューを構築し、**Split Cost Allocation Data**で共有リソースのコストを公正に分割してください。
-   **Action**:
    1.  **Billing Custom Views（2025年GA）**: 従来のCost Explorerのプリセットビューに加え、カスタムフィルタ・グルーピング・計算フィールドを定義した専用コストビューを作成。チームごとのコストダッシュボードを構築。
    2.  **Split Cost Allocation Data**: EKSクラスター、ElastiCacheクラスター、ECS共有サービス等のマルチテナント共有リソースのコストを、実際の使用量（CPU/メモリ/ストレージ消費）に基づいてテナント/チーム/プロジェクト別に分割配分。
    3.  **チャージバック/ショーバック**: Split Costデータを活用し、各チームに正確なコスト配分レポートを提供。チャージバック（実課金）またはショーバック（参考表示）の運用モデルを選択。
    4.  **FinOps統合**: FinOps Foundation推奨のUnit Economics（1ユーザーあたりコスト、1トランザクションあたりコスト）をCustom Viewsで定義・追跡。
    5.  **アラート連携**: Custom Viewsに基づくBudget Alarmsを設定し、チーム別の予算超過を個別に検知・通知。
-   **Cross-Ref**: FinOps基本は§9参照。コスト異常検知は§74参照。Database Savings Plansは§112参照。RI/SP戦略は§9.2参照。

---

## 155. AWSクラウド成熟度モデル & アンチパターン集 (Maturity Model & Anti-Patterns)

### Rule 155.1: The AWS Cloud Maturity Model
-   **Law**: 組織のAWSクラウド活用レベルを以下の**5段階成熟度モデル**で評価し、次のレベルへの改善を計画的に実施してください。
-   **Maturity Levels**:

    | レベル | 名称 | 特徴 |
    |:-------|:-----|:-----|
    | L1 | **Ad-hoc（場当たり）** | コンソール操作中心、IaCなし、タグなし、コスト管理なし、セキュリティ受動的 |
    | L2 | **Foundational（基礎確立）** | IaC導入開始、基本セキュリティ（GuardDuty/Config有効化）、コスト可視化、単一アカウント |
    | L3 | **Systematic（体系化）** | マルチアカウント戦略、CI/CDパイプライン、Well-Architectedレビュー定期実施、FinOps実践、自動修復開始 |
    | L4 | **Advanced（先進）** | Data Perimeter構築、カオスエンジニアリング定期実施、AI/ML統合、Observability as Code、成熟度指標の自動計測 |
    | L5 | **Optimized（最適化）** | 完全自動化IaC、AI駆動オペレーション（DevOps Agent/AIOps）、FinOps文化定着、Sustainability KPI追跡、Continuous Compliance |

-   **Action**: 四半期ごとに成熟度自己評価を実施し、2段階以上のスキップは避け、段階的に次レベルへ移行してください。

### Rule 155.2: The AWS Anti-Pattern Catalog (20大アンチパターン)
-   **Law**: 以下のアンチパターンを認識し、プロジェクトに発生した場合は即座に是正してください。

    | # | アンチパターン | リスク | 正しいアプローチ |
    |:--|:---------------|:-------|:-----------------|
    | 1 | **ClickOps Addiction** | ドリフト、再現不可能 | IaC Only（§0.2） |
    | 2 | **God Account** | 単一アカウントに全環境 | マルチアカウント戦略（§0.4） |
    | 3 | **Wildcard Permissions** | 権限エスカレーション | 最小権限IAM（§1.1） |
    | 4 | **Long-Term Keys** | 認証情報漏洩 | IAMロール + STS（§1.2） |
    | 5 | **Open Security Groups** | 不正アクセス | SG参照 + SSM Session Manager（§2.2） |
    | 6 | **NAT Gateway Sprawl** | コスト浪費 | Regional NAT Gateway（§2.5） |
    | 7 | **Monolithic Lambda** | タイムアウト、デバッグ困難 | 1関数1責務（§3.2） |
    | 8 | **Scan as Query** | DynamoDB全件走査 | Query + GSI設計（§4.2） |
    | 9 | **Public S3 Bucket** | データ漏洩 | Block Public Access + OAC（§5.1） |
    | 10 | **Log Infinity** | コスト爆発 | 保持期間設定（§7.1） |
    | 11 | **Secret Hardcoding** | 認証情報漏洩 | Secrets Manager（§12.3） |
    | 12 | **Tag-Free Chaos** | コスト不明、運用困難 | タグ強制（§8.4） |
    | 13 | **Commitment Over-Buy** | 余剰コミットメント | Waterlineアプローチ（§9.2） |
    | 14 | **Zombie Resources** | サイレントコストリーク | 週次スイープ（§9.3） |
    | 15 | **DR Hope** | 復旧不能 | カオスエンジニアリング（§10.3） |
    | 16 | **TOTP-Only MFA** | フィッシング脆弱 | FIDO2 Passkey必須（§148） |
    | 17 | **No Data Perimeter** | データ流出 | 3層境界戦略（§147） |
    | 18 | **State File on Laptop** | ステート消失 | S3 + DynamoDB Lock（§8.2） |
    | 19 | **Single AZ Everything** | AZ障害で全停止 | Multi-AZ必須（§10.1） |
    | 20 | **AI Without Guardrails** | ハルシネーション・コスト暴走 | Bedrock Guardrails + FinOps（§93/§9） |

-   **Cross-Ref**: 各アンチパターンの参照先セクションで詳細なルールと正しい実装パターンを確認してください。

---

## Appendix A: サービス別逆引き索引

> **目的**: 155セクション・240ルール以上の中から対象サービスのルールを即時発見するための逆引き索引。

| AWSサービス | 関連セクション |
|:------------|:---------------|
| **IAM / Identity Center / STS / ABAC** | §1, §22, §44, §60, §102, §148 |
| **VPC / Subnet / Security Group / Block Public Access** | §2, §2.8, §30, §51, §92, §94, §146 |
| **VPC Lattice** | §2.7, §62, §105 |
| **Transit Gateway** | §2, §130 |
| **Direct Connect** | §32, §131 |
| **EC2 / Auto Scaling / Graviton** | §3.1, §3.4, §69 |
| **Lambda** | §3.2, §79, §108, §142 |
| **Lambda Managed Instances** | §108 |
| **ECS / EKS / Fargate / EKS Auto Mode** | §3.3, §13, §70, §105, §144 |
| **App Runner** | §3.5 |
| **ECR** | §13, §122 |
| **RDS / Aurora** | §4.1, §80, §112 |
| **Aurora DSQL** | §103 |
| **DynamoDB** | §4.2, §109 |
| **DynamoDB MRSC (Multi-Region Strong Consistency)** | §109 |
| **S3** | §5, §78 |
| **S3 Express One Zone** | §141 |
| **S3 Access Grants** | §5.1 |
| **S3 Vectors** | §107 |
| **S3 Tables / S3 Metadata** | §100 |
| **GuardDuty / Security Hub / Config** | §6, §41, §81 |
| **Detective** | §54, §132 |
| **Security Incident Response** | §111 |
| **CloudWatch / X-Ray / Application Signals** | §7, §57, §77, §104, §113 |
| **CloudWatch Internet Monitor** | §7.4 |
| **CloudWatch Unified Data Store** | §113 |
| **CloudFront** | §20, §39, §110 |
| **CloudFront VPC Origins** | §110 |
| **CloudFormation / CDK / Terraform / IaC Generator** | §0.2, §8, §8.5, §90 |
| **CodePipeline / CodeBuild / CodeDeploy** | §42, §123 |
| **CodeCatalyst** | §123 |
| **Cost Explorer / Budgets / FinOps** | §9, §37, §56, §74, §112, §154 |
| **Database Savings Plans** | §112 |
| **Route 53** | §20 |
| **SQS / SNS / EventBridge** | §17, §73 |
| **EventBridge Pipes** | §140 |
| **API Gateway** | §18 |
| **Step Functions** | §19 |
| **Cognito** | §22, §118 |
| **SES** | §124 |
| **Lex** | §135 |
| **Organizations / Control Tower / SCP / RCP** | §0.4, §14.2, §26, §50, §68, §147 |
| **WAF / Shield / Network Firewall** | §72, §94, §153 |
| **Secrets Manager / SSM** | §31, §76 |
| **Glue / Zero-ETL** | §25, §114 |
| **Athena** | §25, §115 |
| **Redshift** | §25, §116 |
| **Kinesis** | §25, §117 |
| **EMR** | §25, §121 |
| **Bedrock / GenAI** | §29, §93, §99, §145 |
| **Bedrock Knowledge Bases / RAG** | §29.4, §99 |
| **Bedrock Flows** | §29.5 |
| **Bedrock Model Distillation** | §29.6 |
| **Bedrock RFT (強化学習ファインチューニング)** | §29.3 |
| **Bedrock AgentCore** | §101 |
| **Amazon Q** | §96, §125 |
| **Rekognition / Textract / Comprehend / Transcribe / Polly** | §133 |
| **Macie** | §34, §119 |
| **CloudTrail / CloudTrail Lake** | §21, §126 |
| **SageMaker** | §59 |
| **Trainium / Inferentia** | §106 |
| **Neptune** | §95 |
| **DocumentDB** | §98 |
| **ElastiCache / MemoryDB** | §71, §89 |
| **MSK (Kafka)** | §52 |
| **OpenSearch** | §49 |
| **Timestream** | §85 |
| **Clean Rooms** | §88 |
| **DataZone / Lake Formation** | §53, §91 |
| **DataSync** | §120 |
| **Snow Family** | §134 |
| **Amplify** | §127 |
| **Location Service** | §128 |
| **Service Catalog** | §129 |
| **WorkSpaces** | §136 |
| **Elemental MediaConvert** | §137 |
| **Outposts / Local Zones / Wavelength** | §97, §149 |
| **IoT Core / Greengrass** | §84 |
| **Backup** | §10.2, §40 |
| **Resilience Hub / FIS** | §43, §47, §86 |
| **DevOps Agent** | §138 |
| **NAT Gateway (Regional)** | §2.5 |
| **Resource Explorer** | §139 |
| **Lambda Durable Functions** | §142 |
| **AWS Interconnect (Multi-Cloud)** | §143 |
| **EKS Capabilities (Argo CD / ACK / KRO)** | §144 |
| **Amazon Nova (AI Foundation Models)** | §145 |
| **VPC Encryption Controls** | §146 |
| **Data Perimeter (SCP / RCP / VPCe)** | §147 |
| **Passkey / FIDO2 MFA** | §148 |
| **Outposts Gen2 / Local Zones 2.0** | §149 |
| **Amazon Transform** | §150 |
| **Data Transfer Terminal** | §151 |
| **Green Insights** | §152 |
| **Shield AI-Driven Protection** | §153 |
| **Billing Custom Views / Split Cost** | §154 |
| **成熟度モデル / アンチパターン** | §155 |

### 内部クロスリファレンス
- **データ主権**: §32.2（基礎）→ §64（高度なデータ主権ガバナンス: Data Boundary/S3 Object Lock/GDPR/Sovereign Cloud）
- **データ分析パイプライン**: §114（Glue）→ §115（Athena）→ §116（Redshift）→ §117（Kinesis）→ §121（EMR）
- **コンテナサプライチェーン**: §122（ECR）→ §13（ECS/EKS）→ §123（CI/CD）→ §42（パイプラインセキュリティ）
- **ネットワークハブ**: §130（Transit Gateway）→ §131（Direct Connect）→ §143（Interconnect Multi-Cloud）→ §2（VPC）→ §92（PrivateLink）
- **セキュリティ調査チェーン**: §6（GuardDuty検知）→ §132（Detective調査）→ §111（インシデント対応）→ §126（CloudTrail Lake監査）→ §138（DevOps Agent AI支援）
- **認証強化チェーン**: §1（IAM基礎）→ §148（FIDO2/Passkey必須化）→ §102（Policy Autopilot/ABAC）→ §147（Data Perimeter）
- **マルチクラウド接続**: §131（Direct Connect）→ §143（Interconnect）→ §130（Transit Gateway）
- **AIモデル活用チェーン**: §145（Nova）→ §29（Bedrock）→ §101（AgentCore）→ §142（Durable Functions）

### クロスリファレンス（他ルールファイル）
- **Supabase Backend**: `320_supabase_architecture.md` — BaaS戦略、RLS、Edge Functions
- **Security & Privacy**: `600_security_privacy.md` — ゼロトラスト、OWASP Top 10
- **SRE & Reliability**: `502_site_reliability.md` — 可用性99.99%、カオスエンジニアリング、負荷テスト
- **API Integration**: `301_api_integration.md` — REST/GraphQL設計、Rate Limiting
- **Engineering General**: `300_engineering_standards.md` — コードレビュー、テスト戦略
- **AI Implementation**: `400_ai_engineering.md` — ストリーミングファースト、RAG設計、トークンコスト管理


