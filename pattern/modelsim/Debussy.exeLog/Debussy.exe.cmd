srcSourceCodeView
debImport "-f" "flist.f" "-2001"
srcResizeWindow 276 192 1423 809
srcViewImportLogFile
srcSearchString "Error" -win $_nTrace2 -next -case
srcSelect -win $_nTrace2 -range {15 15 2 3 1 1}
debReload
srcHBSelect "tb" -win $_nTrace1
srcSelect -win $_nTrace1 -range {24 24 3 4 1 1}
srcDeselectAll -win $_nTrace2
debReload
srcHBSelect "tb" -win $_nTrace1
srcSelect -win $_nTrace1 -range {24 24 3 4 1 1}
srcHBSelect "tb.u_apb_sram" -win $_nTrace1
srcSetScope -win $_nTrace1 "tb.u_apb_sram" -delim "."
srcDeselectAll -win $_nTrace1
srcSelect -signal "prdata" -win $_nTrace1
srcAction -pos 35 1 4 -win $_nTrace1 -name "prdata" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_dout" -win $_nTrace1
srcAction -pos 126 5 3 -win $_nTrace1 -name "mem_dout" -ctrlKey off
srcHBSelect "tb.u_apb_sram.u_mem" -win $_nTrace1
srcSetScope -win $_nTrace1 "tb.u_apb_sram.u_mem" -delim "."
srcHBSelect "tb.u_apb_sram" -win $_nTrace1
srcSetScope -win $_nTrace1 "tb.u_apb_sram" -delim "."
srcHBSelect "tb.u_apb_sram" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "pready" -win $_nTrace1
srcAction -pos 34 1 4 -win $_nTrace1 -name "pready" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "apb_write" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "apb_write" -win $_nTrace1
srcAction -pos 129 11 6 -win $_nTrace1 -name "apb_write" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "apb_write_w" -win $_nTrace1
srcAction -pos 81 5 6 -win $_nTrace1 -name "apb_write_w" -ctrlKey off
debReload
srcHBSelect "tb.u_apb_sram" -win $_nTrace1
srcSelect -win $_nTrace1 -range {28 28 3 4 1 1}
debReload
srcHBSelect "tb.u_apb_sram" -win $_nTrace1
srcSelect -win $_nTrace1 -range {28 28 3 4 1 1}
srcCloseWindow -win $_nTrace2
debReload
srcHBSelect "tb.u_apb_sram" -win $_nTrace1
srcSelect -win $_nTrace1 -range {28 28 3 4 1 1}
srcResizeWindow 154 186 1473 840
debExit
