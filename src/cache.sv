// word size = 32 bits
// instruction size = 13 bits
// #(blocks) * #(words in block) * #(bytes in word) = cache size in bytes
// block * 1 * 4 = 8 * 1024 = 8KB -> block_number = 2048 (2 ^ 11) => number_of_digits for selecting block = 11 bits
// Tag : 19      Block : 11    Word : 0   Au : 2
// Tag : [31:13] address - Block [12:2] address 
// dirty = 1 bit , valid = 1 bit
// blocks * 1 * 


module cache #(
    BLOCKS = 2048,
    SIZE = 8 * 1024 //bytes
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
    mem_to_reg,
    rd_data,
    clk,
    reset,
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
output reg [31:0] rd_data;
output reg hit;
output reg mem_to_reg;


//     assign rd_data = mem_to_reg ? read_data : mem_addr; // old way


reg [31:0] block [BLOCKS]; // our cache system consisting of a dirty bit, a valid bit, a tag and a data array
reg [18:0] tag [BLOCKS];
reg valid_bit [BLOCKS];
reg dirty_bit [BLOCKS];

reg [31:0] this_block; // temporary registers
reg [18:0] this_tag;
reg this_valid;
reg this_dirty;

reg [10:0] line_num;                                    // find the wanted line number in the cache
reg [18:0] tag_num;

integer i;

assign address_output = address_input;                  //address output is the same as input


initial begin
    //make all valid bits 0
    for (i = 0; i < BLOCKS; i = i + 1) begin
        valid_bit[i] = 0;
        dirty_bit[i] = 0;
    end
end
                                                       // **still having thoughts about read and write signals**


always_ff @(posedge clk,negedge reset) begin

    i = 0;
    line_num = address_input[12:2];                  // get and store the block number from input address
    tag_num = address_input[31:13];                  // get and store the tag from input address
    this_block = block[line_num];                    // get the wanted block
    this_tag = tag[line_num];                        // get the tag of the wanted block



    if(valid_bit[line_num] == 1) begin            //it is a valid bit
        if(write_en_in == 1) begin                  // we should write in this block
            this_block = read_data_2;                // write the data in this block                
            block[line_num] = this_block;           //  write the block to the cache
            write_en_out = 1;                       // enable the write signal for the memory
            mem_data_in[3] = read_data_2 [7:0];     // write the data in the memory
            mem_data_in[2] = read_data_2 [15:8];
            mem_data_in[1] = read_data_2 [23:16];
            mem_data_in[0] = read_data_2 [31:24];
            for (i = 0 ; i<4 ; i+=1 ) begin         // dont know if it should be #4 or this
                 @(posedge clk)                                   // empty for only for showing cycles    
            end                                     // we need 4 cycles for the memory to finish and then we can disable the write signal
        end
        else begin                                  // we should read from this block and search
            if(this_tag == tag_num) begin           // if the tag is the same, we can read from this block
                read_data = this_block;
            end 
            else begin                                // if the tag is not the same, we need to get data and overwrite the data
                write_en_out = 0;                     // enable the read signal from memory
                for (i = 0 ; i<4 ; i+=1 ) begin       // dont know if it should be #4 or this  
                    @(posedge clk)                                   // empty for only for showing cycles
                end                                   // we need to waid 4 cycles for the memory to give us the data
                this_block = {mem_data_out[0], mem_data_out[1], mem_data_out[2], mem_data_out[3]}; // write the data in this block
                block[line_num] = this_block;         //  write the block to the cache
                read_data = this_block;               // give read_data the wanted data
            end 
        end 
         tag[line_num] = tag_num;                      // write the tag to the cache
    end  
    else begin                                         // it is not a valid bit
        if(write_en_in == 1) begin                     // we should write in this block
            this_block = read_data_2;                   // write the data in this block                
            block[line_num] = this_block;              //  write the block to the cache
            write_en_out = 1;                          // enable the write signal for the memory
            mem_data_in[3] = read_data_2 [7:0];        // write the data in the memory
            mem_data_in[2] = read_data_2 [15:8];
            mem_data_in[1] = read_data_2 [23:16];
            mem_data_in[0] = read_data_2 [31:24];
            for (i = 0 ; i<4 ; i+=1 ) begin            // dont know if it should be #4 or this
                 @(posedge clk)                                         // empty for only for showing cycles    
            end                                        // we need 4 cycles for the memory to finish and then we can disable the write signal
        end     
        else begin                                     // we should read from this block and search
            write_en_out = 0;                          // enable the read signal from memory
            for (i = 0 ; i<4 ; i+=1 ) begin            // dont know if it should be #4 or this  
                 @(posedge clk)                                         // empty for only for showing cycles
            end                                        // we need to waid 4 cycles for the memory to give us the data
            this_block = {mem_data_out[0], mem_data_out[1], mem_data_out[2], mem_data_out[3]}; // write the data in this block
            block[line_num] = this_block;              //  write the block to the cache
            read_data = this_block;                    // give read_data the wanted data
        end     
         valid_bit[line_num] = 1;                      // set the valid bit to 1
         tag[line_num] = tag_num;                      // set the tag to the wanted tag 
    end
end




endmodule