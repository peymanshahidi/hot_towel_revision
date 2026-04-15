# Rewrite model section from PK standalone-theory backup

## Summary
The editor's #1 condition for publication is a cleaner, self-contained model section. Rewrite the theory body so it contains **only FOCs + comparative statics**; move everything else (robustness, second signal, defensive writing) to the appendix. Start from `writeup/hot_towel_backup.tex` (PK 2022-03-28 / 2023-02-10 standalone-theory backup) — don't iterate on the current submission.

## Files
- Base: `writeup/hot_towel_backup.tex`
- Current (for reference, don't edit): `writeup/hot_towel.tex`
- Diff between the two: `revision_notes/Version_Comparison_Backup_vs_Current.docx`
- Base PDF already compiled: `writeup/hot_towel_backup.pdf`

## Keep in mind
- AEJ Micro accepts only two appendix types: **main (in-print)** and **supplementary**. The current "Online Appendix" must be split into these.
- Body + main appendix together must be self-contained. A reader should not need the supplementary to follow Proposition 1.
- Body should read as a sketch a directed-search theorist can fill in from FOCs.
- Page limits apply — verify compliance at the end.

## Actionable items

### Setup (from PK backup)
- [ ] Confirm with Philipp whether `hot_towel_backup.tex` (2023-02-10 version) is indeed the intended starting point, or whether the simpler 2022-03-15 version (without the $s$ signal) is what he meant
- [ ] Branch/copy `hot_towel_backup.tex` → `writeup/hot_towel.tex` once confirmed
- [ ] Remove the current `hot_towel.tex` theory section contents before pasting

### Body structure
- [ ] Split theory into (i) technical body with FOCs + comp statics only, (ii) separate intuition subsection
- [ ] Remove all defensive/hedging passages ("we are not aiming for maximum generality", alternative production functions, etc.)
- [ ] Introduce truthtelling **before** Proposition 1 (move §III.C earlier)
- [ ] Define "large market" precisely (continuum of firms/jobs?)
- [ ] Clarify Poisson-distribution-at-each-firm assertion
- [ ] Clarify whether $u'$ is bounded or unbounded at market entry
- [ ] Clarify why $s_1$ is needed — if only to generate baseline sorting, consider dropping

### Appendix relocation
- [ ] Move "Model Omissions, Extensions and Robustness" subsection to appendix
- [ ] Move second signal ($s_2$ / $\psi_2$) discussion to appendix (still needed for comp statics, so keep available)
- [ ] Move alternative-production-function discussion to appendix
- [ ] Restructure current Online Appendix sections into in-print vs. supplementary
- [ ] Verify supplementary appendix is actually attached at resubmission (editor couldn't find it last time)

### Model-section minor items (will mostly be subsumed by rewrite, verify after)
- [ ] p. 8: drop repeated "salient"; cut standard point (2); cut or rephrase first part of point (3)
- [ ] p. 9: clarify $a$ is nonnegative real; define subscript $T$ on $v_T$ (consider lowercase $t$); replace $\delta$ (probability) with $p$; clarify "in principle firms could have…"
- [ ] p. 10: address whether more difficult jobs imply disutility
- [ ] p. 10 (bottom): properly introduce "multiple exogenous signals" and outside-options paragraph
- [ ] p. 11: trim footnote 8 citations; "can reject" → "rejects"
- [ ] p. 12: "message off-equilibrium" → "message off the equilibrium path"; fix footnote 11 bracket; use ":=" consistently
- [ ] p. 13: clarify "meaningful mass points"; trim Proposition 1 first-sentence repetition
- [ ] p. 15: clarify whether "generically fails" is formal genericity
- [ ] Footnote 13: use "I" for intermediate instead of "Medium"
- [ ] Proposition 1: standardize "part" / "bullet" / "Part"
- [ ] Improve the graphical intuition figure in the main appendix

### Final checks
- [ ] Verify body reads as FOCs + comp statics only (no long derivations)
- [ ] Verify body + main appendix self-contained
- [ ] Verify page-length guidelines met
- [ ] Compile cleanly; no missing bib entries (currently `shimer2005cyclical` is missing)

## Source
Editor's Letter §1 (a-d), R2 §1, meeting decisions A.2-A.3.

## Owner
Peyman. Coauthor input needed for the $\psi_2$ wage-effect paradox (see separate issue).
