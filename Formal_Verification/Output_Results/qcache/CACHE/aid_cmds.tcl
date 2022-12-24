# 
# Questa Static Verification System
# Version 2019.2_1 linux_x86_64 18 May 2019

clear settings -all
clear directives
netlist clock read_clk -period 10 
netlist clock write_clk -period 20 
netlist constraint fifo_reset -value 1'b1 -after_init 
formal compile -d core
formal verify  -init  $env(SRC_ROOT)//homes/user/stud/fall21/ig2451/FV/FV-Hardware/Formal_Verification/qs_files/core.init -timeout 5m
