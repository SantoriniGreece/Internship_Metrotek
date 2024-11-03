
module top_debouncer #(
  parameter CLK_FREQ_MHZ   = 100, 
  parameter GLITCH_TIME_NS = 50
) (
  input  logic clk,
  input  logic key_i,
  output logic key_pressed_stb_o
);

  localparam GLITCH_TIME_CYCLES = int'(GLITCH_TIME_NS * CLK_FREQ_MHZ / 1000);

  logic [2 : 0]                                key_sync;
  logic [$clog2(GLITCH_TIME_CYCLES) - 1 : 0]   counter = '0;
  logic                                        en;

  logic                                        onkey;
  logic                                        onkey_d;

  always_ff @( posedge clk ) 
    begin
      key_sync <= (key_sync << 1) | key_i;
      if (key_sync[2 : 1] == 2'b01)
        en <= 1'b1;
      else if (counter == GLITCH_TIME_CYCLES)
        en <= 1'b0;
    end

  always_ff @( posedge clk ) 
    begin
      if (counter == GLITCH_TIME_CYCLES)
        counter <= '0;
      else 
        begin
          if (en && (~key_i))
            counter <= counter + 1'b1;
          else if (en && key_i)
            counter <= '0;
        end
      
    end

  always_ff @( posedge clk ) 
    begin
      if (counter == GLITCH_TIME_CYCLES)
        onkey <= 1'b1;
      else
        onkey <= 1'b0;
    end

  always_ff @( posedge clk ) begin
    onkey_d <= onkey;
  end

  assign key_pressed_stb_o = onkey & (~onkey_d);
  
endmodule