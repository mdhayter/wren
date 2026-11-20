# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
load("@pavona_pavona//rules/pavona:hw.bzl", "pavona_ip")

AST = pavona_ip(
    name = "ast",
    hjson = "@pavona_pavona//hw/top_egret/ip/ast/data:ast.hjson",
    regs = "@pavona_pavona//hw/top_egret/ip/ast/rtl:regs",
)
