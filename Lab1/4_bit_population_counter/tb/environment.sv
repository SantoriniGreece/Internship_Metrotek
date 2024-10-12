
`include "scoreboard.sv"

import bit_population_counter_pkg::*;

class environment;
  bit_population_counter_generator          g0;
  bit_population_counter_driver             d0;
  bit_population_counter_monitor            m0;
  scoreboard                                s0;

  mailbox                                   gen2drv_mbx;
  mailbox                                   drv2scb_mbx;
  mailbox                                   mon2scb_mbx;

  event                                     drv_done;
  event                                     env_done;

  virtual bit_population_counter_interface  vif;

  function new(virtual bit_population_counter_interface vif);
    // Interface
    this.vif    = vif;
    // Mailboxes
    gen2drv_mbx = new();
    drv2scb_mbx = new();
    mon2scb_mbx = new();
    // Components
    g0          = new(gen2drv_mbx, drv_done);
    d0          = new(vif        , gen2drv_mbx, drv2scb_mbx, drv_done);
    m0          = new(vif        , mon2scb_mbx);
    // Scoreboard
    s0          = new(drv2scb_mbx, mon2scb_mbx);
  endfunction

  virtual task run();
    
    fork
      g0.run();
      d0.run();
      m0.run();
      s0.run();     
    join_any

    #100 -> env_done;
  endtask
  
endclass