package alsu_seq_item_pkg;
    import uvm_pkg::*;
    import shared_pkg::*;
    `include "uvm_macros.svh"

    class alsu_seq_item extends uvm_sequence_item;
        `uvm_object_utils(alsu_seq_item)

        // randomized data inputs
        rand logic rst;
        rand bit cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
        rand opcode_e opcode;
        rand logic signed [2:0] A, B;
        logic [15:0] leds;
        logic signed [5:0] out;
        logic [15:0] leds_ref;
        logic [5:0] out_ref;

        // constructor
        function new(string name = "alsu_seq_item");
            super.new(name);
        endfunction 

        function string convert2string();
            return $sformatf("%s rst= %b , cin= %b , red_op_A= %b , red_op_B= %b , bypass_A= %b , bypass_B= %b , direction= %b , serial_in= %b , opcode= %s , A= %0h , B= %0h , leds= %0h , out= %0h , leds_ref= %0h , out_ref= %0h"
            ,super.convert2string(),rst,cin,red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in,opcode,A,B,leds,out,leds_ref,out_ref);
        endfunction

        function string convert2string_stimulus();
            return $sformatf("rst= %b , cin= %b , red_op_A= %b , red_op_B= %b , bypass_A= %b , bypass_B= %b , direction= %b , serial_in= %b , opcode= %s , A= %0h , B= %0h",
            rst,cin,red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in,opcode,A,B);
        endfunction

        // constraint blocks
        // reset constraint
        constraint rst_c { rst  dist {0:=96 , 1:=4};}

        // opcode constraint
        constraint opcode_c {opcode dist {[OR:ROTATE]:/90 , [INVALID_6:INVALID_7]:/10};}

        // bypass constraint
        constraint bypassA_c {bypass_A dist {0:=90 , 1:=10};}
        constraint bypassB_c {bypass_B dist {0:=90 , 1:=10};}

        // Constraints for A and B in case of ADD or MULT
        constraint ADDorMULT_c {
            if (opcode inside {ADD, MULT}) {
                A dist {3:/30 , -4:/30 , 0:/20 ,{-3,-2,-1,1,2}:/20};
                B dist {3:/30 , -4:/30 , 0:/20 ,{-3,-2,-1,1,2}:/20};
            }
        }

        // Constraints for A and B in case of OR or XOR and red_op_A = 1
        constraint or_xorA_c {
            if (opcode inside {[OR:XOR]} && red_op_A ) {
                A inside {1,2,-4};
                B == 3'b000;
            }
        }

        // Constraints for A and B in case of OR or XOR and red_op_B = 1
        constraint or_xorB_c {
            if (opcode inside {[OR:XOR]} && red_op_B && !red_op_A) {
                B inside {1,2,-4};
                A == 3'b000;
            }
        }

    endclass 
    
endpackage