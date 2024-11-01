module lfsr (
    input   logic       clk,
    input   logic       rst,
    input   logic       en,
    output  logic [6:0] data_out
);

    logic [7:1]     sreg;

always_ff @( posedge clk, posedge rst)
    if (rst)
    // We reset in a *non-zero* state, as else we would get stuck
        sreg <= 4'b1;
    else
    // to do the same for 7 bits, is quite "simple", we shift left the first 6 bits, then the new LSB is the given formula
        sreg <= {sreg[6:1], sreg[3] ^ sreg[7]};
    
assign data_out = sreg;

endmodule
