# Define clocks
#netlist clock clk -period 10 

netlist clock read_clk -period 10 
netlist clock write_clk -period 20 

# Constrain rst
#netlist constraint rst -value 1'b0 -after_init

netlist constraint fifo_reset -value 1'b1 -after_init

