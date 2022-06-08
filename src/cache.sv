// word size = 32 bits
// instruction size = 13 bits
// #(blocks) * #(words in block) * #(bytes in word) = cache size in bytes
// block * 1 * 4 = 8 * 1024 = 8KB -> block_number = 2048 (2 ^ 11) => number_of_digits for selecting block = 11 bits
// Tag : 19      Block : 11    Word : 0   Au : 2
// Tag : [31:13] address - Block [12:2] address 
// dirty = 1 bit , valid = 1 bit
// blocks * 1 * 


module cache #(
    parameter BLOCKS = 2048,
    parameter SIZE = 8 * 1024 //bytes
) (
    address_input, // address that goes into cache generated from alu
    address_output, // address that cache gives to memory
    read_data_2, // input of cache
    read_data, // output of cache
    mem_data_in, // output of cache to memory
    mem_data_out, // output of memory to cache
    write_en_in, // input signal of write or read to cache
    write_en_out, // output signal to memory
    hit,
    clk,
    cache_done,
    reset
);

input [31:0] read_data_2;
output reg [31:0] read_data;
input   [7:0]  mem_data_out[0:3];
output  reg [7:0]  mem_data_in[0:3];
input  [31:0] address_input;
output  reg [31:0] address_output;
input write_en_in;
output reg write_en_out;
input clk;
output reg hit;
output reg cache_done;



reg [31:0] block [BLOCKS]; // our cache system consisting of a dirty bit, a valid bit, a tag and a data array
reg [18:0] tag   [BLOCKS];
reg valid_bit    [BLOCKS];
reg dirty_bit    [BLOCKS];

reg [31:0] this_block; // temporary registers
reg [18:0] this_tag;
reg this_valid;
reg this_dirty;

reg [10:0] line_num;                                    // find the wanted line number in the cache
reg [18:0] tag_num;

integer i;

assign address_output = address_input;                  //address output is the same as input


always @(negedge reset) begin
    for (i = 0; i < BLOCKS; i = i + 1) begin
        valid_bit[i] = 0;
        dirty_bit[i] = 0;
    end
end

always @(posedge clk) begin
    cache_done = 0;
    hit = 0;
    i = 0;
    line_num = address_input[12:2];                  // get and store the block number from input address
    tag_num = address_input[31:13];                  // get and store the tag from input address
    this_block = block[line_num];                    // get the wanted block
    this_tag = tag[line_num];                        // get the tag of the wanted block



    if(valid_bit[line_num] == 1) begin
        if(write_en_in == 1) begin
            if (this_tag == tag_num) begin
                // this_block = read_data_2;
                // block[line_num] = this_block;
                block[line_num] = read_data_2;
                dirty[line_num] = 1;
                hit = 1;
            end else begin
                write_to_mem;
                read_from_mem;
                dirty_bit[line_num] = 0;
               end
        end else begin
                if(this_tag == tag_num) begin
                    // read_data = this_block;
                    read_data = block[line_num];
                    hit = 1;
                end else begin
                write_to_mem;
                read_from_mem;
                @(posedge clk)
                // read_data = this_block;
                read_data = block[line_num];
                dirty_bit[line_num] = 0;
            end
        end 
        tag[line_num] = tag_num;
    end else begin
        if(write_en_in == 1) begin
            // this_block = read_data_2;
            // block[line_num] = this_block;
            block[line_num] = read_data_2;
            dirty[line_num] = 1;
        end
        else begin
            read_from_mem;
            @(posedge clk)
            // read_data = this_block;
            read_data = block[line_num];
        end     
         valid_bit[line_num] = 1;
         tag[line_num] = tag_num;
    end
    cache_done = 1;
end


function read_from_mem;
    begin
        write_en_out = 0;
        for (i = 0; i < 4; i += 1)
             @(posedge clk)
        // this_block = {mem_data_out[0], mem_data_out[1], mem_data_out[2], mem_data_out[3]};
        // block[line_num] = this_block;
        block[line_num] = {mem_data_out[0], mem_data_out[1], mem_data_out[2], mem_data_out[3]};
    end
endfunction

function write_to_mem;
    begin
        if (dirty[line_num] == 1) begin
           this_block = block[line_num];
           write_en_out = 1;
           mem_data_in[3] = this_block [7:0];
           mem_data_in[2] = this_block [15:8];
           mem_data_in[1] = this_block [23:16];
           mem_data_in[0] = this_block [31:24];
           for (i = 0; i < 5 ; i += 1)
                @(posedge clk)
        end
   end
endfunction

endmodule