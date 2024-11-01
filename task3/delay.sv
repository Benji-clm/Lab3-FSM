module delay #(
    parameter WIDTH = 16
)(
  // interface signals
  input  logic             clk,      // clock 
  input  logic             rst,      // reset
  input  logic             en,       // enable signal
  input  logic [WIDTH-1:0] N,     	 // clock divided by N+1
  output logic             tick,  
  output  logic [7:0] data_out,
);

 

clktick clocktick (
    .clk (clk),
    .rst (rst),
    .en (en),
    .N (N),
    .tick (tick)    
);

f1_fsm FSM (
    .rst (rst),
    .en  (tick),
    .clk (clk),
    .data_out (data_out)
);

endmodule
