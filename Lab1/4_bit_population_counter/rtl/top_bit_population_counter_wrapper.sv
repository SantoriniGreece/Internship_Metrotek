
module top_bit_population_counter_wrapper #(
  parameter     WIDTH = 16
) (
  input  logic                        clk,
  input  logic                        srst_i,

  input  logic [    WIDTH - 1 : 0]    data_i,
  input  logic                        data_val_i,

  output logic [$clog2(WIDTH) : 0]    data_o,
  output logic                        data_val_o
);

  logic                        wr_srst_i;
  logic [    WIDTH - 1 : 0]    wr_data_i;
  logic                        wr_data_val_i;
  logic [$clog2(WIDTH) : 0]    wr_data_o;
  logic                        wr_data_val_o;

  always_ff @( posedge clk ) 
    begin : i_ff
      wr_srst_i     <= srst_i;
      wr_data_i     <= data_i;
      wr_data_val_i <= data_val_i;
    end

  top_bit_population_counter # (
    .WIDTH        (WIDTH))   
  dut_top_bit_population_counter (
    .clk          (clk),
    .srst_i       (wr_srst_i),
    .data_i       (wr_data_i),
    .data_val_i   (wr_data_val_i),
    .data_o       (wr_data_o),
    .data_val_o   (wr_data_val_o)
  );

  always_ff @( posedge clk ) 
    begin : o_ff
      data_o        <= wr_data_o;
      data_val_o    <= wr_data_val_o;
    end
  
endmodule