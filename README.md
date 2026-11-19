# Pony: a practical handbook

Read [the handbook online](https://littleli.github.io/pony-practical-handbook/handbook/).

The [local handbook](handbook/index.html) is a self-contained HTML file that also works offline. To run the examples or edit the material, clone the repository:

```sh
git clone https://github.com/littleli/pony-practical-handbook.git
cd pony-practical-handbook
```

Open `handbook/index.html` in a browser, or serve the repository locally with:

```sh
python3 -m http.server 8765 --bind 127.0.0.1
```

Then visit <http://127.0.0.1:8765/handbook/>.

The guide uses Java/Kotlin comparisons and one evolving notebook application. It covers the type system, all six reference capabilities, receivers, aliases, `consume`, `recover`, viewpoint adaptation, generics, actor boundaries and compiler errors. It includes exercises with expandable answers and a printable desk reference. The print button expands answers and diagnostics.

Each `examples/` directory is an independent, complete program. Each `failures/` directory is deliberately invalid and illustrates one error; keep them separate from working programs.

```sh
mkdir -p .build
ponyc examples/01-local -o .build -b local
./.build/local

# Eight working programs, eight intended failures, plus CLI usage.
python3 verify.py
```

Validated using the installed Pony 0.78.2 on macOS ARM64. No external Pony packages are required. Python 3 is used only for verification and handbook generation. Verification logs and binaries go in `.build/`; a completed verification run writes `verification.json`.

To update the handbook, edit `handbook/content.html`, `handbook/style.css`, or `handbook/reader.js`. The builder embeds the actual Pony source files and captured diagnostics so the displayed programs match the checked ones:

```sh
python3 verify.py
python3 handbook/build.py
```

Official reference links appear beside the relevant explanations. Standalone illustrative snippets and exercise edits are labeled separately from the eight verified example packages.
