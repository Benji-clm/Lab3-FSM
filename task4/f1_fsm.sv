module f1_fsm (
    input   logic       rst,
    input   logic       en,
    input   logic       trigger,
    input   logic       clk,
    output  logic [7:0] data_out,
    output  logic       cmd_seq,
    output  logic       cmd_delay
);

    typedef enum {S0, S1, S2, S3, S4, S5, S6, S7, S8} my_state;
    my_state current_state, next_state;

    // Register to hold the trigger state
    logic trigger_activated;

    always_ff @(posedge clk or posedge rst)
        if (rst) begin
            current_state <= S0;
            trigger_activated <= 0;
        end
        else if (en) begin
            if (trigger) trigger_activated <= 1;  // Capture the trigger to start sequence
            if (trigger_activated) current_state <= next_state;
        end

    always_comb
        case (current_state)
            S0: next_state = trigger_activated ? S1 : S0;  // Wait in S0 until triggered
            S1: next_state = S2;
            S2: next_state = S3;
            S3: next_state = S4;
            S4: next_state = S5;
            S5: next_state = S6;
            S6: next_state = S7;
            S7: next_state = S8;
            S8: next_state = S0;
        endcase

    always_comb
        case (current_state)
            S0: data_out = 8'b0;
            S1: data_out = 8'b0000_0001;
            S2: data_out = 8'b0000_0011;
            S3: data_out = 8'b0000_0111;
            S4: data_out = 8'b0000_1111;
            S5: data_out = 8'b0001_1111;
            S6: data_out = 8'b0011_1111;
            S7: data_out = 8'b0111_1111;
            S8: data_out = 8'b1111_1111;
        endcase

    // Set cmd_seq high in states S1 to S8
    always_ff @(posedge clk or posedge rst)
    if (rst) begin
        cmd_seq <= 0;
        cmd_delay <= 0;
    end else begin
        cmd_seq <= (current_state != S0);
        cmd_delay <= (current_state == S8);
    end

endmodule
