
package priority_encoder_pkg;

    parameter WIDTH     = 12;

    int rand_tests_cntr = 0;
    int err_cntr        = 0;

    int rand_tests      = 1000;
    int val1_tests      = 10;
    int val0_tests      = 10;

    parameter int TIMEOUT = 100_000;

    `include "priority_encoder_transaction.sv"
    `include "priority_encoder_generator.sv"
    `include "priority_encoder_driver.sv"
    `include "priority_encoder_monitor.sv"
    
endpackage