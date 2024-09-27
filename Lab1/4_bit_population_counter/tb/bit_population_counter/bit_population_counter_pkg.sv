
package bit_population_counter_pkg;

  parameter WIDTH       = 32;

  int rand_tests_cntr   = 0;
  int err_cntr          = 0;

  int rand_tests        = 10000;
  int val1_tests        = 10;
  int val0_tests        = 10;

  parameter int TIMEOUT = 100_000;

  `include "bit_population_counter_transaction.sv"
  `include "bit_population_counter_generator.sv"
  `include "bit_population_counter_driver.sv"
  `include "bit_population_counter_monitor.sv"
  
endpackage