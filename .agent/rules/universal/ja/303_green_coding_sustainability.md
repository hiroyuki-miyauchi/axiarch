# 30. エンジニアリングの卓越性 (Engineering Excellence - General)

## 6. グリーンコーディング (Green Coding & Sustainability)
*   **エネルギー効率 (Energy Efficiency)**:
    *   **アルゴリズム**: 計算量（O記法）を意識し、無駄なCPUサイクルを消費しないコードを書きます。これはバッテリー寿命と地球環境の両方を守ります。
    *   **ダークモード**: 有機EL（OLED）デバイスでの消費電力を抑えるため、真の黒（#000000）を使用したダークモードを推奨します。
*   **データ転送量**:
    *   **圧縮**: 画像や動画は必ず最適化（AVIF/H.265）し、ネットワーク帯域の浪費を防ぎます。
    *   **Cache Maximization**: CDNキャッシュヒット率 **80%以上** を目標とし、静的アセットのオリジン負荷を最小化します。
    *   **Centralized Storage Shield**: 画像実体はBaaSストレージ（Origin）に集約し、配信はCDNのOptimization機能を経由させることで、コストとパフォーマンスを両立します。

## 7. ゼロバグ・ポリシー (The "Zero Bug Policy")
*   **修正優先 (Fix First)**:
    *   既知のバグがある状態で新機能を開発しません。バグ修正は最優先事項です。
*   **24時間ルール (24-Hour Rule)**:
    *   クリティカルなバグ（データ損失、セキュリティ、主要機能停止）は、発見から **24時間以内** に修正します。
*   **The Framework Signature Reality (Codebase as Truth)**:
    *   **Context**: ライブラリやフレームワークの公式ドキュメントは更新が遅れることがあります。
    *   **Law**: 公式ドキュメントよりも「既存コードベースのシグネチャ（実際の型定義）」を正とします。APIを使用する前に、必ず `grep` やIDEの定義ジャンプで既存使用例と型定義を確認してください。「ドキュメント通りに書いたのに動かない」は言い訳になりません。
*   **The Fix Twice Principle (再発防止)**:
    *   バグを修正する際は、「そのバグを直す (Fix Once)」だけでなく、「二度と同じバグが起きない仕組み（Lint追加、型厳格化、テスト追加）を作る (Fix Twice)」までをワンセットとします。

## 8. 継続的学習と検証 (Continuous Learning & Verification)
*   **最新情報の確認義務 (Latest Info Protocol)**:
    *   **開発着手前**: コードを書く前に、必ず対象技術の公式ドキュメントや最新のリリースノート（例: "Next.js 15 breaking changes", "Swift 6 concurrency"）を確認します。古い情報に基づいた実装は手戻りの元です。
    *   **非推奨チェック**: 使用しようとしているAPIが Deprecated（非推奨）になっていないか確認します。
*   **トレンドの把握**:
    *   シリコンバレーの最新トレンド（AIエージェント、Privacy Manifests等）を常にキャッチアップし、ルール自体も進化させ続けます。
*   **The Crystallization Protocol (Knowledge Extraction)**:
    *   **Law**: 機能実装完了後、その過程で得られた「暗黙知」「新しいパターン」「ハマったポイント」は、設計書（Blueprint）やルールファイルに文書として還元する義務を負います。
    *   **Rationale**: 知識がコードにのみ存在する状態は「経験の揮発」です。次の開発者（人間・AI問わず）が同じ轍を踏むことを防ぐため、得られた学びを即座にドキュメント化する習慣がチームの生産性を指数関数的に向上させます。

## 9. 互換性とテスト (Compatibility & Testing)
*   **実機テスト (Real Device Testing)**:
    *   シミュレーターだけでなく、必ず実機（iOS, Android）でテストを行います。特にカメラ、GPS、生体認証などのハードウェア機能は実機必須です。
*   **ブラウザ互換性 (Browser Compatibility)**:
    *   Chrome, Safari (iOS/macOS), Firefox, Edge の最新2バージョンをサポートします。特にSafari（iOS）特有のバグ（100vh問題など）に注意します。
*   **セルフチェックリスト (Self-Check List)**:
    *   PRを出す前に、開発者は自身のコードをレビューし、「警告ゼロ」「コンソールエラーなし」「不要なログ削除」を確認します。
