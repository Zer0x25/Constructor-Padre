#!/usr/bin/env bash
# Constructor validation, independent of the mold/product governance phases.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
bash -n "$ROOT/scripts/tests/verify-derivative.sh"
bash -n "$ROOT/scripts/verify-distribution.sh"
bash "$ROOT/Spring-0/scripts/verify.sh"
bash "$ROOT/scripts/tests/verify-derivative.sh"
bash "$ROOT/Spring-0/scripts/prepare-derivative.sh" "$TMP/derived"
# seed gate runs the real lifecycle pilot, including two recovery scenarios.
bash "$TMP/derived/scripts/verify.sh"
printf 'Distribution verified: mold → seed → initializing → project; temporary fixtures removed on exit.\n'
