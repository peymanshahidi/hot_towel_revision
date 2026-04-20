#!/usr/bin/env python3
"""
Build a Markdown response-tracker from the referee reports.
Mirrors the .docx tracker but renders as GitHub-flavored Markdown
so it can be read, edited, and diffed like any other source file.
"""
from pathlib import Path
from docx import Document
from docx.oxml.ns import qn

# Reuse the same RESPONSES dict as the docx builder so the two views
# stay in sync. Import by executing the sibling script's dict.
import importlib.util


def list_info(paragraph):
    """Return (is_list, ilvl) for a paragraph. ilvl is 0 for top-level bullets."""
    pPr = paragraph._p.find(qn("w:pPr"))
    if pPr is None:
        return (False, 0)
    numPr = pPr.find(qn("w:numPr"))
    if numPr is None:
        return (False, 0)
    ilvl_el = numPr.find(qn("w:ilvl"))
    val = ilvl_el.get(qn("w:val")) if ilvl_el is not None else "0"
    try:
        return (True, int(val))
    except ValueError:
        return (True, 0)

HERE = Path(__file__).parent
SRC_DOCX = HERE / "Hot Towel - AEJ Micro Revision.docx"
DST_MD = HERE / "Hot Towel - AEJ Micro Revision - Response Tracker.md"
SIBLING = HERE / "build_response_tracker.py"

spec = importlib.util.spec_from_file_location("tracker_docx", SIBLING)
mod = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mod)
RESPONSES = mod.RESPONSES


# Status emoji mapping — match the docx color legend
def status_emoji(status: str) -> str:
    s = status.upper()
    if s.startswith("ADDRESSED") or s.startswith("VERIFIED"):
        return "✅"
    if s.startswith("PARTIALLY"):
        return "🟡"
    if s.startswith("DECLINED"):
        return "🟣"
    return "🔴"  # OPEN


def render_response(entry: dict) -> str:
    """Render a response entry as a Markdown blockquote callout."""
    emoji = status_emoji(entry.get("status", ""))
    lines = [f"> {emoji} **{entry.get('status', '—')}**"]
    lines.append(f"> ")
    lines.append(f"> **What:** {entry.get('what', '')}")
    if entry.get("location"):
        lines.append(f"> ")
        lines.append(f"> **Location:** {entry['location']}")
    if entry.get("commit"):
        lines.append(f"> ")
        lines.append(f"> **Commit / Issue:** {entry['commit']}")
    return "\n".join(lines)


def md_escape(text: str) -> str:
    """Light escaping so referee text doesn't accidentally render as markup."""
    # Escape leading # so paragraphs that start with '#' aren't mistaken for headings.
    if text.lstrip().startswith("#"):
        text = "\\" + text
    return text


def main():
    src = Document(SRC_DOCX)
    out = []

    # Header block
    out.append("# Hot Towel — AEJ Micro Revision Response Tracker")
    out.append("")
    out.append(
        "_Running document mapping every editor/referee comment to our revision status, "
        "where the fix lives in the paper, and the commit / issue reference. "
        "Edit this file directly to add new responses or update existing ones; "
        "the sibling `.docx` version is regenerated from `build_response_tracker.py`._"
    )
    out.append("")
    out.append(
        "**Status legend:** "
        "✅ addressed / verified · "
        "🟡 partially addressed (open items remain) · "
        "🔴 open (awaiting coauthor input or further work) · "
        "🟣 declined per referee's own suggestion."
    )
    out.append("")
    out.append("---")
    out.append("")

    paragraphs = list(src.paragraphs)

    # Heading level map (collapse H3 and H4 into nested markdown levels)
    # We keep Title=##, H1=##, H2=###, H3=###, H4=####, List as bullet
    heading_md = {
        "Title": "##",
        "Heading 1": "##",
        "Heading 2": "###",
        "Heading 3": "###",
        "Heading 4": "####",
    }

    for i, p in enumerate(paragraphs):
        txt = p.text.strip()
        if not txt:
            out.append("")
            # Still check for a response anchored to a blank index (rare, skip)
            continue

        style = p.style.name if p.style else "Normal"
        is_list, ilvl = list_info(p)

        if is_list:
            indent = "  " * ilvl
            out.append(f"{indent}- {md_escape(txt)}")
        elif style == "Subtitle":
            out.append(f"_{md_escape(txt)}_")
        elif style in heading_md:
            out.append(f"{heading_md[style]} {md_escape(txt)}")
        else:
            out.append(md_escape(txt))

        # Inline response if this paragraph has one
        if i in RESPONSES:
            out.append("")
            out.append(render_response(RESPONSES[i]))

        out.append("")

    # Clean up multiple consecutive blank lines
    cleaned = []
    prev_blank = False
    for line in out:
        is_blank = (line == "")
        if is_blank and prev_blank:
            continue
        cleaned.append(line)
        prev_blank = is_blank

    DST_MD.write_text("\n".join(cleaned) + "\n", encoding="utf-8")
    print(f"Wrote {DST_MD}")


if __name__ == "__main__":
    main()
