# OmniScale permanent evidence-preservation fix

This build fixes the failure seen in `Gremmy Thoumeaux_import_preview (1).json`, where the VS deterministic skeleton was correct but most chunk-extracted effects ended with empty `evidenceIds`.

## What changed

- Added `src/battle/sourceEvidence.ts`.
- Builds a global MediaWiki named-ref registry from the entire pasted source, so self-closing refs such as `<ref name="Bleach576"/>` resolve even when their definition is in another chunk.
- Adds a named-reference legend to each fragment prompt without adding outside facts.
- Deterministically backfills only provenance after the LM returns an effect:
  - matches the returned effect to the exact source link/clause in the same fragment;
  - copies only a visible chapter/episode/ref or direct feat URL;
  - never changes effect wording and never invents evidence;
  - ambiguous/weak matches remain empty and Needs Review.
- Rejects prose accidentally emitted in the LM `source` field instead of turning feat sentences into fake evidence.
- Allows direct source/scan URLs as legitimate evidence when the pasted page has no chapter/episode citation for that feat.
- Preserves the existing VS deterministic identity/stats/equipment/weaknesses pipeline and two-stage battle engine.

## Validation added

`src/__tests__/sourceEvidence.test.ts` covers:
- named ref definition + self-closing ref resolution;
- fragment citation legends;
- exact citation recovery for separate effects on one MediaWiki line;
- direct scan URL provenance;
- replacing fake prose `source` values;
- end-to-end recovered source -> final evidence ID.

## Verification in this environment

- `tsc -p tsconfig.json --noEmit` passes.
- A direct compiled integration probe against the supplied Gremmy MediaWiki source resolves examples such as:
  - massive hand -> Bleach Chapter 576;
  - earth pillars -> Bleach Chapter 575;
  - metal dome -> Bleach Chapter 576;
  - durability amplification -> Bleach Chapter 573;
  - exact duplicate -> Bleach Chapter 576;
  - healing -> Bleach Chapter 574.
- Vitest could not start in this Linux sandbox because the uploaded Windows `node_modules` lacks the Linux Rolldown native binding. Run `npm install && npm test` on the user's Windows machine.

## Acceptance test

After extracting on Windows:
1. `npm install`
2. `npm test`
3. `npm run typecheck`
4. `npm run build`
5. restart `npm run dev`
6. hard refresh browser
7. delete old Gremmy profile and re-import the same full raw source

Expected: the deterministic VS stats remain correct and materially more effects receive real `evidenceIds`; genuinely uncited effects stay Needs Review rather than receiving invented citations.
