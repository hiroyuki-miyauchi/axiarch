# 00. コア・フィロソフィーとマインドセット (Core Philosophy & Mindset)

> [!CRITICAL]
> **Supreme Law Declaration (最高法規宣言)**
>
> 1.  本ドキュメント群 (`.agent/rules/universal/*.md`) は、本プロジェクトの開発・運用・ビジネスにおける**最高法規**です。
> 2.  本憲法に違反するコード、設計、運用判断は、いかなる理由があっても**却下（Reject）**されます。
> 3.  全開発者（AI Agentを含む）は、タスク開始前に本憲法を確認し、遵守する義務を負います。

> [!IMPORTANT]
> **絶対的な基盤 (Absolute Foundation)**
> この「Core Philosophy」は、Google Antigravityの全ての活動における憲法であり、例外は認められません。
> 我々は「シリコンバレーの超優秀なエリートチーム」として振る舞い、世界最高水準の成果のみを追求します。

## 8. グローバル・ガバナンス・プロトコル (Global Governance Protocols)

### 8.1. The Supreme Sovereignty Protocol (Deployment & Git Ban)
*   **Supreme Law**: **AIはいかなる理由（「保存のため」「キリが良い」等）があっても、ユーザーからの明示的な指示（「コミットして」「Pushして」等）がない限り、一切のGitコマンド（add, commit, push, stash, restore等）を実行してはなりません。** この違反は、ユーザーの確認機会を奪い履歴を汚染する「あわよくば」の精神に基づく**最高重度の憲法違反**とみなされます。
*   **Action**:
    1.  **Wait**: 作業完了時はファイルを保存（Save）するに留め、`git status` で変更状態を示します。
    2.  **Ask**: 「コミットおよびプッシュを行ってもよろしいですか？」とユーザーに仰ぎ、明示的な承認を得てからのみ実行します。
    3.  **STRICT BRANCH CHECK (厳格なブランチ確認)**:
        *   **Before Code**: 作業を開始する前（最初の1行目のコードを書く前）に必ず `git branch --show-current` を実行してください。
        *   **Before Commit**: コミット直前に再度確認し、現在地が `main` (または `master`) でないことを物理的に確認しなければなりません。出力が `main` であった場合、いかなる理由があっても即座に停止せよ。
    4.  **No Exceptions**: 「Lint修正」「雑用」「タイプミス修正」であっても、`main` への直接コミットは厳禁です。
    5.  **No Assumption**: 「SafeToAutoRun」フラグは「雑用ならワークフローをバイパスして良い」という意味ではありません。Git操作においてAIの独断は一切認められません。

### 8.2. The Main Branch Sanctuary (Strict Enforcement)
*   **Law 1**: `main` (または `master`) ブランチへの直接コミットおよび作業は、**物理的に禁止**とします。「Lint修正」「雑用（chore）」「タイプミス修正」等の些細な理由であっても例外は一切認められません。
*   **Law 2 (Husky Guard)**: 全てのプロジェクトにおいて、**Husky** の導入および `pre-push` フックによる `main` ブランチへの直接プッシュ禁止設定を **義務（Universal Mandate）** とします。「気をつける」という運用ルールは無意味であり、コードによる物理的な防衛線のみを信頼します。
    *   **Implementation**: 具体的なセットアップ手順および技術詳細については、300番台（Engineering） を参照してください。
*   **Action**:
    *   **Stop**: `git branch` が `main` を示している場合、いかなるコード編集も直ちに停止してください。
    *   **Create**: 必ず適切な命名のブランチ（`feature/xxx`, `fix/xxx`）を新規作成し、移動してから着手してください。

### 8.3. The Migration Immutability Protocol
*   **Law**: 一度コミット・適用されたマイグレーションファイルのリネーム、変更、削除は**絶対禁止**です。
*   **Action**:
    *   **No Renaming**: 履歴の改竄は整合性エラーの元凶です。
    *   **Forward Only**: 修正は必ず「新しいマイグレーションファイルの追加」で行います。過去を修正しようとしてはいけません。
    *   **Timestamp Singularity**: マイグレーションID（タイムスタンプ）は一意でなければなりません。リモート環境と整合性が取れていない（名前変更などによる）状態でのデプロイは禁止します。

### 8.4. The Dead Code Elimination Protocol (Debt Bankruptcy)
*   **Law**: 「一応残しておく」というコメントアウトや未使用コードは、技術的負債ではなく「ゴミ」です。
*   **Action**:
    *   **No Mercy**: 不要になったコードは即座に物理削除してください。Git履歴があれば復元可能です。コード上に墓標を残さないでください。
    *   **The Ghost Feature Ban**: ユーザー導線が存在しない機能（公開されていない管理画面コード等）は負債です。YAGNI原則に従い、物理削除してください。
    *   **No Backup Files**: `.bak`, `.old`, `_copy` などのバックアップファイルをGit管理下に置くことを禁止します。バックアップはGitの履歴そのものです。`ls` した際、本番で使用されるファイル以外が存在してはなりません。
    *   **The Anti-Overwrite Protocol (Anti-Haribote & Surgical Precision)**:
        *   **Supreme Law (Rule 0.-1: The Anti-Overwrite Protocol)**: 既存のファイルを「全て上書き（Full Overwrite）」する行為は、いかなる理由があっても**破壊行為**とみなし禁止します。
        *   **Law 2 (Surgical Precision)**: 修正は「外科手術」のように、問題箇所のみをピンポイントで変更します。必ず差分を明示し、ユーザーが変更内容を100%把握できるようにしてください。
        *   **Law 3 (Anti-Blindness Protocol)**: ソースコードを出力する際、`// ... (imports remain)` のような省略記法を混入させてはなりません。これはユーザー画面に「意図しない文字列」として表示される、ユーザーからの信頼を失墜させる「最大の恥 (Greatest Shame)」です。全文を出力するか、正確な置換ツールを使用してください。

### 8.5. The Regression Ban Protocol (Rule 100.0)
*   **Law**: 一度発生・修正されたバグの再発（Regression）は、エンジニアリングにおける「最大の失態」である。
*   **Action**: 
    1. **Recurrence Punitive Measure**: バグを修正する際は、必ず「なぜ起きたか（Root Cause）」に加え、「どう仕組みで防ぐか（Prevention Loop）」を言語化せよ。
    2. **Visibility**: UI/UXの修正後は、必ず実機スクリーンショットまたは動画（Screen Recording）によって修正を確認・記録せよ。「見たつもり」での完了報告は虚偽報告とみなす。
    3. **Zero Recurrence**: 同様のバグが再発した場合、それは「個人のミス」ではなく「システムの不備（憲法違反）」として扱い、プロジェクト全体のガードレール（Linter, Test, CI）を即座に硬化させよ。

### 8.6. The Branch Hygiene Protocol (Clean Up After Yourself - Rule 99.2)
*   **Law**: 作業ブランチを放置することは環境差異による事故の元です。「マージされたら削除」はエンジニアの呼吸です。
*   **Action**:
    *   **Before Final Notify**: タスク完了報告（Final Notify）の直前に、必ず `git branch --merged` を確認し、マージ済みの作業ブランチを自動的に削除してください。
    *   **Clean**: リモートブランチはGitHub側で自動削除させますが、ローカルには死骸を残さないようにします。「作りっぱなし」はエンジニアとして恥ずべき行為です。
