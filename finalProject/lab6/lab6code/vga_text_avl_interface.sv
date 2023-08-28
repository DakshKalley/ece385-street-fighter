/************************************************************************
Avalon-MM Interface VGA Text mode display

Register Map:
0x000-0x0257 : VRAM, 80x30 (2400 byte, 600 word) raster order (first column then row)
0x258        : control register

VRAM Format:
X->
[ 31  30-24][ 23  22-16][ 15  14-8 ][ 7    6-0 ]
[IV3][CODE3][IV2][CODE2][IV1][CODE1][IV0][CODE0]

IVn = Draw inverse glyph
CODEn = Glyph code from IBM codepage 437

Control Register Format:
[[31-25][24-21][20-17][16-13][ 12-9][ 8-5 ][ 4-1 ][   0    ] 
[[RSVD ][FGD_R][FGD_G][FGD_B][BKG_R][BKG_G][BKG_B][RESERVED]

VSYNC signal = bit which flips on every Vsync (time for new frame), used to synchronize software
BKG_R/G/B = Background color, flipped with foreground when IVn bit is set
FGD_R/G/B = Foreground color, flipped with background when Inv bit is set

************************************************************************/
`define NUM_REGS 601 //80*30 characters / 4 characters per register
`define CTRL_REG 600 //index of control register

module vga_text_avl_interface (
	// Avalon Clock Input, note this clock is also used for VGA, so this must be 50Mhz
	// We can put a clock divider here in the future to make this IP more generalizable
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,					// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,			// Avalon-MM Byte Enable
	input  logic [11:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [3:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs						// VGA HS/VS
);



//logic [31:0] LOCAL_REG       [`NUM_REGS]; // Registers
//put other local variables here
logic VGA_CLK, blank, sync;
logic [9:0] drawxsig, drawysig;
logic [10:0] sprite_addr;
logic [7:0] sprite_data;
// logic [31:0] CTRL;
logic we;

logic [31:0] palette [8];

//Declare submodules..e.g. VGA controller, ROMS, etc
	font_rom font_rom_instance(.addr(sprite_addr), .data(sprite_data));
	vga_controller vga(.Clk(CLK), .Reset(RESET), .hs(hs), .vs(vs), .pixel_clk(VGA_CLK), .blank(blank), .sync(sync), .DrawX(drawxsig), .DrawY(drawysig));
	ram OCM(.address_a(AVL_ADDR[10:0]), .address_b(addr_b), .byteena_a(AVL_BYTE_EN), .byteena_b(), .clock(CLK), .data_a(AVL_WRITEDATA), .data_b(), .rden_a(AVL_READ), .rden_b(1), .wren_a(we & AVL_WRITE), .wren_b(0), .q_a(AVL_READDATA), .q_b(CP));
   
// Read and write from AVL interface to register block, note that READ waitstate = 1, so this should be in always_ff

always_ff @(posedge CLK) begin
	if (RESET) begin
		for(int i = 0; i < 8; i++) begin
			palette[i] <= 32'd0;
		end
		// CTRL <= 32'd0;
		// for(int i=0; i<`NUM_REGS; i++) begin
		// 	LOCAL_REG[i] <= 32'd0;
		// end
	end
	if(AVL_WRITE && AVL_CS) begin
	// if (AVL_ADDR == 600) begin
		if (AVL_ADDR[11] == 1) begin
			we <= 1'b0;
			palette[AVL_ADDR[2:0]] <= AVL_WRITEDATA;
			// if (AVL_BYTE_EN[0] == 1'b1)
			// begin
				// palette[AVL_ADDR[2:0]][7:0] <= AVL_WRITEDATA[7:0];
				// CTRL[7:0] <= AVL_WRITEDATA[7:0];
			// end
			// if (AVL_BYTE_EN[1] == 1'b1) 
			// begin
				// palette[AVL_ADDR[2:0]][15:8] <= AVL_WRITEDATA[15:8];
				// CTRL[15:8] <= AVL_WRITEDATA[15:8];
			// end
			// if (AVL_BYTE_EN[2] == 1'b1) 
			// begin
				// palette[AVL_ADDR[2:0]][23:16] <= AVL_WRITEDATA[23:16];
				// CTRL[23:16] <= AVL_WRITEDATA[23:16];
			// end
			// if (AVL_BYTE_EN[3] == 1'b1)
			// begin
				// palette[AVL_ADDR[2:0]][31:24] <= AVL_WRITEDATA[31:24];
				// CTRL[31:24] <= AVL_WRITEDATA[31:24];
			// end
		end
		else we <= 1'b1;
	end
	else we <= 1'b1;
end




//handle drawing (may either be combinational or sequential - or both).
logic [12:0] AC; //reg index
logic [31:0] CP; //current register
logic [15:0] C; //character
logic [10:0] addr_b;

always_comb
begin
	AC = drawxsig[9:3] + 80*drawysig[9:4];
	//CP = LOCAL_REG[AC[11:2]];
	addr_b = AC[11:1];
	// addr_b = {1'b0, AC[11:2]};

	if(AC[0] == 1)
	begin
		C = CP[31:16];
	end
	else
	begin
		C = CP[15:0];
	end
	sprite_addr = {C[14:8], drawysig[3:0]};
	

	if (!blank)
		begin
			red = 0;
			green = 0;
			blue = 0;
		end
	else
	begin
		if((C[15] && sprite_data[7 - drawxsig[2:0]]) || (!C[15] && !sprite_data[7 - drawxsig[2:0]]))
		begin
			if(C[0] == 0) //background
			begin
				red = palette[C[3:1]][12:9];
				green = palette[C[3:1]][8:5];
				blue = palette[C[3:1]][4:1];
			end
			else
			begin
				red = palette[C[3:1]][24:21];
				green = palette[C[3:1]][20:17];
				blue = palette[C[3:1]][16:13];
			end
		end
		else
		begin
			if(C[4] == 0)
			begin
				red = palette[C[7:5]][12:9];
				green = palette[C[7:5]][8:5];
				blue = palette[C[7:5]][4:1];
			end
			else
			begin
				red = palette[C[7:5]][24:21];
				green = palette[C[7:5]][20:17];
				blue = palette[C[7:5]][16:13];
			end
		end
	end


end

endmodule














































//COMMENT GRAVEYARD LOL

// two rectangle implementation
/*
logic shape_on;
logic shape2_on;

logic[10:0] shape_x = 300;
logic[10:0] shape_y = 300;
logic[10:0] shape_size_x = 20;
logic[10:0] shape_size_y = 20;

logic[10:0] shape2_x = 200;
logic[10:0] shape2_y = 200;
logic[10:0] shape2_size_x = 30;
logic[10:0] shape2_size_y = 30;

always_comb
begin:Ball_on_proc
	if (drawxsig >= shape_x && drawxsig < shape_x + shape_size_x &&
		drawysig >= shape_y && drawysig < shape_y + shape_size_y)
	begin
		shape_on = 1'b1;
		shape2_on = 1'b0;
	end
	else if (drawxsig >= shape2_x && drawxsig < shape2_x + shape2_size_x &&
		drawysig >= shape2_y && drawysig < shape2_y + shape2_size_y)
	begin
		shape_on = 1'b0;
		shape2_on = 1'b1;
	end
	else
	begin
		shape_on = 1'b0;
		shape2_on = 1'b0;
	end
end

always_comb
begin:RGB_Display
	if ((shape_on == 1'b1))
	begin
		red = 8'h00;
		green = 8'hff;
		blue = 8'hff;
	end
	else if ((shape2_on == 1'b1))
	begin
		red = 8'hff;
		green = 8'hff;
		blue = 8'h00;
	end
	else
	begin
		red = 8'h4f - drawxsig[9:3];
		green = 8'h00;
		blue = 8'h44;
	end
end
*/


	/*
	AWR <= 0;
	if (AVL_WRITE && AVL_CS) begin
		if (AVL_BYTE_EN[0] == 1'b1)
		begin
			AWR <= 1;
			a_data_in[7:0] <= AVL_WRITEDATA[7:0];
			//LOCAL_REG[AVL_ADDR][7:0] <= AVL_WRITEDATA[7:0];
		end
		if (AVL_BYTE_EN[1] == 1'b1) 
		begin
			AWR <= 1;
			a_data_in[15:8] <= AVL_WRITEDATA[15:8];
			//LOCAL_REG[AVL_ADDR][15:8] <= AVL_WRITEDATA[15:8];
		end
		if (AVL_BYTE_EN[2] == 1'b1) 
		begin
			AWR <= 1;
			a_data_in[23:16] <= AVL_WRITEDATA[23:16];
			//LOCAL_REG[AVL_ADDR][23:16] <= AVL_WRITEDATA[23:16];
		end
		if (AVL_BYTE_EN[3] == 1'b1)
		begin
			AWR <= 1;
			a_data_in[31:24] <= AVL_WRITEDATA[31:24];
			//LOCAL_REG[AVL_ADDR][31:24] <= AVL_WRITEDATA[31:24];
		end
	end
	else if (AVL_READ && AVL_CS) begin
		AWR <= 0;
		AVL_READDATA <= a_data_out;
		// AVL_READDATA <= LOCAL_REG[AVL_ADDR];
	end
	else AVL_READDATA <= 32'b0;
end
*/


	/*
	if (!blank)
		begin
			red = 0;
			green = 0;
			blue = 0;
		end
	else
		begin
			if((C[7] && sprite_data[7 - drawxsig[2:0]]) || (!C[7] && !sprite_data[7 - drawxsig[2:0]]))
			begin
				red = CTRL[12:9];
				green = CTRL[8:5];
				blue = CTRL[4:1];
				// addr_b = 600;
				// red = CP[12:9];
				// green = CP[8:5];
				// blue = CP[4:1];

				// red = LOCAL_REG[`CTRL_REG][12:9];
				// green = LOCAL_REG[`CTRL_REG][8:5];
				// blue = LOCAL_REG[`CTRL_REG][4:1];
			end
			else
			begin
				red = CTRL[24:21];
				green = CTRL[20:17];
				blue = CTRL[16:13];
				// addr_b = 600;
				// red = CP[24:21];
				// green = CP[20:17];
				// blue = CP[16:13];

				// red = LOCAL_REG[`CTRL_REG][24:21];
				// green = LOCAL_REG[`CTRL_REG][20:17];
				// blue = LOCAL_REG[`CTRL_REG][16:13];
			end
		end
		*/

		/*
	if(AC[1:0] == 2'b00)
	begin
		C = CP[7:0];
	end
	else if(AC[1:0] == 2'b01)
	begin
		C = CP[15:8];
	end
	else if(AC[1:0] == 2'b10)
	begin
		C = CP[23:16];
	end
	else
	begin
		C = CP[31:24];
	end
	sprite_addr = C*16 + drawysig[3:0];
	*/

	// if(C[4] == 0) //foreground
			// begin
			// 	red = palette[C[7:5]][12:9];
			// 	green = palette[C[7:5]][8:5];
			// 	blue = palette[C[7:5]][4:1];
			// end
			// else
			// begin
			// 	red = palette[C[7:5]][24:21];
			// 	green = palette[C[7:5]][20:17];
			// 	blue = palette[C[7:5]][16:13];
			// end

	// if(C[0] == 0)
			// begin
			// 	red = palette[C[3:1]][12:9];
			// 	green = palette[C[3:1]][8:5];
			// 	blue = palette[C[3:1]][4:1];
			// end
			// else
			// begin
			// 	red = palette[C[3:1]][24:21];
			// 	green = palette[C[3:1]][20:17];
			// 	blue = palette[C[3:1]][16:13];
			// end