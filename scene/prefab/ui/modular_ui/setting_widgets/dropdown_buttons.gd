#|*******************************************************************
# dropdown_buttons.gd
#*******************************************************************
# This file is part of gd_app_ui.
# 
# gd_app_ui is an open-source software library.
# gd_app_ui is licensed under the MIT license.
# https://github.com/gammasynth/gd_app_ui
#*******************************************************************
# Copyright (c) 2025 AD - present; 1447 AH - present, Gammasynth.  
# 
# Gammasynth
# 
# Gammasynth (Gammasynth Software), Texas, U.S.A.
# https://gammasynth.com
# https://github.com/gammasynth
# 
# This software is licensed under the MIT license.
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# 
#|*******************************************************************
extends SettingWidget

@onready var menu_button: MenuButton = $MenuButton
var popup:PopupMenu = null

var items_dict:Dictionary = {}

# When preparing a new setting that will use "dropdown_buttons" here is an example of the widget dictionary:
	
	#var theme_settings_widget_params : Dictionary = {
		#"WINDOW_TITLE" : "themes", # telling the dropdown widget to have a title above list
		#"ITEM_0" : "dark", # simply adding an item button to the dropdown as a string
		#"ITEM_1" : { "ITEM_NAME" : "light" }, # alternatively adding an item to dropdown as Dictionary
		#"ITEM_2" : { "ITEM_NAME" : "custom", "ACCEL" : KEY_C } # optional accel shortcut can be added
	#}

func _widget_setup() -> Error:
	popup = menu_button.get_popup()
	popup.index_pressed.connect(_on_index_pressed)
	
	if widget_params.has("WINDOW_TITLE"): popup.title = widget_params.get("WINDOW_TITLE")
	
	var item_index:int = 0
	
	while widget_params.has(str("ITEM_" + str(item_index))):
		
		var val: Variant = widget_params.get(str("ITEM_" + str(item_index)))
		
		if val is String:
			items_dict.set(item_index, val)
			popup.add_item(val)
		elif val is Dictionary:
			var item_def: Dictionary = val as Dictionary
			
			if item_def.has("ITEM_NAME") and item_def.get("ITEM_NAME") is String:
				var item_name: String = item_def.get("ITEM_NAME")
				
				var accel : Key = 0 as Key
				if item_def.has("ACCEL") and item_def.get("ACCEL") is Key: accel = item_def.get("ACCEL")
				
				items_dict.set(item_index, item_name)
				popup.add_item(item_name, -1, accel)
		
		item_index += 1
	menu_button.text = str("   " + items_dict.get(int(default_value)) + "   ")
	return OK




func _on_index_pressed(index: int) -> void:
	update_setting_value(index)
	menu_button.text = str("   " + items_dict.get(index) + "   ")

func _update_setting_value_from_external(new_value:Variant) -> void:
	if new_value is int: 
		if items_dict.has(new_value):
			menu_button.text = str("   " + items_dict.get(new_value) + "   ")
