#!/bin/bash
# Copyright Mark Hayter.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Regenerate the Wren top out of tree, with the generators of the Pavona checkout next door.
# The same steps as `make -C hw top_and_cmdgen TOPS=top_wren` (hw/Makefile, `%_gen`), with the
# top directory here instead of under the checkout's hw/. Run in the checkout's venv:
#   source ../pavona/.venv/bin/activate && util/regen.sh
set -euo pipefail
WREN=$(cd "$(dirname "$0")/.." && pwd)
PRJ=$(cd "$WREN/../pavona" && pwd)
TOP=top_wren
D=$WREN/hw/$TOP
SEED_MODE=${SEED_MODE:-testing}
cfg=$D/data/autogen/$TOP.gen.hjson
seed=$D/data/autogen/$TOP.secrets.$SEED_MODE.gen.hjson

cd "$PRJ"
util/topgen.py -t "$D/data/$TOP.hjson" -s "$D/data/${TOP}_seed.$SEED_MODE.hjson" -o "$D/"
for ipgen in $(util/top_cm_and_blocks.py -t "$cfg" --filter ipgen get_blocks); do
  util/gen_top_ipconfigs.py --seedcfg "$seed" --ips "$ipgen" --outdir "$D/ip_autogen/$ipgen/data" -t "$cfg"
  util/ipgen.py generate -C "hw/ip_templates/$ipgen" --force --outdir "$D/ip_autogen/$ipgen" \
    --config-file "$D/ip_autogen/$ipgen/data/${TOP}_$ipgen.ipconfig.hjson"
done
for xbar in xbar_main xbar_peri xbar_mbx xbar_dbg; do
  util/gen_top_ipconfigs.py --ips "$xbar" --xbars -s "$seed" --outdir "$D/ip/$xbar/data/autogen" -t "$cfg"
  out=$D/ip/$xbar/data/autogen/$xbar.gen.hjson
  if [ -f "$out" ]; then util/tlgen.py --libname "$TOP" -t "$out" -o "$D/ip/$xbar"; else rm -rf "$D/ip/$xbar"; fi
done
util/gen_top_sv.py -t "$cfg" -s "$seed"
util/gen_top_docs.py -t "$cfg"
util/gen_top_sw.py -t "$cfg"
util/gen_top_host.py -t "$cfg" --top-dir "$D"

# Labels for this repository (see util/fix-labels.py).
python3 "$WREN/util/fix-labels.py" "$D"
