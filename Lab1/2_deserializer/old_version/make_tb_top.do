vlib work

vlog -sv top_deserializer_old.sv
vlog -sv tb_top_old.sv

vsim -novopt tb_top_old

add log -r /*

add wave -divider "INPUT SIGNALS"
add wave                    tb_top_old/clk
add wave                    tb_top_old/srst_i
add wave                    tb_top_old/data_i
add wave                    tb_top_old/data_val_i

add wave -divider "OUTPUT SIGNALS"
add wave -radix binary      tb_top_old/deser_data_o
add wave                    tb_top_old/deser_data_val_o

add wave -divider "CHECK"
add wave -radix binary      tb_top_old/deser_data_res
add wave                    tb_top_old/res_val
add wave -radix unsigned    tb_top_old/res_cntr
add wave -radix unsigned    tb_top_old/bit_cntr
add wave -radix unsigned    tb_top_old/err_cntr
add wave -radix unsigned    tb_top_old/errbit_cntr

run 1us
