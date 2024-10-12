
import bit_population_counter_pkg::*;

class bit_population_counter_generator;

  mailbox gen2drv_mbx;
  event drv_done;

  bit_population_counter_transaction tr2drv, tr2scb;

  function new(mailbox gen2drv_mbx, event drv_done);
    this.gen2drv_mbx = gen2drv_mbx;
    this.drv_done    = drv_done;    
  endfunction

  int rand_test_cntr  = 0;
  int data1_test_cntr = 0;
  int data0_test_cntr = 0;

  task run();
    // Test with valid = 1
    for (int i = 0; i < val1_test; i++) 
      begin
        bit_population_counter_transaction trns = new();
        trns.randi();
        trns.data_val_i = 1;

        gen2drv_mbx.put(trns);
        @(drv_done);
      end
    $display("Time = %t [Generator]: Done generation of %0d items with val = 1", $time, val1_test);

    // Test with valid = 0
    for (int i = 0; i < val0_test; i++) 
      begin
        bit_population_counter_transaction trns = new();
        trns.randi();
        trns.data_val_i = 0;

        gen2drv_mbx.put(trns);
        @(drv_done);
      end
    $display("Time = %t [Generator]: Done generation of %0d items with val = 0", $time, val0_test);

    // Test with data = '1
    while (data1_test_cntr < data1_test) 
      begin
        bit_population_counter_transaction trns = new();
        trns.randi();
        trns.data_i = '1;
    
        gen2drv_mbx.put(trns);
        @(drv_done);
        if (trns.data_val_i) 
          data1_test_cntr++;
      end
    $display("Time = %t [Generator]: Done generation of %0d items with data = '1", $time, data1_test);

    // Test with data = '0
    while (data0_test_cntr < data0_test) 
      begin
        bit_population_counter_transaction trns = new();
        trns.randi();
        trns.data_i = '0;
    
        gen2drv_mbx.put(trns);
        @(drv_done);
        if (trns.data_val_i) 
          data0_test_cntr++;
      end
    $display("Time = %t [Generator]: Done generation of %0d items with data = '0", $time, data0_test);

    // Test with random valid
    while (rand_test_cntr < rand_test) 
      begin
        bit_population_counter_transaction trns = new();
        trns.randi();
    
        gen2drv_mbx.put(trns);
        @(drv_done);
        if (trns.data_val_i) 
          rand_test_cntr++;
      end
    $display("Time = %t [Generator]: Done generation of %0d rand items", $time, rand_test);

    // #100 
    // $finish();

  endtask 

endclass //generator