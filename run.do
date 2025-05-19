vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.alsu_top -cover -classdebug -uvmcontrol=all
add wave /alsu_top/alsu_if/*
coverage save ALSU_tb.ucdb -onexit
run -all