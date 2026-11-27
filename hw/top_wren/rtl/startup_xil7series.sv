// Copyright Mark Hayter.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Drive the configuration clock pin (CCLK) from user logic on a 7-series
// FPGA. CCLK stays a dedicated pin after configuration, so a SPI host that
// talks to the configuration flash reaches it only through STARTUPE2.
// The first three clock edges after the end of startup switch CCLK over to
// USRCCLKO and do not reach the pin (UG470), so the first transfer after
// configuration loses them.

module startup_xil7series (
  input logic usrcclk_i,   // Clock for the CCLK pin
  input logic usrcclk_en_i // Drive CCLK; it is tri-stated otherwise
);

  STARTUPE2 #(
    .PROG_USR("FALSE"),
    .SIM_CCLK_FREQ(0.0)
  ) u_startup (
    .CFGCLK(),
    .CFGMCLK(),
    .EOS(),
    .PREQ(),
    .CLK(1'b0),
    .GSR(1'b0),
    .GTS(1'b0),
    .KEYCLEARB(1'b1),
    .PACK(1'b0),
    .USRCCLKO(usrcclk_i),
    .USRCCLKTS(~usrcclk_en_i),
    .USRDONEO(1'b1),
    .USRDONETS(1'b1)
  );

endmodule // startup_xil7series
