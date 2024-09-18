`timescale 1ns/1ps
`include "test.sv"

import priority_encoder_pkg::*;

module tb_top ( );

    parameter CLK_PERIOD = 10; // Clock period
    bit   clk;
    bit   rst;
    logic srst_i;

    test t0;

    //* Clock gen
    initial begin
      clk = 1'b0;
      forever 
        #(CLK_PERIOD/2) clk = !clk;
    end
    
    initial $timeformat(-9, 0, " ns", 8);

    priority_encoder_interface priority_encoder_intf (clk, srst_i);

    initial begin
      rst = 1'b1;
      #100 rst = 1'b0;
      @( posedge clk )
      srst_i <= rst;

      t0 = new;
      t0.e0.vif = priority_encoder_intf;
      t0.run();

      #TIMEOUT; 
      $finish;
    end

    final begin
      $display("---------------------------------------------------------------------------------");
      $display("Simulation is done (time %t): %0d errors from %0d tests", $time, err_cntr, (rand_tests+val1_tests) );
    end

    top_priority_encoder 
    # (
      .WIDTH              (WIDTH)
    )   
    dut_top_priority_encoder (
      .clk                (clk                                ),
      .srst_i             (srst_i                             ),
      .data_i             (priority_encoder_intf.data_i       ),
      .data_val_i         (priority_encoder_intf.data_val_i   ),
      .data_left_o        (priority_encoder_intf.data_left_o  ),
      .data_right_o       (priority_encoder_intf.data_right_o ),
      .data_val_o         (priority_encoder_intf.data_val_o   )
    );
    
endmodule