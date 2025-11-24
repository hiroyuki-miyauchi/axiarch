# 39. クロスプラットフォーム戦略 (Cross-Platform Strategy)

## 1. 技術選定基準 (Tech Selection Criteria)
*   **Web (Next.js)**:
    *   **適用**: SEOが必須、インストール不要で即座に利用させたい場合（LP、メディア、SaaSダッシュボード）。
    *   **原則**: コンテンツ閲覧やPCでの作業がメインならWebを第一選択とします。
*   **Flutter**:
    *   **適用**: 高度なUI/UX、オフライン機能、プッシュ通知が必要なモバイルアプリ。
    *   **原則**: iOS/Androidの両対応が必須の新規アプリ開発における標準技術とします。
*   **Native (Swift/Kotlin)**:
    *   **適用**: OSの最新機能（ARKit, HealthKit, Home Screen Widgets）への深い統合が不可欠な場合。
    *   **原則**: Flutterで実現不可能な機能（Widget等）のみをNativeで実装し、Method Channelで連携します。

## 2. 統合と連携 (Integration)
*   **Deep Linking**:
    *   **必須**: Webとアプリをシームレスに繋ぐため、**Universal Links (iOS)** と **App Links (Android)** の実装を義務付けます。
    *   **体験**: ユーザーがWebのURLをタップした際、アプリがインストールされていれば即座にアプリ内の該当ページを開きます。
*   **WebView Bridge**:
    *   **セキュリティ**: アプリ内でWebコンテンツを表示する場合、セキュアな通信プロトコル（JavaScript Bridge）を確立し、不正なスクリプト実行を防ぎます。

## 3. PWA (Progressive Web App)
*   **インストール可能なWeb**:
    *   ネイティブアプリの開発コストをかけずに、ホーム画面への追加やプッシュ通知（Web Push）を実現する軽量な代替手段としてPWAを検討します。
    *   **オフライン対応**: Service Workerを使用して、オフラインでも主要機能が動作するように設計します。
