package alsu_test_pkg;
    import uvm_pkg::*;
    import shared_pkg::*;
    import alsu_env_pkg::*;
    import alsu_main_sequence_pkg::*;
    import alsu_rst_sequence_pkg::*;
    import alsu_config_obj_pkg::*;
    `include "uvm_macros.svh"

    class alsu_test extends uvm_test;
        `uvm_component_utils(alsu_test)

        alsu_env my_env;
        virtual alsu_interface alsu_vif;
        alsu_config_obj alsu_cfg;
        alsu_main_sequence main_seq;
        alsu_rst_sequence rst_seq;
        
        //constructor
        function new(string name = "alsu_test" ,uvm_component parent = null);
            super.new(name,parent);
        endfunction 

        //build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            my_env = alsu_env::type_id::create("my_env",this);
            alsu_cfg = alsu_config_obj::type_id::create("alsu_cfg",this);
            main_seq = alsu_main_sequence::type_id::create("main_seq",this);
            rst_seq = alsu_rst_sequence::type_id::create("rst_seq",this);
            if (!uvm_config_db #(virtual alsu_interface)::get(this , "" , "ALSU_IF" , alsu_cfg.alsu_vif)) begin
                `uvm_fatal("build_phase" , "Test - unable to get the virtual interface of ALSU from uvm_config_db");
            end

            uvm_config_db #(alsu_config_obj)::set(this , "*" , "CFG" , alsu_cfg);
        endfunction

        //run phase
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);

            //reset seq
            `uvm_info("run_phase", "reset_asserted" , UVM_LOW)
            rst_seq.start(my_env.agt.sqr);
            `uvm_info("run_phase" , "reset_deasserted" , UVM_LOW)

            //main_seq
            `uvm_info("run_phase", "stimulus generation started" , UVM_LOW)
            main_seq.start(my_env.agt.sqr);
            `uvm_info("run_phase", "stimulus generation ended" , UVM_LOW)

            phase.drop_objection(this);
        endtask
    endclass 
endpackage