#!/usr/bin/env bash
# Assemble the complete hemocell.eu site: the static pages of this repository
# plus the user guide built (Sphinx + Doxygen) from a HemoCell checkout.
#
# Usage: scripts/build-site.sh <path-to-HemoCell-checkout> [output-dir]
#
# The output directory defaults to ./_site and is replaced on every run.
# Requires doxygen, graphviz (dot) and the Python packages listed in
# <HemoCell>/doc/requirements.txt. Used by .github/workflows/pages.yml.
set -euo pipefail

usage="usage: $0 <path-to-HemoCell-checkout> [output-dir]"
hemocell=$(cd "${1:?$usage}" && pwd)
out=${2:-_site}
site=$(cd "$(dirname "$0")/.." && pwd)

for tool in doxygen dot sphinx-build rsync make; do
    command -v "$tool" >/dev/null || { echo "error: '$tool' not found" >&2; exit 1; }
done

mkdir -p "$out"
out=$(cd "$out" && pwd)
case "$out" in
    / | "$site" | "$hemocell") echo "error: refusing to use '$out' as output directory" >&2; exit 1 ;;
esac

# Sphinx runs Doxygen itself (see doc/user_guide/conf.py in HemoCell).
make -C "$hemocell/doc/user_guide" clean html

rm -rf "$out"
mkdir -p "$out"
rsync -a \
    --exclude .git --exclude .github --exclude .claude --exclude .gitignore \
    --exclude scripts --exclude README.md --exclude /_site --exclude /user_guide \
    "$site/" "$out/"
# -L: the Doxygen pages are linked into the Sphinx output via a symlink
cp -RL "$hemocell/doc/user_guide/_build/html" "$out/user_guide"

echo "Site assembled in $out ($(du -sh "$out" | cut -f1))"
