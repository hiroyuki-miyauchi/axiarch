# 31. Mobile & Native App Standards (Flutter Edition)

## 1. Architecture & State Management
*   **Clean Architecture**:
    *   UI (Presentation), Logic (Domain), Data (Infrastructure) を明確に分離する。
    *   "Feature-First" なディレクトリ構成を採用し、機能ごとの独立性を高める。
*   **State Management**:
    *   予測可能で不変（Immutable）な状態管理を行う。
    *   **Recommended**: Riverpod (with code generation) または BLoC。
    *   `setState` の乱用を避け、リビルド範囲を最小化する。

## 2. Performance Obsession
*   **60fps / 120fps**:
    *   Jank（カクつき）はバグと同義である。常に滑らかな描画を維持する。
    *   `const` コンストラクタを徹底的に使用する。
    *   重い処理（JSONパース、画像加工等）はメインスレッドで行わず、Isolate（別スレッド）に逃がす。

## 4.3. Code Size & Obfuscation
*   **Release Build**: 必ず `--release` でビルドする。
*   **Obfuscation**: サイズ削減とコード保護のために `--obfuscate --split-debug-info=/<path>` を使用する。
    *   *Why*: シンボル名を短縮し、デバッグメタデータを削除するため。
*   **Tree Shaking**: コンパイラがデッドコードを削除しやすくするために、可能な限り `const` コンストラクタを使用する。

## 5. Testing & CI/CD
*   **Widget Tests**: UIコンポーネントを単体でテストする。
*   **Integration Tests**: 重要なフロー（ログイン、決済）を実機/エミュレータでテストする。
*   **Golden Tests**: UIの退行（リグレッション）を防ぐためにゴールデンテスト（ピクセルパーフェクトチェック）を使用する。

## 3. Platform Fidelity & UI
*   **Native Feel**:
    *   iOSとAndroidそれぞれの「らしさ」を尊重しつつ、ブランドの世界観を統一する。
    *   Material 3 と Cupertino ウィジェットを適切に使い分けるか、高度にカスタマイズされた共通コンポーネントを構築する。

## 4. Robust Connectivity
*   **Offline-First**:
    *   ネットワーク切断時でもアプリがクラッシュせず、閲覧可能なデータは表示する。
    *   Repository Patternを用いて、ローカルキャッシュとリモートデータの同期を適切に管理する。
