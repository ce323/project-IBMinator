module PC(
    input clk,rst_b,
    input [31:0] pc_input,
    output reg [31:0] pc_output
);


always @(posedge clk, negedge rst_b) begin
    if(rst_b == 0)
        pc_output <= 1;
    else begin
      pc_output <= pc_input;
    end
end


endmodule