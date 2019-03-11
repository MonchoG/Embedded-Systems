create_clock -name {clk} -period 50.000 -waveform { 0.000 25.000 } [get_ports {clk_clk}]
derive_clock_uncertainty