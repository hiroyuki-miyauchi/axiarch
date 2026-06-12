# 730. キャッシュ規律 (Caching Discipline)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-06-12

> [!IMPORTANT]
> **Level 1 Priority: Absolute Compliance（最上位の優先事項）**
> キャッシュは「最も安易に導入され、最も検証されない分散システム」である。1行の `cache.set()` は、暗黙のうちに整合性モデル・障害モード・容量特性をシステムに追加する。
> 本ファイルの MUST 要件はリスク低減と品質の底上げを目的とし、実装の簡便さ・開発速度よりも優先する。

> [!CAUTION]
> **Primary Directive（主要方針）**
> 「staleness 契約なきキャッシュは、性能最適化ではなく無申告の整合性劣化である」
> 本ファイルは、プロセス内・分散・HTTP/CDN・DB バッファ・アプリ層を問わず**全キャッシュ層**に適用される、言語・スタック非依存の普遍規律である。
> 本ファイルが正本化するのは**「キャッシュの staleness 契約・TTL 設計・無効化・全損耐性の普遍規律」**であり、Web フレームワーク固有のキャッシュ機構（ISR / SWR ライブラリ / CDN 構成）は `engineering/300`、CMS キャッシュは `engineering/310`、SRE 観点の Tier 運用は `operations/400` Part XXIII、スタック固有実装は `engineering/200` 等へ委譲する（§1.2 責任分界表参照）。

---

## 目次

- §1. 主要方針・責務範囲
  - §1.1. 適用範囲
  - §1.2. 責任分界表（隣接ファイルとの境界）
  - §1.3. 基本原則と RFC 2119 用語
- §2. staleness 契約（本ファイルの核）
  - §2.1. データ種別ごとの許容 staleness 明文化
  - §2.2. 暗黙の整合性劣化禁止
  - §2.3. キャッシュ整合性 SLO
- §3. TTL 設計
  - §3.1. 二重 TTL（soft TTL / hard TTL）
  - §3.2. fail-open / fail-closed の設計時明示
  - §3.3. TTL ジッタ（同時失効スタンピード防止）
  - §3.4. ネガティブキャッシュ（不存在の別 TTL）
- §4. スタンピード防止
  - §4.1. Request Coalescing（single-flight）
  - §4.2. 確率的早期再計算
  - §4.3. ロック付き再構築
- §5. 無効化戦略
  - §5.1. 多層無効化の順序（origin → 分散 → エッジ）
  - §5.2. イベント駆動 vs TTL の選択基準
  - §5.3. キャッシュキー設計（スキーマバージョン必須）
  - §5.4. バージョン付きキー vs パージ
- §6. stale-while-revalidate / stale-if-error（RFC 5861）
- §7. 全損耐性（コールドスタート）
- §8. 可観測性
- §9. セキュリティ / プライバシー
- §10. テスト義務
- §11. 実装スニペット（参考実装）
- §12. アンチパターン集
- §13. 成熟度モデル L1–L5
- Appendix A: 逆引き索引
- Cross-Reference（関連ルール）

---

## §1. 主要方針・責務範囲 (Primary Directive & Scope)

### §1.1. 適用範囲

-   **Rule 730.1.1（適用対象）**: 本ファイルは、**正本（origin）から導出された値を、正本より近い・速い場所に保持する全機構**に適用する（MUST）。具体的には以下を含むが、これらに限定されない:
    -   プロセス内キャッシュ（メモ化・LRU マップ・アプリ内オブジェクトキャッシュ）
    -   分散キャッシュ（Redis / Memcached 等の外部キャッシュストア）
    -   HTTP / CDN キャッシュ（ブラウザ・リバースプロキシ・エッジ）
    -   DB 側キャッシュ（マテリアライズドビュー・クエリ結果キャッシュ・バッファ運用に依存する設計判断）
    -   アプリケーション層キャッシュ（フレームワークのデータキャッシュ・セッションに紐づく導出値）
-   **判定基準**: 「この値は、いま origin を読んだ場合と異なりうるか？」— YES なら、それはキャッシュであり本ファイルの適用対象である。名称（メモ化・スナップショット・プリフェッチ）は問わない。

### §1.2. 責任分界表（隣接ファイルとの境界）

-   **Rule 730.1.2（責任分界）**: 本ファイルは「言語・層非依存のキャッシュ普遍規律」のみを正本とし、以下は各正本へ委譲する（MUST）:

| トピック | 正本（委譲先） | 本ファイルとの関係 |
|:--------|:-------------|:-----------------|
| Web フロントエンド固有のキャッシュ（ISR / `'use cache'` / revalidateTag / CDN ヘッダ / SWR ライブラリ） | `engineering/300_web_frontend.md` Part XVII（§85–§86）, §208 | 本ファイルは普遍規律、Web スタック固有の機構・目標値は委譲 |
| CMS コンテンツのキャッシュ階層・On-demand Revalidation | `engineering/310_headless_cms.md` Part XVII | コンテンツ Tier 設計・プレビュー分離は委譲 |
| Supabase / DB 層のキャッシュ運用（Cache Versioning・スキーマキャッシュ再読込・Storage CDN） | `engineering/200_supabase_architecture.md` §7.4–§7.5 周辺 | スタック固有の手順は委譲 |
| SRE 観点のキャッシュ Tier 表（STATIC / WARM / HOT / REALTIME）と運用 | `operations/400_site_reliability.md` Part XXIII §57 | Tier の具体値・運用判断は委譲。本ファイルは Tier 選択の前提となる staleness 契約（§2）を定義 |
| 容量計画・スケール崖の台帳化（事前計画） | `operations/650_capacity_planning.md` | キャッシュ全損時の容量要件（§7）の接続先。事後の飽和度監視は `operations/400` Part XXVII §65 |
| キャッシュポイズニング・Service Worker キャッシュの攻撃面・機密データの no-store | `security/000_security_privacy.md` §22.6, §7 | 脅威モデル・対策の正本は委譲。本ファイルは設計境界（§9）のみ定義 |
| スキーマ進化（Expand-Contract）とデプロイ互換性 | `engineering/000_engineering_standards.md` Part XVII | スキーマバージョン付きキー（§5.3）の背景となる正本 |
| メトリクス・構造化ログ基盤の総論 | `ai/100_data_analytics.md` Part XI–XV | 本ファイルは「何を計測するか」（§8）を定義し、収集基盤は委譲 |

### §1.3. 基本原則と RFC 2119 用語

-   **Rule 730.1.3（RFC 2119）**: 本ファイルの **MUST / MUST NOT / SHOULD / MAY** は RFC 2119 の定義に従う。MUST はリスク低減のための必須要件であり、逸脱には ADR による明示的な記録を要する。
-   **Rule 730.1.4（誇張禁止）**: 本ファイルは「整合性とヒット率の両立」を約束しない。キャッシュは本質的に**鮮度と負荷のトレードオフ**であり、目的は劣化を**明示的・有界・観測可能**にすることである。「常に最新」「キャッシュなのに強整合」といった表現は設計文書でも禁止する（MUST NOT）。
-   **Rule 730.1.5（キャッシュは派生データ）**: キャッシュは origin から**再構築可能な派生データ**でなければならない（MUST）。キャッシュにのみ存在し origin に存在しない状態を作ってはならない（MUST NOT）— キャッシュの SSOT 化は §12 アンチパターンの筆頭である。データの正本所在は `engineering/000` を参照。
-   **Rule 730.1.6（双峰性の認識）**: キャッシュを持つシステムは「ヒット時は軽く、ミス時は重い」**双峰的（bimodal）な振る舞い**を持つ。設計・容量・テストは常に**ミス側・全損側**を基準に行う（MUST）。先行整理: AWS Builders' Library「Caching challenges and strategies」。

---

## §2. staleness 契約 (Staleness Contract)

> 本セクションが本ファイルの核である。キャッシュ設計の最初の成果物はコードではなく、**「どのデータが、どれだけ古くてよいか」の合意文書**である。

### §2.1. データ種別ごとの許容 staleness 明文化

-   **Rule 730.2.1（staleness 契約必須）**: キャッシュを導入する際は、**データ種別ごとに許容 staleness（最大どれだけ古い値を提供してよいか）を明文化**しなければならない（MUST）。契約は最低限、以下の列を持つ表として設計文書（ADR / README / ルールファイル）に残す:

| 列 | 意味 |
|:---|:-----|
| データ種別 | キャッシュ対象の論理データクラス（例: マスタデータ / 検索結果 / 残高） |
| 許容 staleness | 提供してよい値の最大経過時間（soft TTL の上限根拠） |
| 無効化トリガ | TTL のみか、イベント駆動無効化を併用するか（§5.2） |
| 下流障害時の振る舞い | stale 提供で継続（fail-open）か、エラー（fail-closed）か（§3.2） |
| キャッシュ禁止理由（該当時） | 認可結果・PII 等、キャッシュ自体を禁止する場合の根拠（§9） |

-   **Rule 730.2.2（既定値の禁止）**: 「とりあえず 60 秒」のような**根拠なき既定 TTL でデータ種別の差を均してはならない**（MUST NOT）。残高と静的マスタが同じ TTL を持つ設計は、契約が存在しない証拠である。Tier の具体値の先行例は `operations/400` §57 を参照。

### §2.2. 暗黙の整合性劣化禁止

-   **Rule 730.2.3（無申告キャッシュ禁止）**: staleness 契約のないキャッシュ導入（レビューで staleness の質問に答えられないキャッシュ）をマージしてはならない（MUST NOT）。キャッシュ導入の差分には「何が・最大どれだけ古くなるか・誰がそれを許容したか」を明記する（MUST）。
-   **判定基準**: 「このキャッシュが返しうる最も古い値はいつ時点のものか？」に即答できないキャッシュは、契約が存在しない。

### §2.3. キャッシュ整合性 SLO

-   **Rule 730.2.4（キャッシュ SLO）**: 主要キャッシュには**目標ヒット率**と**staleness 上限（提供エントリ age の上限目標）**を SLO として設定する（SHOULD）。ヒット率のみを KPI にすると「TTL を伸ばすだけの改善」に退化する — 必ず staleness とペアで管理する（MUST）。
-   **Rule 730.2.5（SLO 違反時の扱い）**: 無効化遅延・staleness の SLO 違反は、性能問題ではなく**データ正確性インシデント**として扱う（SHOULD）。検知の仕組みは §8。

---

## §3. TTL 設計 (TTL Design)

### §3.1. 二重 TTL（soft TTL / hard TTL）

-   **Rule 730.3.1（二重 TTL）**: 可用性が重要なキャッシュには **soft TTL（鮮度期限）と hard TTL（提供期限）の二重 TTL** を採用する（SHOULD）:
    -   **soft TTL 経過**: エントリは「stale」となり、origin への再取得を試みる。**再取得が失敗した場合は stale 値の提供で継続**してよい（MAY — fail-open を選択した場合、§3.2）
    -   **hard TTL 経過**: エントリは提供不可。stale 提供はここで**打ち切り**となる
-   **意図**: 二重 TTL は「下流の一時障害でキャッシュ済みデータまで提供不能になる」事故を防ぎつつ、stale 提供の**上限を構造的に保証**する。RFC 5861 の `stale-while-revalidate` / `stale-if-error` と同型の概念であり（§6）、HTTP 層に限らずアプリ層・分散キャッシュにも適用できる。
-   **構造例**: §11.2 参照。

### §3.2. fail-open / fail-closed の設計時明示

-   **Rule 730.3.2（障害時挙動の事前選択）**: 「origin が落ちているときに stale を返すか、エラーを返すか」は、**キャッシュ設計時に明示的に選択し文書化**する（MUST）。障害当日に即興で決めてはならない（MUST NOT）:
    -   **fail-open（stale 提供で継続）**: 可用性優先。コンテンツ・カタログ・推薦など、古い値の提供が誤動作より害が小さいデータに適する
    -   **fail-closed（エラーで停止）**: 正確性・安全性優先。認可判定・残高・在庫引当など、古い値が実害を生むデータに必須
-   **Rule 730.3.3（安全側の既定）**: 認可・課金・セキュリティ判定に関わるキャッシュは **fail-closed を既定**とする（MUST）。fail-open を選ぶ場合は ADR で根拠を残す。

### §3.3. TTL ジッタ（同時失効スタンピード防止）

-   **Rule 730.3.4（TTL ジッタ必須）**: 同種エントリを大量にキャッシュする場合、TTL には **±10–20% 程度のランダムジッタ**を付与する（MUST）。デプロイ・一括ウォームアップ・毎時 0 分などを起点とした**同時失効**は、origin への同期した負荷スパイク（スタンピード）を生む。
-   **先行整理**: AWS Builders' Library は、ジッタなしの一斉失効を外部キャッシュの代表的な障害要因として挙げている。

### §3.4. ネガティブキャッシュ（不存在の別 TTL）

-   **Rule 730.3.5（ネガティブキャッシュ）**: 「存在しない」「エラーだった」という結果も、**正常値とは別の（通常はより短い）TTL でキャッシュ**する（SHOULD）。不存在キーへの連続アクセスは、キャッシュを素通りして origin を直撃する。
-   **Rule 730.3.6（ネガティブ TTL の上限）**: ネガティブキャッシュの TTL は「新規作成されたデータが見えるようになるまでの最大遅延」を直接決める。**作成系フローの許容遅延（§2.1 契約）を超えてはならない**（MUST）。作成イベントでの明示的な無効化（§5.2）を併用することを推奨する（SHOULD）。

---

## §4. スタンピード防止 (Stampede Prevention)

### §4.1. Request Coalescing（single-flight）

-   **Rule 730.4.1（coalescing 必須）**: 同一キーのキャッシュミスが並行して発生した場合、**origin への取得は 1 つに合流（coalesce / single-flight）**させ、残りの要求はその結果を待つか stale を受け取る（MUST）。N 並行ミス = N origin 呼び出しの実装は §12 アンチパターンである。
-   **適用層**: プロセス内では in-flight Promise/Future の共有、分散環境ではロック（§4.3）または専用の coalescing 層で実現する。擬似コードは §11.1。

### §4.2. 確率的早期再計算

-   **Rule 730.4.2（早期再計算）**: ホットキー（失効瞬間に大量アクセスが集中するキー）には、**TTL 満了前に確率的に再計算を開始する方式（probabilistic early expiration）**を推奨する（SHOULD）。期限に近づくほど高い確率で先行再取得することで、失効瞬間のミス集中自体を消す。
-   **先行整理**: Vattani らの「Optimal Probabilistic Cache Stampede Prevention」（XFetch）。`operations/400` §57 も Thundering Herd 防止として同方式を挙げる。

### §4.3. ロック付き再構築

-   **Rule 730.4.3（再構築ロック）**: 分散キャッシュで重い再計算を伴うキーは、**再構築権を獲得した 1 ワーカーのみが origin を叩き、他は stale 提供または短い待機**とする（SHOULD）。ロックには必ず有効期限を付け、再構築者の死亡でキーが永久に再生不能になる事態を防ぐ（MUST）。

---

## §5. 無効化戦略 (Invalidation Strategy)

### §5.1. 多層無効化の順序（origin → 分散 → エッジ）

-   **Rule 730.5.1（無効化の順序）**: 複数キャッシュ層を持つシステムの無効化は、**origin に近い層から外側（エッジ）へ向かう順**で行う（MUST）: ① origin のデータ確定 → ② アプリ / 分散キャッシュの無効化 → ③ CDN / エッジのパージ。
-   **理由**: 逆順（エッジを先にパージ）にすると、パージ直後のリクエストが**まだ古い内側キャッシュから値を取り、エッジに古い値を再キャッシュ**する。無効化したのに古い値が残る典型的な原因である。
-   **Rule 730.5.2（無効化の冪等性と再試行）**: 無効化操作は冪等とし、失敗時に再試行可能でなければならない（MUST）。無効化の失敗を握りつぶしてはならない（MUST NOT）— 失敗した無効化は staleness 契約違反として計上する（§8.3）。

### §5.2. イベント駆動 vs TTL の選択基準

-   **Rule 730.5.3（二重の安全網）**: 無効化は「**イベント駆動（更新を検知して即時無効化）を一次手段、TTL を安全網**」の二段構えを基本とする（SHOULD）。イベント駆動のみ（TTL ∞）は無効化漏れが永久残留し、TTL のみは staleness が TTL いっぱいまで劣化する:
    -   許容 staleness が短いデータ（§2.1 契約）: イベント駆動必須 + 短い TTL の安全網
    -   許容 staleness が長いデータ: TTL のみで足りる場合がある（MAY）
-   **先行例**: `engineering/310` の `content.updated` Webhook → キャッシュ無効化、`engineering/300` の `revalidateTag` はこの方式のスタック固有実装である。

### §5.3. キャッシュキー設計（スキーマバージョン必須）

-   **Rule 730.5.4（キーの完全性）**: キャッシュキーは、**値の内容を決定する全入力次元**を含まなければならない（MUST）。ロケール・テナント・ロール・フィーチャーフラグ等、出力を変える入力がキーに含まれない場合、別文脈の値が混線する（プレビュー/公開の混在防止は `engineering/310` §17.2 参照）。
-   **Rule 730.5.5（スキーマバージョン必須）**: キャッシュキー（または名前空間プレフィックス）には**キャッシュ値のスキーマバージョンを含める**（MUST）。デプロイのロールアウト中は新旧コードが共存するため、バージョンなしキーでは旧コードの書いた値を新コードが読んでデシリアライズ失敗・サイレント不整合を起こす。スキーマ共存の総論は `engineering/000` Part XVII（Expand-Contract）を正本とする。設計例は §11.3。
-   **先行例**: `engineering/200` の Cache Versioning（`master_data_v2` サフィックスによる Cache Rot 防止）は本ルールのスタック固有実装である。

### §5.4. バージョン付きキー vs パージ

-   **Rule 730.5.6（方式の使い分け）**: 無効化の実現方式は 2 系統あり、特性を理解して選択する（SHOULD）:
    -   **バージョン付きキー（キー切替）**: 新バージョンのキーへ書き、旧キーは自然失効に任せる。パージの伝搬を待たず、原子的に切り替わる。一括無効化（デプロイ・マイグレーション後）に適する。コストは旧エントリ分のストレージ
    -   **パージ（明示削除）**: 個別エントリの即時無効化に適する。多層・分散環境では**伝搬遅延と部分失敗**が本質的に存在するため、§5.1 の順序と §8.3 の遅延計測を必須とする
-   **Rule 730.5.7（マイグレーション後の強制無効化）**: データマイグレーション・一括バックフィル（`engineering/700`）の完了後は、影響範囲のキャッシュをバージョン切替またはパージで**明示的に無効化**する（MUST）。「TTL でそのうち消える」を移行手順としてはならない（MUST NOT）。

---

## §6. stale-while-revalidate / stale-if-error（RFC 5861）

-   **Rule 730.6.1（SWR の普遍適用）**: **stale-while-revalidate**（soft TTL 経過後、stale を即座に返しつつ裏で非同期再取得する）は、HTTP の `Cache-Control` 拡張（RFC 5861）として標準化された概念だが、**HTTP 層に限らず全キャッシュ層に同型適用できる普遍パターン**である。レイテンシ一定性が重要な読み取りには採用を推奨する（SHOULD）。stale 提供時間は §2.1 の許容 staleness を超えてはならない（MUST）。
-   **Rule 730.6.2（SIE の普遍適用）**: **stale-if-error**（origin がエラーの間、stale を提供して可用性を維持する）も同様に層非依存で適用する。これは §3.2 の fail-open を時間境界付きで実装する標準形であり、**提供を許す最大時間（hard TTL 相当）を必ず併設**する（MUST）。
-   **Rule 730.6.3（stale 提供の可視化）**: SWR / SIE で stale を提供した事実は、レスポンスメタデータ（HTTP なら `Warning`/`Age` 相当、アプリ層ならログ・メトリクスのフラグ）として**観測可能に**する（MUST）。「いつのまにか stale を配り続けていた」状態を検知不能にしてはならない（§8.2）。
-   **Web スタック固有形**: Next.js ISR / SWR ライブラリ / CDN の `stale-while-revalidate` ディレクティブは本パターンの実装である — 設定値・運用は `engineering/300` を正本とする。

---

## §7. 全損耐性 (Total-Loss Tolerance / Cold Start)

-   **Rule 730.7.1（全損を容量計画に含める）**: **キャッシュが空（全損・flush・再起動・リージョン切替）の状態で、下流（origin DB・外部 API）が負荷に耐えるか**を容量計画に含める（MUST）。耐えない場合、キャッシュは「性能最適化」ではなく**可用性の単一障害点**である — その依存を認識し、コールドスタート時の負荷制限（同時実行上限・アドミッション制御・段階的トラフィック復帰）を設計する（MUST）。容量計画・崖シナリオ試験（キャッシュ全損コールドスタートを含む）の正本は `operations/650` §9、飽和度監視は `operations/400` Part XXVII §65 を正本とする。
-   **Rule 730.7.2（ウォームアップ / プリロード）**: 全損からの回復手段として、**ホットキーのウォームアップ（事前充填）手順**を用意する（SHOULD）。ウォームアップ自体が origin を圧迫しないよう、スロットリング（`engineering/700` §3.3 と同型の背圧）を適用する（MUST）。
-   **Rule 730.7.3（全損演習）**: 主要キャッシュについて、**意図的な flush からの回復演習**を定期的に実施することを推奨する（SHOULD）。双峰性（Rule 730.1.6）を持つシステムでは、ミス側の挙動は演習なしには検証されないまま劣化する。
-   **先行整理**: AWS Builders' Library は「キャッシュ可用性への依存を許容できるか」を外部キャッシュ導入の最初の設計判断として位置づけている。

---

## §8. 可観測性 (Observability)

> メトリクス・ログ基盤の総論は `ai/100` Part XI–XV を正本とする。本セクションは**キャッシュ固有の計測義務のみ**を定義する。

-   **Rule 730.8.1（ヒット率の計測）**: 主要キャッシュは**ヒット率 / ミス率をキースペース（データ種別）単位で**メトリクス化する（MUST）。全体平均のみのヒット率は、特定データ種別の劣化を隠す。
-   **Rule 730.8.2（staleness の計測）**: **提供したエントリの age（生成からの経過時間）**を計測し、stale 提供（§6）はフラグ付きで計上する（MUST）。staleness を計測しないシステムでは、§2 の契約遵守を検証できない。
-   **Rule 730.8.3（無効化遅延の計測）**: イベント駆動無効化を持つシステムは、**「origin 更新 → 全層で新値が提供される」までの伝搬遅延**を計測する（SHOULD）。無効化バグ（漏れ・順序逆転・部分失敗）は、この計測なしには**構造的に検知不能**である — 「無効化したつもり」が本ファイルで最も警戒すべき不可視故障である。
-   **Rule 730.8.4（origin 保護効果の実測）**: キャッシュ導入の根拠（origin への負荷削減）は、**origin リクエストレートの実測**で検証する（SHOULD）。ヒット率が高くても origin 負荷が想定より高い場合、キー断片化・ネガティブキャッシュ欠如（§3.4）を疑う。

---

## §9. セキュリティ / プライバシー (Security & Privacy)

> 脅威モデル・対策の正本は `security/000_security_privacy.md`（§22.6 キャッシュポイズニング・Service Worker、§7 プライバシー・バイ・デザイン）。本セクションは設計境界のみ定義する。

-   **Rule 730.9.1（認可結果のキャッシュ境界）**: 認可判定（許可/拒否）をキャッシュする場合、キーは**主体（principal）× 対象（resource）× 操作（action）を完全に含み**、TTL は短く、障害時は fail-closed（Rule 730.3.3）とする（MUST）。主体次元を欠いたキーでの認可キャッシュは**権限昇格の直接原因**であり禁止する（MUST NOT）。権限剥奪（revocation）の反映遅延は §2.1 契約に明記する（MUST）。
-   **Rule 730.9.2（PII・秘密情報の共有キャッシュ禁止）**: PII・認証トークン・セッション固有データを、**共有キャッシュ（CDN・プロキシ・マルチユーザー共用層）に保存してはならない**（MUST NOT）。HTTP では `Cache-Control: no-store`（または `private`）を明示し、「ヘッダ未指定 = 中間層の既定に委ねる」状態を禁止する（MUST）。
-   **Rule 730.9.3（キャッシュポイズニング境界）**: キャッシュキーは**正規化済みの入力のみ**から構成する（MUST）。キーに含まれない入力（unkeyed input — 任意ヘッダ等）がレスポンス内容に影響する構成は、攻撃者が細工レスポンスを共有キャッシュへ固定するキャッシュポイズニングの典型条件である。詳細は `security/000` §22.6。
-   **Rule 730.9.4（テナント間キー分離）**: マルチテナントシステムでは、キャッシュキーの名前空間を**テナント単位で分離**する（MUST）。テナント ID をキーの必須次元（Rule 730.5.4）とし、テナント横断のキー衝突がそのままデータ漏えいになる構造を排除する。

---

## §10. テスト義務 (Testing Obligations)

> テスト層の定義・テストダブル等の総論は `quality/000_qa_testing.md` を正本とする。本セクションは**キャッシュ固有のテスト義務のみ**を定義する。

-   **Rule 730.10.1（無効化パステスト）**: 「origin 更新 → 無効化 → 読み取りが新値を返す」までの**無効化パスを、関与する全キャッシュ層を通して**検証するテストを必須とする（MUST）。読み取りパスだけのテストは、キャッシュバグの主因（無効化漏れ）を素通しする。
-   **Rule 730.10.2（stale 提供パステスト）**: 下流障害を注入し、**soft TTL 経過後の stale 提供（fail-open 選択時）と hard TTL での打ち切り**が設計どおり動くことを検証する（MUST）。fail-closed 選択時は、stale が提供されないことを検証する。
-   **Rule 730.10.3（coalescing テスト）**: 同一キーへの N 並行ミスに対し、**origin 呼び出しが 1 回（または設計上の上限以下）**であることを検証する（MUST）。
-   **Rule 730.10.4（ネガティブキャッシュ / キーバージョンテスト）**: ①「不存在 → 作成 → ネガティブ TTL / 無効化により可視化される」パス、②「スキーマバージョン更新後、旧バージョンのエントリが読まれない」パスを検証する（SHOULD）。

---

## §11. 実装スニペット (Implementation Snippets)

> 以下はすべて**参考実装**（e.g. TypeScript）であり、言語非依存規律（§3–§5）の代表例として示す。自スタックの慣用形に翻訳して用いること。

### §11.1. single-flight（§4.1）

```typescript
// 同一キーの並行ミスを 1 つの origin 取得に合流させる参考実装
const inFlight = new Map<string, Promise<Value>>();

async function getWithCoalescing(key: string, fetchOrigin: () => Promise<Value>): Promise<Value> {
  const cached = cache.get(key);
  if (cached && !isSoftExpired(cached)) return cached.value;

  const existing = inFlight.get(key);
  if (existing) {
    // 既に誰かが再取得中: 合流して待つ（stale があれば即返してもよい — §6 SWR）
    if (cached) return cached.value;
    return existing;
  }

  const flight = fetchOrigin()
    .then((value) => { cache.set(key, wrap(value)); return value; })
    .finally(() => inFlight.delete(key)); // 成否によらず必ず解放する
  inFlight.set(key, flight);

  if (cached) return cached.value; // stale-while-revalidate: stale を返し裏で更新
  return flight;
}
```

### §11.2. 二重 TTL エントリ構造（§3.1）

```typescript
// soft TTL / hard TTL を持つエントリと読み取り判定の参考実装
interface CacheEntry<V> {
  value: V;
  schemaVersion: number;   // §5.3: キー側に含めるのが原則、値側にも併記してよい
  createdAt: number;       // epoch ms — §8.2 の age 計測に使用
  softExpiresAt: number;   // 鮮度期限: 以降は stale（再取得を試みる）
  hardExpiresAt: number;   // 提供期限: 以降は提供不可（stale 提供の打ち切り）
}

type ReadResult<V> =
  | { kind: 'fresh'; value: V }
  | { kind: 'stale'; value: V }   // fail-open 時のみ提供可。served_stale を計上（§6.3）
  | { kind: 'expired' };          // hard TTL 超過 — fail-open でも提供してはならない

function classify<V>(e: CacheEntry<V>, now: number): ReadResult<V> {
  if (now >= e.hardExpiresAt) return { kind: 'expired' };
  if (now >= e.softExpiresAt) return { kind: 'stale', value: e.value };
  return { kind: 'fresh', value: e.value };
}
```

### §11.3. バージョン付き・ジッタ付きキー設計（§3.3, §5.3, §9.4）

```typescript
// スキーマバージョン + テナント分離 + TTL ジッタの参考実装
const SCHEMA_VERSION = 3; // キャッシュ値の形を変えたら必ずインクリメント（§5.3）

function cacheKey(tenantId: string, dataClass: string, naturalKey: string): string {
  // tenant → 名前空間分離（§9.4）/ v3 → デプロイ間の新旧混線防止（§5.3）
  return `t:${tenantId}:v${SCHEMA_VERSION}:${dataClass}:${naturalKey}`;
}

function ttlWithJitter(baseMs: number, jitterRatio = 0.15): number {
  // ±15% のジッタで同時失効スタンピードを防止（§3.3、10–20% の範囲で選択）
  const delta = baseMs * jitterRatio;
  return Math.round(baseMs - delta + Math.random() * 2 * delta);
}
```

---

## §12. アンチパターン集 (Anti-Pattern Catalog)

| # | アンチパターン | 違反ルール | 帰結 |
|:--|:-------------|:----------|:-----|
| 1 | 無期限 TTL（TTL なし・実質 ∞）のキャッシュ | 730.2.1, 730.5.3 | 無効化漏れが永久残留し、staleness が無制限に劣化する |
| 2 | ジッタなしの一斉失効（デプロイ起点・毎時 0 分起点） | 730.3.4 | 同時失効スタンピードで origin に同期負荷スパイク |
| 3 | 主体次元を欠いたキーで認可結果をキャッシュ | 730.9.1 | 他ユーザーの許可判定を流用する権限昇格 |
| 4 | PII・トークンを共有キャッシュ / CDN に保存（no-store 欠落） | 730.9.2 | 機密データがユーザー間で配信される |
| 5 | 無効化遅延・staleness を計測しない | 730.8.2–3 | 無効化バグが構造的に検知不能になる |
| 6 | キャッシュにのみ存在するデータを作る（キャッシュの SSOT 化） | 730.1.5 | flush・障害・再起動でデータが恒久消失する |
| 7 | coalescing なしの cache miss（N 並行ミス = N origin 呼出） | 730.4.1 | ホットキー失効のたびに thundering herd |
| 8 | ネガティブキャッシュなしで不存在キーを素通し | 730.3.5 | 不存在キー連打が origin を直撃する |
| 9 | ネガティブ TTL が作成フローの許容遅延を超過 | 730.3.6 | 新規作成データが長時間「存在しない」ように見える |
| 10 | エッジ → origin の逆順で無効化 | 730.5.1 | パージ直後に古い値がエッジへ再キャッシュされる |
| 11 | スキーマバージョンなしキーでデプロイをまたぐ | 730.5.5 | 新旧コードが同一キーを取り合い、デシリアライズ失敗・不整合 |
| 12 | fail-open / fail-closed を未決定のまま障害日に即興判断 | 730.3.2 | 障害対応中に整合性 / 可用性の判断ミスが重なる |
| 13 | キャッシュ全損を容量計画に含めない | 730.7.1 | flush・再起動後のコールドスタートで origin が飽和する |
| 14 | テナント間でキー名前空間を共有 | 730.9.4 | キー衝突がそのままクロステナント漏えいになる |
| 15 | ヒット率のみを KPI にして staleness を無視 | 730.2.4 | 「TTL を伸ばすだけの改善」で整合性が無申告劣化する |

---

## §13. 成熟度モデル L1–L5 (Maturity Model)

| Level | 状態 | 特徴 |
|:------|:-----|:-----|
| **L1: Ad-hoc** | 契約なきキャッシュ | `cache.set()` が散在し staleness 契約がない。無期限 TTL・認可キャッシュの境界違反が存在しうる |
| **L2: TTL'd** | TTL はあるが規律がない | 全データが根拠なき一律 TTL。ジッタ・coalescing・ネガティブキャッシュなし。無効化は「TTL を待つ」のみ |
| **L3: Contracted** | staleness 契約を実装 | データ種別ごとの契約表（§2.1）が存在。二重 TTL + ジッタ + single-flight + スキーマバージョン付きキーが標準 |
| **L4: Operated** | 運用規律が定着 | ヒット率・staleness・無効化遅延がメトリクス化されアラート接続。fail-open/closed が全キャッシュで文書化。全損時容量が検証済み |
| **L5: Verified** | 継続検証 | 無効化パス・stale 提供・coalescing が CI で検証され、flush 演習が定期実施。キャッシュ起因インシデントの傾向が契約改定に還流する |

-   **Rule 730.13.1（最低ライン）**: 本番トラフィックを受けるキャッシュは **L3 以上**を必須とする（MUST）。認可・課金・PII に関わるデータをキャッシュ境界の近くで扱うシステムは、§9 の遵守を L3 の前提条件とする（MUST）。

---

## Appendix A: 逆引き索引（キーワード → セクション）

| キーワード | セクション |
|:----------|:----------|
| 適用範囲 / 何がキャッシュか / 判定基準 | §1.1 |
| 責任分界 / 委譲先 / 隣接ファイル境界 | §1.2 |
| 派生データ / SSOT 禁止 / 双峰性（bimodal） | §1.3 |
| staleness 契約 / 許容 staleness / 契約表 | §2.1 |
| 無申告キャッシュ禁止 / レビュー基準 | §2.2 |
| キャッシュ SLO / ヒット率と staleness のペア管理 | §2.3 |
| 二重 TTL / soft TTL / hard TTL | §3.1, §11.2 |
| fail-open / fail-closed / 障害時挙動 | §3.2 |
| TTL ジッタ / 同時失効 / 10–20% | §3.3, §11.3 |
| ネガティブキャッシュ / 不存在 / エラーのキャッシュ | §3.4 |
| スタンピード / thundering herd / single-flight / coalescing | §4.1, §11.1 |
| 確率的早期再計算 / XFetch | §4.2 |
| 再構築ロック / ロック有効期限 | §4.3 |
| 無効化の順序 / origin → 分散 → エッジ | §5.1 |
| イベント駆動無効化 / TTL 安全網 | §5.2 |
| キャッシュキー設計 / スキーマバージョン / 入力次元 | §5.3, §11.3 |
| バージョン付きキー vs パージ / マイグレーション後無効化 | §5.4 |
| stale-while-revalidate / stale-if-error / RFC 5861 | §6 |
| 全損耐性 / コールドスタート / ウォームアップ / flush 演習 | §7 |
| ヒット率 / staleness 計測 / 無効化遅延 / origin 保護効果 | §8 |
| 認可キャッシュ / 権限昇格 / revocation 遅延 | §9 (730.9.1) |
| PII / no-store / 共有キャッシュ禁止 | §9 (730.9.2) |
| キャッシュポイズニング / unkeyed input | §9 (730.9.3) |
| テナント分離 / マルチテナントキー | §9 (730.9.4) |
| 無効化パステスト / stale 提供テスト / coalescing テスト | §10 |
| アンチパターン | §12 |
| 成熟度モデル / L1–L5 / 最低ライン | §13 |

---

**参考規格・先行事例（References）**: RFC 2119 / RFC 5861 (stale-while-revalidate, stale-if-error) / AWS Builders' Library「Caching challenges and strategies」 / Vattani et al.「Optimal Probabilistic Cache Stampede Prevention」(XFetch) / RFC 9111 (HTTP Caching)

**Cross-Reference（関連ルール）:**
-   `engineering/300_web_frontend.md` — Part XVII Data Fetching & キャッシュ（§85 Public Cache Mandate・§86 Cache Versioning）、§208 ヒット率目標（ISR / SWR / CDN の Web スタック固有正本）
-   `engineering/310_headless_cms.md` — Part XVII キャッシュ階層戦略（コンテンツ Tier・On-demand Revalidation・プレビュー/公開のキー分離）
-   `engineering/200_supabase_architecture.md` — Cache Versioning（Cache Rot 防止）・Rule 7.5 Cache Reload Protocol・Storage CDN キャッシュ（スタック固有正本）
-   `operations/400_site_reliability.md` — Part XXIII §57 Cache Hierarchy（SRE の Tier 表正本）、Part XXVII §65 飽和度監視
-   `operations/650_capacity_planning.md` — 容量計画・スケール崖台帳・§9 キャッシュ全損コールドスタート試験（本ファイル §7 の接続先）
-   `operations/600_cloud_finops.md` — キャッシュによる従量課金削減の総論（FinOps 観点）
-   `engineering/000_engineering_standards.md` — Part XVII Expand-Contract（スキーマバージョン付きキーの背景）・データ正本（SSOT）の所在原則
-   `engineering/700_batch_backfill_operations.md` — バックフィル / マイグレーション後の強制無効化（§5.7）・背圧の同型適用（§7.2）
-   `security/000_security_privacy.md` — §22.6 Service Worker / キャッシュポイズニング・§7 プライバシー・バイ・デザイン（本ファイル §9 の正本）
-   `quality/000_qa_testing.md` — テスト層定義の正本（本ファイル §10 はキャッシュ固有義務のみ）
-   `ai/100_data_analytics.md` — Part XI–XV メトリクス・構造化ログ基盤の総論（本ファイル §8 の収集側）

---

**Last Updated**: 2026-06-12
**Authority**: Universal Constitution (axiarch core)
**Classification**: Engineering — Caching Discipline
