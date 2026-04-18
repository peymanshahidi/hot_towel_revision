# Report absolute value of parameters in auto-generated LaTeX macros

## Summary
Numerical point estimates in `hot_towel.tex` are populated from LaTeX parameter macros emitted by the `analysis/params_*.R` scripts via `JJHmisc::genParamAdder`. When an estimated coefficient is negative, the macro carries the minus sign through to the draft, producing awkward phrasings such as "a decrease of -18%" or "a decline of -7%." R2 explicitly flagged this in the smaller comments.

Fix belongs in the code, not in the tex: the draft should always read "a decrease of Y%" and let the *word* carry the sign. The cleanest way is to have the `addParam` calls wrap negative values in `abs()` before writing them to `params_*.tex`, rather than patching every call site in the text.

## Referee source
From R2 (smaller comments):
> - Avoid "-Y% decrease" phrasing; use "Y% decrease."

Flagged at the same bullet level as the p.26 "prior cumulative earnings," the p.28 stray ")", and the Figure 5 panel-order issue. See `referee_reports/Hot Towel - AEJ Micro Revision.docx` (Dropbox: https://www.dropbox.com/scl/fi/e0qn6j6sn12x7upwoly04/Hot-Towel-AEJ-Micro-Revision.docx?rlkey=ej0cr5o8sxcwp6qmlo0uvtqro&dl=0).

## Files
- Macro-generating scripts: `analysis/params_exp_details.R`, `analysis/params_chi_square.R`, and any other `analysis/params_*.R` or `analysis/co_*.R` that call `addParam` / `genParamAdder` with percentage-change quantities.
- Generated macros: `writeup/params_*.tex` (do not hand-edit; these are build artifacts).
- Consumer: `writeup/hot_towel.tex` — the macros are interpolated into running text via `\MacroName{}`.

## Keep in mind
- Fixing only the tex (e.g., hardcoding `18\%` instead of `\MacroName{}`) is brittle: the next re-run of the analysis will re-introduce the sign. The invariant has to live in the R code.
- Some macros legitimately carry sign (e.g., a raw regression coefficient printed in a results table). Only macros that get read out loud as "a decrease/decline/drop of X%" should be absolute-valued. Rule of thumb: if the accompanying English word already conveys direction, strip the sign.
- After editing the R scripts, re-run the macro pipeline (`make params` or the relevant script) and recompile `hot_towel.tex`. Confirm nothing reads "decrease of -X%" or "decline of -X%" anywhere in the manuscript.

## Actionable items (for @johnjosephhorton)

- [ ] Audit every `addParam(...)` call in `analysis/params_*.R` and `analysis/co_*.R` that produces a percentage-change-style value.
- [ ] Wrap the value in `abs(...)` for any macro that is consumed in text as "a {decrease, decline, drop, fall, reduction} of \MacroName{}\%."
- [ ] Leave sign untouched for macros that are consumed in signed contexts (tables, or prose that says "a coefficient of \MacroName{}").
- [ ] Re-run the macro pipeline and recompile `writeup/hot_towel.tex`.
- [ ] Grep the compiled tex for residual `of -` / `by -` / `-\d+\\%` patterns as a sanity check.

## Source
R2 smaller comments (see `referee_reports/Hot Towel - AEJ Micro Revision.docx`).

## Owner
John Horton (code owner for the `analysis/` pipeline).
