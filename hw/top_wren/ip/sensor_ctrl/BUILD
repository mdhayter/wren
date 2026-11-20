# Copyright lowRISC contributors (OpenTitan project).
# Copyright Mark Hayter.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "rtl_files",
    srcs = glob(
        ["**"],
        exclude = [
            "dv/**",
            "doc/**",
            "README.md",
            "BUILD",
        ],
        # Only the BUILD file is here; the data are in data/.
        allow_empty = True,
    ) + [
        "//hw/top_wren/ip/sensor_ctrl/data:all_files",
    ],
)
