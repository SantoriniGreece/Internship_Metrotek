`timescale 1ns/1ps
`include "environment.sv"

import bit_population_counter_pkg::*;

module tb_top ( );

  parameter     CLK_PERIOD = 10; // Clock period
  bit           clk;
  bit           rst;
  logic         srst_i;

  environment   e0;

  //* Clock gen
  initial 
    begin
    clk = 1'b0;
    forever 
      #(CLK_PERIOD/2) clk = !clk;
    end
  
  initial $timeformat(-9, 0, " ns", 8);

  bit_population_counter_interface bit_population_counter_intf (clk, srst_i);

  initial 
    begin
      rst         = 1'b1;
      #100 rst    = 1'b0;

      e0          = new;
      e0.vif      = bit_population_counter_intf;
      e0.run();
      
      fork
        begin
          wait(e0.env_done.triggered);
          $display("---------------------------------------------------------------------------------");
          $display("Simulation is done (time %t): %0d errors from %0d tests", $time, err_cntr, (rand_tests+val1_tests) );
        end
        begin
          #TIMEOUT; 
          $display("---------------------------------------------------------------------------------");
          $display("Simulation is not done (time %t): timeout", $time ); 
        end
      join_any
      $finish;
      
    end

  always_ff @( posedge clk ) 
    begin
      srst_i <= rst;
    end

//  final 
//    begin
//      $display("---------------------------------------------------------------------------------");
//      $display("Simulation is done (time %t): %0d errors from %0d tests", $time, err_cntr, (rand_tests+val1_tests) );
//    end

  top_bit_population_counter 
  # (
    .WIDTH        (WIDTH)
  )   
  dut_top_bit_population_counter (
    .clk          (clk                                      ),
    .srst_i       (srst_i                                   ),
    .data_i       (bit_population_counter_intf.data_i       ),
    .data_val_i   (bit_population_counter_intf.data_val_i   ),
    .data_o       (bit_population_counter_intf.data_o       ),
    .data_val_o   (bit_population_counter_intf.data_val_o   )
  );
  
endmodule