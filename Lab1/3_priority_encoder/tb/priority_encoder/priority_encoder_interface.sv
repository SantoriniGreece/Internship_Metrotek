
import priority_encoder_pkg::*;

interface priority_encoder_interface (
    input bit clk,
    input bit srst_i
);
    
    logic [WIDTH - 1 : 0] data_i;
    logic                 data_val_i;

    logic [WIDTH - 1 : 0] data_left_o;
    logic [WIDTH - 1 : 0] data_right_o;
    logic                 data_val_o;

endinterface //priority_encoder_interface