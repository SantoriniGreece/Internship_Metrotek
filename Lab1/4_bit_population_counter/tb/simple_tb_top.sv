import bit_population_counter_pkg::*;

module simple_tb_top ( );

  parameter                    WIDTH = 8;

  bit                          clk;
  localparam int               CLK_PERIOD = 10;

  bit                          rst, srst_i;

  logic [    WIDTH - 1 : 0]    data_i;
  logic                        data_val_i;
  logic [$clog2(WIDTH) : 0]    data_o;
  logic                        data_val_o;
  
  bit_population_counter_transaction trns;

  initial 
    begin
    clk = 1'b0;
    forever 
      #(CLK_PERIOD/2) clk = ~clk;    
    end
    
  always @(clk) begin
    srst_i <= rst;
  end

  initial 
    begin
    rst = 1'b1;
    #100 rst = 1'b0;

    @( posedge clk )
    data_i      <= '1;
    data_val_i  <= 1'b1;
    forever 
      begin
        @( posedge clk )
//        data_i      <= $random%(2**(WIDTH)- 1);
//        data_val_i  <= $random%(2);
        trns = new;
        trns.randi() with { data_val_i == '1; };
//        trns.randi();
        
        data_i      <= trns.data_i;
        data_val_i  <= trns.data_val_i;
      end
    end

  top_bit_population_counter # (
    .WIDTH        (WIDTH))   
  dut_top (
    .clk          (clk),
    .srst_i       (srst_i),
    .data_i       (data_i),
    .data_val_i   (data_val_i),
    .data_o       (data_o),
    .data_val_o   (data_val_o)
  );

endmodule