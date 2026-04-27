# Hot Towel — Items Awaiting John Horton's Input

_Extracted from the AEJ Micro Revision Response Tracker. These are the open items where John's institutional/empirical knowledge is needed before we can resolve them._

Prepared: 2026-04-27

---

## 1. Wage determination — is "no bargaining" realistic? (Editor's letter, additional comments)

**Editor's question:** "You assume the firm pays the demanded wage. Is this realistic for your application — i.e., is there truly no wage bargaining? Could it occur outside the platform? How would this affect your analysis?"

**What we need from John:**
- Institutional knowledge of how wages are actually set on the platform: is the worker's posted wage demand effectively final, or do firms counter?
- Whether off-platform bargaining is plausible (e.g., follow-up communication once a worker is shortlisted).
- A few sentences we can put in the response letter — and possibly a footnote in the model interpretation — defending the worker-TIOLI assumption.

**Where in the paper:** Response letter item; also affects how we describe the wage-posting protocol in the model section.

**Internal tracking:** GitHub Issue #5 (open, pinged @johnjosephhorton).

---

## 2. "The survey" reference on p.18 (R1)

**R1's comment:** "At the top of p.18, I wasn't able to tell what 'survey' you are referring to. Can you clarify?"

**What we need from John:** The paragraph in the Empirical Context section (Section IV.A), in the discussion of whether workers and firms multi-home across platforms, references "the survey" twice without naming the source. We need John to tell us:
- Which survey is being referenced?
- Is it a published source we can cite, or internal platform survey data?
- Exact wording / citation we should add.

**Where in the paper:** Empirical Context (Section IV.A), multi-homing paragraph. Note: this paragraph also sits right after the new Roth (2018) "market vs. marketplace" rewrite, so the survey reference is now adjacent to fresh prose — worth a quick read of the surrounding context.

**Internal tracking:** GitHub Issue #6 item 2 (open).

---

## 3. "-Y% decrease" phrasing in the empirical section (R2)

**R2's comment:** "Avoid '-Y% decrease' phrasing; use 'Y% decrease.'"

**What we need from John:** The "-Y% decrease" wording shows up because some of the auto-generated LaTeX macros from the R analysis pipeline emit negative numbers, and those flow straight into sentences like "a -12% decrease." Cleanest fix is in the R scripts — wrap the relevant values in `abs()` so the minus sign does not propagate to the paper.

- Can John (or someone on his side) sweep the R scripts that produce the percentage-change macros and apply `abs()` where the surrounding sentence already says "decrease" / "decline"?
- Alternatively, hand off a list of which macros need fixing and Peyman can patch them.

**Where in the paper:** Various places in the empirical section reporting percentage declines.

**Internal tracking:** GitHub Issue #9 (open, pinged @johnjosephhorton).

---

## 4. Surplus vs. wages — do we have outside-options data? (R2, p.34)

**R2's comment:** "On p.34, the authors describe expected wages. If data on outside options exist, it may be more relevant to study surplus rather than wages (though this is minor)."

**What we need from John:**
- Do we have outside-options data on the relevant workers (e.g., earnings on other platforms, reservation wages from survey, etc.)?
- If yes, is it usable at the scale of our experiment, or too thin?
- If no, we can decline the suggestion in the response letter — R2 explicitly flagged it as minor.

This is a "yes/no, and if yes how much work" question — we are not committing to running the surplus regressions today, just trying to size whether it is feasible at all.

**Where in the paper:** Section VI (discussion).

**Internal tracking:** Deferred to response letter.

---

## 5. Pooling-consistency audit across Figure 1, Figure 4, and Section V.E (R2 §2b)

**R2's comment:** "The choice to pool the sample is not always consistent: it is done after Figure 1, except in Figure 4, and again in Section V.E. A brief clarification would help."

**What we need from John:** Once PK settles the framing call on truth-telling (R2 §2c, see the tracker), the rule for pooling vs. not-pooling needs to be applied uniformly. The audit step is empirical and best done by John, who ran the pipeline:
- Confirm what each of Figure 1 (pooled), Figure 4 (not pooled), and Section V.E (pooled) currently does and why.
- Flag whether the inconsistency is a deliberate empirical choice (e.g., sample-size or identification reasons specific to Figure 4) or just an oversight from earlier drafts.
- Once the rule is fixed, re-run any specifications that need to change.

This item is gated on PK's framing call, but the audit work itself is John's. Worth flagging in the meeting so John knows it's coming and can think about it now.

**Where in the paper:** Figures 1 and 4 and Section V.E.

**Internal tracking:** GitHub Issue #4 §2b (open, waiting on PK §2c + John audit).

---

## Summary — what to walk out of the meeting with

| # | Item | Minimum we need |
|---|------|-----------------|
| 1 | Wage bargaining realism | A few sentences for the response letter on how wages are set on the platform |
| 2 | "The survey" on p.18 | Source name / citation |
| 3 | "-Y% decrease" macro fix | Either John fixes the R scripts or hands Peyman the macro list |
| 4 | Outside-options / surplus | Yes/no on whether we have the data |
| 5 | Pooling audit (Fig 1 / Fig 4 / §V.E) | John's read on whether the inconsistency is deliberate; commitment to re-run once PK settles framing |
