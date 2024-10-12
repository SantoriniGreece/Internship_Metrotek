
import bit_population_counter_pkg::*;

class bit_population_counter_monitor;
  virtual bit_population_counter_interface vif;
  mailbox   mon2scb_mbx;

  function new(virtual bit_population_counter_interface vif, mailbox mon2scb_mbx);
    this.vif         = vif;
    this.mon2scb_mbx = mon2scb_mbx;
  endfunction

  task run ();
    $display("Time = %t [Monitor]: starting ...", $time);
    forever 
      begin
        bit_population_counter_transaction trns = new();
        @ (posedge vif.clk);
        
        trns.data_o = vif.data_o;
        mon2scb_mbx.put(trns);
      end
  endtask 
  
endclass