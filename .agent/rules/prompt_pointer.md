# Antigravity Rules — Pointer / 目次

> [!CAUTION]
> 🇯🇵 **このファイルは「目次（ポインター）」であり、ルール本体ではない。**
> ルールの本体は `antigravity-rules/` に存在する。ルールの更新・追加は**必ず `antigravity-rules/` 内で行うこと**。
> **`.agent/rules/` に新しいルールファイルを作成してはならない。**

> [!CAUTION]
> 🇺🇸 **This file is a POINTER (table of contents), NOT the rules themselves.**
> All rule definitions live in `antigravity-rules/`. When updating or adding rules, **always edit files inside `antigravity-rules/`**.
> **DO NOT create new rule files in `.agent/rules/`.**

---

## 🇯🇵 日本語セクション

### 🔴 作業開始前の必須読み込み手順

**すべてのタスクを開始する前に、以下の順序でファイルを読み込み、内容を遵守せよ。**

#### Step 1: 最上位憲法 & 全体地図の把握（必ず最初に読む）
- **`GEMINI.md`**（プロジェクトルート）
  - Antigravity System Protocol の最高法規。全ルールに優先する。
- **`antigravity-rules/INDEX.md`** — 全ルールの詳細索引
  - 全ルールファイルの概要を把握し、以降のStepで**どのファイルを読むべきか判断する地図**として使用する。

#### Step 2: 必須ルール（どんなタスクでも毎回必ず読む）

> [!IMPORTANT]
> 以下のファイルはタスクの種類に関わらず**毎回必ず読み込むこと。**
> これらは全タスクに横断的に適用される最重要ルールである。

- **`antigravity-rules/universal/{lang}/00_core_mindset.md`** — 全ルールの基盤・最上位行動原則
- **`antigravity-rules/universal/{lang}/60_security_privacy.md`** — セキュリティ・プライバシー（横断的関心事）
- **`antigravity-rules/blueprint/{lang}/01_project_lessons_log.md`** — プロジェクト教訓ログ（最優先適用）

> ※ `{lang}` は `GEMINI.md` の `Project Native Language` に従い `ja/` または `en/` に置換する。

#### Step 3: タスク関連ルールの選択的読み込み

> [!IMPORTANT]
> **全ファイルを無差別に読み込む必要はない。**
> Step 1 で把握した `INDEX.md` の情報に基づき、**「現在のタスクに関連するファイルのみ」**をツールを使って読み込むこと。

- **Universal Rules**（`antigravity-rules/universal/{lang}/`）
  - **不変** — 明示的に「憲法改正」を指示されない限り編集禁止。
  - Step 2 で読んだファイルを除き、タスクに関連するファイルをINDEXから選択して読む。
- **Blueprint Rules**（`antigravity-rules/blueprint/{lang}/`）
  - **可変** — プロジェクトのコンテキストに応じて作成・編集可能。
  - Step 2 で読んだファイルを除き、タスクに関連するファイルをINDEXから選択して読む。

> [!TIP]
> **クロスリファレンスに従うこと。** 読み込んだファイル内に「関連ルール」「参照」等のリンクがあれば、そのリンク先も追加で読み込むこと。これにより、見落としを防ぐ。

#### Step 4: ルートレベルの参照ファイル（必要時のみ）

> 以下のファイルは `antigravity-rules/` **直下**に配置されている。必要に応じて参照する。

- **`antigravity-rules/README.md`** — マスター目次（ナビゲーション用）
- **`antigravity-rules/compliance_matrix.md`** — 要件対照表（Universal/Blueprintの責務分離確認用）

### 🚫 禁止事項

1. **`.agent/rules/` に新しいルールファイルを作成禁止。** ルールは全て `antigravity-rules/` に配置する。
2. **Universal Rules を無断で編集禁止。** 「憲法改正」の明示的指示がある場合のみ許可。
3. **この `prompt_pointer.md` のポインター構造を変更禁止。**

---

## 🇺🇸 English Section

### 🔴 Mandatory Loading Order Before Any Task

**Before starting any task, load the following files in order and comply with their contents.**

#### Step 1: Supreme Constitution & Master Map (Always Read First)
- **`GEMINI.md`** (project root)
  - The supreme law of the Antigravity System Protocol. Takes precedence over all other rules.
- **`antigravity-rules/INDEX.md`** — Detailed index of all rules
  - Understand the overview of all rule files and use this as a **map to decide which files to read** in the following steps.

#### Step 2: Mandatory Rules (Always Read Regardless of Task)

> [!IMPORTANT]
> The following files MUST be read **every time, regardless of task type.**
> These are the most critical rules that apply across all tasks.

- **`antigravity-rules/universal/{lang}/00_core_mindset.md`** — Foundation of all rules, supreme behavioral principles
- **`antigravity-rules/universal/{lang}/60_security_privacy.md`** — Security & Privacy (cross-cutting concern)
- **`antigravity-rules/blueprint/{lang}/01_project_lessons_log.md`** — Project lessons log (highest priority)

> Note: Replace `{lang}` with `ja/` or `en/` based on the `Project Native Language` setting in `GEMINI.md`.

#### Step 3: Selective Loading of Task-Relevant Rules

> [!IMPORTANT]
> **DO NOT indiscriminately read all files.**
> Based on the `INDEX.md` reviewed in Step 1, **read only the files relevant to the current task** using your tools.

- **Universal Rules** (`antigravity-rules/universal/{lang}/`)
  - **Immutable** — DO NOT edit unless explicitly instructed to "Amend Constitution".
  - Excluding files already read in Step 2, select and read task-relevant files from the INDEX.
- **Blueprint Rules** (`antigravity-rules/blueprint/{lang}/`)
  - **Mutable** — Create and edit to define project-specific context.
  - Excluding files already read in Step 2, select and read task-relevant files from the INDEX.

> [!TIP]
> **Follow cross-references.** If a loaded file contains links labeled "Related Rules", "See Also", etc., load those linked files as well. This prevents oversight.

#### Step 4: Root-Level Reference Files (As Needed)

> The following files are located **directly under** `antigravity-rules/`. Refer to them as needed.

- **`antigravity-rules/README.md`** — Master index (for navigation)
- **`antigravity-rules/compliance_matrix.md`** — Compliance matrix (for Universal/Blueprint responsibility verification)

### 🚫 Prohibited Actions

1. **DO NOT create new rule files in `.agent/rules/`.** All rules belong in `antigravity-rules/`.
2. **DO NOT edit Universal Rules without explicit "Amend Constitution" instruction.**
3. **DO NOT alter the pointer structure of this `prompt_pointer.md`.**
