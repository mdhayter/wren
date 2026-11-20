# Copyright lowRISC contributors (OpenTitan project).
# Copyright Mark Hayter.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "sim_verilator",
    srcs = ["sim_verilator.c"],
    deps = [
        "@pavona_pavona//hw/top/dt:api",
        "@pavona_pavona//sw/device/lib/base:macros",
    ],
)

cc_library(
    name = "fpga_genesys2",
    srcs = ["fpga_genesys2.c"],
    deps = [
        "@pavona_pavona//hw/top/dt:api",
        "@pavona_pavona//sw/device/lib/base:macros",
    ],
)
