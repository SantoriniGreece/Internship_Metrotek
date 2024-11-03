
module simple_top_tb2 ( );

  parameter CLK_FREQ_MHZ   = 500;
  parameter GLITCH_TIME_NS = 10;

  parameter CLK_PERIOD = int'(1000 / CLK_FREQ_MHZ); // ns

  logic clk, key_i, key_pressed_stb_o;

  initial 
    begin
    clk = 1'b0;
    forever 
      #(CLK_PERIOD/2) clk = !clk;
    end
    
  initial
    begin
      key_i = 1'b0;
      #(CLK_PERIOD*5)
      for (int i = -5; i < 5; i++) begin
        @(posedge clk)
        key_i = 1'b1;
        #(CLK_PERIOD*3)
        key_i = 1'b0;
        #(GLITCH_TIME_NS + i)
        key_i = 1'b1;
      end
      $finish;
    end
      
  top_debouncer #(CLK_FREQ_MHZ, GLITCH_TIME_NS) inst_debouncer (.*);
  
endmodule