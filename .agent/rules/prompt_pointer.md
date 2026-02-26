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

#### Step 1: 最上位憲法
- **`GEMINI.md`**（プロジェクトルート）
  - Antigravity System Protocol の最高法規。全ルールに優先する。

#### Step 2: Universal Rules（不変ルール）
- **`antigravity-rules/universal/`** 配下の全ファイル
  - **不変** — 明示的に「憲法改正」を指示されない限り編集禁止。
  - `GEMINI.md` の `Project Native Language` に従い、該当する言語フォルダ（`ja/` or `en/`）を参照する。

#### Step 3: Blueprint Rules（プロジェクト固有仕様）
- **`antigravity-rules/blueprint/`** 配下のファイル
  - **可変** — プロジェクトのコンテキストに応じて作成・編集可能。
  - 特に **`01_project_lessons_log.md`**（教訓ログ）を最優先で適用する。

#### Step 4〜6: ルートレベルの参照ファイル

> 以下3ファイルは `antigravity-rules/` **直下**に配置されている（`universal/` や `blueprint/` の中ではない）。

- **`antigravity-rules/README.md`** — マスター目次
  - 全ルールモジュールへのリンク集。ルール間のナビゲーションに使用する。
- **`antigravity-rules/compliance_matrix.md`** — 要件対照表
  - ユーザーの要望がどのルールファイルでカバーされているかを証明する対照表。
  - Universal（不変）と Blueprint（可変）の責務分離を明確にする。
- **`antigravity-rules/INDEX.md`** — 詳細索引
  - 全ルールファイルの概要説明を記載した詳細索引。各ファイルが何を規定しているかを把握する際に参照する。

### 🚫 禁止事項

1. **`.agent/rules/` に新しいルールファイルを作成禁止。** ルールは全て `antigravity-rules/` に配置する。
2. **Universal Rules を無断で編集禁止。** 「憲法改正」の明示的指示がある場合のみ許可。
3. **この `prompt_pointer.md` のポインター構造を変更禁止。**

---

## 🇺🇸 English Section

### 🔴 Mandatory Loading Order Before Any Task

**Before starting any task, load the following files in order and comply with their contents.**

#### Step 1: Supreme Constitution
- **`GEMINI.md`** (project root)
  - The supreme law of the Antigravity System Protocol. Takes precedence over all other rules.

#### Step 2: Universal Rules (Immutable)
- **`antigravity-rules/universal/`** — all files under this directory
  - **Immutable** — DO NOT edit unless explicitly instructed to "Amend Constitution".
  - Refer to the language folder (`ja/` or `en/`) matching the `Project Native Language` setting in `GEMINI.md`.

#### Step 3: Blueprint Rules (Project-Specific)
- **`antigravity-rules/blueprint/`** — files under this directory
  - **Mutable** — Create and edit to define project-specific context.
  - Prioritize **`01_project_lessons_log.md`** (Lessons Log) above all other blueprints.

#### Steps 4–6: Root-Level Reference Files

> The following 3 files are located **directly under** `antigravity-rules/` (NOT inside `universal/` or `blueprint/`).

- **`antigravity-rules/README.md`** — Master Index
  - Link collection to all rule modules. Use for navigation.
- **`antigravity-rules/compliance_matrix.md`** — Compliance Matrix
  - Proves which rule files cover each user requirement.
  - Clarifies the separation of responsibilities between Universal (immutable) and Blueprint (mutable).
- **`antigravity-rules/INDEX.md`** — Detailed Index
  - Detailed index with summaries for every rule file. Use to understand what each file governs.

### 🚫 Prohibited Actions

1. **DO NOT create new rule files in `.agent/rules/`.** All rules belong in `antigravity-rules/`.
2. **DO NOT edit Universal Rules without explicit "Amend Constitution" instruction.**
3. **DO NOT alter the pointer structure of this `prompt_pointer.md`.**
