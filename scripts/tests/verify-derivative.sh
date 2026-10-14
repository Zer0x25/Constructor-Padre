#!/usr/bin/env bash
# Adversarial export checks; all destinations are temporary, no remote calls.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SOURCE="$ROOT/Spring-0"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
prepare="$SOURCE/scripts/prepare-derivative.sh"
expect_reject() {
  if bash "$prepare" "$1" > "$TMP/rejection.log" 2>&1; then
    printf 'FAIL: destination accepted: %s\n' "$1" >&2; exit 1
  fi
  grep -q 'DERIVATION ERROR:' "$TMP/rejection.log"
}
expect_reject "$SOURCE"
mkdir "$TMP/foreign"
printf 'preserve\n' > "$TMP/foreign/STATE.md"
expect_reject "$TMP/foreign"
[[ "$(cat "$TMP/foreign/STATE.md")" == preserve ]]
ln -s "$SOURCE" "$TMP/source-link"
expect_reject "$TMP/source-link"
expect_reject "$SOURCE/derived-child"
[[ ! -e "$SOURCE/derived-child" ]]
child="$TMP/new project"
bash "$prepare" "$child"
grep -qx 'phase=seed' "$child/.agents/project-profile.conf"
grep -q '^source_commit=' "$child/.agents/mold-origin.conf"
grep -Eq '^content_sha256=[0-9a-f]{64}$' "$child/.agents/mold-origin.conf"
! grep -q 'Seed 016\|Commit: pendiente' "$child/STATE.md"
[[ "$(git -C "$child" rev-parse --show-toplevel)" == "$child" ]]
[[ ! -e "$child/.git/modules" ]]
# Repeated preparation is a no-op, including after initialization or sealing.
for phase in seed initializing project; do
  sed -i "s/^phase=.*/phase=$phase/" "$child/.agents/project-profile.conf"
  printf 'user checkpoint %s\n' "$phase" >> "$child/STATE.md"
  before="$(sha256sum "$child/STATE.md" "$child/.agents/project-profile.conf" "$child/.agents/mold-origin.conf")"
  bash "$prepare" "$child"
  [[ "$before" == "$(sha256sum "$child/STATE.md" "$child/.agents/project-profile.conf" "$child/.agents/mold-origin.conf")" ]]
done
# Independent local source: tracked worktree edits are exported, local secrets are not.
git clone --quiet --no-hardlinks "$SOURCE" "$TMP/source"
cp "$prepare" "$TMP/source/scripts/prepare-derivative.sh"
printf '\nLOCAL_TRACKED_CHANGE\n' >> "$TMP/source/README.md"
printf 'LOCAL_SECRET_FIXTURE\n' > "$TMP/source/.env"
printf 'LOCAL_UNTRACKED_FIXTURE\n' > "$TMP/source/private-note.txt"
bash "$TMP/source/scripts/prepare-derivative.sh" "$TMP/filtered"
grep -q LOCAL_TRACKED_CHANGE "$TMP/filtered/README.md"
[[ ! -e "$TMP/filtered/.env" && ! -e "$TMP/filtered/private-note.txt" ]]
# An incomplete source cannot leave a partially initialized destination.
rm "$TMP/source/AGENTS.md"
if bash "$TMP/source/scripts/prepare-derivative.sh" "$TMP/incomplete" > "$TMP/incomplete.log" 2>&1; then
  printf 'FAIL: incomplete source accepted\n' >&2; exit 1
fi
grep -q 'AGENTS.md' "$TMP/incomplete.log"
[[ ! -e "$TMP/incomplete" ]]
[[ -z "$(find "$TMP" -maxdepth 1 -name '.spring-0-export.*' -print)" ]]
printf 'derivative checks: destination safety, seed, provenance and repetition passed.\n'
