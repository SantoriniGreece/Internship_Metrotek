
import bit_population_counter_pkg::*;

class bit_population_counter_monitor;
  virtual bit_population_counter_interface vif;
  mailbox   scb_mbx;

  task run ();
    $display("Time = %t [Monitor]: starting ...", $time);
    forever 
      begin
        @ (posedge vif.clk);
        if (vif.data_val_i) 
          begin
            bit_population_counter_transaction trns = new;
            trns.data_i = vif.data_i;
            
            @(posedge vif.clk);
            trns.data_o = vif.data_o;
            scb_mbx.put(trns);
          end
      end
  endtask 
  
endclass