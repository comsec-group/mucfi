import "DPI-C" function string getenv(input string env_name);

module tb_top #(
    // The two below must be equal.
    parameter int unsigned InstrMemDepth = 1 << 15, // 32-bit words
    parameter int unsigned DataMemDepth  = 1 << 15, // 32-bit words

    // Derived parameters
    localparam int unsigned InstrMemAw = $clog2(InstrMemDepth),
    localparam int unsigned DataMemAw = $clog2(DataMemDepth),

    localparam type data_t = logic [31:0],
    localparam type strb_t = logic [31:0], // The strobe is bitwise.
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
    logic  instr_mem_gnt;
    addr_t instr_mem_addr;
    data_t instr_mem_wdata;
    strb_t instr_mem_strb;
    logic  instr_mem_we;
    data_t instr_mem_rdata;

    logic  data_mem_req;
    logic  data_mem_gnt;
    addr_t data_mem_addr;
    data_t data_mem_wdata;
    strb_t data_mem_strb;
    logic  data_mem_we;
    data_t data_mem_rdata;

    picorv32_tiny_soc i_dut (
        .clk_i(clk),
        .rst_ni(rst_n),

        .instr_mem_req(instr_mem_req),
        .instr_mem_gnt(instr_mem_gnt),
        .instr_mem_addr(instr_mem_addr),
        .instr_mem_wdata(instr_mem_wdata),
        .instr_mem_strb(instr_mem_strb),
        .instr_mem_we(instr_mem_we),
        .instr_mem_rdata(instr_mem_rdata),
        .data_mem_req(data_mem_req),
        .data_mem_gnt(data_mem_gnt),
        .data_mem_addr(data_mem_addr),
        .data_mem_wdata(data_mem_wdata),
        .data_mem_strb(data_mem_strb),
        .data_mem_we(data_mem_we),
        .data_mem_rdata(data_mem_rdata),
        .irq_i('0),
        .eoi_o()
    );

    initial begin: application_block
        wait (rst_n);

        @(posedge clk);
        #(APPL_DELAY);
    end

    initial begin: acquisition_block
        bit got_stop_req, got_pc_dontcare;
        int remaining_before_stop;
        int step_id;
        int simlen;

        int int_req_dump_id = 1;

        wait (rst_n);

        numcycles_elapsed = 0;
        got_pc_dontcare = 0;
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
                    // data_mem_wdata == 0 &&
                    data_mem_addr == 0) begin
                $display("Found a stop request. Stopping the benchmark after", remaining_before_stop, " more ticks. Elapsed ticks: ", numcycles_elapsed);
                got_stop_req = 1;
            end

            // Register dumps
            if (!got_stop_req &&
                    data_mem_req &&
                    data_mem_we &&
                    // data_mem_wdata == 0 &&
                    data_mem_addr == 32'h10) begin
                if ($isunknown(data_mem_wdata))
                    $display("Dump of reg x%02d: 0x%08h", int_req_dump_id, 64'hbadcab1ebadcab1e);
                else
                    $display("Dump of reg x%02d: 0x%08h", int_req_dump_id, data_mem_wdata & 64'hFFFFFFFF);
                int_req_dump_id += 1;
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
                    $isunknown(i_dut.i_picorv32_mem_top.i_picorv32.next_pc)) begin
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
