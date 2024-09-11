import "DPI-C" function string getenv(input string env_name);

module tb_top();

    timeunit 1ns;
    timeprecision 10ps;

    localparam time CLK_PERIOD          = 50ns;
    localparam time APPL_DELAY          = 10ns;
    localparam time ACQ_DELAY           = 30ns;
    localparam unsigned RST_CLK_CYCLES  = 10;
    localparam unsigned TOT_STIMS       = 10000;
    localparam unsigned TIMEOUT_LIM     = 1000;

    localparam type data_t = logic [31:0];
    localparam type strb_t = logic [31:0];
    localparam type addr_t = logic [31:0];

    localparam logic [31:0] ADDR_STOP_SIG = 0;
    localparam logic [31:0] ADDR_TRAP_SIG = 8;

    int unsigned numcycles_elapsed;

    logic clk;
    logic rst_n;

    logic [1:0]  esc_tx = 2'h0;
    logic [31:0] hart_id = 32'h0;
    logic [31:0] boot_addr = 32'h80000000;

    clk_rst_gen #(
        .CLK_PERIOD     (CLK_PERIOD),
        .RST_CLK_CYCLES (RST_CLK_CYCLES)
    ) i_clk_rst_gen (
        .clk_o  (clk),
        .rst_no (rst_n)
    );

    logic  instr_mem_req;
    addr_t instr_mem_addr;
    data_t instr_mem_wdata;
    strb_t instr_mem_strb;
    logic  instr_mem_we;
    data_t instr_mem_rdata;

    logic  data_mem_req;
    addr_t data_mem_addr;
    data_t data_mem_wdata;
    strb_t data_mem_strb;
    logic  data_mem_we;
    data_t data_mem_rdata;

    ibex_tiny_soc #(
        .NumTaints(1)
    ) i_dut (
        .clk_i(clk),
        .rst_ni(rst_n),
        .esc_tx_i(esc_tx),
        .hart_id_i(hart_id),
        .boot_addr_i(boot_addr),

        .instr_mem_req_o(instr_mem_req),
        .instr_mem_addr_o(instr_mem_addr),
        .instr_mem_wdata_o(instr_mem_wdata),
        .instr_mem_strb_o(instr_mem_strb),
        .instr_mem_we_o(instr_mem_we),
        .instr_mem_rdata_o(instr_mem_rdata),
        .data_mem_req_o(data_mem_req),
        .data_mem_addr_o(data_mem_addr),
        .data_mem_wdata_o(data_mem_wdata),
        .data_mem_strb_o(data_mem_strb),
        .data_mem_we_o(data_mem_we),
        .data_mem_rdata_o(data_mem_rdata)
    );

    initial begin: application_block
        wait (rst_n);

        @(posedge clk);
        #(APPL_DELAY);
    end

    initial begin: acquisition_block
        bit got_stop_req;
        int remaining_before_stop;
        int step_id;
        int simlen;
        wait (rst_n);

        numcycles_elapsed = 0;
        got_stop_req = 0;
        step_id = 0;
        remaining_before_stop = 50;
        simlen = getenv("SIMLEN").atoi();

        forever begin
            @(posedge clk);
            #(APPL_DELAY);
            numcycles_elapsed += 1;

            // Check whether got a stop request
            if (!got_stop_req &&
                    data_mem_req &&
                    data_mem_we &&
                    //data_mem_wdata == 0 &&
                    data_mem_addr == ADDR_STOP_SIG) begin
                $display("Found a stop request. Stopping the benchmark after ", remaining_before_stop, " more ticks. Elapsed ticks: ", numcycles_elapsed);
                got_stop_req = 1;
            end

            // Check whether got an exception signal
            if (!got_stop_req &&
                    data_mem_req &&
                    data_mem_we &&
                    // data_mem_wdata == 0 &&  // We release this constraint == 0 since now we store the destination register for stopping.
                    data_mem_addr == ADDR_TRAP_SIG) begin
                if (getenv("DONTSTOP_TB_ON_TRAP") == null || getenv("DONTSTOP_TB_ON_TRAP").atoi() != 1) begin
                    $display("Found an exception signal. Stopping the benchmark after %d more ticks, since DONTSTOP_TB_ON_TRAP is not 1.", remaining_before_stop);
                    got_stop_req = 1;
                end
                else
                    $display("Found an exception signal. Not stopping.");
            end

            // Decrement if got a stop request.
            if (got_stop_req)
                if (remaining_before_stop-- == 0)
                    break;

            // "Natural" stop since SIMLEN has been reached
            if (step_id == simlen-1) begin
                $display("Reached SIMLEN (%d cycles). Stopping.", simlen);
                break;
            end

            step_id++;
        end

        $stop();
    end

endmodule
