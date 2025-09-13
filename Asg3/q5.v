`timescale 1ns / 1ps

// Simple D flip-flop with active-low synchronous reset
module D_FLIP_FLOP (
	input  wire D, CLK, Rst,
	output reg  Q
);
	initial Q = 1'b0;
	always @(posedge CLK) begin
		if (Rst) Q <= 1'b0;
		else Q <= D;
	end
endmodule

// N-bit bidirectional shift register built from D flip-flops
module N_BIT_BIDIR_SHIFT_REG #(parameter MSB = 8) (
	input wire D, CLK, En, DIR, Rst,
	output wire [MSB-1:0] OUT
);
	reg [MSB-1:0] nxt;

	always @(*) begin
		// Hold by default when not enabled
		nxt = OUT;
		if (En) begin
			case (DIR)
				1'b0: nxt = {OUT[MSB-2:0], D}; // shift left, insert at LSB
				1'b1: nxt = {D, OUT[MSB-1:1]}; // shift right, insert at MSB
			endcase
		end
	end

	genvar i;
	generate
		for (i = 0; i < MSB; i = i + 1) begin : GEN_DFF
			D_FLIP_FLOP dff_i (
				nxt[i], CLK, Rst, OUT[i]
			);
		end
	endgenerate
endmodule


module TEST();

	reg D, CLK, En, DIR, Rst;
	wire [7:0] OUT;

	N_BIT_BIDIR_SHIFT_REG #(8) nbbsr (
		D, CLK, En, DIR, Rst, OUT
	);

	initial CLK = 0;
	always begin
		#5; CLK = ~CLK;
	end

	initial begin
		$dumpfile("q5.vcd");
		$dumpvars(0, TEST);
    $display("Solution by Adheesh Trivedi");
    $display("===========================");

		$display("");
		$display("Time   CLK Rst En DIR D   OUT");
		$display("-----------------------------------");
		$monitor("%6t  %b   %b   %b  %b   %b   %b", $time, CLK, Rst, En, DIR, D, OUT);

		// Reset low for a couple of clock edges (synchronous reset)
		D = 0; En = 0; DIR = 0; Rst = 1; #12;
		En = 1; #8;

		// Enable and shift left (DIR=0) while feeding data bits
		Rst = 0; DIR = 0;
		D = 1; #10;
		D = 0; #10;
		D = 1; #10;
		D = 1; #10;

		// Shift right (DIR=1) with new data pattern
		DIR = 1;
		D = 0; #10;
		D = 1; #10;
		D = 0; #10;

		// Disable shifting; output should hold
		En = 0; D = 1; DIR = 0; #20;

		// Re-enable and shift left again
		En = 1; #32;

		$finish;
	end
endmodule
