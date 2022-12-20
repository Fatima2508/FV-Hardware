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


###### Compile Design ##########################################################
compile:
	$(VLIB) work
	$(VMAP) work work
	$(VLOG) -sv ./src/vlog/core.v 
	
sim:
	$(VSIM) $(VSIMOPT)

clean:
	rm -rf work modelsim.ini *.wlf *.log replay* transcript *.db
