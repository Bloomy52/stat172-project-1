# Highlighting sources

Shiki 4.4.3 supplies the GitHub Light Default theme and bundled language grammars.
The npm lockfile pins the dependency tree.

SAS source: https://github.com/rpardee/sas
Downloaded 2026-09-17 from `master/syntaxes/sas.tmLanguage`.
GitHub Linguist lists this repository (under its former `sas.tmbundle` name):
https://github.com/github-linguist/linguist/blob/main/vendor/README.md

`sas.tmLanguage` is the unmodified upstream source. Its MIT license is included
in `SAS-LICENSE`. `sas.json` is its plist-to-JSON conversion with these changes:

- Register the language as `sas`.
- Escape the bare caret alternative in the operator regex; otherwise its
  zero-width match prevents effective tokenization in this pipeline.
- Classify SET/UPDATE/MODIFY/MERGE as keywords for the reference's red color.
- Require a following opening parenthesis for the broad function-name rule,
  so a variable named `month` remains plain while `month(...)` is blue.

The theme uses dark foreground for SAS dataset names, numeric constants,
and operators to match the screenshot. Panels use #F6F8FA; the light theme was requested after the screenshot. These adaptations
make this a screenshot-matched GitHub-style theme, not a claim of exact parity
with every version of GitHub's hosted renderer.

## AI Use
After many tries with Codex, it finally created this script and its files since I didn't feel like creating it. 