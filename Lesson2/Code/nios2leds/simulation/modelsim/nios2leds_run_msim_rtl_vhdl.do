transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {D:/Personal/School/EmbeddedSystems/Lesson2/nios2leds/ip/avalon_pwm.vhd}
vlib HostSystem
vmap HostSystem HostSystem

