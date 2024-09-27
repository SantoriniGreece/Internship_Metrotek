
import bit_population_counter_pkg::*;

interface bit_population_counter_interface (
  input bit clk,
  input bit srst_i
);
  
  logic [               WIDTH - 1 : 0]  data_i;
  logic                                 data_val_i;

  logic [ ($clog2(WIDTH) + 1) - 1 : 0]  data_o;
  logic                                 data_val_o;

endinterface