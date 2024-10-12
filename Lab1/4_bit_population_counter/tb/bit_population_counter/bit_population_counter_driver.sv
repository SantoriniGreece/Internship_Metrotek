
import bit_population_counter_pkg::*;

class bit_population_counter_driver;

  virtual bit_population_counter_interface vif;
  mailbox gen2drv_mbx, drv2scb_mbx;
  event drv_done;
  bit_population_counter_transaction tr2scb = new();

  function new(virtual bit_population_counter_interface vif, mailbox gen2drv_mbx, mailbox drv2scb_mbx, event drv_done);
    this.vif         = vif;
    this.gen2drv_mbx = gen2drv_mbx;
    this.drv2scb_mbx = drv2scb_mbx;
    this.drv_done    = drv_done;
  endfunction

  task run();
    $display("Time = %t [Driver]: starting ...", $time);
    @(posedge vif.clk);
    forever 
      begin
        bit_population_counter_transaction trns;

        gen2drv_mbx.get(trns);

        vif.data_val_i <= trns.data_val_i;
        vif.data_i     <= trns.data_i;

        tr2scb.data_val_i <= vif.data_val_i;
        tr2scb.data_i     <= vif.data_i;
        drv2scb_mbx.put(tr2scb);

        @(posedge vif.clk);
        vif.data_val_i <= 1'b0;
        -> drv_done;
      end

  endtask

endclass //className