`timescale 1ns / 1ps

module MEMORY_1P (
	input  wire clk, we,
  // address
	input  wire [6:0]  waddr, raddr,
  // Data input
	input  wire [15:0] Din,
  // Data output
	output reg  [15:0] rdata, wdata
);
	reg [15:0] mem [0:127];

	integer i;
	initial begin
		// Initialize memory to 0 for determinism
		for (i = 0; i < 128; i = i + 1) begin
			mem[i] = 16'h0000;
		end
		rdata = 16'h0000;
		wdata = 16'h0000;
	end

	always @(posedge clk) begin
		// Write path
		if (we) begin
			mem[waddr] <= Din;
			wdata <= Din;
		end

		// Read path: write-first if raddr == waddr and we is asserted
		if (we && (waddr == raddr)) begin
			rdata <= Din;
		end else begin
			rdata <= mem[raddr];
		end
	end
endmodule


module TEST();
	reg        clk, we;
	reg [6:0]  waddr, raddr;
	reg [15:0] Din;
	wire [15:0] rdata, wdata;

	MEMORY_1P mem (
		clk, we, waddr, raddr, Din, rdata, wdata
	);

	initial clk = 0;
	always begin
		#5; clk = ~clk;
	end

	initial begin
		$dumpfile("q6.vcd");
		$dumpvars(0, TEST);
    $display("Solution by Adheesh Trivedi");
    $display("===========================");

		$display("");
		$display("Time   clk we waddr raddr   Din  | rdata   wdata");
		$display("--------------------------------------------------");
		$monitor("%6t %b   %b  %3d   %3d   0x%04h | 0x%04h  0x%04h", $time, clk, we, waddr, raddr, Din, rdata, wdata);

		// Initial
		we = 0; waddr = 0; raddr = 0; Din = 16'h0000; #12;

		// Write some locations
		we = 1; waddr = 7'd3;  Din = 16'hABCD; raddr = 7'd0; #10;
		we = 1; waddr = 7'd5;  Din = 16'h1234; raddr = 7'd3; #10;
		we = 1; waddr = 7'd127; Din = 16'hDEAD; raddr = 7'd5; #10;

		// Read back
		we = 0; raddr = 7'd3; #10;
		raddr = 7'd5; #10;
		raddr = 7'd127; #10;

		// Same-cycle write/read to same address -> write-first behavior
		we = 1; waddr = 7'd8; raddr = 7'd8; Din = 16'hBEEF; #10;
		we = 0; raddr = 7'd8; #10;

		// Hold read while writing elsewhere
		raddr = 7'd5; we = 1; waddr = 7'd9; Din = 16'hCAFE; #10;
		we = 0; #10;

		$finish;
	end
endmodule
