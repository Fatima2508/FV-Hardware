######################################################################
## Timing setup for logic synthesis
## The unit for time is ns as defined in the IBM delay-power library
## The unit for wireload is pF as defined in the IBM delay-power library
## MS 2015
######################################################################

# Setting variables
# clk1 = 10kHz
# clk2 = 2MHz
set clk1_period 100000 
set clk2_period 500
set clk_uncertainty 0
set clk_transition 0.010
set typical_input_delay 0.05
set typical_output_delay 0.05
set typical_wire_load 0.005

#Create real clock if clock port is found
if {[sizeof_collection [get_ports clk1]] > 0} {
  set clk1_name "clk1"
  set clk1_port "clk1"
  #If no waveform is specified, 50% duty cycle is assumed
  create_clock -name $clk1_name -period $clk1_period [get_ports $clk1_port]
}

#Create real clock if clock port is found
if {[sizeof_collection [get_ports clk2]] > 0} {
  set clk2_name "clk2"
  set clk2_port "clk2"
  #If no waveform is specified, 50% duty cycle is assumed
  create_clock -name $clk2_name -period $clk2_period [get_ports $clk2_port]
}

#Set clock uncertainty
set_clock_uncertainty $clk_uncertainty [get_clocks $clk1_name]
set_clock_uncertainty $clk_uncertainty [get_clocks $clk2_name]
#Propagated clock used for gated clocks only
set_clock_transition $clk_transition [get_clocks $clk1_name]
set_clock_transition $clk_transition [get_clocks $clk2_name]

# Configure the clock network
set_fix_hold [all_clocks]
set_dont_touch_network $clk1_port
set_dont_touch_network $clk2_port
set_ideal_network $clk1_port
set_ideal_network $clk2_port
#set_ideal_network pad_*
#set_ideal_network sc_*

# Set the paths to be ignored in timing opt
#set_false_path -from pad_*
#set_false_path -from sc_*

# Set input and output delays
set_driving_cell -lib_cell INVX1TS [all_inputs]
set_input_delay $typical_input_delay [all_inputs] -clock $clk1_name
set_input_delay $typical_input_delay [all_inputs] -clock $clk2_name
remove_input_delay -clock $clk1_name [find port $clk1_port]
remove_input_delay -clock $clk2_name [find port $clk2_port]
set_output_delay $typical_output_delay [all_outputs] -clock $clk1_name
set_output_delay $typical_output_delay [all_outputs] -clock $clk2_name

# Customize for block
#set_output_delay 52 [all_outputs] -clock $clk_name
#set_output_delay 0 next_* -clock $clk_name

# Set loading of outputs
set_load 0.01 [all_outputs]
