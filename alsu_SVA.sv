module alsu_SVA (alsu_interface.SVA alsu_if);

    // out and leds when reset is asserted
    always_comb begin : reset_assertion
        if (alsu_if.rst) begin
            rst_out_ass: assert final (alsu_if.out==0);
            rst_leds_ass: assert final (alsu_if.leds==0);
        end
    end

    
    //////////invalid cases///////////
    property invalid_or_xor;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) ((alsu_if.red_op_A || alsu_if.red_op_B) && (alsu_if.opcode ==2  || alsu_if.opcode == 3 || alsu_if.opcode == 4 || alsu_if.opcode == 5)) |-> ##2 ((alsu_if.out == 0) && alsu_if.leds == ~$past(alsu_if.leds,1));
    endproperty

    property invalid_opcode_6_7;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode == 6  || alsu_if.opcode == 7) |-> ##2 ((alsu_if.out == 0) && alsu_if.leds == ~$past(alsu_if.leds,1));
    endproperty

    //bypass A , bypass_B
    property bypass_A_ass;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode!=6 && alsu_if.opcode!=7 && alsu_if.bypass_A && !alsu_if.red_op_A && !alsu_if.red_op_B) |-> ##2 ((alsu_if.out == $past(alsu_if.A,2)) && alsu_if.leds == 0);
    endproperty

    property bypass_B_ass;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode!=6 && alsu_if.opcode!=7 && alsu_if.bypass_B && !alsu_if.bypass_A && !alsu_if.red_op_A && !alsu_if.red_op_B) |-> ##2 ((alsu_if.out == $past(alsu_if.B,2)) && alsu_if.leds == 0);
    endproperty

    //ALSU operations
    // OR operation
    property bitwise_or;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode==0 && !alsu_if.red_op_A && !alsu_if.red_op_B && !alsu_if.bypass_B && !alsu_if.bypass_A) |-> ##2 (alsu_if.out == ($past(alsu_if.A,2)|$past(alsu_if.B,2)) && alsu_if.leds == 0);
    endproperty

    property red_op_A_or;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode==0 && alsu_if.red_op_A && !alsu_if.bypass_B && !alsu_if.bypass_A) |-> ##2 ((alsu_if.out == |$past(alsu_if.A,2))  && alsu_if.leds == 0);
    endproperty

    property red_op_B_or;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode==0 && !alsu_if.red_op_A && alsu_if.red_op_B && !alsu_if.bypass_B && !alsu_if.bypass_A) |-> ##2 ((alsu_if.out == |$past(alsu_if.B,2))  && alsu_if.leds == 0);
    endproperty

    // XOR operation
    property bitwise_xor;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode==1 && !alsu_if.red_op_A && !alsu_if.red_op_B && !alsu_if.bypass_B && !alsu_if.bypass_A) |-> ##2 ((alsu_if.out == $past(alsu_if.A,2) ^ $past(alsu_if.B,2))  && alsu_if.leds == 0);
    endproperty

    property red_op_A_xor;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode==1 && alsu_if.red_op_A && !alsu_if.bypass_B && !alsu_if.bypass_A) |-> ##2 ((alsu_if.out == ^$past(alsu_if.A,2))  && alsu_if.leds == 0);
    endproperty

    property red_op_B_xor;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode==1 && !alsu_if.red_op_A && alsu_if.red_op_B && !alsu_if.bypass_B && !alsu_if.bypass_A) |-> ##2 ((alsu_if.out == ^$past(alsu_if.B,2))  && alsu_if.leds == 0);
    endproperty

    // Addition operation
    property add;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode==2 && !alsu_if.red_op_A && !alsu_if.red_op_B && !alsu_if.bypass_B && !alsu_if.bypass_A) |-> ##2 ((alsu_if.out == $past(alsu_if.A,2) + $past(alsu_if.B,2) + $past(alsu_if.cin,2))  && alsu_if.leds == 0);
    endproperty

    // Multiplication operation
    property mult;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode==3 && !alsu_if.red_op_A && !alsu_if.red_op_B && !alsu_if.bypass_B && !alsu_if.bypass_A) |-> ##2 ((alsu_if.out == $past(alsu_if.A,2) * $past(alsu_if.B,2)) && alsu_if.leds == 0);
    endproperty

    // shift operation
    property shift_left;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode==4 && alsu_if.direction &&!alsu_if.red_op_A && !alsu_if.red_op_B && !alsu_if.bypass_B && !alsu_if.bypass_A) |-> ##2 ((alsu_if.out == {$past(alsu_if.out[4:0],1),$past(alsu_if.serial_in,2)}) && alsu_if.leds == 0);
    endproperty

    property shift_right;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode==4 && !alsu_if.direction && !alsu_if.red_op_A && !alsu_if.red_op_B && !alsu_if.bypass_B && !alsu_if.bypass_A) |-> ##2 ((alsu_if.out == {$past(alsu_if.serial_in,2),$past(alsu_if.out[5:1],1)}) && alsu_if.leds == 0);
    endproperty

    // rotate operation
    property rotate_left;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode==5 && alsu_if.direction && !alsu_if.red_op_A && !alsu_if.red_op_B && !alsu_if.bypass_B && !alsu_if.bypass_A) |-> ##2 ((alsu_if.out == {$past(alsu_if.out[4:0],1),$past(alsu_if.out[5],1)}) && alsu_if.leds == 0);
    endproperty

    property rotate_right;
        @(posedge alsu_if.clk) disable iff(alsu_if.rst) (alsu_if.opcode==5 && !alsu_if.direction && !alsu_if.red_op_A && !alsu_if.red_op_B && !alsu_if.bypass_B && !alsu_if.bypass_A) |-> ##2 ((alsu_if.out == {$past(alsu_if.out[0],1),$past(alsu_if.out[5:1],1)}) && alsu_if.leds == 0);
    endproperty

    // asseert properties
    invalid_or_xor_ass: assert property (invalid_or_xor)  else $display("at time %t : invalid OR and XOR fail",$time);
    invalid_opcode_6_7_ass: assert property (invalid_opcode_6_7) else $display("at time %t : invalid opcode fails",$time);
    bypass_A_assert: assert property (bypass_A_ass)  else $display("at time %t : bypass_A fails",$time);
    bypass_B_assert: assert property (bypass_B_ass)  else $display("at time %t : bypass_B fails",$time);
    bitwise_or_ass: assert property (bitwise_or)     else $display("at time %t : bitwise OR fails",$time);
    red_op_A_or_ass: assert property (red_op_A_or)   else $display("at time %t : red_op_A_or fails",$time);
    red_op_B_or_ass: assert property (red_op_B_or)   else $display("at time %t : red_op_B_or fails",$time);
    bitwise_xor_ass: assert property (bitwise_xor)   else $display("at time %t : bitwise XOR fails",$time);
    red_op_A_xor_ass: assert property (red_op_A_xor) else $display("at time %t : red_op_A_xor fails",$time);
    red_op_B_xor_ass: assert property (red_op_B_xor) else $display("at time %t : red_op_B_xor fails",$time);
    add_ass: assert property (add)                   else $display("at time %t : addition fails",$time);
    mult_ass: assert property (mult)                 else $display("at time %t : multiplication fails",$time);
    shift_left_ass: assert property (shift_left)     else $display("at time %t : shift_left fails",$time);
    shift_right_ass: assert property (shift_right)   else $display("at time %t : shift_right fails",$time);
    rotate_left_ass: assert property (rotate_left)   else $display("at time %t : rotate_left fails",$time);
    rotate_right_ass: assert property (rotate_right) else $display("at time %t : rotate_right fails",$time);

    // cover assertions
    invalid_or_xor_cov:      cover property (invalid_or_xor);
    invalid_opcode_6_7_cov:  cover property (invalid_opcode_6_7);
    bypass_A_assert_cov:     cover property (bypass_A_ass);
    bypass_B_assert_cov:     cover property (bypass_B_ass);
    bitwise_or_ass_cov:      cover property (bitwise_or);
    red_op_A_or_ass_cov:     cover property (red_op_A_or);
    red_op_B_or_ass_cov:     cover property (red_op_B_or);
    bitwise_xor_ass_cov:     cover property (bitwise_xor);
    red_op_A_xor_ass_cov:    cover property (red_op_A_xor);
    red_op_B_xor_ass_cov:    cover property (red_op_B_xor);
    add_ass_cov:             cover property (add);
    mult_ass_cov:            cover property (mult);
    shift_left_ass_cov:      cover property (shift_left);
    shift_right_ass_cov:     cover property (shift_right);
    rotate_left_ass_cov:     cover property (rotate_left);
    rotate_right_ass_cov:    cover property (rotate_right);

endmodule