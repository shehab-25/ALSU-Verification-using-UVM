interface alsu_interface(clk);
    input bit clk;
    logic rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
    logic [2:0] opcode;
    logic signed [2:0] A, B;
    logic [15:0] leds , leds_ref;
    logic signed [5:0] out , out_ref;

    modport SVA (input clk,rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in,opcode,A,B,output leds , out);
endinterface 