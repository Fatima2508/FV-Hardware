#################################################
# Primetime
# Script for static timing analysis
# MS 7/2015
#################################################

#################################################
# Units are defined in the .lib file
# time: ns
#################################################

## Global
set sh_enable_page_mode true
set power_enable_analysis true

## Setting files/paths
set verilog_files {../../dc/core/results/core.nl.v}
set my_toplevel core
set search_path ". /courses/ee6321/share/ibm13rflpvt/synopsys/"
set link_path "* scx3_cmos8rf_lpvt_tt_1p2v_25c.db"

## Read design
set link_library [list "/homes/user/stud/fall21/ms6350/EE4823_PG9/memory_comp/CMEM/CMEM_tt_1p2v_25c_syn.db" \
    "scx3_cmos8rf_lpvt_tt_1p2v_25c.db"]
read_verilog $verilog_files
link_design -keep_sub_designs $my_toplevel

## Timing Constraints
source ./timing.tcl

###################################################
## Run STA
###################################################
set rpt_file "./core_pt.rpt"
check_timing
report_design >> ${rpt_file}
report_reference >> ${rpt_file}
report_constraint >> ${rpt_file}
report_constraint -all_violators -significant_digits 4 >> ${rpt_file}
report_timing -significant_digits 4 -delay_type min_max >> ${rpt_file}

## Power analysis
set power_analysis_mode "time_based"
read_vcd "../../qsim_dc/core/core_fi_short.vcd" -strip_path "testbench/core_0"
report_switching_activity >> ${rpt_file}
report_switching_activity -list_not_annotated >> ${rpt_file}
update_power
report_power >> ${rpt_file}
report_power -hierarchy  >> ${rpt_file}

write_sdf -context verilog "./core.sdf"

# Exiting primetime
quit
