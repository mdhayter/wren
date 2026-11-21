# Copyright Mark Hayter.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Tests of Wren on its boards, built from Pavona's test sources. Pavona's own test
# targets ask for execution environments by role (sim_dv, sim_verilator), which
# give Wren only its Verilator environment; the board environments are named here.

load("@pavona_pavona//rules/pavona:defs.bzl", "pavona_test")

package(default_visibility = ["//visibility:public"])

pavona_test(
    name = "hello_world",
    srcs = ["@pavona_pavona//sw/device/examples/hello_world:hello_world.c"],
    copts = [
        # Disable the date-time warning only for the hello world program.
        "-Wno-date-time",
    ],
    exec_env = {
        "//hw/top_wren:fpga_genesys2_test_rom": None,
    },
    deps = [
        "@pavona_pavona//hw/top/dt",
        "@pavona_pavona//sw/device/lib/arch:device",
        "@pavona_pavona//sw/device/lib/dif:uart",
        "@pavona_pavona//sw/device/lib/runtime:print_uart",
        "@pavona_pavona//sw/device/lib/testing/test_framework:check",
        "@pavona_pavona//sw/device/lib/testing/test_framework:ottf_start",
        "@pavona_pavona//sw/device/lib/testing/test_framework:ottf_test_config",
    ],
)
