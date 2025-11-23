# 90. Advanced Operations (Legal, FinOps & AI Ethics)

## 1. FinOps (Cloud Cost Optimization)
*   **Cost Awareness**:
    *   Cash is oxygen for startups. Wasted cloud resources mean "Death."
*   **Alerting & Quotas**:
    *   Always set GCP Budget Alerts (50%, 90%, 100%).
    *   Set quotas (limits) on Firestore read/write counts and Cloud Functions execution time to prevent billing accidents due to infinite loops.
*   **Optimization**:
    *   Regularly analyze costs and delete unused resources (Zombie Instances).

## 2. Legal & Compliance (Legal View)
*   **IP & Licensing**:
    *   Strictly verify licenses of libraries used (MIT, Apache 2.0, etc.). Avoid GPL contamination.
    *   Ensure that Intellectual Property rights of generated code and assets belong to the company.
*   **Terms & Privacy**:
    *   Terms of Service (ToS) and Privacy Policy must be in place before release. Specifically include disclaimers regarding "AI Hallucinations."

## 3. AI Ethics & Governance
*   **Responsible AI**:
    *   Maximize filtering (Safety Settings) to ensure AI models do not generate discriminatory, violent, or inappropriate content.
    *   **Human in the Loop**: Always include a human verification process if AI decisions significantly affect user life or property.
*   **Transparency**:
    *   Clearly disclose to users that they are "interacting with AI" (Bot Disclosure).
