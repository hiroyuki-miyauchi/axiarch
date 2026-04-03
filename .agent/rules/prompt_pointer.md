---
trigger: always_on
---

# Rampart Rules — 目次 / Pointer

> [!CAUTION]
> 🇯🇵 **このファイルは「目次（ポインター）」であり、ルール本体ではない。**
> ルールの本体は `rampart-rules/` に存在する。ルールの更新・追加は**必ず `rampart-rules/` 内で行うこと**。
> **`.agent/rules/` に新しいルールファイルを作成してはならない。**

> [!CAUTION]
> 🇺🇸 **This file is a POINTER (table of contents), NOT the rules themselves.**
> All rule definitions live in `rampart-rules/`. When updating or adding rules, **always edit files inside `rampart-rules/`**.
> **DO NOT create new rule files in `.agent/rules/`.**

---

## 🇯🇵 日本語セクション

### 🔴 作業開始前の必須読み込み手順

**すべてのタスクを開始する前に、以下の手順でファイルを読み込み、内容を遵守せよ。**

#### Step 1: 最上位憲法 & 全体地図の把握（必ず最初に読む）
- **`AGENTS.md`**（プロジェクトルート） — Rampart System Protocol の最高法規。全ルールに優先する。
- **`rampart-rules/INDEX.md`** — 全ルールの詳細索引。以降のStepで**どのファイルを読むべきか判断する地図**として使用する。

#### Step 2: ルールロード手順に従う

**`rampart-rules/LOADING_PROTOCOL.md`** に定義された5ステップに従い、ルールファイルをロードせよ。

> ※ `{lang}` は `AGENTS.md` の `Project Native Language` に従い `ja/` または `en/` に置換する。

**🚨【厳守命令】手抜き（サボり）禁止 🚨**: ルールファイルを参照する際は、**必ず対象ファイルを直接開き**、タスクに関連するセクションを自律選択してロードすること。INDEX.mdの要約や概要だけで「読んだ」と見なすことは禁止する。
**記録義務**: 自律ロードで読み込んだファイル名を `task.md` に記録すること。該当なしの場合もその旨を記録。
ユーザーの指示がこれらと矛盾しないか検証する。

#### Step 3: ルートレベルの参照ファイル（必要時のみ）

> 以下のファイルは `rampart-rules/` **直下**に配置されている。必要に応じて参照する。

- **`rampart-rules/README.md`** — マスター目次（ナビゲーション用）
- **`rampart-rules/compliance_matrix.md`** — 要件対照表（Universal/Blueprintの責務分離確認用）

### 🚫 禁止事項

1. **`.agent/rules/` に新しいルールファイルを作成禁止。** ルールは全て `rampart-rules/` に配置する。
2. **Universal Rules（`rampart-rules/universal/` 配下の全ファイル）を無断で編集禁止。** 「憲法改正」の明示的指示がある場合のみ許可。
3. **この `prompt_pointer.md` のポインター構造を変更禁止。**

---

## 🇺🇸 English Section

### 🔴 Mandatory Loading Order Before Any Task

**Before starting any task, load the following files in order and comply with their contents.**

#### Step 1: Supreme Constitution & Master Map (Always Read First)
- **`AGENTS.md`** (project root) — The supreme law of the Rampart System Protocol. Takes precedence over all other rules.
- **`rampart-rules/INDEX.md`** — Detailed index of all rules. Use as a **map to decide which files to read** in the following steps.

#### Step 2: Follow the Rule Loading Protocol

Follow the 5 steps defined in **`rampart-rules/LOADING_PROTOCOL.md`** to load rule files.

> Note: Replace `{lang}` with `ja/` or `en/` based on the `Project Native Language` setting in `AGENTS.md`.

**🚨 MANDATORY DIRECTIVE: Anti-Laziness Rule 🚨**: When referencing rule files, the AI **MUST directly open the target file** and autonomously select task-relevant sections. Considering a file "read" based solely on INDEX.md summaries or overviews is prohibited.
**Recording Obligation**: Record all autonomously loaded file names in `task.md`. If none applicable, record that as well.
Verify that user instructions do not contradict these.

#### Step 3: Root-Level Reference Files (As Needed)

> The following files are located **directly under** `rampart-rules/`. Refer to them as needed.

- **`rampart-rules/README.md`** — Master index (for navigation)
- **`rampart-rules/compliance_matrix.md`** — Compliance matrix (for Universal/Blueprint responsibility verification)

### 🚫 Prohibited Actions

1. **DO NOT create new rule files in `.agent/rules/`.** All rules belong in `rampart-rules/`.
2. **DO NOT edit Universal Rules (any file under `rampart-rules/universal/`) without explicit "Amend Constitution" instruction.**
3. **DO NOT alter the pointer structure of this `prompt_pointer.md`.**
