# Copyright lowRISC contributors (OpenTitan project).
# Copyright Mark Hayter.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("@pavona_pavona//rules/pavona:defs.bzl", "PAVONA_CPU")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_files",
    srcs = glob(["**"]),
)

# The opentitantool configuration of Wren on the Genesys 2 (the pins of its reset
# and straps), on top of the board's built-in ftdi_genesys2 configuration.
exports_files(["ftdi_genesys2.json5"])

# Which pads test software uses: see sw/device/lib/testing/test_pinout.h.
cc_library(
    name = "test_pinout",
    srcs = ["test_pinout.c"],
    target_compatible_with = [PAVONA_CPU],
    deps = [
        "@pavona_pavona//hw/top/dt",
        "@pavona_pavona//sw/device/lib/arch:device",
        "@pavona_pavona//sw/device/lib/dif:pinmux",
        "@pavona_pavona//sw/device/lib/testing:test_pinout_intf",
        "@pavona_pavona//sw/device/lib/testing/test_framework:check",
    ],
)
