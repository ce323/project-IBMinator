module pc (
    input clk, rst_b, cache_done,
    input [31:0] pc_input,
    output reg [31:0] pc_output
);

always @(posedge clk, negedge rst_b/*, posedge cache_done*/) begin
    if(rst_b == 0)
        pc_output <= 0;
    else if (cache_done)
        pc_output <= pc_input;
end


endmodule