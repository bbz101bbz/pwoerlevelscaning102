# OmniScale-New v1

Clean VS judge: two character profiles -> battle packet -> LM Studio (OpenAI-compat) -> structured verdict.

## Run
```
cd omniscale-new
npm install
npm run dev   # http://localhost:3001
```
`run.bat` does the same.

## LM Studio Setup
1. Open LM Studio -> load a model (any instruct, e.g. Qwen2.5 7B+)
2. Start Local Server (port 1234 default)
3. In app: Settings -> baseUrl `http://localhost:1234/v1` -> Test Connection -> Save
4. Create 2 characters (or use seeded: Garou, Gremmy, Sukuna, Gojo) -> VS Battle -> RUN

Proxy: Vite proxies `/v1` to `http://localhost:1234` to avoid CORS. Direct URL also works.

## Project Structure
src/types/  character,battle,lm
src/battle/ buildBattlePacket, basicStatComparison
src/lm/     lmClient, battlePrompt, responseSchema
src/validation/ validateCharacter, validateLmVerdict
src/storage/ characterStore, lmSettingsStore
src/pages/  Characters, CharacterEditor, VsBattle, Settings
src/components/ DebugPanel

## Philosophy
Code validates IDs / JSON / sums, never hidden winner formula. LM is judge.

## Tests
npm test  # 17 tests
npm run typecheck
npm run build

## Known Limitations
- Stat comparison is display only, no numeric tier logic
- No claim splitting / source tiers (v1)
- EvidenceIds linking only, no file uploads
- LM must return strict JSON (fenced allowed)
