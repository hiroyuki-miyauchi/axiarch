# 00. Core Philosophy & Mindset
## 7. Development & Operations Iron Rules
*   **Latest Info**: Always check the latest official docs for libs, OS, APIs every development session. Old knowledge is a sin.
*   **Real Device Test**: Test on real devices (smartphones), not just simulators. Use TestFlight for beta testing.
*   Maps and video embeds use dedicated fields (address input, YouTube ID input), NOT raw iframe paste. Frontend generates tags safely.
*   **The Explicit Explanation Protocol (No Expert Bias)**:
    *   **Law**: Developer "common sense" (Input Price, CPM, MRR, etc.) is "mysterious symbols" to users. Lacking explanations is tool failure.
    *   **Action**: All technical terms, metrics, and calculated values on admin screens MUST have `Info` icons and `Tooltips` explaining "what it is, how it's calculated, how it affects business" in layman's terms.
    *   **Zero Jargon**: Prohibit assuming "it's obvious." All numbers and states need clear definitions and help.
*   **Code Input Standard**:
    *   **Law**: Using raw `textarea` for HTML/CSS/JSON code editing is strictly prohibited—lack of syntax highlighting invites errors and degrades quality.
    *   **Action**: Use editor components like `react-simple-code-editor` (+ `prismjs`) for professional quality. Raw `Textarea` use is considered incomplete.
*   **The Sortable Table Standard**:
    *   **Law**: Admin list tables (users, products, logs) that "cannot sort" are incomplete tools.
    *   **Action**: Use `SortableTableHead` component and implement server-side sorting (`sortBy`, `sortOrder`) via header click as standard.
*   **Cleanup**: Delete unused code, comments, and files immediately. Leave no trash.
*   **The Architectural Preservation Protocol (Code Sanctuary)**:
    *   **Context**: Prevent accidental deletion (Friendly Fire) of core features by auto-refactoring or cleanup tasks.
    *   **Action**: Files constituting core features MUST have `@preservation_level CRITICAL` header at the top.
    *   **Prohibition**: AI must NOT autonomously delete, move, or destructively change marked files. If changes are needed, ask "May I change this file?" and get explicit approval.
    *   **Document Asset Protection**: Document assets such as project lessons logs, specifications (Blueprints), and rule definition files are protected from "physical deletion" or "excessive summarization causing information loss" under the guise of organization or consolidation. Changes MUST be made only via "Append" or "Amend"—preserving existing knowledge and lessons is mandatory.

*   **Proactive Proposal**: Never passive. Always propose the "Next Move".
*   **Context Guardian**: Remember all history and point out contradictions.
*   **Owner Health**: Protect the owner's health. Propose rest when overworked.
*   **The Zero Yapping Protocol (Professionalism)**:
*   **Law**: AI must eliminate all unnecessary preambles ("I apologize", "I understand", "Here is the code")—output results immediately. Reduce overall response volume and present only the essence.

*   **Day 1 Philosophy**: Every day is startup day one. Never rest on success.
*   **Radical Candor**: Care personally, challenge directly.
*   **Keeper Test**: "Would I fight to keep this?" If no, delete it.
*   **Working Backwards**: Start from the customer press release.
*   **System Transparency Protocol (Tech Stack Sync)**:
*   **Law**: If tech configuration becomes a black box, shared understanding with non-engineers (executives, operators) diverges and leads to wrong decisions.
*   **Action**: When tech stack changes (DB config change, new AI model, major library added, etc.), immediately update the admin dashboard (`tech-stack-card.tsx` etc.) to fully synchronize with reality.
*   **Purpose**: Content should not be "for engineers" but written in words non-engineers can understand—"What purpose does this serve."
