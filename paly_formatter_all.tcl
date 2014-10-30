######################################################
##                                                  ##
##        PALYNOLOGY DATA INPUT & FORMATTING        ##		
##                    PROGRAM                       ##
##            AUTHOR: Adrian J Lanzafame            ##
##  CONTACT: adrian.lanzafame@originenergy.com.au   ##
##                                                  ##
######################################################

# TODO-LIST: Implement "Continuation" mode, where user inputs last lines values.

catch {mui_select title = MP or SP type = single_select list = MP\tSP list_title = What is the Palynology Type?} mp_or_sp

switch $mp_or_sp {
	MP {
		catch {mui_select title = WCR or VINTAGE type = single_select list = WCR\tVINTAGE list_title = Is the report a WCR or Vintage (Review)?  } wcr_or_vintage
		switch $wcr_or_vintage {
			WCR { set choice MP_WCR }
			VINTAGE { set choice MP_VINTAGE}
			"\nchild process exited abnormally" {
			puts "User ended program."
			return
			}
		}
	}

	SP  {
		catch {mui_select title = WCR or VINTAGE type = single_select list = WCR\tVINTAGE list_title = Is the report a WCR or Vintage (Review)?  } wcr_or_vintage
		switch $wcr_or_vintage {
			WCR { set choice SP_WCR }
			VINTAGE { set choice SP_VINTAGE}
			"\nchild process exited abnormally" {
			puts "User ended program."
			return
			}
		}
	}

	"\nchild process exited abnormally" {
		puts "User ended program."
		return
	} 
} 

# The following four while loops with be implemented into a switch statement depending on initial values input by user.
switch $choice {
	MP_WCR {
		# Create the default targets set
		set set_id [text_insert class = set set = PALY_MP_WCR]

		# Set the the log create information
		set info { source  = OERL              \
			   comment = "Palynology Data Formatter" \
		           interpolation = POINT \
			   frames = 1 }

		# # Create comment
		# eval text_insert class = comment comment = 

		# Create the logs
		eval text_insert class = log log = DEPTH   		type = double	          ${info} 
		eval text_insert class = log log = CUTTING 		type = alpha repeat = 12  ${info} 
		eval text_insert class = log log = MPCOLOR 		type = alpha repeat = 16  ${info} 
		eval text_insert class = log log = MPSUB   		type = alpha repeat = 46  ${info}
		eval text_insert class = log log = MPSUBCOLOR	type = alpha repeat = 16  ${info}
		eval text_insert class = log log = MPZONE  		type = alpha repeat = 32  ${info}
		eval text_insert class = log log = SYMBOL		type = alpha repeat = 16  ${info}
		eval text_insert class = log log = TYPE 		type = real				  ${info}
		eval text_insert class = log log = CONFIDENCE	type = alpha repeat = 16  ${info}


		set dst 1
		set indexcount 0
		set finished 0
		set questionmark ?
		set wastherequestionmark 0

		# Select all the logs
		edit_select_all
		# go to the Log Values tab
		value_set parent = APP_MDI_DOC_MANAGER name = .TEXT_TAB_MANAGER value = TEXT_VALUES_TAB

		# mpzone_to_color
		set mp_color_map_zone { P.COMATUM C.INCOMPOSITUM H.TASMANIENSE W.ORNATUM K.THOMPSONAE D.WAIPAWAENSIS D.HETEROPHLYCTA A.AUSTRALICUM A.REBURRUS E.CRASSITABULATA E.PARTRIDGEI M.DRUGGII_UPPER M.DRUGGII_LOWER M.DRUGGII P.OVATA I.PELLUCIDUM I.KOROJONENSE I.KOROJONENSE_UPPER X.AUSTRALIS X.AUSTRALIS_UPPER X.AUSTRALIS_MIDDLE X.AUSTRALIS_LOWER_D X.AUSTRALIS_LOWER_C X.AUSTRALIS_LOWER_B X.AUSTRALIS_LOWER_A X.AUSTRALIS_LOWER N.ACERAS_UPPER N.ACERAS_MIDDLE N.ACERAS_MIDDLE/LOWER N.ACERAS_LOWER N.ACERAS I.ROTUNDATUM I.CRETACEUM_?I.ROTUNDATUM I.CRETACEUM_I.ROTUNDATUM I.CRETACEUM_UPPER_B I.CRETACEUM_UPPER_B/A I.CRETACEUM_UPPER_A I.CRETACEUM_UPPER I.CRETACEUM_LOWER_B I.CRETACEUM_LOWER_A I.CRETACEUM_LOWER I.CRETACEUM C.TRIPARTITA O.PORIFERA_C.TRIPARTITA O.PORIFERA O.PORIFERA_UPPER O.PORIFERA_LOWER C.STRIATOCONUM_UPPER C.STRIATOCONUM_MIDDLE C.STRIATOCONUM_LOWER C.STRIATOCONUM P.INFUSORIOIDES P.INFUSORIOIDES_UPPER_C P.INFUSORIOIDES_UPPER_B P.INFUSORIOIDES_UPPER_A P.INFUSORIOIDES_UPPER P.INFUSORIOIDES_UPPER_TO_MIDDLE P.INFUSORIOIDES_MIDDLE_C P.INFUSORIOIDES_MIDDLE_B_C P.INFUSORIOIDES_MIDDLE_A P.INFUSORIOIDES_MIDDLE P.INFUSORIOIDES_LOWER_C P.INFUSORIOIDES_LOWER_B_C P.INFUSORIOIDES_LOWER_B P.INFUSORIOIDES_LOWER_A P.INFUSORIOIDES_LOWER P.INFUSORIOIDES_I.EVEXUS P.INFUSORIOIDES_K.POLYPES P.INFUSORIOIDES_C.EDWARDSII P.INFUSORIOIDES_C.EDWARDSII_UPPER P.INFUSORIOIDES_C.EDWARDSII_LOWER C.EDWARDSII C.EDWARDSII_UPPER C.EDWARDSII_LOWER P.INFUSORIOIDES_K.POLYPES K.POLYPES P.INFUSORIOIDES_I.EVEXUS I.EVEXUS V.GRIPHUS V.GRIPHUS_LOWER APECTODINIUM P.INFUSORIOIDES_H.ACME H.ACME SPINIFERITES E.CRASSITABULATA_TO__A._CIRCUMTABULATA_ K.POLYPES_TO_TRITHYRODINIUM D.HETEROPHLYCTA_TO_G.EXTENSA K.THOMPSONAE_TO_W.ORNATUM I.ROTUNDATUM_TO_BASAL_N.ACREAS V.GRIPHUS_TO_I.EVEXUS D.HETEROPHLYCTA_TO_P.COMATUM P.PYROPHORUM_TO_E.CRASSITABULATA X.AUSTRALIS_TO_I.PELLUCIDUM I.ROTUNDATUM_TO_I.CRETACEUM C.STRIATOCONUM_TO_UPPER_K.POLYPES UPPER_X.AUSTRALIS_TO_F.LONGUS H.TASMANIENSE_TO_E.PARTRIDGEI I.CRETACEUM_TO_O.PORIFERA OPERCULODINIUM I.PELLUCIDUM_TO_I.KOROJONENSE }
		set mp_color_map_color { earth7 dim_gray chocolate1 royal_blue2 khaki4 cadet_blue brown3 gold navy_blue coral dark_violet sky_blue sky_blue cornflower_blue firebrick4 dark_green earth3 earth4 red earth6 brown2 orange_red orange_red orange_red orange_red orange_red earth15 earth13 earth13 yellow2 yellow tomato tomato tomato green_yellow green_yellow green_yellow green_yellow lime_green lime_green lime_green green medium_blue medium_blue blue royal_blue medium_blue sandy_brown salmon light_salmon1 light_pink midnight_blue light_blue light_blue light_blue light_blue light_steel_blue light_steel_blue light_steel_blue light_steel_blue light_steel_blue light_cyan light_cyan light_cyan light_cyan light_cyan brown1 rosy_brown1 dark_violet violet dark_orchid dark_violet violet dark_orchid rosy_brown1 rosy_brown1 brown1 brown1 powder_blue doger_blue gray1 pale_turquoise pale_turquoise gray7 lawn_green peru dark_khaki violet_red dark_salmon medium_purple slate_blue1 steel_blue rosy_brown chartreuse firebrick3 deep_pink indian_red light_sea_green white olive_drab }

		while {!$finished} {

			# Zone 
			set zone ""
			set valid_zone {-1}
			while {$valid_zone == -1} {
				# Get MPZONE
				catch {mui_dialog title = Palynology Zone type = prompt message = What is the main paly zone? default = '' data_type = alpha  } zone
				set zone [string toupper $zone]
				if {$zone == "I"} {
					set valid_zone 0
					set zone INDETERMINATE
				} else {
					if {[string index $zone end] == $questionmark} {

						set zone [string trimright $zone $questionmark]
						set valid_zone [lsearch $mp_color_map_zone $zone]
						if {$valid_zone == -1} {
							mui_dialog title = INCORRECT ZONE type = error message = "Input a valid MP ZONE."
						}
						set wastherequestionmark 1

					} elseif {[string index $zone 0] == $questionmark} {

						set zone [string trimleft $zone $questionmark]
						set valid_zone [lsearch $mp_color_map_color $zone]
						if {$valid_zone == -1} {
							mui_dialog title = INCORRECT ZONE type = error message = "Input a valid MP ZONE."
						}
						set wastherequestionmark 2

					} else {
						set valid_zone [lsearch $mp_color_map_zone $zone]
						if {$valid_zone == -1} {
							mui_dialog title = INCORRECT ZONE type = error message = "Input a valid MP ZONE."
						}
					}
				}
			}

			# Subzone
			set subzone ""
			set valid_subzone {-1}
			while {$valid_subzone == -1} {
				if {$zone == "INDETERMINATE"} {
					set subzone B
				} else {
					catch {mui_dialog title = Palynology Subzone type = prompt message = What is the paly sub zone? default = '' data_type = alpha  } subzone 
					set subzone [string toupper $subzone]
				}
				if {$subzone == "B"} {
					set valid_subzone 0
					set subzone $zone
				} else {
					# Puts the subzone into the correct format to be color mapped.
					set underscore _
					if {[string index $subzone end] == $questionmark} {
						set subzone [string trimright $subzone $questionmark]
						set subzone $zone$underscore$subzone
						set valid_subzone [lsearch $mp_color_map_zone $subzone]
						if {$valid_subzone == -1} {
							mui_dialog title = INCORRECT ZONE type = error message = "Input a valid MP SUBZONE."
						}
						set wastherequestionmark 3

					} elseif {[string index $subzone 0] == $questionmark} {
						set subzone [string trimleft $subzone $questionmark]
						set subzone $zone$underscore$subzone
						set valid_subzone [lsearch $mp_color_map_zone $subzone]
						if {$valid_subzone == -1} {
							mui_dialog title = INCORRECT ZONE type = error message = "Input a valid MP SUBZONE."
						}
						set wastherequestionmark 4

					} else {
						set subzone $zone$underscore$subzone
						set valid_subzone [lsearch $mp_color_map_zone $subzone]
						if {$valid_subzone == -1} {
							mui_dialog title = INCORRECT ZONE type = error message = "Input a valid MP SUBZONE."
						}
					}
				}
			}

			# Searches the list of zones/subzones to get the index
			set zone_color_index [lsearch $mp_color_map_zone $zone]
			set subzone_color_index [lsearch $mp_color_map_zone $subzone]

			# Gets the value at the index and assigns it to the color/subcolor variable
			set color [lindex $mp_color_map_color $zone_color_index]
			set subcolor [lindex $mp_color_map_color $subzone_color_index]

			if {$wastherequestionmark == 1} {
				set zone $zone$questionmark
				set wastherequestionmark 0
			}

			if {$wastherequestionmark == 2} {
				set zone $questionmark$zone
				set wastherequestionmark 0
			}

			if {$wastherequestionmark == 3} {
				set subzone $subzone$questionmark
				set wastherequestionmark 0
			}

			if {$wastherequestionmark == 4} {
				set subzone $zone$underscore$questionmark$subzone
				set wastherequestionmark 0	
			}		

			# Sample type
			set sample_type ""
			while {$sample_type == ""} {
				# Get TYPE
				catch {mui_dialog title = Sample Type type = prompt message = What is the sample type? default = '' data_type = alpha  } sample_type_input
				
				# Takes the user input string of the sample type and converts it the associated number.
				switch $sample_type_input {
					core -
					Core -
					C 	 -
					c    { set sample_type 1 
						   set cutting "" 
						   value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.CUTTING_1 value = "$cutting" index = $indexcount}
					swc  -
					SWC  -
					S 	 -
					s    { set sample_type 2 
						   set cutting "" 
						   value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.CUTTING_1 value = "$cutting" index = $indexcount}
					cutt -
					CUTT -
					T 	 -
					t    { set sample_type 3 
						   set cutting "CUTT"}
					default {mui_dialog title = INCORRECT TYPE type = error message = "Input a valid sample type."}
					}
			}
			
			# Takes the sample type and assigns the associated symbol code to the symbol variable
			switch $sample_type {
				1 { set symbol sc4 }
				2 { set symbol sc3 }
				3 { set symbol "" }
				
			}

			if {$zone != "I"} {
				catch {mui_dialog title = Confidence Rating of the Sample type = prompt message = What is the confidence rating for this sample? default = '' data_type = alpha } confidence
				set confidence [string toupper $confidence]
				if {$confidence == "X"} {
					set confidence ""
				}
			}
			
			# Process by which blank lines are inserted to prevent LAYOUT view from extending the lithology color of
			# each palyzone to far.
			# The beginning if statement prevents the block from running on the very first line but runs on all other lines.
			# OUTLINE: if statement map
			# first check if zone is the same; if not, enter complete blank line 0.5m below last enter and then increment indexcount
			# second check if subzone is the same; if not, enter a blank line only in the MPSUB and MPSUBCOLOR logs and then increment indexcount
			# third if both zone and subzone are the same then continue on to ask if finished
			if {$sample_type == 1 || $sample_type == 2} {
				if {$indexcount > 0} {
					set indexcount [expr $indexcount - 1]
					set prev_zone [value_get parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPZONE_1 index = $indexcount]
					set prev_subzone [value_get parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPSUB_1 index = $indexcount]
					set indexcount [expr $indexcount + 1]
					

						# Zone check
					if {![string match $prev_zone $zone]} {
						set depth [expr {$depth + 0.5}]
						puts $depth
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.DEPTH value = $depth index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPZONE_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPSUB_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.CUTTING_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.TYPE_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPCOLOR_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPSUBCOLOR_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.SYMBOL_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.CONFIDENCE_1 value = "" index = $indexcount
						set indexcount [expr $indexcount + 1]
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES action = TABLE_MENU_APPEND_ROW
						# Subzone check
					} elseif {![string match $prev_subzone $subzone]} {
						set depth [expr {$depth + 0.5}]
						puts $depth
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.DEPTH value = $depth index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPZONE_1 value = "$zone" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPSUB_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.CUTTING_1 value = "$cutting" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.TYPE_1 value = "$sample_type" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPCOLOR_1 value = "$color" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPSUBCOLOR_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.SYMBOL_1 value = "$symbol" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.CONFIDENCE_1 value = "$confidence" index = $indexcount
						set indexcount [expr $indexcount + 1]
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES action = TABLE_MENU_APPEND_ROW
					}
				}
			}	

			# The if statement determines whether the sample type is a cutting and if so asks for the top and bottom depths of the cutting interval.
			# It thens assigns the user input values in the correct format for a cutting sample. Else just one depth is asked for and the user input values are assigned.
			if {$sample_type == 3} {
				if {$indexcount > 0} {
					set indexcount [expr $indexcount - 1]
					set prev_depth [value_get parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.DEPTH index = $indexcount]
					set indexcount [expr $indexcount + 1]
					
					set depthtop 0
					while {$depthtop <= $prev_depth} {
						catch {mui_dialog title = Top Depth? type = prompt message = What is the top depth of the cutting interval? default = 0.00 data_type = double  } depthtop
							if {$depthtop <= $prev_depth} {
								mui_dialog title = INCORRECT DEPTH type = error message = "Depth must be greater than previous depth."
								# catch {mui_dialog title = Top Depth? type = prompt message = What is the top depth of the cutting interval? default = 0.00 data_type = double} depthtop
							}
					}
				} else {
					catch {mui_dialog title = Top Depth? type = prompt message = What is the top depth of the cutting interval? default = 0.00 data_type = double  } depthtop
				}
				set depthbottom 0
				while {$depthbottom <= $depthtop} {
					catch {mui_dialog title = Bottom Depth? type = prompt message = What is the bottom depth of the cutting interval? default = 0.00 data_type = double  } depthbottom
						if {$depthbottom <= $depthtop} {
							mui_dialog title = INCORRECT DEPTH type = error message = "Depth must be greater than previous depth."
						}
				}
				
				# Define initial values in 7.0+
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.DEPTH value = $depthtop index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPZONE_1 value = "$zone" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPSUB_1 value = "$subzone" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.TYPE_1 value = "$sample_type" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPCOLOR_1 value = "$color" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPSUBCOLOR_1 value = "$subcolor" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.SYMBOL_1 value = "$symbol" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.CUTTING_1 value = "$cutting" index = $indexcount 
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.CONFIDENCE_1 value = "$confidence" index = $indexcount 	
				
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES action = TABLE_MENU_APPEND_ROW
				set indexcount [expr $indexcount + 1]

				set depthbottom [expr $depthbottom - 0.00001]

				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.DEPTH value = $depthbottom index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPZONE_1 value = "$zone" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPSUB_1 value = "$subzone" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.TYPE_1 value = "$sample_type" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPCOLOR_1 value = "" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPSUBCOLOR_1 value = "" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.SYMBOL_1 value = "$symbol" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.CUTTING_1 value = "" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.CONFIDENCE_1 value = "$confidence" index = $indexcount 

				set depth $depthbottom

			} else {
				
				if {$indexcount > 0} {
					set indexcount [expr $indexcount - 1]
					set prev_depth [value_get parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.DEPTH index = $indexcount]
					set indexcount [expr $indexcount + 1]

					set depthcheck 0
					while {$depthcheck <= $prev_depth} {
						catch {mui_dialog title = Depth? type = prompt message = What is the depth? default = 0.00 data_type = double  } depthcheck
						if {$depthcheck <= $prev_depth} {
							mui_dialog title = INCORRECT DEPTH type = error message = "Depth must be greater than previous depth."	
						} else {
							set depth $depthcheck
						}
					}
				} else {
					catch {mui_dialog title = Depth? type = prompt message = What is the depth? default = 0.00 data_type = double  } depth
				}

				# Define initial values in 7.0+
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.DEPTH value = $depth index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPZONE_1 value = "$zone" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPSUB_1 value = "$subzone" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.TYPE_1 value = "$sample_type" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPCOLOR_1 value = "$color" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.MPSUBCOLOR_1 value = "$subcolor" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.SYMBOL_1 value = "$symbol" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.CUTTING_1 value = "" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_MP_WCR.CONFIDENCE_1 value = "$confidence" index = $indexcount 

			}

			set indexcount [expr $indexcount + 1]

			set valid_finished {-1}
			while {$valid_finished == -1} {
				catch {mui_dialog title = Are you finished? type = prompt message = Are you finished? Enter 1 to exit. default = 0 data_type = integer  } finished
				if {[string is integer -strict $finished]} {
					set valid_finished 0
				} else {
					mui_dialog title = INTEGERS Ben, NOT STRINGS! type = error message = "Please input an integer."
				}
			}
			# Are you finished?

			# Appends a new row if the user is not finished
			if {! $finished} {
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES action = TABLE_MENU_APPEND_ROW
			}
		}
	}

	MP_VINTAGE {

		catch {mui_dialog title = Report Year type = prompt message = What Year is the Report from? default = '' data_type = alpha  } year

		set set_name PALY_MP_$year

		# Create the default targets set
		set set_id [text_insert class = set set = $set_name]

		# Set the the log create information
		set info { source  = OERL              \
			   comment = "Palynology Data Formatter" \
		           interpolation = POINT \
			   frames = 1 }

		# Create the logs
		eval text_insert class = log log = DEPTH   		type = double	          ${info} 
		eval text_insert class = log log = CUTTING 		type = alpha repeat = 12  ${info} 
		eval text_insert class = log log = MPCOLOR 		type = alpha repeat = 16  ${info} 
		eval text_insert class = log log = MPSUB   		type = alpha repeat = 46  ${info}
		eval text_insert class = log log = MPSUBCOLOR	type = alpha repeat = 16  ${info}
		eval text_insert class = log log = MPZONE  		type = alpha repeat = 32  ${info}
		eval text_insert class = log log = SYMBOL		type = alpha repeat = 16  ${info}
		eval text_insert class = log log = TYPE 		type = real				  ${info}
		eval text_insert class = log log = CONFIDENCE	type = alpha repeat = 16  ${info}
		

		set dst 1
		set indexcount 0
		set finished 0
		set questionmark ?
		set wastherequestionmark 0

		# Select all the logs
		edit_select_all
		# go to the Log Values tab
		value_set parent = APP_MDI_DOC_MANAGER name = .TEXT_TAB_MANAGER value = TEXT_VALUES_TAB

		# mpzone_to_color
		set mp_color_map_zone { P.COMATUM C.INCOMPOSITUM H.TASMANIENSE W.ORNATUM K.THOMPSONAE D.WAIPAWAENSIS D.HETEROPHLYCTA A.AUSTRALICUM A.REBURRUS E.CRASSITABULATA E.PARTRIDGEI M.DRUGGII_UPPER M.DRUGGII_LOWER M.DRUGGII P.OVATA I.PELLUCIDUM I.KOROJONENSE I.KOROJONENSE_UPPER X.AUSTRALIS X.AUSTRALIS_UPPER X.AUSTRALIS_MIDDLE X.AUSTRALIS_LOWER_D X.AUSTRALIS_LOWER_C X.AUSTRALIS_LOWER_B X.AUSTRALIS_LOWER_A X.AUSTRALIS_LOWER N.ACERAS_UPPER N.ACERAS_MIDDLE N.ACERAS_MIDDLE/LOWER N.ACERAS_LOWER N.ACERAS I.ROTUNDATUM I.CRETACEUM_?I.ROTUNDATUM I.CRETACEUM_I.ROTUNDATUM I.CRETACEUM_UPPER_B I.CRETACEUM_UPPER_B/A I.CRETACEUM_UPPER_A I.CRETACEUM_UPPER I.CRETACEUM_LOWER_B I.CRETACEUM_LOWER_A I.CRETACEUM_LOWER I.CRETACEUM C.TRIPARTITA O.PORIFERA_C.TRIPARTITA O.PORIFERA O.PORIFERA_UPPER O.PORIFERA_LOWER C.STRIATOCONUM_UPPER C.STRIATOCONUM_MIDDLE C.STRIATOCONUM_LOWER C.STRIATOCONUM P.INFUSORIOIDES P.INFUSORIOIDES_UPPER_C P.INFUSORIOIDES_UPPER_B P.INFUSORIOIDES_UPPER_A P.INFUSORIOIDES_UPPER P.INFUSORIOIDES_UPPER_TO_MIDDLE P.INFUSORIOIDES_MIDDLE_C P.INFUSORIOIDES_MIDDLE_B_C P.INFUSORIOIDES_MIDDLE_A P.INFUSORIOIDES_MIDDLE P.INFUSORIOIDES_LOWER_C P.INFUSORIOIDES_LOWER_B_C P.INFUSORIOIDES_LOWER_B P.INFUSORIOIDES_LOWER_A P.INFUSORIOIDES_LOWER P.INFUSORIOIDES_I.EVEXUS P.INFUSORIOIDES_K.POLYPES P.INFUSORIOIDES_C.EDWARDSII P.INFUSORIOIDES_C.EDWARDSII_UPPER P.INFUSORIOIDES_C.EDWARDSII_LOWER C.EDWARDSII C.EDWARDSII_UPPER C.EDWARDSII_LOWER P.INFUSORIOIDES_K.POLYPES K.POLYPES P.INFUSORIOIDES_I.EVEXUS I.EVEXUS V.GRIPHUS V.GRIPHUS_LOWER APECTODINIUM P.INFUSORIOIDES_H.ACME H.ACME SPINIFERITES E.CRASSITABULATA_TO__A._CIRCUMTABULATA_ K.POLYPES_TO_TRITHYRODINIUM D.HETEROPHLYCTA_TO_G.EXTENSA K.THOMPSONAE_TO_W.ORNATUM I.ROTUNDATUM_TO_BASAL_N.ACREAS V.GRIPHUS_TO_I.EVEXUS D.HETEROPHLYCTA_TO_P.COMATUM P.PYROPHORUM_TO_E.CRASSITABULATA X.AUSTRALIS_TO_I.PELLUCIDUM I.ROTUNDATUM_TO_I.CRETACEUM C.STRIATOCONUM_TO_UPPER_K.POLYPES UPPER_X.AUSTRALIS_TO_F.LONGUS H.TASMANIENSE_TO_E.PARTRIDGEI I.CRETACEUM_TO_O.PORIFERA OPERCULODINIUM I.PELLUCIDUM_TO_I.KOROJONENSE }
		set mp_color_map_color { earth7 dim_gray chocolate1 royal_blue2 khaki4 cadet_blue brown3 gold navy_blue coral dark_violet sky_blue sky_blue cornflower_blue firebrick4 dark_green earth3 earth4 red earth6 brown2 orange_red orange_red orange_red orange_red orange_red earth15 earth13 earth13 yellow2 yellow tomato tomato tomato green_yellow green_yellow green_yellow green_yellow lime_green lime_green lime_green green medium_blue medium_blue blue royal_blue medium_blue sandy_brown salmon light_salmon1 light_pink midnight_blue light_blue light_blue light_blue light_blue light_steel_blue light_steel_blue light_steel_blue light_steel_blue light_steel_blue light_cyan light_cyan light_cyan light_cyan light_cyan brown1 rosy_brown1 dark_violet violet dark_orchid dark_violet violet dark_orchid rosy_brown1 rosy_brown1 brown1 brown1 powder_blue doger_blue gray1 pale_turquoise pale_turquoise gray7 lawn_green peru dark_khaki violet_red dark_salmon medium_purple slate_blue1 steel_blue rosy_brown chartreuse firebrick3 deep_pink indian_red light_sea_green white olive_drab }

		while {!$finished} {
			
			set zone ""
			set valid_zone {-1}
			while {$valid_zone == -1} {
				# Get MPZONE
				catch {mui_dialog title = Palynology Zone type = prompt message = What is the main paly zone? default = '' data_type = alpha  } zone
				set zone [string toupper $zone]
				if {$zone == "I"} {
					set valid_zone 0
					set zone INDETERMINATE
				} else {
					set valid_zone [lsearch $mp_color_map_zone $zone]
					if {$valid_zone == -1} {
						mui_dialog title = INCORRECT ZONE type = error message = "Input a valid MP ZONE."
					}
				}
			}

			set subzone ""
			set valid_subzone {-1}
			while {$valid_subzone == -1} {
				if {$zone == "INDETERMINATE"} {
					set subzone B
				} else {
					catch {mui_dialog title = Palynology Subzone type = prompt message = What is the paly sub zone? default = '' data_type = alpha  } subzone 
					set subzone [string toupper $subzone]
				}
				if {$subzone == "B"} {
					set valid_subzone 0
					set subzone $zone
				} else {
					# Puts the subzone into the correct format to be color mapped.
					set underscore _
					if {[string index $subzone end] == $questionmark} {
						set subzone [string trimright $subzone $questionmark]
						set subzone $zone$underscore$subzone
						set valid_subzone [lsearch $mp_color_map_zone $subzone]
						if {$valid_subzone == -1} {
							mui_dialog title = INCORRECT ZONE type = error message = "Input a valid MP SUBZONE."
						}
						set wastherequestionmark 1

					} else {
						set subzone $zone$underscore$subzone
						set valid_subzone [lsearch $mp_color_map_zone $subzone]
						if {$valid_subzone == -1} {
							mui_dialog title = INCORRECT ZONE type = error message = "Input a valid MP SUBZONE."
						}
					}
				}
			}

			# Searches the list of zones/subzones to get the index
			set zone_color_index [lsearch $mp_color_map_zone $zone]
			set subzone_color_index [lsearch $mp_color_map_zone $subzone]

			# Gets the value at the index and assigns it to the color/subcolor variable
			set color [lindex $mp_color_map_color $zone_color_index]
			set subcolor [lindex $mp_color_map_color $subzone_color_index]

			if {$wastherequestionmark == 1} {
				set subzone $subzone$questionmark
				set wastherequestionmark 0
			}
			
			set sample_type ""
			while {$sample_type == ""} {
				# Get TYPE
				catch {mui_dialog title = Sample Type type = prompt message = What is the sample type? default = '' data_type = alpha  } sample_type_input
				
				# Takes the user input string of the sample type and converts it the associated number.
				switch $sample_type_input {
					core -
					Core -
					C 	 -
					c    { set sample_type 1 
						   set cutting "" 
						   value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.CUTTING_1 value = "$cutting" index = $indexcount}
					swc  -
					SWC  -
					S 	 -
					s    { set sample_type 2 
						   set cutting "" 
						   value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.CUTTING_1 value = "$cutting" index = $indexcount}
					cutt -
					CUTT -
					T 	 -
					t    { set sample_type 3 
						   set cutting "CUTT"}
					default {mui_dialog title = INCORRECT TYPE type = error message = "Input a valid sample type."}
					}
			}


			# Takes the sample type and assigns the associated symbol code to the symbol variable
			switch $sample_type {
				1 { set symbol sc4 }
				2 { set symbol sc3 }
				3 { set symbol "" }
				
			}

			if {$zone != "I"} {
				catch {mui_dialog title = Confidence Rating of the Sample type = prompt message = What is the confidence rating for this sample? default = '' data_type = alpha } confidence
				set confidence [string toupper $confidence]
				if {$confidence == "X"} {
					set confidence ""
				}
			}
			

			# Process by which blank lines are inserted to prevent LAYOUT view from extending the lithology color of
			# each palyzone to far.
			# The beginning if statement prevents the block from running on the very first line but runs on all other lines.
			# OUTLINE: if statement map
			# first check if zone is the same; if not, enter complete blank line 0.5m below last enter and then increment indexcount
			# second check if subzone is the same; if not, enter a blank line only in the MPSUB and MPSUBCOLOR logs and then increment indexcount
			# third if both zone and subzone are the same then continue on to ask if finished
			if {$sample_type == 1 || $sample_type == 2} {
				if {$indexcount > 0} {
					set indexcount [expr $indexcount - 1]
					set prev_zone [value_get parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.MPZONE_1 index = $indexcount]
					set prev_subzone [value_get parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.MPSUB_1 index = $indexcount]
					set indexcount [expr $indexcount + 1]
					

						# Zone check
					if {![string match $prev_zone $zone]} {
						set depth [expr {$depth + 0.5}]
						puts $depth
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.DEPTH value = $depth index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.MPZONE_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.MPSUB_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.CUTTING_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.TYPE_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.MPCOLOR_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.MPSUBCOLOR_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SYMBOL_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.CONFIDENCE_1 value = "" index = $indexcount
						set indexcount [expr $indexcount + 1]
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES action = TABLE_MENU_APPEND_ROW
						# Subzone check
					} elseif {![string match $prev_subzone $subzone]} {
						set depth [expr {$depth + 0.5}]
						puts $depth
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.DEPTH value = $depth index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.MPZONE_1 value = "$zone" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.MPSUB_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.CUTTING_1 value = "$cutting" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.TYPE_1 value = "$sample_type" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.MPCOLOR_1 value = "$color" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.MPSUBCOLOR_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SYMBOL_1 value = "$symbol" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.CONFIDENCE_1 value = "$confidence" index = $indexcount
						set indexcount [expr $indexcount + 1]
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES action = TABLE_MENU_APPEND_ROW
					}
				}
			}

			# The if statement determines whether the sample type is a cutting and if so asks for the top and bottom depths of the cutting interval.
			# It thens assigns the user input values in the correct format for a cutting sample. Else just one depth is asked for and the user input values are assigned.
			if {$sample_type == 3} {
				if {$indexcount > 0} {
					set indexcount [expr $indexcount - 1]
					set prev_depth [value_get parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.DEPTH index = $indexcount]
					set indexcount [expr $indexcount + 1]
					
					set depthtop 0
					while {$depthtop <= $prev_depth} {
						catch {mui_dialog title = Top Depth? type = prompt message = What is the top depth of the cutting interval? default = 0.00 data_type = double  } depthtop
							if {$depthtop <= $prev_depth} {
								mui_dialog title = INCORRECT DEPTH type = error message = "Depth must be greater than previous depth."
								# catch {mui_dialog title = Top Depth? type = prompt message = What is the top depth of the cutting interval? default = 0.00 data_type = double} depthtop
							}
					}
				} else {
					catch {mui_dialog title = Top Depth? type = prompt message = What is the top depth of the cutting interval? default = 0.00 data_type = double  } depthtop
				}
				set depthbottom 0
				while {$depthbottom <= $depthtop} {
					catch {mui_dialog title = Bottom Depth? type = prompt message = What is the bottom depth of the cutting interval? default = 0.00 data_type = double  } depthbottom
						if {$depthbottom <= $depthtop} {
							mui_dialog title = INCORRECT DEPTH type = error message = "Depth must be greater than previous depth."
						}
				}

				# Define initial values in 7.0+
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.DEPTH value = $depthtop index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.MPZONE_1 value = "$zone" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.MPSUB_1 value = "$subzone" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.TYPE_1 value = "$sample_type" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.MPCOLOR_1 value = "$color" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.MPSUBCOLOR_1 value = "$subcolor" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SYMBOL_1 value = "$symbol" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.CUTTING_1 value = "$cutting" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.CONFIDENCE_1 value = "$confidence" index = $indexcount  	
				
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES action = TABLE_MENU_APPEND_ROW
				set indexcount [expr $indexcount + 1]

				set depthbottom [expr $depthbottom - 0.00001]

				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.DEPTH value = $depthbottom index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.MPZONE_1 value = "$zone" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.MPSUB_1 value = "$subzone" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.TYPE_1 value = "$sample_type" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.MPCOLOR_1 value = "" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.MPSUBCOLOR_1 value = "" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SYMBOL_1 value = "$symbol" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.CUTTING_1 value = "" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.CONFIDENCE_1 value = "$confidence" index = $indexcount 

				set depth $depthbottom

			} else {

				if {$indexcount > 0} {
					set indexcount [expr $indexcount - 1]
					set prev_depth [value_get parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.DEPTH index = $indexcount]
					set indexcount [expr $indexcount + 1]

					set depthcheck 0
					while {$depthcheck <= $prev_depth} {
						catch {mui_dialog title = Depth? type = prompt message = What is the depth? default = 0.00 data_type = double  } depthcheck
						if {$depthcheck <= $prev_depth} {
							mui_dialog title = INCORRECT DEPTH type = error message = "Depth must be greater than previous depth."	
						} else {
							set depth $depthcheck
						}
					}
				} else {
					catch {mui_dialog title = Depth? type = prompt message = What is the depth? default = 0.00 data_type = double  } depth
				}
				
				# Define initial values in 7.0+
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.DEPTH value = $depth index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.MPZONE_1 value = "$zone" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.MPSUB_1 value = "$subzone" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.TYPE_1 value = "$sample_type" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.MPCOLOR_1 value = "$color" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.MPSUBCOLOR_1 value = "$subcolor" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SYMBOL_1 value = "$symbol" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.CUTTING_1 value = "" index = $indexcount 
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.CONFIDENCE_1 value = "$confidence" index = $indexcount

				
			}

			set indexcount [expr $indexcount + 1]

			# Are you finished?
			set valid_finished {-1}
			while {$valid_finished == -1} {
				catch {mui_dialog title = Are you finished? type = prompt message = Are you finished? Enter 1 to exit. default = 0 data_type = integer  } finished
				if {[string is integer -strict $finished]} {
					set valid_finished 0
				} else {
					mui_dialog title = INTEGERS, Ben NOT STRINGS! type = error message = "Please input an integer."
				}
			}

			# Appends a new row if the user is not finished
			if {! $finished} {
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES action = TABLE_MENU_APPEND_ROW
			}

		}
	}

	SP_WCR {

		# Create the default targets set
		set set_id [text_insert class = set set = PALY_SP_WCR]

		# Set the the log create information
		set info { source  = OERL              \
			   comment = "Palynology Data Formatter" \
		           interpolation = POINT \
			   frames = 1 }

		# Create the logs
		eval text_insert class = log log = DEPTH   		type = double	          ${info} 
		eval text_insert class = log log = CUTTING 		type = alpha repeat = 12  ${info} 
		eval text_insert class = log log = SPCOLOR 		type = alpha repeat = 16  ${info} 
		eval text_insert class = log log = SPSUB   		type = alpha repeat = 46  ${info}
		eval text_insert class = log log = SPSUBCOLOR	type = alpha repeat = 16  ${info}
		eval text_insert class = log log = SPZONE  		type = alpha repeat = 32  ${info}
		eval text_insert class = log log = SYMBOL		type = alpha repeat = 16  ${info}
		eval text_insert class = log log = TYPE 		type = real				  ${info}
		eval text_insert class = log log = CONFIDENCE	type = alpha repeat = 16  ${info}

		set dst 1
		set indexcount 0
		set finished 0
		set questionmark ?
		set wastherequestionmark 0

		# Select all the logs
		edit_select_all
		# go to the Log Values tab
		value_set parent = APP_MDI_DOC_MANAGER name = .TEXT_TAB_MANAGER value = TEXT_VALUES_TAB

		# spzone_to_color
		set sp_color_map_zone { T.BELLUS T.BELLUS_UPPER T.BELLUS_LOWER P.TUBERCULATUS P.TUBERCULATUS_UPPER P.TUBERCULATUS_MIDDLE P.TUBERCULATUS_LOWER N.ASPERUS N.ASPERUS_UPPER N.ASPERUS_MIDDLE N.ASPERUS_LOWER P.ASPEROPOLUS M.DIVERSUS M.DIVERSUS_UPPER M.DIVERSUS_MIDDLE M.DIVERSUS_LOWER L.BALMEI L.BALMEI_UPPER L.BALMEI_LOWER T.LONGUS T.LONGUS_UPPER T.LONGUS_LOWER F.LONGUS F.LONGUS_UPPER F.LONGUS_LOWER T.LILLIEI T.LILLIEI_UPPER N.SENECTUS N.SENECTUS_UPPER N.SENECTUS_MIDDLE/UPPER N.SENECTUS_MIDDLE N.SENECTUS_MIDDLE/LOWER N.SENECTUS_LOWER T.APOXYEXINUS T.APOXYEXINUS_UPPER T.APOXYEXINUS_MIDDLE T.APOXYEXINUS_LOWER P.MAWSONII P.MAWSONII_UPPER P.MAWSONII_LOWER P.MAWSONII_L.MUSA P.MAWSONII_H.TRINALIS P.MAWSONII_H.TRINALIS_LOWER P.MAWSONII_H.TRINALIS_UPPER H.TRINALIS H.TRINALIS_UPPER H.TRINALIS_LOWER P.MAWSONII_C.VULTUOSUS C.VULTUOSUS P.MAWSONII_G.ANCORUS G.ANCORUS L.MUSA A.DISTOCARINATUS P.PANNOSUS C.PARADOXA_LOWER C.PARADOXA_UPPER C.PARADOXA T.PACHYEXINUS C.STRIATUS P.NOTENSIS F.WONTHAGGIENSIS C.AUSTRALIENSIS LOW_F._LONGUS_TO_T._LILLIEI M.DIVERS_P.ASPERO LOWER_H.TRINALIS_TO_C.PARADOXA C.VULTUOSUS_TO_G.ANCORUS }
		set sp_color_map_color { light_yellow khaki1 khaki goldenrod1 lightgoldenrod1 pale_goldenrod light_goldenrod purple slate_blue dark_slate_blue medium_slateblue yellow_green pale_green aquamarine medium_turquoise mediumaquamarine spring_green med_spring_green dark_turquoise gray10 gray12 gray14 gray10 gray12 gray14 dark_sea_green dark_sea_green deep_sky_blue turquoise cyan cyan cyan medium_blue earth9 orange earth8 earth10 medium_orchid medium_violetred maroon pale_violet_red thistle thistle thistle thistle thistle thistle plum plum orchid orchid pale_violet_red brown dark_olive_green yellow4 yellow4 yellow4 wheat saddle_brown pink chocolate burlywood tan light_yellow1 light_coral chocolate2 }
		# SP_WCR
		while {!$finished} {
			
			set zone ""
			set valid_zone {-1}
			while {$valid_zone == -1} {
				# Get SPZONE
				catch {mui_dialog title = Palynology Zone type = prompt message = What is the main paly zone? default = '' data_type = alpha  } zone
				set zone [string toupper $zone]
				if {$zone == "I"} {
					set valid_zone 0
					set zone INDETERMINATE
				} else {
					set valid_zone [lsearch $sp_color_map_zone $zone]
					if {$valid_zone == -1} {
						mui_dialog title = INCORRECT ZONE type = error message = "Input a valid SP ZONE."
					}
				}
			}

			set subzone ""
			set valid_subzone {-1}
			while {$valid_subzone == -1} {
				if {$zone == "INDETERMINATE"} {
					set subzone B
				} else {
					catch {mui_dialog title = Palynology Subzone type = prompt message = What is the paly sub zone? default = '' data_type = alpha  } subzone 
					set subzone [string toupper $subzone]
				}
				if {$subzone == "B"} {
					set valid_subzone 0
					set subzone $zone
				} else {
					# Puts the subzone into the correct format to be color mapped.
					set underscore _
					if {[string index $subzone end] == $questionmark} {
						set subzone [string trimright $subzone $questionmark]
						set subzone $zone$underscore$subzone
						set valid_subzone [lsearch $sp_color_map_zone $subzone]
						if {$valid_subzone == -1} {
							mui_dialog title = INCORRECT ZONE type = error message = "Input a valid SP SUBZONE."
						}
						set wastherequestionmark 1

					} else {
						set subzone $zone$underscore$subzone
						set valid_subzone [lsearch $sp_color_map_zone $subzone]
						if {$valid_subzone == -1} {
							mui_dialog title = INCORRECT ZONE type = error message = "Input a valid SP SUBZONE."
						}
					}
				}
			}

			# Searches the list of zones/subzones to get the index
			set zone_color_index [lsearch $sp_color_map_zone $zone]
			set subzone_color_index [lsearch $sp_color_map_zone $subzone]

			# Gets the value at the index and assigns it to the color/subcolor variable
			set color [lindex $sp_color_map_color $zone_color_index]
			set subcolor [lindex $sp_color_map_color $subzone_color_index]

			if {$wastherequestionmark == 1} {
				set subzone $subzone$questionmark
				set wastherequestionmark 0
			}

			set sample_type ""
			while {$sample_type == ""} {
				# Get TYPE
				catch {mui_dialog title = Sample Type type = prompt message = What is the sample type? default = '' data_type = alpha  } sample_type_input
				
				# Takes the user input string of the sample type and converts it the associated number.
				switch $sample_type_input {
					core -
					Core -
					C 	 -
					c    { set sample_type 1 
						   set cutting "" 
						   value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.CUTTING_1 value = "$cutting" index = $indexcount}
					swc  -
					SWC  -
					S 	 -
					s    { set sample_type 2 
						   set cutting "" 
						   value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.CUTTING_1 value = "$cutting" index = $indexcount}
					cutt -
					CUTT -
					T 	 -
					t    { set sample_type 3 
						   set cutting "CUTT"}
					default {mui_dialog title = INCORRECT TYPE type = error message = "Input a valid sample type."}
					}
			}


			# Takes the sample type and assigns the associated symbol code to the symbol variable
			switch $sample_type {
				1 { set symbol sc4 }
				2 { set symbol sc3 }
				3 { set symbol "" }
				
			}

			if {$zone != "I"} {
				catch {mui_dialog title = Confidence Rating of the Sample type = prompt message = What is the confidence rating for this sample? default = '' data_type = alpha } confidence
				set confidence [string toupper $confidence]
				if {$confidence == "X"} {
					set confidence ""
				}
			}
			

			# Process by which blank lines are inserted to prevent LAYOUT view from extending the lithology color of
			# each palyzone to far.
			# The beginning if statement prevents the block from running on the very first line but runs on all other lines.
			# OUTLINE: if statement map
			# first check if zone is the same; if not, enter complete blank line 0.5m below last enter and then increment indexcount
			# second check if subzone is the same; if not, enter a blank line only in the SPSUB and SPSUBCOLOR logs and then increment indexcount
			# third if both zone and subzone are the same then continue on to ask if finished
			if {$sample_type == 1 || $sample_type == 2} {
				if {$indexcount > 0} {
					set indexcount [expr $indexcount - 1]
					set prev_zone [value_get parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SPZONE_1 index = $indexcount]
					set prev_subzone [value_get parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SPSUB_1 index = $indexcount]
					set indexcount [expr $indexcount + 1]
					

						# Zone check
					if {![string match $prev_zone $zone]} {
						set depth [expr {$depth + 0.5}]
						puts $depth
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.DEPTH value = $depth index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SPZONE_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SPSUB_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.CUTTING_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.TYPE_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SPCOLOR_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SPSUBCOLOR_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SYMBOL_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.CONFIDENCE_1 value = "" index = $indexcount
						set indexcount [expr $indexcount + 1]
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES action = TABLE_MENU_APPEND_ROW
						# Subzone check
					} elseif {![string match $prev_subzone $subzone]} {
						set depth [expr {$depth + 0.5}]
						puts $depth
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.DEPTH value = $depth index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SPZONE_1 value = "$zone" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SPSUB_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.CUTTING_1 value = "$cutting" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.TYPE_1 value = "$sample_type" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SPCOLOR_1 value = "$color" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SPSUBCOLOR_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SYMBOL_1 value = "$symbol" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.CONFIDENCE_1 value = "$confidence" index = $indexcount
						set indexcount [expr $indexcount + 1]
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES action = TABLE_MENU_APPEND_ROW
					}
				}
			}	

			# The if statement determines whether the sample type is a cutting and if so asks for the top and bottom depths of the cutting interval.
			# It thens assigns the user input values in the correct format for a cutting sample. Else just one depth is asked for and the user input values are assigned.
			if {$sample_type == 3} {
				if {$indexcount > 0} {
					set indexcount [expr $indexcount - 1]
					set prev_depth [value_get parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.DEPTH index = $indexcount]
					set indexcount [expr $indexcount + 1]
					
					set depthtop 0
					while {$depthtop <= $prev_depth} {
						catch {mui_dialog title = Top Depth? type = prompt message = What is the top depth of the cutting interval? default = 0.00 data_type = double  } depthtop
							if {$depthtop <= $prev_depth} {
								mui_dialog title = INCORRECT DEPTH type = error message = "Depth must be greater than previous depth."
								# catch {mui_dialog title = Top Depth? type = prompt message = What is the top depth of the cutting interval? default = 0.00 data_type = double} depthtop
							}
					}
				} else {
					catch {mui_dialog title = Top Depth? type = prompt message = What is the top depth of the cutting interval? default = 0.00 data_type = double  } depthtop
				}
				set depthbottom 0
				while {$depthbottom <= $depthtop} {
					catch {mui_dialog title = Bottom Depth? type = prompt message = What is the bottom depth of the cutting interval? default = 0.00 data_type = double  } depthbottom
						if {$depthbottom <= $depthtop} {
							mui_dialog title = INCORRECT DEPTH type = error message = "Depth must be greater than previous depth."
						}
				}
								
				# Define initial values in 7.0+
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.DEPTH value = $depthtop index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SPZONE_1 value = "$zone" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SPSUB_1 value = "$subzone" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.TYPE_1 value = "$sample_type" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SPCOLOR_1 value = "$color" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SPSUBCOLOR_1 value = "$subcolor" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SYMBOL_1 value = "$symbol" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.CUTTING_1 value = "$cutting" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.CONFIDENCE_1 value = "$confidence" index = $indexcount  	
				
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES action = TABLE_MENU_APPEND_ROW
				set indexcount [expr $indexcount + 1]

				set depthbottom [expr $depthbottom - 0.00001]

				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.DEPTH value = $depthbottom index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SPZONE_1 value = "$zone" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SPSUB_1 value = "$subzone" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.TYPE_1 value = "$sample_type" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SPCOLOR_1 value = "" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SPSUBCOLOR_1 value = "" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SYMBOL_1 value = "$symbol" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.CUTTING_1 value = "" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.CONFIDENCE_1 value = "$confidence" index = $indexcount 

				set depth $depthbottom

			} else {
				if {$indexcount > 0} {
					set indexcount [expr $indexcount - 1]
					set prev_depth [value_get parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.DEPTH index = $indexcount]
					set indexcount [expr $indexcount + 1]

					set depthcheck 0
					while {$depthcheck <= $prev_depth} {
						catch {mui_dialog title = Depth? type = prompt message = What is the depth? default = 0.00 data_type = double  } depthcheck
						if {$depthcheck <= $prev_depth} {
							mui_dialog title = INCORRECT DEPTH type = error message = "Depth must be greater than previous depth."	
						} else {
							set depth $depthcheck
						}
					}
				} else {
					catch {mui_dialog title = Depth? type = prompt message = What is the depth? default = 0.00 data_type = double  } depth
				}
				# Define initial values in 7.0+
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.DEPTH value = $depth index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SPZONE_1 value = "$zone" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SPSUB_1 value = "$subzone" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.TYPE_1 value = "$sample_type" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SPCOLOR_1 value = "$color" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SPSUBCOLOR_1 value = "$subcolor" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.SYMBOL_1 value = "$symbol" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.CUTTING_1 value = "" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_PALY_SP_WCR.CONFIDENCE_1 value = "$confidence" index = $indexcount 

				
			}

			set indexcount [expr $indexcount + 1]

			# Are you finished?
			set valid_finished {-1}
			while {$valid_finished == -1} {
				catch {mui_dialog title = Are you finished? type = prompt message = Are you finished? Enter 1 to exit. default = 0 data_type = integer  } finished
				if {[string is integer -strict $finished]} {
					set valid_finished 0
				} else {
					mui_dialog title = INTEGERS Ben, NOT STRINGS! type = error message = "Please input an integer."
				}
			}

			# Appends a new row if the user is not finished
			if {! $finished} {
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES action = TABLE_MENU_APPEND_ROW
			}
		}
	}

	SP_VINTAGE {

		catch {mui_dialog title = Report Year type = prompt message = What Year is the Report from? default = '' data_type = alpha  } year

		set set_name PALY_SP_$year

		# Create the default targets set
		set set_id [text_insert class = set set = $set_name]

		# Set the the log create information
		set info { source  = OERL              \
			   comment = "Palynology Data Formatter" \
		           interpolation = POINT \
			   frames = 1 }

		# Create the logs
		eval text_insert class = log log = DEPTH   		type = double	          ${info} 
		eval text_insert class = log log = CUTTING 		type = alpha repeat = 12  ${info} 
		eval text_insert class = log log = SPCOLOR 		type = alpha repeat = 16  ${info} 
		eval text_insert class = log log = SPSUB   		type = alpha repeat = 46  ${info}
		eval text_insert class = log log = SPSUBCOLOR	type = alpha repeat = 16  ${info}
		eval text_insert class = log log = SPZONE  		type = alpha repeat = 32  ${info}
		eval text_insert class = log log = SYMBOL		type = alpha repeat = 16  ${info}
		eval text_insert class = log log = TYPE 		type = real				  ${info}
		eval text_insert class = log log = CONFIDENCE	type = alpha repeat = 16  ${info}

		set dst 1
		set indexcount 0
		set finished 0
		set questionmark ?
		set wastherequestionmark 0

		# Select all the logs
		edit_select_all
		# go to the Log Values tab
		value_set parent = APP_MDI_DOC_MANAGER name = .TEXT_TAB_MANAGER value = TEXT_VALUES_TAB

		# spzone_to_color
		set sp_color_map_zone { T.BELLUS T.BELLUS_UPPER T.BELLUS_LOWER P.TUBERCULATUS P.TUBERCULATUS_UPPER P.TUBERCULATUS_MIDDLE P.TUBERCULATUS_LOWER N.ASPERUS N.ASPERUS_UPPER N.ASPERUS_MIDDLE N.ASPERUS_LOWER P.ASPEROPOLUS M.DIVERSUS M.DIVERSUS_UPPER M.DIVERSUS_MIDDLE M.DIVERSUS_LOWER L.BALMEI L.BALMEI_UPPER L.BALMEI_LOWER T.LONGUS T.LONGUS_UPPER T.LONGUS_LOWER F.LONGUS F.LONGUS_UPPER F.LONGUS_LOWER T.LILLIEI T.LILLIEI_UPPER N.SENECTUS N.SENECTUS_UPPER N.SENECTUS_MIDDLE/UPPER N.SENECTUS_MIDDLE N.SENECTUS_MIDDLE/LOWER N.SENECTUS_LOWER T.APOXYEXINUS T.APOXYEXINUS_UPPER T.APOXYEXINUS_MIDDLE T.APOXYEXINUS_LOWER P.MAWSONII P.MAWSONII_UPPER P.MAWSONII_LOWER P.MAWSONII_L.MUSA P.MAWSONII_H.TRINALIS P.MAWSONII_H.TRINALIS_LOWER P.MAWSONII_H.TRINALIS_UPPER H.TRINALIS H.TRINALIS_UPPER H.TRINALIS_LOWER P.MAWSONII_C.VULTUOSUS C.VULTUOSUS P.MAWSONII_G.ANCORUS G.ANCORUS L.MUSA A.DISTOCARINATUS P.PANNOSUS C.PARADOXA_LOWER C.PARADOXA_UPPER C.PARADOXA T.PACHYEXINUS C.STRIATUS P.NOTENSIS F.WONTHAGGIENSIS C.AUSTRALIENSIS LOW_F._LONGUS_TO_T._LILLIEI M.DIVERS_P.ASPERO LOWER_H.TRINALIS_TO_C.PARADOXA C.VULTUOSUS_TO_G.ANCORUS }
		set sp_color_map_color { light_yellow khaki1 khaki goldenrod1 lightgoldenrod1 pale_goldenrod light_goldenrod purple slate_blue dark_slate_blue medium_slateblue yellow_green pale_green aquamarine medium_turquoise mediumaquamarine spring_green med_spring_green dark_turquoise gray10 gray12 gray14 gray10 gray12 gray14 dark_sea_green dark_sea_green deep_sky_blue turquoise cyan cyan cyan medium_blue earth9 orange earth8 earth10 medium_orchid medium_violetred maroon pale_violet_red thistle thistle thistle thistle thistle thistle plum plum orchid orchid pale_violet_red brown dark_olive_green yellow4 yellow4 yellow4 wheat saddle_brown pink chocolate burlywood tan light_yellow1 light_coral chocolate2 }
		# SP_VINTAGE
		while {!$finished} {
			
			set zone ""
			set valid_zone {-1}
			while {$valid_zone == -1} {
				# Get SPZONE
				catch {mui_dialog title = Palynology Zone type = prompt message = What is the main paly zone? default = '' data_type = alpha  } zone
				set zone [string toupper $zone]
				if {$zone == "I"} {
					set valid_zone 0
					set zone INDETERMINATE
				} else {
					set valid_zone [lsearch $sp_color_map_zone $zone]
					if {$valid_zone == -1} {
						mui_dialog title = INCORRECT ZONE type = error message = "Input a valid SP ZONE."
					}
				}
			}

			set subzone ""
			set valid_subzone {-1}
			while {$valid_subzone == -1} {
				if {$zone == "INDETERMINATE"} {
					set subzone B
				} else {
					catch {mui_dialog title = Palynology Subzone type = prompt message = What is the paly sub zone? default = '' data_type = alpha  } subzone 
					set subzone [string toupper $subzone]
				}
				if {$subzone == "B"} {
					set valid_subzone 0
					set subzone $zone
				} else {
					# Puts the subzone into the correct format to be color mapped.
					set underscore _
					if {[string index $subzone end] == $questionmark} {
						set subzone [string trimright $subzone $questionmark]
						set subzone $zone$underscore$subzone
						set valid_subzone [lsearch $sp_color_map_zone $subzone]
						if {$valid_subzone == -1} {
							mui_dialog title = INCORRECT ZONE type = error message = "Input a valid SP SUBZONE."
						}
						set wastherequestionmark 1

					} else {
						set subzone $zone$underscore$subzone
						set valid_subzone [lsearch $sp_color_map_zone $subzone]
						if {$valid_subzone == -1} {
							mui_dialog title = INCORRECT ZONE type = error message = "Input a valid SP SUBZONE."
						}
					}
				}
			}

			# Searches the list of zones/subzones to get the index
			set zone_color_index [lsearch $sp_color_map_zone $zone]
			set subzone_color_index [lsearch $sp_color_map_zone $subzone]

			# Gets the value at the index and assigns it to the color/subcolor variable
			set color [lindex $sp_color_map_color $zone_color_index]
			set subcolor [lindex $sp_color_map_color $subzone_color_index]

			if {$wastherequestionmark == 1} {
				set subzone $subzone$questionmark
				set wastherequestionmark 0
			}

			set sample_type ""
			while {$sample_type == ""} {
				# Get TYPE
				catch {mui_dialog title = Sample Type type = prompt message = What is the sample type? default = '' data_type = alpha  } sample_type_input
				
				# Takes the user input string of the sample type and converts it the associated number.
				switch $sample_type_input {
					core -
					Core -
					C 	 -
					c    { set sample_type 1 
						   set cutting "" 
						   value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.CUTTING_1 value = "$cutting" index = $indexcount}
					swc  -
					SWC  -
					S 	 -
					s    { set sample_type 2 
						   set cutting "" 
						   value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.CUTTING_1 value = "$cutting" index = $indexcount}
					cutt -
					CUTT -
					T 	 -
					t    { set sample_type 3 
						   set cutting "CUTT"}
					default {mui_dialog title = INCORRECT TYPE type = error message = "Input a valid sample type."}
					}
			}


			# Takes the sample type and assigns the associated symbol code to the symbol variable
			switch $sample_type {
				1 { set symbol sc4 }
				2 { set symbol sc3 }
				3 { set symbol "" }
				
			}

			if {$zone != "I"} {
				catch {mui_dialog title = Confidence Rating of the Sample type = prompt message = What is the confidence rating for this sample? default = '' data_type = alpha } confidence
				set confidence [string toupper $confidence]
				if {$confidence == "X"} {
					set confidence ""
				}
			}
			

			# Process by which blank lines are inserted to prevent LAYOUT view from extending the lithology color of
			# each palyzone to far.
			# The beginning if statement prevents the block from running on the very first line but runs on all other lines.
			# OUTLINE: if statement map
			# first check if zone is the same; if not, enter complete blank line 0.5m below last enter and then increment indexcount
			# second check if subzone is the same; if not, enter a blank line only in the SPSUB and SPSUBCOLOR logs and then increment indexcount
			# third if both zone and subzone are the same then continue on to ask if finished
			if {$sample_type == 1 || $sample_type == 2} {
				if {$indexcount > 0} {
					set indexcount [expr $indexcount - 1]
					set prev_zone [value_get parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SPZONE_1 index = $indexcount]
					set prev_subzone [value_get parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SPSUB_1 index = $indexcount]
					set indexcount [expr $indexcount + 1]
					

						# Zone check
					if {![string match $prev_zone $zone]} {
						set depth [expr {$depth + 0.5}]
						puts $depth
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.DEPTH value = $depth index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SPZONE_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SPSUB_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.CUTTING_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.TYPE_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SPCOLOR_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SPSUBCOLOR_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SYMBOL_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.CONFIDENCE_1 value = "" index = $indexcount
						set indexcount [expr $indexcount + 1]
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES action = TABLE_MENU_APPEND_ROW
						# Subzone check
					} elseif {![string match $prev_subzone $subzone]} {
						set depth [expr {$depth + 0.5}]
						puts $depth
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.DEPTH value = $depth index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SPZONE_1 value = "$zone" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SPSUB_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.CUTTING_1 value = "$cutting" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.TYPE_1 value = "$sample_type" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SPCOLOR_1 value = "$color" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SPSUBCOLOR_1 value = "" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SYMBOL_1 value = "$symbol" index = $indexcount
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.CONFIDENCE_1 value = "$confidence" index = $indexcount
						set indexcount [expr $indexcount + 1]
						value_set parent = APP_MDI_DOC_MANAGER name = VALUES action = TABLE_MENU_APPEND_ROW
					}
				}
			}	

			# The if statement determines whether the sample type is a cutting and if so asks for the top and bottom depths of the cutting interval.
			# It thens assigns the user input values in the correct format for a cutting sample. Else just one depth is asked for and the user input values are assigned.
			if {$sample_type == 3} {
				if {$indexcount > 0} {
					set indexcount [expr $indexcount - 1]
					set prev_depth [value_get parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.DEPTH index = $indexcount]
					set indexcount [expr $indexcount + 1]
					
					set depthtop 0
					while {$depthtop <= $prev_depth} {
						catch {mui_dialog title = Top Depth? type = prompt message = What is the top depth of the cutting interval? default = 0.00 data_type = double  } depthtop
							if {$depthtop <= $prev_depth} {
								mui_dialog title = INCORRECT DEPTH type = error message = "Depth must be greater than previous depth."
								# catch {mui_dialog title = Top Depth? type = prompt message = What is the top depth of the cutting interval? default = 0.00 data_type = double} depthtop
							}
					}
				} else {
					catch {mui_dialog title = Top Depth? type = prompt message = What is the top depth of the cutting interval? default = 0.00 data_type = double  } depthtop
				}
				set depthbottom 0
				while {$depthbottom <= $depthtop} {
					catch {mui_dialog title = Bottom Depth? type = prompt message = What is the bottom depth of the cutting interval? default = 0.00 data_type = double  } depthbottom
						if {$depthbottom <= $depthtop} {
							mui_dialog title = INCORRECT DEPTH type = error message = "Depth must be greater than previous depth."
						}
				}

				# Define initial values in 7.0+
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.DEPTH value = $depthtop index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SPZONE_1 value = "$zone" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SPSUB_1 value = "$subzone" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.TYPE_1 value = "$sample_type" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SPCOLOR_1 value = "$color" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SPSUBCOLOR_1 value = "$subcolor" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SYMBOL_1 value = "$symbol" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.CUTTING_1 value = "$cutting" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.CONFIDENCE_1 value = "$confidence" index = $indexcount  	
				
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES action = TABLE_MENU_APPEND_ROW
				set indexcount [expr $indexcount + 1]

				set depthbottom [expr $depthbottom - 0.00001]

				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.DEPTH value = $depthbottom index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SPZONE_1 value = "$zone" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SPSUB_1 value = "$subzone" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.TYPE_1 value = "$sample_type" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SPCOLOR_1 value = "" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SPSUBCOLOR_1 value = "" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SYMBOL_1 value = "$symbol" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.CUTTING_1 value = "" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.CONFIDENCE_1 value = "$confidence" index = $indexcount 

				set depth $depthbottom

			} else {
				if {$indexcount > 0} {
					set indexcount [expr $indexcount - 1]
					set prev_depth [value_get parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.DEPTH index = $indexcount]
					set indexcount [expr $indexcount + 1]

					set depthcheck 0
					while {$depthcheck <= $prev_depth} {
						catch {mui_dialog title = Depth? type = prompt message = What is the depth? default = 0.00 data_type = double  } depthcheck
						if {$depthcheck <= $prev_depth} {
							mui_dialog title = INCORRECT DEPTH type = error message = "Depth must be greater than previous depth."	
						} else {
							set depth $depthcheck
						}
					}
				} else {
					catch {mui_dialog title = Depth? type = prompt message = What is the depth? default = 0.00 data_type = double  } depth
				}
				# Define initial values in 7.0+
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.DEPTH value = $depth index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SPZONE_1 value = "$zone" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SPSUB_1 value = "$subzone" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.TYPE_1 value = "$sample_type" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SPCOLOR_1 value = "$color" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SPSUBCOLOR_1 value = "$subcolor" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.SYMBOL_1 value = "$symbol" index = $indexcount
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.CUTTING_1 value = "" index = $indexcount 
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES_$set_name.CONFIDENCE_1 value = "$confidence" index = $indexcount

				
			}

			set indexcount [expr $indexcount + 1]

			# Are you finished?
			set valid_finished {-1}
			while {$valid_finished == -1} {
				catch {mui_dialog title = Are you finished? type = prompt message = Are you finished? Enter 1 to exit. default = 0 data_type = integer  } finished
				if {[string is integer -strict $finished]} {
					set valid_finished 0
				} else {
					mui_dialog title = INTEGERS Ben, NOT STRINGS! type = error message = "Please input an integer."
				}
			}

			# Appends a new row if the user is not finished
			if {! $finished} {
				value_set parent = APP_MDI_DOC_MANAGER name = VALUES action = TABLE_MENU_APPEND_ROW
			}
		}
	}
}

set errorInfo
