# Hot Towel — AEJ Micro Revision Response Tracker

_Running document mapping every editor/referee comment to our revision status, where the fix lives in the paper, and the commit / issue reference. This markdown file is the primary working copy — edit it directly to add new responses or update existing ones._

**Status legend:** ✅ addressed / verified · 🟡 partially addressed (open items remain) · 🔴 open (awaiting coauthor input or further work) · 🟣 declined per referee's own suggestion.

---

## Revision TO Dos for

## “Sorting through Cheap Talk: Theory and Evidence from a Labor Market”

@ AEJ Micro

_John Horton			   Ramesh Johari			    Philipp Kircher_

Below is the text from the editor's letter and three referee reports.

## Editor’s Letter

Thank you for submitting this paper to the American Economic Journal: Microeconomics (AEJ Micro). Based on the advice of three referees and my own reading, I am inviting a revision for possible publication in AEJ Micro.

This is a very promising paper. It combines a theoretical model of cheap talk in labor markets with an impressively large and well-designed field experiment. The experiment is compelling and generates clear results: the cheap-talk device improves sorting, affects wages, and increases efficiency. The contribution is significant, and the paper has the potential to have impact. All three referees recommend that I invite a revision.

However, there are also concerns that need to be addressed before the paper can be published in AEJ Micro. In particular, the current presentation of the model is not clear enough for the journal’s readership; Referee 2 (whose report begins “This paper theoretically and experimentally…”) found this section especially difficult to follow, and I share that view. Referee 3 (“This is a great…”) also suggested that the framing of the paper should be sharpened considering subsequent developments in the literature.

### Key goals for the revision

#### 1. Model section

While the model is appropriate for your empirical setting, its exposition falls short. I agree with Referee 2 that mixing formal assumptions with intuition, and requiring the reader to toggle between multiple sections and appendices, is not up to AEJ Micro standards. Moreover, I could not find either your supplementary appendix or your online appendix with the submission, so it is impossible to assess the full model.

Please improve the presentation of the model and analysis, with the following points in mind:

a) Separate formalism from intuition. Present the formal model clearly and cleanly, and then provide the intuition. Readers should be able to distinguish formalism from commentary and understand the model on its own.

> ✅ **ADDRESSED**
> 
> **What:** Theory section fully restructured: body now contains only the formal model setup, FOCs, and comparative statics; exposition and intuition are presented in separated passages. All proofs, extensions, robustness, and second-signal machinery are in the appendix.
> 
> **Location:** §III.A–E (body); Appendices A (Proofs), B (Information Revelation), C (Model Extensions)
> 
> **Commit / Issue:** 9d8fcc6 (theory rewrite merge); c3a8cf4 (Corollary 2 proof relocation)

b) Trim defensive writing. Early passages hedge about generality and alternative modeling choices. These are distracting and sometimes confusing. Streamline for a crisp statement of the model.

> ✅ **ADDRESSED**
> 
> **What:** Defensive/hedging passages about generality and alternative modeling choices removed from the body. Alternative production-function discussion moved to Appendix C.
> 
> **Location:** §III body (cleaned); Appendix C
> 
> **Commit / Issue:** 9d8fcc6

c) Clarify definitions and logic. Define all terms precisely—e.g., what you mean by a “large market.” Introduce truthtelling before it appears in Proposition 1. Be transparent about the role of both signals (s_1, s_2). As Referee 2 noted, if s_2 is nearly perfectly revealing, the wage effects of cheap talk should vanish—yet you report non-trivial effects. Please reconcile this. Also clarify why s_1 is needed: is it to generate sorting without cheap talk? If so, perhaps exclude it from the baseline model.

> 🟡 **PARTIALLY ADDRESSED — open items remain**
> 
> **What:** ψ₂ paradox reconciled with a two-pronged response: (i) wage-mechanism clarification at end of §III.C explaining why wage effects on a worker-firm type pair survive the ψ₂→1 limit (pool locked by (m, s₁) before s₂); (ii) IC-based justification for 'almost precise, not perfectly precise' in §III.E / Appendix B.1. OPEN — precise definition of 'large market', truth-telling placement vs. Prop 1, clarification of u' boundedness, role of s₁ still awaiting PK/coauthor call (see Issue #1 residual checklist).
> 
> **Location:** §III.C tail paragraph; §III.E; Appendix B.1 (\label{online_app:imprecise_second_signal})
> 
> **Commit / Issue:** 1183eb0; 3f3b5c0; b74b7a0

d) Improve organization. Currently, to understand Proposition 1 a reader must consult the body, main appendix, and supplementary appendix. The graphical intuition in the main appendix is difficult to follow. The paper and main (“in-print”) appendix should together provide a self-contained sketch of the main results, deferring details to the supplementary appendix. (At AEJ Micro, there are only those two kinds of appendices.) You must still adhere to page-length guidelines.

> ✅ **ADDRESSED (structural)**
> 
> **What:** Body + main appendix reorganized to be self-contained for Proposition 1. Online Appendix renamed to 'Appendix' throughout (per AEJ Micro's in-print vs. supplementary distinction). Proofs ordered properly: No-mass-point lemma + proof in Appendix A, then Corollary 1, Corollary 2, Proposition 2 (no-talk), Proposition 1 (comparison). Supplementary Empirical Appendix kept separate.
> 
> **Location:** Appendices A/B/C + Supplementary Empirical Appendix
> 
> **Commit / Issue:** 207d38f (Online Appendix → Appendix sweep)

Overall, AEJ Micro publishes both top-field theoretical and theoretically grounded empirical papers. Models should have the clarity and precision expected by theorists but remain accessible to a broad microeconomics audience. Please revise your model section accordingly. I am not micromanaging at this stage, but I reserve the right to do so in the next round.

#### 2. Framing and literature positioning

Referee 3 emphasized improving the framing by connecting more directly to the literature. I concur. Please address their points 1–3. In addition, note that this paper—and perhaps others cited—also relates to work on credible communication in labor markets, including costly signaling models (see also point 5 below).

Besides these points, please incorporate any other referee suggestions you find helpful. While I am not mandating all of them, you should obviously fix typos, ambiguities, and similar issues, and consider Referee 2’s specific comments.

### Additional comments

- Wage determination. You assume the firm pays the demanded wage. Is this realistic for your application—i.e., is there truly no wage bargaining? Could it occur outside the platform? How would this affect your analysis?

> 🔴 **OPEN — John Horton**
> 
> **What:** Needs institutional knowledge of how wages are actually set on Upwork / whether bargaining occurs off-platform. Routed to coauthor.
> 
> **Location:** N/A (response letter item)
> 
> **Commit / Issue:** Issue #5 (open, pinged @johnjosephhorton)

- Truthtelling preferences. In the introduction you write, “lack of incentives makes truth-telling a focal point.” Is there evidence for that? You might cite literature on preferences for truth-telling even without incentives (e.g., Kartik 2009; Abeler et al. 2019). Such preferences could allow separation even where a pure cheap-talk model predicts pooling. How does this relate to your conditions for separation under pure cheap talk?

> 🟡 **PARTIALLY ADDRESSED — awaiting PK**
> 
> **What:** Kartik (2009) and Abeler et al. (2019) citations added to the bibliography. Issue #4 §2c open: the framing reconciliation between intro ('plausible behavioral assumption') and theory body ('imposed assumption justified by Prop 3') requires PK/Horton steer before committing.
> 
> **Location:** hot_towel.bib (refs added); framing decision pending
> 
> **Commit / Issue:** 207d38f (bib additions); Issue #4 §2c open

- Minor issues.

  - p.2: “Recent theory papers” — do you want to call a 2007 paper “recent”? Also, the mid-sentence reference to Horton (2010) is distracting; consider moving it. More broadly, I agree with Referee 2 that your connections to cited papers are often unclear.

> 🟡 **PARTIALLY ADDRESSED — one open item**
> 
> **What:** 'Recent theory papers' (p.2) softened to 'Existing theoretical work' (line 197); mid-sentence Horton (2010) reference removed from intro (line 201) — the paper is still cited properly at line 683 in §IV.A where the platform is described. OPEN: the broader 'connections to cited papers are often unclear' concern — the systemic fix requires PK's positioning paragraphs (Issue #3 framing), after which the intro and §II Literature can be rewritten to explicitly state each citation's relationship to our contribution.
> 
> **Location:** hot_towel.tex lines 197 and 201 (applied); intro + §II systemic cleanup pending
> 
> **Commit / Issue:** 589f185 (two narrow fixes); Issue #3 for broader cleanup

  - p.3: The phrase “persists from partial to full market roll-out” is unclear.

> ✅ **ADDRESSED**
> 
> **What:** Rewrote the 'persists from partial to full market roll-out' sentence as: 'our predictions hold whether cheap talk is introduced to a fraction of firms (as in our experimental variation) or to the entire market (as in the platform-wide roll-out that followed the experiment).'
> 
> **Location:** hot_towel.tex line 204
> 
> **Commit / Issue:** 5da3999

  - p.8: Second line of Section III: omit the repeated “salient.” Point (2) could be dropped—it is standard. The first part of point (3) could also be cut unless you wish to emphasize that wage demands are worker commitments; in that case, rephrase.

> 🔴 **OPEN — Issue #1 residual**
> 
> **What:** p.8 minor items (repeated 'salient'; standard point (2); rephrasing first part of point (3)) not yet touched. Held for PK's theory-body pass.
> 
> **Location:** §III.A body (top of theory section)
> 
> **Commit / Issue:** Issue #1 open

  - p.9: Clarify that a is a real (presumably nonnegative) number. Define subscript T on v_T when first introduced—it indexes job type. (Minor: consider lowercase t instead of uppercase T.) Using \delta for probability is nonstandard; consider p. When you write “in principle firms could have…,” are you stating the model allows it or only conceptually?

> 🟡 **PARTIALLY ADDRESSED — one open item**
> 
> **What:** Four of the five sub-items addressed in the Setup paragraph (§III.A, lines 266–272):
> 
> 1. Ability `a` now explicitly declared as a nonnegative real: "Workers have heterogeneous ability $a \in \mathbb{R}_{+}$".
> 2. Subscript `T` now introduced explicitly at first use: "differences across job types, indexed by the subscript $T$: a job of type $T$ has marginal valuation $v_T$ for workers' ability."
> 3. `\delta` replaced with `p` throughout the paper (14 subscripted occurrences swept: the probability of high types is now $p_H$, low types $p_L$). The one remaining `\delta` at line 1348 is kept as-is since it denotes a generic small positive real in a proof, not a probability.
> 4. "In principle firms could have…" wording clarified. New text makes the model-vs-reality distinction explicit: "In reality a firm may post several job openings, potentially of different types; in the model, however, we restrict attention to the case where each firm posts a single opening, and we use the words 'job' and 'firm' interchangeably throughout."
> 
> OPEN (minor): editor's parenthetical suggestion to use lowercase $t$ rather than uppercase $T$ — kept as uppercase per Peyman's call; deferred to PK for a final call.
> 
> **Location:** hot_towel.tex §III.A Setup (lines 266–272 for the main paragraph); manuscript-wide for the δ→p sweep.
> 
> **Commit / Issue:** this commit; Issue #1 open for the uppercase-vs-lowercase T decision

  - p.10: Workers care only about wages—so more difficult jobs don’t imply higher disutility?

> 🔴 **OPEN — Issue #1 residual**
> 
> **What:** p.10 'more difficult jobs and worker disutility' clarification not yet touched.
> 
> **Location:** §III.A setup
> 
> **Commit / Issue:** Issue #1 open

  - p.11: Clarify “large market.” Do you need all the citations in footnote 8, or would a summary suffice? Also, “can reject” might simply be “rejects.”

> 🔴 **OPEN — Issue #1 residual**
> 
> **What:** p.11 'large market' precise definition; footnote 8 citations trim; 'can reject'→'rejects'. 'Can reject'→'rejects' swept in typo pass; other two still pending.
> 
> **Location:** §III
> 
> **Commit / Issue:** 9c14d38 (partial — 'can reject' fix); Issue #1 residual

  - p.12: “Message off-equilibrium” → “message off the equilibrium path.” Footnote 11 lacks a right bracket. Be consistent in your use of “:=” for definitions.

> ✅ **ADDRESSED (typo items)**
> 
> **What:** 'message off-equilibrium'→'message off the equilibrium path'; footnote 11 bracket; ':=' consistency — all swept in manuscript-wide typo pass.
> 
> **Location:** §III
> 
> **Commit / Issue:** 9c14d38 (closes Issue #7)

  - p.13: What does “meaningful mass points” mean? The first sentence of Proposition 1 repeats what was just stated.

> ✅ **ADDRESSED**
> 
> **What:** 'Meaningful mass points' clarified; repetition in first sentence of Proposition 1 trimmed.
> 
> **Location:** §III (Proposition 1 walk-through)
> 
> **Commit / Issue:** 9c14d38

  - p.15: When you write “generically fails,” do you mean in a formal genericity sense?

> 🔴 **OPEN — Issue #1 residual**
> 
> **What:** 'Generically fails' formality not yet addressed.
> 
> **Location:** §III.E
> 
> **Commit / Issue:** Issue #1 open

  - Footnote 13: Using “L” and “H” but then “Medium” looks odd. Perhaps use “I” for intermediate.

> ✅ **ADDRESSED**
> 
> **What:** Footnote 13 'Medium' → 'I' (Intermediate) consistency applied in typo pass.
> 
> **Location:** §III
> 
> **Commit / Issue:** 9c14d38

While I cannot commit to publication, I am cautiously optimistic that a thorough revision will pay off. When resubmitting, please include a single PDF containing:

- detailed responses to each referee and to me,

- an outline of all changes made to the paper.

AEJ Micro allows 12 months for resubmission, though since this is mostly an expositional revision, I hope you can return it within about four months.

If anything in this letter requires clarification, feel free to reach out. Thank you again for submitting this interesting paper to AEJ Micro. I look forward to seeing your revision.

Sincerely,

Navin Kartik

Editor, American Economic Journal: Microeconomics

Resubmission Instructions

Log into http://mc.manuscriptcentral.com/aej-micro and enter your Author Center. Under “Manuscripts with Decisions,” click “Create a Revision.”

You cannot revise the original submission directly; instead, prepare a new PDF for upload.

All submissions must include a Disclosure Statement (see AEA Disclosure Policy), one per coauthor. State whether IRB approval was obtained.

AEJ Micro policy requires that authors provide all data, code, and documentation necessary for replication prior to publication.

Please delete redundant files before completing your resubmission. Revised manuscripts not submitted within a year may be treated as new submissions.


## R1 Report

This paper offers a theoretical model and field experiment in an online labor market, analyzing the sorting benefits of allowing job posters the ability to signal to workers their preference over hiring high-skilled workers at higher prices or low-skilled workers at lower prices (or an intermediate option).

In one arm of the experiment, job posters told the platform about these preferences but the preferences were not revealed to potential workers. In another arm, the preferences were revealed. In a final arm, the preferences were revealed with some probability.

The signal/preference statement constitutes cheap talk (they are costless, non-binding, and unverifiable), and the authors show in their theoretical model that it is possible for the signals to be useless in sorting workers and jobs (a babbling equilibrium). However, the authors demonstrate that, in cases where the value placed on quality by high-value job posters is sufficiently higher than that of low-value job posters, an informative, separating equilibrium exists that allows high-skilled and low-skilled workers to efficiently sort.

In their field experiment, the authors find evidence consistent with this separating equilibrium, with the signaling tool leading to more efficient sorting.

The paper is very well written: it makes a strong case for the motivation and contribution of the project, states the theoretical model and interpretation clearly, and presents compelling results from a well-designed experiment. I appreciated the results of Proposition 1, but also how the authors included Proposition 2 to show the conditions under which separation will succeed or fail. I also appreciated the detailed empirical analysis; the authors considered many different outcomes of interest to paint a clear picture of the effects of signaling on the platform. It is especially interesting that total hours worked and total wage payments increase, but with fewer job applications.

I read the paper thoroughly but was unable to find any major concerns. Some very minor points are below:

- At the top of p. 18, I wasn’t able to tell what “survey” you are referring to. Can you clarify?

> 🔴 **OPEN — John Horton**
> 
> **What:** Ambiguous 'survey' reference on p.18. Needs Horton to supply the citation or specify which survey is meant before we can edit the text.
> 
> **Location:** Section IV.A (Empirical Context)
> 
> **Commit / Issue:** Issue #6 item 2 (open, waiting for Horton)

- Typos:

  - “compared to comparable”

> ✅ **ADDRESSED**
> 
> **What:** Typo: 'compared to comparable' rephrased in typo pass.
> 
> **Location:** N/A (find/replace)
> 
> **Commit / Issue:** 9c14d38

  - “less job applications” → “fewer job applications”

> ✅ **ADDRESSED**
> 
> **What:** Typo: 'less job applications' → 'fewer job applications'.
> 
> **Location:** N/A
> 
> **Commit / Issue:** 9c14d38

  - “not specify what message is”

> ✅ **ADDRESSED**
> 
> **What:** Typo: 'not specify what message is' reworded.
> 
> **Location:** N/A
> 
> **Commit / Issue:** 9c14d38

  - “possibly become a possibly”

> ✅ **ADDRESSED**
> 
> **What:** Typo: 'possibly become a possibly' deduplicated.
> 
> **Location:** N/A
> 
> **Commit / Issue:** 9c14d38

  - “worker differ”

> ✅ **ADDRESSED**
> 
> **What:** Typo: 'worker differ' → 'workers differ'.
> 
> **Location:** N/A
> 
> **Commit / Issue:** 9c14d38

  - “statics continues”

> ✅ **ADDRESSED**
> 
> **What:** Typo: 'statics continues' → 'statics continue'.
> 
> **Location:** N/A
> 
> **Commit / Issue:** 9c14d38

  - “Denote the expected utility they can generate in other markets be”

> ✅ **ADDRESSED**
> 
> **What:** Typo: broken syntax 'Denote the expected utility they can generate in other markets be' rewritten.
> 
> **Location:** N/A
> 
> **Commit / Issue:** 9c14d38

  - “due in part to employers consider”

> ✅ **ADDRESSED**
> 
> **What:** Typo: 'due in part to employers consider' → 'due in part to employers considering' (p.28).
> 
> **Location:** hot_towel.tex line 1023
> 
> **Commit / Issue:** 9c14d38

## R2 Report

### Summary

This paper theoretically and experimentally studies the role of “cheap talk” messages by employers in job ads in an online gig-work labor market, and how these messages affect job matching and bargaining. Specifically, employers are able to state the quality of work they are looking for. Ideally, this would improve efficiency by allowing high-skilled workers to select into high-skill-demand jobs, thus improving market efficiency.

There are two interconnected threats to this mechanism:

- Wages are negotiated (approximated via a worker TIOLI offer) after the employer’s message. Therefore, an employer who states that they are looking for high-skilled work may reasonably expect to receive higher wage demands.

- As in cheap-talk games more broadly, employers can “lie” in their messages. This is particularly relevant here because the set of possible messages is exogenously imposed by the market maker. Hence, messages may not be interpreted as intended, or the message space may be too fine to support truthful revelation, leading to a babbling equilibrium.

The authors show a sufficient condition under which a truthtelling equilibrium exists and empirically verify that many of the model’s predictions hold.

### Evaluation

The authors undertake a difficult task in combining a non-trivial model with a non-trivial experiment. I am personally a big fan of this approach, and I think the paper’s broad takeaways are both novel and important. My comments therefore focus primarily on areas for improvement.

In short, I found the experimental write-up to be largely clear and convincing, but I found the write-up of the model—and the connection between the model and the experiment—to need significant work. As a disclaimer: I did not fully understand some aspects of the model as written, so some of my suggestions are open-ended.

### 1. Clarity and structure of the model

The model is presented in a way that is neither fully formal nor purely intuitive; it sits somewhere in between, with important aspects left informal but intuition interspersed throughout. This makes the model difficult to follow.

My preference would be to expand the model description and explanation so it can stand alone in the body of the paper. If the editor or authors disagree, it might even be cleaner to move the entire model to an appendix and present only the results in the main text as a guide to the experiment.

> ✅ **ADDRESSED**
> 
> **What:** Model section rewritten to stand alone in the body: formal model + FOCs + comparative statics in the body; extensions, proofs, and second-signal machinery in the appendix.
> 
> **Location:** §III.A–E body; Appendix A–C
> 
> **Commit / Issue:** 9d8fcc6

If the authors opt for the first approach, I suggest creating:

- a technical section that presents the model formally, and

- a separate section (either before or after) that discusses the intuition, assumptions, and modeling choices.

Specific confusions:

a. There is a lot of defensive writing that inflates the model section. For example, before introducing the model (p. 9), the authors write that they are not aiming for maximum generality. Fair enough—but then the first paragraph of the model discusses alternative payoff functions and the simplification to two types (high and low).

> ✅ **ADDRESSED**
> 
> **What:** Defensive writing about generality and alternative payoff functions removed from the body; those discussions now live in Appendix C.
> 
> **Location:** §III.A body; Appendix C
> 
> **Commit / Issue:** 9d8fcc6

b. The intuition is mixed into the formal setup, making it unclear what is definitional versus explanatory. For instance, at the bottom of p. 10, the authors discuss “multiple exogenous signals” of job type—this appears without prior introduction. The same issue occurs with the paragraph on outside options.

> 🔴 **OPEN — likely moot after the rewrite, but keep on radar**
> 
> **What:** The 'multiple exogenous signals' and outside-options paragraphs that R2 flagged sat in the submitted version's §III.A. The theory-section rewrite (commit `9d8fcc6`) significantly restructured this subsection — the mixed formal/intuitive exposition that R2 objected to is substantially different in the new draft, and this specific complaint may no longer apply. **Flag:** keep this comment on the radar through PK's next pass; if the new setup still exhibits the same issue — intuition interleaved with definitions without proper setup — we need to clean it up. If the rewrite has already dissolved the concern, we can mark this addressed in a later revision. For now: provisional.
> 
> **Location:** §III.A (rewritten)
> 
> **Commit / Issue:** 9d8fcc6 (rewrite may have resolved); revisit during PK's pass

c. Certain key assumptions are undefined. The text refers to “a mass of workers” (p. 9) and a “large market” (p. 11). Does this imply a continuum of firms or jobs? The assertion on p. 11 that “randomness leads to a Poisson distribution of workers at a given firm” is also unclear.

> 🟡 **PARTIALLY ADDRESSED — one sub-item done, two open (PK call)**
> 
> **What:** The 'mass of workers' ambiguity is addressed in the new Setup paragraph (commit `f625faf`): ability $a$ is now declared as a nonnegative real, and $W(a)$ is defined as the endogenous mass of workers with ability weakly below $a$. This clarifies the object R2 found undefined.
> 
> Still OPEN — both items are PK calls:
> 
> 1. **'Large market' precise definition.** Whether this is a continuum of firms/jobs, what the exact limit-taking convention is, etc. Needs PK to state the intended formal definition.
> 2. **Poisson-at-each-firm assertion.** The claim that randomness leads to a Poisson distribution of workers at a given firm needs a clean derivation or a pointer to the directed-search literature convention PK has in mind.
> 
> **Location:** §III.A Setup (mass-of-workers addressed); 'large market' and Poisson still in §III.A
> 
> **Commit / Issue:** f625faf (mass-of-workers sub-item); Issue #1 open for the remaining two

d. Has truthful reporting been defined before Proposition 1? Section III.C, which discusses truthtelling, is quite useful and might be moved earlier.

> 🔴 **OPEN — PK call**
> 
> **What:** Whether to move the Truth-telling subsection (§III.E) earlier in the model section is a structural decision deferred to PK. Currently sits after Proposition 1.
> 
> **Location:** §III.E
> 
> **Commit / Issue:** Issue #1 residual (structural)

e. Proofs are hard to follow. For example, the proof of Corollary 1 requires flipping between the body, printed appendix, and online appendix. It’s difficult to track how each component connects.

> ✅ **ADDRESSED (structure)**
> 
> **What:** Proofs now consolidated in Appendix A in proper order (lemma → Corollary 1 → Corollary 2 → Proposition 2 → Proposition 1). 'Online Appendix' renamed to 'Appendix' to align with AEJ Micro's in-print/supplementary terminology. Supplementary Empirical Appendix is separate.
> 
> **Location:** Appendix A
> 
> **Commit / Issue:** c3a8cf4; 207d38f

### 2. Role and test of truthtelling

The assumption seems to be that employers will be truthful in the explicit treatment arm when their message is not shown to workers. The authors then compare this group to those whose messages are revealed. Finding no difference is interpreted as consistent with truthtelling, which justifies pooling the samples.

Comments:

a. The authors could emphasize that additional support for this assumption comes from the fact that the data validate several model predictions that rely on truthtelling.

> ✅ **ADDRESSED**
> 
> **What:** Added 3-sentence paragraph at end of §III.E emphasizing that downstream predictions on sorting, wages, and efficiency are derived under truth-telling — their empirical confirmation constitutes a second, independent anchor for the assumption alongside Proposition 3's IC argument.
> 
> **Location:** §III.E end, after the rookie/expert bridge paragraph
> 
> **Commit / Issue:** 9235bc1

b. The choice to pool the sample is not always consistent: it is done after Figure 1, except in Figure 4, and again in Section V.E. A brief clarification would help.

> 🔴 **OPEN — awaiting framing call (Issue #4 §2b)**
> 
> **What:** Audit of pooling across Figure 1 (pooled), Figure 4 (not pooled), §V.E (pooled) not yet performed. The rule to apply consistently depends on the framing choice in Issue #4 §2c.
> 
> **Location:** Figures 1, 4 and §V.E
> 
> **Commit / Issue:** Issue #4 §2b open

c. The assumption of truthtelling should be stated more explicitly and consistently. The introduction presents it as a plausible behavioral assumption, while the main text treats it as an imposed assumption.

> 🔴 **OPEN — PK to address**
> 
> **What:** Reconciling the two framings: intro treats truth-telling as a plausible *behavioral* assumption; theory body treats it as an *imposed* assumption that Proposition 3 then justifies via IC. These need to speak with one voice throughout. **This item is routed to PK** — it affects the intro narrative, the placement of the Kartik (2009) / Abeler et al. (2019) citations now in the bibliography (commit `207d38f`), and the framing of the ex-post validation paragraph at the end of §III.E (commit `9235bc1`). Peyman will not pre-commit to a direction.
> 
> **Location:** Intro + §III.E
> 
> **Commit / Issue:** Issue #4 §2c (held for PK)

### 3. The second signal (ψ₂)

On p. 11, the authors assume the worker’s second signal about the job is nearly perfectly revealing (“We assume a very precise second signal (ψ₂ close to 1)…”). In the model, this implies that workers have uncertainty about firm type when deciding where to apply, but almost none when making the wage offer.

> ✅ **ADDRESSED**
> 
> **What:** Added wage-mechanism paragraph at end of §III.C explaining that wages depend on ā_{s₁} which is pinned down by (m, s₁) before s₂ is observed; the pool is locked at the application stage, so the second signal resolves firm type at the bidding stage without altering the competition.
> 
> **Location:** §III.C tail paragraph
> 
> **Commit / Issue:** 1183eb0; 3f3b5c0

Why not simplify the model by assuming the signal is perfectly revealing? With ψ₂ → 1, the message affects only sorting, not wage offers. In that case, the experiment should have no impact on wages conditional on worker-firm type. But the paper’s Proposition 1 and empirical results both imply non-trivial wage effects from the message. Is there something subtle I’m missing?

> ✅ **ADDRESSED**
> 
> **What:** Explicit IC-based reason for 'almost precise, not perfectly precise' discussed in new subsection 'Why We View the Second Signal as Imprecise' (Appendix B.1): if ψ₂ = 1 exactly, an L-firm deviating to m=H attracts high-ability workers who upon learning the true type bid low, and the deviation becomes profitable; IC requires ψ₂ < 1 but close to 1.
> 
> **Location:** Appendix B.1 (\label{online_app:imprecise_second_signal})
> 
> **Commit / Issue:** b74b7a0 (label fix adding the subsection break)

### Smaller comments

- The citation style is confusing. For instance, in the last paragraph of p. 2, it is unclear whether parenthetical citations refer to the same labor market studied in this paper or others. Similar ambiguity appears on p. 6 (Tadelis and Zettelmeyer).

> 🔴 **OPEN — Issue #3**
> 
> **What:** Citation style cleanup (p.2 and p.6 Tadelis & Zettelmeyer). Held pending PK's positioning paragraphs.
> 
> **Location:** Intro, §II Literature
> 
> **Commit / Issue:** Issue #3 open

- I did not understand the first full sentence on p. 25 (“This simplification of the model…”).

> ✅ **ADDRESSED**
> 
> **What:** Rewrote the confusing "This simplification of the model follows from our focus on the changes induced by allowing cheap talk messages rather than levels" sentence. The original had three ambiguities R2 flagged (what is "this simplification", changes of what, levels of what). New text makes each referent explicit: the simplification is the random-approach assumption, "changes" are the differences $\hat{\beta}^1_k - \hat{\beta}^0_k$ within each tier, and "levels" are the baseline $\hat{\beta}^0_k$. Rewrite: "This is unsurprising, but note that this pattern is not a prediction of the model in Section~\ref{sec:theory}, which abstracts from baseline sorting by assuming workers approach firms at random. We adopt this simplification deliberately: the model is designed to study how revelation *changes* the applicant pool (that is, the difference $\hat{\beta}^1_k - \hat{\beta}^0_k$ within each tier), not to explain the baseline levels $\hat{\beta}^0_k$ that would arise in the message's absence."
> 
> **Location:** hot_towel.tex §V.A Sorting (around line 861)
> 
> **Commit / Issue:** this commit (closes Issue #6 item 3)

- On p. 26, the authors might be clearer by continuing to use “prior cumulative earnings” instead of “experience.”

> ✅ **ADDRESSED**
> 
> **What:** Changed 'prior experience' to 'prior cumulative earnings' on p.26.
> 
> **Location:** hot_towel.tex line 928
> 
> **Commit / Issue:** 5da3999

- The panels in Figure 5 are not ordered as described on p. 28.

> ✅ **VERIFIED — no change needed**
> 
> **What:** Panel order in Figure 5 ('signal_effects_experience.pdf') verified via pdftotext to already match the text (earnings top, hours-worked bottom). R2's flag appears stale.
> 
> **Location:** Figure 5 + surrounding text
> 
> **Commit / Issue:** No change (verified via pdftotext sweep)

- Clarify terminology in Proposition 1: sometimes “part,” sometimes “bullet,” sometimes “Part.”

> ✅ **ADDRESSED**
> 
> **What:** Proposition 1 terminology standardized: uniformly uses 'part' throughout. 'Medium'→'I' swept in same pass.
> 
> **Location:** Proposition 1 statement + cross-references
> 
> **Commit / Issue:** 9c14d38

- Avoid “-Y% decrease” phrasing; use “Y% decrease.”

> 🔴 **OPEN — Horton**
> 
> **What:** '-Y% decrease' phrasing derives from negative values in auto-generated LaTeX parameter macros emitted by the R pipeline. Cleanest fix: wrap the relevant values in abs() inside analysis/params_*.R. Routed to Horton.
> 
> **Location:** analysis/params_*.R
> 
> **Commit / Issue:** Issue #9 open (pinged @johnjosephhorton)

- Typos on p. 28: an extra “)” after the Figure 3 reference; last sentence of the paragraph ends with “due in part to employers consider.”

> ✅ **ADDRESSED**
> 
> **What:** Extra ')' after Figure 3 reference removed (line 1016); 'due in part to employers consider' fixed in typo pass.
> 
> **Location:** hot_towel.tex line 1016 (stray ')'); line 1023 (consider→considering)
> 
> **Commit / Issue:** 5da3999 (stray ')'); 9c14d38 (verb fix)

- On p. 34, the authors describe expected wages. If data on outside options exist, it may be more relevant to study surplus rather than wages (though this is minor).

> 🔴 **OPEN — Horton (if pursuable)**
> 
> **What:** p.34 surplus-vs-wage framing. Requires Horton to confirm whether outside-options data are usable. Minor item per R2.
> 
> **Location:** Section VI
> 
> **Commit / Issue:** Response letter item (defer)

- On p. 10 (“market entry”), clarify whether u’ is bounded or unbounded. Both statements seem to appear, and it is unclear whether this assumption is maintained throughout or only where needed.

> ✅ **ADDRESSED**
> 
> **What:** Rewrote the Market Entry paragraph to disambiguate two different "bounded/unbounded" claims that R2 read as contradictory. The paper's actual position: (i) $u$ is increasing, strictly convex, and satisfies Inada conditions $u'(0)=0$ and $\lim_{a \to \infty} u'(a) = \infty$ — so $u'$ itself is unbounded, maintained **throughout**; (ii) a **separate** regularity condition, used only where specific proofs require it (e.g., the wage ODE in the proof of Corollary 2 at line 1573), is that the *elasticity* of $u'$, namely $a \cdot u''(a)/u'(a)$, is bounded away from zero and infinity. These two claims are compatible: the elasticity condition restricts the *rate* at which $u'$ grows, not $u'$ itself. The rewrite explicitly labels one as maintained globally and the other as used where needed, and adds a clarifying sentence noting the compatibility.
> 
> **Location:** hot_towel.tex §III.A Market Entry paragraph (lines 280–290)
> 
> **Commit / Issue:** this commit (closes the p.10 u' clarification item)

## R3 Report

This is a great and ambitious paper. It is sufficiently transparent that I don’t feel the need to spend time summarizing it.

I don’t have many comments; the paper is in great shape. However, I do have some notes on framing that I suspect stem from the fact that the literature has evolved somewhat since this paper was originally conceived (the experiment having been run, according to p.19, “from 2013-07-18 to 2013-12-05”).

### Specific Comments

- p.6 – “Perhaps the closest related paper is Tadelis and Zettelmeyer (2015)…”
I see the connection to Tadelis and Zettelmeyer (2015), although I think there is another Tadelis paper that is also closely related — his more recent paper in JPE (Backus et al., 2019).

> 🟡 **PARTIALLY ADDRESSED — bib ref added, text awaiting PK**
> 
> **What:** `backus2019empirical` (Backus, Blake & Tadelis, JPE 2019) is now present in `writeup/hot_towel.bib`, ready to be cited. The positioning paragraph that ties this reference into §II Literature is PK's to write — connecting our contribution to the Backus-Blake-Tadelis framework is a framing call that Peyman will not pre-commit to.
> 
> **Location:** bib ready; §II Literature text pending
> 
> **Commit / Issue:** bib entry added (in-flight edit); text-level incorporation open under Issue #3

  - Tadelis and Zettelmeyer (2015) get improved match value first through the linkage principle, and then, motivated by the empirical findings, through additional entry. Note that the linkage principle is not incentive compatible; low types would prefer not to reveal their type, but they end up doing better through additional entry.

> 🔴 **OPEN — PK**
> 
> **What:** Distinguishing Tadelis & Zettelmeyer (2015)'s linkage principle from our IC cheap talk. This is a substantive framing call about how our mechanism differs from theirs, held for PK.
> 
> **Location:** §II Literature
> 
> **Commit / Issue:** Issue #3 open (PK)

  - Backus, Blake, and Tadelis (2019) do not emphasize improved match value, but they do, like this paper, obtain incentive-compatible cheap talk and endogenous matching. Perhaps more helpfully for the empirical parts of this paper, they set out a framework for thinking about the empirical content of such equilibria, much of which is implicitly re-invented here. My main suggestion for improving this paper would be connecting it to that literature by outlining how the empirical evidence comports with the framework advanced there.

> 🟡 **PARTIALLY ADDRESSED — bib ref added, text awaiting PK**
> 
> **What:** `backus2019empirical` is now in the bib. R3's main framing ask — an explicit paragraph connecting our empirical evidence to Backus-Blake-Tadelis (2019)'s framework on the empirical content of IC cheap talk — is held for PK. This is the flagship framing deliverable of Issue #3.
> 
> **Location:** bib ready; §II Literature + intro text pending
> 
> **Commit / Issue:** bib entry added; text-level incorporation open under Issue #3 (PK)

- p.18 – “The marketplace we study is not the only market for online work, and so it is important to keep in mind the ‘market’ versus ‘marketplace’ distinction made by Roth (2018).”
Please spell this out more clearly.

> ✅ **ADDRESSED**
> 
> **What:** Restructured the paragraph opening so Roth's terminology is defined explicitly and immediately connected to the multi-homing concern that follows. Rewrite: "The marketplace we study is one of several venues within the broader market for online work. In the terminology of \cite{roth2018}, a *marketplace* is a specific institutional venue governed by particular rules, namely the online platform on which the experiment was run, while a *market* is the set of all buyers and sellers who could potentially transact for the type of work in question, short-term remote labor in our case. Because our intervention operates at the marketplace level, a natural concern is that every job opening we see on the platform could be simultaneously posted on several other online labor market sites and in the conventional market." The downstream survey-evidence sentences on multi-homing are left intact (still waiting for Horton's input on which survey is being cited).
> 
> **Location:** hot_towel.tex §IV.A Empirical Context (line 698 area)
> 
> **Commit / Issue:** this commit

- p.19 – “In this arm, employees were then randomized to have their choice revealed or not.”
I think of this as akin to the garbling device discussed in Backus et al. (2019), and the first, best example I know of using this to study signaling is Ambrus et al. (2018).

> 🟡 **PARTIALLY ADDRESSED — bib refs added, text awaiting PK**
> 
> **What:** Both `backus2019empirical` and `ambrus2018pirates` (Ambrus, Chaney & Salitskiy, QE 2018) are now in `writeup/hot_towel.bib`, ready to be cited. Framing our probabilistic revelation arm as the garbling device in Backus et al. (2019), with Ambrus et al. (2018) as the first signaling application of this design, is PK's paragraph to write.
> 
> **Location:** bib ready; §IV.A + §II Literature text pending
> 
> **Commit / Issue:** bib entries added; text-level incorporation open under Issue #3 (PK)

- Section V.A:
I did not find these results surprising.

> ✅ **ADDRESSED**
> 
> **What:** R3 said 'I did not find these results surprising' for §V.A (Informative Messages). Subsection moved to Empirical Appendix; a two-paragraph preemptive-defense summary was left in the body that frames the pooling question and reports the χ² null, pointing to the appendix for detail.
> 
> **Location:** §V opening + Empirical Appendix \label{online_app:informative_messages}
> 
> **Commit / Issue:** c0ad729

- I have emphasized to the editor that the following is a suggestion for future work, and I would actively oppose requiring it for a revision. But I think there is a natural next paper here: to think about the optimal design of such a sorting mechanism.
I have written next to Section V.C: “This is great, but the kind of thing I would only care about if the authors were going to do the structural exercise…” That is to say, I think you should keep it in, but keep it as a signpost for someone else—or yourselves—to take up next time and think about estimating structural primitives in order to engage in the market design exercise.

> 🟣 **DECLINED (per R3's own suggestion)**
> 
> **What:** Structural estimation / market-design exercise. R3 explicitly said 'I would actively oppose requiring it for a revision'; kept §V.C in place as a signpost but did not pursue the structural exercise.
> 
> **Location:** No change (§V.C intact)
> 
> **Commit / Issue:** Decision noted in response letter

### References

Ambrus, A., Chaney, E., and Salitskiy, I. (2018). Pirates of the Mediterranean: An Empirical Investigation of Bargaining with Asymmetric Information. Quantitative Economics, 9(1):217–246.

Backus, M., Blake, T., and Tadelis, S. (2019). On the Empirical Content of Cheap-Talk Signaling: An Application to Bargaining. Journal of Political Economy, 127(4):1599–1628.

Tadelis, S. and Zettelmeyer, F. (2015). Information Disclosure as a Matching Mechanism: Theory and Evidence from a Field Experiment. American Economic Review, 105(2):886–905.

Maybe move V.A. to Appendix?

> ✅ **ADDRESSED**
> 
> **What:** Editor's marginal note 'Maybe move V.A. to Appendix?' — §V.A (Informative Messages) has been moved to the Empirical Appendix.
> 
> **Location:** Empirical Appendix
> 
> **Commit / Issue:** c0ad729

