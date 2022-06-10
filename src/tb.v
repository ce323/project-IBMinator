// word size = 32 bits
// instruction size = 13 bits
// #(blocks) * #(words in block) * #(bytes in word) = cache size in bytes
// block * 1 * 4 = 8 * 1024 = 8KB -> block_number = 2048 (2 ^ 11) => number_of_digits for selecting block = 11 bits
// Tag : 19      Block : 11    Word : 0   Au : 2
// Tag : [31:13] address - Block [12:2] address 
// dirty = 1 bit , valid = 1 bit
// blocks * 1 * 
`timescale 1ns/1ns

module cache (
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

parameter BLOCKS = 2048,
parameter SIZE = 8 * 1024 //bytes

input [31:0] read_data_2;
output reg [31:0] read_data;
input   [7:0]  mem_data_out [0:3];
output [7:0]  mem_data_in [0:3];
input  [31:0] address_input;
output  [31:0] address_output;
input write_en_in;
output reg write_en_out;
reg clk, reset;
output reg hit;
output reg cache_done;



reg [31:0] block [BLOCKS]; // our cache system consisting of a dirty bit, a valid bit, a tag and a data array
reg [18:0] tag   [BLOCKS];
reg valid_bit    [BLOCKS];
reg dirty        [BLOCKS];

reg [31:0] this_block; // temporary registers
reg [18:0] this_tag;
reg this_valid;
reg this_dirty;

reg [10:0] line_num;                                    // find the wanted line number in the cache
reg [18:0] tag_num;

integer i;
reg [31:0] j;

assign address_output = address_input;                  //address output is the same as input

reg [7:0] dummy [0:3];
assign mem_data_in[3] = dummy[3];
assign mem_data_in[2] = dummy[2];
assign mem_data_in[1] = dummy[1];
assign mem_data_in[0] = dummy[0];

always @(negedge reset) begin
    j = 0;

    for (i = 0; i < BLOCKS; i += 1) begin
        valid_bit[i] = 0;
        dirty[i] = 0;
    end
end

reg states [5:0];
reg dirty_bit;
always @(posedge clk) begin
    $display("j = %d", j);
    for (i = 0; i < 6; i += 1) begin
        if (states[i]) begin
            $display("states[%d]", i);
            break;
        end
    end
    dirty_bit = dirty[line_num];

    if (states[5] && j == 0)
        // write_en_out = 0;
        $display("state 5 == read signal activated");
    else if (states[5] && j == 4)
        $display("state 5 == data fetched from m.m");// we shouldnt write in cache in this state
    else if (states[5] && j == 5) begin
        // block[line_num] = {mem_data_out[0], mem_data_out[1], mem_data_out[2], mem_data_out[3]};
        $display("state 5 == data went into cache block---state is done");
        // read_data = block[line_num];
        // valid_bit[line_num] = 1;
        // tag[line_num] = tag_num;
        j = -1;
        cache_done = 1; // we should check  this
    end
    
    else if (states[3] && j == 0 && dirty_bit) begin
        // valid bit 1 === read ===  miss


        $display("state 3 == dirty ==> write");
        // this_block = block[line_num];
        // write_en_out = 1;
        // dummy[3] = this_block [7:0];
        // dummy[2] = this_block [15:8];
        // dummy[1] = this_block [23:16];
        // dummy[0] = this_block [31:24];
    end else if (states[3] && (dirty_bit && j == 1 || !dirty_bit && j == 0)) //fixed j
        // write_en_out = 0;
        $display("state 3 == read signal enabled");
    else if (states[3] && (dirty_bit && j == 9 || !dirty_bit && j == 4))
        $display("data fetched from memory");
    else if (states[3] && (dirty_bit && j == 10 || !dirty_bit && j == 5)) begin
        // block[line_num] = {mem_data_out[0], mem_data_out[1], mem_data_out[2], mem_data_out[3]};
        $display("data writen into cache === done");
        // read_data = block[line_num];
        // dirty[line_num] = 0;
        j = -1;
        cache_done = 1;
    end

    else if (states[1] && j == 0 && dirty_bit) begin
        $display("state 1 == dirty ==> write");
        // this_block = block[line_num];
        // write_en_out = 1;
        // dummy[3] = this_block [7:0];
        // dummy[2] = this_block [15:8];
        // dummy[1] = this_block [23:16];
        // dummy[0] = this_block [31:24];
    end else if (states[1] && (dirty_bit && j == 1 || !dirty_bit && j == 0))//fix
        // write_en_out = 0;
        $display("state 3 == read signal enabled == cache done");
    else if (states[1] && (dirty_bit && j == 10 || !dirty_bit && j == 5)) begin
        // block[line_num] = {mem_data_out[0], mem_data_out[1], mem_data_out[2], mem_data_out[3]};
        // dirty[line_num] = 0;
        j = -1;
        // tag[line_num] = tag_num;
        cache_done = 1;
    end

    else if(state[0]) begin
            block[line_num] = read_data_2;
            dirty[line_num] = 1;
            hit = 1;
            cache_done = 1;
    end

    else if(state[2]) begin
            hit = 1;
            read_data = block[line_num];
            cache_done = 1;
            tag[line_num] = tag_num;
    end

    else if(state[4]) begin
            block[line_num] = read_data_2;
            dirty[line_num] = 1;
            valid_bit[line_num] = 1;
            tag[line_num] = tag_num;
            cache_done = 1;
    end
    

    j += 1;
end

always @(posedge clk) begin
    hit = 0;
    i = 0;
    line_num = address_input[12:2];                  // get and store the block number from input address
    tag_num = address_input[31:13];                  // get and store the tag from input address
    this_block = block[line_num];                    // get the wanted block
    this_tag = tag[line_num];                        // get the tag of the wanted block

    // $display("valid=%d write_en_in=%d equality_tag=%d dirty=%d", valid_bit[line_num], write_en_in, (this_tag == tag_num), dirty[line_num]);
    if(valid_bit[line_num] == 1) begin
        if (write_en_in == 1) begin
            if (this_tag == tag_num) begin
                $display("state 0");
                for (i = 0; i < 6; i += 1) begin
                    states[i] = 0;
                end
                states[0] = 1;
                cache_done = 0;
                /*block[line_num] = read_data_2;
                dirty[line_num] = 1;
                hit = 1;
                cache_done = 1;*/

            end else begin
                $display("state 1");
                for (i = 0; i < 6; i += 1) begin
                    states[i] = 0;
                end
                states[1] = 1;
                cache_done = 0;
                /*
                if (dirty[line_num] == 1) begin
                this_block = block[line_num];
                write_en_out = 1;
                dummy[3] = this_block [7:0];
                dummy[2] = this_block [15:8];
                dummy[1] = this_block [23:16];
                dummy[0] = this_block [31:24];
                // for (i = 0; i < 5; i += 1)
                    // @(posedge clk)
                end
                */
                /*write_en_out = 0;*/
                // for (i = 0; i < 4; i += 1)
                //      @(posedge clk)
                /*
                block[line_num] = {mem_data_out[0], mem_data_out[1], mem_data_out[2], mem_data_out[3]};
        
                dirty[line_num] = 0;
                */
               end
        end else begin
                if(this_tag == tag_num) begin
                    
                    $display("state 2");
                    for (i = 0; i < 6; i += 1) begin
                        states[i] = 0;
                    end
                    states[2] = 1;
                    cache_done = 0;
                    /*hit = 1;
                    read_data = block[line_num];
                    cache_done = 1;*/
                end else begin
                    $display("state 3");
                    for (i = 0; i < 6; i += 1) begin
                        states[i] = 0;
                    end
                    states[3] = 1;
                    cache_done = 0;
                    /*
                    if (dirty[line_num] == 1) begin
                    this_block = block[line_num];
                    write_en_out = 1;
                    dummy[3] = this_block [7:0];
                    dummy[2] = this_block [15:8];
                    dummy[1] = this_block [23:16];
                    dummy[0] = this_block [31:24];
                    // for (i = 0; i < 5; i += 1)
                    //     @(posedge clk)
                    end
                    */
                    // read_from_mem;
                    /*write_en_out = 0;*/
                    // for (i = 0; i < 4; i += 1)
                    //      @(posedge clk)
                    /*block[line_num] = {mem_data_out[0], mem_data_out[1], mem_data_out[2], mem_data_out[3]};*/

                    // @(posedge clk)
                    /*
                    read_data = block[line_num];
                    dirty[line_num] = 0;
                    */
                end
        end 
       /* tag[line_num] = tag_num;*/
    end else begin
        if(write_en_in == 1) begin
            $display("state 4");
            for (i = 0; i < 6; i += 1) begin
                states[i] = 0;
            end
            states[4] = 1;
            cache_done = 0;
          /*  block[line_num] = read_data_2;
            dirty[line_num] = 1;
            valid_bit[line_num] = 1;
            tag[line_num] = tag_num;
            cache_done = 1; */
        end else begin
            $display("state 5");
            for (i = 0; i < 6; i += 1) begin
                states[i] = 0;
            end
            states[5] = 1;
            cache_done = 0;

            /*write_en_out = 0;*/
            // for (i = 0; i < 4; i += 1)
            //      @(posedge clk)
            /*block[line_num] = {mem_data_out[0], mem_data_out[1], mem_data_out[2], mem_data_out[3]};*/

            // @(posedge clk)
            // read_data = this_block;
            /*
            read_data = block[line_num];
            */
        end
    end
end

// function read_from_mem (input a);
//     begin
//         write_en_out = 0;
//         for (i = 0; i < 4; i += 1)
//              @(posedge clk);
//         // this_block = {mem_data_out[0], mem_data_out[1], mem_data_out[2], mem_data_out[3]};
//         // block[line_num] = this_block;
//         block[line_num] = {mem_data_out[0], mem_data_out[1], mem_data_out[2], mem_data_out[3]};
//     end
// endfunction

// function write_to_mem (input a);
//     begin
//         if (dirty[line_num] == 1) begin
//            this_block = block[line_num];
//            write_en_out = 1;
//            mem_data_in[3] = this_block [7:0];
//            mem_data_in[2] = this_block [15:8];
//            mem_data_in[1] = this_block [23:16];
//            mem_data_in[0] = this_block [31:24];
//            for (i = 0; i < 5; i += 1)
//                 @(posedge clk);
//         end
//    end
// endfunction

initial begin
    #10000 $finish;
end

endmodule