
import bit_population_counter_pkg::*;

class bit_population_counter_generator;

  mailbox drv_mbx;
  event drv_done;

  task run();
    // Test with valid = 1
    for (int i = 0; i < val1_tests; i++) 
      begin
        bit_population_counter_transaction trns = new;
        trns.randi();
        trns.data_val_i = 1;

        drv_mbx.put(trns);
        @(drv_done);
      end
    $display("Time = %t [Generator]: Done generation of %0d items with val = 1", $time, val1_tests);

    // Test with valid = 0
    for (int i = 0; i < val0_tests; i++) 
      begin
        bit_population_counter_transaction trns = new;
        trns.randi();
        trns.data_val_i = 0;

        drv_mbx.put(trns);
        @(drv_done);
      end
    $display("Time = %t [Generator]: Done generation of %0d items with val = 0", $time, val0_tests);

    // Test with random valid
    while (rand_tests_cntr < rand_tests) 
      begin
        bit_population_counter_transaction trns = new;
        trns.randi();
    
        drv_mbx.put(trns);
        @(drv_done);
        if (trns.data_val_i) 
          rand_tests_cntr++;
      end
    $display("Time = %t [Generator]: Done generation of %0d rand items", $time, rand_tests);

    // #100 
    // $finish();

  endtask 

endclass //generator