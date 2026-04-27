# Hot Towel — AEJ Micro Revision Response Tracker

_Running document mapping every editor/referee comment to our revision status._

Under each referee or editor comment is a response callout with three fields:

- **What we did** — a plain-English description of the revision, suitable for any reader.
- **Where in the paper** — the section or paragraph where the fix lives.
- **Internal tracking** — commit hashes, GitHub issue numbers, and file paths for the team's audit trail.

**Status legend:**

- ✅ addressed / verified
- 🟡 partially addressed (open items remain)
- 🔴 open (awaiting coauthor input or further work)
- 🟣 declined per referee's own suggestion

---

## Revision TO Dos for

## "Sorting through Cheap Talk: Theory and Evidence from a Labor Market"

@ AEJ Micro

_John Horton			   Ramesh Johari			    Philipp Kircher_

Below is the text from the editor's letter and three referee reports.

## Editor's Letter

Thank you for submitting this paper to the American Economic Journal: Microeconomics (AEJ Micro). Based on the advice of three referees and my own reading, I am inviting a revision for possible publication in AEJ Micro.

This is a very promising paper. It combines a theoretical model of cheap talk in labor markets with an impressively large and well-designed field experiment. The experiment is compelling and generates clear results: the cheap-talk device improves sorting, affects wages, and increases efficiency. The contribution is significant, and the paper has the potential to have impact. All three referees recommend that I invite a revision.

However, there are also concerns that need to be addressed before the paper can be published in AEJ Micro. In particular, the current presentation of the model is not clear enough for the journal's readership; Referee 2 (whose report begins "This paper theoretically and experimentally…") found this section especially difficult to follow, and I share that view. Referee 3 ("This is a great…") also suggested that the framing of the paper should be sharpened considering subsequent developments in the literature.

### Key goals for the revision

#### 1. Model section

While the model is appropriate for your empirical setting, its exposition falls short. I agree with Referee 2 that mixing formal assumptions with intuition, and requiring the reader to toggle between multiple sections and appendices, is not up to AEJ Micro standards. Moreover, I could not find either your supplementary appendix or your online appendix with the submission, so it is impossible to assess the full model.

Please improve the presentation of the model and analysis, with the following points in mind:

a) Separate formalism from intuition. Present the formal model clearly and cleanly, and then provide the intuition. Readers should be able to distinguish formalism from commentary and understand the model on its own.

> 🟡 **PARTIALLY ADDRESSED — first pass done, PK to iterate**
> 
> **What we did:** Rewrote the theory section so the main body carries only the formal model setup, first-order conditions, and comparative statics. Proofs, extensions, robustness discussions, and second-signal machinery all moved to the appendix. Intuition and exposition are now separated from the formal statements rather than interleaved. This is a first pass; PK is expected to iterate further on the separation between formalism and intuition, on the wording of the intuition passages, and on any remaining hedging that slipped through.
> 
> **Where in the paper:** Theory section (Section III, subsections A through E) in the main body; new appendices (Appendix A for proofs, Appendix B for information revelation, Appendix C for model extensions).
> 
> **Internal tracking:** commits `9d8fcc6` (theory rewrite merge), `c3a8cf4` (Corollary 2 proof relocation). Awaiting PK's iteration.

b) Trim defensive writing. Early passages hedge about generality and alternative modeling choices. These are distracting and sometimes confusing. Streamline for a crisp statement of the model.

> ✅ **ADDRESSED**
> 
> **What we did:** Removed the hedging and defensive passages from the body that discussed alternative modeling choices and generality. The discussion of alternative production functions now lives in an appendix, where interested readers can find it without interrupting the main exposition.
> 
> **Where in the paper:** Theory section (Section III) body is now cleaner; alternative production-function material moved to Appendix C (Model Extensions).
> 
> **Internal tracking:** commit `9d8fcc6`.

c) Clarify definitions and logic. Define all terms precisely—e.g., what you mean by a "large market." Introduce truthtelling before it appears in Proposition 1. Be transparent about the role of both signals (s_1, s_2). As Referee 2 noted, if s_2 is nearly perfectly revealing, the wage effects of cheap talk should vanish—yet you report non-trivial effects. Please reconcile this. Also clarify why s_1 is needed: is it to generate sorting without cheap talk? If so, perhaps exclude it from the baseline model.

> 🟡 **PARTIALLY ADDRESSED — open items remain**
> 
> **What we did:** This comment bundles several separate requests. Status of each:
> 
> 1. **ψ₂ paradox (why wages still move when the second signal is nearly perfect).** Addressed with a two-part response: (i) a clarifying paragraph at the end of the no-messages analysis explaining that wages depend on the lowest worker type in the applicant pool, which is pinned down by the message and the first signal *before* the second signal is observed, so wage effects survive as the second signal becomes perfect; (ii) an appendix subsection explaining why we treat the second signal as "almost precise" rather than literally perfect — at literal precision, incentive compatibility for truth-telling breaks.
> 2. **Precise definition of "large market".** Still open. Needs PK's call on the intended formal definition (continuum of firms/jobs, what the limit-taking convention is).
> 3. **Whether to introduce truth-telling before Proposition 1.** Still open. Currently truth-telling is introduced in §III.E, after Proposition 1. Whether to move it earlier is a structural call deferred to PK.
> 4. **Role of u' boundedness.** Addressed separately (see R2's p.10 comment below).
> 5. **Role of s_1.** Still open pending PK's read.
> 
> **Where in the paper:** End of Section III.C (wage-mechanism paragraph); Section III.E; Appendix B.1 "Why We View the Second Signal as Imprecise."
> 
> **Internal tracking:** commits `1183eb0`, `3f3b5c0`, `b74b7a0`; remaining items under GitHub Issue #1 (residual checklist).

d) Improve organization. Currently, to understand Proposition 1 a reader must consult the body, main appendix, and supplementary appendix. The graphical intuition in the main appendix is difficult to follow. The paper and main ("in-print") appendix should together provide a self-contained sketch of the main results, deferring details to the supplementary appendix. (At AEJ Micro, there are only those two kinds of appendices.) You must still adhere to page-length guidelines.

> ✅ **ADDRESSED (structural)**
> 
> **What we did:** Reorganized the body and main appendix so they are self-contained for Proposition 1. All proofs now sit in the first appendix in their proper order: the no-mass-point lemma, then Corollary 1, Corollary 2, Proposition 2 (the no-talk equilibrium), and finally Proposition 1 (the comparison result). Renamed the previous "Online Appendix" to "Appendix" throughout to match AEJ Micro's two-appendix convention (main/in-print and supplementary). The empirical supplementary appendix is kept as a separate document.
> 
> **Where in the paper:** Main appendices A–C; Supplementary Empirical Appendix.
> 
> **Internal tracking:** commit `207d38f` (Online Appendix → Appendix rename sweep).

Overall, AEJ Micro publishes both top-field theoretical and theoretically grounded empirical papers. Models should have the clarity and precision expected by theorists but remain accessible to a broad microeconomics audience. Please revise your model section accordingly. I am not micromanaging at this stage, but I reserve the right to do so in the next round.

#### 2. Framing and literature positioning

Referee 3 emphasized improving the framing by connecting more directly to the literature. I concur. Please address their points 1–3. In addition, note that this paper—and perhaps others cited—also relates to work on credible communication in labor markets, including costly signaling models (see also point 5 below).

Besides these points, please incorporate any other referee suggestions you find helpful. While I am not mandating all of them, you should obviously fix typos, ambiguities, and similar issues, and consider Referee 2's specific comments.

### Additional comments

- Wage determination. You assume the firm pays the demanded wage. Is this realistic for your application—i.e., is there truly no wage bargaining? Could it occur outside the platform? How would this affect your analysis?

> 🔴 **OPEN — John Horton to address**
> 
> **What we did:** Not yet addressed. This needs institutional knowledge of how wages are actually set on the platform and whether bargaining occurs off-platform. Routed to John.
> 
> **Where in the paper:** Response letter item, also affects the model's interpretation.
> 
> **Internal tracking:** GitHub Issue #5 (open, pinged @johnjosephhorton).

- Truthtelling preferences. In the introduction you write, "lack of incentives makes truth-telling a focal point." Is there evidence for that? You might cite literature on preferences for truth-telling even without incentives (e.g., Kartik 2009; Abeler et al. 2019). Such preferences could allow separation even where a pure cheap-talk model predicts pooling. How does this relate to your conditions for separation under pure cheap talk?

> 🟡 **PARTIALLY ADDRESSED — citations in, framing awaiting PK**
> 
> **What we did:** Added the Kartik (2009) and Abeler et al. (2019) references to the bibliography so they are ready to cite. How exactly to integrate them — and how to reconcile the intro's "plausible behavioral assumption" framing with the theory section's "imposed assumption later justified by incentive compatibility" framing — is a call we are holding for PK and John. See the related R2 §2c comment below.
> 
> **Where in the paper:** Bibliography ready; intro and theory section to be edited once the framing is decided.
> 
> **Internal tracking:** commit `207d38f` (bib additions). Framing decision tracked under GitHub Issue #4 §2c.

- Minor issues.

  - p.2: "Recent theory papers" — do you want to call a 2007 paper "recent"? Also, the mid-sentence reference to Horton (2010) is distracting; consider moving it. More broadly, I agree with Referee 2 that your connections to cited papers are often unclear.

> 🟡 **PARTIALLY ADDRESSED — one open item**
> 
> **What we did:** Three items bundled here:
> 
> 1. **"Recent theory papers" → "Existing theoretical work"** in the introduction, so the Menzio (2007) citation is no longer described as "recent." Done.
> 2. **Mid-sentence Horton (2010) citation removed** from the introduction. The reference still appears later in the Empirical Context section where the platform is properly described, so nothing is lost. Done.
> 3. **Broader "connections to cited papers are often unclear" concern.** Still open. The systemic fix requires PK's positioning paragraphs that explicitly state each citation's relationship to our contribution; once those land, the intro and Literature section can be swept for citation clarity.
> 
> **Where in the paper:** Introduction (first mention of Menzio 2007 and first mention of Horton 2010).
> 
> **Internal tracking:** commit `589f185` (two narrow fixes). Broader cleanup tracked under GitHub Issue #3.

  - p.3: The phrase "persists from partial to full market roll-out" is unclear.

> ✅ **ADDRESSED**
> 
> **What we did:** Rewrote the sentence to make clear that the paper's predictions hold whether cheap talk is introduced to a fraction of firms (as in our experimental variation) or to the entire market (as in the platform-wide roll-out that followed the experiment).
> 
> **Where in the paper:** Introduction (toward the end of the paragraph that summarizes the theoretical predictions).
> 
> **Internal tracking:** commit `5da3999`.

  - p.8: Second line of Section III: omit the repeated "salient." Point (2) could be dropped—it is standard. The first part of point (3) could also be cut unless you wish to emphasize that wage demands are worker commitments; in that case, rephrase.

> 🔴 **OPEN — awaiting PK's theory-body pass**
> 
> **What we did:** Not yet addressed. Three items bundled here:
> 
> 1. Remove the repeated word "salient" on the second line of Section III.
> 2. Consider dropping point (2) of the introductory numbered list, since it is a standard point in the directed-search literature.
> 3. Consider cutting the first part of point (3), or rephrase it, to emphasize that wage demands are worker commitments.
> 
> All three are held for PK's pass over the theory-section body, since they involve judgment calls about what standard readers expect.
> 
> **Where in the paper:** Opening of the theory section (Section III), introductory paragraphs.
> 
> **Internal tracking:** GitHub Issue #1 (residual).

  - p.9: Clarify that a is a real (presumably nonnegative) number. Define subscript T on v_T when first introduced—it indexes job type. (Minor: consider lowercase t instead of uppercase T.) Using \delta for probability is nonstandard; consider p. When you write "in principle firms could have…," are you stating the model allows it or only conceptually?

> 🟡 **PARTIALLY ADDRESSED — one open item**
> 
> **What we did:** Five items bundled here; four addressed:
> 
> 1. **Ability "a" explicitly declared as a nonnegative real.** The Setup paragraph now opens with "Workers have heterogeneous ability a in the nonnegative reals."
> 2. **Subscript T introduced at first use.** The paragraph now says "differences across job types, indexed by the subscript T: a job of type T has marginal valuation v_T for workers' ability."
> 3. **"δ" replaced with "p"** throughout the paper for type probabilities (14 subscripted occurrences swept). The probability of a high type is now p_H, low types p_L. A standalone δ appears in one proof as a generic positive real; that one is left alone because it denotes a different object.
> 4. **"In principle firms could have…" wording clarified.** New text makes the model-vs-reality distinction explicit: in reality a firm may post several openings potentially of different types; in the model we restrict attention to one opening per firm and use "job" and "firm" interchangeably.
> 5. **Uppercase T vs. lowercase t** (the editor's parenthetical suggestion): kept as uppercase T for now. This is a notation call held for PK.
> 
> **Where in the paper:** Setup paragraph of the theory section (Section III.A).
> 
> **Internal tracking:** commit `f625faf`. Uppercase-T decision tracked under GitHub Issue #1.

  - p.10: Workers care only about wages—so more difficult jobs don't imply higher disutility?

> 🔴 **OPEN — awaiting PK's theory-body pass**
> 
> **What we did:** Not yet addressed. Need to clarify whether workers in the model experience any disutility from more difficult jobs, or whether job difficulty enters only through the firm's cost parameter c_T. Held for PK.
> 
> **Where in the paper:** Setup paragraph of the theory section (Section III.A).
> 
> **Internal tracking:** GitHub Issue #1 (residual).

  - p.11: Clarify "large market." Do you need all the citations in footnote 8, or would a summary suffice? Also, "can reject" might simply be "rejects."
  
> 🟡 **PARTIALLY ADDRESSED — two open items**
> 
> **What we did:** Three items bundled here:
> 
> 1. **"Can reject" → "rejects"** swept in the manuscript-wide typo pass. Done.
> 2. **Precise definition of "large market".** Still open. Needs PK's call on the intended formal convention.
> 3. **Trim footnote 8 citations.** Still open. Needs judgment on which directed-search citations are load-bearing vs. background.
> 
> **Where in the paper:** Theory section.
> 
> **Internal tracking:** commit `9c14d38` (typo fix). Remaining items under GitHub Issue #1.

  - p.12: "Message off-equilibrium" → "message off the equilibrium path." Footnote 11 lacks a right bracket. Be consistent in your use of ":=" for definitions.

> ✅ **ADDRESSED**
> 
> **What we did:** Three items bundled here; all done in the manuscript-wide typo pass:
> 
> 1. "Message off-equilibrium" changed to "message off the equilibrium path."
> 2. Footnote 11 missing right bracket fixed.
> 3. ":=" usage made consistent throughout for definitions.
> 
> **Where in the paper:** Theory section.
> 
> **Internal tracking:** commit `9c14d38` (closes GitHub Issue #7).

  - p.13: What does "meaningful mass points" mean? The first sentence of Proposition 1 repeats what was just stated.

> ✅ **ADDRESSED**
> 
> **What we did:** Two items bundled here; both done in the typo pass:
> 
> 1. "Meaningful mass points" clarified.
> 2. The repetition in the first sentence of Proposition 1 was trimmed.
> 
> **Where in the paper:** Theory section (around the Proposition 1 walk-through).
> 
> **Internal tracking:** commit `9c14d38`.

  - p.15: When you write "generically fails," do you mean in a formal genericity sense?

> 🔴 **OPEN — awaiting PK's theory-body pass**
> 
> **What we did:** Not yet addressed. Need to decide whether "generically fails" is meant in the formal genericity sense or informally; if formal, add a precise statement. Held for PK.
> 
> **Where in the paper:** Theory section (truth-telling subsection).
> 
> **Internal tracking:** GitHub Issue #1 (residual).

  - Footnote 13: Using "L" and "H" but then "Medium" looks odd. Perhaps use "I" for intermediate.

> ✅ **ADDRESSED**
> 
> **What we did:** Changed "Medium" to "I" (for Intermediate) in Footnote 13 to match the L/H convention used elsewhere.
> 
> **Where in the paper:** Theory section, Footnote 13.
> 
> **Internal tracking:** commit `9c14d38`.

While I cannot commit to publication, I am cautiously optimistic that a thorough revision will pay off. When resubmitting, please include a single PDF containing:

- detailed responses to each referee and to me,

- an outline of all changes made to the paper.

AEJ Micro allows 12 months for resubmission, though since this is mostly an expositional revision, I hope you can return it within about four months.

If anything in this letter requires clarification, feel free to reach out. Thank you again for submitting this interesting paper to AEJ Micro. I look forward to seeing your revision.

Sincerely,

Navin Kartik

Editor, American Economic Journal: Microeconomics

Resubmission Instructions

Log into http://mc.manuscriptcentral.com/aej-micro and enter your Author Center. Under "Manuscripts with Decisions," click "Create a Revision."

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

- At the top of p. 18, I wasn't able to tell what "survey" you are referring to. Can you clarify?

> 🔴 **OPEN — John Horton to address**
> 
> **What we did:** Not yet addressed. The paragraph references "the survey" twice without naming the source. John needs to tell us which survey is being referenced so we can add a citation or name it explicitly.
> 
> **Where in the paper:** Empirical Context section (Section IV.A), in the paragraph discussing whether workers and firms multi-home across platforms.
> 
> **Internal tracking:** GitHub Issue #6 item 2 (open, waiting for John).

- Typos:

  - "compared to comparable"

> ✅ **ADDRESSED**
> 
> **What we did:** Reworded to eliminate the repetition.
> 
> **Where in the paper:** Manuscript-wide typo pass.
> 
> **Internal tracking:** commit `9c14d38`.

  - "less job applications" → "fewer job applications"

> ✅ **ADDRESSED**
> 
> **What we did:** Changed "less" to "fewer" (correct usage with countable noun).
> 
> **Where in the paper:** Manuscript-wide typo pass.
> 
> **Internal tracking:** commit `9c14d38`.

  - "not specify what message is"

> ✅ **ADDRESSED**
> 
> **What we did:** Reworded the sentence.
> 
> **Where in the paper:** Manuscript-wide typo pass.
> 
> **Internal tracking:** commit `9c14d38`.

  - "possibly become a possibly"

> ✅ **ADDRESSED**
> 
> **What we did:** Removed the duplicated word.
> 
> **Where in the paper:** Manuscript-wide typo pass.
> 
> **Internal tracking:** commit `9c14d38`.

  - "worker differ"

> ✅ **ADDRESSED**
> 
> **What we did:** Changed "worker differ" to "workers differ."
> 
> **Where in the paper:** Manuscript-wide typo pass.
> 
> **Internal tracking:** commit `9c14d38`.

  - "statics continues"

> ✅ **ADDRESSED**
> 
> **What we did:** Changed "statics continues" to "statics continue."
> 
> **Where in the paper:** Manuscript-wide typo pass.
> 
> **Internal tracking:** commit `9c14d38`.

  - "Denote the expected utility they can generate in other markets be"

> ✅ **ADDRESSED**
> 
> **What we did:** Rewrote this broken sentence.
> 
> **Where in the paper:** Manuscript-wide typo pass.
> 
> **Internal tracking:** commit `9c14d38`.

  - "due in part to employers consider"

> ✅ **ADDRESSED**
> 
> **What we did:** Changed "employers consider" to "employers considering."
> 
> **Where in the paper:** Section V (wages discussion).
> 
> **Internal tracking:** commit `9c14d38`.

## R2 Report

### Summary

This paper theoretically and experimentally studies the role of "cheap talk" messages by employers in job ads in an online gig-work labor market, and how these messages affect job matching and bargaining. Specifically, employers are able to state the quality of work they are looking for. Ideally, this would improve efficiency by allowing high-skilled workers to select into high-skill-demand jobs, thus improving market efficiency.

There are two interconnected threats to this mechanism:

- Wages are negotiated (approximated via a worker TIOLI offer) after the employer's message. Therefore, an employer who states that they are looking for high-skilled work may reasonably expect to receive higher wage demands.

- As in cheap-talk games more broadly, employers can "lie" in their messages. This is particularly relevant here because the set of possible messages is exogenously imposed by the market maker. Hence, messages may not be interpreted as intended, or the message space may be too fine to support truthful revelation, leading to a babbling equilibrium.

The authors show a sufficient condition under which a truthtelling equilibrium exists and empirically verify that many of the model's predictions hold.

### Evaluation

The authors undertake a difficult task in combining a non-trivial model with a non-trivial experiment. I am personally a big fan of this approach, and I think the paper's broad takeaways are both novel and important. My comments therefore focus primarily on areas for improvement.

In short, I found the experimental write-up to be largely clear and convincing, but I found the write-up of the model—and the connection between the model and the experiment—to need significant work. As a disclaimer: I did not fully understand some aspects of the model as written, so some of my suggestions are open-ended.

### 1. Clarity and structure of the model

The model is presented in a way that is neither fully formal nor purely intuitive; it sits somewhere in between, with important aspects left informal but intuition interspersed throughout. This makes the model difficult to follow.

My preference would be to expand the model description and explanation so it can stand alone in the body of the paper. If the editor or authors disagree, it might even be cleaner to move the entire model to an appendix and present only the results in the main text as a guide to the experiment.

> 🟡 **PARTIALLY ADDRESSED — awaiting PK's theory pass**
> 
> **What we did:** Restructured the theory section so the body carries the formal model setup, first-order conditions, and comparative statics, while extensions, proofs, and second-signal machinery have been moved to the appendix. This is a structural first pass — it gets the section closer to standing alone in the body, but the prose still needs work and PK's iterations before we can call the section truly self-contained at AEJ Micro standards.
> 
> **Where in the paper:** Theory section (Section III) and appendices A–C.
> 
> **Internal tracking:** commit `9d8fcc6`. Awaiting PK's iteration.

If the authors opt for the first approach, I suggest creating:

- a technical section that presents the model formally, and

- a separate section (either before or after) that discusses the intuition, assumptions, and modeling choices.

> 🔴 **OPEN — awaiting PK's theory pass**
> 
> **What we did:** Not yet addressed. R2 is asking for a structural split of the theory section into (i) a technical section with the formal model only, and (ii) a separate intuition/assumptions/modeling-choices section placed before or after. The current rewrite already moves in this direction (formal setup in the body, intuition no longer interleaved with definitions), but a clean two-subsection split has not been performed. Whether to commit to that split — and if so, whether the intuition section sits before or after the technical one — is a structural call held for PK.
> 
> **Where in the paper:** Theory section (Section III).
> 
> **Internal tracking:** GitHub Issue #1 (residual, structural).

Specific confusions:

a. There is a lot of defensive writing that inflates the model section. For example, before introducing the model (p. 9), the authors write that they are not aiming for maximum generality. Fair enough—but then the first paragraph of the model discusses alternative payoff functions and the simplification to two types (high and low).

> ✅ **ADDRESSED**
> 
> **What we did:** Removed the defensive hedging about generality and alternative payoff functions from the body. That discussion now lives in an appendix, where interested readers can find it without being slowed down in the main text.
> 
> **Where in the paper:** Theory section (Section III.A); Appendix C (Model Extensions).
> 
> **Internal tracking:** commit `9d8fcc6`.

b. The intuition is mixed into the formal setup, making it unclear what is definitional versus explanatory. For instance, at the bottom of p. 10, the authors discuss "multiple exogenous signals" of job type—this appears without prior introduction. The same issue occurs with the paragraph on outside options.

> 🔴 **OPEN — likely moot after the rewrite, but keep on radar**
> 
> **What we did:** The paragraphs R2 flagged here sat in the submitted version of the theory section. The rewrite significantly restructured this subsection, so the specific "multiple exogenous signals" and outside-options problems R2 described may no longer apply. Keep this comment on the radar during PK's pass: if the new setup still exhibits the same issue (intuition interleaved with definitions without proper setup), we clean it up; if the rewrite has already dissolved the concern, we mark this addressed.
> 
> **Where in the paper:** Theory section (Section III.A, rewritten).
> 
> **Internal tracking:** commit `9d8fcc6` may already resolve; revisit during PK's pass.

c. Certain key assumptions are undefined. The text refers to "a mass of workers" (p. 9) and a "large market" (p. 11). Does this imply a continuum of firms or jobs? The assertion on p. 11 that "randomness leads to a Poisson distribution of workers at a given firm" is also unclear.

> 🟡 **PARTIALLY ADDRESSED — two open items**
> 
> **What we did:** Three items bundled here:
> 
> 1. **"Mass of workers" ambiguity.** Addressed. The Setup paragraph now declares ability as a nonnegative real and defines the endogenous mass of workers as the quantity of workers with ability weakly below a given level. This pins down what R2 found undefined.
> 2. **"Large market" precise definition.** Still open — needs PK's call (continuum of firms/jobs? what is the limit-taking convention?).
> 3. **Poisson-at-each-firm assertion.** Still open — needs a clean derivation or a pointer to the directed-search literature convention PK has in mind.
> 
> **Where in the paper:** Setup paragraph of the theory section (Section III.A).
> 
> **Internal tracking:** commit `f625faf`. Remaining items under GitHub Issue #1.

d. Has truthful reporting been defined before Proposition 1? Section III.C, which discusses truthtelling, is quite useful and might be moved earlier.

> 🔴 **OPEN — PK call**
> 
> **What we did:** Not yet addressed. Whether to move the Truth-telling subsection earlier in the theory section is a structural decision deferred to PK. Currently truth-telling sits after Proposition 1.
> 
> **Where in the paper:** Theory section (Section III.E currently).
> 
> **Internal tracking:** GitHub Issue #1 (residual, structural).

e. Proofs are hard to follow. For example, the proof of Corollary 1 requires flipping between the body, printed appendix, and online appendix. It's difficult to track how each component connects.

> ✅ **ADDRESSED (structure)**
> 
> **What we did:** Consolidated all proofs in the first appendix in proper order: the no-mass-point lemma, then Corollary 1, Corollary 2, Proposition 2, then Proposition 1. The reader no longer has to flip between three locations. Renamed "Online Appendix" to "Appendix" to match AEJ Micro's in-print/supplementary convention. The empirical supplementary appendix is kept as a separate document.
> 
> **Where in the paper:** Appendix A (Proofs and Analytic Derivations).
> 
> **Internal tracking:** commits `c3a8cf4`, `207d38f`.

### 2. Role and test of truthtelling

The assumption seems to be that employers will be truthful in the explicit treatment arm when their message is not shown to workers. The authors then compare this group to those whose messages are revealed. Finding no difference is interpreted as consistent with truthtelling, which justifies pooling the samples.

Comments:

a. The authors could emphasize that additional support for this assumption comes from the fact that the data validate several model predictions that rely on truthtelling.

> ✅ **ADDRESSED**
> 
> **What we did:** Added a three-sentence paragraph at the end of the Truth-telling subsection. It states that the downstream predictions on sorting, wages, and efficiency are all derived under truth-telling, so their empirical confirmation constitutes a second, independent anchor for the assumption alongside the incentive-compatibility argument in the theorem.
> 
> **Where in the paper:** End of the Truth-telling subsection (Section III.E), right after the bridge paragraph to the empirical section.
> 
> **Internal tracking:** commit `9235bc1`.

b. The choice to pool the sample is not always consistent: it is done after Figure 1, except in Figure 4, and again in Section V.E. A brief clarification would help.

> 🔴 **OPEN — awaiting framing call from PK + audit input from John**
> 
> **What we did:** Not yet addressed. Two dependencies before this can be resolved:
> 
> 1. **PK's framing call (R2 §2c below):** the rule to apply consistently depends on whether truth-telling is framed as a plausible behavioral assumption or as an imposed-then-justified assumption. Until §2c is settled, we cannot pick a pooling rule.
> 2. **John's empirical audit:** once the rule is set, someone needs to walk through Figure 1 (pooled), Figure 4 (not pooled), and Section V.E (pooled) and confirm what each currently does and why. John ran the empirical pipeline and is best positioned to say whether the inconsistency is a deliberate empirical choice or an oversight, and to re-run any specifications that need to change.
> 
> **Where in the paper:** Figures 1 and 4 and Section V.E.
> 
> **Internal tracking:** GitHub Issue #4 §2b (open, waiting on PK §2c + John audit).

c. The assumption of truthtelling should be stated more explicitly and consistently. The introduction presents it as a plausible behavioral assumption, while the main text treats it as an imposed assumption.

> 🔴 **OPEN — PK to address**
> 
> **What we did:** Not yet addressed. The two framings — intro treats truth-telling as a plausible behavioral assumption; theory body treats it as an imposed assumption later justified via incentive compatibility — need to speak with one voice. This item is routed to PK. It affects the intro narrative, the placement of the Kartik and Abeler et al. citations now in the bibliography, and the framing of the ex-post validation paragraph at the end of the Truth-telling subsection. Peyman will not pre-commit to a direction.
> 
> **Where in the paper:** Introduction and Truth-telling subsection (Section III.E).
> 
> **Internal tracking:** GitHub Issue #4 §2c (held for PK).

### 3. The second signal (ψ₂)

On p. 11, the authors assume the worker's second signal about the job is nearly perfectly revealing ("We assume a very precise second signal (ψ₂ close to 1)…"). In the model, this implies that workers have uncertainty about firm type when deciding where to apply, but almost none when making the wage offer.

> ✅ **ADDRESSED**
> 
> **What we did:** Added a paragraph at the end of the no-messages analysis explaining the role of the second signal in the wage equation. Wages depend on the lowest worker type in the applicant pool, and that lowest type is pinned down by the message and the first signal at the *application* stage, before the second signal is observed. So when the second signal later reveals the firm's type to the worker at the bidding stage, it resolves the firm's identity without altering the competition the worker faces.
> 
> **Where in the paper:** End of Section III.C (Analysis Without Cheap Talk).
> 
> **Internal tracking:** commits `1183eb0`, `3f3b5c0`.

Why not simplify the model by assuming the signal is perfectly revealing? With ψ₂ → 1, the message affects only sorting, not wage offers. In that case, the experiment should have no impact on wages conditional on worker-firm type. But the paper's Proposition 1 and empirical results both imply non-trivial wage effects from the message. Is there something subtle I'm missing?

> ✅ **ADDRESSED**
> 
> **What we did:** Added a new appendix subsection titled "Why We View the Second Signal as Imprecise" that explains the subtle point R2 was missing. If the second signal were literally perfect (ψ₂ = 1 exactly), a low-type firm that deviates to the high message could attract high-ability workers who, upon learning the firm's true type, would bid low — and this deviation would be profitable, breaking truth-telling incentive compatibility. So we treat the second signal as *almost* precise (ψ₂ close to 1 but strictly less), which keeps the model tractable while preserving IC.
> 
> **Where in the paper:** Appendix B.1 "Why We View the Second Signal as Imprecise."
> 
> **Internal tracking:** commit `b74b7a0`.

### Smaller comments

- The citation style is confusing. For instance, in the last paragraph of p. 2, it is unclear whether parenthetical citations refer to the same labor market studied in this paper or others. Similar ambiguity appears on p. 6 (Tadelis and Zettelmeyer).

> 🔴 **OPEN — held for PK's framing pass**
> 
> **What we did:** Not yet addressed. Citation style cleanup on p.2 and around the Tadelis-Zettelmeyer reference on p.6 is held pending PK's positioning paragraphs, since the framing PK picks will shape which citations need foregrounding.
> 
> **Where in the paper:** Introduction and Section II (Literature).
> 
> **Internal tracking:** GitHub Issue #3 (open).

- I did not understand the first full sentence on p. 25 ("This simplification of the model…").

> ✅ **ADDRESSED**
> 
> **What we did:** Rewrote the confusing sentence. The original had three ambiguities (what is "this simplification"; changes of what; levels of what). The new text spells out each referent: the simplification is the random-approach assumption in the theory, "changes" are the treatment effects within each tier, and "levels" are the baseline sorting that would exist without the message. The rewrite also explains *why* we model it this way: the model targets the change margin that the experimental variation identifies, and leaves baseline sorting from other channels to be absorbed into the control condition.
> 
> **Where in the paper:** Sorting subsection in the Results section (Section V.A).
> 
> **Internal tracking:** commit `c2f0ef1`.

- On p. 26, the authors might be clearer by continuing to use "prior cumulative earnings" instead of "experience."

> ✅ **ADDRESSED**
> 
> **What we did:** Changed "prior experience" to "prior cumulative earnings" where the $5,400 interpretation of the hired-worker coefficient appears, so the wording matches the rest of the section.
> 
> **Where in the paper:** Sorting subsection (Section V.A), discussion of hired-worker earnings.
> 
> **Internal tracking:** commit `5da3999`.

- The panels in Figure 5 are not ordered as described on p. 28.

> ✅ **VERIFIED — no change needed**
> 
> **What we did:** Extracted the text from the figure and verified that the panel order already matches the text (earnings on top, hours-worked on bottom). R2's flag appears to be stale, perhaps from an earlier version of the figure.
> 
> **Where in the paper:** Figure 5 (signal effects on experience) and surrounding text.
> 
> **Internal tracking:** verified via pdftotext sweep; no code change required.

- Clarify terminology in Proposition 1: sometimes "part," sometimes "bullet," sometimes "Part."

> ✅ **ADDRESSED**
> 
> **What we did:** Standardized the terminology so Proposition 1 and its cross-references uniformly use "part" throughout.
> 
> **Where in the paper:** Proposition 1 statement and all downstream references.
> 
> **Internal tracking:** commit `9c14d38`.

- Avoid "-Y% decrease" phrasing; use "Y% decrease."

> 🔴 **OPEN — John Horton to address**
> 
> **What we did:** Not yet addressed. The "-Y% decrease" phrasing comes from negative values in the automatically-generated LaTeX macros produced by the R analysis pipeline. The cleanest fix is in the R scripts (wrap the values in abs() so the minus sign does not propagate to the paper). Routed to John.
> 
> **Where in the paper:** Various places in the empirical section where percentage declines are reported.
> 
> **Internal tracking:** GitHub Issue #9 (open, pinged @johnjosephhorton).

- Typos on p. 28: an extra ")" after the Figure 3 reference; last sentence of the paragraph ends with "due in part to employers consider."

> ✅ **ADDRESSED**
> 
> **What we did:** Two items bundled here; both fixed:
> 
> 1. Extra ")" after the Figure 3 reference removed.
> 2. "Due in part to employers consider" fixed to "due in part to employers considering."
> 
> **Where in the paper:** Wages subsection (Section V.C).
> 
> **Internal tracking:** commits `5da3999` (stray ')'), `9c14d38` (verb fix).

- On p. 34, the authors describe expected wages. If data on outside options exist, it may be more relevant to study surplus rather than wages (though this is minor).

> 🔴 **OPEN — Horton, if pursuable**
> 
> **What we did:** Not yet addressed. Studying surplus rather than wages would require outside-options data; John needs to confirm whether such data are available and usable. R2 flagged this as minor.
> 
> **Where in the paper:** Section VI.
> 
> **Internal tracking:** deferred to response letter.

- On p. 10 ("market entry"), clarify whether u' is bounded or unbounded. Both statements seem to appear, and it is unclear whether this assumption is maintained throughout or only where needed.

> ✅ **ADDRESSED**
> 
> **What we did:** Rewrote the Market Entry paragraph to disambiguate two different "bounded/unbounded" claims that were confusing R2. The paper makes two separate claims about u that are compatible but were conflated in the original wording:
> 
> 1. **Maintained throughout the paper:** u is increasing and strictly convex, with Inada conditions u'(0)=0 and u'(a) → ∞ as a → ∞. In this sense u' itself is unbounded.
> 2. **Used only in specific proofs where needed:** the *elasticity* of u' is bounded away from zero and infinity. This restricts the *rate* at which u' grows, not u' itself, so it is compatible with the Inada condition.
> 
> The rewrite labels the first as "throughout" and the second as "only where specific proofs require it," and adds one clarifying sentence about the compatibility.
> 
> **Where in the paper:** Market Entry paragraph in the theory section (Section III.A).
> 
> **Internal tracking:** commit `95d7619`.

## R3 Report

This is a great and ambitious paper. It is sufficiently transparent that I don't feel the need to spend time summarizing it.

I don't have many comments; the paper is in great shape. However, I do have some notes on framing that I suspect stem from the fact that the literature has evolved somewhat since this paper was originally conceived (the experiment having been run, according to p.19, "from 2013-07-18 to 2013-12-05").

### Specific Comments

- p.6 – "Perhaps the closest related paper is Tadelis and Zettelmeyer (2015)…"
I see the connection to Tadelis and Zettelmeyer (2015), although I think there is another Tadelis paper that is also closely related — his more recent paper in JPE (Backus et al., 2019).

> 🟡 **PARTIALLY ADDRESSED — citation added, text awaiting PK**
> 
> **What we did:** Added the Backus, Blake, and Tadelis (2019, JPE) reference to the bibliography. The positioning paragraph that ties this reference into the Literature section is held for PK — connecting our contribution to the Backus-Blake-Tadelis framework is a framing call Peyman does not want to pre-commit to.
> 
> **Where in the paper:** Bibliography ready; Literature section text pending.
> 
> **Internal tracking:** bib entry added in-flight. Text-level incorporation open under GitHub Issue #3.

  - Tadelis and Zettelmeyer (2015) get improved match value first through the linkage principle, and then, motivated by the empirical findings, through additional entry. Note that the linkage principle is not incentive compatible; low types would prefer not to reveal their type, but they end up doing better through additional entry.

> 🔴 **OPEN — PK**
> 
> **What we did:** Not yet addressed. Distinguishing Tadelis-Zettelmeyer's linkage-principle mechanism from our incentive-compatible cheap-talk mechanism is a substantive framing call held for PK. This shapes how we describe both papers' contributions in the Literature section.
> 
> **Where in the paper:** Section II (Literature).
> 
> **Internal tracking:** GitHub Issue #3 (open, PK).

  - Backus, Blake, and Tadelis (2019) do not emphasize improved match value, but they do, like this paper, obtain incentive-compatible cheap talk and endogenous matching. Perhaps more helpfully for the empirical parts of this paper, they set out a framework for thinking about the empirical content of such equilibria, much of which is implicitly re-invented here. My main suggestion for improving this paper would be connecting it to that literature by outlining how the empirical evidence comports with the framework advanced there.

> 🟡 **PARTIALLY ADDRESSED — citation added, text awaiting PK**
> 
> **What we did:** The Backus-Blake-Tadelis citation is now in the bibliography. R3's main framing ask — an explicit paragraph connecting our empirical evidence to that paper's framework on the empirical content of incentive-compatible cheap talk — is held for PK. This is the flagship framing deliverable of the revision.
> 
> **Where in the paper:** Bibliography ready; Literature section and introduction text pending.
> 
> **Internal tracking:** bib entry added. Text-level incorporation open under GitHub Issue #3 (PK).

- p.18 – "The marketplace we study is not the only market for online work, and so it is important to keep in mind the 'market' versus 'marketplace' distinction made by Roth (2018)."
Please spell this out more clearly.

> ✅ **ADDRESSED**
> 
> **What we did:** Restructured the paragraph opening so Roth's terminology is defined explicitly and immediately connected to the multi-homing concern that follows. The new text says a "marketplace" is a specific institutional venue governed by particular rules (namely our platform), while a "market" is the set of all buyers and sellers who could potentially transact for the type of work in question (short-term remote labor). It then pivots to the concrete consequence: because we operate at the marketplace level, we need to worry about whether job openings we see are simultaneously posted elsewhere. The downstream survey-evidence sentences are left untouched (still waiting for John to clarify which survey is being cited).
> 
> **Where in the paper:** Opening of the Empirical Context section (Section IV.A).
> 
> **Internal tracking:** commit `45fc857`.

- p.19 – "In this arm, employees were then randomized to have their choice revealed or not."
I think of this as akin to the garbling device discussed in Backus et al. (2019), and the first, best example I know of using this to study signaling is Ambrus et al. (2018).

> 🟡 **PARTIALLY ADDRESSED — citations added, text awaiting PK**
> 
> **What we did:** Added the Ambrus, Chaney, and Salitskiy (2018, QE) reference to the bibliography, alongside the Backus-Blake-Tadelis reference added earlier. Framing our probabilistic-revelation arm as the garbling device in Backus et al. (2019), with Ambrus et al. (2018) as the first signaling application of this design, is PK's paragraph to write.
> 
> **Where in the paper:** Bibliography ready; Experimental Design section and Literature section text pending.
> 
> **Internal tracking:** bib entries added. Text-level incorporation open under GitHub Issue #3 (PK).

- Section V.A:
I did not find these results surprising.

> ✅ **ADDRESSED**
> 
> **What we did:** Moved the "Informative Messages" subsection (which R3 said was unsurprising) out of the main body and into the Empirical Appendix. Left a short two-paragraph summary in the body that frames the pooling question and reports the headline statistical test, with a pointer to the appendix for the figure and fuller discussion.
> 
> **Where in the paper:** Opening of Section V plus the new "Informative Messages: Evidence from the Explicit Arm" subsection in the Empirical Appendix.
> 
> **Internal tracking:** commit `c0ad729`.

- I have emphasized to the editor that the following is a suggestion for future work, and I would actively oppose requiring it for a revision. But I think there is a natural next paper here: to think about the optimal design of such a sorting mechanism.
I have written next to Section V.C: "This is great, but the kind of thing I would only care about if the authors were going to do the structural exercise…" That is to say, I think you should keep it in, but keep it as a signpost for someone else—or yourselves—to take up next time and think about estimating structural primitives in order to engage in the market design exercise.

> 🟣 **DECLINED — per R3's own suggestion**
> 
> **What we did:** Not pursued. R3 explicitly said this is a suggestion for future work and that they would "actively oppose requiring it for a revision." Section V.C remains in the paper as R3 suggested — as a signpost for future structural work — but we do not undertake the structural estimation exercise.
> 
> **Where in the paper:** No change (Section V.C kept intact).
> 
> **Internal tracking:** decision noted for the response letter.

### References

Ambrus, A., Chaney, E., and Salitskiy, I. (2018). Pirates of the Mediterranean: An Empirical Investigation of Bargaining with Asymmetric Information. Quantitative Economics, 9(1):217–246.

Backus, M., Blake, T., and Tadelis, S. (2019). On the Empirical Content of Cheap-Talk Signaling: An Application to Bargaining. Journal of Political Economy, 127(4):1599–1628.

Tadelis, S. and Zettelmeyer, F. (2015). Information Disclosure as a Matching Mechanism: Theory and Evidence from a Field Experiment. American Economic Review, 105(2):886–905.

Maybe move V.A. to Appendix?

> ✅ **ADDRESSED**
> 
> **What we did:** Editor's marginal note suggesting that Section V.A (Informative Messages) be moved to the appendix has been acted on. The subsection is now in the Empirical Appendix, with a short summary left in the body.
> 
> **Where in the paper:** Empirical Appendix.
> 
> **Internal tracking:** commit `c0ad729`.
