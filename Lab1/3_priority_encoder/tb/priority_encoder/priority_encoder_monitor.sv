
import priority_encoder_pkg::*;

class priority_encoder_monitor;
  virtual priority_encoder_interface vif;
  mailbox scb_mbx;

  task run ();
    $display("Time = %t [Monitor]: starting ...", $time);
    forever begin
      @ (posedge vif.clk);
      if (vif.data_val_i) begin
        priority_encoder_transaction trns = new;
        trns.data_i = vif.data_i;
        
        @(posedge vif.clk);
        trns.data_left_o  = vif.data_left_o;
        trns.data_right_o = vif.data_right_o;
        scb_mbx.put(trns);
      end
    end
  endtask 
  
endclass