
import bit_population_counter_pkg::*;

class bit_population_counter_transaction;

  bit [WIDTH - 1 : 0]               data_i;
  bit                               data_val_i;

  bit [($clog2(WIDTH) + 1) - 1 : 0] data_o;

  function new();
    this.data_i     = data_i;
    this.data_val_i = data_val_i;
    this.data_o     = data_o;
  endfunction

  function void display (string tag = "");
    $display ("Time = %t [%s]: InputData = %b\nOutputData = %b", $time, tag, data_i, data_o);
  endfunction

  function void randi ();
    for (int i = 0; i < WIDTH; i++) 
      begin
        data_i[i] = $urandom%(2);
      end
    data_val_i  = $urandom%(2);
  endfunction

  function bit_population_counter_transaction make_copy();
    bit_population_counter_transaction trns_copy;
    trns_copy            = new();
    trns_copy.data_i     = this.data_i;
    trns_copy.data_val_i = this.data_val_i;
    trns_copy.data_o     = this.data_o;
    return trns_copy;
  endfunction

endclass