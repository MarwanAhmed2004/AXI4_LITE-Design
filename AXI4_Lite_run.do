vlib work
vlog AXI4-Lite_top.v AXI4-Lite_Master.v AXI4-Lite_Slave.v AXI4-Lite_Ram.v AXI4-Lite_golden.v AXI4-Lite_tb.v
vsim -voptargs=+acc work.AXI4_Lite_TB
add wave *
add wave -position insertpoint  \
sim:/AXI4_Lite_TB/dut1/slave1/ram/mem
add wave -position insertpoint  \
sim:/AXI4_Lite_TB/dut1/ARREADY \
sim:/AXI4_Lite_TB/dut1/AWREADY \
sim:/AXI4_Lite_TB/dut1/BVALID \
sim:/AXI4_Lite_TB/dut1/RVALID \
sim:/AXI4_Lite_TB/dut1/WREADY \
sim:/AXI4_Lite_TB/dut1/BRESP \
sim:/AXI4_Lite_TB/dut1/RRESP \
sim:/AXI4_Lite_TB/dut1/AWVALID \
sim:/AXI4_Lite_TB/dut1/ARVALID \
sim:/AXI4_Lite_TB/dut1/WVALID \
sim:/AXI4_Lite_TB/dut1/RREADY \
sim:/AXI4_Lite_TB/dut1/BREADY
run -all
#quit -sim
