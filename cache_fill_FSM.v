module cache_fill_FSM(clk, rst_n, miss_detected, miss_address, fsm_busy, write_data_array, write_tag_array,
						memory_address, memory_data, memory_data_valid, memory_enable, counter2);
	input clk, rst_n;
	input miss_detected;			//active high when tag match logic detects a miss
	input [15:0] miss_address;		//address that missed the cache
	output fsm_busy;				//asserted while FSM is busy handling the miss (can be used as pipeline stall signal)
	output write_data_array;		//write enable to cache data array to signal when filling with memory_data
	output write_tag_array;			//write enable to cache tag array to signal when all words are filled into a data array
	output [15:0] memory_address;	//address to read from memory_address
	input [15:0] memory_data;		//data returned by memory (after delay)
	input memory_data_valid;		//active high indicates valid data returning on memory bus
	output memory_enable;
	output [2:0] counter2;
	wire write_memory_address;
								
	wire state, nxt_state;
	
	wire [3:0] A, B, counter, ff_counter;
	reg memory_enable;
	reg [3:0] regA, regB;
	//reg [2:0] A_new, B_new, new_count;
	//wire [2:0] ff_new;
	reg reg_nxt_state, reg_fsm_busy, reg_write_data_array, reg_write_tag_array, reg_write_memory_address;
	
	//attach wires to outputs of registers
	assign nxt_state = reg_nxt_state;
	assign fsm_busy = reg_fsm_busy;
	assign write_data_array = reg_write_data_array;
	assign write_tag_array = reg_write_tag_array;
	assign write_memory_address = reg_write_memory_address;
	assign A = regA;
	assign B = regB;
	assign counter2 = (ff_counter == 4'h1) ? 3'b000 : 
						(ff_counter == 4'h2) ? 3'b001 : 
						(ff_counter == 4'h3) ? 3'b010 : 
						(ff_counter == 4'h4) ? 3'b011 : 
						(ff_counter == 4'h5) ? 3'b100 : 
						(ff_counter == 4'h6) ? 3'b101 : 
						(ff_counter == 4'h7) ? 3'b110 : 
						(ff_counter == 4'h8) ? 3'b111 : 
						3'b000;
						
	assign memory_address = {miss_address[15:4], ff_counter[2:0], 1'b0};
	
	//flip flop for state = nxt_state
	dff state_ff(.q(state), .d(nxt_state), .wen(1'b1), .clk(clk), .rst(rst_n));
	
	//flip flops for counters
	dff adder_ff0(.q(ff_counter[0]), .d(counter[0]), .wen(1'b1), .clk(clk),.rst(rst_n));
	dff adder_ff1(.q(ff_counter[1]), .d(counter[1]), .wen(1'b1), .clk(clk),.rst(rst_n));
	dff adder_ff2(.q(ff_counter[2]), .d(counter[2]), .wen(1'b1), .clk(clk),.rst(rst_n));
	dff adder_ff3(.q(ff_counter[3]), .d(counter[3]), .wen(1'b1), .clk(clk),.rst(rst_n));
	
	//dff adder_ff_new(.q(ff_new[0]), .d(new_count[0]), .wen(1'b1), .clk(clk),.rst(rst_n));
	//dff adder_ff1_new(.q(ff_new[1]), .d(new_count[1]), .wen(1'b1), .clk(clk),.rst(rst_n));
	//dff adder_ff2_new(.q(ff_new[2]), .d(new_count[2]), .wen(1'b1), .clk(clk),.rst(rst_n));
	
	always@(*) begin
		
		//default values for state machine
		reg_nxt_state = 1'b0;
		reg_fsm_busy = 1'b0;
		reg_write_data_array = 1'b0;
		reg_write_tag_array = 1'b0;
		reg_write_memory_address = 1'b0;
		regA = ff_counter;			//we will have to set regA to 0 initially (somehow)
		regB = 4'b0000;
		memory_enable = 1'b0;
		case(state)
			//IDLE state
			1'b0:
				case(miss_detected)
					//stay here
					1'b0: begin
						reg_nxt_state = 1'b0;
						regA = 4'b0000;		//reset counter
					//WAIT state
					end
					1'b1: begin
						regA = 4'b0000;		//reset counter
						memory_enable = 1'b1;
						reg_nxt_state = 1'b1;
						reg_fsm_busy = 1'b1;
						reg_write_memory_address = 1'b1;
						regB = 4'b0001;		//increment the counter
						//B_new = 3'b111;
						end
				endcase
			//WAIT state
			1'b1:
				case(ff_counter == 4'b1001)
					//keep receiving data	
					1'b0:
						case(memory_data_valid)	//grab 2 byte chunk
							1'b0: begin
								memory_enable = 1'b0;
								reg_nxt_state = 1'b1;
								reg_fsm_busy = 1'b1; end
							1'b1: begin
								regB = 4'b0001;		//increment the counter
								reg_nxt_state = 1'b1;
								reg_write_data_array = 1'b1;
								reg_fsm_busy = 1'b1; 
								memory_enable = ff_counter[3] ? 1'b0 : 1'b1;
								reg_write_tag_array = (ff_counter == 4'b1000) ? 1'b1 : 1'b0; 	end
						endcase
					//done receiving
					1'b1: begin
						reg_nxt_state = 1'b0; 
						regA = 4'b0000;	end
					


				endcase
						
					
			
		endcase
		

	end
	
	//4 bit adder to indicate all chunks received
	CLA4bit adder(.A(A), .B(B), .SUB(1'b0), .SUM(counter), .Cout());
	
	//3 bit adder to indicate all chunks received
	//CLA3bit adder(.A(A_new), .B(B_new), .SUB(1'b0), .SUM(new_count), .Cout());
						
endmodule
