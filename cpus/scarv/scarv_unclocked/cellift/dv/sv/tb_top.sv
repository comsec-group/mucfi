import "DPI-C" function string getenv(input string env_name);

module tb_top #(
    // The two below must be equal.
    parameter int unsigned InstrMemDepth = 1 << 15, // 32-bit words
    parameter int unsigned DataMemDepth  = 1 << 15, // 32-bit words

    // Derived parameters
    localparam int unsigned InstrMemAw = $clog2(InstrMemDepth),
    localparam int unsigned DataMemAw = $clog2(DataMemDepth),

    localparam type data_t = logic [31:0],
    localparam type strb_t = logic [3:0], // The strobe is bitwise.
    localparam type addr_t = logic [InstrMemAw-1:0]
)();

    timeunit 1ns;
    timeprecision 10ps;

    localparam time CLK_PERIOD          = 50ns;
    localparam time APPL_DELAY          = 10ns;
    localparam time ACQ_DELAY           = 30ns;
    localparam unsigned RST_CLK_CYCLES  = 10;
    localparam unsigned TOT_STIMS       = 10000;
    localparam unsigned TIMEOUT_LIM     = 1000;

    localparam addr_t ADDR_STOP_SIG = 0;
    localparam addr_t ADDR_TRAP_SIG = 8;

    int unsigned numcycles_elapsed;

    logic clk;
    logic rst_n;

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

    ///////////////////////
    // Interrupt signals //
    ///////////////////////

    // logic int_nmi;
    // logic int_external;
    // logic [3:0] int_extern_cause;
    // logic int_software;
    // assign int_nmi = '0;
    // assign int_external = '0;
    // assign int_extern_cause = '0;
    // assign int_software = '0;
    
    ///////////////////
    // Trace signals //
    ///////////////////

    logic [31:0]  trs_pc;
    logic [31:0]  trs_instr;
    logic         trs_valid;

    scarv_tiny_soc i_dut (
        .clk_i(clk),
        .rst_ni(rst_n),

        // .int_nmi,
        // .int_external,
        // .int_extern_cause,
        // .int_software,

        .trs_pc_o(trs_pc),
        .trs_instr_o(trs_instr),
        .trs_valid_o(trs_valid),

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

    initial begin: pc_trace_block
        wait (rst_n);

        forever begin
            @(posedge clk);
            #(ACQ_DELAY);
            if (trs_valid)
                $display("PC = 0x%h, instruction = %h", trs_pc, trs_instr);
        end
    end

    initial begin: acquisition_block
        bit got_stop_req, got_pc_dontcare;
        int remaining_before_stop;
        int step_id;
        int simlen;
        wait (rst_n);

        numcycles_elapsed = 0;
        got_pc_dontcare = 0;
        got_stop_req = 0;
        step_id = 0;
        remaining_before_stop = 50;
        simlen = getenv("SIMLEN").atoi();

        forever begin
            @(posedge clk);
            #(ACQ_DELAY);
            numcycles_elapsed += 1;

            // Check whether got a stop request
            if (!got_stop_req &&
                    data_mem_req &&
                    data_mem_we &&
                    // data_mem_wdata == 0 &&
                    data_mem_addr == ADDR_STOP_SIG) begin
                $display("Found a stop request. Stopping the benchmark after", remaining_before_stop, " more ticks. Elapsed ticks: ", numcycles_elapsed);
                got_stop_req = 1;
            end

            // Check whether got an exception signal
            if (!got_stop_req &&
                    data_mem_req &&
                    data_mem_we &&
                    // data_mem_wdata == 0 &&
                    data_mem_addr == ADDR_TRAP_SIG) begin
                if (getenv("DONTSTOP_TB_ON_TRAP") == null || getenv("DONTSTOP_TB_ON_TRAP").atoi() != 1) begin
                    $display("Found an exception signal. Stopping the benchmark after %d more ticks, since DONTSTOP_TB_ON_TRAP is not 1.", remaining_before_stop);
                    got_stop_req = 1;
                end
                else
                    $display("Found an exception signal. Not stopping.");
            end

            // Check whether the PC is X (dont't care).
            if (step_id >= 10 &&
                    !got_pc_dontcare &&
                    $isunknown(i_dut.i_scarv_mem_top.i_scarv_core.i_pipeline.i_pipeline_s0_fetch.n_imem_addr)) begin
                $display("PC has become X! Stopping the benchmark after ", remaining_before_stop, " more ticks.");
                got_stop_req = 1;
                got_pc_dontcare = 1;
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
