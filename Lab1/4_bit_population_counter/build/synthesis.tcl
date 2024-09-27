# delete_runs "width_8 width_16 width_32 width_64 width_128 width_256"

# WIDTH = 8
create_run width_8 -flow {Vivado Synthesis 2020}
create_run impl_width_8 -parent_run width_8 -flow {Vivado Implementation 2020}
set_property generic WIDTH=8 [current_fileset]

set_property part xc7a200tffg1156-1 [get_runs width_8]
set_property part xc7a200tffg1156-1 [get_runs impl_width_8]

current_run [get_runs width_8]
launch_runs width_8
wait_on_run width_8
launch_runs impl_width_8
wait_on_run impl_width_8

# WIDTH = 16
create_run width_16 -flow {Vivado Synthesis 2020}
create_run impl_width_16 -parent_run width_16 -flow {Vivado Implementation 2020}
set_property generic WIDTH=16 [current_fileset]

set_property part xc7a200tffg1156-1 [get_runs width_16]
set_property part xc7a200tffg1156-1 [get_runs impl_width_16]

current_run [get_runs width_16]
launch_runs width_16
wait_on_run width_16
launch_runs impl_width_16
wait_on_run impl_width_16

# WIDTH = 32
create_run width_32 -flow {Vivado Synthesis 2020}
create_run impl_width_32 -parent_run width_32 -flow {Vivado Implementation 2020}
set_property generic WIDTH=32 [current_fileset]

set_property part xc7a200tffg1156-1 [get_runs width_32]
set_property part xc7a200tffg1156-1 [get_runs impl_width_32]

current_run [get_runs width_32]
launch_runs width_32
wait_on_run width_32
launch_runs impl_width_32
wait_on_run impl_width_32

# WIDTH = 64
create_run width_64 -flow {Vivado Synthesis 2020}
create_run impl_width_64 -parent_run width_64 -flow {Vivado Implementation 2020}
set_property generic WIDTH=64 [current_fileset]

set_property part xc7a200tffg1156-1 [get_runs width_64]
set_property part xc7a200tffg1156-1 [get_runs impl_width_64]

current_run [get_runs width_64]
launch_runs width_64
wait_on_run width_64
launch_runs impl_width_64
wait_on_run impl_width_64

# WIDTH = 128
create_run width_128 -flow {Vivado Synthesis 2020}
create_run impl_width_128 -parent_run width_128 -flow {Vivado Implementation 2020}
set_property generic WIDTH=128 [current_fileset]

set_property part xc7a200tffg1156-1 [get_runs width_128]
set_property part xc7a200tffg1156-1 [get_runs impl_width_128]

current_run [get_runs width_128]
launch_runs width_128
wait_on_run width_128
launch_runs impl_width_128
wait_on_run impl_width_128

# WIDTH = 256
create_run width_256 -flow {Vivado Synthesis 2020}
create_run impl_width_256 -parent_run width_256 -flow {Vivado Implementation 2020}
set_property generic WIDTH=256 [current_fileset]

set_property part xc7a200tffg1156-1 [get_runs width_256]
set_property part xc7a200tffg1156-1 [get_runs impl_width_256]

current_run [get_runs width_256]
launch_runs width_256
wait_on_run width_256
launch_runs impl_width_256
wait_on_run impl_width_256
