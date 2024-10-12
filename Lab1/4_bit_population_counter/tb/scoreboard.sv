
import bit_population_counter_pkg::*;

class scoreboard;
  mailbox mon2scb_mbx, drv2scb_mbx;

  function new(mailbox drv2scb_mbx, mailbox mon2scb_mbx);
    this.drv2scb_mbx = drv2scb_mbx;
    this.mon2scb_mbx = mon2scb_mbx;    
  endfunction

  task run ();
    forever 
      begin
        bit_population_counter_transaction trns_rx, trns_tx;
        mon2scb_mbx.get(trns_rx);
        drv2scb_mbx.get(trns_tx);

        // Check results
        if (trns_tx.data_val_i) begin
          if ( trns_rx.data_o !== $countones(trns_tx.data_i) )
            $display("Time = %t [Scoreboard]: ERROR! excepted %0d, actual %0d", $time, $countones(trns_tx.data_i), trns_rx.data_o);
          else
            $display("Time = %t [Scoreboard]: PASS!  excepted %0d, actual %0d", $time, $countones(trns_tx.data_i), trns_rx.data_o);

          // Error counter
          if ( trns_rx.data_o !== $countones(trns_tx.data_i) ) 
            err_cntr++;
        end
        
      end
  endtask

endclass