
import bit_population_counter_pkg::*;

class scoreboard;
  mailbox scb_mbx;

  task run ();
    forever 
      begin
        bit_population_counter_transaction trns;
        scb_mbx.get(trns);

        // Check results
        if ( trns.data_o !== $countones(trns.data_i) )
          $display("Time = %t [Scoreboard]: ERROR! excepted %0d, actual %0d", $time, $countones(trns.data_i), trns.data_o);
        else
          $display("Time = %t [Scoreboard]: PASS!  excepted %0d, actual %0d", $time, $countones(trns.data_i), trns.data_o);

        // Error counter
        if ( trns.data_o !== $countones(trns.data_i) ) 
          err_cntr++;
      end
  endtask

endclass