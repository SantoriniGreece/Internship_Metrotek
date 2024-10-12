
package bit_population_counter_pkg;

  parameter WIDTH       = 64;

  int err_cntr          = 0;

  int num_test          = 1000;
  int val1_test         = 10;
  int val0_test         = 5;
  int data1_test        = 3;
  int data0_test        = 3;
  int rand_test         = num_test - (val1_test + data1_test + data0_test);

  parameter int TIMEOUT = 100_000;

  `include "bit_population_counter_transaction.sv"
  `include "bit_population_counter_generator.sv"
  `include "bit_population_counter_driver.sv"
  `include "bit_population_counter_monitor.sv"
  
endpackage