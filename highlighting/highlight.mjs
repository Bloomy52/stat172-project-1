import fs from 'node:fs';
import { createHighlighter, bundledLanguages } from 'shiki';

const grammar = JSON.parse(fs.readFileSync(new URL('./sas.json', import.meta.url)));
const highlighter = await createHighlighter({
  themes: ['github-light-default'], langs: [grammar],
});
const baseTheme = highlighter.getTheme('github-light-default');
await highlighter.loadTheme({
  ...baseTheme, name: 'disclosure-github-light',
  settings: [...baseTheme.settings,
    {scope: ['source.sas entity.name.class', 'source.sas constant.numeric', 'source.sas keyword.operator'], settings: {foreground: '#24292F'}},
  ],
});
const theme = 'disclosure-github-light';
const doc = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
const escape = text => text.replace(/[\\{}%&#_$^~]/g, char => ({
  '\\': '\\textbackslash{}', '{': '\\{', '}': '\\}', '%': '\\%',
  '&': '\\&', '#': '\\#', '_': '\\_', '$': '\\$',
  '^': '\\textasciicircum{}', '~': '\\textasciitilde{}',
}[char]));
const nameFor = index => 'GHStyle' + String.fromCharCode(65 + Math.floor(index / 26)) + String.fromCharCode(65 + index % 26);

async function visit(value) {
  if (Array.isArray(value)) return Promise.all(value.map(visit));
  if (!value || typeof value !== 'object') return value;
  if (value.t === 'CodeBlock') {
    const [attrs, code] = value.c;
    let lang = (attrs[1][0] || 'text').toLowerCase();
    if (lang !== 'sas' && !['text','plaintext','txt'].includes(lang)) {
      if (bundledLanguages[lang]) await highlighter.loadLanguage(bundledLanguages[lang]);
      else { console.error(`No highlighting grammar for ${lang}; using plain text.`); lang = 'text'; }
    }
    const { tokens } = highlighter.codeToTokens(code, {lang, theme});
    const styles = new Map();
    const lines = tokens.map(line => line.map(token => {
      const color = (token.color || '#24292F').replace('#', '');
      if (!/^[0-9a-f]{6}$/i.test(color)) throw new Error('Invalid token color');
      const style = token.fontStyle || 0;
      const key = `${color}:${style}`;
      if (!styles.has(key)) styles.set(key, {name: nameFor(styles.size), color, style});
      return `\\${styles.get(key).name}{${escape(token.content)}}`;
    }).join('')).join('\n');
    const definitions = [...styles.values()].map(({name,color,style}) => {
      const font = `${style & 1 ? '\\itshape' : ''}${style & 2 ? '\\bfseries' : ''}`;
      return `\\definecolor{${name}}{HTML}{${color}}\n\\newcommand{\\${name}}[1]{{\\color{${name}}${font}\\FancyVerbBreakStart#1\\FancyVerbBreakStop}}`;
    }).join('\n');
    return {t:'RawBlock',c:['latex', `\\begingroup
\\definecolor{shadecolor}{HTML}{F6F8FA}
\\definecolor{codeforeground}{HTML}{24292F}
${definitions}
\\color{codeforeground}
\\begin{Shaded}
\\begin{Highlighting}[]
${lines}
\\end{Highlighting}
\\end{Shaded}
\\endgroup`]};
  }
  const result = {};
  for (const [key, child] of Object.entries(value)) result[key] = await visit(child);
  return result;
}
fs.writeFileSync(process.argv[3], JSON.stringify(await visit(doc)));
highlighter.dispose();
