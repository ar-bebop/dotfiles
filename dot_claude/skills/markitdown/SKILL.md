---
name: markitdown
description: Use when asked to convert, extract, or "turn into markdown" a PDF, Word/DOCX, PowerPoint/PPTX, Excel/XLSX/XLS, Outlook .msg, EPUB, ZIP, image, or audio file. Do NOT use for plain text, Markdown, CSV, JSON, XML, or HTML — read those directly, no conversion needed.
---

# markitdown

## Overview

Convert binary / complex documents to Markdown using Microsoft's `markitdown`, run on demand via `uvx`. **Nothing is installed system-wide** — `uvx` executes the tool in a throwaway environment and only caches downloaded wheels under `~/.cache/uv`.

## When to use

Route through markitdown (the user cannot easily read these directly):

- **Documents:** `.pdf`, `.docx`, `.pptx`, `.xlsx`, `.xls`, `.msg` (Outlook), `.epub`
- **Archives:** `.zip` (expanded and converted recursively)
- **Media:** images (`.jpg/.jpeg/.png/.gif/.webp`), audio (`.mp3/.wav/.m4a/.flac`)

**Do NOT use markitdown for** `.txt`, `.md`, `.csv`, `.json`, `.xml`, `.html/.htm` — read those with the Read tool directly. No download needed, faster.

**Never** `pip install markitdown` system-wide or into a global environment. Always go through `uvx`.

## How to run

```bash
uvx --from 'markitdown[EXTRA]' markitdown INPUT -o OUTPUT.md
```

- Always **quote** `'markitdown[...]'` so the shell doesn't glob the brackets.
- Default: write `OUTPUT.md` next to the input with the same basename. Omit `-o` to print to stdout for a quick peek.
- `uvx` auto-fetches a compatible Python; nothing beyond `uvx` needs to be present.

## Picking EXTRA (by input extension)

| Extension | EXTRA |
|---|---|
| `.pdf` | `[pdf]` |
| `.docx` | `[docx]` |
| `.pptx` | `[pptx]` |
| `.xlsx` | `[xlsx]` |
| `.xls` | `[xls]` |
| `.msg` | `[outlook]` |
| audio (`.mp3/.wav/.m4a/.flac`) | `[audio-transcription]` — heavy download, **confirm with the user first** |
| images, `.epub`, `.zip` | *(none — omit the `[EXTRA]`, just `'markitdown'`)* |

Converting several formats at once? Combine extras: `'markitdown[pdf,docx]'`.

## If a dependency is missing

markitdown raises `MissingDependencyException` and prints the exact extra it needs (e.g. `pip install markitdown[pdf]`). Re-run with that extra added to `--from`. **Do not fall back to `[all]`** — it pulls in Azure SDKs and heavy models you don't need.

## Keeping the cache clean

Each distinct extra you use adds one small environment to `~/.cache/uv`; the markitdown core and shared deps are stored once and reused (no duplicate copies).

- Drop only unused entries: `uv cache prune`
- Remove markitdown entirely: `uv cache clean markitdown`

## Caveats

- **Audio** transcription pulls large dependencies — always confirm before running.
- **Images** mainly yield EXIF/metadata; OCR/vision extraction is limited.
- **`.zip`** is expanded and every contained file is converted in place.
