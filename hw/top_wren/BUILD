# Copyright lowRISC contributors (OpenTitan project).
# Copyright Mark Hayter.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load(
    "@pavona_pavona//rules/pavona:defs.bzl",
    "DEFAULT_TEST_FAILURE_MSG",
    "DEFAULT_TEST_SUCCESS_MSG",
    "fpga_genesys2",
    "sim_verilator",
)

package(default_visibility = ["//visibility:public"])

# The Egret files that Wren's cores use, not the whole of Egret: an edit
# elsewhere in hw/top_egret (its software, say) would otherwise rebuild
# Wren's Verilator model and bitstream. These are the cores
# lowrisc:systems:top_egret_padring, lowrisc:systems:top_egret_physical_pads,
# lowrisc:egret_systems:scan_role_pkg, lowrisc:egret_ip:alert_handler_pkg and
# lowrisc:egret_constants:top_pkg, and the ones they depend on in Egret
# (lowrisc:systems:top_egret_pkg). Also Egret's testing lc_ctrl token
# package (lowrisc:egret_constants:testing_lc_ctrl_token_pkg): Wren has no
# lc_ctrl, but top_wren depends on lowrisc:ip:lc_ctrl for its types, which
# needs a provider of lowrisc:virtual_constants:lc_ctrl_token_pkg.
# Keep in step with those cores.
filegroup(
    name = "egret_rtl_files",
    srcs = [
        "@pavona_pavona//hw/top_egret/ip_autogen/alert_handler/rtl:alert_handler_pkg.sv",
        "@pavona_pavona//hw/top_egret/ip_autogen/alert_handler/rtl:alert_handler_reg_pkg.sv",
        "@pavona_pavona//hw/top_egret/ip_autogen/alert_handler:alert_handler_pkg.core",
        "@pavona_pavona//hw/top_egret:lint/padring.waiver",
        "@pavona_pavona//hw/top_egret:lint/top_egret_pkg.vlt",
        "@pavona_pavona//hw/top_egret:lint/top_egret_pkg.waiver",
        "@pavona_pavona//hw/top_egret:padring.core",
        "@pavona_pavona//hw/top_egret:physical_pads.core",
        "@pavona_pavona//hw/top_egret:rtl/autogen/testing/lc_ctrl_token_pkg.sv",
        "@pavona_pavona//hw/top_egret:rtl/autogen/testing/top_egret_testing_lc_ctrl_token_pkg.core",
        "@pavona_pavona//hw/top_egret:rtl/autogen/top_egret_pkg.sv",
        "@pavona_pavona//hw/top_egret:rtl/padring.sv",
        "@pavona_pavona//hw/top_egret:rtl/physical_pads.sv",
        "@pavona_pavona//hw/top_egret:rtl/scan_role_pkg.sv",
        "@pavona_pavona//hw/top_egret:rtl/top_pkg.sv",
        "@pavona_pavona//hw/top_egret:scan_role_pkg.core",
        "@pavona_pavona//hw/top_egret:top_egret_pkg.core",
        "@pavona_pavona//hw/top_egret:top_pkg.core",
    ],
)

filegroup(
    name = "rtl_files",
    # Only what FuseSoC and Verilator read, so that editing a BUILD file, defs.bzl or the
    # documentation does not resynthesize the bitstream.
    srcs = glob(
        [
            "*.core",
            "lint/**",
            "rtl/**",
            "util/**",
        ],
    ) + [
        ":egret_rtl_files",
        "//hw/top_wren/data:all_files",
        "//hw/top_wren/dv/verilator:all_files",
        "//hw/top_wren/ip:rtl_files",
    ],
    visibility = ["//visibility:public"],
)

# A core file in this directory, so that FuseSoC searches it for Wren's cores.
filegroup(
    name = "cores",
    srcs = ["top_wren.core"],
)

filegroup(
    name = "doc_files",
    srcs = glob(
        [
            "**/*.md",
            "**/*.hjson",
            "**/*.html",
        ],
        allow_empty = True,
        exclude_directories = 0,
    ) + [
        "//hw/top_wren/data:doc_files",
    ],
    visibility = ["//visibility:public"],
)

###########################################################################
# Sim Verilator Environments
#
# The sim_verilator_base target is only meant to be used for building ROMs
# and other items without `testonly=True`.
#
# Copied (and modified) from hw/top_egret/BUILD. Wren has no OTP, and its
# Verilator model loads an unscrambled ROM image (`rom32`). Its test
# programs boot from the test ROM with no ROM_EXT, so there is no slot
# layout.
###########################################################################
sim_verilator(
    name = "sim_verilator_base",
    design = "wren",
    exec_env = "sim_verilator",
    libs = [
        "@pavona_pavona//sw/device/lib/arch:boot_stage_rom_ext",
        "@pavona_pavona//sw/device/lib/arch:sim_verilator",
        "//hw/top_wren/sw/dt:sim_verilator",
    ],
    linker_script = "@pavona_pavona//sw/device/lib/testing/test_framework:ottf_ld_silicon_creator_slot_a",
    test_cmd = "testing-not-supported",
)

sim_verilator(
    name = "sim_verilator",
    testonly = True,
    args = [
        "--rcfile=",
        "--logging=info",
        "--top=wren",
        "--interface=verilator",
        "--verilator-bin=$(rootpath @pavona_pavona//hw:verilator)",
        "--verilator-rom={rom:rom32}",
        "--verilator-flash={firmware}",
    ],
    base = ":sim_verilator_base",
    data = [
        "@pavona_pavona//hw:fusesoc_ignore",
        "@pavona_pavona//hw:verilator",
    ],
    exec_env = "sim_verilator",
    param = {
        "exit_success": DEFAULT_TEST_SUCCESS_MSG,
        "exit_failure": DEFAULT_TEST_FAILURE_MSG,
    },
    rom = "@pavona_pavona//sw/device/lib/testing/test_rom:test_rom",
    test_cmd = """
        --exec="console --non-interactive --exit-success='{exit_success}' --exit-failure='{exit_failure}'"
        no-op
    """,
)

###########################################################################
# FPGA Genesys 2 Environments
#
# The fpga_genesys2 target is only meant to be used for building ROMs and
# other items without `testonly=True`.
#
# Tests run through the board's FT2232H (interface `ftdi_genesys2`, with Wren's
# pins in sw/ftdi_genesys2.json5): load the bitstream over JTAG (skipped when the
# ROM reports the same bitstream already loaded), bootstrap over spi_device, then
# the console.
###########################################################################
fpga_genesys2(
    name = "fpga_genesys2",
    design = "wren",
    exec_env = "fpga_genesys2",
    libs = [
        "@pavona_pavona//sw/device/lib/arch:boot_stage_rom_ext",
        "//hw/top_wren/sw/arch:fpga_genesys2",
        "//hw/top_wren/sw/dt:fpga_genesys2",
    ],
    linker_script = "@pavona_pavona//sw/device/lib/testing/test_framework:ottf_ld_silicon_creator_slot_a",
    test_cmd = "testing-not-supported",
)

fpga_genesys2(
    name = "fpga_genesys2_test_rom",
    testonly = True,
    args = [
        "--rcfile=",
        "--logging=info",
        "--top=wren",
        "--interface={interface}",
        # The label names this repository: Pavona's tests expand it in their own packages.
        "--conf=$(rootpath @@//hw/top_wren/sw:ftdi_genesys2.json5)",
    ],
    base = ":fpga_genesys2",
    base_bitstream = "//hw/top_wren/bitstream:genesys2_bitstream",
    data = ["//hw/top_wren/sw:ftdi_genesys2.json5"],
    exec_env = "fpga_genesys2_test_rom",
    mmi = "//hw/top_wren/bitstream:genesys2_mmi",
    param = {
        "interface": "ftdi_genesys2",
        "exit_success": DEFAULT_TEST_SUCCESS_MSG,
        "exit_failure": DEFAULT_TEST_FAILURE_MSG,
    },
    rom = "@pavona_pavona//sw/device/lib/testing/test_rom:test_rom",
    test_cmd = """
        --exec="transport init"
        --exec="fpga load-bitstream {bitstream}"
        --exec="bootstrap --clear-uart=true {firmware}"
        --exec="console --non-interactive --exit-success='{exit_success}' --exit-failure='{exit_failure}'"
        no-op
    """,
)
