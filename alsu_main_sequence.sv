package alsu_main_sequence_pkg;
    import uvm_pkg::*;
    import alsu_seq_item_pkg::*;
    import shared_pkg::*;
    `include "uvm_macros.svh"

    class alsu_main_sequence extends uvm_sequence #(alsu_seq_item);
        `uvm_object_utils(alsu_main_sequence)
        alsu_seq_item main_seq;

        //constructor
        function new(string name = "alsu_main_sequence");
            super.new(name);
        endfunction  

        task body ();
            opcode_e opcode;
            repeat(1000) begin
                main_seq = alsu_seq_item::type_id::create("main_seq"); // create a sequence item
                start_item(main_seq);
                assert(main_seq.randomize());
                finish_item(main_seq); 
            end

            // to get 100% functional coverage to hit trans_bins (OR => XOR => ADD => MULT => SHIFT => ROTATE)
            opcode = OR;
            for (opcode = OR; opcode <= ROTATE; opcode = opcode_e'(int'(opcode) + 1)) begin
                main_seq = alsu_seq_item::type_id::create("main_seq"); // create a sequence item
                main_seq.opcode.rand_mode(0); // disable randomization on opcode
                start_item(main_seq);
                main_seq.opcode = opcode;
                assert(main_seq.randomize());
                finish_item(main_seq); 
           end
                
        endtask
    endclass 
endpackage