
import priority_encoder_pkg::*;
`include "scoreboard.sv"

class environment;
  priority_encoder_generator          g0;
  priority_encoder_driver             d0;
  priority_encoder_monitor            m0;
  scoreboard                          s0;

  mailbox                             drv_mbx;
  mailbox                             scb_mbx;
  event                               drv_done;

  virtual priority_encoder_interface  vif;

  function new ();
    g0          = new;
    d0          = new;
    m0          = new;
    s0          = new;

    drv_mbx     = new();
    scb_mbx     = new();

    g0.drv_mbx  = drv_mbx;
    d0.drv_mbx  = drv_mbx;
    m0.scb_mbx  = scb_mbx;
    s0.scb_mbx  = scb_mbx;

    d0.drv_done = drv_done;
    g0.drv_done = drv_done;

  endfunction

  virtual task run();
    d0.vif = vif;
    m0.vif = vif;

    fork
      g0.run();
      d0.run();
      m0.run();
      s0.run();     
    join_any
  endtask 

endclass