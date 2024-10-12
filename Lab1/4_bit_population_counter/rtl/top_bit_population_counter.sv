
module top_bit_population_counter #(
  parameter     WIDTH = 16
) (
  input  logic                                  clk,
  input  logic                                  srst_i,

  input  logic [              WIDTH - 1 : 0]    data_i,
  input  logic                                  data_val_i,

  output logic [($clog2(WIDTH) + 1) - 1 : 0]    data_o,
  output logic                                  data_val_o
);

  logic [($clog2(WIDTH) + 1) - 1 : 0]   count_ones;

  always_comb 
    begin
      count_ones = '0;  
      for(int i = 0; i < WIDTH; i++)
        begin
          count_ones = count_ones + data_i[i];
        end
    end

  always_ff @( posedge clk ) 
    begin
      data_o <= count_ones;
    end

  always_ff @( posedge clk ) 
    begin
      if (srst_i)
        data_val_o <= 1'b0;
      else
        data_val_o <= data_val_i;
    end
  
endmodule