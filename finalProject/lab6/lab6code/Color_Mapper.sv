//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input        [9:0] BallX_1, BallY_1, BallX_2, BallY_2, DrawX, DrawY, Ball_size,
                       input               vga_clk, blank, crouch1, crouch2, p1jab, 
                       input                int sprite_state1, 
                       input                int sprite_state2,
                       output logic [7:0]  Red, Green, Blue );
    
    logic ball_1_on, ball_2_on;
    logic [3:0] back_r, back_g, back_b;

    logic [3:0] p1_w1_r, p1_w1_g, p1_w1_b, p2_w1_r, p2_w1_g, p2_w1_b;
    logic [3:0] p1_w2_r, p1_w2_g, p1_w2_b, p2_w2_r, p2_w2_g, p2_w2_b;
    logic [3:0] p1_w3_r, p1_w3_g, p1_w3_b, p2_w3_r, p2_w3_g, p2_w3_b;
    logic [3:0] p1_w4_r, p1_w4_g, p1_w4_b, p2_w4_r, p2_w4_g, p2_w4_b;
    logic [3:0] p1_w5_r, p1_w5_g, p1_w5_b, p2_w5_r, p2_w5_g, p2_w5_b;
    logic [3:0] p1_w6_r, p1_w6_g, p1_w6_b, p2_w6_r, p2_w6_g, p2_w6_b;

    logic [3:0] p1_w1r_r, p1_w1r_g, p1_w1r_b, p2_w1r_r, p2_w1r_g, p2_w1r_b;
    logic [3:0] p1_w2r_r, p1_w2r_g, p1_w2r_b, p2_w2r_r, p2_w2r_g, p2_w2r_b;
    logic [3:0] p1_w3r_r, p1_w3r_g, p1_w3r_b, p2_w3r_r, p2_w3r_g, p2_w3r_b;
    logic [3:0] p1_w4r_r, p1_w4r_g, p1_w4r_b, p2_w4r_r, p2_w4r_g, p2_w4r_b;
    logic [3:0] p1_w5r_r, p1_w5r_g, p1_w5r_b, p2_w5r_r, p2_w5r_g, p2_w5r_b;
    logic [3:0] p1_w6r_r, p1_w6r_g, p1_w6r_b, p2_w6r_r, p2_w6r_g, p2_w6r_b;

    logic [3:0] p1_i1_r, p1_i1_g, p1_i1_b, p2_i1_r, p2_i1_g, p2_i1_b;
    logic [3:0] p1_i2_r, p1_i2_g, p1_i2_b, p2_i2_r, p2_i2_g, p2_i2_b;
    logic [3:0] p1_i3_r, p1_i3_g, p1_i3_b, p2_i3_r, p2_i3_g, p2_i3_b;
    logic [3:0] p1_i4_r, p1_i4_g, p1_i4_b, p2_i4_r, p2_i4_g, p2_i4_b;
    logic [3:0] p1_i5_r, p1_i5_g, p1_i5_b, p2_i5_r, p2_i5_g, p2_i5_b;

    logic [3:0] p1_c1_r, p1_c1_g, p1_c1_b, p2_c1_r, p2_c1_g, p2_c1_b;
    logic [3:0] p1_c2_r, p1_c2_g, p1_c2_b, p2_c2_r, p2_c2_g, p2_c2_b;
    //logic [3:0] p1_c3_r, p1_c3_g, p1_c3_b, p2_c3_r, p2_c3_g, p2_c3_b; we reuse walk1

    logic [3:0] p1_j1_r, p1_j1_g, p1_j1_b, p2_j1_r, p2_j1_g, p2_j1_b;
    logic [3:0] p1_j2_r, p1_j2_g, p1_j2_b, p2_j2_r, p2_j2_g, p2_j2_b;
    logic [3:0] p1_j3_r, p1_j3_g, p1_j3_b, p2_j3_r, p2_j3_g, p2_j3_b;
    logic [3:0] p1_j4_r, p1_j4_g, p1_j4_b, p2_j4_r, p2_j4_g, p2_j4_b;
    logic [3:0] p1_j5_r, p1_j5_g, p1_j5_b, p2_j5_r, p2_j5_g, p2_j5_b;
    logic [3:0] p1_j6_r, p1_j6_g, p1_j6_b, p2_j6_r, p2_j6_g, p2_j6_b;
    logic [3:0] p1_j7_r, p1_j7_g, p1_j7_b, p2_j7_r, p2_j7_g, p2_j7_b;

    logic [3:0] p1_jab1_r, p1_jab1_g, p1_jab1_b, p2_jab1_r, p2_jab1_g, p2_jab1_b;
    logic [3:0] p1_jab2_r, p1_jab2_g, p1_jab2_b, p2_jab2_r, p2_jab2_g, p2_jab2_b;

 
	 
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
    int DistX, DistY, SizeX, SizeY_1, SizeY_2;
	//  assign DistX = DrawX - BallX;
    // assign DistY = DrawY - BallY;
    assign SizeX = Ball_size;
    always_comb
    begin:Ball_on_proc
        SizeY_1 = Ball_size * 2;
        SizeY_2 = Ball_size * 2;

        // if(crouch1 == 1'b1)
        // begin
        //     if ((DrawX >= BallX_1 - SizeX + 2) &&
        //     (DrawX <= BallX_1 + SizeX) &&
        //     (DrawY >= BallY_1) &&
        //     (DrawY <= BallY_1 + SizeY_1))
        //         ball_1_on = 1'b1;
        //     else 
        //         ball_1_on = 1'b0;
        // end
        // else
        if(sprite_state1 == 29)
        begin
            if ((DrawX > BallX_1 - SizeX + 1) &&
        (DrawX <= BallX_1 + SizeX + (SizeX/2)) &&
        (DrawY >= BallY_1 - SizeY_1) &&
        (DrawY <= BallY_1 + SizeY_1)) 
                ball_1_on = 1'b1;
            else 
                ball_1_on = 1'b0;
        end
        else
        begin
            if ((DrawX > BallX_1 - SizeX + 1) &&
        (DrawX <= BallX_1 + SizeX) &&
        (DrawY >= BallY_1 - SizeY_1) &&
        (DrawY <= BallY_1 + SizeY_1)) 
                ball_1_on = 1'b1;
            else 
                ball_1_on = 1'b0;
        end


        // if(crouch2 == 1'b1)
        // begin
        //     if ((DrawX >= BallX_2 - SizeX) &&
        //     (DrawX <= BallX_2 + SizeX) &&
        //     (DrawY >= BallY_2) &&
        //     (DrawY <= BallY_2 + SizeY_2))
        //         ball_2_on = 1'b1;
        //     else 
        //         ball_2_on = 1'b0;
        // end
        // else
        if(sprite_state2 == 29)
        begin
            if ((DrawX > BallX_2 - SizeX + 1 - (SizeX/2)) &&
        (DrawX <= BallX_2 + SizeX) &&
        (DrawY >= BallY_2 - SizeY_2) &&
        (DrawY <= BallY_2 + SizeY_2)) 
                ball_2_on = 1'b1;
            else 
                ball_2_on = 1'b0;
        end
        else
        begin
            if ((DrawX > BallX_2 - SizeX + 1) &&
            (DrawX <= BallX_2 + SizeX) &&
            (DrawY >= BallY_2 - SizeY_2) &&
            (DrawY <= BallY_2 + SizeY_2)) 
                ball_2_on = 1'b1;
            else 
                ball_2_on = 1'b0;
        end
     end 


    always_ff @ (posedge vga_clk)
    begin:RGB_Display
        if ((sprite_state1 == 1) && (ball_1_on == 1'b1) && (p1_w1_r != 4'h4) && (p1_w1_g != 4'h7) && (p1_w1_b != 4'h6))
        begin
            Red[3:0] <= p1_w1_r;
            Green[3:0] <= p1_w1_g;
            Blue[3:0] <= p1_w1_b;
        end
        else if ((sprite_state1 == 2) && (ball_1_on == 1'b1) && (p1_w2_r != 4'h4) && (p1_w2_g != 4'h6) && (p1_w2_b != 4'h6))
        begin
            Red[3:0] <= p1_w2_r;
            Green[3:0] <= p1_w2_g;
            Blue[3:0] <= p1_w2_b;
        end
        else if ((sprite_state1 == 3) && (ball_1_on == 1'b1) && (p1_w3_r != 4'h4) && (p1_w3_g != 4'h6) && (p1_w3_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_w3_r;
            Green[3:0] <= p1_w3_g;
            Blue[3:0] <= p1_w3_b;
        end    
        else if ((sprite_state1 == 4) && (ball_1_on == 1'b1) && (p1_w4_r != 4'h4) && (p1_w4_g != 4'h6) && (p1_w4_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_w4_r;
            Green[3:0] <= p1_w4_g;
            Blue[3:0] <= p1_w4_b;
        end    
        else if ((sprite_state1 == 5) && (ball_1_on == 1'b1) && (p1_w5_r != 4'h4) && (p1_w5_g != 4'h6) && (p1_w5_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_w5_r;
            Green[3:0] <= p1_w5_g;
            Blue[3:0] <= p1_w5_b;
        end    
        else if ((sprite_state1 == 6) && (ball_1_on == 1'b1) && (p1_w6_r != 4'h4) && (p1_w6_g != 4'h6) && (p1_w6_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_w6_r;
            Green[3:0] <= p1_w6_g;
            Blue[3:0] <= p1_w6_b;
        end
        else if ((sprite_state1 == 7) && (ball_1_on == 1'b1) && (p1_w1r_r != 4'h4) && (p1_w1r_g != 4'h6) && (p1_w1r_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_w1r_r;
            Green[3:0] <= p1_w1r_g;
            Blue[3:0] <= p1_w1r_b;
        end
        else if ((sprite_state1 == 8) && (ball_1_on == 1'b1) && (p1_w2r_r != 4'h4) && (p1_w2r_g != 4'h6) && (p1_w2r_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_w2r_r;
            Green[3:0] <= p1_w2r_g;
            Blue[3:0] <= p1_w2r_b;
        end 
        else if ((sprite_state1 == 9) && (ball_1_on == 1'b1) && (p1_w3r_r != 4'h4) && (p1_w3r_g != 4'h6) && (p1_w3r_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_w3r_r;
            Green[3:0] <= p1_w3r_g;
            Blue[3:0] <= p1_w3r_b;
        end 
        else if ((sprite_state1 == 10) && (ball_1_on == 1'b1) && (p1_w4r_r != 4'h4) && (p1_w4r_g != 4'h6) && (p1_w4r_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_w4r_r;
            Green[3:0] <= p1_w4r_g;
            Blue[3:0] <= p1_w4r_b;
        end 
        else if ((sprite_state1 == 11) && (ball_1_on == 1'b1) && (p1_w5r_r != 4'h4) && (p1_w5r_g != 4'h6) && (p1_w5r_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_w5r_r;
            Green[3:0] <= p1_w5r_g;
            Blue[3:0] <= p1_w5r_b;
        end 
        else if ((sprite_state1 == 12) && (ball_1_on == 1'b1) && (p1_w6r_r != 4'h4) && (p1_w6r_g != 4'h6) && (p1_w6r_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_w6r_r;
            Green[3:0] <= p1_w6r_g;
            Blue[3:0] <= p1_w6r_b;
        end
        else if ((sprite_state1 == 13) && (ball_1_on == 1'b1) && (p1_i1_r != 4'h4) && (p1_i1_g != 4'h6) && (p1_i1_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_i1_r;
            Green[3:0] <= p1_i1_g;
            Blue[3:0] <= p1_i1_b;
        end    
        else if ((sprite_state1 == 14) && (ball_1_on == 1'b1) && (p1_i2_r != 4'h4) && (p1_i2_g != 4'h6) && (p1_i2_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_i2_r;
            Green[3:0] <= p1_i2_g;
            Blue[3:0] <= p1_i2_b;
        end    
        else if ((sprite_state1 == 15) && (ball_1_on == 1'b1) && (p1_i3_r != 4'h4) && (p1_i3_g != 4'h6) && (p1_i3_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_i3_r;
            Green[3:0] <= p1_i3_g;
            Blue[3:0] <= p1_i3_b;
        end    
        else if ((sprite_state1 == 16) && (ball_1_on == 1'b1) && (p1_i4_r != 4'h4) && (p1_i4_g != 4'h6) && (p1_i4_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_i4_r;
            Green[3:0] <= p1_i4_g;
            Blue[3:0] <= p1_i4_b;
        end    
        else if ((sprite_state1 == 17) && (ball_1_on == 1'b1) && (p1_i5_r != 4'h4) && (p1_i5_g != 4'h6) && (p1_i5_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_i5_r;
            Green[3:0] <= p1_i5_g;
            Blue[3:0] <= p1_i5_b;
        end        
        else if ((sprite_state1 == 18) && (ball_1_on == 1'b1) && (p1_w1_r != 4'h4) && (p1_w1_g != 4'h6) && (p1_w1_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_w1_r;
            Green[3:0] <= p1_w1_g;
            Blue[3:0] <= p1_w1_b;
        end        
        else if ((sprite_state1 == 19) && (ball_1_on == 1'b1) && (p1_c1_r != 4'h4) && (p1_c1_g != 4'h6) && (p1_c1_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_c1_r;
            Green[3:0] <= p1_c1_g;
            Blue[3:0] <= p1_c1_b;
        end     
        else if ((sprite_state1 == 20) && (ball_1_on == 1'b1) && (p1_c2_r != 4'h4) && (p1_c2_g != 4'h6) && (p1_c2_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_c2_r;
            Green[3:0] <= p1_c2_g;
            Blue[3:0] <= p1_c2_b;
        end     
        else if ((sprite_state1 == 21) && (ball_1_on == 1'b1) && (p1_j1_r != 4'h4) && (p1_j1_g != 4'h6) && (p1_j1_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_j1_r;
            Green[3:0] <= p1_j1_g;
            Blue[3:0] <= p1_j1_b;
        end       
        else if ((sprite_state1 == 22) && (ball_1_on == 1'b1) && (p1_j2_r != 4'h4) && (p1_j2_g != 4'h6) && (p1_j2_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_j2_r;
            Green[3:0] <= p1_j2_g;
            Blue[3:0] <= p1_j2_b;
        end
        else if ((sprite_state1 == 23) && (ball_1_on == 1'b1) && (p1_j3_r != 4'h4) && (p1_j3_g != 4'h6) && (p1_j3_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_j3_r;
            Green[3:0] <= p1_j3_g;
            Blue[3:0] <= p1_j3_b;
        end
        else if ((sprite_state1 == 24) && (ball_1_on == 1'b1) && (p1_j4_r != 4'h4) && (p1_j4_g != 4'h6) && (p1_j4_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_j4_r;
            Green[3:0] <= p1_j4_g;
            Blue[3:0] <= p1_j4_b;
        end
        else if ((sprite_state1 == 25) && (ball_1_on == 1'b1) && (p1_j5_r != 4'h4) && (p1_j5_g != 4'h6) && (p1_j5_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_j5_r;
            Green[3:0] <= p1_j5_g;
            Blue[3:0] <= p1_j5_b;
        end
        else if ((sprite_state1 == 26) && (ball_1_on == 1'b1) && (p1_j6_r != 4'h4) && (p1_j6_g != 4'h6) && (p1_j6_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_j6_r;
            Green[3:0] <= p1_j6_g;
            Blue[3:0] <= p1_j6_b;
        end
        else if ((sprite_state1 == 27) && (ball_1_on == 1'b1) && (p1_j7_r != 4'h4) && (p1_j7_g != 4'h6) && (p1_j7_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_j7_r;
            Green[3:0] <= p1_j7_g;
            Blue[3:0] <= p1_j7_b;
        end 
        else if ((sprite_state1 == 28) && (ball_1_on == 1'b1) && (p1_jab1_r != 4'h4) && (p1_jab1_g != 4'h6) && (p1_jab1_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_jab1_r;
            Green[3:0] <= p1_jab1_g;
            Blue[3:0] <= p1_jab1_b;
        end 
        else if ((sprite_state1 == 29) && (ball_1_on == 1'b1) && (p1_jab2_r != 4'h4) && (p1_jab2_g != 4'h6) && (p1_jab2_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_jab2_r;
            Green[3:0] <= p1_jab2_g;
            Blue[3:0] <= p1_jab2_b;
        end 
        else if ((sprite_state1 == 30) && (ball_1_on == 1'b1) && (p1_jab1_r != 4'h4) && (p1_jab1_g != 4'h6) && (p1_jab1_b != 4'h6)) 
        begin 
            Red[3:0] <= p1_jab1_r;
            Green[3:0] <= p1_jab1_g;
            Blue[3:0] <= p1_jab1_b;
        end 


        ////////////////////////////////////////////Player 2//////////////////////////////////////////////////////


        else if ((sprite_state2 == 1) && (ball_2_on == 1'b1) && (p2_w1_r != 4'h4) && (p2_w1_g != 4'h7) && (p2_w1_b != 4'h6))
        begin
            Red[3:0] <= p2_w1_r;
            Green[3:0] <= p2_w1_g;
            Blue[3:0] <= p2_w1_b;
        end
        else if ((sprite_state2 == 2) && (ball_2_on == 1'b1) && (p2_w2_r != 4'h4) && (p2_w2_g != 4'h6) && (p2_w2_b != 4'h6))
        begin
            Red[3:0] <= p2_w2_r;
            Green[3:0] <= p2_w2_g;
            Blue[3:0] <= p2_w2_b;
        end
        else if ((sprite_state2 == 3) && (ball_2_on == 1'b1) && (p2_w3_r != 4'h4) && (p2_w3_g != 4'h6) && (p2_w3_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_w3_r;
            Green[3:0] <= p2_w3_g;
            Blue[3:0] <= p2_w3_b;
        end    
        else if ((sprite_state2 == 4) && (ball_2_on == 1'b1) && (p2_w4_r != 4'h4) && (p2_w4_g != 4'h6) && (p2_w4_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_w4_r;
            Green[3:0] <= p2_w4_g;
            Blue[3:0] <= p2_w4_b;
        end    
        else if ((sprite_state2 == 5) && (ball_2_on == 1'b1) && (p2_w5_r != 4'h4) && (p2_w5_g != 4'h6) && (p2_w5_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_w5_r;
            Green[3:0] <= p2_w5_g;
            Blue[3:0] <= p2_w5_b;
        end    
        else if ((sprite_state2 == 6) && (ball_2_on == 1'b1) && (p2_w6_r != 4'h4) && (p2_w6_g != 4'h6) && (p2_w6_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_w6_r;
            Green[3:0] <= p2_w6_g;
            Blue[3:0] <= p2_w6_b;
        end
        else if ((sprite_state2 == 7) && (ball_2_on == 1'b1) && (p2_w1r_r != 4'h4) && (p2_w1r_g != 4'h6) && (p2_w1r_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_w1r_r;
            Green[3:0] <= p2_w1r_g;
            Blue[3:0] <= p2_w1r_b;
        end
        else if ((sprite_state2 == 8) && (ball_2_on == 1'b1) && (p2_w2r_r != 4'h4) && (p2_w2r_g != 4'h6) && (p2_w2r_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_w2r_r;
            Green[3:0] <= p2_w2r_g;
            Blue[3:0] <= p2_w2r_b;
        end 
        else if ((sprite_state2 == 9) && (ball_2_on == 1'b1) && (p2_w3r_r != 4'h4) && (p2_w3r_g != 4'h6) && (p2_w3r_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_w3r_r;
            Green[3:0] <= p2_w3r_g;
            Blue[3:0] <= p2_w3r_b;
        end 
        else if ((sprite_state2 == 10) && (ball_2_on == 1'b1) && (p2_w4r_r != 4'h4) && (p2_w4r_g != 4'h6) && (p2_w4r_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_w4r_r;
            Green[3:0] <= p2_w4r_g;
            Blue[3:0] <= p2_w4r_b;
        end 
        else if ((sprite_state2 == 11) && (ball_2_on == 1'b1) && (p2_w5r_r != 4'h4) && (p2_w5r_g != 4'h6) && (p2_w5r_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_w5r_r;
            Green[3:0] <= p2_w5r_g;
            Blue[3:0] <= p2_w5r_b;
        end 
        else if ((sprite_state2 == 12) && (ball_2_on == 1'b1) && (p2_w6r_r != 4'h4) && (p2_w6r_g != 4'h6) && (p2_w6r_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_w6r_r;
            Green[3:0] <= p2_w6r_g;
            Blue[3:0] <= p2_w6r_b;
        end
        else if ((sprite_state2 == 13) && (ball_2_on == 1'b1) && (p2_i1_r != 4'h4) && (p2_i1_g != 4'h6) && (p2_i1_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_i1_r;
            Green[3:0] <= p2_i1_g;
            Blue[3:0] <= p2_i1_b;
        end    
        else if ((sprite_state2 == 14) && (ball_2_on == 1'b1) && (p2_i2_r != 4'h4) && (p2_i2_g != 4'h6) && (p2_i2_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_i2_r;
            Green[3:0] <= p2_i2_g;
            Blue[3:0] <= p2_i2_b;
        end    
        else if ((sprite_state2 == 15) && (ball_2_on == 1'b1) && (p2_i3_r != 4'h4) && (p2_i3_g != 4'h6) && (p2_i3_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_i3_r;
            Green[3:0] <= p2_i3_g;
            Blue[3:0] <= p2_i3_b;
        end    
        else if ((sprite_state2 == 16) && (ball_2_on == 1'b1) && (p2_i4_r != 4'h4) && (p2_i4_g != 4'h6) && (p2_i4_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_i4_r;
            Green[3:0] <= p2_i4_g;
            Blue[3:0] <= p2_i4_b;
        end    
        else if ((sprite_state2 == 17) && (ball_2_on == 1'b1) && (p2_i5_r != 4'h4) && (p2_i5_g != 4'h6) && (p2_i5_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_i5_r;
            Green[3:0] <= p2_i5_g;
            Blue[3:0] <= p2_i5_b;
        end        
        else if ((sprite_state2 == 18) && (ball_2_on == 1'b1) && (p2_w1_r != 4'h4) && (p2_w1_g != 4'h6) && (p2_w1_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_w1_r;
            Green[3:0] <= p2_w1_g;
            Blue[3:0] <= p2_w1_b;
        end        
        else if ((sprite_state2 == 19) && (ball_2_on == 1'b1) && (p2_c1_r != 4'h4) && (p2_c1_g != 4'h6) && (p2_c1_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_c1_r;
            Green[3:0] <= p2_c1_g;
            Blue[3:0] <= p2_c1_b;
        end     
        else if ((sprite_state2 == 20) && (ball_2_on == 1'b1) && (p2_c2_r != 4'h4) && (p2_c2_g != 4'h6) && (p2_c2_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_c2_r;
            Green[3:0] <= p2_c2_g;
            Blue[3:0] <= p2_c2_b;
        end     
        else if ((sprite_state2 == 21) && (ball_2_on == 1'b1) && (p2_j1_r != 4'h4) && (p2_j1_g != 4'h6) && (p2_j1_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_j1_r;
            Green[3:0] <= p2_j1_g;
            Blue[3:0] <= p2_j1_b;
        end       
        else if ((sprite_state2 == 22) && (ball_2_on == 1'b1) && (p2_j2_r != 4'h4) && (p2_j2_g != 4'h6) && (p2_j2_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_j2_r;
            Green[3:0] <= p2_j2_g;
            Blue[3:0] <= p2_j2_b;
        end
        else if ((sprite_state2 == 23) && (ball_2_on == 1'b1) && (p2_j3_r != 4'h4) && (p2_j3_g != 4'h6) && (p2_j3_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_j3_r;
            Green[3:0] <= p2_j3_g;
            Blue[3:0] <= p2_j3_b;
        end
        else if ((sprite_state2 == 24) && (ball_2_on == 1'b1) && (p2_j4_r != 4'h4) && (p2_j4_g != 4'h6) && (p2_j4_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_j4_r;
            Green[3:0] <= p2_j4_g;
            Blue[3:0] <= p2_j4_b;
        end
        else if ((sprite_state2 == 25) && (ball_2_on == 1'b1) && (p2_j5_r != 4'h4) && (p2_j5_g != 4'h6) && (p2_j5_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_j5_r;
            Green[3:0] <= p2_j5_g;
            Blue[3:0] <= p2_j5_b;
        end
        else if ((sprite_state2 == 26) && (ball_2_on == 1'b1) && (p2_j6_r != 4'h4) && (p2_j6_g != 4'h6) && (p2_j6_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_j6_r;
            Green[3:0] <= p2_j6_g;
            Blue[3:0] <= p2_j6_b;
        end
        else if ((sprite_state2 == 27) && (ball_2_on == 1'b1) && (p2_j7_r != 4'h4) && (p2_j7_g != 4'h6) && (p2_j7_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_j7_r;
            Green[3:0] <= p2_j7_g;
            Blue[3:0] <= p2_j7_b;
        end 
        else if ((sprite_state2 == 28) && (ball_2_on == 1'b1) && (p2_jab1_r != 4'h4) && (p2_jab1_g != 4'h6) && (p2_jab1_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_jab1_r;
            Green[3:0] <= p2_jab1_g;
            Blue[3:0] <= p2_jab1_b;
        end 
        else if ((sprite_state2 == 29) && (ball_2_on == 1'b1) && (p2_jab2_r != 4'h4) && (p2_jab2_g != 4'h6) && (p2_jab2_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_jab2_r;
            Green[3:0] <= p2_jab2_g;
            Blue[3:0] <= p2_jab2_b;
        end 
        else if ((sprite_state2 == 30) && (ball_2_on == 1'b1) && (p2_jab1_r != 4'h4) && (p2_jab1_g != 4'h6) && (p2_jab1_b != 4'h6)) 
        begin 
            Red[3:0] <= p2_jab1_r;
            Green[3:0] <= p2_jab1_g;
            Blue[3:0] <= p2_jab1_b;
        end

        else 
        begin 
            Red[3:0] <= back_r; 
            Green[3:0] <= back_g;
            Blue[3:0] <= back_b;
        end    
        
    end 
    
    



    
    StageCrop1_example stage(.vga_clk(vga_clk), .DrawX(DrawX), .DrawY(DrawY), .blank(blank), .red(back_r), .green(back_g), .blue(back_b));

    Walk1_example p1_walk1(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_w1_r), .green(p1_w1_g), .blue(p1_w1_b));
    Walk1R_example p2_walk1(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_w1_r), .green(p2_w1_g), .blue(p2_w1_b));

    Walk2_example p1_walk2(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_w2_r), .green(p1_w2_g), .blue(p1_w2_b));
    Walk2R_example p2_walk2(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_w2_r), .green(p2_w2_g), .blue(p2_w2_b));
    
    Walk3_example p1_walk3(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_w3_r), .green(p1_w3_g), .blue(p1_w3_b));
    Walk3R_example p2_walk3(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_w3_r), .green(p2_w3_g), .blue(p2_w3_b));

    Walk4_example p1_walk4(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_w4_r), .green(p1_w4_g), .blue(p1_w4_b));
    Walk4R_example p2_walk4(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_w4_r), .green(p2_w4_g), .blue(p2_w4_b));
    
    Walk5_example p1_walk5(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_w5_r), .green(p1_w5_g), .blue(p1_w5_b));
    Walk5R_example p2_walk5(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_w5_r), .green(p2_w5_g), .blue(p2_w5_b));

    Walk6_example p1_walk6(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_w6_r), .green(p1_w6_g), .blue(p1_w6_b));
    Walk6R_example p2_walk6(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_w6_r), .green(p2_w6_g), .blue(p2_w6_b));

    WalkB1_example p1_walkB1(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_w1r_r), .green(p1_w1r_g), .blue(p1_w1r_b));
    WalkB1R_example p2_walkB1(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_w1r_r), .green(p2_w1r_g), .blue(p2_w1r_b));

    WalkB2_example p1_walkB2(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_w2r_r), .green(p1_w2r_g), .blue(p1_w2r_b));
    WalkB2R_example p2_walkB2(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_w2r_r), .green(p2_w2r_g), .blue(p2_w2r_b));
    
    WalkB3_example p1_walkB3(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_w3r_r), .green(p1_w3r_g), .blue(p1_w3r_b));
    WalkB3R_example p2_walkB3(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_w3r_r), .green(p2_w3r_g), .blue(p2_w3r_b));

    WalkB4_example p1_walkB4(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_w4r_r), .green(p1_w4r_g), .blue(p1_w4r_b));
    WalkB4R_example p2_walkB4(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_w4r_r), .green(p2_w4r_g), .blue(p2_w4r_b));
    
    WalkB5_example p1_walkB5(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_w5r_r), .green(p1_w5r_g), .blue(p1_w5r_b));
    WalkB5R_example p2_walkB5(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_w5r_r), .green(p2_w5r_g), .blue(p2_w5r_b));

    WalkB6_example p1_walkB6(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_w6r_r), .green(p1_w6r_g), .blue(p1_w6r_b));
    WalkB6R_example p2_walkB6(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_w6r_r), .green(p2_w6r_g), .blue(p2_w6r_b));

    Idle1_example p1_Idle1(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_i1_r), .green(p1_i1_g), .blue(p1_i1_b));
    Idle1R_example p2_Idle1(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_i1_r), .green(p2_i1_g), .blue(p2_i1_b));

    Idle2_example p1_Idle2(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_i2_r), .green(p1_i2_g), .blue(p1_i2_b));
    Idle2R_example p2_Idle2(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_i2_r), .green(p2_i2_g), .blue(p2_i2_b));

    Idle3_example p1_Idle3(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_i3_r), .green(p1_i3_g), .blue(p1_i3_b));
    Idle3R_example p2_Idle3(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_i3_r), .green(p2_i3_g), .blue(p2_i3_b));

    Idle4_example p1_Idle4(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_i4_r), .green(p1_i4_g), .blue(p1_i4_b));
    Idle4R_example p2_Idle4(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_i4_r), .green(p2_i4_g), .blue(p2_i4_b));

    Idle5_example p1_Idle5(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_i5_r), .green(p1_i5_g), .blue(p1_i5_b));
    Idle5R_example p2_Idle5(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_i5_r), .green(p2_i5_g), .blue(p2_i5_b));

    crouch1_example p1_crouch1(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_c1_r), .green(p1_c1_g), .blue(p1_c1_b));
    crouch1R_example p2_crouch1(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_c1_r), .green(p2_c1_g), .blue(p2_c1_b));

    crouch2_example p1_crouch2(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_c2_r), .green(p1_c2_g), .blue(p1_c2_b));
    crouch2R_example p2_crouch2(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_c2_r), .green(p2_c2_g), .blue(p2_c2_b));

    Jump1_example p1_Jump1(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_j1_r), .green(p1_j1_g), .blue(p1_j1_b));
    Jump1R_example p2_Jump1(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_j1_r), .green(p2_j1_g), .blue(p2_j1_b));

    Jump2_example p1_Jump2(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_j2_r), .green(p1_j2_g), .blue(p1_j2_b));
    Jump2R_example p2_Jump2(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_j2_r), .green(p2_j2_g), .blue(p2_j2_b));

    Jump3_example p1_Jump3(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_j3_r), .green(p1_j3_g), .blue(p1_j3_b));
    Jump3R_example p2_Jump3(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_j3_r), .green(p2_j3_g), .blue(p2_j3_b));

    Jump4_example p1_Jump4(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_j4_r), .green(p1_j4_g), .blue(p1_j4_b));
    Jump4R_example p2_Jump4(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_j4_r), .green(p2_j4_g), .blue(p2_j4_b));

    Jump5_example p1_Jump5(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_j5_r), .green(p1_j5_g), .blue(p1_j5_b));
    Jump5R_example p2_Jump5(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_j5_r), .green(p2_j5_g), .blue(p2_j5_b));

    Jump6_example p1_Jump6(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_j6_r), .green(p1_j6_g), .blue(p1_j6_b));
    Jump6R_example p2_Jump6(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_j6_r), .green(p2_j6_g), .blue(p2_j6_b));

    Jump7_example p1_Jump7(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_j7_r), .green(p1_j7_g), .blue(p1_j7_b));
    Jump7R_example p2_Jump7(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_j7_r), .green(p2_j7_g), .blue(p2_j7_b));

    Jab1_example p1_Jab1(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_jab1_r), .green(p1_jab1_g), .blue(p1_jab1_b));
    Jab1R_example p2_Jab1(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_jab1_r), .green(p2_jab1_g), .blue(p2_jab1_b));

    Jab2_example p1_Jab2(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_1 - SizeX)), .DrawY(DrawY - (BallY_1 - SizeY_1)), .blank(blank), .red(p1_jab2_r), .green(p1_jab2_g), .blue(p1_jab2_b));
    Jab2R_example p2_Jab2(.vga_clk(vga_clk), .DrawX(DrawX - (BallX_2 - SizeX - SizeX/2)), .DrawY(DrawY - (BallY_2 - SizeY_2)), .blank(blank), .red(p2_jab2_r), .green(p2_jab2_g), .blue(p2_jab2_b));

endmodule

