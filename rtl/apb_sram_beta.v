module apb_sram_beta(
	//generic inputs
	clk,
	rstn,
	
	//apb interface 
	paddr,
	pwrite, //1 write, 0 read
	psel, 
	penable,
	pwdata,
	pready,
	prdata
); 
 
	parameter mem_depth = 1024; //2^10
	parameter addr_bits = 10;
	parameter data_bits = 32;
	
	input wire clk, rstn;
	input wire [addr_bits+2-1:0] paddr;
	//Because one data element has 4 byte, it needs 2 bits to indicate which byte it is
	input wire pwrite; 
	input wire psel;
	input wire penable;
	
	input wire [data_bits-1:0] pwdata;
	
	output wire pready; // pready is wire!!
	output reg [data_bits-1:0] prdata;
	
	
	
	//1: change apb interface to sram ctrl signals
	reg [addr_bits-1:0] apb_addr;

	always @(posedge clk or negedge rstn) begin
		if(~rstn)
			apb_addr <= 'b0;
		else if(psel & !penable)
			apb_addr <= paddr[2 +: addr_bits]; //count 10 from bit 2 = [11:2]
	end
	
	//2:  write in process
	wire apb_write_w;
	reg apb_write;
	reg [data_bits-1:0] apb_wdata;
	
	assign apb_write_w = psel & pwrite & (!penable); //T1 = 1
	
	always @(posedge clk or negedge rstn) begin
		if(~rstn)
			apb_write <= 1'b0;
		else if(apb_write_w)      // T2, apb_write changes to 1
			apb_write <= 1'b1;
		else if(pready)			// if no wait, T3 apb_write changes to 0, if wait, then change to 0 after ready
			apb_write <= 1'b0;
	end
	
	always @(posedge clk or negedge rstn) begin
		if(~rstn)
			apb_wdata <= 'b0;
		else if(apb_write_w)
			apb_wdata <= pwdata; // apb_wdata valid at rising clk edge of T2
	end
	
	//3:  read out process
	wire apb_read_W;
	reg apb_read;
	
	assign apb_read_W = psel & (!penable) & (!pwrite); //T1 = 1
	
	always @(posedge clk or negedge rstn) begin
		if(~rstn)
			apb_read <= 1'b0;
		else 
			apb_read <= apb_read_W; //?????
	end
	
	// always @(posedge clk or negedge rstn) begin
		// if(~rstn)
			// apb_read <= 1'b0;
		// else if(apb_read_W)
			// apb_read <= 1'b1;
		// else if(ready)
			// apb_read <= 1'b0;
	// end
	
	//4: merge to SRAM ctrl
	wire mem_cs; //sram select
	wire mem_we; //sram write enable
	
	wire [data_bits-1:0] mem_dout;
	
	reg [1:0] mem_rd_d;
	
	always @(posedge clk or negedge rstn) begin
		if(~rstn)
			mem_rd_d <= 2'b0;
		else
			mem_rd_d <= {mem_rd_d[0],apb_read};  //??
	end
	
	
	
	assign mem_we = apb_write;
	assign mem_cs = apb_read | apb_write;
	
	always @(posedge clk) begin
		if(mem_rd_d[0]) 	//apb_read
			prdata <= mem_dout;
	end
	
	
	assign pready = (pwrite)? apb_write : mem_rd_d[1];
	
	sp_sram #(.mem_depth(mem_depth),.addr_bits(addr_bits), .data_width(data_bits)) u_mem(
		.clk	(clk),
		.en		(mem_cs),
		.we		(mem_we),
		.addr	(apb_addr),
		.din	(apb_wdata), // can direct connect to pwdata? 
		.dout	(mem_dout)			// need wire signals to connect this output
	);
endmodule