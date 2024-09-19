// Copyright (c) 2020 Sonal Pinto
// SPDX-License-Identifier: Apache-2.0

/*
Kronos: Zero Degree

Kronos-powered SoC designed for the iCE40UP5K

  - 128KB of RAM as 2 contiguous banks of 64KB.
  - 1KB Bootrom for loading program from flash to RAM.
  - UART TX with 128B buffer.
    - Configurable baud rate
  - SPI Master with 256B RX/TX buffers.
    - Configurable SPI Mode and rate.
    - Max 12MHz.
  - 12 Bidirectional configurable GPIO.
    - Debounced inputs.
  - General Purpose registers

The bootrom, and two 64KB banks of main memory are individually arbitrated.
The Kronos Instruction Bus and Data Bus can access different parts of
the memory simultaneously without halting each other. They can access the
entire memory, and only need to be arbitrated if they are accessing the same
section.

But, usually, most of the code should be run from bank0, while frequent data 
like the stack will be in bank1. In a design without cache, this setup
will lead to optimal performance.

*/

module krz_top (
  input  logic    RSTN,
  output logic    TX,
  output logic    SCLK,
  output logic    MOSI,
  input  logic    MISO,
  inout  wire     GPIO0,
  inout  wire     GPIO1,
  inout  wire     GPIO2,
  inout  wire     GPIO3,
  inout  wire     GPIO4,
  inout  wire     GPIO5,
  inout  wire     GPIO6,
  inout  wire     GPIO7,
  inout  wire     GPIO8,
  inout  wire     GPIO9,
  inout  wire     GPIO10,
  inout  wire     GPIO11
);

logic clk, rstz;
logic [1:0] reset_sync;
logic rstz_sync;
logic [7:0] reset_counter;

logic [31:0] instr_addr;
logic [31:0] instr_data;
logic instr_req;
logic instr_ack;
logic [31:0] data_addr;
logic [31:0] data_rd_data;
logic [31:0] data_wr_data;
logic [3:0] data_mask;
logic data_wr_en;
logic data_req;
logic data_ack;

// ----------------------------
logic [23:0] bootrom_addr;
logic [31:0] bootrom_rd_data;
logic bootrom_en;

logic [23:0] mem0_addr;
logic [31:0] mem0_rd_data;
logic [31:0] mem0_wr_data;
logic mem0_en;
logic mem0_wr_en;
logic [3:0] mem0_mask;

logic [23:0] mem1_addr;
logic [31:0] mem1_rd_data;
logic [31:0] mem1_wr_data;
logic mem1_en;
logic mem1_wr_en;
logic [3:0] mem1_mask;

logic [23:0] sys_adr;
logic [31:0] sys_rdat;
logic [31:0] sys_wdat;
logic sys_we;
logic [3:0] sys_sel;
logic sys_stb;
logic sys_ack;

// ----------------------------
logic [5:0] perif_adr;
logic [2:0][31:0] perif_rdat;
logic [31:0] perif_wdat;
logic perif_we;
logic [2:0] perif_stb;
logic [2:0] perif_ack;

logic gpreg_stb, gpreg_ack;
logic uart_stb, uart_ack;
logic spim_stb, spim_ack;

logic [31:0] gpreg_dat;
logic [7:0] uart_dat;
logic [7:0] spim_dat;

// ----------------------------
logic [11:0] gpio_dir;
logic [11:0] gpio_write;
logic [11:0] gpio_read;

logic [11:0] uart_prescaler;
logic uart_tx_clear;
logic [7:0] uart_tx_size;

logic [7:0] spim_prescaler;
logic spim_cpol;
logic spim_cpha;
logic spim_tx_clear;
logic spim_rx_clear;
logic [7:0] spim_tx_size;
logic [7:0] spim_rx_size;


// ============================================================
// Clock and Reset
// ============================================================

// 24MHz internal oscillator
HSOSC #(.CLKHF_DIV ("0b01")) u_osc (
  .CLKHFPU(1'b1),
  .CLKHFEN(1'b1),
  .CLKHF  (clk) 
);

// synchronize reset, and a tiny 5us glitch filter
always_ff @(posedge clk or negedge RSTN) begin
  if (~RSTN) reset_sync <= '0;
  else reset_sync <= {reset_sync[0], RSTN};
end
assign rstz_sync = reset_sync[1];

always_ff @(posedge clk_sync) begin
  if (~rstz_sync) reset_counter <= '0;
  else if (~reset_counter[7]) reset_counter <= reset_counter + 1'b1;
end
assign rstz = reset_counter[7];

// ============================================================
// Kronos
// ============================================================

kronos_core #(
  .BOOT_ADDR(32'h0),
  .FAST_BRANCH(1),
  .EN_COUNTERS(1),
  .EN_COUNTERS64B(0),
  .CATCH_ILLEGAL_INSTR(1),
  .CATCH_MISALIGNED_JMP(0),
  .CATCH_MISALIGNED_LDST(0)
) u_core (
  .clk               (clk         ),
  .rstz              (rstz        ),
  .instr_addr        (instr_addr  ),
  .instr_data        (instr_data  ),
  .instr_req         (instr_req   ),
  .instr_ack         (instr_ack   ),
  .data_addr         (data_addr   ),
  .data_rd_data      (data_rd_data),
  .data_wr_data      (data_wr_data),
  .data_mask         (data_mask   ),
  .data_wr_en        (data_wr_en  ),
  .data_req          (data_req    ),
  .data_ack          (data_ack    ),
  .software_interrupt(1'b0        ),
  .timer_interrupt   (1'b0        ),
  .external_interrupt(1'b0        )
);

// ============================================================
// Primary Crossbar and Memory
// ============================================================

krz_xbar u_xbar (
  .clk            (clk             ),
  .rstz           (rstz            ),
  .instr_addr     (instr_addr[23:0]),
  .instr_data     (instr_data      ),
  .instr_req      (instr_req       ),
  .instr_ack      (instr_ack       ),
  .data_addr      (data_addr[23:0] ),
  .data_rd_data   (data_rd_data    ),
  .data_wr_data   (data_wr_data    ),
  .data_mask      (data_mask       ),
  .data_wr_en     (data_wr_en      ),
  .data_req       (data_req        ),
  .data_ack       (data_ack        ),
  .bootrom_addr   (bootrom_addr    ),
  .bootrom_rd_data(bootrom_rd_data ),
  .bootrom_en     (bootrom_en      ),
  .mem0_addr      (mem0_addr       ),
  .mem0_rd_data   (mem0_rd_data    ),
  .mem0_wr_data   (mem0_wr_data    ),
  .mem0_en        (mem0_en         ),
  .mem0_wr_en     (mem0_wr_en      ),
  .mem0_mask      (mem0_mask       ),
  .mem1_addr      (mem1_addr       ),
  .mem1_rd_data   (mem1_rd_data    ),
  .mem1_wr_data   (mem1_wr_data    ),
  .mem1_en        (mem1_en         ),
  .mem1_wr_en     (mem1_wr_en      ),
  .mem1_mask      (mem1_mask       ),
  .sys_adr_o      (sys_adr       ),
  .sys_dat_i      (sys_rdat       ),
  .sys_dat_o      (sys_wdat       ),
  .sys_we_o       (sys_we        ),
  .sys_sel_o      (sys_sel       ),
  .sys_stb_o      (sys_stb       ),
  .sys_ack_i      (sys_ack       )
);

generic_rom #(.AWIDTH(24), .KB(1)) u_bootrom (
  .clk    (clk            ),
  .addr   (bootrom_addr   ),
  .rdata  (bootrom_rd_data),
  .en     (bootrom_en     )
);

ice40up_sram64K #(.AWIDTH(24)) u_mem0 (
  .clk  (clk         ),
  .addr (mem0_addr   ),
  .wdata(mem0_wr_data),
  .rdata(mem0_rd_data),
  .en   (mem0_en     ),
  .wr_en(mem0_wr_en  ),
  .mask (mem0_mask   )
);

ice40up_sram64K #(.AWIDTH(24)) u_mem1 (
  .clk  (clk         ),
  .addr (mem1_addr   ),
  .wdata(mem1_wr_data),
  .rdata(mem1_rd_data),
  .en   (mem1_en     ),
  .wr_en(mem1_wr_en  ),
  .mask (mem1_mask   )
);

// ============================================================
// System
// ============================================================

// System Bus
krz_sysbus u_sysbus (
  .clk        (clk       ),
  .rstz       (rstz      ),
  .sys_adr_i  (sys_adr   ),
  .sys_dat_i  (sys_wdat  ),
  .sys_dat_o  (sys_rdat  ),
  .sys_we_i   (sys_we    ),
  .sys_stb_i  (sys_stb   ),
  .sys_ack_o  (sys_ack   ),
  .perif_adr_o(perif_adr ),
  .perif_dat_i(perif_rdat),
  .perif_dat_o(perif_wdat),
  .perif_we_o (perif_we  ),
  .perif_stb_o(perif_stb ),
  .perif_ack_o(perif_ack )
);

assign {spim_stb, uart_stb, gpreg_stb} = perif_stb;
assign perif_ack = {spim_ack, uart_ack, gpreg_ack};

assign perif_rdat[0] = gpreg_dat;
assign perif_rdat[1] = {24'h0, uart_dat};
assign perif_rdat[2] = {24'h0, spim_dat};


// General Purpose Registers
krz_gpreg u_gpr (
  .clk           (clk           ),
  .rstz          (rstz          ),
  .adr_i         (perif_adr     ),
  .dat_i         (perif_wdat    ),
  .dat_o         (gpreg_dat     ),
  .we_i          (perif_we      ),
  .stb_i         (gpreg_stb     ),
  .ack_o         (gpreg_ack     ),
  .gpio_dir      (gpio_dir      ),
  .gpio_write    (gpio_write    ),
  .gpio_read     (gpio_read     ),
  .uart_prescaler(uart_prescaler),
  .uart_tx_clear (uart_tx_clear ),
  .uart_tx_size  (uart_tx_size  ),
  .spim_prescaler(spim_prescaler),
  .spim_cpol     (spim_cpol     ),
  .spim_cpha     (spim_cpha     ),
  .spim_tx_clear (spim_tx_clear ),
  .spim_rx_clear (spim_rx_clear ),
  .spim_tx_size  (spim_tx_size  ),
  .spim_rx_size  (spim_rx_size  )
);


// UART TX
wb_uart_tx #(
  .BUFFER         (128),
  .PRESCALER_WIDTH(12 )
) u_uart_tx (
  .clk      (clk            ),
  .rstz     (rstz           ),
  .tx       (TX             ),
  .prescaler(uart_prescaler ),
  .clear    (uart_tx_clear  ),
  .size     (uart_tx_size   ),
  .dat_i    (perif_wdat[7:0]),
  .we_i     (perif_we       ),
  .stb_i    (uart_stb       ),
  .ack_o    (uart_ack       )
);

assign uart_dat = '0;


// SPI Master
wb_spi_master #(
  .BUFFER         (128),
  .PRESCALER_WIDTH(8  )
) u_spim (
  .clk      (clk            ),
  .rstz     (rstz           ),
  .sclk     (SCLK           ),
  .mosi     (MOSI           ),
  .miso     (MISO           ),
  .prescaler(spim_prescaler ),
  .cpol     (spim_cpol      ),
  .cpha     (spim_cpha      ),
  .tx_clear (spim_tx_clear  ),
  .rx_clear (spim_rx_clear  ),
  .tx_size  (spim_tx_size   ),
  .rx_size  (spim_rx_size   ),
  .dat_i    (perif_wdat[7:0]),
  .dat_o    (spim_dat       ),
  .we_i     (perif_we       ),
  .stb_i    (spim_stb       ),
  .ack_o    (spim_ack       )
);


// Bidirectional GPIO x 12
assign GPIO0  =  gpio_dir[0] ? gpio_write[0] : 1'bz;
assign GPIO1  =  gpio_dir[1] ? gpio_write[1] : 1'bz;
assign GPIO2  =  gpio_dir[2] ? gpio_write[2] : 1'bz;
assign GPIO3  =  gpio_dir[3] ? gpio_write[3] : 1'bz;

assign GPIO4  =  gpio_dir[4] ? gpio_write[4] : 1'bz;
assign GPIO5  =  gpio_dir[5] ? gpio_write[5] : 1'bz;
assign GPIO6  =  gpio_dir[6] ? gpio_write[6] : 1'bz;
assign GPIO7  =  gpio_dir[7] ? gpio_write[7] : 1'bz;

assign GPIO8  =  gpio_dir[8] ? gpio_write[8] : 1'bz;
assign GPIO9  =  gpio_dir[9] ? gpio_write[9] : 1'bz;
assign GPIO10 = gpio_dir[10] ? gpio_write[10] : 1'bz;
assign GPIO11 = gpio_dir[11] ? gpio_write[11] : 1'bz;

// 24MHz/(2^17) ~  5.46ms x3 poll consensus
input_debouncer #(
  .N       (12),
  .DEBOUNCE(17)
) u_debounce (
  .clk (clk      ),
  .rstz(rstz     ),
  .read(gpio_read),
  .gpio_in({
    GPIO11,
    GPIO10,
    GPIO9,
    GPIO8,
    GPIO7,
    GPIO6,
    GPIO5,
    GPIO4,
    GPIO3,
    GPIO2,
    GPIO1,
    GPIO0
  })
);


// ------------------------------------------------------------
`ifdef verilator
logic _unused = &{1'b0
  , sys_sel
};
`endif

endmodule
