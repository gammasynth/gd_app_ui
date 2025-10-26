#|*******************************************************************
# color.gd
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

@onready var color_picker_button: ColorPickerButton = $CenterContainer/ColorPickerButton

func _widget_setup() -> Error:
	setup_button(color_picker_button)
	if modular_setting.setting_values.size() > 0:
		if modular_setting.setting_values.get(0) is Color: color_picker_button.color = modular_setting.setting_values.get(0)
	if widget_params.has("color"): color_picker_button.color = widget_params.get("color")
	if widget_params.has("edit_alpha"): color_picker_button.edit_alpha = widget_params.get("edit_alpha")
	return OK


func _on_color_picker_button_color_changed(color: Color) -> void:
	update_setting_value(color)

func _update_setting_value_from_external(new_value:Variant) -> void:
	if new_value is Color: color_picker_button.color = new_value
