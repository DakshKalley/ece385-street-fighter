module StageCrop1_rom (
	input logic clock,
	input logic [14:0] address,
	output logic [2:0] q
);

logic [2:0] memory [0:19199] /* synthesis ram_init_file = "./StageCrop1/StageCrop1.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
