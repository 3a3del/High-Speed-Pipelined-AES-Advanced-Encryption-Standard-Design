############################################################
#################	Parameters	####################
############################################################
set CLK_PERIOD 1


set UNCERTAINTY_SETUP  0.1

set UNCERTAINTY_HOLD  0.1

set CLOCK_TRANSITION 0.02

set INPUT_DELAY  [expr 0.1*$CLK_PERIOD]
set OUTPUT_DELAY [expr 0.1*$CLK_PERIOD]

#################   Clock Constraints   ####################
############################################################

create_clock -name clk -period $CLK_PERIOD [get_ports clk] 

## clock transition
set_clock_transition $CLOCK_TRANSITION [get_clocks clk]


set_clock_uncertainty -setup $UNCERTAINTY_SETUP  [all_clocks]
set_clock_uncertainty -hold $UNCERTAINTY_HOLD [all_clocks]

##################################################################
#################   environment constraints   ####################
##################################################################
## input & output delays

set_input_delay $INPUT_DELAY -clock [get_clocks clk] [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay $OUTPUT_DELAY -clock [get_clocks clk] [get_ports cipher_out]

group_path -name INREG -from [all_inputs]
group_path -name REGOUT -to [all_outputs]
group_path -name INOUT -from [all_inputs] -to [all_outputs]
group_path -name REG2REG -from [all_registers] -to [all_registers]





