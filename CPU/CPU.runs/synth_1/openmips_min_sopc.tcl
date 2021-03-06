# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param synth.incrementalSynthesisCache ./.Xil/Vivado-2266-shawn-All-Series/incrSyn
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.cache/wt [current_project]
set_property parent.project_path /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.xpr [current_project]
set_property XPM_LIBRARIES XPM_MEMORY [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/inst_rom.coe
add_files /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/test_logc_inst.coe
add_files /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/test_nop_shift_inst.coe
add_files /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/test_move_inst.coe
add_files /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/test_arithmetic_inst.coe
add_files /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/test_maddandmsub_inst.coe
add_files /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/test_div_inst.coe
add_files /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/test_jump_inst.coe
add_files /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/test_branch_inst.coe
add_files /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/test_load_store_inst.coe
add_files /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/test_cp0_inst.coe
read_verilog /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/define.vh
read_verilog -library xil_defaultlib {
  /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/cp0_reg.v
  /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/ctrl.v
  /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/div.v
  /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/ex.v
  /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/ex_mem.v
  /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/hilo_reg.v
  /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/id.v
  /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/id_ex.v
  /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/if_id.v
  /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/mem.v
  /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/mem_wb.v
  /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/openmips.v
  /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/pc_reg.v
  /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/regfile.v
  /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/new/openmips_min_sopc.v
}
read_ip -quiet /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/ip/inst_rom/inst_rom.xci
set_property used_in_implementation false [get_files -all /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/ip/inst_rom/inst_rom_ooc.xdc]

read_ip -quiet /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/ip/data_ram/data_ram.xci
set_property used_in_implementation false [get_files -all /home/shawn/workspace/ComputerDesignAndOriganization/CPU/CPU.srcs/sources_1/ip/data_ram/data_ram_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param ips.enableIPCacheLiteLoad 0
close [open __synthesis_is_running__ w]

synth_design -top openmips_min_sopc -part xc7a100tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef openmips_min_sopc.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file openmips_min_sopc_utilization_synth.rpt -pb openmips_min_sopc_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
