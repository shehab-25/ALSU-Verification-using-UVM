package alsu_coverage_pkg;
    import uvm_pkg::*;
    import shared_pkg::*;
    import alsu_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class alsu_coverage extends uvm_component;
        `uvm_component_utils(alsu_coverage)
        uvm_analysis_export #(alsu_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(alsu_seq_item) cov_fifo;
        alsu_seq_item seq_item_cov;

        //covergroups
        covergroup alsu_cvg;
            A_cp: coverpoint seq_item_cov.A 
            {
                bins A_data_0 = {ZERO};
                bins A_data_max = {MAXPOS};
                bins A_data_min = {MAXNEG};
                bins A_data_walkingones[] = {1,2,-4} iff(seq_item_cov.red_op_A);
                bins A_data_default = default;
            }

            B_cp: coverpoint seq_item_cov.B
            {
                bins B_data_0 = {ZERO};
                bins B_data_max = {MAXPOS};
                bins B_data_min = {MAXNEG};
                bins B_data_walkingones[] = {1,2,-4} iff(!seq_item_cov.red_op_A && seq_item_cov.red_op_B);
                bins B_data_default = default;
            }

            ALU_cp: coverpoint seq_item_cov.opcode
            {
                bins Bins_shift[] = {[SHIFT:ROTATE]};
                bins Bins_arith[] = {[ADD:MULT]};
                bins Bins_bitwise[] = {[OR:XOR]};
                illegal_bins Bins_invalid[] = {INVALID_6,INVALID_7};
                bins Bins_trans[] =(OR => XOR => ADD => MULT => SHIFT => ROTATE);
            }

            cin_cp: coverpoint seq_item_cov.cin;
            serialin_cp: coverpoint seq_item_cov.serial_in;
            red_op_A_cp: coverpoint seq_item_cov.red_op_A;
            red_op_B_cp: coverpoint seq_item_cov.red_op_B;

            add_mult_A_B_cr: cross A_cp , B_cp , ALU_cp
            {
                option.cross_auto_bin_max=0;
                bins A_B_permutations = (binsof(A_cp.A_data_0) || binsof(A_cp.A_data_max) || binsof(A_cp.A_data_min))
                && (binsof(B_cp.B_data_0) || binsof(B_cp.B_data_max) || binsof(B_cp.B_data_min)) && (binsof(ALU_cp.Bins_arith));
            }

            add_cin_cr: cross ALU_cp , cin_cp
            {
                option.cross_auto_bin_max=0;
                bins add_cin1 = binsof(ALU_cp) intersect {ADD} && binsof(cin_cp) intersect {1};
                bins add_cin0 = binsof(ALU_cp) intersect {ADD} && binsof(cin_cp) intersect {0};
            }

            shifting_cr: cross ALU_cp , serialin_cp
            {
                option.cross_auto_bin_max=0;
                bins shifting_s1 = binsof(ALU_cp) intersect {SHIFT} && binsof(serialin_cp) intersect{1};
                bins shifting_s0 = binsof(ALU_cp) intersect {SHIFT} && binsof(serialin_cp) intersect{0};
            }

            or_xor_redopA: cross ALU_cp , red_op_A_cp , A_cp , B_cp
            {
                option.cross_auto_bin_max=0;
                bins or_xor_crA = binsof(ALU_cp.Bins_bitwise) && binsof(red_op_A_cp) intersect{1} && binsof(A_cp.A_data_walkingones) && binsof(B_cp.B_data_0);
            }

            or_xor_redopB: cross ALU_cp , red_op_B_cp , A_cp , B_cp
            {
                option.cross_auto_bin_max=0;
                bins or_xor_crB = binsof(ALU_cp.Bins_bitwise) && binsof(red_op_B_cp) intersect{1} && binsof(B_cp.B_data_walkingones) && binsof(A_cp.A_data_0);
            }

            invalid_cr : cross ALU_cp , red_op_B_cp , red_op_A_cp
            {
                option.cross_auto_bin_max=0;
                bins invalid_case = (binsof(ALU_cp.Bins_shift) || binsof(ALU_cp.Bins_arith)) && (binsof(red_op_A_cp) intersect{1} || binsof(red_op_B_cp) intersect{1});
            }
        endgroup

        //constructor
        function new(string name = "alsu_coverage" , uvm_component parent = null);
            super.new(name,parent);
            alsu_cvg = new();
        endfunction

        //build_phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export",this);
            cov_fifo = new("cov_fifo",this);
        endfunction
        
        //connect_phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        //run phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
               cov_fifo.get(seq_item_cov);
               alsu_cvg.sample(); 
            end
        endtask 
    endclass
endpackage  