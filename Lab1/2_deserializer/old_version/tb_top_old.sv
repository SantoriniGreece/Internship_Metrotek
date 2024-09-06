`timescale 1ns / 1ns

module tb_top_old;
 
    bit             clk;
    logic           srst_i;
    logic           data_i;
    logic           data_val_i;
    logic [15 : 0]  deser_data_o;
    logic           deser_data_val_o;

    logic [15 : 0]  deser_data_res = 16'd1;
    integer         ind;

    int max_res     = 100;
    int max_err     = 5;
    
    int res_cntr    = 0;
    int err_cntr    = 0;
    int bit_cntr    = 0;
    int errbit_cntr = 0;
    
    enum logic [1 : 0] {OK, ERROR, IDLE} res_val = IDLE;
    
    initial
      forever
        #5 clk = !clk;
        
    initial $timeformat(-9, 0, " ns", 8);
        
    default clocking cb @ (posedge clk);
    endclocking

    initial begin
       srst_i <= 1'b0;
       ##1
       srst_i <= 1'b1;
       ##5
       srst_i <= 1'b0; 
    end
    
    task getRandomData (); 
        forever begin
            ##1
            data_i      = $urandom%(2);
            data_val_i  = 1'b1;
        end
    endtask
    
    task testDeserializer ();
        forever begin
            @(posedge clk)
            if (srst_i)
                deser_data_res  = '0;
            else begin
                deser_data_res  = (deser_data_res << data_val_i);   
                deser_data_res  = deser_data_res + (data_val_i & data_i);
            end     
        end
    endtask
    
    task state ();
        forever begin
            ##1
            if (deser_data_val_o) begin
                res_cntr    = res_cntr + 1;
                bit_cntr    = bit_cntr + 16;
                if (deser_data_o !== deser_data_res) begin
                    res_val = ERROR;
                end else
                    res_val = OK;
            end else begin
                res_val = IDLE;
            end
            // Log
            if (res_val == ERROR) begin
                $display("\tError (time %t): expected %b (%b)", $realtime, deser_data_res, deser_data_o);
                err_cntr    = err_cntr + 1;
                errbit_cntr = errbit_cntr + $countones(deser_data_o ^ deser_data_res);
            end else if (res_val == OK) begin
                $display("\tOK (time %t): the word is accepted successful (%b)", $realtime, deser_data_o);
            end
        end
    endtask
    
    task end_test ();
        forever begin
            ##1
            if ( ( res_cntr >= max_res) || ( err_cntr >= max_err) ) begin
                 $display("---------------------------------------------------------------------------------");
                 if (res_cntr >= max_res) 
                     $display("\tSimulation is done (time %t): maximum number of words received (%0d)", $time, max_res);
                 else
                     $display("\tSimulation is done (time %t): maximum number of errors detected (%0d)", $time, max_err);
                 $display("\t%0d words received,\t%0d errors found", res_cntr, err_cntr);
                 $display("\t%0d bits received,\t%0d bit-errors found", bit_cntr, errbit_cntr);
                 $display("---------------------------------------------------------------------------------");
                 $finish;
            end
        end
    endtask

    initial begin
        fork 
            getRandomData();
            testDeserializer();
            state();
            end_test();             
        join     
    end

    top_deserializer_old    dut_top_deserializer(
        .clk                (clk),
        .srst_i             (srst_i),
        .data_i             (data_i),
        .data_val_i         (data_val_i),
        .deser_data_o       (deser_data_o),
        .deser_data_val_o   (deser_data_val_o)
    );


endmodule