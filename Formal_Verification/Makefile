################################################################################
#               Copyright 2006-2019 Mentor Graphics Corporation
#                            All Rights Reserved.
#               THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY
#             INFORMATION WHICH IS THE PROPERTY OF MENTOR GRAPHICS 
#         CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
################################################################################
# V2019 Formal Quick Start Tutorial
#$(VLOG) ./testbench.v ./core.v ./alu.v ./CMEM.v ./CMEM_W.v ./counter.v ./fifo_shift_reg.v ./REG_N.v 
#$(VLOG) -sv ./core.sv ./alu.sv ./CMEM_W.sv ./CMEM.sv ./counter.sv ./fifo_shift_reg.sv ./REG_N.sv
################################################################################
run: clean compile formal debug

###### Define Variables ########################################################
VLIB = ${QHOME}/modeltech/plat/vlib
VMAP = ${QHOME}/modeltech/plat/vmap
VLOG = ${QHOME}/modeltech/plat/vlog

###### Compile Design ##########################################################
compile:
	$(VLIB) work
	$(VMAP) work work
	$(VLOG) -sv ./core.sv ./alu.sv ./CMEM_W.sv ./CMEM.sv ./counter.sv ./REG_N.sv ./fifo_shift_reg.sv
	
	

###### Run Formal Analysis #####################################################
formal:
	qverify -c -od Output_Results -do "\
		do qs_files/directives.tcl; \
		formal compile -d core; \
		formal verify -init qs_files/core.init \
		-timeout 5m; \
		exit"

###### Debug Results ###########################################################
debug: 
	qverify Output_Results/formal_verify.db &

###### Clean Data ##############################################################
clean:
	qverify_clean
	\rm -rf work modelsim.ini *.wlf *.log replay* transcript *.db
	\rm -rf Output_Results *.tcl 

################################################################################
# Regressions 
################################################################################
REGRESS_FILE_LIST = \
	Output_Results/formal_property.rpt \
	Output_Results/formal_verify.rpt

regression: clean compile formal
	@rm -f regress_file_list
	@echo "# This file was generated by make" > regress_file_list
	@/bin/ls -1 $(REGRESS_FILE_LIST) >> regress_file_list
	@chmod -w regress_file_list
