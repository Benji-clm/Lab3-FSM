module mux (
    input logic     clk,
    input logic     a,         // Input 1
    input logic     b,         // Input 2
    input logic     sel,       // Select line
    output logic    y         // Output
);
    assign y = sel ? b : a;
endmodule