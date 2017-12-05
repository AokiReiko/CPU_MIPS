
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name cpu_mips -dir "D:/17fall/ComputerOrganization/120402/CPU_MIPS/planAhead_run_3" -part xc3s1200efg320-5
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "D:/17fall/ComputerOrganization/120402/CPU_MIPS/cpu_16bit_top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {D:/17fall/ComputerOrganization/120402/CPU_MIPS} {xst} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "cpu_16bit_top.ucf" [current_fileset -constrset]
add_files [list {cpu_16bit_top.ucf}] -fileset [get_property constrset [current_run]]
link_design
