module Jump4_example (
	input logic vga_clk,
	input logic [9:0] DrawX, DrawY,
	input logic blank,
	output logic [3:0] red, green, blue
);

logic [12:0] rom_address;
logic [2:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

logic negedge_vga_clk;

// read from ROM on negedge, set pixel on posedge
assign negedge_vga_clk = ~vga_clk;

// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
// this will stretch out the sprite across the entire screen
// assign rom_address = (DrawX * 60 / 80) + ((DrawY * 90 / 120)) * 80;
//hitbox width = 80; hitbox height = 160;
//sprite width = 60; sprite height = 90;

assign rom_address = (DrawX*60)/80 + (((DrawY*90)/160) * 60);

always_ff @ (posedge vga_clk) begin
	// rom_address = (DrawX*60)/80 + (((DrawY*90)/160) * 60);
	red <= 4'h0;
	green <= 4'h0;
	blue <= 4'h0;

	if (blank) begin
		red <= palette_red;
		green <= palette_green;
		blue <= palette_blue;
	end
end

Jump4_rom Jump4_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

Jump4_palette Jump4_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

endmodule

module Jump4R_example (
	input logic vga_clk,
	input logic [9:0] DrawX, DrawY,
	input logic blank,
	output logic [3:0] red, green, blue
);

logic [12:0] rom_address;
logic [2:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

logic negedge_vga_clk;

// read from ROM on negedge, set pixel on posedge
assign negedge_vga_clk = ~vga_clk;

// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
// this will stretch out the sprite across the entire screen
// assign rom_address = (DrawX * 60 / 80) + ((DrawY * 90 / 120)) * 80;
//hitbox width = 80; hitbox height = 160;
//sprite width = 60; sprite height = 90;

assign rom_address = (59 - (DrawX*60)/80) + (((DrawY*90)/160) * 60);

always_ff @ (posedge vga_clk) begin
	// rom_address = (59 - (DrawX*60)/80) + (((DrawY*90)/160) * 60);
	red <= 4'h0;
	green <= 4'h0;
	blue <= 4'h0;

	if (blank) begin
		red <= palette_red;
		green <= palette_green;
		blue <= palette_blue;
	end
end

Jump4_rom Jump4_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

Jump4_palette Jump4_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

endmodule
