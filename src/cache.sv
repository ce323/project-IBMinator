module cache #(
    parameter BLOCKS = 2048,
    parameter SIZE = 8 * 1024 //bytes
) (
    input [31:0] address_input, cache_input,
    input [7:0] mem_data_out [0:3],
    input write_en_in, is_mem_inst, clk, reset,
    output [31:0] address_output, 
    output [31:0] cache_data_out,
    output [7:0] mem_data_in [0:3],
    output write_en_out, is_word, cache_done
);

    assign cache_done = is_mem_inst && !hit;

    reg [31:0] block   [BLOCKS];
    reg [31:0] this_block;
    reg [18:0] tag     [BLOCKS];
    reg valid          [BLOCKS];
    reg dirty          [BLOCKS];

    wire [18:0] this_tag = tag[line_num];
    wire [18:0] tag_num = address_input[31:13];
    wire [10:0] line_num;

    wire valid_bit = valid[line_num];
    wire dirty_bit = dirty[line_num];

    wire hit = valid_bit && (this_tag == tag_num);
    wire address_controll, output_controll, mem_data_in_controll, write_data_in_mem, overwrite_data, write_data_in_cache;

    assign address_output = address_controll ? address_input : {this_tag, line_num, 2'b0};
    assign write_en_out = write_data_in_mem;

    wire [31:0] byte_3_sign_extended = {{24{block[line_num][7]}}, block[line_num][7:0]};
    wire [31:0] byte_2_sign_extended = {{24{block[line_num][15]}}, block[line_num][15:8]};
    wire [31:0] byte_1_sign_extended = {{24{block[line_num][23]}}, block[line_num][23:16]};
    wire [31:0] byte_0_sign_extended = {{24{block[line_num][31]}}, block[line_num][31:24]};
    assign cache_data_out = is_word ? block[line_num] : (chosen_byte == 0) ? byte_0_sign_extended : (chosen_byte == 1) ? byte_1_sign_extended : (chosen_byte == 2) ? byte_2_sign_extended : byte_3_sign_extended;
    assign line_num = address_input[12:2];
    wire [1:0] chosen_byte = address_input[1:0];
    
    wire read_state;
    cache_control cache_control (
        .hit(hit),
        .dirty_bit(dirty[line_num]),
        .is_mem_inst(is_mem_inst),
        .write_en_in(write_en_in),
        .clk(clk),
        .reset(reset),
        .address_controll(address_controll),
        .output_controll(output_controll),
        .mem_data_in_controll(mem_data_in_controll),
        .write_data_in_mem(write_data_in_mem),
        .overwrite_data(overwrite_data),
        .write_data_in_cache(write_data_in_cache),
        .read_state(read_state)
    );
    

    always @(negedge reset) begin
        for (i = 0; i < BLOCKS; i += 1) begin
            valid[i] = 0;
            dirty[i] = 0;
        end
    end

    assign mem_data_in[3] = is_word ? block[line_num] [7:0] : {8{block[line_num] [7]}};
    assign mem_data_in[2] = is_word ? block[line_num] [15:8] : {8{block[line_num] [7]}};
    assign mem_data_in[1] = is_word ? block[line_num] [23:16] : {8{block[line_num] [7]}};
    assign mem_data_in[0] = block[line_num] [31:24];
    
    int i = 0;
    always_latch @(write_data_in_cache, overwrite_data) begin
        if (write_data_in_cache)
            block[line_num] = {mem_data_out[0], mem_data_out[1], mem_data_out[2], mem_data_out[3]};

        if (overwrite_data) begin
            if (is_word)
                block[line_num] = cache_input;
            else if (chosen_byte == 0)
                block[line_num] [31:24] = cache_input[7:0];
            else if (chosen_byte == 1)
                block[line_num] [23:16] = cache_input[7:0];
            else if (chosen_byte == 2)
                block[line_num] [15:8] = cache_input[7:0];
            else if (chosen_byte == 3)
                block[line_num] [7:0] = cache_input[7:0];
        end

    end


    always @(hit) begin
         if (hit)
            dirty[line_num] = 0;
        else
            dirty[line_num] = 1;
    end

    always_latch @(read_state) begin
        if (read_state) begin
            valid[line_num] = 1;
            tag[line_num] = tag_num;
        end
    end 
    
endmodule