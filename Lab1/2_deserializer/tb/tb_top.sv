`timescale 1ns / 1ns

module tb_top;

    //* Входные и выходные сигналы модуля
    bit             clk;
    logic           srst_i;
    logic           data_i;
    logic           data_val_i;
    logic [15 : 0]  deser_data_o;
    logic           deser_data_val_o;

    //* Переменные для проверки правильности работы модуля, счетчики
    logic [15 : 0]  deser_data_res = 16'd1; // Основной результат

    int max_res     = 10000;
    int max_err     = 5;
    int res_cntr    = 0; // Счетчик результата
    int err_cntr    = 0; // Счетчик ошибок результата
    int bit_cntr    = 0; // Счетчик количества переданных бит
    int errbit_cntr = 0; // Счетчик битовых ошибок

    int val_o_cntr  = 0; // Счетчик для строб-теста

    enum logic [1 : 0] {OK, ERROR, IDLE}                        res_val = IDLE;
    enum logic [1 : 0] {RANDOM, VALID_ZERO, VALID_ONE, RESET}   test_val = RESET;
    
    // Длительность каждого режима симуляции: RESET, VALID_ONE, VALID_ZERO (остальное время - RANDOM)
    int test_length_cycles[3] = '{10, 50, 100};
    
    // Буфер для записи последних BUFFER_DEPTH значений (в лог для ошибок)
    parameter                       BUFFER_DEPTH = 64;
    logic [BUFFER_DEPTH - 1 : 0]    buffer_data[2];
    
    int fd; // file id
    
    //* Настройка клока
    initial
      forever
        #5 clk = !clk;
        
    initial $timeformat(-9, 0, " ns", 8);
        
    default clocking cb @ (posedge clk);
    endclocking
    
    //* Таски для теста
    task srst (); //! Сброс
        srst_i = 1'b1;
        ##(test_length_cycles[0])
        srst_i = 1'b0; 
    endtask

    task get_test_type (); //! Выбор режима теста
        test_val = VALID_ONE;
        ##(test_length_cycles[1])
        test_val = VALID_ZERO;
        ##(test_length_cycles[2])
        test_val = RANDOM;
    endtask 
        
    task getData (); //! Генерация входных данных
        forever begin
            ##1
            data_i = $random%(2);
            if (test_val == VALID_ONE)
                data_val_i = 1'b1;
            else if (test_val == VALID_ZERO)
                data_val_i = 1'b0;
            else 
                data_val_i = $random%(2);
        end
    endtask
        
    task saveData (); //! Запись истории
        buffer_data = '{ default : '0 };
        forever begin
            @(posedge clk)
            buffer_data[0]      = (buffer_data[0] << 1);
            buffer_data[0][0]   = data_i;
            buffer_data[1]      = (buffer_data[1] << 1);
            buffer_data[1][0]   = data_val_i;
        end
    endtask
    
    task openFile (); //! Открытие файла, проверка
        fd = $fopen("./errlog.txt", "w");
        if (fd) $display("File was opened successfully: fd = %0d", fd);
        else begin 
            $display("File was NOT opened successfully: fd = %0d", fd);
            $stop;
        end   
    endtask
    
    task writeData (); //! Запись в файл при ошибки (результаты, время, входные данные последних BUFFER_DEPTH тактов)
        $fdisplay(fd, "Error (time %t): expected %b (%b)", $realtime, deser_data_res, deser_data_o);
        $fdisplay(fd, "data_i buffer: \t\t%b", buffer_data[0]);
        $fdisplay(fd, "data_val_i buffer: \t%b", buffer_data[1]);
        $fdisplay(fd, "----------------------------------------------------------------------------------------");
    endtask
    
    task testDeserializer (); //! Тест десериализатора
        forever begin
            @(posedge clk)
            if (data_val_i) begin
                deser_data_res = (deser_data_res << 1);
                deser_data_res[0] = data_i;
                // deser_data_res[0] = 1'b0; // error test
            end   
        end
    endtask
    
    task state (); //! Статус теста (нахождение ошибки, инкремент счетчиков)
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
                $display("# %d.\tError (time %t): expected %b (%b)", res_cntr, $realtime, deser_data_res, deser_data_o);
                err_cntr    = err_cntr + 1;
                errbit_cntr = errbit_cntr + $countones(deser_data_o ^ deser_data_res);
                if (fd) 
                    writeData();
            end else if (res_val == OK) begin
                $display("# %d.\tOK (time %t): the word is accepted successful (%b)", res_cntr, $realtime, deser_data_o);
            end
        end
    endtask

    task testStrobe();
        forever begin
            ##1
            val_o_cntr = val_o_cntr + deser_data_val_o;
        end
    endtask 
    
    task end_test (); //! Окончание теста и его лог
        forever begin
            ##1
            if ( ( res_cntr >= max_res) || ( err_cntr >= max_err) ) begin
                $display("---------------------------------------------------------------------------------");
                // Main results test
                if (res_cntr >= max_res) 
                    $display("\tSimulation is done (time %t): maximum number of words received (%0d)", $time, max_res);
                else
                    $display("\tSimulation is done (time %t): maximum number of errors detected (%0d)", $time, max_err);
                $display("\t%0d words received,\t%0d errors found", res_cntr, err_cntr);
                $display("\t%0d bits received,\t%0d bit-errors found", bit_cntr, errbit_cntr);
                // Strobe test
                if (val_o_cntr == max_res) 
                    $display("\tStrobe test completed!");
                else
                    $display("\tStrobe test failed!");
                $display("---------------------------------------------------------------------------------");
                if (fd) 
                    $fclose(fd);
                $finish;
            end
        end
    endtask

    //* Основной тест
    initial begin 
        openFile ();
        srst ();
        fork 
            get_test_type();
            getData();
            saveData();
            testDeserializer();
            testStrobe();
            state();
            end_test();             
        join     
    end

    //* Подключение модуля
    top_deserializer    dut_top_deserializer(
        .clk                (clk),
        .srst_i             (srst_i),
        .data_i             (data_i),
        .data_val_i         (data_val_i),
        .deser_data_o       (deser_data_o),
        .deser_data_val_o   (deser_data_val_o)
    );


endmodule