onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/clk
add wave -noupdate /tb/rstn
add wave -noupdate /tb/u_apb_sram/psel
add wave -noupdate /tb/u_apb_sram/penable
add wave -noupdate /tb/u_apb_sram/paddr
add wave -noupdate /tb/u_apb_sram/pwrite
add wave -noupdate /tb/u_apb_sram/pwdata
add wave -noupdate /tb/u_apb_sram/pready
add wave -noupdate /tb/u_apb_sram/prdata
add wave -noupdate -divider SRAM
add wave -noupdate /tb/u_apb_sram/u_mem/en
add wave -noupdate /tb/u_apb_sram/u_mem/we
add wave -noupdate /tb/u_apb_sram/u_mem/addr
add wave -noupdate /tb/u_apb_sram/u_mem/din
add wave -noupdate /tb/u_apb_sram/u_mem/dout
add wave -noupdate /tb/u_apb_ms_model/pwdata
add wave -noupdate /tb/u_apb_ms_model/cnt
add wave -noupdate /tb/u_apb_ms_model/addr
add wave -noupdate /tb/u_apb_ms_model/wdata
add wave -noupdate /tb/u_apb_ms_model/addr
add wave -noupdate /tb/u_apb_ms_model/rand
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {995350 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 215
configure wave -valuecolwidth 101
configure wave -justifyvalue left
configure wave -signalnamewidth 3
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {1029490 ps} {1124990 ps}
