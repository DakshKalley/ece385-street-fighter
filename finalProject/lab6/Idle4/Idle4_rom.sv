module Idle4_rom (
	input logic clock,
	input logic [12:0] address,
	output logic [2:0] q
);

logic [2:0] memory [0:5399] /* synthesis ram_init_file = "./Idle4/Idle4.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
