`timescale 1ns / 1ps

module top_priority_encoder # (
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

    logic [WIDTH - 1 : 0]           data_left, data_right;
    
    always_ff @(posedge clk) begin : left_one
        if (srst_i)
            data_left_o <= '0;
        else if (data_val_i) begin
            data_left_o <= '0;
            for (int i = WIDTH - 1; i >= 0; i--) begin
                if (data_i[i]) begin
                    data_left_o[i] <= 1'b1;
                    break;
                end
            end
        end
    end

    always_ff @(posedge clk) begin : right_one
        if (srst_i)
            data_right_o <= '0;
        else if (data_val_i) begin
            data_right_o <= '0;
            for (int i = 0; i < WIDTH; i++) begin
                if (data_i[i]) begin
                    data_right_o[i] <= 1'b1;
                    break;
                end
            end
        end
    end

//    always_ff @( posedge clk ) begin : data_left_delay
//        if (srst_i)
//            data_left_o <= '0;
//        else
//            data_left_o <= data_left;
//    end

//    always_ff @( posedge clk ) begin : data_right_delay
//        if (srst_i)
//            data_right_o <= '0;
//        else
//            data_right_o <= data_right;
//    end

    always_ff @( posedge clk ) begin : val_o
        if (srst_i)
            data_val_o <= 1'b0;
        else
            data_val_o <= data_val_i;
    end
    
endmodule