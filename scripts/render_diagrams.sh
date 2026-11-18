#!/usr/bin/env bash
# Renders every docs/diagrams/*.mmd to an SVG beside it. Run via `npm run diagrams`.
# Pass file paths to render only those diagrams.
set -euo pipefail

cd "$(dirname "$0")/.."
mmdc=node_modules/.bin/mmdc
[ -x "$mmdc" ] || { echo "Run 'npm install' first." >&2; exit 1; }

# Use a locally installed Chrome/Chromium unless puppeteer's own browser was installed
# (npm may block puppeteer's postinstall download).
if [ -z "${PUPPETEER_EXECUTABLE_PATH:-}" ]; then
  for browser in google-chrome-stable google-chrome chromium chromium-browser; do
    if command -v "$browser" >/dev/null; then
      export PUPPETEER_EXECUTABLE_PATH="$(command -v "$browser")"
      break
    fi
  done
fi

files=("$@")
[ ${#files[@]} -gt 0 ] || files=(docs/diagrams/*.mmd)

status=0
for source in "${files[@]}"; do
  if "$mmdc" --quiet --puppeteerConfigFile scripts/puppeteer.json --configFile scripts/mermaid.json \
       --backgroundColor white --input "$source" --output "${source%.mmd}.svg"; then
    echo "rendered ${source%.mmd}.svg"
  else
    echo "FAILED $source" >&2
    status=1
  fi
done
exit $status
