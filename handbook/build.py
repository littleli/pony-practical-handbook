"""Rebuild the self-contained handbook from prose and the checked Pony files."""
from pathlib import Path
import html
import re

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
content = (HERE / 'content.html').read_text()

def example(match):
    name = match[1]
    path = f'examples/{name}/main.pony'
    code = html.escape((ROOT / path).read_text())
    return f'<figure class="program"><figcaption><a href="../{path}">{path}</a><button class="copy" type="button">Copy code</button></figcaption><pre><code>{code}</code></pre></figure>'

def failure(match):
    name = match[1]
    path = f'failures/{name}/main.pony'
    code = html.escape((ROOT / path).read_text())
    diagnostic = (ROOT / '.build' / f'{name}.diagnostic.txt').read_text().replace(str(ROOT) + '/', '')
    return f'<details class="failure"><summary>{html.escape(name)}</summary><p><a href="../{path}">Open broken source</a></p><pre><code>{code}</code></pre><p class="diagnostic-label">Actual compiler diagnostic</p><pre class="diagnostic"><code>{html.escape(diagnostic)}</code></pre></details>'

content = re.sub(r'\{\{example:([^}]+)\}\}', example, content)
content = re.sub(r'\{\{failure:([^}]+)\}\}', failure, content)
sections = re.findall(r'<section id="([^"]+)" data-title="([^"]+)">', content)
links = ''.join(f'<a href="#{id}">{title}</a>' for id, title in sections)
css = (HERE / 'style.css').read_text()
js = (HERE / 'reader.js').read_text()
out = f'''<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="description" content="A connected Pony type system and reference capabilities handbook with compiled examples, exercises and real compiler diagnostics."><title>Pony · A practical handbook</title><style>{css}</style></head>
<body><a class="skip" href="#main">Skip to handbook</a>
<aside><a class="brand" href="#start">PONY<span>THE PRACTICAL HANDBOOK</span></a><nav aria-label="Chapters">{links}</nav><p class="side-note">One connected example.<br>Read · predict · run · explain.</p><button type="button" id="print">Print / save PDF</button></aside>
<main id="main">{content}<footer>Built from local source files. Working examples and intentional failures checked by <a href="../verify.py">verify.py</a>. Use your browser’s Find command to search the full handbook.</footer></main>
<div id="copy-status" role="status" aria-live="polite"></div><script>{js}</script></body></html>'''
(HERE / 'index.html').write_text(out)
assert '{{' not in out, 'Unexpanded content placeholder'
print(f'Built {HERE / "index.html"}: {len(out.encode()):,} bytes, {len(sections)} chapters')
