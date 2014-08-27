# Create the default targets set
set set_id [text_insert class = set set = PALY_MP_WCR]

# Set the the log create information
set info { source  = OERL              \
	   comment = "Palynology Data Formatter" \
           interpolation = POINT \
	   frames = 2 }

# Create the logs
eval text_insert class = log log = DEPTH   		type = double	          ${info} 
eval text_insert class = log log = CUTTING 		type = alpha repeat = 12  ${info} 
eval text_insert class = log log = MPCOLOR 		type = alpha repeat = 16  ${info} 
eval text_insert class = log log = MPSUB   		type = alpha repeat = 32  ${info}
eval text_insert class = log log = MPSUBCOLOR	type = alpha repeat = 16  ${info}
eval text_insert class = log log = MPZONE  		type = alpha repeat = 32  ${info}
eval text_insert class = log log = SYMBOL		type = alpha repeat = 16  ${info}
eval text_insert class = log log = TYPE 		type = real				  ${info}


set dst 1
set indexcount 0
set finished 0

# Select all the logs
edit_select_all
# go to the Log Values tab
value_set parent = APP_MDI_DOC_MANAGER name = .TEXT_TAB_MANAGER value = TEXT_VALUES_TAB

while {!$finished} {


# Get MPZONE
catch {mui_dialog title = Palynology Zone type = prompt message = What is the main paly zone? default = '' data_type = alpha} zone
# Get MPSUB
catch {mui_dialog title = Palynology SubZone type = prompt message = What is the paly sub zone? default = '' data_type = alpha} subzone 
# Get TYPE
catch {mui_dialog title = Sample Type type = prompt message = What is the sample type? default = '' data_type = alpha} sample_type_input
# Get DEPTH value
catch {mui_dialog title = Depth? type = prompt message = What is the depth? default = 0.00 data_type = double} depth

switch $sample_type_input {
	core { set sample_type 1 
		   set cutting "" 
		   value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.CUTTING_1 value = "$cutting" index = $indexcount}
	Core { set sample_type 1 
		   set cutting "" 
		   value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.CUTTING_1 value = "$cutting" index = $indexcount}
	C 	 { set sample_type 1
		   set cutting "" 
		   value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.CUTTING_1 value = "$cutting" index = $indexcount}
	c    { set sample_type 1 
		   set cutting "" 
		   value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.CUTTING_1 value = "$cutting" index = $indexcount}
	swc  { set sample_type 2 
		   set cutting "" 
		   value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.CUTTING_1 value = "$cutting" index = $indexcount}
	SWC  { set sample_type 2 
		   set cutting "" 
		   value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.CUTTING_1 value = "$cutting" index = $indexcount}
	s 	 { set sample_type 2 
		   set cutting "" 
		   value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.CUTTING_1 value = "$cutting" index = $indexcount}
	cutt { set sample_type 3 
		   set cutting "CUTT" 
		   value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.CUTTING_1 value = "$cutting" index = $indexcount }
	CUTT { set sample_type 3 
		   set cutting "CUTT" 
		   value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.CUTTING_1 value = "$cutting" index = $indexcount }
	t 	 { set sample_type 3 
		   set cutting "CUTT" 
		   value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.CUTTING_1 value = "$cutting" index = $indexcount }
	}







# ColorMap goes here





# ATTENTION! Need to run if statement over cutting result because it will require a top and base depth value. 
# It will also require that MPCOLOR and MPSUBCOLOR be repeated on a second row that is at the depth of the base value.

# Process by which blank lines are inserted to prevent LAYOUT view from extending the lithology color of
# each palyzone to far.
# The beginning if statement prevents the block from running on the very first line but runs on all other lines.

if {$indexcount > 0} {
	set prev_zone [value_get parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPZONE_1 index = [expr $indexcount - 1 ]]
	set prev_subzone [value_get parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPSUB_1 index = [expr $indexcount - 1]]
	# Zone check
	if {![string match $prev_zone $zone]} {
		value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.DEPTH value = [expr {$depth + 0.5}] index = $indexcount
		value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPZONE_1 value = "" index = $indexcount
		value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPSUB_1 value = "" index = $indexcount
		value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.CUTTING_1 value = "" index = $indexcount
		value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.TYPE_1 value = "" index = $indexcount
		# value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPCOLOR_1 value = "" index = $indexcount
		# value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPSUBCOLOR_1 value = "" index = $indexcount
		# value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.SYMBOL_1 value = "" index = $indexcount
	# Subzone check
	} elseif {![string match $prev_subzone $subzone]} {
		value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.DEPTH value = [expr {$depth + 0.5}] index = $indexcount
		value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPZONE_1 value = "$zone" index = $indexcount
		value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPSUB_1 value = "" index = $indexcount
		value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.CUTTING_1 value = "$cutting" index = $indexcount
		value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.TYPE_1 value = "$sample_type" index = $indexcount
		# value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPCOLOR_1 value = $color index = $indexcount
		# value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPSUBCOLOR_1 value = "" index = $indexcount
		# value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.SYMBOL_1 value = $symbol index = $indexcount
	}
}
# if statement map
# first check if zone is the same; if not, enter complete blank line 0.5m below last enter and then increment indexcount
# second check if subzone is the same; if not, enter a blank line only in the MPSUB and MPSUBCOLOR logs and then increment indexcount
# third if both zone and subzone are the same then continue on to ask if finished

# Define initial values in 7.0+
value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.DEPTH value = $depth index = $indexcount
value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPZONE_1 value = "$zone" index = $indexcount
value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPSUB_1 value = "$subzone" index = $indexcount
value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.TYPE_1 value = "$sample_type" index = $indexcount
# Once ColorMap is setup, a MPCOLOR and MPSUBCOLOR value_set will be here as well.
# Once TYPE to SYMBOL conversion is implemented, a SYMBOL value_set will be here as well.
# value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPCOLOR_1 value = $color index = $indexcount
# value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPSUBCOLOR_1 value = $subcolor index = $indexcount
# value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.SYMBOL_1 value = $symbol index = $indexcount 

set indexcount [expr $indexcount + 1]
# incr indexcount
puts "Indexcount is at $indexcount"



# Are you finished?
catch {mui_dialog title = Are you finished? type = prompt message = Are you finished? Enter 1 to exit. default = 0 data_type = integer} finished
if {! $finished} {
	value_set parent = APP_MDI_DOC_MANAGER name = VALUES action = TABLE_MENU_APPEND_ROW
}

}
