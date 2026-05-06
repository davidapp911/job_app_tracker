#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── 1. Locate pip ────────────────────────────────────────────────────────────
if ! command -v pyenv &>/dev/null; then
    echo "Error: pyenv not found. Install it from https://github.com/pyenv/pyenv"
    exit 1
fi

PIP="$(pyenv which pip 2>/dev/null || true)"
if [[ -z "$PIP" ]]; then
    echo "Error: no pip found for the active pyenv version ($(pyenv global))."
    exit 1
fi

PYENV_BIN="$(dirname "$PIP")"

# ── 2. Ensure setuptools is available ────────────────────────────────────────
if ! "$PIP" show setuptools &>/dev/null; then
    echo "Installing setuptools..."
    "$PIP" install setuptools -q
fi

# ── 3. Install japp ──────────────────────────────────────────────────────────
echo "Installing japp..."
"$PIP" install -e "$SCRIPT_DIR" -q
echo "Package installed."

# ── 4. Add pyenv bin to PATH in ~/.zshrc (idempotent) ───────────────────────
ZSHRC="$HOME/.zshrc"
PATH_LINE="export PATH=\"$PYENV_BIN:\$PATH\""

if grep -qF "pyenv/versions/$(pyenv global)/bin" "$ZSHRC" 2>/dev/null; then
    echo "PATH already configured in ~/.zshrc."
else
    printf '\n%s\n' "$PATH_LINE" >> "$ZSHRC"
    echo "Added $PYENV_BIN to PATH in ~/.zshrc."
fi

# ── 5. Done ───────────────────────────────────────────────────────────────────
echo ""
echo "All done! Open a new terminal and run: japp --help"
