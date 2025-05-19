package alsu_rst_sequence_pkg;
    import uvm_pkg::*;
    import alsu_seq_item_pkg::*;
    import shared_pkg::*;
    `include "uvm_macros.svh"

    class alsu_rst_sequence extends uvm_sequence #(alsu_seq_item);
        `uvm_object_utils(alsu_rst_sequence)
        alsu_seq_item rst_seq;

        //constructor
        function new(string name = "alsu_rst_sequence");
            super.new(name);
        endfunction  

        task body ();
            rst_seq = alsu_seq_item::type_id::create("rst_seq"); // create a sequence item
            start_item(rst_seq);
            rst_seq.rst = 1;
            rst_seq.opcode = ADD;
            rst_seq.A = 1;
            rst_seq.B = 3;
            finish_item(rst_seq);
        endtask
    endclass 
endpackage