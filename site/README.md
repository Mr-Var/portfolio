# VAR Portfolio — web version

A React + Vite port of the Flutter portfolio in `../lib`. Same layout, content, animations and breakpoints.

## Run

    npm install
    npm run dev

## Build

    npm run build      # output in dist/

## Personalise

Edit the constants at the top of `src/App.jsx` (name, email, phone, links, skill tags).

## Figma frames

Drop exported PNG/JPG/WEBP frames into `src/assets/figma/<project>/` and rebuild. They replace the
decorative artwork automatically, as a draggable rail you can click to zoom.

## Deploy (Vercel)

The repo-root `vercel.json` installs and builds inside `site/` and serves `site/dist/`, so no dashboard changes are needed.

## Files

- `src/App.jsx` — page sections (nav, hero, skills, MedNU case study, websites, Figma, process, contact)
- `src/mednu.jsx` — the interactive MedNU app screens shown in the phone
- `src/frames.jsx` — phone and browser mockups, full-size site viewer
- `src/figma.jsx` — Figma card artwork and image rail
- `src/theme.jsx` — colours, type helpers, icons, animation helpers
