##################################################
#  Modelsim do file to run simuilation
#  MS 7/2015
##################################################

vlib work
vmap work work

# Include Netlist and Testbench
vlog +acc -incr /courses/ee6321/share/ibm13rflpvt/verilog/ibm13rflpvt.v
vlog +acc -incr ../../dc/core/results/core.nl.v
vlog +acc -incr ../../memory_comp/CMEM/CMEM.v
vlog +acc -incr core_test_fi.v

# Run Simulator
vsim -voptargs=+acc -t ps -lib work -sdftyp core_0=../../dc/core/core.syn.sdf testbench
do waveformat.do
run -all
