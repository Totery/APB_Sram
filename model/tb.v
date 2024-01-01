`timescale 1ns/10ps

module tb();

	parameter clk_cyc = 10.0;
	parameter mem_depth = 1024;
	parameter addr_bits = 10;

	reg clk, rstn;
	
	always #(clk_cyc/2.0) clk = ~clk;
	
	initial begin
		clk = 0; rstn = 1;
		repeat(10) @(posedge clk); rstn = 0;
		repeat(10) @(posedge clk); rstn = 1;	
	
		// repeat(1<<12) @(posedge clk);
		// $finish();
	end

	wire psel;
	wire penable;
	wire [(addr_bits+2-1):0] paddr;
	
	wire pwrite;
	wire [31:0] pwdata;
	wire pready;
	
	wire [31:0] prdata;
	
	apb_ms_model #(.mem_depth(mem_depth),.mem_abit(addr_bits)) u_apb_ms_model(
		//outputs of model, in tb, wire signals connect them
		.psel	(psel),
		.penable (penable),
		.paddr	(paddr),
		.pwrite	(pwrite),
		.pwdata	(pwdata),
		
		
		.pready	(pready),	//inputs of Model
		.prdata (prdata),	//inputs of Model
		
		.clk	(clk),
		.rstn	(rstn)
	);
	
	apb_sram_beta #(.mem_depth(mem_depth),.addr_bits(addr_bits)) u_apb_sram(
		.psel	(psel),
		.penable (penable),
		.paddr	(paddr),
		.pwrite	(pwrite),
		.pwdata	(pwdata),
		.pready	(pready),	//outputs of DUT
		.prdata (prdata),   //outputs of DUT
		
		.clk	(clk),
		.rstn	(rstn)
	);
endmodule