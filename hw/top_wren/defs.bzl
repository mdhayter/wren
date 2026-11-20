# Copyright lowRISC contributors (OpenTitan project).
# Copyright Mark Hayter.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#

load("@pavona_pavona//rules/pavona:hw.bzl", "pavona_top")
load("//hw/top_wren/data/autogen:defs.bzl", "WREN_INSTANCES", "WREN_IPS")

WREN = pavona_top(
    name = "wren",
    hjson = str(Label("//hw/top_wren/data/autogen:top_wren.gen.hjson")),
    top_lib = str(Label("//hw/top_wren/sw/autogen:top_wren")),
    test_pinout = str(Label("//hw/top_wren/sw:test_pinout")),
    # Execution environments by role, for pavona_test_envs().
    test_envs = {
        "sim_verilator": str(Label("//hw/top_wren:sim_verilator")),
    },
    # Environments the test ROM is built for.
    test_rom_envs = [
        str(Label("//hw/top_wren:fpga_genesys2")),
        str(Label("//hw/top_wren:sim_verilator_base")),
    ],
    # Host description, embedded in the host tools (//sw/host/ot_hal).
    host_desc = str(Label("//hw/top_wren/data:host_desc")),
    top_rtl = str(Label("//hw/top_wren:rtl_files")),
    # FuseSoC searches the top's directory for its cores.
    top_cores = str(Label("//hw/top_wren:cores")),
    top_verilator_core = ["lowrisc:dv:top_wren_chip_verilator_sim"],
    top_verilator_binary = {"binary": ["lowrisc_dv_top_wren_chip_verilator_sim_0.1/sim-verilator/Vchip_sim_tb"]},
    top_ld = str(Label("//hw/top_wren/sw/autogen:top_wren_memory")),
    # 64 KiB of flash: no room for the OTTF's non-volatile scratch and counters.
    ottf_no_nv_storage = True,
    # Bitstream splicing: no OTP, and the ROM takes the unscrambled 32-bit image.
    bitstream_splice = {"otp_size": 0, "rom_field": "rom32"},
    ips = WREN_IPS,
    instances = WREN_INSTANCES,
    secret_cfgs = {
        "testing": str(Label("//hw/top_wren/data/autogen:top_wren.secrets.testing.gen.hjson")),
    },
)
