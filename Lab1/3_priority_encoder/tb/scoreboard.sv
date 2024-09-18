
import priority_encoder_pkg::*;

class scoreboard;
  mailbox scb_mbx;
  logic [WIDTH - 1 : 0] data_left_res, data_right_res;

  task run ();
    forever begin
      priority_encoder_transaction trns;
      scb_mbx.get(trns);
      
      data_left_res  = getDataLeft(trns.data_i);
      data_right_res = getDataRight(trns.data_i);

      // Check results
      if (trns.data_left_o !== data_left_res)
        $display("Time = %t [Scoreboard]: ERROR! Left:\t excepted %b, actual %b", $time, data_left_res, trns.data_left_o);
      else
        $display("Time = %t [Scoreboard]: PASS! Left:\t excepted %b, actual %b", $time, data_left_res, trns.data_left_o);

      if (trns.data_right_o !== data_right_res)
        $display("Time = %t [Scoreboard]: ERROR! Right:\t excepted %b, actual %b", $time, data_right_res, trns.data_right_o);
      else
        $display("Time = %t [Scoreboard]: PASS! Right:\t excepted %b, actual %b", $time, data_right_res, trns.data_right_o);

      // Error counter
      if ( ( trns.data_left_o !== data_left_res ) || ( trns.data_right_o !== data_right_res ) ) 
        err_cntr++;
    end
  endtask 

  function [WIDTH - 1 : 0] getDataLeft ( input [WIDTH - 1 : 0] data );
    getDataLeft  = '0;
    if ($countones(data) !== 0) begin
      if ($countones(data) == 1) 
        getDataLeft  = data;
      else begin
        int left_one  = $clog2(data) - 1;
        getDataLeft[left_one] = 1'b1;
      end
    end
  endfunction

  function [WIDTH - 1 : 0] getDataRight ( input [WIDTH - 1 : 0] data );
    getDataRight  = '0;
    if ($countones(data) !== 0) begin
      if ($countones(data) == 1) 
        getDataRight  = data;
      else begin
        int right_one  = WIDTH - $clog2(bit_reverse(data));
        getDataRight[right_one] = 1'b1;
      end
    end
  endfunction

  function [WIDTH - 1 : 0] bit_reverse ( input [WIDTH - 1 : 0] data );
    integer i;
    begin
      for ( i=0; i < WIDTH; i = i + 1 )
        begin
          bit_reverse[WIDTH-i-1] = data[i];
        end
      end
  endfunction

endclass