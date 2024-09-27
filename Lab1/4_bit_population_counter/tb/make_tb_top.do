vlib work

# RTL
vlog -sv    ../rtl/top_bit_population_counter.sv
# TESTBENCH
vlog -sv    bit_population_counter/bit_population_counter_pkg.sv
vlog -sv    bit_population_counter/bit_population_counter_transaction.sv
vlog -sv    bit_population_counter/bit_population_counter_generator.sv
vlog -sv    bit_population_counter/bit_population_counter_driver.sv
vlog -sv    bit_population_counter/bit_population_counter_monitor.sv
vlog -sv    bit_population_counter/bit_population_counter_interface.sv
vlog -sv    scoreboard.sv
vlog -sv    environment.sv
vlog -sv    tb_top.sv

# vopt +acc tb_top -o tb_top_opt
vsim tb_top

add log -r /*

add wave -divider "INPUT SIGNALS"
add wave                    tb_top/clk
add wave                    tb_top/srst_i
add wave -radix binary      tb_top/bit_population_counter_intf.data_i
add wave                    tb_top/bit_population_counter_intf.data_val_i

add wave -divider "OUTPUT SIGNALS"
add wave -radix unsigned    tb_top/bit_population_counter_intf.data_o
add wave                    tb_top/bit_population_counter_intf.data_val_o

add wave -divider "COUNTERS"
add wave -radix unsigned    bit_population_counter_pkg/rand_tests_cntr
add wave -radix unsigned    bit_population_counter_pkg/err_cntr

run -all
wave zoom full
# quit -f