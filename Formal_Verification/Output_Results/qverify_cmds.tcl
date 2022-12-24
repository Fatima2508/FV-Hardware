# do qs_files/directives.tcl
netlist clock read_clk -period 10
netlist clock write_clk -period 20
netlist constraint fifo_reset -value 1'b1 -after_init
# end do qs_files/directives.tcl
formal compile -d core
formal verify -init qs_files/core.init -timeout 5m
