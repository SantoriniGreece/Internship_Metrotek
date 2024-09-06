`timescale 1ns / 1ps

module top_deserializer_old (
    input  logic            clk,
    input  logic            srst_i,
    input  logic            data_i,
    input  logic            data_val_i,
    output logic [15 : 0]   deser_data_o,
    output logic            deser_data_val_o
);

    logic [ 3 : 0]          counter;
    logic [15 : 0]          tmp;
    logic                   val, val_d;

    always_ff @( posedge clk ) begin : counter_proc
        if (srst_i)
            counter <= '0;
        else if (data_val_i) begin
            if (counter == '1)
                val <= 1'b1;
            counter <= counter + 1'b1;
        end
        else val <= 1'b0;
    end

    always_ff @( posedge clk ) begin : shift_register_proc
        if (data_val_i)
            tmp <= {tmp[14 : 0], data_i};       
    end
    
    always_ff @( posedge clk ) begin : strobe_proc
        val_d <= val;
    end
    
    assign deser_data_o     = tmp;
    assign deser_data_val_o = val & (~val_d);

endmodule