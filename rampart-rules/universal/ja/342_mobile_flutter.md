# 342. モバイルエンジニアリング — Flutter (Mobile Engineering — Flutter)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-03-30 | 対象: Flutter 3.41+ / Dart 3.7+ / Riverpod 3.0+ / Impeller GA（iOS唯一・Androidデフォルト）

> [!IMPORTANT]
> **Supreme Directive（最高指令）**
> 「Flutterはワンコードベース — だがワン妥協ではない。プラットフォーム忠実度は交渉不可。」
> すべてのFlutter実装は各プラットフォームでネイティブ品質のUXを提供しなければならない。
> **UX忠実度 > パフォーマンス > セキュリティ > コード再利用 > 開発速度** の優先順位を厳守せよ。
> **55パート・265セクション構成。**

---

## 目次

| Part | トピック | セクション |
|------|---------|-----------|
| I | 哲学・Supreme Directive | §1–§4 |
| II | テクノロジースタック標準 | §5–§8 |
| III | アーキテクチャ原則 | §9–§14 |
| IV | Dart 3.7+ 言語規約 | §15–§21 |
| V | 型システム・パターンマッチング | §22–§26 |
| VI | 非同期処理・Isolates | §27–§31 |
| VII | コード生成・ツーリング | §32–§35 |
| VIII | Riverpod 3.x 基盤 | §36–§41 |
| IX | 高度なRiverpodパターン | §42–§46 |
| X | オフライン永続化・Mutations | §47–§50 |
| XI | GoRouter・宣言的ルーティング | §51–§55 |
| XII | ディープリンク・Universal Links | §56–§59 |
| XIII | Clean Architecture詳細 | §60–§64 |
| XIV | Repository・データ層 | §65–§68 |
| XV | 依存性注入 (DI) | §69–§71 |
| XVI | パフォーマンス基盤 — "120fps or Die" | §72–§77 |
| XVII | Impellerレンダリングエンジン | §78–§80 |
| XVIII | Widgetツリー最適化 | §81–§85 |
| XIX | 起動最適化・アプリサイズ | §86–§89 |
| XX | メモリ管理・プロファイリング | §90–§93 |
| XXI | オフラインファースト・ローカルDB | §94–§98 |
| XXII | ネットワーク通信・API統合 | §99–§104 |
| XXIII | 画像・メディア・アセット管理 | §105–§108 |
| XXIV | リアルタイム通信 | §109–§111 |
| XXV | プラットフォーム忠実度 | §112–§116 |
| XXVI | レスポンシブ・アダプティブUI | §117–§121 |
| XXVII | Material 3・デザインシステム | §122–§126 |
| XXVIII | アニメーション・モーションデザイン | §127–§130 |
| XXIX | フォーム・インプットUX | §131–§134 |
| XXX | アクセシビリティ (a11y) | §135–§141 |
| XXXI | セキュリティ基盤 — OWASP MAS | §142–§146 |
| XXXII | ランタイム保護・RASP | §147–§149 |
| XXXIII | AI・オンデバイスML | §150–§154 |
| XXXIV | テスト戦略 | §155–§162 |
| XXXV | CI/CD・デプロイ | §163–§170 |
| XXXVI | 可観測性・監視 | §171–§176 |
| XXXVII | マルチプラットフォーム・エコシステム | §177–§182 |
| XXXVIII | ガバナンス・コンプライアンス | §183–§188 |
| XXXIX | 成熟度モデル・アンチパターン | §189–§191 |
| XL | 将来展望 | §192–§193 |
| XLI | プッシュ通知アーキテクチャ | §194–§196 |
| XLII | 認証・App Check | §197–§199 |
| XLIII | アプリライフサイクル・バックグラウンド | §200–§202 |
| XLIV | In-App Purchase・アプリ更新 | §203–§205 |
| XLV | Dart FFI・Native Interop 深化 `[Flutter-Specific]` | §206–§210 |
| XLVI | 決済統合アーキテクチャ `[Universal+Flutter]` | §211–§216 |
| XLVII | ローカル通知・スケジューリング `[Universal+Flutter]` | §217–§220 |
| XLVIII | ウィジェットテスト深化 `[Flutter-Specific]` | §221–§225 |
| XLIX | エラーバウンダリ・Recovery UX `[Universal]` | §226–§230 |
| L | Connectivity・ネットワークレジリエンス `[Universal]` | §231–§235 |
| LI | アプリ内ナビゲーションUX設計 `[Universal+Flutter]` | §236–§240 |
| LII | 構成管理・Feature Flag深化 `[Universal]` | §241–§245 |
| LIII | データプライバシー・同意管理深化 `[Universal]` | §246–§250 |
| LIV | モバイルDevOps・DX `[Universal+Flutter]` | §251–§256 |
| LV | 言語固有補遺・拡張アンチパターン `[Flutter-Specific]` | §257–§265 |
| Appendix | 逆引き索引・クロスリファレンス | — |

---

# Part A: 哲学・アーキテクチャ基盤

## I. 哲学・Supreme Directive

### §1. Supreme Directive — Flutter Excellence

- **原則**: Flutterは「妥協のないクロスプラットフォーム」を実現する唯一のフレームワークである
- **優先順位**: UX忠実度 > パフォーマンス > セキュリティ > コード再利用 > 開発速度
- **ゼロ妥協**: 各プラットフォーム（iOS/Android/Web/Desktop）でネイティブ品質を100%維持する
- **最新安定版**: 常にFlutter/Dartの最新安定版を前提とする。非推奨APIの新規使用は禁止
- **Platform Conventions First**: iOS HIG / Material Design 3 に完全準拠。プラットフォーム間でUXパターンを無理に統一しない

### §2. 品質ゲート（デプロイ前提条件）

| メトリクス | 閾値 | ブロッカー |
|---|---|---|
| `dart analyze --fatal-infos` | 警告・情報ゼロ | ✅ |
| `dart format --set-exit-if-changed .` | フォーマット差分ゼロ | ✅ |
| テストカバレッジ（Domain層） | ≥ 90% | ✅ |
| アプリサイズ（AAB/IPA） | ≤ 30MB | ✅ |
| コールドスタート | ≤ 2秒 | ✅ |
| フレームレート | ≥ 60fps（120fps推奨） | ✅ |
| クラッシュフリー率 | ≥ 99.5% | ✅ |

### §3. 禁止事項（Zero Tolerance）

- **絶対禁止**: `dynamic`型の使用、`setState()`の乱用、`Navigator.push()`直接使用、API Keyハードコード
- **原則禁止**: 手動Provider定義、`Image.network()`直接使用、Debugモードでの計測、`.then()`チェーン
- **条件付禁止**: Skiaフォールバック（既知互換性問題のみ例外）、`get_it`等の外部DI（Riverpodで十分）

### §4. バージョニング戦略

- **最小SDK**: Android `minSdk = 28`（Android 9）、iOS `deploymentTarget = 16.0`
- **Target SDK**: 常に最新安定版を追従
- **Dart SDK**: `sdk: '>=3.7.0 <4.0.0'`
- **非推奨API SLA**: 公式に非推奨化されたAPIは**2リリースサイクル以内**に移行完了
- **依存関係更新**: セキュリティパッチは72時間以内、通常更新はRenovate/Dependabotで14日待機後マージ

---

## II. テクノロジースタック標準

### §5. 必須パッケージスタック

| 用途 | パッケージ | 備考 |
|---|---|---|
| 状態管理 | `riverpod` + `riverpod_generator` | コード生成ファースト必須 |
| ルーティング | `go_router` | 宣言的ルーティング唯一の選択肢 |
| 不変状態 | `freezed` + `freezed_annotation` | 全状態クラス必須 |
| JSON変換 | `json_serializable` + `json_annotation` | DTO必須 |
| HTTPクライアント | `dio` | インターセプターベース |
| ローカルDB | `drift` | リレーショナルデータ |
| セキュアストレージ | `flutter_secure_storage` | トークン・PII |
| 画像キャッシュ | `cached_network_image` | ネットワーク画像必須 |
| SVG | `flutter_svg` | ベクターグラフィックス |
| RASP | `freeRASP` | ランタイム保護 |
| クラッシュ | `firebase_crashlytics` | クラッシュレポート |
| アナリティクス | `firebase_analytics` | イベント計測 |

### §6. 禁止・非推奨パッケージ

| パッケージ | 理由 | 代替 |
|---|---|---|
| `http` | 機能不足 | `dio` |
| `provider` | レガシー | `riverpod` |
| `get_it` + `injectable` | Riverpodで十分 | Riverpod Provider |
| `hive` | 複雑なクエリ不可 | `drift`（リレーショナル）|
| `shared_preferences`（機密データ） | 平文保存 | `flutter_secure_storage` |

### §7. コード生成パイプライン

```bash
# 標準コード生成コマンド
dart run build_runner build --delete-conflicting-outputs

# ウォッチモード（開発中）
dart run build_runner watch --delete-conflicting-outputs
```

- **生成ファイル命名**: `*.g.dart`（json_serializable）、`*.freezed.dart`（freezed）
- **生成ファイルのGit管理**: `.g.dart` / `.freezed.dart` はGitにコミット**する**（CI再現性のため）
- **`build.yaml`**: 生成オプションはプロジェクトルートの`build.yaml`で一元管理

### §8. analysis_options.yaml 標準設定

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

## III. アーキテクチャ原則

### §9. レイヤードアーキテクチャ（必須）

- **3層構造**を厳守する:
  - **Presentation層**: Widget + ViewModel（Notifier）。UIロジックのみ。ビジネスロジック禁止
  - **Domain層**: ビジネスロジック + エンティティ + Repositoryインターフェース。**Flutter依存ゼロ**（pure Dart）
  - **Data層**: API通信 + ローカルDB + DTO。Repositoryパターンで抽象化
- **依存の方向**: `Presentation → Domain ← Data`。Domain層は他層を知らない

### §10. フィーチャーベースディレクトリ構成

```
lib/
├── core/                  # 共通ユーティリティ、テーマ、定数、例外
│   ├── constants/
│   ├── exceptions/
│   ├── extensions/
│   ├── theme/
│   └── utils/
├── features/
│   ├── auth/
│   │   ├── data/          # Repository実装、DTO、DataSource
│   │   │   ├── datasources/
│   │   │   ├── dto/
│   │   │   └── repositories/
│   │   ├── domain/        # Entity、Repositoryインターフェース、UseCase
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/  # Widget、Notifier、Screen
│   │       ├── notifiers/
│   │       ├── screens/
│   │       └── widgets/
│   └── cart/
├── l10n/                  # 国際化ARBファイル
├── routing/               # GoRouter設定
└── main.dart
```

### §11. SSOT（Single Source of Truth）原則

- **ローカルDBをSSOTとして扱う**: UIは常にローカルDBからレンダリング
- **ネットワークは同期レイヤー**: UI描画の前提条件ではない
- **状態の源泉は1つ**: 同一データが複数の状態管理に分散することを禁止

### §12. 単方向データフロー（UDF）

- **データフロー**: Network → Repository → Notifier → Widget → User Action → Notifier → Repository
- **Widget → Notifier**: ユーザーアクションはNotifierのメソッド呼び出しで伝播
- **Notifier → Widget**: 状態変更は`ref.watch()`によるリアクティブ更新
- **禁止**: Widget間の直接データ受け渡し（Callback Hell）、GlobalKeyによる状態アクセス

### §13. モジュール境界と公開API

- **Feature Export**: 各featureディレクトリに`barrel file`（例: `auth.dart`）を**置かない**。Barrel Exportは循環参照の温床
- **代替**: 必要なクラスを直接インポート。IDEの自動インポートに委ねる
- **Feature間の依存**: Domain層のインターフェースを通じてのみ。Data/Presentation層の直接参照禁止

### §14. エラーアーキテクチャ

```dart
// ✅ アプリケーション全体のエラー階層
sealed class AppException implements Exception {
  String get message;
  String? get debugInfo;
}

class NetworkException extends AppException {
  @override final String message;
  @override final String? debugInfo;
  final int? statusCode;
  const NetworkException(this.message, {this.statusCode, this.debugInfo});
}

class CacheException extends AppException { /* ... */ }
class AuthException extends AppException { /* ... */ }
class ValidationException extends AppException { /* ... */ }
```

- **Domain層**: `AppException`のみをthrow/catch。パッケージ固有例外はData層で変換
- **Presentation層**: `AsyncValue`のerror状態でUIにマッピング
- **fire-and-forget禁止**: 全非同期呼び出しにエラーハンドリング必須

---

# Part B: Dart言語マスタリー

## IV. Dart 3.7+ 言語規約

### §15. Wildcard Variables（Dart 3.7）

- **`_`は真のワイルドカード**: パラメータやローカル変数で`_`を使用すると変数を宣言しない
- 不要なコールバックパラメータの命名を排除

```dart
// ✅ Dart 3.7 Wildcard
list.where((_, ) => true); // 第1引数を無視
future.then((_) => doSomething()); // 結果を無視

// ❌ Dart 3.6以前の冗長な命名
list.where((unused) => true);
```

### §16. 新フォーマッター（Dart 3.7）

- Dart 3.7+プロジェクトでは**新フォーマットスタイルが自動適用**
- Trailing commaの自動処理により手動調整が不要に
- `dart format`をCIゲートとして必ず実行

### §17. 厳格な型注釈

- **`dynamic`の使用を禁止**: 全変数・パラメータに型注釈を付与
- `analysis_options.yaml`で`strict-casts: true`、`strict-raw-types: true`、`strict-inference: true`を有効化
- **`Object`の使用**: 型が不明な場合は`dynamic`ではなく`Object`を使用

### §18. 命名規約

| 対象 | 規約 | 例 |
|---|---|---|
| クラス・enum・typedef | `UpperCamelCase` | `AuthState`, `UserRole` |
| 変数・関数・パラメータ | `lowerCamelCase` | `userName`, `fetchData()` |
| 定数 | `lowerCamelCase` | `defaultTimeout` |
| ファイル名 | `snake_case` | `auth_repository.dart` |
| プライベート | `_`プレフィックス | `_internalState` |
| ブーリアン | `is`/`has`/`can`プレフィックス | `isLoading`, `hasError` |

### §19. Extension Types（Dart 3.3+）

- プリミティブ型のラッピングにはExtension Typesを使用し、**ゼロコストで型安全**を実現

```dart
extension type UserId(String value) {
  factory UserId.fromInt(int id) => UserId(id.toString());
}

extension type Email(String value) {
  bool get isValid => value.contains('@');
}

// ✅ コンパイル時にStringに展開、ランタイムコストなし
void fetchUser(UserId id) { /* ... */ }
```

### §20. Records（Dart 3.0+）

- 複数値の返却には`Record`を使用し、不要なクラス定義を排除

```dart
// ✅ Record
(String name, int age) parseUser(Map<String, dynamic> json) {
  return (json['name'] as String, json['age'] as int);
}

// ✅ Named fields
({String token, DateTime expiresAt}) authenticate() { /* ... */ }
```

### §21. その他のDart言語ベストプラクティス

- **`final`優先**: `var`より`final`。再代入がない変数は必ず`final`
- **`const`最大化**: コンパイル時定数は必ず`const`。`dart fix --apply`で自動修正
- **Cascade Notation**: オブジェクト初期化時は`..`を活用
- **Collection Literals**: `List()` → `[]`、`Map()` → `{}`
- **String Interpolation**: `'$variable'`を優先。`+`による文字列結合は禁止

---

## V. 型システム・パターンマッチング

### §22. Sealed Classによる網羅的分岐

```dart
sealed class AuthState {}
class Authenticated extends AuthState {
  final User user;
  const Authenticated(this.user);
}
class Unauthenticated extends AuthState {}
class AuthLoading extends AuthState {}

// ✅ コンパイラが網羅性を保証
String label(AuthState s) => switch (s) {
  Authenticated(:final user) => user.name,
  Unauthenticated() => 'Guest',
  AuthLoading() => 'Loading...',
};
```

### §23. パターンマッチング活用

- `switch`式、`if-case`、シールドクラスを活用し、**網羅的（exhaustive）な分岐**を保証
- **Guard Clause**: `when`キーワードで条件付きマッチング
- **Destructuring**: オブジェクトパターンでフィールドを直接抽出

```dart
// ✅ Guard clause + destructuring
switch (response) {
  case Success(data: final items) when items.isNotEmpty:
    showList(items);
  case Success(data: final items) when items.isEmpty:
    showEmpty();
  case Failure(error: final e):
    showError(e.message);
}
```

### §24. 型安全なJSON処理

- **DTO変換**: 全APIレスポンスにDTO（`@JsonSerializable`）を定義。`Map<String, dynamic>`の直接操作禁止
- **型変換**: `as`キャストは禁止。`is`チェック + パターンマッチングを使用
- **Null安全**: JSONのnullableフィールドは`@JsonKey(defaultValue: ...)`で安全にデフォルト値設定

### §25. Enum拡張

```dart
enum PaymentMethod {
  creditCard('Credit Card', Icons.credit_card),
  bankTransfer('Bank Transfer', Icons.account_balance),
  cash('Cash', Icons.money);

  final String label;
  final IconData icon;
  const PaymentMethod(this.label, this.icon);

  // ✅ Enumにメソッド追加
  bool get isOnline => this != PaymentMethod.cash;
}
```

### §26. Null安全の徹底

- **`!`演算子禁止**: 強制アンラップは例外なく禁止。`?.`、`??`、`?.let`を使う
- **`late`の制限**: `late final`のみ許可。`late var`は禁止（初期化忘れのリスク）
- **`required`キーワード**: Named Parameterでnullableでないものは必ず`required`修飾

---

## VI. 非同期処理・Isolates

### §27. async/await規約

- **`async/await`を標準**: `.then()`チェーンの使用は禁止
- 複数の独立した非同期処理は`Future.wait()`で並列実行
- **fire-and-forget禁止**: 全`Future`に`await`または`unawaited()`明示が必要

```dart
// ✅ 並列実行
final (user, settings) = await (
  fetchUser(id),
  fetchSettings(),
).wait;

// ❌ ウォーターフォール
final user = await fetchUser(id);
final settings = await fetchSettings(); // 不要な待機
```

### §28. Isolateの活用

- **CPU集約型処理**（JSON解析、画像処理、暗号化）は`Isolate.run()`でバックグラウンド実行
- UIジャンクを防止するため、**16ms以上かかる処理**はメインIsolateから分離

```dart
// ✅ Isolate.run()
final result = await Isolate.run(() {
  return heavyJsonParsing(rawData);
});
```

### §29. Stream管理

- **StreamSubscriptionの生存管理**: `ref.onDispose()`でsubscriptionを必ずキャンセル
- **broadcast stream**: 複数リスナーが必要な場合のみ`.asBroadcastStream()`
- **StreamController**: 使用後は必ず`.close()`。メモリリークの最大原因

### §30. キャンセレーション

- **CancellationToken パターン**: 長時間実行される非同期処理にはキャンセル機構を実装
- **Dio CancelToken**: HTTPリクエストにはDioの`CancelToken`を使用し、画面離脱時にキャンセル
- **ref.onDispose()**: Riverpod NotifierではonDisposeでリソースを解放

### §31. エラーハンドリングの非同期パターン

```dart
// ✅ Result型パターン
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

// ✅ Repository内での変換
Future<Result<User>> fetchUser(UserId id) async {
  try {
    final dto = await _api.getUser(id.value);
    return Success(dto.toEntity());
  } on DioException catch (e) {
    return Failure(NetworkException.fromDio(e));
  }
}
```

---

## VII. コード生成・ツーリング

### §32. build_runner戦略

- **コード生成はCI必須ステップ**: `dart run build_runner build`をCIパイプラインに含める
- **生成ファイルのコンフリクト**: `--delete-conflicting-outputs`フラグを必ず使用
- **ウォッチモード**: 開発時は`watch`モードで継続的に生成

### §33. Macros廃止とAugmentations

- **Dart Macrosは開発中止**: ホットリロード・IDE分析への性能劣化が理由
- **現行標準**: `freezed` + `json_serializable` + `build_runner`を継続使用
- **Augmentations**: クラス定義を複数ファイルに分割する機能が後続として開発中。ただし安定版まで待機

### §34. コードジェネレータの選定基準

| 用途 | 推奨ジェネレータ |
|---|---|
| 不変データクラス | `freezed` |
| JSONシリアライゼーション | `json_serializable` |
| Riverpodプロバイダ | `riverpod_generator` |
| ルーティング | `go_router_builder`（任意） |
| アセットアクセス | `flutter_gen`（任意） |
| ローカルDB | `drift`（内蔵ジェネレータ） |

### §35. DevTools・プロファイリングツール

- **Flutter DevTools**: Widget Inspector、Performance Overlay、Memory Profiler、Network Profilerを日常的に使用
- **Dart DevTools**: CPU Profiler、Heap Snapshot でメモリリークを検出
- **Performance Overlay**: `PerformanceOverlay.allEnabled()`を開発中にオンにし、フレーム落ちを即座に検知
- **Great Thread Merge（Flutter 3.29+）**: UIとRasterスレッドが統合。DevToolsのフレーム分析UIが刷新

---

# Part C: 状態管理

## VIII. Riverpod 3.0+ 基盤

### §36. コード生成ファーストの原則

- **`riverpod_generator`（`@riverpod`アノテーション）を必須**とする。手動プロバイダ定義は禁止
- コンパイル時の型安全性とボイラープレート削減を担保
- **レガシーAPI廃止（Riverpod 3.0）**: `StateProvider`、`StateNotifierProvider`、`ChangeNotifierProvider`は`package:riverpod/legacy.dart`に移行。**新規使用を絶対禁止**
- **統合Notifier API（Riverpod 3.0）**: `AutoDisposeNotifier`と`Notifier`が統合。auto-disposeがデフォルト動作に統一
- **`riverpod_lint`必須**: `riverpod_lint`パッケージを導入し、以下のLintルールをCIで強制:
  - `riverpod_final_provider`—Provider変数はfinal必須
  - `unsupported_provider_value`—非対応型のProvider値検知
  - `missing_provider_scope`—ProviderScope未設定検知
  - `avoid_manual_providers_as_generated_provider_dependency`—手動定義への依存検知

### §37. Provider種別の使い分け

| ユースケース | 推奨Provider |
|---|---|
| 同期的な値の公開 | `@riverpod` (auto-dispose) |
| 非同期データ取得 | `@riverpod Future<T>` (FutureProvider) |
| リアルタイムストリーム | `@riverpod Stream<T>` (StreamProvider) |
| 可変状態 + ロジック | `@riverpod class MyNotifier extends _$MyNotifier` |
| 非同期可変状態 | `AsyncNotifier` / `AsyncNotifierProvider` |
| ファミリー（パラメータ付き） | `@riverpod`関数にパラメータを追加 |

### §38. ref.watch / ref.read の絶対規則

- **`build()`メソッド内** → `ref.watch()` のみ
- **コールバック・イベントハンドラ内** → `ref.read()` のみ
- `ref.watch()`をコールバック内で使用することは**厳禁**（Riverpodの再評価ループを引き起こす）
- **`ref.listen()`**: サイドイフェクト（Snackbar表示等）にはlistenを使用
- **`Ref.mounted`（Riverpod 3.0）**: 非同期処理完了後に`if (!ref.mounted) return;`でProvider破棄後の状態更新を防止
- **`Ref`型の簡素化（Riverpod 3.0）**: ジェネリクスパラメータ廃止。全サブクラス（`FutureProviderRef`等）が単一`Ref`型に統合

### §39. 粒度制御（select）

- **`ref.watch(provider.select((state) => state.specificField))`** で特定フィールドのみをwatch
- 状態オブジェクト全体をwatchすることは、パフォーマンスデグレードの最大原因
- **AsyncValue のselect**: `ref.watch(asyncProvider.select((v) => v.valueOrNull?.field))`
- **等価ベース更新（Riverpod 3.0）**: 状態比較が`identical()`から`==`演算子に変更。`freezed`の`==`オーバーライドが直接活用され、不要なリビルドがさらに削減

### §40. 不変（Immutable）状態の徹底

- 全ての状態クラスに**`freezed`**を使用し、不変性を保証
- `copyWith()` による状態遷移のみを許可。直接のフィールド変更は禁止

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

### §41. Provider Lifecycle管理

- **auto-dispose（デフォルト）**: 使用されなくなったProviderは自動破棄
- **`keepAlive()`**: グローバルな状態（認証状態等）にはkeepAliveを設定
- **`ref.invalidate()`**: 強制リフレッシュ。Pull-to-Refreshの実装に使用
- **`ref.onDispose()`**: StreamSubscription、Timer等のリソースクリーンアップ
- **自動リトライ（Riverpod 3.0）**: Provider計算失敗時にExponential Backoffで自動リトライ。ネットワーク一時障害への組み込み耐性を提供
- **Pause/Resume（Riverpod 3.0）**: 非表示WidgetのリスナーをOSが自動的にPause。不要な再計算を排除しパフォーマンス向上

---

## IX. 高度なRiverpodパターン

### §42. Provider間の依存チェーン

- ProviderはProvider同士を`ref.watch()`で依存可能
- **循環依存禁止**: A → B → A のような循環は`ProviderException`をthrowする
- **依存の深さ制限**: 5段階以上の依存チェーンはアーキテクチャの見直しを要する

### §43. Notifier設計パターン

```dart
@riverpod
class OrderNotifier extends _$OrderNotifier {
  @override
  Future<List<Order>> build() async {
    // 他のProviderに依存
    final userId = ref.watch(authProvider).requireValue.id;
    return ref.watch(orderRepositoryProvider).fetchOrders(userId);
  }

  Future<void> placeOrder(OrderRequest request) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(orderRepositoryProvider).placeOrder(request);
      // ✅ Riverpod 3.0: 非同期完了後の安全チェック
      if (!ref.mounted) return state.requireValue;
      return ref.read(orderRepositoryProvider).fetchOrders(
        ref.read(authProvider).requireValue.id,
      );
    });
  }
}
```

### §44. スコープ付きProvider

- **`ProviderScope`のオーバーライド**: テスト時にモックを挿入
- **Feature-scoped Provider**: 特定画面でのみ有効なProviderはその画面のProviderScope内で定義

### §45. AsyncValue の統一ハンドリング

```dart
// ✅ AsyncValueの統一パターン
asyncValue.when(
  data: (data) => DataWidget(data: data),
  loading: () => const ShimmerLoading(),  // Shimmerプレースホルダ
  error: (error, stack) => ErrorWidget(
    message: error.toString(),
    onRetry: () => ref.invalidate(provider),
  ),
);
```

### §46. テスト用Providerオーバーライド

```dart
// ✅ テスト内でのオーバーライド
final container = ProviderContainer(
  overrides: [
    orderRepositoryProvider.overrideWithValue(MockOrderRepository()),
    authProvider.overrideWith((ref) => const AsyncData(mockUser)),
  ],
);
```

- **`ProviderContainer.test`（Riverpod 3.0）**: テスト用コンテナの簡易生成。ボイラープレートなしでテストコンテナを構築
- **`tester.container()`（Riverpod 3.0）**: Widget Test内でウィジェットツリーからProviderContainerを直接取得するユーティリティ

---

## X. オフライン永続化・Mutations

### §47. Riverpod Offline Persistence（Experimental）

- **`.persist()` API**: `build()`メソッド内で呼び出し、状態をローカルストレージに自動キャッシュ
- **`riverpod_sqflite`**: SQLiteベースのStorage実装
- **Stale-While-Revalidate**: 起動時にローカルデータを即座に表示し、バックグラウンドで最新データをフェッチ

```dart
@riverpod
class UserProfile extends _$UserProfile {
  @override
  Future<User> build() async {
    // ローカル永続化を有効化
    ref.persist(storage: sqfliteStorage);
    
    // ネットワークから最新データを取得
    return ref.watch(userRepositoryProvider).fetchProfile();
  }
}
```

### §48. Mutations API

- **副作用の宣言的管理**: フォーム送信、削除操作等のside effectを`Mutation`として定義
- **自動状態追跡**: Loading → Success → Error の状態遷移を自動管理
- **Dispose中のミューテーション保護**: プロバイダ破棄中でもミューテーション完了を保証
- **コード生成不要（Riverpod 3.0）**: Mutations APIがコード生成なしで利用可能に
- **`Mutation.run`**: 非同期コールバックを`Mutation.run`で実行し、状態を`ref.watch`でUIに反映（Loadingスピナー、エラー㒒0等）

### §49. オフラインキューイング

- **同期キュー**: オフラインで発生した変更操作をDriftの同期テーブルに記録
- **バッチ処理**: ネットワーク復旧時にキューを順次送信
- **コンフリクト解決**: サーバーサイドの`updated_at`タイムスタンプを比較し、Last-Write-Winsまたはサーバー優先戦略を採用
- **冪等性**: 同一操作の再送でもサーバー側で一意性を保証（idempotency key）

### §50. 状態復元（Android Process Death）

- **`RestorationMixin`**: Androidのプロセス死からの復元をサポート
- **`RestorableValue`**: 重要なUI状態（スクロール位置、フォーム入力等）を復元可能にする
- **Riverpodとの連携**: 永続化されたProviderの状態はプロセス再起動後も自動復元

---

# Part D: ナビゲーション

## XI. GoRouter・宣言的ルーティング

### §51. 宣言的ルーティング原則

- **`go_router`を唯一の公式ルーティングとして採用**。`Navigator.push()`の直接使用は禁止
- `context.go()` / `context.push()` / `context.pop()` のみを使用

### §52. ルート定義の一元管理

```dart
// ✅ ルートパスの型安全な定義
abstract class AppRoutes {
  static const home = '/';
  static const profile = '/profile/:id';
  static const settings = '/settings';
  static const login = '/login';
}

// ✅ GoRouter設定
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

### §53. 認証ガード

- `GoRouter`の`redirect`プロパティで認証状態をリアクティブに評価
- `refreshListenable`に認証状態のNotifierを接続し、状態変更時にルーターを自動再評価
- **Role-based Routing**: ユーザー権限に応じたルートアクセス制御

### §54. ネストルーティング

- **ShellRoute**: BottomNavigationBar等のシェルUI内でのページ遷移
- **StatefulShellRoute**: タブ間の状態保持を実現
- **`parentNavigatorKey`**: モーダル等を親Navigatorで表示する際に使用

### §55. ルート遷移アニメーション

- **`CustomTransitionPage`**: 画面遷移アニメーションをカスタマイズ
- **プラットフォーム準拠**: iOSはスライド遷移、Androidはフェード遷移をデフォルトとする
- **Hero Animation**: ルート間の共有要素アニメーションはGoRouterと組み合わせて実装

---

## XII. ディープリンク・Universal Links

### §56. Universal Links（iOS）

- **Associated Domains**: Xcode設定で`applinks:example.com`を追加
- **`apple-app-site-association`**: サーバーに配置。JSON形式でパスマッピングを定義
- **検証**: `swcutil`コマンドでリンク設定を検証

### §57. App Links（Android）

- **`assetlinks.json`**: サーバーの`.well-known/`ディレクトリに配置
- **`autoVerify="true"`**: `intent-filter`に設定しリンクの自動検証を有効化
- **デジタルアセットリンクの検証**: `adb shell am start`で動作確認

### §58. ディファードディープリンク

- 未インストール時の遷移対応を実装
- ストアページ経由でインストール後、最初の起動時に目的の画面を表示
- **Firebase Dynamic Links廃止対応**: 自前実装またはサードパーティ（Branch.io等）で代替

### §59. カスタムURLスキーム

- **カスタムスキーム**: `myapp://`形式。Universal/App Linksを優先し、フォールバックとして使用
- **セキュリティ**: カスタムスキーム経由のパラメータは必ずバリデーション（インジェクション防止）

---

# Part E: アーキテクチャパターン

## XIII. Clean Architecture詳細

### §60. UseCase層（任意）

- **UseCase**: ビジネスロジックの一単位をカプセル化。Repositoryを組み合わせた複合操作に使用
- **単一責任**: 1 UseCase = 1ビジネス操作。複数操作を1つに詰め込まない
- **純粋Dart**: UseCase層はFlutter依存ゼロ。テスタビリティを最大化

```dart
class PlaceOrderUseCase {
  final OrderRepository _orderRepo;
  final PaymentRepository _paymentRepo;
  final NotificationRepository _notificationRepo;

  const PlaceOrderUseCase(this._orderRepo, this._paymentRepo, this._notificationRepo);

  Future<Result<Order>> execute(OrderRequest request) async {
    final payment = await _paymentRepo.processPayment(request.payment);
    return switch (payment) {
      Success(:final data) => await _orderRepo.createOrder(request, data),
      Failure(:final error) => Failure(error),
    };
  }
}
```

### §61. Entity設計

- **Domain Entity**: ビジネスロジック固有の値オブジェクト。DTOとは別に定義
- **不変性**: 全Entityは`freezed`で不変化
- **バリデーション**: ファクトリメソッドで入力バリデーション

### §62. DTO ↔ Entity マッピング

- **Mapper**: Data層に`toEntity()` / `fromEntity()`メソッドを定義
- **マッピングの方向**: DTO → Entity（Data層）、Entity → DTO（Data層）。Domain層はDTOを知らない
- **null安全マッピング**: サーバーからのnull値はデフォルト値に変換

### §63. DataSource抽象化

- **RemoteDataSource**: HTTP API通信をラップ。Dioインスタンスを注入
- **LocalDataSource**: ローカルDB（Drift）操作をラップ
- **Repositoryでの統合**: RemoteとLocalを統合し、オフライン対応のData Flowを実現

### §64. テスタビリティ設計

- **インターフェース優先**: 全Repository・DataSourceにabstract classを定義
- **モック生成**: `mocktail`パッケージでモックを自動生成
- **テスト容易性の指標**: 外部依存ゼロのDomain層テストが全テストの50%以上を占めること

---

## XIV. Repository・データ層

### §65. Repositoryパターン

```dart
// ✅ Domain層: インターフェース定義
abstract class OrderRepository {
  Future<Result<List<Order>>> getOrders();
  Future<Result<Order>> getOrderById(String id);
  Future<Result<void>> placeOrder(OrderRequest request);
}

// ✅ Data層: 実装
class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource _remote;
  final OrderLocalDataSource _local;

  const OrderRepositoryImpl(this._remote, this._local);

  @override
  Future<Result<List<Order>>> getOrders() async {
    try {
      final dtoList = await _remote.fetchOrders();
      final entities = dtoList.map((d) => d.toEntity()).toList();
      await _local.cacheOrders(dtoList); // ローカルキャッシュ更新
      return Success(entities);
    } on DioException catch (e) {
      // オフラインフォールバック
      final cached = await _local.getCachedOrders();
      if (cached.isNotEmpty) return Success(cached.map((d) => d.toEntity()).toList());
      return Failure(NetworkException.fromDio(e));
    }
  }
}
```

### §66. キャッシュ戦略

| 戦略 | 説明 | ユースケース |
|---|---|---|
| Cache First | ローカルを先に返し、バックグラウンドで更新 | 商品カタログ |
| Network First | ネットワークを優先、失敗時にキャッシュ | ユーザーデータ |
| Stale While Revalidate | 古いデータを即座に表示 + 裏で更新 | フィード |
| Network Only | 常にネットワークから取得 | 決済情報 |

### §67. ページネーション

- **カーソルベース**: 大量データには`cursor`パラメータによるページネーション
- **Riverpod統合**: `FamilyAsyncNotifier`でページパラメータを管理
- **スクロール検出**: `ScrollController`で末尾到達を検知し次ページをロード
- **無限スクロール**: `ListView.builder`と組み合わせて実装。全件ロードは禁止

### §68. データ同期パターン

- **Delta Sync**: 前回同期以降の変更分のみを取得（`last_synced_at`パラメータ）
- **Full Sync**: 初回起動時またはDelta Syncエラー時のフォールバック
- **Conflict Resolution**: サーバー優先（Server Wins）をデフォルトとする

---

## XV. 依存性注入 (DI)

### §69. RiverpodベースDI

- **RiverpodのProviderをDIコンテナとして使用**。`get_it`等の追加DIライブラリは原則不要
- 全Repositoryはインターフェースに対してProvider登録

```dart
@riverpod
OrderRepository orderRepository(Ref ref) {
  return OrderRepositoryImpl(
    ref.watch(orderRemoteDataSourceProvider),
    ref.watch(orderLocalDataSourceProvider),
  );
}
```

### §70. テスト時のDI差し替え

- **`ProviderContainer`のoverrides**: ユニットテストではProviderをモックで差し替え
- **`ProviderScope`のoverrides**: Widget Test / Integration Testではスコープレベルで差し替え

### §71. 環境別DI設定

- **Flavor/環境管理**: `--dart-define=ENV=development`で環境を切り替え
- **環境別Provider**: 開発/ステージング/本番で異なるAPI URLやサービスを注入

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

# Part F: パフォーマンス & レンダリング

## XVI. パフォーマンス基盤 — "120fps or Die"

### §72. constコンストラクタの徹底

- 変化しないWidgetには**必ず`const`コンストラクタ**を付与
- `dart fix --apply`を定期的に実行し、`const`化可能なWidgetを自動修正
- **Lint**: `prefer_const_constructors`を有効化

### §73. リビルド抑制

- **`Consumer`ウィジェットまたは`ConsumerWidget`**でリビルドスコープを最小化
- `Builder`パターンでリビルド境界を明示的に設定
- **禁止**: `setState()`の乱用。画面全体の再描画を引き起こす

### §74. リスト最適化

- **`ListView.builder()`を必須**。`ListView(children: [...])`はアイテム数が固定・少量の場合のみ
- **`itemExtent`または`prototypeItem`を指定**しスクロールパフォーマンスを向上
- **SliverList/SliverGrid**: 複雑なスクロールレイアウトにはSliver APIを使用
- **`findChildIndexCallback`**: リスト要素のIDベース検索で不要な再描画を防止

### §75. RepaintBoundary

- アニメーションの激しいWidgetには**`RepaintBoundary`**で囲み、再描画領域を分離
- DevToolsの「Highlight repaints」で再描画範囲を視覚的に確認
- **過度な使用禁止**: RepaintBoundary自体にメモリコストがある。計測に基づいて適用

### §76. 計算コストの分離

- **`ValueListenableBuilder`**: 特定の値変更時のみリビルド
- **`AnimatedBuilder`**: アニメーション値変更時のみリビルド
- **`Selector`パターン**: 状態の一部フィールドのみをwatchし、無関係なリビルドを排除

### §77. パフォーマンス計測規約

- **必ずProfile/Releaseモードで計測**。Debugモードの計測結果は無効
- フレームレート目標: **16ms/frame（60fps）死守**。Impeller対応デバイスでは8ms/frame（120fps）目標
- **CI統合**: パフォーマンスリグレッションテストをCIに組み込み、自動検知

```bash
flutter run --profile  # パフォーマンス計測
flutter run --release  # 本番相当の動作確認
```

---

## XVII. Impellerレンダリングエンジン

### §78. Impellerの採用方針

- **iOS**: Impellerが**唯一のレンダラー**。Skiaは完全削除済み。オプトアウト不可
- **Android**: API 29+でデフォルト有効（Vulkanバックエンド）。**オプトアウトは非推奨化**（Flutter 3.38+）。API 28以下はOpenGLフォールバック
- **Skiaフォールバック**: iOSでは完全廃止。Androidでも原則禁止（レガシーAPI 28以下の自動フォールバックのみ）

### §79. Impellerの利点と最適化

- **利点**: シェーダーのAOTプリコンパイルにより「シェーダーコンパイルジャンク」を根絶
- **120fps対応**: 8.33msのフレームバジェットを達成するため、Fragment Shaderの効率化が重要
- **Impeller Inspector**: DevToolsでオーバードロー問題を特定・修正
- **Impeller専用DevTools（2026）**: 以下の専用メトリクスを提供:
  - **Command Buffer Build Time**: 描画コマンドの構築時間。8.33ms以下が目標
  - **GPU Frame Time**: GPU側のフレーム処理時間。Rasterタブで確認
  - **Texture Upload Latency**: テクスチャアップロードの遅延。大画像デコードのボトルネック検出
  - **Draw Call Count**: 描画コール数とバッチング効率。過剰なコールはレイアウト見直しが必要
  - **GPU Memory Usage**: GPUメモリ使用量のリアルタイム監視

### §80. カスタムシェーダー

- **Impeller互換で記述**: SkSL非互換のシェーダーは使用禁止
- **`FragmentProgram`**: カスタムビジュアルエフェクトはImpeller対応のFragment Shader APIで実装
- **数学演算優先**: シェーダー内では条件分岐よりも数学演算を優先（GPU最適化）

---

## XVIII. Widgetツリー最適化

### §81. Widget分割戦略

- **小さなWidgetに分割**: 1 Widgetあたり50行以下を目安
- **`const` Widget化**: 静的なWidgetは独立したconstクラスに抽出
- **関数ではなくWidgetクラス**: `Widget buildHeader()` → `class HeaderWidget`。関数はリビルド最適化が効かない

### §82. Sliver API活用

- **`CustomScrollView`**: 複数のスクロール可能コンテンツを効率的に組み合わせ
- **`SliverAppBar`**: スクロールに連動するAppBar
- **`SliverList.builder` / `SliverGrid`**: 大量データの遅延構築

### §83. Overlay・ダイアログ最適化

- **`OverlayPortal`（Flutter 3.10+）**: ツールチップ、ドロップダウン等のオーバーレイ
- **Dialog/BottomSheet**: `showDialog` / `showModalBottomSheet`のビルダー内でのみ状態を管理

### §84. key活用戦略

- **`ValueKey`**: リスト要素のIDに基づく識別
- **`UniqueKey`**: 強制的な再構築が必要な場合
- **`GlobalKey`の使用制限**: パフォーマンスコストが高い。フォームバリデーション以外での使用は要承認

### §85. レイアウト最適化

- **`ConstrainedBox` / `SizedBox`**: 固定サイズにはSizedBox、制約にはConstrainedBox
- **`IntrinsicHeight` / `IntrinsicWidth`**: 使用を最小限に（2パスレイアウトのためコスト大）
- **`Wrap`**: 動的な折り返しレイアウト。ただし大量要素の場合はFlowを検討

---

## XIX. 起動最適化 & アプリサイズ

### §86. コールドスタート目標

- **起動時間（コールドスタート）は2秒以内**を絶対目標
- 初期化処理は`Future.wait()`で並列実行。逐次の`await`チェーンは禁止
- 重い初期化（DBマイグレーション等）はバックグラウンドで遅延実行

### §87. アプリサイズ目標

- **ターゲットサイズ: 30MB以下**（AAB/IPA）
- `flutter build appbundle --split-per-abi` でABI別に分割
- 未使用パッケージを`dart pub deps --no-dev`で定期監査・除去
- **アイコン/フォント最適化**: 未使用Materialアイコンの除去（`--no-tree-shake-icons`は禁止）

### §88. Tree Shaking & 難読化

- リリースビルドでは難読化を**必須**とする:

```bash
flutter build ipa --obfuscate --split-debug-info=build/debug-info
flutter build appbundle --obfuscate --split-debug-info=build/debug-info
```

- シンボルファイルはCrashlytics/Sentryにアップロード

### §89. 遅延読み込み（Deferred Loading）

- **`deferred as`**: 大きなライブラリは遅延インポートでバンドルサイズを削減
- **ルーティングベースの遅延ロード**: フィーチャーモジュールをルート遷移時に初回ロード
- **アセットバンドル分割**: 大きなアセットはネットワーク経由でオンデマンドダウンロード

---

## XX. メモリ管理・プロファイリング

### §90. メモリリーク防止

- **StreamSubscriptionの解放**: `ref.onDispose()`で必ずキャンセル
- **AnimationControllerの解放**: `dispose()`で必ず破棄
- **TextEditingControllerの解放**: StatefulWidget/HookWidgetで必ず`dispose()`
- **Closureキャプチャ**: `this`のキャプチャに注意。不要な参照保持を避ける

### §91. Dart DevToolsによるプロファイリング

- **Heap Snapshot**: 定期的にHeap Snapshotを取得し、意図しないオブジェクト保持を検出
- **Allocation Tracking**: 高頻度アロケーションを検出し、オブジェクトプール化を検討
- **Leak Tracking**: `leak_tracker`パッケージでリーク自動検出をCI統合

### §92. 画像メモリ管理

- **`ImageCache`設定**: `PaintingBinding.instance.imageCache.maximumSize`でキャッシュサイズを制限
- **適切な画像サイズ**: デバイスの画面サイズに合わせた解像度の画像を取得（過大な画像は禁止）
- **`ResizeImage`**: 表示サイズに合わせて画像をデコード時にリサイズ

### §93. プロファイリングのCI統合

- **`flutter test --track-widget-creation`**: Widget作成をトラッキングしDevToolsで分析
- **ベンチマークテスト**: `flutter_test`の`Benchmark`で主要操作の実行時間を計測
- **メモリ回帰テスト**: 主要フロー実行後のメモリ使用量を記録し、回帰を検知

---

# Part G: データ & ネットワーク

## XXI. オフラインファースト・ローカルDB

### §94. オフラインファーストの原則

- **ローカルDBをSSOTとして扱う**。UIは常にローカルDBからレンダリング
- ネットワークは「同期レイヤー」であり、UI描画の前提条件ではない

### §95. ローカルDB選定基準

| ユースケース | 推奨 |
|---|---|
| リレーショナルデータ（複雑なクエリ） | **Drift**（旧Moor） |
| Key-Value設定値 | **SharedPreferences** |
| 機密データ（トークン・PII） | **flutter_secure_storage** |
| 大量データのフルテキスト検索 | **Drift** + FTS5 |

### §96. Drift設定基準

```dart
// ✅ Drift データベース定義
@DriftDatabase(tables: [Orders, Users, SyncQueue])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 2;

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

### §97. 同期アーキテクチャ

- **Repositoryパターン**でローカル/リモートを抽象化
- **同期キュー**: オフラインで発生した変更操作をDriftの同期テーブルに記録し、ネットワーク復旧時にバッチ送信
- **コネクティビティ検出**: `connectivity_plus`でネットワーク状態を監視し、復旧時に自動同期

### §98. データ暗号化

- **SQLCipher**: 機密性の高いローカルDBにはDrift + SQLCipherで透過的暗号化
- **暗号化キー管理**: 暗号化キーは`flutter_secure_storage`に保存。ハードコード禁止

---

## XXII. ネットワーク通信・API統合

### §99. HTTPクライアント

- **`dio`を標準HTTPクライアント**として採用。`http`パッケージは原則不使用
- **インターセプター**でリクエスト/レスポンスの横断的関心事を処理

### §100. API認証 — VIP Lane戦略

- **Law**: ログインユーザーのリクエストでは**API Key (`x-api-key`) を送信せず、`Authorization: Bearer <token>`のみ**を送信
- **理由**: アプリバイナリ内へのAPI Key埋め込みリスクを物理的にゼロにする
- トークンのリフレッシュはDioインターセプターで自動処理

### §101. Error Handling & Retry

- 全API呼び出しにタイムアウト（接続: 10秒、受信: 30秒）を設定
- 一時的エラー（5xx、タイムアウト）には**Exponential Backoff**で最大3回リトライ
- エラーレスポンスはsealed classで型安全にモデリング（§31参照）

### §102. Dioインターセプター構成

```dart
final dio = Dio(BaseOptions(
  baseUrl: apiBaseUrl,
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 30),
))
  ..interceptors.addAll([
    AuthInterceptor(ref),          // Bearer Token自動付与
    RetryInterceptor(maxRetries: 3), // Exponential Backoff
    LogInterceptor(requestBody: true, responseBody: true), // Debug only
    ErrorMappingInterceptor(),      // DioException → AppException変換
  ]);
```

### §103. GraphQL対応（任意）

- **`graphql_flutter`**: GraphQL APIを使用する場合の標準パッケージ
- **コード生成**: `graphql_codegen`でクエリ/ミューテーションの型安全なDartコードを生成
- **キャッシュ**: GraphQLの正規化キャッシュを活用し、ネットワークリクエストを削減

### §104. HTTP/2・HTTP/3

- **HTTP/2**: Dioの`Dio(BaseOptions(...))` + `dio_http2_adapter`でHTTP/2を有効化
- **HTTP/3（QUIC）**: 対応クライアントが安定次第、移行を検討
- **接続プーリング**: 同一ホストへの複数リクエストで接続を再利用

---

## XXIII. 画像・メディア・アセット管理

### §105. 画像キャッシュ

- **`cached_network_image`を必須**。直接`Image.network()`は禁止
- プレースホルダとエラーウィジェットを必ず設定
- **Shimmerプレースホルダ**: `shimmer`パッケージでローディング中のUI品質を確保

### §106. 画像最適化

- サーバー側でレスポンシブ画像を提供し、デバイスに最適なサイズを取得
- **WebP/AVIF形式**を優先。PNG/JPEGはフォールバックのみ
- ローカルアセットはビルド前に圧縮

### §107. SVG & ベクターグラフィックス

- アイコン・イラストには**SVG（`flutter_svg`）**を使用し解像度非依存を実現
- 複雑なSVGはビルド時にベクターバイナリに変換（`vector_graphics_compiler`）

### §108. 動画・音声

- **`video_player`**: 動画再生の標準。プラットフォーム固有の最適化が自動適用
- **`just_audio`**: 音声再生の標準
- **バックグラウンド再生**: `audio_service`でバックグラウンド再生とメディアコントロールを統合

---

## XXIV. リアルタイム通信

### §109. WebSocket統合

- **`web_socket_channel`**: WebSocket通信の標準パッケージ
- **自動再接続**: 切断時にExponential Backoffで自動再接続を実装
- **心拍（Heartbeat）**: 接続維持のためPing/Pongメッセージを定期送信

### §110. Server-Sent Events (SSE)

- **用途**: サーバーからの一方向リアルタイムストリーム（通知、フィード更新等）
- **Dio対応**: `dio`の`responseType: ResponseType.stream`でSSEを受信

### §111. Supabase Realtime

- **Supabase Realtime**: データベース変更のリアルタイム通知
- **チャンネル**: テーブル単位でリアルタイム購読。セキュリティはRLSで担保
- **Presence**: オンラインステータス等のユーザー存在情報を共有

---

# Part H: プラットフォーム & UX

## XXV. プラットフォーム忠実度

### §112. ネイティブの感触（必須）

- **iOS**: スワイプバックジェスチャ（`CupertinoPageRoute`）、Bouncing Scroll Physics、Cupertino UIコンポーネント
- **Cupertino Squircles（Flutter 3.32+）**: `CupertinoAlertDialog`、`CupertinoActionSheet`がApple標準のスーパーエリプス（角丸蝿曲線）形状をサポート。iOSフィデリティが向上
- **Android**: システム戻るボタン、Predictive Back Gesture対応、Clamping Scroll Physics、Material Design 3
- **絶対禁止**: iOSでMaterialダイアログ表示、AndroidでCupertino使用

### §113. .adaptive()コンストラクタ

- **`Switch.adaptive()`、`Slider.adaptive()`、`CircularProgressIndicator.adaptive()`** を優先使用
- プラットフォームに応じてMaterial/Cupertinoを自動切替

### §114. プラットフォーム固有コード

- プラットフォーム固有ロジックは**1箇所に集約**。UIレイヤーに分散させない
- ネイティブAPIとの通信には**Pigeon（型安全なPlatform Channels）**を使用。`MethodChannel`の生文字列は禁止

### §115. Platform Channel & FFI

- **Pigeon**: iOS/Androidとの型安全な通信。コード生成で型定義を共有
- **Dart FFI**: C/C++ライブラリとの直接連携。暗号化・画像処理等のパフォーマンスクリティカルな処理に使用
- **`@Native`アノテーション**: FFI関数バインディングの簡素化

### §116. ハプティックフィードバック

- **`HapticFeedback`クラス**: タップ、ロングプレス等の触覚フィードバック
- **使用ガイドライン**: 重要なアクション（決済完了、エラー）にのみ使用。過度なフィードバックは禁止
- **プラットフォーム準拠**: iOS Haptic Engine / Android Vibration APIを適切に使い分け

---

## XXVI. レスポンシブ・アダプティブUI

### §117. ブレークポイント定義

| デバイスタイプ | 幅 |
|---|---|
| モバイル（コンパクト） | < 600dp |
| タブレット（ミディアム） | 600dp – 840dp |
| デスクトップ（エクスパンデッド） | > 840dp |

### §118. レイアウトウィジェット

- **`LayoutBuilder`**でブレークポイントに応じたレイアウト切替
- **`MediaQuery.sizeOf(context)`**: 非推奨の`MediaQuery.of(context).size`は使用しない
- SafeArea、ノッチ、パンチホール、Dynamic Island対応を全画面で保証

### §119. AdaptiveScaffold

- **`adaptive_scaffold`パッケージ**: 画面サイズに応じてNavigationBar / NavigationRail / NavigationDrawerを自動切替
- デバイスタイプチェック（`Platform.isAndroid`等）ではなく、**画面幅ベース**でレイアウトを決定

### §120. 折りたたみデバイス対応

- **Foldable対応**: `MediaQuery`のヒンジ情報を活用
- **マルチウィンドウ**: Android大画面のマルチウィンドウモードに対応

### §121. 画面回転・サイズ変更

- **画面回転ロック禁止**: レイアウトはあらゆるウィンドウサイズ/向きに対応すること
- **`OrientationBuilder`**: 画面向きに応じたレイアウト分岐

---

## XXVII. Material 3・デザインシステム

### §122. Material 3テーマ設定

```dart
// ✅ Material 3 Dynamic Color
MaterialApp(
  theme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
    ),
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

### §123. Design Token体系

- **Color Token**: `ColorScheme`の各プロパティ（`primary`, `secondary`, `surface`等）をDesign Tokenとして扱う
- **Typography Token**: `TextTheme`のスタイル（`headlineLarge`, `bodyMedium`等）を統一
- **Elevation Token**: `ElevationOverlay`で一貫したエレベーション表現
- **ハードコードカラー禁止**: `Color(0xFF...)` の直接使用禁止。必ず`Theme.of(context).colorScheme`経由

### §124. ダーク/ライトモード

- **システム設定に連動**: `ThemeMode.system`をデフォルト
- **マニュアルトグル**: ユーザーが手動でテーマを切り替えるUIを提供
- **テスト**: ダーク/ライト両モードでGolden Testを実行

### §125. カスタムデザインシステム

- **コンポーネントライブラリ**: プロジェクト固有のデザインシステムは`core/theme/`に集約
- **セマンティックカラー**: `successColor`, `warningColor`等のセマンティックカラーはThemeExtensionで定義
- **スペーシング定数**: 4dp/8dp/16dp/24dp/32dpのスペーシング定数を定義

### §126. アイコン・タイポグラフィ

- **Material Symbols**: Material Icons 3の新しいバリアブルアイコンを使用
- **カスタムフォント**: `google_fonts`パッケージまたはアセットバンドルで配信
- **フォントスケーリング**: `textScaler`対応を全テキストで保証

---

## XXVIII. アニメーション・モーションデザイン

### §127. アニメーションの分類と選定

| 種類 | 用途 | 推奨API |
|---|---|---|
| 暗示的（Implicit） | 単純なプロパティ変更 | `AnimatedContainer`, `AnimatedOpacity` |
| 明示的（Explicit） | 細かな制御が必要なリッチアニメーション | `AnimationController` + `Tween` |
| ヒーロー | 画面間の共有要素遷移 | `Hero` widget |
| 物理ベース | 自然な動きのアニメーション | `SpringSimulation`, `physics_simulations` |
| Lottie/Rive | デザイナー制作の複合アニメーション | `lottie`, `rive` |

### §128. アニメーション性能基準

- **60fps死守**: アニメーション中のフレームドロップは0を目標
- **アニメーション時間**: 200ms–400msをデフォルト。500ms超は要承認
- **Curve**: `Curves.easeInOutCubicEmphasized`（Material 3推奨）

### §129. ページ遷移アニメーション

- **iOS**: `CupertinoPageTransition`（右→左スライド）
- **Android**: `FadeUpwardsPageTransition`または`ZoomPageTransition`
- **SharedAxisTransition**: Material 3のShared Axis遷移パターン

### §130. Lottie/Rive統合

- **Lottie**: After Effectsベースのアニメーション。`lottie`パッケージで再生
- **Rive**: インタラクティブなステートマシンベースアニメーション。`rive`パッケージ
- **アセットサイズ**: Lottie JSONは100KB以下を目標。大きい場合はRiveを検討

---

## XXIX. フォーム・インプットUX

### §131. フォーム設計パターン

- **Reactive Forms**: `FormField` + `TextFormField`をRiverpod Notifierと統合
- **バリデーション**: フィールドレベル（即時）+ フォームレベル（送信時）の2段階バリデーション
- **エラー表示**: フィールド直下にインラインエラーメッセージ

### §132. 入力UX

- **`TextInputType`**: 各フィールドに適切なキーボードタイプを指定（email, phone, number等）
- **`TextInputAction`**: `next`→`done`の順序でフォーカス移動を最適化
- **オートコンプリート**: `AutofillGroup`でOS標準の自動入力に対応

### §133. IME・国際化対応

- **NFKC正規化**: 全角英数を半角に正規化（日本語入力対応）
- **maxLength**: `LengthLimitingTextInputFormatter`でバイト数ではなく文字数で制限
- **IMEガード**: `composing`中のバリデーション実行を抑止

### §134. 検索UI

- **`SearchAnchor`（Material 3）**: 標準の検索UI
- **デバウンス**: 検索クエリの入力に300msのデバウンスを適用
- **検索履歴**: ローカルストレージに検索履歴を保持

---

# Part I: アクセシビリティ

## XXX. アクセシビリティ (a11y)

### §135. Semanticsウィジェット

- **全インタラクティブ要素に`Semantics`ウィジェットでラベルを付与**
- アイコンボタンには必ず`semanticLabel`を指定
- **Semantics Tree**: DevToolsでSemantics Treeを確認し、論理的な順序を保証
- **`SemanticsRole` API（Flutter 3.32+）**: 支援技術への解釈指示をより細かく制御。ボタン、リンク、見出し等のセマンティクス役割を明示的に定義可能
- **WCAG 2.2 AA 新基準対応**:
  - **Target Size (Enhanced) 2.5.8**: タップターゲットは最低24×24dp（推奨44×44dp）。既存の48dp規約で自動準拠
  - **Focus Not Obscured (Minimum) 2.4.11**: フォーカス要素がSticky Header/Footerで隠れないことを保証
  - **Dragging Movements 2.5.7**: ドラッグ操作に代替手段（ボタン操作等）を必ず提供
- **EU Accessibility Act (EAA) 2025**: 2025年6月発効。EU市場向けアプリは法的義務としてWCAG 2.1 AA準拠が必須

### §136. タップターゲット

- **最小タップターゲットサイズ: 48×48dp**（WCAG 2.1 AA準拠）
- **`MaterialTapTargetSize.padded`**: Material Widgetのデフォルト

### §137. コントラスト比

- テキストと背景のコントラスト比は**最低4.5:1**（AA準拠）。大テキスト（18sp+）は3:1
- **ツール**: `Accessibility Scanner`でコントラスト比を自動検証

### §138. スクリーンリーダー対応

- **TalkBack（Android）& VoiceOver（iOS）で全画面を手動検証**
- `flutter test`で`Accessibility Guideline API`を使用した自動テストをCI/CDに組み込む:

```dart
testWidgets('a11y check', (tester) async {
  await tester.pumpWidget(MyApp());
  await expectLater(tester, meetsGuideline(textContrastGuideline));
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
});
```

### §139. ダイナミックフォントサイズ

- **`MediaQuery.textScalerOf(context)`**に対応し、システムのフォントサイズ設定を尊重
- テキストオーバーフローが発生しないことを200%スケールで検証

### §140. 操作モード対応

- **キーボードナビゲーション**: 全操作がキーボードで可能であること（Desktop/Web対応時）
- **スイッチコントロール**: iOS Switch Controlでの操作可能性を検証
- **モーション配慮**: `MediaQuery.disableAnimationsOf(context)`でモーション設定を尊重

### §141. 文字方向・言語対応

- **RTL対応**: `Directionality`ウィジェットでテキスト方向を制御
- **テスト**: RTLロケールでのレイアウト崩れをGolden Testで検証

---

# Part J: セキュリティ

## XXXI. セキュリティ基盤 — OWASP MAS

### §142. OWASP MASアラインメント

- **OWASP MASVS（Mobile Application Security Verification Standard）** に準拠。以下のControl Group別にセキュリティ要件を管理:
  - **MASVS-STORAGE**: データ保護（§144, §98）
  - **MASVS-CRYPTO**: 暗号化（AES-256-GCM、SHA-256/3）
  - **MASVS-AUTH**: 認証（§197–§199）
  - **MASVS-NETWORK**: 通信セキュリティ（§145）
  - **MASVS-PLATFORM**: プラットフォームセキュリティ（§112–§116）
  - **MASVS-CODE**: コード品質（§88, §146）
  - **MASVS-RESILIENCE**: ランタイム保護・RASP（§147–§149）
- **OWASP MASTG（Mobile Application Security Testing Guide）** をテストフレームワークとして使用
- **MobSF**: CI/CDに統合し、SAST（静的解析）を自動実行

### §143. 秘密情報の管理

- **アプリバイナリ内にAPI Key・Secret Keyを埋め込むことを絶対禁止**
- 環境変数はビルド時の`--dart-define`で注入:

```bash
flutter run --dart-define=API_URL=https://api.example.com
```

- **`--dart-define-from-file`**: 複数環境変数を`.env`ファイルから一括注入
- 実行時に必要な秘密情報はサーバーから取得

### §144. セキュアストレージ

- トークン・PII・パスワードは**`flutter_secure_storage`**に保存（iOS Keychain / Android Keystore経由）
- **`SharedPreferences`に機密データを保存することを絶対禁止**
- **バックアップ除外**: Android `android:allowBackup="false"`、iOS `isExcludedFromBackup`

### §145. 通信セキュリティ

- **HTTPS のみ**。HTTPフォールバックは一切許可しない
- **Certificate Pinning**: SPKIハッシュをピン留めし、MITM攻撃を防止
- **バックアップピン**: 証明書ローテーション時のアプリブロックを防止するため複数ピンを設定
- **TLS 1.2以上必須**: TLS 1.0/1.1は拒否

### §146. コード保護

- リリースビルドでは**`--obfuscate`を必須**（§88参照）
- ProGuard/R8（Android）の設定はCI/CDで自動検証
- **ログ出力**: リリースビルドではセンシティブ情報のログ出力を完全無効化。`kReleaseMode`フラグで制御

---

## XXXII. ランタイム保護・RASP

### §147. RASP（Runtime Application Self-Protection）

- **`freeRASP`**（または商用RASP SDK）を導入し、以下を検出:
  - Root化・Jailbreak検出
  - デバッガ・フッキングフレームワーク（Frida等）検出
  - アプリ改竄（リパッケージ）検出
  - エミュレータ・仮想環境検出
  - スクリーンレコーディング検出

### §148. RASP対応アクション

- RASP検出時のアクションは**サーバー側で制御**。クライアントのみでブロックしても回避可能
- 段階的対応: 警告表示 → 機能制限 → セッション無効化 → アプリブロック
- **テレメトリ**: RASP検出イベントをサーバーに送信し、脅威インテリジェンスとして蓄積

### §149. 追加セキュリティ対策

- **スクリーンショット防止**: `FlutterWindowManager`で金融画面等のスクリーンキャプチャを制御
- **クリップボード制御**: 機密フィールドからのコピーを制御
- **バックグラウンドスナップショット**: アプリ切替時にセキュアな画面でコンテンツを隠蔽

---

# Part K: AI・オンデバイスML

## XXXIII. AI・オンデバイスML

### §150. オンデバイスML統合

- **Google ML Kit**: テキスト認識（OCR）、顔検出、バーコードスキャン等の標準タスク
- **TFLite（TensorFlow Lite）**: `tflite_flutter`パッケージでカスタムモデルをデバイス上で実行
- **量子化**: Post-training quantizationでモデルサイズ削減・推論速度向上
- **Isolate実行**: ML推論は`Isolate.run()`でバックグラウンド実行しUIジャンクを防止

### §151. Gemini / 生成AI統合

- **Firebase AI Logic**: `firebase_ai`パッケージでGemini APIに接続
- **ストリーミングレスポンス**: `generateContentStream()`でリアルタイムにAI応答を表示
- **マルチモーダル**: テキスト + 画像入力に対応
- **FinOps**: AI APIコールのコストを`30%ルール`でガバナンス（月間予算の30%超過でアラート）

### §152. Gemini Nano（オンデバイス）

- **オンデバイスLLM**: ネットワーク不要の軽量推論（要約、校正、書き換え）
- **用途**: リアルタイムテキスト提案、センシティブデータのプライバシー保護処理
- **対応デバイス**: Pixel 8 Pro以降等の対応ハードウェアのみ

### §153. AIエージェント統合

- **MCP（Model Context Protocol）**: AI ToolにアプリのデータをContextとして提供
- **Intent-Based UI**: AIの分析に基づくUI動的適応
- **ガードレール**: AI出力の品質・安全性をフィルタリング

### §154. モデル管理

- **Firebase ML**: カスタムTFLiteモデルをFirebase経由でOTAダウンロード
- **モデルバージョニング**: モデル更新はアプリ更新不要。バックグラウンドでダウンロード・適用
- **フォールバック**: モデルダウンロード失敗時はバンドルされた初期モデルにフォールバック

---

# Part L: テスト戦略

## XXXIV. テスト戦略

### §155. テストピラミッド

| レベル | 対象 | フレームワーク | CI必須 |
|---|---|---|---|
| Unit Test | Domain/Data層ロジック | `flutter_test` | ✅ |
| Widget Test | UIコンポーネント単体 | `flutter_test` | ✅ |
| Golden Test | UIスナップショット回帰 | `golden_toolkit` | ✅ |
| Integration Test | ユーザーフロー全体 | `integration_test` | ✅ |
| E2E Test | 実機/エミュレータ | **Maestro** | ✅（ナイトリー）|
| Security Test | OWASP MAS検証 | **MobSF** | ✅（リリース前）|

### §156. Golden Test規約

- **複数デバイスサイズ**（iPhone SE / Pro Max / Pixel 7）でのスナップショットテスト
- ダーク/ライトモード両方のスナップショットを取得
- RTLロケールのスナップショットを取得
- Goldenファイル更新は`flutter test --update-goldens`で行い、PRレビューで差分を目視確認

### §157. カバレッジ目標

- **Domain層: 90%以上** / **Data層: 80%以上** / **Presentation層: Widget Test + Golden Test**
- CI/CDでカバレッジしきい値を下回るPRをブロック

### §158. モック戦略

- **`mocktail`**: モック生成の標準。`mockito`より軽量でnull safety完全対応
- **Faker**: テストデータ生成に`faker`パッケージを使用
- **`patrol`（E2E新標準）**: Maestroの代替/補完として、DartネイティブのE2Eテスト。ネイティブUIAutomation/UiAutomatorをDartから直接操作
- **`alchemist`（Golden Test強化）**: CI環境でのフォントレンダリング差異を吸収するGolden Testフレームワーク
- **テストFとxture**: 共通テストデータは`test/fixtures/`に集約

### §159. Property-Based Testing

- **`glados`**: Property-Based Testingでエッジケースを自動発見
- **用途**: パーサー、バリデーター、データ変換ロジックのテスト

### §160. パフォーマンステスト

- **ベンチマーク**: `flutter_test`の`Benchmark`で主要操作の実行時間を計測
- **メモリプロファイル**: テスト中のメモリ使用量を記録し回帰を検知
- **フレームレートテスト**: アニメーション中のフレームドロップをCIで検出

### §161. アクセシビリティテスト（自動）

- `meetsGuideline()`を全画面で実行（§138参照）
- **フォントスケーリングテスト**: 200%スケールでオーバーフローが発生しないことを検証

### §162. セキュリティテスト

- **MobSF**: APK/IPAの静的解析をCI統合
- **OWASP MASTG**: テストケースをマニュアルテスト計画に含める
- **依存関係脆弱性スキャン**: `dart pub outdated`を定期実行

---

# Part M: CI/CD & デプロイ

## XXXV. CI/CD・デプロイ

### §163. CIパイプライン構成

```
Push/PR → Format Check → Lint → Test → Build → Distribute
```

- **Format**: `dart format --set-exit-if-changed .`
- **Lint**: `dart analyze --fatal-infos`
- **Test**: Unit + Widget + Golden + Accessibility Tests
- **Build**: `flutter build ipa/appbundle --release --obfuscate`
- 全ステップ成功しない限りマージ不可

### §164. CDパイプライン構成

| トリガー | アクション | 配信先 |
|---|---|---|
| PR → develop | ビルド + テスト | Firebase App Distribution |
| develop → main | ビルド + テスト + 署名 | TestFlight / Google Play Internal |
| main tag | プロダクションビルド | App Store / Google Play（段階的） |

### §165. 署名管理

- iOS: **App Store Connect API + Fastlane Match**で証明書・プロビジョニングプロファイルを自動管理
- Android: **Play App Signing**を使用し、アップロードキーのみCI/CDで管理
- **秘密鍵をリポジトリに含めることを絶対禁止**

### §166. OTA更新 — Shorebird

- **Shorebird Code Push**でDartコードのOTA更新を運用
- **制約**: Dartコードのみ更新可能。ネイティブプラグイン・アセットはストア申請が必要
- **デュアルトラック戦略**: Shorebirdパッチとストアリリースを同時提出し100%カバレッジ保証
- **ロックファイル永続化**: `pubspec.lock`と`Podfile.lock`をCIアーティファクトとして保存。パッチ作成時に同一の依存グラフを再現するための必須慣行
- **`fastlane-plugin-shorebird`**: Fastlaneのレーン内で`shorebird_release`/`shorebird_patch`を直接実行
- **パッチ成功率監視**: Shorebirdコンソールでパッチ適用率、成功率、ロールバックパフォーマンスを監視

### §167. 環境管理（Flavor）

- **Flutter Flavors**: `--flavor dev`/`--flavor staging`/`--flavor prod`で環境分離
- **`--dart-define-from-file`**: 環境変数を`.env.dev`/`.env.prod`ファイルから注入
- **FirebaseプロジェクトのFlavor対応**: `google-services.json`/`GoogleService-Info.plist`を環境ごとに配置

### §168. ビルドキャッシュ

- **GitHub Actions Cache**: Flutter SDK、pubキャッシュ、build_runner出力をキャッシュ
- **ビルド時間目標: 15分以内**。超過する場合はキャッシュ戦略を見直す

### §169. コードサイニング自動化

```yaml
# GitHub Actions — iOS ビルド例
- name: Build iOS
  run: |
    flutter build ipa \
      --release \
      --obfuscate \
      --split-debug-info=build/debug-info \
      --export-options-plist=ios/ExportOptions.plist
```

### §170. 段階的ロールアウト

- **Google Play**: ステージドロールアウト（1% → 5% → 25% → 100%）
- **App Store**: 段階的リリース（1日〜7日間）
- **ロールバック**: クラッシュ率が0.5%を超えた場合、即座にロールアウトを停止

---

# Part N: 可観測性 & 監視

## XXXVI. 可観測性・監視

### §171. クラッシュレポーティング

- **Firebase Crashlytics**をデフォルト。難読化シンボルを必ずアップロード
- 高度な分散トレーシングが必要な場合は**Sentry**を採用
- **Non-fatal Error**: ビジネスクリティカルエラーは`recordError()`で記録

### §172. パフォーマンスモニタリング

- **Firebase Performance Monitoring**でHTTPリクエスト時間、画面レンダリング時間を自動計測
- カスタムトレースでビジネスクリティカル操作の所要時間を計測

### §173. アナリティクス

- **Firebase Analytics**をデフォルト
- 全画面遷移で`logScreenView`イベントを自動送信（GoRouter `observer`で実装）
- ユーザーアクションを標準化されたイベント名で記録

### §174. ログ戦略

- **Debugモード**: `logger`パッケージで構造化ログ
- **Releaseモード**: コンソールログ完全無効化。Crashlytics/Sentryへのリモートログのみ
- **センシティブ情報のログ禁止**: トークン・PII等のログ出力を全モードで禁止

### §175. カスタムメトリクス

- **アプリ専用KPI**: 「決済完了率」「検索結果表示時間」等のビジネスメトリクスを定義
- **ユーザーフロー分析**: 主要フローの完了率とドロップオフポイントを計測

### §176. リモート設定

- **Firebase Remote Config**: A/Bテスト、フィーチャーフラグ、動的パラメータ配信
- **デフォルト値必須**: リモート設定取得失敗時のフォールバック値を全パラメータに設定
- **キャッシュ戦略**: `minimumFetchInterval`でAPI呼び出し頻度を制御

---

# Part O: マルチプラットフォーム・エコシステム

## XXXVII. マルチプラットフォーム・エコシステム

### §177. Flutter Web

- **用途**: 管理画面、ランディングページ、PWA。メインのモバイルアプリのWeb版
- **レンダリング**: CanvasKit（高品質）vs HTML（軽量）の選択
- **SEO**: サーバーサイドレンダリングは不可。SPAとしてのSEO対策（`flutter_meta_seo`等）
- **パフォーマンス**: 初回ロード時間の最適化。Tree Shaking + Deferred Loadingの活用
- **Web Hot Reload（Flutter 3.32+ Experimental）**: ブラウザ上でのHot Reloadが実験的に利用可能。フルリロードなしでUI変更を即時反映
- **WebAssembly（Dart→Wasm）**: Webターゲットのパフォーマンスを大幅向上。CanvasKit+Wasmでネイティブ級の描画速度

### §178. Flutter Desktop

- **用途**: 社内ツール、管理画面、ユーティリティアプリ
- **ウィンドウ管理**: `window_size`パッケージでウィンドウサイズ制御
- **キーボードショートカット**: `Shortcuts`/`Actions`ウィジェットでデスクトップ操作に対応
- **メニューバー**: `PlatformMenuBar`でネイティブメニューバーを実装

### §179. パッケージ管理・SBOM

- **依存関係監査**: `dart pub outdated`を月次実行
- **SBOM（Software Bill of Materials）**: CycloneDX形式でパッケージ一覧を生成
- **ライセンス確認**: 全依存パッケージのライセンスを確認。GPL互換性に注意
- **セキュリティスキャン**: `dart pub deps`の脆弱性警告に48時間以内に対応

### §180. Wearable・Embedded

- **Wear OS**: Compose for Wear OS（ネイティブ推奨）。Flutter Wear OSプラグインは限定的
- **watchOS**: WatchKit/SwiftUI（ネイティブ必須）
- **IoT/Embedded**: Flutter Embeddedは実験的。プロダクション用途は要評価

### §181. プラグイン開発

- **Federated Plugin**: プラットフォーム別の実装を分離したプラグイン構成
- **Platform Interface**: 共通インターフェースを`_platform_interface`パッケージで定義
- **テスト**: プラグインのUnit TestはPlatform Channelのモックで実施

### §182. モノレポ戦略

- **Melos**: Flutter/Dartのモノレポ管理ツール
- **パッケージ分割**: `packages/`ディレクトリで共通ライブラリ・フィーチャーモジュールを分割管理
- **依存関係グラフ**: `melos list --graph`で依存関係を可視化

---

# Part P: ガバナンス・コンプライアンス

## XXXVIII. ガバナンス・コンプライアンス

### §183. 国際化（i18n）

- **`flutter_localizations` + `intl`**: Flutter標準のi18n。ARBファイルでメッセージ管理
- **ARBファイル構成**: `l10n/app_ja.arb`, `l10n/app_en.arb`で言語別に分離
- **`l10n.yaml`**: コード生成設定を一元管理
- **プレースホルダ**: `{name}`形式のパラメータ挿入。複数形・性別対応はICU MF 2.0

### §184. プライバシー・コンプライアンス

- **Privacy Manifest（iOS）**: `PrivacyInfo.xcprivacy`で使用APIの理由を宣言（§143参照に加えiOS固有）
- **GDPR/APPI対応**: ユーザーデータの収集・保存・削除フローを実装
- **同意管理**: 初回起動時にデータ収集同意UIを表示。同意なしでのデータ送信は禁止
- **データ削除**: ユーザーアカウント削除時に全ローカルデータを完全削除

### §185. App Store/Google Playコンプライアンス

- **IAP必須**: デジタルコンテンツの課金はアプリ内課金（StoreKit 2 / Google Play Billing）を使用
- **ASO（App Store Optimization）**: ストアリスティングのキーワード・スクリーンショット・説明文を最適化
- **レビューガイドライン準拠**: Human Interface Guidelines / Material Design Guidelinesに完全準拠

### §186. エラーハンドリングガバナンス

- **全エラーの分類**: Fatal / Non-fatal / Expected / Unexpected の4分類
- **ユーザー表示**: テクニカルエラーメッセージをユーザーに直接表示することを禁止
- **エラー回復**: 全エラー画面にリトライ/ホームに戻るアクションを必須実装

### §187. グリーンエンジニアリング

- **バッテリー最適化**: バックグラウンド処理の最小化。位置情報の精度をユースケースに合わせて選択
- **ネットワーク効率**: バッチリクエスト、圧縮、キャッシュでデータ転送量を削減
- **計算効率**: 不要なリビルド・再計算の排除（§72-§77準拠）

### §188. チーム・組織設計

- **コードレビュー**: 全PRに最低1名のレビュー。Flutter固有のパフォーマンス・セキュリティ観点を含む
- **ADR（Architecture Decision Record）**: 重要な技術選定はADRとして記録
- **ナレッジ共有**: 月次のFlutter技術共有セッション。公式ブログ・リリースノートの定期レビュー

---

# Part Q: 成熟度・アンチパターン・将来展望

## XXXIX. 成熟度モデル・アンチパターン

### §189. 成熟度モデル

| レベル | 名称 | 基準 |
|---|---|---|
| L1 | Reactive | クラッシュ対応のみ。テスト不足。`setState()`主体 |
| L2 | Managed | CI/CD稼働。Unit Test導入。Riverpod導入。Golden Test開始 |
| L3 | Optimized | オフラインファースト。RASP導入。a11yテスト自動化。Material 3完全移行 |
| L4 | Proactive | Shorebird OTA運用。パフォーマンスバジェット厳守。セキュリティスキャンCI統合 |
| L5 | Predictive | AI支援テスト。自動パフォーマンス回帰検知。FinOps最適化。グリーンエンジニアリング |

### §190. 禁止アンチパターン集（Top 50）

| # | アンチパターン | 正しいアプローチ |
|---|---|---|
| 1 | `setState()`の乱用 | Riverpod `Notifier`で状態管理 |
| 2 | 手動プロバイダ定義 | `@riverpod`コード生成 |
| 3 | `Navigator.push()`直接使用 | GoRouter `context.go()` |
| 4 | `SharedPreferences`にトークン保存 | `flutter_secure_storage` |
| 5 | `dynamic`型の多用 | 厳密な型注釈 |
| 6 | `Image.network()`直接使用 | `cached_network_image` |
| 7 | API Keyのハードコード | `--dart-define`またはサーバー取得 |
| 8 | `ListView(children:[...])`全件 | `ListView.builder()` |
| 9 | 全状態のwatch（selectなし） | `ref.watch(p.select(...))` |
| 10 | Debugモードでの計測 | Profile/Releaseモードで計測 |
| 11 | `MethodChannel`の直指定 | Pigeon（型安全Platform Channel）|
| 12 | iOSでMaterialダイアログ | `CupertinoAlertDialog` |
| 13 | 難読化なしのリリースビルド | `--obfuscate`必須 |
| 14 | `.then()`チェーン | `async/await` |
| 15 | テストなしのUIデプロイ | Golden Test + CI/CD必須 |
| 16 | `Widget buildXxx()`関数 | 独立したWidgetクラスに抽出 |
| 17 | `GlobalKey`の乱用 | `ValueKey` / `UniqueKey` |
| 18 | `late var`の多用 | `late final`のみ、または`?`nullable |
| 19 | `!`演算子の使用 | `?.`、`??`、パターンマッチング |
| 20 | Barrel Export（循環参照） | 直接インポート |
| 21 | `IntrinsicHeight`の多用 | 固定高さまたは`ConstrainedBox` |
| 22 | Fire-and-forget | 全`Future`に`await`または明示的無視 |
| 23 | `Color(0xFF...)`ハードコード | `Theme.of(context).colorScheme` |
| 24 | StreamSubscription未解放 | `ref.onDispose()`で解放 |
| 25 | GodWidget（500行超の1Widget） | 50行以下のWidget分割 |
| 26 | `BuildContext`の非同期使用 | `mounted`チェックまたは`ref` |
| 27 | テスト内のreal API呼び出し | モック/スタブで分離 |
| 28 | `print()`のリリースビルド残留 | `kReleaseMode`ガード |
| 29 | Skiaフォールバックのデフォルト化 | Impellerをデフォルト有効 |
| 30 | `http`パッケージの使用 | `dio`を標準採用 |
| 31 | 環境変数のハードコード | `--dart-define-from-file` |
| 32 | 画面回転ロック | 全方向対応レイアウト |
| 33 | `TextScaler`無視 | 200%スケール対応テスト |
| 34 | セキュリティテスト未実施 | MobSF CI統合 |
| 35 | `provider`パッケージ使用 | `riverpod`に移行 |
| 36 | マジックストリング（ルートパス） | `AppRoutes`定数 |
| 37 | `await`チェーン（ウォーターフォール） | `Future.wait()`並列実行 |
| 38 | 過大な画像のデコード | `ResizeImage`で適正サイズ |
| 39 | `Semantics`未設定 | 全インタラクティブ要素にラベル |
| 40 | ML推論のメインスレッド実行 | `Isolate.run()`で分離 |
| 41 | RiverpodレガシーAPIの使用 | `Notifier`/`AsyncNotifier`に移行 |
| 42 | `ref.mounted`チェックの欠如 | 非同期後に`if (!ref.mounted) return` |
| 43 | `riverpod_lint`未導入 | `riverpod_lint`をanalysis_optionsに追加 |
| 44 | `showDialog()`の直接コール散在 | ダイアログはサービス/ユーティリティクラスに集約 |
| 45 | Overlay API未使用のドロップダウン | `OverlayPortal`/`CompositedTransformFollower`を使用 |
| 46 | `TextEditingController`の未dispose | `ref.onDispose()`で確実に解放 |
| 47 | 通知の`message_id`未チェック（重複処理） | 冪等性を保証する`message_id`チェック |
| 48 | `Scaffold.of(context)`の直接使用 | `ScaffoldMessenger.of(context)` |
| 49 | 起動時の全権限一括リクエスト | コンテキスト依存の段階的権限リクエスト |
| 50 | `AnimationController`未dispose | `SingleTickerProviderStateMixin`+`dispose()`厳守 |

### §191. FinOps基準値

| メトリクス | 目標値 |
|---|---|
| CIビルド時間 | ≤ 15分 |
| アプリサイズ（AAB/IPA） | ≤ 30MB |
| コールドスタート時間 | ≤ 2秒 |
| フレームレート | ≥ 60fps（120fps推奨） |
| クラッシュフリー率 | ≥ 99.5% |
| テストカバレッジ（Domain） | ≥ 90% |
| セキュリティスキャンパス率 | 100% |

---

## XL. 将来展望

### §192. 技術ロードマップ

- **Dart Augmentations**: クラス定義の分割機能。安定版リリース後に`freezed`等の簡素化を検討
- **Flutter GPU API**: カスタムレンダリングのGPU直接アクセス。ゲーム・3D描画の革新
- **WebAssembly（Dart→Wasm）**: Web対象パフォーマンスの大幅向上。Flutter 3.38+で安定性向上
- **Riverpod Offline GA**: 永続化機能の安定版リリース。Experimental卒業後に全面採用
- **GenUI SDK（Flutter 3.41+）**: GeminiベースのAI支援開発ツール。自然言語からUIコンポーネントの自動生成
- **Impeller Desktop/Web統合**: macOS/Windows/LinuxへのImpeller展開が進行中。WebGPU経由のWeb統合も将来展望

### §193. エコシステム進化

- **AI-Driven Development**: Gemini Code Assistによるコード生成・リファクタリング自動化
- **Design-to-Code**: Figma→Flutter Widget自動変換の成熟
- **Edge Computing**: オンデバイスAIの進化。Gemini Nanoの対応デバイス拡大
- **Cross-Platform統一**: Flutter Web/Desktop/Mobileの境界線がさらに曖昧化
- **Sustainability**: カーボンアウェアなモバイルアプリ開発の標準化
- **Flutterモジュラリゼーション**: フレームワークのモジュール分割が進行。必要なコンポーネントのみインポートしビルドサイズ削減

---

# Part R: モバイル固有インフラストラクチャ

## XLI. プッシュ通知アーキテクチャ

### §194. FCM / APNs 統合

- **Firebase Cloud Messaging（FCM）**: Android / iOS / Web の統一的なプッシュ通知基盤
- **APNs直接統合**: iOS固有の通知機能（Live Activity、Critical Alert等）を活用する場合はAPNs直接統合を検討
- **トークン管理**: FCMトークンはサーバー側で一元管理。トークンリフレッシュ時の即座の更新を保証
- **Permission Request**: 通知許可はアプリ初回起動時ではなく、**ユーザーが通知のメリットを理解したタイミング**で行う（コンテキスト依存許可）
- **チャンネル設計（Android）**: Notification Channelをユースケースごとに分離（`chat`、`promotion`、`system`等）
- **`flutter_local_notifications`統合**: FCM受信時にローカル通知を生成し、フォアグラウンドでの表示カスタマイズを実現
- **冪等性（message_id）**: 通知の`message_id`で重複処理を防止。同一の通知を複数回処理しない設計を必須とする

### §195. 通知ペイロード設計

- **Data Message vs Notification Message**: バックグラウンド処理が必要な場合は**Data Message**を使用。Notification Messageはフォアグラウンドでのカスタム表示が制限される
- **ペイロードサイズ**: FCM 4096バイト / APNs 4096バイト以内。画像URLは外部リンクで参照
- **Rich Notification**: iOS: Notification Service Extension / Android: BigPictureStyle で画像・動画プレビュー
- **サイレント通知**: バックグラウンドデータ同期に使用。ユーザーに表示せずデータ更新を実行

### §196. 通知タップハンドリング

- **ディープリンク連携**: 通知タップ時にGoRouter経由で適切な画面に遷移（§56–§59参照）
- **フォアグラウンド通知**: `firebase_messaging`の`onMessage`でアプリ内バナー（Snackbar/Dialog）として表示
- **通知履歴**: 通知一覧画面を実装し、既読/未読管理を行う

---

## XLII. 認証・App Check

### §197. 生体認証（Biometric Authentication）

- **`local_auth`パッケージ**: Face ID / Touch ID（iOS）、指紋認証 / 顔認証（Android）を統一インターフェースで実装
- **用途**: 決済確認、機密データ表示、再認証。初回ログインの代替としては使用しない
- **フォールバック**: 生体認証失敗時はPIN / パスワード入力にフォールバック
- **Keychain / Keystore連携**: 生体認証成功後にKeychain / Android Keystoreからトークンを取得する設計
- **Passkeys / FIDO2対応**: パスワードレス認証の次世代標準。iOS 16+ / Android 14+のCredential ManagerでPasskeyをサポート
- **パスワードレスフロー**: WebAuthn API経由でサーバーサイドでPasskeyを検証。クライアント側は`credential_manager`プラグインで統一的に実装

### §198. Firebase App Check

- **デバイス認証**: App Attestation（iOS）/ Play Integrity（Android）でリクエスト元の正当性を検証
- **バックエンド保護**: Firebase / カスタムバックエンドのAPIエンドポイントをApp Checkトークンで保護
- **Debug Token**: 開発環境ではDebug Providerを使用し、CIではdebugトークンを環境変数で注入
- **フォールバック戦略**: App Check失敗時のリトライロジックとユーザー通知を実装

### §199. ランタイム権限管理

- **`permission_handler`パッケージ**: カメラ、位置情報、写真、マイク等の権限を統一的に管理
- **コンテキスト依存リクエスト**: 権限が必要な機能を使おうとした時点で許可を求める。起動時の一括リクエストは禁止
- **永続拒否（Permanently Denied）対応**: 設定画面への誘導UI（`openAppSettings()`）を必ず実装
- **権限状態の監視**: `AppLifecycleListener`で設定画面からの復帰時に権限状態を再チェック

---

## XLIII. アプリライフサイクル・バックグラウンド

### §200. アプリライフサイクル管理

- **`AppLifecycleListener`（Flutter 3.29+）**: 旧`WidgetsBindingObserver`を置き換え。`onResume`、`onInactive`、`onPause`、`onDetach`、`onHide`、`onShow`を明確に分離
- **状態復元**: バックグラウンドからの復帰時にデータの最新性を確認（`onResume`でAPI再取得）
- **メモリ警告**: `onMemoryPressure`でキャッシュクリア・メモリ解放を実装
- **認証状態確認**: 長時間バックグラウンド後のトークン有効期限チェック

### §201. バックグラウンド処理

- **`workmanager`パッケージ**: Android WorkManager / iOS BGTaskScheduler のFlutterラッパー
- **用途**: 定期データ同期、ログアップロード、キャッシュクリーンアップ
- **制約**: iOS BGTaskSchedulerは最低15分間隔。実行タイミングはOSが制御
- **Headless Dart Callback**: バックグラウンドタスクは`callbackDispatcher`で定義。UIコンテキスト不要
- **電池最適化**: Dozeモード（Android）/ Background App Refresh（iOS）の制約を考慮した設計

### §202. フォアグラウンドサービス

- **`flutter_foreground_task`パッケージ**: 音楽再生・ナビゲーション・位置追跡等の長時間実行タスク
- **通知必須（Android）**: フォアグラウンドサービスは常駐通知が必要。ユーザーに実行中であることを明示
- **バッテリー消費**: フォアグラウンドサービスのバッテリー消費をモニタリングし、不要時は即座に停止

---

## XLIV. In-App Purchase・アプリ更新

### §203. In-App Purchase アーキテクチャ

- **`in_app_purchase`パッケージ**: StoreKit 2（iOS）/ Google Play Billing Library 7+（Android）の公式Flutterプラグイン
- **サーバーサイド検証必須**: レシート / Purchase Token の検証は**必ずサーバーサイド**で実行。クライアントサイド検証のみは完全禁止
- **サブスクリプション管理**: サーバーサイドでReal-Time Developer Notifications（Google）/ App Store Server Notifications V2（Apple）を受信し、ステータスを同期
- **リストア機能**: `restorePurchases()`を設定画面に必ず実装。App Storeレビューガイドライン必須要件
- **サンドボックステスト**: StoreKit Configuration File（iOS）/ Google Play Console テストトラックで開発中の課金テスト

### §204. 強制アップデート・バージョンチェック

- **Firebase Remote Config**: 最低バージョン番号をRemote Configで管理
- **起動時チェック**: アプリ起動時に現在のバージョンとRemote Config値を比較
- **強制アップデート**: 重大なバグ・セキュリティ修正時に全ユーザーにストアへの遷移を強制
- **オプショナルアップデート**: 非破壊的な更新時にBottomSheetで更新を推奨（スキップ可能）
- **ストア遷移**: `url_launcher`で直接ストアページに遷移。iOS App Store / Google Play Storeの両方に対応

### §205. アプリレビュー促進

- **`in_app_review`パッケージ**: ネイティブのアプリ内レビューダイアログ（Apple / Google標準UI）を表示
- **タイミング戦略**: ポジティブなユーザー体験直後（タスク完了、目標達成等）にレビューを依頼
- **頻度制限**: 同一ユーザーに365日以内に3回まで。iOS APIは表示制限を自動管理、Androidは手動制御が必要
- **カスタムプロンプト禁止**: App Storeガイドラインにより、ストアレビューダイアログの前にカスタムレビュー誘導ダイアログを表示することは禁止

---

# Part S: 高度なモバイルインフラ拡張

## XLV. Dart FFI・Native Interop 深化 `[Flutter-Specific]`

### §206. FFI基礎・`dart:ffi`ルール

- **`dart:ffi`**: Dart→C/C++の直接関数呼び出し。Platform Channelより低レイテンシー
- **用途**: 画像処理、暗号演算、既存C/C++ライブラリの統合
- **BindingGen**: `ffigen`パッケージでC/C++ヘッダーからDartバインディングを自動生成
- **メモリ安全**: `Pointer<T>`の手動管理が必須。`calloc.free()`を必ず呼び出し、メモリリークを防止

### §207. JNI・`package:jni`（Android）

- **`package:jni`**: DartからJava/Kotlin APIに直接アクセス
- **`jnigen`**: Javaクラスの.classファイルからDartバインディングを自動生成
- **ユースケース**: Android固有SDK（CameraX、MediaCodec等）の低レベルアクセス
- **スレッド安全**: JNIコールはメインスレッド外で実行。`Isolate.run()`との併用を推奨

### §208. Swift/Objective-C Interop（iOS）

- **`package:ffigen`**: Objective-Cヘッダーからのバインディング生成をサポート
- **Swift Interop**: Swift→Objective-Cブリッジヘッダー経由でDart FFIに接続
- **フレームワーク統合**: XCFrameworkとして配布。`CocoaPods`/`Swift Package Manager`で管理

### §209. Native Build統合

- **CMake（Android NDK）**: `android/app/src/main/jni/CMakeLists.txt`でネイティブビルド設定
- **Podspec（iOS）**: `ios/*.podspec`でC/C++ソースファイルとコンパイルフラグを指定
- **Cross-Compilation**: NDK/Xcode Toolchainでarm64, x86_64等の複数アーキテクチャをサポート
- **CI統合**: ネイティブ依存関係のビルドをCIパイプラインに含め、全アーキテクチャのビルド成功を保証

### §210. FFI安全ガイドライン

- **Null Pointer防御**: FFI呼び出し前のポインタnullチェックを必須化
- **例外ブリッジ**: C/C++の例外をDart例外に変換するラッパーを必ず実装
- **テスト戦略**: FFIバインディングのUnit Testはネイティブテストツール（gtest等）と併用
- **ドキュメント**: 全FFIバインディングにDartdocを記述し、メモリ管理責任を明記

---

## XLVI. 決済統合アーキテクチャ `[Universal+Flutter]`

### §211. 決済サービス選定基準

- **PCI DSS準拠**: クレジットカード決済はPCI DSS準拠のSDK（Stripe、Square等）を使用
- **トークナイゼーション**: カード情報はクライアント側でトークン化。生カード番号の保持は禁止
- **サーバーサイド決済処理**: PaymentIntentの作成・確認は**必ずサーバーサイド**で実行
- **クライアント役割**: UIの表示とユーザー入力の収集のみ。決済ロジックの配置禁止

### §212. Stripe統合パターン

- **`flutter_stripe`パッケージ**: Stripe SDKのFlutter公式バインディング
- **PaymentSheet**: Stripe提供のUI。PCI DSS準拠のカード入力フォームを利用
- **3D Secure（3DS）**: サーバーサイドでPaymentIntentに`automatic_payment_methods`を設定。3DS認証は自動ハンドリング
- **Apple Pay / Google Pay**: `flutter_stripe`経由でネイティブ決済UIを統合

### §213. RevenueCat統合パターン

- **用途**: サブスクリプション管理のSaaS。StoreKit 2/Google Play Billing Libraryの抽象化
- **Entitlementベース設計**: アプリロジックは「Entitlement」（`isPremium`、`hasFeatureX`）で判定。Product IDへの直接依存禁止
- **サーバーサイドWebhook**: RevenueCatのWebhookでサーバー側のEntitlement状態を同期
- **`purchases_flutter`パッケージ**: RevenueCat公式Flutter SDK

### §214. 決済フローUX設計

- **ステータスマッピング**: 決済フローは`PaymentStatus`（`idle`→`processing`→`success`/`failure`）で型安全に管理
- **ローディング表示**: 決済処理中はUIをブロックし、二重決済を防止
- **エラーリカバリ**: 決済失敗時はリトライ/代替決済手段への誘導を必ず実装
- **レシート確認UI**: 決済完了後にレシート情報（金額、日時、Transaction ID）を表示

### §215. 税金・通貨管理

- **通貨表示**: `intl`パッケージの`NumberFormat.currency()`で地域対応の通貨フォーマット
- **最小単位計算**: Stripe等は最小通貨単位（cents）で計算。表示時のみフォーマット変換
- **消費税**: 税計算はサーバーサイドで実行。地域別税率をRemote Configで管理

### §216. 決済コンプライアンス

- **App Store課金ルール**: デジタルコンテンツ・サービスはIAP必須（§203準拠）。物理商品・外部サービスは外部決済可
- **PSD2 SCA**: EU圏はStrong Customer Authentication（3DS2）が法的必須
- **レシートログ**: 全決済トランザクションをサーバーサイドで監査ログに記録

---

## XLVII. ローカル通知・スケジューリング `[Universal+Flutter]`

### §217. ローカル通知基盤

- **`flutter_local_notifications`**: iOS/Androidのローカル通知の統一API
- **用途**: リマインダー、タイマー、オフライン完了通知。プッシュ通知なしで動作
- **チャンネル分離（Android）**: `AndroidNotificationChannel`でユースケース別に分離。ユーザー設定を尊重
- **権限管理**: iOS 10+は`UNUserNotificationCenter`の許可が必要。Android 13+は`POST_NOTIFICATIONS`権限

### §218. 通知スケジューリング

- **日時指定**: `zonedSchedule()`でタイムゾーン考慮のスケジュール通知
- **繰り返し通知**: `periodicallyShow()`で日次/週次のリマインダー
- **精密スケジュール（Android 12+）**: `SCHEDULE_EXACT_ALARM`権限。ユーザー許可が必要
- **キャンセル戦略**: `cancel(id)`/`cancelAll()`で不要通知を即座にクリア

### §219. 通知アクション・Deep Link連携

- **アクション付き通知**: `AndroidNotificationAction`/`DarwinNotificationAction`でインライン応答ボタンを追加
- **通知タップ→ルーティング**: 通知ペイロードに`route`パラメータを含め、GoRouterで対象画面に遷移
- **フォアグラウンド表示**: `onDidReceiveNotificationResponse`でフォアグラウンド通知のタップハンドリング

### §220. 通知テスト・検証

- **Unit Test**: `FlutterLocalNotificationsPlugin`のモックで通知呼び出しを検証
- **統合テスト**: 実機/エミュレータでスケジュール通知の発火タイミングを確認
- **タイムゾーンテスト**: `timezone`パッケージでDST（夏時間）切り替え時の動作を検証

---

## XLVIII. ウィジェットテスト深化 `[Flutter-Specific]`

### §221. Widget Testの設計原則

- **ユーザー行動テスト**: `find.text()`/`find.byType()`よりも`find.bySemanticsLabel()`を優先。a11y的にも正しいテスト
- **Arrange-Act-Assert**: `pumpWidget()`→`tap()`→`expect()`の3フェーズ構造を厳守
- **テストサイズ指定**: `binding.setSurfaceSize()`で画面サイズを固定し、レスポンシブテストを実施

### §222. Golden Test戦略

- **`matchesGoldenFile()`**: ピクセル単位の画面スナップショットテスト
- **`alchemist`フレームワーク**: CI環境でのフォントレンダリング差異を吸収。プラットフォーム間のGolden差分を最小化
- **更新フロー**: `flutter test --update-goldens`でベースライン更新。PRレビュー時にGolden差分を必ず目視確認
- **命名規則**: `test/goldens/{feature}_{variant}.png`で統一

### §223. インタラクションテスト

- **スクロールテスト**: `drag()`/`fling()`でスクロール動作を検証
- **ジェスチャーテスト**: `longPress()`/`dragFrom()`でジェスチャー操作をシミュレート
- **テキスト入力テスト**: `enterText()`でフォーム入力→`find.text()`でバリデーション結果を検証
- **アニメーションテスト**: `pumpAndSettle()`でアニメーション完了を待機。デュレーション0で即時完了テスト

### §224. テストカバレッジ戦略

- **必須Widget Test対象**: 全画面Widget、全フォームWidget、全ナビゲーションフロー
- **カバレッジ基準**: Presentation層80%以上。Domain/Data層90%以上
- **テストマトリクス**: 画面サイズ（phone/tablet）× テーマ（light/dark）× ロケール（ja/en）

### §225. ビジュアルリグレッションCI

- **CI Golden Test実行**: `flutter test --tags=golden`でGolden Testのみ分離実行
- **画像比較ツール**: Pixel diff > 0.5%で失敗判定。微小な差異は`tolerance`パラメータで制御
- **レポート出力**: 失敗時にdiff画像をCI Artifactとして出力し、即座にレビュー可能に

---

## XLIX. エラーバウンダリ・Recovery UX `[Universal]`

### §226. エラー分類体系

- **Fatal Error**: アプリ続行不能（DB破損、認証不正等）。強制再起動フローを表示
- **Recoverable Error**: リトライ/代替パスで回復可能（ネットワーク一時障害、API 500等）
- **Expected Error**: ビジネスロジック上の想定済みエラー（バリデーション失敗、権限不足等）
- **Silent Error**: ユーザー影響なし。ログ記録のみ（アナリティクス送信失敗等）

### §227. エラーバウンダリWidget

- **`ErrorBoundary`Widget**: アプリ全体をラップし、未処理例外をキャッチして`ErrorScreen`を表示
- **`FlutterError.onError`**: Flutterフレームワーク内エラーをCrashlytics/Sentryに転送
- **`PlatformDispatcher.instance.onError`**: Dartランタイムの未処理例外をキャッチ
- **Zone Guard**: `runZonedGuarded()`で全非同期コードの例外をキャッチ

### §228. Recovery UXパターン

- **リトライボタン**: 全エラー画面に「再試行」ボタンを必ず配置
- **オフライン状態表示**: ネットワーク切断時は`OfflineBanner`を画面上部に常時表示
- **Stale Data表示**: キャッシュデータ表示中は「最終更新: XX分前」のラベルを付与
- **段階的デグレード**: 主要機能が利用不可の場合、代替UIを表示（画像読込失敗→プレースホルダ等）

### §229. エラーメッセージ設計

- **ユーザーフレンドリー**: テクニカルエラーメッセージの直接表示を禁止
- **アクション指向**: エラーメッセージに「次の行動」を含める（「接続を確認してリトライ」等）
- **多言語対応**: エラーメッセージはi18nキーで管理。ハードコード禁止
- **エラーコード**: 内部エラーコード（`E-AUTH-001`等）をログにのみ記録。ユーザーには非表示

### §230. クラッシュ後の復旧

- **状態復元**: `RestorationMixin`でフォーム入力・スクロール位置を復元
- **再起動検知**: SharedPreferencesにクラッシュフラグを記録。起動時に検知して回復フロー実行
- **データ整合性**: クラッシュ後のDB整合性チェック。不整合データの自動修復またはユーザー通知

---

## L. Connectivity・ネットワークレジリエンス `[Universal]`

### §231. ネットワーク状態管理

- **`connectivity_plus`パッケージ**: WiFi/モバイル/なしの接続状態を検知
- **`InternetConnectionChecker`**: 実際のインターネット到達可能性を確認（DNS解決ベース）
- **Riverpod統合**: `connectivityProvider`でアプリ全体の接続状態をリアクティブに管理
- **UI反映**: オフライン時は赤い`OfflineBanner`を`MaterialBanner`で画面上部に表示

### §232. オフラインキュー

- **操作キュー**: オフライン中のユーザー操作をローカルDBにキューイング
- **再接続時同期**: 接続復帰時にキューを順次実行。コンフリクト解決ロジックを実装
- **冪等性保証**: キューされた操作は`idempotency_key`で重複実行を防止
- **キュー可視化**: 未同期の操作件数をUI上でバッジ表示

### §233. リトライ戦略

- **Exponential Backoff**: 初回1秒→2秒→4秒→…最大60秒のバックオフ
- **Jitter**: バックオフにランダムジッターを追加し、サーバー集中を防止
- **最大リトライ回数**: API呼び出しは最大5回。超過時はユーザーに通知
- **Circuit Breaker**: 連続失敗3回でCircuit Open。30秒後にHalf-Openで再試行

### §234. 帯域適応戦略

- **画質動的調整**: 接続品質に応じて画像解像度を自動切替（WiFi: 高解像度、3G: 低解像度）
- **プリフェッチ制御**: WiFi接続時のみプリフェッチを実行。モバイルデータでは省データモード
- **圧縮**: APIレスポンスのgzip/br圧縮を必須化。Dioインターセプタで`Accept-Encoding`を設定

### §235. VPN・プロキシ検出

- **セキュリティ要件**: 金融/ヘルスケアアプリはVPN/プロキシ経由の接続を検出し、追加認証を要求
- **Certificate Pinning連携**: VPN環境でのCertificate Pinning失敗時の適切なエラーハンドリング

---

## LI. アプリ内ナビゲーションUX設計 `[Universal+Flutter]`

### §236. Bottom Navigation設計

- **`NavigationBar`（Material 3）**: 3〜5個の主要機能にアクセス。6個以上はDrawerに移行
- **状態保持**: 各タブの状態をPreserveで保持。タブ切替時にリビルドしない設計
- **`StatefulShellRoute`（GoRouter）**: ネストされたNavigatorで各タブの独立したナビゲーションスタックを管理
- **バッジ**: 未読件数はBadge Widgetで表示。Riverpod Providerからリアクティブに更新

### §237. Modal・BottomSheet設計

- **`showModalBottomSheet`**: 補助的なアクション・選択肢の表示
- **`DraggableScrollableSheet`**: コンテンツ量に応じて高さが変動するシート
- **閉じる操作**: スワイプダウン/外部タップ/閉じるボタンの3手段を必ず提供
- **Dialog vs BottomSheet**: 確認/警告はDialog。選択/フィルターはBottomSheet

### §238. Drawer・最上位ナビゲーション

- **`NavigationDrawer`（Material 3）**: 5個以上のセクションがある場合に使用
- **ハンバーガーメニュー**: 使用可能だが、主要機能はBottom Navigationに配置。Drawerは設定・サブ機能に限定
- **Railナビゲーション**: タブレット/デスクトップでは`NavigationRail`に自動切替

### §239. ページ遷移アニメーション

- **プラットフォーム準拠**: iOSはリーフ遷移（右→左スライド）、Androidは上方向フェード
- **GoRouter遷移**: `CustomTransitionPage`でルート別にカスタム遷移を定義
- **共有要素遷移**: `Hero`ウィジェットでリスト→詳細画面の共有要素アニメーション
- **遷移時間**: 200〜400msの範囲。300msがデフォルト推奨

### §240. インタースティシャル・オーバーレイ

- **`OverlayPortal`（Flutter 3.32+）**: フローティングUI（ツールチップ、ドロップダウン）の標準API
- **DropDown最新パターン**: `OverlayPortal`+`CompositedTransformFollower`でウィジェットツリー外にレンダリング
- **背景スクリム**: モーダルオーバーレイは半透明スクリムで背景を暗転。タップで閉じる操作を標準化

---

## LII. 構成管理・Feature Flag深化 `[Universal]`

### §241. Feature Flag基盤

- **Firebase Remote Config**: Feature Flagの標準ソリューション
- **フラグ命名規則**: `feature_{機能名}_{段階}` — `feature_new_checkout_enabled`
- **デフォルト値**: 全フラグにローカルデフォルト値を設定。Remote Config到達不能時のフォールバック
- **キャッシュ戦略**: `minimumFetchInterval`を本番12時間、開発10分に設定

### §242. 段階的ロールアウト

- **ユーザーセグメント**: Remote Config条件でユーザーID末尾/国/バージョンによる段階展開
- **カナリアリリース**: 1%→5%→25%→100%の段階。各段階でクラッシュ率・パフォーマンスを監視
- **キルスイッチ**: 全Feature Flagに即座に無効化可能なキルスイッチを実装
- **A/Bテスト統合**: Firebase A/B TestingでFeature Flagとコンバージョンの相関を測定

### §243. 設計パターン

- **Feature Flagプロバイダ**: `featureFlagProvider(flagName)`でRiverpodから型安全にアクセス
- **コード分離**: Feature Flagによる分岐はUseCase/Repository層に限定。Widget内の`if`分岐を最小化
- **テスト除外**: Feature FlagのON/OFF両方をUnit Testでカバー

### §244. 技術的負債管理

- **有効期限**: 全Feature Flagに有効期限（最大90日）を設定。期限超過フラグは強制クリーンアップ
- **Lint警告**: カスタムAnalyzerプラグインで90日超のFeature Flagを警告
- **クリーンアップPR**: Feature Flagの完全ロールアウト後、7日以内にフラグ削除PRを作成

### §245. 緊急統制

- **グローバルキルスイッチ**: アプリ全体の特定機能を即座に無効化するマスターフラグ
- **メンテナンスモード**: 全機能を停止し、メンテナンス画面を表示するフラグ
- **強制アップデート連携**: Remote Configのバージョンチェック（§204）と連携

---

## LIII. データプライバシー・同意管理深化 `[Universal]`

### §246. 同意管理プラットフォーム（CMP）

- **用途**: GDPR/APPI/CCPA等の各地域プライバシー法対応
- **標準SDK**: TCF 2.0（IAB Transparency & Consent Framework）準拠のCMP SDKを採用
- **初回同意**: アプリ初回起動時に同意管理UIを表示。同意なきデータ収集は完全禁止
- **同意状態管理**: `ConsentStatus`（`granted`/`denied`/`notDetermined`）をRiverpod Providerで管理

### §247. データ分類・権限マッピング

- **PII分類**: Tier 1（直接個人特定: 氏名, メール）、Tier 2（間接識別: デバイスID, IP）、Tier 3（匿名: 集計データ）
- **目的別同意**: 「分析」「マーケティング」「パーソナライゼーション」の目的別に独立した同意を取得
- **同意→機能マッピング**: 同意状態に応じてAnalytics/Crashlytics/広告SDKの初期化を制御

### §248. データ主体の権利

- **アクセス権**: ユーザーが自分のデータの全エクスポートを要求できるUI（設定画面内）
- **削除権**: アカウント削除時に全ローカルデータ＋サーバーデータの削除を実行
- **ポータビリティ**: JSON形式でのデータエクスポート機能
- **対応期限**: GDPR要求は30日以内に自動処理

### §249. Apple App Tracking Transparency（ATT）

- **iOS 14.5+**: IDFA取得前に`requestTrackingAuthorization()`を必ず呼び出し
- **`app_tracking_transparency`パッケージ**: ATTダイアログの表示とステータス管理
- **Denied時の対応**: トラッキング拒否時は`IDFA`を使用せず、コンテキスト広告にフォールバック
- **App Storeレビュー**: ATTプロンプトの事前説明（Pre-prompt）を実装し、承認率を向上

### §250. プライバシーテスト

- **Privacy Manifest検証**: Xcode 15のPrivacy Report機能で`PrivacyInfo.xcprivacy`の網羅性を確認
- **ネットワーク監査**: Charles Proxy等で全通信先を確認。未宣言のデータ送信先がないことを検証
- **データ削除テスト**: アカウント削除後にローカルDB/Keychain/SharedPreferencesのクリーンアップを確認
- **同意状態テスト**: 同意ON/OFFの全組み合わせで機能制限が正しく動作することを検証

---

## LIV. モバイルDevOps・DX `[Universal+Flutter]`

### §251. 開発環境標準化

- **FVM（Flutter Version Management）**: プロジェクト単位のFlutterバージョン固定
- **`.fvmrc`**: プロジェクトルートにFlutterバージョンを明記。`fvm use 3.41.0`で全開発者を統一
- **VSCode Settings**: `.vscode/settings.json`でFVM SDKパスを自動設定
- **DevContainer**: Docker + FVM + Android SDKのDevContainer定義で環境構築を5分以内に

### §252. コード生成パイプライン

- **`build_runner`最適化**: `build.yaml`でターゲットフィルタリング。不要な生成を除外
- **生成ファイル管理**: `.g.dart`/`.freezed.dart`は`.gitignore`で除外（CI生成推奨）またはコミット（チーム判断）
- **ウォッチモード**: `dart run build_runner watch --delete-conflicting-outputs`で開発中の自動再生成
- **CI統合**: `dart run build_runner build --delete-conflicting-outputs`をCIの最初のステップで実行

### §253. Hot Reload・開発効率

- **Hot Reload最大化**: StatelessWidget + `const`コンストラクタの徹底でHot Reload成功率を向上
- **Hot Restart回避**: 状態初期化ロジックを`ref.onDispose()`で適切に管理し、Hot Restartの必要性を削減
- **デバッグ拡張**: `toString()`オーバーライドでデバッグ出力を充実

### §254. 開発ツールチェーン

- **Flutter DevTools**: Performance、Memory、Network、Widgetタブで包括的なデバッグ
- **Dart DevTools**: CPU Profiler、Heap Snapshot、Logging Viewで詳細分析
- **カスタムDevTools拡張**: `devtools_extensions`でプロジェクト固有のデバッグパネルを追加可能
- **Very Good CLI**: `very_good_cli`でプロジェクトテンプレート・パッケージ雛形を高速生成

### §255. PR品質ゲート

- **自動レビュー**: `dart analyze` + `dart format --set-exit-if-changed`をPRトリガーで実行
- **テスト必須**: Unit + Widget Test（最低80%カバレッジ）のPass必須
- **ファイルサイズ制限**: 新規Dartファイルは300行以下。超過時は分割理由をPR説明に記載
- **レビュー範囲**: +500行を超えるPRは原則分割

### §256. ドキュメント・ナレッジベース

- **ADR（Architecture Decision Record）**: `docs/adr/`に重要な技術判断を記録
- **Widget Catalog**: Widgetbook/Storybook for Flutterで全カスタムWidgetをカタログ化
- **API Contract**: `openapi.yaml`でバックエンドAPIの型定義を管理。`openapi_generator`でDart clientを自動生成
- **オンボーディング**: `CONTRIBUTING.md`にセットアップ手順、コーディング規約、PRフローを記載

---

## LV. 言語固有補遺・拡張アンチパターン `[Flutter-Specific]`

### §257. Dart 3.7+ 最新機能の活用

- **Wildcard Variables（`_`）**: 未使用変数は`_`で明示。コード意図を明確化
- **Strict Bound Checks**: ジェネリクスの上限・下限チェックの厳格化
- **Extension Types**: プリミティブ型のラッパーとして使用。コンパイル時のゼロコスト抽象化
- **Enhanced Enums**: `enum`にフィールド・メソッドを追加し、型安全な値オブジェクトを実現

### §258. パッケージ依存管理

- **`dart pub outdated`月次実行**: 依存パッケージの更新状況を月次チェック
- **Resolvable版指定**: `^`（caret syntax）でメジャーバージョンロック。パッチ・マイナーは自動更新
- **依存関係ツリー分析**: `dart pub deps --style=compact`で依存ツリーを可視化。不要な推移的依存を排除
- **セキュリティアドバイザリ**: `dart pub`の脆弱性警告に48時間以内に対応

### §259. メモリリーク防止パターン

- **StreamSubscription**: `listen()`で取得した`StreamSubscription`は必ず`cancel()`
- **Timer**: `Timer.periodic()`は`dispose()`時に`cancel()`
- **AnimationController**: `SingleTickerProviderStateMixin`使用時、`dispose()`で必ず解放
- **Riverpod連携**: `ref.onDispose()`で全リソースのクリーンアップを一元管理
- **DevTools Memoryタブ**: HeapSnapshotで定期的にリーク検知

### §260. 非同期プログラミング深化

- **`Stream.asyncMap`**: ストリームイベントの非同期変換
- **`StreamQueue`**: ストリームからの順次値取得（テスト用途で有用）
- **Completer Pattern**: コールバックベースAPIをFutureに変換
- **`runZonedGuarded`**: 非同期コードの例外境界を設定
- **Rate Limiting**: `Stream.throttle()`/`Stream.debounce()`でUIイベントの流量制御

### §261. 型安全パターン集

- **Union Types**: `sealed class`で代数的データ型を定義。全パターンの網羅的マッチングを保証
- **Type-Safe ID**: `extension type UserId(String value)`で文字列IDの型混同を防止
- **Result型**: `sealed class Result<T>`で`Success<T>`/`Failure`を定義。例外に頼らないエラーハンドリング
- **Branded Types**: Extension Typeで`Email`、`Password`等のドメイン固有型を定義

### §262. コード品質メトリクス

- **Cyclomatic Complexity**: 関数あたり≤10を目標。超過時はリファクタリング対象
- **依存関係数**: 1クラスの依存は≤7。超過時は責務分割のサイン
- **ファイル行数**: 300行以下を厳守。Widget + Logic混在は分離
- **カスタムLint**: `custom_lint`パッケージでプロジェクト固有のLintルールを定義

### §263. Flutter固有デバッグ手法

- **`debugPaintSizeEnabled`**: レイアウトデバッグ用のサイズ可視化
- **`debugPaintBaselinesEnabled`**: テキストベースラインの可視化
- **`debugRepaintRainbowEnabled`**: リペイント領域のレインボー表示
- **`Timeline.startSync()`**: カスタムパフォーマンスイベントの記録
- **`debugPrint()`**: 長い出力を自動的にスロットリングする安全なprintラッパー

### §264. レスポンシブ設計深化

- **ブレークポイント定数**: `Breakpoints`クラスで`compact`(< 600dp)/`medium`(600-839dp)/`expanded`(840dp+)を定義
- **`AdaptiveScaffold`**: Material 3のアダプティブレイアウトWidget
- **条件付きWidget**: `LayoutBuilder`でブレークポイントに応じたWidget切替
- **テスト網羅**: 全ブレークポイントのGolden Testを実施

### §265. CI自動化拡張

- **マージキュー**: GitHub Merge Queueでコンフリクト検知をマージ前に自動化
- **自動バージョニング**: `cider`/`version`パッケージでSemVerバージョンを自動インクリメント
- **Changelog自動生成**: Conventional Commitsからchangelogを自動生成
- **依存関係更新自動化**: Dependabot/Renovateで月次のdependency updatePRを自動作成

---

## Appendix A: 逆引き索引

### キーワード → セクション

| キーワード | 対応セクション |
|---|---|
| Supreme Directive・哲学・品質ゲート | §1–§4 |
| パッケージスタック・analysis_options | §5–§8 |
| Clean Architecture・レイヤー・DI・SSOT | §9–§14 |
| Dart 3.7・Wildcard・フォーマッター・型注釈 | §15–§21 |
| sealed class・パターンマッチング・Enum・Null安全 | §22–§26 |
| async/await・Isolate・Stream・キャンセレーション | §27–§31 |
| build_runner・Macros廃止・Augmentations | §32–§35 |
| Riverpod・Notifier・Provider・watch・select・Freezed | §36–§41 |
| Provider依存・スコープ・AsyncValue | §42–§46 |
| Offline Persistence・Mutations・状態復元 | §47–§50 |
| GoRouter・ルーティング・認証ガード・ネスト | §51–§55 |
| ディープリンク・Universal Links・App Links | §56–§59 |
| UseCase・Entity・DTO・DataSource | §60–§64 |
| Repository・キャッシュ・ページネーション・同期 | §65–§68 |
| DI・環境別設定・Flavor | §69–§71 |
| 60fps・120fps・const・リビルド・RepaintBoundary | §72–§77 |
| Impeller・Skia・シェーダー | §78–§80 |
| Widget分割・Sliver・key・レイアウト最適化 | §81–§85 |
| 起動速度・アプリサイズ・Tree Shaking・難読化 | §86–§89 |
| メモリリーク・HeapSnapshot・プロファイリング | §90–§93 |
| オフラインファースト・Drift・SQLCipher・同期 | §94–§98 |
| Dio・API Key・Bearer Token・VIP Lane・リトライ | §99–§104 |
| 画像キャッシュ・WebP・SVG・動画 | §105–§108 |
| WebSocket・SSE・Supabase Realtime | §109–§111 |
| Cupertino・Material・Pigeon・FFI・ハプティクス | §112–§116 |
| レスポンシブ・ブレークポイント・AdaptiveScaffold | §117–§121 |
| Material 3・Design Token・テーマ・ダークモード | §122–§126 |
| アニメーション・Lottie・Rive・遷移 | §127–§130 |
| フォーム・バリデーション・IME・検索 | §131–§134 |
| Semantics・タップターゲット・コントラスト・VoiceOver | §135–§141 |
| OWASP・Keychain・Certificate Pinning・MobSF | §142–§146 |
| RASP・freeRASP・Root検出・改竄検出 | §147–§149 |
| ML Kit・TFLite・Gemini・AIエージェント | §150–§154 |
| Unit Test・Golden Test・Maestro・E2E・カバレッジ | §155–§162 |
| CI/CD・Fastlane・Shorebird・OTA・Flavor | §163–§170 |
| Crashlytics・Sentry・Analytics・ログ・Remote Config | §171–§176 |
| Flutter Web・Desktop・SBOM・Wearable・Melos | §177–§182 |
| i18n・プライバシー・App Store・グリーンエンジニアリング | §183–§188 |
| FinOps・成熟度・アンチパターン50選 | §189–§191 |
| ロードマップ・AI開発・将来展望 | §192–§193 |
| FCM・APNs・プッシュ通知・通知チャンネル | §194–§196 |
| 生体認証・App Check・権限管理 | §197–§199 |
| AppLifecycleListener・WorkManager・フォアグラウンドサービス | §200–§202 |
| IAP・強制アップデート・アプリレビュー | §203–§205 |
| Dart FFI・JNI・Swift Interop・Native Build | §206–§210 |
| Stripe・RevenueCat・決済・PCI DSS・税金 | §211–§216 |
| flutter_local_notifications・スケジュール・通知アクション | §217–§220 |
| Widget Test・Golden Testセalchemist・ビジュアルリグレッション | §221–§225 |
| エラーバウンダリ・Recovery UX・クラッシュ復旧 | §226–§230 |
| Connectivity・オフラインキュー・リトライ・Circuit Breaker | §231–§235 |
| Bottom NavigationセBottomSheetセDrawerセページ遷移セOverlay | §236–§240 |
| Feature Flagセロールアウトセキルスイッチセ技術的負債 | §241–§245 |
| CMPセGDPRセATTセデータ主体権利セプライバシー | §246–§250 |
| FVMセbuild_runnerセDevToolsセPR品質ゲートセADR | §251–§256 |
| Extension Typeセメモリリークセ型安全セデバッグセレスポンシブ | §257–§265 |

---

## Appendix B: クロスリファレンス

### セクション → 関連ルール

| パート | 関連 Universal ルール |
|---|---|
| I–III 哲学・アーキテクチャ | `000_core_mindset`, `300_engineering_standards` |
| IV–VII Dart言語 | `300_engineering_standards` |
| VIII–X 状態管理 | `300_engineering_standards` |
| XI–XII ナビゲーション | `200_design_ux` |
| XIII–XV アーキテクチャパターン | `300_engineering_standards`, `343_native_platforms` |
| XVI–XX パフォーマンス | `502_site_reliability`, `300_engineering_standards` |
| XXI–XXIV データ・ネットワーク | `301_api_integration`, `320_supabase_architecture` |
| XXV–XXVI プラットフォーム | `343_native_platforms`, `200_design_ux` |
| XXVII–XXVIII デザイン・アニメーション | `200_design_ux` |
| XXIX フォーム | `200_design_ux`, `340_web_frontend` |
| XXX アクセシビリティ | `200_design_ux`, `343_native_platforms` |
| XXXI–XXXII セキュリティ | `600_security_privacy`, `301_api_integration` |
| XXXIII AI・ML | `400_ai_engineering` |
| XXXIV テスト | `700_qa_testing` |
| XXXV CI/CD | `502_site_reliability`, `300_engineering_standards` |
| XXXVI 可観測性 | `401_data_analytics`, `502_site_reliability` |
| XXXVII マルチプラットフォーム | `602_oss_compliance`, `343_native_platforms` |
| XXXVIII ガバナンス | `601_data_governance`, `103_appstore_compliance` |
| XXXIX–XL 成熟度・将来 | `720_cloud_finops`, `801_governance` |
| XLI–XLII プッシュ通知・認証 | `600_security_privacy`, `343_native_platforms` |
| XLIII バックグラウンド・ライフサイクル | `502_site_reliability`, `343_native_platforms` |
| XLIV IAP・アプリ更新 | `103_appstore_compliance`, `720_cloud_finops` |
| XLV FFI・Native Interop | `343_native_platforms`, `300_engineering_standards` |
| XLVI 決済統合 | `600_security_privacy`, `103_appstore_compliance` |
| XLVII ローカル通知 | `343_native_platforms`, `200_design_ux` |
| XLVIII ウィジェットテスト | `700_qa_testing`, `300_engineering_standards` |
| XLIX エラーバウンダリ | `200_design_ux`, `502_site_reliability` |
| L Connectivity | `502_site_reliability`, `301_api_integration` |
| LI ナビゲーションUX | `200_design_ux`, `343_native_platforms` |
| LII Feature Flag | `502_site_reliability`, `401_data_analytics` |
| LIII データプライバシー | `600_security_privacy`, `601_data_governance` |
| LIV DevOps・DX | `502_site_reliability`, `300_engineering_standards` |
| LV 言語固有補遺 | `300_engineering_standards`, `700_qa_testing` |


