# 
# Questa Static Verification System
# Version 2019.2_1 linux_x86_64 18 May 2019

clear settings -all
clear directives
netlist clock clk -period 10 
netlist constraint rst -value 1'b0 -after_init 
formal compile -d core
formal verify  -init  $env(SRC_ROOT)//homes/user/stud/fall21/ig2451/FV-Hardware/FIR/qs_files/core.init -timeout 5m
