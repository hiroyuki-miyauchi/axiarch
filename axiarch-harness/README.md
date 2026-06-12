# Axiarch Execution Harness / Axiarch実行ハーネス

`axiarch-harness/` defines how an agent executes Axiarch work after it has loaded the canonical protocol in `AXIARCH.md`.

`axiarch-harness/` は、エージェントが `AXIARCH.md` の正本プロトコルをロードした後、Axiarch作業をどう実行するかを定義する。

This directory is the implementation unit for Harness Engineering. It turns Axiarch's rule model into concrete task levels, execution order, audit verdicts, role passes, evidence packets, human approval boundaries, and optional delegation.

このディレクトリはハーネスエンジニアリングの実装単位である。Axiarchのルールモデルを、具体的なタスクレベル、実行順序、監査Verdict、役割パス、証跡パケット、人間承認境界、任意の委任へ変換する。

This directory does not replace `axiarch-rules/`.
Universal and Blueprint remain the rule source of truth.
The harness is the operational workflow for planning, implementation, audit, evidence, approval, and optional subagent delegation.
Read-only subagent delegation is not a Human Approval Gate action by itself. When the user explicitly requests a named read-only workflow such as Deep Security Scan, the workflow's required read-only worker fanout is included in that request. If delegation is unavailable, do not claim the formal deep workflow ran; use the ordinary scan or main-agent sequential fallback.

このディレクトリは `axiarch-rules/` を置き換えない。
UniversalとBlueprintは引き続きルールの正本である。
harnessは、計画、実装、監査、証跡、承認、任意のサブエージェント委任を扱う実行ワークフローである。
読み取り専用のサブエージェント委任は、それ自体では Human Approval Gate 対象ではない。ユーザーが Deep Security Scan などの名前付き読み取り専用 workflow を明示した場合、必要な読み取り専用 worker fanout はその要求に含まれる。委任が利用できない場合は、正式な deep workflow を実行済みと主張せず、通常 scan またはメインエージェント順次 fallback を使う。

## Structure / 構成

```text
axiarch-harness/
 ├── README.md
 ├── ja/
 │   ├── EXECUTION_HARNESS_PROTOCOL.md
 │   ├── AUDIT_GATE_PROTOCOL.md
 │   ├── ROLE_PASS_PROTOCOL.md
 │   ├── EVIDENCE_PACKET_PROTOCOL.md
 │   ├── HUMAN_APPROVAL_GATE.md
 │   └── SUBAGENT_DELEGATION_PROTOCOL.md
 └── en/
     ├── EXECUTION_HARNESS_PROTOCOL.md
     ├── AUDIT_GATE_PROTOCOL.md
     ├── ROLE_PASS_PROTOCOL.md
     ├── EVIDENCE_PACKET_PROTOCOL.md
     ├── HUMAN_APPROVAL_GATE.md
     └── SUBAGENT_DELEGATION_PROTOCOL.md
```

## Usage / 使い方

### English

1. Read `AXIARCH.md`.
2. Resolve `{lang}` from Project Native Language.
3. Load the harness files required for the task level.
4. If subagents are unavailable, the main agent performs the same role passes sequentially.
5. If subagents are available, delegate only bounded work and keep final decisions with the main agent.
6. Do not stop for separate subagent permission when the requested workflow is read-only and already user-requested; stop only before approval-required actions.

### 日本語

1. `AXIARCH.md` を読む。
2. Project Native Languageから `{lang}` を解決する。
3. タスクレベルに必要なharnessファイルをロードする。
4. サブエージェントが使えない場合、メインエージェントが同じ役割パスを順番に実行する。
5. サブエージェントが使える場合、範囲を限定した作業だけを委任し、最終判断はメインエージェントに残す。
6. 読み取り専用かつユーザー要求済みの workflow では、別途サブエージェント許可を求めて停止しない。承認対象操作に移る場合だけ停止する。

## Protocol Map / プロトコル対応表

| File | English purpose | 日本語での用途 |
|:--|:--|:--|
| `EXECUTION_HARNESS_PROTOCOL.md` | Task levels and lifecycle | タスクレベルと実行ライフサイクル |
| `AUDIT_GATE_PROTOCOL.md` | Audit verdicts and fix loop | 監査Verdictと修正ループ |
| `ROLE_PASS_PROTOCOL.md` | Planner, implementer, verifier, auditor, blueprint-drift, QA, docs, crystallizer, and release-safety passes | Planner、Implementer、Verifier、Auditor、Blueprint Drift、QA、Docs、Crystallizer、Release Safetyの役割パス |
| `EVIDENCE_PACKET_PROTOCOL.md` | Required closeout evidence, loaded rules, verification, approval status, and crystallization result | 完了時証跡、ロード済みルール、検証、承認状態、結晶化結果 |
| `HUMAN_APPROVAL_GATE.md` | Actions that require explicit human approval | 明示的な人間承認が必要な操作 |
| `SUBAGENT_DELEGATION_PROTOCOL.md` | Optional subagent delegation, read-only delegation boundary, and fallback to main-agent sequential execution | 任意のサブエージェント委任、読み取り専用委任境界、メインエージェント順次実行フォールバック |
