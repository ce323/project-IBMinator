module PC (
    input clk, rst_b,
    input [31:0] pc_input,
    output reg [31:0] pc_output
);

// initial begin
//     pc_output = 1;
// end

always_latch @(posedge clk, negedge rst_b) begin
    if(rst_b == 0)
        pc_output <= 0;
    else begin
      pc_output <= pc_input;
    end
end


endmodule