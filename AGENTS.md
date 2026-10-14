# AGENTS.md

## Project Context

This is the AI Council app repository — user-owned application code. Keep changes focused on the user's request and preserve existing project conventions.

Start with `README.md` for local setup and the publish workflow.

## Key Files

- `src/`: frontend application source.
- `src/api/client.js`: frontend platform SDK client (exposes `client.auth`, `client.entities`, `client.functions`).
- `src/lib/app-params.js`: reads the platform-injected app id / token values.
- `vite.config.js`: Vite config and the platform Vite plugin setup.
- `launcher.ps1` plus its double-clickable `.bat` wrapper in the project root: the local desktop launcher (starts the local backend and opens the app in a standalone window).
- `.env.local`: local-only environment values; never commit secrets.

## Working Notes

- The full local stack (backend + frontend together) is started by the platform CLI; `launcher.ps1` wires this up. `npm run dev` on its own serves only the frontend with no local backend behind it (every `/api` call is forwarded to the hosted app, or fails) — use it only for frontend-only work.
- Do NOT rename these fixed platform contracts, or the app breaks: the platform config directory in the project root (the one holding `config.jsonc` and `.app.jsonc`), the SDK package names in `package.json`, the `VITE_*` app-id/token env variables, the auth localStorage key, and the media CDN host / image `data-*` attributes.
- Reuse the existing SDK client (`src/api/client.js`) and Vite plugin patterns before adding new integration paths.
- Run the relevant checks from `package.json` (`lint`, `typecheck`, `build`) before finishing code changes.
