module pc (
    input clk, rst_b,hit, cache_done,
    input [31:0] pc_input,
    output reg [31:0] pc_output
);

always_latch @(/*posedge clk or */negedge rst_b or posedge cache_done) begin
    if(rst_b == 0)
        pc_output <= 0;
    else begin
        pc_output <= pc_input;
    end
end


endmodule