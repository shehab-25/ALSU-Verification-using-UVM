package alsu_scoreboard_pkg;
    import uvm_pkg::*;
    import shared_pkg::*;
    import alsu_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class alsu_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(alsu_scoreboard)
        uvm_analysis_export #(alsu_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(alsu_seq_item) sb_fifo;
        alsu_seq_item seq_item_sb;
        int error_count = 0;
        int correct_count = 0;

        //constructor
        function new(string name = "alsu_scoreboard" , uvm_component parent = null);
            super.new(name,parent);
        endfunction

        //build_phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export",this);
            sb_fifo = new("sb_fifo",this);
        endfunction
        
        //connect_phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        //run_phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item_sb);

                //checking
                if (seq_item_sb.out != seq_item_sb.out_ref || seq_item_sb.leds != seq_item_sb.leds_ref) begin
                    `uvm_error("run_phase" , $sformatf("comparison failed , transaction recieved by the DUT: %s , while the out_ref is: %0h and leds_ref: %0h"
                    ,seq_item_sb.convert2string() , seq_item_sb.out_ref,seq_item_sb.leds_ref));
                    error_count++;
                end
                else begin
                    `uvm_info("run_phase",$sformatf("correct output: %s ",seq_item_sb.convert2string()),UVM_HIGH);
                    correct_count++;
                end
            end
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase",$sformatf("total successful transactions = %0d",correct_count),UVM_MEDIUM);
            `uvm_info("report_phase",$sformatf("total failed transactions = %0d",error_count),UVM_MEDIUM);
        endfunction
    endclass 
endpackage