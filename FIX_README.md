# OmniScale fixed source

This package contains the repaired source tree. It intentionally excludes `node_modules` and `dist` so it is small and platform-neutral.

## Main fixes

- Raw VS Battles / MediaWiki pages are detected deterministically even when labels use wiki markup such as `'''[[Attack Potency]]:'''`.
- Identity, stats, equipment and weaknesses come from deterministic parsing for VS-style pages instead of a generic LM full-profile import.
- Long VS pages use the deterministic VS skeleton first and chunk only ability/notable-technique text, preventing the 8192-token full-profile truncation failure.
- Long non-VS sources automatically fall back to compact fragment extraction after a real truncation instead of asking you to manually shorten the paste.
- MediaWiki ability hierarchy is respected better so nested techniques do not become duplicate top-level abilities.
- Exact duplicate ability/effect text is merged conservatively; evidence is unioned rather than double-counted.
- Evidence sanitation rejects ordinary feat prose as if it were a chapter/episode citation.
- Battle readiness blocks effect-less demo/seed profiles before Stage 1, so they cannot create empty interaction matrices.
- Existing two-stage battle judging, fighter-aware coverage, canonical probability, and transport diagnostics are preserved.

## Install on Windows

1. Back up your current OmniScale folder.
2. Extract this ZIP into a new folder.
3. In that folder run:

   npm install
   npm test
   npm run typecheck
   npm run build
   npm run dev

4. In LM Studio, load your model and keep Thinking / Reasoning OFF for OmniScale.
5. Hard-refresh the browser (`Ctrl+Shift+R`).
6. Re-import characters from source text. Do not reuse old demo/seed characters for battle acceptance tests because they may have abilities without effect-level data.

## Important accuracy rule

Multi-form VS pages remain intentionally strict. If deterministic form/stat attribution is ambiguous, import each form/key separately rather than guessing and merging stats into the wrong form.

## Verification performed here

- TypeScript project check (`tsc -b --noEmit`) passes on the fixed source.
- Direct runtime checks against the supplied raw Gremmy MediaWiki source confirm VS detection, identity/stat/equipment/weakness parsing, stat exclusion from ability chunks, and successful six-fragment merge without duplicate top-level ability names.
- A mocked generic long source that truncates its first full-profile request successfully falls back to fragments and imports.

Full Vitest/Vite execution could not be run in this Linux environment using the uploaded Windows-native `node_modules`; run the commands above on your Windows machine after `npm install`.
