#!/usr/bin/env bash
# detect-test-framework.sh
# Detects the project's test framework(s) on session start.
# This is informational only — always exits 0.

detected=()

# --- JavaScript / TypeScript ---
if [ -f "package.json" ]; then
  pkg=$(cat package.json 2>/dev/null)

  if echo "$pkg" | grep -q '"jest"'; then
    detected+=("jest")
  fi

  if echo "$pkg" | grep -q '"vitest"'; then
    detected+=("vitest")
  fi

  if echo "$pkg" | grep -q '"mocha"'; then
    detected+=("mocha")
  fi

  if echo "$pkg" | grep -q '"ava"'; then
    detected+=("ava")
  fi
fi

# --- Python ---
if [ -f "pytest.ini" ] || [ -f "conftest.py" ]; then
  detected+=("pytest")
elif [ -f "setup.cfg" ] && grep -q '\[tool:pytest\]' setup.cfg 2>/dev/null; then
  detected+=("pytest")
elif [ -f "pyproject.toml" ] && grep -q '\[tool\.pytest' pyproject.toml 2>/dev/null; then
  detected+=("pytest")
elif [ -f "pyproject.toml" ] && grep -q 'pytest' pyproject.toml 2>/dev/null; then
  detected+=("pytest")
fi

# --- Go ---
if [ -f "go.mod" ]; then
  detected+=("go test")
fi

# --- Rust ---
if [ -f "Cargo.toml" ]; then
  detected+=("cargo test")
fi

# --- Ruby ---
if [ -f "Gemfile" ]; then
  gemfile=$(cat Gemfile 2>/dev/null)

  if echo "$gemfile" | grep -q 'rspec'; then
    detected+=("rspec")
  fi

  if echo "$gemfile" | grep -q 'minitest'; then
    detected+=("minitest")
  fi
fi

# --- Output results ---
if [ ${#detected[@]} -eq 0 ]; then
  echo "No test framework detected. Tests plugin is available — specify a framework when generating tests."
else
  frameworks=$(IFS=', '; echo "${detected[*]}")
  echo "Detected test framework(s): ${frameworks}. Tests plugin is ready."
fi

exit 0
