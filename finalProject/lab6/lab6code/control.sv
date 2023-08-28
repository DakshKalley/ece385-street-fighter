package state_pkg;
	typedef enum logic [4:0] {Idle1,
                                Idle2,
                                Idle3,
                                Idle4,
                                Idle5,
                                Crouch1,
                                Crouch2,
                                Crouch3,
                                Jump1,
                                Jump2,
                                Jump3,
                                Jump4,
                                Jump5,
                                Jump6,
                                Jump7,
                                Jab1,
                                Jab2,
                                Jab3,
                                Walk1,
                                Walk2,
                                Walk3,
                                Walk4,
                                Walk5,
                                Walk6,
                                Walk1R,
                                Walk2R,
                                Walk3R,
                                Walk4R,
                                Walk5R,
                                Walk6R} state_t;
endpackage 



module fsm
    import state_pkg::*;
    (input w_in, a_in, s_in, d_in, v_in, air, Clk, Reset,
    input int health, opphp,
    output int sprite);

        state_t State, Next_state;  
        
        logic [3:0] ct, ct_next;

        always_ff @ (posedge Clk)
        begin
            if (Reset) 
            begin
                State <= Idle1;
                ct <= 4'b0000;
            end
            else if (health == 0)
            begin
                State <= Crouch3;
            end
            else
            begin
                State <= Next_state;
                ct <= ct_next;
            end 
        end

        always_comb
	    begin 
            // Default next state is staying at current state
            Next_state = State;
            ct_next = ct;

            unique case (State)
                Idle1:
                    if (opphp == 0)
                    begin
                        if (ct == 5)
                        begin
                            ct_next = 4'b0;
                            Next_state = Idle2;
                        end
                        else 
                        begin
                            ct_next = ct + 1'b1;
                            Next_state = Idle1;
                        end
                    end
                    else if (v_in == 1'b1)
                        Next_state = Jab1;
                    else if (a_in == 1'b1)
                        Next_state = Walk1R;
                    else if (d_in == 1'b1)
                        Next_state = Walk1;
                    else if (s_in == 1'b1)
                        Next_state = Crouch1;
                    else if (w_in == 1'b1)
                        Next_state = Jump1;
                    else if (ct == 5)
                    begin
                        ct_next = 4'b0;
                        Next_state = Idle2;
                    end
                    else 
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Idle1;
                    end
                Idle2:
                    if (opphp == 0)
                    begin
                        if (ct == 5)
                        begin
                            ct_next = 4'b0;
                            Next_state = Idle3;
                        end
                        else 
                        begin
                            ct_next = ct + 1'b1;
                            Next_state = Idle2;
                        end
                    end
                    else if (v_in == 1'b1)
                        Next_state = Jab1;
                    else if (a_in == 1'b1)
                        Next_state = Walk1R;
                    else if (d_in == 1'b1)
                        Next_state = Walk1;
                    else if (s_in == 1'b1)
                        Next_state = Crouch1;
                    else if (w_in == 1'b1)
                        Next_state = Jump1;
                    else if (ct == 5)
                    begin
                        ct_next = 4'b0;
                        Next_state = Idle3;
                    end
                    else 
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Idle2;
                    end
                Idle3:
                    if (opphp == 0)
                    begin
                        if (ct == 5)
                        begin
                            ct_next = 4'b0;
                            Next_state = Idle4;
                        end
                        else 
                        begin
                            ct_next = ct + 1'b1;
                            Next_state = Idle3;
                        end
                    end
                    else if (v_in == 1'b1)
                        Next_state = Jab1;
                    else if (a_in == 1'b1)
                        Next_state = Walk1R;
                    else if (d_in == 1'b1)
                        Next_state = Walk1;
                    else if (s_in == 1'b1)
                        Next_state = Crouch1;
                    else if (w_in == 1'b1)
                        Next_state = Jump1;
                    else if (ct == 5)
                    begin
                        ct_next = 4'b0;
                        Next_state = Idle4;
                    end
                    else 
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Idle3;
                    end
                Idle4:
                    if (opphp == 0)
                    begin
                        if (ct == 5)
                        begin
                            ct_next = 4'b0;
                            Next_state = Idle5;
                        end
                        else 
                        begin
                            ct_next = ct + 1'b1;
                            Next_state = Idle4;
                        end
                    end
                    else if (v_in == 1'b1)
                        Next_state = Jab1;
                    else if (a_in == 1'b1)
                        Next_state = Walk1R;
                    else if (d_in == 1'b1)
                        Next_state = Walk1;
                    else if (s_in == 1'b1)
                        Next_state = Crouch1;
                    else if (w_in == 1'b1)
                        Next_state = Jump1;
                    else if (ct == 5)
                    begin
                        ct_next = 4'b0;
                        Next_state = Idle5;
                    end
                    else 
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Idle4;
                    end
                Idle5:
                    if (opphp == 0)
                    begin
                        if (ct == 5)
                        begin
                            ct_next = 4'b0;
                            Next_state = Idle1;
                        end
                        else 
                        begin
                            ct_next = ct + 1'b1;
                            Next_state = Idle5;
                        end
                    end
                    else if (v_in == 1'b1)
                        Next_state = Jab1;
                    else if (a_in == 1'b1)
                        Next_state = Walk1R;
                    else if (d_in == 1'b1)
                        Next_state = Walk1;
                    else if (s_in == 1'b1)
                        Next_state = Crouch1;
                    else if (w_in == 1'b1)
                        Next_state = Jump1;
                    else if (ct == 5)
                    begin
                        ct_next = 4'b0;
                        Next_state = Idle1;
                    end
                    else 
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Idle5;
                    end
                Walk1:
                    if (v_in == 1'b1)
                        Next_state = Jab1;
                    else if (ct == 5)
                    begin
                        ct_next = 4'b0;
                        Next_state = Walk2;
                    end
                    else if (s_in == 1'b1)
                        Next_state = Crouch1;
                    else if (w_in == 1'b1)
                        Next_state = Jump1;
                    else if(d_in == 1'b1)
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Walk1;
                    end
                    else Next_state = Idle1;
                Walk2:
                    if (v_in == 1'b1)
                        Next_state = Jab1;
                    else if (ct == 5)
                    begin
                        ct_next = 4'b0;
                        Next_state = Walk3;
                    end
                    else if (s_in == 1'b1)
                        Next_state = Crouch1;
                    else if (w_in == 1'b1)
                        Next_state = Jump1;
                    else if(d_in == 1'b1)
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Walk2;
                    end
                    else Next_state = Idle1;
                Walk3:
                    if (v_in == 1'b1)
                        Next_state = Jab1;
                    else if (ct == 5)
                    begin
                        ct_next = 4'b0;
                        Next_state = Walk4;
                    end
                    else if (s_in == 1'b1)
                        Next_state = Crouch1;
                    else if (w_in == 1'b1)
                        Next_state = Jump1;
                    else if(d_in == 1'b1)
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Walk3;
                    end
                    else Next_state = Idle1;
                Walk4:
                    if (v_in == 1'b1)
                        Next_state = Jab1;
                    else if (ct == 5)
                    begin
                        ct_next = 4'b0;
                        Next_state = Walk5;
                    end
                    else if (s_in == 1'b1)
                        Next_state = Crouch1;
                    else if (w_in == 1'b1)
                        Next_state = Jump1;
                    else if(d_in == 1'b1)
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Walk4;
                    end
                    else Next_state = Idle1;
                Walk5:
                    if (v_in == 1'b1)
                        Next_state = Jab1;
                    else if (ct == 5)
                    begin
                        ct_next = 4'b0;
                        Next_state = Walk6;
                    end
                    else if (s_in == 1'b1)
                        Next_state = Crouch1;
                    else if (w_in == 1'b1)
                        Next_state = Jump1;
                    else if(d_in == 1'b1)
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Walk5;
                    end
                    else Next_state = Idle1;
                Walk6:
                    if (v_in == 1'b1)
                        Next_state = Jab1;
                    else if (ct == 5)
                    begin
                        ct_next = 4'b0;
                        Next_state = Walk1;
                    end
                    else if (s_in == 1'b1)
                        Next_state = Crouch1;
                    else if (w_in == 1'b1)
                        Next_state = Jump1;
                    else if(d_in == 1'b1)
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Walk6;
                    end
                    else Next_state = Idle1;
                Walk1R:
                    if (v_in == 1'b1)
                        Next_state = Jab1;
                    else if (ct == 5)
                    begin
                        ct_next = 4'b0;
                        Next_state = Walk2R;
                    end
                    else if (s_in == 1'b1)
                        Next_state = Crouch1;
                    else if (w_in == 1'b1)
                        Next_state = Jump1;
                    else if(a_in == 1'b1)
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Walk1R;
                    end
                    else Next_state = Idle1;
                Walk2R:
                    if (v_in == 1'b1)
                        Next_state = Jab1;
                    else if (ct == 5)
                    begin
                        ct_next = 4'b0;
                        Next_state = Walk3R;
                    end
                    else if (s_in == 1'b1)
                        Next_state = Crouch1;
                    else if (w_in == 1'b1)
                        Next_state = Jump1;
                    else if(a_in == 1'b1)
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Walk2R;
                    end
                    else Next_state = Idle1;
                Walk3R:
                    if (v_in == 1'b1)
                        Next_state = Jab1;
                    else if (ct == 5)
                    begin
                        ct_next = 4'b0;
                        Next_state = Walk4R;
                    end
                    else if (s_in == 1'b1)
                        Next_state = Crouch1;
                    else if (w_in == 1'b1)
                        Next_state = Jump1;
                    else if(a_in == 1'b1)
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Walk3R;
                    end
                    else Next_state = Idle1;
                Walk4R:
                    if (v_in == 1'b1)
                        Next_state = Jab1;
                    else if (ct == 5)
                    begin
                        ct_next = 4'b0;
                        Next_state = Walk5R;
                    end
                    else if (s_in == 1'b1)
                        Next_state = Crouch1;
                    else if (w_in == 1'b1)
                        Next_state = Jump1;
                    else if(a_in == 1'b1)
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Walk4R;
                    end
                    else Next_state = Idle1;
                Walk5R:
                    if (v_in == 1'b1)
                        Next_state = Jab1;
                    else if (ct == 5)
                    begin
                        ct_next = 4'b0;
                        Next_state = Walk6R;
                    end
                    else if (s_in == 1'b1)
                        Next_state = Crouch1;
                    else if (w_in == 1'b1)
                        Next_state = Jump1;
                    else if(a_in == 1'b1)
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Walk5R;
                    end
                    else Next_state = Idle1;
                Walk6R:
                    if (v_in == 1'b1)
                        Next_state = Jab1;
                    else if (ct == 5)
                    begin
                        ct_next = 4'b0;
                        Next_state = Walk1R;
                    end
                    else if (s_in == 1'b1)
                        Next_state = Crouch1;
                    else if (w_in == 1'b1)
                        Next_state = Jump1;
                    else if(a_in == 1'b1)
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Walk6R;
                    end
                    else Next_state = Idle1;
                Crouch1:
                    if (ct == 5)
                    begin
                        ct_next = 4'b0;
                        Next_state = Crouch2;
                    end
                    else if(s_in == 1'b1)
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Crouch1;
                    end
                    else Next_state = Idle1;
                Crouch2:
                    if (ct == 5)
                    begin
                        ct_next = 4'b0;
                        Next_state = Crouch3;
                    end
                    else if(s_in == 1'b1)
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Crouch2;
                    end
                    else Next_state = Crouch1;
                Crouch3:
                    if (ct == 5)
                    begin
                        ct_next = 4'b0;
                        Next_state = Crouch3;
                    end
                    else if(s_in == 1'b1)
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Crouch3;
                    end
                    else Next_state = Crouch2;
                Jump1:
                    if (ct == 2)
                    begin
                        ct_next = 4'b0;
                        Next_state = Jump2;
                    end
                    else if(air == 1'b1)
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Jump1;
                    end
                    else Next_state = Idle1;
                Jump2:
                    if (ct == 6)
                    begin
                        ct_next = 4'b0;
                        Next_state = Jump3;
                    end
                    else if(air == 1'b1)
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Jump2;
                    end
                    else Next_state = Idle1;
                Jump3:
                    if (ct == 4)
                    begin
                        ct_next = 4'b0;
                        Next_state = Jump4;
                    end
                    else if(air == 1'b1)
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Jump3;
                    end
                    else Next_state = Idle1;
                Jump4:
                    if (ct == 4)
                    begin
                        ct_next = 4'b0;
                        Next_state = Jump5;
                    end
                    else if(air == 1'b1)
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Jump4;
                    end
                    else Next_state = Idle1;
                Jump5:
                    if (ct == 4)
                    begin
                        ct_next = 4'b0;
                        Next_state = Jump6;
                    end
                    else if(air == 1'b1)
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Jump5;
                    end
                    else Next_state = Idle1;
                Jump6:
                    if (ct == 4)
                    begin
                        ct_next = 4'b0;
                        Next_state = Jump7;
                    end
                    else if(air == 1'b1)
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Jump6;
                    end
                    else Next_state = Idle1;
                Jump7:
                    if (ct == 4)
                    begin
                        ct_next = 4'b0;
                        Next_state = Idle1;
                    end
                    else if(air == 1'b1)
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Jump7;
                    end
                    else Next_state = Idle1;
                Jab1:
                    if (ct == 5)
                    begin
                        ct_next = 4'b0;
                        Next_state = Jab2;
                    end
                    else
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Jab1;
                    end
                Jab2:
                    if (ct == 5)
                    begin
                        ct_next = 4'b0;
                        Next_state = Jab3;
                    end
                    else
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Jab2;
                    end
                Jab3:
                    if (ct == 5)
                    begin
                        ct_next = 4'b0;
                        Next_state = Idle1;
                    end
                    else
                    begin
                        ct_next = ct + 1'b1;
                        Next_state = Jab3;
                    end
            endcase
        end

        always_comb
        begin
            case (State)
                Walk1: sprite = 1;
                Walk2: sprite = 2;
                Walk3: sprite = 3;
                Walk4: sprite = 4;
                Walk5: sprite = 5;
                Walk6: sprite = 6;
                Walk1R: sprite = 7;
                Walk2R: sprite = 8;
                Walk3R: sprite = 9;
                Walk4R: sprite = 10;
                Walk5R: sprite = 11;
                Walk6R: sprite = 12;
                Idle1: sprite = 13;
                Idle2: sprite = 14;
                Idle3: sprite = 15;
                Idle4: sprite = 16;
                Idle5: sprite = 17;
                Crouch1: sprite = 18;
                Crouch2: sprite = 19;
                Crouch3: sprite = 20;
                Jump1: sprite = 21;
                Jump2: sprite = 22;
                Jump3: sprite = 23;
                Jump4: sprite = 24;
                Jump5: sprite = 25;
                Jump6: sprite = 26;
                Jump7: sprite = 27;
                Jab1: sprite = 28;
                Jab2: sprite = 29;
                Jab3: sprite = 30;
            endcase
        end

endmodule

