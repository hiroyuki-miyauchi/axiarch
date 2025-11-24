# 90. Advanced Operations (Legal, FinOps & AI Ethics)

## 1. FinOps (Cloud Cost Optimization)
*   **Cost Awareness**:
    *   Cash is oxygen for startups. Wasted cloud resources mean "Death."
*   **Alerting & Quotas**:
    *   Always set GCP Budget Alerts (50%, 90%, 100%).
    *   Set quotas (limits) on Firestore read/write counts and Cloud Functions execution time to prevent billing accidents due to infinite loops.
# 90. Advanced Ops & Legal

## 1. Legal & Compliance
*   **Terms & Privacy**:
    *   Must be accessible from the app settings.
    *   **Updates**: Notify users when terms change.
*   **AI Disclaimer**:
    *   Explicitly state that "AI may generate incorrect information" to mitigate liability for hallucinations.

## 2. FinOps (Cost Management)
*   **Budget Alerts**:
    *   Set budget alerts in GCP/Firebase to detect cost spikes (e.g., DDOS, infinite loops) immediately.
*   **Resource Cleanup**:
    *   Delete unused resources (old buckets, unattached IPs) regularly.

## 3. AI Ethics
*   **Bias Check**:
    *   Regularly check if AI outputs are biased against specific groups.
*   **Transparency**:
    *   Clearly indicate when a user is interacting with an AI, not a human.Disclosure).
