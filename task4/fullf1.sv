module fullf1 #(
    parameter WIDTH = 8
)(
    input  logic               clk,
    input  logic               rst,
    input  logic               trigger,
    input  logic [5:0]         n,
    output logic [WIDTH-1:0]   data_out,
    output logic               cmd_delay,
    output logic               cmd_seq
);

    logic     mux_out;
    logic     [7:1] k;
    logic     mux_0;
    logic     mux_1;

lfsr shiftregister (
    .clk (clk),
    .rst (rst),
    .data_out (k)
);

delay delayed (
    .clk (clk),
    .rst (rst),
    .trigger (cmd_delay),
    .n (k),
    .time_out (mux_0)
);

clktick ticker (
    .clk (clk),
    .rst (rst),
    .en (cmd_seq),
    .N (n),
    .tick (mux_1)
);

mux mutliplexer (
    .clk (clk),
    .a (mux_0),
    .b (mux_1),
    .sel (cmd_seq),
    .y (mux_out)
);

f1_fsm FSM (
    .rst (rst),
    .en (mux_out),
    .trigger (trigger),
    .clk (clk),
    .data_out (data_out),
    .cmd_seq (cmd_seq),
    .cmd_delay (cmd_delay)
);

endmodule
