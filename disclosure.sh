#!/usr/bin/env bash
# Usage: bash disclosure.sh input.md [output.pdf]
set -euo pipefail

die() { printf 'Error: %s\n' "$*" >&2; exit 1; }

if [[ $# -lt 1 || $# -gt 2 ]]; then
  printf 'Usage: bash %s input.md [output.pdf]\n' "$0" >&2
  exit 2
fi

input=$1
output=${2:-"${input%.*}.pdf"}
# Absolute paths also handle filenames that begin with a dash.
[[ "$input" = /* ]] || input="$PWD/$input"
[[ "$output" = /* ]] || output="$PWD/$output"
[[ -f "$input" && -r "$input" ]] || die "Cannot read: $input"
[[ "$output" = *.[pP][dD][fF] ]] || die 'Output filename must end in .pdf'
[[ ! -e "$output" ]] || die "Output already exists: $output (choose another filename)"
[[ -d "$(dirname "$output")" ]] || die 'Output directory does not exist'

for tool in pandoc tectonic node; do
  command -v "$tool" >/dev/null 2>&1 ||
    die "Missing $tool. On macOS with Homebrew: brew install pandoc tectonic node"
done

# Compile to a temporary file so a failed conversion leaves no partial PDF.
tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/disclosure-pdf.XXXXXX")
trap 'rm -rf "$tmpdir"' EXIT

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
[[ -d "$script_dir/node_modules/shiki" ]] || die "Install highlighting dependencies: npm --prefix \"$script_dir\" ci --ignore-scripts"

# Keep highlighting and wrapping compatible with Tectonic's older fvextra.
cat > "$tmpdir/wrapping.tex" <<'LATEX'
\usepackage{fvextra}
\usepackage{framed}
\usepackage{titlesec}
\usepackage{fancyhdr}
\definecolor{ink}{HTML}{243447}
\definecolor{accent}{HTML}{256C78}
\definecolor{shadecolor}{HTML}{F3F5F7}
\color{ink}
\renewcommand{\familydefault}{\sfdefault}
% Soft wraps are visual only: no arrows or other continuation symbols.
\fvset{breaklines=true,breakanywhere=true,breaksymbolleft={},breaksymbolright={},breakanywheresymbolpre={},breakanywheresymbolpost={},breakautoindent=false,breakindent=0pt,fontsize=\small}
\DefineVerbatimEnvironment{verbatim}{Verbatim}{}
\DefineVerbatimEnvironment{Highlighting}{Verbatim}{commandchars=\\\{\}}
% Shiki's generated token macros apply the wrapping hooks themselves.
\ifcsundef{Shaded}
  {\newenvironment{Shaded}{\begin{snugshade}}{\end{snugshade}}}
  {\renewenvironment{Shaded}{\begin{snugshade}}{\end{snugshade}}}
% Framed's shaded environment can continue across page boundaries.
\BeforeBeginEnvironment{verbatim}{\begin{snugshade}}
\AfterEndEnvironment{verbatim}{\end{snugshade}}
\titleformat{\section}{\Large\bfseries\color{ink}}{}{0pt}{}
\titleformat{\subsection}{\large\bfseries\color{accent}}{}{0pt}{}
\titleformat{\subsubsection}{\normalsize\bfseries\color{ink}}{}{0pt}{}
\titlespacing*{\section}{0pt}{0pt}{12pt}
\titlespacing*{\subsection}{0pt}{20pt}{8pt}
\titlespacing*{\subsubsection}{0pt}{14pt}{6pt}
\setlength{\parindent}{0pt}
\setlength{\parskip}{7pt}
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0.3pt}
\fancyfoot[L]{\footnotesize\color{accent}AI usage disclosure}
\fancyfoot[R]{\footnotesize\thepage}
\fancypagestyle{plain}{\fancyhf{}\fancyfoot[L]{\footnotesize\color{accent}AI usage disclosure}\fancyfoot[R]{\footnotesize\thepage}\renewcommand{\headrulewidth}{0pt}\renewcommand{\footrulewidth}{0.3pt}}
LATEX

# Run beside the Markdown file so relative image paths work.
(
  cd "$(dirname "$input")"
  pandoc "$input" --from=gfm+yaml_metadata_block --to=json --output="$tmpdir/source.json"
  node "$script_dir/highlighting/highlight.mjs" "$tmpdir/source.json" "$tmpdir/highlighted.json"
  pandoc "$tmpdir/highlighted.json" \
    --from=json \
    --standalone \
    --syntax-highlighting=none \
    --pdf-engine=tectonic \
    --include-in-header="$tmpdir/wrapping.tex" \
    --variable=documentclass:article \
    --variable=papersize:letter \
    --variable=geometry:margin=1in \
    --variable=fontsize:11pt \
    --variable=linestretch:1.08 \
    --variable=colorlinks:true \
    --variable=urlcolor:accent \
    --output="$tmpdir/disclosure.pdf"
)
mv -n "$tmpdir/disclosure.pdf" "$output"
[[ ! -e "$tmpdir/disclosure.pdf" ]] || die 'Output appeared during conversion; it was not overwritten'
printf 'Created: %s\n' "$output"
