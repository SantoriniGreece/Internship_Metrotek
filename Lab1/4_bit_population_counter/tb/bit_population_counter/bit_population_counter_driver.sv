
import bit_population_counter_pkg::*;

class bit_population_counter_driver;

  virtual bit_population_counter_interface vif;
  event drv_done;
  mailbox drv_mbx;

  task run();
    $display("Time = %t [Driver]: starting ...", $time);
    @(posedge vif.clk);
    forever 
      begin
        bit_population_counter_transaction trns;

        drv_mbx.get(trns);
        // trns.display("Driver");
        vif.data_val_i <= trns.data_val_i;
        vif.data_i     <= trns.data_i;

        @(posedge vif.clk);
        vif.data_val_i <= 1'b0;
        -> drv_done;
      end

  endtask

endclass //className