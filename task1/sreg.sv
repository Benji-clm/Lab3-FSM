module sreg4 (
    input logic     clk,
    input logic     rst,
    input logic     data_in,
    input logic     data_out
);

    logic [4:1]     sreg;

    always_ff @ (posedge clk)
    if (rst)
        sreg <= 4'b0;
        else  begin
            sreg <= {sreg[3:1], data_in};
        end
    assign data_out = sreg[4];
endmodule
