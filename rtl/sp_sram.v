module sp_sram(
	clk,
	//input rstn, //sp_ram no reset input
	en,
	we,
	addr,
	din,
	dout
);

	parameter mem_depth = 1024; //2^10
	parameter addr_bits = 10;
	parameter data_width = 32;
	
	input wire clk, en, we;
	input wire [addr_bits-1:0] addr;
	input wire [data_width-1:0] din;
	
	output reg [data_width-1:0] dout;
	
	reg [data_width-1:0] mem[mem_depth-1:0];
	
	always @(posedge clk) begin
		if(en) begin
			if(we) //write
				mem[addr] <= din; 
			else
				dout <= mem[addr];
		end
	end
	
	
endmodule