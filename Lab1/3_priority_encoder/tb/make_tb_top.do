vlib work

# RTL
vlog -sv    ../rtl/top_priority_encoder.sv
# TESTBENCH
vlog -sv    priority_encoder/priority_encoder_pkg.sv
vlog -sv    priority_encoder/priority_encoder_transaction.sv
vlog -sv    priority_encoder/priority_encoder_generator.sv
vlog -sv    priority_encoder/priority_encoder_driver.sv
vlog -sv    priority_encoder/priority_encoder_monitor.sv
vlog -sv    priority_encoder/priority_encoder_interface.sv
vlog -sv    scoreboard.sv
vlog -sv    environment.sv
vlog -sv    test.sv
vlog -sv    tb_top.sv

# vopt +acc tb_top -o tb_top_opt
# vsim tb_top -onfinish final
vsim tb_top

add log -r /*

add wave -divider "INPUT SIGNALS"
add wave                    tb_top/clk
add wave                    tb_top/srst_i
add wave                    tb_top/priority_encoder_intf.data_i
add wave                    tb_top/priority_encoder_intf.data_val_i

add wave -divider "OUTPUT SIGNALS"
add wave -radix binary      tb_top/priority_encoder_intf.data_left_o
add wave -radix binary      tb_top/priority_encoder_intf.data_right_o
add wave                    tb_top/priority_encoder_intf.data_val_o

add wave -divider "COUNTERS"
add wave -radix unsigned    priority_encoder_pkg/rand_tests_cntr
add wave -radix unsigned    priority_encoder_pkg/err_cntr

run -all
# quit -f