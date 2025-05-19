import uvm_pkg::*;
import alsu_test_pkg::*;
`include "uvm_macros.svh"

module alsu_top ();
    logic clk;
    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end

    alsu_interface alsu_if (clk);

    ALSU alsu_dut (alsu_if.A, alsu_if.B, alsu_if.cin, alsu_if.serial_in,
    alsu_if.red_op_A, alsu_if.red_op_B, alsu_if.opcode, alsu_if.bypass_A, alsu_if.bypass_B, alsu_if.clk, alsu_if.rst, alsu_if.direction, alsu_if.leds, alsu_if.out);

    ALSU_golden alsu_ref (alsu_if.A,alsu_if.B,alsu_if.opcode,alsu_if.cin, alsu_if.serial_in,alsu_if.direction,alsu_if.red_op_A, 
    alsu_if.red_op_B,alsu_if.bypass_A, alsu_if.bypass_B,alsu_if.clk, alsu_if.rst,alsu_if.out_ref,alsu_if.leds_ref );

    bind ALSU alsu_SVA alsu_SVA_inst(alsu_if.SVA);

    initial begin
        uvm_config_db #(virtual alsu_interface)::set(null , "uvm_test_top" , "ALSU_IF" , alsu_if);
        run_test("alsu_test");
    end
    
endmodule