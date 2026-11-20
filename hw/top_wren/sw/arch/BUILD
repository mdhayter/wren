# Copyright Mark Hayter.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

package(default_visibility = ["//visibility:public"])

# Device library for Wren's Genesys 2 build: its clock frequencies.
cc_library(
    name = "fpga_genesys2",
    srcs = ["device_fpga_genesys2.c"],
    deps = [
        "@pavona_pavona//sw/device/lib/arch:device",
        "@pavona_pavona//sw/device/lib/arch:uart",
        "@pavona_pavona//sw/device/lib/base:macros",
        "@pavona_pavona//sw/device/silicon_creator/lib/drivers:ibex",
    ],
)
