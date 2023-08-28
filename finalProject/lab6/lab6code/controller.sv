module control (input logic Clk, Reset_Load_Clear, Run, M, 
                output logic S_RLC, S_ADD, S_SUB, S_Shift, Clr_A
                );

    enum logic [6:0] {CXALB, START, SHIFT, ADD, SUB, CHECK, E} curr_state, next_state;
    logic [3:0] ct, ct_next;

    always_ff @ (posedge Clk)
    begin
            if (Reset_Load_Clear)
				begin
					curr_state <= CXALB;
					ct <= 4'b0000;
				end
            else
				begin
					curr_state <= next_state;
					ct <= ct_next;
				end
    end

    always_comb
    begin
            next_state = curr_state;
			ct_next = ct;

            unique case (curr_state)
                CXALB : 
                        next_state = START;
                START : 
					begin
						if (Run)
                                next_state = CHECK;
                        else   
                                next_state = START;
					end
                CHECK : 
                    begin
                                                if (ct == 8)
                                                        next_state = E;
						else if (~M)
							next_state = SHIFT; 
						else if (ct == 7 && M)
							next_state = SUB;
						else
							next_state = ADD;  
                    end
                SHIFT : 
                    begin
                        next_state = CHECK;
                            ct_next = ct + 1'b1;
                    end
                ADD : 
                        next_state = SHIFT;
                SUB :
                        next_state = SHIFT;
                E :
                    //perform shift
                    begin
							ct_next = 4'b0000;
                            if (~Run)
                                    next_state = START; 
                            else
                                    next_state = E;
                    end
            endcase
    end

    always_comb
    begin
                Clr_A = 0;
            case (curr_state)
                CXALB:
                    begin
                            S_RLC = 1'b1;
                            S_ADD = 1'b0;
                            S_SUB = 1'b0;
                            S_Shift = 1'b0;
                    end
                START:
                    begin
                            S_RLC = 1'b0;
                            S_ADD = 1'b0;
                            S_SUB = 1'b0;
                            S_Shift = 1'b0;
                    end
                CHECK:
                    begin
                           if (ct == 0) Clr_A = 1;
                            S_RLC = 1'b0;
                            S_ADD = 1'b0;
                            S_SUB = 1'b0;
                            S_Shift = 1'b0;
                    end
                SHIFT: 
                    begin
                            S_RLC = 1'b0;
                            S_ADD = 1'b0;
                            S_SUB = 1'b0;
                            S_Shift = 1'b1;
                    end
                ADD:
                    begin
                            S_RLC = 1'b0;
                            S_ADD = 1'b1;
                            S_SUB = 1'b0;
                            S_Shift = 1'b0;
                    end
                SUB:
                    begin
                            S_RLC = 1'b0;
                            S_ADD = 1'b0;
                            S_SUB = 1'b1;
                            S_Shift = 1'b0;
                    end
                E:
                    begin
                            S_RLC = 1'b0;
                            S_ADD = 1'b0;
                            S_SUB = 1'b0;
                            S_Shift = 1'b0;
                    end
            endcase
    end

endmodule