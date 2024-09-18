
import priority_encoder_pkg::*;
`include "environment.sv"

class test;
  environment e0;

  function new();
    e0 = new();
  endfunction

  task run();
    e0.run();
  endtask

endclass