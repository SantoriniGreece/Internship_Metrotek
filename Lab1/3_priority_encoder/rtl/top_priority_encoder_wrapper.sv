`timescale 1ns / 1ps

module top_priority_encoder_wrapper # (
    parameter WIDTH = 8
) (
    input  logic                    clk,
    input  logic                    srst_i,
    input  logic [WIDTH - 1 : 0]    data_i,
    input  logic                    data_val_i,
    output logic [WIDTH - 1 : 0]    data_left_o,
    output logic [WIDTH - 1 : 0]    data_right_o,
    output logic                    data_val_o
);

    logic                   wr_srst_i;
    logic [WIDTH - 1 : 0]   wr_data_i;
    logic                   wr_data_val_i;
    logic [WIDTH - 1 : 0]   wr_data_left_o, wr_data_right_o;
    logic                   wr_data_val_o;

    always_ff @( posedge clk ) begin : i_ff
        wr_srst_i       <= srst_i;
        wr_data_i       <= data_i;
        wr_data_val_i   <= data_val_i;
    end

    top_priority_encoder # (
        .WIDTH              (WIDTH))   
    dut_top_priority_encoder (
        .clk                (clk),
        .srst_i             (wr_srst_i),
        .data_i             (wr_data_i),
        .data_val_i         (wr_data_val_i),
        .data_left_o        (wr_data_left_o),
        .data_right_o       (wr_data_right_o),
        .data_val_o         (wr_data_val_o)
    );

    always_ff @( posedge clk ) begin : o_ff
        data_left_o     <= wr_data_left_o;
        data_right_o    <= wr_data_right_o;
        data_val_o      <= wr_data_val_o;
    end
    
endmodule
