vlib work

vlog -sv ../rtl/top_deserializer.sv
vlog -sv tb_top.sv

vsim -novopt tb_top

add log -r /*

add wave -divider "INPUT SIGNALS"
add wave                    tb_top/clk
add wave                    tb_top/srst_i
add wave                    tb_top/data_i
add wave                    tb_top/data_val_i

add wave -divider "OUTPUT SIGNALS"
add wave -radix binary      tb_top/deser_data_o
add wave                    tb_top/deser_data_val_o

# add wave -divider "INTERNAL SIGNALS"
# add wave -radix binary      tb_top/fixed_data
# add wave                    tb_top/en

add wave -divider "CHECK"
add wave -radix binary      tb_top/deser_data_res
add wave                    tb_top/res_val
add wave -radix unsigned    tb_top/res_cntr
add wave -radix unsigned    tb_top/bit_cntr
add wave -radix unsigned    tb_top/err_cntr
add wave -radix unsigned    tb_top/errbit_cntr

run -all