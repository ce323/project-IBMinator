module cache_control (
    input hit, dirty_bit, is_mem_inst, write_en_in, clk, reset,
    output address_controll, output_controll, write_data_in_mem, write_data_in_cache, mem_data_in_controll, overwrite_data, read_state
);

    reg [1:0] current_state, next_state;
    reg [3:0] counter;

    assign address_controll = !(current_state == 2); 
    assign output_controll = (current_state == 1) && (counter == 6); 
    assign write_data_in_mem = (current_state == 2) && (counter == 1);
    assign write_data_in_cache = (current_state == 1) && dirty_bit;
    assign mem_data_in_controll = (current_state == 2) && (counter == 0);
    assign overwrite_data = (hit && write_en_in);
    assign read_state = (current_state == 1);

    always @(posedge clk, negedge reset) begin
        if (!reset) begin
            current_state <= 2'b00;
            counter <= 1;
        end else begin
            current_state <= next_state;
            counter <= counter + 1;

            if (current_state == 0 && is_mem_inst && (is_mem_inst || hit) ||
                current_state == 1 && counter == 6 ||
                current_state == 2 && counter == 5)
                counter <= 1;

        end
    end

    always_latch @(*) begin
        if (current_state == 2'b00) begin
            if (!is_mem_inst || is_mem_inst && hit)
                next_state = 2'b00;
            else if (dirty_bit)
                next_state = 2'b10;
            else
                next_state = 2'b01;
        end else if (current_state == 2'b01) begin
            if (counter != 6)
                next_state = 2'b01;
            else
                next_state = 2'b00;
        end else if (current_state == 2'b10) begin
            if (counter != 5)
                next_state = 2'b10;
            else
                next_state = 2'b01;
        end
    end

    
endmodule