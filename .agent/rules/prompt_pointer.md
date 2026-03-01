---
trigger: always_on
---

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

**すべてのタスクを開始する前に、以下の手順でファイルを読み込み、内容を遵守せよ。**

#### Step 1: 最上位憲法 & 全体地図の把握（必ず最初に読む）
- **`GEMINI.md`**（プロジェクトルート） — Antigravity System Protocol の最高法規。全ルールに優先する。
- **`antigravity-rules/INDEX.md`** — 全ルールの詳細索引。以降のStepで**どのファイルを読むべきか判断する地図**として使用する。

#### Step 2: 階級別スキャンとロード（AIが自律判断で選択・読み込み）

ルールディレクトリをスキャンし、以下の2階級に分類して自律的にロードせよ。

**Class S（Universal / 不変の法則・Read-Only）:**
- **対象**: `antigravity-rules/universal/{lang}/` 内のファイル
- **性質**: プロジェクトを超えた普遍的ルール。編集禁止（「憲法改正」の明示的指示がある場合のみ許可）。
- **ロード方式**: タスクの種類に応じて関連するファイルをAIが自律判断で選択しロードする。

**Class A（Blueprint / プロジェクト固有・更新対象）:**
- **対象**: `antigravity-rules/blueprint/{lang}/` 内のファイル
- **性質**: プロジェクト固有の仕様・設計・教訓。監査結果に基づき更新可能。
- **ロード方式**: タスクに関連するファイルを自律選択してロードする。`01_project_lessons_log.md`（教訓ログ）は優先度が高い。

> ※ `{lang}` は `GEMINI.md` の `Project Native Language` に従い `ja/` または `en/` に置換する。

**原則**: 全ファイルを毎回読む必要はない。INDEXとディレクトリ構造から、現在のタスクに必要なルールだけを自律判断で選択すること。

**選択の指針（例）:**
- 技術スタック把握: Blueprint `00_project_overview.md` と `blueprint/{lang}/INDEX.md` を読み、プロジェクトの技術スタックとBlueprint全体像を把握。技術スタックに対応するUniversalファイルを自律選択（例：Next.js→`33_web_frontend`, Supabase→`37_backend_supabase`）。Blueprint側もタスクに関連するファイルを自律選択。
- セキュリティ関連タスク → `60_security_privacy`, `61_legal_data_privacy`
- UI/デザインタスク → `20_design_ux`
- API設計タスク → `35_api_integration`, `30_engineering_general`

**クロスリファレンス**: 読み込んだファイル内に関連ルールへのリンクがあり、現在のタスクに関連する場合は、そのリンク先も追加で読むこと。
ユーザーの指示がこれらと矛盾しないか検証する。

#### Step 3: ルートレベルの参照ファイル（必要時のみ）

> 以下のファイルは `antigravity-rules/` **直下**に配置されている。必要に応じて参照する。

- **`antigravity-rules/README.md`** — マスター目次（ナビゲーション用）
- **`antigravity-rules/compliance_matrix.md`** — 要件対照表（Universal/Blueprintの責務分離確認用）

### 🚫 禁止事項

1. **`.agent/rules/` に新しいルールファイルを作成禁止。** ルールは全て `antigravity-rules/` に配置する。
2. **Universal Rules（`antigravity-rules/universal/` 配下の全ファイル）を無断で編集禁止。** 「憲法改正」の明示的指示がある場合のみ許可。
3. **この `prompt_pointer.md` のポインター構造を変更禁止。**

---

## 🇺🇸 English Section

### 🔴 Mandatory Loading Order Before Any Task

**Before starting any task, load the following files in order and comply with their contents.**

#### Step 1: Supreme Constitution & Master Map (Always Read First)
- **`GEMINI.md`** (project root) — The supreme law of the Antigravity System Protocol. Takes precedence over all other rules.
- **`antigravity-rules/INDEX.md`** — Detailed index of all rules. Use as a **map to decide which files to read** in the following steps.

#### Step 2: Class-Based Scan & Load (AI Autonomously Selects & Loads)

Scan the rules directory and classify into 2 classes, then autonomously load relevant files.

**Class S (Universal / Immutable / Read-Only):**
- **Target**: Files in `antigravity-rules/universal/{lang}/`
- **Nature**: Universal rules that transcend projects. Editing prohibited (only allowed with explicit "Amend Constitution" instruction).
- **Loading**: AI autonomously selects and loads files relevant to the current task.

**Class A (Blueprint / Project-Specific / Mutable):**
- **Target**: Files in `antigravity-rules/blueprint/{lang}/`
- **Nature**: Project-specific specs, design, and lessons. Can be updated based on audit results.
- **Loading**: AI autonomously selects task-relevant files. `01_project_lessons_log.md` (lessons log) has high priority.

> Note: Replace `{lang}` with `ja/` or `en/` based on the `Project Native Language` setting in `GEMINI.md`.

**Principle**: Do NOT load all files every time. Based on INDEX and directory structure, autonomously select only the rules needed for the current task.

**Selection Guide (examples):**
- Tech stack: Read Blueprint `00_project_overview.md` and `blueprint/{lang}/INDEX.md` to understand the project's tech stack and Blueprint full picture. Autonomously select corresponding Universal files (e.g., Next.js→`33_web_frontend`, Supabase→`37_backend_supabase`). Also autonomously select task-relevant Blueprint files.
- Security tasks → `60_security_privacy`, `61_legal_data_privacy`
- UI/Design tasks → `20_design_ux`
- API design tasks → `35_api_integration`, `30_engineering_general`

**Cross-references**: If a loaded file references related rules and they are relevant to the current task, load those as well.
Verify that user instructions do not contradict these.

#### Step 3: Root-Level Reference Files (As Needed)

> The following files are located **directly under** `antigravity-rules/`. Refer to them as needed.

- **`antigravity-rules/README.md`** — Master index (for navigation)
- **`antigravity-rules/compliance_matrix.md`** — Compliance matrix (for Universal/Blueprint responsibility verification)

### 🚫 Prohibited Actions

1. **DO NOT create new rule files in `.agent/rules/`.** All rules belong in `antigravity-rules/`.
2. **DO NOT edit Universal Rules (any file under `antigravity-rules/universal/`) without explicit "Amend Constitution" instruction.**
3. **DO NOT alter the pointer structure of this `prompt_pointer.md`.**
