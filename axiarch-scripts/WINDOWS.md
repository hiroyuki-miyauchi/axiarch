# Windowsでの利用 / Using Axiarch on Windows

## 日本語

Axiarchの規則文書と、保存・導入・更新・フックの補助スクリプトは対応範囲が異なります。規則の正本は `AXIARCH.md` です。Windows版のAI製品が動くことだけで、Axiarchの補助スクリプトも動くとは判定しません。

| 実行環境 | 現在の扱い |
|---|---|
| Windows上のWSL 2、Linux Python/Bash/Git、Linux側ファイルシステム | Windows CIでスクリプト全回帰を検査する構成 |
| PowerShell/CMDのWindows版Python | 補助スクリプトは非対応。POSIXのロック・ファイルAPIが必要 |
| Git BashからWindows版Pythonを実行 | 非対応。Bashを追加してもPythonのPOSIX APIは追加されない |
| WSL 1、Windows側のPython/GitをWSLから呼ぶ構成、Windowsドライブや共有フォルダ上の記録 | 検証・保証の対象外。WSL 2のLinux側へ揃える |
| Windowsネイティブの各製品で規則文書を参照 | 文書は参照可能。フック・記録・全工程の動作実証を意味しない |

### 準備と確認

1. [Microsoftの手順](https://learn.microsoft.com/en-us/windows/wsl/install)でWSL 2を準備します。OS機能の有効化や再起動は利用者・管理者が判断します。Axiarchの導入処理はPC設定を変更しません。PowerShellの `wsl --list --verbose` で対象ディストリビューションのVERSIONが2か確認します。
2. WSLのLinux側にプロジェクトとBash、Python 3、Gitを用意します。Linux側のホーム以下を使い、Windows側のGitやPythonを混在させません。`/mnt/c` は既定の例で、マウント位置は変更できるため固定パスとして仮定しません。[Microsoftのファイル配置の説明](https://learn.microsoft.com/en-us/windows/wsl/filesystems)を参照してください。
3. WSL内のプロジェクトで次を実行します。

```bash
command -v bash python3 git
python3 -c 'import os,sys,fcntl; print(sys.executable, os.name); assert os.name == "posix"'
git --no-lazy-fetch --version
bash axiarch-scripts/check-axiarch-health.sh --phase structure
```

Gitの差分・追跡診断は `--no-lazy-fetch` に対応するGitを必要とします。古いUbuntuの標準Gitでは不足する場合があります。更新方法は [Git公式のLinux導入手順](https://git-scm.com/install/linux)を確認し、利用者が採用する配布元を判断してください。Git非管理の運用ではGit追跡検査は未確認となり、Gitの追加導入自体は必須ではありません。

新規導入はWSL内で、レビューしたソースの `init.sh` を `bash` で実行します。既存導入先には再インストールせず、`axiarch-scripts/axiarch-upgrade.sh --dry-run` で比較し、独自設定・仕様・記録を残して更新してください。詳細は `axiarch-scripts/README.md`。Windows Pythonでは初期導入・更新の起動処理と状態を扱うPython補助が `AXIARCH_PLATFORM_UNSUPPORTED`・終了2で停止します。シェル自体を実行できないPowerShell/CMDで `.sh` を直接呼んだ場合は、Axiarchの診断へ到達しないことがあります。

### エージェントの実行場所

- Codex：Windowsアプリの統合ターミナルとエージェント環境は別設定です。ターミナルをWSLへ変更するだけでは足りません。エージェントをWSLへ切り替えてアプリを再起動し、プロジェクトとフックが同じ環境を使うことを確認します。現在のCodexはWSL 1をサポートしません。[公式説明](https://learn.chatgpt.com/docs/windows/windows-app)
- Claude Code：WSL内へLinux版を導入し、WSL内から起動します。Windowsネイティブ版のGit Bash/PowerShell対応を、Axiarchの補助スクリプト対応と混同しません。[公式説明](https://code.claude.com/docs/en/setup)
- Antigravity：Windows版アプリ・CLIの提供と、Axiarchを組み合わせたWindows/WSLの実務検証は別です。採用する製品の実行先・ファイル参照先がWSLと一致するか個別に確認します。単にWindows側でWSLフォルダを開いても実行先が切り替わったとはみなしません。従来の実務実証をWindows版・WSL版・別のCLI製品へ拡張しません。[公式CLIの対応OS](https://antigravity.google/docs/cli/install/)

差分の事後検査は未対応環境を `DIFF GUARD UNASSESSED` と通知します。既存の `warn` は通知・終了0、`block` は停止要求・終了2、`off` は検査無効という方針を維持します。警告モードの終了0を差分確認成功とは扱いません。

認証情報や個人設定のWindows/WSL間コピー、フックの信頼確認の回避、WSLディストリビューションの自動変更は行いません。製品別の入口と更新時の信頼確認は `axiarch-scripts/AGENT_COMPATIBILITY.md` を参照してください。

### 改行・検査・移行の限界

Axiarch本体の `.gitattributes` は実行ファイルをLFに保ち、Windows GitのCRLF変換によるBashの誤動作を抑えます。この設定は本体専用で、利用先の `.gitattributes` を置換しません。WSLのプロジェクトはLinux Gitで管理します。Windows Gitも使う場合は、既存属性をレビューしてAxiarchの `.sh`・`.py` 等をLFに保つ設定を統合し、再度疎通を確認してください。既存ファイルを一括変換・削除して直したことにはしません。

CIはWindows Server 2025上のnative Python/Git Bashで非対応時の終了コード・対象無変更・UTF-8/LFを検査し、同じコミットをWSL 2 Ubuntu 24.04のLinuxファイルシステムへ取得して一般ユーザーで全回帰を実行します。セットアップ用ActionはSHA固定です。このジョブもPRとリリース前の共通qualityに含まれ、失敗を任意扱いで無視しません。

CI成功はそのランナーとスクリプトの範囲に限ります。Windows 10/11の全設定、ARM、全AI製品UI、認証済みモデル推論、フック信頼登録、NTFS/共有ディスク上の排他・権限、Windowsネイティブ実行を保証しません。healthも意味理解や全操作の安全性の証明ではありません。

## English

The canonical rules are in `AXIARCH.md`. Reading rules and running the installation, upgrade, record and hook helpers have different platform requirements. A product's Windows support does not establish compatibility of Axiarch's helpers.

| Environment | Current scope |
|---|---|
| WSL 2 on Windows with Linux Python/Bash/Git and the Linux filesystem | Configuration exercised by the Windows CI regression job |
| Native Windows Python in PowerShell/CMD, or Windows Python launched through Git Bash | Unsupported helper runtime; POSIX locking and file APIs are required |
| WSL 1, mixed Windows/Linux executables, Windows-drive or network-share records | Outside validation; keep the runtime and files together inside WSL 2 |
| Rules read by native Windows products | Document access does not establish hook, record or end-to-end operation |

### Setup and verification

Follow [Microsoft's WSL installation guide](https://learn.microsoft.com/en-us/windows/wsl/install) and check `wsl --list --verbose` from PowerShell. The chosen distribution must use version 2. Enabling OS features and restarting the PC remain user/administrator decisions; Axiarch does not change them.

Keep the project, Bash, Python 3 and Git inside the Linux environment. Prefer the Linux home filesystem and avoid mixing Windows executables. `/mnt/c` is only a default example, not a fixed mount location. See [Microsoft's filesystem guidance](https://learn.microsoft.com/en-us/windows/wsl/filesystems). Run the verification commands shown above from the project inside WSL.

Git-based diagnostics require `git --no-lazy-fetch --version` to succeed. An older distribution package may not provide this capability. Consult [Git's Linux installation instructions](https://git-scm.com/install/linux) and review any package-source change yourself. Git remains optional outside Git-managed projects; tracking is then unverified.

For a new installation, review and execute `init.sh` using Bash inside WSL. For existing adopters, preview `axiarch-scripts/axiarch-upgrade.sh --dry-run` and preserve local settings, specifications and records; see `axiarch-scripts/README.md`. On Windows Python, installation/upgrade launchers and state-dependent Python helpers stop with `AXIARCH_PLATFORM_UNSUPPORTED` and exit 2. Invoking a `.sh` file directly from a shell that cannot run it may fail before Axiarch can produce its diagnostic.

### Product environment

- Codex: the integrated terminal and agent environment are independent. Select the WSL agent environment and restart the app; merely selecting a WSL terminal does not switch the agent. Verify that the project and hooks use the same environment. Current Codex does not support WSL 1. See the [official Windows guide](https://learn.chatgpt.com/docs/windows/windows-app).
- Claude Code: install its Linux version inside WSL and launch it there. Native Git Bash/PowerShell support does not supply Axiarch's POSIX requirements. See [official setup](https://code.claude.com/docs/en/setup).
- Antigravity: native Windows app/CLI availability is separate from Axiarch validation on Windows/WSL. Verify the actual product's execution and file locations. Opening a WSL folder from Windows alone does not change the execution environment. Prior practical validation is not extended to Windows, WSL or a different CLI product. See the [CLI platform documentation](https://antigravity.google/docs/cli/install/).

The post-edit diff observer reports unsupported runtimes as `DIFF GUARD UNASSESSED`. It retains the configured policy: `warn` notifies and exits 0, `block` requests a pause and exits 2, and `off` disables observation. Exit 0 in warning mode is not a successful diff assessment.

Do not automatically copy credentials/personal settings between Windows and WSL, bypass hook trust or change distributions. Entrypoints and trust checks are documented in `axiarch-scripts/AGENT_COMPATIBILITY.md`.

### Line endings and validation boundaries

The source repository's `.gitattributes` keeps executable source in LF format. It is source-only and does not replace adopter attributes. Use Linux Git for WSL projects. If Windows Git is also used, review and merge appropriate LF rules for Axiarch's scripts into existing attributes, then verify the combination separately. Do not mass-convert or delete existing files as an implicit repair.

The Windows Server 2025 CI job checks native Python/Git Bash rejection, unchanged targets and UTF-8/LF source, then checks out the same commit into the WSL 2 Ubuntu 24.04 Linux filesystem and runs all regressions as a non-root user. The setup action is pinned to a commit SHA. This job is part of the shared PR/pre-release quality gate, with no ignored failure.

Success is limited to that runner and the exercised scripts. It does not validate every Windows 10/11 configuration, ARM, product UI, authenticated model reasoning, hook trust, NTFS/network filesystem locking and permissions, or native Windows operation. Health is not proof of semantic understanding or all-operation safety.
