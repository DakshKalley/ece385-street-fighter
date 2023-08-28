//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball_1 ( input Reset, frame_clk,
					input [47:0] keycode,
					input [9:0] OppX, OppY,
					input knockback, opp_crouch,
					input int opp_hp,
               output [9:0]  BallX, BallY, BallS,
			   output int health,
			   output crouch, w_out, a_out, s_out, d_out, v_out, air, hitopp);
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
	logic [5:0] w_press, a_press, d_press, s_press, v_press;
	//logic air;
	logic jab_hold;
	int knockback_count;

	always_comb
	begin
		if (w_press != 6'b0) w_out = 1;
		else w_out = 0;
		if (a_press != 6'b0) a_out = 1;
		else a_out = 0;
		if (s_press != 6'b0) s_out = 1;
		else s_out = 0;
		if (d_press != 6'b0) d_out = 1;
		else d_out = 0;
		if (jab_hold) v_out = 1;
		else v_out = 0;
	end
	 
    parameter [9:0] Ball_X_Center=160;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=349;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis

    assign Ball_Size = 40;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
				Ball_X_Motion <= 10'd0; //Ball_X_Step;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
				knockback_count <= 0;
				health <= 10;
        end
           
        else 
        begin 
				

				 if ( ((Ball_Y_Pos + 2*Ball_Size) > (Ball_Y_Max - 50)))  // Ball is at the bottom edge, BOUNCE!
					  begin
						// Ball_Y_Motion <= 10'd0;
					  	// Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);  // 2's complement.
						Ball_Y_Motion <= 0;
						air = 1'b0;
					  end 
				 else if ( (Ball_Y_Pos - Ball_Size) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
					  begin
						// Ball_Y_Motion <= 10'd0;
					  	Ball_Y_Motion <= Ball_Y_Step;
					  end
				  else if ( (Ball_X_Pos + Ball_Size) >= Ball_X_Max )  // Ball is at the Right edge, BOUNCE!
					  begin
						// Ball_X_Motion <= 10'd0;
					  	Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);  // 2's complement.
					  end
				else if (knockback_count > 0)
				begin
					if (knockback_count < 30)
					begin
						Ball_X_Motion <= -3;
						if (air == 1'b1) Ball_Y_Motion <= Ball_Y_Motion + 1;
						knockback_count <= knockback_count+1;
					end						
					else
					begin
						knockback_count <= 0;
						health <= health - 1;
					end
				end
				else if (knockback && !crouch)
				begin
					if (hitopp)
					begin
						Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1); 
						hitopp <= 0;
					end
					else knockback_count <= 1;
					//Ball_X_Motion <= 10;
				end
				else if (((Ball_X_Pos + Ball_Size + (Ball_Size/2) - 10) >= (OppX - Ball_Size)) && (jab_hold == 1) && !opp_crouch)
				begin
					hitopp <= 1;
				end
				else if ( ((Ball_X_Pos + Ball_Size) >= (OppX - Ball_Size + 10)) && !knockback)  // Prevent Collision
					  begin
					  	Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);  // 2's complement.
					  end
				 else if ( (Ball_X_Pos - Ball_Size) <= Ball_X_Min )  // Ball is at the Left edge, BOUNCE!
					  begin
						// Ball_X_Motion <= 10'd0;
					  	Ball_X_Motion <= Ball_X_Step;
					  end
				 else if (air == 1'b1)
				 begin
					Ball_X_Motion <= Ball_X_Motion;
					Ball_Y_Motion <= Ball_Y_Motion + 1;
				 end
				 else 
					  begin
						hitopp <= 0;
						Ball_X_Motion <= Ball_X_Motion;
						Ball_Y_Motion <= Ball_Y_Motion;

						if(a_press != 6'd0 && !crouch)
						begin
							Ball_X_Motion <= -2;
						end
						
						if(d_press != 6'd0 && !crouch)
						begin
							Ball_X_Motion <= 2;
						end

						if(s_press != 6'd0)
						begin
							Ball_Y_Motion <= 0;
							Ball_X_Motion <= 0;
							crouch <= 1'b1;
						end
						else crouch <= 1'b0;

						if(w_press != 6'd0 && !crouch)
						begin
							Ball_Y_Motion <= -15;
							air <= 1'b1;
						end
						
						if (v_press != 6'd0 && !air && !crouch && (jab_hold == 1'b0))
						begin
							Ball_X_Motion <= 0;
							Ball_Y_Motion <= 0;
							jab_hold <= 1;
						end
						else if (v_press == 6'd0) jab_hold <= 0;
						
						if (jab_hold == 1)
						begin
							Ball_X_Motion <= 0;
							Ball_Y_Motion <= 0;
						end
						
						if((a_press == 6'd0 && d_press == 6'd0 && s_press == 6'd0 && w_press == 6'd0))
						begin
							Ball_X_Motion <= 0;
							Ball_Y_Motion <= 0;
						end

						if ((opp_hp == 0) || (health == 0))
						begin
							Ball_X_Motion <= 0;
							Ball_X_Pos <= Ball_X_Center;
							Ball_Y_Motion <= 0;
							Ball_Y_Pos <= Ball_Y_Center;
						end
						
					  end


				if ( (Ball_Y_Pos + 2*Ball_Size) > (Ball_Y_Max - 50) ) Ball_Y_Pos <= Ball_Y_Center;
				else Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
				Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);

				if ((opp_hp == 0) || (health == 0))
				begin
					Ball_X_Motion <= 0;
					Ball_X_Pos <= Ball_X_Center;
					Ball_Y_Motion <= 0;
					Ball_Y_Pos <= Ball_Y_Center;
				end

		end
	end  
       
	always_comb
	begin
		a_press = 6'd0;
		d_press = 6'd0;
		s_press = 6'd0;
		w_press = 6'd0;
		v_press = 6'd0;
		case (keycode[7:0])
			8'h04 : a_press[0] = 1'b1;
			8'h07 : d_press[0] = 1'b1;
			8'h16 : s_press[0] = 1'b1;
			8'h1A : w_press[0] = 1'b1;
			8'h19 : v_press[0] = 1'b1;
			default: begin
				a_press[0] = 1'b0;
				d_press[0] = 1'b0;
				s_press[0] = 1'b0;
				w_press[0] = 1'b0;
				v_press[0] = 1'b0;
			end
		endcase

		case (keycode[15:8])
			8'h04 : a_press[1] = 1'b1;
			8'h07 : d_press[1] = 1'b1;
			8'h16 : s_press[1] = 1'b1;
			8'h1A : w_press[1] = 1'b1;
			8'h19 : v_press[1] = 1'b1;
			default: begin
				a_press[1] = 1'b0;
				d_press[1] = 1'b0;
				s_press[1] = 1'b0;
				w_press[1] = 1'b0;
				v_press[1] = 1'b0;
			end
		endcase

		case (keycode[23:16])
			8'h04 : a_press[2] = 1'b1;
			8'h07 : d_press[2] = 1'b1;
			8'h16 : s_press[2] = 1'b1;
			8'h1A : w_press[2] = 1'b1;
			8'h19 : v_press[2] = 1'b1;
			default: begin
				a_press[2] = 1'b0;
				d_press[2] = 1'b0;
				s_press[2] = 1'b0;
				w_press[2] = 1'b0;
				v_press[2] = 1'b0;
			end
		endcase

		case (keycode[31:24])
			8'h04 : a_press[3] = 1'b1;
			8'h07 : d_press[3] = 1'b1;
			8'h16 : s_press[3] = 1'b1;
			8'h1A : w_press[3] = 1'b1;
			8'h19 : v_press[3] = 1'b1;
			default: begin
				a_press[3] = 1'b0;
				d_press[3] = 1'b0;
				s_press[3] = 1'b0;
				w_press[3] = 1'b0;
				v_press[3] = 1'b0;
			end
		endcase

		case (keycode[39:32])
			8'h04 : a_press[4] = 1'b1;
			8'h07 : d_press[4] = 1'b1;
			8'h16 : s_press[4] = 1'b1;
			8'h1A : w_press[4] = 1'b1;
			8'h19 : v_press[4] = 1'b1;
			default: begin
				a_press[4] = 1'b0;
				d_press[4] = 1'b0;
				s_press[4] = 1'b0;
				w_press[4] = 1'b0;
				v_press[4] = 1'b0;
			end
		endcase

		case (keycode[47:40])
			8'h04 : a_press[5] = 1'b1;
			8'h07 : d_press[5] = 1'b1;
			8'h16 : s_press[5] = 1'b1;
			8'h1A : w_press[5] = 1'b1;
			8'h19 : v_press[5] = 1'b1;
			default: begin
				a_press[5] = 1'b0;
				d_press[5] = 1'b0;
				s_press[5] = 1'b0;
				w_press[5] = 1'b0;
				v_press[5] = 1'b0;
			end
		endcase
	end

    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
   
    assign BallS = Ball_Size;
    

endmodule


module  ball_2 ( input Reset, frame_clk,
					input [47:0] keycode,
					input [9:0] OppX, OppY,
					input knockback, opp_crouch,
					input int opp_hp,
               output [9:0]  BallX, BallY, BallS,
			   output int health,
			   output crouch, up_out, left_out, down_out, right_out, o_out, air, hitopp);
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
	logic [5:0] up_press, left_press, right_press, down_press, o_press;
	//logic air;
	logic jab_hold;
	int knockback_count;

	always_comb
	begin
		if (up_press != 6'b0) up_out = 1;
		else up_out = 0;
		if (left_press != 6'b0) left_out = 1;
		else left_out = 0;
		if (down_press != 6'b0) down_out = 1;
		else down_out = 0;
		if (right_press != 6'b0) right_out = 1;
		else right_out = 0;
		if (jab_hold) o_out = 1;
		else o_out = 0;
	end
	 
    parameter [9:0] Ball_X_Center=480;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=349;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis

    assign Ball_Size = 40;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
				Ball_X_Motion <= 10'd0; //Ball_X_Step;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
				knockback_count <= 0;
				health <= 10;
        end
           
        else 
        begin 
				
				 if ( (Ball_Y_Pos + 2*Ball_Size) > (Ball_Y_Max - 50))  // Ball is at the bottom edge, BOUNCE!
					  begin
						// Ball_Y_Motion <= 10'd0;
						// Ball_Y_Pos <= Ball_Y_Center;
						Ball_Y_Motion <= 0;
					  	// Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);  // 2's complement.
						air = 1'b0;
					  end
					  
				 else if ( (Ball_Y_Pos - Ball_Size) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
					  begin
						// Ball_Y_Motion <= 10'd0;
					  	Ball_Y_Motion <= Ball_Y_Step;
					  end
					  
				  else if ( (Ball_X_Pos + Ball_Size) >= Ball_X_Max )  // Ball is at the Right edge, BOUNCE!
					  begin
						// Ball_X_Motion <= 10'd0;
					  	Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);  // 2's complement.
					  end
				else if (knockback_count > 0)
				begin
					if (knockback_count < 30)
					begin
						Ball_X_Motion <= 3;
						if (air == 1'b1) Ball_Y_Motion <= Ball_Y_Motion + 1;
						knockback_count <= knockback_count+1;
					end						
					else
					begin
						knockback_count <= 0;
						health <= health - 1;
					end
				end
				else if (knockback && !crouch)
				begin
					if (hitopp)
					begin
						Ball_X_Motion <= Ball_X_Step;
						hitopp <= 0;
					end
					else knockback_count <= 1;
					//Ball_X_Motion <= 10;
				end
				else if (((Ball_X_Pos - Ball_Size - (Ball_Size/2) + 10) <= (OppX + Ball_Size)) && (jab_hold == 1) && !opp_crouch)
				begin
					hitopp <= 1;
				end
				else if ( ((Ball_X_Pos - Ball_Size) <= (OppX + Ball_Size - 10)) && !knockback)  //Prevent Collision
					  begin
						// Ball_X_Motion <= 10'd0;
					  	Ball_X_Motion <= Ball_X_Step;  // 2's complement.
					  end
				 else if ( (Ball_X_Pos - Ball_Size) <= Ball_X_Min )  // Ball is at the Left edge, BOUNCE!
					  begin
						// Ball_X_Motion <= 10'd0;
					  	Ball_X_Motion <= Ball_X_Step;
					  end
				 else if (air == 1'b1)
				 begin
					Ball_X_Motion <= Ball_X_Motion;
					Ball_Y_Motion <= Ball_Y_Motion + 1;
				 end
				 else 
					  begin
						hitopp <= 0;
						Ball_X_Motion <= Ball_X_Motion;
						Ball_Y_Motion <= Ball_Y_Motion;

						if(left_press != 6'd0 && !crouch)
						begin
							Ball_X_Motion <= -2;
						end
						
						if(right_press != 6'd0 && !crouch)
						begin
							Ball_X_Motion <= 2;
						end

						if(down_press != 6'd0)
						begin
							Ball_Y_Motion <= 0;
							Ball_X_Motion <= 0;
							crouch <= 1'b1;
						end
						else crouch <= 1'b0;

						if(up_press != 6'd0 && !crouch)
						begin
							Ball_Y_Motion <= -15;
							air <= 1'b1;
						end

						if (o_press != 6'd0 && !air && !crouch && (jab_hold == 1'b0))
						begin
							Ball_X_Motion <= 0;
							Ball_Y_Motion <= 0;
							jab_hold <= 1;
						end
						else if (o_press == 6'd0) jab_hold <= 0;
						
						if (jab_hold == 1)
						begin
							Ball_X_Motion <= 0;
							Ball_Y_Motion <= 0;
						end
						
						
						if(left_press == 6'd0 && right_press == 6'd0 && down_press == 6'd0 && up_press == 6'd0)
						begin
							Ball_X_Motion <= 0;
							Ball_Y_Motion <= 0;
						end
						
						if ((opp_hp == 0) || (health == 0))
						begin
							Ball_X_Motion <= 0;
							Ball_X_Pos <= Ball_X_Center;
							Ball_Y_Motion <= 0;
							Ball_Y_Pos <= Ball_Y_Center;
						end

					  end


				if ( (Ball_Y_Pos + 2*Ball_Size) > (Ball_Y_Max - 50) ) Ball_Y_Pos <= Ball_Y_Center;
				else Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
				Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);

				if ((opp_hp == 0) || (health == 0))
				begin
					Ball_X_Motion <= 0;
					Ball_X_Pos <= Ball_X_Center;
					Ball_Y_Motion <= 0;
					Ball_Y_Pos <= Ball_Y_Center;
				end

			
		end  
    end
       
	always_comb
	begin
		left_press = 6'd0;
		right_press = 6'd0;
		down_press = 6'd0;
		up_press = 6'd0;
		o_press = 6'd0;

		case (keycode[7:0])
			8'h50 : left_press[0] = 1'b1;
			8'h4f : right_press[0] = 1'b1;
			8'h51 : down_press[0] = 1'b1;
			8'h52 : up_press[0] = 1'b1;
			8'h12 : o_press[0] = 1'b1;
			default: begin
				left_press[0] = 1'b0;
				right_press[0] = 1'b0;
				down_press[0] = 1'b0;
				up_press[0] = 1'b0;
				o_press[0] = 1'b0;
			end
		endcase

		case (keycode[15:8])
			8'h50 : left_press[1] = 1'b1;
			8'h4f : right_press[1] = 1'b1;
			8'h51 : down_press[1] = 1'b1;
			8'h52 : up_press[1] = 1'b1;
			8'h12 : o_press[1] = 1'b1;
			default: begin
				left_press[1] = 1'b0;
				right_press[1] = 1'b0;
				down_press[1] = 1'b0;
				up_press[1] = 1'b0;
				o_press[1] = 1'b0;
			end
		endcase

		case (keycode[23:16])
			8'h50 : left_press[2] = 1'b1;
			8'h4f : right_press[2] = 1'b1;
			8'h51 : down_press[2] = 1'b1;
			8'h52 : up_press[2] = 1'b1;
			8'h12 : o_press[2] = 1'b1;
			default: begin
				left_press[2] = 1'b0;
				right_press[2] = 1'b0;
				down_press[2] = 1'b0;
				up_press[2] = 1'b0;
				o_press[2] = 1'b0;
			end
		endcase

		case (keycode[31:24])
			8'h50 : left_press[3] = 1'b1;
			8'h4f : right_press[3] = 1'b1;
			8'h51 : down_press[3] = 1'b1;
			8'h52 : up_press[3] = 1'b1;
			8'h12 : o_press[3] = 1'b1;
			default: begin
				left_press[3] = 1'b0;
				right_press[3] = 1'b0;
				down_press[3] = 1'b0;
				up_press[3] = 1'b0;
				o_press[3] = 1'b0;
			end
		endcase

		case (keycode[39:32])
			8'h50 : left_press[4] = 1'b1;
			8'h4f : right_press[4] = 1'b1;
			8'h51 : down_press[4] = 1'b1;
			8'h52 : up_press[4] = 1'b1;
			8'h12 : o_press[4] = 1'b1;
			default: begin
				left_press[4] = 1'b0;
				right_press[4] = 1'b0;
				down_press[4] = 1'b0;
				up_press[4] = 1'b0;
				o_press[4] = 1'b0;
			end
		endcase

		case (keycode[47:40])
			8'h50 : left_press[5] = 1'b1;
			8'h4f : right_press[5] = 1'b1;
			8'h51 : down_press[5] = 1'b1;
			8'h52 : up_press[5] = 1'b1;
			8'h12 : o_press[5] = 1'b1;
			default: begin
				left_press[5] = 1'b0;
				right_press[5] = 1'b0;
				down_press[5] = 1'b0;
				up_press[5] = 1'b0;
				o_press[5] = 1'b0;
			end
		endcase
	end

    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
   
    assign BallS = Ball_Size;
    

endmodule






















/*
/ GRAVEYARD

else if(keycode[31:24] == 8'h16)
						begin
							Ball_Y_Motion <= 1;
							Ball_X_Motion <= Ball_X_Motion;
						end
						else if(keycode[31:24] == 8'h1A)
						begin
							Ball_Y_Motion <= -1;
							Ball_X_Motion <= Ball_X_Motion;
						end
						else if(keycode[23:16] == 8'h04)
						begin
							Ball_X_Motion <= -1;
							Ball_Y_Motion <= 0;
						end
						else if(keycode[23:16] == 8'h07)
						begin
							Ball_X_Motion <= 1;
							Ball_Y_Motion <= 0;
						end
						else if(keycode[23:16] == 8'h16)
						begin
							Ball_Y_Motion <= 1;
							Ball_X_Motion <= 0;
						end
						else if(keycode[23:16] == 8'h1A)
						begin
							Ball_Y_Motion <= -1;
							Ball_X_Motion <= 0;
						end
						else if(keycode[15:8] == 8'h04)
						begin
							Ball_X_Motion <= -1;
							Ball_Y_Motion <= 0;
						end
						else if(keycode[15:8] == 8'h07)
						begin
							Ball_X_Motion <= 1;
							Ball_Y_Motion <= 0;
						end
						else if(keycode[15:8] == 8'h16)
						begin
							Ball_Y_Motion <= 1;
							Ball_X_Motion <= 0;
						end
						else if(keycode[15:8] == 8'h1A)
						begin
							Ball_Y_Motion <= -1;
							Ball_X_Motion <= 0;
						end
						else if(keycode[7:0] == 8'h04)
						begin
							Ball_X_Motion <= -1;
							Ball_Y_Motion <= 0;
						end
						else if(keycode[7:0] == 8'h07)
						begin
							Ball_X_Motion <= 1;
							Ball_Y_Motion <= 0;
						end
						else if(keycode[7:0] == 8'h16)
						begin
							Ball_Y_Motion <= 1;
							Ball_X_Motion <= 0;
						end
						else if(keycode[7:0] == 8'h1A)
						begin
							Ball_Y_Motion <= -1;
							Ball_X_Motion <= 0;
						end
						else
						begin
							Ball_X_Motion <= 0;
							Ball_Y_Motion <= 0;
						end


						case (keycode[7:0])
						8'h50 : begin

									Ball_X_Motion <= -1;//A
									Ball_Y_Motion<= 0;
								end
								
						8'h4f : begin
									
								Ball_X_Motion <= 1;//D
								Ball_Y_Motion <= 0;
								end

								
						8'h51 : begin

								Ball_Y_Motion <= 1;//S
								Ball_X_Motion <= 0;
								end
								
						8'h52 : begin
								Ball_Y_Motion <= -1;//W
								Ball_X_Motion <= 0;
								end	  
						default: begin
								 Ball_Y_Motion <= 0;
								 Ball_X_Motion <= 0;
								 end
			   			endcase

						case (keycode[15:8])
						8'h50 : begin

									Ball_X_Motion <= -1;//A
									Ball_Y_Motion<= 0;
								end
								
						8'h4f : begin
									
								Ball_X_Motion <= 1;//D
								Ball_Y_Motion <= 0;
								end

								
						8'h51 : begin

								Ball_Y_Motion <= 1;//S
								Ball_X_Motion <= 0;
								end
								
						8'h52 : begin
								Ball_Y_Motion <= -1;//W
								Ball_X_Motion <= 0;
								end	  
						default: begin
								 Ball_Y_Motion <= 0;
								 Ball_X_Motion <= 0;
								 end
			   			endcase

						case (keycode[23:16])
						8'h50 : begin

									Ball_X_Motion <= -1;//A
									Ball_Y_Motion<= 0;
								end
								
						8'h4f : begin
									
								Ball_X_Motion <= 1;//D
								Ball_Y_Motion <= 0;
								end

								
						8'h51 : begin

								Ball_Y_Motion <= 1;//S
								Ball_X_Motion <= 0;
								end
								
						8'h52 : begin
								Ball_Y_Motion <= -1;//W
								Ball_X_Motion <= 0;
								end	  
						default: begin
								 Ball_Y_Motion <= 0;
								 Ball_X_Motion <= 0;
								 end
			   			endcase

						case (keycode[31:24])
						8'h50 : begin

									Ball_X_Motion <= -1;//A
									Ball_Y_Motion<= 0;
								end
								
						8'h4f : begin
									
								Ball_X_Motion <= 1;//D
								Ball_Y_Motion <= 0;
								end

								
						8'h51 : begin

								Ball_Y_Motion <= 1;//S
								Ball_X_Motion <= 0;
								end
								
						8'h52 : begin
								Ball_Y_Motion <= -1;//W
								Ball_X_Motion <= 0;
								end	  
						default: begin
								 Ball_Y_Motion <= 0;
								 Ball_X_Motion <= 0;
								 end
			   			endcase
		

								case (keycode[7:0])
						8'h04 : begin

									Ball_X_Motion <= -1;//A
									Ball_Y_Motion<= 0;
								end
								
						8'h07 : begin
									
								Ball_X_Motion <= 1;//D
								Ball_Y_Motion <= 0;
								end

								
						8'h16 : begin

								Ball_Y_Motion <= 1;//S
								Ball_X_Motion <= 0;
								end
								
						8'h1A : begin
								Ball_Y_Motion <= -1;//W
								Ball_X_Motion <= 0;
								end	  
						default: begin
								 Ball_Y_Motion <= 0;
								 Ball_X_Motion <= 0;
								 end
			   			endcase

						case (keycode[15:8])
						8'h04 : begin

									Ball_X_Motion <= -1;//A
									Ball_Y_Motion<= 0;
								end
								
						8'h07 : begin
									
								Ball_X_Motion <= 1;//D
								Ball_Y_Motion <= 0;
								end

								
						8'h16 : begin

								Ball_Y_Motion <= 1;//S
								Ball_X_Motion <= 0;
								end
								
						8'h1A : begin
								Ball_Y_Motion <= -1;//W
								Ball_X_Motion <= 0;
								end	  
						default: begin
								 Ball_Y_Motion <= 0;
								 Ball_X_Motion <= 0;
								 end
			   			endcase

						case (keycode[23:16])
						8'h04 : begin

									Ball_X_Motion <= -1;//A
									Ball_Y_Motion<= 0;
								end
								
						8'h07 : begin
									
								Ball_X_Motion <= 1;//D
								Ball_Y_Motion <= 0;
								end

								
						8'h16 : begin

								Ball_Y_Motion <= 1;//S
								Ball_X_Motion <= 0;
								end
								
						8'h1A : begin
								Ball_Y_Motion <= -1;//W
								Ball_X_Motion <= 0;
								end	  
						default: begin
								 Ball_Y_Motion <= 0;
								 Ball_X_Motion <= 0;
								 end
			   			endcase

						case (keycode[31:24])
						8'h04 : begin

									Ball_X_Motion <= -1;//A
									Ball_Y_Motion<= 0;
								end
								
						8'h07 : begin
									
								Ball_X_Motion <= 1;//D
								Ball_Y_Motion <= 0;
								end

								
						8'h16 : begin

								Ball_Y_Motion <= 1;//S
								Ball_X_Motion <= 0;
								end
								
						8'h1A : begin
								Ball_Y_Motion <= -1;//W
								Ball_X_Motion <= 0;
								end	  
						default: begin
								 Ball_Y_Motion <= 0;
								 Ball_X_Motion <= 0;
								 end
			   			endcase
			   		end

				//  if (flag == 0)
				// begin
				// 	case (keycode)
				// 		8'h04 : begin

				// 					Ball_X_Motion <= -1;//A
				// 					Ball_Y_Motion<= 0;
				// 				end
								
				// 		8'h07 : begin
									
				// 				Ball_X_Motion <= 1;//D
				// 				Ball_Y_Motion <= 0;
				// 				end

								
				// 		8'h16 : begin

				// 				Ball_Y_Motion <= 1;//S
				// 				Ball_X_Motion <= 0;
				// 				end
								
				// 		8'h1A : begin
				// 				Ball_Y_Motion <= -1;//W
				// 				Ball_X_Motion <= 0;
				// 				end	  
				// 		default: ;
			   	// 	endcase
			   	// end
				// else flag = 0;

				
*/

