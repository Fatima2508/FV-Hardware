################################################################################
#               Copyright 2006-2019 Mentor Graphics Corporation
#                            All Rights Reserved.
#               THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY
#             INFORMATION WHICH IS THE PROPERTY OF MENTOR GRAPHICS 
#         CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
################################################################################
# V2019 Formal Quick Start Tutorial
################################################################################
run: compile sim

###### Define Variables ########################################################
VLIB = ${QHOME}/modeltech/plat/vlib
VMAP = ${QHOME}/modeltech/plat/vmap
VLOG = ${QHOME}/modeltech/plat/vlog
VSIM = ${QHOME}/modeltech/plat/vsim

###### Compile Design ##########################################################
compile:
	$(VLIB) work
	$(VMAP) work work
	$(VLOG) ./testbench.v ./rtl/core.v ./rtl/alu.v ./rtl/CMEM.v \
			./rtl/CMEM_W.v ./rtl/counter.v ./rtl/fifo_shift_reg.v  ./rtl/REG_N.v 

sim:
	$(VSIM) testbench
	
