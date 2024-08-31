`timescale 1ns / 1ps

module top_deserializer_wrapper (
    input  logic            clk,
    input  logic            srst_i,
    input  logic            data_i,
    input  logic            data_val_i,
    output logic [15 : 0]   deser_data_o,
    output logic            deser_data_val_o
);

    logic                   wr_srst_i;
    logic                   wr_data_i;
    logic                   wr_data_val_i;
    logic [15 : 0]          wr_deser_data_o;
    logic                   wr_deser_data_val_o;

    always_ff @( posedge clk ) begin : i_ff
        wr_srst_i       <= srst_i;
        wr_data_i       <= data_i;
        wr_data_val_i   <= data_val_i;
    end

    top_deserializer    dut_top_deserializer(
        .clk                (clk),
        .srst_i             (wr_srst_i),
        .data_i             (wr_data_i),
        .data_val_i         (wr_data_val_i),
        .deser_data_o       (wr_deser_data_o),
        .deser_data_val_o   (wr_deser_data_val_o)
    );

    always_ff @( posedge clk ) begin : o_ff
        deser_data_o     <= wr_deser_data_o;
        deser_data_val_o <= wr_deser_data_val_o;
    end
    
endmodule
