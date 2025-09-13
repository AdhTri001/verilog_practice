`timescale 1ns / 1ps

module N_BIT_BIDIR_SHIFT_REG #(parameter MSB = 8) (
	input wire D, CLK, En, DIR, Rstn,
	output reg [MSB-1:0] OUT
);
	initial OUT = {MSB{1'b0}};

	always @(posedge CLK) begin
		if (!Rstn) begin
			OUT <= {MSB{1'b0}};
		end else if (En) begin
			case (DIR)
				1'b0: OUT <= {OUT[MSB-2:0], D};
				1'b1: OUT <= {D, OUT[MSB-1:1]};
			endcase
		end
	end
endmodule


module TEST();

	reg D, CLK, En, DIR, Rstn;
	wire [7:0] OUT;

	N_BIT_BIDIR_SHIFT_REG #(8) nbbsr (
		D, CLK, En, DIR, Rstn, OUT
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
		$display("Time   CLK Rstn En DIR D   OUT");
		$display("-----------------------------------");
		$monitor("%6t %b    %b   %b  %b   %b   %b", $time, CLK, Rstn, En, DIR, D, OUT);

		// Reset low for a couple of clock edges (synchronous reset)
		D = 0; En = 0; DIR = 0; Rstn = 0; #12;
		Rstn = 1; #8;

		// Enable and shift left (DIR=0) while feeding data bits
		En = 1; DIR = 0;
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
