`define MEM_PATH tb.u_apb_sram.u_mem 
//tb-->instantiate apb_sram u_apb_sram --> instantiate sp_sram u_mem

`timescale 1ns/10ps
module apb_ms_model(
	//outputS of the model, generating stimuli for the apb_sram
	psel,
	penable,
	paddr,
	pwrite,
	pwdata,
	
	//outputs of apb_sram, these values input into model to check if apb_sram works correctly
	pready,
	prdata,
	
	//global signals
	clk,
	rstn
);

	parameter mem_depth = 1024;
	parameter mem_abit = 10;
	parameter mem_dw = 32;
	
	input wire clk, rstn;
	
	output reg psel;
	output reg penable;
	output reg [11 :0] paddr; //why 32 bits? not 12 bits?
	//output reg [31 :0] paddr;
	output reg pwrite;
	
	output reg [31:0] pwdata;
	
	input wire pready;
	input wire [31:0] prdata;
	
	//write operation
	task apb_write;
	//input [31:0] addr; //why 32 bits?
	input [11:0] addr;
	input [31:0] wdata;
	
	begin
		@(posedge clk); #1;
		psel = 1; pwrite = 1; paddr = addr; pwdata = wdata;  //T1, set values for all model outputs
		@(posedge clk); #1; 
		
		penable = 1;//T2, pull up penable
		
		@(negedge clk);
		while(~pready) begin
			@(negedge clk);
		end		// if pready = 0, then wait
		
		@(posedge clk); #1; //until pready = 1, T3 or Tn
		psel = 0; penable = 0;
	end
	endtask
	
	
	//read operation
	task apb_read;
	//input [31:0] addr;
	input [11:0] addr;
	output [31:0] rdata;
	
	begin
		@(posedge clk); #1;
		psel = 1; pwrite = 0; paddr = addr; //T1
		
		@(posedge clk); #1;
		penable = 1;  //T2
		
		@(negedge clk);
		while(~pready) begin
			@(negedge clk);
		end
		
		rdata = prdata;  // prdata和pready在一个周期
		@(posedge clk); #1;
		psel = 0; penable = 0;
	end
	endtask
	//
	
	//SRAM data initial 
	
	integer cnt;
	//reg [31:0] addr; //???
	reg [11:0] addr;
	
	reg [31:0] wdata;
	reg [31:0] rdata;
	reg [31:0] rand ;
	reg [31:0] ref_data;
	
	initial begin
		psel = 0;
		penable = 0;
		paddr = 0;
		pwrite = 0;
		pwdata = 0;
		
		$display("model works");
		@(posedge rstn);
		
		// sram data initial
		for(cnt = 0; cnt < mem_depth; cnt = cnt + 1) begin
			//$display("111");
			wdata = $random();
			`MEM_PATH.mem[cnt] = wdata; //sp_sram 中的mem signal
			//$display("222");
			#1;
		end
		
		repeat(2) @(posedge clk); #1;
		$display("initialization works");
		
		//	boarder addr check
		for(cnt = 0; cnt < 4; cnt = cnt+1) begin
			if((cnt == 0)||(cnt==2)) begin
				addr = 0;					//cnt = 0|2, addr = 12'b0?? Sky的答案里是32'b0
				$display("111");
			end
			else
				addr = (mem_depth-1) << 2; //cnt = 1|3, addr = {111111111100}
			
			if(cnt < 2) begin // write test
				wdata = $random();
				apb_write(addr,wdata);
				
				@(negedge clk);
				ref_data = `MEM_PATH.mem[addr>>2]; //写入后apb_sram中 sp_sram 中的mem对应addr的值
				$display("cnt < 2");
				
				if(ref_data !== wdata) begin
					$display("Error: APB write error");
					repeat(2) @(posedge clk); #1;
					$finish();
				end		
			end else begin // read test
				$display("cnt >= 2");
				$display("%x",cnt);
				$display("addr is %x",addr);
				apb_read(addr,rdata);
				
				$display("333");
				ref_data = `MEM_PATH.mem[addr >> 2];
				
				
				if(ref_data !== rdata) begin
					$display("Error:APB read error");
					repeat(2) @(posedge clk); #1;
					$finish();
				end
			end
			$display("%x",cnt);
		end	
		
		$display("fixed addr works");
		// random read/write test
		for(cnt = 0; cnt < (1<<10);cnt = cnt+1) begin
			rand = $random();
			addr = {rand[2+:mem_abit],2'b0}; //10 bits random + 00
			
			if(rand[31]) begin
				wdata = $random();
				apb_write(addr,wdata);
				
				@(negedge clk);
				ref_data = `MEM_PATH.mem[addr >> 2];
				if(ref_data !== wdata) begin
					$display("Error: APB write Error");
					repeat(2) @(posedge clk); #1;
					$finish();
				end
			end else begin
				apb_read(addr, rdata);
				ref_data = `MEM_PATH.mem[addr >> 2];
				if(ref_data !== rdata) begin
					$display("Error: APB read Error");
					repeat(2) @(posedge clk); #1;
					$finish();
				end
			end
		end
		
		repeat(10) @(posedge clk); #1;
		$display("OK: sim pass");
		$finish();
		
	end

endmodule