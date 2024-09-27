
import bit_population_counter_pkg::*;

class bit_population_counter_transaction;

  rand bit [WIDTH - 1 : 0]               data_i;
  rand bit                               data_val_i;
       bit [($clog2(WIDTH) + 1) - 1 : 0] data_o;

  function void display (string tag = "");
    $display ("Time = %t [%s]: InputData = %b\nOutputData = %b", $time, tag, data_i, data_o);
  endfunction //new()

  function void randi ();
    data_i     = $urandom%(2**WIDTH);
    data_val_i = $urandom%(2);
  endfunction

endclass

