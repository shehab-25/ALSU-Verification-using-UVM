package alsu_sequencer_pkg;
    import uvm_pkg::*;
    import alsu_seq_item_pkg::*;
    `include "uvm_macros.svh"
    
    class alsu_sequencer extends uvm_sequencer #(alsu_seq_item);
        `uvm_component_utils(alsu_sequencer)

        //constructor
        function new(string name = "alsu_sequencer" , uvm_component parent = null);
            super.new(name,parent);
        endfunction 
    endclass 
endpackage