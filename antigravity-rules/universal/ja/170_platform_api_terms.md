# 170. プラットフォームAPI規約とコンプライアンス (Platform API Terms & Compliance)

## 1. Google エコシステム (Google Ecosystem)
*   **Google Maps Platform**:
    *   **キャッシュ禁止 (No Caching)**: 地図データ（緯度経度、場所のIDを除く）の保存・キャッシュは利用規約で厳しく制限されています。一時的なキャッシュ（30日以内等）を除き、原則として毎回APIから取得します。
    *   **帰属表示 (Attribution)**: Googleロゴと著作権表示を隠したり、改変したりすることは禁止です。
*   **YouTube Data API & Player**:
    *   **バックグラウンド再生禁止**: YouTube Premium会員向けの機能である「バックグラウンド再生」をAPIで実装することは規約違反です。
    *   **分離禁止**: 映像と音声を分離して再生すること（音声のみ再生など）は禁止されています。
*   **AdMob / AdSense**:
    *   **無効なトラフィック (Invalid Traffic)**: 開発者自身が広告をクリックすること、またはユーザーにクリックを依頼・推奨すること（インセンティブ付きクリック）は即アカウント停止（BAN）の対象です。テスト時は必ず「テスト広告ID」を使用します。

## 2. Apple エコシステム (Apple Ecosystem)
*   **Sign in with Apple**:
    *   **義務 (Mandate)**: GoogleログインやFacebookログインなどのサードパーティ認証を実装する場合、**Sign in with Apple** も同等のプロミネンス（大きさ、位置）で実装することがガイドラインで義務付けられています。
*   **Apple Pay**:
    *   **UIガイドライン**: Apple Payボタンのサイズ、色、周囲の余白には厳格な規定があります。CSSで勝手にスタイルを変更せず、Appleが提供する公式のアセットまたはAPIを使用します。

## 3. ブランディングガイドライン (Branding Guidelines)
*   **ストアバッジ (Store Badges)**:
    *   "Get it on Google Play" や "Download on the App Store" のバッジは、各社が提供する公式アセットをそのまま使用します。色変更、縦横比の変更、過度な装飾は禁止です。
    *   **クリアスペース**: バッジの周囲には規定の余白（クリアスペース）を確保します。

## 4. クラウドとAIサービス (Cloud & AI Services)
*   **OpenAI / LLM APIs**:
    *   **コンテンツモデレーション**: ユーザーが生成AIを使用する場合、OpenAIの **Moderation Endpoint** 等を使用して、不適切なコンテンツ（ヘイト、暴力、性表現）の生成をブロックする義務があります。
    *   **AI生成の明示**: AIによって生成されたコンテンツであることをユーザーに通知します。
*   **AUP (Acceptable Use Policy)**:
    *   **AWS / GCP**: クラウドプロバイダーのAUP（利用規定）を遵守します。許可なきポートスキャン、クリプトマイニング、スパム送信は即時アカウント停止の対象です。
