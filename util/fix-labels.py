#!/usr/bin/env python3
# Copyright Mark Hayter.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
"""Make the labels in Wren's Bazel files work from this repository.

Pavona's generators write every label as "//...", as for a top inside Pavona. Here "//" is this
repository (pavona_wren), so:
- in BUILD files, a label outside hw/top_wren becomes "@pavona_pavona//...";
- in .bzl files, a load() outside hw/top_wren becomes "@pavona_pavona//...", and a string label
  becomes "@pavona_pavona//..." or, for one inside hw/top_wren, str(Label("//hw/top_wren/...")),
  since Pavona's rules resolve these strings in their own repository.
Idempotent; symlinks (files shared with the Pavona checkout) are left alone.
"""
import re
import sys
from pathlib import Path

OWN = "hw/top_wren"
PAVONA = "@pavona_pavona//"

# A label string "//pkg..." not already qualified with a repository.
LABEL = re.compile(r'(?<![@\w])"//([^"]*)"')
LOAD = re.compile(r'(\bload\(\s*)"//([^"]*)"')
STR_LABEL = re.compile(r'(?<!Label\()"//([^"]*)"')


def own(path: str) -> bool:
    return path == OWN or path.startswith(OWN + "/") or path.startswith(OWN + ":")


def fix_build(text: str) -> str:
    def sub(m):
        path = m.group(1)
        if own(path) or path.startswith("visibility:"):
            return m.group(0)
        return f'"{PAVONA}{path}"'
    return LABEL.sub(sub, text)


def fix_bzl(text: str) -> str:
    def load(m):
        path = m.group(2)
        return m.group(0) if own(path) else f'{m.group(1)}"{PAVONA}{path}"'
    text = LOAD.sub(load, text)
    out = []
    for line in text.splitlines(keepends=True):
        if re.match(r'\s*load\(', line) or line.lstrip().startswith("#"):
            out.append(line)
            continue

        def sub(m):
            path = m.group(1)
            if own(path):
                return f'str(Label("//{path}"))'
            if path.startswith("visibility:"):
                return m.group(0)
            return f'"{PAVONA}{path}"'
        out.append(STR_LABEL.sub(sub, line))
    return "".join(out)


def main():
    root = Path(sys.argv[1] if len(sys.argv) > 1 else Path(__file__).parents[1] / OWN)
    changed = 0
    for p in sorted(root.rglob("*")):
        if p.is_symlink() or not p.is_file():
            continue
        if p.name in ("BUILD", "BUILD.bazel"):
            fix = fix_build
        elif p.suffix == ".bzl":
            fix = fix_bzl
        else:
            continue
        old = p.read_text()
        new = fix(old)
        if new != old:
            p.write_text(new)
            changed += 1
    print(f"fix-labels: {changed} files changed under {root}")


if __name__ == "__main__":
    main()
