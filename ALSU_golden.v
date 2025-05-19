module ALSU_golden (a,b,opcode,cin,serial_in,direction,red_op_a,red_op_b,bypass_a,bypass_b,clk,rst,out,leds);
    parameter INPUT_PRIORITY = "A"; // Default
    parameter FULL_ADDER = "ON";  // Default
    input clk,rst,cin,serial_in,red_op_a,red_op_b,bypass_a,bypass_b,direction;
    input signed [2:0] a,b;
    input [2:0] opcode;
    output reg signed [5:0] out;
    output reg [15:0] leds; 
    reg signed [2:0] a_reg,b_reg;
    reg [2:0] opcode_reg;
    reg cin_reg,serial_in_reg,red_op_a_reg,red_op_b_reg,bypass_a_reg,bypass_b_reg,direction_reg;

    always @(posedge clk or posedge rst) begin   
        if (rst) begin
            a_reg <= 'b0; 
            b_reg <= 'b0;
            opcode_reg <= 'b0;
            cin_reg <= 'b0;
            serial_in_reg <= 'b0;
            direction_reg <= 'b0;
            red_op_a_reg <= 'b0;
            red_op_b_reg <= 'b0;
            bypass_a_reg <= 'b0;
            bypass_b_reg <= 'b0;
        end

        else begin
            a_reg <= a;
            b_reg <= b;
            opcode_reg <= opcode;
            cin_reg <= cin;
            serial_in_reg <= serial_in;
            direction_reg <= direction;
            red_op_a_reg <= red_op_a;
            red_op_b_reg <= red_op_b;
            bypass_a_reg <= bypass_a;
            bypass_b_reg <= bypass_b;
        end
    end

    always @(posedge clk or posedge rst) begin   
        if (rst) begin
            out <= 'b0;
            leds <= 'b0;
        end

        else if (((red_op_a_reg || red_op_b_reg) && (opcode_reg != 0 && opcode_reg != 1)) || opcode_reg==6 || opcode_reg==7) begin  // invalid output
            out <= 'b0;
            leds <= ~leds;  //blinking 
        end

        else begin
            if(bypass_a_reg && bypass_b_reg) begin
                if (INPUT_PRIORITY == "B") begin
                    out <= b_reg;
                    leds <= 'b0;
                end

                else begin   // Default A
                    out <= a_reg;
                    leds <= 'b0;
                end
            end

            else if (bypass_a_reg) begin
                out <= a_reg;
                leds <= 'b0;
            end

            else if (bypass_b_reg) begin
                out <= b_reg;
                leds <= 'b0;
            end

            else begin
                case (opcode_reg)
                0: begin    //OR
                    if (red_op_a_reg && red_op_b_reg) begin
                        if (INPUT_PRIORITY == "B") begin
                            out <= | b_reg;
                        end
                        else begin   // Default A
                            out <= | a_reg;
                        end
                    end
                    else if (red_op_a_reg) begin
                        out <= | a_reg;
                    end

                    else if (red_op_b_reg) begin
                        out <= | b_reg;
                    end

                    else begin   // Bitwise AND
                        out <= a_reg | b_reg;
                    end
                    leds <= 'b0;
                end 

                1: begin   //XOR
                    if (red_op_a_reg && red_op_b_reg) begin
                        if (INPUT_PRIORITY == "B") begin
                            out <= ^ b_reg;
                        end
                        else begin   // Default A
                            out <= ^ a_reg;
                        end
                    end
                    else if (red_op_a_reg) begin
                        out <= ^ a_reg;
                    end

                    else if (red_op_b_reg) begin
                        out <= ^ b_reg;
                    end

                    else begin   // Bitwise XOR
                        out <= a_reg ^ b_reg;
                    end
                    leds <= 'b0; 
                end

                2: begin    //Addition
                    if (FULL_ADDER == "OFF") begin
                        out <= a_reg + b_reg;
                    end

                    else begin     // Default ON
                        out <= a_reg + b_reg + cin_reg;
                    end
                    leds <= 'b0;
                end

                3: begin         //Multiplication
                    out <= a_reg * b_reg;
                    leds <= 'b0;
                end

                4: begin     // shift
                    if (direction_reg) begin  // shift left
                        out <= {out[4:0],serial_in_reg};
                    end
                    else begin   // shift right
                        out <= {serial_in_reg,out[5:1]};
                    end
                    leds <= 'b0;
                end

                5: begin    // rotate
                    if (direction_reg) begin  // rotate left
                        out <= {out[4:0],out[5]};
                    end
                    else begin   // rotate right
                        out <= {out[0],out[5:1]};
                    end
                    leds <= 'b0;
                end

                default:   // invalid opcode
                begin
                    if (bypass_b_reg && bypass_a_reg) begin
                        if (INPUT_PRIORITY == "B") begin
                            out <= b_reg;
                        end
                        else begin   // Default A
                            out <= a_reg;
                        end
                    end

                    else if(bypass_a_reg) begin
                        out <= a_reg;
                    end

                    else if (bypass_b_reg) begin
                        out <= b_reg;
                    end
                    
                    else begin
                        out<='b0;
                    end
                end
            endcase
                
            end

            
        end
    end
endmodule