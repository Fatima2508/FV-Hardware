# 
# Questa Static Verification System
# Version 2019.2_1 linux_x86_64 18 May 2019

clear settings -all
clear directives
netlist clock read_clk -period 10 
netlist clock write_clk -period 20 
netlist constraint fifo_reset -value 1'b1 -after_init 
formal compile -d fifo_shift_reg
formal verify  -init  $env(SRC_ROOT)//homes/user/stud/fall21/Fd2508/Desktop/FV/FV-Hardware/FIR/qs_files/fifo.init -timeout 5m
