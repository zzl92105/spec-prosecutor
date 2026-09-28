#!/usr/bin/env python3
"""Validate distribution invariants, YAML, local references and version consistency."""
import json
import re
import subprocess
import sys
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
PLUGIN = ROOT / 'plugins/spec-prosecutor'
subprocess.run([sys.executable, str(ROOT / 'scripts/sync-metadata.py'), '--check'], check=True)
portable = json.loads((PLUGIN / 'plugin.json').read_text(encoding='utf-8'))
assert portable['name'] == PLUGIN.name == 'spec-prosecutor'
assert re.fullmatch(r'(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)', portable['version'])
assert portable['$schema'] == 'https://agent-plugins.org/schemas/1.0.0/plugin.schema.json'
assert portable['repository'].startswith('https://'), 'Repository must be an HTTPS URL'
assert not any(p.is_symlink() for p in PLUGIN.rglob('*')), 'Plugin must be self-contained'
for path in PLUGIN.rglob('SKILL.md'):
    text = path.read_text(encoding='utf-8')
    assert text.startswith('---\n')
    header = yaml.safe_load(text.split('---', 2)[1])
    assert header['name'] == path.parent.name
    assert isinstance(header['description'], str) and header['description'].strip()
    agent = yaml.safe_load((path.parent / 'agents/openai.yaml').read_text(encoding="utf-8"))
    assert agent['policy']['allow_implicit_invocation'] is True
    assert '$spec-prosecutor' in agent['interface']['default_prompt']
# Local Markdown links in maintained docs and the shipped plugin must resolve.
for path in [ROOT / 'README.md', *PLUGIN.rglob('*.md'), * (ROOT / 'docs/install').glob('*.md'),
             * (ROOT / 'docs/platform-guides').glob('*.md')]:
    for link in re.findall(r'\]\(([^)]+)\)', path.read_text(encoding='utf-8')):
        link = link.split('#', 1)[0]
        if not link or '://' in link or link.startswith('mailto:'):
            continue
        assert (path.parent / link).exists(), f'Broken link in {path}: {link}'
for case in (ROOT / 'tests/cases').iterdir():
    if case.is_dir():
        assert (case / 'prd.md').is_file() and (case / 'expected-report.md').is_file()
print('Distribution manifests, Skill YAML and references passed.')
