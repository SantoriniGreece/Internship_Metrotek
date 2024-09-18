
import priority_encoder_pkg::*;

class priority_encoder_transaction;

    rand bit [WIDTH - 1 : 0] data_i;
    rand bit                 data_val_i;
         bit [WIDTH - 1 : 0] data_left_o;
         bit [WIDTH - 1 : 0] data_right_o;

    function void display (string tag = "");
        $display ("Time = %t [%s]: InputData = %b\nOutputDataLeft = %b, OutputDataRight = %b", $time, tag, data_i, data_left_o, data_right_o);
    endfunction //new()

endclass

