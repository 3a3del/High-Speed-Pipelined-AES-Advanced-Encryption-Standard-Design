# XDC Constraints for AES_Encryption Module
# Target FPGA: xc7vx485tffg1157-2L (Virtex-7)
# Setup and Hold Uncertainty: 200ps each

#==============================================================================
# Clock Constraints
#==============================================================================

# Primary clock constraint - 100MHz system clock
# Adjust frequency as needed for your design requirements
create_clock -period 10 -name sys_clk -waveform {0.000 5} [get_ports clk]

# Clock uncertainty constraints (100ps for both setup and hold)
set_clock_uncertainty -setup 0.100 [get_clocks sys_clk]
set_clock_uncertainty -hold 0.100 [get_clocks sys_clk]

#==============================================================================
# Input/Output Delay Constraints
#==============================================================================

# Input delay constraints (assuming external logic provides data)
# Set based on your system timing requirements
set_input_delay -clock [get_clocks sys_clk] -max 1 [get_ports {Data_in[*]}]
set_input_delay -clock [get_clocks sys_clk] -min 1 [get_ports {Data_in[*]}]

set_input_delay -clock [get_clocks sys_clk] -max 1 [get_ports {key_in[*]}]
set_input_delay -clock [get_clocks sys_clk] -min 1 [get_ports {key_in[*]}]

set_input_delay -clock [get_clocks sys_clk] -max 1 [get_ports rst_n]
set_input_delay -clock [get_clocks sys_clk] -min 1 [get_ports rst_n]

# Output delay constraints
set_output_delay -clock [get_clocks sys_clk] -max 1 [get_ports {cipher_out[*]}]
set_output_delay -clock [get_clocks sys_clk] -min 1 [get_ports {cipher_out[*]}]

#==============================================================================
# False Path Constraints
#==============================================================================

# Reset is asynchronous, so set false path from reset to all registers
set_false_path -from [get_ports rst_n] -to [all_registers]

#==============================================================================
# Multi-cycle Path Constraints (if needed)
#==============================================================================

# If your AES pipeline takes multiple cycles to complete, uncomment and adjust:
# set_multicycle_path -setup 2 -from [get_ports {Data_in[*]}] -to [get_ports {cipher_out[*]}]
# set_multicycle_path -hold 1 -from [get_ports {Data_in[*]}] -to [get_ports {cipher_out[*]}]

#==============================================================================
# Physical Constraints
#==============================================================================

#==============================================================================
# Example Pin Assignments (Adjust based on your board)
#==============================================================================

# Clock pin (example location)
# set_property PACKAGE_PIN E19 [get_ports clk]
# set_property IOSTANDARD LVCMOS18 [get_ports clk]

# Reset pin (example location)
# set_property PACKAGE_PIN F20 [get_ports rst_n]
# set_property IOSTANDARD LVCMOS18 [get_ports rst_n]

# Note: Uncomment and modify the above pin assignments based on your actual board pinout
# For 128-bit vectors, you can use:
# set_property PACKAGE_PIN {pin1 pin2 pin3 ...} [get_ports {Data_in[*]}]
# set_property IOSTANDARD LVCMOS18 [get_ports {Data_in[*]}]

#==============================================================================
# Additional Timing Constraints
#==============================================================================

# Maximum delay constraint for critical paths (optional)
# set_max_delay 8.000 -from [get_ports {Data_in[*]}] -to [get_ports {cipher_out[*]}]

# Minimum delay constraint (optional)
# set_min_delay 1.000 -from [get_ports {Data_in[*]}] -to [get_ports {cipher_out[*]}]