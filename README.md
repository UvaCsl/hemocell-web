# HemoCell-web
Website repository for HemoCell, published at https://hemocell.eu.

## Deployment

The site is deployed to GitHub Pages by the workflow in
`.github/workflows/pages.yml` on every push to `main`, nightly, and on demand
(Actions → Deploy website → Run workflow).

The user guide (`/user_guide/`) is **not** stored in this repository. The
workflow builds it with Sphinx and Doxygen from the `dev` branch of
[UvaCsl/HemoCell](https://github.com/UvaCsl/HemoCell/tree/dev) and adds it to
the static pages of this repository before publishing.

## Building locally

With `doxygen`, `graphviz` and the Python packages from
`<HemoCell>/doc/requirements.txt` installed:

```bash
scripts/build-site.sh /path/to/HemoCell _site
python3 -m http.server --directory _site
```

Note that HemoCell's Doxygen configuration skips any path containing
`/build`, `/doc/`, `/tmp`, … (see `EXCLUDE_PATTERNS` in
`doc/doxygen/config.xml`), so build from a HemoCell checkout whose path does
not contain those.
