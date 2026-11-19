"""Compile and run lessons; require each deliberately broken lesson to fail.

Only Python's standard library and the installed ponyc are needed.
Run: python3 verify.py
"""
from pathlib import Path
import json
import subprocess
import sys

ROOT = Path(__file__).resolve().parent
BUILD = ROOT / '.build'
BUILD.mkdir(exist_ok=True)

EXPECTED = {
    '01-local': 'Pony lab: 1\n',
    '02-types': 'Pony lab: 1\nUnderstand unions\nPony lab: 1\n',
    '03-views': '1\n2\n',
    '04-freeze': '1\n1\n',
    '05-transfer': '2\n',
    '06-generics': '1\nPony lab\n',
    '07-trn-and-drain': '1\n1\n1\n0\n',
    '08-notes-cli': 'first\nsecond\nTotal: 2\n',
}
# Match the intended reason as well as a failing exit code.
REASONS = {
    '01-box-write': 'receiver type is not a subtype',
    '02-iso-alias': 'right side must be a subtype',
    '03-send-ref': 'this parameter must be sendable',
    '04-freeze-ref': 'right side must be a subtype',
    '05-use-after-consume': 'consumed',
    '06-leaking-getter': 'function body isn\'t the result type',
    '07-generic-getter': 'function body isn\'t the result type',
    '08-recover-capture': "can't recover to this capability",
}

def run(args):
    return subprocess.run(args, cwd=ROOT, text=True, capture_output=True, timeout=120)

def main():
    report = {'compiler': run(['ponyc', '--version']).stdout.strip(), 'checks': []}
    for name, output in EXPECTED.items():
        result = run(['ponyc', str(ROOT / 'examples' / name), '-o', str(BUILD), '-b', name, '-V', '0'])
        if result.returncode:
            sys.exit(result.stderr + result.stdout)
        args = [str(BUILD / name), '--ponymaxthreads=2']
        if name == '08-notes-cli':
            args += ['first', 'second']
        result = run(args)
        if result.returncode or result.stdout != output:
            sys.exit(f'{name}: expected {output!r}, got {result.stdout!r}\n{result.stderr}')
        if name == '08-notes-cli':
            usage = run([str(BUILD / name), '--ponymaxthreads=2'])
            if usage.returncode or usage.stdout != 'Usage: notes <note> [<note> ...]\n':
                sys.exit('CLI usage check failed')
        print(f'PASS {name}')
        report['checks'].append({'name': name, 'result': 'compiled and matched expected output'})
    for name, reason in REASONS.items():
        result = run(['ponyc', str(ROOT / 'failures' / name), '--pass', 'verify', '-V', '0'])
        diagnostic = result.stderr + result.stdout
        (BUILD / f'{name}.diagnostic.txt').write_text(diagnostic)
        if not result.returncode or reason not in diagnostic:
            sys.exit(f'{name}: expected failure containing {reason!r}\n{diagnostic}')
        print(f'PASS {name} rejected for intended reason')
        report['checks'].append({'name': name, 'result': 'rejected as intended'})
    (ROOT / 'verification.json').write_text(json.dumps(report, indent=2) + '\n')
    print('All 16 programs checked; CLI usage also checked.')

if __name__ == '__main__':
    main()
