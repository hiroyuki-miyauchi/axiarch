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

## 3. Platform Fidelity & UI
*   **Native Feel**:
    *   iOSとAndroidそれぞれの「らしさ」を尊重しつつ、ブランドの世界観を統一する。
    *   Material 3 と Cupertino ウィジェットを適切に使い分けるか、高度にカスタマイズされた共通コンポーネントを構築する。

## 4. Robust Connectivity
*   **Offline-First**:
    *   ネットワーク切断時でもアプリがクラッシュせず、閲覧可能なデータは表示する。
    *   Repository Patternを用いて、ローカルキャッシュとリモートデータの同期を適切に管理する。
